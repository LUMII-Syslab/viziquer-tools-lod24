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
-- Name: http_ldf_fi_yoma_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_ldf_fi_yoma_sparql;


--
-- Name: SCHEMA http_ldf_fi_yoma_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_ldf_fi_yoma_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE FUNCTION http_ldf_fi_yoma_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE FUNCTION http_ldf_fi_yoma_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COMMENT ON TABLE http_ldf_fi_yoma_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COMMENT ON COLUMN http_ldf_fi_yoma_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_ldf_fi_yoma_sparql.classes c1
     JOIN http_ldf_fi_yoma_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_ldf_fi_yoma_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_ldf_fi_yoma_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_ldf_fi_yoma_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_yoma_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_yoma_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_yoma_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_cc_rels AS
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
   FROM http_ldf_fi_yoma_sparql.cc_rels r,
    http_ldf_fi_yoma_sparql.classes c1,
    http_ldf_fi_yoma_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_classes_ns AS
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
    http_ldf_fi_yoma_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_ldf_fi_yoma_sparql.classes c
     LEFT JOIN http_ldf_fi_yoma_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_classes_ns_main AS
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
   FROM http_ldf_fi_yoma_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_ldf_fi_yoma_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_classes_ns_plus AS
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
    http_ldf_fi_yoma_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_ldf_fi_yoma_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_ldf_fi_yoma_sparql.classes c
     LEFT JOIN http_ldf_fi_yoma_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_classes_ns_main_plus AS
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
   FROM http_ldf_fi_yoma_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_ldf_fi_yoma_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_ldf_fi_yoma_sparql.v_classes_ns v
     LEFT JOIN http_ldf_fi_yoma_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_cp_rels AS
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
    http_ldf_fi_yoma_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_ldf_fi_yoma_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_ldf_fi_yoma_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_ldf_fi_yoma_sparql.cp_rels r,
    http_ldf_fi_yoma_sparql.classes c,
    http_ldf_fi_yoma_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_cp_rels_card AS
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
   FROM http_ldf_fi_yoma_sparql.cp_rels r,
    http_ldf_fi_yoma_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_properties_ns AS
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
    http_ldf_fi_yoma_sparql.tapprox(p.cnt) AS cnt_x,
    http_ldf_fi_yoma_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_ldf_fi_yoma_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_ldf_fi_yoma_sparql.properties p
     LEFT JOIN http_ldf_fi_yoma_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_cp_sources_single AS
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
   FROM ((http_ldf_fi_yoma_sparql.v_cp_rels_card r
     JOIN http_ldf_fi_yoma_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_ldf_fi_yoma_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_cp_targets_single AS
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
   FROM ((http_ldf_fi_yoma_sparql.v_cp_rels_card r
     JOIN http_ldf_fi_yoma_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_ldf_fi_yoma_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_ldf_fi_yoma_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_ldf_fi_yoma_sparql.pp_rels r,
    http_ldf_fi_yoma_sparql.properties p1,
    http_ldf_fi_yoma_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_properties_sources AS
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
   FROM (http_ldf_fi_yoma_sparql.v_properties_ns v
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
           FROM http_ldf_fi_yoma_sparql.cp_rels r,
            http_ldf_fi_yoma_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_properties_sources_single AS
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
   FROM (http_ldf_fi_yoma_sparql.v_properties_ns v
     LEFT JOIN http_ldf_fi_yoma_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_properties_targets AS
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
   FROM (http_ldf_fi_yoma_sparql.v_properties_ns v
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
           FROM http_ldf_fi_yoma_sparql.cp_rels r,
            http_ldf_fi_yoma_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_yoma_sparql.v_properties_targets_single AS
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
   FROM (http_ldf_fi_yoma_sparql.v_properties_ns v
     LEFT JOIN http_ldf_fi_yoma_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	skos:prefLabel	\N	\N
9	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	8	196	1	\N	\N
2	112	46	1	\N	\N
3	177	46	1	\N	\N
4	196	102	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	1	8	yleinen oikeustutkinto	fi
2	2	8	lääketieteen kandidaatti	fi
3	3	8	Rector Period	en
4	3	8	Rehtorikausi	fi
5	4	8	opettajakandidaatti	fi
6	5	8	eläinlääkärin tutkinto	fi
7	6	8	molempien oikeuksien kandidaatti	fi
8	7	8	fyysis-matem. tiet. maisteri	fi
9	9	8	venäjän kielen tutkinto	fi
10	11	8	Wikipedia	\N
11	12	8	Enrollment	en
12	12	8	Kirjautuminen	fi
13	13	8	Concept	en
14	13	8	Käsite	fi
15	14	8	YSO	\N
16	15	8	suurempi kameraalitutkinto	fi
17	16	8	vakuutustutkinto	fi
18	17	8	metsänhoitaja	fi
19	18	8	apteekkarin tutkinto	fi
20	19	8	Matrikkelissa mainittu henkilö	fi
21	20	8	hist.-filol. tohtori	fi
22	21	8	filosofian maisteri	fi
23	22	8	insinööri	fi
24	23	8	Doria, Respondentti	\N
25	24	8	Sukunimi	fi
26	25	8	pedagogian tutkinto	fi
27	26	8	Doria, Praeses	\N
28	27	8	Osakunta	fi
29	28	8	Kategoria	fi
30	29	8	Graduation	en
31	29	8	Tutkinnon suorittaminen	fi
32	30	8	vuoritutkinto	fi
33	31	8	hammaslääkärin tutkinto	fi
34	32	8	Lähde	fi
35	33	8	fyysis-matem. tiet. kandidaatti	fi
36	34	8	filosofian lisensiaatti	fi
37	35	8	tuomarintutkinto	fi
38	36	8	tykistöupseerin tutkinto	fi
39	37	8	Doria, Gratulantti	\N
40	38	8	Doria, Dedikaation kohde	\N
41	39	8	aineopettajan tutkinto	fi
42	40	8	voimistelunopettaja	fi
43	41	8	teologian lisensiaatti	fi
44	42	8	Maatalous- ja metsätieteiden tohtori	fi
45	43	8	Suomen ministerit	\N
46	44	8	sotilastutkinto	fi
47	45	8	hammaslääketieteen lisensiaatti	fi
48	46	8	Place	en
49	46	8	Paikka	fi
50	47	8	siveysopin tutkinto	fi
51	48	8	kirurgian kandidaatti	fi
52	49	8	taktiikan ja linnoitusopin tutkinto	fi
53	50	8	kansliatutkinto	fi
54	51	8	Etunimi	fi
55	52	9	Great Great Great Grandparent	en
56	52	8	Great Great Great Grandparent	en
57	52	8	isoisoisoisovanhempi	fi
58	53	9	Great Great Grandson	en
59	53	8	Great Great Grandson	en
60	53	8	pojanpojan pojanpoika	fi
61	54	9	Great Great Great Grandchild	en
62	54	8	Great Great Great Grandchild	en
63	54	8	lapsenlapsenlapsenlapsenlapsi	fi
64	55	9	Great Great Great Grandfather	en
65	55	8	Great Great Great Grandfather	en
66	55	8	isän isän isän isän isä	fi
67	57	8	teologinen erotutkinto	fi
68	58	8	Finnish Geographic Names	\N
69	59	8	isän serkku	fi
70	60	9	Grandparent	en
71	60	8	Grandparent	en
72	60	8	isovanhempi	fi
73	61	9	Husband	en
74	61	8	Husband	en
75	61	8	aviomies	fi
76	62	8	isän lanko	fi
77	63	9	Wife	en
78	63	8	Wife	en
79	63	8	vaimo	fi
80	64	9	Spouse	en
81	64	8	Spouse	en
82	64	8	puoliso	fi
83	65	9	Cousin	en
84	65	8	Cousin	en
85	65	8	serkku	fi
86	66	9	Great Great Great Grandson	en
87	66	8	Great Great Great Grandson	en
88	66	8	pojanpojan pojanpojan poika	fi
89	67	9	Grandmother	en
90	67	8	Grandmother	en
91	67	8	äidin äiti	fi
92	68	8	maanmittari	fi
93	69	8	lääket.-fil. kandidaatti	fi
94	70	9	Grandmother	en
95	70	8	Grandmother	en
96	70	8	isän äiti	fi
97	71	8	isän velipuoli	fi
98	72	8	velipuolen poika	fi
99	73	8	Kaste	fi
100	73	8	Baptism	en
101	74	9	Grandfather	en
102	74	8	Grandfather	en
103	74	8	isän isä	fi
104	75	9	Grandfather	en
105	75	8	Grandfather	en
106	75	8	äidin isä	fi
107	76	8	Kansallisbiografia	\N
108	77	8	Burial	en
109	77	8	Hautaaminen	fi
110	78	8	agronomi	fi
111	79	8	ominaisuus	fi
112	80	8	koneinsinööri	fi
113	81	8	odontologian kandidaatti	fi
114	82	8	kameraalitutkinto	fi
115	83	8	Wikimedia Commons	\N
116	84	8	serkun tytär	fi
117	85	8	serkun poika	fi
118	86	8	pikkuserkun poika	fi
119	87	9	Second Cousin	en
120	87	8	Second Cousin	en
121	87	8	pikkuserkku	fi
122	88	8	Maatalous- ja metsätieteiden kandidaatti	fi
123	89	8	langon poika	fi
124	90	9	Fourth Cousin	en
125	90	8	Fourth Cousin	en
126	90	8	neljäs serkku	fi
127	91	8	inst.t.	fi
128	92	9	Third Cousin	en
129	92	8	Third Cousin	en
130	92	8	kolmas serkku	fi
131	93	8	lääketieteen lisensiaatti	fi
132	94	8	pikkuserkun tytär	fi
133	95	8	Arvo, ammatti tai toiminta	fi
134	96	8	tarkenne	fi
135	97	8	valtiotieteen kandidaatti	fi
136	98	8	mit	fi
137	99	8	viittaus henkilöön	fi
138	100	8	teologian kandidaatti	fi
139	101	8	Ylioppilasmatrikkeli 1640	\N
140	103	8	hovioikeuden auskultantti	fi
141	105	8	Nimi	fi
142	106	8	fyysis-matem. tiet. lisensiaatti	fi
143	107	8	kadettitutkinto	fi
144	109	8	la	fi
145	110	8	Suomen kansanedustajat	\N
146	111	8	vuori-insinööri	fi
147	112	8	Valtio	fi
148	113	9	Aunt	en
149	113	8	Aunt	en
150	113	8	täti	fi
151	114	8	pojanpojanpoika	fi
152	115	8	pojanpojantytär	fi
153	116	9	Great Grandparent	en
154	116	8	Great Grandparent	en
155	116	8	isoisovanhempi	fi
156	117	9	Father-in-law	en
157	117	8	Father-in-law	en
158	117	8	appi	fi
159	118	9	Mother-in-law	en
160	118	8	Mother-in-law	en
161	118	8	anoppi	fi
162	119	8	Birth	en
163	119	8	Syntymä	fi
164	120	8	ylempi hallintotutkinto	fi
165	121	9	Great grandfather	en
166	121	8	Great grandfather	en
167	121	8	isoisoisä	fi
168	122	9	Great Grandmother	en
169	122	8	Great Grandmother	en
170	122	8	isoisoäiti	fi
171	124	8	yksityistodistuksen saaja s.d	fi
172	125	8	yksityistodistuksen antaja s.d	fi
173	126	8	yksityistodistuksen saaja	fi
174	127	8	yksityistodistuksen antaja	fi
175	128	8	molempien oikeuksien tohtori	fi
176	129	8	mv-ins.t.	fi
177	130	8	hist.-filol. kandidaatti	fi
178	131	8	luokka	fi
179	132	9	Godson	en
180	132	8	Godson	en
181	132	8	kummipoika	fi
182	133	9	Goddaughter	en
183	133	8	Goddaughter	en
184	133	8	kummityttö	fi
185	134	9	Godchild	en
186	134	8	Godchild	en
187	134	8	kummilapsi	fi
188	135	9	Godfather	en
189	135	8	Godfather	en
190	135	8	kummisetä	fi
191	136	8	alempi hallintotutkinto	fi
192	137	8	puolison myöhempi aviomies	fi
193	138	8	puolison seuraava aviomies	fi
194	139	8	puolison edellinen aviomies	fi
195	140	8	puolison aviomies	fi
196	141	8	Wikisource	\N
197	142	8	filosofian kandidaatti	fi
198	143	9	Godmother	en
199	143	8	Godmother	en
200	143	8	kummitäti	fi
201	144	9	Godparent	en
202	144	8	Godparent	en
203	144	8	kummi	fi
204	145	8	puolison aiempi aviomies	fi
205	146	8	meijeritutkinto	fi
206	149	8	Referenced person	en
207	149	8	viitattu henkilö	fi
208	150	8	Namesake	en
209	150	8	kaima	fi
210	151	8	Student	en
211	151	8	oppilas	fi
212	152	8	Teacher	en
213	152	8	opettaja	fi
214	153	8	maanmittausinsinöörin tutkinto	fi
215	154	8	pedagoginen tutkinto	fi
216	155	9	Other Relative	en
217	155	8	Other Relative	en
218	155	8	muu sukulainen	fi
219	156	9	Foster Son	en
220	156	8	Foster Son	en
221	156	8	kasvattipoika	fi
222	157	8	tprelim.t.	fi
223	158	8	appipuoli	fi
224	159	8	dimissiotutkinto	fi
225	160	9	Stepdaughter	en
226	160	8	Stepdaughter	en
227	160	8	tytärpuoli	fi
228	162	9	Stepson	en
229	162	8	Stepson	en
230	162	8	poikapuoli	fi
231	163	8	filosofian tohtori	fi
232	164	9	Foster Father	en
233	164	8	Foster Father	en
234	164	8	kasvatusisä	fi
235	165	9	Daughter's Daughter	en
236	165	8	Daughter's Daughter	en
237	165	8	tyttärentytär	fi
238	166	9	Daughter's Son	en
239	166	8	Daughter's Son	en
240	166	8	tyttärenpoika	fi
241	167	9	Son's Son	en
242	167	8	Son's Son	en
243	167	8	pojanpoika	fi
244	168	8	lääketieteen ja kirurgian tohtori	fi
245	169	8	odontologian tohtori	fi
246	170	8	Geonames	\N
247	171	8	äidin aiempi puoliso	fi
248	172	8	laivarakennusinsinööri	fi
249	173	9	Stepfather	en
250	173	8	isäpuoli	fi
251	173	8	Stepfather	en
252	174	9	Stepmother	en
253	174	8	Stepmother	en
254	174	8	äitipuoli	fi
255	175	8	arkkitehti	fi
256	176	9	Son's Daughter	en
257	176	8	Son's Daughter	en
258	176	8	pojantytär	fi
259	177	8	Lääni, maakunta	fi
260	179	8	kirurgian maisteri	fi
261	180	8	eläinlääketieteen tohtori	fi
262	181	8	Ylioppilasmatrikkeli 1853	\N
263	182	8	Laskennallinen etäisyys	fi
264	183	9	Grandchild	en
265	183	8	Grandchild	en
266	183	8	lapsenlapsi	fi
267	184	9	Big Brother	en
268	184	8	Big Brother	en
269	184	8	isoveli	fi
270	185	8	maanviljelystutkinto	fi
271	186	9	Big Sister	en
272	186	8	Big Sister	en
273	186	8	isosisko	fi
274	187	9	Brother	en
275	187	8	Brother	en
276	187	8	veli	fi
277	188	9	Sister	en
278	188	8	Sister	en
279	188	8	sisko	fi
280	189	9	Twin Sister	en
281	189	8	Twin Sister	en
282	189	8	kaksoissisko	fi
283	190	9	Twin	en
284	190	8	Twin	en
285	190	8	kaksonen	fi
286	191	8	hist.-filol. lisensiaatti	fi
287	192	9	Little Brother	en
288	192	8	Little Brother	en
289	192	8	pikkuveli	fi
290	193	9	Little Sister	en
291	193	8	Little Sister	en
292	193	8	pikkusisko	fi
293	194	9	Twin Brother	en
294	194	8	Twin Brother	en
295	194	8	kaksoisveli	fi
296	195	8	odontologian lisensiaatti	fi
297	197	8	veistonopettaja	fi
298	198	8	molempien oikeuksien lisensiaatti	fi
299	199	8	eläinlääketieteen kandidaatti	fi
300	200	8	kirurginen tutkinto	fi
301	201	9	Great Great Grandchild	en
302	201	8	Great Great Grandchild	en
303	201	8	lapsenlapsenlapsenlapsi	fi
304	202	9	Great Great Grandfather	en
305	202	8	Great Great Grandfather	en
306	202	8	isän isän isän isä	fi
307	203	8	Wikidata	\N
308	205	8	hammaslääketieteen kandidaatti	fi
309	206	8	kansakoulunopettaja	fi
310	207	8	fyysis-matem. tiet. tohtori	fi
311	208	8	farmaseutin tutkinto	fi
312	209	9	Mother	en
313	209	8	Mother	en
314	209	8	äiti	fi
315	210	9	Great Nephew	en
316	210	8	Great Nephew	en
317	210	8	veljentyttären poika	fi
318	211	9	Father	en
319	211	8	Father	en
320	211	8	isä	fi
321	212	9	Great Niece	en
322	212	8	Great Niece	en
323	212	8	siskonpojan tytär	fi
324	213	8	pienempi kameraalitutkinto	fi
325	214	9	Relative	en
326	214	8	Relative	en
327	214	8	sukulainen	fi
328	215	9	Great Niece	en
329	215	8	Great Niece	en
330	215	8	veljenpojan tytär	fi
331	216	8	teologian tohtori	fi
332	217	9	Great Nephew	en
333	217	8	Great Nephew	en
334	217	8	siskonpojan poika	fi
335	218	9	Great Great Grandparent	en
336	218	8	Great Great Grandparent	en
337	218	8	isoisoisovanhempi	fi
338	219	9	Great Niece	en
339	219	8	Great Niece	en
340	219	8	siskontyttären tytär	fi
341	220	9	Great Niece	en
342	220	8	Great Niece	en
343	220	8	veljentyttären tytär	fi
344	221	9	Great Nephew	en
345	221	8	Great Nephew	en
346	221	8	siskontyttären poika	fi
347	222	9	Great Nephew	en
348	222	8	Great Nephew	en
349	222	8	veljenpojan poika	fi
350	223	9	Great Aunt	en
351	223	8	Great Aunt	en
352	223	8	isotäti	fi
353	224	9	Great Uncle	en
354	224	8	Great Uncle	en
355	224	8	isoeno	fi
356	225	8	lakitieteen tohtori	fi
357	226	9	Daughter	en
358	226	8	Daughter	en
359	226	8	tytär	fi
360	227	9	Son	en
361	227	8	Son	en
362	227	8	poika	fi
363	228	8	merikapteeni	fi
364	230	8	Death	en
365	230	8	Kuolema	fi
366	231	8	Henkilö	fi
367	232	8	Lifetime event	en
368	232	8	Elämäntapahtuma	fi
369	233	8	hist.-filol. maisteri	fi
370	234	8	Aika	fi
371	235	8	Event	en
372	235	8	Tapahtuma	fi
373	236	8	hovioikeudentutkinto	fi
374	237	9	Great Grandchild	en
375	237	8	Great Grandchild	en
376	237	8	lapsenlapsenlapsi	fi
377	238	8	teologinen alkututkinto	fi
378	239	9	Stepsister	en
379	239	8	Stepsister	en
380	239	8	sisarpuoli	fi
381	240	9	Great Uncle	en
382	240	8	Great Uncle	en
383	240	8	isosetä	fi
384	241	9	Great Grandson	en
385	241	8	Great Grandson	en
386	241	8	pojantyttären poika	fi
387	242	9	Great Grandson	en
388	242	8	Great Grandson	en
389	242	8	tyttärentyttären poika	fi
390	243	9	Type of Gender	en
391	243	8	Sukupuoli	fi
392	244	9	Great Grandson	en
393	244	8	Great Grandson	en
394	244	8	tyttärenpojan poika	fi
395	245	8	Biografiasampo	\N
396	246	9	Stepbrother	en
397	246	8	Stepbrother	en
398	246	8	velipuoli	fi
399	247	8	suomen asiain komitean tutkinto	fi
400	248	9	Brother-in-law	en
401	248	8	Brother-in-law	en
402	248	8	lanko	fi
403	249	8	Maatalous- ja metsätieteiden lisensiaatti	fi
404	250	8	varatuomari	fi
405	251	8	lääketieteen tohtori	fi
406	252	8	eläinlääketieteen lisensiaatti	fi
407	253	8	Organisaatio	fi
408	254	8	diplomi-insinööri	fi
409	255	9	Niece	en
410	255	8	Niece	en
411	255	8	veljentytär	fi
412	256	9	Niece	en
413	256	8	Niece	en
414	256	8	veljen- tai sisarentyttö	fi
415	257	9	Sister-in-law	en
416	257	8	Sister-in-law	en
417	257	8	käly	fi
418	258	9	Son-in-law	en
419	258	8	Son-in-law	en
420	258	8	vävy	fi
421	259	9	Daughter-in-law	en
422	259	8	Daughter-in-law	en
423	259	8	miniä	fi
424	260	9	Nephew	en
425	260	8	Nephew	en
426	260	8	veljenpoika	fi
427	261	8	valtiotieteen tohtori	fi
428	262	9	Nephew	en
429	262	8	Nephew	en
430	262	8	veljen- tai sisarenpoika	fi
431	263	9	Uncle	en
432	263	8	Uncle	en
433	263	8	setä	fi
434	264	9	Uncle	en
435	264	8	Uncle	en
436	264	8	eno	fi
437	265	8	vihitty papiksi	fi
438	266	9	Nephew	en
439	266	8	Nephew	en
440	266	8	sisarenpoika	fi
441	267	8	Study event	en
442	267	8	Opiskelutapahtuma	fi
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
3	http://ldf.fi/schema/yoma/RectorPeriod	188	\N	t	69	RectorPeriod	RectorPeriod	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	188
8	http://rdfs.org/ns/void#Dataset	1	\N	t	16	Dataset	Dataset	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
10	http://xmlns.com/foaf/0.1/Project	2	\N	t	8	Project	Project	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27
11	http://ldf.fi/yoma/external/Wikipedia	4733	\N	t	72	Wikipedia	Wikipedia	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5164
12	http://ldf.fi/schema/yoma/Enrollment	6675	\N	t	69	Enrollment	Enrollment	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34950
13	http://www.w3.org/2004/02/skos/core#Concept	2141	\N	t	4	Concept	Concept	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	95045
14	http://ldf.fi/yoma/external/Yso	1229	\N	t	72	Yso	Yso	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1284
19	http://ldf.fi/schema/yoma/ReferencedPerson	47246	\N	t	69	ReferencedPerson	ReferencedPerson	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	150438
23	http://ldf.fi/yoma/external/DoriaR	1367	\N	t	72	DoriaR	DoriaR	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1367
24	http://ldf.fi/schema/yoma/FamilyName	18825	\N	t	69	FamilyName	FamilyName	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	153012
26	http://ldf.fi/yoma/external/DoriaP	148	\N	t	72	DoriaP	DoriaP	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	148
27	http://ldf.fi/schema/yoma/StudentNation	24	\N	t	69	StudentNation	StudentNation	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4578
28	http://ldf.fi/schema/yoma/Category	548	\N	t	69	Category	Category	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	77562
29	http://ldf.fi/schema/yoma/Graduation	93	\N	t	69	Graduation	Graduation	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5005
32	http://ldf.fi/schema/yoma/Source	2	\N	t	69	Source	Source	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	28002
1	http://ldf.fi/schema/yoma/g2558301335515412112	42	\N	t	69	g2558301335515412112	[yleinen oikeustutkinto (g2558301335515412112)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	214
2	http://ldf.fi/schema/yoma/g3368169966292211634	201	\N	t	69	g3368169966292211634	[lääketieteen kandidaatti (g3368169966292211634)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	610
4	http://ldf.fi/schema/yoma/g5451505006617159651	21	\N	t	69	g5451505006617159651	[opettajakandidaatti (g5451505006617159651)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	59
5	http://ldf.fi/schema/yoma/g2618394947756368354	11	\N	t	69	g2618394947756368354	[eläinlääkärin tutkinto (g2618394947756368354)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16
6	http://ldf.fi/schema/yoma/g1737743947080393408	83	\N	t	69	g1737743947080393408	[molempien oikeuksien kandidaatti (g1737743947080393408)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	200
7	http://ldf.fi/schema/yoma/g3221810094737866990	4	\N	t	69	g3221810094737866990	[fyysis-matem. tiet. maisteri (g3221810094737866990)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29
9	http://ldf.fi/schema/yoma/g1444884500940040942	2	\N	t	69	g1444884500940040942	[venäjän kielen tutkinto (g1444884500940040942)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
15	http://ldf.fi/schema/yoma/g3160819519021955097	45	\N	t	69	g3160819519021955097	[suurempi kameraalitutkinto (g3160819519021955097)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	45
16	http://ldf.fi/schema/yoma/g1631876715370043005	1	\N	t	69	g1631876715370043005	[vakuutustutkinto (g1631876715370043005)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
17	http://ldf.fi/schema/yoma/g5996229715948430665	21	\N	t	69	g5996229715948430665	[metsänhoitaja (g5996229715948430665)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	30
18	http://ldf.fi/schema/yoma/g4933096598425118816	2	\N	t	69	g4933096598425118816	[apteekkarin tutkinto (g4933096598425118816)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
20	http://ldf.fi/schema/yoma/g3191334509679551021	3	\N	t	69	g3191334509679551021	[hist.-filol. tohtori (g3191334509679551021)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13
21	http://ldf.fi/schema/yoma/g3297450366287827456	259	\N	t	69	g3297450366287827456	[filosofian maisteri (g3297450366287827456)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1512
22	http://ldf.fi/schema/yoma/g5846651988972296464	37	\N	t	69	g5846651988972296464	[insinööri (g5846651988972296464)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	127
25	http://ldf.fi/schema/yoma/g9708147906518802909	16	\N	t	69	g9708147906518802909	[pedagogian tutkinto (g9708147906518802909)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27
30	http://ldf.fi/schema/yoma/g8646787494355964426	16	\N	t	69	g8646787494355964426	[vuoritutkinto (g8646787494355964426)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16
33	http://ldf.fi/schema/yoma/g3215269664579339651	29	\N	t	69	g3215269664579339651	[fyysis-matem. tiet. kandidaatti (g3215269664579339651)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	93
34	http://ldf.fi/schema/yoma/g1850302861453412824	93	\N	t	69	g1850302861453412824	[filosofian lisensiaatti (g1850302861453412824)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	380
35	http://ldf.fi/schema/yoma/g1094414009164056432	283	\N	t	69	g1094414009164056432	[tuomarintutkinto (g1094414009164056432)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	394
36	http://ldf.fi/schema/yoma/g1407292077800346185	1	\N	t	69	g1407292077800346185	[tykistöupseerin tutkinto (g1407292077800346185)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
37	http://ldf.fi/yoma/external/DoriaG	783	\N	t	72	DoriaG	DoriaG	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	783
38	http://ldf.fi/yoma/external/DoriaD	1135	\N	t	72	DoriaD	DoriaD	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1135
43	http://ldf.fi/yoma/external/Ministerit	73	\N	t	72	Ministerit	Ministerit	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	75
46	http://ldf.fi/schema/yoma/Place	9553	\N	t	69	Place	Place	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	379605
51	http://ldf.fi/schema/yoma/GivenName	3660	\N	t	69	GivenName	GivenName	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	146116
56	http://ldf.fi/schema/yoma/Coordinate	27978	\N	t	69	Coordinate	Coordinate	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27978
58	http://ldf.fi/yoma/external/PNR	686	\N	t	72	PNR	PNR	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	690
73	http://ldf.fi/schema/yoma/Baptism	495	\N	t	69	Baptism	Baptism	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	495
76	http://ldf.fi/yoma/external/Kansallisbiografia	2669	\N	t	72	Kansallisbiografia	Kansallisbiografia	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2669
77	http://ldf.fi/schema/yoma/Burial	1260	\N	t	69	Burial	Burial	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1260
40	http://ldf.fi/schema/yoma/g9638768252472673330	18	\N	t	69	g9638768252472673330	[voimistelunopettaja (g9638768252472673330)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	36
41	http://ldf.fi/schema/yoma/g2343862490778152611	42	\N	t	69	g2343862490778152611	[teologian lisensiaatti (g2343862490778152611)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	49
42	http://ldf.fi/schema/yoma/g1134642612769778431	1	\N	t	69	g1134642612769778431	[Maatalous- ja metsätieteiden tohtori (g1134642612769778431)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
44	http://ldf.fi/schema/yoma/g1020977664085017850	1	\N	t	69	g1020977664085017850	[sotilastutkinto (g1020977664085017850)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
47	http://ldf.fi/schema/yoma/g1051132990331311919	2	\N	t	69	g1051132990331311919	[siveysopin tutkinto (g1051132990331311919)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
48	http://ldf.fi/schema/yoma/g1276345218737905284	13	\N	t	69	g1276345218737905284	[kirurgian kandidaatti (g1276345218737905284)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13
49	http://ldf.fi/schema/yoma/g1092369315679461239	1	\N	t	69	g1092369315679461239	[taktiikan ja linnoitusopin tutkinto (g1092369315679461239)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
50	http://ldf.fi/schema/yoma/g2917574996974726792	11	\N	t	69	g2917574996974726792	[kansliatutkinto (g2917574996974726792)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11
52	http://ldf.fi/yoma/relations/f101	2	\N	t	73	f101	[Great Great Great Grandparent (f101)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
53	http://ldf.fi/yoma/relations/f100	17	\N	t	73	f100	[Great Great Grandson (f100)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	17
54	http://ldf.fi/yoma/relations/f103	1	\N	t	73	f103	[Great Great Great Grandchild (f103)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
55	http://ldf.fi/yoma/relations/f102	2	\N	t	73	f102	[Great Great Great Grandfather (f102)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
59	http://ldf.fi/yoma/relations/f109	968	\N	t	73	f109	[isän serkku (f109)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	968
60	http://ldf.fi/yoma/relations/f13	1	\N	t	73	f13	[Grandparent (f13)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
61	http://ldf.fi/yoma/relations/f12	31276	\N	t	73	f12	[Husband (f12)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	48228
62	http://ldf.fi/yoma/relations/f108	1382	\N	t	73	f108	[isän lanko (f108)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1384
63	http://ldf.fi/yoma/relations/f11	34606	\N	t	73	f11	[Wife (f11)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	51940
64	http://ldf.fi/yoma/relations/f10	1	\N	t	73	f10	[Spouse (f10)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
65	http://ldf.fi/yoma/relations/f105	3504	\N	t	73	f105	[Cousin (f105)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3869
66	http://ldf.fi/yoma/relations/f104	2	\N	t	73	f104	[Great Great Great Grandson (f104)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
67	http://ldf.fi/yoma/relations/f16	3	\N	t	73	f16	[Grandmother (f16)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
69	http://ldf.fi/schema/yoma/g4969316710281496718	10	\N	t	69	g4969316710281496718	[lääket.-fil. kandidaatti (g4969316710281496718)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11
70	http://ldf.fi/yoma/relations/f15	3929	\N	t	73	f15	[Grandmother (f15)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3930
71	http://ldf.fi/yoma/relations/f107	16	\N	t	73	f107	[isän velipuoli (f107)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	17
72	http://ldf.fi/yoma/relations/f106	17	\N	t	73	f106	[velipuolen poika (f106)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	17
74	http://ldf.fi/yoma/relations/f19	4090	\N	t	73	f19	[Grandfather (f19)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4120
75	http://ldf.fi/yoma/relations/f18	531	\N	t	73	f18	[Grandfather (f18)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	599
78	http://ldf.fi/schema/yoma/g1529496508497607186	47	\N	t	69	g1529496508497607186	[agronomi (g1529496508497607186)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	87
79	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	12	\N	t	1	Property	Property	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	184
83	http://ldf.fi/yoma/external/Wikimedia	494	\N	t	72	Wikimedia	Wikimedia	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	520
95	http://ldf.fi/schema/yoma/Title	10914	\N	t	69	Title	Title	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	210048
96	http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement	187324	\N	t	1	Statement	Statement	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
99	http://ldf.fi/schema/yoma/PersonLink	24	\N	t	69	PersonLink	PersonLink	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
102	http://www.w3.org/ns/sparql-service-description#Dataset	1	\N	t	27	Dataset	Dataset	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
104	http://www.w3.org/2002/07/owl#DatatypeProperty	25	\N	t	7	DatatypeProperty	DatatypeProperty	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
105	http://ldf.fi/schema/yoma/Label	93050	\N	t	69	Label	Label	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	113645
108	http://www.w3.org/2002/07/owl#ObjectProperty	38	\N	t	7	ObjectProperty	ObjectProperty	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	187324
110	http://ldf.fi/yoma/external/Kansanedustajat	216	\N	t	72	Kansanedustajat	Kansanedustajat	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	224
112	http://ldf.fi/schema/yoma/Country	199	\N	t	69	Country	Country	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	54993
119	http://ldf.fi/schema/yoma/Birth	24944	\N	t	69	Birth	Birth	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24944
82	http://ldf.fi/schema/yoma/g3024618096142062191	107	\N	t	69	g3024618096142062191	[kameraalitutkinto (g3024618096142062191)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	248
84	http://ldf.fi/yoma/relations/f112	26	\N	t	73	f112	[serkun tytär (f112)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26
85	http://ldf.fi/yoma/relations/f111	1707	\N	t	73	f111	[serkun poika (f111)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1708
86	http://ldf.fi/yoma/relations/f114	306	\N	t	73	f114	[pikkuserkun poika (f114)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	306
87	http://ldf.fi/yoma/relations/f113	654	\N	t	73	f113	[Second Cousin (f113)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	654
88	http://ldf.fi/schema/yoma/g5045484143321347432	1	\N	t	69	g5045484143321347432	[Maatalous- ja metsätieteiden kandidaatti (g5045484143321347432)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
89	http://ldf.fi/yoma/relations/f110	5619	\N	t	73	f110	[langon poika (f110)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5619
90	http://ldf.fi/yoma/relations/f119	1	\N	t	73	f119	[Fourth Cousin (f119)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
92	http://ldf.fi/yoma/relations/f116	1	\N	t	73	f116	[Third Cousin (f116)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
93	http://ldf.fi/schema/yoma/g2492297360127435117	196	\N	t	69	g2492297360127435117	[lääketieteen lisensiaatti (g2492297360127435117)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	572
94	http://ldf.fi/yoma/relations/f115	4	\N	t	73	f115	[pikkuserkun tytär (f115)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
97	http://ldf.fi/schema/yoma/g1638491349696170650	9	\N	t	69	g1638491349696170650	[valtiotieteen kandidaatti (g1638491349696170650)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
98	http://ldf.fi/schema/yoma/g1527209374544075562	1	\N	t	69	g1527209374544075562	[mit (g1527209374544075562)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
100	http://ldf.fi/schema/yoma/g1746701616399258867	57	\N	t	69	g1746701616399258867	[teologian kandidaatti (g1746701616399258867)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	73
101	http://ldf.fi/yoma/external/D1640	18493	\N	t	72	D1640	[Ylioppilasmatrikkeli 1640 (D1640)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18493
106	http://ldf.fi/schema/yoma/g6549489709986829201	9	\N	t	69	g6549489709986829201	[fyysis-matem. tiet. lisensiaatti (g6549489709986829201)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
107	http://ldf.fi/schema/yoma/g1957318864592042076	1	\N	t	69	g1957318864592042076	[kadettitutkinto (g1957318864592042076)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
109	http://ldf.fi/schema/yoma/g2672195952323784717	1	\N	t	69	g2672195952323784717	[la (g2672195952323784717)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
111	http://ldf.fi/schema/yoma/g3122949480113649318	4	\N	t	69	g3122949480113649318	[vuori-insinööri (g3122949480113649318)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
113	http://ldf.fi/yoma/relations/f64	6	\N	t	73	f64	[Aunt (f64)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6
114	http://ldf.fi/yoma/relations/f62	4462	\N	t	73	f62	[pojanpojanpoika (f62)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4462
115	http://ldf.fi/yoma/relations/f61	78	\N	t	73	f61	[pojanpojantytär (f61)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	78
116	http://ldf.fi/yoma/relations/f57	5	\N	t	73	f57	[Great Grandparent (f57)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
117	http://ldf.fi/yoma/relations/f56	14702	\N	t	73	f56	[Father-in-law (f56)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16631
118	http://ldf.fi/yoma/relations/f55	13588	\N	t	73	f55	[Mother-in-law (f55)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13588
123	http://www.w3.org/ns/sparql-service-description#Graph	12	\N	t	27	Graph	Graph	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24
131	http://www.w3.org/2000/01/rdf-schema#Class	184	\N	t	2	Class	Class	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1100285
141	http://ldf.fi/yoma/external/Wikisource	238	\N	t	72	Wikisource	Wikisource	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	255
147	http://xmlns.com/foaf/0.1/Organization	1	\N	t	8	Organization	Organization	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15
148	http://ldf.fi/schema/yoma/Reference	1217	\N	t	69	Reference	Reference	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	105933
151	http://ldf.fi/yoma/relations/ff2	76	\N	t	73	ff2	ff2	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	80
152	http://ldf.fi/yoma/relations/ff1	48	\N	t	73	ff1	ff1	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	81
161	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
122	http://ldf.fi/yoma/relations/f58	1587	\N	t	73	f58	[Great Grandmother (f58)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1589
124	http://ldf.fi/yoma/relations/ff8	231	\N	t	73	ff8	[yksityistodistuksen saaja s.d (ff8)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	231
125	http://ldf.fi/yoma/relations/ff7	83	\N	t	73	ff7	[yksityistodistuksen antaja s.d (ff7)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	213
127	http://ldf.fi/yoma/relations/ff5	408	\N	t	73	ff5	[yksityistodistuksen antaja (ff5)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2159
128	http://ldf.fi/schema/yoma/g9283198276855811099	33	\N	t	69	g9283198276855811099	[molempien oikeuksien tohtori (g9283198276855811099)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	49
129	http://ldf.fi/schema/yoma/g9617631581330674986	1	\N	t	69	g9617631581330674986	[mv-ins.t. (g9617631581330674986)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
130	http://ldf.fi/schema/yoma/g1124787801950771664	32	\N	t	69	g1124787801950771664	[hist.-filol. kandidaatti (g1124787801950771664)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	98
132	http://ldf.fi/yoma/relations/f53	2	\N	t	73	f53	[Godson (f53)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
133	http://ldf.fi/yoma/relations/f52	2	\N	t	73	f52	[Goddaughter (f52)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
134	http://ldf.fi/yoma/relations/f51	1	\N	t	73	f51	[Godchild (f51)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
135	http://ldf.fi/yoma/relations/f50	2	\N	t	73	f50	[Godfather (f50)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
137	http://ldf.fi/yoma/relations/f46	4	\N	t	73	f46	[puolison myöhempi aviomies (f46)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
138	http://ldf.fi/yoma/relations/f45	736	\N	t	73	f45	[puolison seuraava aviomies (f45)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	752
139	http://ldf.fi/yoma/relations/f44	753	\N	t	73	f44	[puolison edellinen aviomies (f44)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	753
140	http://ldf.fi/yoma/relations/f43	1	\N	t	73	f43	[puolison aviomies (f43)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
143	http://ldf.fi/yoma/relations/f49	2	\N	t	73	f49	[Godmother (f49)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
144	http://ldf.fi/yoma/relations/f48	1	\N	t	73	f48	[Godparent (f48)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
145	http://ldf.fi/yoma/relations/f47	2	\N	t	73	f47	[puolison aiempi aviomies (f47)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
146	http://ldf.fi/schema/yoma/g1903599853551775083	1	\N	t	69	g1903599853551775083	[meijeritutkinto (g1903599853551775083)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
149	http://ldf.fi/yoma/relations/ff4	464	\N	t	73	ff4	[Referenced person (ff4)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	506
150	http://ldf.fi/yoma/relations/ff3	638	\N	t	73	ff3	[Namesake (ff3)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	671
153	http://ldf.fi/schema/yoma/g2085248443894212426	10	\N	t	69	g2085248443894212426	[maanmittausinsinöörin tutkinto (g2085248443894212426)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
154	http://ldf.fi/schema/yoma/g2497945159166979817	5	\N	t	69	g2497945159166979817	[pedagoginen tutkinto (g2497945159166979817)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
155	http://ldf.fi/yoma/relations/f123	131	\N	t	73	f123	[Other Relative (f123)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	136
156	http://ldf.fi/yoma/relations/f122	48	\N	t	73	f122	[Foster Son (f122)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	48
158	http://ldf.fi/yoma/relations/f124	1	\N	t	73	f124	[appipuoli (f124)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
159	http://ldf.fi/schema/yoma/g2218637135154495384	1	\N	t	69	g2218637135154495384	[dimissiotutkinto (g2218637135154495384)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
160	http://ldf.fi/yoma/relations/f42	2	\N	t	73	f42	[Stepdaughter (f42)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
162	http://ldf.fi/yoma/relations/f41	167	\N	t	73	f41	[Stepson (f41)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	168
163	http://ldf.fi/schema/yoma/g2358668915759952842	79	\N	t	69	g2358668915759952842	[filosofian tohtori (g2358668915759952842)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	352
170	http://ldf.fi/yoma/external/Geonames	5695	\N	t	72	Geonames	Geonames	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10450
177	http://ldf.fi/schema/yoma/County	45	\N	t	69	County	County	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	53545
178	http://ldf.fi/yoma/external/nbf	2669	\N	t	72	nbf	nbf	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2669
182	http://ldf.fi/schema/yoma/Distance	123197	\N	t	69	Distance	Distance	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
196	http://www.w3.org/ns/dcat#Dataset	1	\N	t	15	Dataset	Dataset	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
203	http://ldf.fi/yoma/external/Wikidata	8949	\N	t	72	Wikidata	Wikidata	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9917
204	http://www.w3.org/2002/07/owl#Class	6	\N	t	7	Class	Class	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25
166	http://ldf.fi/yoma/relations/f34	599	\N	t	73	f34	[Daughter's Son (f34)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	599
167	http://ldf.fi/yoma/relations/f33	9054	\N	t	73	f33	[Son's Son (f33)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9054
168	http://ldf.fi/schema/yoma/g1380146229371818664	65	\N	t	69	g1380146229371818664	[lääketieteen ja kirurgian tohtori (g1380146229371818664)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	183
169	http://ldf.fi/schema/yoma/g4498816009714067930	1	\N	t	69	g4498816009714067930	[odontologian tohtori (g4498816009714067930)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
171	http://ldf.fi/yoma/relations/f39	27	\N	t	73	f39	[äidin aiempi puoliso (f39)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	28
173	http://ldf.fi/yoma/relations/f38	161	\N	t	73	f38	[Stepfather (f38)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	164
174	http://ldf.fi/yoma/relations/f37	3	\N	t	73	f37	[Stepmother (f37)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
175	http://ldf.fi/schema/yoma/g1459438354005302838	1	\N	t	69	g1459438354005302838	[arkkitehti (g1459438354005302838)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
176	http://ldf.fi/yoma/relations/f36	110	\N	t	73	f36	[Son's Daughter (f36)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	110
179	http://ldf.fi/schema/yoma/g1756189121092445527	27	\N	t	69	g1756189121092445527	[kirurgian maisteri (g1756189121092445527)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	28
180	http://ldf.fi/schema/yoma/g1679953932587298964	2	\N	t	69	g1679953932587298964	[eläinlääketieteen tohtori (g1679953932587298964)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
181	http://ldf.fi/yoma/external/D1853	9509	\N	t	72	D1853	[Ylioppilasmatrikkeli 1853 (D1853)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9509
183	http://ldf.fi/yoma/relations/f30	3	\N	t	73	f30	[Grandchild (f30)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
184	http://ldf.fi/yoma/relations/f24	2	\N	t	73	f24	[Big Brother (f24)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
186	http://ldf.fi/yoma/relations/f23	2	\N	t	73	f23	[Big Sister (f23)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
187	http://ldf.fi/yoma/relations/f22	12981	\N	t	73	f22	[Brother (f22)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	13574
188	http://ldf.fi/yoma/relations/f21	272	\N	t	73	f21	[Sister (f21)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	272
189	http://ldf.fi/yoma/relations/f28	1	\N	t	73	f28	[Twin Sister (f28)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
190	http://ldf.fi/yoma/relations/f27	1	\N	t	73	f27	[Twin (f27)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
191	http://ldf.fi/schema/yoma/g6374835255930559944	16	\N	t	69	g6374835255930559944	[hist.-filol. lisensiaatti (g6374835255930559944)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	17
192	http://ldf.fi/yoma/relations/f26	2	\N	t	73	f26	[Little Brother (f26)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
193	http://ldf.fi/yoma/relations/f25	2	\N	t	73	f25	[Little Sister (f25)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
194	http://ldf.fi/yoma/relations/f29	2	\N	t	73	f29	[Twin Brother (f29)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
197	http://ldf.fi/schema/yoma/g1171664233185438051	1	\N	t	69	g1171664233185438051	[veistonopettaja (g1171664233185438051)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
198	http://ldf.fi/schema/yoma/g9623729553228523179	48	\N	t	69	g9623729553228523179	[molempien oikeuksien lisensiaatti (g9623729553228523179)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	59
199	http://ldf.fi/schema/yoma/g2859349496070693686	11	\N	t	69	g2859349496070693686	[eläinlääketieteen kandidaatti (g2859349496070693686)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
200	http://ldf.fi/schema/yoma/g2142232220837155842	1	\N	t	69	g2142232220837155842	[kirurginen tutkinto (g2142232220837155842)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
201	http://ldf.fi/yoma/relations/f99	2	\N	t	73	f99	[Great Great Grandchild (f99)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
202	http://ldf.fi/yoma/relations/f98	16	\N	t	73	f98	[Great Great Grandfather (f98)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18
206	http://ldf.fi/schema/yoma/g1242261180393355164	23	\N	t	69	g1242261180393355164	[kansakoulunopettaja (g1242261180393355164)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	67
229	http://www.w3.org/ns/sparql-service-description#NamedGraph	14	\N	t	27	NamedGraph	NamedGraph	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
230	http://ldf.fi/schema/yoma/Death	42815	\N	t	69	Death	Death	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	41657
231	http://ldf.fi/schema/yoma/Person	27978	\N	t	69	Person	Person	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	622011
232	http://ldf.fi/schema/yoma/Career	41760	\N	t	69	Career	Career	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	101746
234	http://ldf.fi/schema/yoma/Timespan	62575	\N	t	69	Timespan	Timespan	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	367448
235	http://ldf.fi/schema/yoma/Event	16987	\N	t	69	Event	Event	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	85489
243	http://schema.org/GenderType	2	\N	t	9	GenderType	GenderType	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	74733
245	http://ldf.fi/yoma/external/Biografiasampo	2668	\N	t	72	Biografiasampo	Biografiasampo	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2668
208	http://ldf.fi/schema/yoma/g2453613365096743404	4	\N	t	69	g2453613365096743404	[farmaseutin tutkinto (g2453613365096743404)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
209	http://ldf.fi/yoma/relations/f3	18080	\N	t	73	f3	[Mother (f3)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25514
210	http://ldf.fi/yoma/relations/f93	165	\N	t	73	f93	[Great Nephew (f93)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	268
211	http://ldf.fi/yoma/relations/f4	17688	\N	t	73	f4	[Father (f4)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25498
212	http://ldf.fi/yoma/relations/f92	2	\N	t	73	f92	[Great Niece (f92)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
213	http://ldf.fi/schema/yoma/g2003576090173480696	64	\N	t	69	g2003576090173480696	[pienempi kameraalitutkinto (g2003576090173480696)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	65
214	http://ldf.fi/yoma/relations/f1	401	\N	t	73	f1	[Relative (f1)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	412
215	http://ldf.fi/yoma/relations/f91	50	\N	t	73	f91	[Great Niece (f91)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	50
217	http://ldf.fi/yoma/relations/f90	232	\N	t	73	f90	[Great Nephew (f90)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	232
218	http://ldf.fi/yoma/relations/f97	2	\N	t	73	f97	[Great Great Grandparent (f97)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
219	http://ldf.fi/yoma/relations/f96	1	\N	t	73	f96	[Great Niece (f96)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
220	http://ldf.fi/yoma/relations/f95	3	\N	t	73	f95	[Great Niece (f95)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
221	http://ldf.fi/yoma/relations/f94	5	\N	t	73	f94	[Great Nephew (f94)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
222	http://ldf.fi/yoma/relations/f89	2846	\N	t	73	f89	[Great Nephew (f89)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2846
223	http://ldf.fi/yoma/relations/f88	8	\N	t	73	f88	[Great Aunt (f88)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
224	http://ldf.fi/yoma/relations/f87	130	\N	t	73	f87	[Great Uncle (f87)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	131
226	http://ldf.fi/yoma/relations/f7	520	\N	t	73	f7	[Daughter (f7)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1028
227	http://ldf.fi/yoma/relations/f6	25076	\N	t	73	f6	[Son (f6)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	49997
228	http://ldf.fi/schema/yoma/g2806744662468601197	1	\N	t	69	g2806744662468601197	[merikapteeni (g2806744662468601197)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
233	http://ldf.fi/schema/yoma/g1915398551571420968	6	\N	t	69	g1915398551571420968	[hist.-filol. maisteri (g1915398551571420968)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34
236	http://ldf.fi/schema/yoma/g1516437164325354918	17	\N	t	69	g1516437164325354918	[hovioikeudentutkinto (g1516437164325354918)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18
237	http://ldf.fi/yoma/relations/f81	602	\N	t	73	f81	[Great Grandchild (f81)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	602
238	http://ldf.fi/schema/yoma/g2483673649728743521	14	\N	t	69	g2483673649728743521	[teologinen alkututkinto (g2483673649728743521)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	30
239	http://ldf.fi/yoma/relations/f80	2	\N	t	73	f80	[Stepsister (f80)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
240	http://ldf.fi/yoma/relations/f86	1317	\N	t	73	f86	[Great Uncle (f86)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1877
241	http://ldf.fi/yoma/relations/f85	7	\N	t	73	f85	[Great Grandson (f85)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7
242	http://ldf.fi/yoma/relations/f84	4	\N	t	73	f84	[Great Grandson (f84)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4
244	http://ldf.fi/yoma/relations/f83	14	\N	t	73	f83	[Great Grandson (f83)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
246	http://ldf.fi/yoma/relations/f79	340	\N	t	73	f79	[Stepbrother (f79)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	394
248	http://ldf.fi/yoma/relations/f77	11472	\N	t	73	f77	[Brother-in-law (f77)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12396
249	http://ldf.fi/schema/yoma/g1426472843350672558	1	\N	t	69	g1426472843350672558	[Maatalous- ja metsätieteiden lisensiaatti (g1426472843350672558)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
253	http://ldf.fi/schema/yoma/Organization	494	\N	t	69	Organization	Organization	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	51588
265	http://ldf.fi/schema/yoma/g1714899163887998743	1892	\N	t	69	g1714899163887998743	g1714899163887998743	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2352
267	http://ldf.fi/schema/yoma/Study	42052	\N	t	69	Study	Study	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	167002
31	http://ldf.fi/schema/yoma/g1575311609677174422	13	\N	t	69	g1575311609677174422	[hammaslääkärin tutkinto (g1575311609677174422)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18
39	http://ldf.fi/schema/yoma/g2481595331836779350	1	\N	t	69	g2481595331836779350	[aineopettajan tutkinto (g2481595331836779350)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
45	http://ldf.fi/schema/yoma/g2538365191212913001	2	\N	t	69	g2538365191212913001	[hammaslääketieteen lisensiaatti (g2538365191212913001)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
57	http://ldf.fi/schema/yoma/g2713054240657153466	65	\N	t	69	g2713054240657153466	[teologinen erotutkinto (g2713054240657153466)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	264
68	http://ldf.fi/schema/yoma/g2243205162698326589	67	\N	t	69	g2243205162698326589	[maanmittari (g2243205162698326589)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	70
80	http://ldf.fi/schema/yoma/g1223568493341421625	1	\N	t	69	g1223568493341421625	[koneinsinööri (g1223568493341421625)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
81	http://ldf.fi/schema/yoma/g2532983791094511735	5	\N	t	69	g2532983791094511735	[odontologian kandidaatti (g2532983791094511735)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6
91	http://ldf.fi/schema/yoma/g1554755626560400279	3	\N	t	69	g1554755626560400279	[inst.t. (g1554755626560400279)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
103	http://ldf.fi/schema/yoma/g2253062910799314776	1	\N	t	69	g2253062910799314776	[hovioikeuden auskultantti (g2253062910799314776)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
120	http://ldf.fi/schema/yoma/g8475694716147164306	21	\N	t	69	g8475694716147164306	[ylempi hallintotutkinto (g8475694716147164306)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	142
121	http://ldf.fi/yoma/relations/f59	1713	\N	t	73	f59	[Great grandfather (f59)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1791
126	http://ldf.fi/yoma/relations/ff6	2086	\N	t	73	ff6	[yksityistodistuksen saaja (ff6)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2141
136	http://ldf.fi/schema/yoma/g5769799630000311203	20	\N	t	69	g5769799630000311203	[alempi hallintotutkinto (g5769799630000311203)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	55
142	http://ldf.fi/schema/yoma/g1358693986524009994	595	\N	t	69	g1358693986524009994	[filosofian kandidaatti (g1358693986524009994)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2002
157	http://ldf.fi/schema/yoma/g2676255065583335423	1	\N	t	69	g2676255065583335423	[tprelim.t. (g2676255065583335423)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
164	http://ldf.fi/yoma/relations/f120	47	\N	t	73	f120	[Foster Father (f120)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	48
165	http://ldf.fi/yoma/relations/f35	2	\N	t	73	f35	[Daughter's Daughter (f35)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
172	http://ldf.fi/schema/yoma/g2351146375655609964	1	\N	t	69	g2351146375655609964	[laivarakennusinsinööri (g2351146375655609964)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
185	http://ldf.fi/schema/yoma/g3755442716089739948	1	\N	t	69	g3755442716089739948	[maanviljelystutkinto (g3755442716089739948)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
195	http://ldf.fi/schema/yoma/g9878215652764345507	6	\N	t	69	g9878215652764345507	[odontologian lisensiaatti (g9878215652764345507)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7
252	http://ldf.fi/schema/yoma/g1772647649112862996	1	\N	t	69	g1772647649112862996	[eläinlääketieteen lisensiaatti (g1772647649112862996)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
254	http://ldf.fi/schema/yoma/g1241766674481741742	3	\N	t	69	g1241766674481741742	[diplomi-insinööri (g1241766674481741742)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
255	http://ldf.fi/yoma/relations/f71	78	\N	t	73	f71	[Niece (f71)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	78
256	http://ldf.fi/yoma/relations/f70	10	\N	t	73	f70	[Niece (f70)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19
257	http://ldf.fi/yoma/relations/f75	6447	\N	t	73	f75	[Sister-in-law (f75)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8534
258	http://ldf.fi/yoma/relations/f74	4783	\N	t	73	f74	[Son-in-law (f74)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5186
259	http://ldf.fi/yoma/relations/f73	20497	\N	t	73	f73	[Daughter-in-law (f73)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20499
260	http://ldf.fi/yoma/relations/f72	5820	\N	t	73	f72	[Nephew (f72)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5821
261	http://ldf.fi/schema/yoma/g6058950148274999344	3	\N	t	69	g6058950148274999344	[valtiotieteen tohtori (g6058950148274999344)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
262	http://ldf.fi/yoma/relations/f67	562	\N	t	73	f67	[Nephew (f67)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	907
263	http://ldf.fi/yoma/relations/f66	3779	\N	t	73	f66	[Uncle (f66)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4078
264	http://ldf.fi/yoma/relations/f65	400	\N	t	73	f65	[Uncle (f65)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	462
266	http://ldf.fi/yoma/relations/f69	460	\N	t	73	f69	[Nephew (f69)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	460
205	http://ldf.fi/schema/yoma/g2655061136992365297	10	\N	t	69	g2655061136992365297	[hammaslääketieteen kandidaatti (g2655061136992365297)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	17
207	http://ldf.fi/schema/yoma/g9491104119765718792	2	\N	t	69	g9491104119765718792	[fyysis-matem. tiet. tohtori (g9491104119765718792)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
216	http://ldf.fi/schema/yoma/g5133781108713492098	29	\N	t	69	g5133781108713492098	[teologian tohtori (g5133781108713492098)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	57
225	http://ldf.fi/schema/yoma/g2277722951792149696	8	\N	t	69	g2277722951792149696	[lakitieteen tohtori (g2277722951792149696)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
247	http://ldf.fi/schema/yoma/g1753293870331390562	7	\N	t	69	g1753293870331390562	[suomen asiain komitean tutkinto (g1753293870331390562)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7
250	http://ldf.fi/schema/yoma/g1695979729067765665	65	\N	t	69	g1695979729067765665	[varatuomari (g1695979729067765665)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	88
251	http://ldf.fi/schema/yoma/g2248230971429509069	15	\N	t	69	g2248230971429509069	[lääketieteen tohtori (g2248230971429509069)]	85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	19	1	2	7168	\N	0	\N	\N	1	1	2	f	7168	\N	\N
2	46	1	2	3963	\N	0	\N	\N	2	1	2	f	3963	\N	\N
3	227	1	2	2578	\N	0	\N	\N	3	1	2	f	2578	\N	\N
4	61	1	2	1591	\N	0	\N	\N	4	1	2	f	1591	\N	\N
5	63	1	2	1335	\N	0	\N	\N	5	1	2	f	1335	\N	\N
6	231	1	2	457	\N	0	\N	\N	6	1	2	f	457	\N	\N
7	209	1	2	406	\N	0	\N	\N	7	1	2	f	406	\N	\N
8	95	1	2	358	\N	0	\N	\N	8	1	2	f	358	\N	\N
9	211	1	2	240	\N	0	\N	\N	9	1	2	f	240	\N	\N
10	235	1	2	184	\N	0	\N	\N	10	1	2	f	184	\N	\N
11	259	1	2	122	\N	0	\N	\N	11	1	2	f	122	\N	\N
12	267	1	2	94	\N	0	\N	\N	12	1	2	f	94	\N	\N
13	253	1	2	85	\N	0	\N	\N	13	1	2	f	85	\N	\N
14	232	1	2	77	\N	0	\N	\N	14	1	2	f	77	\N	\N
15	188	1	2	63	\N	0	\N	\N	15	1	2	f	63	\N	\N
16	226	1	2	58	\N	0	\N	\N	16	1	2	f	58	\N	\N
17	257	1	2	49	\N	0	\N	\N	17	1	2	f	49	\N	\N
18	176	1	2	29	\N	0	\N	\N	18	1	2	f	29	\N	\N
19	255	1	2	25	\N	0	\N	\N	19	1	2	f	25	\N	\N
20	258	1	2	25	\N	0	\N	\N	20	1	2	f	25	\N	\N
21	234	1	2	22	\N	0	\N	\N	21	1	2	f	22	\N	\N
22	115	1	2	19	\N	0	\N	\N	22	1	2	f	19	\N	\N
23	27	1	2	13	\N	0	\N	\N	23	1	2	f	13	\N	\N
24	13	1	2	13	\N	0	\N	\N	24	1	2	f	13	\N	\N
25	187	1	2	12	\N	0	\N	\N	25	1	2	f	12	\N	\N
26	248	1	2	11	\N	0	\N	\N	26	1	2	f	11	\N	\N
27	215	1	2	9	\N	0	\N	\N	27	1	2	f	9	\N	\N
28	65	1	2	6	\N	0	\N	\N	28	1	2	f	6	\N	\N
29	167	1	2	6	\N	0	\N	\N	29	1	2	f	6	\N	\N
30	84	1	2	5	\N	0	\N	\N	30	1	2	f	5	\N	\N
31	222	1	2	4	\N	0	\N	\N	31	1	2	f	4	\N	\N
32	114	1	2	4	\N	0	\N	\N	32	1	2	f	4	\N	\N
33	89	1	2	4	\N	0	\N	\N	33	1	2	f	4	\N	\N
34	260	1	2	4	\N	0	\N	\N	34	1	2	f	4	\N	\N
35	230	1	2	4	\N	0	\N	\N	35	1	2	f	4	\N	\N
36	87	1	2	3	\N	0	\N	\N	36	1	2	f	3	\N	\N
37	85	1	2	3	\N	0	\N	\N	37	1	2	f	3	\N	\N
38	32	1	2	2	\N	0	\N	\N	38	1	2	f	2	\N	\N
39	94	1	2	2	\N	0	\N	\N	39	1	2	f	2	\N	\N
40	12	1	2	1	\N	0	\N	\N	40	1	2	f	1	\N	\N
41	118	1	2	1	\N	0	\N	\N	41	1	2	f	1	\N	\N
42	117	1	2	1	\N	0	\N	\N	42	1	2	f	1	\N	\N
43	112	1	2	116	\N	0	\N	\N	0	1	2	f	116	\N	\N
44	177	1	2	83	\N	0	\N	\N	0	1	2	f	83	\N	\N
45	131	1	2	73	\N	0	\N	\N	0	1	2	f	73	\N	\N
46	267	2	2	4847	\N	4847	\N	\N	1	1	2	f	0	231	\N
47	235	2	2	115	\N	115	\N	\N	2	1	2	f	0	231	\N
48	231	2	1	4962	\N	4962	\N	\N	1	1	2	f	\N	\N	\N
49	123	3	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
50	231	4	2	21520	\N	0	\N	\N	1	1	2	f	21520	\N	\N
51	232	5	2	54909	\N	54909	\N	\N	1	1	2	f	0	234	\N
52	267	5	2	46114	\N	46114	\N	\N	2	1	2	f	0	234	\N
53	230	5	2	42452	\N	42452	\N	\N	3	1	2	f	0	\N	\N
54	119	5	2	23249	\N	23249	\N	\N	4	1	2	f	0	234	\N
55	96	5	2	21566	\N	21566	\N	\N	5	1	2	f	0	234	\N
56	235	5	2	19841	\N	19841	\N	\N	6	1	2	f	0	234	\N
57	12	5	2	6675	\N	6675	\N	\N	7	1	2	f	0	234	\N
58	265	5	2	1892	\N	1892	\N	\N	8	1	2	f	0	\N	\N
59	77	5	2	1108	\N	1108	\N	\N	9	1	2	f	0	234	\N
60	142	5	2	595	\N	595	\N	\N	10	1	2	f	0	234	\N
61	73	5	2	494	\N	494	\N	\N	11	1	2	f	0	234	\N
62	35	5	2	283	\N	283	\N	\N	12	1	2	f	0	234	\N
63	21	5	2	259	\N	259	\N	\N	13	1	2	f	0	234	\N
64	2	5	2	201	\N	201	\N	\N	14	1	2	f	0	234	\N
65	93	5	2	196	\N	196	\N	\N	15	1	2	f	0	234	\N
66	3	5	2	188	\N	188	\N	\N	16	1	2	f	0	234	\N
67	82	5	2	107	\N	107	\N	\N	17	1	2	f	0	\N	\N
68	34	5	2	93	\N	93	\N	\N	18	1	2	f	0	\N	\N
69	6	5	2	83	\N	83	\N	\N	19	1	2	f	0	234	\N
70	163	5	2	79	\N	79	\N	\N	20	1	2	f	0	234	\N
71	68	5	2	67	\N	67	\N	\N	21	1	2	f	0	234	\N
72	250	5	2	65	\N	65	\N	\N	22	1	2	f	0	234	\N
73	168	5	2	65	\N	65	\N	\N	23	1	2	f	0	234	\N
74	57	5	2	65	\N	65	\N	\N	24	1	2	f	0	234	\N
75	213	5	2	64	\N	64	\N	\N	25	1	2	f	0	234	\N
76	100	5	2	57	\N	57	\N	\N	26	1	2	f	0	234	\N
77	198	5	2	48	\N	48	\N	\N	27	1	2	f	0	234	\N
78	78	5	2	47	\N	47	\N	\N	28	1	2	f	0	234	\N
79	15	5	2	45	\N	45	\N	\N	29	1	2	f	0	234	\N
80	1	5	2	42	\N	42	\N	\N	30	1	2	f	0	234	\N
81	41	5	2	42	\N	42	\N	\N	31	1	2	f	0	234	\N
82	22	5	2	37	\N	37	\N	\N	32	1	2	f	0	234	\N
83	128	5	2	33	\N	33	\N	\N	33	1	2	f	0	234	\N
84	130	5	2	32	\N	32	\N	\N	34	1	2	f	0	234	\N
85	216	5	2	29	\N	29	\N	\N	35	1	2	f	0	234	\N
86	33	5	2	29	\N	29	\N	\N	36	1	2	f	0	234	\N
87	179	5	2	27	\N	27	\N	\N	37	1	2	f	0	234	\N
88	206	5	2	23	\N	23	\N	\N	38	1	2	f	0	234	\N
89	120	5	2	21	\N	21	\N	\N	39	1	2	f	0	234	\N
90	17	5	2	21	\N	21	\N	\N	40	1	2	f	0	234	\N
91	4	5	2	21	\N	21	\N	\N	41	1	2	f	0	234	\N
92	136	5	2	20	\N	20	\N	\N	42	1	2	f	0	234	\N
93	40	5	2	18	\N	18	\N	\N	43	1	2	f	0	234	\N
94	236	5	2	17	\N	17	\N	\N	44	1	2	f	0	234	\N
95	30	5	2	16	\N	16	\N	\N	45	1	2	f	0	234	\N
96	25	5	2	16	\N	16	\N	\N	46	1	2	f	0	234	\N
97	191	5	2	16	\N	16	\N	\N	47	1	2	f	0	234	\N
98	251	5	2	15	\N	15	\N	\N	48	1	2	f	0	234	\N
99	238	5	2	14	\N	14	\N	\N	49	1	2	f	0	234	\N
100	31	5	2	13	\N	13	\N	\N	50	1	2	f	0	234	\N
101	48	5	2	13	\N	13	\N	\N	51	1	2	f	0	234	\N
102	5	5	2	11	\N	11	\N	\N	52	1	2	f	0	234	\N
103	50	5	2	11	\N	11	\N	\N	53	1	2	f	0	234	\N
104	199	5	2	11	\N	11	\N	\N	54	1	2	f	0	234	\N
105	205	5	2	10	\N	10	\N	\N	55	1	2	f	0	234	\N
106	153	5	2	10	\N	10	\N	\N	56	1	2	f	0	234	\N
107	69	5	2	10	\N	10	\N	\N	57	1	2	f	0	234	\N
108	106	5	2	9	\N	9	\N	\N	58	1	2	f	0	234	\N
109	97	5	2	9	\N	9	\N	\N	59	1	2	f	0	234	\N
110	225	5	2	8	\N	8	\N	\N	60	1	2	f	0	234	\N
111	247	5	2	7	\N	7	\N	\N	61	1	2	f	0	234	\N
112	195	5	2	6	\N	6	\N	\N	62	1	2	f	0	234	\N
113	233	5	2	6	\N	6	\N	\N	63	1	2	f	0	234	\N
114	154	5	2	5	\N	5	\N	\N	64	1	2	f	0	234	\N
115	81	5	2	5	\N	5	\N	\N	65	1	2	f	0	234	\N
116	111	5	2	4	\N	4	\N	\N	66	1	2	f	0	234	\N
117	7	5	2	4	\N	4	\N	\N	67	1	2	f	0	234	\N
118	208	5	2	4	\N	4	\N	\N	68	1	2	f	0	234	\N
119	261	5	2	3	\N	3	\N	\N	69	1	2	f	0	234	\N
120	20	5	2	3	\N	3	\N	\N	70	1	2	f	0	234	\N
121	91	5	2	3	\N	3	\N	\N	71	1	2	f	0	234	\N
122	254	5	2	3	\N	3	\N	\N	72	1	2	f	0	234	\N
123	180	5	2	2	\N	2	\N	\N	73	1	2	f	0	234	\N
124	207	5	2	2	\N	2	\N	\N	74	1	2	f	0	234	\N
125	9	5	2	2	\N	2	\N	\N	75	1	2	f	0	234	\N
126	18	5	2	2	\N	2	\N	\N	76	1	2	f	0	234	\N
127	45	5	2	2	\N	2	\N	\N	77	1	2	f	0	234	\N
128	47	5	2	2	\N	2	\N	\N	78	1	2	f	0	234	\N
129	129	5	2	1	\N	1	\N	\N	79	1	2	f	0	234	\N
130	252	5	2	1	\N	1	\N	\N	80	1	2	f	0	234	\N
131	249	5	2	1	\N	1	\N	\N	81	1	2	f	0	234	\N
132	88	5	2	1	\N	1	\N	\N	82	1	2	f	0	234	\N
133	42	5	2	1	\N	1	\N	\N	83	1	2	f	0	234	\N
134	44	5	2	1	\N	1	\N	\N	84	1	2	f	0	234	\N
135	169	5	2	1	\N	1	\N	\N	85	1	2	f	0	234	\N
136	103	5	2	1	\N	1	\N	\N	86	1	2	f	0	234	\N
137	49	5	2	1	\N	1	\N	\N	87	1	2	f	0	234	\N
138	107	5	2	1	\N	1	\N	\N	88	1	2	f	0	234	\N
139	200	5	2	1	\N	1	\N	\N	89	1	2	f	0	234	\N
140	36	5	2	1	\N	1	\N	\N	90	1	2	f	0	234	\N
141	228	5	2	1	\N	1	\N	\N	91	1	2	f	0	234	\N
142	157	5	2	1	\N	1	\N	\N	92	1	2	f	0	234	\N
143	80	5	2	1	\N	1	\N	\N	93	1	2	f	0	234	\N
144	98	5	2	1	\N	1	\N	\N	94	1	2	f	0	234	\N
145	197	5	2	1	\N	1	\N	\N	95	1	2	f	0	234	\N
146	109	5	2	1	\N	1	\N	\N	96	1	2	f	0	234	\N
147	146	5	2	1	\N	1	\N	\N	97	1	2	f	0	234	\N
148	185	5	2	1	\N	1	\N	\N	98	1	2	f	0	234	\N
149	16	5	2	1	\N	1	\N	\N	99	1	2	f	0	234	\N
150	172	5	2	1	\N	1	\N	\N	100	1	2	f	0	234	\N
151	39	5	2	1	\N	1	\N	\N	101	1	2	f	0	234	\N
152	175	5	2	1	\N	1	\N	\N	102	1	2	f	0	234	\N
153	159	5	2	1	\N	1	\N	\N	103	1	2	f	0	234	\N
154	234	5	1	221535	\N	221535	\N	\N	1	1	2	f	\N	\N	\N
155	231	6	2	27978	\N	27978	\N	\N	1	1	2	f	0	56	\N
156	56	6	1	27978	\N	27978	\N	\N	1	1	2	f	\N	231	\N
157	231	7	2	6074	\N	6074	\N	\N	1	1	2	f	0	\N	\N
158	127	7	1	2158	\N	2158	\N	\N	1	1	2	f	\N	231	\N
159	126	7	1	2140	\N	2140	\N	\N	2	1	2	f	\N	231	\N
160	150	7	1	670	\N	670	\N	\N	3	1	2	f	\N	231	\N
161	149	7	1	505	\N	505	\N	\N	4	1	2	f	\N	231	\N
162	124	7	1	230	\N	230	\N	\N	5	1	2	f	\N	231	\N
163	125	7	1	212	\N	212	\N	\N	6	1	2	f	\N	231	\N
164	152	7	1	80	\N	80	\N	\N	7	1	2	f	\N	231	\N
165	151	7	1	79	\N	79	\N	\N	8	1	2	f	\N	231	\N
166	105	8	2	92758	\N	0	\N	\N	1	1	2	f	92758	\N	\N
167	231	9	2	23837	\N	23837	\N	\N	1	1	2	f	0	46	\N
168	19	9	2	260	\N	260	\N	\N	2	1	2	f	0	46	\N
169	46	9	1	24097	\N	24097	\N	\N	1	1	2	f	\N	\N	\N
170	112	9	1	159	\N	159	\N	\N	0	1	2	f	\N	\N	\N
171	177	9	1	28	\N	28	\N	\N	0	1	2	f	\N	231	\N
172	46	10	2	4564	\N	4564	\N	\N	1	1	2	f	0	170	\N
173	177	10	2	21	\N	21	\N	\N	0	1	2	f	0	170	\N
174	170	10	1	4564	\N	4564	\N	\N	1	1	2	f	\N	46	\N
175	234	11	2	62352	\N	0	\N	\N	1	1	2	f	62352	\N	\N
176	182	12	2	123197	\N	0	\N	\N	1	1	2	f	123197	\N	\N
177	231	13	2	24545	\N	24545	\N	\N	1	1	2	f	0	\N	\N
178	19	13	2	17797	\N	17797	\N	\N	2	1	2	f	0	\N	\N
179	230	13	1	41657	\N	41657	\N	\N	1	1	2	f	\N	\N	\N
180	232	14	2	40849	\N	40849	\N	\N	1	1	2	f	0	46	\N
181	267	14	2	26092	\N	26092	\N	\N	2	1	2	f	0	46	\N
182	230	14	2	23483	\N	23483	\N	\N	3	1	2	f	0	46	\N
183	119	14	2	23190	\N	23190	\N	\N	4	1	2	f	0	46	\N
184	235	14	2	13784	\N	13784	\N	\N	5	1	2	f	0	46	\N
185	95	14	2	8504	\N	8504	\N	\N	6	1	2	f	0	46	\N
186	77	14	2	1235	\N	1235	\N	\N	7	1	2	f	0	46	\N
187	28	14	2	497	\N	497	\N	\N	8	1	2	f	0	\N	\N
188	73	14	2	494	\N	494	\N	\N	9	1	2	f	0	46	\N
189	46	14	1	138088	\N	138088	\N	\N	1	1	2	f	\N	\N	\N
190	177	14	1	4315	\N	4315	\N	\N	0	1	2	f	\N	\N	\N
191	112	14	1	4240	\N	4240	\N	\N	0	1	2	f	\N	\N	\N
192	231	15	2	27978	\N	0	\N	\N	1	1	2	f	27978	\N	\N
193	99	15	2	24	\N	0	\N	\N	2	1	2	f	24	\N	\N
194	123	16	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
195	102	16	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
196	8	16	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
197	196	16	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
198	27	17	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
199	231	18	2	1260	\N	1260	\N	\N	1	1	2	f	0	77	\N
200	77	18	1	1260	\N	1260	\N	\N	1	1	2	f	\N	231	\N
201	231	19	2	178587	\N	178587	\N	\N	1	1	2	f	0	\N	\N
202	19	19	2	146134	\N	146134	\N	\N	2	1	2	f	0	\N	\N
203	227	19	1	49994	\N	49994	\N	\N	1	1	2	f	\N	\N	\N
204	61	19	1	35208	\N	35208	\N	\N	2	1	2	f	\N	\N	\N
205	63	19	1	35202	\N	35202	\N	\N	3	1	2	f	\N	\N	\N
206	209	19	1	25509	\N	25509	\N	\N	4	1	2	f	\N	231	\N
207	211	19	1	25493	\N	25493	\N	\N	5	1	2	f	\N	\N	\N
208	259	19	1	20495	\N	20495	\N	\N	6	1	2	f	\N	\N	\N
209	117	19	1	16629	\N	16629	\N	\N	7	1	2	f	\N	\N	\N
210	118	19	1	13586	\N	13586	\N	\N	8	1	2	f	\N	\N	\N
211	187	19	1	13571	\N	13571	\N	\N	9	1	2	f	\N	231	\N
212	248	19	1	12392	\N	12392	\N	\N	10	1	2	f	\N	\N	\N
213	167	19	1	9052	\N	9052	\N	\N	11	1	2	f	\N	\N	\N
214	257	19	1	8530	\N	8530	\N	\N	12	1	2	f	\N	\N	\N
215	260	19	1	5821	\N	5821	\N	\N	13	1	2	f	\N	231	\N
216	89	19	1	5618	\N	5618	\N	\N	14	1	2	f	\N	\N	\N
217	258	19	1	5182	\N	5182	\N	\N	15	1	2	f	\N	\N	\N
218	114	19	1	4462	\N	4462	\N	\N	16	1	2	f	\N	\N	\N
219	74	19	1	4118	\N	4118	\N	\N	17	1	2	f	\N	231	\N
220	263	19	1	4074	\N	4074	\N	\N	18	1	2	f	\N	231	\N
221	70	19	1	3928	\N	3928	\N	\N	19	1	2	f	\N	231	\N
222	65	19	1	3868	\N	3868	\N	\N	20	1	2	f	\N	231	\N
223	222	19	1	2844	\N	2844	\N	\N	21	1	2	f	\N	231	\N
224	240	19	1	1873	\N	1873	\N	\N	22	1	2	f	\N	231	\N
225	121	19	1	1789	\N	1789	\N	\N	23	1	2	f	\N	231	\N
226	85	19	1	1708	\N	1708	\N	\N	24	1	2	f	\N	231	\N
227	122	19	1	1587	\N	1587	\N	\N	25	1	2	f	\N	231	\N
228	62	19	1	1383	\N	1383	\N	\N	26	1	2	f	\N	231	\N
229	226	19	1	1025	\N	1025	\N	\N	27	1	2	f	\N	\N	\N
230	59	19	1	968	\N	968	\N	\N	28	1	2	f	\N	231	\N
231	262	19	1	903	\N	903	\N	\N	29	1	2	f	\N	231	\N
232	138	19	1	752	\N	752	\N	\N	30	1	2	f	\N	231	\N
233	139	19	1	751	\N	751	\N	\N	31	1	2	f	\N	231	\N
234	87	19	1	653	\N	653	\N	\N	32	1	2	f	\N	231	\N
235	237	19	1	598	\N	598	\N	\N	33	1	2	f	\N	\N	\N
236	75	19	1	597	\N	597	\N	\N	34	1	2	f	\N	231	\N
237	166	19	1	597	\N	597	\N	\N	35	1	2	f	\N	\N	\N
238	264	19	1	460	\N	460	\N	\N	36	1	2	f	\N	231	\N
239	266	19	1	460	\N	460	\N	\N	37	1	2	f	\N	231	\N
240	214	19	1	411	\N	411	\N	\N	38	1	2	f	\N	231	\N
241	246	19	1	392	\N	392	\N	\N	39	1	2	f	\N	231	\N
242	86	19	1	306	\N	306	\N	\N	40	1	2	f	\N	231	\N
243	188	19	1	269	\N	269	\N	\N	41	1	2	f	\N	231	\N
244	210	19	1	267	\N	267	\N	\N	42	1	2	f	\N	231	\N
245	217	19	1	230	\N	230	\N	\N	43	1	2	f	\N	231	\N
246	162	19	1	166	\N	166	\N	\N	44	1	2	f	\N	231	\N
247	173	19	1	161	\N	161	\N	\N	45	1	2	f	\N	231	\N
248	155	19	1	135	\N	135	\N	\N	46	1	2	f	\N	231	\N
249	224	19	1	127	\N	127	\N	\N	47	1	2	f	\N	231	\N
250	176	19	1	108	\N	108	\N	\N	48	1	2	f	\N	\N	\N
251	115	19	1	78	\N	78	\N	\N	49	1	2	f	\N	\N	\N
252	255	19	1	78	\N	78	\N	\N	50	1	2	f	\N	231	\N
253	215	19	1	48	\N	48	\N	\N	51	1	2	f	\N	231	\N
254	164	19	1	47	\N	47	\N	\N	52	1	2	f	\N	231	\N
255	156	19	1	47	\N	47	\N	\N	53	1	2	f	\N	231	\N
256	171	19	1	28	\N	28	\N	\N	54	1	2	f	\N	231	\N
257	84	19	1	26	\N	26	\N	\N	55	1	2	f	\N	231	\N
258	202	19	1	17	\N	17	\N	\N	56	1	2	f	\N	231	\N
259	53	19	1	17	\N	17	\N	\N	57	1	2	f	\N	231	\N
260	256	19	1	16	\N	16	\N	\N	58	1	2	f	\N	231	\N
261	71	19	1	16	\N	16	\N	\N	59	1	2	f	\N	231	\N
262	72	19	1	16	\N	16	\N	\N	60	1	2	f	\N	231	\N
263	244	19	1	14	\N	14	\N	\N	61	1	2	f	\N	231	\N
264	220	19	1	7	\N	7	\N	\N	62	1	2	f	\N	231	\N
265	241	19	1	7	\N	7	\N	\N	63	1	2	f	\N	231	\N
266	94	19	1	4	\N	4	\N	\N	64	1	2	f	\N	231	\N
267	242	19	1	4	\N	4	\N	\N	65	1	2	f	\N	231	\N
268	221	19	1	4	\N	4	\N	\N	66	1	2	f	\N	231	\N
269	55	19	1	2	\N	2	\N	\N	67	1	2	f	\N	231	\N
270	66	19	1	2	\N	2	\N	\N	68	1	2	f	\N	231	\N
271	145	19	1	2	\N	2	\N	\N	69	1	2	f	\N	231	\N
272	137	19	1	2	\N	2	\N	\N	70	1	2	f	\N	231	\N
273	158	19	1	1	\N	1	\N	\N	71	1	2	f	\N	231	\N
274	67	19	1	1	\N	1	\N	\N	72	1	2	f	\N	231	\N
275	102	20	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
276	8	20	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
277	196	20	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
278	10	20	1	2	\N	2	\N	\N	1	1	2	f	\N	196	\N
279	147	20	1	1	\N	1	\N	\N	2	1	2	f	\N	196	\N
280	267	21	2	4054	\N	4054	\N	\N	1	1	2	f	0	27	\N
281	232	21	2	456	\N	456	\N	\N	2	1	2	f	0	27	\N
282	27	21	1	4510	\N	4510	\N	\N	1	1	2	f	\N	\N	\N
283	131	22	2	122	\N	0	\N	\N	0	1	2	f	122	\N	\N
284	231	23	2	19563	\N	0	\N	\N	1	1	2	f	19563	\N	\N
285	19	23	2	14922	\N	0	\N	\N	2	1	2	f	14922	\N	\N
286	161	24	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
287	19	25	2	47246	\N	47246	\N	\N	1	1	2	f	0	105	\N
288	231	25	2	27978	\N	27978	\N	\N	2	1	2	f	0	105	\N
289	105	25	1	75224	\N	75224	\N	\N	1	1	2	f	\N	\N	\N
290	10	26	2	2	\N	2	\N	\N	1	1	2	f	0	10	\N
291	102	26	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
292	147	26	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
293	131	26	2	2	\N	2	\N	\N	0	1	2	f	0	10	\N
294	8	26	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
295	196	26	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
296	10	26	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
297	182	27	2	395958	\N	395958	\N	\N	1	1	2	f	0	\N	\N
298	95	27	1	98786	\N	98786	\N	\N	1	1	2	f	\N	182	\N
299	46	27	1	93811	\N	93811	\N	\N	2	1	2	f	\N	182	\N
300	13	27	1	81981	\N	81981	\N	\N	3	1	2	f	\N	182	\N
301	253	27	1	36708	\N	36708	\N	\N	4	1	2	f	\N	182	\N
302	28	27	1	36012	\N	36012	\N	\N	5	1	2	f	\N	182	\N
303	234	27	1	18902	\N	18902	\N	\N	6	1	2	f	\N	182	\N
304	235	27	1	12045	\N	12045	\N	\N	7	1	2	f	\N	182	\N
305	12	27	1	7255	\N	7255	\N	\N	8	1	2	f	\N	182	\N
306	267	27	1	7085	\N	7085	\N	\N	9	1	2	f	\N	182	\N
307	232	27	1	2470	\N	2470	\N	\N	10	1	2	f	\N	182	\N
308	27	27	1	68	\N	68	\N	\N	11	1	2	f	\N	182	\N
309	177	27	1	4548	\N	4548	\N	\N	0	1	2	f	\N	182	\N
310	112	27	1	2086	\N	2086	\N	\N	0	1	2	f	\N	182	\N
311	161	28	2	1	\N	1	\N	\N	1	1	2	f	0	102	\N
312	102	28	1	1	\N	1	\N	\N	1	1	2	f	\N	161	\N
313	8	28	1	1	\N	1	\N	\N	0	1	2	f	\N	161	\N
314	196	28	1	1	\N	1	\N	\N	0	1	2	f	\N	161	\N
315	131	29	2	119	\N	0	\N	\N	0	1	2	f	119	\N	\N
316	231	30	2	18469	\N	0	\N	\N	1	1	2	f	18469	\N	\N
317	46	31	2	17061	\N	0	\N	\N	1	1	2	f	17061	\N	\N
318	253	31	2	945	\N	0	\N	\N	2	1	2	f	945	\N	\N
319	95	31	2	79	\N	0	\N	\N	3	1	2	f	79	\N	\N
320	27	31	2	2	\N	0	\N	\N	4	1	2	f	2	\N	\N
321	112	31	2	196	\N	0	\N	\N	0	1	2	f	196	\N	\N
322	177	31	2	83	\N	0	\N	\N	0	1	2	f	83	\N	\N
323	131	31	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
324	231	32	2	27691	\N	27691	\N	\N	1	1	2	f	0	12	\N
325	12	32	1	27691	\N	27691	\N	\N	1	1	2	f	\N	231	\N
326	232	32	1	8	\N	8	\N	\N	0	1	2	f	\N	231	\N
327	267	32	1	4	\N	4	\N	\N	0	1	2	f	\N	231	\N
328	234	33	2	61354	\N	61354	\N	\N	1	1	2	f	0	234	\N
329	46	33	2	9475	\N	9475	\N	\N	2	1	2	f	0	46	\N
330	13	33	2	2130	\N	2130	\N	\N	3	1	2	f	0	13	\N
331	148	33	2	1214	\N	1214	\N	\N	4	1	2	f	0	148	\N
332	28	33	2	542	\N	542	\N	\N	5	1	2	f	0	28	\N
333	112	33	2	196	\N	196	\N	\N	0	1	2	f	0	46	\N
334	177	33	2	46	\N	46	\N	\N	0	1	2	f	0	46	\N
335	234	33	1	61354	\N	61354	\N	\N	1	1	2	f	\N	234	\N
336	46	33	1	9475	\N	9475	\N	\N	2	1	2	f	\N	46	\N
337	13	33	1	2130	\N	2130	\N	\N	3	1	2	f	\N	13	\N
338	148	33	1	1214	\N	1214	\N	\N	4	1	2	f	\N	148	\N
339	28	33	1	542	\N	542	\N	\N	5	1	2	f	\N	28	\N
340	112	33	1	937	\N	937	\N	\N	0	1	2	f	\N	46	\N
341	177	33	1	720	\N	720	\N	\N	0	1	2	f	\N	46	\N
342	123	34	2	28	\N	28	\N	\N	1	1	2	f	0	\N	\N
343	102	34	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
344	8	34	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
345	196	34	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
346	10	34	1	18	\N	18	\N	\N	1	1	2	f	\N	\N	\N
347	147	34	1	13	\N	13	\N	\N	2	1	2	f	\N	\N	\N
348	102	35	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
349	8	35	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
350	196	35	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
351	102	36	2	14	\N	14	\N	\N	1	1	2	f	0	229	\N
352	8	36	2	14	\N	14	\N	\N	0	1	2	f	0	229	\N
353	196	36	2	14	\N	14	\N	\N	0	1	2	f	0	229	\N
354	229	36	1	14	\N	14	\N	\N	1	1	2	f	\N	196	\N
355	96	37	2	21034	\N	0	\N	\N	1	1	2	f	21034	\N	\N
356	46	38	2	742	\N	742	\N	\N	1	1	2	f	0	\N	\N
357	27	38	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
358	177	38	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
359	108	39	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
360	46	40	2	584	\N	584	\N	\N	1	1	2	f	0	\N	\N
361	99	40	2	24	\N	24	\N	\N	2	1	2	f	0	231	\N
362	177	40	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
363	231	40	1	24	\N	24	\N	\N	1	1	2	f	\N	99	\N
364	230	41	2	42810	\N	0	\N	\N	1	1	2	f	42810	\N	\N
365	119	41	2	24939	\N	0	\N	\N	2	1	2	f	24939	\N	\N
366	77	41	2	1260	\N	0	\N	\N	3	1	2	f	1260	\N	\N
367	73	41	2	495	\N	0	\N	\N	4	1	2	f	495	\N	\N
368	27	41	2	8	\N	0	\N	\N	5	1	2	f	8	\N	\N
369	19	42	2	57590	\N	57590	\N	\N	1	1	2	f	0	231	\N
370	231	42	2	544	\N	544	\N	\N	2	1	2	f	0	231	\N
371	231	42	1	58148	\N	58148	\N	\N	1	1	2	f	\N	\N	\N
372	231	43	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
373	19	43	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
374	231	44	2	27978	\N	0	\N	\N	1	1	2	f	27978	\N	\N
375	232	45	2	45234	\N	45234	\N	\N	1	1	2	f	0	95	\N
376	231	45	2	24861	\N	24861	\N	\N	2	1	2	f	0	95	\N
377	19	45	2	18178	\N	18178	\N	\N	3	1	2	f	0	95	\N
378	235	45	2	16155	\N	16155	\N	\N	4	1	2	f	0	95	\N
379	267	45	2	6676	\N	6676	\N	\N	5	1	2	f	0	95	\N
380	3	45	2	188	\N	188	\N	\N	6	1	2	f	0	95	\N
381	29	45	2	60	\N	60	\N	\N	7	1	2	f	0	95	\N
382	95	45	1	111261	\N	111261	\N	\N	1	1	2	f	\N	\N	\N
383	231	46	2	104509	\N	104509	\N	\N	1	1	2	f	0	148	\N
384	148	46	1	104718	\N	104718	\N	\N	1	1	2	f	\N	\N	\N
385	161	47	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
386	231	48	2	23801	\N	23801	\N	\N	1	1	2	f	0	112	\N
387	19	48	2	260	\N	260	\N	\N	2	1	2	f	0	112	\N
388	112	48	1	24061	\N	24061	\N	\N	1	1	2	f	\N	\N	\N
389	46	48	1	24061	\N	24061	\N	\N	0	1	2	f	\N	\N	\N
390	231	49	2	23690	\N	23690	\N	\N	1	1	2	f	0	234	\N
391	19	49	2	51	\N	51	\N	\N	2	1	2	f	0	234	\N
392	234	49	1	23742	\N	23742	\N	\N	1	1	2	f	\N	\N	\N
393	46	50	2	4564	\N	0	\N	\N	1	1	2	f	4564	\N	\N
394	99	50	2	24	\N	0	\N	\N	2	1	2	f	24	\N	\N
395	204	50	2	5	\N	0	\N	\N	3	1	2	f	5	\N	\N
396	243	50	2	2	\N	0	\N	\N	4	1	2	f	2	\N	\N
397	108	50	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
398	131	50	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
399	177	50	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
400	123	51	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
401	102	51	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
402	8	51	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
403	196	51	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
404	231	52	2	290	\N	0	\N	\N	1	1	2	f	290	\N	\N
405	19	52	2	20	\N	0	\N	\N	2	1	2	f	20	\N	\N
406	19	53	2	46429	\N	46429	\N	\N	1	1	2	f	0	243	\N
407	231	53	2	27978	\N	27978	\N	\N	2	1	2	f	0	243	\N
408	116	53	2	10	\N	10	\N	\N	3	1	2	f	0	243	\N
409	223	53	2	8	\N	8	\N	\N	4	1	2	f	0	243	\N
410	237	53	2	8	\N	8	\N	\N	5	1	2	f	0	243	\N
411	183	53	2	6	\N	6	\N	\N	6	1	2	f	0	243	\N
412	113	53	2	6	\N	6	\N	\N	7	1	2	f	0	243	\N
413	262	53	2	5	\N	5	\N	\N	8	1	2	f	0	243	\N
414	211	53	2	5	\N	5	\N	\N	9	1	2	f	0	243	\N
415	209	53	2	5	\N	5	\N	\N	10	1	2	f	0	243	\N
416	52	53	2	4	\N	4	\N	\N	11	1	2	f	0	243	\N
417	201	53	2	4	\N	4	\N	\N	12	1	2	f	0	243	\N
418	224	53	2	4	\N	4	\N	\N	13	1	2	f	0	243	\N
419	240	53	2	4	\N	4	\N	\N	14	1	2	f	0	243	\N
420	263	53	2	4	\N	4	\N	\N	15	1	2	f	0	243	\N
421	258	53	2	4	\N	4	\N	\N	16	1	2	f	0	243	\N
422	257	53	2	4	\N	4	\N	\N	17	1	2	f	0	243	\N
423	248	53	2	4	\N	4	\N	\N	18	1	2	f	0	243	\N
424	259	53	2	4	\N	4	\N	\N	19	1	2	f	0	243	\N
425	218	53	2	3	\N	3	\N	\N	20	1	2	f	0	243	\N
426	194	53	2	3	\N	3	\N	\N	21	1	2	f	0	243	\N
427	174	53	2	3	\N	3	\N	\N	22	1	2	f	0	243	\N
428	256	53	2	3	\N	3	\N	\N	23	1	2	f	0	243	\N
429	173	53	2	3	\N	3	\N	\N	24	1	2	f	0	243	\N
430	188	53	2	3	\N	3	\N	\N	25	1	2	f	0	243	\N
431	226	53	2	3	\N	3	\N	\N	26	1	2	f	0	243	\N
432	187	53	2	3	\N	3	\N	\N	27	1	2	f	0	243	\N
433	227	53	2	3	\N	3	\N	\N	28	1	2	f	0	243	\N
434	64	53	2	2	\N	2	\N	\N	29	1	2	f	0	243	\N
435	54	53	2	2	\N	2	\N	\N	30	1	2	f	0	243	\N
436	92	53	2	2	\N	2	\N	\N	31	1	2	f	0	243	\N
437	90	53	2	2	\N	2	\N	\N	32	1	2	f	0	243	\N
438	190	53	2	2	\N	2	\N	\N	33	1	2	f	0	243	\N
439	60	53	2	2	\N	2	\N	\N	34	1	2	f	0	243	\N
440	134	53	2	2	\N	2	\N	\N	35	1	2	f	0	243	\N
441	144	53	2	2	\N	2	\N	\N	36	1	2	f	0	243	\N
442	165	53	2	2	\N	2	\N	\N	37	1	2	f	0	243	\N
443	193	53	2	2	\N	2	\N	\N	38	1	2	f	0	243	\N
444	186	53	2	2	\N	2	\N	\N	39	1	2	f	0	243	\N
445	160	53	2	2	\N	2	\N	\N	40	1	2	f	0	243	\N
446	133	53	2	2	\N	2	\N	\N	41	1	2	f	0	243	\N
447	143	53	2	2	\N	2	\N	\N	42	1	2	f	0	243	\N
448	239	53	2	2	\N	2	\N	\N	43	1	2	f	0	243	\N
449	212	53	2	2	\N	2	\N	\N	44	1	2	f	0	243	\N
450	192	53	2	2	\N	2	\N	\N	45	1	2	f	0	243	\N
451	184	53	2	2	\N	2	\N	\N	46	1	2	f	0	243	\N
452	132	53	2	2	\N	2	\N	\N	47	1	2	f	0	243	\N
453	135	53	2	2	\N	2	\N	\N	48	1	2	f	0	243	\N
454	67	53	2	2	\N	2	\N	\N	49	1	2	f	0	243	\N
455	137	53	2	2	\N	2	\N	\N	50	1	2	f	0	243	\N
456	215	53	2	2	\N	2	\N	\N	51	1	2	f	0	243	\N
457	176	53	2	2	\N	2	\N	\N	52	1	2	f	0	243	\N
458	155	53	2	2	\N	2	\N	\N	53	1	2	f	0	243	\N
459	162	53	2	2	\N	2	\N	\N	54	1	2	f	0	243	\N
460	217	53	2	2	\N	2	\N	\N	55	1	2	f	0	243	\N
461	246	53	2	2	\N	2	\N	\N	56	1	2	f	0	243	\N
462	264	53	2	2	\N	2	\N	\N	57	1	2	f	0	243	\N
463	214	53	2	2	\N	2	\N	\N	58	1	2	f	0	243	\N
464	75	53	2	2	\N	2	\N	\N	59	1	2	f	0	243	\N
465	166	53	2	2	\N	2	\N	\N	60	1	2	f	0	243	\N
466	87	53	2	2	\N	2	\N	\N	61	1	2	f	0	243	\N
467	139	53	2	2	\N	2	\N	\N	62	1	2	f	0	243	\N
468	122	53	2	2	\N	2	\N	\N	63	1	2	f	0	243	\N
469	121	53	2	2	\N	2	\N	\N	64	1	2	f	0	243	\N
470	222	53	2	2	\N	2	\N	\N	65	1	2	f	0	243	\N
471	65	53	2	2	\N	2	\N	\N	66	1	2	f	0	243	\N
472	70	53	2	2	\N	2	\N	\N	67	1	2	f	0	243	\N
473	74	53	2	2	\N	2	\N	\N	68	1	2	f	0	243	\N
474	167	53	2	2	\N	2	\N	\N	69	1	2	f	0	243	\N
475	118	53	2	2	\N	2	\N	\N	70	1	2	f	0	243	\N
476	117	53	2	2	\N	2	\N	\N	71	1	2	f	0	243	\N
477	189	53	2	1	\N	1	\N	\N	72	1	2	f	0	243	\N
478	219	53	2	1	\N	1	\N	\N	73	1	2	f	0	243	\N
479	140	53	2	1	\N	1	\N	\N	74	1	2	f	0	243	\N
480	220	53	2	1	\N	1	\N	\N	75	1	2	f	0	243	\N
481	221	53	2	1	\N	1	\N	\N	76	1	2	f	0	243	\N
482	202	53	2	1	\N	1	\N	\N	77	1	2	f	0	243	\N
483	71	53	2	1	\N	1	\N	\N	78	1	2	f	0	243	\N
484	72	53	2	1	\N	1	\N	\N	79	1	2	f	0	243	\N
485	164	53	2	1	\N	1	\N	\N	80	1	2	f	0	243	\N
486	156	53	2	1	\N	1	\N	\N	81	1	2	f	0	243	\N
487	210	53	2	1	\N	1	\N	\N	82	1	2	f	0	243	\N
488	62	53	2	1	\N	1	\N	\N	83	1	2	f	0	243	\N
489	89	53	2	1	\N	1	\N	\N	84	1	2	f	0	243	\N
490	61	53	2	1	\N	1	\N	\N	85	1	2	f	0	243	\N
491	63	53	2	1	\N	1	\N	\N	86	1	2	f	0	243	\N
492	131	53	2	106	\N	106	\N	\N	0	1	2	f	0	243	\N
493	243	53	1	74733	\N	74733	\N	\N	1	1	2	f	\N	\N	\N
494	123	54	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
495	10	54	1	1	\N	1	\N	\N	1	1	2	f	\N	123	\N
496	253	54	1	1	\N	1	\N	\N	2	1	2	f	\N	123	\N
497	28	54	1	1	\N	1	\N	\N	3	1	2	f	\N	123	\N
498	148	54	1	1	\N	1	\N	\N	4	1	2	f	\N	123	\N
499	46	54	1	1	\N	1	\N	\N	5	1	2	f	\N	123	\N
500	95	54	1	1	\N	1	\N	\N	6	1	2	f	\N	123	\N
501	119	54	1	1	\N	1	\N	\N	7	1	2	f	\N	123	\N
502	231	54	1	1	\N	1	\N	\N	8	1	2	f	\N	123	\N
503	61	54	1	1	\N	1	\N	\N	9	1	2	f	\N	123	\N
504	234	54	1	1	\N	1	\N	\N	10	1	2	f	\N	123	\N
505	105	54	1	1	\N	1	\N	\N	11	1	2	f	\N	123	\N
506	96	55	2	187324	\N	187324	\N	\N	1	1	2	f	0	\N	\N
507	267	55	1	73134	\N	73134	\N	\N	1	1	2	f	\N	96	\N
508	232	55	1	49634	\N	49634	\N	\N	2	1	2	f	\N	96	\N
509	235	55	1	36722	\N	36722	\N	\N	3	1	2	f	\N	96	\N
510	63	55	1	16737	\N	16737	\N	\N	4	1	2	f	\N	96	\N
511	61	55	1	13018	\N	13018	\N	\N	5	1	2	f	\N	96	\N
512	12	55	1	2	\N	2	\N	\N	0	1	2	f	\N	96	\N
513	229	56	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
514	123	56	1	12	\N	12	\N	\N	1	1	2	f	\N	229	\N
515	105	57	2	93050	\N	0	\N	\N	1	1	2	f	93050	\N	\N
516	234	57	2	62575	\N	0	\N	\N	2	1	2	f	62575	\N	\N
517	19	57	2	47246	\N	0	\N	\N	3	1	2	f	47246	\N	\N
518	230	57	2	42815	\N	0	\N	\N	4	1	2	f	42815	\N	\N
519	267	57	2	42053	\N	0	\N	\N	5	1	2	f	42053	\N	\N
520	232	57	2	41761	\N	0	\N	\N	6	1	2	f	41761	\N	\N
521	63	57	2	34606	\N	0	\N	\N	7	1	2	f	34606	\N	\N
522	61	57	2	31275	\N	0	\N	\N	8	1	2	f	31275	\N	\N
523	231	57	2	27978	\N	0	\N	\N	9	1	2	f	27978	\N	\N
524	227	57	2	25073	\N	0	\N	\N	10	1	2	f	25073	\N	\N
525	119	57	2	24944	\N	0	\N	\N	11	1	2	f	24944	\N	\N
526	259	57	2	20493	\N	0	\N	\N	12	1	2	f	20493	\N	\N
527	24	57	2	18825	\N	0	\N	\N	13	1	2	f	18825	\N	\N
528	209	57	2	18075	\N	0	\N	\N	14	1	2	f	18075	\N	\N
529	211	57	2	17683	\N	0	\N	\N	15	1	2	f	17683	\N	\N
530	235	57	2	16987	\N	0	\N	\N	16	1	2	f	16987	\N	\N
531	117	57	2	14700	\N	0	\N	\N	17	1	2	f	14700	\N	\N
532	118	57	2	13583	\N	0	\N	\N	18	1	2	f	13583	\N	\N
533	187	57	2	12978	\N	0	\N	\N	19	1	2	f	12978	\N	\N
534	248	57	2	11468	\N	0	\N	\N	20	1	2	f	11468	\N	\N
535	95	57	2	10914	\N	0	\N	\N	21	1	2	f	10914	\N	\N
536	46	57	2	9332	\N	0	\N	\N	22	1	2	f	9332	\N	\N
537	167	57	2	9052	\N	0	\N	\N	23	1	2	f	9052	\N	\N
538	12	57	2	6677	\N	0	\N	\N	24	1	2	f	6677	\N	\N
539	257	57	2	6443	\N	0	\N	\N	25	1	2	f	6443	\N	\N
540	260	57	2	5820	\N	0	\N	\N	26	1	2	f	5820	\N	\N
541	89	57	2	5618	\N	0	\N	\N	27	1	2	f	5618	\N	\N
542	258	57	2	4779	\N	0	\N	\N	28	1	2	f	4779	\N	\N
543	114	57	2	4462	\N	0	\N	\N	29	1	2	f	4462	\N	\N
544	74	57	2	4088	\N	0	\N	\N	30	1	2	f	4088	\N	\N
545	70	57	2	3927	\N	0	\N	\N	31	1	2	f	3927	\N	\N
546	263	57	2	3775	\N	0	\N	\N	32	1	2	f	3775	\N	\N
547	51	57	2	3660	\N	0	\N	\N	33	1	2	f	3660	\N	\N
548	65	57	2	3503	\N	0	\N	\N	34	1	2	f	3503	\N	\N
549	222	57	2	2844	\N	0	\N	\N	35	1	2	f	2844	\N	\N
550	13	57	2	2141	\N	0	\N	\N	36	1	2	f	2141	\N	\N
551	126	57	2	2085	\N	0	\N	\N	37	1	2	f	2085	\N	\N
552	265	57	2	1892	\N	0	\N	\N	38	1	2	f	1892	\N	\N
553	121	57	2	1711	\N	0	\N	\N	39	1	2	f	1711	\N	\N
554	85	57	2	1707	\N	0	\N	\N	40	1	2	f	1707	\N	\N
555	122	57	2	1585	\N	0	\N	\N	41	1	2	f	1585	\N	\N
556	62	57	2	1381	\N	0	\N	\N	42	1	2	f	1381	\N	\N
557	240	57	2	1313	\N	0	\N	\N	43	1	2	f	1313	\N	\N
558	77	57	2	1260	\N	0	\N	\N	44	1	2	f	1260	\N	\N
559	148	57	2	1217	\N	0	\N	\N	45	1	2	f	1217	\N	\N
560	59	57	2	968	\N	0	\N	\N	46	1	2	f	968	\N	\N
561	139	57	2	751	\N	0	\N	\N	47	1	2	f	751	\N	\N
562	138	57	2	736	\N	0	\N	\N	48	1	2	f	736	\N	\N
563	87	57	2	653	\N	0	\N	\N	49	1	2	f	653	\N	\N
564	150	57	2	637	\N	0	\N	\N	50	1	2	f	637	\N	\N
565	237	57	2	598	\N	0	\N	\N	51	1	2	f	598	\N	\N
566	166	57	2	597	\N	0	\N	\N	52	1	2	f	597	\N	\N
567	142	57	2	595	\N	0	\N	\N	53	1	2	f	595	\N	\N
568	262	57	2	558	\N	0	\N	\N	54	1	2	f	558	\N	\N
569	28	57	2	548	\N	0	\N	\N	55	1	2	f	548	\N	\N
570	75	57	2	529	\N	0	\N	\N	56	1	2	f	529	\N	\N
571	226	57	2	517	\N	0	\N	\N	57	1	2	f	517	\N	\N
572	73	57	2	495	\N	0	\N	\N	58	1	2	f	495	\N	\N
573	253	57	2	494	\N	0	\N	\N	59	1	2	f	494	\N	\N
574	149	57	2	463	\N	0	\N	\N	60	1	2	f	463	\N	\N
575	266	57	2	460	\N	0	\N	\N	61	1	2	f	460	\N	\N
576	127	57	2	407	\N	0	\N	\N	62	1	2	f	407	\N	\N
577	214	57	2	400	\N	0	\N	\N	63	1	2	f	400	\N	\N
578	264	57	2	398	\N	0	\N	\N	64	1	2	f	398	\N	\N
579	246	57	2	338	\N	0	\N	\N	65	1	2	f	338	\N	\N
580	86	57	2	306	\N	0	\N	\N	66	1	2	f	306	\N	\N
581	35	57	2	283	\N	0	\N	\N	67	1	2	f	283	\N	\N
582	188	57	2	269	\N	0	\N	\N	68	1	2	f	269	\N	\N
583	21	57	2	259	\N	0	\N	\N	69	1	2	f	259	\N	\N
584	124	57	2	230	\N	0	\N	\N	70	1	2	f	230	\N	\N
585	217	57	2	230	\N	0	\N	\N	71	1	2	f	230	\N	\N
586	2	57	2	201	\N	0	\N	\N	72	1	2	f	201	\N	\N
587	93	57	2	196	\N	0	\N	\N	73	1	2	f	196	\N	\N
588	3	57	2	188	\N	0	\N	\N	74	1	2	f	188	\N	\N
589	162	57	2	165	\N	0	\N	\N	75	1	2	f	165	\N	\N
590	210	57	2	164	\N	0	\N	\N	76	1	2	f	164	\N	\N
591	173	57	2	158	\N	0	\N	\N	77	1	2	f	158	\N	\N
592	155	57	2	130	\N	0	\N	\N	78	1	2	f	130	\N	\N
593	224	57	2	126	\N	0	\N	\N	79	1	2	f	126	\N	\N
594	176	57	2	108	\N	0	\N	\N	80	1	2	f	108	\N	\N
595	82	57	2	107	\N	0	\N	\N	81	1	2	f	107	\N	\N
596	29	57	2	93	\N	0	\N	\N	82	1	2	f	93	\N	\N
597	34	57	2	93	\N	0	\N	\N	83	1	2	f	93	\N	\N
598	6	57	2	83	\N	0	\N	\N	84	1	2	f	83	\N	\N
599	125	57	2	82	\N	0	\N	\N	85	1	2	f	82	\N	\N
600	163	57	2	79	\N	0	\N	\N	86	1	2	f	79	\N	\N
601	255	57	2	78	\N	0	\N	\N	87	1	2	f	78	\N	\N
602	115	57	2	78	\N	0	\N	\N	88	1	2	f	78	\N	\N
603	151	57	2	75	\N	0	\N	\N	89	1	2	f	75	\N	\N
604	68	57	2	67	\N	0	\N	\N	90	1	2	f	67	\N	\N
605	168	57	2	65	\N	0	\N	\N	91	1	2	f	65	\N	\N
606	57	57	2	65	\N	0	\N	\N	92	1	2	f	65	\N	\N
607	250	57	2	65	\N	0	\N	\N	93	1	2	f	65	\N	\N
608	213	57	2	64	\N	0	\N	\N	94	1	2	f	64	\N	\N
609	100	57	2	57	\N	0	\N	\N	95	1	2	f	57	\N	\N
610	198	57	2	48	\N	0	\N	\N	96	1	2	f	48	\N	\N
611	215	57	2	48	\N	0	\N	\N	97	1	2	f	48	\N	\N
612	78	57	2	47	\N	0	\N	\N	98	1	2	f	47	\N	\N
613	156	57	2	47	\N	0	\N	\N	99	1	2	f	47	\N	\N
614	152	57	2	47	\N	0	\N	\N	100	1	2	f	47	\N	\N
615	164	57	2	46	\N	0	\N	\N	101	1	2	f	46	\N	\N
616	15	57	2	45	\N	0	\N	\N	102	1	2	f	45	\N	\N
617	41	57	2	42	\N	0	\N	\N	103	1	2	f	42	\N	\N
618	1	57	2	42	\N	0	\N	\N	104	1	2	f	42	\N	\N
619	27	57	2	38	\N	0	\N	\N	105	1	2	f	38	\N	\N
620	108	57	2	38	\N	0	\N	\N	106	1	2	f	38	\N	\N
621	22	57	2	37	\N	0	\N	\N	107	1	2	f	37	\N	\N
622	128	57	2	33	\N	0	\N	\N	108	1	2	f	33	\N	\N
623	130	57	2	32	\N	0	\N	\N	109	1	2	f	32	\N	\N
624	33	57	2	29	\N	0	\N	\N	110	1	2	f	29	\N	\N
625	216	57	2	29	\N	0	\N	\N	111	1	2	f	29	\N	\N
626	179	57	2	27	\N	0	\N	\N	112	1	2	f	27	\N	\N
627	171	57	2	27	\N	0	\N	\N	113	1	2	f	27	\N	\N
628	84	57	2	26	\N	0	\N	\N	114	1	2	f	26	\N	\N
629	104	57	2	25	\N	0	\N	\N	115	1	2	f	25	\N	\N
630	206	57	2	23	\N	0	\N	\N	116	1	2	f	23	\N	\N
631	17	57	2	21	\N	0	\N	\N	117	1	2	f	21	\N	\N
632	120	57	2	21	\N	0	\N	\N	118	1	2	f	21	\N	\N
633	4	57	2	21	\N	0	\N	\N	119	1	2	f	21	\N	\N
634	136	57	2	20	\N	0	\N	\N	120	1	2	f	20	\N	\N
635	40	57	2	18	\N	0	\N	\N	121	1	2	f	18	\N	\N
636	236	57	2	17	\N	0	\N	\N	122	1	2	f	17	\N	\N
637	53	57	2	17	\N	0	\N	\N	123	1	2	f	17	\N	\N
638	191	57	2	16	\N	0	\N	\N	124	1	2	f	16	\N	\N
639	30	57	2	16	\N	0	\N	\N	125	1	2	f	16	\N	\N
640	25	57	2	16	\N	0	\N	\N	126	1	2	f	16	\N	\N
641	72	57	2	16	\N	0	\N	\N	127	1	2	f	16	\N	\N
642	251	57	2	15	\N	0	\N	\N	128	1	2	f	15	\N	\N
643	202	57	2	15	\N	0	\N	\N	129	1	2	f	15	\N	\N
644	71	57	2	15	\N	0	\N	\N	130	1	2	f	15	\N	\N
645	238	57	2	14	\N	0	\N	\N	131	1	2	f	14	\N	\N
646	244	57	2	14	\N	0	\N	\N	132	1	2	f	14	\N	\N
647	31	57	2	13	\N	0	\N	\N	133	1	2	f	13	\N	\N
648	48	57	2	13	\N	0	\N	\N	134	1	2	f	13	\N	\N
649	79	57	2	12	\N	0	\N	\N	135	1	2	f	12	\N	\N
650	50	57	2	11	\N	0	\N	\N	136	1	2	f	11	\N	\N
651	199	57	2	11	\N	0	\N	\N	137	1	2	f	11	\N	\N
652	5	57	2	11	\N	0	\N	\N	138	1	2	f	11	\N	\N
653	205	57	2	10	\N	0	\N	\N	139	1	2	f	10	\N	\N
654	69	57	2	10	\N	0	\N	\N	140	1	2	f	10	\N	\N
655	153	57	2	10	\N	0	\N	\N	141	1	2	f	10	\N	\N
656	106	57	2	9	\N	0	\N	\N	142	1	2	f	9	\N	\N
657	97	57	2	9	\N	0	\N	\N	143	1	2	f	9	\N	\N
658	225	57	2	8	\N	0	\N	\N	144	1	2	f	8	\N	\N
659	247	57	2	7	\N	0	\N	\N	145	1	2	f	7	\N	\N
660	241	57	2	7	\N	0	\N	\N	146	1	2	f	7	\N	\N
661	256	57	2	7	\N	0	\N	\N	147	1	2	f	7	\N	\N
662	195	57	2	6	\N	0	\N	\N	148	1	2	f	6	\N	\N
663	233	57	2	6	\N	0	\N	\N	149	1	2	f	6	\N	\N
664	154	57	2	5	\N	0	\N	\N	150	1	2	f	5	\N	\N
665	81	57	2	5	\N	0	\N	\N	151	1	2	f	5	\N	\N
666	208	57	2	4	\N	0	\N	\N	152	1	2	f	4	\N	\N
667	111	57	2	4	\N	0	\N	\N	153	1	2	f	4	\N	\N
668	7	57	2	4	\N	0	\N	\N	154	1	2	f	4	\N	\N
669	242	57	2	4	\N	0	\N	\N	155	1	2	f	4	\N	\N
670	94	57	2	4	\N	0	\N	\N	156	1	2	f	4	\N	\N
671	221	57	2	4	\N	0	\N	\N	157	1	2	f	4	\N	\N
672	261	57	2	3	\N	0	\N	\N	158	1	2	f	3	\N	\N
673	91	57	2	3	\N	0	\N	\N	159	1	2	f	3	\N	\N
674	254	57	2	3	\N	0	\N	\N	160	1	2	f	3	\N	\N
675	20	57	2	3	\N	0	\N	\N	161	1	2	f	3	\N	\N
676	147	57	2	2	\N	0	\N	\N	162	1	2	f	2	\N	\N
677	47	57	2	2	\N	0	\N	\N	163	1	2	f	2	\N	\N
678	180	57	2	2	\N	0	\N	\N	164	1	2	f	2	\N	\N
679	18	57	2	2	\N	0	\N	\N	165	1	2	f	2	\N	\N
680	207	57	2	2	\N	0	\N	\N	166	1	2	f	2	\N	\N
681	9	57	2	2	\N	0	\N	\N	167	1	2	f	2	\N	\N
682	45	57	2	2	\N	0	\N	\N	168	1	2	f	2	\N	\N
683	66	57	2	2	\N	0	\N	\N	169	1	2	f	2	\N	\N
684	145	57	2	2	\N	0	\N	\N	170	1	2	f	2	\N	\N
685	55	57	2	2	\N	0	\N	\N	171	1	2	f	2	\N	\N
686	243	57	2	2	\N	0	\N	\N	172	1	2	f	2	\N	\N
687	32	57	2	2	\N	0	\N	\N	173	1	2	f	2	\N	\N
688	10	57	2	2	\N	0	\N	\N	174	1	2	f	2	\N	\N
689	220	57	2	2	\N	0	\N	\N	175	1	2	f	2	\N	\N
690	137	57	2	2	\N	0	\N	\N	176	1	2	f	2	\N	\N
691	204	57	2	2	\N	0	\N	\N	177	1	2	f	2	\N	\N
692	109	57	2	1	\N	0	\N	\N	178	1	2	f	1	\N	\N
693	157	57	2	1	\N	0	\N	\N	179	1	2	f	1	\N	\N
694	146	57	2	1	\N	0	\N	\N	180	1	2	f	1	\N	\N
695	39	57	2	1	\N	0	\N	\N	181	1	2	f	1	\N	\N
696	103	57	2	1	\N	0	\N	\N	182	1	2	f	1	\N	\N
697	172	57	2	1	\N	0	\N	\N	183	1	2	f	1	\N	\N
698	107	57	2	1	\N	0	\N	\N	184	1	2	f	1	\N	\N
699	36	57	2	1	\N	0	\N	\N	185	1	2	f	1	\N	\N
700	175	57	2	1	\N	0	\N	\N	186	1	2	f	1	\N	\N
701	44	57	2	1	\N	0	\N	\N	187	1	2	f	1	\N	\N
702	200	57	2	1	\N	0	\N	\N	188	1	2	f	1	\N	\N
703	159	57	2	1	\N	0	\N	\N	189	1	2	f	1	\N	\N
704	228	57	2	1	\N	0	\N	\N	190	1	2	f	1	\N	\N
705	49	57	2	1	\N	0	\N	\N	191	1	2	f	1	\N	\N
706	249	57	2	1	\N	0	\N	\N	192	1	2	f	1	\N	\N
707	129	57	2	1	\N	0	\N	\N	193	1	2	f	1	\N	\N
708	88	57	2	1	\N	0	\N	\N	194	1	2	f	1	\N	\N
709	80	57	2	1	\N	0	\N	\N	195	1	2	f	1	\N	\N
710	16	57	2	1	\N	0	\N	\N	196	1	2	f	1	\N	\N
711	42	57	2	1	\N	0	\N	\N	197	1	2	f	1	\N	\N
712	252	57	2	1	\N	0	\N	\N	198	1	2	f	1	\N	\N
713	98	57	2	1	\N	0	\N	\N	199	1	2	f	1	\N	\N
714	185	57	2	1	\N	0	\N	\N	200	1	2	f	1	\N	\N
715	169	57	2	1	\N	0	\N	\N	201	1	2	f	1	\N	\N
716	197	57	2	1	\N	0	\N	\N	202	1	2	f	1	\N	\N
717	158	57	2	1	\N	0	\N	\N	203	1	2	f	1	\N	\N
718	67	57	2	1	\N	0	\N	\N	204	1	2	f	1	\N	\N
719	131	57	2	303	\N	0	\N	\N	0	1	2	f	303	\N	\N
720	112	57	2	199	\N	0	\N	\N	0	1	2	f	199	\N	\N
721	177	57	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
722	231	58	2	41007	\N	41007	\N	\N	1	1	2	f	0	28	\N
723	28	58	1	41007	\N	41007	\N	\N	1	1	2	f	\N	231	\N
724	19	59	2	7223	\N	7223	\N	\N	1	1	2	f	0	105	\N
725	231	59	2	157	\N	157	\N	\N	2	1	2	f	0	105	\N
726	105	59	1	7380	\N	7380	\N	\N	1	1	2	f	\N	\N	\N
727	235	60	2	6702	\N	6702	\N	\N	1	1	2	f	0	\N	\N
728	267	60	2	4383	\N	4383	\N	\N	2	1	2	f	0	\N	\N
729	232	60	2	6	\N	6	\N	\N	3	1	2	f	0	\N	\N
730	265	60	1	2352	\N	2352	\N	\N	1	1	2	f	\N	\N	\N
731	142	60	1	2002	\N	2002	\N	\N	2	1	2	f	\N	\N	\N
732	21	60	1	1512	\N	1512	\N	\N	3	1	2	f	\N	\N	\N
733	2	60	1	610	\N	610	\N	\N	4	1	2	f	\N	\N	\N
734	93	60	1	572	\N	572	\N	\N	5	1	2	f	\N	\N	\N
735	35	60	1	394	\N	394	\N	\N	6	1	2	f	\N	\N	\N
736	34	60	1	380	\N	380	\N	\N	7	1	2	f	\N	\N	\N
737	163	60	1	352	\N	352	\N	\N	8	1	2	f	\N	\N	\N
738	57	60	1	264	\N	264	\N	\N	9	1	2	f	\N	235	\N
739	82	60	1	248	\N	248	\N	\N	10	1	2	f	\N	\N	\N
740	1	60	1	214	\N	214	\N	\N	11	1	2	f	\N	235	\N
741	6	60	1	200	\N	200	\N	\N	12	1	2	f	\N	\N	\N
742	168	60	1	183	\N	183	\N	\N	13	1	2	f	\N	\N	\N
743	120	60	1	142	\N	142	\N	\N	14	1	2	f	\N	235	\N
744	22	60	1	127	\N	127	\N	\N	15	1	2	f	\N	235	\N
745	130	60	1	98	\N	98	\N	\N	16	1	2	f	\N	\N	\N
746	33	60	1	93	\N	93	\N	\N	17	1	2	f	\N	\N	\N
747	250	60	1	88	\N	88	\N	\N	18	1	2	f	\N	235	\N
748	78	60	1	87	\N	87	\N	\N	19	1	2	f	\N	\N	\N
749	100	60	1	73	\N	73	\N	\N	20	1	2	f	\N	\N	\N
750	68	60	1	70	\N	70	\N	\N	21	1	2	f	\N	\N	\N
751	206	60	1	67	\N	67	\N	\N	22	1	2	f	\N	235	\N
752	213	60	1	65	\N	65	\N	\N	23	1	2	f	\N	\N	\N
753	4	60	1	59	\N	59	\N	\N	24	1	2	f	\N	235	\N
754	198	60	1	59	\N	59	\N	\N	25	1	2	f	\N	\N	\N
755	216	60	1	57	\N	57	\N	\N	26	1	2	f	\N	\N	\N
756	136	60	1	55	\N	55	\N	\N	27	1	2	f	\N	235	\N
757	128	60	1	49	\N	49	\N	\N	28	1	2	f	\N	\N	\N
758	41	60	1	49	\N	49	\N	\N	29	1	2	f	\N	\N	\N
759	15	60	1	45	\N	45	\N	\N	30	1	2	f	\N	267	\N
760	40	60	1	36	\N	36	\N	\N	31	1	2	f	\N	235	\N
761	233	60	1	34	\N	34	\N	\N	32	1	2	f	\N	\N	\N
762	238	60	1	30	\N	30	\N	\N	33	1	2	f	\N	235	\N
763	17	60	1	30	\N	30	\N	\N	34	1	2	f	\N	\N	\N
764	7	60	1	29	\N	29	\N	\N	35	1	2	f	\N	\N	\N
765	179	60	1	28	\N	28	\N	\N	36	1	2	f	\N	267	\N
766	25	60	1	27	\N	27	\N	\N	37	1	2	f	\N	267	\N
767	251	60	1	20	\N	20	\N	\N	38	1	2	f	\N	\N	\N
768	31	60	1	18	\N	18	\N	\N	39	1	2	f	\N	235	\N
769	236	60	1	18	\N	18	\N	\N	40	1	2	f	\N	267	\N
770	205	60	1	17	\N	17	\N	\N	41	1	2	f	\N	235	\N
771	191	60	1	17	\N	17	\N	\N	42	1	2	f	\N	\N	\N
772	5	60	1	16	\N	16	\N	\N	43	1	2	f	\N	\N	\N
773	30	60	1	16	\N	16	\N	\N	44	1	2	f	\N	\N	\N
774	153	60	1	14	\N	14	\N	\N	45	1	2	f	\N	235	\N
775	20	60	1	13	\N	13	\N	\N	46	1	2	f	\N	\N	\N
776	48	60	1	13	\N	13	\N	\N	47	1	2	f	\N	267	\N
777	225	60	1	12	\N	12	\N	\N	48	1	2	f	\N	235	\N
778	199	60	1	12	\N	12	\N	\N	49	1	2	f	\N	235	\N
779	69	60	1	11	\N	11	\N	\N	50	1	2	f	\N	267	\N
780	50	60	1	11	\N	11	\N	\N	51	1	2	f	\N	267	\N
781	97	60	1	9	\N	9	\N	\N	52	1	2	f	\N	267	\N
782	106	60	1	9	\N	9	\N	\N	53	1	2	f	\N	\N	\N
783	195	60	1	7	\N	7	\N	\N	54	1	2	f	\N	235	\N
784	247	60	1	7	\N	7	\N	\N	55	1	2	f	\N	267	\N
785	81	60	1	6	\N	6	\N	\N	56	1	2	f	\N	235	\N
786	207	60	1	5	\N	5	\N	\N	57	1	2	f	\N	\N	\N
787	254	60	1	5	\N	5	\N	\N	58	1	2	f	\N	235	\N
788	154	60	1	5	\N	5	\N	\N	59	1	2	f	\N	235	\N
789	111	60	1	4	\N	4	\N	\N	60	1	2	f	\N	235	\N
790	208	60	1	4	\N	4	\N	\N	61	1	2	f	\N	267	\N
791	180	60	1	3	\N	3	\N	\N	62	1	2	f	\N	235	\N
792	261	60	1	3	\N	3	\N	\N	63	1	2	f	\N	235	\N
793	91	60	1	3	\N	3	\N	\N	64	1	2	f	\N	235	\N
794	9	60	1	2	\N	2	\N	\N	65	1	2	f	\N	267	\N
795	45	60	1	2	\N	2	\N	\N	66	1	2	f	\N	235	\N
796	47	60	1	2	\N	2	\N	\N	67	1	2	f	\N	267	\N
797	18	60	1	2	\N	2	\N	\N	68	1	2	f	\N	\N	\N
798	169	60	1	1	\N	1	\N	\N	69	1	2	f	\N	235	\N
799	80	60	1	1	\N	1	\N	\N	70	1	2	f	\N	235	\N
800	49	60	1	1	\N	1	\N	\N	71	1	2	f	\N	232	\N
801	200	60	1	1	\N	1	\N	\N	72	1	2	f	\N	267	\N
802	88	60	1	1	\N	1	\N	\N	73	1	2	f	\N	235	\N
803	172	60	1	1	\N	1	\N	\N	74	1	2	f	\N	235	\N
804	159	60	1	1	\N	1	\N	\N	75	1	2	f	\N	235	\N
805	197	60	1	1	\N	1	\N	\N	76	1	2	f	\N	235	\N
806	103	60	1	1	\N	1	\N	\N	77	1	2	f	\N	235	\N
807	157	60	1	1	\N	1	\N	\N	78	1	2	f	\N	235	\N
808	36	60	1	1	\N	1	\N	\N	79	1	2	f	\N	232	\N
809	107	60	1	1	\N	1	\N	\N	80	1	2	f	\N	267	\N
810	39	60	1	1	\N	1	\N	\N	81	1	2	f	\N	235	\N
811	228	60	1	1	\N	1	\N	\N	82	1	2	f	\N	235	\N
812	185	60	1	1	\N	1	\N	\N	83	1	2	f	\N	235	\N
813	109	60	1	1	\N	1	\N	\N	84	1	2	f	\N	235	\N
814	16	60	1	1	\N	1	\N	\N	85	1	2	f	\N	235	\N
815	129	60	1	1	\N	1	\N	\N	86	1	2	f	\N	235	\N
816	98	60	1	1	\N	1	\N	\N	87	1	2	f	\N	235	\N
817	146	60	1	1	\N	1	\N	\N	88	1	2	f	\N	235	\N
818	252	60	1	1	\N	1	\N	\N	89	1	2	f	\N	235	\N
819	175	60	1	1	\N	1	\N	\N	90	1	2	f	\N	235	\N
820	249	60	1	1	\N	1	\N	\N	91	1	2	f	\N	235	\N
821	42	60	1	1	\N	1	\N	\N	92	1	2	f	\N	235	\N
822	44	60	1	1	\N	1	\N	\N	93	1	2	f	\N	267	\N
823	231	61	2	24830	\N	24830	\N	\N	1	1	2	f	0	\N	\N
824	19	61	2	1008	\N	1008	\N	\N	2	1	2	f	0	\N	\N
825	119	61	1	24943	\N	24943	\N	\N	1	1	2	f	\N	\N	\N
826	231	62	2	27978	\N	27978	\N	\N	1	1	2	f	0	32	\N
827	99	62	2	24	\N	24	\N	\N	2	1	2	f	0	32	\N
828	32	62	1	28002	\N	28002	\N	\N	1	1	2	f	\N	\N	\N
829	231	63	2	46228	\N	46228	\N	\N	1	1	2	f	0	\N	\N
830	46	63	2	14494	\N	14494	\N	\N	2	1	2	f	0	\N	\N
831	19	63	2	1634	\N	1634	\N	\N	3	1	2	f	0	\N	\N
832	95	63	2	565	\N	565	\N	\N	4	1	2	f	0	203	\N
833	13	63	2	417	\N	417	\N	\N	5	1	2	f	0	203	\N
834	99	63	2	24	\N	24	\N	\N	6	1	2	f	0	101	\N
835	112	63	2	387	\N	387	\N	\N	0	1	2	f	0	\N	\N
836	177	63	2	69	\N	69	\N	\N	0	1	2	f	0	\N	\N
837	101	63	1	18493	\N	18493	\N	\N	1	1	2	f	\N	\N	\N
838	203	63	1	9917	\N	9917	\N	\N	2	1	2	f	\N	\N	\N
839	181	63	1	9509	\N	9509	\N	\N	3	1	2	f	\N	231	\N
840	170	63	1	5886	\N	5886	\N	\N	4	1	2	f	\N	46	\N
841	11	63	1	5164	\N	5164	\N	\N	5	1	2	f	\N	\N	\N
842	178	63	1	2669	\N	2669	\N	\N	6	1	2	f	\N	231	\N
843	76	63	1	2669	\N	2669	\N	\N	7	1	2	f	\N	231	\N
844	245	63	1	2668	\N	2668	\N	\N	8	1	2	f	\N	231	\N
845	23	63	1	1367	\N	1367	\N	\N	9	1	2	f	\N	231	\N
846	14	63	1	1284	\N	1284	\N	\N	10	1	2	f	\N	46	\N
847	38	63	1	1135	\N	1135	\N	\N	11	1	2	f	\N	231	\N
848	37	63	1	783	\N	783	\N	\N	12	1	2	f	\N	231	\N
849	58	63	1	690	\N	690	\N	\N	13	1	2	f	\N	46	\N
850	83	63	1	520	\N	520	\N	\N	14	1	2	f	\N	\N	\N
851	141	63	1	255	\N	255	\N	\N	15	1	2	f	\N	\N	\N
852	110	63	1	224	\N	224	\N	\N	16	1	2	f	\N	\N	\N
853	26	63	1	148	\N	148	\N	\N	17	1	2	f	\N	231	\N
854	43	63	1	75	\N	75	\N	\N	18	1	2	f	\N	\N	\N
855	19	64	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
856	231	65	2	21550	\N	21550	\N	\N	1	1	2	f	0	177	\N
857	19	65	2	239	\N	239	\N	\N	2	1	2	f	0	177	\N
858	177	65	1	21789	\N	21789	\N	\N	1	1	2	f	\N	\N	\N
859	46	65	1	21789	\N	21789	\N	\N	0	1	2	f	\N	\N	\N
860	46	66	2	9244	\N	0	\N	\N	1	1	2	f	9244	\N	\N
861	112	66	2	199	\N	0	\N	\N	0	1	2	f	199	\N	\N
862	177	66	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
863	123	67	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
864	32	67	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
865	10	67	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
866	102	67	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
867	8	67	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
868	196	67	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
869	231	68	2	23163	\N	23163	\N	\N	1	1	2	f	0	112	\N
870	19	68	2	197	\N	197	\N	\N	2	1	2	f	0	112	\N
871	112	68	1	23361	\N	23361	\N	\N	1	1	2	f	\N	\N	\N
872	46	68	1	23361	\N	23361	\N	\N	0	1	2	f	\N	\N	\N
873	63	69	2	34608	\N	34608	\N	\N	1	1	2	f	0	\N	\N
874	61	69	2	31275	\N	31275	\N	\N	2	1	2	f	0	\N	\N
875	227	69	2	25073	\N	25073	\N	\N	3	1	2	f	0	231	\N
876	259	69	2	20493	\N	20493	\N	\N	4	1	2	f	0	\N	\N
877	209	69	2	18075	\N	18075	\N	\N	5	1	2	f	0	\N	\N
878	211	69	2	17683	\N	17683	\N	\N	6	1	2	f	0	\N	\N
879	117	69	2	14700	\N	14700	\N	\N	7	1	2	f	0	\N	\N
880	118	69	2	13586	\N	13586	\N	\N	8	1	2	f	0	\N	\N
881	187	69	2	12978	\N	12978	\N	\N	9	1	2	f	0	231	\N
882	248	69	2	11468	\N	11468	\N	\N	10	1	2	f	0	\N	\N
883	167	69	2	9052	\N	9052	\N	\N	11	1	2	f	0	231	\N
884	257	69	2	6443	\N	6443	\N	\N	12	1	2	f	0	\N	\N
885	260	69	2	5820	\N	5820	\N	\N	13	1	2	f	0	231	\N
886	89	69	2	5618	\N	5618	\N	\N	14	1	2	f	0	231	\N
887	258	69	2	4779	\N	4779	\N	\N	15	1	2	f	0	\N	\N
888	114	69	2	4462	\N	4462	\N	\N	16	1	2	f	0	231	\N
889	74	69	2	4088	\N	4088	\N	\N	17	1	2	f	0	\N	\N
890	70	69	2	3927	\N	3927	\N	\N	18	1	2	f	0	19	\N
891	263	69	2	3775	\N	3775	\N	\N	19	1	2	f	0	231	\N
892	65	69	2	3503	\N	3503	\N	\N	20	1	2	f	0	231	\N
893	222	69	2	2844	\N	2844	\N	\N	21	1	2	f	0	231	\N
894	126	69	2	2085	\N	2085	\N	\N	22	1	2	f	0	231	\N
895	121	69	2	1711	\N	1711	\N	\N	23	1	2	f	0	\N	\N
896	85	69	2	1707	\N	1707	\N	\N	24	1	2	f	0	231	\N
897	122	69	2	1585	\N	1585	\N	\N	25	1	2	f	0	19	\N
898	62	69	2	1381	\N	1381	\N	\N	26	1	2	f	0	231	\N
899	240	69	2	1313	\N	1313	\N	\N	27	1	2	f	0	231	\N
900	59	69	2	968	\N	968	\N	\N	28	1	2	f	0	231	\N
901	139	69	2	751	\N	751	\N	\N	29	1	2	f	0	231	\N
902	138	69	2	736	\N	736	\N	\N	30	1	2	f	0	231	\N
903	87	69	2	653	\N	653	\N	\N	31	1	2	f	0	231	\N
904	150	69	2	650	\N	650	\N	\N	32	1	2	f	0	231	\N
905	237	69	2	598	\N	598	\N	\N	33	1	2	f	0	231	\N
906	166	69	2	597	\N	597	\N	\N	34	1	2	f	0	231	\N
907	262	69	2	558	\N	558	\N	\N	35	1	2	f	0	231	\N
908	75	69	2	529	\N	529	\N	\N	36	1	2	f	0	\N	\N
909	226	69	2	517	\N	517	\N	\N	37	1	2	f	0	231	\N
910	149	69	2	463	\N	463	\N	\N	38	1	2	f	0	231	\N
911	266	69	2	460	\N	460	\N	\N	39	1	2	f	0	231	\N
912	127	69	2	407	\N	407	\N	\N	40	1	2	f	0	231	\N
913	214	69	2	400	\N	400	\N	\N	41	1	2	f	0	231	\N
914	264	69	2	398	\N	398	\N	\N	42	1	2	f	0	231	\N
915	246	69	2	338	\N	338	\N	\N	43	1	2	f	0	231	\N
916	86	69	2	306	\N	306	\N	\N	44	1	2	f	0	231	\N
917	188	69	2	269	\N	269	\N	\N	45	1	2	f	0	231	\N
918	124	69	2	230	\N	230	\N	\N	46	1	2	f	0	231	\N
919	217	69	2	230	\N	230	\N	\N	47	1	2	f	0	231	\N
920	162	69	2	165	\N	165	\N	\N	48	1	2	f	0	231	\N
921	210	69	2	164	\N	164	\N	\N	49	1	2	f	0	231	\N
922	173	69	2	158	\N	158	\N	\N	50	1	2	f	0	231	\N
923	155	69	2	130	\N	130	\N	\N	51	1	2	f	0	231	\N
924	224	69	2	126	\N	126	\N	\N	52	1	2	f	0	231	\N
925	176	69	2	108	\N	108	\N	\N	53	1	2	f	0	231	\N
926	125	69	2	82	\N	82	\N	\N	54	1	2	f	0	231	\N
927	115	69	2	78	\N	78	\N	\N	55	1	2	f	0	231	\N
928	255	69	2	78	\N	78	\N	\N	56	1	2	f	0	231	\N
929	151	69	2	75	\N	75	\N	\N	57	1	2	f	0	231	\N
930	215	69	2	48	\N	48	\N	\N	58	1	2	f	0	231	\N
931	156	69	2	47	\N	47	\N	\N	59	1	2	f	0	231	\N
932	152	69	2	47	\N	47	\N	\N	60	1	2	f	0	231	\N
933	164	69	2	46	\N	46	\N	\N	61	1	2	f	0	231	\N
934	171	69	2	27	\N	27	\N	\N	62	1	2	f	0	231	\N
935	84	69	2	26	\N	26	\N	\N	63	1	2	f	0	231	\N
936	53	69	2	17	\N	17	\N	\N	64	1	2	f	0	231	\N
937	72	69	2	16	\N	16	\N	\N	65	1	2	f	0	231	\N
938	71	69	2	15	\N	15	\N	\N	66	1	2	f	0	231	\N
939	202	69	2	15	\N	15	\N	\N	67	1	2	f	0	231	\N
940	244	69	2	14	\N	14	\N	\N	68	1	2	f	0	231	\N
941	241	69	2	7	\N	7	\N	\N	69	1	2	f	0	231	\N
942	256	69	2	7	\N	7	\N	\N	70	1	2	f	0	231	\N
943	242	69	2	4	\N	4	\N	\N	71	1	2	f	0	231	\N
944	94	69	2	4	\N	4	\N	\N	72	1	2	f	0	231	\N
945	221	69	2	4	\N	4	\N	\N	73	1	2	f	0	231	\N
946	66	69	2	2	\N	2	\N	\N	74	1	2	f	0	231	\N
947	55	69	2	2	\N	2	\N	\N	75	1	2	f	0	231	\N
948	145	69	2	2	\N	2	\N	\N	76	1	2	f	0	231	\N
949	220	69	2	2	\N	2	\N	\N	77	1	2	f	0	231	\N
950	137	69	2	2	\N	2	\N	\N	78	1	2	f	0	231	\N
951	158	69	2	1	\N	1	\N	\N	79	1	2	f	0	231	\N
952	67	69	2	1	\N	1	\N	\N	80	1	2	f	0	19	\N
953	231	69	1	139454	\N	139454	\N	\N	1	1	2	f	\N	\N	\N
954	19	69	1	136142	\N	136142	\N	\N	2	1	2	f	\N	\N	\N
955	11	70	2	1750	\N	0	\N	\N	1	1	2	f	1750	\N	\N
956	204	71	2	1	\N	1	\N	\N	1	1	2	f	0	204	\N
957	131	71	2	178	\N	178	\N	\N	0	1	2	f	0	\N	\N
958	204	71	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
959	131	71	1	152	\N	152	\N	\N	0	1	2	f	\N	\N	\N
960	102	72	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
961	8	72	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
962	196	72	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
963	123	73	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
964	102	74	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
965	8	74	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
966	196	74	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
967	234	75	2	62421	\N	0	\N	\N	1	1	2	f	62421	\N	\N
968	96	76	2	187324	\N	187324	\N	\N	1	1	2	f	0	\N	\N
969	231	76	1	173028	\N	173028	\N	\N	1	1	2	f	\N	96	\N
970	19	76	1	14296	\N	14296	\N	\N	2	1	2	f	\N	96	\N
971	95	77	2	10934	\N	10934	\N	\N	1	1	2	f	0	13	\N
972	13	77	1	10934	\N	10934	\N	\N	1	1	2	f	\N	95	\N
973	102	78	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
974	8	78	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
975	196	78	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
976	10	78	1	2	\N	2	\N	\N	1	1	2	f	\N	196	\N
977	147	78	1	1	\N	1	\N	\N	2	1	2	f	\N	196	\N
978	123	79	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
979	102	79	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
980	8	79	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
981	196	79	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
982	96	80	2	157630	\N	0	\N	\N	1	1	2	f	157630	\N	\N
983	46	81	2	5662	\N	5662	\N	\N	1	1	2	f	0	\N	\N
984	231	81	2	948	\N	948	\N	\N	2	1	2	f	0	\N	\N
985	19	81	2	286	\N	286	\N	\N	3	1	2	f	0	\N	\N
986	112	81	2	870	\N	870	\N	\N	0	1	2	f	0	\N	\N
987	177	81	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
988	231	82	2	18457	\N	0	\N	\N	1	1	2	f	18457	\N	\N
989	161	83	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
990	232	84	2	8585	\N	8585	\N	\N	1	1	2	f	0	253	\N
991	267	84	2	3931	\N	3931	\N	\N	2	1	2	f	0	253	\N
992	235	84	2	2367	\N	2367	\N	\N	3	1	2	f	0	253	\N
993	253	84	1	14879	\N	14879	\N	\N	1	1	2	f	\N	\N	\N
994	96	85	2	187324	\N	187324	\N	\N	1	1	2	f	0	\N	\N
995	182	85	2	123197	\N	123197	\N	\N	2	1	2	f	0	\N	\N
996	105	85	2	93050	\N	93050	\N	\N	3	1	2	f	0	\N	\N
997	234	85	2	62575	\N	62575	\N	\N	4	1	2	f	0	\N	\N
998	19	85	2	47246	\N	47246	\N	\N	5	1	2	f	0	\N	\N
999	230	85	2	42815	\N	42815	\N	\N	6	1	2	f	0	\N	\N
1000	267	85	2	42090	\N	42090	\N	\N	7	1	2	f	0	\N	\N
1001	232	85	2	41930	\N	41930	\N	\N	8	1	2	f	0	\N	\N
1002	63	85	2	34606	\N	34606	\N	\N	9	1	2	f	0	\N	\N
1003	61	85	2	31276	\N	31276	\N	\N	10	1	2	f	0	\N	\N
1004	231	85	2	27978	\N	27978	\N	\N	11	1	2	f	0	\N	\N
1005	56	85	2	27978	\N	27978	\N	\N	12	1	2	f	0	\N	\N
1006	227	85	2	25076	\N	25076	\N	\N	13	1	2	f	0	\N	\N
1007	119	85	2	24944	\N	24944	\N	\N	14	1	2	f	0	\N	\N
1008	259	85	2	20497	\N	20497	\N	\N	15	1	2	f	0	\N	\N
1009	24	85	2	19348	\N	19348	\N	\N	16	1	2	f	0	\N	\N
1010	101	85	2	18493	\N	18493	\N	\N	17	1	2	f	0	\N	\N
1011	209	85	2	18080	\N	18080	\N	\N	18	1	2	f	0	\N	\N
1012	211	85	2	17688	\N	17688	\N	\N	19	1	2	f	0	\N	\N
1013	235	85	2	17125	\N	17125	\N	\N	20	1	2	f	0	\N	\N
1014	117	85	2	14702	\N	14702	\N	\N	21	1	2	f	0	\N	\N
1015	118	85	2	13588	\N	13588	\N	\N	22	1	2	f	0	\N	\N
1016	187	85	2	12981	\N	12981	\N	\N	23	1	2	f	0	\N	\N
1017	248	85	2	11472	\N	11472	\N	\N	24	1	2	f	0	\N	\N
1018	95	85	2	10914	\N	10914	\N	\N	25	1	2	f	0	\N	\N
1019	46	85	2	9797	\N	9797	\N	\N	26	1	2	f	0	\N	\N
1020	181	85	2	9509	\N	9509	\N	\N	27	1	2	f	0	\N	\N
1021	167	85	2	9054	\N	9054	\N	\N	28	1	2	f	0	\N	\N
1022	203	85	2	8949	\N	8949	\N	\N	29	1	2	f	0	\N	\N
1023	12	85	2	6677	\N	6677	\N	\N	30	1	2	f	0	\N	\N
1024	257	85	2	6447	\N	6447	\N	\N	31	1	2	f	0	\N	\N
1025	260	85	2	5820	\N	5820	\N	\N	32	1	2	f	0	\N	\N
1026	170	85	2	5695	\N	5695	\N	\N	33	1	2	f	0	\N	\N
1027	89	85	2	5619	\N	5619	\N	\N	34	1	2	f	0	\N	\N
1028	258	85	2	4783	\N	4783	\N	\N	35	1	2	f	0	\N	\N
1029	11	85	2	4733	\N	4733	\N	\N	36	1	2	f	0	\N	\N
1030	114	85	2	4462	\N	4462	\N	\N	37	1	2	f	0	\N	\N
1031	51	85	2	4183	\N	4183	\N	\N	38	1	2	f	0	\N	\N
1032	74	85	2	4090	\N	4090	\N	\N	39	1	2	f	0	\N	\N
1033	70	85	2	3929	\N	3929	\N	\N	40	1	2	f	0	\N	\N
1034	263	85	2	3779	\N	3779	\N	\N	41	1	2	f	0	\N	\N
1035	65	85	2	3504	\N	3504	\N	\N	42	1	2	f	0	\N	\N
1036	222	85	2	2846	\N	2846	\N	\N	43	1	2	f	0	\N	\N
1037	178	85	2	2669	\N	2669	\N	\N	44	1	2	f	0	\N	\N
1038	76	85	2	2669	\N	2669	\N	\N	45	1	2	f	0	\N	\N
1039	245	85	2	2668	\N	2668	\N	\N	46	1	2	f	0	\N	\N
1040	13	85	2	2141	\N	2141	\N	\N	47	1	2	f	0	\N	\N
1041	126	85	2	2086	\N	2086	\N	\N	48	1	2	f	0	\N	\N
1042	265	85	2	1892	\N	1892	\N	\N	49	1	2	f	0	29	\N
1043	121	85	2	1713	\N	1713	\N	\N	50	1	2	f	0	\N	\N
1044	85	85	2	1707	\N	1707	\N	\N	51	1	2	f	0	\N	\N
1045	122	85	2	1587	\N	1587	\N	\N	52	1	2	f	0	\N	\N
1046	62	85	2	1382	\N	1382	\N	\N	53	1	2	f	0	\N	\N
1047	23	85	2	1367	\N	1367	\N	\N	54	1	2	f	0	\N	\N
1048	240	85	2	1317	\N	1317	\N	\N	55	1	2	f	0	\N	\N
1049	77	85	2	1260	\N	1260	\N	\N	56	1	2	f	0	\N	\N
1050	14	85	2	1229	\N	1229	\N	\N	57	1	2	f	0	\N	\N
1051	148	85	2	1217	\N	1217	\N	\N	58	1	2	f	0	\N	\N
1052	38	85	2	1135	\N	1135	\N	\N	59	1	2	f	0	\N	\N
1053	59	85	2	968	\N	968	\N	\N	60	1	2	f	0	\N	\N
1054	37	85	2	783	\N	783	\N	\N	61	1	2	f	0	\N	\N
1055	139	85	2	753	\N	753	\N	\N	62	1	2	f	0	\N	\N
1056	138	85	2	736	\N	736	\N	\N	63	1	2	f	0	\N	\N
1057	58	85	2	686	\N	686	\N	\N	64	1	2	f	0	\N	\N
1058	87	85	2	654	\N	654	\N	\N	65	1	2	f	0	\N	\N
1059	150	85	2	638	\N	638	\N	\N	66	1	2	f	0	\N	\N
1060	237	85	2	602	\N	602	\N	\N	67	1	2	f	0	\N	\N
1061	166	85	2	599	\N	599	\N	\N	68	1	2	f	0	\N	\N
1062	142	85	2	595	\N	595	\N	\N	69	1	2	f	0	29	\N
1063	262	85	2	562	\N	562	\N	\N	70	1	2	f	0	\N	\N
1064	28	85	2	548	\N	548	\N	\N	71	1	2	f	0	\N	\N
1065	75	85	2	531	\N	531	\N	\N	72	1	2	f	0	\N	\N
1066	226	85	2	520	\N	520	\N	\N	73	1	2	f	0	\N	\N
1067	73	85	2	495	\N	495	\N	\N	74	1	2	f	0	\N	\N
1068	83	85	2	494	\N	494	\N	\N	75	1	2	f	0	\N	\N
1069	253	85	2	494	\N	494	\N	\N	76	1	2	f	0	\N	\N
1070	149	85	2	464	\N	464	\N	\N	77	1	2	f	0	\N	\N
1071	266	85	2	460	\N	460	\N	\N	78	1	2	f	0	\N	\N
1072	127	85	2	408	\N	408	\N	\N	79	1	2	f	0	\N	\N
1073	214	85	2	401	\N	401	\N	\N	80	1	2	f	0	\N	\N
1074	264	85	2	400	\N	400	\N	\N	81	1	2	f	0	\N	\N
1075	246	85	2	340	\N	340	\N	\N	82	1	2	f	0	\N	\N
1076	86	85	2	306	\N	306	\N	\N	83	1	2	f	0	\N	\N
1077	35	85	2	283	\N	283	\N	\N	84	1	2	f	0	29	\N
1078	188	85	2	272	\N	272	\N	\N	85	1	2	f	0	\N	\N
1079	21	85	2	259	\N	259	\N	\N	86	1	2	f	0	29	\N
1080	141	85	2	238	\N	238	\N	\N	87	1	2	f	0	\N	\N
1081	217	85	2	232	\N	232	\N	\N	88	1	2	f	0	\N	\N
1082	124	85	2	231	\N	231	\N	\N	89	1	2	f	0	\N	\N
1083	110	85	2	216	\N	216	\N	\N	90	1	2	f	0	\N	\N
1084	2	85	2	201	\N	201	\N	\N	91	1	2	f	0	29	\N
1085	93	85	2	196	\N	196	\N	\N	92	1	2	f	0	29	\N
1086	3	85	2	188	\N	188	\N	\N	93	1	2	f	0	\N	\N
1087	162	85	2	167	\N	167	\N	\N	94	1	2	f	0	\N	\N
1088	210	85	2	165	\N	165	\N	\N	95	1	2	f	0	\N	\N
1089	173	85	2	161	\N	161	\N	\N	96	1	2	f	0	\N	\N
1090	26	85	2	148	\N	148	\N	\N	97	1	2	f	0	\N	\N
1091	155	85	2	131	\N	131	\N	\N	98	1	2	f	0	\N	\N
1092	224	85	2	130	\N	130	\N	\N	99	1	2	f	0	\N	\N
1093	176	85	2	110	\N	110	\N	\N	100	1	2	f	0	\N	\N
1094	82	85	2	107	\N	107	\N	\N	101	1	2	f	0	29	\N
1095	29	85	2	93	\N	93	\N	\N	102	1	2	f	0	\N	\N
1096	34	85	2	93	\N	93	\N	\N	103	1	2	f	0	29	\N
1097	6	85	2	83	\N	83	\N	\N	104	1	2	f	0	29	\N
1098	125	85	2	83	\N	83	\N	\N	105	1	2	f	0	\N	\N
1099	163	85	2	79	\N	79	\N	\N	106	1	2	f	0	29	\N
1100	255	85	2	78	\N	78	\N	\N	107	1	2	f	0	\N	\N
1101	115	85	2	78	\N	78	\N	\N	108	1	2	f	0	\N	\N
1102	151	85	2	76	\N	76	\N	\N	109	1	2	f	0	\N	\N
1103	43	85	2	73	\N	73	\N	\N	110	1	2	f	0	\N	\N
1104	68	85	2	67	\N	67	\N	\N	111	1	2	f	0	29	\N
1105	168	85	2	65	\N	65	\N	\N	112	1	2	f	0	29	\N
1106	57	85	2	65	\N	65	\N	\N	113	1	2	f	0	29	\N
1107	250	85	2	65	\N	65	\N	\N	114	1	2	f	0	29	\N
1108	213	85	2	64	\N	64	\N	\N	115	1	2	f	0	29	\N
1109	100	85	2	57	\N	57	\N	\N	116	1	2	f	0	29	\N
1110	215	85	2	50	\N	50	\N	\N	117	1	2	f	0	\N	\N
1111	198	85	2	48	\N	48	\N	\N	118	1	2	f	0	29	\N
1112	156	85	2	48	\N	48	\N	\N	119	1	2	f	0	\N	\N
1113	152	85	2	48	\N	48	\N	\N	120	1	2	f	0	\N	\N
1114	78	85	2	47	\N	47	\N	\N	121	1	2	f	0	29	\N
1115	164	85	2	47	\N	47	\N	\N	122	1	2	f	0	\N	\N
1116	15	85	2	45	\N	45	\N	\N	123	1	2	f	0	29	\N
1117	41	85	2	42	\N	42	\N	\N	124	1	2	f	0	29	\N
1118	1	85	2	42	\N	42	\N	\N	125	1	2	f	0	29	\N
1119	108	85	2	38	\N	38	\N	\N	126	1	2	f	0	\N	\N
1120	22	85	2	37	\N	37	\N	\N	127	1	2	f	0	29	\N
1121	128	85	2	33	\N	33	\N	\N	128	1	2	f	0	29	\N
1122	130	85	2	32	\N	32	\N	\N	129	1	2	f	0	29	\N
1123	33	85	2	29	\N	29	\N	\N	130	1	2	f	0	29	\N
1124	216	85	2	29	\N	29	\N	\N	131	1	2	f	0	29	\N
1125	104	85	2	28	\N	28	\N	\N	132	1	2	f	0	\N	\N
1126	179	85	2	27	\N	27	\N	\N	133	1	2	f	0	29	\N
1127	171	85	2	27	\N	27	\N	\N	134	1	2	f	0	\N	\N
1128	84	85	2	26	\N	26	\N	\N	135	1	2	f	0	\N	\N
1129	99	85	2	24	\N	24	\N	\N	136	1	2	f	0	\N	\N
1130	27	85	2	24	\N	24	\N	\N	137	1	2	f	0	\N	\N
1131	206	85	2	23	\N	23	\N	\N	138	1	2	f	0	29	\N
1132	17	85	2	21	\N	21	\N	\N	139	1	2	f	0	29	\N
1133	120	85	2	21	\N	21	\N	\N	140	1	2	f	0	29	\N
1134	4	85	2	21	\N	21	\N	\N	141	1	2	f	0	29	\N
1135	136	85	2	20	\N	20	\N	\N	142	1	2	f	0	29	\N
1136	40	85	2	18	\N	18	\N	\N	143	1	2	f	0	29	\N
1137	236	85	2	17	\N	17	\N	\N	144	1	2	f	0	29	\N
1138	53	85	2	17	\N	17	\N	\N	145	1	2	f	0	\N	\N
1139	72	85	2	17	\N	17	\N	\N	146	1	2	f	0	\N	\N
1140	191	85	2	16	\N	16	\N	\N	147	1	2	f	0	29	\N
1141	30	85	2	16	\N	16	\N	\N	148	1	2	f	0	29	\N
1142	25	85	2	16	\N	16	\N	\N	149	1	2	f	0	29	\N
1143	202	85	2	16	\N	16	\N	\N	150	1	2	f	0	\N	\N
1144	71	85	2	16	\N	16	\N	\N	151	1	2	f	0	\N	\N
1145	79	85	2	15	\N	15	\N	\N	152	1	2	f	0	\N	\N
1146	251	85	2	15	\N	15	\N	\N	153	1	2	f	0	29	\N
1147	238	85	2	14	\N	14	\N	\N	154	1	2	f	0	29	\N
1148	244	85	2	14	\N	14	\N	\N	155	1	2	f	0	\N	\N
1149	229	85	2	14	\N	14	\N	\N	156	1	2	f	0	\N	\N
1150	31	85	2	13	\N	13	\N	\N	157	1	2	f	0	29	\N
1151	48	85	2	13	\N	13	\N	\N	158	1	2	f	0	29	\N
1152	123	85	2	12	\N	12	\N	\N	159	1	2	f	0	\N	\N
1153	50	85	2	11	\N	11	\N	\N	160	1	2	f	0	29	\N
1154	199	85	2	11	\N	11	\N	\N	161	1	2	f	0	29	\N
1155	5	85	2	11	\N	11	\N	\N	162	1	2	f	0	29	\N
1156	205	85	2	10	\N	10	\N	\N	163	1	2	f	0	29	\N
1157	69	85	2	10	\N	10	\N	\N	164	1	2	f	0	29	\N
1158	153	85	2	10	\N	10	\N	\N	165	1	2	f	0	29	\N
1159	256	85	2	10	\N	10	\N	\N	166	1	2	f	0	\N	\N
1160	106	85	2	9	\N	9	\N	\N	167	1	2	f	0	29	\N
1161	97	85	2	9	\N	9	\N	\N	168	1	2	f	0	29	\N
1162	225	85	2	8	\N	8	\N	\N	169	1	2	f	0	29	\N
1163	223	85	2	8	\N	8	\N	\N	170	1	2	f	0	\N	\N
1164	247	85	2	7	\N	7	\N	\N	171	1	2	f	0	29	\N
1165	241	85	2	7	\N	7	\N	\N	172	1	2	f	0	\N	\N
1166	195	85	2	6	\N	6	\N	\N	173	1	2	f	0	29	\N
1167	233	85	2	6	\N	6	\N	\N	174	1	2	f	0	29	\N
1168	113	85	2	6	\N	6	\N	\N	175	1	2	f	0	\N	\N
1169	204	85	2	6	\N	6	\N	\N	176	1	2	f	0	\N	\N
1170	154	85	2	5	\N	5	\N	\N	177	1	2	f	0	29	\N
1171	81	85	2	5	\N	5	\N	\N	178	1	2	f	0	29	\N
1172	221	85	2	5	\N	5	\N	\N	179	1	2	f	0	\N	\N
1173	116	85	2	5	\N	5	\N	\N	180	1	2	f	0	\N	\N
1174	208	85	2	4	\N	4	\N	\N	181	1	2	f	0	29	\N
1175	111	85	2	4	\N	4	\N	\N	182	1	2	f	0	29	\N
1176	7	85	2	4	\N	4	\N	\N	183	1	2	f	0	29	\N
1177	242	85	2	4	\N	4	\N	\N	184	1	2	f	0	\N	\N
1178	94	85	2	4	\N	4	\N	\N	185	1	2	f	0	\N	\N
1179	137	85	2	4	\N	4	\N	\N	186	1	2	f	0	\N	\N
1180	102	85	2	3	\N	3	\N	\N	187	1	2	f	0	\N	\N
1181	261	85	2	3	\N	3	\N	\N	188	1	2	f	0	29	\N
1182	91	85	2	3	\N	3	\N	\N	189	1	2	f	0	29	\N
1183	254	85	2	3	\N	3	\N	\N	190	1	2	f	0	29	\N
1184	20	85	2	3	\N	3	\N	\N	191	1	2	f	0	29	\N
1185	220	85	2	3	\N	3	\N	\N	192	1	2	f	0	\N	\N
1186	67	85	2	3	\N	3	\N	\N	193	1	2	f	0	\N	\N
1187	183	85	2	3	\N	3	\N	\N	194	1	2	f	0	\N	\N
1188	174	85	2	3	\N	3	\N	\N	195	1	2	f	0	\N	\N
1189	47	85	2	2	\N	2	\N	\N	196	1	2	f	0	29	\N
1190	180	85	2	2	\N	2	\N	\N	197	1	2	f	0	29	\N
1191	18	85	2	2	\N	2	\N	\N	198	1	2	f	0	29	\N
1192	207	85	2	2	\N	2	\N	\N	199	1	2	f	0	29	\N
1193	9	85	2	2	\N	2	\N	\N	200	1	2	f	0	29	\N
1194	45	85	2	2	\N	2	\N	\N	201	1	2	f	0	29	\N
1195	66	85	2	2	\N	2	\N	\N	202	1	2	f	0	\N	\N
1196	145	85	2	2	\N	2	\N	\N	203	1	2	f	0	\N	\N
1197	55	85	2	2	\N	2	\N	\N	204	1	2	f	0	\N	\N
1198	32	85	2	2	\N	2	\N	\N	205	1	2	f	0	\N	\N
1199	218	85	2	2	\N	2	\N	\N	206	1	2	f	0	\N	\N
1200	52	85	2	2	\N	2	\N	\N	207	1	2	f	0	\N	\N
1201	201	85	2	2	\N	2	\N	\N	208	1	2	f	0	\N	\N
1202	186	85	2	2	\N	2	\N	\N	209	1	2	f	0	\N	\N
1203	184	85	2	2	\N	2	\N	\N	210	1	2	f	0	\N	\N
1204	193	85	2	2	\N	2	\N	\N	211	1	2	f	0	\N	\N
1205	192	85	2	2	\N	2	\N	\N	212	1	2	f	0	\N	\N
1206	194	85	2	2	\N	2	\N	\N	213	1	2	f	0	\N	\N
1207	165	85	2	2	\N	2	\N	\N	214	1	2	f	0	\N	\N
1208	160	85	2	2	\N	2	\N	\N	215	1	2	f	0	\N	\N
1209	143	85	2	2	\N	2	\N	\N	216	1	2	f	0	\N	\N
1210	135	85	2	2	\N	2	\N	\N	217	1	2	f	0	\N	\N
1211	133	85	2	2	\N	2	\N	\N	218	1	2	f	0	\N	\N
1212	132	85	2	2	\N	2	\N	\N	219	1	2	f	0	\N	\N
1213	239	85	2	2	\N	2	\N	\N	220	1	2	f	0	\N	\N
1214	212	85	2	2	\N	2	\N	\N	221	1	2	f	0	\N	\N
1215	243	85	2	2	\N	2	\N	\N	222	1	2	f	0	\N	\N
1216	10	85	2	2	\N	2	\N	\N	223	1	2	f	0	\N	\N
1217	44	85	2	1	\N	1	\N	\N	224	1	2	f	0	29	\N
1218	49	85	2	1	\N	1	\N	\N	225	1	2	f	0	29	\N
1219	42	85	2	1	\N	1	\N	\N	226	1	2	f	0	29	\N
1220	197	85	2	1	\N	1	\N	\N	227	1	2	f	0	29	\N
1221	80	85	2	1	\N	1	\N	\N	228	1	2	f	0	29	\N
1222	36	85	2	1	\N	1	\N	\N	229	1	2	f	0	29	\N
1223	249	85	2	1	\N	1	\N	\N	230	1	2	f	0	29	\N
1224	175	85	2	1	\N	1	\N	\N	231	1	2	f	0	29	\N
1225	98	85	2	1	\N	1	\N	\N	232	1	2	f	0	29	\N
1226	16	85	2	1	\N	1	\N	\N	233	1	2	f	0	29	\N
1227	252	85	2	1	\N	1	\N	\N	234	1	2	f	0	29	\N
1228	146	85	2	1	\N	1	\N	\N	235	1	2	f	0	29	\N
1229	107	85	2	1	\N	1	\N	\N	236	1	2	f	0	29	\N
1230	200	85	2	1	\N	1	\N	\N	237	1	2	f	0	29	\N
1231	159	85	2	1	\N	1	\N	\N	238	1	2	f	0	29	\N
1232	103	85	2	1	\N	1	\N	\N	239	1	2	f	0	29	\N
1233	172	85	2	1	\N	1	\N	\N	240	1	2	f	0	29	\N
1234	39	85	2	1	\N	1	\N	\N	241	1	2	f	0	29	\N
1235	109	85	2	1	\N	1	\N	\N	242	1	2	f	0	29	\N
1236	157	85	2	1	\N	1	\N	\N	243	1	2	f	0	29	\N
1237	228	85	2	1	\N	1	\N	\N	244	1	2	f	0	29	\N
1238	185	85	2	1	\N	1	\N	\N	245	1	2	f	0	29	\N
1239	169	85	2	1	\N	1	\N	\N	246	1	2	f	0	29	\N
1240	88	85	2	1	\N	1	\N	\N	247	1	2	f	0	29	\N
1241	129	85	2	1	\N	1	\N	\N	248	1	2	f	0	29	\N
1242	158	85	2	1	\N	1	\N	\N	249	1	2	f	0	\N	\N
1243	64	85	2	1	\N	1	\N	\N	250	1	2	f	0	\N	\N
1244	54	85	2	1	\N	1	\N	\N	251	1	2	f	0	\N	\N
1245	92	85	2	1	\N	1	\N	\N	252	1	2	f	0	\N	\N
1246	90	85	2	1	\N	1	\N	\N	253	1	2	f	0	\N	\N
1247	60	85	2	1	\N	1	\N	\N	254	1	2	f	0	\N	\N
1248	190	85	2	1	\N	1	\N	\N	255	1	2	f	0	\N	\N
1249	189	85	2	1	\N	1	\N	\N	256	1	2	f	0	\N	\N
1250	140	85	2	1	\N	1	\N	\N	257	1	2	f	0	\N	\N
1251	144	85	2	1	\N	1	\N	\N	258	1	2	f	0	\N	\N
1252	134	85	2	1	\N	1	\N	\N	259	1	2	f	0	\N	\N
1253	219	85	2	1	\N	1	\N	\N	260	1	2	f	0	\N	\N
1254	147	85	2	1	\N	1	\N	\N	261	1	2	f	0	\N	\N
1255	161	85	2	1	\N	1	\N	\N	262	1	2	f	0	\N	\N
1256	112	85	2	398	\N	398	\N	\N	0	1	2	f	0	\N	\N
1257	131	85	2	184	\N	184	\N	\N	0	1	2	f	0	79	\N
1258	177	85	2	90	\N	90	\N	\N	0	1	2	f	0	\N	\N
1259	8	85	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1260	196	85	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1261	29	85	1	5005	\N	5005	\N	\N	1	1	2	f	\N	\N	\N
1262	79	85	1	184	\N	184	\N	\N	2	1	2	f	\N	\N	\N
1263	131	85	1	1099955	\N	1099955	\N	\N	0	1	2	f	\N	\N	\N
1264	105	86	2	85766	\N	85766	\N	\N	1	1	2	f	0	\N	\N
1265	24	86	1	85764	\N	85764	\N	\N	1	1	2	f	\N	105	\N
1266	51	86	1	5406	\N	5406	\N	\N	0	1	2	f	\N	105	\N
1267	147	87	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1268	182	88	2	246394	\N	246394	\N	\N	1	1	2	f	0	231	\N
1269	231	88	1	246394	\N	246394	\N	\N	1	1	2	f	\N	182	\N
1270	148	89	2	1217	\N	1217	\N	\N	1	1	2	f	0	\N	\N
1271	28	89	2	536	\N	536	\N	\N	2	1	2	f	0	\N	\N
1272	32	89	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
1273	131	89	2	37	\N	37	\N	\N	0	1	2	f	0	\N	\N
1274	131	89	1	37	\N	37	\N	\N	0	1	2	f	\N	\N	\N
1275	231	90	2	21494	\N	21494	\N	\N	1	1	2	f	0	177	\N
1276	19	90	2	64	\N	64	\N	\N	2	1	2	f	0	177	\N
1277	177	90	1	21559	\N	21559	\N	\N	1	1	2	f	\N	\N	\N
1278	46	90	1	21559	\N	21559	\N	\N	0	1	2	f	\N	\N	\N
1279	131	91	2	194	\N	194	\N	\N	0	1	2	f	0	\N	\N
1280	223	91	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
1281	113	91	1	6	\N	6	\N	\N	2	1	2	f	\N	\N	\N
1282	116	91	1	5	\N	5	\N	\N	3	1	2	f	\N	\N	\N
1283	211	91	1	5	\N	5	\N	\N	4	1	2	f	\N	\N	\N
1284	209	91	1	5	\N	5	\N	\N	5	1	2	f	\N	\N	\N
1285	224	91	1	4	\N	4	\N	\N	6	1	2	f	\N	\N	\N
1286	262	91	1	4	\N	4	\N	\N	7	1	2	f	\N	\N	\N
1287	237	91	1	4	\N	4	\N	\N	8	1	2	f	\N	\N	\N
1288	240	91	1	4	\N	4	\N	\N	9	1	2	f	\N	\N	\N
1289	263	91	1	4	\N	4	\N	\N	10	1	2	f	\N	\N	\N
1290	258	91	1	4	\N	4	\N	\N	11	1	2	f	\N	\N	\N
1291	257	91	1	4	\N	4	\N	\N	12	1	2	f	\N	\N	\N
1292	248	91	1	4	\N	4	\N	\N	13	1	2	f	\N	\N	\N
1293	259	91	1	4	\N	4	\N	\N	14	1	2	f	\N	\N	\N
1294	183	91	1	3	\N	3	\N	\N	15	1	2	f	\N	\N	\N
1295	174	91	1	3	\N	3	\N	\N	16	1	2	f	\N	\N	\N
1296	256	91	1	3	\N	3	\N	\N	17	1	2	f	\N	\N	\N
1297	173	91	1	3	\N	3	\N	\N	18	1	2	f	\N	\N	\N
1298	188	91	1	3	\N	3	\N	\N	19	1	2	f	\N	\N	\N
1299	226	91	1	3	\N	3	\N	\N	20	1	2	f	\N	\N	\N
1300	187	91	1	3	\N	3	\N	\N	21	1	2	f	\N	\N	\N
1301	227	91	1	3	\N	3	\N	\N	22	1	2	f	\N	\N	\N
1302	218	91	1	2	\N	2	\N	\N	23	1	2	f	\N	\N	\N
1303	52	91	1	2	\N	2	\N	\N	24	1	2	f	\N	\N	\N
1304	165	91	1	2	\N	2	\N	\N	25	1	2	f	\N	\N	\N
1305	193	91	1	2	\N	2	\N	\N	26	1	2	f	\N	\N	\N
1306	192	91	1	2	\N	2	\N	\N	27	1	2	f	\N	\N	\N
1307	186	91	1	2	\N	2	\N	\N	28	1	2	f	\N	\N	\N
1308	184	91	1	2	\N	2	\N	\N	29	1	2	f	\N	\N	\N
1309	194	91	1	2	\N	2	\N	\N	30	1	2	f	\N	\N	\N
1310	160	91	1	2	\N	2	\N	\N	31	1	2	f	\N	\N	\N
1311	133	91	1	2	\N	2	\N	\N	32	1	2	f	\N	\N	\N
1312	132	91	1	2	\N	2	\N	\N	33	1	2	f	\N	\N	\N
1313	143	91	1	2	\N	2	\N	\N	34	1	2	f	\N	\N	\N
1314	135	91	1	2	\N	2	\N	\N	35	1	2	f	\N	\N	\N
1315	239	91	1	2	\N	2	\N	\N	36	1	2	f	\N	\N	\N
1316	212	91	1	2	\N	2	\N	\N	37	1	2	f	\N	\N	\N
1317	201	91	1	2	\N	2	\N	\N	38	1	2	f	\N	\N	\N
1318	67	91	1	2	\N	2	\N	\N	39	1	2	f	\N	\N	\N
1319	137	91	1	2	\N	2	\N	\N	40	1	2	f	\N	\N	\N
1320	215	91	1	2	\N	2	\N	\N	41	1	2	f	\N	\N	\N
1321	176	91	1	2	\N	2	\N	\N	42	1	2	f	\N	\N	\N
1322	162	91	1	2	\N	2	\N	\N	43	1	2	f	\N	\N	\N
1323	217	91	1	2	\N	2	\N	\N	44	1	2	f	\N	\N	\N
1324	246	91	1	2	\N	2	\N	\N	45	1	2	f	\N	\N	\N
1325	264	91	1	2	\N	2	\N	\N	46	1	2	f	\N	\N	\N
1326	75	91	1	2	\N	2	\N	\N	47	1	2	f	\N	\N	\N
1327	166	91	1	2	\N	2	\N	\N	48	1	2	f	\N	\N	\N
1328	139	91	1	2	\N	2	\N	\N	49	1	2	f	\N	\N	\N
1329	122	91	1	2	\N	2	\N	\N	50	1	2	f	\N	\N	\N
1330	121	91	1	2	\N	2	\N	\N	51	1	2	f	\N	\N	\N
1331	222	91	1	2	\N	2	\N	\N	52	1	2	f	\N	\N	\N
1332	70	91	1	2	\N	2	\N	\N	53	1	2	f	\N	\N	\N
1333	74	91	1	2	\N	2	\N	\N	54	1	2	f	\N	\N	\N
1334	167	91	1	2	\N	2	\N	\N	55	1	2	f	\N	\N	\N
1335	118	91	1	2	\N	2	\N	\N	56	1	2	f	\N	\N	\N
1336	117	91	1	2	\N	2	\N	\N	57	1	2	f	\N	\N	\N
1337	64	91	1	1	\N	1	\N	\N	58	1	2	f	\N	\N	\N
1338	54	91	1	1	\N	1	\N	\N	59	1	2	f	\N	\N	\N
1339	92	91	1	1	\N	1	\N	\N	60	1	2	f	\N	\N	\N
1340	90	91	1	1	\N	1	\N	\N	61	1	2	f	\N	\N	\N
1341	190	91	1	1	\N	1	\N	\N	62	1	2	f	\N	\N	\N
1342	189	91	1	1	\N	1	\N	\N	63	1	2	f	\N	\N	\N
1343	60	91	1	1	\N	1	\N	\N	64	1	2	f	\N	\N	\N
1344	140	91	1	1	\N	1	\N	\N	65	1	2	f	\N	\N	\N
1345	134	91	1	1	\N	1	\N	\N	66	1	2	f	\N	\N	\N
1346	144	91	1	1	\N	1	\N	\N	67	1	2	f	\N	\N	\N
1347	219	91	1	1	\N	1	\N	\N	68	1	2	f	\N	\N	\N
1348	220	91	1	1	\N	1	\N	\N	69	1	2	f	\N	\N	\N
1349	221	91	1	1	\N	1	\N	\N	70	1	2	f	\N	\N	\N
1350	202	91	1	1	\N	1	\N	\N	71	1	2	f	\N	\N	\N
1351	71	91	1	1	\N	1	\N	\N	72	1	2	f	\N	\N	\N
1352	72	91	1	1	\N	1	\N	\N	73	1	2	f	\N	\N	\N
1353	164	91	1	1	\N	1	\N	\N	74	1	2	f	\N	\N	\N
1354	156	91	1	1	\N	1	\N	\N	75	1	2	f	\N	\N	\N
1355	152	91	1	1	\N	1	\N	\N	76	1	2	f	\N	\N	\N
1356	151	91	1	1	\N	1	\N	\N	77	1	2	f	\N	\N	\N
1357	125	91	1	1	\N	1	\N	\N	78	1	2	f	\N	\N	\N
1358	155	91	1	1	\N	1	\N	\N	79	1	2	f	\N	\N	\N
1359	210	91	1	1	\N	1	\N	\N	80	1	2	f	\N	\N	\N
1360	124	91	1	1	\N	1	\N	\N	81	1	2	f	\N	\N	\N
1361	214	91	1	1	\N	1	\N	\N	82	1	2	f	\N	\N	\N
1362	127	91	1	1	\N	1	\N	\N	83	1	2	f	\N	\N	\N
1363	149	91	1	1	\N	1	\N	\N	84	1	2	f	\N	\N	\N
1364	150	91	1	1	\N	1	\N	\N	85	1	2	f	\N	\N	\N
1365	87	91	1	1	\N	1	\N	\N	86	1	2	f	\N	\N	\N
1366	62	91	1	1	\N	1	\N	\N	87	1	2	f	\N	\N	\N
1367	126	91	1	1	\N	1	\N	\N	88	1	2	f	\N	\N	\N
1368	65	91	1	1	\N	1	\N	\N	89	1	2	f	\N	\N	\N
1369	89	91	1	1	\N	1	\N	\N	90	1	2	f	\N	\N	\N
1370	61	91	1	1	\N	1	\N	\N	91	1	2	f	\N	\N	\N
1371	63	91	1	1	\N	1	\N	\N	92	1	2	f	\N	\N	\N
1372	102	92	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1373	8	92	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1374	196	92	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1375	231	93	2	495	\N	495	\N	\N	1	1	2	f	0	73	\N
1376	73	93	1	495	\N	495	\N	\N	1	1	2	f	\N	231	\N
1377	56	94	2	27978	\N	0	\N	\N	1	1	2	f	27978	\N	\N
1378	161	95	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1379	259	96	2	20493	\N	0	\N	\N	1	1	2	f	20493	\N	\N
1380	118	96	2	13586	\N	0	\N	\N	2	1	2	f	13586	\N	\N
1381	117	96	2	11753	\N	0	\N	\N	3	1	2	f	11753	\N	\N
1382	187	96	2	9283	\N	0	\N	\N	4	1	2	f	9283	\N	\N
1383	167	96	2	8755	\N	0	\N	\N	5	1	2	f	8755	\N	\N
1384	248	96	2	8455	\N	0	\N	\N	6	1	2	f	8455	\N	\N
1385	257	96	2	6443	\N	0	\N	\N	7	1	2	f	6443	\N	\N
1386	89	96	2	5603	\N	0	\N	\N	8	1	2	f	5603	\N	\N
1387	260	96	2	5415	\N	0	\N	\N	9	1	2	f	5415	\N	\N
1388	114	96	2	4415	\N	0	\N	\N	10	1	2	f	4415	\N	\N
1389	70	96	2	3927	\N	0	\N	\N	11	1	2	f	3927	\N	\N
1390	74	96	2	3811	\N	0	\N	\N	12	1	2	f	3811	\N	\N
1391	263	96	2	3407	\N	0	\N	\N	13	1	2	f	3407	\N	\N
1392	65	96	2	3140	\N	0	\N	\N	14	1	2	f	3140	\N	\N
1393	222	96	2	2779	\N	0	\N	\N	15	1	2	f	2779	\N	\N
1394	85	96	2	1689	\N	0	\N	\N	16	1	2	f	1689	\N	\N
1395	121	96	2	1644	\N	0	\N	\N	17	1	2	f	1644	\N	\N
1396	122	96	2	1585	\N	0	\N	\N	18	1	2	f	1585	\N	\N
1397	62	96	2	1365	\N	0	\N	\N	19	1	2	f	1365	\N	\N
1398	240	96	2	1233	\N	0	\N	\N	20	1	2	f	1233	\N	\N
1399	59	96	2	952	\N	0	\N	\N	21	1	2	f	952	\N	\N
1400	87	96	2	641	\N	0	\N	\N	22	1	2	f	641	\N	\N
1401	237	96	2	598	\N	0	\N	\N	23	1	2	f	598	\N	\N
1402	262	96	2	558	\N	0	\N	\N	24	1	2	f	558	\N	\N
1403	258	96	2	315	\N	0	\N	\N	25	1	2	f	315	\N	\N
1404	86	96	2	304	\N	0	\N	\N	26	1	2	f	304	\N	\N
1405	188	96	2	269	\N	0	\N	\N	27	1	2	f	269	\N	\N
1406	217	96	2	229	\N	0	\N	\N	28	1	2	f	229	\N	\N
1407	210	96	2	143	\N	0	\N	\N	29	1	2	f	143	\N	\N
1408	224	96	2	118	\N	0	\N	\N	30	1	2	f	118	\N	\N
1409	176	96	2	108	\N	0	\N	\N	31	1	2	f	108	\N	\N
1410	115	96	2	78	\N	0	\N	\N	32	1	2	f	78	\N	\N
1411	255	96	2	78	\N	0	\N	\N	33	1	2	f	78	\N	\N
1412	215	96	2	48	\N	0	\N	\N	34	1	2	f	48	\N	\N
1413	173	96	2	28	\N	0	\N	\N	35	1	2	f	28	\N	\N
1414	84	96	2	26	\N	0	\N	\N	36	1	2	f	26	\N	\N
1415	211	96	2	21	\N	0	\N	\N	37	1	2	f	21	\N	\N
1416	155	96	2	12	\N	0	\N	\N	38	1	2	f	12	\N	\N
1417	256	96	2	7	\N	0	\N	\N	39	1	2	f	7	\N	\N
1418	164	96	2	5	\N	0	\N	\N	40	1	2	f	5	\N	\N
1419	94	96	2	4	\N	0	\N	\N	41	1	2	f	4	\N	\N
1420	63	96	2	3	\N	0	\N	\N	42	1	2	f	3	\N	\N
1421	220	96	2	2	\N	0	\N	\N	43	1	2	f	2	\N	\N
1422	67	96	2	1	\N	0	\N	\N	44	1	2	f	1	\N	\N
1423	264	96	2	1	\N	0	\N	\N	45	1	2	f	1	\N	\N
1424	75	96	2	1	\N	0	\N	\N	46	1	2	f	1	\N	\N
1425	166	96	2	1	\N	0	\N	\N	47	1	2	f	1	\N	\N
1426	139	96	2	1	\N	0	\N	\N	48	1	2	f	1	\N	\N
1427	229	97	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
1428	123	97	1	12	\N	12	\N	\N	1	1	2	f	\N	229	\N
1429	131	98	2	78	\N	78	\N	\N	0	1	2	f	0	\N	\N
1430	131	98	1	78	\N	78	\N	\N	0	1	2	f	\N	\N	\N
1431	56	99	2	27978	\N	0	\N	\N	1	1	2	f	27978	\N	\N
1432	105	100	2	92871	\N	0	\N	\N	1	1	2	f	92871	\N	\N
1433	131	101	2	63	\N	63	\N	\N	0	1	2	f	0	\N	\N
1434	131	101	1	63	\N	63	\N	\N	0	1	2	f	\N	\N	\N
1435	231	102	2	23592	\N	23592	\N	\N	1	1	2	f	0	\N	\N
1436	19	102	2	9320	\N	9320	\N	\N	2	1	2	f	0	\N	\N
1437	105	102	1	31040	\N	31040	\N	\N	1	1	2	f	\N	\N	\N
1438	147	103	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1439	231	104	2	171402	\N	171402	\N	\N	1	1	2	f	0	\N	\N
1440	267	104	1	86779	\N	86779	\N	\N	1	1	2	f	\N	231	\N
1441	232	104	1	49634	\N	49634	\N	\N	2	1	2	f	\N	231	\N
1442	235	104	1	36722	\N	36722	\N	\N	3	1	2	f	\N	231	\N
1443	3	104	1	188	\N	188	\N	\N	4	1	2	f	\N	231	\N
1444	12	104	1	2	\N	2	\N	\N	0	1	2	f	\N	231	\N
1445	32	105	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1446	10	105	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
1447	231	106	2	25115	\N	25115	\N	\N	1	1	2	f	0	234	\N
1448	19	106	2	16795	\N	16795	\N	\N	2	1	2	f	0	234	\N
1449	234	106	1	41914	\N	41914	\N	\N	1	1	2	f	\N	\N	\N
1450	105	107	2	10	\N	10	\N	\N	1	1	2	f	0	51	\N
1451	51	107	1	10	\N	10	\N	\N	1	1	2	f	\N	105	\N
1452	24	107	1	2	\N	2	\N	\N	0	1	2	f	\N	105	\N
1453	123	108	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
1454	102	108	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1455	8	108	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1456	196	108	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1457	105	109	2	47	\N	47	\N	\N	1	1	2	f	0	51	\N
1458	51	109	1	47	\N	47	\N	\N	1	1	2	f	\N	105	\N
1459	24	109	1	6	\N	6	\N	\N	0	1	2	f	\N	105	\N
1460	105	110	2	427	\N	427	\N	\N	1	1	2	f	0	51	\N
1461	51	110	1	427	\N	427	\N	\N	1	1	2	f	\N	105	\N
1462	24	110	1	105	\N	105	\N	\N	0	1	2	f	\N	105	\N
1463	105	111	2	4987	\N	4987	\N	\N	1	1	2	f	0	51	\N
1464	51	111	1	4987	\N	4987	\N	\N	1	1	2	f	\N	105	\N
1465	24	111	1	1637	\N	1637	\N	\N	0	1	2	f	\N	105	\N
1466	46	112	2	9244	\N	0	\N	\N	1	1	2	f	9244	\N	\N
1467	112	112	2	199	\N	0	\N	\N	0	1	2	f	199	\N	\N
1468	177	112	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
1469	105	113	2	2	\N	2	\N	\N	1	1	2	f	0	51	\N
1470	51	113	1	2	\N	2	\N	\N	1	1	2	f	\N	105	\N
1471	105	114	2	5	\N	5	\N	\N	1	1	2	f	0	51	\N
1472	51	114	1	5	\N	5	\N	\N	1	1	2	f	\N	105	\N
1473	231	115	2	27956	\N	0	\N	\N	1	1	2	f	27956	\N	\N
1474	46	116	2	2936	\N	0	\N	\N	1	1	2	f	2936	\N	\N
1475	112	116	2	58	\N	0	\N	\N	0	1	2	f	58	\N	\N
1476	177	116	2	38	\N	0	\N	\N	0	1	2	f	38	\N	\N
1477	231	117	2	20397	\N	0	\N	\N	1	1	2	f	20397	\N	\N
1478	105	118	2	49581	\N	49581	\N	\N	1	1	2	f	0	51	\N
1479	51	118	1	49581	\N	49581	\N	\N	1	1	2	f	\N	105	\N
1480	24	118	1	26587	\N	26587	\N	\N	0	1	2	f	\N	105	\N
1481	105	119	2	85653	\N	85653	\N	\N	1	1	2	f	0	\N	\N
1482	51	119	1	85651	\N	85651	\N	\N	1	1	2	f	\N	105	\N
1483	24	119	1	38911	\N	38911	\N	\N	0	1	2	f	\N	105	\N
1484	123	120	2	48	\N	48	\N	\N	1	1	2	f	0	\N	\N
1485	96	121	2	187324	\N	187324	\N	\N	1	1	2	f	0	108	\N
1486	108	121	1	187324	\N	187324	\N	\N	1	1	2	f	\N	96	\N
1487	161	122	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1488	231	123	2	23164	\N	23164	\N	\N	1	1	2	f	0	46	\N
1489	19	123	2	198	\N	198	\N	\N	2	1	2	f	0	46	\N
1490	46	123	1	23363	\N	23363	\N	\N	1	1	2	f	\N	\N	\N
1491	177	123	1	586	\N	586	\N	\N	0	1	2	f	\N	\N	\N
1492	112	123	1	149	\N	149	\N	\N	0	1	2	f	\N	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
1	46	231	4847	\N	1	\N
2	47	231	115	\N	1	\N
3	48	235	115	\N	2	\N
4	48	267	4847	\N	1	\N
5	51	234	54909	\N	1	\N
6	52	234	46114	\N	1	\N
7	53	234	42451	\N	1	\N
8	54	234	23249	\N	1	\N
9	55	234	21566	\N	1	\N
10	56	234	19841	\N	1	\N
11	57	234	6675	\N	1	\N
12	58	234	1890	\N	1	\N
13	59	234	1108	\N	1	\N
14	60	234	595	\N	1	\N
15	61	234	494	\N	1	\N
16	62	234	283	\N	1	\N
17	63	234	259	\N	1	\N
18	64	234	201	\N	1	\N
19	65	234	196	\N	1	\N
20	66	234	188	\N	1	\N
21	67	234	106	\N	1	\N
22	68	234	92	\N	1	\N
23	69	234	83	\N	1	\N
24	70	234	79	\N	1	\N
25	71	234	67	\N	1	\N
26	72	234	65	\N	1	\N
27	73	234	65	\N	1	\N
28	74	234	65	\N	1	\N
29	75	234	64	\N	1	\N
30	76	234	57	\N	1	\N
31	77	234	48	\N	1	\N
32	78	234	47	\N	1	\N
33	79	234	45	\N	1	\N
34	80	234	42	\N	1	\N
35	81	234	42	\N	1	\N
36	82	234	37	\N	1	\N
37	83	234	33	\N	1	\N
38	84	234	32	\N	1	\N
39	85	234	29	\N	1	\N
40	86	234	29	\N	1	\N
41	87	234	27	\N	1	\N
42	88	234	23	\N	1	\N
43	89	234	21	\N	1	\N
44	90	234	21	\N	1	\N
45	91	234	21	\N	1	\N
46	92	234	20	\N	1	\N
47	93	234	18	\N	1	\N
48	94	234	17	\N	1	\N
49	95	234	16	\N	1	\N
50	96	234	16	\N	1	\N
51	97	234	16	\N	1	\N
52	98	234	15	\N	1	\N
53	99	234	14	\N	1	\N
54	100	234	13	\N	1	\N
55	101	234	13	\N	1	\N
56	102	234	11	\N	1	\N
57	103	234	11	\N	1	\N
58	104	234	11	\N	1	\N
59	105	234	10	\N	1	\N
60	106	234	10	\N	1	\N
61	107	234	10	\N	1	\N
62	108	234	9	\N	1	\N
63	109	234	9	\N	1	\N
64	110	234	8	\N	1	\N
65	111	234	7	\N	1	\N
66	112	234	6	\N	1	\N
67	113	234	6	\N	1	\N
68	114	234	5	\N	1	\N
69	115	234	5	\N	1	\N
70	116	234	4	\N	1	\N
71	117	234	4	\N	1	\N
72	118	234	4	\N	1	\N
73	119	234	3	\N	1	\N
74	120	234	3	\N	1	\N
75	121	234	3	\N	1	\N
76	122	234	3	\N	1	\N
77	123	234	2	\N	1	\N
78	124	234	2	\N	1	\N
79	125	234	2	\N	1	\N
80	126	234	2	\N	1	\N
81	127	234	2	\N	1	\N
82	128	234	2	\N	1	\N
83	129	234	1	\N	1	\N
84	130	234	1	\N	1	\N
85	131	234	1	\N	1	\N
86	132	234	1	\N	1	\N
87	133	234	1	\N	1	\N
88	134	234	1	\N	1	\N
89	135	234	1	\N	1	\N
90	136	234	1	\N	1	\N
91	137	234	1	\N	1	\N
92	138	234	1	\N	1	\N
93	139	234	1	\N	1	\N
94	140	234	1	\N	1	\N
95	141	234	1	\N	1	\N
96	142	234	1	\N	1	\N
97	143	234	1	\N	1	\N
98	144	234	1	\N	1	\N
99	145	234	1	\N	1	\N
100	146	234	1	\N	1	\N
101	147	234	1	\N	1	\N
102	148	234	1	\N	1	\N
103	149	234	1	\N	1	\N
104	150	234	1	\N	1	\N
105	151	234	1	\N	1	\N
106	152	234	1	\N	1	\N
107	153	234	1	\N	1	\N
108	154	12	6675	\N	7	\N
109	154	130	32	\N	34	\N
110	154	129	1	\N	79	\N
111	154	128	33	\N	33	\N
112	154	18	2	\N	73	\N
113	154	146	1	\N	80	\N
114	154	16	1	\N	81	\N
115	154	15	45	\N	29	\N
116	154	136	20	\N	42	\N
117	154	17	21	\N	39	\N
118	154	142	595	\N	10	\N
119	154	6	83	\N	19	\N
120	154	5	11	\N	52	\N
121	154	7	4	\N	66	\N
122	154	2	201	\N	14	\N
123	154	1	42	\N	30	\N
124	154	4	21	\N	40	\N
125	154	3	188	\N	16	\N
126	154	119	23249	\N	4	\N
127	154	9	2	\N	74	\N
128	154	120	21	\N	41	\N
129	154	39	1	\N	82	\N
130	154	179	27	\N	37	\N
131	154	35	283	\N	12	\N
132	154	180	2	\N	75	\N
133	154	36	1	\N	83	\N
134	154	45	2	\N	76	\N
135	154	195	6	\N	62	\N
136	154	44	1	\N	84	\N
137	154	42	1	\N	85	\N
138	154	41	42	\N	31	\N
139	154	185	1	\N	86	\N
140	154	40	18	\N	43	\N
141	154	191	16	\N	45	\N
142	154	22	37	\N	32	\N
143	154	157	1	\N	87	\N
144	154	21	259	\N	13	\N
145	154	163	79	\N	20	\N
146	154	159	1	\N	88	\N
147	154	154	5	\N	64	\N
148	154	153	10	\N	55	\N
149	154	20	3	\N	69	\N
150	154	34	92	\N	18	\N
151	154	33	29	\N	35	\N
152	154	31	13	\N	50	\N
153	154	168	65	\N	22	\N
154	154	25	16	\N	46	\N
155	154	175	1	\N	89	\N
156	154	172	1	\N	90	\N
157	154	30	16	\N	47	\N
158	154	169	1	\N	91	\N
159	154	216	29	\N	36	\N
160	154	213	64	\N	25	\N
161	154	88	1	\N	92	\N
162	154	77	1108	\N	9	\N
163	154	78	47	\N	28	\N
164	154	207	2	\N	77	\N
165	154	206	23	\N	38	\N
166	154	82	106	\N	17	\N
167	154	81	5	\N	65	\N
168	154	208	4	\N	67	\N
169	154	80	1	\N	93	\N
170	154	96	21566	\N	5	\N
171	154	228	1	\N	94	\N
172	154	93	196	\N	15	\N
173	154	225	8	\N	60	\N
174	154	91	3	\N	70	\N
175	154	199	11	\N	53	\N
176	154	57	65	\N	23	\N
177	154	49	1	\N	95	\N
178	154	48	13	\N	51	\N
179	154	197	1	\N	96	\N
180	154	47	2	\N	78	\N
181	154	50	11	\N	54	\N
182	154	198	48	\N	27	\N
183	154	73	494	\N	11	\N
184	154	205	10	\N	56	\N
185	154	200	1	\N	97	\N
186	154	68	67	\N	21	\N
187	154	69	10	\N	57	\N
188	154	109	1	\N	98	\N
189	154	254	3	\N	71	\N
190	154	111	4	\N	68	\N
191	154	267	46114	\N	2	\N
192	154	261	3	\N	72	\N
193	154	265	1890	\N	8	\N
194	154	100	57	\N	26	\N
195	154	238	14	\N	49	\N
196	154	98	1	\N	99	\N
197	154	235	19841	\N	6	\N
198	154	97	9	\N	58	\N
199	154	236	17	\N	44	\N
200	154	103	1	\N	100	\N
201	154	230	42451	\N	3	\N
202	154	232	54909	\N	1	\N
203	154	233	6	\N	63	\N
204	154	106	9	\N	59	\N
205	154	252	1	\N	101	\N
206	154	107	1	\N	102	\N
207	154	250	65	\N	24	\N
208	154	249	1	\N	103	\N
209	154	247	7	\N	61	\N
210	154	251	15	\N	48	\N
211	155	56	27978	\N	1	\N
212	156	231	27978	\N	1	\N
213	157	150	670	\N	3	\N
214	157	149	505	\N	4	\N
215	157	152	80	\N	7	\N
216	157	151	79	\N	8	\N
217	157	125	212	\N	6	\N
218	157	124	230	\N	5	\N
219	157	127	2158	\N	1	\N
220	157	126	2140	\N	2	\N
221	158	231	2158	\N	1	\N
222	159	231	2140	\N	1	\N
223	160	231	670	\N	1	\N
224	161	231	505	\N	1	\N
225	162	231	230	\N	1	\N
226	163	231	212	\N	1	\N
227	164	231	80	\N	1	\N
228	165	231	79	\N	1	\N
229	167	177	28	\N	0	\N
230	167	112	152	\N	0	\N
231	167	46	23837	\N	1	\N
232	168	112	7	\N	0	\N
233	168	46	260	\N	1	\N
234	169	231	23837	\N	1	\N
235	169	19	260	\N	2	\N
236	170	231	152	\N	1	\N
237	170	19	7	\N	2	\N
238	171	231	28	\N	1	\N
239	172	170	4564	\N	1	\N
240	173	170	21	\N	1	\N
241	174	177	21	\N	0	\N
242	174	46	4564	\N	1	\N
243	177	230	24454	\N	1	\N
244	178	230	17199	\N	1	\N
245	179	231	24454	\N	1	\N
246	179	19	17199	\N	2	\N
247	180	112	2042	\N	0	\N
248	180	46	40849	\N	1	\N
249	180	177	2667	\N	0	\N
250	181	177	347	\N	0	\N
251	181	46	26092	\N	1	\N
252	181	112	682	\N	0	\N
253	182	112	168	\N	0	\N
254	182	46	23483	\N	1	\N
255	182	177	31	\N	0	\N
256	183	177	618	\N	0	\N
257	183	112	153	\N	0	\N
258	183	46	23190	\N	1	\N
259	184	46	13784	\N	1	\N
260	184	112	1069	\N	0	\N
261	184	177	316	\N	0	\N
262	185	177	314	\N	0	\N
263	185	46	8504	\N	1	\N
264	185	112	131	\N	0	\N
265	186	46	1235	\N	1	\N
266	187	177	20	\N	0	\N
267	187	46	495	\N	1	\N
268	188	177	2	\N	0	\N
269	188	46	494	\N	1	\N
270	189	235	13784	\N	5	\N
271	189	232	40849	\N	1	\N
272	189	230	23483	\N	3	\N
273	189	77	1235	\N	7	\N
274	189	267	26092	\N	2	\N
275	189	95	8504	\N	6	\N
276	189	73	494	\N	9	\N
277	189	28	495	\N	8	\N
278	189	119	23190	\N	4	\N
279	190	119	618	\N	2	\N
280	190	28	20	\N	7	\N
281	190	267	347	\N	3	\N
282	190	95	314	\N	5	\N
283	190	73	2	\N	8	\N
284	190	232	2667	\N	1	\N
285	190	230	31	\N	6	\N
286	190	235	316	\N	4	\N
287	191	232	2042	\N	1	\N
288	191	230	168	\N	4	\N
289	191	235	1069	\N	2	\N
290	191	119	153	\N	5	\N
291	191	267	682	\N	3	\N
292	191	95	131	\N	6	\N
293	199	77	1260	\N	1	\N
294	200	231	1260	\N	1	\N
295	201	211	25492	\N	2	\N
296	201	85	1708	\N	22	\N
297	201	209	25509	\N	1	\N
298	201	210	267	\N	40	\N
299	201	84	26	\N	55	\N
300	201	87	653	\N	29	\N
301	201	217	230	\N	41	\N
302	201	214	411	\N	34	\N
303	201	86	306	\N	38	\N
304	201	215	48	\N	50	\N
305	201	221	4	\N	66	\N
306	201	89	2496	\N	18	\N
307	201	220	7	\N	62	\N
308	201	222	2844	\N	17	\N
309	201	138	752	\N	27	\N
310	201	137	2	\N	70	\N
311	201	224	127	\N	45	\N
312	201	139	751	\N	28	\N
313	201	94	4	\N	64	\N
314	201	226	109	\N	46	\N
315	201	227	9137	\N	5	\N
316	201	145	2	\N	67	\N
317	201	53	17	\N	57	\N
318	201	55	2	\N	68	\N
319	201	115	32	\N	53	\N
320	201	114	2365	\N	19	\N
321	201	75	597	\N	30	\N
322	201	74	4118	\N	13	\N
323	201	62	1383	\N	24	\N
324	201	117	5181	\N	9	\N
325	201	61	317	\N	36	\N
326	201	59	968	\N	25	\N
327	201	202	17	\N	56	\N
328	201	63	22142	\N	3	\N
329	201	118	315	\N	37	\N
330	201	66	2	\N	69	\N
331	201	67	1	\N	72	\N
332	201	65	3868	\N	16	\N
333	201	72	16	\N	60	\N
334	201	122	1587	\N	23	\N
335	201	121	1789	\N	21	\N
336	201	70	3928	\N	15	\N
337	201	71	16	\N	59	\N
338	201	256	16	\N	58	\N
339	201	255	78	\N	48	\N
340	201	258	4928	\N	10	\N
341	201	257	8358	\N	6	\N
342	201	260	5821	\N	8	\N
343	201	259	7627	\N	7	\N
344	201	262	903	\N	26	\N
345	201	264	460	\N	32	\N
346	201	188	269	\N	39	\N
347	201	187	13571	\N	4	\N
348	201	263	4074	\N	14	\N
349	201	266	460	\N	33	\N
350	201	156	47	\N	52	\N
351	201	237	91	\N	47	\N
352	201	155	135	\N	44	\N
353	201	158	1	\N	71	\N
354	201	162	166	\N	42	\N
355	201	241	7	\N	63	\N
356	201	240	1873	\N	20	\N
357	201	164	47	\N	51	\N
358	201	244	14	\N	61	\N
359	201	242	4	\N	65	\N
360	201	166	596	\N	31	\N
361	201	246	392	\N	35	\N
362	201	248	4168	\N	12	\N
363	201	167	4668	\N	11	\N
364	201	173	161	\N	43	\N
365	201	171	28	\N	54	\N
366	201	176	78	\N	49	\N
367	202	89	3122	\N	9	\N
368	202	211	1	\N	18	\N
369	202	226	916	\N	11	\N
370	202	227	40852	\N	1	\N
371	202	115	46	\N	15	\N
372	202	114	2097	\N	10	\N
373	202	61	34886	\N	2	\N
374	202	117	11446	\N	6	\N
375	202	118	13269	\N	3	\N
376	202	63	13060	\N	4	\N
377	202	258	254	\N	13	\N
378	202	257	172	\N	14	\N
379	202	259	12868	\N	5	\N
380	202	237	507	\N	12	\N
381	202	176	30	\N	16	\N
382	202	166	1	\N	17	\N
383	202	248	8223	\N	7	\N
384	202	167	4384	\N	8	\N
385	203	19	40852	\N	1	\N
386	203	231	9137	\N	2	\N
387	204	231	317	\N	2	\N
388	204	19	34886	\N	1	\N
389	205	231	22142	\N	1	\N
390	205	19	13060	\N	2	\N
391	206	231	25509	\N	1	\N
392	207	231	25492	\N	1	\N
393	207	19	1	\N	2	\N
394	208	19	12868	\N	1	\N
395	208	231	7627	\N	2	\N
396	209	231	5181	\N	2	\N
397	209	19	11446	\N	1	\N
398	210	231	315	\N	2	\N
399	210	19	13269	\N	1	\N
400	211	231	13571	\N	1	\N
401	212	231	4168	\N	2	\N
402	212	19	8223	\N	1	\N
403	213	231	4668	\N	1	\N
404	213	19	4384	\N	2	\N
405	214	19	172	\N	2	\N
406	214	231	8358	\N	1	\N
407	215	231	5821	\N	1	\N
408	216	19	3122	\N	1	\N
409	216	231	2496	\N	2	\N
410	217	19	254	\N	2	\N
411	217	231	4928	\N	1	\N
412	218	19	2097	\N	2	\N
413	218	231	2365	\N	1	\N
414	219	231	4118	\N	1	\N
415	220	231	4074	\N	1	\N
416	221	231	3928	\N	1	\N
417	222	231	3868	\N	1	\N
418	223	231	2844	\N	1	\N
419	224	231	1873	\N	1	\N
420	225	231	1789	\N	1	\N
421	226	231	1708	\N	1	\N
422	227	231	1587	\N	1	\N
423	228	231	1383	\N	1	\N
424	229	19	916	\N	1	\N
425	229	231	109	\N	2	\N
426	230	231	968	\N	1	\N
427	231	231	903	\N	1	\N
428	232	231	752	\N	1	\N
429	233	231	751	\N	1	\N
430	234	231	653	\N	1	\N
431	235	231	91	\N	2	\N
432	235	19	507	\N	1	\N
433	236	231	597	\N	1	\N
434	237	231	596	\N	1	\N
435	237	19	1	\N	2	\N
436	238	231	460	\N	1	\N
437	239	231	460	\N	1	\N
438	240	231	411	\N	1	\N
439	241	231	392	\N	1	\N
440	242	231	306	\N	1	\N
441	243	231	269	\N	1	\N
442	244	231	267	\N	1	\N
443	245	231	230	\N	1	\N
444	246	231	166	\N	1	\N
445	247	231	161	\N	1	\N
446	248	231	135	\N	1	\N
447	249	231	127	\N	1	\N
448	250	19	30	\N	2	\N
449	250	231	78	\N	1	\N
450	251	19	46	\N	1	\N
451	251	231	32	\N	2	\N
452	252	231	78	\N	1	\N
453	253	231	48	\N	1	\N
454	254	231	47	\N	1	\N
455	255	231	47	\N	1	\N
456	256	231	28	\N	1	\N
457	257	231	26	\N	1	\N
458	258	231	17	\N	1	\N
459	259	231	17	\N	1	\N
460	260	231	16	\N	1	\N
461	261	231	16	\N	1	\N
462	262	231	16	\N	1	\N
463	263	231	14	\N	1	\N
464	264	231	7	\N	1	\N
465	265	231	7	\N	1	\N
466	266	231	4	\N	1	\N
467	267	231	4	\N	1	\N
468	268	231	4	\N	1	\N
469	269	231	2	\N	1	\N
470	270	231	2	\N	1	\N
471	271	231	2	\N	1	\N
472	272	231	2	\N	1	\N
473	273	231	1	\N	1	\N
474	274	231	1	\N	1	\N
475	275	10	2	\N	1	\N
476	275	147	1	\N	2	\N
477	276	10	2	\N	1	\N
478	276	147	1	\N	2	\N
479	277	10	2	\N	1	\N
480	277	147	1	\N	2	\N
481	278	196	2	\N	1	\N
482	278	102	2	\N	0	\N
483	278	8	2	\N	0	\N
484	279	196	1	\N	1	\N
485	279	102	1	\N	0	\N
486	279	8	1	\N	0	\N
487	280	27	4054	\N	1	\N
488	281	27	456	\N	1	\N
489	282	267	4054	\N	1	\N
490	282	232	456	\N	2	\N
491	287	105	47246	\N	1	\N
492	288	105	27978	\N	1	\N
493	289	19	47246	\N	1	\N
494	289	231	27978	\N	2	\N
495	290	10	2	\N	1	\N
496	293	10	2	\N	1	\N
497	296	131	2	\N	0	\N
498	296	10	2	\N	1	\N
499	297	234	18902	\N	6	\N
500	297	232	2470	\N	10	\N
501	297	46	93811	\N	2	\N
502	297	12	7255	\N	8	\N
503	297	13	81981	\N	3	\N
504	297	235	12045	\N	7	\N
505	297	112	2086	\N	0	\N
506	297	27	68	\N	11	\N
507	297	28	36012	\N	5	\N
508	297	267	7085	\N	9	\N
509	297	253	36708	\N	4	\N
510	297	95	98786	\N	1	\N
511	297	177	4548	\N	0	\N
512	298	182	98786	\N	1	\N
513	299	182	93811	\N	1	\N
514	300	182	81981	\N	1	\N
515	301	182	36708	\N	1	\N
516	302	182	36012	\N	1	\N
517	303	182	18902	\N	1	\N
518	304	182	12045	\N	1	\N
519	305	182	7255	\N	1	\N
520	306	182	7085	\N	1	\N
521	307	182	2470	\N	1	\N
522	308	182	68	\N	1	\N
523	309	182	4548	\N	1	\N
524	310	182	2086	\N	1	\N
525	311	102	1	\N	1	\N
526	311	8	1	\N	0	\N
527	311	196	1	\N	0	\N
528	312	161	1	\N	1	\N
529	313	161	1	\N	1	\N
530	314	161	1	\N	1	\N
531	324	12	27691	\N	1	\N
532	324	267	4	\N	0	\N
533	324	232	8	\N	0	\N
534	325	231	27691	\N	1	\N
535	326	231	8	\N	1	\N
536	327	231	4	\N	1	\N
537	328	234	61354	\N	1	\N
538	329	177	720	\N	0	\N
539	329	112	937	\N	0	\N
540	329	46	9475	\N	1	\N
541	330	13	2130	\N	1	\N
542	331	148	1214	\N	1	\N
543	332	28	542	\N	1	\N
544	333	46	196	\N	1	\N
545	333	112	3	\N	0	\N
546	334	46	46	\N	1	\N
547	334	177	2	\N	0	\N
548	334	112	42	\N	0	\N
549	335	234	61354	\N	1	\N
550	336	177	46	\N	0	\N
551	336	112	196	\N	0	\N
552	336	46	9475	\N	1	\N
553	337	13	2130	\N	1	\N
554	338	148	1214	\N	1	\N
555	339	28	542	\N	1	\N
556	340	46	937	\N	1	\N
557	340	177	42	\N	0	\N
558	340	112	3	\N	0	\N
559	341	46	720	\N	1	\N
560	341	177	2	\N	0	\N
561	342	10	16	\N	1	\N
562	342	147	12	\N	2	\N
563	343	10	2	\N	1	\N
564	343	147	1	\N	2	\N
565	344	10	2	\N	1	\N
566	344	147	1	\N	2	\N
567	345	10	2	\N	1	\N
568	345	147	1	\N	2	\N
569	346	123	16	\N	1	\N
570	346	196	2	\N	2	\N
571	346	102	2	\N	0	\N
572	346	8	2	\N	0	\N
573	347	123	12	\N	1	\N
574	347	196	1	\N	2	\N
575	347	102	1	\N	0	\N
576	347	8	1	\N	0	\N
577	351	229	14	\N	1	\N
578	352	229	14	\N	1	\N
579	353	229	14	\N	1	\N
580	354	196	14	\N	1	\N
581	354	102	14	\N	0	\N
582	354	8	14	\N	0	\N
583	361	231	24	\N	1	\N
584	363	99	24	\N	1	\N
585	369	231	57590	\N	1	\N
586	370	231	544	\N	1	\N
587	371	19	57590	\N	1	\N
588	371	231	544	\N	2	\N
589	375	95	45234	\N	1	\N
590	376	95	24861	\N	1	\N
591	377	95	18178	\N	1	\N
592	378	95	16155	\N	1	\N
593	379	95	6676	\N	1	\N
594	380	95	188	\N	1	\N
595	381	95	60	\N	1	\N
596	382	232	45234	\N	1	\N
597	382	3	188	\N	6	\N
598	382	231	24861	\N	2	\N
599	382	29	60	\N	7	\N
600	382	19	18178	\N	3	\N
601	382	267	6676	\N	5	\N
602	382	235	16155	\N	4	\N
603	383	148	104509	\N	1	\N
604	384	231	104509	\N	1	\N
605	386	112	23801	\N	1	\N
606	386	46	23801	\N	0	\N
607	387	112	260	\N	1	\N
608	387	46	260	\N	0	\N
609	388	231	23801	\N	1	\N
610	388	19	260	\N	2	\N
611	389	231	23801	\N	1	\N
612	389	19	260	\N	2	\N
613	390	234	23690	\N	1	\N
614	391	234	51	\N	1	\N
615	392	19	51	\N	2	\N
616	392	231	23690	\N	1	\N
617	406	243	46429	\N	1	\N
618	407	243	27978	\N	1	\N
619	408	243	10	\N	1	\N
620	409	243	8	\N	1	\N
621	410	243	8	\N	1	\N
622	411	243	6	\N	1	\N
623	412	243	6	\N	1	\N
624	413	243	5	\N	1	\N
625	414	243	5	\N	1	\N
626	415	243	5	\N	1	\N
627	416	243	4	\N	1	\N
628	417	243	4	\N	1	\N
629	418	243	4	\N	1	\N
630	419	243	4	\N	1	\N
631	420	243	4	\N	1	\N
632	421	243	4	\N	1	\N
633	422	243	4	\N	1	\N
634	423	243	4	\N	1	\N
635	424	243	4	\N	1	\N
636	425	243	3	\N	1	\N
637	426	243	3	\N	1	\N
638	427	243	3	\N	1	\N
639	428	243	3	\N	1	\N
640	429	243	3	\N	1	\N
641	430	243	3	\N	1	\N
642	431	243	3	\N	1	\N
643	432	243	3	\N	1	\N
644	433	243	3	\N	1	\N
645	434	243	2	\N	1	\N
646	435	243	2	\N	1	\N
647	436	243	2	\N	1	\N
648	437	243	2	\N	1	\N
649	438	243	2	\N	1	\N
650	439	243	2	\N	1	\N
651	440	243	2	\N	1	\N
652	441	243	2	\N	1	\N
653	442	243	2	\N	1	\N
654	443	243	2	\N	1	\N
655	444	243	2	\N	1	\N
656	445	243	2	\N	1	\N
657	446	243	2	\N	1	\N
658	447	243	2	\N	1	\N
659	448	243	2	\N	1	\N
660	449	243	2	\N	1	\N
661	450	243	2	\N	1	\N
662	451	243	2	\N	1	\N
663	452	243	2	\N	1	\N
664	453	243	2	\N	1	\N
665	454	243	2	\N	1	\N
666	455	243	2	\N	1	\N
667	456	243	2	\N	1	\N
668	457	243	2	\N	1	\N
669	458	243	2	\N	1	\N
670	459	243	2	\N	1	\N
671	460	243	2	\N	1	\N
672	461	243	2	\N	1	\N
673	462	243	2	\N	1	\N
674	463	243	2	\N	1	\N
675	464	243	2	\N	1	\N
676	465	243	2	\N	1	\N
677	466	243	2	\N	1	\N
678	467	243	2	\N	1	\N
679	468	243	2	\N	1	\N
680	469	243	2	\N	1	\N
681	470	243	2	\N	1	\N
682	471	243	2	\N	1	\N
683	472	243	2	\N	1	\N
684	473	243	2	\N	1	\N
685	474	243	2	\N	1	\N
686	475	243	2	\N	1	\N
687	476	243	2	\N	1	\N
688	477	243	1	\N	1	\N
689	478	243	1	\N	1	\N
690	479	243	1	\N	1	\N
691	480	243	1	\N	1	\N
692	481	243	1	\N	1	\N
693	482	243	1	\N	1	\N
694	483	243	1	\N	1	\N
695	484	243	1	\N	1	\N
696	485	243	1	\N	1	\N
697	486	243	1	\N	1	\N
698	487	243	1	\N	1	\N
699	488	243	1	\N	1	\N
700	489	243	1	\N	1	\N
701	490	243	1	\N	1	\N
702	491	243	1	\N	1	\N
703	492	243	106	\N	1	\N
704	493	87	2	\N	61	\N
705	493	217	2	\N	55	\N
706	493	131	106	\N	0	\N
707	493	214	2	\N	58	\N
708	493	215	2	\N	51	\N
709	493	212	2	\N	37	\N
710	493	211	5	\N	9	\N
711	493	209	5	\N	10	\N
712	493	210	1	\N	82	\N
713	493	135	2	\N	38	\N
714	493	221	1	\N	76	\N
715	493	134	2	\N	29	\N
716	493	220	1	\N	75	\N
717	493	89	1	\N	84	\N
718	493	133	2	\N	39	\N
719	493	219	1	\N	72	\N
720	493	218	3	\N	20	\N
721	493	132	2	\N	40	\N
722	493	140	1	\N	73	\N
723	493	224	4	\N	13	\N
724	493	223	8	\N	4	\N
725	493	139	2	\N	62	\N
726	493	90	2	\N	30	\N
727	493	222	2	\N	65	\N
728	493	137	2	\N	50	\N
729	493	227	3	\N	28	\N
730	493	144	2	\N	31	\N
731	493	143	2	\N	41	\N
732	493	92	2	\N	32	\N
733	493	226	3	\N	26	\N
734	493	54	2	\N	33	\N
735	493	52	4	\N	11	\N
736	493	113	6	\N	7	\N
737	493	64	2	\N	34	\N
738	493	202	1	\N	77	\N
739	493	63	1	\N	86	\N
740	493	118	2	\N	70	\N
741	493	201	4	\N	12	\N
742	493	61	1	\N	85	\N
743	493	62	1	\N	83	\N
744	493	117	2	\N	71	\N
745	493	60	2	\N	35	\N
746	493	116	10	\N	3	\N
747	493	122	2	\N	63	\N
748	493	72	1	\N	79	\N
749	493	70	2	\N	67	\N
750	493	71	1	\N	78	\N
751	493	121	2	\N	64	\N
752	493	67	2	\N	49	\N
753	493	65	2	\N	66	\N
754	493	75	2	\N	59	\N
755	493	74	2	\N	68	\N
756	493	256	3	\N	23	\N
757	493	259	4	\N	19	\N
758	493	183	6	\N	6	\N
759	493	258	4	\N	16	\N
760	493	257	4	\N	17	\N
761	493	188	3	\N	25	\N
762	493	264	2	\N	57	\N
763	493	187	3	\N	27	\N
764	493	263	4	\N	15	\N
765	493	186	2	\N	42	\N
766	493	262	5	\N	8	\N
767	493	184	2	\N	43	\N
768	493	193	2	\N	44	\N
769	493	192	2	\N	45	\N
770	493	190	2	\N	36	\N
771	493	189	1	\N	74	\N
772	493	194	3	\N	21	\N
773	493	19	46429	\N	1	\N
774	493	231	27978	\N	2	\N
775	493	239	2	\N	46	\N
776	493	237	8	\N	5	\N
777	493	156	1	\N	81	\N
778	493	155	2	\N	53	\N
779	493	164	1	\N	80	\N
780	493	162	2	\N	54	\N
781	493	160	2	\N	47	\N
782	493	240	4	\N	14	\N
783	493	167	2	\N	69	\N
784	493	248	4	\N	18	\N
785	493	166	2	\N	60	\N
786	493	165	2	\N	48	\N
787	493	246	2	\N	56	\N
788	493	176	2	\N	52	\N
789	493	174	3	\N	22	\N
790	493	173	3	\N	24	\N
791	494	119	1	\N	7	\N
792	494	28	1	\N	3	\N
793	494	61	1	\N	9	\N
794	494	46	1	\N	5	\N
795	494	105	1	\N	11	\N
796	494	234	1	\N	10	\N
797	494	10	1	\N	1	\N
798	494	231	1	\N	8	\N
799	494	95	1	\N	6	\N
800	494	253	1	\N	2	\N
801	494	148	1	\N	4	\N
802	495	123	1	\N	1	\N
803	496	123	1	\N	1	\N
804	497	123	1	\N	1	\N
805	498	123	1	\N	1	\N
806	499	123	1	\N	1	\N
807	500	123	1	\N	1	\N
808	501	123	1	\N	1	\N
809	502	123	1	\N	1	\N
810	503	123	1	\N	1	\N
811	504	123	1	\N	1	\N
812	505	123	1	\N	1	\N
813	506	232	49634	\N	2	\N
814	506	63	16737	\N	4	\N
815	506	61	13018	\N	5	\N
816	506	267	73134	\N	1	\N
817	506	12	2	\N	0	\N
818	506	235	36722	\N	3	\N
819	507	96	73134	\N	1	\N
820	508	96	49634	\N	1	\N
821	509	96	36722	\N	1	\N
822	510	96	16737	\N	1	\N
823	511	96	13018	\N	1	\N
824	512	96	2	\N	1	\N
825	513	123	12	\N	1	\N
826	514	229	12	\N	1	\N
827	722	28	41007	\N	1	\N
828	723	231	41007	\N	1	\N
829	724	105	7223	\N	1	\N
830	725	105	157	\N	1	\N
831	726	19	7223	\N	1	\N
832	726	231	157	\N	2	\N
833	727	128	35	\N	26	\N
834	727	129	1	\N	54	\N
835	727	130	74	\N	18	\N
836	727	142	1426	\N	1	\N
837	727	17	20	\N	32	\N
838	727	136	55	\N	22	\N
839	727	16	1	\N	55	\N
840	727	146	1	\N	56	\N
841	727	4	59	\N	21	\N
842	727	1	214	\N	9	\N
843	727	2	455	\N	3	\N
844	727	7	26	\N	31	\N
845	727	6	167	\N	11	\N
846	727	5	14	\N	36	\N
847	727	120	142	\N	14	\N
848	727	180	3	\N	45	\N
849	727	35	145	\N	13	\N
850	727	39	1	\N	57	\N
851	727	191	3	\N	49	\N
852	727	41	27	\N	30	\N
853	727	185	1	\N	58	\N
854	727	40	36	\N	25	\N
855	727	42	1	\N	59	\N
856	727	45	2	\N	51	\N
857	727	195	7	\N	39	\N
858	727	154	5	\N	43	\N
859	727	153	14	\N	35	\N
860	727	20	2	\N	52	\N
861	727	159	1	\N	60	\N
862	727	163	327	\N	6	\N
863	727	21	1094	\N	2	\N
864	727	22	127	\N	15	\N
865	727	157	1	\N	61	\N
866	727	172	1	\N	62	\N
867	727	169	1	\N	63	\N
868	727	30	3	\N	50	\N
869	727	175	1	\N	64	\N
870	727	168	159	\N	12	\N
871	727	31	18	\N	33	\N
872	727	34	352	\N	5	\N
873	727	33	72	\N	19	\N
874	727	81	6	\N	41	\N
875	727	80	1	\N	65	\N
876	727	82	182	\N	10	\N
877	727	206	67	\N	20	\N
878	727	78	86	\N	17	\N
879	727	207	1	\N	74	\N
880	727	88	1	\N	66	\N
881	727	216	32	\N	27	\N
882	727	213	7	\N	40	\N
883	727	93	427	\N	4	\N
884	727	91	3	\N	46	\N
885	727	225	12	\N	37	\N
886	727	228	1	\N	67	\N
887	727	198	39	\N	24	\N
888	727	197	1	\N	68	\N
889	727	57	264	\N	7	\N
890	727	199	12	\N	38	\N
891	727	68	1	\N	75	\N
892	727	205	17	\N	34	\N
893	727	254	5	\N	42	\N
894	727	109	1	\N	69	\N
895	727	265	235	\N	8	\N
896	727	261	3	\N	47	\N
897	727	111	4	\N	44	\N
898	727	233	29	\N	29	\N
899	727	103	1	\N	70	\N
900	727	98	1	\N	71	\N
901	727	238	30	\N	28	\N
902	727	100	44	\N	23	\N
903	727	251	2	\N	53	\N
904	727	250	88	\N	16	\N
905	727	249	1	\N	72	\N
906	727	106	3	\N	48	\N
907	727	252	1	\N	73	\N
908	728	9	2	\N	40	\N
909	728	2	155	\N	5	\N
910	728	6	33	\N	11	\N
911	728	5	2	\N	42	\N
912	728	7	3	\N	39	\N
913	728	15	45	\N	10	\N
914	728	142	576	\N	2	\N
915	728	17	10	\N	32	\N
916	728	18	1	\N	46	\N
917	728	128	14	\N	26	\N
918	728	130	24	\N	18	\N
919	728	168	24	\N	19	\N
920	728	25	27	\N	15	\N
921	728	30	13	\N	28	\N
922	728	34	28	\N	14	\N
923	728	33	21	\N	21	\N
924	728	20	11	\N	29	\N
925	728	21	417	\N	3	\N
926	728	163	25	\N	17	\N
927	728	41	22	\N	20	\N
928	728	191	14	\N	25	\N
929	728	44	1	\N	43	\N
930	728	179	28	\N	13	\N
931	728	35	249	\N	4	\N
932	728	200	1	\N	44	\N
933	728	68	69	\N	7	\N
934	728	69	11	\N	30	\N
935	728	47	2	\N	41	\N
936	728	48	13	\N	27	\N
937	728	198	20	\N	22	\N
938	728	50	11	\N	31	\N
939	728	93	145	\N	6	\N
940	728	207	4	\N	37	\N
941	728	208	4	\N	38	\N
942	728	82	66	\N	8	\N
943	728	216	25	\N	16	\N
944	728	213	58	\N	9	\N
945	728	247	7	\N	34	\N
946	728	251	18	\N	23	\N
947	728	106	6	\N	35	\N
948	728	107	1	\N	45	\N
949	728	233	5	\N	36	\N
950	728	236	18	\N	24	\N
951	728	97	9	\N	33	\N
952	728	100	29	\N	12	\N
953	728	265	2116	\N	1	\N
954	729	18	1	\N	3	\N
955	729	36	1	\N	1	\N
956	729	21	1	\N	5	\N
957	729	78	1	\N	4	\N
958	729	49	1	\N	2	\N
959	729	265	1	\N	6	\N
960	730	235	235	\N	2	\N
961	730	232	1	\N	3	\N
962	730	267	2116	\N	1	\N
963	731	235	1426	\N	1	\N
964	731	267	576	\N	2	\N
965	732	267	417	\N	2	\N
966	732	232	1	\N	3	\N
967	732	235	1094	\N	1	\N
968	733	267	155	\N	2	\N
969	733	235	455	\N	1	\N
970	734	235	427	\N	1	\N
971	734	267	145	\N	2	\N
972	735	235	145	\N	2	\N
973	735	267	249	\N	1	\N
974	736	267	28	\N	2	\N
975	736	235	352	\N	1	\N
976	737	267	25	\N	2	\N
977	737	235	327	\N	1	\N
978	738	235	264	\N	1	\N
979	739	235	182	\N	1	\N
980	739	267	66	\N	2	\N
981	740	235	214	\N	1	\N
982	741	267	33	\N	2	\N
983	741	235	167	\N	1	\N
984	742	267	24	\N	2	\N
985	742	235	159	\N	1	\N
986	743	235	142	\N	1	\N
987	744	235	127	\N	1	\N
988	745	235	74	\N	1	\N
989	745	267	24	\N	2	\N
990	746	267	21	\N	2	\N
991	746	235	72	\N	1	\N
992	747	235	88	\N	1	\N
993	748	235	86	\N	1	\N
994	748	232	1	\N	2	\N
995	749	267	29	\N	2	\N
996	749	235	44	\N	1	\N
997	750	267	69	\N	1	\N
998	750	235	1	\N	2	\N
999	751	235	67	\N	1	\N
1000	752	235	7	\N	2	\N
1001	752	267	58	\N	1	\N
1002	753	235	59	\N	1	\N
1003	754	267	20	\N	2	\N
1004	754	235	39	\N	1	\N
1005	755	235	32	\N	1	\N
1006	755	267	25	\N	2	\N
1007	756	235	55	\N	1	\N
1008	757	235	35	\N	1	\N
1009	757	267	14	\N	2	\N
1010	758	235	27	\N	1	\N
1011	758	267	22	\N	2	\N
1012	759	267	45	\N	1	\N
1013	760	235	36	\N	1	\N
1014	761	267	5	\N	2	\N
1015	761	235	29	\N	1	\N
1016	762	235	30	\N	1	\N
1017	763	235	20	\N	1	\N
1018	763	267	10	\N	2	\N
1019	764	267	3	\N	2	\N
1020	764	235	26	\N	1	\N
1021	765	267	28	\N	1	\N
1022	766	267	27	\N	1	\N
1023	767	267	18	\N	1	\N
1024	767	235	2	\N	2	\N
1025	768	235	18	\N	1	\N
1026	769	267	18	\N	1	\N
1027	770	235	17	\N	1	\N
1028	771	235	3	\N	2	\N
1029	771	267	14	\N	1	\N
1030	772	267	2	\N	2	\N
1031	772	235	14	\N	1	\N
1032	773	267	13	\N	1	\N
1033	773	235	3	\N	2	\N
1034	774	235	14	\N	1	\N
1035	775	267	11	\N	1	\N
1036	775	235	2	\N	2	\N
1037	776	267	13	\N	1	\N
1038	777	235	12	\N	1	\N
1039	778	235	12	\N	1	\N
1040	779	267	11	\N	1	\N
1041	780	267	11	\N	1	\N
1042	781	267	9	\N	1	\N
1043	782	267	6	\N	1	\N
1044	782	235	3	\N	2	\N
1045	783	235	7	\N	1	\N
1046	784	267	7	\N	1	\N
1047	785	235	6	\N	1	\N
1048	786	235	1	\N	2	\N
1049	786	267	4	\N	1	\N
1050	787	235	5	\N	1	\N
1051	788	235	5	\N	1	\N
1052	789	235	4	\N	1	\N
1053	790	267	4	\N	1	\N
1054	791	235	3	\N	1	\N
1055	792	235	3	\N	1	\N
1056	793	235	3	\N	1	\N
1057	794	267	2	\N	1	\N
1058	795	235	2	\N	1	\N
1059	796	267	2	\N	1	\N
1060	797	232	1	\N	1	\N
1061	797	267	1	\N	2	\N
1062	798	235	1	\N	1	\N
1063	799	235	1	\N	1	\N
1064	800	232	1	\N	1	\N
1065	801	267	1	\N	1	\N
1066	802	235	1	\N	1	\N
1067	803	235	1	\N	1	\N
1068	804	235	1	\N	1	\N
1069	805	235	1	\N	1	\N
1070	806	235	1	\N	1	\N
1071	807	235	1	\N	1	\N
1072	808	232	1	\N	1	\N
1073	809	267	1	\N	1	\N
1074	810	235	1	\N	1	\N
1075	811	235	1	\N	1	\N
1076	812	235	1	\N	1	\N
1077	813	235	1	\N	1	\N
1078	814	235	1	\N	1	\N
1079	815	235	1	\N	1	\N
1080	816	235	1	\N	1	\N
1081	817	235	1	\N	1	\N
1082	818	235	1	\N	1	\N
1083	819	235	1	\N	1	\N
1084	820	235	1	\N	1	\N
1085	821	235	1	\N	1	\N
1086	822	267	1	\N	1	\N
1087	823	119	24733	\N	1	\N
1088	824	119	209	\N	1	\N
1089	825	231	24733	\N	1	\N
1090	825	19	209	\N	2	\N
1091	826	32	27978	\N	1	\N
1092	827	32	24	\N	1	\N
1093	828	231	27978	\N	1	\N
1094	828	99	24	\N	2	\N
1095	829	83	390	\N	11	\N
1096	829	181	9509	\N	2	\N
1097	829	110	207	\N	13	\N
1098	829	178	2669	\N	5	\N
1099	829	37	783	\N	10	\N
1100	829	38	1135	\N	9	\N
1101	829	43	72	\N	15	\N
1102	829	141	222	\N	12	\N
1103	829	101	18469	\N	1	\N
1104	829	76	2669	\N	6	\N
1105	829	245	2668	\N	7	\N
1106	829	23	1367	\N	8	\N
1107	829	26	148	\N	14	\N
1108	829	11	2907	\N	4	\N
1109	829	203	3013	\N	3	\N
1110	830	14	1284	\N	4	\N
1111	830	58	690	\N	5	\N
1112	830	170	5886	\N	1	\N
1113	830	11	1531	\N	3	\N
1114	830	203	5102	\N	2	\N
1115	831	83	127	\N	3	\N
1116	831	110	17	\N	5	\N
1117	831	43	3	\N	6	\N
1118	831	141	28	\N	4	\N
1119	831	11	686	\N	2	\N
1120	831	203	773	\N	1	\N
1121	832	203	565	\N	1	\N
1122	833	203	417	\N	1	\N
1123	834	101	24	\N	1	\N
1124	835	14	193	\N	1	\N
1125	835	170	1	\N	4	\N
1126	835	11	1	\N	3	\N
1127	835	203	192	\N	2	\N
1128	836	14	23	\N	1	\N
1129	836	170	21	\N	3	\N
1130	836	203	23	\N	2	\N
1131	836	58	2	\N	4	\N
1132	837	231	18469	\N	1	\N
1133	837	99	24	\N	2	\N
1134	838	95	565	\N	4	\N
1135	838	13	417	\N	5	\N
1136	838	177	23	\N	0	\N
1137	838	112	192	\N	0	\N
1138	838	19	773	\N	3	\N
1139	838	46	5102	\N	1	\N
1140	838	231	3013	\N	2	\N
1141	839	231	9509	\N	1	\N
1142	840	177	21	\N	0	\N
1143	840	112	1	\N	0	\N
1144	840	46	5886	\N	1	\N
1145	841	112	1	\N	0	\N
1146	841	19	686	\N	3	\N
1147	841	46	1531	\N	2	\N
1148	841	231	2907	\N	1	\N
1149	842	231	2669	\N	1	\N
1150	843	231	2669	\N	1	\N
1151	844	231	2668	\N	1	\N
1152	845	231	1367	\N	1	\N
1153	846	46	1284	\N	1	\N
1154	846	112	193	\N	0	\N
1155	846	177	23	\N	0	\N
1156	847	231	1135	\N	1	\N
1157	848	231	783	\N	1	\N
1158	849	46	690	\N	1	\N
1159	849	177	2	\N	0	\N
1160	850	231	390	\N	1	\N
1161	850	19	127	\N	2	\N
1162	851	19	28	\N	2	\N
1163	851	231	222	\N	1	\N
1164	852	231	207	\N	1	\N
1165	852	19	17	\N	2	\N
1166	853	231	148	\N	1	\N
1167	854	19	3	\N	2	\N
1168	854	231	72	\N	1	\N
1169	856	177	21550	\N	1	\N
1170	856	46	21550	\N	0	\N
1171	857	177	239	\N	1	\N
1172	857	46	239	\N	0	\N
1173	858	231	21550	\N	1	\N
1174	858	19	239	\N	2	\N
1175	859	231	21550	\N	1	\N
1176	859	19	239	\N	2	\N
1177	869	112	23163	\N	1	\N
1178	869	46	23163	\N	0	\N
1179	870	112	197	\N	1	\N
1180	870	46	197	\N	0	\N
1181	871	231	23163	\N	1	\N
1182	871	19	197	\N	2	\N
1183	872	231	23163	\N	1	\N
1184	872	19	197	\N	2	\N
1185	873	231	304	\N	2	\N
1186	873	19	34300	\N	1	\N
1187	874	231	18467	\N	1	\N
1188	874	19	12807	\N	2	\N
1189	875	231	25073	\N	1	\N
1190	876	19	20325	\N	1	\N
1191	876	231	166	\N	2	\N
1192	877	231	1	\N	2	\N
1193	877	19	18071	\N	1	\N
1194	878	231	4988	\N	2	\N
1195	878	19	12695	\N	1	\N
1196	879	231	5351	\N	2	\N
1197	879	19	9349	\N	1	\N
1198	880	231	1	\N	2	\N
1199	880	19	13582	\N	1	\N
1200	881	231	12978	\N	1	\N
1201	882	231	11411	\N	1	\N
1202	882	19	57	\N	2	\N
1203	883	231	9052	\N	1	\N
1204	884	19	6208	\N	1	\N
1205	884	231	234	\N	2	\N
1206	885	231	5820	\N	1	\N
1207	886	231	5618	\N	1	\N
1208	887	19	148	\N	2	\N
1209	887	231	4631	\N	1	\N
1210	888	231	4462	\N	1	\N
1211	889	231	1883	\N	2	\N
1212	889	19	2205	\N	1	\N
1213	890	19	3927	\N	1	\N
1214	891	231	3775	\N	1	\N
1215	892	231	3503	\N	1	\N
1216	893	231	2844	\N	1	\N
1217	894	231	2085	\N	1	\N
1218	895	19	881	\N	1	\N
1219	895	231	830	\N	2	\N
1220	896	231	1707	\N	1	\N
1221	897	19	1585	\N	1	\N
1222	898	231	1381	\N	1	\N
1223	899	231	1313	\N	1	\N
1224	900	231	968	\N	1	\N
1225	901	231	751	\N	1	\N
1226	902	231	736	\N	1	\N
1227	903	231	653	\N	1	\N
1228	904	231	650	\N	1	\N
1229	905	231	598	\N	1	\N
1230	906	231	597	\N	1	\N
1231	907	231	558	\N	1	\N
1232	908	231	528	\N	1	\N
1233	908	19	1	\N	2	\N
1234	909	231	517	\N	1	\N
1235	910	231	463	\N	1	\N
1236	911	231	460	\N	1	\N
1237	912	231	407	\N	1	\N
1238	913	231	400	\N	1	\N
1239	914	231	398	\N	1	\N
1240	915	231	338	\N	1	\N
1241	916	231	306	\N	1	\N
1242	917	231	269	\N	1	\N
1243	918	231	230	\N	1	\N
1244	919	231	230	\N	1	\N
1245	920	231	165	\N	1	\N
1246	921	231	164	\N	1	\N
1247	922	231	158	\N	1	\N
1248	923	231	130	\N	1	\N
1249	924	231	126	\N	1	\N
1250	925	231	108	\N	1	\N
1251	926	231	82	\N	1	\N
1252	927	231	78	\N	1	\N
1253	928	231	78	\N	1	\N
1254	929	231	75	\N	1	\N
1255	930	231	48	\N	1	\N
1256	931	231	47	\N	1	\N
1257	932	231	47	\N	1	\N
1258	933	231	46	\N	1	\N
1259	934	231	27	\N	1	\N
1260	935	231	26	\N	1	\N
1261	936	231	17	\N	1	\N
1262	937	231	16	\N	1	\N
1263	938	231	15	\N	1	\N
1264	939	231	15	\N	1	\N
1265	940	231	14	\N	1	\N
1266	941	231	7	\N	1	\N
1267	942	231	7	\N	1	\N
1268	943	231	4	\N	1	\N
1269	944	231	4	\N	1	\N
1270	945	231	4	\N	1	\N
1271	946	231	2	\N	1	\N
1272	947	231	2	\N	1	\N
1273	948	231	2	\N	1	\N
1274	949	231	2	\N	1	\N
1275	950	231	2	\N	1	\N
1276	951	231	1	\N	1	\N
1277	952	19	1	\N	1	\N
1278	953	211	4988	\N	9	\N
1279	953	85	1707	\N	17	\N
1280	953	210	164	\N	45	\N
1281	953	84	26	\N	59	\N
1282	953	209	1	\N	77	\N
1283	953	217	230	\N	42	\N
1284	953	87	653	\N	24	\N
1285	953	214	400	\N	34	\N
1286	953	86	306	\N	37	\N
1287	953	215	48	\N	54	\N
1288	953	221	4	\N	69	\N
1289	953	89	5618	\N	7	\N
1290	953	220	2	\N	73	\N
1291	953	125	82	\N	50	\N
1292	953	124	230	\N	41	\N
1293	953	127	407	\N	33	\N
1294	953	126	2085	\N	15	\N
1295	953	150	650	\N	25	\N
1296	953	149	463	\N	31	\N
1297	953	152	47	\N	55	\N
1298	953	151	75	\N	53	\N
1299	953	222	2844	\N	14	\N
1300	953	138	736	\N	23	\N
1301	953	137	2	\N	74	\N
1302	953	224	126	\N	48	\N
1303	953	139	751	\N	22	\N
1304	953	94	4	\N	67	\N
1305	953	226	517	\N	30	\N
1306	953	227	25073	\N	1	\N
1307	953	145	2	\N	70	\N
1308	953	53	17	\N	60	\N
1309	953	55	2	\N	71	\N
1310	953	115	78	\N	51	\N
1311	953	114	4462	\N	11	\N
1312	953	75	528	\N	29	\N
1313	953	74	1883	\N	16	\N
1314	953	61	18467	\N	2	\N
1315	953	117	5351	\N	8	\N
1316	953	62	1381	\N	18	\N
1317	953	59	968	\N	20	\N
1318	953	202	15	\N	62	\N
1319	953	63	304	\N	38	\N
1320	953	118	1	\N	76	\N
1321	953	66	2	\N	72	\N
1322	953	65	3503	\N	13	\N
1323	953	72	16	\N	61	\N
1324	953	121	830	\N	21	\N
1325	953	71	15	\N	63	\N
1326	953	256	7	\N	66	\N
1327	953	255	78	\N	52	\N
1328	953	258	4631	\N	10	\N
1329	953	257	234	\N	40	\N
1330	953	260	5820	\N	6	\N
1331	953	259	166	\N	43	\N
1332	953	262	558	\N	28	\N
1333	953	264	398	\N	35	\N
1334	953	188	269	\N	39	\N
1335	953	187	12978	\N	3	\N
1336	953	263	3775	\N	12	\N
1337	953	266	460	\N	32	\N
1338	953	237	598	\N	26	\N
1339	953	156	47	\N	56	\N
1340	953	155	130	\N	47	\N
1341	953	158	1	\N	75	\N
1342	953	241	7	\N	65	\N
1343	953	162	165	\N	44	\N
1344	953	240	1313	\N	19	\N
1345	953	244	14	\N	64	\N
1346	953	164	46	\N	57	\N
1347	953	242	4	\N	68	\N
1348	953	166	597	\N	27	\N
1349	953	246	338	\N	36	\N
1350	953	248	11411	\N	4	\N
1351	953	167	9052	\N	5	\N
1352	953	173	158	\N	46	\N
1353	953	171	27	\N	58	\N
1354	953	176	108	\N	49	\N
1355	954	211	12695	\N	6	\N
1356	954	209	18071	\N	3	\N
1357	954	75	1	\N	16	\N
1358	954	74	2205	\N	10	\N
1359	954	67	1	\N	15	\N
1360	954	122	1585	\N	11	\N
1361	954	70	3927	\N	9	\N
1362	954	121	881	\N	12	\N
1363	954	117	9349	\N	7	\N
1364	954	61	12807	\N	5	\N
1365	954	118	13582	\N	4	\N
1366	954	63	34300	\N	1	\N
1367	954	258	148	\N	13	\N
1368	954	257	6208	\N	8	\N
1369	954	259	20325	\N	2	\N
1370	954	248	57	\N	14	\N
1371	956	204	1	\N	1	\N
1372	957	204	24	\N	1	\N
1373	957	131	152	\N	0	\N
1374	958	131	24	\N	0	\N
1375	958	204	1	\N	1	\N
1376	959	131	152	\N	0	\N
1377	968	231	173028	\N	1	\N
1378	968	19	14296	\N	2	\N
1379	969	96	173028	\N	1	\N
1380	970	96	14296	\N	1	\N
1381	971	13	10934	\N	1	\N
1382	972	95	10934	\N	1	\N
1383	973	10	2	\N	1	\N
1384	973	147	1	\N	2	\N
1385	974	10	2	\N	1	\N
1386	974	147	1	\N	2	\N
1387	975	10	2	\N	1	\N
1388	975	147	1	\N	2	\N
1389	976	196	2	\N	1	\N
1390	976	102	2	\N	0	\N
1391	976	8	2	\N	0	\N
1392	977	196	1	\N	1	\N
1393	977	102	1	\N	0	\N
1394	977	8	1	\N	0	\N
1395	990	253	8585	\N	1	\N
1396	991	253	3931	\N	1	\N
1397	992	253	2367	\N	1	\N
1398	993	232	8585	\N	1	\N
1399	993	235	2367	\N	3	\N
1400	993	267	3931	\N	2	\N
1401	994	131	187324	\N	0	\N
1402	995	131	123197	\N	0	\N
1403	996	131	93050	\N	0	\N
1404	997	131	62575	\N	0	\N
1405	998	131	47246	\N	0	\N
1406	999	131	42815	\N	0	\N
1407	1000	131	42090	\N	0	\N
1408	1001	131	41930	\N	0	\N
1409	1002	131	34606	\N	0	\N
1410	1003	131	31276	\N	0	\N
1411	1004	131	27978	\N	0	\N
1412	1006	131	25076	\N	0	\N
1413	1007	131	24944	\N	0	\N
1414	1008	131	20497	\N	0	\N
1415	1009	131	19348	\N	0	\N
1416	1010	131	18493	\N	0	\N
1417	1011	131	18080	\N	0	\N
1418	1012	131	17688	\N	0	\N
1419	1013	131	17125	\N	0	\N
1420	1014	131	14702	\N	0	\N
1421	1015	131	13588	\N	0	\N
1422	1016	131	12981	\N	0	\N
1423	1017	131	11472	\N	0	\N
1424	1018	131	10914	\N	0	\N
1425	1019	131	9797	\N	0	\N
1426	1020	131	9509	\N	0	\N
1427	1021	131	9054	\N	0	\N
1428	1022	131	8949	\N	0	\N
1429	1023	131	6677	\N	0	\N
1430	1024	131	6447	\N	0	\N
1431	1025	131	5820	\N	0	\N
1432	1026	131	5695	\N	0	\N
1433	1027	131	5619	\N	0	\N
1434	1028	131	4783	\N	0	\N
1435	1029	131	4733	\N	0	\N
1436	1030	131	4462	\N	0	\N
1437	1031	131	4183	\N	0	\N
1438	1032	131	4090	\N	0	\N
1439	1033	131	3929	\N	0	\N
1440	1034	131	3779	\N	0	\N
1441	1035	131	3504	\N	0	\N
1442	1036	131	2846	\N	0	\N
1443	1038	131	2669	\N	0	\N
1444	1039	131	2668	\N	0	\N
1445	1040	131	2141	\N	0	\N
1446	1041	131	2086	\N	0	\N
1447	1042	29	1892	\N	1	\N
1448	1043	131	1713	\N	0	\N
1449	1044	131	1707	\N	0	\N
1450	1045	131	1587	\N	0	\N
1451	1046	131	1382	\N	0	\N
1452	1047	131	1367	\N	0	\N
1453	1048	131	1317	\N	0	\N
1454	1049	131	1260	\N	0	\N
1455	1050	131	1229	\N	0	\N
1456	1052	131	1135	\N	0	\N
1457	1053	131	968	\N	0	\N
1458	1054	131	783	\N	0	\N
1459	1055	131	753	\N	0	\N
1460	1056	131	736	\N	0	\N
1461	1057	131	686	\N	0	\N
1462	1058	131	654	\N	0	\N
1463	1059	131	638	\N	0	\N
1464	1060	131	602	\N	0	\N
1465	1061	131	599	\N	0	\N
1466	1062	29	595	\N	1	\N
1467	1063	131	562	\N	0	\N
1468	1064	131	548	\N	0	\N
1469	1065	131	531	\N	0	\N
1470	1066	131	520	\N	0	\N
1471	1067	131	495	\N	0	\N
1472	1068	131	494	\N	0	\N
1473	1069	131	494	\N	0	\N
1474	1070	131	464	\N	0	\N
1475	1071	131	460	\N	0	\N
1476	1072	131	408	\N	0	\N
1477	1073	131	401	\N	0	\N
1478	1074	131	400	\N	0	\N
1479	1075	131	340	\N	0	\N
1480	1076	131	306	\N	0	\N
1481	1077	29	283	\N	1	\N
1482	1078	131	272	\N	0	\N
1483	1079	29	259	\N	1	\N
1484	1080	131	238	\N	0	\N
1485	1081	131	232	\N	0	\N
1486	1082	131	231	\N	0	\N
1487	1083	131	216	\N	0	\N
1488	1084	29	201	\N	1	\N
1489	1085	29	196	\N	1	\N
1490	1086	131	188	\N	0	\N
1491	1087	131	167	\N	0	\N
1492	1088	131	165	\N	0	\N
1493	1089	131	161	\N	0	\N
1494	1090	131	148	\N	0	\N
1495	1091	131	131	\N	0	\N
1496	1092	131	130	\N	0	\N
1497	1093	131	110	\N	0	\N
1498	1094	29	107	\N	1	\N
1499	1095	131	93	\N	0	\N
1500	1096	29	93	\N	1	\N
1501	1097	29	83	\N	1	\N
1502	1098	131	83	\N	0	\N
1503	1099	29	79	\N	1	\N
1504	1100	131	78	\N	0	\N
1505	1101	131	78	\N	0	\N
1506	1102	131	76	\N	0	\N
1507	1103	131	73	\N	0	\N
1508	1104	29	67	\N	1	\N
1509	1105	29	65	\N	1	\N
1510	1106	29	65	\N	1	\N
1511	1107	29	65	\N	1	\N
1512	1108	29	64	\N	1	\N
1513	1109	29	57	\N	1	\N
1514	1110	131	50	\N	0	\N
1515	1111	29	48	\N	1	\N
1516	1112	131	48	\N	0	\N
1517	1113	131	48	\N	0	\N
1518	1114	29	47	\N	1	\N
1519	1115	131	47	\N	0	\N
1520	1116	29	45	\N	1	\N
1521	1117	29	42	\N	1	\N
1522	1118	29	42	\N	1	\N
1523	1120	29	37	\N	1	\N
1524	1121	29	33	\N	1	\N
1525	1122	29	32	\N	1	\N
1526	1123	29	29	\N	1	\N
1527	1124	29	29	\N	1	\N
1528	1125	131	3	\N	0	\N
1529	1126	29	27	\N	1	\N
1530	1127	131	27	\N	0	\N
1531	1128	131	26	\N	0	\N
1532	1129	131	24	\N	0	\N
1533	1130	131	24	\N	0	\N
1534	1131	29	23	\N	1	\N
1535	1132	29	21	\N	1	\N
1536	1133	29	21	\N	1	\N
1537	1134	29	21	\N	1	\N
1538	1135	29	20	\N	1	\N
1539	1136	29	18	\N	1	\N
1540	1137	29	17	\N	1	\N
1541	1138	131	17	\N	0	\N
1542	1139	131	17	\N	0	\N
1543	1140	29	16	\N	1	\N
1544	1141	29	16	\N	1	\N
1545	1142	29	16	\N	1	\N
1546	1143	131	16	\N	0	\N
1547	1144	131	16	\N	0	\N
1548	1145	131	12	\N	0	\N
1549	1146	29	15	\N	1	\N
1550	1147	29	14	\N	1	\N
1551	1148	131	14	\N	0	\N
1552	1150	29	13	\N	1	\N
1553	1151	29	13	\N	1	\N
1554	1153	29	11	\N	1	\N
1555	1154	29	11	\N	1	\N
1556	1155	29	11	\N	1	\N
1557	1156	29	10	\N	1	\N
1558	1157	29	10	\N	1	\N
1559	1158	29	10	\N	1	\N
1560	1159	131	10	\N	0	\N
1561	1160	29	9	\N	1	\N
1562	1161	29	9	\N	1	\N
1563	1162	29	8	\N	1	\N
1564	1163	131	8	\N	0	\N
1565	1164	29	7	\N	1	\N
1566	1165	131	7	\N	0	\N
1567	1166	29	6	\N	1	\N
1568	1167	29	6	\N	1	\N
1569	1168	131	6	\N	0	\N
1570	1170	29	5	\N	1	\N
1571	1171	29	5	\N	1	\N
1572	1172	131	5	\N	0	\N
1573	1173	131	5	\N	0	\N
1574	1174	29	4	\N	1	\N
1575	1175	29	4	\N	1	\N
1576	1176	29	4	\N	1	\N
1577	1177	131	4	\N	0	\N
1578	1178	131	4	\N	0	\N
1579	1179	131	4	\N	0	\N
1580	1181	29	3	\N	1	\N
1581	1182	29	3	\N	1	\N
1582	1183	29	3	\N	1	\N
1583	1184	29	3	\N	1	\N
1584	1185	131	3	\N	0	\N
1585	1186	131	3	\N	0	\N
1586	1187	131	3	\N	0	\N
1587	1188	131	3	\N	0	\N
1588	1189	29	2	\N	1	\N
1589	1190	29	2	\N	1	\N
1590	1191	29	2	\N	1	\N
1591	1192	29	2	\N	1	\N
1592	1193	29	2	\N	1	\N
1593	1194	29	2	\N	1	\N
1594	1195	131	2	\N	0	\N
1595	1196	131	2	\N	0	\N
1596	1197	131	2	\N	0	\N
1597	1198	131	2	\N	0	\N
1598	1199	131	2	\N	0	\N
1599	1200	131	2	\N	0	\N
1600	1201	131	2	\N	0	\N
1601	1202	131	2	\N	0	\N
1602	1203	131	2	\N	0	\N
1603	1204	131	2	\N	0	\N
1604	1205	131	2	\N	0	\N
1605	1206	131	2	\N	0	\N
1606	1207	131	2	\N	0	\N
1607	1208	131	2	\N	0	\N
1608	1209	131	2	\N	0	\N
1609	1210	131	2	\N	0	\N
1610	1211	131	2	\N	0	\N
1611	1212	131	2	\N	0	\N
1612	1213	131	2	\N	0	\N
1613	1214	131	2	\N	0	\N
1614	1215	131	2	\N	0	\N
1615	1217	29	1	\N	1	\N
1616	1218	29	1	\N	1	\N
1617	1219	29	1	\N	1	\N
1618	1220	29	1	\N	1	\N
1619	1221	29	1	\N	1	\N
1620	1222	29	1	\N	1	\N
1621	1223	29	1	\N	1	\N
1622	1224	29	1	\N	1	\N
1623	1225	29	1	\N	1	\N
1624	1226	29	1	\N	1	\N
1625	1227	29	1	\N	1	\N
1626	1228	29	1	\N	1	\N
1627	1229	29	1	\N	1	\N
1628	1230	29	1	\N	1	\N
1629	1231	29	1	\N	1	\N
1630	1232	29	1	\N	1	\N
1631	1233	29	1	\N	1	\N
1632	1234	29	1	\N	1	\N
1633	1235	29	1	\N	1	\N
1634	1236	29	1	\N	1	\N
1635	1237	29	1	\N	1	\N
1636	1238	29	1	\N	1	\N
1637	1239	29	1	\N	1	\N
1638	1240	29	1	\N	1	\N
1639	1241	29	1	\N	1	\N
1640	1242	131	1	\N	0	\N
1641	1243	131	1	\N	0	\N
1642	1244	131	1	\N	0	\N
1643	1245	131	1	\N	0	\N
1644	1246	131	1	\N	0	\N
1645	1247	131	1	\N	0	\N
1646	1248	131	1	\N	0	\N
1647	1249	131	1	\N	0	\N
1648	1250	131	1	\N	0	\N
1649	1251	131	1	\N	0	\N
1650	1252	131	1	\N	0	\N
1651	1253	131	1	\N	0	\N
1652	1256	131	398	\N	0	\N
1653	1257	79	184	\N	1	\N
1654	1258	131	90	\N	0	\N
1655	1261	228	1	\N	69	\N
1656	1261	225	8	\N	50	\N
1657	1261	216	29	\N	25	\N
1658	1261	213	64	\N	15	\N
1659	1261	206	23	\N	28	\N
1660	1261	207	2	\N	63	\N
1661	1261	208	4	\N	56	\N
1662	1261	205	10	\N	45	\N
1663	1261	200	1	\N	70	\N
1664	1261	199	11	\N	42	\N
1665	1261	197	1	\N	71	\N
1666	1261	198	48	\N	17	\N
1667	1261	261	3	\N	59	\N
1668	1261	265	1892	\N	1	\N
1669	1261	254	3	\N	60	\N
1670	1261	252	1	\N	72	\N
1671	1261	249	1	\N	73	\N
1672	1261	250	65	\N	12	\N
1673	1261	247	7	\N	51	\N
1674	1261	251	15	\N	38	\N
1675	1261	236	17	\N	34	\N
1676	1261	238	14	\N	39	\N
1677	1261	233	6	\N	52	\N
1678	1261	146	1	\N	74	\N
1679	1261	136	20	\N	32	\N
1680	1261	142	595	\N	2	\N
1681	1261	130	32	\N	24	\N
1682	1261	128	33	\N	23	\N
1683	1261	129	1	\N	75	\N
1684	1261	120	21	\N	29	\N
1685	1261	195	6	\N	53	\N
1686	1261	185	1	\N	76	\N
1687	1261	191	16	\N	35	\N
1688	1261	179	27	\N	27	\N
1689	1261	180	2	\N	64	\N
1690	1261	168	65	\N	13	\N
1691	1261	172	1	\N	77	\N
1692	1261	169	1	\N	78	\N
1693	1261	175	1	\N	79	\N
1694	1261	157	1	\N	80	\N
1695	1261	159	1	\N	81	\N
1696	1261	163	79	\N	10	\N
1697	1261	154	5	\N	54	\N
1698	1261	153	10	\N	46	\N
1699	1261	93	196	\N	6	\N
1700	1261	91	3	\N	61	\N
1701	1261	88	1	\N	82	\N
1702	1261	78	47	\N	18	\N
1703	1261	81	5	\N	55	\N
1704	1261	80	1	\N	83	\N
1705	1261	82	107	\N	7	\N
1706	1261	68	67	\N	11	\N
1707	1261	69	10	\N	47	\N
1708	1261	57	65	\N	14	\N
1709	1261	47	2	\N	65	\N
1710	1261	49	1	\N	84	\N
1711	1261	48	13	\N	40	\N
1712	1261	50	11	\N	43	\N
1713	1261	111	4	\N	57	\N
1714	1261	109	1	\N	85	\N
1715	1261	106	9	\N	48	\N
1716	1261	107	1	\N	86	\N
1717	1261	98	1	\N	87	\N
1718	1261	97	9	\N	49	\N
1719	1261	100	57	\N	16	\N
1720	1261	103	1	\N	88	\N
1721	1261	18	2	\N	66	\N
1722	1261	15	45	\N	19	\N
1723	1261	16	1	\N	89	\N
1724	1261	17	21	\N	30	\N
1725	1261	9	2	\N	67	\N
1726	1261	6	83	\N	9	\N
1727	1261	5	11	\N	44	\N
1728	1261	7	4	\N	58	\N
1729	1261	1	42	\N	20	\N
1730	1261	2	201	\N	5	\N
1731	1261	4	21	\N	31	\N
1732	1261	44	1	\N	90	\N
1733	1261	45	2	\N	68	\N
1734	1261	41	42	\N	21	\N
1735	1261	40	18	\N	33	\N
1736	1261	42	1	\N	91	\N
1737	1261	39	1	\N	92	\N
1738	1261	35	283	\N	3	\N
1739	1261	36	1	\N	93	\N
1740	1261	31	13	\N	41	\N
1741	1261	34	93	\N	8	\N
1742	1261	33	29	\N	26	\N
1743	1261	25	16	\N	36	\N
1744	1261	30	16	\N	37	\N
1745	1261	21	259	\N	4	\N
1746	1261	22	37	\N	22	\N
1747	1261	20	3	\N	62	\N
1748	1262	131	184	\N	0	\N
1749	1263	104	3	\N	0	\N
1750	1263	101	18493	\N	16	\N
1751	1263	99	24	\N	104	\N
1752	1263	105	93050	\N	3	\N
1753	1263	110	216	\N	83	\N
1754	1263	51	4183	\N	37	\N
1755	1263	46	9797	\N	25	\N
1756	1263	58	686	\N	60	\N
1757	1263	55	2	\N	125	\N
1758	1263	54	1	\N	146	\N
1759	1263	53	17	\N	106	\N
1760	1263	52	2	\N	126	\N
1761	1263	72	17	\N	107	\N
1762	1263	70	3929	\N	39	\N
1763	1263	71	16	\N	108	\N
1764	1263	66	2	\N	127	\N
1765	1263	67	3	\N	121	\N
1766	1263	65	3504	\N	41	\N
1767	1263	64	1	\N	147	\N
1768	1263	63	34606	\N	9	\N
1769	1263	61	31276	\N	10	\N
1770	1263	62	1382	\N	50	\N
1771	1263	59	968	\N	56	\N
1772	1263	60	1	\N	148	\N
1773	1263	76	2669	\N	43	\N
1774	1263	75	531	\N	67	\N
1775	1263	74	4090	\N	38	\N
1776	1263	73	495	\N	69	\N
1777	1263	77	1260	\N	53	\N
1778	1263	79	12	\N	111	\N
1779	1263	89	5619	\N	33	\N
1780	1263	87	654	\N	61	\N
1781	1263	86	306	\N	78	\N
1782	1263	85	1707	\N	48	\N
1783	1263	83	494	\N	70	\N
1784	1263	84	26	\N	103	\N
1785	1263	94	4	\N	118	\N
1786	1263	92	1	\N	149	\N
1787	1263	90	1	\N	150	\N
1788	1263	96	187324	\N	1	\N
1789	1263	95	10914	\N	24	\N
1790	1263	19	47246	\N	5	\N
1791	1263	29	93	\N	92	\N
1792	1263	28	548	\N	66	\N
1793	1263	26	148	\N	88	\N
1794	1263	27	24	\N	105	\N
1795	1263	24	19348	\N	15	\N
1796	1263	23	1367	\N	51	\N
1797	1263	32	2	\N	128	\N
1798	1263	38	1135	\N	55	\N
1799	1263	37	783	\N	57	\N
1800	1263	43	73	\N	97	\N
1801	1263	3	188	\N	84	\N
1802	1263	11	4733	\N	35	\N
1803	1263	14	1229	\N	54	\N
1804	1263	13	2141	\N	45	\N
1805	1263	12	6677	\N	29	\N
1806	1263	234	62575	\N	4	\N
1807	1263	232	41930	\N	8	\N
1808	1263	231	27978	\N	11	\N
1809	1263	230	42815	\N	6	\N
1810	1263	244	14	\N	110	\N
1811	1263	242	4	\N	119	\N
1812	1263	243	2	\N	129	\N
1813	1263	241	7	\N	114	\N
1814	1263	240	1317	\N	52	\N
1815	1263	239	2	\N	130	\N
1816	1263	237	602	\N	63	\N
1817	1263	235	17125	\N	19	\N
1818	1263	248	11472	\N	23	\N
1819	1263	245	2668	\N	44	\N
1820	1263	246	340	\N	77	\N
1821	1263	253	494	\N	71	\N
1822	1263	260	5820	\N	31	\N
1823	1263	259	20497	\N	14	\N
1824	1263	258	4783	\N	34	\N
1825	1263	257	6447	\N	30	\N
1826	1263	256	10	\N	112	\N
1827	1263	255	78	\N	94	\N
1828	1263	266	460	\N	73	\N
1829	1263	264	400	\N	76	\N
1830	1263	263	3779	\N	40	\N
1831	1263	262	562	\N	65	\N
1832	1263	267	42090	\N	7	\N
1833	1263	203	8949	\N	28	\N
1834	1263	202	16	\N	109	\N
1835	1263	201	2	\N	131	\N
1836	1263	221	5	\N	116	\N
1837	1263	220	3	\N	122	\N
1838	1263	219	1	\N	151	\N
1839	1263	218	2	\N	132	\N
1840	1263	217	232	\N	81	\N
1841	1263	214	401	\N	75	\N
1842	1263	215	50	\N	98	\N
1843	1263	211	17688	\N	18	\N
1844	1263	212	2	\N	133	\N
1845	1263	209	18080	\N	17	\N
1846	1263	210	165	\N	86	\N
1847	1263	227	25076	\N	12	\N
1848	1263	226	520	\N	68	\N
1849	1263	224	130	\N	90	\N
1850	1263	223	8	\N	113	\N
1851	1263	222	2846	\N	42	\N
1852	1263	164	47	\N	101	\N
1853	1263	162	167	\N	85	\N
1854	1263	160	2	\N	134	\N
1855	1263	158	1	\N	152	\N
1856	1263	156	48	\N	99	\N
1857	1263	155	131	\N	89	\N
1858	1263	176	110	\N	91	\N
1859	1263	174	3	\N	123	\N
1860	1263	173	161	\N	87	\N
1861	1263	170	5695	\N	32	\N
1862	1263	171	27	\N	102	\N
1863	1263	167	9054	\N	27	\N
1864	1263	166	599	\N	64	\N
1865	1263	165	2	\N	135	\N
1866	1263	177	90	\N	0	\N
1867	1263	183	3	\N	124	\N
1868	1263	182	123197	\N	2	\N
1869	1263	181	9509	\N	26	\N
1870	1263	193	2	\N	136	\N
1871	1263	192	2	\N	137	\N
1872	1263	190	1	\N	153	\N
1873	1263	189	1	\N	154	\N
1874	1263	188	272	\N	79	\N
1875	1263	187	12981	\N	22	\N
1876	1263	186	2	\N	138	\N
1877	1263	184	2	\N	139	\N
1878	1263	194	2	\N	140	\N
1879	1263	115	78	\N	95	\N
1880	1263	114	4462	\N	36	\N
1881	1263	113	6	\N	115	\N
1882	1263	112	398	\N	0	\N
1883	1263	122	1587	\N	49	\N
1884	1263	121	1713	\N	47	\N
1885	1263	119	24944	\N	13	\N
1886	1263	118	13588	\N	21	\N
1887	1263	117	14702	\N	20	\N
1888	1263	116	5	\N	117	\N
1889	1263	127	408	\N	74	\N
1890	1263	126	2086	\N	46	\N
1891	1263	125	83	\N	93	\N
1892	1263	124	231	\N	82	\N
1893	1263	135	2	\N	141	\N
1894	1263	134	1	\N	155	\N
1895	1263	133	2	\N	142	\N
1896	1263	132	2	\N	143	\N
1897	1263	145	2	\N	144	\N
1898	1263	144	1	\N	156	\N
1899	1263	143	2	\N	145	\N
1900	1263	141	238	\N	80	\N
1901	1263	140	1	\N	157	\N
1902	1263	139	753	\N	58	\N
1903	1263	138	736	\N	59	\N
1904	1263	137	4	\N	120	\N
1905	1263	152	48	\N	100	\N
1906	1263	151	76	\N	96	\N
1907	1263	150	638	\N	62	\N
1908	1263	149	464	\N	72	\N
1909	1264	24	85764	\N	1	\N
1910	1264	51	5406	\N	0	\N
1911	1265	105	85764	\N	1	\N
1912	1266	105	5406	\N	1	\N
1913	1268	231	246394	\N	1	\N
1914	1269	182	246394	\N	1	\N
1915	1273	131	37	\N	0	\N
1916	1274	131	37	\N	0	\N
1917	1275	177	21494	\N	1	\N
1918	1275	46	21494	\N	0	\N
1919	1276	177	64	\N	1	\N
1920	1276	46	64	\N	0	\N
1921	1277	231	21494	\N	1	\N
1922	1277	19	64	\N	2	\N
1923	1278	231	21494	\N	1	\N
1924	1278	19	64	\N	2	\N
1925	1279	164	1	\N	74	\N
1926	1279	162	2	\N	43	\N
1927	1279	160	2	\N	23	\N
1928	1279	240	4	\N	9	\N
1929	1279	239	2	\N	24	\N
1930	1279	156	1	\N	75	\N
1931	1279	237	4	\N	8	\N
1932	1279	155	1	\N	79	\N
1933	1279	176	2	\N	42	\N
1934	1279	174	3	\N	15	\N
1935	1279	173	3	\N	18	\N
1936	1279	167	2	\N	55	\N
1937	1279	248	4	\N	13	\N
1938	1279	166	2	\N	48	\N
1939	1279	165	2	\N	25	\N
1940	1279	246	2	\N	45	\N
1941	1279	259	4	\N	14	\N
1942	1279	258	4	\N	11	\N
1943	1279	183	3	\N	16	\N
1944	1279	257	4	\N	12	\N
1945	1279	256	3	\N	17	\N
1946	1279	193	2	\N	26	\N
1947	1279	192	2	\N	27	\N
1948	1279	190	1	\N	58	\N
1949	1279	189	1	\N	59	\N
1950	1279	188	3	\N	19	\N
1951	1279	264	2	\N	46	\N
1952	1279	187	3	\N	21	\N
1953	1279	263	4	\N	10	\N
1954	1279	186	2	\N	28	\N
1955	1279	262	4	\N	7	\N
1956	1279	184	2	\N	29	\N
1957	1279	194	2	\N	30	\N
1958	1279	113	6	\N	2	\N
1959	1279	54	1	\N	60	\N
1960	1279	52	2	\N	31	\N
1961	1279	72	1	\N	73	\N
1962	1279	122	2	\N	50	\N
1963	1279	71	1	\N	71	\N
1964	1279	70	2	\N	53	\N
1965	1279	121	2	\N	51	\N
1966	1279	67	2	\N	39	\N
1967	1279	65	1	\N	89	\N
1968	1279	64	1	\N	61	\N
1969	1279	202	1	\N	72	\N
1970	1279	63	1	\N	92	\N
1971	1279	118	2	\N	56	\N
1972	1279	201	2	\N	32	\N
1973	1279	61	1	\N	91	\N
1974	1279	62	1	\N	87	\N
1975	1279	117	2	\N	57	\N
1976	1279	60	1	\N	62	\N
1977	1279	116	5	\N	3	\N
1978	1279	75	2	\N	47	\N
1979	1279	74	2	\N	54	\N
1980	1279	127	1	\N	83	\N
1981	1279	126	1	\N	88	\N
1982	1279	125	1	\N	78	\N
1983	1279	124	1	\N	81	\N
1984	1279	135	2	\N	33	\N
1985	1279	221	1	\N	70	\N
1986	1279	89	1	\N	90	\N
1987	1279	134	1	\N	63	\N
1988	1279	220	1	\N	69	\N
1989	1279	133	2	\N	34	\N
1990	1279	219	1	\N	64	\N
1991	1279	218	2	\N	35	\N
1992	1279	132	2	\N	36	\N
1993	1279	87	1	\N	86	\N
1994	1279	217	2	\N	44	\N
1995	1279	214	1	\N	82	\N
1996	1279	215	2	\N	41	\N
1997	1279	211	5	\N	4	\N
1998	1279	212	2	\N	37	\N
1999	1279	209	5	\N	5	\N
2000	1279	210	1	\N	80	\N
2001	1279	227	3	\N	22	\N
2002	1279	144	1	\N	65	\N
2003	1279	143	2	\N	38	\N
2004	1279	92	1	\N	66	\N
2005	1279	226	3	\N	20	\N
2006	1279	140	1	\N	67	\N
2007	1279	224	4	\N	6	\N
2008	1279	139	2	\N	49	\N
2009	1279	223	8	\N	1	\N
2010	1279	90	1	\N	68	\N
2011	1279	222	2	\N	52	\N
2012	1279	137	2	\N	40	\N
2013	1279	152	1	\N	76	\N
2014	1279	151	1	\N	77	\N
2015	1279	150	1	\N	85	\N
2016	1279	149	1	\N	84	\N
2017	1280	131	8	\N	0	\N
2018	1281	131	6	\N	0	\N
2019	1282	131	5	\N	0	\N
2020	1283	131	5	\N	0	\N
2021	1284	131	5	\N	0	\N
2022	1285	131	4	\N	0	\N
2023	1286	131	4	\N	0	\N
2024	1287	131	4	\N	0	\N
2025	1288	131	4	\N	0	\N
2026	1289	131	4	\N	0	\N
2027	1290	131	4	\N	0	\N
2028	1291	131	4	\N	0	\N
2029	1292	131	4	\N	0	\N
2030	1293	131	4	\N	0	\N
2031	1294	131	3	\N	0	\N
2032	1295	131	3	\N	0	\N
2033	1296	131	3	\N	0	\N
2034	1297	131	3	\N	0	\N
2035	1298	131	3	\N	0	\N
2036	1299	131	3	\N	0	\N
2037	1300	131	3	\N	0	\N
2038	1301	131	3	\N	0	\N
2039	1302	131	2	\N	0	\N
2040	1303	131	2	\N	0	\N
2041	1304	131	2	\N	0	\N
2042	1305	131	2	\N	0	\N
2043	1306	131	2	\N	0	\N
2044	1307	131	2	\N	0	\N
2045	1308	131	2	\N	0	\N
2046	1309	131	2	\N	0	\N
2047	1310	131	2	\N	0	\N
2048	1311	131	2	\N	0	\N
2049	1312	131	2	\N	0	\N
2050	1313	131	2	\N	0	\N
2051	1314	131	2	\N	0	\N
2052	1315	131	2	\N	0	\N
2053	1316	131	2	\N	0	\N
2054	1317	131	2	\N	0	\N
2055	1318	131	2	\N	0	\N
2056	1319	131	2	\N	0	\N
2057	1320	131	2	\N	0	\N
2058	1321	131	2	\N	0	\N
2059	1322	131	2	\N	0	\N
2060	1323	131	2	\N	0	\N
2061	1324	131	2	\N	0	\N
2062	1325	131	2	\N	0	\N
2063	1326	131	2	\N	0	\N
2064	1327	131	2	\N	0	\N
2065	1328	131	2	\N	0	\N
2066	1329	131	2	\N	0	\N
2067	1330	131	2	\N	0	\N
2068	1331	131	2	\N	0	\N
2069	1332	131	2	\N	0	\N
2070	1333	131	2	\N	0	\N
2071	1334	131	2	\N	0	\N
2072	1335	131	2	\N	0	\N
2073	1336	131	2	\N	0	\N
2074	1337	131	1	\N	0	\N
2075	1338	131	1	\N	0	\N
2076	1339	131	1	\N	0	\N
2077	1340	131	1	\N	0	\N
2078	1341	131	1	\N	0	\N
2079	1342	131	1	\N	0	\N
2080	1343	131	1	\N	0	\N
2081	1344	131	1	\N	0	\N
2082	1345	131	1	\N	0	\N
2083	1346	131	1	\N	0	\N
2084	1347	131	1	\N	0	\N
2085	1348	131	1	\N	0	\N
2086	1349	131	1	\N	0	\N
2087	1350	131	1	\N	0	\N
2088	1351	131	1	\N	0	\N
2089	1352	131	1	\N	0	\N
2090	1353	131	1	\N	0	\N
2091	1354	131	1	\N	0	\N
2092	1355	131	1	\N	0	\N
2093	1356	131	1	\N	0	\N
2094	1357	131	1	\N	0	\N
2095	1358	131	1	\N	0	\N
2096	1359	131	1	\N	0	\N
2097	1360	131	1	\N	0	\N
2098	1361	131	1	\N	0	\N
2099	1362	131	1	\N	0	\N
2100	1363	131	1	\N	0	\N
2101	1364	131	1	\N	0	\N
2102	1365	131	1	\N	0	\N
2103	1366	131	1	\N	0	\N
2104	1367	131	1	\N	0	\N
2105	1368	131	1	\N	0	\N
2106	1369	131	1	\N	0	\N
2107	1370	131	1	\N	0	\N
2108	1371	131	1	\N	0	\N
2109	1375	73	495	\N	1	\N
2110	1376	231	495	\N	1	\N
2111	1427	123	12	\N	1	\N
2112	1428	229	12	\N	1	\N
2113	1429	131	78	\N	0	\N
2114	1430	131	78	\N	0	\N
2115	1433	131	63	\N	0	\N
2116	1434	131	63	\N	0	\N
2117	1435	105	22203	\N	1	\N
2118	1436	105	8795	\N	1	\N
2119	1437	19	8795	\N	2	\N
2120	1437	231	22203	\N	1	\N
2121	1439	235	36722	\N	3	\N
2122	1439	12	2	\N	0	\N
2123	1439	267	86779	\N	1	\N
2124	1439	232	49634	\N	2	\N
2125	1439	3	188	\N	4	\N
2126	1440	231	86779	\N	1	\N
2127	1441	231	49634	\N	1	\N
2128	1442	231	36722	\N	1	\N
2129	1443	231	188	\N	1	\N
2130	1444	231	2	\N	1	\N
2131	1447	234	25115	\N	1	\N
2132	1448	234	16795	\N	1	\N
2133	1449	19	16795	\N	2	\N
2134	1449	231	25115	\N	1	\N
2135	1450	24	2	\N	0	\N
2136	1450	51	10	\N	1	\N
2137	1451	105	10	\N	1	\N
2138	1452	105	2	\N	1	\N
2139	1457	24	6	\N	0	\N
2140	1457	51	47	\N	1	\N
2141	1458	105	47	\N	1	\N
2142	1459	105	6	\N	1	\N
2143	1460	24	105	\N	0	\N
2144	1460	51	427	\N	1	\N
2145	1461	105	427	\N	1	\N
2146	1462	105	105	\N	1	\N
2147	1463	24	1637	\N	0	\N
2148	1463	51	4987	\N	1	\N
2149	1464	105	4987	\N	1	\N
2150	1465	105	1637	\N	1	\N
2151	1469	51	2	\N	1	\N
2152	1470	105	2	\N	1	\N
2153	1471	51	5	\N	1	\N
2154	1472	105	5	\N	1	\N
2155	1478	24	26587	\N	0	\N
2156	1478	51	49581	\N	1	\N
2157	1479	105	49581	\N	1	\N
2158	1480	105	26587	\N	1	\N
2159	1481	24	38911	\N	0	\N
2160	1481	51	85651	\N	1	\N
2161	1482	105	85651	\N	1	\N
2162	1483	105	38911	\N	1	\N
2163	1485	108	187324	\N	1	\N
2164	1486	96	187324	\N	1	\N
2165	1488	177	584	\N	0	\N
2166	1488	112	54	\N	0	\N
2167	1488	46	23164	\N	1	\N
2168	1489	177	2	\N	0	\N
2169	1489	112	95	\N	0	\N
2170	1489	46	198	\N	1	\N
2171	1490	231	23164	\N	1	\N
2172	1490	19	198	\N	2	\N
2173	1491	231	584	\N	1	\N
2174	1491	19	2	\N	2	\N
2175	1492	231	54	\N	2	\N
2176	1492	19	95	\N	1	\N
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
69		http://ldf.fi/schema/yoma/	0	t	0
70	skosxl	http://www.w3.org/2008/05/skos-xl#	0	f	0
71	gvp	http://vocab.getty.edu/ontology#	0	f	0
75	biocrm	http://ldf.fi/schema/bioc/	0	f	0
72	y-ext	http://ldf.fi/yoma/external/	0	f	0
73	y-rel	http://ldf.fi/yoma/relations/	0	f	0
74	ldf-s	http://ldf.fi/schema/ldf/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_ldf_fi_yoma_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_ldf_fi_yoma_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://ldf.fi/yoma/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://ldf.fi/yoma/sparql", "correlationId": "3383844293340974879", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": true, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": false, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:34:03.090Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://www.w3.org/2004/02/skos/core#altLabel	19124	\N	4	altLabel	altLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://ldf.fi/schema/yoma/supervisor	4962	\N	69	supervisor	supervisor	f	4962	\N	\N	f	f	\N	231	\N	t	f	\N	\N	\N	t	f	f
3	http://ldf.fi/schema/ldf/dataDocumentation	12	\N	74	dataDocumentation	dataDocumentation	f	12	\N	\N	f	f	123	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://ldf.fi/schema/yoma/number_of_spouses	21520	\N	69	number_of_spouses	number_of_spouses	f	0	\N	\N	f	f	231	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://schema.org/date	221540	\N	9	date	date	f	221540	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://ldf.fi/schema/yoma/coordinate	27978	\N	69	coordinate	coordinate	f	27978	\N	\N	f	f	231	56	\N	t	f	\N	\N	\N	t	f	f
8	http://schema.org/givenName	92758	\N	9	givenName	givenName	f	0	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://ldf.fi/schema/yoma/place_of_end	24097	\N	69	place_of_end	place_of_end	f	24097	\N	\N	f	f	\N	46	\N	t	f	\N	\N	\N	t	f	f
10	http://ldf.fi/schema/yoma/geonames	4564	\N	69	geonames	geonames	f	4564	\N	\N	f	f	46	170	\N	t	f	\N	\N	\N	t	f	f
11	http://vocab.getty.edu/ontology#estEnd	62352	\N	71	estEnd	estEnd	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://ldf.fi/schema/yoma/value	123197	\N	69	value	value	f	0	\N	\N	f	f	182	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://schema.org/place	138090	\N	9	place	place	f	138090	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://ldf.fi/schema/yoma/id	28002	\N	69	id	id	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://rdfs.org/ns/void#uriSpace	13	\N	16	uriSpace	uriSpace	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://ldf.fi/schema/yoma/wikidata	6	\N	69	wikidata	wikidata	f	6	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://purl.org/dc/terms/creator	3	\N	5	creator	creator	f	3	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://ldf.fi/schema/yoma/student_nation	4510	\N	69	student_nation	student_nation	f	4510	\N	\N	f	f	\N	27	\N	t	f	\N	\N	\N	t	f	f
22	http://ldf.fi/yoma/relations/level	122	\N	73	level	level	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://ldf.fi/schema/yoma/title_text	34513	\N	69	title_text	title_text	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://www.w3.org/2008/05/skos-xl#prefLabel	75224	\N	70	prefLabel	prefLabel	f	75224	\N	\N	f	f	\N	105	\N	t	f	\N	\N	\N	t	f	f
26	http://xmlns.com/foaf/0.1/homepage	6	\N	8	homepage	homepage	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://ldf.fi/schema/yoma/link_by	395958	\N	69	link_by	link_by	f	395958	\N	\N	f	f	182	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://www.w3.org/ns/sparql-service-description#defaultDataset	1	\N	27	defaultDataset	defaultDataset	f	1	\N	\N	f	f	161	102	\N	t	f	\N	\N	\N	t	f	f
29	http://ldf.fi/yoma/relations/distance	119	\N	73	distance	distance	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://ldf.fi/schema/yoma/abstract	18469	\N	69	abstract	abstract	f	0	\N	\N	f	f	231	\N	\N	t	f	\N	\N	\N	t	f	f
31	http://www.w3.org/2004/02/skos/core#hiddenLabel	18093	\N	4	hiddenLabel	hiddenLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://www.w3.org/2004/02/skos/core#broader	74715	\N	4	broader	broader	f	74715	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://purl.org/dc/terms/rightsHolder	31	\N	5	rightsHolder	rightsHolder	f	31	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://rdfs.org/ns/void#uriLookupEndPoint	1	\N	16	uriLookupEndPoint	uriLookupEndPoint	f	1	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://www.w3.org/ns/sparql-service-description#namedGraph	14	\N	27	namedGraph	namedGraph	f	14	\N	\N	f	f	102	229	\N	t	f	\N	\N	\N	t	f	f
37	http://ldf.fi/schema/yoma/spouse_no	21034	\N	69	spouse_no	spouse_no	f	0	\N	\N	f	f	96	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://ldf.fi/schema/yoma/wikipedia	748	\N	69	wikipedia	wikipedia	f	748	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
39	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	2	\N	2	subPropertyOf	subPropertyOf	f	2	\N	\N	f	f	108	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://www.w3.org/2002/07/owl#sameAs	608	\N	7	sameAs	sameAs	f	608	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://ldf.fi/schema/yoma/comment	69512	\N	69	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://ldf.fi/schema/yoma/kb	3	\N	69	kb	kb	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://ldf.fi/schema/yoma/entry_text	27978	\N	69	entry_text	entry_text	f	0	\N	\N	f	f	231	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://ldf.fi/schema/yoma/country_of_end	24061	\N	69	country_of_end	country_of_end	f	24061	\N	\N	f	f	\N	112	\N	t	f	\N	\N	\N	t	f	f
49	http://ldf.fi/schema/yoma/date_of_origin	23742	\N	69	date_of_origin	date_of_origin	f	23742	\N	\N	f	f	\N	234	\N	t	f	\N	\N	\N	t	f	f
50	http://www.w3.org/2000/01/rdf-schema#label	4700	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://purl.org/dc/terms/title	14	\N	5	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://ldf.fi/schema/yoma/code	310	\N	69	code	code	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://ldf.fi/schema/yoma/has_death	42389	\N	69	[kuolintapahtuma (has_death)]	has_death	f	42389	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://ldf.fi/schema/yoma/has_burial	1260	\N	69	[hautaaminen (has_burial)]	has_burial	f	1260	\N	\N	f	f	231	77	\N	t	f	\N	\N	\N	t	f	f
19	http://ldf.fi/schema/bioc/has_family_relation	324736	\N	75	[perhesuhde (has_family_relation)]	has_family_relation	f	324736	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
32	http://ldf.fi/schema/yoma/has_enrollment	27691	\N	69	[kirjautuminen (has_enrollment)]	has_enrollment	f	27691	\N	\N	f	f	231	12	\N	t	f	\N	\N	\N	t	f	f
42	http://ldf.fi/schema/yoma/in_bio	58148	\N	69	[biografiat, joissa henkilö mainitaan (in_bio)]	in_bio	f	58148	\N	\N	f	f	\N	231	\N	t	f	\N	\N	\N	t	f	f
45	http://ldf.fi/schema/yoma/has_title	111261	\N	69	[arvo, ammatti tai toiminta (has_title)]	has_title	f	111261	\N	\N	f	f	\N	95	\N	t	f	\N	\N	\N	t	f	f
46	http://ldf.fi/schema/yoma/has_reference	104718	\N	69	[viittaus lähdeaineistoon (has_reference)]	has_reference	f	104718	\N	\N	f	f	\N	148	\N	t	f	\N	\N	\N	t	f	f
53	http://schema.org/gender	74733	\N	9	gender	gender	f	74733	\N	\N	f	f	\N	243	\N	t	f	\N	\N	\N	t	f	f
54	http://rdfs.org/ns/void#exampleResource	11	\N	16	exampleResource	exampleResource	f	11	\N	\N	f	f	123	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://www.w3.org/1999/02/22-rdf-syntax-ns#object	187324	\N	1	object	object	f	187324	\N	\N	f	f	96	\N	\N	t	f	\N	\N	\N	t	f	f
56	http://www.w3.org/ns/sparql-service-description#graph	14	\N	27	graph	graph	f	14	\N	\N	f	f	229	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://www.w3.org/2004/02/skos/core#prefLabel	735576	\N	4	prefLabel	prefLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
59	http://www.w3.org/2008/05/skos-xl#hiddenLabel	7380	\N	70	hiddenLabel	hiddenLabel	f	7380	\N	\N	f	f	\N	105	\N	t	f	\N	\N	\N	t	f	f
60	http://ldf.fi/schema/yoma/has_part	11091	\N	69	has_part	has_part	f	11091	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
62	http://purl.org/dc/terms/source	28002	\N	5	source	source	f	28002	\N	\N	f	f	\N	32	\N	t	f	\N	\N	\N	t	f	f
63	http://schema.org/sameAs	63458	\N	9	sameAs	sameAs	f	63458	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
64	http://ldf.fi/schema/yoma/nbf	2	\N	69	nbf	nbf	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://ldf.fi/schema/yoma/county_of_end	21789	\N	69	county_of_end	county_of_end	f	21789	\N	\N	f	f	\N	177	\N	t	f	\N	\N	\N	t	f	f
66	http://www.w3.org/2003/01/geo/wgs84_pos#long	9244	\N	25	long	long	f	0	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://purl.org/dc/terms/description	17	\N	5	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://ldf.fi/schema/yoma/country_of_origin	23361	\N	69	country_of_origin	country_of_origin	f	23361	\N	\N	f	f	\N	112	\N	t	f	\N	\N	\N	t	f	f
69	http://ldf.fi/schema/bioc/inheres_in	275610	\N	75	inheres_in	inheres_in	f	275610	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://ldf.fi/schema/yoma/weight	1750	\N	69	weight	weight	f	0	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
71	http://www.w3.org/2000/01/rdf-schema#subClassOf	179	\N	2	subClassOf	subClassOf	f	179	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
72	http://purl.org/dc/terms/subject	4	\N	5	subject	subject	f	4	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://rdfs.org/ns/void#dataDump	12	\N	16	dataDump	dataDump	f	12	\N	\N	f	f	123	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://ldf.fi/schema/ldf/starRating	1	\N	74	starRating	starRating	f	0	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
75	http://vocab.getty.edu/ontology#estStart	62421	\N	71	estStart	estStart	f	0	\N	\N	f	f	234	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://www.w3.org/1999/02/22-rdf-syntax-ns#subject	187324	\N	1	subject	subject	f	187324	\N	\N	f	f	96	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://ldf.fi/schema/yoma/related_occupation	10934	\N	69	related_occupation	related_occupation	f	10934	\N	\N	f	f	95	13	\N	t	f	\N	\N	\N	t	f	f
78	http://purl.org/dc/terms/publisher	3	\N	5	publisher	publisher	f	3	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://ldf.fi/schema/ldf/dataVisualization	5	\N	74	dataVisualization	dataVisualization	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
80	http://ldf.fi/schema/yoma/event_no	157630	\N	69	event_no	event_no	f	0	\N	\N	f	f	96	\N	\N	t	f	\N	\N	\N	t	f	f
81	http://schema.org/image	6911	\N	9	image	image	f	6911	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://ldf.fi/schema/yoma/reference_text	18457	\N	69	reference_text	reference_text	f	0	\N	\N	f	f	231	\N	\N	t	f	\N	\N	\N	t	f	f
83	http://www.w3.org/ns/sparql-service-description#resultFormat	4	\N	27	resultFormat	resultFormat	f	4	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
84	http://ldf.fi/schema/yoma/organization	14879	\N	69	organization	organization	f	14879	\N	\N	f	f	\N	253	\N	t	f	\N	\N	\N	t	f	f
86	http://ldf.fi/schema/yoma/fname	85766	\N	69	fname	fname	f	85766	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://xmlns.com/foaf/0.1/phone	1	\N	8	phone	phone	f	0	\N	\N	f	f	147	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://ldf.fi/yoma/relations/relates_to	246394	\N	73	relates_to	relates_to	f	246394	\N	\N	f	f	182	231	\N	t	f	\N	\N	\N	t	f	f
89	http://www.w3.org/2004/02/skos/core#related	1792	\N	4	related	related	f	1792	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://ldf.fi/schema/yoma/county_of_origin	21559	\N	69	county_of_origin	county_of_origin	f	21559	\N	\N	f	f	\N	177	\N	t	f	\N	\N	\N	t	f	f
91	http://ldf.fi/schema/bioc/inverse_role	194	\N	75	inverse_role	inverse_role	f	194	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://rdfs.org/ns/void#sparqlEndpoint	1	\N	16	sparqlEndpoint	sparqlEndpoint	f	1	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://ldf.fi/schema/yoma/has_baptism	495	\N	69	has_baptism	has_baptism	f	495	\N	\N	f	f	231	73	\N	t	f	\N	\N	\N	t	f	f
94	http://ldf.fi/schema/yoma/y	27978	\N	69	y	y	f	0	\N	\N	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
95	http://www.w3.org/ns/sparql-service-description#defaultEntailmentRegime	1	\N	27	defaultEntailmentRegime	defaultEntailmentRegime	f	1	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://ldf.fi/schema/yoma/inferred	123333	\N	69	inferred	inferred	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://www.w3.org/ns/sparql-service-description#name	14	\N	27	name	name	f	14	\N	\N	f	f	229	\N	\N	t	f	\N	\N	\N	t	f	f
98	http://ldf.fi/yoma/relations/compound_1	78	\N	73	compound_1	compound_1	f	78	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
99	http://ldf.fi/schema/yoma/x	27978	\N	69	x	x	f	0	\N	\N	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://schema.org/familyName	92871	\N	9	familyName	familyName	f	0	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
101	http://ldf.fi/yoma/relations/compound_2	63	\N	73	compound_2	compound_2	f	63	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
102	http://www.w3.org/2008/05/skos-xl#altLabel	32974	\N	70	altLabel	altLabel	f	32974	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
103	http://xmlns.com/foaf/0.1/mbox	1	\N	8	mbox	mbox	f	0	\N	\N	f	f	147	\N	\N	t	f	\N	\N	\N	t	f	f
104	http://ldf.fi/schema/yoma/has_event	171402	\N	69	has_event	has_event	f	171402	\N	\N	f	f	231	\N	\N	t	f	\N	\N	\N	t	f	f
105	http://purl.org/dc/terms/author	4	\N	5	author	author	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://ldf.fi/schema/yoma/has_category	41007	\N	69	[kuuluu kategoriaan (has_category)]	has_category	f	41007	\N	\N	f	f	231	28	\N	t	f	\N	\N	\N	t	f	f
61	http://ldf.fi/schema/yoma/has_birth	25885	\N	69	[synnyintapahtuma (has_birth)]	has_birth	f	25885	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
106	http://ldf.fi/schema/yoma/date_of_end	41914	\N	69	date_of_end	date_of_end	f	41914	\N	\N	f	f	\N	234	\N	t	f	\N	\N	\N	t	f	f
107	http://ldf.fi/schema/yoma/name_6	10	\N	69	name_6	name_6	f	10	\N	\N	f	f	105	51	\N	t	f	\N	\N	\N	t	f	f
108	http://purl.org/dc/terms/license	13	\N	5	license	license	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://ldf.fi/schema/yoma/name_5	47	\N	69	name_5	name_5	f	47	\N	\N	f	f	105	51	\N	t	f	\N	\N	\N	t	f	f
110	http://ldf.fi/schema/yoma/name_4	427	\N	69	name_4	name_4	f	427	\N	\N	f	f	105	51	\N	t	f	\N	\N	\N	t	f	f
111	http://ldf.fi/schema/yoma/name_3	4987	\N	69	name_3	name_3	f	4987	\N	\N	f	f	105	51	\N	t	f	\N	\N	\N	t	f	f
112	http://www.w3.org/2003/01/geo/wgs84_pos#lat	9244	\N	25	lat	lat	f	0	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://ldf.fi/schema/yoma/name_8	2	\N	69	name_8	name_8	f	2	\N	\N	f	f	105	51	\N	t	f	\N	\N	\N	t	f	f
114	http://ldf.fi/schema/yoma/name_7	5	\N	69	name_7	name_7	f	5	\N	\N	f	f	105	51	\N	t	f	\N	\N	\N	t	f	f
115	http://ldf.fi/schema/yoma/enrollment_text	27956	\N	69	enrollment_text	enrollment_text	f	0	\N	\N	f	f	231	\N	\N	t	f	\N	\N	\N	t	f	f
116	http://ldf.fi/schema/yoma/number_of_events	2937	\N	69	number_of_events	number_of_events	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
117	http://ldf.fi/schema/yoma/relative_text	20397	\N	69	relative_text	relative_text	f	0	\N	\N	f	f	231	\N	\N	t	f	\N	\N	\N	t	f	f
118	http://ldf.fi/schema/yoma/name_2	49581	\N	69	name_2	name_2	f	49581	\N	\N	f	f	105	51	\N	t	f	\N	\N	\N	t	f	f
119	http://ldf.fi/schema/yoma/name_1	85653	\N	69	name_1	name_1	f	85653	\N	\N	f	f	105	\N	\N	t	f	\N	\N	\N	t	f	f
120	http://rdfs.org/ns/void#vocabulary	48	\N	16	vocabulary	vocabulary	f	48	\N	\N	f	f	123	\N	\N	t	f	\N	\N	\N	t	f	f
121	http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate	187324	\N	1	predicate	predicate	f	187324	\N	\N	f	f	96	108	\N	t	f	\N	\N	\N	t	f	f
122	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	161	\N	\N	t	f	\N	\N	\N	t	f	f
123	http://ldf.fi/schema/yoma/place_of_origin	23363	\N	69	place_of_origin	place_of_origin	f	23363	\N	\N	f	f	\N	46	\N	t	f	\N	\N	\N	t	f	f
85	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	1137110	\N	1	type	type	f	1137110	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
7	http://ldf.fi/schema/bioc/has_person_relation	6074	\N	75	[ihmissuhde (has_person_relation)]	has_person_relation	f	6074	\N	\N	f	f	231	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

COPY http_ldf_fi_yoma_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	1	8	toissijainen nimi	fi
2	4	8	puolisoiden lukumäärä	fi
3	5	8	päivämäärä	fi
4	6	8	coordinate of embedding into a two-dimensional space	en
5	7	8	ihmissuhde	fi
6	8	8	etunimi	fi
7	9	8	kuolinpaikka	fi
8	11	8	loppuhetki	fi
9	12	8	lukuarvo	fi
10	13	8	kuolintapahtuma	fi
11	14	8	paikka	fi
12	15	8	tunniste	fi
13	17	8	Wikidata-resurssi	fi
14	18	8	hautaaminen	fi
15	19	8	perhesuhde	fi
16	21	8	osakunta	fi
17	22	8	tasoero sukupuussa	fi
18	23	8	tekstikentässä mainittu arvo, ammatti tai toiminta	fi
19	25	8	ensisijainen nimi	fi
20	27	8	liittyvät ominaisuudet	fi
21	29	8	etäisyys sukupuussa	fi
22	30	8	tiivistelmä	fi
23	31	8	vaihtoehtoinen, ei-suositeltu nimi	fi
24	32	8	kirjautuminen	fi
25	33	9	Broader instance in hiearchy	\N
26	33	8	laajempi yläinstanssi	fi
27	37	8	puoliso n:o	fi
28	38	8	Wikipedia-sivu	fi
29	39	8	yläominaisuus	fi
30	41	8	kommentti	fi
31	42	8	biografiat, joissa henkilö mainitaan	fi
32	43	8	tunniste kansallisbiografia-sivustolla	fi
33	44	8	matrikkeliteksti	fi
34	45	8	arvo, ammatti tai toiminta	fi
35	46	8	viittaus lähdeaineistoon	fi
36	48	8	kuolinvaltio	fi
37	49	8	synnyinhetki	fi
38	52	8	1853–matrikkelissa käytetty koodi	fi
39	53	8	sukupuoli	fi
40	55	8	objekti	fi
41	57	8	ensisijainen nimi	fi
42	58	8	kuuluu kategoriaan	fi
43	61	8	synnyintapahtuma	fi
44	62	8	lähde	fi
45	63	8	link to an external url or website	en
46	64	8	tunniste biografiasampo-sivustolla	fi
47	65	8	kuolinmaakunta tai -lääni	fi
48	66	8	pituusaste	fi
49	68	8	synnyinvaltio	fi
50	71	8	yläluokka	fi
51	75	8	alkuhetki	fi
52	76	8	subjekti	fi
53	81	8	kuvatiedosto	fi
54	82	8	tekstikentän viittaukset	fi
55	84	8	organisaatio	fi
56	85	8	tyyppi	fi
57	88	8	liittyvät henkilöt	fi
58	90	8	synnyinmaakunta tai -lääni	fi
59	91	8	käänteinen suhde	fi
60	93	8	kastetapahtuma	fi
61	100	8	sukunimi	fi
62	102	8	toissijainen nimi	fi
63	104	8	liittyy tapahtumaan	fi
64	106	8	kuolinhetki	fi
65	112	8	leveysaste	fi
66	115	8	tekstikentän tiedot kirjautumisesta	fi
67	116	8	tapahtumien lukumäärä	fi
68	117	8	tekstikentän sukulaiskuvaus	fi
69	121	8	predikaatti	fi
70	123	8	synnyinpaikka	fi
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.annot_types_id_seq', 9, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.cc_rels_id_seq', 4, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.class_annots_id_seq', 442, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.classes_id_seq', 267, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.cp_rels_id_seq', 1492, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.cpc_rels_id_seq', 2176, true);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.ns_id_seq', 75, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.properties_id_seq', 123, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_yoma_sparql.property_annots_id_seq', 70, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_ldf_fi_yoma_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_ldf_fi_yoma_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_ldf_fi_yoma_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_ldf_fi_yoma_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_ldf_fi_yoma_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_ldf_fi_yoma_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_ldf_fi_yoma_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_ldf_fi_yoma_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_ldf_fi_yoma_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_ldf_fi_yoma_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_ldf_fi_yoma_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_ldf_fi_yoma_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_ldf_fi_yoma_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_ldf_fi_yoma_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_ldf_fi_yoma_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_ldf_fi_yoma_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_ldf_fi_yoma_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_ldf_fi_yoma_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_ldf_fi_yoma_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_ldf_fi_yoma_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_ldf_fi_yoma_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_ldf_fi_yoma_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_ldf_fi_yoma_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_ldf_fi_yoma_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_ldf_fi_yoma_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_ldf_fi_yoma_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_ldf_fi_yoma_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_ldf_fi_yoma_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_ldf_fi_yoma_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_ldf_fi_yoma_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_ldf_fi_yoma_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_ldf_fi_yoma_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_ldf_fi_yoma_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_ldf_fi_yoma_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_ldf_fi_yoma_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_ldf_fi_yoma_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_ldf_fi_yoma_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_ldf_fi_yoma_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_ldf_fi_yoma_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_ldf_fi_yoma_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_ldf_fi_yoma_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_ldf_fi_yoma_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_ldf_fi_yoma_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_ldf_fi_yoma_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_ldf_fi_yoma_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_ldf_fi_yoma_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_ldf_fi_yoma_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_ldf_fi_yoma_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_ldf_fi_yoma_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_ldf_fi_yoma_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_ldf_fi_yoma_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_ldf_fi_yoma_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_ldf_fi_yoma_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_ldf_fi_yoma_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_ldf_fi_yoma_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_ldf_fi_yoma_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_ldf_fi_yoma_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_ldf_fi_yoma_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_ldf_fi_yoma_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_ldf_fi_yoma_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_ldf_fi_yoma_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_ldf_fi_yoma_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_ldf_fi_yoma_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_ldf_fi_yoma_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_ldf_fi_yoma_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_ldf_fi_yoma_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_ldf_fi_yoma_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_yoma_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_yoma_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_ldf_fi_yoma_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

