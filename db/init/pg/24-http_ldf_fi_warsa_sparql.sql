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
-- Name: http_ldf_fi_warsa_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_ldf_fi_warsa_sparql;


--
-- Name: SCHEMA http_ldf_fi_warsa_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_ldf_fi_warsa_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE FUNCTION http_ldf_fi_warsa_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE FUNCTION http_ldf_fi_warsa_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COMMENT ON TABLE http_ldf_fi_warsa_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COMMENT ON COLUMN http_ldf_fi_warsa_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_ldf_fi_warsa_sparql.classes c1
     JOIN http_ldf_fi_warsa_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_ldf_fi_warsa_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_ldf_fi_warsa_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_ldf_fi_warsa_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE TABLE http_ldf_fi_warsa_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE http_ldf_fi_warsa_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_ldf_fi_warsa_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_cc_rels AS
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
   FROM http_ldf_fi_warsa_sparql.cc_rels r,
    http_ldf_fi_warsa_sparql.classes c1,
    http_ldf_fi_warsa_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_classes_ns AS
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
    http_ldf_fi_warsa_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_ldf_fi_warsa_sparql.classes c
     LEFT JOIN http_ldf_fi_warsa_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_classes_ns_main AS
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
   FROM http_ldf_fi_warsa_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_ldf_fi_warsa_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_classes_ns_plus AS
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
    http_ldf_fi_warsa_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_ldf_fi_warsa_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_ldf_fi_warsa_sparql.classes c
     LEFT JOIN http_ldf_fi_warsa_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_classes_ns_main_plus AS
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
   FROM http_ldf_fi_warsa_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_ldf_fi_warsa_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_ldf_fi_warsa_sparql.v_classes_ns v
     LEFT JOIN http_ldf_fi_warsa_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_cp_rels AS
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
    http_ldf_fi_warsa_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_ldf_fi_warsa_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_ldf_fi_warsa_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_ldf_fi_warsa_sparql.cp_rels r,
    http_ldf_fi_warsa_sparql.classes c,
    http_ldf_fi_warsa_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_cp_rels_card AS
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
   FROM http_ldf_fi_warsa_sparql.cp_rels r,
    http_ldf_fi_warsa_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_properties_ns AS
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
    http_ldf_fi_warsa_sparql.tapprox(p.cnt) AS cnt_x,
    http_ldf_fi_warsa_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_ldf_fi_warsa_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_ldf_fi_warsa_sparql.properties p
     LEFT JOIN http_ldf_fi_warsa_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_cp_sources_single AS
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
   FROM ((http_ldf_fi_warsa_sparql.v_cp_rels_card r
     JOIN http_ldf_fi_warsa_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_ldf_fi_warsa_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_cp_targets_single AS
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
   FROM ((http_ldf_fi_warsa_sparql.v_cp_rels_card r
     JOIN http_ldf_fi_warsa_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_ldf_fi_warsa_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_ldf_fi_warsa_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_ldf_fi_warsa_sparql.pp_rels r,
    http_ldf_fi_warsa_sparql.properties p1,
    http_ldf_fi_warsa_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_properties_sources AS
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
   FROM (http_ldf_fi_warsa_sparql.v_properties_ns v
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
           FROM http_ldf_fi_warsa_sparql.cp_rels r,
            http_ldf_fi_warsa_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_properties_sources_single AS
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
   FROM (http_ldf_fi_warsa_sparql.v_properties_ns v
     LEFT JOIN http_ldf_fi_warsa_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_properties_targets AS
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
   FROM (http_ldf_fi_warsa_sparql.v_properties_ns v
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
           FROM http_ldf_fi_warsa_sparql.cp_rels r,
            http_ldf_fi_warsa_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE VIEW http_ldf_fi_warsa_sparql.v_properties_targets_single AS
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
   FROM (http_ldf_fi_warsa_sparql.v_properties_ns v
     LEFT JOIN http_ldf_fi_warsa_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	skos:prefLabel	\N	\N
9	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	6	58	1	\N	\N
2	19	88	1	\N	\N
3	31	88	1	\N	\N
4	49	6	1	\N	\N
5	56	88	1	\N	\N
6	65	88	1	\N	\N
7	70	88	1	\N	\N
8	74	60	1	\N	\N
9	82	80	1	\N	\N
10	88	60	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	2	8	Video	en
2	2	8	Video	fi
3	4	8	Wounding	en
4	4	8	Haavoittuminen	fi
5	5	8	Dissolution of a Military Group	en
6	5	8	Joukko-osaston lakkauttaminen	fi
7	7	8	Troop Movement	en
8	7	8	Joukkojen liikutus	fi
9	9	8	Group	en
10	9	8	Ryhmä	fi
11	10	8	Kunta	fi
12	10	8	Municipality	en
13	11	8	Disappearing	en
14	11	8	Katoaminen	fi
15	12	8	Vesimuodostuma	fi
16	12	8	Body of water	en
17	15	8	Military Rank	en
18	15	8	Sotilasarvo	fi
19	16	8	Unit Naming	en
20	16	8	Joukko-osaston nimeäminen	fi
21	17	8	Medal	en
22	17	8	Kunniamitali	fi
23	19	8	Degree	en
24	19	8	Oppiarvo	fi
25	20	8	Event	en
26	20	8	Tapahtuma	fi
27	21	8	Political Activity	en
28	21	8	Poliittinen toiminta	fi
29	22	8	Death	en
30	22	8	Kuolema	fi
31	23	8	Image size	en
32	23	8	Kuvakoko	fi
33	24	8	Marital Status	en
34	24	8	Siviilisääty	fi
35	25	8	Kylä	fi
36	25	8	Village	en
37	28	9	Class	\N
38	29	8	Person joining a Military Unit	en
39	29	8	Henkilön liittyminen joukko-osastoon	fi
40	30	8	War Diary	en
41	30	8	Sotapäiväkirja	fi
42	31	8	Title	en
43	31	8	Arvonimi	fi
44	32	8	Menehtymisluokka	fi
45	32	8	Perishing category	en
46	33	8	Source	en
47	33	8	Lähde	fi
48	34	8	Ajanjakso	fi
49	34	8	Period	en
50	35	8	Conflict	en
51	35	8	Sota	fi
52	36	8	Prisoner-of-War Camp	en
53	36	8	Sotavankileiri	fi
54	37	9	Class	\N
55	38	8	Place	en
56	38	8	Paikka	fi
57	40	8	Prisoner of War Record	en
58	40	8	Sotavankiasiakirja	fi
59	41	8	Sotilasyksikkö	fi
60	41	8	Military Unit	en
61	42	8	Mother tongue	en
62	42	8	Äidinkieli	fi
63	43	9	ObjectProperty	\N
64	44	8	Photograph	en
65	44	8	Valokuva	fi
66	45	8	Kunniamitalin myöntäminen	fi
67	45	8	Medal Awarding	en
68	46	9	Concept Scheme	en
69	47	8	Kunta	fi
70	47	8	Municipality	en
71	48	8	Formation of a Military Group	en
72	48	8	Joukko-osaston muodostaminen	fi
73	51	8	Valtio	fi
74	51	8	Country	en
75	53	8	Gender	en
76	53	8	Sukupuoli	fi
77	55	8	Article	en
78	55	8	Artikkeli	fi
79	56	8	Role	en
80	56	8	Rooli	fi
81	57	8	Military Activity	en
82	57	8	Sotatoimi	fi
83	60	9	Concept	en
84	61	8	Person	en
85	61	8	Henkilö	fi
86	62	8	Bombardment	en
87	62	8	Pommitus	fi
88	63	8	Cemetery	en
89	63	8	Hautausmaa	fi
90	64	8	Rakennettu kohde	fi
91	64	8	Man-made feature	en
92	65	8	Ammatti	fi
93	65	8	Occupation	en
94	66	8	Kirkonkylä , kaupunki	fi
95	66	8	Town	en
96	67	8	Maastokohde	fi
97	67	8	Hypsographic feature	en
98	68	8	Unit Joining	en
99	68	8	Joukko-osaston liittyminen suurempaan joukko-osastoon	fi
100	69	8	Photography	en
101	69	8	Valokuvaus	fi
102	70	8	Military Rank	en
103	70	8	Sotilasarvo	fi
104	71	8	Citizenship	en
105	71	8	Kansalaisuus	fi
106	72	8	Kansallisuus	fi
107	72	8	Nationality	en
108	73	8	Prisoner of war capture	en
109	73	8	Sotavangiksi jääminen	fi
110	75	8	An image of a Sotilaan Ääni magazine spread or page	en
111	75	8	Kuva Sotilaan Ääni -lehden aukeamasta tai sivusta	fi
112	76	9	DatatypeProperty	\N
113	77	8	Battle	en
114	77	8	Taistelu	fi
115	79	8	Death Record	en
116	79	8	Kuolinasiakirja	fi
117	80	9	Property	\N
118	81	8	Symboli	fi
119	81	8	Symbol	en
120	82	9	AnnotationProperty	\N
121	83	8	Birth	en
122	83	8	Syntymä	fi
123	84	8	Prisoner-of-War Hospital	en
124	84	8	Sotavankisairaala	fi
125	85	8	Lääni	fi
126	85	8	County	en
127	86	8	Military Unit category	en
128	86	8	Sotilasosastotyyppi	fi
129	88	8	AMMO Concept	en
130	88	8	AMMO-käsite	fi
131	89	8	Promotion	en
132	89	8	Ylennys	fi
133	90	8	A document related to one or more persons	en
134	90	8	Yhteen tai useampaan henkilöön liittyvä dokumentti	fi
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	http://ldf.fi/schema/hipla/Topology	625	\N	t	71	Topology	Topology	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	625
2	http://ldf.fi/schema/warsa/Video	27	\N	t	69	Video	Video	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	548
3	http://ldf.fi/schema/bioc/Brother	2	\N	t	72	Brother	Brother	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
4	http://ldf.fi/schema/warsa/Wounding	14361	\N	t	69	Wounding	Wounding	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
5	http://ldf.fi/schema/warsa/Dissolution	7701	\N	t	69	Dissolution	Dissolution	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
6	http://www.w3.org/ns/dcat#Dataset	1	\N	t	15	Dataset	Dataset	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
7	http://ldf.fi/schema/warsa/TroopMovement	684	\N	t	69	TroopMovement	TroopMovement	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
8	http://www.w3.org/ns/sparql-service-description#NamedGraph	14	\N	t	27	NamedGraph	NamedGraph	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14
9	http://ldf.fi/schema/warsa/Group	203	\N	t	69	Group	Group	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1171
10	http://ldf.fi/schema/warsa/casualties/Municipality	632	\N	t	73	Municipality	Municipality	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	411922
11	http://ldf.fi/schema/warsa/Disappearing	5292	\N	t	69	Disappearing	Disappearing	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
12	http://ldf.fi/schema/warsa/Body_of_water	5554	\N	t	69	Body_of_water	Body_of_water	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4364
13	http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement	16845	\N	t	1	Statement	Statement	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
14	http://xmlns.com/foaf/0.1/Organization	2	\N	t	8	Organization	Organization	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20
15	http://ldf.fi/schema/warsa/Rank	206	\N	t	69	Rank	Rank	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	203661
16	http://ldf.fi/schema/warsa/UnitNaming	3250	\N	t	69	UnitNaming	UnitNaming	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
17	http://ldf.fi/schema/warsa/Medal	200	\N	t	69	Medal	Medal	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6088
18	http://www.w3.org/2000/01/rdf-schema#Property	7	\N	t	2	Property	Property	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
19	http://ldf.fi/schema/ammo/Degree	40	\N	t	74	Degree	Degree	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	789
20	http://ldf.fi/schema/warsa/Event	154	\N	t	69	Event	Event	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
21	http://ldf.fi/schema/warsa/PoliticalActivity	231	\N	t	69	PoliticalActivity	PoliticalActivity	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
22	http://ldf.fi/schema/warsa/Death	99263	\N	t	69	Death	Death	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
23	http://ldf.fi/schema/warsa/photographs/Size	3	\N	t	75	Size	Size	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	496211
24	http://ldf.fi/schema/warsa/MaritalStatus	5	\N	t	69	MaritalStatus	MaritalStatus	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	98379
25	http://ldf.fi/schema/warsa/Village	1551	\N	t	69	Village	Village	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12439
26	http://purl.org/dc/terms/BibliographicResource	5	\N	t	5	BibliographicResource	BibliographicResource	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	681
27	http://www.w3.org/2004/02/skos/core#OrderedCollection	3	\N	t	4	OrderedCollection	OrderedCollection	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
28	http://www.w3.org/2002/07/owl#Class	86	\N	t	7	Class	Class	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1042580
29	http://ldf.fi/schema/warsa/PersonJoining	93216	\N	t	69	PersonJoining	PersonJoining	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
30	http://ldf.fi/schema/warsa/WarDiary	26387	\N	t	69	WarDiary	WarDiary	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
31	http://ldf.fi/schema/ammo/Title	68	\N	t	74	Title	Title	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	250
32	http://ldf.fi/schema/warsa/PerishingCategory	7	\N	t	69	PerishingCategory	PerishingCategory	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	94677
33	http://ldf.fi/schema/warsa/Source	2546	\N	t	69	Source	Source	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	898725
35	http://ldf.fi/schema/warsa/Conflict	4	\N	t	69	Conflict	Conflict	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	127362
36	http://ldf.fi/schema/warsa/PowCamp	120	\N	t	69	PowCamp	PowCamp	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7798
37	http://www.w3.org/2000/01/rdf-schema#Class	84	\N	t	2	Class	Class	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1032966
38	http://ldf.fi/schema/hipla/Place	3	\N	t	71	Place	Place	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	625
39	http://www.w3.org/2002/07/owl#Ontology	2	\N	t	7	Ontology	Ontology	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
40	http://ldf.fi/schema/warsa/PrisonerRecord	4200	\N	t	69	PrisonerRecord	PrisonerRecord	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21047
41	http://ldf.fi/schema/warsa/MilitaryUnit	15712	\N	t	69	MilitaryUnit	MilitaryUnit	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	270410
34	http://www.cidoc-crm.org/cidoc-crm/E4_Period	1	\N	t	70	E4_Period	[Ajanjakso (E4_Period)]	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1625
42	http://ldf.fi/schema/warsa/MotherTongue	11	\N	t	69	MotherTongue	MotherTongue	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	98887
43	http://www.w3.org/2002/07/owl#ObjectProperty	62	\N	t	7	ObjectProperty	ObjectProperty	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23
44	http://ldf.fi/schema/warsa/Photograph	166214	\N	t	69	Photograph	Photograph	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	662426
45	http://ldf.fi/schema/warsa/MedalAwarding	6086	\N	t	69	MedalAwarding	MedalAwarding	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
46	http://www.w3.org/2004/02/skos/core#ConceptScheme	17	\N	t	4	ConceptScheme	ConceptScheme	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4096
47	http://www.yso.fi/onto/suo/kunta	627	\N	t	76	kunta	kunta	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	232750
48	http://ldf.fi/schema/warsa/Formation	13489	\N	t	69	Formation	Formation	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
49	http://rdfs.org/ns/void#Dataset	1	\N	t	16	Dataset	Dataset	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
50	http://www.w3.org/ns/sparql-service-description#Graph	15	\N	t	27	Graph	Graph	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26
51	http://www.yso.fi/onto/suo/valtio	1	\N	t	76	valtio	valtio	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
52	http://www.cidoc-crm.org/cidoc-crm/E52_Time-Span	243760	\N	t	70	E52_Time-Span	E52_Time-Span	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	347344
53	http://ldf.fi/schema/warsa/Gender	3	\N	t	69	Gender	Gender	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	94679
54	http://www.cidoc-crm.org/cidoc-crm/E73_Information_Object	496211	\N	t	70	E73_Information_Object	E73_Information_Object	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	496211
55	http://ldf.fi/schema/warsa/Article	3357	\N	t	69	Article	Article	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
56	http://ldf.fi/schema/ammo/Role	17	\N	t	74	Role	Role	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1446
57	http://ldf.fi/schema/warsa/MilitaryActivity	567	\N	t	69	MilitaryActivity	MilitaryActivity	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
58	http://www.w3.org/ns/sparql-service-description#Dataset	1	\N	t	27	Dataset	Dataset	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
59	http://www.w3.org/2004/02/skos/core#Collection	2	\N	t	4	Collection	Collection	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
60	http://www.w3.org/2004/02/skos/core#Concept	7090	\N	t	4	Concept	Concept	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	221502
61	http://ldf.fi/schema/warsa/Person	102613	\N	t	69	Person	Person	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	652985
62	http://ldf.fi/schema/warsa/Bombardment	78	\N	t	69	Bombardment	Bombardment	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
63	http://ldf.fi/schema/warsa/Cemetery	672	\N	t	69	Cemetery	Cemetery	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	86747
64	http://ldf.fi/schema/warsa/Man-made_feature	14363	\N	t	69	Man-made_feature	Man-made_feature	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	21
65	http://ldf.fi/schema/ammo/Occupation	2258	\N	t	74	Occupation	Occupation	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	177664
66	http://ldf.fi/schema/warsa/Town	50	\N	t	69	Town	Town	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2410
67	http://ldf.fi/schema/warsa/Hypsographic_feature	10869	\N	t	69	Hypsographic_feature	Hypsographic_feature	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6017
68	http://ldf.fi/schema/warsa/UnitJoining	9422	\N	t	69	UnitJoining	UnitJoining	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
69	http://ldf.fi/schema/warsa/Photography	116857	\N	t	69	Photography	Photography	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
70	http://ldf.fi/schema/ammo/Military_rank	66	\N	t	74	Military_rank	Military_rank	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1961
71	http://ldf.fi/schema/warsa/Citizenship	10	\N	t	69	Citizenship	Citizenship	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	94763
72	http://ldf.fi/schema/warsa/Nationality	11	\N	t	69	Nationality	Nationality	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	94687
73	http://ldf.fi/schema/warsa/Capture	4202	\N	t	69	Capture	Capture	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
74	http://xmlns.com/foaf/0.1/Person	1586	\N	t	8	Person	Person	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4942
75	http://ldf.fi/schema/warsa/SotilaanAani	340	\N	t	69	SotilaanAani	SotilaanAani	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3964
76	http://www.w3.org/2002/07/owl#DatatypeProperty	88	\N	t	7	DatatypeProperty	DatatypeProperty	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	16797
77	http://ldf.fi/schema/warsa/Battle	938	\N	t	69	Battle	Battle	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
78	http://ldf.fi/schema/warsa/prisoners/Captivity	10983	\N	t	77	Captivity	Captivity	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10987
79	http://ldf.fi/schema/warsa/DeathRecord	94677	\N	t	69	DeathRecord	DeathRecord	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	94672
80	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	14	\N	t	1	Property	Property	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
81	http://ldf.fi/schema/warsa/Symbol	29	\N	t	69	Symbol	Symbol	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
82	http://www.w3.org/2002/07/owl#AnnotationProperty	6	\N	t	7	AnnotationProperty	AnnotationProperty	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
83	http://ldf.fi/schema/warsa/Birth	99801	\N	t	69	Birth	Birth	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
84	http://ldf.fi/schema/warsa/PowHospital	85	\N	t	69	PowHospital	PowHospital	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1047
85	http://www.yso.fi/onto/suo/laani	11	\N	t	76	laani	laani	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	644
86	http://ldf.fi/schema/warsa/UnitCategory	182	\N	t	69	UnitCategory	UnitCategory	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
87	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
88	http://ldf.fi/schema/ammo/Concept	2447	\N	t	74	Concept	Concept	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	182096
89	http://ldf.fi/schema/warsa/Promotion	105652	\N	t	69	Promotion	Promotion	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
90	http://ldf.fi/schema/warsa/PersonDocument	2314	\N	t	69	PersonDocument	PersonDocument	269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4620
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	88	1	2	2452	\N	2452	\N	\N	1	1	2	f	0	\N	\N
2	60	1	2	2452	\N	2452	\N	\N	0	1	2	f	0	\N	\N
3	65	1	2	2263	\N	2263	\N	\N	0	1	2	f	0	\N	\N
4	31	1	2	68	\N	68	\N	\N	0	1	2	f	0	\N	\N
5	70	1	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
6	19	1	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
7	56	1	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
8	60	1	1	2452	\N	2452	\N	\N	1	1	2	f	\N	\N	\N
9	61	2	2	2759	\N	2759	\N	\N	1	1	2	f	0	\N	\N
10	41	2	2	491	\N	491	\N	\N	2	1	2	f	0	\N	\N
11	15	2	2	166	\N	166	\N	\N	3	1	2	f	0	\N	\N
12	17	2	2	2	\N	2	\N	\N	4	1	2	f	0	\N	\N
13	9	2	2	1	\N	1	\N	\N	5	1	2	f	0	\N	\N
14	16	2	2	1	\N	1	\N	\N	6	1	2	f	0	\N	\N
15	40	3	2	4009	\N	0	\N	\N	1	1	2	f	4009	\N	\N
16	22	4	2	1006	\N	0	\N	\N	1	1	2	f	1006	\N	\N
17	83	4	2	695	\N	0	\N	\N	2	1	2	f	695	\N	\N
18	48	4	2	126	\N	0	\N	\N	3	1	2	f	126	\N	\N
19	4	4	2	73	\N	0	\N	\N	4	1	2	f	73	\N	\N
20	11	4	2	49	\N	0	\N	\N	5	1	2	f	49	\N	\N
21	16	4	2	3	\N	0	\N	\N	6	1	2	f	3	\N	\N
22	41	4	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
23	40	5	2	2539	\N	0	\N	\N	1	1	2	f	2539	\N	\N
24	60	6	2	254	\N	0	\N	\N	1	1	2	f	254	\N	\N
25	79	6	2	5	\N	0	\N	\N	2	1	2	f	5	\N	\N
26	26	6	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
27	88	7	2	2452	\N	2452	\N	\N	1	1	2	f	0	\N	\N
28	60	7	2	2452	\N	2452	\N	\N	0	1	2	f	0	\N	\N
29	65	7	2	2263	\N	2263	\N	\N	0	1	2	f	0	\N	\N
30	31	7	2	68	\N	68	\N	\N	0	1	2	f	0	\N	\N
31	70	7	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
32	19	7	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
33	56	7	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
34	60	7	1	2452	\N	2452	\N	\N	1	1	2	f	\N	\N	\N
35	10	8	2	577	\N	577	\N	\N	1	1	2	f	0	\N	\N
36	47	8	1	577	\N	577	\N	\N	1	1	2	f	\N	\N	\N
37	40	9	2	3908	\N	3908	\N	\N	1	1	2	f	0	\N	\N
38	47	9	1	3908	\N	3908	\N	\N	1	1	2	f	\N	\N	\N
39	44	10	2	136296	\N	0	\N	\N	1	1	2	f	136296	\N	\N
40	44	11	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
41	61	11	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
42	60	12	2	843	\N	0	\N	\N	1	1	2	f	843	\N	\N
43	55	13	2	3358	\N	3358	\N	\N	1	1	2	f	0	\N	\N
44	74	13	1	3356	\N	3356	\N	\N	1	1	2	f	\N	\N	\N
45	60	13	1	3356	\N	3356	\N	\N	0	1	2	f	\N	\N	\N
46	26	14	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
47	61	15	2	9348	\N	9348	\N	\N	1	1	2	f	0	\N	\N
48	55	16	2	3357	\N	3357	\N	\N	1	1	2	f	0	\N	\N
49	60	16	1	3357	\N	3357	\N	\N	1	1	2	f	\N	\N	\N
50	79	17	2	41679	\N	41679	\N	\N	1	1	2	f	0	\N	\N
51	10	17	1	41679	\N	41679	\N	\N	1	1	2	f	\N	\N	\N
52	29	18	2	93787	\N	93787	\N	\N	1	1	2	f	0	\N	\N
53	68	18	2	9423	\N	9423	\N	\N	2	1	2	f	0	\N	\N
54	41	18	1	102795	\N	102795	\N	\N	1	1	2	f	\N	\N	\N
55	9	18	1	297	\N	297	\N	\N	2	1	2	f	\N	\N	\N
56	79	19	2	94775	\N	94775	\N	\N	1	1	2	f	0	\N	\N
57	71	19	1	94753	\N	94753	\N	\N	1	1	2	f	\N	\N	\N
58	40	20	2	646	\N	0	\N	\N	1	1	2	f	646	\N	\N
59	79	21	2	94676	\N	94676	\N	\N	1	1	2	f	0	\N	\N
60	40	21	2	4200	\N	4200	\N	\N	2	1	2	f	0	\N	\N
61	42	21	1	98876	\N	98876	\N	\N	1	1	2	f	\N	\N	\N
62	44	22	2	496211	\N	496211	\N	\N	1	1	2	f	0	\N	\N
63	54	22	1	496211	\N	496211	\N	\N	1	1	2	f	\N	\N	\N
64	79	23	2	5339	\N	0	\N	\N	1	1	2	f	5339	\N	\N
65	41	24	2	299	\N	0	\N	\N	1	1	2	f	299	\N	\N
66	77	25	2	233	\N	0	\N	\N	1	1	2	f	233	\N	\N
67	79	26	2	94432	\N	94432	\N	\N	1	1	2	f	0	\N	\N
68	10	26	1	94430	\N	94430	\N	\N	1	1	2	f	\N	\N	\N
69	41	27	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
70	77	28	2	233	\N	0	\N	\N	1	1	2	f	233	\N	\N
71	26	29	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
72	40	30	2	27	\N	0	\N	\N	1	1	2	f	27	\N	\N
73	46	31	2	9	\N	2	\N	\N	1	1	2	f	7	\N	\N
74	58	31	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
75	39	31	2	2	\N	1	\N	\N	3	1	2	f	1	\N	\N
76	49	31	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
77	6	31	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
78	14	31	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
79	79	32	2	94515	\N	0	\N	\N	1	1	2	f	94515	\N	\N
80	69	33	2	166214	\N	166214	\N	\N	1	1	2	f	0	\N	\N
81	44	33	1	166214	\N	166214	\N	\N	1	1	2	f	\N	\N	\N
82	36	34	2	89	\N	0	\N	\N	1	1	2	f	89	\N	\N
83	84	34	2	77	\N	0	\N	\N	2	1	2	f	77	\N	\N
84	41	35	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
85	79	36	2	13547	\N	0	\N	\N	1	1	2	f	13547	\N	\N
86	40	37	2	3673	\N	0	\N	\N	1	1	2	f	3673	\N	\N
87	79	38	2	45510	\N	0	\N	\N	1	1	2	f	45510	\N	\N
88	40	39	2	191	\N	0	\N	\N	1	1	2	f	191	\N	\N
89	58	40	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
90	14	40	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
91	49	40	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
92	6	40	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
93	87	41	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
94	58	41	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
95	49	41	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
96	6	41	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
97	84	42	2	78	\N	0	\N	\N	1	1	2	f	78	\N	\N
98	40	43	2	5436	\N	0	\N	\N	1	1	2	f	5436	\N	\N
99	44	44	2	180969	\N	0	\N	\N	1	1	2	f	180969	\N	\N
100	41	44	2	2906	\N	0	\N	\N	2	1	2	f	2906	\N	\N
101	9	44	2	20	\N	0	\N	\N	3	1	2	f	20	\N	\N
102	79	45	2	10300	\N	0	\N	\N	1	1	2	f	10300	\N	\N
103	52	46	2	243760	\N	0	\N	\N	1	1	2	f	243760	\N	\N
104	78	47	2	10983	\N	0	\N	\N	1	1	2	f	10983	\N	\N
105	48	48	2	13489	\N	13489	\N	\N	1	1	2	f	0	\N	\N
106	16	48	2	3247	\N	3247	\N	\N	2	1	2	f	0	\N	\N
107	7	48	2	632	\N	632	\N	\N	3	1	2	f	0	\N	\N
108	41	48	1	17028	\N	17028	\N	\N	1	1	2	f	\N	\N	\N
109	9	48	1	261	\N	261	\N	\N	2	1	2	f	\N	\N	\N
110	61	49	2	9348	\N	9348	\N	\N	1	1	2	f	0	\N	\N
111	50	50	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
112	58	50	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
113	46	50	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
114	39	50	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
115	49	50	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
116	6	50	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
117	14	50	1	14	\N	14	\N	\N	1	1	2	f	\N	\N	\N
118	58	51	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
119	49	51	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
120	6	51	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
121	88	52	2	650	\N	650	\N	\N	1	1	2	f	0	\N	\N
122	60	52	2	650	\N	650	\N	\N	0	1	2	f	0	\N	\N
123	65	52	2	566	\N	566	\N	\N	0	1	2	f	0	\N	\N
124	31	52	2	45	\N	45	\N	\N	0	1	2	f	0	\N	\N
125	19	52	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
126	70	52	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
127	56	52	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
128	40	53	2	1519	\N	0	\N	\N	1	1	2	f	1519	\N	\N
129	79	54	2	94677	\N	94677	\N	\N	1	1	2	f	0	\N	\N
130	32	54	1	94677	\N	94677	\N	\N	1	1	2	f	\N	\N	\N
131	58	55	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
132	49	55	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
133	6	55	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
134	8	55	1	14	\N	14	\N	\N	1	1	2	f	\N	\N	\N
135	79	56	2	3720	\N	0	\N	\N	1	1	2	f	3720	\N	\N
136	39	57	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
137	55	58	2	74	\N	74	\N	\N	1	1	2	f	0	\N	\N
138	41	58	1	59	\N	59	\N	\N	1	1	2	f	\N	\N	\N
139	40	59	2	866	\N	0	\N	\N	1	1	2	f	866	\N	\N
140	35	60	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
141	34	60	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
142	35	60	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
143	77	61	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
144	43	62	2	17	\N	17	\N	\N	1	1	2	f	0	\N	\N
145	76	62	2	15	\N	15	\N	\N	2	1	2	f	0	\N	\N
146	80	62	2	6	\N	6	\N	\N	3	1	2	f	0	\N	\N
147	18	62	2	3	\N	3	\N	\N	4	1	2	f	0	\N	\N
148	82	62	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
149	43	62	1	19	\N	19	\N	\N	1	1	2	f	\N	\N	\N
150	76	62	1	11	\N	11	\N	\N	2	1	2	f	\N	\N	\N
151	80	62	1	5	\N	5	\N	\N	3	1	2	f	\N	\N	\N
152	18	62	1	3	\N	3	\N	\N	4	1	2	f	\N	\N	\N
153	82	62	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
154	61	63	2	1098	\N	1098	\N	\N	1	1	2	f	0	\N	\N
155	41	63	2	182	\N	182	\N	\N	2	1	2	f	0	\N	\N
156	9	63	2	67	\N	67	\N	\N	3	1	2	f	0	\N	\N
157	15	63	2	35	\N	35	\N	\N	4	1	2	f	0	\N	\N
158	41	63	1	194	\N	194	\N	\N	1	1	2	f	\N	\N	\N
159	61	63	1	158	\N	158	\N	\N	2	1	2	f	\N	\N	\N
160	9	63	1	70	\N	70	\N	\N	3	1	2	f	\N	\N	\N
161	60	64	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
162	60	64	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
163	40	65	2	4059	\N	0	\N	\N	1	1	2	f	4059	\N	\N
164	55	66	2	3357	\N	0	\N	\N	1	1	2	f	3357	\N	\N
165	79	67	2	94676	\N	94676	\N	\N	1	1	2	f	0	\N	\N
166	24	67	1	94676	\N	94676	\N	\N	1	1	2	f	\N	\N	\N
167	61	68	2	90502	\N	90502	\N	\N	1	1	2	f	0	\N	\N
168	79	68	2	86137	\N	86137	\N	\N	2	1	2	f	0	\N	\N
169	40	68	2	5457	\N	5457	\N	\N	3	1	2	f	0	\N	\N
170	88	68	1	182096	\N	182096	\N	\N	1	1	2	f	\N	\N	\N
171	60	68	1	182096	\N	182096	\N	\N	0	1	2	f	\N	\N	\N
172	65	68	1	177664	\N	177664	\N	\N	0	1	2	f	\N	\N	\N
173	70	68	1	1961	\N	1961	\N	\N	0	1	2	f	\N	\N	\N
174	56	68	1	1446	\N	1446	\N	\N	0	1	2	f	\N	\N	\N
175	19	68	1	789	\N	789	\N	\N	0	1	2	f	\N	\N	\N
176	31	68	1	250	\N	250	\N	\N	0	1	2	f	\N	\N	\N
177	40	69	2	502	\N	0	\N	\N	1	1	2	f	502	\N	\N
178	60	70	1	28	\N	28	\N	\N	1	1	2	f	\N	\N	\N
179	79	71	2	93557	\N	93557	\N	\N	1	1	2	f	0	\N	\N
180	15	71	1	93557	\N	93557	\N	\N	1	1	2	f	\N	\N	\N
181	40	72	2	603	\N	0	\N	\N	1	1	2	f	603	\N	\N
182	44	73	2	163783	\N	0	\N	\N	1	1	2	f	163783	\N	\N
183	82	74	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
184	28	74	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
185	80	74	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
186	41	75	2	77	\N	77	\N	\N	1	1	2	f	0	\N	\N
187	9	75	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
188	41	75	1	70	\N	70	\N	\N	1	1	2	f	\N	\N	\N
189	41	76	2	299	\N	0	\N	\N	1	1	2	f	299	\N	\N
190	9	76	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
191	40	77	2	5707	\N	0	\N	\N	1	1	2	f	5707	\N	\N
192	89	78	2	105653	\N	105653	\N	\N	1	1	2	f	0	\N	\N
193	69	78	2	26414	\N	26414	\N	\N	2	1	2	f	0	\N	\N
194	4	78	2	14361	\N	14361	\N	\N	3	1	2	f	0	\N	\N
195	45	78	2	6086	\N	6086	\N	\N	4	1	2	f	0	\N	\N
196	11	78	2	5292	\N	5292	\N	\N	5	1	2	f	0	\N	\N
197	73	78	2	4202	\N	4202	\N	\N	6	1	2	f	0	\N	\N
198	16	78	2	3250	\N	3250	\N	\N	7	1	2	f	0	\N	\N
199	77	78	2	1980	\N	1980	\N	\N	8	1	2	f	0	\N	\N
200	57	78	2	421	\N	421	\N	\N	9	1	2	f	0	\N	\N
201	21	78	2	191	\N	191	\N	\N	10	1	2	f	0	\N	\N
202	20	78	2	126	\N	126	\N	\N	11	1	2	f	0	\N	\N
203	7	78	2	71	\N	71	\N	\N	12	1	2	f	0	\N	\N
204	22	78	2	29	\N	29	\N	\N	13	1	2	f	0	\N	\N
205	62	78	2	11	\N	11	\N	\N	14	1	2	f	0	\N	\N
206	48	78	2	4	\N	4	\N	\N	15	1	2	f	0	\N	\N
207	61	78	1	147298	\N	147298	\N	\N	1	1	2	f	\N	\N	\N
208	41	78	1	14131	\N	14131	\N	\N	2	1	2	f	\N	\N	\N
209	9	78	1	52	\N	52	\N	\N	3	1	2	f	\N	\N	\N
210	28	79	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
211	79	80	2	4117	\N	4117	\N	\N	1	1	2	f	0	\N	\N
212	10	80	1	4117	\N	4117	\N	\N	1	1	2	f	\N	\N	\N
213	41	81	2	46	\N	0	\N	\N	1	1	2	f	46	\N	\N
214	9	81	2	44	\N	0	\N	\N	2	1	2	f	44	\N	\N
215	80	81	2	18	\N	0	\N	\N	3	1	2	f	18	\N	\N
216	43	81	2	3	\N	0	\N	\N	4	1	2	f	3	\N	\N
217	28	81	2	3	\N	0	\N	\N	5	1	2	f	3	\N	\N
218	60	81	2	2	\N	0	\N	\N	6	1	2	f	2	\N	\N
219	37	81	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
220	82	81	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
221	79	82	2	81661	\N	81661	\N	\N	1	1	2	f	0	\N	\N
222	10	82	1	81661	\N	81661	\N	\N	1	1	2	f	\N	\N	\N
223	50	83	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
224	46	83	2	14	\N	0	\N	\N	2	1	2	f	14	\N	\N
225	26	83	2	6	\N	0	\N	\N	3	1	2	f	6	\N	\N
226	58	83	2	2	\N	0	\N	\N	4	1	2	f	2	\N	\N
227	39	83	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
228	49	83	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
229	6	83	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
230	79	84	2	7673	\N	7673	\N	\N	1	1	2	f	0	\N	\N
231	10	84	1	7673	\N	7673	\N	\N	1	1	2	f	\N	\N	\N
232	63	85	2	302	\N	0	\N	\N	1	1	2	f	302	\N	\N
233	50	86	2	15	\N	15	\N	\N	1	1	2	f	0	\N	\N
234	35	86	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
235	66	86	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
236	20	86	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
237	17	86	1	1	\N	1	\N	\N	4	1	2	f	\N	\N	\N
238	15	86	1	1	\N	1	\N	\N	5	1	2	f	\N	\N	\N
239	47	86	1	1	\N	1	\N	\N	6	1	2	f	\N	\N	\N
240	63	86	1	1	\N	1	\N	\N	7	1	2	f	\N	\N	\N
241	33	86	1	1	\N	1	\N	\N	8	1	2	f	\N	\N	\N
242	55	86	1	1	\N	1	\N	\N	9	1	2	f	\N	\N	\N
243	41	86	1	1	\N	1	\N	\N	10	1	2	f	\N	\N	\N
244	30	86	1	1	\N	1	\N	\N	11	1	2	f	\N	\N	\N
245	79	86	1	1	\N	1	\N	\N	12	1	2	f	\N	\N	\N
246	61	86	1	1	\N	1	\N	\N	13	1	2	f	\N	\N	\N
247	44	86	1	1	\N	1	\N	\N	14	1	2	f	\N	\N	\N
248	52	86	1	1	\N	1	\N	\N	15	1	2	f	\N	\N	\N
249	60	87	2	2880	\N	2880	\N	\N	1	1	2	f	0	\N	\N
250	88	87	2	2146	\N	2146	\N	\N	0	1	2	f	0	\N	\N
251	65	87	2	1985	\N	1985	\N	\N	0	1	2	f	0	\N	\N
252	70	87	2	63	\N	63	\N	\N	0	1	2	f	0	\N	\N
253	31	87	2	62	\N	62	\N	\N	0	1	2	f	0	\N	\N
254	19	87	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
255	74	87	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
256	56	87	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
257	12	87	1	181	\N	181	\N	\N	1	1	2	f	\N	\N	\N
258	25	87	1	115	\N	115	\N	\N	2	1	2	f	\N	\N	\N
259	47	87	1	90	\N	90	\N	\N	3	1	2	f	\N	\N	\N
260	67	87	1	64	\N	64	\N	\N	4	1	2	f	\N	\N	\N
261	66	87	1	25	\N	25	\N	\N	5	1	2	f	\N	\N	\N
262	61	87	1	8	\N	8	\N	\N	6	1	2	f	\N	\N	\N
263	64	87	1	1	\N	1	\N	\N	7	1	2	f	\N	\N	\N
264	13	88	2	16845	\N	59	\N	\N	1	1	2	f	16786	\N	\N
265	24	88	1	55	\N	55	\N	\N	1	1	2	f	\N	\N	\N
266	78	88	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
267	40	89	2	2060	\N	0	\N	\N	1	1	2	f	2060	\N	\N
268	79	90	2	88176	\N	88176	\N	\N	1	1	2	f	0	\N	\N
269	10	90	1	88176	\N	88176	\N	\N	1	1	2	f	\N	\N	\N
270	54	91	2	992422	\N	0	\N	\N	1	1	2	f	992422	\N	\N
271	52	91	2	241481	\N	0	\N	\N	2	1	2	f	241481	\N	\N
272	89	91	2	202074	\N	0	\N	\N	3	1	2	f	202074	\N	\N
273	83	91	2	200414	\N	0	\N	\N	4	1	2	f	200414	\N	\N
274	22	91	2	199328	\N	0	\N	\N	5	1	2	f	199328	\N	\N
275	29	91	2	180543	\N	0	\N	\N	6	1	2	f	180543	\N	\N
276	44	91	2	158608	\N	0	\N	\N	7	1	2	f	158608	\N	\N
277	69	91	2	109251	\N	0	\N	\N	8	1	2	f	109251	\N	\N
278	61	91	2	102622	\N	0	\N	\N	9	1	2	f	102622	\N	\N
279	79	91	2	94677	\N	0	\N	\N	10	1	2	f	94677	\N	\N
280	4	91	2	28533	\N	0	\N	\N	11	1	2	f	28533	\N	\N
281	30	91	2	26388	\N	0	\N	\N	12	1	2	f	26388	\N	\N
282	78	91	2	21966	\N	0	\N	\N	13	1	2	f	21966	\N	\N
283	41	91	2	15713	\N	0	\N	\N	14	1	2	f	15713	\N	\N
284	64	91	2	14363	\N	0	\N	\N	15	1	2	f	14363	\N	\N
285	48	91	2	13550	\N	0	\N	\N	16	1	2	f	13550	\N	\N
286	67	91	2	10869	\N	0	\N	\N	17	1	2	f	10869	\N	\N
287	11	91	2	10522	\N	0	\N	\N	18	1	2	f	10522	\N	\N
288	73	91	2	8404	\N	0	\N	\N	19	1	2	f	8404	\N	\N
289	60	91	2	8311	\N	0	\N	\N	20	1	2	f	8311	\N	\N
290	5	91	2	7701	\N	0	\N	\N	21	1	2	f	7701	\N	\N
291	68	91	2	6370	\N	0	\N	\N	22	1	2	f	6370	\N	\N
292	45	91	2	6086	\N	0	\N	\N	23	1	2	f	6086	\N	\N
293	12	91	2	5554	\N	0	\N	\N	24	1	2	f	5554	\N	\N
294	40	91	2	4199	\N	0	\N	\N	25	1	2	f	4199	\N	\N
295	16	91	2	3268	\N	0	\N	\N	26	1	2	f	3268	\N	\N
296	33	91	2	2571	\N	0	\N	\N	27	1	2	f	2571	\N	\N
297	90	91	2	2314	\N	0	\N	\N	28	1	2	f	2314	\N	\N
298	25	91	2	1551	\N	0	\N	\N	29	1	2	f	1551	\N	\N
299	77	91	2	1235	\N	0	\N	\N	30	1	2	f	1235	\N	\N
300	7	91	2	684	\N	0	\N	\N	31	1	2	f	684	\N	\N
301	63	91	2	672	\N	0	\N	\N	32	1	2	f	672	\N	\N
302	10	91	2	667	\N	0	\N	\N	33	1	2	f	667	\N	\N
303	47	91	2	627	\N	0	\N	\N	34	1	2	f	627	\N	\N
304	57	91	2	597	\N	0	\N	\N	35	1	2	f	597	\N	\N
305	75	91	2	340	\N	0	\N	\N	36	1	2	f	340	\N	\N
306	15	91	2	304	\N	0	\N	\N	37	1	2	f	304	\N	\N
307	21	91	2	287	\N	0	\N	\N	38	1	2	f	287	\N	\N
308	9	91	2	203	\N	0	\N	\N	39	1	2	f	203	\N	\N
309	17	91	2	200	\N	0	\N	\N	40	1	2	f	200	\N	\N
310	86	91	2	182	\N	0	\N	\N	41	1	2	f	182	\N	\N
311	76	91	2	175	\N	0	\N	\N	42	1	2	f	175	\N	\N
312	20	91	2	171	\N	0	\N	\N	43	1	2	f	171	\N	\N
313	28	91	2	168	\N	0	\N	\N	44	1	2	f	168	\N	\N
314	36	91	2	120	\N	0	\N	\N	45	1	2	f	120	\N	\N
315	43	91	2	116	\N	0	\N	\N	46	1	2	f	116	\N	\N
316	84	91	2	85	\N	0	\N	\N	47	1	2	f	85	\N	\N
317	62	91	2	80	\N	0	\N	\N	48	1	2	f	80	\N	\N
318	66	91	2	50	\N	0	\N	\N	49	1	2	f	50	\N	\N
319	81	91	2	29	\N	0	\N	\N	50	1	2	f	29	\N	\N
320	2	91	2	27	\N	0	\N	\N	51	1	2	f	27	\N	\N
321	42	91	2	22	\N	0	\N	\N	52	1	2	f	22	\N	\N
322	72	91	2	22	\N	0	\N	\N	53	1	2	f	22	\N	\N
323	71	91	2	20	\N	0	\N	\N	54	1	2	f	20	\N	\N
324	32	91	2	14	\N	0	\N	\N	55	1	2	f	14	\N	\N
325	18	91	2	14	\N	0	\N	\N	56	1	2	f	14	\N	\N
326	85	91	2	11	\N	0	\N	\N	57	1	2	f	11	\N	\N
327	24	91	2	10	\N	0	\N	\N	58	1	2	f	10	\N	\N
328	35	91	2	8	\N	0	\N	\N	59	1	2	f	8	\N	\N
329	23	91	2	6	\N	0	\N	\N	60	1	2	f	6	\N	\N
330	53	91	2	6	\N	0	\N	\N	61	1	2	f	6	\N	\N
331	14	91	2	4	\N	0	\N	\N	62	1	2	f	4	\N	\N
332	38	91	2	3	\N	0	\N	\N	63	1	2	f	3	\N	\N
333	27	91	2	3	\N	0	\N	\N	64	1	2	f	3	\N	\N
334	26	91	2	3	\N	0	\N	\N	65	1	2	f	3	\N	\N
335	34	91	2	2	\N	0	\N	\N	66	1	2	f	2	\N	\N
336	39	91	2	2	\N	0	\N	\N	67	1	2	f	2	\N	\N
337	59	91	2	2	\N	0	\N	\N	68	1	2	f	2	\N	\N
338	51	91	2	1	\N	0	\N	\N	69	1	2	f	1	\N	\N
339	88	91	2	3385	\N	0	\N	\N	0	1	2	f	3385	\N	\N
340	65	91	2	3110	\N	0	\N	\N	0	1	2	f	3110	\N	\N
341	74	91	2	1586	\N	0	\N	\N	0	1	2	f	1586	\N	\N
342	37	91	2	152	\N	0	\N	\N	0	1	2	f	152	\N	\N
343	31	91	2	96	\N	0	\N	\N	0	1	2	f	96	\N	\N
344	70	91	2	95	\N	0	\N	\N	0	1	2	f	95	\N	\N
345	19	91	2	60	\N	0	\N	\N	0	1	2	f	60	\N	\N
346	56	91	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
347	29	92	2	849	\N	0	\N	\N	1	1	2	f	849	\N	\N
348	55	93	2	3357	\N	0	\N	\N	1	1	2	f	3357	\N	\N
349	40	94	2	78	\N	0	\N	\N	1	1	2	f	78	\N	\N
350	40	95	2	4373	\N	0	\N	\N	1	1	2	f	4373	\N	\N
351	40	96	2	10983	\N	10983	\N	\N	1	1	2	f	0	\N	\N
352	78	96	1	10983	\N	10983	\N	\N	1	1	2	f	\N	\N	\N
353	44	97	2	163783	\N	0	\N	\N	1	1	2	f	163783	\N	\N
354	41	98	2	11239	\N	0	\N	\N	1	1	2	f	11239	\N	\N
355	9	98	2	233	\N	0	\N	\N	2	1	2	f	233	\N	\N
356	64	99	2	14363	\N	0	\N	\N	1	1	2	f	14363	\N	\N
357	67	99	2	10869	\N	0	\N	\N	2	1	2	f	10869	\N	\N
358	12	99	2	5554	\N	0	\N	\N	3	1	2	f	5554	\N	\N
359	25	99	2	1551	\N	0	\N	\N	4	1	2	f	1551	\N	\N
360	63	99	2	614	\N	0	\N	\N	5	1	2	f	614	\N	\N
361	47	99	2	492	\N	0	\N	\N	6	1	2	f	492	\N	\N
362	36	99	2	88	\N	0	\N	\N	7	1	2	f	88	\N	\N
363	84	99	2	77	\N	0	\N	\N	8	1	2	f	77	\N	\N
364	66	99	2	50	\N	0	\N	\N	9	1	2	f	50	\N	\N
365	81	99	2	29	\N	0	\N	\N	10	1	2	f	29	\N	\N
366	48	100	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
367	33	100	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
368	82	101	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
369	28	101	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
370	80	101	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
371	58	102	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
372	49	102	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
373	6	102	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
374	79	103	2	86098	\N	0	\N	\N	1	1	2	f	86098	\N	\N
375	55	104	2	1193	\N	1193	\N	\N	1	1	2	f	0	\N	\N
376	79	105	2	93557	\N	0	\N	\N	1	1	2	f	93557	\N	\N
377	44	106	2	22393	\N	0	\N	\N	1	1	2	f	22393	\N	\N
378	61	106	2	312	\N	0	\N	\N	2	1	2	f	312	\N	\N
379	41	106	2	208	\N	0	\N	\N	3	1	2	f	208	\N	\N
380	67	106	2	2	\N	0	\N	\N	4	1	2	f	2	\N	\N
381	5	106	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
382	68	106	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
383	48	106	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
384	55	107	2	3963	\N	3963	\N	\N	1	1	2	f	0	\N	\N
385	61	107	1	3957	\N	3957	\N	\N	1	1	2	f	\N	\N	\N
386	40	108	2	1622	\N	0	\N	\N	1	1	2	f	1622	\N	\N
387	77	109	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
388	61	110	2	279	\N	279	\N	\N	1	1	2	f	0	\N	\N
389	40	110	2	265	\N	265	\N	\N	2	1	2	f	0	\N	\N
390	2	110	1	548	\N	548	\N	\N	1	1	2	f	\N	\N	\N
391	40	111	2	730	\N	0	\N	\N	1	1	2	f	730	\N	\N
392	88	112	2	2453	\N	2453	\N	\N	1	1	2	f	0	\N	\N
393	60	112	2	2453	\N	2453	\N	\N	0	1	2	f	0	\N	\N
394	65	112	2	2264	\N	2264	\N	\N	0	1	2	f	0	\N	\N
395	31	112	2	68	\N	68	\N	\N	0	1	2	f	0	\N	\N
396	70	112	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
397	19	112	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
398	56	112	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
399	60	112	1	2453	\N	2453	\N	\N	1	1	2	f	\N	\N	\N
400	78	113	2	10983	\N	0	\N	\N	1	1	2	f	10983	\N	\N
401	54	114	2	496211	\N	496211	\N	\N	1	1	2	f	0	\N	\N
402	23	114	1	496211	\N	496211	\N	\N	1	1	2	f	\N	\N	\N
403	15	115	2	42	\N	42	\N	\N	1	1	2	f	0	\N	\N
404	15	115	1	42	\N	42	\N	\N	1	1	2	f	\N	\N	\N
405	61	116	2	98873	\N	98873	\N	\N	1	1	2	f	0	\N	\N
406	79	116	1	94671	\N	94671	\N	\N	1	1	2	f	\N	\N	\N
407	40	116	1	4202	\N	4202	\N	\N	2	1	2	f	\N	\N	\N
408	83	117	2	99830	\N	99830	\N	\N	1	1	2	f	0	\N	\N
409	61	117	1	99610	\N	99610	\N	\N	1	1	2	f	\N	\N	\N
410	87	118	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
411	41	119	2	4312	\N	4312	\N	\N	1	1	2	f	0	\N	\N
412	9	119	2	210	\N	210	\N	\N	2	1	2	f	0	\N	\N
413	40	120	2	687	\N	0	\N	\N	1	1	2	f	687	\N	\N
414	40	121	2	3915	\N	3915	\N	\N	1	1	2	f	0	\N	\N
415	47	121	1	3915	\N	3915	\N	\N	1	1	2	f	\N	\N	\N
416	14	122	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
417	21	123	2	246	\N	246	\N	\N	1	1	2	f	0	\N	\N
418	57	123	2	157	\N	157	\N	\N	2	1	2	f	0	\N	\N
419	20	123	2	91	\N	91	\N	\N	3	1	2	f	0	\N	\N
420	62	123	2	90	\N	90	\N	\N	4	1	2	f	0	\N	\N
421	40	124	2	6594	\N	0	\N	\N	1	1	2	f	6594	\N	\N
422	40	125	2	1982	\N	1982	\N	\N	1	1	2	f	0	\N	\N
423	61	125	2	1982	\N	1982	\N	\N	2	1	2	f	0	\N	\N
424	75	125	1	3964	\N	3964	\N	\N	1	1	2	f	\N	\N	\N
425	40	126	2	776	\N	0	\N	\N	1	1	2	f	776	\N	\N
426	60	127	2	1168	\N	0	\N	\N	1	1	2	f	1168	\N	\N
427	79	128	2	92633	\N	92633	\N	\N	1	1	2	f	0	\N	\N
428	10	128	1	92633	\N	92633	\N	\N	1	1	2	f	\N	\N	\N
429	58	129	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
430	49	129	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
431	6	129	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
432	87	129	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
433	40	130	2	3403	\N	0	\N	\N	1	1	2	f	3403	\N	\N
434	1	131	2	625	\N	625	\N	\N	1	1	2	f	0	\N	\N
435	38	131	1	625	\N	625	\N	\N	1	1	2	f	\N	\N	\N
436	79	132	2	11834	\N	0	\N	\N	1	1	2	f	11834	\N	\N
437	26	133	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
438	87	134	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
439	55	135	2	1489	\N	0	\N	\N	1	1	2	f	1489	\N	\N
440	15	135	2	25	\N	0	\N	\N	2	1	2	f	25	\N	\N
441	80	135	2	13	\N	0	\N	\N	3	1	2	f	13	\N	\N
442	37	135	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
443	82	135	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
444	65	136	2	32	\N	32	\N	\N	1	1	2	f	0	\N	\N
445	60	136	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
446	88	136	2	32	\N	32	\N	\N	0	1	2	f	0	\N	\N
447	15	137	2	106	\N	106	\N	\N	1	1	2	f	0	\N	\N
448	15	137	1	106	\N	106	\N	\N	1	1	2	f	\N	\N	\N
449	14	138	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
450	61	139	2	855	\N	0	\N	\N	1	1	2	f	855	\N	\N
451	26	140	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
452	45	141	2	6086	\N	6086	\N	\N	1	1	2	f	0	\N	\N
453	17	141	1	6086	\N	6086	\N	\N	1	1	2	f	\N	\N	\N
454	43	142	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
455	55	143	2	3854	\N	3854	\N	\N	1	1	2	f	0	\N	\N
456	60	143	1	3854	\N	3854	\N	\N	1	1	2	f	\N	\N	\N
457	26	144	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
458	76	145	2	58	\N	58	\N	\N	1	1	2	f	0	\N	\N
459	43	145	2	51	\N	51	\N	\N	2	1	2	f	0	\N	\N
460	80	145	2	8	\N	8	\N	\N	3	1	2	f	0	\N	\N
461	28	145	1	101	\N	101	\N	\N	1	1	2	f	\N	\N	\N
462	37	145	1	105	\N	105	\N	\N	0	1	2	f	\N	\N	\N
463	61	146	2	94460	\N	0	\N	\N	1	1	2	f	94460	\N	\N
464	79	147	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
465	63	147	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
466	36	148	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
467	84	148	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
468	63	149	2	238	\N	0	\N	\N	1	1	2	f	238	\N	\N
469	77	150	2	231	\N	0	\N	\N	1	1	2	f	231	\N	\N
470	40	151	2	3082	\N	3082	\N	\N	1	1	2	f	0	\N	\N
471	47	151	1	3082	\N	3082	\N	\N	1	1	2	f	\N	\N	\N
472	77	152	2	723	\N	0	\N	\N	1	1	2	f	723	\N	\N
473	79	153	2	89733	\N	0	\N	\N	1	1	2	f	89733	\N	\N
474	61	154	2	656	\N	0	\N	\N	1	1	2	f	656	\N	\N
475	50	155	2	86	\N	86	\N	\N	1	1	2	f	0	\N	\N
476	48	156	2	868	\N	0	\N	\N	1	1	2	f	868	\N	\N
477	7	156	2	601	\N	0	\N	\N	2	1	2	f	601	\N	\N
478	16	156	2	16	\N	0	\N	\N	3	1	2	f	16	\N	\N
479	5	156	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
480	63	157	2	513	\N	0	\N	\N	1	1	2	f	513	\N	\N
481	40	158	2	3643	\N	3643	\N	\N	1	1	2	f	0	\N	\N
482	24	158	1	3643	\N	3643	\N	\N	1	1	2	f	\N	\N	\N
483	88	159	2	2448	\N	2448	\N	\N	1	1	2	f	0	\N	\N
484	60	159	2	2448	\N	2448	\N	\N	0	1	2	f	0	\N	\N
485	65	159	2	2259	\N	2259	\N	\N	0	1	2	f	0	\N	\N
486	31	159	2	68	\N	68	\N	\N	0	1	2	f	0	\N	\N
487	70	159	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
488	19	159	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
489	56	159	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
490	60	159	1	452	\N	452	\N	\N	1	1	2	f	\N	\N	\N
491	40	160	2	3996	\N	0	\N	\N	1	1	2	f	3996	\N	\N
492	77	161	2	233	\N	0	\N	\N	1	1	2	f	233	\N	\N
493	41	162	2	14244	\N	0	\N	\N	1	1	2	f	14244	\N	\N
494	48	162	2	11529	\N	0	\N	\N	2	1	2	f	11529	\N	\N
495	16	162	2	3161	\N	0	\N	\N	3	1	2	f	3161	\N	\N
496	60	162	2	1270	\N	0	\N	\N	4	1	2	f	1270	\N	\N
497	63	162	2	502	\N	0	\N	\N	5	1	2	f	502	\N	\N
498	9	162	2	158	\N	0	\N	\N	6	1	2	f	158	\N	\N
499	15	162	2	132	\N	0	\N	\N	7	1	2	f	132	\N	\N
500	17	162	2	89	\N	0	\N	\N	8	1	2	f	89	\N	\N
501	61	162	2	29	\N	0	\N	\N	9	1	2	f	29	\N	\N
502	25	162	2	2	\N	0	\N	\N	10	1	2	f	2	\N	\N
503	67	162	2	2	\N	0	\N	\N	11	1	2	f	2	\N	\N
504	88	162	2	790	\N	0	\N	\N	0	1	2	f	790	\N	\N
505	65	162	2	754	\N	0	\N	\N	0	1	2	f	754	\N	\N
506	19	162	2	19	\N	0	\N	\N	0	1	2	f	19	\N	\N
507	70	162	2	13	\N	0	\N	\N	0	1	2	f	13	\N	\N
508	31	162	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
509	56	162	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
510	50	163	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
511	77	164	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
512	77	165	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
513	77	166	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
514	80	167	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
515	43	167	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
516	63	168	2	615	\N	0	\N	\N	1	1	2	f	615	\N	\N
517	15	169	2	171	\N	171	\N	\N	1	1	2	f	0	\N	\N
518	15	169	1	171	\N	171	\N	\N	1	1	2	f	\N	\N	\N
519	60	170	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
520	60	170	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
521	55	171	2	593	\N	593	\N	\N	1	1	2	f	0	\N	\N
522	47	171	1	580	\N	580	\N	\N	1	1	2	f	\N	\N	\N
523	66	171	1	13	\N	13	\N	\N	2	1	2	f	\N	\N	\N
524	77	173	2	61	\N	0	\N	\N	1	1	2	f	61	\N	\N
525	41	173	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
526	29	174	2	557	\N	0	\N	\N	1	1	2	f	557	\N	\N
527	61	174	2	17	\N	0	\N	\N	2	1	2	f	17	\N	\N
528	80	175	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
529	38	175	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
530	28	175	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
531	82	175	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
532	43	175	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
533	88	176	2	2310	\N	2310	\N	\N	1	1	2	f	0	\N	\N
534	60	176	2	2310	\N	2310	\N	\N	0	1	2	f	0	\N	\N
535	65	176	2	2153	\N	2153	\N	\N	0	1	2	f	0	\N	\N
536	31	176	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
537	70	176	2	62	\N	62	\N	\N	0	1	2	f	0	\N	\N
538	56	176	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
539	19	176	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
540	60	176	1	2307	\N	2307	\N	\N	1	1	2	f	\N	\N	\N
541	40	177	2	197	\N	0	\N	\N	1	1	2	f	197	\N	\N
542	79	178	2	6016	\N	0	\N	\N	1	1	2	f	6016	\N	\N
543	40	179	2	3861	\N	3861	\N	\N	1	1	2	f	0	\N	\N
544	41	179	1	3855	\N	3855	\N	\N	1	1	2	f	\N	\N	\N
545	60	180	2	419	\N	419	\N	\N	1	1	2	f	0	\N	\N
546	60	180	1	419	\N	419	\N	\N	1	1	2	f	\N	\N	\N
547	61	181	2	102155	\N	0	\N	\N	1	1	2	f	102155	\N	\N
548	60	182	2	361	\N	0	\N	\N	1	1	2	f	361	\N	\N
549	50	183	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
550	58	183	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
551	49	183	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
552	6	183	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
553	78	184	2	5926	\N	0	\N	\N	1	1	2	f	5926	\N	\N
554	80	185	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
555	28	185	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
556	37	185	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
557	82	185	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
558	43	185	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
559	63	186	2	531	\N	0	\N	\N	1	1	2	f	531	\N	\N
560	22	187	2	99294	\N	99294	\N	\N	1	1	2	f	0	\N	\N
561	57	187	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
562	61	187	1	99075	\N	99075	\N	\N	1	1	2	f	\N	\N	\N
563	63	188	2	614	\N	0	\N	\N	1	1	2	f	614	\N	\N
564	79	189	2	94676	\N	94676	\N	\N	1	1	2	f	0	\N	\N
565	53	189	1	94676	\N	94676	\N	\N	1	1	2	f	\N	\N	\N
566	69	190	2	89129	\N	87296	\N	\N	1	1	2	f	1833	\N	\N
567	77	190	2	234	\N	234	\N	\N	2	1	2	f	0	\N	\N
568	61	190	1	87296	\N	87296	\N	\N	1	1	2	f	\N	\N	\N
569	41	190	1	234	\N	234	\N	\N	2	1	2	f	\N	\N	\N
570	29	191	2	163	\N	0	\N	\N	1	1	2	f	163	\N	\N
571	61	192	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
572	3	192	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
573	40	193	2	2145	\N	0	\N	\N	1	1	2	f	2145	\N	\N
574	40	194	2	4109	\N	0	\N	\N	1	1	2	f	4109	\N	\N
575	79	195	2	88189	\N	88189	\N	\N	1	1	2	f	0	\N	\N
576	41	195	1	87886	\N	87886	\N	\N	1	1	2	f	\N	\N	\N
577	9	195	1	194	\N	194	\N	\N	2	1	2	f	\N	\N	\N
578	63	196	2	581	\N	0	\N	\N	1	1	2	f	581	\N	\N
579	28	197	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
580	28	197	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
581	87	198	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
582	46	199	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
583	79	200	2	84310	\N	84310	\N	\N	1	1	2	f	0	\N	\N
584	63	200	1	84310	\N	84310	\N	\N	1	1	2	f	\N	\N	\N
585	40	201	2	2306	\N	2306	\N	\N	1	1	2	f	0	\N	\N
586	61	201	2	2306	\N	2306	\N	\N	2	1	2	f	0	\N	\N
587	90	201	1	4620	\N	4620	\N	\N	1	1	2	f	\N	\N	\N
588	54	202	2	496211	\N	491349	\N	\N	1	1	2	f	4862	\N	\N
589	90	202	2	2328	\N	2328	\N	\N	2	1	2	f	0	\N	\N
590	75	202	2	340	\N	340	\N	\N	3	1	2	f	0	\N	\N
591	2	202	2	27	\N	27	\N	\N	4	1	2	f	0	\N	\N
592	44	203	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
593	40	204	2	211	\N	0	\N	\N	1	1	2	f	211	\N	\N
594	60	205	2	1783	\N	1783	\N	\N	1	1	2	f	0	\N	\N
595	60	205	1	1783	\N	1783	\N	\N	1	1	2	f	\N	\N	\N
596	46	206	2	3221	\N	3221	\N	\N	1	1	2	f	0	\N	\N
597	60	206	1	2542	\N	2542	\N	\N	1	1	2	f	\N	\N	\N
598	10	206	1	632	\N	632	\N	\N	2	1	2	f	\N	\N	\N
599	42	206	1	11	\N	11	\N	\N	3	1	2	f	\N	\N	\N
600	72	206	1	11	\N	11	\N	\N	4	1	2	f	\N	\N	\N
601	71	206	1	10	\N	10	\N	\N	5	1	2	f	\N	\N	\N
602	24	206	1	5	\N	5	\N	\N	6	1	2	f	\N	\N	\N
603	53	206	1	3	\N	3	\N	\N	7	1	2	f	\N	\N	\N
604	74	206	1	1586	\N	1586	\N	\N	0	1	2	f	\N	\N	\N
605	44	207	2	132845	\N	0	\N	\N	1	1	2	f	132845	\N	\N
606	61	208	2	102563	\N	0	\N	\N	1	1	2	f	102563	\N	\N
607	77	209	2	233	\N	0	\N	\N	1	1	2	f	233	\N	\N
608	60	210	2	441	\N	441	\N	\N	1	1	2	f	0	\N	\N
609	60	210	1	441	\N	441	\N	\N	1	1	2	f	\N	\N	\N
610	40	211	2	263	\N	0	\N	\N	1	1	2	f	263	\N	\N
611	61	212	2	27	\N	0	\N	\N	1	1	2	f	27	\N	\N
612	60	213	2	41	\N	41	\N	\N	1	1	2	f	0	\N	\N
613	46	213	1	41	\N	41	\N	\N	1	1	2	f	\N	\N	\N
614	26	214	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
615	79	215	2	76694	\N	0	\N	\N	1	1	2	f	76694	\N	\N
616	40	216	2	4166	\N	0	\N	\N	1	1	2	f	4166	\N	\N
617	46	217	2	451	\N	451	\N	\N	1	1	2	f	0	\N	\N
618	59	217	2	156	\N	156	\N	\N	2	1	2	f	0	\N	\N
619	60	217	1	607	\N	607	\N	\N	1	1	2	f	\N	\N	\N
620	30	218	2	26371	\N	0	\N	\N	1	1	2	f	26371	\N	\N
621	55	218	2	3357	\N	3357	\N	\N	2	1	2	f	0	\N	\N
622	87	219	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
623	63	220	2	615	\N	0	\N	\N	1	1	2	f	615	\N	\N
624	60	221	2	377	\N	0	\N	\N	1	1	2	f	377	\N	\N
625	47	222	2	625	\N	625	\N	\N	1	1	2	f	0	\N	\N
626	1	222	1	625	\N	625	\N	\N	1	1	2	f	\N	\N	\N
627	77	223	2	769	\N	0	\N	\N	1	1	2	f	769	\N	\N
628	40	224	2	4006	\N	4006	\N	\N	1	1	2	f	0	\N	\N
629	47	224	1	4006	\N	4006	\N	\N	1	1	2	f	\N	\N	\N
630	55	225	2	3357	\N	3357	\N	\N	1	1	2	f	0	\N	\N
631	60	225	1	3357	\N	3357	\N	\N	1	1	2	f	\N	\N	\N
632	63	226	2	615	\N	0	\N	\N	1	1	2	f	615	\N	\N
633	8	227	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
634	50	227	1	13	\N	13	\N	\N	1	1	2	f	\N	\N	\N
635	26	228	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
636	22	229	2	604	\N	604	\N	\N	1	1	2	f	0	\N	\N
637	40	230	2	222	\N	0	\N	\N	1	1	2	f	222	\N	\N
638	40	231	2	1806	\N	0	\N	\N	1	1	2	f	1806	\N	\N
639	60	232	2	33	\N	33	\N	\N	1	1	2	f	0	\N	\N
640	44	233	2	166214	\N	166214	\N	\N	1	1	2	f	0	\N	\N
641	69	233	2	116857	\N	116857	\N	\N	2	1	2	f	0	\N	\N
642	61	233	2	105681	\N	105681	\N	\N	3	1	2	f	0	\N	\N
643	89	233	2	102619	\N	102619	\N	\N	4	1	2	f	0	\N	\N
644	83	233	2	99127	\N	99127	\N	\N	5	1	2	f	0	\N	\N
645	22	233	2	98910	\N	98910	\N	\N	6	1	2	f	0	\N	\N
646	29	233	2	92833	\N	92833	\N	\N	7	1	2	f	0	\N	\N
647	41	233	2	21986	\N	21986	\N	\N	8	1	2	f	0	\N	\N
648	13	233	2	16845	\N	16845	\N	\N	9	1	2	f	0	\N	\N
649	64	233	2	14363	\N	14363	\N	\N	10	1	2	f	0	\N	\N
650	67	233	2	10867	\N	10867	\N	\N	11	1	2	f	0	\N	\N
651	48	233	2	8611	\N	8611	\N	\N	12	1	2	f	0	\N	\N
652	4	233	2	7842	\N	7842	\N	\N	13	1	2	f	0	\N	\N
653	5	233	2	7701	\N	7701	\N	\N	14	1	2	f	0	\N	\N
654	68	233	2	6610	\N	6610	\N	\N	15	1	2	f	0	\N	\N
655	45	233	2	5892	\N	5892	\N	\N	16	1	2	f	0	\N	\N
656	12	233	2	5553	\N	5553	\N	\N	17	1	2	f	0	\N	\N
657	11	233	2	5292	\N	5292	\N	\N	18	1	2	f	0	\N	\N
658	73	233	2	4202	\N	4202	\N	\N	19	1	2	f	0	\N	\N
659	16	233	2	3325	\N	3325	\N	\N	20	1	2	f	0	\N	\N
660	25	233	2	1550	\N	1550	\N	\N	21	1	2	f	0	\N	\N
661	63	233	2	1230	\N	1230	\N	\N	22	1	2	f	0	\N	\N
662	77	233	2	937	\N	937	\N	\N	23	1	2	f	0	\N	\N
663	7	233	2	684	\N	684	\N	\N	24	1	2	f	0	\N	\N
664	60	233	2	674	\N	674	\N	\N	25	1	2	f	0	\N	\N
665	47	233	2	627	\N	627	\N	\N	26	1	2	f	0	\N	\N
666	57	233	2	569	\N	569	\N	\N	27	1	2	f	0	\N	\N
667	9	233	2	266	\N	266	\N	\N	28	1	2	f	0	\N	\N
668	21	233	2	234	\N	234	\N	\N	29	1	2	f	0	\N	\N
669	86	233	2	182	\N	182	\N	\N	30	1	2	f	0	\N	\N
670	20	233	2	156	\N	156	\N	\N	31	1	2	f	0	\N	\N
671	62	233	2	80	\N	80	\N	\N	32	1	2	f	0	\N	\N
672	66	233	2	50	\N	50	\N	\N	33	1	2	f	0	\N	\N
673	81	233	2	29	\N	29	\N	\N	34	1	2	f	0	\N	\N
674	27	233	2	3	\N	3	\N	\N	35	1	2	f	0	\N	\N
675	59	233	2	2	\N	2	\N	\N	36	1	2	f	0	\N	\N
676	46	233	2	2	\N	2	\N	\N	37	1	2	f	0	\N	\N
677	50	233	2	1	\N	1	\N	\N	38	1	2	f	0	\N	\N
678	33	233	1	898723	\N	898723	\N	\N	1	1	2	f	\N	\N	\N
679	26	233	1	681	\N	681	\N	\N	2	1	2	f	\N	\N	\N
680	84	234	2	85	\N	0	\N	\N	1	1	2	f	85	\N	\N
681	36	234	2	65	\N	0	\N	\N	2	1	2	f	65	\N	\N
682	36	235	2	73	\N	0	\N	\N	1	1	2	f	73	\N	\N
683	84	235	2	52	\N	0	\N	\N	2	1	2	f	52	\N	\N
684	44	236	2	163470	\N	0	\N	\N	1	1	2	f	163470	\N	\N
685	69	236	2	109251	\N	0	\N	\N	2	1	2	f	109251	\N	\N
686	61	236	2	2985	\N	0	\N	\N	3	1	2	f	2985	\N	\N
687	77	236	2	1174	\N	0	\N	\N	4	1	2	f	1174	\N	\N
688	57	236	2	597	\N	0	\N	\N	5	1	2	f	597	\N	\N
689	29	236	2	394	\N	0	\N	\N	6	1	2	f	394	\N	\N
690	41	236	2	302	\N	0	\N	\N	7	1	2	f	302	\N	\N
691	21	236	2	287	\N	0	\N	\N	8	1	2	f	287	\N	\N
692	15	236	2	244	\N	0	\N	\N	9	1	2	f	244	\N	\N
693	20	236	2	171	\N	0	\N	\N	10	1	2	f	171	\N	\N
694	62	236	2	80	\N	0	\N	\N	11	1	2	f	80	\N	\N
695	76	236	2	37	\N	0	\N	\N	12	1	2	f	37	\N	\N
696	68	236	2	21	\N	0	\N	\N	13	1	2	f	21	\N	\N
697	22	236	2	18	\N	0	\N	\N	14	1	2	f	18	\N	\N
698	50	236	2	15	\N	0	\N	\N	15	1	2	f	15	\N	\N
699	43	236	2	11	\N	0	\N	\N	16	1	2	f	11	\N	\N
700	46	236	2	7	\N	0	\N	\N	17	1	2	f	7	\N	\N
701	17	236	2	4	\N	0	\N	\N	18	1	2	f	4	\N	\N
702	48	236	2	4	\N	0	\N	\N	19	1	2	f	4	\N	\N
703	4	236	2	2	\N	0	\N	\N	20	1	2	f	2	\N	\N
704	58	236	2	1	\N	0	\N	\N	21	1	2	f	1	\N	\N
705	39	236	2	1	\N	0	\N	\N	22	1	2	f	1	\N	\N
706	26	236	2	1	\N	0	\N	\N	23	1	2	f	1	\N	\N
707	9	236	2	1	\N	0	\N	\N	24	1	2	f	1	\N	\N
708	89	236	2	1	\N	0	\N	\N	25	1	2	f	1	\N	\N
709	49	236	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
710	6	236	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
711	3	237	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
712	61	237	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
713	79	238	2	94677	\N	0	\N	\N	1	1	2	f	94677	\N	\N
714	40	238	2	4200	\N	0	\N	\N	2	1	2	f	4200	\N	\N
715	60	239	2	4055	\N	4055	\N	\N	1	1	2	f	0	\N	\N
716	74	239	2	1586	\N	1586	\N	\N	0	1	2	f	0	\N	\N
717	46	239	1	4055	\N	4055	\N	\N	1	1	2	f	\N	\N	\N
718	79	240	2	94495	\N	0	\N	\N	1	1	2	f	94495	\N	\N
719	40	240	2	4011	\N	0	\N	\N	2	1	2	f	4011	\N	\N
720	55	241	2	3357	\N	3357	\N	\N	1	1	2	f	0	\N	\N
721	60	241	1	3357	\N	3357	\N	\N	1	1	2	f	\N	\N	\N
722	27	242	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
723	28	243	2	85	\N	85	\N	\N	1	1	2	f	0	\N	\N
724	37	243	2	88	\N	88	\N	\N	0	1	2	f	0	\N	\N
725	28	243	1	81	\N	81	\N	\N	1	1	2	f	\N	\N	\N
726	37	243	1	81	\N	81	\N	\N	0	1	2	f	\N	\N	\N
727	55	244	2	46	\N	46	\N	\N	1	1	2	f	0	\N	\N
728	58	244	2	5	\N	5	\N	\N	2	1	2	f	0	\N	\N
729	39	244	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
730	49	244	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
731	6	244	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
732	61	244	1	33	\N	33	\N	\N	1	1	2	f	\N	\N	\N
733	58	245	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
734	49	245	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
735	6	245	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
736	40	246	2	4118	\N	0	\N	\N	1	1	2	f	4118	\N	\N
737	40	247	2	2930	\N	0	\N	\N	1	1	2	f	2930	\N	\N
738	55	248	2	2828	\N	2826	\N	\N	1	1	2	f	2	\N	\N
739	60	248	1	2826	\N	2826	\N	\N	1	1	2	f	\N	\N	\N
740	52	249	2	243760	\N	0	\N	\N	1	1	2	f	243760	\N	\N
741	40	250	2	2748	\N	0	\N	\N	1	1	2	f	2748	\N	\N
742	43	251	2	50	\N	50	\N	\N	1	1	2	f	0	\N	\N
743	76	251	2	47	\N	47	\N	\N	2	1	2	f	0	\N	\N
744	80	251	2	8	\N	8	\N	\N	3	1	2	f	0	\N	\N
745	28	251	1	53	\N	53	\N	\N	1	1	2	f	\N	\N	\N
746	37	251	1	77	\N	77	\N	\N	0	1	2	f	\N	\N	\N
747	63	252	2	612	\N	0	\N	\N	1	1	2	f	612	\N	\N
748	63	253	2	246	\N	0	\N	\N	1	1	2	f	246	\N	\N
749	41	254	2	329	\N	0	\N	\N	1	1	2	f	329	\N	\N
750	7	254	2	52	\N	0	\N	\N	2	1	2	f	52	\N	\N
751	5	254	2	35	\N	0	\N	\N	3	1	2	f	35	\N	\N
752	40	255	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
753	13	256	2	16845	\N	16845	\N	\N	1	1	2	f	0	\N	\N
754	40	256	1	16845	\N	16845	\N	\N	1	1	2	f	\N	\N	\N
755	40	257	2	188	\N	188	\N	\N	1	1	2	f	0	\N	\N
756	63	258	2	191	\N	0	\N	\N	1	1	2	f	191	\N	\N
757	41	259	2	895	\N	0	\N	\N	1	1	2	f	895	\N	\N
758	79	260	2	94676	\N	94676	\N	\N	1	1	2	f	0	\N	\N
759	72	260	1	94676	\N	94676	\N	\N	1	1	2	f	\N	\N	\N
760	58	261	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
761	39	261	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
762	49	261	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
763	6	261	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
764	14	261	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
765	50	262	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
766	58	262	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
767	49	262	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
768	6	262	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
769	44	263	2	102704	\N	0	\N	\N	1	1	2	f	102704	\N	\N
770	40	264	2	4138	\N	4138	\N	\N	1	1	2	f	0	\N	\N
771	15	264	1	4138	\N	4138	\N	\N	1	1	2	f	\N	\N	\N
772	55	265	2	3357	\N	3357	\N	\N	1	1	2	f	0	\N	\N
773	60	265	1	3357	\N	3357	\N	\N	1	1	2	f	\N	\N	\N
774	79	266	2	93379	\N	0	\N	\N	1	1	2	f	93379	\N	\N
775	61	267	2	191	\N	0	\N	\N	1	1	2	f	191	\N	\N
776	17	268	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
777	17	268	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
778	54	269	2	496211	\N	496211	\N	\N	1	1	2	f	0	\N	\N
779	52	269	2	243760	\N	243760	\N	\N	2	1	2	f	0	\N	\N
780	44	269	2	166214	\N	166214	\N	\N	3	1	2	f	0	\N	\N
781	69	269	2	116857	\N	116857	\N	\N	4	1	2	f	0	\N	\N
782	89	269	2	105652	\N	105652	\N	\N	5	1	2	f	0	\N	\N
783	61	269	2	102613	\N	102613	\N	\N	6	1	2	f	0	\N	\N
784	83	269	2	99801	\N	99801	\N	\N	7	1	2	f	0	\N	\N
785	22	269	2	99264	\N	99264	\N	\N	8	1	2	f	0	\N	\N
786	79	269	2	94677	\N	94677	\N	\N	9	1	2	f	0	\N	\N
787	29	269	2	93216	\N	93216	\N	\N	10	1	2	f	0	\N	\N
788	30	269	2	26387	\N	26387	\N	\N	11	1	2	f	0	\N	\N
789	13	269	2	16845	\N	16845	\N	\N	12	1	2	f	0	\N	\N
790	41	269	2	15714	\N	15714	\N	\N	13	1	2	f	0	\N	\N
791	64	269	2	14363	\N	14363	\N	\N	14	1	2	f	0	\N	\N
792	4	269	2	14361	\N	14361	\N	\N	15	1	2	f	0	\N	\N
793	60	269	2	13572	\N	13572	\N	\N	16	1	2	f	0	\N	\N
794	48	269	2	13492	\N	13492	\N	\N	17	1	2	f	0	\N	\N
795	78	269	2	10983	\N	10983	\N	\N	18	1	2	f	0	\N	\N
796	67	269	2	10869	\N	10869	\N	\N	19	1	2	f	0	\N	\N
797	68	269	2	9422	\N	9422	\N	\N	20	1	2	f	0	\N	\N
798	5	269	2	7701	\N	7701	\N	\N	21	1	2	f	0	\N	\N
799	45	269	2	6086	\N	6086	\N	\N	22	1	2	f	0	\N	\N
800	12	269	2	5554	\N	5554	\N	\N	23	1	2	f	0	\N	\N
801	11	269	2	5292	\N	5292	\N	\N	24	1	2	f	0	\N	\N
802	73	269	2	4202	\N	4202	\N	\N	25	1	2	f	0	\N	\N
803	40	269	2	4200	\N	4200	\N	\N	26	1	2	f	0	\N	\N
804	55	269	2	3357	\N	3357	\N	\N	27	1	2	f	0	\N	\N
805	16	269	2	3253	\N	3253	\N	\N	28	1	2	f	0	\N	\N
806	33	269	2	2546	\N	2546	\N	\N	29	1	2	f	0	\N	\N
807	90	269	2	2314	\N	2314	\N	\N	30	1	2	f	0	\N	\N
808	25	269	2	1551	\N	1551	\N	\N	31	1	2	f	0	\N	\N
809	77	269	2	938	\N	938	\N	\N	32	1	2	f	0	\N	\N
810	7	269	2	684	\N	684	\N	\N	33	1	2	f	0	\N	\N
811	63	269	2	672	\N	672	\N	\N	34	1	2	f	0	\N	\N
812	10	269	2	632	\N	632	\N	\N	35	1	2	f	0	\N	\N
813	47	269	2	627	\N	627	\N	\N	36	1	2	f	0	\N	\N
814	1	269	2	625	\N	625	\N	\N	37	1	2	f	0	\N	\N
815	57	269	2	568	\N	568	\N	\N	38	1	2	f	0	\N	\N
816	75	269	2	340	\N	340	\N	\N	39	1	2	f	0	\N	\N
817	21	269	2	231	\N	231	\N	\N	40	1	2	f	0	\N	\N
818	15	269	2	206	\N	206	\N	\N	41	1	2	f	0	\N	\N
819	9	269	2	205	\N	205	\N	\N	42	1	2	f	0	\N	\N
820	17	269	2	200	\N	200	\N	\N	43	1	2	f	0	\N	\N
821	86	269	2	182	\N	182	\N	\N	44	1	2	f	0	\N	\N
822	28	269	2	162	\N	162	\N	\N	45	1	2	f	0	\N	\N
823	20	269	2	154	\N	154	\N	\N	46	1	2	f	0	\N	\N
824	36	269	2	120	\N	120	\N	\N	47	1	2	f	0	\N	\N
825	76	269	2	88	\N	88	\N	\N	48	1	2	f	0	\N	\N
826	84	269	2	85	\N	85	\N	\N	49	1	2	f	0	\N	\N
827	62	269	2	78	\N	78	\N	\N	50	1	2	f	0	\N	\N
828	43	269	2	63	\N	63	\N	\N	51	1	2	f	0	\N	\N
829	66	269	2	50	\N	50	\N	\N	52	1	2	f	0	\N	\N
830	81	269	2	29	\N	29	\N	\N	53	1	2	f	0	\N	\N
831	2	269	2	27	\N	27	\N	\N	54	1	2	f	0	\N	\N
832	80	269	2	21	\N	21	\N	\N	55	1	2	f	0	\N	\N
833	46	269	2	17	\N	17	\N	\N	56	1	2	f	0	\N	\N
834	50	269	2	15	\N	15	\N	\N	57	1	2	f	0	\N	\N
835	8	269	2	14	\N	14	\N	\N	58	1	2	f	0	\N	\N
836	85	269	2	11	\N	11	\N	\N	59	1	2	f	0	\N	\N
837	42	269	2	11	\N	11	\N	\N	60	1	2	f	0	\N	\N
838	72	269	2	11	\N	11	\N	\N	61	1	2	f	0	\N	\N
839	71	269	2	10	\N	10	\N	\N	62	1	2	f	0	\N	\N
840	32	269	2	7	\N	7	\N	\N	63	1	2	f	0	\N	\N
841	18	269	2	7	\N	7	\N	\N	64	1	2	f	0	\N	\N
842	24	269	2	5	\N	5	\N	\N	65	1	2	f	0	\N	\N
843	26	269	2	5	\N	5	\N	\N	66	1	2	f	0	\N	\N
844	35	269	2	4	\N	4	\N	\N	67	1	2	f	0	\N	\N
845	58	269	2	3	\N	3	\N	\N	68	1	2	f	0	\N	\N
846	23	269	2	3	\N	3	\N	\N	69	1	2	f	0	\N	\N
847	38	269	2	3	\N	3	\N	\N	70	1	2	f	0	\N	\N
848	53	269	2	3	\N	3	\N	\N	71	1	2	f	0	\N	\N
849	27	269	2	3	\N	3	\N	\N	72	1	2	f	0	\N	\N
850	39	269	2	2	\N	2	\N	\N	73	1	2	f	0	\N	\N
851	14	269	2	2	\N	2	\N	\N	74	1	2	f	0	\N	\N
852	59	269	2	2	\N	2	\N	\N	75	1	2	f	0	\N	\N
853	3	269	2	2	\N	2	\N	\N	76	1	2	f	0	\N	\N
854	34	269	2	1	\N	1	\N	\N	77	1	2	f	0	\N	\N
855	51	269	2	1	\N	1	\N	\N	78	1	2	f	0	\N	\N
856	87	269	2	1	\N	1	\N	\N	79	1	2	f	0	\N	\N
857	88	269	2	7343	\N	7343	\N	\N	0	1	2	f	0	\N	\N
858	65	269	2	6776	\N	6776	\N	\N	0	1	2	f	0	\N	\N
859	74	269	2	3172	\N	3172	\N	\N	0	1	2	f	0	\N	\N
860	31	269	2	205	\N	205	\N	\N	0	1	2	f	0	\N	\N
861	70	269	2	198	\N	198	\N	\N	0	1	2	f	0	\N	\N
862	37	269	2	160	\N	160	\N	\N	0	1	2	f	0	\N	\N
863	19	269	2	121	\N	121	\N	\N	0	1	2	f	0	\N	\N
864	56	269	2	51	\N	51	\N	\N	0	1	2	f	0	\N	\N
865	82	269	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
866	49	269	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
867	6	269	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
868	28	269	1	1042342	\N	1042342	\N	\N	1	1	2	f	\N	\N	\N
869	37	269	1	1032703	\N	1032703	\N	\N	0	1	2	f	\N	\N	\N
870	79	270	2	94677	\N	0	\N	\N	1	1	2	f	94677	\N	\N
871	40	270	2	4004	\N	0	\N	\N	2	1	2	f	4004	\N	\N
872	7	271	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
873	5	271	2	35	\N	0	\N	\N	2	1	2	f	35	\N	\N
874	77	272	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
875	40	273	2	2192	\N	2192	\N	\N	1	1	2	f	0	\N	\N
876	79	274	2	94677	\N	94677	\N	\N	1	1	2	f	0	\N	\N
877	30	274	2	26409	\N	26409	\N	\N	2	1	2	f	0	\N	\N
878	40	274	2	4202	\N	4202	\N	\N	3	1	2	f	0	\N	\N
879	61	274	1	99058	\N	99058	\N	\N	1	1	2	f	\N	\N	\N
880	41	274	1	26074	\N	26074	\N	\N	2	1	2	f	\N	\N	\N
881	9	274	1	202	\N	202	\N	\N	3	1	2	f	\N	\N	\N
882	39	275	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
883	36	276	2	120	\N	0	\N	\N	1	1	2	f	120	\N	\N
884	47	277	2	625	\N	0	\N	\N	1	1	2	f	625	\N	\N
885	55	278	2	3381	\N	3381	\N	\N	1	1	2	f	0	\N	\N
886	89	279	2	105652	\N	105652	\N	\N	1	1	2	f	0	\N	\N
887	61	279	2	218	\N	0	\N	\N	2	1	2	f	218	\N	\N
888	15	279	1	105646	\N	105646	\N	\N	1	1	2	f	\N	\N	\N
889	29	280	2	93226	\N	93226	\N	\N	1	1	2	f	0	\N	\N
890	68	280	2	9455	\N	9455	\N	\N	2	1	2	f	0	\N	\N
891	61	280	1	93226	\N	93226	\N	\N	1	1	2	f	\N	\N	\N
892	41	280	1	9420	\N	9420	\N	\N	2	1	2	f	\N	\N	\N
893	9	280	1	31	\N	31	\N	\N	3	1	2	f	\N	\N	\N
894	10	281	2	558	\N	558	\N	\N	1	1	2	f	0	\N	\N
895	83	282	2	100058	\N	100058	\N	\N	1	1	2	f	0	\N	\N
896	22	282	2	99555	\N	99555	\N	\N	2	1	2	f	0	\N	\N
897	69	282	2	71609	\N	71609	\N	\N	3	1	2	f	0	\N	\N
898	30	282	2	26091	\N	26091	\N	\N	4	1	2	f	0	\N	\N
899	4	282	2	13723	\N	13723	\N	\N	5	1	2	f	0	\N	\N
900	48	282	2	8567	\N	8567	\N	\N	6	1	2	f	0	\N	\N
901	5	282	2	7702	\N	7702	\N	\N	7	1	2	f	0	\N	\N
902	89	282	2	6151	\N	6151	\N	\N	8	1	2	f	0	\N	\N
903	11	282	2	5333	\N	5333	\N	\N	9	1	2	f	0	\N	\N
904	73	282	2	4438	\N	4438	\N	\N	10	1	2	f	0	\N	\N
905	77	282	2	937	\N	937	\N	\N	11	1	2	f	0	\N	\N
906	29	282	2	717	\N	717	\N	\N	12	1	2	f	0	\N	\N
907	7	282	2	670	\N	670	\N	\N	13	1	2	f	0	\N	\N
908	57	282	2	567	\N	567	\N	\N	14	1	2	f	0	\N	\N
909	45	282	2	532	\N	532	\N	\N	15	1	2	f	0	\N	\N
910	21	282	2	231	\N	231	\N	\N	16	1	2	f	0	\N	\N
911	16	282	2	212	\N	212	\N	\N	17	1	2	f	0	\N	\N
912	20	282	2	154	\N	154	\N	\N	18	1	2	f	0	\N	\N
913	62	282	2	78	\N	78	\N	\N	19	1	2	f	0	\N	\N
914	68	282	2	21	\N	21	\N	\N	20	1	2	f	0	\N	\N
915	35	282	2	4	\N	4	\N	\N	21	1	2	f	0	\N	\N
916	34	282	2	1	\N	1	\N	\N	22	1	2	f	0	\N	\N
917	52	282	1	347343	\N	347343	\N	\N	1	1	2	f	\N	\N	\N
918	83	283	2	85753	\N	85753	\N	\N	1	1	2	f	0	\N	\N
919	69	283	2	75161	\N	75161	\N	\N	2	1	2	f	0	\N	\N
920	22	283	2	44608	\N	44608	\N	\N	3	1	2	f	0	\N	\N
921	4	283	2	7711	\N	7711	\N	\N	4	1	2	f	0	\N	\N
922	11	283	2	4170	\N	4170	\N	\N	5	1	2	f	0	\N	\N
923	73	283	2	3083	\N	3083	\N	\N	6	1	2	f	0	\N	\N
924	48	283	2	1837	\N	1837	\N	\N	7	1	2	f	0	\N	\N
925	77	283	2	927	\N	927	\N	\N	8	1	2	f	0	\N	\N
926	7	283	2	657	\N	657	\N	\N	9	1	2	f	0	\N	\N
927	57	283	2	395	\N	395	\N	\N	10	1	2	f	0	\N	\N
928	16	283	2	129	\N	129	\N	\N	11	1	2	f	0	\N	\N
929	41	283	2	129	\N	129	\N	\N	12	1	2	f	0	\N	\N
930	62	283	2	112	\N	112	\N	\N	13	1	2	f	0	\N	\N
931	20	283	2	89	\N	89	\N	\N	14	1	2	f	0	\N	\N
932	21	283	2	40	\N	40	\N	\N	15	1	2	f	0	\N	\N
933	5	283	2	26	\N	26	\N	\N	16	1	2	f	0	\N	\N
934	89	283	2	1	\N	1	\N	\N	17	1	2	f	0	\N	\N
935	47	283	1	185746	\N	185746	\N	\N	1	1	2	f	\N	\N	\N
936	25	283	1	12324	\N	12324	\N	\N	2	1	2	f	\N	\N	\N
937	67	283	1	5953	\N	5953	\N	\N	3	1	2	f	\N	\N	\N
938	12	283	1	4183	\N	4183	\N	\N	4	1	2	f	\N	\N	\N
939	66	283	1	2371	\N	2371	\N	\N	5	1	2	f	\N	\N	\N
940	10	283	1	910	\N	910	\N	\N	6	1	2	f	\N	\N	\N
941	64	283	1	20	\N	20	\N	\N	7	1	2	f	\N	\N	\N
942	85	283	1	17	\N	17	\N	\N	8	1	2	f	\N	\N	\N
943	8	284	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
944	50	284	1	13	\N	13	\N	\N	1	1	2	f	\N	\N	\N
945	47	285	2	488	\N	0	\N	\N	1	1	2	f	488	\N	\N
946	79	286	2	94606	\N	0	\N	\N	1	1	2	f	94606	\N	\N
947	40	287	2	4472	\N	0	\N	\N	1	1	2	f	4472	\N	\N
948	83	288	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
949	61	288	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
950	50	289	2	15	\N	15	\N	\N	1	1	2	f	0	\N	\N
951	58	289	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
952	39	289	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
953	26	289	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
954	49	289	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
955	6	289	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
956	88	290	2	208	\N	208	\N	\N	1	1	2	f	0	\N	\N
957	60	290	2	208	\N	208	\N	\N	0	1	2	f	0	\N	\N
958	65	290	2	168	\N	168	\N	\N	0	1	2	f	0	\N	\N
959	19	290	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
960	56	290	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
961	70	290	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
962	31	290	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
963	77	291	2	61	\N	0	\N	\N	1	1	2	f	61	\N	\N
964	64	292	2	13729	\N	13729	\N	\N	1	1	2	f	0	\N	\N
965	67	292	2	10023	\N	10023	\N	\N	2	1	2	f	0	\N	\N
966	12	292	2	5144	\N	5144	\N	\N	3	1	2	f	0	\N	\N
967	25	292	2	1300	\N	1300	\N	\N	4	1	2	f	0	\N	\N
968	47	292	2	627	\N	627	\N	\N	5	1	2	f	0	\N	\N
969	66	292	2	44	\N	44	\N	\N	6	1	2	f	0	\N	\N
970	81	292	2	28	\N	28	\N	\N	7	1	2	f	0	\N	\N
971	85	292	2	11	\N	11	\N	\N	8	1	2	f	0	\N	\N
972	47	292	1	30268	\N	30268	\N	\N	1	1	2	f	\N	\N	\N
973	85	292	1	627	\N	627	\N	\N	2	1	2	f	\N	\N	\N
974	64	293	2	14363	\N	0	\N	\N	1	1	2	f	14363	\N	\N
975	67	293	2	10869	\N	0	\N	\N	2	1	2	f	10869	\N	\N
976	12	293	2	5554	\N	0	\N	\N	3	1	2	f	5554	\N	\N
977	25	293	2	1551	\N	0	\N	\N	4	1	2	f	1551	\N	\N
978	63	293	2	614	\N	0	\N	\N	5	1	2	f	614	\N	\N
979	47	293	2	492	\N	0	\N	\N	6	1	2	f	492	\N	\N
980	36	293	2	88	\N	0	\N	\N	7	1	2	f	88	\N	\N
981	84	293	2	77	\N	0	\N	\N	8	1	2	f	77	\N	\N
982	66	293	2	50	\N	0	\N	\N	9	1	2	f	50	\N	\N
983	81	293	2	29	\N	0	\N	\N	10	1	2	f	29	\N	\N
984	10	294	2	513	\N	0	\N	\N	1	1	2	f	513	\N	\N
985	41	295	2	1018	\N	1018	\N	\N	1	1	2	f	0	\N	\N
986	9	295	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
987	61	295	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
988	41	295	1	1017	\N	1017	\N	\N	1	1	2	f	\N	\N	\N
989	61	295	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
990	78	296	2	8845	\N	8845	\N	\N	1	1	2	f	0	\N	\N
991	36	296	2	121	\N	0	\N	\N	2	1	2	f	121	\N	\N
992	84	296	2	84	\N	0	\N	\N	3	1	2	f	84	\N	\N
993	33	296	2	28	\N	0	\N	\N	4	1	2	f	28	\N	\N
994	36	296	1	7798	\N	7798	\N	\N	1	1	2	f	\N	\N	\N
995	84	296	1	1047	\N	1047	\N	\N	2	1	2	f	\N	\N	\N
996	15	297	2	130	\N	0	\N	\N	1	1	2	f	130	\N	\N
997	54	298	2	496211	\N	496211	\N	\N	1	1	2	f	0	\N	\N
998	44	298	2	25693	\N	25693	\N	\N	2	1	2	f	0	\N	\N
999	44	298	1	496211	\N	496211	\N	\N	1	1	2	f	\N	\N	\N
1000	61	298	1	23259	\N	23259	\N	\N	2	1	2	f	\N	\N	\N
1001	63	298	1	2431	\N	2431	\N	\N	3	1	2	f	\N	\N	\N
1002	5	299	2	7711	\N	7711	\N	\N	1	1	2	f	0	\N	\N
1003	41	299	1	7646	\N	7646	\N	\N	1	1	2	f	\N	\N	\N
1004	9	299	1	64	\N	64	\N	\N	2	1	2	f	\N	\N	\N
1005	78	300	2	5926	\N	0	\N	\N	1	1	2	f	5926	\N	\N
1006	10	301	2	632	\N	632	\N	\N	1	1	2	f	0	\N	\N
1007	47	301	1	577	\N	577	\N	\N	1	1	2	f	\N	\N	\N
1008	10	301	1	11	\N	11	\N	\N	2	1	2	f	\N	\N	\N
1009	69	302	2	111082	\N	111082	\N	\N	1	1	2	f	0	\N	\N
1010	77	302	2	890	\N	890	\N	\N	2	1	2	f	0	\N	\N
1011	57	302	2	569	\N	569	\N	\N	3	1	2	f	0	\N	\N
1012	21	302	2	233	\N	233	\N	\N	4	1	2	f	0	\N	\N
1013	20	302	2	154	\N	154	\N	\N	5	1	2	f	0	\N	\N
1014	62	302	2	78	\N	78	\N	\N	6	1	2	f	0	\N	\N
1015	22	302	2	16	\N	16	\N	\N	7	1	2	f	0	\N	\N
1016	4	302	2	1	\N	1	\N	\N	8	1	2	f	0	\N	\N
1017	89	302	2	1	\N	1	\N	\N	9	1	2	f	0	\N	\N
1018	35	302	1	111398	\N	111398	\N	\N	1	1	2	f	\N	\N	\N
1019	34	302	1	1625	\N	1625	\N	\N	2	1	2	f	\N	\N	\N
1020	40	303	2	716	\N	0	\N	\N	1	1	2	f	716	\N	\N
1021	40	304	2	2595	\N	0	\N	\N	1	1	2	f	2595	\N	\N
1022	44	305	2	120966	\N	0	\N	\N	1	1	2	f	120966	\N	\N
1023	36	306	2	67	\N	0	\N	\N	1	1	2	f	67	\N	\N
1024	41	307	2	15775	\N	15775	\N	\N	1	1	2	f	0	\N	\N
1025	9	307	2	184	\N	184	\N	\N	2	1	2	f	0	\N	\N
1026	16	307	2	4	\N	4	\N	\N	3	1	2	f	0	\N	\N
1027	35	307	1	15959	\N	15959	\N	\N	1	1	2	f	\N	\N	\N
1028	77	308	2	233	\N	0	\N	\N	1	1	2	f	233	\N	\N
1029	13	309	2	16845	\N	16845	\N	\N	1	1	2	f	0	\N	\N
1030	76	309	1	16786	\N	16786	\N	\N	1	1	2	f	\N	\N	\N
1031	43	309	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
1032	87	310	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1033	87	310	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
73	n_2	http://ldf.fi/schema/warsa/casualties/	0	f	0
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
69		http://ldf.fi/schema/warsa/	0	t	0
70	crm	http://www.cidoc-crm.org/cidoc-crm/	0	f	0
25	geo	http://www.w3.org/2003/01/geo/wgs84_pos#	0	f	0
71	n_1	http://ldf.fi/schema/hipla/	0	f	0
72	biocrm	http://ldf.fi/schema/bioc/	0	f	0
74	ammo	http://ldf.fi/schema/ammo/	0	f	0
75	n_3	http://ldf.fi/schema/warsa/photographs/	0	f	0
76	n_4	http://www.yso.fi/onto/suo/	0	f	0
77	n_5	http://ldf.fi/schema/warsa/prisoners/	0	f	0
78	n_6	http://ldf.fi/warsa/actors/	0	f	0
79	n_7	http://ldf.fi/schema/warsa/articles/	0	f	0
80	n_8	http://ldf.fi/schema/warsa/actors/	0	f	0
81	n_9	http://ldf.fi/schema/warsa/events/	0	f	0
82	n_10	http://prismstandard.org/namespaces/basic/3.0/	0	f	0
83	n_11	http://ldf.fi/warsa/events/	0	f	0
84	n_12	http://ldf.fi/schema/warsa/places/cemeteries/	0	f	0
85	n_13	http://ldf.fi/schema/ldf/	0	f	0
86	n_14	http://rdf.muninn-project.org/ontologies/organization#	0	f	0
87	n_15	http://ldf.fi/ammo/coo1980/	0	f	0
88	n_16	http://ldf.fi/schema/narc-menehtyneet1939-45/	0	f	0
89	n_17	http://ldf.fi/warsa/places/municipalities/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_ldf_fi_warsa_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_ldf_fi_warsa_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://ldf.fi/warsa/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://ldf.fi/warsa/sparql", "correlationId": "3641535128253500956", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:33:41.941Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://ldf.fi/schema/ammo/hisclass5	2452	\N	74	hisclass5	hisclass5	f	2452	\N	\N	f	f	88	60	\N	t	f	\N	\N	\N	t	f	f
2	http://xmlns.com/foaf/0.1/page	3429	\N	8	page	page	f	3429	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://ldf.fi/schema/warsa/prisoners/original_name	4009	\N	77	original_name	original_name	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://ldf.fi/warsa/actors/hasPlace	1953	\N	78	hasPlace	hasPlace	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://ldf.fi/schema/warsa/prisoners/additional_information	2539	\N	77	additional_information	additional_information	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://www.w3.org/2004/02/skos/core#note	260	\N	4	note	note	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
7	http://ldf.fi/schema/ammo/hisclass7	2452	\N	74	hisclass7	hisclass7	f	2452	\N	\N	f	f	88	60	\N	t	f	\N	\N	\N	t	f	f
8	http://ldf.fi/schema/warsa/casualties/wartime_municipality	577	\N	73	wartime_municipality	wartime_municipality	f	577	\N	\N	f	f	10	47	\N	t	f	\N	\N	\N	t	f	f
12	http://purl.org/dc/terms/spatial	843	\N	5	spatial	spatial	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://ldf.fi/schema/warsa/articles/author	3358	\N	79	author	author	f	3358	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://www.w3.org/2004/02/skos/core#preflabel	3	\N	4	preflabel	preflabel	f	0	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://ldf.fi/schema/warsa/actors/genicom	9355	\N	80	genicom	genicom	f	9355	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://ldf.fi/schema/warsa/articles/volume	3357	\N	79	volume	volume	f	3357	\N	\N	f	f	55	60	\N	t	f	\N	\N	\N	t	f	f
19	http://ldf.fi/schema/warsa/citizenship	94775	\N	69	citizenship	citizenship	f	94775	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://ldf.fi/schema/warsa/prisoners/flyer	646	\N	77	flyer	flyer	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://ldf.fi/schema/warsa/mother_tongue	98876	\N	69	mother_tongue	mother_tongue	f	98876	\N	\N	f	f	\N	42	\N	t	f	\N	\N	\N	t	f	f
22	http://www.cidoc-crm.org/cidoc-crm/P138i_has_representation	496211	\N	70	P138i_has_representation	P138i_has_representation	f	496211	\N	\N	f	f	44	54	\N	t	f	\N	\N	\N	t	f	f
24	http://ldf.fi/warsa/actors/hasCommander	299	\N	78	hasCommander	hasCommander	f	0	\N	\N	f	f	41	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://ldf.fi/schema/warsa/events/place_string	233	\N	81	place_string	place_string	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://ldf.fi/warsa/actors/hasUnitCategory	1	\N	78	hasUnitCategory	hasUnitCategory	f	1	\N	\N	f	f	41	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://ldf.fi/schema/warsa/events/time_start	233	\N	81	time_start	time_start	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://prismstandard.org/namespaces/basic/3.0/url	6	\N	82	url	url	f	6	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://ldf.fi/schema/warsa/prisoners/recording	27	\N	77	recording	recording	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
31	http://purl.org/dc/terms/creator	13	\N	5	creator	creator	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://www.cidoc-crm.org/cidoc-crm/P94_has_created	166214	\N	70	P94_has_created	P94_has_created	f	166214	\N	\N	f	f	69	44	\N	t	f	\N	\N	\N	t	f	f
34	http://ldf.fi/schema/warsa/prisoners/coordinates	166	\N	77	coordinates	coordinates	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://ldf.fi/warsa/actors/covernumber	2	\N	78	covernumber	covernumber	f	0	\N	\N	f	f	41	\N	\N	t	f	\N	\N	\N	t	f	f
39	http://ldf.fi/schema/warsa/prisoners/personal_information_removed	191	\N	77	personal_information_removed	personal_information_removed	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://xmlns.com/foaf/0.1/homepage	2	\N	8	homepage	homepage	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://www.w3.org/ns/sparql-service-description#defaultDataset	1	\N	27	defaultDataset	defaultDataset	f	1	\N	\N	f	f	87	58	\N	t	f	\N	\N	\N	t	f	f
42	http://ldf.fi/schema/warsa/prisoners/hospital_type	78	\N	77	hospital_type	hospital_type	f	0	\N	\N	f	f	84	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://ldf.fi/schema/warsa/prisoners/occupation_literal	5436	\N	77	occupation_literal	occupation_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://www.w3.org/2004/02/skos/core#hiddenLabel	183895	\N	4	hiddenLabel	hiddenLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://ldf.fi/schema/warsa/casualties/graveyard_number	10300	\N	73	graveyard_number	graveyard_number	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
46	http://www.cidoc-crm.org/cidoc-crm/P82a_begin_of_the_begin	243762	\N	70	P82a_begin_of_the_begin	P82a_begin_of_the_begin	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://ldf.fi/schema/warsa/prisoners/municipality_of_domicile	3908	\N	77	[Kotikunta (municipality_of_domicile)]	municipality_of_domicile	f	3908	\N	\N	f	f	40	47	\N	t	f	\N	\N	\N	t	f	f
10	http://ldf.fi/schema/warsa/photographs/place_string	136296	\N	75	[Place (place_string)]	place_string	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://www.cidoc-crm.org/cidoc-crm/P67_refers_to	1	\N	70	[refers to (P67_refers_to)]	P67_refers_to	f	1	\N	\N	f	f	44	61	\N	t	f	\N	\N	\N	t	f	f
18	http://www.cidoc-crm.org/cidoc-crm/P144_joined_with	103210	\N	70	[joined with (P144_joined_with)]	P144_joined_with	f	103210	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://ldf.fi/schema/warsa/place_of_going_mia_literal	5339	\N	69	[Katoamispaikka (place_of_going_mia_literal)]	place_of_going_mia_literal	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://ldf.fi/schema/warsa/casualties/municipality_of_burial	94432	\N	73	[Hautauskunta (municipality_of_burial)]	municipality_of_burial	f	94432	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
32	http://ldf.fi/schema/warsa/date_of_death	94515	\N	69	[Date of death (date_of_death)]	date_of_death	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://ldf.fi/schema/warsa/date_of_wounding	13547	\N	69	[Date of wounding (date_of_wounding)]	date_of_wounding	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://ldf.fi/schema/warsa/prisoners/municipality_of_capture_literal	3673	\N	77	[Municipality of capture (municipality_of_capture_literal)]	municipality_of_capture_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://ldf.fi/schema/warsa/casualties/unit_code	45510	\N	73	[Joukko-osaston peiteluku (unit_code)]	unit_code	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://ldf.fi/schema/warsa/prisoners/location_literal	10983	\N	77	location_literal	location_literal	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://ldf.fi/schema/warsa/actors/genitree	9355	\N	80	genitree	genitree	f	9355	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
50	http://purl.org/dc/terms/rightsHolder	16	\N	5	rightsHolder	rightsHolder	f	16	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://rdfs.org/ns/void#uriLookupEndPoint	1	\N	16	uriLookupEndPoint	uriLookupEndPoint	f	1	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://ldf.fi/schema/ammo/hisco_status	650	\N	74	hisco_status	hisco_status	f	650	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://ldf.fi/schema/warsa/casualties/perishing_category	94677	\N	73	perishing_category	perishing_category	f	94677	\N	\N	f	f	79	32	\N	t	f	\N	\N	\N	t	f	f
55	http://www.w3.org/ns/sparql-service-description#namedGraph	14	\N	27	namedGraph	namedGraph	f	14	\N	\N	f	f	58	8	\N	t	f	\N	\N	\N	t	f	f
56	http://ldf.fi/schema/warsa/casualties/additional_information	3720	\N	73	additional_information	additional_information	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://purl.org/dc/terms/modified	1	\N	5	modified	modified	f	0	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://ldf.fi/schema/warsa/articles/mentionsUnit	74	\N	79	mentionsUnit	mentionsUnit	f	74	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
59	http://ldf.fi/schema/warsa/prisoners/radio_report	866	\N	77	radio_report	radio_report	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
60	http://www.cidoc-crm.org/cidoc-crm/P10_falls_within	4	\N	70	P10_falls_within	P10_falls_within	f	4	\N	\N	f	f	\N	35	\N	t	f	\N	\N	\N	t	f	f
61	http://ldf.fi/warsa/events/place_string	1	\N	83	place_string	place_string	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
62	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	43	\N	2	subPropertyOf	subPropertyOf	f	43	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
63	http://www.w3.org/2002/07/owl#sameAs	1555	\N	7	sameAs	sameAs	f	1555	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
64	http://www.w3.org/2004/02/skos/core#broadMatch	3	\N	4	broadMatch	broadMatch	f	3	\N	\N	f	f	60	60	\N	t	f	\N	\N	\N	t	f	f
66	http://ldf.fi/schema/warsa/articles/page	3357	\N	79	page	page	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://ldf.fi/schema/warsa/marital_status	94676	\N	69	marital_status	marital_status	f	94676	\N	\N	f	f	79	24	\N	t	f	\N	\N	\N	t	f	f
70	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	28	\N	1	first	first	f	28	\N	\N	f	f	\N	60	\N	t	f	\N	\N	\N	t	f	f
71	http://ldf.fi/schema/warsa/casualties/rank	93557	\N	73	rank	rank	f	93557	\N	\N	f	f	79	15	\N	t	f	\N	\N	\N	t	f	f
72	http://ldf.fi/schema/warsa/prisoners/photograph	603	\N	77	photograph	photograph	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://www.cidoc-crm.org/cidoc-crm/P1_is_identified_by	163783	\N	70	P1_is_identified_by	P1_is_identified_by	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://www.w3.org/2004/02/skos/core#example	2	\N	4	example	example	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
75	http://ldf.fi/warsa/actors/hasUpperUnit	78	\N	78	hasUpperUnit	hasUpperUnit	f	78	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://ldf.fi/warsa/actors/upper	300	\N	78	upper	upper	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://ldf.fi/schema/warsa/prisoners/soviet_card_files	5707	\N	77	soviet_card_files	soviet_card_files	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://www.cidoc-crm.org/cidoc-crm/P11_had_participant	168087	\N	70	P11_had_participant	P11_had_participant	f	168087	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://www.w3.org/2000/01/rdf-schema#subClassof	2	\N	2	subClassof	subClassof	f	2	\N	\N	f	f	\N	28	\N	t	f	\N	\N	\N	t	f	f
80	http://ldf.fi/schema/warsa/casualties/municipality_of_going_mia	4117	\N	73	municipality_of_going_mia	municipality_of_going_mia	f	4117	\N	\N	f	f	79	10	\N	t	f	\N	\N	\N	t	f	f
81	http://www.w3.org/2000/01/rdf-schema#label	123	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://ldf.fi/schema/warsa/casualties/municipality_of_birth	81661	\N	73	municipality_of_birth	municipality_of_birth	f	81661	\N	\N	f	f	79	10	\N	t	f	\N	\N	\N	t	f	f
83	http://purl.org/dc/terms/title	38	\N	5	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
84	http://ldf.fi/schema/warsa/casualties/municipality_of_wounding	7673	\N	73	municipality_of_wounding	municipality_of_wounding	f	7673	\N	\N	f	f	79	10	\N	t	f	\N	\N	\N	t	f	f
85	http://ldf.fi/schema/warsa/places/cemeteries/memorial	302	\N	84	memorial	memorial	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
86	http://rdfs.org/ns/void#exampleResource	15	\N	16	exampleResource	exampleResource	f	15	\N	\N	f	f	50	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://www.w3.org/2004/02/skos/core#relatedMatch	2880	\N	4	relatedMatch	relatedMatch	f	2880	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://www.w3.org/1999/02/22-rdf-syntax-ns#object	16845	\N	1	object	object	f	59	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
89	http://ldf.fi/schema/warsa/prisoners/sotilaan_aani	2060	\N	77	sotilaan_aani	sotilaan_aani	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://ldf.fi/schema/warsa/casualties/municipality_of_residence	88176	\N	73	municipality_of_residence	municipality_of_residence	f	88176	\N	\N	f	f	79	10	\N	t	f	\N	\N	\N	t	f	f
91	http://www.w3.org/2004/02/skos/core#prefLabel	2686851	\N	4	prefLabel	prefLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
185	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	23	\N	2	isDefinedBy	isDefinedBy	f	23	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://www.cidoc-crm.org/cidoc-crm/P95_has_formed	17365	\N	70	[has formed (P95_has_formed)]	P95_has_formed	f	17365	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://ldf.fi/schema/warsa/municipality_of_birth_literal	4059	\N	69	[Municipality of birth (municipality_of_birth_literal)]	municipality_of_birth_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://ldf.fi/schema/bioc/has_occupation	182096	\N	72	[Ammatti (has_occupation)]	has_occupation	f	182096	\N	\N	f	f	\N	88	\N	t	f	\N	\N	\N	t	f	f
69	http://ldf.fi/schema/warsa/prisoners/place_of_burial_literal	502	\N	77	[Hautauspaikka (place_of_burial_literal)]	place_of_burial_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://purl.org/dc/elements/1.1/title	3357	\N	6	title	title	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
94	http://ldf.fi/schema/warsa/prisoners/winter_war_collection	78	\N	77	winter_war_collection	winter_war_collection	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://ldf.fi/schema/warsa/prisoners/captivity	10983	\N	77	captivity	captivity	f	10983	\N	\N	f	f	40	78	\N	t	f	\N	\N	\N	t	f	f
98	http://ldf.fi/schema/warsa/actors/covernumber	11470	\N	80	covernumber	covernumber	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
99	http://www.w3.org/2003/01/geo/wgs84_pos#long	33687	\N	25	long	long	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://purl.org/dc/terms/	1	\N	5			f	1	\N	\N	f	f	48	33	\N	t	f	\N	\N	\N	t	f	f
101	http://www.w3.org/2004/02/skos/core#scopeNote	2	\N	4	scopeNote	scopeNote	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
102	http://ldf.fi/schema/ldf/starRating	1	\N	85	starRating	starRating	f	0	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
103	http://ldf.fi/schema/warsa/occupation_literal	86098	\N	69	occupation_literal	occupation_literal	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
104	http://ldf.fi/schema/warsa/articles/mentionsWar	1193	\N	79	mentionsWar	mentionsWar	f	1193	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
105	http://ldf.fi/schema/warsa/casualties/rank_literal	93557	\N	73	rank_literal	rank_literal	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
107	http://ldf.fi/schema/warsa/articles/mentionsPerson	3963	\N	79	mentionsPerson	mentionsPerson	f	3963	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://ldf.fi/warsa/events/time_end	1	\N	83	time_end	time_end	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
110	http://ldf.fi/schema/warsa/documented_in_video	548	\N	69	documented_in_video	documented_in_video	f	548	\N	\N	f	f	\N	2	\N	t	f	\N	\N	\N	t	f	f
111	http://ldf.fi/schema/warsa/prisoners/finnish_return_interrogation_file	730	\N	77	finnish_return_interrogation_file	finnish_return_interrogation_file	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://ldf.fi/schema/ammo/hisclass12	2453	\N	74	hisclass12	hisclass12	f	2453	\N	\N	f	f	88	60	\N	t	f	\N	\N	\N	t	f	f
113	http://ldf.fi/schema/warsa/prisoners/order	10983	\N	77	order	order	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://ldf.fi/schema/warsa/photographs/size	496211	\N	75	size	size	f	496211	\N	\N	f	f	54	23	\N	t	f	\N	\N	\N	t	f	f
115	http://rdf.muninn-project.org/ontologies/organization#rankSeniorTo	42	\N	86	rankSeniorTo	rankSeniorTo	f	42	\N	\N	f	f	15	15	\N	t	f	\N	\N	\N	t	f	f
118	http://www.w3.org/ns/sparql-service-description#resultFormat	4	\N	27	resultFormat	resultFormat	f	4	\N	\N	f	f	87	\N	\N	t	f	\N	\N	\N	t	f	f
119	http://ldf.fi/schema/warsa/actors/hasUnitCategory	4519	\N	80	hasUnitCategory	hasUnitCategory	f	4519	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
120	http://ldf.fi/schema/warsa/prisoners/memoir	687	\N	77	memoir	memoir	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
121	http://ldf.fi/schema/warsa/municipality_of_birth	3915	\N	69	municipality_of_birth	municipality_of_birth	f	3915	\N	\N	f	f	40	47	\N	t	f	\N	\N	\N	t	f	f
122	http://xmlns.com/foaf/0.1/phone	1	\N	8	phone	phone	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
123	http://www.w3.org/2004/02/skos/core#related	584	\N	4	related	related	f	584	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
124	http://ldf.fi/schema/warsa/prisoners/description_of_capture	6594	\N	77	description_of_capture	description_of_capture	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
125	http://ldf.fi/schema/warsa/sotilaan_aani_magazine	3964	\N	69	sotilaan_aani_magazine	sotilaan_aani_magazine	f	3964	\N	\N	f	f	\N	75	\N	t	f	\N	\N	\N	t	f	f
127	http://ldf.fi/schema/warsa/articles/order	1168	\N	79	order	order	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
128	http://ldf.fi/schema/warsa/casualties/municipality_of_domicile	92633	\N	73	municipality_of_domicile	municipality_of_domicile	f	92633	\N	\N	f	f	79	10	\N	t	f	\N	\N	\N	t	f	f
129	http://rdfs.org/ns/void#sparqlEndpoint	1	\N	16	sparqlEndpoint	sparqlEndpoint	f	1	\N	\N	f	f	58	87	\N	t	f	\N	\N	\N	t	f	f
130	http://ldf.fi/schema/warsa/prisoners/number_of_children	3403	\N	77	number_of_children	number_of_children	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
131	http://ldf.fi/schema/hipla/within	625	\N	71	within	within	f	625	\N	\N	f	f	1	38	\N	t	f	\N	\N	\N	t	f	f
133	http://purl.org/dc/terms/bibliographicCitation	3	\N	5	bibliographicCitation	bibliographicCitation	f	0	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
134	http://www.w3.org/ns/sparql-service-description#defaultEntailmentRegime	1	\N	27	defaultEntailmentRegime	defaultEntailmentRegime	f	1	\N	\N	f	f	87	\N	\N	t	f	\N	\N	\N	t	f	f
135	http://www.w3.org/2000/01/rdf-schema#comment	1535	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
136	http://ldf.fi/schema/ammo/hisco_product	32	\N	74	hisco_product	hisco_product	f	32	\N	\N	f	f	65	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://www.cidoc-crm.org/cidoc-crm/P107_1_kind_of_member	849	\N	70	[kind of member (P107_1_kind_of_member)]	P107_1_kind_of_member	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
95	http://ldf.fi/schema/warsa/prisoners/rank_literal	4373	\N	77	[Sotilasarvo (rank_literal)]	rank_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://ldf.fi/schema/warsa/photographs/is_color	163783	\N	75	[Color photograph (is_color)]	is_color	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
106	http://www.cidoc-crm.org/cidoc-crm/P3_has_note	22918	\N	70	[has note (P3_has_note)]	P3_has_note	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://ldf.fi/schema/warsa/prisoners/date_of_going_mia	1622	\N	77	[Date of going missing in action (date_of_going_mia)]	date_of_going_mia	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
117	http://www.cidoc-crm.org/cidoc-crm/P98_brought_into_life	99830	\N	70	[brought into life (P98_brought_into_life)]	P98_brought_into_life	f	99830	\N	\N	f	f	83	\N	\N	t	f	\N	\N	\N	t	f	f
126	http://ldf.fi/schema/warsa/prisoners/place_of_death	776	\N	77	[Kuolinpaikka (place_of_death)]	place_of_death	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
132	http://ldf.fi/schema/warsa/place_of_wounding	11834	\N	69	[Haavoittumispaikka (place_of_wounding)]	place_of_wounding	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
137	http://rdf.muninn-project.org/ontologies/organization#equalTo	106	\N	86	equalTo	equalTo	f	106	\N	\N	f	f	15	15	\N	t	f	\N	\N	\N	t	f	f
138	http://xmlns.com/foaf/0.1/mbox	1	\N	8	mbox	mbox	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
139	http://ldf.fi/schema/warsa/actors/hasType	855	\N	80	hasType	hasType	f	0	\N	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://prismstandard.org/namespaces/basic/3.0/doi	2	\N	82	doi	doi	f	0	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
142	http://www.w3.org/2004/02/skos/core#prefLabal	2	\N	4	prefLabal	prefLabal	f	0	\N	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
143	http://ldf.fi/schema/warsa/articles/place	3854	\N	79	place	place	f	3854	\N	\N	f	f	55	60	\N	t	f	\N	\N	\N	t	f	f
144	http://purl.org/dc/terms/bibliographiccitation	2	\N	5	bibliographiccitation	bibliographiccitation	f	0	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
145	http://www.w3.org/2000/01/rdf-schema#domain	116	\N	2	domain	domain	f	116	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
146	http://xmlns.com/foaf/0.1/givenName	94460	\N	8	givenName	givenName	f	0	\N	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
147	http://ldf.fi/schema/warsa/casualties/buried_in	5	\N	73	buried_in	buried_in	f	5	\N	\N	f	f	79	63	\N	t	f	\N	\N	\N	t	f	f
148	http://ldf.fi/schema/warsa/prisoners/camp_photographs	19	\N	77	camp_photographs	camp_photographs	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
149	http://ldf.fi/schema/warsa/places/cemeteries/architect	238	\N	84	architect	architect	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
150	http://ldf.fi/schema/warsa/events/aircraft	231	\N	81	aircraft	aircraft	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
151	http://ldf.fi/schema/warsa/prisoners/municipality_of_capture	3082	\N	77	municipality_of_capture	municipality_of_capture	f	3082	\N	\N	f	f	40	47	\N	t	f	\N	\N	\N	t	f	f
152	http://ldf.fi/schema/warsa/events/hadCommander	723	\N	81	hadCommander	hadCommander	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
153	http://ldf.fi/schema/warsa/number_of_children	89733	\N	69	number_of_children	number_of_children	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
154	http://ldf.fi/schema/warsa/actors/hasTitle	656	\N	80	hasTitle	hasTitle	f	0	\N	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
155	http://rdfs.org/ns/void#vocabulary	86	\N	16	vocabulary	vocabulary	f	86	\N	\N	f	f	50	\N	\N	t	f	\N	\N	\N	t	f	f
156	http://ldf.fi/warsa/actors/placed_at	1485	\N	78	placed_at	placed_at	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
157	http://ldf.fi/schema/warsa/places/cemeteries/memorial_unveiling_date	513	\N	84	memorial_unveiling_date	memorial_unveiling_date	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://ldf.fi/schema/warsa/prisoners/marital_status	3643	\N	77	marital_status	marital_status	f	3643	\N	\N	f	f	40	24	\N	t	f	\N	\N	\N	t	f	f
159	http://ldf.fi/schema/ammo/hisco_code	2448	\N	74	hisco_code	hisco_code	f	2448	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
160	http://ldf.fi/schema/warsa/prisoners/municipality_of_domicile_literal	3996	\N	77	municipality_of_domicile_literal	municipality_of_domicile_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
161	http://ldf.fi/schema/warsa/events/time_end	233	\N	81	time_end	time_end	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
162	http://www.w3.org/2004/02/skos/core#altLabel	31111	\N	4	altLabel	altLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
163	http://ldf.fi/schema/ldf/dataDocumentation	14	\N	85	dataDocumentation	dataDocumentation	f	14	\N	\N	f	f	50	\N	\N	t	f	\N	\N	\N	t	f	f
164	http://ldf.fi/warsa/events/enemy_aircraft	1	\N	83	enemy_aircraft	enemy_aircraft	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
165	http://ldf.fi/warsa/events/pilot	1	\N	83	pilot	pilot	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
166	http://ldf.fi/warsa/events/time_start	1	\N	83	time_start	time_start	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
167	http://www.w3.org/2002/07/owl#inverseOf	1	\N	7	inverseOf	inverseOf	f	1	\N	\N	f	f	80	\N	\N	t	f	\N	\N	\N	t	f	f
168	http://ldf.fi/schema/warsa/places/cemeteries/cemetery_type	615	\N	84	cemetery_type	cemetery_type	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
169	http://purl.org/dc/terms/isPartOf	171	\N	5	isPartOf	isPartOf	f	171	\N	\N	f	f	15	15	\N	t	f	\N	\N	\N	t	f	f
170	http://www.w3.org/2004/02/skos/core#narrowMatch	3	\N	4	narrowMatch	narrowMatch	f	3	\N	\N	f	f	60	60	\N	t	f	\N	\N	\N	t	f	f
171	http://ldf.fi/schema/warsa/articles/mentionsPlace	593	\N	79	mentionsPlace	mentionsPlace	f	593	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
172	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	28	\N	1	rest	rest	f	28	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
173	http://ldf.fi/schema/warsa/actors/comment	62	\N	80	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
174	http://ldf.fi/schema/warsa/actors/hasUnit	574	\N	80	hasUnit	hasUnit	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
175	http://www.w3.org/2004/02/skos/core#definition	12	\N	4	definition	definition	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
176	http://ldf.fi/schema/ammo/coo1980_code	2310	\N	74	coo1980_code	coo1980_code	f	2310	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://ldf.fi/schema/warsa/prisoners/confiscated_possession	197	\N	77	confiscated_possession	confiscated_possession	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
179	http://ldf.fi/schema/warsa/prisoners/unit	3861	\N	77	unit	unit	f	3861	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
180	http://ldf.fi/ammo/coo1980/socioeconomic_status	419	\N	87	socioeconomic_status	socioeconomic_status	f	419	\N	\N	f	f	60	60	\N	t	f	\N	\N	\N	t	f	f
181	http://xmlns.com/foaf/0.1/firstName	102156	\N	8	firstName	firstName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
182	http://ldf.fi/schema/ammo/hiscam	361	\N	74	hiscam	hiscam	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
183	http://rdfs.org/ns/void#uriSpace	16	\N	16	uriSpace	uriSpace	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
184	http://ldf.fi/schema/warsa/prisoners/date_end	5926	\N	77	date_end	date_end	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
141	http://www.cidoc-crm.org/cidoc-crm/P141_assigned	6086	\N	70	[assigned (P141_assigned)]	P141_assigned	f	6086	\N	\N	f	f	45	17	\N	t	f	\N	\N	\N	t	f	f
186	http://ldf.fi/schema/warsa/places/cemeteries/memorial_sculptor	531	\N	84	memorial_sculptor	memorial_sculptor	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
188	http://ldf.fi/schema/warsa/places/cemeteries/address	614	\N	84	address	address	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
189	http://ldf.fi/schema/warsa/gender	94676	\N	69	gender	gender	f	94676	\N	\N	f	f	79	53	\N	t	f	\N	\N	\N	t	f	f
190	http://www.cidoc-crm.org/cidoc-crm/P14_carried_out_by	89363	\N	70	P14_carried_out_by	P14_carried_out_by	f	87530	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
191	http://ldf.fi/warsa/actors/hasTime	163	\N	78	hasTime	hasTime	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
192	http://ldf.fi/schema/bioc/has_family_relation	2	\N	72	has_family_relation	has_family_relation	f	2	\N	\N	f	f	61	3	\N	t	f	\N	\N	\N	t	f	f
195	http://ldf.fi/schema/warsa/casualties/unit	88189	\N	73	unit	unit	f	88189	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
196	http://ldf.fi/schema/warsa/places/cemeteries/number_of_graves	581	\N	84	number_of_graves	number_of_graves	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
197	http://www.w3.org/2002/07/owl#disjointWith	1	\N	7	disjointWith	disjointWith	f	1	\N	\N	f	f	28	28	\N	t	f	\N	\N	\N	t	f	f
198	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	87	\N	\N	t	f	\N	\N	\N	t	f	f
199	http://www.w3.org/2002/07/owl#versionInfo	1	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
200	http://ldf.fi/schema/warsa/buried_in	84310	\N	69	buried_in	buried_in	f	84310	\N	\N	f	f	79	63	\N	t	f	\N	\N	\N	t	f	f
201	http://ldf.fi/schema/warsa/person_document	4620	\N	69	person_document	person_document	f	4620	\N	\N	f	f	\N	90	\N	t	f	\N	\N	\N	t	f	f
202	http://schema.org/contentUrl	498906	\N	9	contentUrl	contentUrl	f	494044	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
203	http://ldf.fi/schema/warsa/photographs/place_String	1	\N	75	place_String	place_String	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
204	http://ldf.fi/schema/warsa/prisoners/propaganda_magazine	211	\N	77	propaganda_magazine	propaganda_magazine	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
205	http://www.w3.org/2004/02/skos/core#broader	1783	\N	4	broader	broader	f	1783	\N	\N	f	f	60	60	\N	t	f	\N	\N	\N	t	f	f
206	http://www.w3.org/2004/02/skos/core#hasTopConcept	3221	\N	4	hasTopConcept	hasTopConcept	f	3221	\N	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
207	http://ldf.fi/schema/warsa/photographs/photographer_string	132845	\N	75	photographer_string	photographer_string	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
208	http://xmlns.com/foaf/0.1/familyName	102564	\N	8	familyName	familyName	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
209	http://ldf.fi/schema/warsa/events/enemy_aircraft	233	\N	81	enemy_aircraft	enemy_aircraft	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
210	http://www.w3.org/2004/02/skos/core#narrower	441	\N	4	narrower	narrower	f	441	\N	\N	f	f	60	60	\N	t	f	\N	\N	\N	t	f	f
212	http://ldf.fi/schema/warsa/actors/hasEvent	27	\N	80	hasEvent	hasEvent	f	0	\N	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
213	http://www.w3.org/2004/02/skos/core#topConceptOf	41	\N	4	topConceptOf	topConceptOf	f	41	\N	\N	f	f	60	46	\N	t	f	\N	\N	\N	t	f	f
214	http://purl.org/dc/terms/identifier	1	\N	5	identifier	identifier	f	0	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
217	http://www.w3.org/2004/02/skos/core#member	607	\N	4	member	member	f	607	\N	\N	f	f	\N	60	\N	t	f	\N	\N	\N	t	f	f
218	http://purl.org/dc/terms/hasFormat	29728	\N	5	hasFormat	hasFormat	f	3357	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
219	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	87	\N	\N	t	f	\N	\N	\N	t	f	f
220	http://ldf.fi/schema/warsa/places/cemeteries/current_municipality	615	\N	84	current_municipality	current_municipality	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
221	http://purl.org/dc/terms/issued	377	\N	5	issued	issued	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
222	http://ldf.fi/schema/hipla/topology	625	\N	71	topology	topology	f	625	\N	\N	f	f	47	1	\N	t	f	\N	\N	\N	t	f	f
223	http://ldf.fi/schema/warsa/events/hadUnit	769	\N	81	hadUnit	hadUnit	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
224	http://ldf.fi/schema/warsa/prisoners/municipality_of_residence	4006	\N	77	municipality_of_residence	municipality_of_residence	f	4006	\N	\N	f	f	40	47	\N	t	f	\N	\N	\N	t	f	f
225	http://ldf.fi/schema/warsa/articles/unit	3357	\N	79	unit	unit	f	3357	\N	\N	f	f	55	60	\N	t	f	\N	\N	\N	t	f	f
226	http://ldf.fi/schema/warsa/places/cemeteries/cemetery_id	615	\N	84	cemetery_id	cemetery_id	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
227	http://www.w3.org/ns/sparql-service-description#graph	14	\N	27	graph	graph	f	14	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
228	http://purl.org/dc/terms/rights	2	\N	5	rights	rights	f	2	\N	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
229	http://ldf.fi/schema/narc-menehtyneet1939-45/menehtymisluokka	604	\N	88	menehtymisluokka	menehtymisluokka	f	604	\N	\N	f	f	22	\N	\N	t	f	\N	\N	\N	t	f	f
230	http://ldf.fi/schema/warsa/prisoners/karaganda_card_file	222	\N	77	karaganda_card_file	karaganda_card_file	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
187	http://www.cidoc-crm.org/cidoc-crm/P100_was_death_of	99294	\N	70	[was death of (P100_was_death_of)]	P100_was_death_of	f	99294	\N	\N	f	f	22	\N	\N	t	f	\N	\N	\N	t	f	f
194	http://ldf.fi/schema/warsa/prisoners/unit_literal	4109	\N	77	[Joukko-osasto (unit_literal)]	unit_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
211	http://ldf.fi/schema/warsa/prisoners/date_of_declaration_of_death	263	\N	77	[Date of declaration of death (date_of_declaration_of_death)]	date_of_declaration_of_death	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
215	http://ldf.fi/schema/warsa/place_of_death_literal	76694	\N	69	[Kuolinpaikka (place_of_death_literal)]	place_of_death_literal	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
216	http://ldf.fi/schema/warsa/prisoners/date_of_death	4166	\N	77	[Date of death (date_of_death)]	date_of_death	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
280	http://www.cidoc-crm.org/cidoc-crm/P143_joined	102681	\N	70	[joined (P143_joined)]	P143_joined	f	102681	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
232	http://www.w3.org/2004/02/skos/core#exactMatch	33	\N	4	exactMatch	exactMatch	f	33	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
233	http://purl.org/dc/terms/source	908601	\N	5	source	source	f	908601	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
234	http://ldf.fi/schema/warsa/prisoners/camp_id	150	\N	77	camp_id	camp_id	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
235	http://ldf.fi/schema/warsa/prisoners/camp_information	125	\N	77	camp_information	camp_information	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
236	http://purl.org/dc/terms/description	279079	\N	5	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
237	http://ldf.fi/schema/bioc/inheres_in	2	\N	72	inheres_in	inheres_in	f	2	\N	\N	f	f	3	61	\N	t	f	\N	\N	\N	t	f	f
238	http://ldf.fi/schema/warsa/family_name	98877	\N	69	family_name	family_name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
239	http://www.w3.org/2004/02/skos/core#inScheme	4055	\N	4	inScheme	inScheme	f	4055	\N	\N	f	f	60	46	\N	t	f	\N	\N	\N	t	f	f
241	http://ldf.fi/schema/warsa/articles/issue	3357	\N	79	issue	issue	f	3357	\N	\N	f	f	55	60	\N	t	f	\N	\N	\N	t	f	f
242	http://www.w3.org/2004/02/skos/core#memberList	3	\N	4	memberList	memberList	f	3	\N	\N	f	f	27	\N	\N	t	f	\N	\N	\N	t	f	f
243	http://www.w3.org/2000/01/rdf-schema#subClassOf	93	\N	2	subClassOf	subClassOf	f	93	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
244	http://purl.org/dc/terms/subject	52	\N	5	subject	subject	f	52	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
245	http://rdfs.org/ns/void#dataDump	1	\N	16	dataDump	dataDump	f	1	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
302	http://ldf.fi/schema/warsa/events/related_period	113023	\N	81	related_period	related_period	f	113023	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
246	http://ldf.fi/schema/warsa/prisoners/municipality_of_residence_literal	4118	\N	77	municipality_of_residence_literal	municipality_of_residence_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
247	http://ldf.fi/schema/warsa/prisoners/hide_documents	2930	\N	77	hide_documents	hide_documents	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
248	http://ldf.fi/schema/warsa/articles/event	2828	\N	79	event	event	f	2826	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
249	http://www.cidoc-crm.org/cidoc-crm/P82b_end_of_the_end	243762	\N	70	P82b_end_of_the_end	P82b_end_of_the_end	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
251	http://www.w3.org/2000/01/rdf-schema#range	104	\N	2	range	range	f	104	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
252	http://ldf.fi/schema/warsa/places/cemeteries/camera_club	612	\N	84	camera_club	camera_club	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
253	http://ldf.fi/schema/warsa/places/cemeteries/date_of_foundation	246	\N	84	date_of_foundation	date_of_foundation	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
254	http://ldf.fi/warsa/actors/comment	416	\N	78	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
255	http://ldf.fi/schema/warsa/prisoners/karelian_archive_documents	12	\N	77	karelian_archive_documents	karelian_archive_documents	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
256	http://www.w3.org/1999/02/22-rdf-syntax-ns#subject	16845	\N	1	subject	subject	f	16845	\N	\N	f	f	13	40	\N	t	f	\N	\N	\N	t	f	f
257	http://ldf.fi/schema/warsa/prisoners/propaganda_magazine_link	188	\N	77	propaganda_magazine_link	propaganda_magazine_link	f	188	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
258	http://ldf.fi/schema/warsa/places/cemeteries/former_municipality	191	\N	84	former_municipality	former_municipality	f	0	\N	\N	f	f	63	\N	\N	t	f	\N	\N	\N	t	f	f
259	http://ldf.fi/warsa/actors/foundation	895	\N	78	foundation	foundation	f	0	\N	\N	f	f	41	\N	\N	t	f	\N	\N	\N	t	f	f
260	http://ldf.fi/schema/warsa/nationality	94676	\N	69	nationality	nationality	f	94676	\N	\N	f	f	79	72	\N	t	f	\N	\N	\N	t	f	f
261	http://purl.org/dc/terms/publisher	2	\N	5	publisher	publisher	f	2	\N	\N	f	f	\N	14	\N	t	f	\N	\N	\N	t	f	f
262	http://ldf.fi/schema/ldf/dataVisualization	11	\N	85	dataVisualization	dataVisualization	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
263	http://ldf.fi/schema/warsa/photographs/theme	102704	\N	75	theme	theme	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
264	http://ldf.fi/schema/warsa/prisoners/rank	4138	\N	77	rank	rank	f	4138	\N	\N	f	f	40	15	\N	t	f	\N	\N	\N	t	f	f
265	http://ldf.fi/schema/warsa/articles/arms_of_service	3357	\N	79	arms_of_service	arms_of_service	f	3357	\N	\N	f	f	55	60	\N	t	f	\N	\N	\N	t	f	f
266	http://ldf.fi/schema/warsa/casualties/unit_literal	93379	\N	73	unit_literal	unit_literal	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
267	http://ldf.fi/schema/warsa/actors/knight	191	\N	80	knight	knight	f	0	\N	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
268	http://www.w3.org/2002/07/owl#same	1	\N	7	same	same	f	1	\N	\N	f	f	17	17	\N	t	f	\N	\N	\N	t	f	f
270	http://ldf.fi/schema/warsa/given_names	98681	\N	69	given_names	given_names	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
271	http://ldf.fi/warsa/actors/number	87	\N	78	number	number	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
272	http://ldf.fi/warsa/events/aircraft	1	\N	83	aircraft	aircraft	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
273	http://ldf.fi/schema/warsa/prisoners/municipality_of_death	2192	\N	77	municipality_of_death	municipality_of_death	f	2192	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
275	http://purl.org/dc/terms/date	1	\N	5	date	date	f	0	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
276	http://ldf.fi/schema/warsa/prisoners/captivity_location	120	\N	77	captivity_location	captivity_location	f	0	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
277	http://ldf.fi/warsa/places/municipalities/narc_map_id	625	\N	89	narc_map_id	narc_map_id	f	0	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
278	http://ldf.fi/schema/warsa/articles/mentionsGeneral	3381	\N	79	mentionsGeneral	mentionsGeneral	f	3381	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
279	http://ldf.fi/schema/warsa/actors/hasRank	105870	\N	80	hasRank	hasRank	f	105652	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
240	http://ldf.fi/schema/warsa/date_of_birth	98506	\N	69	[Date of birth (date_of_birth)]	date_of_birth	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
250	http://ldf.fi/schema/warsa/prisoners/date_of_return	2748	\N	77	[Date of return from captivity (date_of_return)]	date_of_return	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
274	http://www.cidoc-crm.org/cidoc-crm/P70_documents	125457	\N	70	[documents (P70_documents)]	P70_documents	f	125457	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
281	http://ldf.fi/schema/warsa/casualties/current_municipality	558	\N	73	current_municipality	current_municipality	f	558	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
284	http://www.w3.org/ns/sparql-service-description#name	14	\N	27	name	name	f	14	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
285	http://schema.org/polygon	488	\N	9	polygon	polygon	f	0	\N	\N	f	f	47	\N	\N	t	f	\N	\N	\N	t	f	f
289	http://purl.org/dc/terms/license	18	\N	5	license	license	f	18	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
290	http://ldf.fi/schema/ammo/hisco_relation	208	\N	74	hisco_relation	hisco_relation	f	208	\N	\N	f	f	88	\N	\N	t	f	\N	\N	\N	t	f	f
291	http://ldf.fi/schema/warsa/actors/number	61	\N	80	number	number	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
292	http://www.opengis.net/ont/geosparql#sfWithin	30906	\N	25	sfWithin	sfWithin	f	30906	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
293	http://www.w3.org/2003/01/geo/wgs84_pos#lat	33687	\N	25	lat	lat	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
294	http://www.georss.org/georss/point	513	\N	29	point	point	f	0	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
295	http://www.w3.org/2002/07/owl#differentFrom	1024	\N	7	differentFrom	differentFrom	f	1024	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
296	http://ldf.fi/schema/warsa/prisoners/location	9078	\N	77	location	location	f	8845	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
297	http://ldf.fi/schema/warsa/actors/level	130	\N	80	level	level	f	0	\N	\N	f	f	15	\N	\N	t	f	\N	\N	\N	t	f	f
298	http://www.cidoc-crm.org/cidoc-crm/P138_represents	521904	\N	70	P138_represents	P138_represents	f	521904	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
300	http://ldf.fi/schema/warsa/prisoners/date_begin	5926	\N	77	date_begin	date_begin	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
301	http://ldf.fi/schema/warsa/casualties/preferred_municipality	632	\N	73	preferred_municipality	preferred_municipality	f	632	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
303	http://ldf.fi/schema/warsa/prisoners/cause_of_death	716	\N	77	cause_of_death	cause_of_death	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
304	http://ldf.fi/schema/warsa/prisoners/municipality_of_death_literal	2595	\N	77	municipality_of_death_literal	municipality_of_death_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
305	http://purl.org/dc/terms/created	120966	\N	5	created	created	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
307	http://ldf.fi/schema/warsa/actors/hasConflict	15959	\N	80	hasConflict	hasConflict	f	15959	\N	\N	f	f	\N	35	\N	t	f	\N	\N	\N	t	f	f
308	http://ldf.fi/schema/warsa/events/pilot	233	\N	81	pilot	pilot	f	0	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
309	http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate	16845	\N	1	predicate	predicate	f	16845	\N	\N	f	f	13	\N	\N	t	f	\N	\N	\N	t	f	f
310	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	87	87	\N	t	f	\N	\N	\N	t	f	f
269	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	1817453	\N	1	type	type	f	1817453	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
17	http://ldf.fi/schema/warsa/casualties/municipality_of_death	41679	\N	73	[Kuolinkunta (municipality_of_death)]	municipality_of_death	f	41679	\N	\N	f	f	79	10	\N	t	f	\N	\N	\N	t	f	f
53	http://ldf.fi/schema/warsa/prisoners/place_of_going_mia_literal	1519	\N	77	[Katoamispaikka (place_of_going_mia_literal)]	place_of_going_mia_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
116	http://www.cidoc-crm.org/cidoc-crm/P70i_is_documented_in	98873	\N	70	[is documented in (P70i_is_documented_in)]	P70i_is_documented_in	f	98873	\N	\N	f	f	61	\N	\N	t	f	\N	\N	\N	t	f	f
178	http://ldf.fi/schema/warsa/date_of_going_mia	6016	\N	69	[Date of going missing in action (date_of_going_mia)]	date_of_going_mia	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
193	http://ldf.fi/schema/warsa/prisoners/place_of_capture_literal	2145	\N	77	[Vangiksi jäämisen kylä tai kaupunginosa (place_of_capture_literal)]	place_of_capture_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
231	http://ldf.fi/schema/warsa/prisoners/place_of_capture_battle_literal	1806	\N	77	[Location of battle in which captured (place_of_capture_battle_literal)]	place_of_capture_battle_literal	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
282	http://www.cidoc-crm.org/cidoc-crm/P4_has_time-span	347347	\N	70	[has time-span (P4_has_time-span)]	P4_has_time-span	f	347347	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
283	http://www.cidoc-crm.org/cidoc-crm/P7_took_place_at	224825	\N	70	[took place at (P7_took_place_at)]	P7_took_place_at	f	224825	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
286	http://ldf.fi/schema/warsa/casualties/place_of_burial_number	94606	\N	73	[Hautapaikan numero (place_of_burial_number)]	place_of_burial_number	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
287	http://ldf.fi/schema/warsa/prisoners/date_of_capture	4472	\N	77	[Date of capture (date_of_capture)]	date_of_capture	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
288	http://www.cidoc-crm.org/cidoc-crm/P97_from_father	1	\N	70	[from father (P97_from_father)]	P97_from_father	f	1	\N	\N	f	f	83	61	\N	t	f	\N	\N	\N	t	f	f
299	http://www.cidoc-crm.org/cidoc-crm/P99_dissolved	7711	\N	70	[dissolved (P99_dissolved)]	P99_dissolved	f	7711	\N	\N	f	f	5	\N	\N	t	f	\N	\N	\N	t	f	f
306	http://ldf.fi/schema/warsa/prisoners/time_of_operation	67	\N	77	[Time of operation (time_of_operation)]	time_of_operation	f	0	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

COPY http_ldf_fi_warsa_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	1	8	HISCLASS_5 -luokitus	fi
2	1	8	HISCLASS_5 classification	en
3	5	8	Additional information	en
4	5	8	Muita vankeustietoja	fi
5	6	9	note	en
6	7	8	HISCLASS_7 -luokitus	fi
7	7	8	HISCLASS_7 classification	en
8	9	8	Kotikunta	fi
9	9	8	Municipality of domicile	en
10	10	8	Place	en
11	10	8	Paikka	fi
12	11	8	refers to	en
13	11	8	viittaa	fi
14	13	8	author	en
15	13	8	artikkelin kirjoittaja	fi
16	16	8	volume	en
17	16	8	lehden vuosi	fi
18	17	8	Kuolinkunta	fi
19	17	8	Municipality of death	en
20	18	8	joined with	en
21	18	8	liittynyt osastoon	fi
22	19	8	Citizenship	en
23	19	8	Kansalaisuus	fi
24	20	8	Flyer	en
25	20	8	Lentolehtinen	fi
26	21	8	Mother tongue	en
27	21	8	Äidinkieli	fi
28	23	8	Katoamispaikka	fi
29	23	8	Place of going missing in action	en
30	26	8	Hautauskunta	fi
31	26	8	Municipality of burial	en
32	30	8	Recording (video/audio)	en
33	30	8	Tallenne (video/audio)	fi
34	32	8	Date of death	en
35	32	8	Kuolinpäivä	fi
36	34	8	Captivity location coordinates	en
37	34	8	Vankeuspaikan koordinaatit	fi
38	36	8	Date of wounding	en
39	36	8	Haavoittumispäivä	fi
40	37	8	Municipality of capture	en
41	37	8	Vangiksi jäämisen kunta	fi
42	38	8	Joukko-osaston peiteluku	fi
43	38	8	Military unit identification code	en
44	43	8	Ammatti	fi
45	43	8	Occupation	en
46	44	9	hidden label	en
47	45	8	Burial graveyard number	en
48	45	8	Hautausmaan numero	fi
49	48	8	has formed	en
50	48	8	muodostettu	fi
51	52	8	HISCO-statuskoodi	fi
52	52	8	HISCO status code	en
53	53	8	Katoamispaikka	fi
54	53	8	Place of going missing in action	en
55	54	8	Menehtymisluokka	fi
56	54	8	Perishing category	en
57	56	8	Additional information	en
58	56	8	Lisätietoja	fi
59	58	8	is related to military unit (automatic linking)	en
60	58	8	liittyy joukko-osastoon (automaattinen linkitys)	fi
61	59	8	PM:n valvontatoimiston radiokatsaukset	fi
62	59	8	Radio reports	en
63	65	8	Municipality of birth	en
64	65	8	Syntymäkunta	fi
65	66	8	page	en
66	66	8	sivu	fi
67	67	8	Siviilisääty	fi
68	67	8	Marital status	en
69	68	8	Ammatti	fi
70	68	8	Occupation	en
71	69	8	Hautauspaikka	fi
72	69	8	Place of burial	en
73	72	8	Photograph	en
74	72	8	Valokuva	fi
75	74	9	example	en
76	77	8	Neuvostoliittolaiset sotavankikortistot ja henkilömappikokoelmat	fi
77	77	8	Soviet prisoner of war card files and person registers	en
78	80	8	Katoamiskunta	fi
79	80	8	Municipality of going missing in action	en
80	81	9	label	\N
81	82	8	Municipality of birth	en
82	82	8	Synnyinkunta	fi
83	84	8	Haavoittumiskunta	fi
84	84	8	Municipality of wounding	en
85	89	8	Maininta Sotilaan Ääni -lehdessä	fi
86	89	8	Mention in a Sotilaan Ääni magazine	en
87	90	8	Asuinkunta	fi
88	90	8	Municipality of residence	en
89	91	9	preferred label	en
90	91	9	suositeltu nimike	fi
91	92	8	kind of member	en
92	92	8	henkilön rooli	fi
93	94	8	Talvisodan kokoelma	fi
94	94	8	Winter War collection	en
95	95	8	Sotilasarvo	fi
96	95	8	Military rank	en
97	96	8	Captivity locations	en
98	96	8	Vankeuspaikat	fi
99	97	8	Color photograph	en
100	97	8	Värikuva	fi
101	98	8	Cover Number 	en
102	98	8	Peiteluku	fi
103	103	8	Ammatti	fi
104	103	8	Occupation	en
105	104	8	is related to war concept (automatic linking)	en
106	104	8	liittyy sota-aiheiseen käsitteeseen (automaattinen linkitys)	fi
107	105	8	Sotilasarvo	fi
108	105	8	Military rank	en
109	106	8	has note	en
110	106	8	huomautus	fi
111	107	8	is related to person (automatic linking)	en
112	107	8	liittyy henkilöön (automaattinen linkitys)	fi
113	108	8	Date of going missing in action	en
114	108	8	Katoamispäivä	fi
115	110	8	Henkilö esiintyy tai mainitaan videolla	fi
116	110	8	Person performs or is mentioned in a video	en
117	111	8	Finnish return interrogation file	en
118	111	8	Suomalainen paluukuulustelupöytäkirja	fi
119	112	8	HISCLASS_12 -luokitus	fi
120	112	8	HISCLASS_12 classification	en
121	114	8	Image size	en
122	114	8	Kuvakoko	fi
123	115	8	rank senior to	en
124	115	8	ylempi kuin	fi
125	116	8	is documented in	en
126	116	8	dokumentoitu	fi
127	117	8	brought into life	en
128	117	8	syntynyt	fi
129	119	8	military Unit category	en
130	119	8	sotilasosastotyyppi	fi
131	120	8	Memoirs	en
132	120	8	Muistelmat, lehtiartikkelit ja kirjallisuus	fi
133	121	8	Municipality of birth	en
134	121	8	Synnyinkunta	fi
135	124	8	Description of capture	en
136	124	8	Selvitys vangiksi jäämisestä	fi
137	125	8	Henkilöön liittyvä Sotilaan Ääni -lehti	fi
138	125	8	Sotilaan Ääni magazine related to the person	en
139	126	8	Kuolinpaikka	fi
140	126	8	Place of death	en
141	127	8	order for visualization	en
142	127	8	järjestysnumero UI-visualisointiin	fi
143	128	8	Kotikunta	fi
144	128	8	Municipality of domicile	en
145	130	8	Lasten lukumäärä	fi
146	130	8	Number of children	en
147	132	8	Haavoittumispaikka	fi
148	132	8	Place of wounding	en
149	135	9	comment	\N
150	136	8	HISCO-tuotekoodi	fi
151	136	8	HISCO product code	en
152	137	8	rank equal to	en
153	137	8	vastaa	fi
154	141	8	assigned	en
155	141	8	myönnettiin	fi
156	143	8	is related to place	en
157	143	8	liittyy paikkaan	fi
158	145	9	domain	\N
159	148	8	Captivity location photographs	en
160	148	8	Vankeuspaikan valokuvia	fi
161	151	8	Municipality of capture	en
162	151	8	Vangiksi jäämisen kunta	fi
163	153	8	Lasten lukumäärä	fi
164	153	8	Number of children	en
165	160	8	Kotikunta	fi
166	160	8	Municipality of domicile	en
167	162	9	alternative label	en
168	171	8	is related to place (automatic linking)	en
169	171	8	liittyy paikkaan (automaattinen linkitys)	fi
170	175	9	definition	en
171	177	8	Confiscated possessions	en
172	177	8	Vankeudessa takavarikoitu omaisuus markoissa	fi
173	178	8	Date of going missing in action	en
174	178	8	Katoamispäivä	fi
175	180	9	Socioeconomic status	en
176	180	9	Socioekonomisk ställning	sv
177	180	9	Sosioekoniminen asema	fi
178	187	8	was death of	en
179	187	8	kuollut	fi
180	189	8	Gender	en
181	189	8	Sukupuoli	fi
182	193	8	Vangiksi jäämisen kylä tai kaupunginosa	fi
183	193	8	Village or district of capture	en
184	194	8	Joukko-osasto	fi
185	194	8	Military unit	en
186	195	8	Joukko-osasto	fi
187	195	8	Military unit	en
188	200	8	Buried in	en
189	200	8	Haudattu paikkaan	fi
190	201	8	Henkilöön liittyvä dokumentti	fi
191	201	8	A documented related to the person	en
192	204	8	Propaganda magazine	en
193	204	8	Propagandalehti	fi
194	206	9	has top concept	en
195	207	8	Photographer	en
196	207	8	Valokuvaaja	fi
197	211	8	Date of declaration of death	en
198	211	8	Kuolleeksi julistamisen päivämäärä	fi
199	215	8	Kuolinpaikka	fi
200	215	8	Place of death	en
201	216	8	Date of death	en
202	216	8	Kuolinpäivä	fi
203	220	8	Municipality of cemetery in 2016	en
204	220	8	Hautausmaan kunta 2016	fi
205	222	9	Temporal part of relations	en
206	224	8	Asuinkunta	fi
207	224	8	Municipality of residence	en
208	225	8	is related to military unit	en
209	225	8	liittyy joukko-osastoon	fi
210	230	8	Karaganda card file	en
211	230	8	Karagandan kortisto	fi
212	231	8	Location of battle in which captured	en
213	231	8	Vangiksi jäämisen taistelupaikka	fi
214	233	8	source	en
215	233	8	lähde	fi
216	234	8	Prisoners of war captivity location identifier	en
217	234	8	Sotavankeuspaikan tunniste	fi
218	235	8	Captivity location information	en
219	235	8	Tietoja vankeuspaikasta	fi
220	236	8	description	en
221	236	8	kuvaus	fi
222	238	8	Family name	en
223	238	8	Sukunimi	fi
224	240	8	Date of birth	en
225	240	8	Syntymäpäivä	fi
226	241	8	issue	en
227	241	8	lehden numero	fi
228	243	9	subClassOf	\N
229	246	8	Asuinkunta	fi
230	246	8	Municipality of residence	en
231	248	8	is related to an event	en
232	248	8	liittyy tapahtumaan	fi
233	250	8	Date of return from captivity	en
234	250	8	Sotavankeudesta palaamisen päivämäärä	fi
235	251	9	range	\N
236	255	8	Karelian archive documents	en
237	255	8	Karjalan kansallisarkiston dokumentit	fi
238	258	8	Municipality of cemetery in 1990's	en
239	258	8	Hautausmaan kunta 1990-luvulla	fi
240	260	8	Kansallisuus	fi
241	260	8	Nationality	en
242	263	8	Subject code	en
243	263	8	Kuva-aihekoodi	fi
244	265	8	arms of service	en
245	265	8	aselaji	fi
246	266	8	Joukko-osasto	fi
247	266	8	Military unit	en
248	267	8	MRR numero	fi
249	267	8	Number of Knight of Mannerheim Cross	en
250	269	9	type	en
251	269	9	tyyppi	fi
252	270	8	Etunimet	fi
253	270	8	Given names	en
254	274	8	documents	en
255	274	8	dokumentoi	fi
256	276	8	Captivity location	en
257	276	8	Vankeuspaikka	fi
258	277	8	Arkistolaitoksen karttasovelluksen id	fi
259	278	8	is related to general concept (automatic linking)	en
260	278	8	liittyy yleiskäsitteeseen (automaattinen linkitys)	fi
261	279	8	Military Rank	en
262	279	8	Sotilasarvo	fi
263	280	8	joined	en
264	280	8	liittyjä	fi
265	282	8	has time-span	en
266	282	8	tapahtuma-aika	fi
267	283	8	took place at	en
268	283	8	tapahtumapaikka	fi
269	286	8	Hautapaikan numero	fi
270	286	8	Place of burial (number)	en
271	287	8	Date of capture	en
272	287	8	Vangiksi jäämisen päivämäärä	fi
273	288	8	from father	en
274	288	8	isä	fi
275	290	8	HISCO-suhdekoodi	fi
276	290	8	HISCO relation code	en
277	292	9	Preferred part of relation	en
278	296	8	Captivity location whereabouts	en
279	296	8	Vankeuspaikan sijainti	fi
280	297	8	Level	en
281	297	8	Taso	fi
282	299	8	dissolved	en
283	299	8	lakkautettu	fi
284	302	8	Related period	en
285	302	8	Aikakausi	fi
286	303	8	Kuolinsyy	fi
287	303	8	Cause of death	en
288	306	8	Time of operation	en
289	306	8	Toiminta-aika	fi
290	307	8	participated in conflict	en
291	307	8	osallistui sotaan	fi
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.annot_types_id_seq', 9, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.cc_rels_id_seq', 10, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.class_annots_id_seq', 134, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.classes_id_seq', 90, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.cp_rels_id_seq', 1033, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.ns_id_seq', 89, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.properties_id_seq', 310, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

SELECT pg_catalog.setval('http_ldf_fi_warsa_sparql.property_annots_id_seq', 291, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_ldf_fi_warsa_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_ldf_fi_warsa_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_ldf_fi_warsa_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_ldf_fi_warsa_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_ldf_fi_warsa_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_ldf_fi_warsa_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_ldf_fi_warsa_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_ldf_fi_warsa_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_ldf_fi_warsa_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_ldf_fi_warsa_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_ldf_fi_warsa_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_ldf_fi_warsa_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_ldf_fi_warsa_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_ldf_fi_warsa_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_ldf_fi_warsa_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_ldf_fi_warsa_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_ldf_fi_warsa_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_ldf_fi_warsa_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_ldf_fi_warsa_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_ldf_fi_warsa_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_ldf_fi_warsa_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_ldf_fi_warsa_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_ldf_fi_warsa_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_ldf_fi_warsa_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_ldf_fi_warsa_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_ldf_fi_warsa_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_ldf_fi_warsa_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_ldf_fi_warsa_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_ldf_fi_warsa_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_ldf_fi_warsa_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_ldf_fi_warsa_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_ldf_fi_warsa_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_ldf_fi_warsa_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_ldf_fi_warsa_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_ldf_fi_warsa_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_ldf_fi_warsa_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_ldf_fi_warsa_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_ldf_fi_warsa_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_ldf_fi_warsa_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_ldf_fi_warsa_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_ldf_fi_warsa_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_ldf_fi_warsa_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_ldf_fi_warsa_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_ldf_fi_warsa_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_ldf_fi_warsa_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_ldf_fi_warsa_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_ldf_fi_warsa_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_ldf_fi_warsa_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_ldf_fi_warsa_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_ldf_fi_warsa_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_ldf_fi_warsa_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_ldf_fi_warsa_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_ldf_fi_warsa_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_ldf_fi_warsa_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_ldf_fi_warsa_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_ldf_fi_warsa_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_ldf_fi_warsa_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_ldf_fi_warsa_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_ldf_fi_warsa_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_ldf_fi_warsa_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_ldf_fi_warsa_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_ldf_fi_warsa_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_ldf_fi_warsa_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_ldf_fi_warsa_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_ldf_fi_warsa_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_ldf_fi_warsa_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_ldf_fi_warsa_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_ldf_fi_warsa_sparql; Owner: -
--

ALTER TABLE ONLY http_ldf_fi_warsa_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_ldf_fi_warsa_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

