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
-- Name: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_;


--
-- Name: SCHEMA https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_ IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE FUNCTION https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE FUNCTION https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COMMENT ON TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COMMENT ON COLUMN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties (
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
-- Name: c_links; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes c1
     JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties p ON ((cp1.property_id = p.id)))
     JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_cc_rels AS
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
   FROM https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels r,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes c1,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns AS
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
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes c
     LEFT JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns_main AS
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
   FROM https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns_plus AS
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
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes c
     LEFT JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns_main_plus AS
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
   FROM https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns_main_v01 AS
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
   FROM (https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns v
     LEFT JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_cp_rels AS
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
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.tapprox((r.cnt)::integer) AS cnt_x,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.tapprox(r.object_cnt) AS object_cnt_x,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels r,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes c,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_cp_rels_card AS
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
   FROM https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels r,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_properties_ns AS
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
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.tapprox(p.cnt) AS cnt_x,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.tapprox(p.object_cnt) AS object_cnt_x,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties p
     LEFT JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_cp_sources_single AS
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
   FROM ((https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_cp_rels_card r
     JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_cp_targets_single AS
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
   FROM ((https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_cp_rels_card r
     JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.tapprox((r.cnt)::integer) AS cnt_x
   FROM https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels r,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties p1,
    https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_properties_sources AS
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
   FROM (https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_properties_ns v
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
           FROM https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels r,
            https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_properties_sources_single AS
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
   FROM (https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_properties_ns v
     LEFT JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_properties_targets AS
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
   FROM (https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_properties_ns v
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
           FROM https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels r,
            https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE VIEW https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_properties_targets_single AS
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
   FROM (https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_properties_ns v
     LEFT JOIN https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	4	10	1	\N	\N
2	6	21	1	\N	\N
3	7	6	1	\N	\N
4	8	4	1	\N	\N
5	11	18	1	\N	\N
6	13	4	1	\N	\N
7	14	18	1	\N	\N
8	15	13	1	\N	\N
9	25	4	1	\N	\N
10	26	4	1	\N	\N
11	28	19	1	\N	\N
12	30	18	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	1	8	performer	en
2	3	8	music genre	en
3	5	8	media type	en
4	8	8	classical album	en
5	9	8	external link	en
6	10	8	album	en
7	11	8	important performer	en
8	12	8	broadcast standard	en
9	13	8	collection album	en
10	14	8	popular performer	en
11	15	8	best-of album	en
12	16	8	media format	en
13	17	8	DVD region code	en
14	23	8	order information	en
15	24	8	music label	en
16	25	8	popular album	en
17	26	8	original sound track	en
18	29	8	alias	en
19	30	8	classical performer	en
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	https://data.muziekweb.nl/vocab/Performer	66867	\N	t	69	Performer	Performer	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	941643
2	http://rdfs.org/ns/void#Dataset	1	\N	t	16	Dataset	Dataset	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	95
3	https://data.muziekweb.nl/vocab/Genre	637	\N	t	69	Genre	Genre	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3478820
4	http://schema.org/MusicAlbum	743265	\N	t	9	MusicAlbum	MusicAlbum	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3060929
5	https://data.muziekweb.nl/vocab/MediaType	17	\N	t	69	MediaType	MediaType	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2573605
6	http://www.w3.org/2002/07/owl#SymmetricProperty	2	\N	t	7	SymmetricProperty	SymmetricProperty	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
7	http://www.w3.org/2002/07/owl#ReflexiveProperty	1	\N	t	7	ReflexiveProperty	ReflexiveProperty	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
8	https://data.muziekweb.nl/vocab/ClassicalAlbum	159653	\N	t	69	ClassicalAlbum	ClassicalAlbum	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	370701
9	https://data.muziekweb.nl/vocab/ExternalLink	398307	\N	t	69	ExternalLink	ExternalLink	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	398307
10	https://data.muziekweb.nl/vocab/Album	743265	\N	t	69	Album	Album	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3060929
11	https://data.muziekweb.nl/vocab/ImportantPerformer	143	\N	t	69	ImportantPerformer	ImportantPerformer	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	48038
12	https://data.muziekweb.nl/vocab/BroadcastStandard	8	\N	t	69	BroadcastStandard	BroadcastStandard	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	60936
13	https://data.muziekweb.nl/vocab/CollectionAlbum	79768	\N	t	69	CollectionAlbum	CollectionAlbum	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22090
14	https://data.muziekweb.nl/vocab/PopularPerformer	392166	\N	t	69	PopularPerformer	PopularPerformer	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1076081
15	https://data.muziekweb.nl/vocab/BestOfAlbum	10413	\N	t	69	BestOfAlbum	BestOfAlbum	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10531
16	https://data.muziekweb.nl/vocab/MediaFormat	5	\N	t	69	MediaFormat	MediaFormat	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2355903
17	https://data.muziekweb.nl/vocab/DVDRegion	9	\N	t	69	DVDRegion	DVDRegion	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	27487
18	http://schema.org/MusicGroup	535558	\N	t	9	MusicGroup	MusicGroup	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1512763
19	http://schema.org/Person	157140	\N	t	9	Person	Person	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1028171
20	http://www.w3.org/2002/07/owl#Ontology	1	\N	t	7	Ontology	Ontology	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
21	http://www.w3.org/2002/07/owl#ObjectProperty	20	\N	t	7	ObjectProperty	ObjectProperty	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
22	http://www.w3.org/2002/07/owl#DatatypeProperty	20	\N	t	7	DatatypeProperty	DatatypeProperty	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
23	https://data.muziekweb.nl/vocab/OrderInformation	773024	\N	t	69	OrderInformation	OrderInformation	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	773024
24	https://data.muziekweb.nl/vocab/Label	36251	\N	t	69	Label	Label	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	773024
25	https://data.muziekweb.nl/vocab/PopularAlbum	442509	\N	t	69	PopularAlbum	PopularAlbum	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2195618
26	https://data.muziekweb.nl/vocab/OriginalSoundTrack	13220	\N	t	69	OriginalSoundTrack	OriginalSoundTrack	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	40730
27	http://www.w3.org/2002/07/owl#Class	1	\N	t	7	Class	Class	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	638
28	http://schema.org/Composer	9371	\N	t	9	Composer	Composer	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	160482
29	https://data.muziekweb.nl/vocab/Alias	25942	\N	t	69	Alias	Alias	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25942
30	https://data.muziekweb.nl/vocab/ClassicalPerformer	110184	\N	t	69	ClassicalPerformer	ClassicalPerformer	28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	392733
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	4	1	2	2973060	\N	0	\N	\N	1	1	2	f	2973060	\N	\N
2	10	1	2	2973060	\N	0	\N	\N	0	1	2	f	2973060	\N	\N
3	25	1	2	1770036	\N	0	\N	\N	0	1	2	f	1770036	\N	\N
4	8	1	2	638612	\N	0	\N	\N	0	1	2	f	638612	\N	\N
5	13	1	2	319072	\N	0	\N	\N	0	1	2	f	319072	\N	\N
6	26	1	2	52880	\N	0	\N	\N	0	1	2	f	52880	\N	\N
7	15	1	2	41652	\N	0	\N	\N	0	1	2	f	41652	\N	\N
8	18	2	2	2626	\N	2626	\N	\N	1	1	2	f	0	\N	\N
9	14	2	2	2585	\N	2585	\N	\N	0	1	2	f	0	\N	\N
10	1	2	2	2567	\N	2567	\N	\N	0	1	2	f	0	\N	\N
11	19	2	2	1542	\N	1542	\N	\N	0	1	2	f	0	\N	\N
12	11	2	2	183	\N	183	\N	\N	0	1	2	f	0	\N	\N
13	28	2	2	120	\N	120	\N	\N	0	1	2	f	0	\N	\N
14	30	2	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
15	1	2	1	2626	\N	2626	\N	\N	1	1	2	f	\N	\N	\N
16	18	2	1	2626	\N	2626	\N	\N	0	1	2	f	\N	\N	\N
17	14	2	1	2611	\N	2611	\N	\N	0	1	2	f	\N	\N	\N
18	19	2	1	1412	\N	1412	\N	\N	0	1	2	f	\N	\N	\N
19	11	2	1	100	\N	100	\N	\N	0	1	2	f	\N	\N	\N
20	28	2	1	71	\N	71	\N	\N	0	1	2	f	\N	\N	\N
21	30	2	1	15	\N	15	\N	\N	0	1	2	f	\N	\N	\N
22	18	3	2	25933	\N	0	\N	\N	1	1	2	f	25933	\N	\N
23	19	3	2	15475	\N	0	\N	\N	0	1	2	f	15475	\N	\N
24	30	3	2	14627	\N	0	\N	\N	0	1	2	f	14627	\N	\N
25	14	3	2	10767	\N	0	\N	\N	0	1	2	f	10767	\N	\N
26	28	3	2	5732	\N	0	\N	\N	0	1	2	f	5732	\N	\N
27	1	3	2	4594	\N	0	\N	\N	0	1	2	f	4594	\N	\N
28	11	3	2	234	\N	0	\N	\N	0	1	2	f	234	\N	\N
29	18	4	2	43948	\N	0	\N	\N	1	1	2	f	43948	\N	\N
30	19	4	2	29873	\N	0	\N	\N	0	1	2	f	29873	\N	\N
31	30	4	2	22135	\N	0	\N	\N	0	1	2	f	22135	\N	\N
32	1	4	2	17836	\N	0	\N	\N	0	1	2	f	17836	\N	\N
33	28	4	2	8036	\N	0	\N	\N	0	1	2	f	8036	\N	\N
34	14	4	2	6974	\N	0	\N	\N	0	1	2	f	6974	\N	\N
35	11	4	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
36	18	5	2	147403	\N	0	\N	\N	1	1	2	f	147403	\N	\N
37	30	5	2	103994	\N	0	\N	\N	0	1	2	f	103994	\N	\N
38	19	5	2	86084	\N	0	\N	\N	0	1	2	f	86084	\N	\N
39	1	5	2	28898	\N	0	\N	\N	0	1	2	f	28898	\N	\N
40	14	5	2	20492	\N	0	\N	\N	0	1	2	f	20492	\N	\N
41	28	5	2	10242	\N	0	\N	\N	0	1	2	f	10242	\N	\N
42	11	5	2	82	\N	0	\N	\N	0	1	2	f	82	\N	\N
43	21	6	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
44	18	7	2	16129	\N	16129	\N	\N	1	1	2	f	0	\N	\N
45	14	7	2	14968	\N	14968	\N	\N	0	1	2	f	0	\N	\N
46	1	7	2	13848	\N	13848	\N	\N	0	1	2	f	0	\N	\N
47	19	7	2	6379	\N	6379	\N	\N	0	1	2	f	0	\N	\N
48	30	7	2	873	\N	873	\N	\N	0	1	2	f	0	\N	\N
49	28	7	2	134	\N	134	\N	\N	0	1	2	f	0	\N	\N
50	11	7	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
51	1	7	1	16129	\N	16129	\N	\N	1	1	2	f	\N	\N	\N
52	18	7	1	16127	\N	16127	\N	\N	0	1	2	f	\N	\N	\N
53	14	7	1	15142	\N	15142	\N	\N	0	1	2	f	\N	\N	\N
54	19	7	1	7166	\N	7166	\N	\N	0	1	2	f	\N	\N	\N
55	30	7	1	904	\N	904	\N	\N	0	1	2	f	\N	\N	\N
56	28	7	1	199	\N	199	\N	\N	0	1	2	f	\N	\N	\N
57	11	7	1	64	\N	64	\N	\N	0	1	2	f	\N	\N	\N
58	9	8	2	398307	\N	0	\N	\N	1	1	2	f	398307	\N	\N
59	4	9	2	17629	\N	0	\N	\N	1	1	2	f	17629	\N	\N
60	10	9	2	17629	\N	0	\N	\N	0	1	2	f	17629	\N	\N
61	25	9	2	11390	\N	0	\N	\N	0	1	2	f	11390	\N	\N
62	8	9	2	4337	\N	0	\N	\N	0	1	2	f	4337	\N	\N
63	13	9	2	57	\N	0	\N	\N	0	1	2	f	57	\N	\N
64	15	9	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
65	4	11	2	27478	\N	27478	\N	\N	1	1	2	f	0	\N	\N
66	10	11	2	27478	\N	27478	\N	\N	0	1	2	f	0	\N	\N
67	25	11	2	12894	\N	12894	\N	\N	0	1	2	f	0	\N	\N
68	8	11	2	4581	\N	4581	\N	\N	0	1	2	f	0	\N	\N
69	13	11	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
70	15	11	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
71	17	11	1	27478	\N	27478	\N	\N	1	1	2	f	\N	\N	\N
72	27	12	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
73	4	13	2	23456	\N	0	\N	\N	1	1	2	f	23456	\N	\N
74	10	13	2	23456	\N	0	\N	\N	0	1	2	f	23456	\N	\N
75	25	13	2	10222	\N	0	\N	\N	0	1	2	f	10222	\N	\N
76	8	13	2	4250	\N	0	\N	\N	0	1	2	f	4250	\N	\N
77	13	13	2	53	\N	0	\N	\N	0	1	2	f	53	\N	\N
78	15	13	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
79	21	14	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
80	22	14	2	20	\N	20	\N	\N	2	1	2	f	0	\N	\N
81	6	14	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
82	7	14	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
83	27	14	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
84	23	16	2	773024	\N	773024	\N	\N	1	1	2	f	0	\N	\N
85	24	16	1	773024	\N	773024	\N	\N	1	1	2	f	\N	\N	\N
86	4	17	2	2355898	\N	2355898	\N	\N	1	1	2	f	0	\N	\N
87	10	17	2	2355898	\N	2355898	\N	\N	0	1	2	f	0	\N	\N
88	25	17	2	1373793	\N	1373793	\N	\N	0	1	2	f	0	\N	\N
89	8	17	2	548392	\N	548392	\N	\N	0	1	2	f	0	\N	\N
90	13	17	2	273744	\N	273744	\N	\N	0	1	2	f	0	\N	\N
91	26	17	2	41819	\N	41819	\N	\N	0	1	2	f	0	\N	\N
92	15	17	2	31682	\N	31682	\N	\N	0	1	2	f	0	\N	\N
93	16	17	1	2355898	\N	2355898	\N	\N	1	1	2	f	\N	\N	\N
94	21	18	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
95	22	18	2	18	\N	18	\N	\N	2	1	2	f	0	\N	\N
96	5	18	2	16	\N	16	\N	\N	3	1	2	f	0	\N	\N
97	17	18	2	9	\N	9	\N	\N	4	1	2	f	0	\N	\N
98	12	18	2	8	\N	8	\N	\N	5	1	2	f	0	\N	\N
99	16	18	2	5	\N	5	\N	\N	6	1	2	f	0	\N	\N
100	27	18	2	1	\N	1	\N	\N	7	1	2	f	0	\N	\N
101	6	18	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
102	7	18	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
103	2	18	1	95	\N	95	\N	\N	1	1	2	f	\N	\N	\N
104	18	20	2	1339	\N	0	\N	\N	1	1	2	f	1339	\N	\N
105	14	20	2	1171	\N	0	\N	\N	0	1	2	f	1171	\N	\N
106	1	20	2	1091	\N	0	\N	\N	0	1	2	f	1091	\N	\N
107	19	20	2	847	\N	0	\N	\N	0	1	2	f	847	\N	\N
108	28	20	2	175	\N	0	\N	\N	0	1	2	f	175	\N	\N
109	30	20	2	168	\N	0	\N	\N	0	1	2	f	168	\N	\N
110	11	20	2	32	\N	0	\N	\N	0	1	2	f	32	\N	\N
111	4	21	2	743265	\N	0	\N	\N	1	1	2	f	743265	\N	\N
112	10	21	2	743265	\N	0	\N	\N	0	1	2	f	743265	\N	\N
113	25	21	2	442509	\N	0	\N	\N	0	1	2	f	442509	\N	\N
114	8	21	2	159653	\N	0	\N	\N	0	1	2	f	159653	\N	\N
115	13	21	2	79768	\N	0	\N	\N	0	1	2	f	79768	\N	\N
116	26	21	2	13220	\N	0	\N	\N	0	1	2	f	13220	\N	\N
117	15	21	2	10413	\N	0	\N	\N	0	1	2	f	10413	\N	\N
118	2	22	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
119	20	22	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
120	4	23	2	743265	\N	0	\N	\N	1	1	2	f	743265	\N	\N
121	10	23	2	743265	\N	0	\N	\N	0	1	2	f	743265	\N	\N
122	25	23	2	442509	\N	0	\N	\N	0	1	2	f	442509	\N	\N
123	8	23	2	159653	\N	0	\N	\N	0	1	2	f	159653	\N	\N
124	13	23	2	79768	\N	0	\N	\N	0	1	2	f	79768	\N	\N
125	26	23	2	13220	\N	0	\N	\N	0	1	2	f	13220	\N	\N
126	15	23	2	10413	\N	0	\N	\N	0	1	2	f	10413	\N	\N
127	4	24	2	743265	\N	0	\N	\N	1	1	2	f	743265	\N	\N
128	10	24	2	743265	\N	0	\N	\N	0	1	2	f	743265	\N	\N
129	25	24	2	442509	\N	0	\N	\N	0	1	2	f	442509	\N	\N
130	8	24	2	159653	\N	0	\N	\N	0	1	2	f	159653	\N	\N
131	13	24	2	79768	\N	0	\N	\N	0	1	2	f	79768	\N	\N
132	26	24	2	13220	\N	0	\N	\N	0	1	2	f	13220	\N	\N
133	15	24	2	10413	\N	0	\N	\N	0	1	2	f	10413	\N	\N
134	9	26	2	398307	\N	0	\N	\N	1	1	2	f	398307	\N	\N
135	4	27	2	743265	\N	0	\N	\N	1	1	2	f	743265	\N	\N
136	10	27	2	743265	\N	0	\N	\N	0	1	2	f	743265	\N	\N
137	25	27	2	442509	\N	0	\N	\N	0	1	2	f	442509	\N	\N
138	8	27	2	159653	\N	0	\N	\N	0	1	2	f	159653	\N	\N
139	13	27	2	79768	\N	0	\N	\N	0	1	2	f	79768	\N	\N
140	26	27	2	13220	\N	0	\N	\N	0	1	2	f	13220	\N	\N
141	15	27	2	10413	\N	0	\N	\N	0	1	2	f	10413	\N	\N
142	4	28	2	2192093	\N	2192093	\N	\N	1	1	2	f	0	\N	\N
143	18	28	2	1271350	\N	1271350	\N	\N	2	1	2	f	0	\N	\N
144	23	28	2	773024	\N	773024	\N	\N	3	1	2	f	0	\N	\N
145	9	28	2	398307	\N	398307	\N	\N	4	1	2	f	0	\N	\N
146	24	28	2	36251	\N	36251	\N	\N	5	1	2	f	0	\N	\N
147	29	28	2	25942	\N	25942	\N	\N	6	1	2	f	0	\N	\N
148	3	28	2	637	\N	637	\N	\N	7	1	2	f	0	\N	\N
149	5	28	2	31	\N	31	\N	\N	8	1	2	f	0	\N	\N
150	21	28	2	23	\N	23	\N	\N	9	1	2	f	0	\N	\N
151	22	28	2	20	\N	20	\N	\N	10	1	2	f	0	\N	\N
152	17	28	2	9	\N	9	\N	\N	11	1	2	f	0	\N	\N
153	12	28	2	8	\N	8	\N	\N	12	1	2	f	0	\N	\N
154	16	28	2	5	\N	5	\N	\N	13	1	2	f	0	\N	\N
155	2	28	2	1	\N	1	\N	\N	14	1	2	f	0	\N	\N
156	20	28	2	1	\N	1	\N	\N	15	1	2	f	0	\N	\N
157	27	28	2	1	\N	1	\N	\N	16	1	2	f	0	\N	\N
158	10	28	2	2192093	\N	2192093	\N	\N	0	1	2	f	0	\N	\N
159	25	28	2	1410654	\N	1410654	\N	\N	0	1	2	f	0	\N	\N
160	14	28	2	905903	\N	905903	\N	\N	0	1	2	f	0	\N	\N
161	19	28	2	499568	\N	499568	\N	\N	0	1	2	f	0	\N	\N
162	8	28	2	485049	\N	485049	\N	\N	0	1	2	f	0	\N	\N
163	13	28	2	316096	\N	316096	\N	\N	0	1	2	f	0	\N	\N
164	30	28	2	278319	\N	278319	\N	\N	0	1	2	f	0	\N	\N
165	1	28	2	207587	\N	207587	\N	\N	0	1	2	f	0	\N	\N
166	26	28	2	51707	\N	51707	\N	\N	0	1	2	f	0	\N	\N
167	15	28	2	51049	\N	51049	\N	\N	0	1	2	f	0	\N	\N
168	28	28	2	38069	\N	38069	\N	\N	0	1	2	f	0	\N	\N
169	11	28	2	647	\N	647	\N	\N	0	1	2	f	0	\N	\N
170	6	28	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
171	7	28	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
172	27	28	1	637	\N	637	\N	\N	1	1	2	f	\N	\N	\N
173	18	29	2	346888	\N	0	\N	\N	1	1	2	f	346888	\N	\N
174	29	29	2	18234	\N	0	\N	\N	2	1	2	f	18234	\N	\N
175	14	29	2	208342	\N	0	\N	\N	0	1	2	f	208342	\N	\N
176	19	29	2	148542	\N	0	\N	\N	0	1	2	f	148542	\N	\N
177	30	29	2	110302	\N	0	\N	\N	0	1	2	f	110302	\N	\N
178	1	29	2	50614	\N	0	\N	\N	0	1	2	f	50614	\N	\N
179	28	29	2	14109	\N	0	\N	\N	0	1	2	f	14109	\N	\N
180	11	29	2	286	\N	0	\N	\N	0	1	2	f	286	\N	\N
181	3	30	2	643	\N	643	\N	\N	1	1	2	f	0	\N	\N
182	3	30	1	643	\N	643	\N	\N	1	1	2	f	\N	\N	\N
183	2	31	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
184	20	31	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
185	4	32	2	1311724	\N	1311724	\N	\N	1	1	2	f	0	\N	\N
186	10	32	2	1311724	\N	1311724	\N	\N	0	1	2	f	0	\N	\N
187	25	32	2	780610	\N	780610	\N	\N	0	1	2	f	0	\N	\N
188	8	32	2	295504	\N	295504	\N	\N	0	1	2	f	0	\N	\N
189	13	32	2	147010	\N	147010	\N	\N	0	1	2	f	0	\N	\N
190	26	32	2	23543	\N	23543	\N	\N	0	1	2	f	0	\N	\N
191	15	32	2	18229	\N	18229	\N	\N	0	1	2	f	0	\N	\N
192	5	32	1	2573589	\N	2573589	\N	\N	1	1	2	f	\N	\N	\N
193	4	33	2	743265	\N	0	\N	\N	1	1	2	f	743265	\N	\N
194	10	33	2	743265	\N	0	\N	\N	0	1	2	f	743265	\N	\N
195	25	33	2	442509	\N	0	\N	\N	0	1	2	f	442509	\N	\N
196	8	33	2	159653	\N	0	\N	\N	0	1	2	f	159653	\N	\N
197	13	33	2	79768	\N	0	\N	\N	0	1	2	f	79768	\N	\N
198	26	33	2	13220	\N	0	\N	\N	0	1	2	f	13220	\N	\N
199	15	33	2	10413	\N	0	\N	\N	0	1	2	f	10413	\N	\N
200	18	34	2	19934	\N	0	\N	\N	1	1	2	f	19934	\N	\N
201	30	34	2	12996	\N	0	\N	\N	0	1	2	f	12996	\N	\N
202	19	34	2	11640	\N	0	\N	\N	0	1	2	f	11640	\N	\N
203	1	34	2	4952	\N	0	\N	\N	0	1	2	f	4952	\N	\N
204	28	34	2	4702	\N	0	\N	\N	0	1	2	f	4702	\N	\N
205	14	34	2	3755	\N	0	\N	\N	0	1	2	f	3755	\N	\N
206	11	34	2	31	\N	0	\N	\N	0	1	2	f	31	\N	\N
207	18	35	2	1020008	\N	1020008	\N	\N	1	1	2	f	0	\N	\N
208	19	35	2	738605	\N	738605	\N	\N	0	1	2	f	0	\N	\N
209	14	35	2	586810	\N	586810	\N	\N	0	1	2	f	0	\N	\N
210	1	35	2	448886	\N	448886	\N	\N	0	1	2	f	0	\N	\N
211	30	35	2	389424	\N	389424	\N	\N	0	1	2	f	0	\N	\N
212	28	35	2	143498	\N	143498	\N	\N	0	1	2	f	0	\N	\N
213	11	35	2	36723	\N	36723	\N	\N	0	1	2	f	0	\N	\N
214	4	35	1	1020143	\N	1020143	\N	\N	1	1	2	f	\N	\N	\N
215	10	35	1	1020143	\N	1020143	\N	\N	0	1	2	f	\N	\N	\N
216	25	35	1	422199	\N	422199	\N	\N	0	1	2	f	\N	\N	\N
217	8	35	1	360155	\N	360155	\N	\N	0	1	2	f	\N	\N	\N
218	13	35	1	16455	\N	16455	\N	\N	0	1	2	f	\N	\N	\N
219	26	35	1	10886	\N	10886	\N	\N	0	1	2	f	\N	\N	\N
220	15	35	1	10461	\N	10461	\N	\N	0	1	2	f	\N	\N	\N
221	4	36	2	618835	\N	0	\N	\N	1	1	2	f	618835	\N	\N
222	10	36	2	618835	\N	0	\N	\N	0	1	2	f	618835	\N	\N
223	25	36	2	380413	\N	0	\N	\N	0	1	2	f	380413	\N	\N
224	8	36	2	136548	\N	0	\N	\N	0	1	2	f	136548	\N	\N
225	13	36	2	70402	\N	0	\N	\N	0	1	2	f	70402	\N	\N
226	26	36	2	10855	\N	0	\N	\N	0	1	2	f	10855	\N	\N
227	15	36	2	8370	\N	0	\N	\N	0	1	2	f	8370	\N	\N
228	4	37	2	60936	\N	60936	\N	\N	1	1	2	f	0	\N	\N
229	10	37	2	60936	\N	60936	\N	\N	0	1	2	f	0	\N	\N
230	25	37	2	24764	\N	24764	\N	\N	0	1	2	f	0	\N	\N
231	8	37	2	8846	\N	8846	\N	\N	0	1	2	f	0	\N	\N
232	13	37	2	110	\N	110	\N	\N	0	1	2	f	0	\N	\N
233	15	37	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
234	12	37	1	60936	\N	60936	\N	\N	1	1	2	f	\N	\N	\N
235	3	38	2	334	\N	0	\N	\N	1	1	2	f	334	\N	\N
236	21	38	2	20	\N	0	\N	\N	2	1	2	f	20	\N	\N
237	22	38	2	20	\N	0	\N	\N	3	1	2	f	20	\N	\N
238	2	38	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
239	20	38	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
240	27	38	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
241	6	38	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
242	7	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
243	4	39	2	1020143	\N	1020143	\N	\N	1	1	2	f	0	\N	\N
244	10	39	2	1020143	\N	1020143	\N	\N	0	1	2	f	0	\N	\N
245	25	39	2	422199	\N	422199	\N	\N	0	1	2	f	0	\N	\N
246	8	39	2	360155	\N	360155	\N	\N	0	1	2	f	0	\N	\N
247	13	39	2	16455	\N	16455	\N	\N	0	1	2	f	0	\N	\N
248	26	39	2	10886	\N	10886	\N	\N	0	1	2	f	0	\N	\N
249	15	39	2	10461	\N	10461	\N	\N	0	1	2	f	0	\N	\N
250	18	39	1	1020008	\N	1020008	\N	\N	1	1	2	f	\N	\N	\N
251	19	39	1	738605	\N	738605	\N	\N	0	1	2	f	\N	\N	\N
252	14	39	1	586810	\N	586810	\N	\N	0	1	2	f	\N	\N	\N
253	1	39	1	448886	\N	448886	\N	\N	0	1	2	f	\N	\N	\N
254	30	39	1	389424	\N	389424	\N	\N	0	1	2	f	\N	\N	\N
255	28	39	1	143498	\N	143498	\N	\N	0	1	2	f	\N	\N	\N
256	11	39	1	36723	\N	36723	\N	\N	0	1	2	f	\N	\N	\N
257	3	40	2	643	\N	643	\N	\N	1	1	2	f	0	\N	\N
258	3	40	1	643	\N	643	\N	\N	1	1	2	f	\N	\N	\N
259	4	41	2	686104	\N	686104	\N	\N	1	1	2	f	0	\N	\N
260	18	41	2	376132	\N	376132	\N	\N	2	1	2	f	0	\N	\N
261	10	41	2	686104	\N	686104	\N	\N	0	1	2	f	0	\N	\N
262	25	41	2	490122	\N	490122	\N	\N	0	1	2	f	0	\N	\N
263	14	41	2	315678	\N	315678	\N	\N	0	1	2	f	0	\N	\N
264	19	41	2	166298	\N	166298	\N	\N	0	1	2	f	0	\N	\N
265	1	41	2	85478	\N	85478	\N	\N	0	1	2	f	0	\N	\N
266	8	41	2	76944	\N	76944	\N	\N	0	1	2	f	0	\N	\N
267	13	41	2	72600	\N	72600	\N	\N	0	1	2	f	0	\N	\N
268	30	41	2	56926	\N	56926	\N	\N	0	1	2	f	0	\N	\N
269	28	41	2	17365	\N	17365	\N	\N	0	1	2	f	0	\N	\N
270	26	41	2	16055	\N	16055	\N	\N	0	1	2	f	0	\N	\N
271	15	41	2	13121	\N	13121	\N	\N	0	1	2	f	0	\N	\N
272	11	41	2	501	\N	501	\N	\N	0	1	2	f	0	\N	\N
273	21	42	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
274	22	42	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
275	21	42	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
276	4	43	2	2040786	\N	2040786	\N	\N	1	1	2	f	0	\N	\N
277	18	43	2	470668	\N	470668	\N	\N	2	1	2	f	0	\N	\N
278	10	43	2	2040786	\N	2040786	\N	\N	0	1	2	f	0	\N	\N
279	25	43	2	1762447	\N	1762447	\N	\N	0	1	2	f	0	\N	\N
280	14	43	2	464857	\N	464857	\N	\N	0	1	2	f	0	\N	\N
281	1	43	2	440079	\N	440079	\N	\N	0	1	2	f	0	\N	\N
282	13	43	2	280124	\N	280124	\N	\N	0	1	2	f	0	\N	\N
283	19	43	2	271861	\N	271861	\N	\N	0	1	2	f	0	\N	\N
284	15	43	2	59641	\N	59641	\N	\N	0	1	2	f	0	\N	\N
285	26	43	2	43654	\N	43654	\N	\N	0	1	2	f	0	\N	\N
286	8	43	2	12261	\N	12261	\N	\N	0	1	2	f	0	\N	\N
287	28	43	2	9519	\N	9519	\N	\N	0	1	2	f	0	\N	\N
288	30	43	2	5467	\N	5467	\N	\N	0	1	2	f	0	\N	\N
289	11	43	2	1885	\N	1885	\N	\N	0	1	2	f	0	\N	\N
290	4	43	1	2040786	\N	2040786	\N	\N	1	1	2	f	\N	\N	\N
291	1	43	1	470668	\N	470668	\N	\N	2	1	2	f	\N	\N	\N
292	10	43	1	2040786	\N	2040786	\N	\N	0	1	2	f	\N	\N	\N
293	25	43	1	1773419	\N	1773419	\N	\N	0	1	2	f	\N	\N	\N
294	18	43	1	470668	\N	470668	\N	\N	0	1	2	f	\N	\N	\N
295	14	43	1	468210	\N	468210	\N	\N	0	1	2	f	\N	\N	\N
296	19	43	1	279111	\N	279111	\N	\N	0	1	2	f	\N	\N	\N
297	26	43	1	29844	\N	29844	\N	\N	0	1	2	f	\N	\N	\N
298	28	43	1	16621	\N	16621	\N	\N	0	1	2	f	\N	\N	\N
299	11	43	1	11023	\N	11023	\N	\N	0	1	2	f	\N	\N	\N
300	8	43	1	10546	\N	10546	\N	\N	0	1	2	f	\N	\N	\N
301	13	43	1	5635	\N	5635	\N	\N	0	1	2	f	\N	\N	\N
302	30	43	1	2365	\N	2365	\N	\N	0	1	2	f	\N	\N	\N
303	15	43	1	70	\N	70	\N	\N	0	1	2	f	\N	\N	\N
304	4	44	2	743265	\N	0	\N	\N	1	1	2	f	743265	\N	\N
305	10	44	2	743265	\N	0	\N	\N	0	1	2	f	743265	\N	\N
306	25	44	2	442509	\N	0	\N	\N	0	1	2	f	442509	\N	\N
307	8	44	2	159653	\N	0	\N	\N	0	1	2	f	159653	\N	\N
308	13	44	2	79768	\N	0	\N	\N	0	1	2	f	79768	\N	\N
309	26	44	2	13220	\N	0	\N	\N	0	1	2	f	13220	\N	\N
310	15	44	2	10413	\N	0	\N	\N	0	1	2	f	10413	\N	\N
311	23	45	2	781050	\N	0	\N	\N	1	1	2	f	781050	\N	\N
312	4	46	2	714017	\N	0	\N	\N	1	1	2	f	714017	\N	\N
313	10	46	2	714017	\N	0	\N	\N	0	1	2	f	714017	\N	\N
314	25	46	2	442441	\N	0	\N	\N	0	1	2	f	442441	\N	\N
315	8	46	2	132969	\N	0	\N	\N	0	1	2	f	132969	\N	\N
316	13	46	2	79496	\N	0	\N	\N	0	1	2	f	79496	\N	\N
317	26	46	2	13218	\N	0	\N	\N	0	1	2	f	13218	\N	\N
318	15	46	2	10394	\N	0	\N	\N	0	1	2	f	10394	\N	\N
319	4	47	2	31059	\N	0	\N	\N	1	1	2	f	31059	\N	\N
320	10	47	2	31059	\N	0	\N	\N	0	1	2	f	31059	\N	\N
321	25	47	2	24518	\N	0	\N	\N	0	1	2	f	24518	\N	\N
322	8	47	2	3376	\N	0	\N	\N	0	1	2	f	3376	\N	\N
323	13	47	2	2358	\N	0	\N	\N	0	1	2	f	2358	\N	\N
324	15	47	2	391	\N	0	\N	\N	0	1	2	f	391	\N	\N
325	26	47	2	316	\N	0	\N	\N	0	1	2	f	316	\N	\N
326	5	48	1	16	\N	16	\N	\N	1	1	2	f	\N	\N	\N
327	17	48	1	9	\N	9	\N	\N	2	1	2	f	\N	\N	\N
328	16	48	1	5	\N	5	\N	\N	3	1	2	f	\N	\N	\N
329	21	49	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
330	22	49	2	20	\N	20	\N	\N	2	1	2	f	0	\N	\N
331	6	49	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
332	7	49	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
333	4	50	2	773024	\N	773024	\N	\N	1	1	2	f	0	\N	\N
334	10	50	2	773024	\N	773024	\N	\N	0	1	2	f	0	\N	\N
335	25	50	2	461937	\N	461937	\N	\N	0	1	2	f	0	\N	\N
336	8	50	2	164891	\N	164891	\N	\N	0	1	2	f	0	\N	\N
337	13	50	2	81635	\N	81635	\N	\N	0	1	2	f	0	\N	\N
338	26	50	2	13841	\N	13841	\N	\N	0	1	2	f	0	\N	\N
339	15	50	2	11298	\N	11298	\N	\N	0	1	2	f	0	\N	\N
340	23	50	1	773024	\N	773024	\N	\N	1	1	2	f	\N	\N	\N
341	18	51	2	25942	\N	25942	\N	\N	1	1	2	f	0	\N	\N
342	19	51	2	15484	\N	15484	\N	\N	0	1	2	f	0	\N	\N
343	30	51	2	14636	\N	14636	\N	\N	0	1	2	f	0	\N	\N
344	14	51	2	10767	\N	10767	\N	\N	0	1	2	f	0	\N	\N
345	28	51	2	5737	\N	5737	\N	\N	0	1	2	f	0	\N	\N
346	1	51	2	4593	\N	4593	\N	\N	0	1	2	f	0	\N	\N
347	11	51	2	233	\N	233	\N	\N	0	1	2	f	0	\N	\N
348	29	51	1	25942	\N	25942	\N	\N	1	1	2	f	\N	\N	\N
349	4	52	2	743265	\N	0	\N	\N	1	1	2	f	743265	\N	\N
350	10	52	2	743265	\N	0	\N	\N	0	1	2	f	743265	\N	\N
351	25	52	2	442509	\N	0	\N	\N	0	1	2	f	442509	\N	\N
352	8	52	2	159653	\N	0	\N	\N	0	1	2	f	159653	\N	\N
353	13	52	2	79768	\N	0	\N	\N	0	1	2	f	79768	\N	\N
354	26	52	2	13220	\N	0	\N	\N	0	1	2	f	13220	\N	\N
355	15	52	2	10413	\N	0	\N	\N	0	1	2	f	10413	\N	\N
356	1	53	2	3334	\N	3334	\N	\N	1	1	2	f	0	\N	\N
357	18	53	2	3334	\N	3334	\N	\N	0	1	2	f	0	\N	\N
358	14	53	2	3308	\N	3308	\N	\N	0	1	2	f	0	\N	\N
359	19	53	2	1864	\N	1864	\N	\N	0	1	2	f	0	\N	\N
360	11	53	2	150	\N	150	\N	\N	0	1	2	f	0	\N	\N
361	28	53	2	88	\N	88	\N	\N	0	1	2	f	0	\N	\N
362	30	53	2	25	\N	25	\N	\N	0	1	2	f	0	\N	\N
363	1	53	1	3334	\N	3334	\N	\N	1	1	2	f	\N	\N	\N
364	18	53	1	3334	\N	3334	\N	\N	0	1	2	f	\N	\N	\N
365	14	53	1	3308	\N	3308	\N	\N	0	1	2	f	\N	\N	\N
366	19	53	1	1877	\N	1877	\N	\N	0	1	2	f	\N	\N	\N
367	11	53	1	128	\N	128	\N	\N	0	1	2	f	\N	\N	\N
368	28	53	1	93	\N	93	\N	\N	0	1	2	f	\N	\N	\N
369	30	53	1	25	\N	25	\N	\N	0	1	2	f	\N	\N	\N
370	23	54	2	602132	\N	0	\N	\N	1	1	2	f	602132	\N	\N
371	4	54	2	587538	\N	0	\N	\N	2	1	2	f	587538	\N	\N
372	10	54	2	587538	\N	0	\N	\N	0	1	2	f	587538	\N	\N
373	25	54	2	367056	\N	0	\N	\N	0	1	2	f	367056	\N	\N
374	8	54	2	128544	\N	0	\N	\N	0	1	2	f	128544	\N	\N
375	13	54	2	65858	\N	0	\N	\N	0	1	2	f	65858	\N	\N
376	26	54	2	10637	\N	0	\N	\N	0	1	2	f	10637	\N	\N
377	15	54	2	8367	\N	0	\N	\N	0	1	2	f	8367	\N	\N
378	23	55	2	781066	\N	0	\N	\N	1	1	2	f	781066	\N	\N
379	4	55	2	743282	\N	0	\N	\N	2	1	2	f	743282	\N	\N
380	18	55	2	535561	\N	0	\N	\N	3	1	2	f	535561	\N	\N
381	9	55	2	398567	\N	0	\N	\N	4	1	2	f	398567	\N	\N
382	24	55	2	37143	\N	0	\N	\N	5	1	2	f	37143	\N	\N
383	29	55	2	25942	\N	0	\N	\N	6	1	2	f	25942	\N	\N
384	3	55	2	2752	\N	0	\N	\N	7	1	2	f	2752	\N	\N
385	21	55	2	20	\N	0	\N	\N	8	1	2	f	20	\N	\N
386	22	55	2	20	\N	0	\N	\N	9	1	2	f	20	\N	\N
387	5	55	2	17	\N	0	\N	\N	10	1	2	f	17	\N	\N
388	17	55	2	9	\N	0	\N	\N	11	1	2	f	9	\N	\N
389	12	55	2	8	\N	0	\N	\N	12	1	2	f	8	\N	\N
390	16	55	2	5	\N	0	\N	\N	13	1	2	f	5	\N	\N
391	2	55	2	1	\N	0	\N	\N	14	1	2	f	1	\N	\N
392	20	55	2	1	\N	0	\N	\N	15	1	2	f	1	\N	\N
393	27	55	2	1	\N	0	\N	\N	16	1	2	f	1	\N	\N
394	10	55	2	743282	\N	0	\N	\N	0	1	2	f	743282	\N	\N
395	25	55	2	442488	\N	0	\N	\N	0	1	2	f	442488	\N	\N
396	14	55	2	392165	\N	0	\N	\N	0	1	2	f	392165	\N	\N
397	8	55	2	159655	\N	0	\N	\N	0	1	2	f	159655	\N	\N
398	19	55	2	157068	\N	0	\N	\N	0	1	2	f	157068	\N	\N
399	30	55	2	110187	\N	0	\N	\N	0	1	2	f	110187	\N	\N
400	13	55	2	79767	\N	0	\N	\N	0	1	2	f	79767	\N	\N
401	1	55	2	66873	\N	0	\N	\N	0	1	2	f	66873	\N	\N
402	26	55	2	13220	\N	0	\N	\N	0	1	2	f	13220	\N	\N
403	15	55	2	10413	\N	0	\N	\N	0	1	2	f	10413	\N	\N
404	28	55	2	9368	\N	0	\N	\N	0	1	2	f	9368	\N	\N
405	11	55	2	143	\N	0	\N	\N	0	1	2	f	143	\N	\N
406	6	55	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
407	7	55	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
408	23	56	2	793451	\N	0	\N	\N	1	1	2	f	793451	\N	\N
409	4	57	2	3477534	\N	3477534	\N	\N	1	1	2	f	0	\N	\N
410	10	57	2	3477534	\N	3477534	\N	\N	0	1	2	f	0	\N	\N
411	25	57	2	2386473	\N	2386473	\N	\N	0	1	2	f	0	\N	\N
412	8	57	2	513175	\N	513175	\N	\N	0	1	2	f	0	\N	\N
413	13	57	2	386868	\N	386868	\N	\N	0	1	2	f	0	\N	\N
414	26	57	2	72286	\N	72286	\N	\N	0	1	2	f	0	\N	\N
415	15	57	2	51708	\N	51708	\N	\N	0	1	2	f	0	\N	\N
416	3	57	1	3477534	\N	3477534	\N	\N	1	1	2	f	\N	\N	\N
417	4	58	2	328123	\N	328123	\N	\N	1	1	2	f	0	\N	\N
418	18	58	2	70184	\N	70184	\N	\N	2	1	2	f	0	\N	\N
419	10	58	2	328123	\N	328123	\N	\N	0	1	2	f	0	\N	\N
420	25	58	2	215565	\N	215565	\N	\N	0	1	2	f	0	\N	\N
421	14	58	2	62698	\N	62698	\N	\N	0	1	2	f	0	\N	\N
422	19	58	2	43291	\N	43291	\N	\N	0	1	2	f	0	\N	\N
423	8	58	2	42917	\N	42917	\N	\N	0	1	2	f	0	\N	\N
424	1	58	2	31495	\N	31495	\N	\N	0	1	2	f	0	\N	\N
425	13	58	2	16338	\N	16338	\N	\N	0	1	2	f	0	\N	\N
426	30	58	2	6887	\N	6887	\N	\N	0	1	2	f	0	\N	\N
427	26	58	2	5621	\N	5621	\N	\N	0	1	2	f	0	\N	\N
428	15	58	2	4658	\N	4658	\N	\N	0	1	2	f	0	\N	\N
429	28	58	2	3061	\N	3061	\N	\N	0	1	2	f	0	\N	\N
430	11	58	2	239	\N	239	\N	\N	0	1	2	f	0	\N	\N
431	9	58	1	398307	\N	398307	\N	\N	1	1	2	f	\N	\N	\N
432	4	59	2	743282	\N	0	\N	\N	1	1	2	f	743282	\N	\N
433	18	59	2	535555	\N	0	\N	\N	2	1	2	f	535555	\N	\N
434	29	59	2	25948	\N	0	\N	\N	3	1	2	f	25948	\N	\N
435	10	59	2	743282	\N	0	\N	\N	0	1	2	f	743282	\N	\N
436	25	59	2	442488	\N	0	\N	\N	0	1	2	f	442488	\N	\N
437	14	59	2	392163	\N	0	\N	\N	0	1	2	f	392163	\N	\N
438	8	59	2	159655	\N	0	\N	\N	0	1	2	f	159655	\N	\N
439	19	59	2	157066	\N	0	\N	\N	0	1	2	f	157066	\N	\N
440	30	59	2	110184	\N	0	\N	\N	0	1	2	f	110184	\N	\N
441	13	59	2	79767	\N	0	\N	\N	0	1	2	f	79767	\N	\N
442	1	59	2	66865	\N	0	\N	\N	0	1	2	f	66865	\N	\N
443	26	59	2	13220	\N	0	\N	\N	0	1	2	f	13220	\N	\N
444	15	59	2	10413	\N	0	\N	\N	0	1	2	f	10413	\N	\N
445	28	59	2	9368	\N	0	\N	\N	0	1	2	f	9368	\N	\N
446	11	59	2	143	\N	0	\N	\N	0	1	2	f	143	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
69		https://data.muziekweb.nl/vocab/	0	t	0
70	sdo	https://schema.org/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_muziekweb	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_muziekweb	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	https://data.muziekweb.nl/MuziekwebOrganization/Muziekweb/sparql/Muziekweb	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "https://data.muziekweb.nl/MuziekwebOrganization/Muziekweb/sparql/Muziekweb", "correlationId": "889801491135920343", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": "base", "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:20:29.248Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	https://data.muziekweb.nl/vocab/mediaDescription	2973060	\N	69	mediaDescription	mediaDescription	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
2	https://data.muziekweb.nl/vocab/influencedBy	2626	\N	69	influencedBy	influencedBy	f	2626	\N	\N	f	f	18	1	\N	t	f	\N	\N	\N	t	f	f
3	http://www.w3.org/2004/02/skos/core#altLabel	25933	\N	4	altLabel	altLabel	f	0	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
4	https://data.muziekweb.nl/vocab/beginYear	43948	\N	69	beginYear	beginYear	f	0	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://schema.org/keywords	147403	\N	9	keywords	keywords	f	0	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://www.w3.org/2002/07/owl#inverseOf	1	\N	7	inverseOf	inverseOf	f	1	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
7	https://data.muziekweb.nl/vocab/seeAlso	16129	\N	69	seeAlso	seeAlso	f	16129	\N	\N	f	f	18	1	\N	t	f	\N	\N	\N	t	f	f
8	http://schema.org/url	398307	\N	9	url	url	f	0	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
9	https://data.muziekweb.nl/vocab/dvdAnnotation	17629	\N	69	dvdAnnotation	dvdAnnotation	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	29	\N	1	rest	rest	f	29	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
11	https://data.muziekweb.nl/vocab/dvdRegion	27478	\N	69	dvdRegion	dvdRegion	f	27478	\N	\N	f	f	4	17	\N	t	f	\N	\N	\N	t	f	f
12	http://www.w3.org/2000/01/rdf-schema#subClassOf	31	\N	2	subClassOf	subClassOf	f	31	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
13	https://data.muziekweb.nl/vocab/dvdSoundFormat	23456	\N	69	dvdSoundFormat	dvdSoundFormat	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://www.w3.org/2000/01/rdf-schema#range	40	\N	2	range	range	f	40	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://www.w3.org/2002/07/owl#oneOf	3	\N	7	oneOf	oneOf	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
16	https://data.muziekweb.nl/vocab/label	773024	\N	69	label	label	f	773024	\N	\N	f	f	23	24	\N	t	f	\N	\N	\N	t	f	f
17	https://data.muziekweb.nl/vocab/digitalMediaFormat	2355898	\N	69	digitalMediaFormat	digitalMediaFormat	f	2355898	\N	\N	f	f	4	16	\N	t	f	\N	\N	\N	t	f	f
18	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	95	\N	2	isDefinedBy	isDefinedBy	f	95	\N	\N	f	f	\N	2	\N	t	f	\N	\N	\N	t	f	f
19	https://schema.org/creator	1	\N	70	creator	creator	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://schema.org/description	1339	\N	9	description	description	f	0	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
21	https://data.muziekweb.nl/vocab/fullCover	743265	\N	69	fullCover	fullCover	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
22	http://www.w3.org/2002/07/owl#versionNumber	2	\N	7	versionNumber	versionNumber	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://schema.org/datePublished	743265	\N	9	datePublished	datePublished	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
24	https://data.muziekweb.nl/vocab/possibleToDigitize	743265	\N	69	possibleToDigitize	possibleToDigitize	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://www.w3.org/2002/07/owl#unionOf	3	\N	7	unionOf	unionOf	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
26	https://data.muziekweb.nl/vocab/provider	398307	\N	69	provider	provider	f	0	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
27	https://data.muziekweb.nl/vocab/userRating	743265	\N	69	userRating	userRating	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://www.w3.org/2004/02/skos/core#hiddenLabel	365122	\N	4	hiddenLabel	hiddenLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://www.w3.org/2004/02/skos/core#broader	643	\N	4	broader	broader	f	643	\N	\N	f	f	3	3	\N	t	f	\N	\N	\N	t	f	f
31	http://rdfs.org/ns/void#subSet	1	\N	16	subSet	subSet	f	1	\N	\N	f	f	2	20	\N	t	f	\N	\N	\N	t	f	f
32	https://data.muziekweb.nl/vocab/mediaType	1311724	\N	69	mediaType	mediaType	f	1311724	\N	\N	f	f	4	5	\N	t	f	\N	\N	\N	t	f	f
33	https://data.muziekweb.nl/vocab/numberOfDiscs	743265	\N	69	numberOfDiscs	numberOfDiscs	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
34	https://data.muziekweb.nl/vocab/endYear	19934	\N	69	endYear	endYear	f	0	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
35	https://data.muziekweb.nl/vocab/album	1020143	\N	69	album	album	f	1020143	\N	\N	f	f	\N	4	\N	t	f	\N	\N	\N	t	f	f
36	http://schema.org/duration	618835	\N	9	duration	duration	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
37	https://data.muziekweb.nl/vocab/broadcastStandard	60936	\N	69	broadcastStandard	broadcastStandard	f	60936	\N	\N	f	f	4	12	\N	t	f	\N	\N	\N	t	f	f
38	http://www.w3.org/2000/01/rdf-schema#comment	402	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
39	https://data.muziekweb.nl/vocab/performer	1020143	\N	69	performer	performer	f	1020143	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://www.w3.org/2004/02/skos/core#narrower	643	\N	4	narrower	narrower	f	643	\N	\N	f	f	3	3	\N	t	f	\N	\N	\N	t	f	f
41	http://www.w3.org/2002/07/owl#sameAs	1062236	\N	7	sameAs	sameAs	f	1062236	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
42	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	2	\N	2	subPropertyOf	subPropertyOf	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
43	https://data.muziekweb.nl/vocab/related	2511454	\N	69	related	related	f	2511454	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
44	https://data.muziekweb.nl/vocab/objectAvailable	743265	\N	69	objectAvailable	objectAvailable	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://schema.org/offeredBy	781050	\N	9	offeredBy	offeredBy	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
46	https://data.muziekweb.nl/vocab/genreCode	714017	\N	69	genreCode	genreCode	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
47	https://data.muziekweb.nl/vocab/buyAdvice	31059	\N	69	buyAdvice	buyAdvice	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	29	\N	1	first	first	f	29	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://www.w3.org/2000/01/rdf-schema#domain	40	\N	2	domain	domain	f	40	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
50	https://data.muziekweb.nl/vocab/orderInformation	773024	\N	69	orderInformation	orderInformation	f	773024	\N	\N	f	f	4	23	\N	t	f	\N	\N	\N	t	f	f
28	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	4697768	\N	1	type	type	f	4697768	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
51	https://data.muziekweb.nl/vocab/alias	25942	\N	69	alias	alias	f	25942	\N	\N	f	f	18	29	\N	t	f	\N	\N	\N	t	f	f
52	https://data.muziekweb.nl/vocab/lending	743265	\N	69	lending	lending	f	0	\N	\N	f	f	4	\N	\N	t	f	\N	\N	\N	t	f	f
53	https://data.muziekweb.nl/vocab/contemporary	3334	\N	69	contemporary	contemporary	f	3334	\N	\N	f	f	1	1	\N	t	f	\N	\N	\N	t	f	f
54	https://data.muziekweb.nl/vocab/ean	1189670	\N	69	ean	ean	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://www.w3.org/2000/01/rdf-schema#label	2524415	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
56	https://data.muziekweb.nl/vocab/labelNumber	793451	\N	69	labelNumber	labelNumber	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
57	https://data.muziekweb.nl/vocab/genre	3477534	\N	69	genre	genre	f	3477534	\N	\N	f	f	4	3	\N	t	f	\N	\N	\N	t	f	f
58	https://data.muziekweb.nl/vocab/externalLink	398307	\N	69	externalLink	externalLink	f	398307	\N	\N	f	f	\N	9	\N	t	f	\N	\N	\N	t	f	f
59	http://www.w3.org/2004/02/skos/core#prefLabel	1304785	\N	4	prefLabel	prefLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

COPY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	1	8	has media description	en
2	2	8	influenced	en
3	7	8	see also	en
4	13	8	has DVD sound format	en
5	24	8	can be digitized	en
6	27	8	has user rating	en
7	32	8	has media type	en
8	44	8	object available	en
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels_id_seq', 12, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.class_annots_id_seq', 19, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes_id_seq', 30, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels_id_seq', 446, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns_id_seq', 70, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties_id_seq', 59, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

SELECT pg_catalog.setval('https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.property_annots_id_seq', 8, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_cc_rels_data ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_classes_cnt ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_classes_data ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_classes_iri ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_cp_rels_data ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_instances_local_name ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_instances_test ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_data ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_properties_cnt ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_properties_data ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

CREATE INDEX idx_properties_iri ON https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_; Owner: -
--

ALTER TABLE ONLY https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES https_data_muziekweb_nl_muziekweborganization_muziekweb_sparql_.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

