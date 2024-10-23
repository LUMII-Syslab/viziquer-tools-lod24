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
-- Name: http_rdf_disgenet_org_sparql_; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_rdf_disgenet_org_sparql_;


--
-- Name: SCHEMA http_rdf_disgenet_org_sparql_; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_rdf_disgenet_org_sparql_ IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE FUNCTION http_rdf_disgenet_org_sparql_.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE FUNCTION http_rdf_disgenet_org_sparql_.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COMMENT ON TABLE http_rdf_disgenet_org_sparql_._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COMMENT ON COLUMN http_rdf_disgenet_org_sparql_.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_rdf_disgenet_org_sparql_.classes c1
     JOIN http_rdf_disgenet_org_sparql_.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_rdf_disgenet_org_sparql_.properties p ON ((cp1.property_id = p.id)))
     JOIN http_rdf_disgenet_org_sparql_.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_rdf_disgenet_org_sparql_.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE TABLE http_rdf_disgenet_org_sparql_.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE http_rdf_disgenet_org_sparql_.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_rdf_disgenet_org_sparql_.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_cc_rels AS
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
   FROM http_rdf_disgenet_org_sparql_.cc_rels r,
    http_rdf_disgenet_org_sparql_.classes c1,
    http_rdf_disgenet_org_sparql_.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_classes_ns AS
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
    http_rdf_disgenet_org_sparql_.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_rdf_disgenet_org_sparql_.classes c
     LEFT JOIN http_rdf_disgenet_org_sparql_.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_classes_ns_main AS
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
   FROM http_rdf_disgenet_org_sparql_.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_rdf_disgenet_org_sparql_.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_classes_ns_plus AS
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
    http_rdf_disgenet_org_sparql_.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_rdf_disgenet_org_sparql_.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_rdf_disgenet_org_sparql_.classes c
     LEFT JOIN http_rdf_disgenet_org_sparql_.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_classes_ns_main_plus AS
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
   FROM http_rdf_disgenet_org_sparql_.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_rdf_disgenet_org_sparql_.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_classes_ns_main_v01 AS
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
   FROM (http_rdf_disgenet_org_sparql_.v_classes_ns v
     LEFT JOIN http_rdf_disgenet_org_sparql_.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_cp_rels AS
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
    http_rdf_disgenet_org_sparql_.tapprox((r.cnt)::integer) AS cnt_x,
    http_rdf_disgenet_org_sparql_.tapprox(r.object_cnt) AS object_cnt_x,
    http_rdf_disgenet_org_sparql_.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_rdf_disgenet_org_sparql_.cp_rels r,
    http_rdf_disgenet_org_sparql_.classes c,
    http_rdf_disgenet_org_sparql_.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_cp_rels_card AS
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
   FROM http_rdf_disgenet_org_sparql_.cp_rels r,
    http_rdf_disgenet_org_sparql_.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_properties_ns AS
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
    http_rdf_disgenet_org_sparql_.tapprox(p.cnt) AS cnt_x,
    http_rdf_disgenet_org_sparql_.tapprox(p.object_cnt) AS object_cnt_x,
    http_rdf_disgenet_org_sparql_.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_rdf_disgenet_org_sparql_.properties p
     LEFT JOIN http_rdf_disgenet_org_sparql_.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_cp_sources_single AS
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
   FROM ((http_rdf_disgenet_org_sparql_.v_cp_rels_card r
     JOIN http_rdf_disgenet_org_sparql_.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_rdf_disgenet_org_sparql_.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_cp_targets_single AS
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
   FROM ((http_rdf_disgenet_org_sparql_.v_cp_rels_card r
     JOIN http_rdf_disgenet_org_sparql_.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_rdf_disgenet_org_sparql_.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_rdf_disgenet_org_sparql_.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_rdf_disgenet_org_sparql_.pp_rels r,
    http_rdf_disgenet_org_sparql_.properties p1,
    http_rdf_disgenet_org_sparql_.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_properties_sources AS
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
   FROM (http_rdf_disgenet_org_sparql_.v_properties_ns v
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
           FROM http_rdf_disgenet_org_sparql_.cp_rels r,
            http_rdf_disgenet_org_sparql_.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_properties_sources_single AS
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
   FROM (http_rdf_disgenet_org_sparql_.v_properties_ns v
     LEFT JOIN http_rdf_disgenet_org_sparql_.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_properties_targets AS
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
   FROM (http_rdf_disgenet_org_sparql_.v_properties_ns v
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
           FROM http_rdf_disgenet_org_sparql_.cp_rels r,
            http_rdf_disgenet_org_sparql_.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE VIEW http_rdf_disgenet_org_sparql_.v_properties_targets_single AS
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
   FROM (http_rdf_disgenet_org_sparql_.v_properties_ns v
     LEFT JOIN http_rdf_disgenet_org_sparql_.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	2	39	1	\N	\N
2	15	92	1	\N	\N
3	20	18	1	\N	\N
4	24	57	1	\N	\N
5	26	61	1	\N	\N
6	27	61	1	\N	\N
7	33	32	1	\N	\N
8	53	14	1	\N	\N
9	54	14	1	\N	\N
10	70	68	1	\N	\N
11	71	2	1	\N	\N
12	74	68	1	\N	\N
13	90	14	1	\N	\N
14	100	57	1	\N	\N
15	101	57	1	\N	\N
16	102	61	1	\N	\N
17	104	68	1	\N	\N
18	109	68	1	\N	\N
19	110	74	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	1	8	gene-disease association linked with genetic variation	en
2	3	8	Protein	\N
3	4	8	DisGeNET disease specificity	en
4	5	8	Gene Symbol	\N
5	7	8	reference	\N
6	8	8	splice_donor_variant	\N
7	9	8	stop_gained	\N
8	10	8	frameshift_variant	\N
9	11	8	splice_region_variant	\N
10	12	8	non_coding_transcript_exon_variant	\N
11	13	8	stop_lost	\N
12	14	8	Disease, Disorder or Finding	\N
13	19	8	Ontology	\N
14	20	8	OntologyProperty	\N
15	22	8	fusion gene-disease association	en
16	29	8	stop_retained_variant	\N
17	30	8	gene-disease association linked with germline modifying mutation	en
18	31	8	gene-disease association linked with chromosomal rearrangement	en
19	33	8	data about an ontology part	\N
20	36	8	curator inference	\N
21	36	8	curator_inference	\N
22	36	8	curator_inference	en
23	37	8	gene-disease biomarker association	en
24	38	8	Article	\N
25	41	8	frequency	en
26	42	8	variant	en
27	43	8	sequence start position	en
28	44	8	sequence_variant	\N
29	45	8	intron_variant	\N
30	46	8	3_prime_UTR_variant	\N
31	47	8	start_lost	\N
32	48	8	inframe_deletion	\N
33	49	8	regulatory_region_variant	\N
34	50	8	inframe_insertion	\N
35	51	8	coding_sequence_variant	\N
36	52	8	mature_miRNA_variant	\N
37	53	8	disease	en
38	54	8	phenotype	en
39	55	8	Class	\N
40	59	8	InverseFunctionalProperty	\N
41	64	8	therapeutic gene-disease association	en
42	65	8	gene-disease association linked with modifying mutation	en
43	66	8	gene-disease association linked with susceptibility mutation	en
44	67	8	gene-disease association linked with somatic causal mutation	en
45	68	8	ObjectProperty	\N
46	69	8	FunctionalProperty	\N
47	70	8	SymmetricProperty	\N
48	72	8	sequence orthology evidence used in manual assertion	\N
49	73	8	combinatorial evidence	\N
50	75	8	Score	\N
51	76	8	Gene	\N
52	77	8	gene-disease association linked with altered gene expression	en
53	78	8	DisGeNET Pleiotropy Index	en
54	79	8	intergenic_variant	\N
55	80	8	missense_variant	\N
56	81	8	downstream_gene_variant	\N
57	82	8	splice_acceptor_variant	\N
58	83	8	synonymous_variant	\N
59	84	8	5_prime_UTR_variant	\N
60	85	8	upstream_gene_variant	\N
61	86	8	protein_altering_variant	\N
62	87	8	TF_binding_site_variant	\N
63	88	8	association	en
64	89	8	gene-disease association linked with causal mutation	en
65	90	8	Group	\N
66	91	8	gene-disease association	en
67	96	8	Restriction	\N
68	97	8	AnnotationProperty	\N
69	103	8	gene-disease association linked with germline causal mutation	en
70	104	8	TransitiveProperty	\N
71	105	8	DatatypeProperty	\N
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
2	http://www.w3.org/ns/dcat#Distribution	54	\N	t	15	Distribution	Distribution	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8248507
6	http://purl.obolibrary.org/obo/SO_000957	194515	\N	t	40	SO_000957	SO_000957	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	194515
7	http://purl.obolibrary.org/obo/GENO_0000152	392995	\N	t	40	GENO_0000152	GENO_0000152	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	392995
15	http://www.w3.org/2001/vcard-rdf/3.0#voice	2	\N	t	73	voice	voice	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
1	http://semanticscience.org/resource/SIO_001122	800444	\N	t	70	SIO_001122	[gene-disease association linked with genetic var.. (SIO_001122)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
3	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C17021	17369	\N	t	72	C17021	[Protein (C17021)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	17666
4	http://semanticscience.org/resource/SIO_001351	220696	\N	t	70	SIO_001351	[DisGeNET disease specificity (SIO_001351)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	220696
5	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C43568	26176	\N	t	72	C43568	[Gene Symbol (C43568)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	52362
8	http://purl.obolibrary.org/obo/SO_0001575	4295	\N	t	40	SO_0001575	[splice_donor_variant (SO_0001575)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15253
9	http://purl.obolibrary.org/obo/SO_0001587	14898	\N	t	40	SO_0001587	[stop_gained (SO_0001587)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	64276
10	http://purl.obolibrary.org/obo/SO_0001589	21513	\N	t	40	SO_0001589	[frameshift_variant (SO_0001589)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	70641
11	http://purl.obolibrary.org/obo/SO_0001630	1644	\N	t	40	SO_0001630	[splice_region_variant (SO_0001630)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6498
12	http://purl.obolibrary.org/obo/SO_0001792	3945	\N	t	40	SO_0001792	[non_coding_transcript_exon_variant (SO_0001792)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14538
13	http://purl.obolibrary.org/obo/SO_0001578	140	\N	t	40	SO_0001578	[stop_lost (SO_0001578)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	870
14	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C7057	78757	\N	t	72	C7057	[Disease, Disorder or Finding (C7057)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4098705
16	http://www.w3.org/2000/01/rdf-schema#Datatype	40	\N	t	2	Datatype	Datatype	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	40
17	http://www.w3.org/2002/07/owl#AllDisjointClasses	35	\N	t	7	AllDisjointClasses	AllDisjointClasses	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
18	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	267	\N	t	1	Property	Property	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	295291
19	http://www.w3.org/2002/07/owl#Ontology	16	\N	t	7	Ontology	Ontology	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2173
20	http://www.w3.org/2002/07/owl#OntologyProperty	4	\N	t	7	OntologyProperty	OntologyProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
21	http://identifiers.org/idot/AccessPattern	20	\N	t	74	AccessPattern	AccessPattern	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18
23	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	t	36	BusinessEntity	BusinessEntity	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
24	http://purl.org/goodrelations/v1#ActualProductOrServicesInstance	1	\N	t	36	ActualProductOrServicesInstance	ActualProductOrServicesInstance	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
25	http://purl.org/goodrelations/v1#TypeAndQuantityNode	3	\N	t	36	TypeAndQuantityNode	TypeAndQuantityNode	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
26	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AAB316003-tax	1	\N	t	75	C_AAB316003-tax	C_AAB316003-tax	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
27	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKE112003-tax	1	\N	t	75	C_AKE112003-tax	C_AKE112003-tax	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
28	http://www.openlinksw.com/ontology/acl#Scope	1	\N	t	76	Scope	Scope	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
32	http://www.w3.org/2002/07/owl#NamedIndividual	5	\N	t	7	NamedIndividual	NamedIndividual	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	29
33	http://purl.obolibrary.org/obo/IAO_0000102	2	\N	t	40	IAO_0000102	IAO_0000102	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19
34	http://www.w3.org/ns/prov#Organization	19	\N	t	26	Organization	Organization	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	192703
35	http://www.w3.org/ns/prov#Agent	3	\N	t	26	Agent	Agent	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
36	http://purl.obolibrary.org/obo/ECO_0000205	1	\N	t	40	ECO_0000205	ECO_0000205	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7
39	http://purl.org/dc/dcmitype/Dataset	56	\N	t	71	Dataset	Dataset	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8248509
40	http://rdfs.org/ns/void#Dataset	18	\N	t	16	Dataset	Dataset	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4351289
42	http://purl.obolibrary.org/obo/GENO_0000476	392995	\N	t	40	GENO_0000476	GENO_0000476	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	392995
55	http://www.w3.org/2002/07/owl#Class	361307	\N	t	7	Class	Class	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12041019
29	http://purl.obolibrary.org/obo/SO_0001567	2	\N	t	40	SO_0001567	[stop_retained_variant (SO_0001567)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10
30	http://semanticscience.org/resource/SIO_001347	65	\N	t	70	SIO_001347	[gene-disease association linked with germline mo.. (SIO_001347)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
31	http://semanticscience.org/resource/SIO_001349	223	\N	t	70	SIO_001349	[gene-disease association linked with chromosomal.. (SIO_001349)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
38	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C47902	797936	\N	t	72	C47902	[Article (C47902)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3702960
41	http://semanticscience.org/resource/SIO_001367	392995	\N	t	70	SIO_001367	[frequency (SIO_001367)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	392995
43	http://semanticscience.org/resource/SIO_000791	194515	\N	t	70	SIO_000791	[sequence start position (SIO_000791)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	194515
44	http://purl.obolibrary.org/obo/SO_0001060	194515	\N	t	40	SO_0001060	[sequence_variant (SO_0001060)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	736241
45	http://purl.obolibrary.org/obo/SO_0001627	59646	\N	t	40	SO_0001627	[intron_variant (SO_0001627)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	184018
46	http://purl.obolibrary.org/obo/SO_0001624	3862	\N	t	40	SO_0001624	[3_prime_UTR_variant (SO_0001624)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15616
47	http://purl.obolibrary.org/obo/SO_0002012	535	\N	t	40	SO_0002012	[start_lost (SO_0002012)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2426
48	http://purl.obolibrary.org/obo/SO_0001822	976	\N	t	40	SO_0001822	[inframe_deletion (SO_0001822)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3878
49	http://purl.obolibrary.org/obo/SO_0001566	3116	\N	t	40	SO_0001566	[regulatory_region_variant (SO_0001566)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9141
51	http://purl.obolibrary.org/obo/SO_0001580	53	\N	t	40	SO_0001580	[coding_sequence_variant (SO_0001580)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	208
52	http://purl.obolibrary.org/obo/SO_0001620	40	\N	t	40	SO_0001620	[mature_miRNA_variant (SO_0001620)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1404
53	http://semanticscience.org/resource/SIO_010299	21838	\N	t	70	SIO_010299	[disease (SIO_010299)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2791277
54	http://semanticscience.org/resource/SIO_010056	7493	\N	t	70	SIO_010056	[phenotype (SIO_010056)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	527177
56	http://www.w3.org/2002/07/owl#Annotation	10258	\N	t	7	Annotation	Annotation	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
57	http://www.w3.org/2000/01/rdf-schema#Class	268	\N	t	2	Class	Class	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9767253
58	http://www.w3.org/ns/sparql-service-description#Service	2	\N	t	27	Service	Service	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
59	http://www.w3.org/2002/07/owl#InverseFunctionalProperty	11	\N	t	7	InverseFunctionalProperty	InverseFunctionalProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	46
60	http://purl.org/goodrelations/v1#Offering	3	\N	t	36	Offering	Offering	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
61	http://purl.org/goodrelations/v1#ProductOrServicesSomeInstancesPlaceholder	3	\N	t	36	ProductOrServicesSomeInstancesPlaceholder	ProductOrServicesSomeInstancesPlaceholder	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
62	http://purl.org/goodrelations/v1#Manufacturer	1	\N	t	36	Manufacturer	Manufacturer	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
63	http://www.w3.org/2002/07/owl#inverseFunctionalProperty	4	\N	t	7	inverseFunctionalProperty	inverseFunctionalProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11
68	http://www.w3.org/2002/07/owl#ObjectProperty	604	\N	t	7	ObjectProperty	ObjectProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	273720
69	http://www.w3.org/2002/07/owl#FunctionalProperty	15	\N	t	7	FunctionalProperty	FunctionalProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	56
70	http://www.w3.org/2002/07/owl#SymmetricProperty	40	\N	t	7	SymmetricProperty	SymmetricProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	91
71	http://rdfs.org/ns/void#Linkset	10	\N	t	16	Linkset	Linkset	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	28
72	http://purl.obolibrary.org/obo/ECO_0000266	1	\N	t	40	ECO_0000266	ECO_0000266	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
73	http://purl.obolibrary.org/obo/ECO_0000212	1	\N	t	40	ECO_0000212	ECO_0000212	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
74	http://www.w3.org/2002/07/owl#IrreflexiveProperty	3	\N	t	7	IrreflexiveProperty	IrreflexiveProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	63
87	http://purl.obolibrary.org/obo/SO_0001782	342	\N	t	40	SO_0001782	SO_0001782	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1108
89	http://semanticscience.org/resource/SIO_001119	65588	\N	t	70	SIO_001119	SIO_001119	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
91	http://semanticscience.org/resource/SIO_000983	29135	\N	t	70	SIO_000983	SIO_000983	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
92	http://www.w3.org/2001/vcard-rdf/3.0#work	2	\N	t	73	work	work	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
93	http://www.w3.org/2001/vcard-rdf/3.0#internet	2	\N	t	73	internet	internet	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
94	http://www.w3.org/2002/07/owl#Axiom	985111	\N	t	7	Axiom	Axiom	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	10999
95	http://www.w3.org/1999/02/22-rdf-syntax-ns#List	328	\N	t	1	List	List	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	328
65	http://semanticscience.org/resource/SIO_001342	326	\N	t	70	SIO_001342	[gene-disease association linked with modifying m.. (SIO_001342)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
66	http://semanticscience.org/resource/SIO_001343	1260	\N	t	70	SIO_001343	[gene-disease association linked with susceptibil.. (SIO_001343)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
75	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C25338	1501810	\N	t	72	C25338	[Score (C25338)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3994855
76	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C16612	130895	\N	t	72	C16612	[Gene (C16612)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3696429
77	http://semanticscience.org/resource/SIO_001123	638378	\N	t	70	SIO_001123	[gene-disease association linked with altered gen.. (SIO_001123)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
78	http://semanticscience.org/resource/SIO_001352	220696	\N	t	70	SIO_001352	[DisGeNET Pleiotropy Index (SIO_001352)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	220696
79	http://purl.obolibrary.org/obo/SO_0001628	14207	\N	t	40	SO_0001628	[intergenic_variant (SO_0001628)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	39361
80	http://purl.obolibrary.org/obo/SO_0001583	47727	\N	t	40	SO_0001583	[missense_variant (SO_0001583)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	434608
81	http://purl.obolibrary.org/obo/SO_0001632	3839	\N	t	40	SO_0001632	[downstream_gene_variant (SO_0001632)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11905
82	http://purl.obolibrary.org/obo/SO_0001574	3562	\N	t	40	SO_0001574	[splice_acceptor_variant (SO_0001574)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12606
84	http://purl.obolibrary.org/obo/SO_0001623	1203	\N	t	40	SO_0001623	[5_prime_UTR_variant (SO_0001623)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6279
85	http://purl.obolibrary.org/obo/SO_0001631	1203	\N	t	40	SO_0001631	[upstream_gene_variant (SO_0001631)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6270
86	http://purl.obolibrary.org/obo/SO_0001818	105	\N	t	40	SO_0001818	[protein_altering_variant (SO_0001818)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	309
88	http://semanticscience.org/resource/SIO_000897	736241	\N	t	70	SIO_000897	[association (SIO_000897)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
90	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C43359	962	\N	t	72	C43359	[Group (C43359)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	689077
96	http://www.w3.org/2002/07/owl#Restriction	421281	\N	t	7	Restriction	Restriction	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	421281
97	http://www.w3.org/2002/07/owl#AnnotationProperty	507	\N	t	7	AnnotationProperty	AnnotationProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	939703
98	http://www.openlinksw.com/schemas/VAD#	1	\N	t	77			254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
99	http://purl.org/goodrelations/v1#LocationOfSalesOrServiceProvisioning	1	\N	t	36	LocationOfSalesOrServiceProvisioning	LocationOfSalesOrServiceProvisioning	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
100	http://purl.org/goodrelations/v1#ProductOrServiceSomeInstancePlaceholder	1	\N	t	36	ProductOrServiceSomeInstancePlaceholder	ProductOrServiceSomeInstancePlaceholder	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15
101	http://purl.org/goodrelations/v1#PriceSpecification	1	\N	t	36	PriceSpecification	PriceSpecification	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
102	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKJ315005-tax	1	\N	t	75	C_AKJ315005-tax	C_AKJ315005-tax	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
103	http://semanticscience.org/resource/SIO_001344	6275	\N	t	70	SIO_001344	SIO_001344	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
104	http://www.w3.org/2002/07/owl#TransitiveProperty	57	\N	t	7	TransitiveProperty	TransitiveProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	85801
105	http://www.w3.org/2002/07/owl#DatatypeProperty	10	\N	t	7	DatatypeProperty	DatatypeProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	515
106	http://rdfs.org/ns/void#DatasetDescription	2	\N	t	16	DatasetDescription	DatasetDescription	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
107	http://xmlns.com/foaf/0.1/Person	7	\N	t	8	Person	Person	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	145
108	http://www.w3.org/ns/prov#SoftwareAgent	1	\N	t	26	SoftwareAgent	SoftwareAgent	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
109	http://www.w3.org/2002/07/owl#ReflexiveProperty	3	\N	t	7	ReflexiveProperty	ReflexiveProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	32
110	http://www.w3.org/2002/07/owl#AsymmetricProperty	2	\N	t	7	AsymmetricProperty	AsymmetricProperty	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	52
22	http://semanticscience.org/resource/SIO_001348	315	\N	t	70	SIO_001348	[fusion gene-disease association (SIO_001348)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
37	http://semanticscience.org/resource/SIO_001121	1705576	\N	t	70	SIO_001121	[gene-disease biomarker association (SIO_001121)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
50	http://purl.obolibrary.org/obo/SO_0001821	208	\N	t	40	SO_0001821	[inframe_insertion (SO_0001821)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	704
64	http://semanticscience.org/resource/SIO_001120	10744	\N	t	70	SIO_001120	[therapeutic gene-disease association (SIO_001120)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
67	http://semanticscience.org/resource/SIO_001345	285	\N	t	70	SIO_001345	[gene-disease association linked with somatic cau.. (SIO_001345)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
83	http://purl.obolibrary.org/obo/SO_0001819	2416	\N	t	40	SO_0001819	[synonymous_variant (SO_0001819)]	254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11307
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	2	1	2	51	\N	51	\N	\N	1	1	2	f	0	\N	\N
2	39	1	2	51	\N	51	\N	\N	0	1	2	f	0	\N	\N
3	40	1	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
4	71	1	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
5	34	1	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
6	107	2	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
7	39	3	2	44	\N	44	\N	\N	1	1	2	f	0	\N	\N
8	34	3	2	19	\N	19	\N	\N	2	1	2	f	0	\N	\N
9	97	3	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
10	2	3	2	42	\N	42	\N	\N	0	1	2	f	0	\N	\N
11	71	3	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
12	40	3	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
13	21	3	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
14	55	4	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
15	55	5	2	481	\N	0	\N	\N	1	1	2	f	481	\N	\N
16	94	6	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
17	55	7	2	1945	\N	0	\N	\N	1	1	2	f	1945	\N	\N
18	55	8	2	760	\N	0	\N	\N	1	1	2	f	760	\N	\N
19	97	8	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
20	14	8	2	117	\N	0	\N	\N	0	1	2	f	117	\N	\N
21	55	9	2	2736	\N	0	\N	\N	1	1	2	f	2736	\N	\N
22	97	9	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
23	14	9	2	167	\N	0	\N	\N	0	1	2	f	167	\N	\N
24	57	9	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
25	55	10	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
26	55	10	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
27	55	11	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
28	97	11	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
29	97	12	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
30	55	13	2	40	\N	0	\N	\N	1	1	2	f	40	\N	\N
31	97	13	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
32	55	14	2	331	\N	0	\N	\N	1	1	2	f	331	\N	\N
33	97	15	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
34	55	15	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
35	37	16	2	1705576	\N	1705576	\N	\N	1	1	2	f	0	\N	\N
36	1	16	2	800444	\N	800444	\N	\N	2	1	2	f	0	\N	\N
37	88	16	2	736241	\N	736241	\N	\N	3	1	2	f	0	\N	\N
38	77	16	2	638378	\N	638378	\N	\N	4	1	2	f	0	\N	\N
39	42	16	2	392995	\N	392995	\N	\N	5	1	2	f	0	\N	\N
40	7	16	2	392995	\N	392995	\N	\N	6	1	2	f	0	\N	\N
41	89	16	2	65588	\N	65588	\N	\N	7	1	2	f	0	\N	\N
42	91	16	2	29135	\N	29135	\N	\N	8	1	2	f	0	\N	\N
43	64	16	2	10744	\N	10744	\N	\N	9	1	2	f	0	\N	\N
44	103	16	2	6275	\N	6275	\N	\N	10	1	2	f	0	\N	\N
45	66	16	2	1260	\N	1260	\N	\N	11	1	2	f	0	\N	\N
46	65	16	2	326	\N	326	\N	\N	12	1	2	f	0	\N	\N
47	22	16	2	315	\N	315	\N	\N	13	1	2	f	0	\N	\N
48	67	16	2	285	\N	285	\N	\N	14	1	2	f	0	\N	\N
49	31	16	2	223	\N	223	\N	\N	15	1	2	f	0	\N	\N
50	30	16	2	65	\N	65	\N	\N	16	1	2	f	0	\N	\N
51	2	16	1	3897154	\N	3897154	\N	\N	1	1	2	f	\N	\N	\N
52	39	16	1	3897154	\N	3897154	\N	\N	0	1	2	f	\N	\N	\N
53	34	16	1	192588	\N	192588	\N	\N	0	1	2	f	\N	\N	\N
54	55	17	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
55	19	17	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
56	71	18	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
57	39	18	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
58	2	18	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
59	55	18	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
60	57	18	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
61	96	19	2	23	\N	0	\N	\N	1	1	2	f	23	\N	\N
62	55	20	2	29	\N	0	\N	\N	1	1	2	f	29	\N	\N
63	97	20	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
64	14	20	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
65	19	21	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
66	55	22	2	168	\N	0	\N	\N	1	1	2	f	168	\N	\N
67	55	23	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
68	55	23	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
69	39	24	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
70	2	24	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
71	71	24	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
72	40	24	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
73	55	25	2	780	\N	0	\N	\N	1	1	2	f	780	\N	\N
74	97	25	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
75	14	25	2	37	\N	0	\N	\N	0	1	2	f	37	\N	\N
76	2	26	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
77	39	26	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
78	71	26	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
79	40	26	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
80	35	26	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
81	108	26	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
82	55	27	2	385152	\N	0	\N	\N	1	1	2	f	385152	\N	\N
83	68	27	2	96	\N	0	\N	\N	2	1	2	f	96	\N	\N
84	97	27	2	91	\N	0	\N	\N	3	1	2	f	91	\N	\N
85	57	27	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
86	104	27	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
87	55	28	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
88	14	29	2	112	\N	112	\N	\N	1	1	2	f	0	\N	\N
89	54	29	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
90	53	29	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
91	55	29	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
92	90	29	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
93	55	30	2	4499	\N	0	\N	\N	1	1	2	f	4499	\N	\N
94	37	31	2	80378	\N	80378	\N	\N	1	1	2	f	0	\N	\N
95	14	31	2	31941	\N	31941	\N	\N	2	1	2	f	0	\N	\N
96	64	31	2	8368	\N	8368	\N	\N	3	1	2	f	0	\N	\N
97	55	31	2	46	\N	25	\N	\N	4	1	2	f	21	\N	\N
98	23	31	2	1	\N	1	\N	\N	5	1	2	f	0	\N	\N
99	19	31	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
100	57	31	2	140	\N	90	\N	\N	0	1	2	f	50	\N	\N
101	55	32	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
102	55	33	2	1261	\N	0	\N	\N	1	1	2	f	1261	\N	\N
103	55	34	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
104	97	34	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
105	14	34	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
106	55	35	2	10055	\N	0	\N	\N	1	1	2	f	10055	\N	\N
107	68	35	2	15	\N	0	\N	\N	2	1	2	f	15	\N	\N
108	97	35	2	4	\N	0	\N	\N	3	1	2	f	4	\N	\N
109	57	35	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
110	55	36	2	194	\N	0	\N	\N	1	1	2	f	194	\N	\N
111	97	36	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
112	55	37	2	91471	\N	0	\N	\N	1	1	2	f	91471	\N	\N
113	68	37	2	97	\N	0	\N	\N	2	1	2	f	97	\N	\N
114	97	37	2	69	\N	0	\N	\N	3	1	2	f	69	\N	\N
115	57	37	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
116	104	37	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
117	55	38	2	7141	\N	0	\N	\N	1	1	2	f	7141	\N	\N
118	68	38	2	30	\N	0	\N	\N	2	1	2	f	30	\N	\N
119	94	38	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
120	57	38	2	27	\N	0	\N	\N	0	1	2	f	27	\N	\N
121	14	38	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
122	97	38	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
123	104	38	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
124	49	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
125	29	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
126	82	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
127	8	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
128	13	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
129	51	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
130	80	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
131	9	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
132	10	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
133	52	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
134	84	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
135	46	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
136	45	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
137	79	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
138	11	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
139	85	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
140	81	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
141	87	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
142	12	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
143	86	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
144	83	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
145	50	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
146	48	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
147	47	38	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
148	55	39	2	1972	\N	0	\N	\N	1	1	2	f	1972	\N	\N
149	44	40	2	785990	\N	785990	\N	\N	1	1	2	f	0	\N	\N
150	45	40	2	249212	\N	249212	\N	\N	0	1	2	f	0	\N	\N
151	80	40	2	215716	\N	215716	\N	\N	0	1	2	f	0	\N	\N
152	9	40	2	60464	\N	60464	\N	\N	0	1	2	f	0	\N	\N
153	79	40	2	58028	\N	58028	\N	\N	0	1	2	f	0	\N	\N
154	10	40	2	53570	\N	53570	\N	\N	0	1	2	f	0	\N	\N
155	12	40	2	16986	\N	16986	\N	\N	0	1	2	f	0	\N	\N
156	46	40	2	16594	\N	16594	\N	\N	0	1	2	f	0	\N	\N
157	81	40	2	15768	\N	15768	\N	\N	0	1	2	f	0	\N	\N
158	8	40	2	14820	\N	14820	\N	\N	0	1	2	f	0	\N	\N
159	83	40	2	14010	\N	14010	\N	\N	0	1	2	f	0	\N	\N
160	49	40	2	12734	\N	12734	\N	\N	0	1	2	f	0	\N	\N
161	82	40	2	11468	\N	11468	\N	\N	0	1	2	f	0	\N	\N
162	11	40	2	6918	\N	6918	\N	\N	0	1	2	f	0	\N	\N
163	84	40	2	5624	\N	5624	\N	\N	0	1	2	f	0	\N	\N
164	85	40	2	5624	\N	5624	\N	\N	0	1	2	f	0	\N	\N
165	48	40	2	2476	\N	2476	\N	\N	0	1	2	f	0	\N	\N
166	47	40	2	2104	\N	2104	\N	\N	0	1	2	f	0	\N	\N
167	87	40	2	1402	\N	1402	\N	\N	0	1	2	f	0	\N	\N
168	50	40	2	1190	\N	1190	\N	\N	0	1	2	f	0	\N	\N
169	13	40	2	504	\N	504	\N	\N	0	1	2	f	0	\N	\N
170	86	40	2	250	\N	250	\N	\N	0	1	2	f	0	\N	\N
171	52	40	2	222	\N	222	\N	\N	0	1	2	f	0	\N	\N
172	51	40	2	130	\N	130	\N	\N	0	1	2	f	0	\N	\N
173	29	40	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
174	42	40	1	392995	\N	392995	\N	\N	1	1	2	f	\N	\N	\N
175	7	40	1	392995	\N	392995	\N	\N	2	1	2	f	\N	\N	\N
176	106	41	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
177	55	42	2	131	\N	0	\N	\N	1	1	2	f	131	\N	\N
178	97	42	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
179	55	43	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
180	55	44	2	11651	\N	0	\N	\N	1	1	2	f	11651	\N	\N
181	94	44	2	102	\N	102	\N	\N	2	1	2	f	0	\N	\N
182	14	44	2	219	\N	0	\N	\N	0	1	2	f	219	\N	\N
183	57	44	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
184	55	45	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
185	14	45	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
186	39	46	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
187	2	46	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
188	71	46	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
189	40	46	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
190	55	47	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
191	97	47	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
192	55	48	2	21	\N	0	\N	\N	1	1	2	f	21	\N	\N
193	55	49	2	128	\N	0	\N	\N	1	1	2	f	128	\N	\N
194	39	50	2	22	\N	22	\N	\N	1	1	2	f	0	\N	\N
195	106	50	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
196	108	50	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
197	2	50	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
198	71	50	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
199	40	50	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
200	107	50	1	25	\N	25	\N	\N	1	1	2	f	\N	\N	\N
201	55	51	2	4258	\N	4257	\N	\N	1	1	2	f	1	\N	\N
202	68	51	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
203	19	51	1	2133	\N	2133	\N	\N	1	1	2	f	\N	\N	\N
204	55	52	2	195	\N	0	\N	\N	1	1	2	f	195	\N	\N
205	55	53	2	38	\N	0	\N	\N	1	1	2	f	38	\N	\N
206	55	54	2	175	\N	0	\N	\N	1	1	2	f	175	\N	\N
207	97	54	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
208	94	55	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
209	55	56	2	351	\N	0	\N	\N	1	1	2	f	351	\N	\N
210	14	56	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
211	37	57	2	1705576	\N	1705576	\N	\N	1	1	2	f	0	\N	\N
212	1	57	2	800444	\N	800444	\N	\N	2	1	2	f	0	\N	\N
213	88	57	2	736241	\N	736241	\N	\N	3	1	2	f	0	\N	\N
214	77	57	2	638378	\N	638378	\N	\N	4	1	2	f	0	\N	\N
215	44	57	2	389030	\N	389030	\N	\N	5	1	2	f	0	\N	\N
216	89	57	2	65588	\N	65588	\N	\N	6	1	2	f	0	\N	\N
217	76	57	2	52362	\N	52362	\N	\N	7	1	2	f	0	\N	\N
218	91	57	2	29135	\N	29135	\N	\N	8	1	2	f	0	\N	\N
219	64	57	2	10744	\N	10744	\N	\N	9	1	2	f	0	\N	\N
220	103	57	2	6275	\N	6275	\N	\N	10	1	2	f	0	\N	\N
221	66	57	2	1260	\N	1260	\N	\N	11	1	2	f	0	\N	\N
222	65	57	2	326	\N	326	\N	\N	12	1	2	f	0	\N	\N
223	22	57	2	315	\N	315	\N	\N	13	1	2	f	0	\N	\N
224	67	57	2	285	\N	285	\N	\N	14	1	2	f	0	\N	\N
225	31	57	2	223	\N	223	\N	\N	15	1	2	f	0	\N	\N
226	30	57	2	65	\N	65	\N	\N	16	1	2	f	0	\N	\N
227	45	57	2	119290	\N	119290	\N	\N	0	1	2	f	0	\N	\N
228	80	57	2	95452	\N	95452	\N	\N	0	1	2	f	0	\N	\N
229	10	57	2	43024	\N	43024	\N	\N	0	1	2	f	0	\N	\N
230	9	57	2	29794	\N	29794	\N	\N	0	1	2	f	0	\N	\N
231	79	57	2	28412	\N	28412	\N	\N	0	1	2	f	0	\N	\N
232	8	57	2	8588	\N	8588	\N	\N	0	1	2	f	0	\N	\N
233	12	57	2	7888	\N	7888	\N	\N	0	1	2	f	0	\N	\N
234	46	57	2	7722	\N	7722	\N	\N	0	1	2	f	0	\N	\N
235	81	57	2	7676	\N	7676	\N	\N	0	1	2	f	0	\N	\N
236	82	57	2	7122	\N	7122	\N	\N	0	1	2	f	0	\N	\N
237	49	57	2	6230	\N	6230	\N	\N	0	1	2	f	0	\N	\N
238	83	57	2	4830	\N	4830	\N	\N	0	1	2	f	0	\N	\N
239	11	57	2	3286	\N	3286	\N	\N	0	1	2	f	0	\N	\N
240	84	57	2	2404	\N	2404	\N	\N	0	1	2	f	0	\N	\N
241	85	57	2	2404	\N	2404	\N	\N	0	1	2	f	0	\N	\N
242	48	57	2	1950	\N	1950	\N	\N	0	1	2	f	0	\N	\N
243	47	57	2	1068	\N	1068	\N	\N	0	1	2	f	0	\N	\N
244	87	57	2	682	\N	682	\N	\N	0	1	2	f	0	\N	\N
245	50	57	2	414	\N	414	\N	\N	0	1	2	f	0	\N	\N
246	13	57	2	278	\N	278	\N	\N	0	1	2	f	0	\N	\N
247	86	57	2	208	\N	208	\N	\N	0	1	2	f	0	\N	\N
248	51	57	2	104	\N	104	\N	\N	0	1	2	f	0	\N	\N
249	52	57	2	78	\N	78	\N	\N	0	1	2	f	0	\N	\N
250	29	57	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
251	75	57	1	3994855	\N	3994855	\N	\N	1	1	2	f	\N	\N	\N
252	78	57	1	220696	\N	220696	\N	\N	2	1	2	f	\N	\N	\N
253	4	57	1	220696	\N	220696	\N	\N	3	1	2	f	\N	\N	\N
254	55	58	2	3426	\N	3426	\N	\N	1	1	2	f	0	\N	\N
255	55	58	1	2384	\N	2384	\N	\N	1	1	2	f	\N	\N	\N
256	14	58	1	947	\N	947	\N	\N	2	1	2	f	\N	\N	\N
257	68	59	2	350	\N	350	\N	\N	1	1	2	f	0	\N	\N
258	97	59	2	235	\N	235	\N	\N	2	1	2	f	0	\N	\N
259	18	59	2	65	\N	65	\N	\N	3	1	2	f	0	\N	\N
260	59	59	2	11	\N	11	\N	\N	4	1	2	f	0	\N	\N
261	104	59	2	43	\N	43	\N	\N	0	1	2	f	0	\N	\N
262	70	59	2	38	\N	38	\N	\N	0	1	2	f	0	\N	\N
263	69	59	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
264	109	59	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
265	74	59	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
266	57	59	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
267	110	59	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
268	68	59	1	332	\N	332	\N	\N	1	1	2	f	\N	\N	\N
269	97	59	1	274	\N	274	\N	\N	2	1	2	f	\N	\N	\N
270	18	59	1	130	\N	130	\N	\N	3	1	2	f	\N	\N	\N
271	70	59	1	67	\N	67	\N	\N	0	1	2	f	\N	\N	\N
272	104	59	1	57	\N	57	\N	\N	0	1	2	f	\N	\N	\N
273	63	59	1	9	\N	9	\N	\N	0	1	2	f	\N	\N	\N
274	69	59	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
275	110	59	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
276	74	59	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
277	59	59	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
278	57	59	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
279	109	59	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
280	55	60	2	9125	\N	0	\N	\N	1	1	2	f	9125	\N	\N
281	55	61	2	2649	\N	65	\N	\N	1	1	2	f	2584	\N	\N
282	97	61	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
283	55	61	1	65	\N	65	\N	\N	1	1	2	f	\N	\N	\N
284	97	62	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
285	55	62	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
286	55	63	2	8219	\N	0	\N	\N	1	1	2	f	8219	\N	\N
287	97	63	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
288	68	63	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
289	95	64	2	328	\N	0	\N	\N	1	1	2	f	328	\N	\N
290	96	64	1	217062	\N	217062	\N	\N	1	1	2	f	\N	\N	\N
291	55	64	1	43562	\N	43562	\N	\N	2	1	2	f	\N	\N	\N
292	68	64	1	142	\N	142	\N	\N	3	1	2	f	\N	\N	\N
293	14	64	1	97	\N	97	\N	\N	0	1	2	f	\N	\N	\N
294	104	64	1	51	\N	51	\N	\N	0	1	2	f	\N	\N	\N
295	57	64	1	15	\N	15	\N	\N	0	1	2	f	\N	\N	\N
296	97	64	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
297	109	64	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
298	70	64	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
299	98	65	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
300	55	66	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
301	2	67	2	54	\N	50	\N	\N	1	1	2	f	4	\N	\N
302	21	67	2	20	\N	20	\N	\N	2	1	2	f	0	\N	\N
303	39	67	2	54	\N	50	\N	\N	0	1	2	f	4	\N	\N
304	40	67	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
305	71	67	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
306	34	67	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
307	55	68	2	1325	\N	0	\N	\N	1	1	2	f	1325	\N	\N
308	14	68	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
309	98	69	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
310	55	70	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
311	97	71	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
312	55	71	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
313	94	72	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
314	98	73	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
315	97	74	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
316	55	75	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
317	97	75	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
318	55	76	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
319	55	77	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
320	55	78	2	445	\N	0	\N	\N	1	1	2	f	445	\N	\N
321	97	78	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
322	55	79	2	5718	\N	0	\N	\N	1	1	2	f	5718	\N	\N
323	57	79	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
324	80	79	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
325	51	79	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
326	83	79	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
327	50	79	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
328	48	79	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
329	40	80	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
330	39	80	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
331	2	80	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
332	2	81	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
333	39	81	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
334	40	81	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
335	71	81	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
336	53	81	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
337	76	81	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
338	55	81	1	2	\N	2	\N	\N	3	1	2	f	\N	\N	\N
339	3	81	1	1	\N	1	\N	\N	4	1	2	f	\N	\N	\N
340	38	81	1	1	\N	1	\N	\N	5	1	2	f	\N	\N	\N
341	14	81	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
342	57	81	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
343	55	82	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
344	19	83	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
345	93	84	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
346	25	85	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
347	55	86	2	138	\N	0	\N	\N	1	1	2	f	138	\N	\N
348	97	86	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
349	14	86	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
350	55	87	2	4639	\N	0	\N	\N	1	1	2	f	4639	\N	\N
351	55	88	2	269	\N	0	\N	\N	1	1	2	f	269	\N	\N
352	97	88	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
353	94	89	2	12196	\N	12196	\N	\N	1	1	2	f	0	\N	\N
354	97	89	1	8453	\N	8453	\N	\N	1	1	2	f	\N	\N	\N
355	55	90	2	309	\N	0	\N	\N	1	1	2	f	309	\N	\N
356	97	90	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
357	14	90	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
358	55	91	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
359	97	91	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
360	14	91	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
361	19	92	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
362	55	93	2	36	\N	0	\N	\N	1	1	2	f	36	\N	\N
363	68	93	2	32	\N	0	\N	\N	2	1	2	f	32	\N	\N
364	18	93	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
365	104	93	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
366	74	93	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
367	59	93	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
368	70	93	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
369	109	93	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
370	110	93	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
371	57	93	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
372	55	94	2	352	\N	0	\N	\N	1	1	2	f	352	\N	\N
373	55	95	2	2004	\N	0	\N	\N	1	1	2	f	2004	\N	\N
374	97	95	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
375	14	95	2	1510	\N	0	\N	\N	0	1	2	f	1510	\N	\N
376	18	96	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
377	19	96	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
378	96	97	2	30	\N	0	\N	\N	1	1	2	f	30	\N	\N
379	55	98	2	49506	\N	0	\N	\N	1	1	2	f	49506	\N	\N
380	68	98	2	121	\N	0	\N	\N	2	1	2	f	121	\N	\N
381	97	98	2	22	\N	0	\N	\N	3	1	2	f	22	\N	\N
382	57	98	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
383	104	98	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
384	70	98	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
385	18	98	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
386	49	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
387	29	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
388	82	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
389	8	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
390	13	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
391	51	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
392	80	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
393	9	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
394	10	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
395	52	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
396	84	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
397	46	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
398	45	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
399	79	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
400	11	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
401	85	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
402	81	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
403	87	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
404	12	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
405	86	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
406	83	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
407	50	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
408	48	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
409	47	98	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
410	55	99	2	87	\N	0	\N	\N	1	1	2	f	87	\N	\N
411	97	99	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
412	55	100	2	14	\N	0	\N	\N	1	1	2	f	14	\N	\N
413	97	100	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
414	55	101	2	136	\N	0	\N	\N	1	1	2	f	136	\N	\N
415	55	102	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
416	97	102	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
417	60	103	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
418	25	103	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
419	55	104	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
420	70	104	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
421	19	104	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
422	68	104	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
423	104	104	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
424	55	105	2	13019	\N	0	\N	\N	1	1	2	f	13019	\N	\N
425	55	106	2	1779	\N	0	\N	\N	1	1	2	f	1779	\N	\N
426	55	107	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
427	39	108	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
428	2	108	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
429	71	108	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
430	40	108	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
431	98	109	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
432	39	110	2	22	\N	22	\N	\N	1	1	2	f	0	\N	\N
433	2	110	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
434	71	110	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
435	40	110	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
436	55	111	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
437	14	111	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
438	37	112	2	1705576	\N	1705576	\N	\N	1	1	2	f	0	\N	\N
439	1	112	2	800444	\N	800444	\N	\N	2	1	2	f	0	\N	\N
440	38	112	2	797936	\N	797936	\N	\N	3	1	2	f	0	\N	\N
441	88	112	2	736241	\N	736241	\N	\N	4	1	2	f	0	\N	\N
442	77	112	2	638378	\N	638378	\N	\N	5	1	2	f	0	\N	\N
443	44	112	2	194515	\N	194515	\N	\N	6	1	2	f	0	\N	\N
444	89	112	2	65588	\N	65588	\N	\N	7	1	2	f	0	\N	\N
445	14	112	2	30295	\N	30295	\N	\N	8	1	2	f	0	\N	\N
446	91	112	2	29135	\N	29135	\N	\N	9	1	2	f	0	\N	\N
447	76	112	2	26181	\N	26181	\N	\N	10	1	2	f	0	\N	\N
448	5	112	2	26176	\N	26176	\N	\N	11	1	2	f	0	\N	\N
449	3	112	2	17369	\N	17369	\N	\N	12	1	2	f	0	\N	\N
450	64	112	2	10744	\N	10744	\N	\N	13	1	2	f	0	\N	\N
451	103	112	2	6275	\N	6275	\N	\N	14	1	2	f	0	\N	\N
452	55	112	2	5765	\N	5765	\N	\N	15	1	2	f	0	\N	\N
453	66	112	2	1260	\N	1260	\N	\N	16	1	2	f	0	\N	\N
454	65	112	2	326	\N	326	\N	\N	17	1	2	f	0	\N	\N
455	22	112	2	315	\N	315	\N	\N	18	1	2	f	0	\N	\N
456	67	112	2	285	\N	285	\N	\N	19	1	2	f	0	\N	\N
457	31	112	2	223	\N	223	\N	\N	20	1	2	f	0	\N	\N
458	30	112	2	65	\N	65	\N	\N	21	1	2	f	0	\N	\N
459	45	112	2	59645	\N	59645	\N	\N	0	1	2	f	0	\N	\N
460	80	112	2	47726	\N	47726	\N	\N	0	1	2	f	0	\N	\N
461	53	112	2	21838	\N	21838	\N	\N	0	1	2	f	0	\N	\N
462	10	112	2	21512	\N	21512	\N	\N	0	1	2	f	0	\N	\N
463	9	112	2	14897	\N	14897	\N	\N	0	1	2	f	0	\N	\N
464	79	112	2	14206	\N	14206	\N	\N	0	1	2	f	0	\N	\N
465	54	112	2	7493	\N	7493	\N	\N	0	1	2	f	0	\N	\N
466	8	112	2	4294	\N	4294	\N	\N	0	1	2	f	0	\N	\N
467	12	112	2	3944	\N	3944	\N	\N	0	1	2	f	0	\N	\N
468	46	112	2	3861	\N	3861	\N	\N	0	1	2	f	0	\N	\N
469	81	112	2	3838	\N	3838	\N	\N	0	1	2	f	0	\N	\N
470	82	112	2	3561	\N	3561	\N	\N	0	1	2	f	0	\N	\N
471	49	112	2	3115	\N	3115	\N	\N	0	1	2	f	0	\N	\N
472	83	112	2	2415	\N	2415	\N	\N	0	1	2	f	0	\N	\N
473	11	112	2	1643	\N	1643	\N	\N	0	1	2	f	0	\N	\N
474	84	112	2	1202	\N	1202	\N	\N	0	1	2	f	0	\N	\N
475	85	112	2	1202	\N	1202	\N	\N	0	1	2	f	0	\N	\N
476	48	112	2	975	\N	975	\N	\N	0	1	2	f	0	\N	\N
477	90	112	2	962	\N	962	\N	\N	0	1	2	f	0	\N	\N
478	47	112	2	534	\N	534	\N	\N	0	1	2	f	0	\N	\N
479	87	112	2	341	\N	341	\N	\N	0	1	2	f	0	\N	\N
480	50	112	2	207	\N	207	\N	\N	0	1	2	f	0	\N	\N
481	57	112	2	140	\N	140	\N	\N	0	1	2	f	0	\N	\N
482	13	112	2	139	\N	139	\N	\N	0	1	2	f	0	\N	\N
483	86	112	2	104	\N	104	\N	\N	0	1	2	f	0	\N	\N
484	51	112	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
485	52	112	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
486	29	112	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
487	40	112	1	4351224	\N	4351224	\N	\N	1	1	2	f	\N	\N	\N
488	39	112	1	4351174	\N	4351174	\N	\N	0	1	2	f	\N	\N	\N
489	2	112	1	4351174	\N	4351174	\N	\N	0	1	2	f	\N	\N	\N
490	55	113	2	117	\N	0	\N	\N	1	1	2	f	117	\N	\N
491	55	114	2	2199	\N	0	\N	\N	1	1	2	f	2199	\N	\N
492	14	114	2	639	\N	0	\N	\N	0	1	2	f	639	\N	\N
493	60	115	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
494	55	116	2	332	\N	0	\N	\N	1	1	2	f	332	\N	\N
495	55	117	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
496	55	118	2	20	\N	0	\N	\N	1	1	2	f	20	\N	\N
497	14	118	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
498	55	119	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
499	55	120	2	825	\N	0	\N	\N	1	1	2	f	825	\N	\N
500	21	121	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
501	55	122	2	577	\N	0	\N	\N	1	1	2	f	577	\N	\N
502	55	123	2	19	\N	0	\N	\N	1	1	2	f	19	\N	\N
503	14	123	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
504	76	124	2	26181	\N	26181	\N	\N	1	1	2	f	0	\N	\N
505	5	124	1	26181	\N	26181	\N	\N	1	1	2	f	\N	\N	\N
506	75	125	2	1501810	\N	0	\N	\N	1	1	2	f	1501810	\N	\N
507	42	125	2	392995	\N	0	\N	\N	2	1	2	f	392995	\N	\N
508	7	125	2	392995	\N	0	\N	\N	3	1	2	f	392995	\N	\N
509	6	125	2	194515	\N	0	\N	\N	4	1	2	f	194515	\N	\N
510	43	125	2	194515	\N	0	\N	\N	5	1	2	f	194515	\N	\N
511	4	125	2	159167	\N	0	\N	\N	6	1	2	f	159167	\N	\N
512	41	125	2	145877	\N	0	\N	\N	7	1	2	f	145877	\N	\N
513	78	125	2	145147	\N	0	\N	\N	8	1	2	f	145147	\N	\N
514	55	126	2	12283	\N	0	\N	\N	1	1	2	f	12283	\N	\N
515	14	126	2	7637	\N	0	\N	\N	0	1	2	f	7637	\N	\N
516	55	127	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
517	55	128	2	32	\N	0	\N	\N	1	1	2	f	32	\N	\N
518	97	128	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
519	19	129	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
520	55	130	2	86206	\N	86206	\N	\N	1	1	2	f	0	\N	\N
521	19	131	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
522	68	132	2	43	\N	0	\N	\N	1	1	2	f	43	\N	\N
523	97	132	2	14	\N	0	\N	\N	2	1	2	f	14	\N	\N
524	104	132	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
525	18	132	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
526	70	132	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
527	55	133	2	659	\N	659	\N	\N	1	1	2	f	0	\N	\N
528	97	133	1	645	\N	645	\N	\N	1	1	2	f	\N	\N	\N
529	97	134	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
530	55	134	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
531	60	135	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
532	98	136	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
533	55	137	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
534	97	137	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
535	97	138	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
536	55	138	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
537	55	139	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
538	107	140	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
539	44	141	2	194515	\N	194515	\N	\N	1	1	2	f	0	\N	\N
540	45	141	2	59645	\N	59645	\N	\N	0	1	2	f	0	\N	\N
541	80	141	2	47726	\N	47726	\N	\N	0	1	2	f	0	\N	\N
542	10	141	2	21512	\N	21512	\N	\N	0	1	2	f	0	\N	\N
543	9	141	2	14897	\N	14897	\N	\N	0	1	2	f	0	\N	\N
544	79	141	2	14206	\N	14206	\N	\N	0	1	2	f	0	\N	\N
545	8	141	2	4294	\N	4294	\N	\N	0	1	2	f	0	\N	\N
546	12	141	2	3944	\N	3944	\N	\N	0	1	2	f	0	\N	\N
547	46	141	2	3861	\N	3861	\N	\N	0	1	2	f	0	\N	\N
548	81	141	2	3838	\N	3838	\N	\N	0	1	2	f	0	\N	\N
549	82	141	2	3561	\N	3561	\N	\N	0	1	2	f	0	\N	\N
550	49	141	2	3115	\N	3115	\N	\N	0	1	2	f	0	\N	\N
551	83	141	2	2415	\N	2415	\N	\N	0	1	2	f	0	\N	\N
552	11	141	2	1643	\N	1643	\N	\N	0	1	2	f	0	\N	\N
553	84	141	2	1202	\N	1202	\N	\N	0	1	2	f	0	\N	\N
554	85	141	2	1202	\N	1202	\N	\N	0	1	2	f	0	\N	\N
555	48	141	2	975	\N	975	\N	\N	0	1	2	f	0	\N	\N
556	47	141	2	534	\N	534	\N	\N	0	1	2	f	0	\N	\N
557	87	141	2	341	\N	341	\N	\N	0	1	2	f	0	\N	\N
558	50	141	2	207	\N	207	\N	\N	0	1	2	f	0	\N	\N
559	13	141	2	139	\N	139	\N	\N	0	1	2	f	0	\N	\N
560	86	141	2	104	\N	104	\N	\N	0	1	2	f	0	\N	\N
561	51	141	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
562	52	141	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
563	29	141	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
564	43	141	1	194515	\N	194515	\N	\N	1	1	2	f	\N	\N	\N
565	55	142	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
566	44	143	2	333088	\N	333088	\N	\N	1	1	2	f	0	\N	\N
567	45	143	2	108409	\N	108409	\N	\N	0	1	2	f	0	\N	\N
568	80	143	2	93479	\N	93479	\N	\N	0	1	2	f	0	\N	\N
569	10	143	2	46667	\N	46667	\N	\N	0	1	2	f	0	\N	\N
570	9	143	2	32260	\N	32260	\N	\N	0	1	2	f	0	\N	\N
571	8	143	2	9396	\N	9396	\N	\N	0	1	2	f	0	\N	\N
572	82	143	2	7774	\N	7774	\N	\N	0	1	2	f	0	\N	\N
573	12	143	2	7734	\N	7734	\N	\N	0	1	2	f	0	\N	\N
574	46	143	2	7329	\N	7329	\N	\N	0	1	2	f	0	\N	\N
575	83	143	2	3832	\N	3832	\N	\N	0	1	2	f	0	\N	\N
576	11	143	2	3375	\N	3375	\N	\N	0	1	2	f	0	\N	\N
577	84	143	2	2365	\N	2365	\N	\N	0	1	2	f	0	\N	\N
578	85	143	2	2365	\N	2365	\N	\N	0	1	2	f	0	\N	\N
579	48	143	2	2184	\N	2184	\N	\N	0	1	2	f	0	\N	\N
580	79	143	2	2012	\N	2012	\N	\N	0	1	2	f	0	\N	\N
581	47	143	2	1204	\N	1204	\N	\N	0	1	2	f	0	\N	\N
582	81	143	2	704	\N	704	\N	\N	0	1	2	f	0	\N	\N
583	50	143	2	522	\N	522	\N	\N	0	1	2	f	0	\N	\N
584	49	143	2	459	\N	459	\N	\N	0	1	2	f	0	\N	\N
585	13	143	2	313	\N	313	\N	\N	0	1	2	f	0	\N	\N
586	86	143	2	268	\N	268	\N	\N	0	1	2	f	0	\N	\N
587	51	143	2	115	\N	115	\N	\N	0	1	2	f	0	\N	\N
588	52	143	2	89	\N	89	\N	\N	0	1	2	f	0	\N	\N
589	87	143	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
590	29	143	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
591	76	143	1	333088	\N	333088	\N	\N	1	1	2	f	\N	\N	\N
592	55	144	2	16	\N	0	\N	\N	1	1	2	f	16	\N	\N
593	14	144	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
594	2	145	2	16	\N	0	\N	\N	1	1	2	f	16	\N	\N
595	39	145	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
596	34	145	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
597	97	146	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
598	18	146	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
599	55	147	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
600	97	147	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
601	55	148	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
602	94	149	2	756	\N	0	\N	\N	1	1	2	f	756	\N	\N
603	39	150	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
604	40	150	1	24	\N	24	\N	\N	1	1	2	f	\N	\N	\N
605	39	150	1	24	\N	24	\N	\N	0	1	2	f	\N	\N	\N
606	2	150	1	24	\N	24	\N	\N	0	1	2	f	\N	\N	\N
607	55	151	2	121	\N	0	\N	\N	1	1	2	f	121	\N	\N
608	97	151	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
609	39	152	2	36	\N	36	\N	\N	1	1	2	f	0	\N	\N
610	2	152	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
611	40	152	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
612	71	152	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
613	55	152	1	32	\N	32	\N	\N	1	1	2	f	\N	\N	\N
614	19	152	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
615	57	152	1	19	\N	19	\N	\N	0	1	2	f	\N	\N	\N
616	2	153	2	36	\N	36	\N	\N	1	1	2	f	0	\N	\N
617	39	153	2	36	\N	36	\N	\N	0	1	2	f	0	\N	\N
618	40	153	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
619	71	153	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
620	55	154	2	125	\N	0	\N	\N	1	1	2	f	125	\N	\N
621	25	155	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
622	68	156	2	128	\N	128	\N	\N	1	1	2	f	0	\N	\N
623	104	156	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
624	18	156	2	7	\N	7	\N	\N	0	1	2	f	0	\N	\N
625	59	156	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
626	69	156	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
627	74	156	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
628	109	156	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
629	110	156	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
630	70	156	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
631	68	156	1	128	\N	128	\N	\N	1	1	2	f	\N	\N	\N
632	104	156	1	15	\N	15	\N	\N	0	1	2	f	\N	\N	\N
633	69	156	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
634	18	156	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
635	59	156	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
636	109	156	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
637	110	156	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
638	74	156	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
639	70	156	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
640	97	157	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
641	95	158	2	328	\N	328	\N	\N	1	1	2	f	0	\N	\N
642	95	158	1	311	\N	311	\N	\N	1	1	2	f	\N	\N	\N
643	55	159	2	70	\N	0	\N	\N	1	1	2	f	70	\N	\N
644	68	159	2	21	\N	0	\N	\N	2	1	2	f	21	\N	\N
645	97	159	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
646	104	159	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
647	14	159	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
648	55	160	2	12433	\N	0	\N	\N	1	1	2	f	12433	\N	\N
649	97	160	2	7	\N	0	\N	\N	2	1	2	f	7	\N	\N
650	68	160	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
651	14	160	2	2566	\N	0	\N	\N	0	1	2	f	2566	\N	\N
652	69	160	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
653	55	161	2	221	\N	0	\N	\N	1	1	2	f	221	\N	\N
654	14	161	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
655	55	162	2	20	\N	19	\N	\N	1	1	2	f	1	\N	\N
656	97	162	2	5	\N	4	\N	\N	2	1	2	f	1	\N	\N
657	68	162	2	3	\N	3	\N	\N	3	1	2	f	0	\N	\N
658	69	162	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
659	32	162	1	26	\N	26	\N	\N	1	1	2	f	\N	\N	\N
660	33	162	1	19	\N	19	\N	\N	0	1	2	f	\N	\N	\N
661	55	163	2	335	\N	0	\N	\N	1	1	2	f	335	\N	\N
662	55	164	2	50261	\N	0	\N	\N	1	1	2	f	50261	\N	\N
663	68	164	2	128	\N	0	\N	\N	2	1	2	f	128	\N	\N
664	97	164	2	75	\N	0	\N	\N	3	1	2	f	75	\N	\N
665	105	164	2	4	\N	0	\N	\N	4	1	2	f	4	\N	\N
666	14	164	2	3092	\N	0	\N	\N	0	1	2	f	3092	\N	\N
667	57	164	2	65	\N	0	\N	\N	0	1	2	f	65	\N	\N
668	104	164	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
669	70	164	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
670	18	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
671	49	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
672	29	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
673	82	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
674	8	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
675	13	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
676	51	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
677	80	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
678	9	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
679	10	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
680	52	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
681	84	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
682	46	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
683	45	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
684	79	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
685	11	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
686	85	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
687	81	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
688	87	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
689	12	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
690	86	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
691	83	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
692	50	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
693	48	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
694	47	164	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
695	55	165	2	149	\N	0	\N	\N	1	1	2	f	149	\N	\N
696	68	165	2	9	\N	0	\N	\N	2	1	2	f	9	\N	\N
697	105	165	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
698	14	165	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
699	94	166	2	73814	\N	0	\N	\N	1	1	2	f	73814	\N	\N
700	56	166	2	10258	\N	0	\N	\N	2	1	2	f	10258	\N	\N
701	55	167	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
702	55	168	2	66	\N	65	\N	\N	1	1	2	f	1	\N	\N
703	68	168	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
704	55	169	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
705	55	170	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
706	97	170	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
707	55	171	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
708	55	172	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
709	97	172	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
710	55	173	2	4014	\N	0	\N	\N	1	1	2	f	4014	\N	\N
711	55	174	2	68	\N	38	\N	\N	1	1	2	f	30	\N	\N
712	97	174	2	14	\N	8	\N	\N	2	1	2	f	6	\N	\N
713	19	174	2	4	\N	3	\N	\N	3	1	2	f	1	\N	\N
714	60	174	2	3	\N	3	\N	\N	4	1	2	f	0	\N	\N
715	18	174	2	3	\N	2	\N	\N	5	1	2	f	1	\N	\N
716	14	174	2	2	\N	2	\N	\N	6	1	2	f	0	\N	\N
717	23	174	2	1	\N	1	\N	\N	7	1	2	f	0	\N	\N
718	99	174	2	1	\N	1	\N	\N	8	1	2	f	0	\N	\N
719	57	174	2	123	\N	119	\N	\N	0	1	2	f	4	\N	\N
720	55	174	1	57	\N	57	\N	\N	1	1	2	f	\N	\N	\N
721	19	174	1	34	\N	34	\N	\N	2	1	2	f	\N	\N	\N
722	55	175	2	166	\N	0	\N	\N	1	1	2	f	166	\N	\N
723	68	175	2	21	\N	0	\N	\N	2	1	2	f	21	\N	\N
724	104	175	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
725	55	176	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
726	97	176	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
727	3	177	2	8217	\N	8217	\N	\N	1	1	2	f	0	\N	\N
728	14	177	2	102	\N	102	\N	\N	2	1	2	f	0	\N	\N
729	54	177	2	60	\N	60	\N	\N	0	1	2	f	0	\N	\N
730	53	177	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
731	55	177	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
732	90	177	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
733	55	177	1	8217	\N	8217	\N	\N	1	1	2	f	\N	\N	\N
734	57	177	1	8319	\N	8319	\N	\N	0	1	2	f	\N	\N	\N
735	55	178	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
736	97	178	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
737	19	179	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
738	68	180	2	36	\N	36	\N	\N	1	1	2	f	0	\N	\N
739	104	180	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
740	70	180	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
741	109	180	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
742	55	181	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
743	97	181	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
744	55	182	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
745	97	182	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
746	55	183	2	390	\N	390	\N	\N	1	1	2	f	0	\N	\N
747	14	183	2	23	\N	23	\N	\N	0	1	2	f	0	\N	\N
748	57	183	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
749	55	183	1	388	\N	388	\N	\N	1	1	2	f	\N	\N	\N
750	57	183	1	22	\N	22	\N	\N	0	1	2	f	\N	\N	\N
751	14	183	1	19	\N	19	\N	\N	0	1	2	f	\N	\N	\N
752	97	183	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
753	58	184	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
754	55	185	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
755	97	185	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
756	55	186	2	39	\N	0	\N	\N	1	1	2	f	39	\N	\N
757	97	186	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
758	55	187	2	2233	\N	2233	\N	\N	1	1	2	f	0	\N	\N
759	55	188	2	261	\N	0	\N	\N	1	1	2	f	261	\N	\N
760	19	189	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
761	55	190	2	7359	\N	0	\N	\N	1	1	2	f	7359	\N	\N
762	97	190	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
763	14	190	2	587	\N	0	\N	\N	0	1	2	f	587	\N	\N
764	57	190	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
765	55	191	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
766	97	191	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
767	55	192	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
768	55	193	2	217	\N	0	\N	\N	1	1	2	f	217	\N	\N
769	97	193	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
770	55	194	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
771	97	194	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
772	44	195	2	194515	\N	194515	\N	\N	1	1	2	f	0	\N	\N
773	45	195	2	59645	\N	59645	\N	\N	0	1	2	f	0	\N	\N
774	80	195	2	47726	\N	47726	\N	\N	0	1	2	f	0	\N	\N
775	10	195	2	21512	\N	21512	\N	\N	0	1	2	f	0	\N	\N
776	9	195	2	14897	\N	14897	\N	\N	0	1	2	f	0	\N	\N
777	79	195	2	14206	\N	14206	\N	\N	0	1	2	f	0	\N	\N
778	8	195	2	4294	\N	4294	\N	\N	0	1	2	f	0	\N	\N
779	12	195	2	3944	\N	3944	\N	\N	0	1	2	f	0	\N	\N
780	46	195	2	3861	\N	3861	\N	\N	0	1	2	f	0	\N	\N
781	81	195	2	3838	\N	3838	\N	\N	0	1	2	f	0	\N	\N
782	82	195	2	3561	\N	3561	\N	\N	0	1	2	f	0	\N	\N
783	49	195	2	3115	\N	3115	\N	\N	0	1	2	f	0	\N	\N
784	83	195	2	2415	\N	2415	\N	\N	0	1	2	f	0	\N	\N
785	11	195	2	1643	\N	1643	\N	\N	0	1	2	f	0	\N	\N
786	84	195	2	1202	\N	1202	\N	\N	0	1	2	f	0	\N	\N
787	85	195	2	1202	\N	1202	\N	\N	0	1	2	f	0	\N	\N
788	48	195	2	975	\N	975	\N	\N	0	1	2	f	0	\N	\N
789	47	195	2	534	\N	534	\N	\N	0	1	2	f	0	\N	\N
790	87	195	2	341	\N	341	\N	\N	0	1	2	f	0	\N	\N
791	50	195	2	207	\N	207	\N	\N	0	1	2	f	0	\N	\N
792	13	195	2	139	\N	139	\N	\N	0	1	2	f	0	\N	\N
793	86	195	2	104	\N	104	\N	\N	0	1	2	f	0	\N	\N
794	51	195	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
795	52	195	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
796	29	195	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
797	6	195	1	194515	\N	194515	\N	\N	1	1	2	f	\N	\N	\N
798	60	196	2	738	\N	0	\N	\N	1	1	2	f	738	\N	\N
799	60	197	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
800	99	197	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
801	98	198	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
802	55	199	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
803	55	200	2	25557	\N	0	\N	\N	1	1	2	f	25557	\N	\N
804	68	200	2	88	\N	0	\N	\N	2	1	2	f	88	\N	\N
805	97	200	2	21	\N	0	\N	\N	3	1	2	f	21	\N	\N
806	57	200	2	48	\N	0	\N	\N	0	1	2	f	48	\N	\N
807	104	200	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
808	70	200	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
809	18	200	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
810	49	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
811	29	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
812	82	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
813	8	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
814	13	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
815	51	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
816	80	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
817	9	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
818	10	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
819	52	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
820	84	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
821	46	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
822	45	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
823	79	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
824	11	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
825	85	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
826	81	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
827	87	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
828	12	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
829	86	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
830	83	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
831	50	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
832	48	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
833	47	200	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
834	55	201	2	286	\N	0	\N	\N	1	1	2	f	286	\N	\N
835	97	201	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
836	55	202	2	1163	\N	1162	\N	\N	1	1	2	f	1	\N	\N
837	23	203	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
838	97	204	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
839	55	204	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
840	2	205	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
841	39	205	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
842	40	205	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
843	71	205	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
844	55	206	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
845	14	206	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
846	40	207	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
847	39	207	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
848	2	207	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
849	97	208	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
850	55	208	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
851	55	209	2	71	\N	0	\N	\N	1	1	2	f	71	\N	\N
852	58	210	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
853	60	211	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
854	24	211	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
855	100	211	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
856	57	211	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
857	71	212	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
858	39	212	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
859	2	212	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
860	55	212	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
861	57	212	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
862	94	213	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
863	55	214	2	1587	\N	29	\N	\N	1	1	2	f	1558	\N	\N
864	19	214	2	28	\N	0	\N	\N	2	1	2	f	28	\N	\N
865	57	214	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
866	14	214	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
867	55	215	2	5208	\N	0	\N	\N	1	1	2	f	5208	\N	\N
868	97	215	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
869	14	215	2	1600	\N	0	\N	\N	0	1	2	f	1600	\N	\N
870	57	215	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
871	38	216	2	797936	\N	0	\N	\N	1	1	2	f	797936	\N	\N
872	39	216	2	20	\N	0	\N	\N	2	1	2	f	20	\N	\N
873	106	216	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
874	19	216	2	1	\N	0	\N	\N	4	1	2	f	1	\N	\N
875	2	216	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
876	71	216	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
877	40	216	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
878	37	217	2	1529048	\N	0	\N	\N	1	1	2	f	1529048	\N	\N
879	1	217	2	790858	\N	0	\N	\N	2	1	2	f	790858	\N	\N
880	88	217	2	646577	\N	0	\N	\N	3	1	2	f	646577	\N	\N
881	77	217	2	638378	\N	0	\N	\N	4	1	2	f	638378	\N	\N
882	89	217	2	50977	\N	0	\N	\N	5	1	2	f	50977	\N	\N
883	91	217	2	28738	\N	0	\N	\N	6	1	2	f	28738	\N	\N
884	64	217	2	10743	\N	0	\N	\N	7	1	2	f	10743	\N	\N
885	103	217	2	5787	\N	0	\N	\N	8	1	2	f	5787	\N	\N
886	55	217	2	1378	\N	0	\N	\N	9	1	2	f	1378	\N	\N
887	66	217	2	779	\N	0	\N	\N	10	1	2	f	779	\N	\N
888	65	217	2	326	\N	0	\N	\N	11	1	2	f	326	\N	\N
889	67	217	2	270	\N	0	\N	\N	12	1	2	f	270	\N	\N
890	22	217	2	258	\N	0	\N	\N	13	1	2	f	258	\N	\N
891	68	217	2	171	\N	0	\N	\N	14	1	2	f	171	\N	\N
892	31	217	2	155	\N	0	\N	\N	15	1	2	f	155	\N	\N
893	39	217	2	151	\N	0	\N	\N	16	1	2	f	151	\N	\N
894	30	217	2	62	\N	0	\N	\N	17	1	2	f	62	\N	\N
895	34	217	2	26	\N	0	\N	\N	18	1	2	f	26	\N	\N
896	18	217	2	13	\N	0	\N	\N	19	1	2	f	13	\N	\N
897	35	217	2	3	\N	0	\N	\N	20	1	2	f	3	\N	\N
898	106	217	2	2	\N	0	\N	\N	21	1	2	f	2	\N	\N
899	19	217	2	2	\N	0	\N	\N	22	1	2	f	2	\N	\N
900	108	217	2	1	\N	0	\N	\N	23	1	2	f	1	\N	\N
901	2	217	2	145	\N	0	\N	\N	0	1	2	f	145	\N	\N
902	71	217	2	60	\N	0	\N	\N	0	1	2	f	60	\N	\N
903	40	217	2	36	\N	0	\N	\N	0	1	2	f	36	\N	\N
904	70	217	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
905	104	217	2	25	\N	0	\N	\N	0	1	2	f	25	\N	\N
906	57	217	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
907	69	217	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
908	59	217	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
909	109	217	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
910	74	217	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
911	110	217	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
912	105	217	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
913	19	218	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
914	55	219	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
915	55	220	2	431	\N	0	\N	\N	1	1	2	f	431	\N	\N
916	97	220	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
917	21	221	2	20	\N	0	\N	\N	1	1	2	f	20	\N	\N
918	94	222	2	985111	\N	985111	\N	\N	1	1	2	f	0	\N	\N
919	56	222	2	10999	\N	10999	\N	\N	2	1	2	f	0	\N	\N
920	55	222	1	984618	\N	984618	\N	\N	1	1	2	f	\N	\N	\N
921	94	222	1	10999	\N	10999	\N	\N	2	1	2	f	\N	\N	\N
922	68	222	1	259	\N	259	\N	\N	3	1	2	f	\N	\N	\N
923	97	222	1	181	\N	181	\N	\N	4	1	2	f	\N	\N	\N
924	96	222	1	1	\N	1	\N	\N	5	1	2	f	\N	\N	\N
925	14	222	1	12744	\N	12744	\N	\N	0	1	2	f	\N	\N	\N
926	57	222	1	306	\N	306	\N	\N	0	1	2	f	\N	\N	\N
927	10	222	1	15	\N	15	\N	\N	0	1	2	f	\N	\N	\N
928	80	222	1	14	\N	14	\N	\N	0	1	2	f	\N	\N	\N
929	9	222	1	14	\N	14	\N	\N	0	1	2	f	\N	\N	\N
930	83	222	1	14	\N	14	\N	\N	0	1	2	f	\N	\N	\N
931	13	222	1	12	\N	12	\N	\N	0	1	2	f	\N	\N	\N
932	84	222	1	11	\N	11	\N	\N	0	1	2	f	\N	\N	\N
933	46	222	1	11	\N	11	\N	\N	0	1	2	f	\N	\N	\N
934	45	222	1	11	\N	11	\N	\N	0	1	2	f	\N	\N	\N
935	104	222	1	10	\N	10	\N	\N	0	1	2	f	\N	\N	\N
936	11	222	1	9	\N	9	\N	\N	0	1	2	f	\N	\N	\N
937	51	222	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
938	79	222	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
939	12	222	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
940	29	222	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
941	82	222	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
942	8	222	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
943	50	222	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
944	48	222	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
945	49	222	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
946	85	222	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
947	81	222	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
948	52	222	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
949	47	222	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
950	87	222	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
951	86	222	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
952	55	223	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
953	97	223	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
954	55	224	2	19	\N	0	\N	\N	1	1	2	f	19	\N	\N
955	55	225	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
956	55	226	2	16719	\N	16719	\N	\N	1	1	2	f	0	\N	\N
957	68	226	2	10	\N	10	\N	\N	2	1	2	f	0	\N	\N
958	57	226	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
959	70	226	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
960	104	226	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
961	69	226	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
962	97	226	1	15120	\N	15120	\N	\N	1	1	2	f	\N	\N	\N
963	2	227	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
964	39	227	2	26	\N	26	\N	\N	0	1	2	f	0	\N	\N
965	40	227	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
966	71	227	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
967	55	228	2	200	\N	0	\N	\N	1	1	2	f	200	\N	\N
968	97	228	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
969	55	229	2	817	\N	0	\N	\N	1	1	2	f	817	\N	\N
970	18	230	2	169	\N	169	\N	\N	1	1	2	f	0	\N	\N
971	68	230	2	132	\N	132	\N	\N	2	1	2	f	0	\N	\N
972	97	230	2	100	\N	100	\N	\N	3	1	2	f	0	\N	\N
973	105	230	2	2	\N	2	\N	\N	4	1	2	f	0	\N	\N
974	104	230	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
975	59	230	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
976	20	230	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
977	69	230	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
978	70	230	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
979	55	230	1	134	\N	134	\N	\N	1	1	2	f	\N	\N	\N
980	16	230	1	20	\N	20	\N	\N	2	1	2	f	\N	\N	\N
981	101	230	1	2	\N	2	\N	\N	3	1	2	f	\N	\N	\N
982	100	230	1	1	\N	1	\N	\N	4	1	2	f	\N	\N	\N
983	57	230	1	62	\N	62	\N	\N	0	1	2	f	\N	\N	\N
984	14	230	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
985	55	231	2	17860	\N	0	\N	\N	1	1	2	f	17860	\N	\N
986	19	232	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
987	55	233	2	9230	\N	0	\N	\N	1	1	2	f	9230	\N	\N
988	2	234	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
989	39	234	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
990	34	234	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
991	55	234	1	13	\N	13	\N	\N	1	1	2	f	\N	\N	\N
992	97	234	1	11	\N	11	\N	\N	0	1	2	f	\N	\N	\N
993	55	235	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
994	97	235	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
995	55	236	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
996	97	236	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
997	55	237	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
998	97	237	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
999	55	238	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
1000	55	239	2	7402	\N	0	\N	\N	1	1	2	f	7402	\N	\N
1001	68	239	2	30	\N	0	\N	\N	2	1	2	f	30	\N	\N
1002	94	239	2	11	\N	0	\N	\N	3	1	2	f	11	\N	\N
1003	57	239	2	29	\N	0	\N	\N	0	1	2	f	29	\N	\N
1004	14	239	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
1005	97	239	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1006	104	239	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1007	49	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1008	29	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1009	82	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1010	8	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1011	13	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1012	51	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1013	80	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1014	9	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1015	10	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1016	52	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1017	84	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1018	46	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1019	45	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1020	79	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1021	11	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1022	85	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1023	81	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1024	87	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1025	12	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1026	86	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1027	83	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1028	50	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1029	48	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1030	47	239	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1031	55	241	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1032	39	242	2	56	\N	56	\N	\N	1	1	2	f	0	\N	\N
1033	21	242	2	19	\N	19	\N	\N	2	1	2	f	0	\N	\N
1034	2	242	2	54	\N	54	\N	\N	0	1	2	f	0	\N	\N
1035	40	242	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
1036	71	242	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1037	34	242	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1038	34	242	1	58	\N	58	\N	\N	1	1	2	f	\N	\N	\N
1039	39	242	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1040	2	242	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1041	55	243	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
1042	97	243	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1043	39	244	2	18	\N	0	\N	\N	1	1	2	f	18	\N	\N
1044	2	244	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
1045	71	244	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1046	40	244	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1047	55	245	2	2579	\N	0	\N	\N	1	1	2	f	2579	\N	\N
1048	97	245	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1049	55	246	2	110	\N	0	\N	\N	1	1	2	f	110	\N	\N
1050	97	246	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1051	55	247	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1052	97	247	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1053	55	248	2	125288	\N	125288	\N	\N	1	1	2	f	0	\N	\N
1054	57	248	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1055	55	248	1	125288	\N	125288	\N	\N	1	1	2	f	\N	\N	\N
1056	55	249	2	463	\N	463	\N	\N	1	1	2	f	0	\N	\N
1057	55	249	1	463	\N	463	\N	\N	1	1	2	f	\N	\N	\N
1058	57	249	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1059	55	250	2	1805	\N	1805	\N	\N	1	1	2	f	0	\N	\N
1060	55	250	1	1805	\N	1805	\N	\N	1	1	2	f	\N	\N	\N
1061	55	251	2	1211	\N	0	\N	\N	1	1	2	f	1211	\N	\N
1062	97	251	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1063	55	252	2	1809	\N	1809	\N	\N	1	1	2	f	0	\N	\N
1064	55	252	1	1809	\N	1809	\N	\N	1	1	2	f	\N	\N	\N
1065	55	253	2	23	\N	23	\N	\N	1	1	2	f	0	\N	\N
1066	55	253	1	23	\N	23	\N	\N	1	1	2	f	\N	\N	\N
1067	37	254	2	1705576	\N	1705576	\N	\N	1	1	2	f	0	\N	\N
1068	75	254	2	1501810	\N	1501810	\N	\N	2	1	2	f	0	\N	\N
1069	94	254	2	985111	\N	985111	\N	\N	3	1	2	f	0	\N	\N
1070	1	254	2	800444	\N	800444	\N	\N	4	1	2	f	0	\N	\N
1071	38	254	2	797936	\N	797936	\N	\N	5	1	2	f	0	\N	\N
1072	88	254	2	736241	\N	736241	\N	\N	6	1	2	f	0	\N	\N
1073	77	254	2	638378	\N	638378	\N	\N	7	1	2	f	0	\N	\N
1074	96	254	2	421281	\N	421281	\N	\N	8	1	2	f	0	\N	\N
1075	42	254	2	392995	\N	392995	\N	\N	9	1	2	f	0	\N	\N
1076	7	254	2	392995	\N	392995	\N	\N	10	1	2	f	0	\N	\N
1077	41	254	2	392995	\N	392995	\N	\N	11	1	2	f	0	\N	\N
1078	44	254	2	383968	\N	383968	\N	\N	12	1	2	f	0	\N	\N
1079	55	254	2	375692	\N	375692	\N	\N	13	1	2	f	0	\N	\N
1080	78	254	2	220696	\N	220696	\N	\N	14	1	2	f	0	\N	\N
1081	4	254	2	220696	\N	220696	\N	\N	15	1	2	f	0	\N	\N
1082	6	254	2	194515	\N	194515	\N	\N	16	1	2	f	0	\N	\N
1083	43	254	2	194515	\N	194515	\N	\N	17	1	2	f	0	\N	\N
1084	76	254	2	130895	\N	130895	\N	\N	18	1	2	f	0	\N	\N
1085	14	254	2	117586	\N	117586	\N	\N	19	1	2	f	0	\N	\N
1086	89	254	2	65588	\N	65588	\N	\N	20	1	2	f	0	\N	\N
1087	91	254	2	29135	\N	29135	\N	\N	21	1	2	f	0	\N	\N
1088	5	254	2	26176	\N	26176	\N	\N	22	1	2	f	0	\N	\N
1089	3	254	2	17369	\N	17369	\N	\N	23	1	2	f	0	\N	\N
1090	64	254	2	10744	\N	10744	\N	\N	24	1	2	f	0	\N	\N
1091	56	254	2	10258	\N	10258	\N	\N	25	1	2	f	0	\N	\N
1092	103	254	2	6275	\N	6275	\N	\N	26	1	2	f	0	\N	\N
1093	66	254	2	1260	\N	1260	\N	\N	27	1	2	f	0	\N	\N
1094	68	254	2	742	\N	742	\N	\N	28	1	2	f	0	\N	\N
1095	97	254	2	542	\N	542	\N	\N	29	1	2	f	0	\N	\N
1096	95	254	2	328	\N	328	\N	\N	30	1	2	f	0	\N	\N
1097	65	254	2	326	\N	326	\N	\N	31	1	2	f	0	\N	\N
1098	22	254	2	315	\N	315	\N	\N	32	1	2	f	0	\N	\N
1099	18	254	2	312	\N	312	\N	\N	33	1	2	f	0	\N	\N
1100	67	254	2	285	\N	285	\N	\N	34	1	2	f	0	\N	\N
1101	31	254	2	223	\N	223	\N	\N	35	1	2	f	0	\N	\N
1102	39	254	2	140	\N	140	\N	\N	36	1	2	f	0	\N	\N
1103	30	254	2	65	\N	65	\N	\N	37	1	2	f	0	\N	\N
1104	40	254	2	50	\N	50	\N	\N	38	1	2	f	0	\N	\N
1105	16	254	2	40	\N	40	\N	\N	39	1	2	f	0	\N	\N
1106	17	254	2	35	\N	35	\N	\N	40	1	2	f	0	\N	\N
1107	34	254	2	27	\N	27	\N	\N	41	1	2	f	0	\N	\N
1108	59	254	2	21	\N	21	\N	\N	42	1	2	f	0	\N	\N
1109	63	254	2	5	\N	5	\N	\N	42	1	2	f	0	\N	\N
1110	21	254	2	20	\N	20	\N	\N	43	1	2	f	0	\N	\N
1111	19	254	2	16	\N	16	\N	\N	44	1	2	f	0	\N	\N
1112	105	254	2	12	\N	12	\N	\N	45	1	2	f	0	\N	\N
1113	32	254	2	7	\N	7	\N	\N	46	1	2	f	0	\N	\N
1114	107	254	2	7	\N	7	\N	\N	47	1	2	f	0	\N	\N
1115	61	254	2	6	\N	6	\N	\N	48	1	2	f	0	\N	\N
1116	92	254	2	4	\N	4	\N	\N	50	1	2	f	0	\N	\N
1117	60	254	2	3	\N	3	\N	\N	51	1	2	f	0	\N	\N
1118	25	254	2	3	\N	3	\N	\N	52	1	2	f	0	\N	\N
1119	35	254	2	3	\N	3	\N	\N	53	1	2	f	0	\N	\N
1120	24	254	2	2	\N	2	\N	\N	54	1	2	f	0	\N	\N
1121	100	254	2	2	\N	2	\N	\N	55	1	2	f	0	\N	\N
1122	101	254	2	2	\N	2	\N	\N	56	1	2	f	0	\N	\N
1123	58	254	2	2	\N	2	\N	\N	57	1	2	f	0	\N	\N
1124	106	254	2	2	\N	2	\N	\N	58	1	2	f	0	\N	\N
1125	93	254	2	2	\N	2	\N	\N	59	1	2	f	0	\N	\N
1126	98	254	2	1	\N	1	\N	\N	60	1	2	f	0	\N	\N
1127	23	254	2	1	\N	1	\N	\N	61	1	2	f	0	\N	\N
1128	99	254	2	1	\N	1	\N	\N	62	1	2	f	0	\N	\N
1129	62	254	2	1	\N	1	\N	\N	63	1	2	f	0	\N	\N
1130	28	254	2	1	\N	1	\N	\N	64	1	2	f	0	\N	\N
1131	108	254	2	1	\N	1	\N	\N	65	1	2	f	0	\N	\N
1132	36	254	2	1	\N	1	\N	\N	66	1	2	f	0	\N	\N
1133	72	254	2	1	\N	1	\N	\N	67	1	2	f	0	\N	\N
1134	73	254	2	1	\N	1	\N	\N	68	1	2	f	0	\N	\N
1135	45	254	2	119293	\N	119293	\N	\N	0	1	2	f	0	\N	\N
1136	80	254	2	95455	\N	95455	\N	\N	0	1	2	f	0	\N	\N
1137	53	254	2	49119	\N	49119	\N	\N	0	1	2	f	0	\N	\N
1138	10	254	2	43027	\N	43027	\N	\N	0	1	2	f	0	\N	\N
1139	9	254	2	29797	\N	29797	\N	\N	0	1	2	f	0	\N	\N
1140	79	254	2	28415	\N	28415	\N	\N	0	1	2	f	0	\N	\N
1141	54	254	2	15058	\N	15058	\N	\N	0	1	2	f	0	\N	\N
1142	8	254	2	8591	\N	8591	\N	\N	0	1	2	f	0	\N	\N
1143	12	254	2	7891	\N	7891	\N	\N	0	1	2	f	0	\N	\N
1144	46	254	2	7725	\N	7725	\N	\N	0	1	2	f	0	\N	\N
1145	81	254	2	7679	\N	7679	\N	\N	0	1	2	f	0	\N	\N
1146	82	254	2	7125	\N	7125	\N	\N	0	1	2	f	0	\N	\N
1147	49	254	2	6233	\N	6233	\N	\N	0	1	2	f	0	\N	\N
1148	83	254	2	4833	\N	4833	\N	\N	0	1	2	f	0	\N	\N
1149	84	254	2	3609	\N	3609	\N	\N	0	1	2	f	0	\N	\N
1150	85	254	2	3609	\N	3609	\N	\N	0	1	2	f	0	\N	\N
1151	11	254	2	3289	\N	3289	\N	\N	0	1	2	f	0	\N	\N
1152	90	254	2	2128	\N	2128	\N	\N	0	1	2	f	0	\N	\N
1153	48	254	2	1953	\N	1953	\N	\N	0	1	2	f	0	\N	\N
1154	47	254	2	1071	\N	1071	\N	\N	0	1	2	f	0	\N	\N
1155	87	254	2	685	\N	685	\N	\N	0	1	2	f	0	\N	\N
1156	50	254	2	417	\N	417	\N	\N	0	1	2	f	0	\N	\N
1157	57	254	2	404	\N	404	\N	\N	0	1	2	f	0	\N	\N
1158	13	254	2	281	\N	281	\N	\N	0	1	2	f	0	\N	\N
1159	86	254	2	211	\N	211	\N	\N	0	1	2	f	0	\N	\N
1160	2	254	2	138	\N	138	\N	\N	0	1	2	f	0	\N	\N
1161	104	254	2	125	\N	125	\N	\N	0	1	2	f	0	\N	\N
1162	51	254	2	107	\N	107	\N	\N	0	1	2	f	0	\N	\N
1163	70	254	2	89	\N	89	\N	\N	0	1	2	f	0	\N	\N
1164	52	254	2	81	\N	81	\N	\N	0	1	2	f	0	\N	\N
1165	69	254	2	31	\N	31	\N	\N	0	1	2	f	0	\N	\N
1166	71	254	2	30	\N	30	\N	\N	0	1	2	f	0	\N	\N
1167	109	254	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1168	20	254	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1169	74	254	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1170	110	254	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1171	29	254	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
1172	33	254	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1173	15	254	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1174	102	254	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1175	26	254	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1176	27	254	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1177	55	254	1	8776980	\N	8776980	\N	\N	1	1	2	f	\N	\N	\N
1178	57	254	1	9755805	\N	9755805	\N	\N	0	1	2	f	\N	\N	\N
1179	18	254	1	194515	\N	194515	\N	\N	0	1	2	f	\N	\N	\N
1180	45	254	1	59646	\N	59646	\N	\N	0	1	2	f	\N	\N	\N
1181	80	254	1	47727	\N	47727	\N	\N	0	1	2	f	\N	\N	\N
1182	10	254	1	21513	\N	21513	\N	\N	0	1	2	f	\N	\N	\N
1183	9	254	1	14898	\N	14898	\N	\N	0	1	2	f	\N	\N	\N
1184	79	254	1	14207	\N	14207	\N	\N	0	1	2	f	\N	\N	\N
1185	8	254	1	4295	\N	4295	\N	\N	0	1	2	f	\N	\N	\N
1186	12	254	1	3945	\N	3945	\N	\N	0	1	2	f	\N	\N	\N
1187	46	254	1	3862	\N	3862	\N	\N	0	1	2	f	\N	\N	\N
1188	81	254	1	3839	\N	3839	\N	\N	0	1	2	f	\N	\N	\N
1189	82	254	1	3562	\N	3562	\N	\N	0	1	2	f	\N	\N	\N
1190	49	254	1	3116	\N	3116	\N	\N	0	1	2	f	\N	\N	\N
1191	83	254	1	2416	\N	2416	\N	\N	0	1	2	f	\N	\N	\N
1192	11	254	1	1644	\N	1644	\N	\N	0	1	2	f	\N	\N	\N
1193	84	254	1	1203	\N	1203	\N	\N	0	1	2	f	\N	\N	\N
1194	85	254	1	1203	\N	1203	\N	\N	0	1	2	f	\N	\N	\N
1195	48	254	1	976	\N	976	\N	\N	0	1	2	f	\N	\N	\N
1196	47	254	1	535	\N	535	\N	\N	0	1	2	f	\N	\N	\N
1197	87	254	1	342	\N	342	\N	\N	0	1	2	f	\N	\N	\N
1198	50	254	1	208	\N	208	\N	\N	0	1	2	f	\N	\N	\N
1199	13	254	1	140	\N	140	\N	\N	0	1	2	f	\N	\N	\N
1200	86	254	1	105	\N	105	\N	\N	0	1	2	f	\N	\N	\N
1201	51	254	1	53	\N	53	\N	\N	0	1	2	f	\N	\N	\N
1202	52	254	1	40	\N	40	\N	\N	0	1	2	f	\N	\N	\N
1203	29	254	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1204	97	254	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1205	55	255	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
1206	97	255	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1207	55	256	2	3970	\N	0	\N	\N	1	1	2	f	3970	\N	\N
1208	97	256	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1209	14	256	2	1571	\N	0	\N	\N	0	1	2	f	1571	\N	\N
1210	55	257	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1211	55	257	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1212	55	258	2	121	\N	0	\N	\N	1	1	2	f	121	\N	\N
1213	14	258	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
1214	55	259	2	11	\N	11	\N	\N	1	1	2	f	0	\N	\N
1215	55	259	1	11	\N	11	\N	\N	1	1	2	f	\N	\N	\N
1216	55	261	2	97	\N	97	\N	\N	1	1	2	f	0	\N	\N
1217	55	261	1	97	\N	97	\N	\N	1	1	2	f	\N	\N	\N
1218	57	261	1	16	\N	16	\N	\N	0	1	2	f	\N	\N	\N
1219	19	262	2	31	\N	31	\N	\N	1	1	2	f	0	\N	\N
1220	55	263	2	205723	\N	165	\N	\N	1	1	2	f	205558	\N	\N
1221	94	263	2	166419	\N	22	\N	\N	2	1	2	f	166397	\N	\N
1222	68	263	2	46	\N	0	\N	\N	3	1	2	f	46	\N	\N
1223	97	263	2	14	\N	1	\N	\N	4	1	2	f	13	\N	\N
1224	57	263	2	128	\N	0	\N	\N	0	1	2	f	128	\N	\N
1225	80	263	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1226	83	263	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1227	104	263	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1228	9	263	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1229	10	263	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1230	13	263	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1231	51	263	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1232	82	263	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1233	8	263	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1234	84	263	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1235	46	263	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1236	45	263	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1237	79	263	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1238	50	263	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1239	48	263	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1240	18	263	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1241	14	263	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1242	49	263	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1243	29	263	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1244	52	263	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1245	11	263	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1246	85	263	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1247	81	263	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1248	47	263	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1249	70	263	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1250	87	263	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1251	12	263	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1252	86	263	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1253	97	263	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1254	55	264	2	97	\N	97	\N	\N	1	1	2	f	0	\N	\N
1255	55	264	1	97	\N	97	\N	\N	1	1	2	f	\N	\N	\N
1256	57	264	1	44	\N	44	\N	\N	0	1	2	f	\N	\N	\N
1257	37	265	2	1529050	\N	0	\N	\N	1	1	2	f	1529050	\N	\N
1258	1	265	2	790858	\N	0	\N	\N	2	1	2	f	790858	\N	\N
1259	88	265	2	646577	\N	0	\N	\N	3	1	2	f	646577	\N	\N
1260	77	265	2	638378	\N	0	\N	\N	4	1	2	f	638378	\N	\N
1261	89	265	2	50977	\N	0	\N	\N	5	1	2	f	50977	\N	\N
1262	91	265	2	28738	\N	0	\N	\N	6	1	2	f	28738	\N	\N
1263	64	265	2	10744	\N	0	\N	\N	7	1	2	f	10744	\N	\N
1264	103	265	2	5787	\N	0	\N	\N	8	1	2	f	5787	\N	\N
1265	66	265	2	779	\N	0	\N	\N	9	1	2	f	779	\N	\N
1266	65	265	2	326	\N	0	\N	\N	10	1	2	f	326	\N	\N
1267	67	265	2	270	\N	0	\N	\N	11	1	2	f	270	\N	\N
1268	22	265	2	258	\N	0	\N	\N	12	1	2	f	258	\N	\N
1269	31	265	2	155	\N	0	\N	\N	13	1	2	f	155	\N	\N
1270	30	265	2	62	\N	0	\N	\N	14	1	2	f	62	\N	\N
1271	71	266	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
1272	39	266	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1273	2	266	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1274	55	266	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
1275	57	266	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
1276	97	267	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1277	55	267	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1278	98	268	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1279	55	269	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
1280	97	269	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1281	94	270	2	985111	\N	985111	\N	\N	1	1	2	f	0	\N	\N
1282	56	270	2	10258	\N	10258	\N	\N	2	1	2	f	0	\N	\N
1283	97	270	1	903277	\N	903277	\N	\N	1	1	2	f	\N	\N	\N
1284	18	270	1	100548	\N	100548	\N	\N	2	1	2	f	\N	\N	\N
1285	55	270	1	10258	\N	10258	\N	\N	0	1	2	f	\N	\N	\N
1286	76	271	2	17665	\N	17665	\N	\N	1	1	2	f	0	\N	\N
1287	3	271	1	17665	\N	17665	\N	\N	1	1	2	f	\N	\N	\N
1288	97	272	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1289	55	272	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1290	55	273	2	57	\N	0	\N	\N	1	1	2	f	57	\N	\N
1291	97	273	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1292	55	274	2	3727	\N	0	\N	\N	1	1	2	f	3727	\N	\N
1293	55	275	2	43	\N	0	\N	\N	1	1	2	f	43	\N	\N
1294	97	275	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1295	39	276	2	20	\N	20	\N	\N	1	1	2	f	0	\N	\N
1296	19	276	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
1297	2	276	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
1298	71	276	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1299	40	276	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1300	106	277	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
1301	39	277	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
1302	2	277	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
1303	40	277	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1304	55	278	2	3735	\N	0	\N	\N	1	1	2	f	3735	\N	\N
1305	97	278	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1306	14	278	2	1268	\N	0	\N	\N	0	1	2	f	1268	\N	\N
1307	94	279	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
1308	23	281	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1309	55	282	2	408	\N	408	\N	\N	1	1	2	f	0	\N	\N
1310	55	282	1	408	\N	408	\N	\N	1	1	2	f	\N	\N	\N
1311	39	283	2	55	\N	55	\N	\N	1	1	2	f	0	\N	\N
1312	19	283	2	4	\N	3	\N	\N	2	1	2	f	1	\N	\N
1313	2	283	2	53	\N	53	\N	\N	0	1	2	f	0	\N	\N
1314	40	283	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
1315	71	283	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1316	34	283	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1317	55	284	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
1318	57	284	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1319	97	285	2	20	\N	0	\N	\N	1	1	2	f	20	\N	\N
1320	18	285	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1321	96	286	2	421281	\N	421281	\N	\N	1	1	2	f	0	\N	\N
1322	68	286	1	272858	\N	272858	\N	\N	1	1	2	f	\N	\N	\N
1323	105	286	1	515	\N	515	\N	\N	2	1	2	f	\N	\N	\N
1324	104	286	1	85668	\N	85668	\N	\N	0	1	2	f	\N	\N	\N
1325	18	286	1	62	\N	62	\N	\N	0	1	2	f	\N	\N	\N
1326	74	286	1	56	\N	56	\N	\N	0	1	2	f	\N	\N	\N
1327	110	286	1	45	\N	45	\N	\N	0	1	2	f	\N	\N	\N
1328	69	286	1	40	\N	40	\N	\N	0	1	2	f	\N	\N	\N
1329	59	286	1	36	\N	36	\N	\N	0	1	2	f	\N	\N	\N
1330	109	286	1	27	\N	27	\N	\N	0	1	2	f	\N	\N	\N
1331	70	286	1	21	\N	21	\N	\N	0	1	2	f	\N	\N	\N
1332	55	287	2	481	\N	0	\N	\N	1	1	2	f	481	\N	\N
1333	39	288	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
1334	2	288	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
1335	39	288	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
1336	40	288	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1337	94	289	2	28135	\N	0	\N	\N	1	1	2	f	28135	\N	\N
1338	55	289	2	6	\N	0	\N	\N	2	1	2	f	6	\N	\N
1339	55	290	2	29	\N	0	\N	\N	1	1	2	f	29	\N	\N
1340	97	290	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1341	55	291	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1342	55	292	2	230	\N	0	\N	\N	1	1	2	f	230	\N	\N
1343	97	292	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1344	16	293	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1345	94	294	2	39842	\N	0	\N	\N	1	1	2	f	39842	\N	\N
1346	58	295	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1347	58	295	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1348	55	296	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
1349	97	296	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1350	16	297	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1351	55	298	2	461	\N	0	\N	\N	1	1	2	f	461	\N	\N
1352	55	299	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1353	55	300	2	476	\N	0	\N	\N	1	1	2	f	476	\N	\N
1354	97	300	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1355	97	301	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1356	55	301	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1357	60	302	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
1358	55	303	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1359	55	304	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1360	97	304	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1361	55	305	2	92751	\N	92751	\N	\N	1	1	2	f	0	\N	\N
1362	16	305	2	17	\N	17	\N	\N	2	1	2	f	0	\N	\N
1363	23	305	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
1364	62	305	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
1365	14	305	2	5830	\N	5830	\N	\N	0	1	2	f	0	\N	\N
1366	53	305	2	5443	\N	5443	\N	\N	0	1	2	f	0	\N	\N
1367	90	305	2	204	\N	204	\N	\N	0	1	2	f	0	\N	\N
1368	54	305	2	72	\N	72	\N	\N	0	1	2	f	0	\N	\N
1369	57	305	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1370	55	305	1	86665	\N	86665	\N	\N	1	1	2	f	\N	\N	\N
1371	96	305	1	6086	\N	6086	\N	\N	2	1	2	f	\N	\N	\N
1372	16	305	1	17	\N	17	\N	\N	3	1	2	f	\N	\N	\N
1373	14	305	1	1718	\N	1718	\N	\N	0	1	2	f	\N	\N	\N
1374	57	305	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
1375	60	306	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1376	101	306	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1377	57	306	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1378	55	307	2	1577	\N	0	\N	\N	1	1	2	f	1577	\N	\N
1379	19	307	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
1380	57	307	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1381	55	308	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
1382	55	309	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1383	60	310	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1384	55	311	2	93	\N	0	\N	\N	1	1	2	f	93	\N	\N
1385	55	312	2	11030	\N	0	\N	\N	1	1	2	f	11030	\N	\N
1386	55	313	2	21849	\N	21849	\N	\N	1	1	2	f	0	\N	\N
1387	76	313	2	17665	\N	17665	\N	\N	2	1	2	f	0	\N	\N
1388	14	313	1	6724	\N	6724	\N	\N	1	1	2	f	\N	\N	\N
1389	55	313	1	1270	\N	1270	\N	\N	2	1	2	f	\N	\N	\N
1390	53	313	1	5151	\N	5151	\N	\N	0	1	2	f	\N	\N	\N
1391	90	313	1	394	\N	394	\N	\N	0	1	2	f	\N	\N	\N
1392	54	313	1	322	\N	322	\N	\N	0	1	2	f	\N	\N	\N
1393	60	314	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1394	39	315	2	56	\N	56	\N	\N	1	1	2	f	0	\N	\N
1395	19	315	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1396	2	315	2	54	\N	54	\N	\N	0	1	2	f	0	\N	\N
1397	40	315	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
1398	71	315	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1399	34	315	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1400	34	315	1	42	\N	42	\N	\N	1	1	2	f	\N	\N	\N
1401	107	315	1	13	\N	13	\N	\N	2	1	2	f	\N	\N	\N
1402	39	315	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1403	2	315	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1404	55	316	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
1405	55	317	2	1041	\N	0	\N	\N	1	1	2	f	1041	\N	\N
1406	97	317	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1407	14	317	2	384	\N	0	\N	\N	0	1	2	f	384	\N	\N
1408	71	318	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
1409	39	318	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1410	2	318	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1411	40	318	1	9	\N	9	\N	\N	1	1	2	f	\N	\N	\N
1412	39	318	1	9	\N	9	\N	\N	0	1	2	f	\N	\N	\N
1413	2	318	1	9	\N	9	\N	\N	0	1	2	f	\N	\N	\N
1414	55	319	2	40032	\N	0	\N	\N	1	1	2	f	40032	\N	\N
1415	57	319	2	42	\N	0	\N	\N	0	1	2	f	42	\N	\N
1416	83	319	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
1417	80	319	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1418	10	319	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1419	11	319	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1420	48	319	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1421	9	319	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1422	45	319	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1423	13	319	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1424	51	319	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1425	84	319	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1426	46	319	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1427	79	319	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1428	85	319	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1429	81	319	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1430	12	319	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1431	50	319	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1432	39	321	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1433	97	322	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1434	55	322	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1435	19	323	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1436	23	323	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1437	55	324	2	2367	\N	0	\N	\N	1	1	2	f	2367	\N	\N
1438	55	325	2	65	\N	0	\N	\N	1	1	2	f	65	\N	\N
1439	97	325	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1440	55	326	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
1441	97	327	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1442	55	327	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1443	55	328	2	601	\N	0	\N	\N	1	1	2	f	601	\N	\N
1444	55	330	2	14	\N	0	\N	\N	1	1	2	f	14	\N	\N
1445	97	330	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1446	108	331	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1447	34	331	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1448	94	332	2	510	\N	0	\N	\N	1	1	2	f	510	\N	\N
1449	55	333	2	165	\N	0	\N	\N	1	1	2	f	165	\N	\N
1450	98	334	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1451	19	334	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1452	94	335	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
1453	23	336	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1454	55	337	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
1455	39	338	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
1456	2	338	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1457	40	338	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1458	97	339	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1459	55	340	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
1460	55	341	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
1461	97	341	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1462	39	342	2	19	\N	19	\N	\N	1	1	2	f	0	\N	\N
1463	2	342	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1464	71	342	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1465	40	342	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1466	17	343	2	35	\N	35	\N	\N	1	1	2	f	0	\N	\N
1467	23	344	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1468	60	344	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1469	19	345	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1470	16	346	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1471	55	347	2	384	\N	0	\N	\N	1	1	2	f	384	\N	\N
1472	97	347	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1473	18	348	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1474	39	349	2	106	\N	106	\N	\N	1	1	2	f	0	\N	\N
1475	2	349	2	94	\N	94	\N	\N	0	1	2	f	0	\N	\N
1476	71	349	2	60	\N	60	\N	\N	0	1	2	f	0	\N	\N
1477	40	349	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
1478	37	350	2	1705576	\N	0	\N	\N	1	1	2	f	1705576	\N	\N
1479	75	350	2	1501810	\N	0	\N	\N	2	1	2	f	1501810	\N	\N
1480	1	350	2	800444	\N	0	\N	\N	3	1	2	f	800444	\N	\N
1481	38	350	2	797936	\N	0	\N	\N	4	1	2	f	797936	\N	\N
1482	88	350	2	736241	\N	0	\N	\N	5	1	2	f	736241	\N	\N
1483	77	350	2	638378	\N	0	\N	\N	6	1	2	f	638378	\N	\N
1484	42	350	2	392995	\N	0	\N	\N	7	1	2	f	392995	\N	\N
1485	7	350	2	392995	\N	0	\N	\N	8	1	2	f	392995	\N	\N
1486	41	350	2	392995	\N	0	\N	\N	9	1	2	f	392995	\N	\N
1487	78	350	2	220696	\N	0	\N	\N	10	1	2	f	220696	\N	\N
1488	4	350	2	220696	\N	0	\N	\N	11	1	2	f	220696	\N	\N
1489	44	350	2	194515	\N	0	\N	\N	12	1	2	f	194515	\N	\N
1490	6	350	2	194515	\N	0	\N	\N	13	1	2	f	194515	\N	\N
1491	43	350	2	194515	\N	0	\N	\N	14	1	2	f	194515	\N	\N
1492	76	350	2	130895	\N	0	\N	\N	15	1	2	f	130895	\N	\N
1493	14	350	2	106522	\N	0	\N	\N	16	1	2	f	106522	\N	\N
1494	89	350	2	65588	\N	0	\N	\N	17	1	2	f	65588	\N	\N
1495	91	350	2	29135	\N	0	\N	\N	18	1	2	f	29135	\N	\N
1496	5	350	2	26176	\N	0	\N	\N	19	1	2	f	26176	\N	\N
1497	3	350	2	17369	\N	0	\N	\N	20	1	2	f	17369	\N	\N
1498	64	350	2	10744	\N	0	\N	\N	21	1	2	f	10744	\N	\N
1499	55	350	2	8559	\N	0	\N	\N	22	1	2	f	8559	\N	\N
1500	103	350	2	6275	\N	0	\N	\N	23	1	2	f	6275	\N	\N
1501	66	350	2	1260	\N	0	\N	\N	24	1	2	f	1260	\N	\N
1502	65	350	2	326	\N	0	\N	\N	25	1	2	f	326	\N	\N
1503	22	350	2	315	\N	0	\N	\N	26	1	2	f	315	\N	\N
1504	67	350	2	285	\N	0	\N	\N	27	1	2	f	285	\N	\N
1505	31	350	2	223	\N	0	\N	\N	28	1	2	f	223	\N	\N
1506	39	350	2	81	\N	0	\N	\N	29	1	2	f	81	\N	\N
1507	30	350	2	65	\N	0	\N	\N	30	1	2	f	65	\N	\N
1508	34	350	2	22	\N	0	\N	\N	31	1	2	f	22	\N	\N
1509	35	350	2	3	\N	0	\N	\N	32	1	2	f	3	\N	\N
1510	106	350	2	2	\N	0	\N	\N	33	1	2	f	2	\N	\N
1511	108	350	2	1	\N	0	\N	\N	34	1	2	f	1	\N	\N
1512	19	350	2	1	\N	0	\N	\N	35	1	2	f	1	\N	\N
1513	45	350	2	59645	\N	0	\N	\N	0	1	2	f	59645	\N	\N
1514	80	350	2	47726	\N	0	\N	\N	0	1	2	f	47726	\N	\N
1515	53	350	2	21838	\N	0	\N	\N	0	1	2	f	21838	\N	\N
1516	10	350	2	21512	\N	0	\N	\N	0	1	2	f	21512	\N	\N
1517	9	350	2	14897	\N	0	\N	\N	0	1	2	f	14897	\N	\N
1518	79	350	2	14206	\N	0	\N	\N	0	1	2	f	14206	\N	\N
1519	54	350	2	7493	\N	0	\N	\N	0	1	2	f	7493	\N	\N
1520	8	350	2	4294	\N	0	\N	\N	0	1	2	f	4294	\N	\N
1521	12	350	2	3944	\N	0	\N	\N	0	1	2	f	3944	\N	\N
1522	46	350	2	3861	\N	0	\N	\N	0	1	2	f	3861	\N	\N
1523	81	350	2	3838	\N	0	\N	\N	0	1	2	f	3838	\N	\N
1524	82	350	2	3561	\N	0	\N	\N	0	1	2	f	3561	\N	\N
1525	49	350	2	3115	\N	0	\N	\N	0	1	2	f	3115	\N	\N
1526	83	350	2	2415	\N	0	\N	\N	0	1	2	f	2415	\N	\N
1527	11	350	2	1643	\N	0	\N	\N	0	1	2	f	1643	\N	\N
1528	84	350	2	1202	\N	0	\N	\N	0	1	2	f	1202	\N	\N
1529	85	350	2	1202	\N	0	\N	\N	0	1	2	f	1202	\N	\N
1530	48	350	2	975	\N	0	\N	\N	0	1	2	f	975	\N	\N
1531	90	350	2	962	\N	0	\N	\N	0	1	2	f	962	\N	\N
1532	47	350	2	534	\N	0	\N	\N	0	1	2	f	534	\N	\N
1533	87	350	2	341	\N	0	\N	\N	0	1	2	f	341	\N	\N
1534	50	350	2	207	\N	0	\N	\N	0	1	2	f	207	\N	\N
1535	13	350	2	139	\N	0	\N	\N	0	1	2	f	139	\N	\N
1536	57	350	2	119	\N	0	\N	\N	0	1	2	f	119	\N	\N
1537	86	350	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
1538	2	350	2	79	\N	0	\N	\N	0	1	2	f	79	\N	\N
1539	51	350	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
1540	52	350	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
1541	40	350	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
1542	71	350	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
1543	29	350	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1544	37	351	2	1705576	\N	0	\N	\N	1	1	2	f	1705576	\N	\N
1545	75	351	2	1501810	\N	0	\N	\N	2	1	2	f	1501810	\N	\N
1546	1	351	2	800444	\N	0	\N	\N	3	1	2	f	800444	\N	\N
1547	38	351	2	797936	\N	0	\N	\N	4	1	2	f	797936	\N	\N
1548	88	351	2	736241	\N	0	\N	\N	5	1	2	f	736241	\N	\N
1549	77	351	2	638378	\N	0	\N	\N	6	1	2	f	638378	\N	\N
1550	42	351	2	392995	\N	0	\N	\N	7	1	2	f	392995	\N	\N
1551	7	351	2	392995	\N	0	\N	\N	8	1	2	f	392995	\N	\N
1552	41	351	2	392995	\N	0	\N	\N	9	1	2	f	392995	\N	\N
1553	55	351	2	245945	\N	0	\N	\N	10	1	2	f	245945	\N	\N
1554	78	351	2	220696	\N	0	\N	\N	11	1	2	f	220696	\N	\N
1555	4	351	2	220696	\N	0	\N	\N	12	1	2	f	220696	\N	\N
1556	44	351	2	194515	\N	0	\N	\N	13	1	2	f	194515	\N	\N
1557	6	351	2	194515	\N	0	\N	\N	14	1	2	f	194515	\N	\N
1558	43	351	2	194515	\N	0	\N	\N	15	1	2	f	194515	\N	\N
1559	76	351	2	130895	\N	0	\N	\N	16	1	2	f	130895	\N	\N
1560	14	351	2	113410	\N	0	\N	\N	17	1	2	f	113410	\N	\N
1561	89	351	2	65588	\N	0	\N	\N	18	1	2	f	65588	\N	\N
1562	91	351	2	29135	\N	0	\N	\N	19	1	2	f	29135	\N	\N
1563	5	351	2	26176	\N	0	\N	\N	20	1	2	f	26176	\N	\N
1564	3	351	2	17369	\N	0	\N	\N	21	1	2	f	17369	\N	\N
1565	64	351	2	10744	\N	0	\N	\N	22	1	2	f	10744	\N	\N
1566	103	351	2	6275	\N	0	\N	\N	23	1	2	f	6275	\N	\N
1567	66	351	2	1260	\N	0	\N	\N	24	1	2	f	1260	\N	\N
1568	68	351	2	624	\N	0	\N	\N	25	1	2	f	624	\N	\N
1569	94	351	2	472	\N	0	\N	\N	26	1	2	f	472	\N	\N
1570	65	351	2	326	\N	0	\N	\N	27	1	2	f	326	\N	\N
1571	22	351	2	315	\N	0	\N	\N	28	1	2	f	315	\N	\N
1572	67	351	2	285	\N	0	\N	\N	29	1	2	f	285	\N	\N
1573	31	351	2	223	\N	0	\N	\N	30	1	2	f	223	\N	\N
1574	97	351	2	214	\N	0	\N	\N	31	1	2	f	214	\N	\N
1575	18	351	2	189	\N	0	\N	\N	32	1	2	f	189	\N	\N
1576	30	351	2	65	\N	0	\N	\N	33	1	2	f	65	\N	\N
1577	105	351	2	10	\N	0	\N	\N	34	1	2	f	10	\N	\N
1578	32	351	2	5	\N	0	\N	\N	35	1	2	f	5	\N	\N
1579	19	351	2	5	\N	0	\N	\N	36	1	2	f	5	\N	\N
1580	99	351	2	1	\N	0	\N	\N	37	1	2	f	1	\N	\N
1581	24	351	2	1	\N	0	\N	\N	38	1	2	f	1	\N	\N
1582	100	351	2	1	\N	0	\N	\N	39	1	2	f	1	\N	\N
1583	101	351	2	1	\N	0	\N	\N	40	1	2	f	1	\N	\N
1584	28	351	2	1	\N	0	\N	\N	41	1	2	f	1	\N	\N
1585	108	351	2	1	\N	0	\N	\N	42	1	2	f	1	\N	\N
1586	36	351	2	1	\N	0	\N	\N	43	1	2	f	1	\N	\N
1587	72	351	2	1	\N	0	\N	\N	44	1	2	f	1	\N	\N
1588	73	351	2	1	\N	0	\N	\N	45	1	2	f	1	\N	\N
1589	45	351	2	59646	\N	0	\N	\N	0	1	2	f	59646	\N	\N
1590	80	351	2	47727	\N	0	\N	\N	0	1	2	f	47727	\N	\N
1591	53	351	2	21838	\N	0	\N	\N	0	1	2	f	21838	\N	\N
1592	10	351	2	21513	\N	0	\N	\N	0	1	2	f	21513	\N	\N
1593	9	351	2	14898	\N	0	\N	\N	0	1	2	f	14898	\N	\N
1594	79	351	2	14207	\N	0	\N	\N	0	1	2	f	14207	\N	\N
1595	54	351	2	7493	\N	0	\N	\N	0	1	2	f	7493	\N	\N
1596	8	351	2	4295	\N	0	\N	\N	0	1	2	f	4295	\N	\N
1597	12	351	2	3945	\N	0	\N	\N	0	1	2	f	3945	\N	\N
1598	46	351	2	3862	\N	0	\N	\N	0	1	2	f	3862	\N	\N
1599	81	351	2	3839	\N	0	\N	\N	0	1	2	f	3839	\N	\N
1600	82	351	2	3562	\N	0	\N	\N	0	1	2	f	3562	\N	\N
1601	49	351	2	3116	\N	0	\N	\N	0	1	2	f	3116	\N	\N
1602	83	351	2	2416	\N	0	\N	\N	0	1	2	f	2416	\N	\N
1603	11	351	2	1644	\N	0	\N	\N	0	1	2	f	1644	\N	\N
1604	84	351	2	1203	\N	0	\N	\N	0	1	2	f	1203	\N	\N
1605	85	351	2	1203	\N	0	\N	\N	0	1	2	f	1203	\N	\N
1606	48	351	2	976	\N	0	\N	\N	0	1	2	f	976	\N	\N
1607	90	351	2	962	\N	0	\N	\N	0	1	2	f	962	\N	\N
1608	47	351	2	535	\N	0	\N	\N	0	1	2	f	535	\N	\N
1609	87	351	2	342	\N	0	\N	\N	0	1	2	f	342	\N	\N
1610	57	351	2	295	\N	0	\N	\N	0	1	2	f	295	\N	\N
1611	50	351	2	208	\N	0	\N	\N	0	1	2	f	208	\N	\N
1612	13	351	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
1613	86	351	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
1614	104	351	2	62	\N	0	\N	\N	0	1	2	f	62	\N	\N
1615	51	351	2	53	\N	0	\N	\N	0	1	2	f	53	\N	\N
1616	70	351	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
1617	52	351	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
1618	69	351	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
1619	59	351	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
1620	20	351	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1621	109	351	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1622	74	351	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
1623	29	351	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1624	33	351	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1625	110	351	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1626	55	352	2	716	\N	0	\N	\N	1	1	2	f	716	\N	\N
1627	97	352	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1628	96	353	2	38722	\N	0	\N	\N	1	1	2	f	38722	\N	\N
1629	42	354	2	392995	\N	392995	\N	\N	1	1	2	f	0	\N	\N
1630	41	354	1	392995	\N	392995	\N	\N	1	1	2	f	\N	\N	\N
1631	55	355	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
1632	14	355	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1633	55	356	2	28	\N	0	\N	\N	1	1	2	f	28	\N	\N
1634	97	356	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1635	19	357	2	4	\N	2	\N	\N	1	1	2	f	2	\N	\N
1636	92	358	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1637	93	358	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
1638	15	358	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1639	94	359	2	61	\N	0	\N	\N	1	1	2	f	61	\N	\N
1640	55	360	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1641	55	361	2	336	\N	0	\N	\N	1	1	2	f	336	\N	\N
1642	55	362	2	8	\N	0	\N	\N	1	1	2	f	8	\N	\N
1643	97	362	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1644	14	362	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1645	28	363	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
1646	55	364	2	191	\N	0	\N	\N	1	1	2	f	191	\N	\N
1647	97	364	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1648	55	365	2	52	\N	0	\N	\N	1	1	2	f	52	\N	\N
1649	97	365	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1650	71	366	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
1651	39	366	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1652	2	366	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1653	18	366	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
1654	97	366	1	10	\N	10	\N	\N	0	1	2	f	\N	\N	\N
1655	2	367	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1656	39	367	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1657	55	368	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
1658	94	369	2	508	\N	0	\N	\N	1	1	2	f	508	\N	\N
1659	55	370	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1660	39	371	2	103	\N	103	\N	\N	1	1	2	f	0	\N	\N
1661	2	371	2	61	\N	61	\N	\N	0	1	2	f	0	\N	\N
1662	40	371	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
1663	2	371	1	62	\N	62	\N	\N	1	1	2	f	\N	\N	\N
1664	39	371	1	62	\N	62	\N	\N	0	1	2	f	\N	\N	\N
1665	34	371	1	14	\N	14	\N	\N	0	1	2	f	\N	\N	\N
1666	55	372	2	38	\N	0	\N	\N	1	1	2	f	38	\N	\N
1667	97	372	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1668	55	373	2	254	\N	0	\N	\N	1	1	2	f	254	\N	\N
1669	97	373	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1670	2	374	2	13	\N	13	\N	\N	1	1	2	f	0	\N	\N
1671	39	374	2	13	\N	13	\N	\N	0	1	2	f	0	\N	\N
1672	34	374	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1673	36	374	1	7	\N	7	\N	\N	1	1	2	f	\N	\N	\N
1674	73	374	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1675	55	375	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
1676	39	376	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
1677	108	376	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1678	2	376	2	32	\N	0	\N	\N	0	1	2	f	32	\N	\N
1679	71	376	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1680	40	376	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1681	34	376	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1682	55	377	2	83	\N	0	\N	\N	1	1	2	f	83	\N	\N
1683	40	378	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1684	39	378	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1685	2	378	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1686	58	379	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
1687	55	380	2	510	\N	0	\N	\N	1	1	2	f	510	\N	\N
1688	14	380	2	415	\N	0	\N	\N	0	1	2	f	415	\N	\N
1689	55	381	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1690	97	381	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1691	39	382	2	18	\N	0	\N	\N	1	1	2	f	18	\N	\N
1692	106	382	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1693	2	382	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
1694	71	382	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1695	40	382	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1696	55	383	2	595	\N	595	\N	\N	1	1	2	f	0	\N	\N
1697	96	383	1	593	\N	593	\N	\N	1	1	2	f	\N	\N	\N
1698	55	383	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
1699	55	384	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1700	55	385	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
1701	97	385	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1702	55	386	2	46	\N	0	\N	\N	1	1	2	f	46	\N	\N
1703	39	387	2	26	\N	26	\N	\N	1	1	2	f	0	\N	\N
1704	106	387	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
1705	2	387	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1706	71	387	2	18	\N	18	\N	\N	0	1	2	f	0	\N	\N
1707	40	387	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1708	71	387	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
1709	106	387	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
1710	39	387	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
1711	2	387	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
1712	71	388	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
1713	39	388	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1714	2	388	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1715	55	388	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
1716	57	388	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
1717	55	389	2	9430	\N	0	\N	\N	1	1	2	f	9430	\N	\N
1718	68	389	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
1719	14	389	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1720	37	390	2	1705576	\N	0	\N	\N	1	1	2	f	1705576	\N	\N
1721	75	390	2	1501810	\N	0	\N	\N	2	1	2	f	1501810	\N	\N
1722	1	390	2	800444	\N	0	\N	\N	3	1	2	f	800444	\N	\N
1723	38	390	2	797936	\N	0	\N	\N	4	1	2	f	797936	\N	\N
1724	88	390	2	736241	\N	0	\N	\N	5	1	2	f	736241	\N	\N
1725	77	390	2	638378	\N	0	\N	\N	6	1	2	f	638378	\N	\N
1726	42	390	2	392995	\N	0	\N	\N	7	1	2	f	392995	\N	\N
1727	7	390	2	392995	\N	0	\N	\N	8	1	2	f	392995	\N	\N
1728	41	390	2	392995	\N	0	\N	\N	9	1	2	f	392995	\N	\N
1729	78	390	2	220696	\N	0	\N	\N	10	1	2	f	220696	\N	\N
1730	4	390	2	220696	\N	0	\N	\N	11	1	2	f	220696	\N	\N
1731	44	390	2	194515	\N	0	\N	\N	12	1	2	f	194515	\N	\N
1732	6	390	2	194515	\N	0	\N	\N	13	1	2	f	194515	\N	\N
1733	43	390	2	194515	\N	0	\N	\N	14	1	2	f	194515	\N	\N
1734	76	390	2	130905	\N	0	\N	\N	15	1	2	f	130905	\N	\N
1735	14	390	2	78812	\N	0	\N	\N	16	1	2	f	78812	\N	\N
1736	89	390	2	65588	\N	0	\N	\N	17	1	2	f	65588	\N	\N
1737	45	390	2	59646	\N	0	\N	\N	18	1	2	f	59646	\N	\N
1738	80	390	2	47727	\N	0	\N	\N	19	1	2	f	47727	\N	\N
1739	91	390	2	29135	\N	0	\N	\N	20	1	2	f	29135	\N	\N
1740	5	390	2	26176	\N	0	\N	\N	21	1	2	f	26176	\N	\N
1741	10	390	2	21513	\N	0	\N	\N	22	1	2	f	21513	\N	\N
1742	3	390	2	17369	\N	0	\N	\N	23	1	2	f	17369	\N	\N
1743	9	390	2	14898	\N	0	\N	\N	24	1	2	f	14898	\N	\N
1744	55	390	2	14284	\N	0	\N	\N	25	1	2	f	14284	\N	\N
1745	64	390	2	10744	\N	0	\N	\N	26	1	2	f	10744	\N	\N
1746	103	390	2	6275	\N	0	\N	\N	27	1	2	f	6275	\N	\N
1747	66	390	2	1260	\N	0	\N	\N	28	1	2	f	1260	\N	\N
1748	65	390	2	326	\N	0	\N	\N	29	1	2	f	326	\N	\N
1749	22	390	2	315	\N	0	\N	\N	30	1	2	f	315	\N	\N
1750	67	390	2	285	\N	0	\N	\N	31	1	2	f	285	\N	\N
1751	31	390	2	223	\N	0	\N	\N	32	1	2	f	223	\N	\N
1752	30	390	2	65	\N	0	\N	\N	33	1	2	f	65	\N	\N
1753	97	390	2	65	\N	0	\N	\N	34	1	2	f	65	\N	\N
1754	68	390	2	55	\N	0	\N	\N	35	1	2	f	55	\N	\N
1755	94	390	2	40	\N	0	\N	\N	36	1	2	f	40	\N	\N
1756	19	390	2	13	\N	0	\N	\N	37	1	2	f	13	\N	\N
1757	18	390	2	4	\N	0	\N	\N	38	1	2	f	4	\N	\N
1758	60	390	2	3	\N	0	\N	\N	39	1	2	f	3	\N	\N
1759	25	390	2	3	\N	0	\N	\N	40	1	2	f	3	\N	\N
1760	61	390	2	3	\N	0	\N	\N	41	1	2	f	3	\N	\N
1761	24	390	2	1	\N	0	\N	\N	42	1	2	f	1	\N	\N
1762	100	390	2	1	\N	0	\N	\N	43	1	2	f	1	\N	\N
1763	101	390	2	1	\N	0	\N	\N	44	1	2	f	1	\N	\N
1764	28	390	2	1	\N	0	\N	\N	45	1	2	f	1	\N	\N
1765	36	390	2	1	\N	0	\N	\N	46	1	2	f	1	\N	\N
1766	72	390	2	1	\N	0	\N	\N	47	1	2	f	1	\N	\N
1767	73	390	2	1	\N	0	\N	\N	48	1	2	f	1	\N	\N
1768	105	390	2	1	\N	0	\N	\N	49	1	2	f	1	\N	\N
1769	53	390	2	21838	\N	0	\N	\N	0	1	2	f	21838	\N	\N
1770	79	390	2	14207	\N	0	\N	\N	0	1	2	f	14207	\N	\N
1771	54	390	2	7493	\N	0	\N	\N	0	1	2	f	7493	\N	\N
1772	8	390	2	4294	\N	0	\N	\N	0	1	2	f	4294	\N	\N
1773	12	390	2	3944	\N	0	\N	\N	0	1	2	f	3944	\N	\N
1774	46	390	2	3862	\N	0	\N	\N	0	1	2	f	3862	\N	\N
1775	81	390	2	3839	\N	0	\N	\N	0	1	2	f	3839	\N	\N
1776	82	390	2	3561	\N	0	\N	\N	0	1	2	f	3561	\N	\N
1777	49	390	2	3116	\N	0	\N	\N	0	1	2	f	3116	\N	\N
1778	83	390	2	2416	\N	0	\N	\N	0	1	2	f	2416	\N	\N
1779	11	390	2	1644	\N	0	\N	\N	0	1	2	f	1644	\N	\N
1780	84	390	2	1203	\N	0	\N	\N	0	1	2	f	1203	\N	\N
1781	85	390	2	1203	\N	0	\N	\N	0	1	2	f	1203	\N	\N
1782	48	390	2	975	\N	0	\N	\N	0	1	2	f	975	\N	\N
1783	90	390	2	962	\N	0	\N	\N	0	1	2	f	962	\N	\N
1784	47	390	2	535	\N	0	\N	\N	0	1	2	f	535	\N	\N
1785	87	390	2	341	\N	0	\N	\N	0	1	2	f	341	\N	\N
1786	57	390	2	212	\N	0	\N	\N	0	1	2	f	212	\N	\N
1787	50	390	2	207	\N	0	\N	\N	0	1	2	f	207	\N	\N
1788	13	390	2	140	\N	0	\N	\N	0	1	2	f	140	\N	\N
1789	86	390	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
1790	51	390	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
1791	52	390	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
1792	104	390	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1793	102	390	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1794	26	390	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1795	27	390	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1796	29	390	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1797	55	391	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1798	14	391	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1799	55	392	2	107	\N	0	\N	\N	1	1	2	f	107	\N	\N
1800	68	392	2	7	\N	0	\N	\N	2	1	2	f	7	\N	\N
1801	57	392	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1802	55	393	2	19	\N	0	\N	\N	1	1	2	f	19	\N	\N
1803	97	393	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1804	55	394	2	30	\N	0	\N	\N	1	1	2	f	30	\N	\N
1805	68	394	2	21	\N	0	\N	\N	2	1	2	f	21	\N	\N
1806	104	394	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1807	70	394	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1808	18	394	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1809	109	394	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1810	110	394	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1811	74	394	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
1812	2	395	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
1813	39	395	2	26	\N	0	\N	\N	0	1	2	f	26	\N	\N
1814	40	395	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
1815	71	395	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
1816	55	396	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
1817	97	396	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1818	97	397	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1819	55	397	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1820	2	398	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1821	39	398	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1822	107	398	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1823	18	399	2	279	\N	279	\N	\N	1	1	2	f	0	\N	\N
1824	68	399	2	136	\N	136	\N	\N	2	1	2	f	0	\N	\N
1825	104	399	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1826	69	399	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1827	20	399	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1828	70	399	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1829	55	399	1	138	\N	138	\N	\N	1	1	2	f	\N	\N	\N
1830	100	399	1	13	\N	13	\N	\N	2	1	2	f	\N	\N	\N
1831	101	399	1	6	\N	6	\N	\N	3	1	2	f	\N	\N	\N
1832	24	399	1	4	\N	4	\N	\N	4	1	2	f	\N	\N	\N
1833	57	399	1	304	\N	304	\N	\N	0	1	2	f	\N	\N	\N
1834	14	399	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1835	39	400	2	66	\N	0	\N	\N	1	1	2	f	66	\N	\N
1836	55	400	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
1837	2	400	2	64	\N	0	\N	\N	0	1	2	f	64	\N	\N
1838	40	400	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
1839	71	400	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
1840	34	400	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1841	94	401	2	278786	\N	5	\N	\N	1	1	2	f	278781	\N	\N
1842	94	402	2	61	\N	0	\N	\N	1	1	2	f	61	\N	\N
1843	55	403	2	232	\N	0	\N	\N	1	1	2	f	232	\N	\N
1844	97	403	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1845	55	404	2	245	\N	245	\N	\N	1	1	2	f	0	\N	\N
1846	55	404	1	245	\N	245	\N	\N	1	1	2	f	\N	\N	\N
1847	55	405	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
1848	55	406	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
1849	55	406	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
1850	55	407	2	5242	\N	5242	\N	\N	1	1	2	f	0	\N	\N
1851	55	407	1	5242	\N	5242	\N	\N	1	1	2	f	\N	\N	\N
1852	55	408	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1853	97	408	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1854	19	409	2	14	\N	0	\N	\N	1	1	2	f	14	\N	\N
1855	55	409	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
1856	94	410	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
1857	97	410	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1858	97	410	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1859	97	411	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1860	55	411	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1861	55	412	2	43	\N	0	\N	\N	1	1	2	f	43	\N	\N
1862	55	413	2	10818	\N	0	\N	\N	1	1	2	f	10818	\N	\N
1863	55	414	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1864	97	414	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1865	55	415	2	13	\N	0	\N	\N	1	1	2	f	13	\N	\N
1866	97	415	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1867	55	416	2	330	\N	0	\N	\N	1	1	2	f	330	\N	\N
1868	97	416	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
1869	55	417	2	134	\N	0	\N	\N	1	1	2	f	134	\N	\N
1870	55	418	2	203	\N	0	\N	\N	1	1	2	f	203	\N	\N
1871	55	419	2	27	\N	0	\N	\N	1	1	2	f	27	\N	\N
1872	55	420	2	254	\N	0	\N	\N	1	1	2	f	254	\N	\N
1873	97	420	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1874	94	421	2	985111	\N	107841	\N	\N	1	1	2	f	877270	\N	\N
1875	56	421	2	10258	\N	0	\N	\N	2	1	2	f	10258	\N	\N
1876	55	421	1	78755	\N	78755	\N	\N	1	1	2	f	\N	\N	\N
1877	96	421	1	17977	\N	17977	\N	\N	2	1	2	f	\N	\N	\N
1878	97	421	1	10793	\N	10793	\N	\N	3	1	2	f	\N	\N	\N
1879	14	421	1	2058	\N	2058	\N	\N	0	1	2	f	\N	\N	\N
1880	57	421	1	60	\N	60	\N	\N	0	1	2	f	\N	\N	\N
1881	55	422	2	4110	\N	4110	\N	\N	1	1	2	f	0	\N	\N
1882	14	422	1	3057	\N	3057	\N	\N	1	1	2	f	\N	\N	\N
1883	55	422	1	442	\N	442	\N	\N	2	1	2	f	\N	\N	\N
1884	55	423	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1885	97	423	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1886	55	424	2	19	\N	0	\N	\N	1	1	2	f	19	\N	\N
1887	97	424	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1888	97	425	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1889	55	425	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1890	55	426	2	32	\N	0	\N	\N	1	1	2	f	32	\N	\N
1891	55	427	2	55	\N	0	\N	\N	1	1	2	f	55	\N	\N
1892	55	428	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
1893	55	429	2	1828	\N	0	\N	\N	1	1	2	f	1828	\N	\N
1894	55	430	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
1895	55	431	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1896	40	432	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
1897	39	432	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1898	2	432	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1899	94	433	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1900	37	434	2	1529050	\N	1529050	\N	\N	1	1	2	f	0	\N	\N
1901	1	434	2	790858	\N	790858	\N	\N	2	1	2	f	0	\N	\N
1902	88	434	2	646577	\N	646577	\N	\N	3	1	2	f	0	\N	\N
1903	77	434	2	638378	\N	638378	\N	\N	4	1	2	f	0	\N	\N
1904	89	434	2	50977	\N	50977	\N	\N	5	1	2	f	0	\N	\N
1905	91	434	2	28738	\N	28738	\N	\N	6	1	2	f	0	\N	\N
1906	64	434	2	10744	\N	10744	\N	\N	7	1	2	f	0	\N	\N
1907	103	434	2	5787	\N	5787	\N	\N	8	1	2	f	0	\N	\N
1908	66	434	2	779	\N	779	\N	\N	9	1	2	f	0	\N	\N
1909	65	434	2	326	\N	326	\N	\N	10	1	2	f	0	\N	\N
1910	67	434	2	270	\N	270	\N	\N	11	1	2	f	0	\N	\N
1911	22	434	2	258	\N	258	\N	\N	12	1	2	f	0	\N	\N
1912	31	434	2	155	\N	155	\N	\N	13	1	2	f	0	\N	\N
1913	30	434	2	62	\N	62	\N	\N	14	1	2	f	0	\N	\N
1914	38	434	1	3702959	\N	3702959	\N	\N	1	1	2	f	\N	\N	\N
1915	55	435	2	4807	\N	0	\N	\N	1	1	2	f	4807	\N	\N
1916	55	436	2	205	\N	0	\N	\N	1	1	2	f	205	\N	\N
1917	55	437	2	13452	\N	0	\N	\N	1	1	2	f	13452	\N	\N
1918	98	438	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1919	39	439	2	106	\N	106	\N	\N	1	1	2	f	0	\N	\N
1920	108	439	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
1921	2	439	2	94	\N	94	\N	\N	0	1	2	f	0	\N	\N
1922	71	439	2	60	\N	60	\N	\N	0	1	2	f	0	\N	\N
1923	40	439	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
1924	107	439	1	106	\N	106	\N	\N	1	1	2	f	\N	\N	\N
1925	19	441	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
1926	55	442	2	645	\N	0	\N	\N	1	1	2	f	645	\N	\N
1927	97	442	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1928	55	443	2	3740	\N	0	\N	\N	1	1	2	f	3740	\N	\N
1929	2	444	2	17	\N	17	\N	\N	1	1	2	f	0	\N	\N
1930	39	444	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1931	40	444	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1932	21	444	1	17	\N	17	\N	\N	1	1	2	f	\N	\N	\N
1933	40	445	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
1934	39	445	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1935	2	445	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1936	55	446	2	730	\N	0	\N	\N	1	1	2	f	730	\N	\N
1937	68	446	2	18	\N	0	\N	\N	2	1	2	f	18	\N	\N
1938	104	446	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1939	55	447	2	345	\N	0	\N	\N	1	1	2	f	345	\N	\N
1940	97	447	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1941	68	448	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1942	32	448	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1943	23	449	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1944	99	449	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1945	96	450	2	381917	\N	381917	\N	\N	1	1	2	f	0	\N	\N
1946	55	450	1	381894	\N	381894	\N	\N	1	1	2	f	\N	\N	\N
1947	96	450	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
1948	16	450	1	3	\N	3	\N	\N	3	1	2	f	\N	\N	\N
1949	14	450	1	1922	\N	1922	\N	\N	0	1	2	f	\N	\N	\N
1950	97	450	1	890	\N	890	\N	\N	0	1	2	f	\N	\N	\N
1951	57	450	1	317	\N	317	\N	\N	0	1	2	f	\N	\N	\N
1952	55	451	2	75	\N	75	\N	\N	1	1	2	f	0	\N	\N
1953	55	451	1	31	\N	31	\N	\N	1	1	2	f	\N	\N	\N
1954	55	452	2	133859	\N	0	\N	\N	1	1	2	f	133859	\N	\N
1955	68	452	2	97	\N	0	\N	\N	2	1	2	f	97	\N	\N
1956	97	452	2	74	\N	0	\N	\N	3	1	2	f	74	\N	\N
1957	57	452	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1958	104	452	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1959	58	453	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1960	58	453	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
1961	55	454	2	1262	\N	0	\N	\N	1	1	2	f	1262	\N	\N
1962	57	454	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
1963	10	454	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1964	12	454	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1965	55	455	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
1966	97	455	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1967	55	456	2	126395	\N	0	\N	\N	1	1	2	f	126395	\N	\N
1968	97	456	2	97	\N	0	\N	\N	2	1	2	f	97	\N	\N
1969	68	456	2	96	\N	0	\N	\N	3	1	2	f	96	\N	\N
1970	57	456	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1971	104	456	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1972	55	457	2	11290	\N	0	\N	\N	1	1	2	f	11290	\N	\N
1973	68	457	2	86	\N	0	\N	\N	2	1	2	f	86	\N	\N
1974	97	457	2	65	\N	0	\N	\N	3	1	2	f	65	\N	\N
1975	104	457	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
1976	25	458	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
1977	61	458	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
1978	102	458	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1979	26	458	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1980	27	458	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
1981	55	459	2	341	\N	0	\N	\N	1	1	2	f	341	\N	\N
1982	55	460	2	6267	\N	0	\N	\N	1	1	2	f	6267	\N	\N
1983	55	461	2	154	\N	0	\N	\N	1	1	2	f	154	\N	\N
1984	55	462	2	12349	\N	0	\N	\N	1	1	2	f	12349	\N	\N
1985	55	463	2	2203	\N	0	\N	\N	1	1	2	f	2203	\N	\N
1986	55	465	2	4998	\N	0	\N	\N	1	1	2	f	4998	\N	\N
1987	55	466	2	15	\N	0	\N	\N	1	1	2	f	15	\N	\N
1988	97	466	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1989	55	467	2	55	\N	0	\N	\N	1	1	2	f	55	\N	\N
1990	97	467	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
1991	94	468	2	505	\N	0	\N	\N	1	1	2	f	505	\N	\N
1992	23	469	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1993	98	470	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1994	68	471	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
1995	104	471	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
1996	19	472	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
1997	55	473	2	335	\N	0	\N	\N	1	1	2	f	335	\N	\N
1998	55	474	2	238	\N	238	\N	\N	1	1	2	f	0	\N	\N
1999	55	475	2	237	\N	0	\N	\N	1	1	2	f	237	\N	\N
2000	55	476	2	126395	\N	0	\N	\N	1	1	2	f	126395	\N	\N
2001	97	476	2	97	\N	0	\N	\N	2	1	2	f	97	\N	\N
2002	68	476	2	97	\N	0	\N	\N	3	1	2	f	97	\N	\N
2003	57	476	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2004	104	476	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2005	55	477	2	1223	\N	0	\N	\N	1	1	2	f	1223	\N	\N
2006	55	478	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
2007	55	479	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
2008	19	480	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
2009	97	481	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2010	55	481	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2011	55	482	2	2778	\N	0	\N	\N	1	1	2	f	2778	\N	\N
2012	55	483	2	51022	\N	0	\N	\N	1	1	2	f	51022	\N	\N
2013	97	483	2	11	\N	0	\N	\N	2	1	2	f	11	\N	\N
2014	57	483	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2015	55	484	2	3993	\N	0	\N	\N	1	1	2	f	3993	\N	\N
2016	37	485	2	1705576	\N	0	\N	\N	1	1	2	f	1705576	\N	\N
2017	75	485	2	1501810	\N	0	\N	\N	2	1	2	f	1501810	\N	\N
2018	1	485	2	800444	\N	0	\N	\N	3	1	2	f	800444	\N	\N
2019	38	485	2	797936	\N	0	\N	\N	4	1	2	f	797936	\N	\N
2020	88	485	2	736241	\N	0	\N	\N	5	1	2	f	736241	\N	\N
2021	77	485	2	638378	\N	0	\N	\N	6	1	2	f	638378	\N	\N
2022	42	485	2	392995	\N	0	\N	\N	7	1	2	f	392995	\N	\N
2023	7	485	2	392995	\N	0	\N	\N	8	1	2	f	392995	\N	\N
2024	78	485	2	220696	\N	0	\N	\N	9	1	2	f	220696	\N	\N
2025	4	485	2	220696	\N	0	\N	\N	10	1	2	f	220696	\N	\N
2026	44	485	2	194515	\N	0	\N	\N	11	1	2	f	194515	\N	\N
2027	6	485	2	194515	\N	0	\N	\N	12	1	2	f	194515	\N	\N
2028	43	485	2	194515	\N	0	\N	\N	13	1	2	f	194515	\N	\N
2029	41	485	2	145877	\N	0	\N	\N	14	1	2	f	145877	\N	\N
2030	76	485	2	130895	\N	0	\N	\N	15	1	2	f	130895	\N	\N
2031	14	485	2	78759	\N	0	\N	\N	16	1	2	f	78759	\N	\N
2032	89	485	2	65588	\N	0	\N	\N	17	1	2	f	65588	\N	\N
2033	91	485	2	29135	\N	0	\N	\N	18	1	2	f	29135	\N	\N
2034	5	485	2	26176	\N	0	\N	\N	19	1	2	f	26176	\N	\N
2035	3	485	2	17369	\N	0	\N	\N	20	1	2	f	17369	\N	\N
2036	64	485	2	10744	\N	0	\N	\N	21	1	2	f	10744	\N	\N
2037	55	485	2	8559	\N	0	\N	\N	22	1	2	f	8559	\N	\N
2038	103	485	2	6275	\N	0	\N	\N	23	1	2	f	6275	\N	\N
2039	66	485	2	1260	\N	0	\N	\N	24	1	2	f	1260	\N	\N
2040	65	485	2	326	\N	0	\N	\N	25	1	2	f	326	\N	\N
2041	22	485	2	315	\N	0	\N	\N	26	1	2	f	315	\N	\N
2042	67	485	2	285	\N	0	\N	\N	27	1	2	f	285	\N	\N
2043	31	485	2	223	\N	0	\N	\N	28	1	2	f	223	\N	\N
2044	30	485	2	65	\N	0	\N	\N	29	1	2	f	65	\N	\N
2045	108	485	2	1	\N	0	\N	\N	30	1	2	f	1	\N	\N
2046	19	485	2	1	\N	0	\N	\N	31	1	2	f	1	\N	\N
2047	45	485	2	59645	\N	0	\N	\N	0	1	2	f	59645	\N	\N
2048	80	485	2	47726	\N	0	\N	\N	0	1	2	f	47726	\N	\N
2049	53	485	2	21838	\N	0	\N	\N	0	1	2	f	21838	\N	\N
2050	10	485	2	21512	\N	0	\N	\N	0	1	2	f	21512	\N	\N
2051	9	485	2	14897	\N	0	\N	\N	0	1	2	f	14897	\N	\N
2052	79	485	2	14206	\N	0	\N	\N	0	1	2	f	14206	\N	\N
2053	54	485	2	7493	\N	0	\N	\N	0	1	2	f	7493	\N	\N
2054	8	485	2	4294	\N	0	\N	\N	0	1	2	f	4294	\N	\N
2055	12	485	2	3944	\N	0	\N	\N	0	1	2	f	3944	\N	\N
2056	46	485	2	3861	\N	0	\N	\N	0	1	2	f	3861	\N	\N
2057	81	485	2	3838	\N	0	\N	\N	0	1	2	f	3838	\N	\N
2058	82	485	2	3561	\N	0	\N	\N	0	1	2	f	3561	\N	\N
2059	49	485	2	3115	\N	0	\N	\N	0	1	2	f	3115	\N	\N
2060	83	485	2	2415	\N	0	\N	\N	0	1	2	f	2415	\N	\N
2061	11	485	2	1643	\N	0	\N	\N	0	1	2	f	1643	\N	\N
2062	84	485	2	1202	\N	0	\N	\N	0	1	2	f	1202	\N	\N
2063	85	485	2	1202	\N	0	\N	\N	0	1	2	f	1202	\N	\N
2064	48	485	2	975	\N	0	\N	\N	0	1	2	f	975	\N	\N
2065	90	485	2	962	\N	0	\N	\N	0	1	2	f	962	\N	\N
2066	47	485	2	534	\N	0	\N	\N	0	1	2	f	534	\N	\N
2067	87	485	2	341	\N	0	\N	\N	0	1	2	f	341	\N	\N
2068	50	485	2	207	\N	0	\N	\N	0	1	2	f	207	\N	\N
2069	13	485	2	139	\N	0	\N	\N	0	1	2	f	139	\N	\N
2070	57	485	2	121	\N	0	\N	\N	0	1	2	f	121	\N	\N
2071	86	485	2	104	\N	0	\N	\N	0	1	2	f	104	\N	\N
2072	51	485	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
2073	52	485	2	39	\N	0	\N	\N	0	1	2	f	39	\N	\N
2074	29	485	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2075	55	486	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
2076	14	487	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2077	55	487	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2078	40	488	2	46	\N	46	\N	\N	1	1	2	f	0	\N	\N
2079	39	488	2	46	\N	46	\N	\N	0	1	2	f	0	\N	\N
2080	2	488	2	46	\N	46	\N	\N	0	1	2	f	0	\N	\N
2081	2	488	1	44	\N	44	\N	\N	1	1	2	f	\N	\N	\N
2082	39	488	1	44	\N	44	\N	\N	0	1	2	f	\N	\N	\N
2083	40	488	1	24	\N	24	\N	\N	0	1	2	f	\N	\N	\N
2084	71	488	1	20	\N	20	\N	\N	0	1	2	f	\N	\N	\N
2085	55	489	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2086	55	490	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2087	19	491	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2088	55	492	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
2089	55	493	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
2090	55	494	2	608	\N	0	\N	\N	1	1	2	f	608	\N	\N
2091	55	495	2	33674	\N	0	\N	\N	1	1	2	f	33674	\N	\N
2092	97	495	2	5	\N	0	\N	\N	2	1	2	f	5	\N	\N
2093	57	495	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2094	37	496	2	3411152	\N	3411152	\N	\N	1	1	2	f	0	\N	\N
2095	1	496	2	1600888	\N	1600888	\N	\N	2	1	2	f	0	\N	\N
2096	88	496	2	1472482	\N	1472482	\N	\N	3	1	2	f	0	\N	\N
2097	77	496	2	1276756	\N	1276756	\N	\N	4	1	2	f	0	\N	\N
2098	42	496	2	392995	\N	392995	\N	\N	5	1	2	f	0	\N	\N
2099	7	496	2	392995	\N	392995	\N	\N	6	1	2	f	0	\N	\N
2100	89	496	2	131176	\N	131176	\N	\N	7	1	2	f	0	\N	\N
2101	91	496	2	58270	\N	58270	\N	\N	8	1	2	f	0	\N	\N
2102	64	496	2	21488	\N	21488	\N	\N	9	1	2	f	0	\N	\N
2103	103	496	2	12550	\N	12550	\N	\N	10	1	2	f	0	\N	\N
2104	66	496	2	2520	\N	2520	\N	\N	11	1	2	f	0	\N	\N
2105	65	496	2	652	\N	652	\N	\N	12	1	2	f	0	\N	\N
2106	22	496	2	630	\N	630	\N	\N	13	1	2	f	0	\N	\N
2107	67	496	2	570	\N	570	\N	\N	14	1	2	f	0	\N	\N
2108	31	496	2	446	\N	446	\N	\N	15	1	2	f	0	\N	\N
2109	30	496	2	130	\N	130	\N	\N	16	1	2	f	0	\N	\N
2110	14	496	1	3994855	\N	3994855	\N	\N	1	1	2	f	\N	\N	\N
2111	76	496	1	3258614	\N	3258614	\N	\N	2	1	2	f	\N	\N	\N
2112	44	496	1	736241	\N	736241	\N	\N	3	1	2	f	\N	\N	\N
2113	53	496	1	2779654	\N	2779654	\N	\N	0	1	2	f	\N	\N	\N
2114	55	496	1	1166637	\N	1166637	\N	\N	0	1	2	f	\N	\N	\N
2115	90	496	1	688449	\N	688449	\N	\N	0	1	2	f	\N	\N	\N
2116	54	496	1	526752	\N	526752	\N	\N	0	1	2	f	\N	\N	\N
2117	80	496	1	386865	\N	386865	\N	\N	0	1	2	f	\N	\N	\N
2118	45	496	1	124357	\N	124357	\N	\N	0	1	2	f	\N	\N	\N
2119	9	496	1	49364	\N	49364	\N	\N	0	1	2	f	\N	\N	\N
2120	10	496	1	49106	\N	49106	\N	\N	0	1	2	f	\N	\N	\N
2121	79	496	1	25140	\N	25140	\N	\N	0	1	2	f	\N	\N	\N
2122	46	496	1	11739	\N	11739	\N	\N	0	1	2	f	\N	\N	\N
2123	8	496	1	10951	\N	10951	\N	\N	0	1	2	f	\N	\N	\N
2124	12	496	1	10585	\N	10585	\N	\N	0	1	2	f	\N	\N	\N
2125	82	496	1	9037	\N	9037	\N	\N	0	1	2	f	\N	\N	\N
2126	83	496	1	8875	\N	8875	\N	\N	0	1	2	f	\N	\N	\N
2127	81	496	1	8058	\N	8058	\N	\N	0	1	2	f	\N	\N	\N
2128	49	496	1	6019	\N	6019	\N	\N	0	1	2	f	\N	\N	\N
2129	84	496	1	5060	\N	5060	\N	\N	0	1	2	f	\N	\N	\N
2130	85	496	1	5060	\N	5060	\N	\N	0	1	2	f	\N	\N	\N
2131	11	496	1	4843	\N	4843	\N	\N	0	1	2	f	\N	\N	\N
2132	48	496	1	2893	\N	2893	\N	\N	0	1	2	f	\N	\N	\N
2133	47	496	1	1887	\N	1887	\N	\N	0	1	2	f	\N	\N	\N
2134	52	496	1	1360	\N	1360	\N	\N	0	1	2	f	\N	\N	\N
2135	87	496	1	763	\N	763	\N	\N	0	1	2	f	\N	\N	\N
2136	13	496	1	718	\N	718	\N	\N	0	1	2	f	\N	\N	\N
2137	50	496	1	487	\N	487	\N	\N	0	1	2	f	\N	\N	\N
2138	86	496	1	200	\N	200	\N	\N	0	1	2	f	\N	\N	\N
2139	51	496	1	143	\N	143	\N	\N	0	1	2	f	\N	\N	\N
2140	29	496	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2141	55	497	2	3024	\N	0	\N	\N	1	1	2	f	3024	\N	\N
2142	55	498	2	7826	\N	0	\N	\N	1	1	2	f	7826	\N	\N
2143	55	499	2	4998	\N	0	\N	\N	1	1	2	f	4998	\N	\N
2144	55	500	2	1793	\N	0	\N	\N	1	1	2	f	1793	\N	\N
2145	55	501	2	110299	\N	0	\N	\N	1	1	2	f	110299	\N	\N
2146	57	501	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2147	68	502	2	49	\N	0	\N	\N	1	1	2	f	49	\N	\N
2148	55	502	2	28	\N	0	\N	\N	2	1	2	f	28	\N	\N
2149	18	502	2	9	\N	0	\N	\N	3	1	2	f	9	\N	\N
2150	70	502	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
2151	104	502	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
2152	69	502	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2153	105	502	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2154	74	502	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2155	109	502	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2156	110	502	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2157	39	503	2	18	\N	0	\N	\N	1	1	2	f	18	\N	\N
2158	19	503	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2159	2	503	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
2160	71	503	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2161	40	503	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2162	55	504	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
2163	97	504	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2164	38	505	2	2393808	\N	2393808	\N	\N	1	1	2	f	0	\N	\N
2165	14	505	2	385203	\N	385203	\N	\N	2	1	2	f	0	\N	\N
2166	76	505	2	314172	\N	314172	\N	\N	3	1	2	f	0	\N	\N
2167	44	505	2	194515	\N	194515	\N	\N	4	1	2	f	0	\N	\N
2168	55	505	2	160009	\N	160009	\N	\N	5	1	2	f	0	\N	\N
2169	3	505	2	52107	\N	52107	\N	\N	6	1	2	f	0	\N	\N
2170	5	505	2	26176	\N	26176	\N	\N	7	1	2	f	0	\N	\N
2171	2	505	2	5	\N	5	\N	\N	8	1	2	f	0	\N	\N
2172	53	505	2	271251	\N	271251	\N	\N	0	1	2	f	0	\N	\N
2173	54	505	2	60769	\N	60769	\N	\N	0	1	2	f	0	\N	\N
2174	45	505	2	59645	\N	59645	\N	\N	0	1	2	f	0	\N	\N
2175	80	505	2	47726	\N	47726	\N	\N	0	1	2	f	0	\N	\N
2176	10	505	2	21512	\N	21512	\N	\N	0	1	2	f	0	\N	\N
2177	90	505	2	15441	\N	15441	\N	\N	0	1	2	f	0	\N	\N
2178	9	505	2	14897	\N	14897	\N	\N	0	1	2	f	0	\N	\N
2179	79	505	2	14206	\N	14206	\N	\N	0	1	2	f	0	\N	\N
2180	8	505	2	4294	\N	4294	\N	\N	0	1	2	f	0	\N	\N
2181	12	505	2	3944	\N	3944	\N	\N	0	1	2	f	0	\N	\N
2182	46	505	2	3861	\N	3861	\N	\N	0	1	2	f	0	\N	\N
2183	81	505	2	3838	\N	3838	\N	\N	0	1	2	f	0	\N	\N
2184	82	505	2	3561	\N	3561	\N	\N	0	1	2	f	0	\N	\N
2185	49	505	2	3115	\N	3115	\N	\N	0	1	2	f	0	\N	\N
2186	83	505	2	2415	\N	2415	\N	\N	0	1	2	f	0	\N	\N
2187	11	505	2	1643	\N	1643	\N	\N	0	1	2	f	0	\N	\N
2188	84	505	2	1202	\N	1202	\N	\N	0	1	2	f	0	\N	\N
2189	85	505	2	1202	\N	1202	\N	\N	0	1	2	f	0	\N	\N
2190	48	505	2	975	\N	975	\N	\N	0	1	2	f	0	\N	\N
2191	47	505	2	534	\N	534	\N	\N	0	1	2	f	0	\N	\N
2192	87	505	2	341	\N	341	\N	\N	0	1	2	f	0	\N	\N
2193	50	505	2	207	\N	207	\N	\N	0	1	2	f	0	\N	\N
2194	57	505	2	186	\N	186	\N	\N	0	1	2	f	0	\N	\N
2195	13	505	2	139	\N	139	\N	\N	0	1	2	f	0	\N	\N
2196	86	505	2	104	\N	104	\N	\N	0	1	2	f	0	\N	\N
2197	51	505	2	52	\N	52	\N	\N	0	1	2	f	0	\N	\N
2198	52	505	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
2199	39	505	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
2200	34	505	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2201	29	505	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2202	76	505	1	104724	\N	104724	\N	\N	1	1	2	f	\N	\N	\N
2203	55	505	1	88084	\N	88084	\N	\N	2	1	2	f	\N	\N	\N
2204	14	505	1	70968	\N	70968	\N	\N	3	1	2	f	\N	\N	\N
2205	5	505	1	26181	\N	26181	\N	\N	4	1	2	f	\N	\N	\N
2206	53	505	1	6464	\N	6464	\N	\N	0	1	2	f	\N	\N	\N
2207	90	505	1	234	\N	234	\N	\N	0	1	2	f	\N	\N	\N
2208	54	505	1	103	\N	103	\N	\N	0	1	2	f	\N	\N	\N
2209	57	505	1	37	\N	37	\N	\N	0	1	2	f	\N	\N	\N
2210	2	506	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
2211	19	506	2	12	\N	12	\N	\N	2	1	2	f	0	\N	\N
2212	39	506	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
2213	71	506	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2214	2	506	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
2215	19	506	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
2216	39	506	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
2217	55	507	2	162	\N	0	\N	\N	1	1	2	f	162	\N	\N
2218	97	507	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2219	94	508	2	6350	\N	0	\N	\N	1	1	2	f	6350	\N	\N
2220	94	509	2	6350	\N	0	\N	\N	1	1	2	f	6350	\N	\N
2221	96	510	2	54	\N	54	\N	\N	1	1	2	f	0	\N	\N
2222	55	510	1	54	\N	54	\N	\N	1	1	2	f	\N	\N	\N
2223	96	511	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2224	55	512	2	453802	\N	453802	\N	\N	1	1	2	f	0	\N	\N
2225	14	512	2	4548	\N	4548	\N	\N	2	1	2	f	0	\N	\N
2226	24	512	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
2227	100	512	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
2228	101	512	2	1	\N	1	\N	\N	5	1	2	f	0	\N	\N
2229	96	512	2	1	\N	1	\N	\N	6	1	2	f	0	\N	\N
2230	57	512	2	309	\N	309	\N	\N	0	1	2	f	0	\N	\N
2231	54	512	2	56	\N	56	\N	\N	0	1	2	f	0	\N	\N
2232	53	512	2	39	\N	39	\N	\N	0	1	2	f	0	\N	\N
2233	90	512	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
2234	13	512	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
2235	97	512	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2236	18	512	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2237	29	512	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2238	51	512	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2239	9	512	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2240	12	512	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2241	50	512	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2242	48	512	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2243	47	512	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
2244	49	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2245	82	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2246	8	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2247	80	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2248	10	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2249	52	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2250	84	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2251	46	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2252	45	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2253	79	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2254	11	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2255	85	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2256	81	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2257	87	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2258	86	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2259	83	512	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2260	55	512	1	274194	\N	274194	\N	\N	1	1	2	f	\N	\N	\N
2261	96	512	1	179556	\N	179556	\N	\N	2	1	2	f	\N	\N	\N
2262	14	512	1	3584	\N	3584	\N	\N	3	1	2	f	\N	\N	\N
2263	97	512	1	5	\N	5	\N	\N	4	1	2	f	\N	\N	\N
2264	57	512	1	1881	\N	1881	\N	\N	0	1	2	f	\N	\N	\N
2265	10	512	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
2266	79	512	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
2267	84	512	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
2268	51	512	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
2269	46	512	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
2270	45	512	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
2271	81	512	1	3	\N	3	\N	\N	0	1	2	f	\N	\N	\N
2272	80	512	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2273	11	512	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2274	85	512	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2275	86	512	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2276	83	512	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2277	50	512	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2278	48	512	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2279	49	512	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2280	55	513	2	603	\N	0	\N	\N	1	1	2	f	603	\N	\N
2281	97	513	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2282	97	514	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2283	55	514	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2284	16	515	2	17	\N	17	\N	\N	1	1	2	f	0	\N	\N
2285	95	515	1	17	\N	17	\N	\N	1	1	2	f	\N	\N	\N
2286	94	516	2	425668	\N	0	\N	\N	1	1	2	f	425668	\N	\N
2287	18	517	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2288	97	517	1	28	\N	28	\N	\N	1	1	2	f	\N	\N	\N
2289	18	517	1	22	\N	22	\N	\N	2	1	2	f	\N	\N	\N
2290	59	517	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2291	63	517	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2292	55	518	2	5405	\N	0	\N	\N	1	1	2	f	5405	\N	\N
2293	97	518	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2294	14	518	2	132	\N	0	\N	\N	0	1	2	f	132	\N	\N
2295	94	519	2	425670	\N	0	\N	\N	1	1	2	f	425670	\N	\N
2296	94	520	2	2806	\N	0	\N	\N	1	1	2	f	2806	\N	\N
2297	94	521	2	6350	\N	0	\N	\N	1	1	2	f	6350	\N	\N
2298	94	522	2	18970	\N	0	\N	\N	1	1	2	f	18970	\N	\N
2299	55	523	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2300	94	524	2	56236	\N	0	\N	\N	1	1	2	f	56236	\N	\N
2301	55	525	2	3951	\N	0	\N	\N	1	1	2	f	3951	\N	\N
2302	55	526	2	45	\N	0	\N	\N	1	1	2	f	45	\N	\N
2303	94	527	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2304	71	528	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
2305	39	528	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2306	2	528	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2307	2	528	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
2308	39	528	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
2309	55	529	2	3750	\N	0	\N	\N	1	1	2	f	3750	\N	\N
2310	97	530	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2311	55	530	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2312	55	531	2	1359	\N	0	\N	\N	1	1	2	f	1359	\N	\N
2313	55	532	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
2314	97	532	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2315	55	533	2	462	\N	0	\N	\N	1	1	2	f	462	\N	\N
2316	97	533	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2317	19	534	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2318	55	535	2	844	\N	0	\N	\N	1	1	2	f	844	\N	\N
2319	57	535	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2320	94	536	2	6350	\N	0	\N	\N	1	1	2	f	6350	\N	\N
2321	44	538	2	778060	\N	778060	\N	\N	1	1	2	f	0	\N	\N
2322	76	538	2	235629	\N	235629	\N	\N	2	1	2	f	0	\N	\N
2323	55	538	2	2757	\N	0	\N	\N	3	1	2	f	2757	\N	\N
2324	39	538	2	18	\N	18	\N	\N	4	1	2	f	0	\N	\N
2325	68	538	2	4	\N	1	\N	\N	5	1	2	f	3	\N	\N
2326	23	538	2	3	\N	3	\N	\N	6	1	2	f	0	\N	\N
2327	27	538	2	1	\N	1	\N	\N	7	1	2	f	0	\N	\N
2328	60	538	2	1	\N	1	\N	\N	8	1	2	f	0	\N	\N
2329	19	538	2	1	\N	0	\N	\N	9	1	2	f	1	\N	\N
2330	45	538	2	238580	\N	238580	\N	\N	0	1	2	f	0	\N	\N
2331	80	538	2	190904	\N	190904	\N	\N	0	1	2	f	0	\N	\N
2332	10	538	2	86048	\N	86048	\N	\N	0	1	2	f	0	\N	\N
2333	9	538	2	59588	\N	59588	\N	\N	0	1	2	f	0	\N	\N
2334	79	538	2	56824	\N	56824	\N	\N	0	1	2	f	0	\N	\N
2335	8	538	2	17176	\N	17176	\N	\N	0	1	2	f	0	\N	\N
2336	12	538	2	15776	\N	15776	\N	\N	0	1	2	f	0	\N	\N
2337	46	538	2	15444	\N	15444	\N	\N	0	1	2	f	0	\N	\N
2338	81	538	2	15352	\N	15352	\N	\N	0	1	2	f	0	\N	\N
2339	82	538	2	14244	\N	14244	\N	\N	0	1	2	f	0	\N	\N
2340	49	538	2	12460	\N	12460	\N	\N	0	1	2	f	0	\N	\N
2341	83	538	2	9660	\N	9660	\N	\N	0	1	2	f	0	\N	\N
2342	11	538	2	6572	\N	6572	\N	\N	0	1	2	f	0	\N	\N
2343	84	538	2	4808	\N	4808	\N	\N	0	1	2	f	0	\N	\N
2344	85	538	2	4808	\N	4808	\N	\N	0	1	2	f	0	\N	\N
2345	48	538	2	3900	\N	3900	\N	\N	0	1	2	f	0	\N	\N
2346	47	538	2	2136	\N	2136	\N	\N	0	1	2	f	0	\N	\N
2347	87	538	2	1364	\N	1364	\N	\N	0	1	2	f	0	\N	\N
2348	50	538	2	828	\N	828	\N	\N	0	1	2	f	0	\N	\N
2349	13	538	2	556	\N	556	\N	\N	0	1	2	f	0	\N	\N
2350	86	538	2	416	\N	416	\N	\N	0	1	2	f	0	\N	\N
2351	51	538	2	208	\N	208	\N	\N	0	1	2	f	0	\N	\N
2352	52	538	2	156	\N	156	\N	\N	0	1	2	f	0	\N	\N
2353	2	538	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
2354	71	538	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2355	29	538	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2356	40	538	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
2357	61	538	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
2358	57	538	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2359	70	538	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
2360	68	538	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
2361	98	539	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2362	55	540	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
2363	55	541	2	76573	\N	0	\N	\N	1	1	2	f	76573	\N	\N
2364	68	541	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
2365	97	541	2	3	\N	0	\N	\N	3	1	2	f	3	\N	\N
2366	14	541	2	11800	\N	0	\N	\N	0	1	2	f	11800	\N	\N
2367	57	541	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2368	104	541	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2369	14	542	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2370	55	542	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2371	55	543	2	88671	\N	0	\N	\N	1	1	2	f	88671	\N	\N
2372	57	543	2	203	\N	0	\N	\N	0	1	2	f	203	\N	\N
2373	83	543	2	11	\N	0	\N	\N	0	1	2	f	11	\N	\N
2374	9	543	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2375	84	543	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2376	46	543	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2377	13	543	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2378	51	543	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
2379	80	543	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
2380	10	543	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
2381	45	543	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
2382	50	543	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
2383	29	543	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2384	82	543	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2385	8	543	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2386	79	543	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2387	48	543	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
2388	49	543	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2389	11	543	2	5	\N	0	\N	\N	0	1	2	f	5	\N	\N
2390	52	543	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2391	85	543	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2392	81	543	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2393	12	543	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2394	87	543	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2395	47	543	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
2396	86	543	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
2397	55	544	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2398	97	544	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2399	55	545	2	9	\N	0	\N	\N	1	1	2	f	9	\N	\N
2400	55	546	2	49	\N	49	\N	\N	1	1	2	f	0	\N	\N
2401	55	547	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
2402	55	547	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
2403	98	548	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2404	2	551	2	14	\N	0	\N	\N	1	1	2	f	14	\N	\N
2405	39	551	2	14	\N	0	\N	\N	0	1	2	f	14	\N	\N
2406	71	551	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2407	40	551	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2408	94	553	2	125330	\N	0	\N	\N	1	1	2	f	125330	\N	\N
2409	60	554	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
2410	19	557	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
2411	92	558	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
2412	15	558	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
2413	55	559	2	176	\N	0	\N	\N	1	1	2	f	176	\N	\N
2414	55	560	2	5	\N	0	\N	\N	1	1	2	f	5	\N	\N
2415	97	560	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2416	19	561	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
2417	55	562	2	708	\N	0	\N	\N	1	1	2	f	708	\N	\N
2418	55	563	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
2419	28	564	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
2420	55	565	2	23	\N	0	\N	\N	1	1	2	f	23	\N	\N
2421	55	566	2	72309	\N	0	\N	\N	1	1	2	f	72309	\N	\N
2422	57	566	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2423	2	567	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
2424	39	567	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
2425	40	567	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2426	55	568	2	94	\N	0	\N	\N	1	1	2	f	94	\N	\N
2427	55	569	2	8985	\N	0	\N	\N	1	1	2	f	8985	\N	\N
2428	71	570	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
2429	39	570	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2430	2	570	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
2431	97	570	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
2432	55	570	1	10	\N	10	\N	\N	0	1	2	f	\N	\N	\N
2433	96	571	2	588	\N	588	\N	\N	1	1	2	f	0	\N	\N
2434	55	571	1	585	\N	585	\N	\N	1	1	2	f	\N	\N	\N
2435	96	571	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
2436	39	572	2	19	\N	0	\N	\N	1	1	2	f	19	\N	\N
2437	98	572	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
2438	2	572	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
2439	71	572	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
2440	40	572	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
2441	55	573	2	4605	\N	0	\N	\N	1	1	2	f	4605	\N	\N
2442	55	574	2	3530	\N	0	\N	\N	1	1	2	f	3530	\N	\N
2443	57	574	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
2444	55	575	2	169	\N	0	\N	\N	1	1	2	f	169	\N	\N
2445	55	576	2	26	\N	0	\N	\N	1	1	2	f	26	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
69		http://www.ebi.ac.uk/efo/	0	t	0
70	sio	http://semanticscience.org/resource/	0	f	0
71	dcmit	http://purl.org/dc/dcmitype/	0	f	0
72	ncit	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#	0	f	0
73	n_1	http://www.w3.org/2001/vcard-rdf/3.0#	0	f	0
74	idot	http://identifiers.org/idot/	0	f	0
75	eco	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#	0	f	0
76	oplacl	http://www.openlinksw.com/ontology/acl#	0	f	0
77	n_2	http://www.openlinksw.com/schemas/VAD#	0	f	0
78	oboinowl	http://www.geneontology.org/formats/oboInOwl#	0	f	0
79	n_3	http://purl.obolibrary.org/obo#	0	f	0
80	pav	http://purl.org/pav/	0	f	0
81	n_4	http://www.openlinksw.com/virtdav#	0	f	0
82	n_5	http://purl.obolibrary.org/obo/mondo#	0	f	0
83	n_6	http://purl.obolibrary.org/obo/ncbitaxon#	0	f	0
84	n_7	http://vocabularies.bridgedb.org/ops#	0	f	0
85	n_8	http://www.drugtargetontology.org/dto/	0	f	0
86	n_9	http://purl.obolibrary.org/obo/hsapdv#	0	f	0
87	cito	http://purl.org/spar/cito/	0	f	0
88	n_10	http://www.co-ode.org/patterns#	0	f	0
89	n_11	http://protege.stanford.edu/plugins/owl/protege#	0	f	0
90	n_12	http://purl.obolibrary.org/obo/uberon/core#	0	f	0
91	wi	http://purl.org/ontology/wi/core#	0	f	0
92	n_13	http://purl.obolibrary.org/obo/uberon#	0	f	0
93	n_14	http://www.orpha.net/ORDO/Orphanet_#	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_rdf_disgenet_org_sparql_	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_rdf_disgenet_org_sparql_	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://rdf.disgenet.org/sparql/	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://rdf.disgenet.org/sparql/", "correlationId": "1102833009475798341", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:36:05.453Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://www.w3.org/ns/dcat#downloadURL	51	\N	15	downloadURL	downloadURL	f	51	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://xmlns.com/foaf/0.1/name	7	\N	8	name	name	f	0	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://xmlns.com/foaf/0.1/page	60	\N	8	page	page	f	59	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://www.ebi.ac.uk/efo/CLO_definition_citation	4	\N	69	CLO_definition_citation	CLO_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://purl.obolibrary.org/obo/creation_date	481	\N	40	creation_date	creation_date	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
6	http://www.geneontology.org/formats/oboInOwl#notes	2	\N	78	notes	notes	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
7	http://purl.obolibrary.org/obo/hasRelatedSynonym	1945	\N	40	hasRelatedSynonym	hasRelatedSynonym	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
8	http://www.ebi.ac.uk/efo/Wikipedia_definition_citation	761	\N	69	Wikipedia_definition_citation	Wikipedia_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://www.ebi.ac.uk/efo/UMLS_definition_citation	2737	\N	69	UMLS_definition_citation	UMLS_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://www.ebi.ac.uk/efo/ANISEED_definition_citation	4	\N	69	ANISEED_definition_citation	ANISEED_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://www.ebi.ac.uk/efo/BM_definition_citation	41	\N	69	BM_definition_citation	BM_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://purl.obolibrary.org/obo#InChIKey	331	\N	79	InChIKey	InChIKey	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://purl.org/dc/elements/1.1/description	20	\N	6	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://www.ontologydesignpatterns.org/ont/dul/DUL.owl#expresses	10	\N	34	expresses	expresses	f	10	\N	\N	f	f	71	55	\N	t	f	\N	\N	\N	t	f	f
19	http://www.w3.org/2002/07/owl#minQualifiedCardinality	23	\N	7	minQualifiedCardinality	minQualifiedCardinality	f	0	\N	\N	f	f	96	\N	\N	t	f	\N	\N	\N	t	f	f
20	http://www.ebi.ac.uk/efo/MONDO_definition_citation	30	\N	69	MONDO_definition_citation	MONDO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
22	http://www.ebi.ac.uk/efo/Beilstein_definition_citation	168	\N	69	Beilstein_definition_citation	Beilstein_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://purl.obolibrary.org/obo/RO_0002161	21	\N	40	RO_0002161	RO_0002161	f	21	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://schema.org/logo	18	\N	9	logo	logo	f	18	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://www.ebi.ac.uk/efo/PMID_definition_citation	781	\N	69	PMID_definition_citation	PMID_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
26	http://purl.org/pav/createdWith	26	\N	80	createdWith	createdWith	f	26	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
31	http://xmlns.com/foaf/0.1/homepage	120827	\N	8	homepage	homepage	f	120776	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
32	http://www.ebi.ac.uk/efo/BAO_definition_citation	3	\N	69	BAO_definition_citation	BAO_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://www.ebi.ac.uk/efo/MP_definition_citation	18	\N	69	MP_definition_citation	MP_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
36	http://www.ebi.ac.uk/efo/EHDAA2_definition_citation	195	\N	69	EHDAA2_definition_citation	EHDAA2_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://www.geneontology.org/formats/oboInOwl#creation_date	7173	\N	78	creation_date	creation_date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://purl.org/pav/lastUpdateOn	1	\N	80	lastUpdateOn	lastUpdateOn	f	0	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
42	http://www.ebi.ac.uk/efo/galen_definition_citation	132	\N	69	galen_definition_citation	galen_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://purl.obolibrary.org/obo/IAO_created_by	8	\N	40	IAO_created_by	IAO_created_by	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
44	http://www.ebi.ac.uk/efo/definition_citation	11753	\N	69	definition_citation	definition_citation	f	102	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://www.ebi.ac.uk/efo/branch_class	13	\N	69	branch_class	branch_class	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
46	http://www.w3.org/ns/dcat#landingPage	18	\N	15	landingPage	landingPage	f	18	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://www.ebi.ac.uk/efo/OGES_definition_citation	12	\N	69	OGES_definition_citation	OGES_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://purl.obolibrary.org/obo/RO_0002174	6	\N	40	[dubious_for_taxon (RO_0002174)]	RO_0002174	f	6	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://purl.obolibrary.org/obo/UBPROP_0000101	1	\N	40	[preceding element is (UBPROP_0000101)]	UBPROP_0000101	f	1	\N	\N	f	f	97	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://semanticscience.org/resource/SIO_000253	4780845	\N	70	[has source (SIO_000253)]	SIO_000253	f	4780845	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
27	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P90	385339	\N	72	[FULL_SYN (P90)]	P90	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://purl.obolibrary.org/obo/UBPROP_0000111	8	\N	40	[rhombomere number (UBPROP_0000111)]	UBPROP_0000111	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://semanticscience.org/resource/SIO_000008	112	\N	70	[has_quality (SIO_000008)]	SIO_000008	f	112	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P93	4499	\N	72	[Swiss_Prot (P93)]	P93	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P92	1261	\N	72	[Subsource (P92)]	P92	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P98	10074	\N	72	[DesignNote (P98)]	P98	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P97	91637	\N	72	[DEFINITION (P97)]	P97	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
40	http://semanticscience.org/resource/SIO_000223	785990	\N	70	[has property (SIO_000223)]	SIO_000223	f	785990	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
50	http://purl.org/pav/createdBy	25	\N	80	createdBy	createdBy	f	25	\N	\N	f	f	\N	107	\N	t	f	\N	\N	\N	t	f	f
52	http://purl.obolibrary.org/obo/UBPROP_0000003	195	\N	40	UBPROP_0000003	UBPROP_0000003	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
240	http://www.w3.org/2001/vcard-rdf/3.0#Pcode	2	\N	73	Pcode	Pcode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
53	http://purl.obolibrary.org/obo/UBPROP_0000002	38	\N	40	UBPROP_0000002	UBPROP_0000002	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://www.ebi.ac.uk/efo/Reaxys_definition_citation	176	\N	69	Reaxys_definition_citation	Reaxys_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
55	http://www.geneontology.org/formats/oboInOwl#taxon	2	\N	78	taxon	taxon	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
56	http://purl.obolibrary.org/obo/UBPROP_0000001	352	\N	40	UBPROP_0000001	UBPROP_0000001	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://www.w3.org/2004/02/skos/core#broadMatch	3426	\N	4	broadMatch	broadMatch	f	3426	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
59	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	1025	\N	2	subPropertyOf	subPropertyOf	f	1025	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
60	http://www.w3.org/2004/02/skos/core#notation	9125	\N	4	notation	notation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
62	http://www.ebi.ac.uk/efo/PRO_definition_citation	2	\N	69	PRO_definition_citation	PRO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
63	http://www.w3.org/2002/07/owl#deprecated	8221	\N	7	deprecated	deprecated	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
64	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	261098	\N	1	first	first	f	260770	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
65	http://www.openlinksw.com/schemas/VAD#versionNumber	1	\N	77	versionNumber	versionNumber	f	0	\N	\N	f	f	98	\N	\N	t	f	\N	\N	\N	t	f	f
66	http://www.ebi.ac.uk/efo/VO_definition_citation	1	\N	69	VO_definition_citation	VO_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://purl.org/dc/terms/format	74	\N	5	format	format	f	70	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://www.ebi.ac.uk/efo/organizational_class	1325	\N	69	organizational_class	organizational_class	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
69	http://www.openlinksw.com/virtdav#dynRdfExtractor	1	\N	81	dynRdfExtractor	dynRdfExtractor	f	0	\N	\N	f	f	98	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://www.ebi.ac.uk/efo/BFO_definition_citation	2	\N	69	BFO_definition_citation	BFO_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
71	http://www.ebi.ac.uk/efo/FAO_definition_citation	2	\N	69	FAO_definition_citation	FAO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
72	http://www.geneontology.org/formats/oboInOwl#url	3	\N	78	url	url	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://purl.org/dc/terms/extent	987	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
75	http://www.ebi.ac.uk/efo/HsapDv_definition_citation	4	\N	69	HsapDv_definition_citation	HsapDv_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://purl.obolibrary.org/obo/IAO_creation_date	8	\N	40	IAO_creation_date	IAO_creation_date	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://purl.obolibrary.org/obo/UBPROP_0000012	7	\N	40	UBPROP_0000012	UBPROP_0000012	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://www.ebi.ac.uk/efo/EMAPA_definition_citation	446	\N	69	EMAPA_definition_citation	EMAPA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://www.geneontology.org/formats/oboInOwl#hasAlternativeId	5725	\N	78	hasAlternativeId	hasAlternativeId	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
80	http://rdfs.org/ns/void#distinctSubjects	2	\N	16	distinctSubjects	distinctSubjects	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
81	http://rdfs.org/ns/void#exampleResource	26	\N	16	exampleResource	exampleResource	f	26	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://purl.obolibrary.org/obo/UBPROP_0000010	2	\N	40	UBPROP_0000010	UBPROP_0000010	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
83	http://purl.org/dc/elements/1.1/title	2	\N	6	title	title	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
84	http://www.w3.org/2001/vcard-rdf/3.0#EMAIL	2	\N	73	EMAIL	EMAIL	f	2	\N	\N	f	f	\N	93	\N	t	f	\N	\N	\N	t	f	f
85	http://purl.org/goodrelations/v1#amountOfThisGood	3	\N	36	amountOfThisGood	amountOfThisGood	f	0	\N	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
86	http://www.ebi.ac.uk/efo/NIFSTD_definition_citation	139	\N	69	NIFSTD_definition_citation	NIFSTD_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://www.ebi.ac.uk/efo/FBbt_definition_citation	270	\N	69	FBbt_definition_citation	FBbt_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
89	http://www.geneontology.org/formats/oboInOwl#hasSynonymType	12196	\N	78	hasSynonymType	hasSynonymType	f	12196	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://www.ebi.ac.uk/efo/EV_definition_citation	310	\N	69	EV_definition_citation	EV_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
91	http://www.ebi.ac.uk/efo/NCI_Metathesaurus_definition_citation	13	\N	69	NCI_Metathesaurus_definition_citation	NCI_Metathesaurus_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://www.geneontology.org/formats/oboInOwl#default-namespace	4	\N	78	default-namespace	default-namespace	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://semanticscience.org/resource/example	68	\N	70	example	example	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://purl.obolibrary.org/obo/UBPROP_0000008	21	\N	40	[taxon_notes (UBPROP_0000008)]	UBPROP_0000008	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://purl.obolibrary.org/obo/UBPROP_0000007	128	\N	40	[has_relational_adjective (UBPROP_0000007)]	UBPROP_0000007	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://purl.obolibrary.org/obo/IAO_0000412	4268	\N	40	[imported from (IAO_0000412)]	IAO_0000412	f	4267	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://semanticscience.org/resource/SIO_000216	4436247	\N	70	[has measurement value (SIO_000216)]	SIO_000216	f	4436247	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
61	http://purl.obolibrary.org/obo/IAO_0100001	2650	\N	40	[term replaced by (IAO_0100001)]	IAO_0100001	f	65	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://purl.obolibrary.org/obo/IAO_0000425	2	\N	40	[expand assertion to (IAO_0000425)]	IAO_0000425	f	0	\N	\N	f	f	97	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P310	4639	\N	72	[Concept_Status (P310)]	P310	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
94	http://www.ebi.ac.uk/efo/KEGG_COMPOUND_definition_citation	352	\N	69	KEGG_COMPOUND_definition_citation	KEGG_COMPOUND_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
95	http://www.ebi.ac.uk/efo/DOID_definition_citation	2005	\N	69	DOID_definition_citation	DOID_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://www.w3.org/2000/01/rdf-schema#isDescribedUsing	2	\N	2	isDescribedUsing	isDescribedUsing	f	2	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://www.w3.org/2002/07/owl#qualifiedCardinality	30	\N	7	qualifiedCardinality	qualifiedCardinality	f	0	\N	\N	f	f	96	\N	\N	t	f	\N	\N	\N	t	f	f
98	http://www.geneontology.org/formats/oboInOwl#id	49734	\N	78	id	id	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
99	http://www.ebi.ac.uk/efo/NIF_GrossAnatomy_definition_citation	88	\N	69	NIF_GrossAnatomy_definition_citation	NIF_GrossAnatomy_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://www.ebi.ac.uk/efo/RGD_definition_citation	15	\N	69	RGD_definition_citation	RGD_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
102	http://www.ebi.ac.uk/efo/WebElements_definition_citation	6	\N	69	WebElements_definition_citation	WebElements_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
103	http://purl.org/goodrelations/v1#includesObject	3	\N	36	includesObject	includesObject	f	3	\N	\N	f	f	60	25	\N	t	f	\N	\N	\N	t	f	f
104	http://schema.org/comment	8	\N	9	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://purl.org/dc/terms/conformsTo	18	\N	5	conformsTo	conformsTo	f	18	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://www.openlinksw.com/schemas/VAD#versionBuild	1	\N	77	versionBuild	versionBuild	f	0	\N	\N	f	f	98	\N	\N	t	f	\N	\N	\N	t	f	f
110	http://www.w3.org/ns/dcat#accessURL	22	\N	15	accessURL	accessURL	f	22	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://www.ebi.ac.uk/efo/DSSTox_CID_definition_citation	5	\N	69	DSSTox_CID_definition_citation	DSSTox_CID_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://rdfs.org/ns/void#inDataset	5087465	\N	16	inDataset	inDataset	f	5087465	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://semanticscience.org/resource/seeAlso	117	\N	70	seeAlso	seeAlso	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://www.ebi.ac.uk/efo/gwas_trait	2199	\N	69	gwas_trait	gwas_trait	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
115	http://purl.org/goodrelations/v1#acceptedPaymentMethods	18	\N	36	acceptedPaymentMethods	acceptedPaymentMethods	f	18	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
116	http://purl.obolibrary.org/obo#InChI	332	\N	79	InChI	InChI	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
118	http://www.ebi.ac.uk/efo/DSSTox_Generic_SID_definition_citation	20	\N	69	DSSTox_Generic_SID_definition_citation	DSSTox_Generic_SID_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
121	http://identifiers.org/idot/primarySource	2	\N	74	primarySource	primarySource	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
123	http://www.ebi.ac.uk/efo/CASRN_definition_citation	19	\N	69	CASRN_definition_citation	CASRN_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
126	http://www.ebi.ac.uk/efo/bioportal_provenance	12283	\N	69	bioportal_provenance	bioportal_provenance	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
128	http://www.ebi.ac.uk/efo/WBls_definition_citation	33	\N	69	WBls_definition_citation	WBls_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
129	http://purl.org/dc/elements/1.1/subject	1	\N	6	subject	subject	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
130	http://www.w3.org/2002/07/owl#intersectionOf	86206	\N	7	intersectionOf	intersectionOf	f	86206	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
131	http://www.geneontology.org/formats/oboInOwl#auto-generated-by	2	\N	78	auto-generated-by	auto-generated-by	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
132	http://www.geneontology.org/formats/oboInOwl#shorthand	108	\N	78	shorthand	shorthand	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
133	http://purl.obolibrary.org/obo/inSubset	659	\N	40	inSubset	inSubset	f	659	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
134	http://www.ebi.ac.uk/efo/TO_definition_citation	2	\N	69	TO_definition_citation	TO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
135	http://purl.org/goodrelations/v1#hasBusinessFunction	6	\N	36	hasBusinessFunction	hasBusinessFunction	f	6	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
136	http://www.openlinksw.com/schemas/VAD#packageName	1	\N	77	packageName	packageName	f	0	\N	\N	f	f	98	\N	\N	t	f	\N	\N	\N	t	f	f
137	http://www.ebi.ac.uk/efo/CARO_definition_citation	4	\N	69	CARO_definition_citation	CARO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
138	http://www.ebi.ac.uk/efo/DrerDO_definition_citation	2	\N	69	DrerDO_definition_citation	DrerDO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
139	http://purl.obolibrary.org/obo/UBPROP_0000202	7	\N	40	UBPROP_0000202	UBPROP_0000202	f	7	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
101	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P315	136	\N	72	[SNP_ID (P315)]	P315	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
106	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P317	1779	\N	72	[FDA_Table (P317)]	P317	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
107	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P316	1	\N	72	[Relative_Enzyme_Activity (P316)]	P316	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
117	http://purl.obolibrary.org/obo/IAO_0000600	10	\N	40	[elucidation (IAO_0000600)]	IAO_0000600	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
119	http://purl.obolibrary.org/obo/IAO_0000601	1	\N	40	[has associated axiom(nl) (IAO_0000601)]	IAO_0000601	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
120	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P303	825	\N	72	[In_Clinical_Trial_For (P303)]	P303	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
124	http://semanticscience.org/resource/SIO_000205	26181	\N	70	[is represented by (SIO_000205)]	SIO_000205	f	26181	\N	\N	f	f	76	5	\N	t	f	\N	\N	\N	t	f	f
125	http://semanticscience.org/resource/SIO_000300	3127021	\N	70	[has value (SIO_000300)]	SIO_000300	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
127	http://purl.obolibrary.org/obo/IAO_0000602	3	\N	40	[has associated axiom(fol) (IAO_0000602)]	IAO_0000602	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://xmlns.com/foaf/0.1/mbox	6	\N	8	mbox	mbox	f	6	\N	\N	f	f	107	\N	\N	t	f	\N	\N	\N	t	f	f
142	http://purl.obolibrary.org/obo/mondo#excluded_synonym	7	\N	82	excluded_synonym	excluded_synonym	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
143	http://purl.obolibrary.org/obo/SO_associated_with	333088	\N	40	SO_associated_with	SO_associated_with	f	333088	\N	\N	f	f	44	76	\N	t	f	\N	\N	\N	t	f	f
144	http://www.ebi.ac.uk/efo/CMO_definition_citation	16	\N	69	CMO_definition_citation	CMO_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
145	http://purl.org/pav/importedOn	16	\N	80	importedOn	importedOn	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
146	http://www.geneontology.org/formats/oboInOwl#is_class_level	5	\N	78	is_class_level	is_class_level	f	0	\N	\N	f	f	97	\N	\N	t	f	\N	\N	\N	t	f	f
147	http://www.ebi.ac.uk/efo/MmusDv_definition_citation	7	\N	69	MmusDv_definition_citation	MmusDv_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
148	http://semanticscience.org/resource/similarTo	3	\N	70	similarTo	similarTo	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
149	http://www.geneontology.org/formats/oboInOwl#is_inferred	756	\N	78	is_inferred	is_inferred	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
150	http://purl.org/dc/terms/hasPart	26	\N	5	hasPart	hasPart	f	26	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
151	http://www.ebi.ac.uk/efo/NIST_Chemistry_WebBook_definition_citation	122	\N	69	NIST_Chemistry_WebBook_definition_citation	NIST_Chemistry_WebBook_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
152	http://www.w3.org/ns/dcat#theme	36	\N	15	theme	theme	f	36	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
153	http://rdfs.org/ns/void#vocabulary	36	\N	16	vocabulary	vocabulary	f	36	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
154	http://www.ebi.ac.uk/efo/DrugBank_definition_citation	125	\N	69	DrugBank_definition_citation	DrugBank_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
155	http://purl.org/goodrelations/v1#hasUnitOfMeasurement	3	\N	36	hasUnitOfMeasurement	hasUnitOfMeasurement	f	0	\N	\N	f	f	25	\N	\N	t	f	\N	\N	\N	t	f	f
156	http://www.w3.org/2002/07/owl#inverseOf	128	\N	7	inverseOf	inverseOf	f	128	\N	\N	f	f	68	68	\N	t	f	\N	\N	\N	t	f	f
157	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#required	13	\N	72	required	required	f	0	\N	\N	f	f	97	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	261098	\N	1	rest	rest	f	261098	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
161	http://www.ebi.ac.uk/efo/MO_definition_citation	221	\N	69	MO_definition_citation	MO_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
163	http://www.ebi.ac.uk/efo/ChemIDplus_definition_citation	335	\N	69	ChemIDplus_definition_citation	ChemIDplus_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
166	http://purl.obolibrary.org/obo/ECO_0000218	84072	\N	40	ECO_0000218	ECO_0000218	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
168	http://purl.obolibrary.org/obo/IAO_0000231	69	\N	40	IAO_0000231	IAO_0000231	f	65	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
169	http://www.ebi.ac.uk/efo/COMe_definition_citation	3	\N	69	COMe_definition_citation	COMe_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
172	http://www.ebi.ac.uk/efo/MolBase_definition_citation	4	\N	69	MolBase_definition_citation	MolBase_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
173	http://purl.obolibrary.org/obo/hasExactSynonym	4014	\N	40	hasExactSynonym	hasExactSynonym	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
174	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	187	\N	2	isDefinedBy	isDefinedBy	f	150	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
178	http://www.ebi.ac.uk/efo/RESID_definition_citation	4	\N	69	RESID_definition_citation	RESID_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
179	http://www.geneontology.org/formats/oboInOwl#saved-by	4	\N	78	saved-by	saved-by	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
180	http://www.w3.org/2002/07/owl#propertyChainAxiom	36	\N	7	propertyChainAxiom	propertyChainAxiom	f	36	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
181	http://www.ebi.ac.uk/efo/BILA_definition_citation	27	\N	69	BILA_definition_citation	BILA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
182	http://www.ebi.ac.uk/efo/EHDAA2_RETIRED_definition_citation	4	\N	69	EHDAA2_RETIRED_definition_citation	EHDAA2_RETIRED_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
183	http://www.w3.org/2002/07/owl#disjointWith	390	\N	7	disjointWith	disjointWith	f	390	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
184	http://www.w3.org/ns/sparql-service-description#feature	3	\N	27	feature	feature	f	3	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
185	http://www.ebi.ac.uk/efo/STRUCTURE_Formula_definition_citation	3	\N	69	STRUCTURE_Formula_definition_citation	STRUCTURE_Formula_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
186	http://www.ebi.ac.uk/efo/ATCC_definition_citation	40	\N	69	ATCC_definition_citation	ATCC_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
159	http://purl.obolibrary.org/obo/IAO_0000116	92	\N	40	[editor note (IAO_0000116)]	IAO_0000116	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
160	http://purl.obolibrary.org/obo/IAO_0000117	12443	\N	40	[term editor (IAO_0000117)]	IAO_0000117	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
162	http://purl.obolibrary.org/obo/IAO_0000114	28	\N	40	[has curation status (IAO_0000114)]	IAO_0000114	f	26	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
164	http://purl.obolibrary.org/obo/IAO_0000115	50518	\N	40	[definition (IAO_0000115)]	IAO_0000115	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
165	http://purl.obolibrary.org/obo/IAO_0000112	159	\N	40	[example of usage (IAO_0000112)]	IAO_0000112	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
170	http://purl.obolibrary.org/obo/IAO_0000232	6	\N	40	[curator note (IAO_0000232)]	IAO_0000232	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
171	http://purl.obolibrary.org/obo/IAO_0000111	1	\N	40	[editor preferred term (IAO_0000111)]	IAO_0000111	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
175	http://purl.obolibrary.org/obo/IAO_0000118	187	\N	40	[alternative term (IAO_0000118)]	IAO_0000118	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
176	http://purl.obolibrary.org/obo/IAO_0000119	10	\N	40	[definition source (IAO_0000119)]	IAO_0000119	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
177	http://semanticscience.org/resource/SIO_000095	8319	\N	70	[is member of (SIO_000095)]	SIO_000095	f	8319	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
187	http://www.w3.org/2002/07/owl#unionOf	2233	\N	7	unionOf	unionOf	f	2233	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
188	http://www.ebi.ac.uk/efo/ChEMBL_definition_citation	261	\N	69	ChEMBL_definition_citation	ChEMBL_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
189	http://www.w3.org/2002/07/owl#versionInfo	9	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
190	http://www.ebi.ac.uk/efo/OMIM_definition_citation	7360	\N	69	OMIM_definition_citation	OMIM_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
191	http://www.ebi.ac.uk/efo/Coriell_definition_citation	4	\N	69	Coriell_definition_citation	Coriell_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
192	http://purl.obolibrary.org/obo/namespace	7	\N	40	namespace	namespace	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
193	http://www.ebi.ac.uk/efo/AAO_definition_citation	218	\N	69	AAO_definition_citation	AAO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
194	http://www.ebi.ac.uk/efo/MetaCyc_definition_citation	14	\N	69	MetaCyc_definition_citation	MetaCyc_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
196	http://purl.org/goodrelations/v1#eligibleRegions	738	\N	36	eligibleRegions	eligibleRegions	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
197	http://purl.org/goodrelations/v1#availableAtOrFrom	3	\N	36	availableAtOrFrom	availableAtOrFrom	f	3	\N	\N	f	f	60	99	\N	t	f	\N	\N	\N	t	f	f
198	http://www.openlinksw.com/schemas/VAD#packageTitle	1	\N	77	packageTitle	packageTitle	f	0	\N	\N	f	f	98	\N	\N	t	f	\N	\N	\N	t	f	f
199	http://purl.obolibrary.org/obo/mondo#RELARED	1	\N	82	RELARED	RELARED	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
200	http://www.geneontology.org/formats/oboInOwl#hasOBONamespace	25751	\N	78	hasOBONamespace	hasOBONamespace	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
201	http://www.ebi.ac.uk/efo/XAO_definition_citation	287	\N	69	XAO_definition_citation	XAO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
202	http://purl.obolibrary.org/obo/ncbitaxon#has_rank	1163	\N	83	has_rank	has_rank	f	1162	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
203	http://xmlns.com/foaf/0.1/logo	1	\N	8	logo	logo	f	1	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
204	http://www.ebi.ac.uk/efo/SPD_definition_citation	2	\N	69	SPD_definition_citation	SPD_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
205	http://rdfs.org/ns/void#uriRegexPattern	26	\N	16	uriRegexPattern	uriRegexPattern	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
206	http://www.ebi.ac.uk/efo/HP_definition_citation	45	\N	69	HP_definition_citation	HP_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
207	http://rdfs.org/ns/void#properties	2	\N	16	properties	properties	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
208	http://www.ebi.ac.uk/efo/KUPO_definition_citation	2	\N	69	KUPO_definition_citation	KUPO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
209	http://www.ebi.ac.uk/efo/Gmelin_definition_citation	71	\N	69	Gmelin_definition_citation	Gmelin_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
210	http://www.w3.org/ns/sparql-service-description#supportedLanguage	2	\N	27	supportedLanguage	supportedLanguage	f	2	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
211	http://purl.org/goodrelations/v1#includes	2	\N	36	includes	includes	f	2	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
212	http://vocabularies.bridgedb.org/ops#objectsDatatype	10	\N	84	objectsDatatype	objectsDatatype	f	10	\N	\N	f	f	71	55	\N	t	f	\N	\N	\N	t	f	f
213	http://www.geneontology.org/formats/oboInOwl#severity	1	\N	78	severity	severity	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
214	http://purl.org/dc/elements/1.1/creator	1615	\N	6	creator	creator	f	29	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
215	http://www.ebi.ac.uk/efo/MSH_definition_citation	5210	\N	69	MSH_definition_citation	MSH_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
216	http://purl.org/dc/terms/issued	797958	\N	5	issued	issued	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
217	http://purl.org/dc/terms/description	3704679	\N	5	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
218	http://purl.obolibrary.org/obo/format-version	1	\N	40	format-version	format-version	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
219	http://www.ebi.ac.uk/efo/OAE_definition_citation	1	\N	69	OAE_definition_citation	OAE_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
220	http://www.ebi.ac.uk/efo/EFO_definition_citation	432	\N	69	EFO_definition_citation	EFO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
221	http://identifiers.org/idot/accessIdentifierPattern	20	\N	74	accessIdentifierPattern	accessIdentifierPattern	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
222	http://www.w3.org/2002/07/owl#annotatedSource	996110	\N	7	annotatedSource	annotatedSource	f	996110	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
223	http://www.ebi.ac.uk/efo/VSAO_definition_citation	18	\N	69	VSAO_definition_citation	VSAO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
224	http://purl.obolibrary.org/obo/IAO_subset	19	\N	40	IAO_subset	IAO_subset	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
225	http://www.ebi.ac.uk/efo/BIRNLEX_definition_citation	9	\N	69	BIRNLEX_definition_citation	BIRNLEX_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
226	http://www.geneontology.org/formats/oboInOwl#inSubset	16729	\N	78	inSubset	inSubset	f	16729	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
227	http://rdfs.org/ns/void#dataDump	26	\N	16	dataDump	dataDump	f	26	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
228	http://www.ebi.ac.uk/efo/Patent_definition_citation	201	\N	69	Patent_definition_citation	Patent_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
229	http://purl.obolibrary.org/obo/hasAlternativeId	817	\N	40	hasAlternativeId	hasAlternativeId	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
230	http://www.w3.org/2000/01/rdf-schema#range	400	\N	2	range	range	f	400	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
231	http://purl.obolibrary.org/obo/hasDbXref	17860	\N	40	hasDbXref	hasDbXref	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
232	http://www.ebi.ac.uk/efo/creator	13	\N	69	creator	creator	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
195	http://semanticscience.org/resource/SIO_000061	194515	\N	70	[is located in (SIO_000061)]	SIO_000061	f	194515	\N	\N	f	f	44	6	\N	t	f	\N	\N	\N	t	f	f
233	http://www.drugtargetontology.org/dto/uniprot_xref	9230	\N	85	uniprot_xref	uniprot_xref	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
234	http://www.w3.org/ns/prov#wasGeneratedBy	13	\N	26	wasGeneratedBy	wasGeneratedBy	f	13	\N	\N	f	f	2	55	\N	t	f	\N	\N	\N	t	f	f
235	http://www.ebi.ac.uk/efo/GOC_definition_citation	4	\N	69	GOC_definition_citation	GOC_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
236	http://www.ebi.ac.uk/efo/NIF_GrossAnatomy_RETIRED_definition_citation	3	\N	69	NIF_GrossAnatomy_RETIRED_definition_citation	NIF_GrossAnatomy_RETIRED_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
237	http://www.ebi.ac.uk/efo/HBA_definition_citation	3	\N	69	HBA_definition_citation	HBA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
238	http://www.ebi.ac.uk/efo/GO_definition_citation	17	\N	69	GO_definition_citation	GO_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
239	http://www.geneontology.org/formats/oboInOwl#created_by	7444	\N	78	created_by	created_by	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
241	http://purl.obolibrary.org/obo/hsapdv#editor_notes	1	\N	86	editor_notes	editor_notes	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
242	http://purl.org/dc/terms/publisher	75	\N	5	publisher	publisher	f	75	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
243	http://www.ebi.ac.uk/efo/UBERON_definition_citation	5	\N	69	UBERON_definition_citation	UBERON_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
244	http://purl.org/pav/authoredOn	18	\N	80	authoredOn	authoredOn	f	0	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
245	http://www.ebi.ac.uk/efo/reason_for_obsolescence	2580	\N	69	reason_for_obsolescence	reason_for_obsolescence	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
246	http://www.ebi.ac.uk/efo/SAEL_definition_citation	111	\N	69	SAEL_definition_citation	SAEL_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
247	http://www.ebi.ac.uk/efo/MAP_definition_citation	3	\N	69	MAP_definition_citation	MAP_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
251	http://www.ebi.ac.uk/efo/obsoleted_in_version	1212	\N	69	obsoleted_in_version	obsoleted_in_version	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
255	http://www.ebi.ac.uk/efo/PERSON_definition_citation	6	\N	69	PERSON_definition_citation	PERSON_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
256	http://www.ebi.ac.uk/efo/NCI_Thesaurus_definition_citation	3972	\N	69	NCI_Thesaurus_definition_citation	NCI_Thesaurus_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
258	http://www.ebi.ac.uk/efo/ORDO_definition_citation	121	\N	69	ORDO_definition_citation	ORDO_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
260	http://www.w3.org/2001/vcard-rdf/3.0#City	2	\N	73	City	City	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
262	http://www.w3.org/2002/07/owl#imports	31	\N	7	imports	imports	f	31	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
263	http://www.geneontology.org/formats/oboInOwl#hasDbXref	372254	\N	78	hasDbXref	hasDbXref	f	188	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
265	http://purl.org/dc/terms/date	3702959	\N	5	date	date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
266	http://vocabularies.bridgedb.org/ops#subjectsDatatype	10	\N	84	subjectsDatatype	subjectsDatatype	f	10	\N	\N	f	f	71	55	\N	t	f	\N	\N	\N	t	f	f
267	http://www.ebi.ac.uk/efo/EMAPA_RETIRED_definition_citation	2	\N	69	EMAPA_RETIRED_definition_citation	EMAPA_RETIRED_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
268	http://www.openlinksw.com/schemas/VAD#releaseDate	1	\N	77	releaseDate	releaseDate	f	0	\N	\N	f	f	98	\N	\N	t	f	\N	\N	\N	t	f	f
269	http://www.ebi.ac.uk/efo/RETIRED_EHDAA2_definition_citation	18	\N	69	RETIRED_EHDAA2_definition_citation	RETIRED_EHDAA2_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
270	http://www.w3.org/2002/07/owl#annotatedProperty	995369	\N	7	annotatedProperty	annotatedProperty	f	995369	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
272	http://www.ebi.ac.uk/efo/PDB_definition_citation	2	\N	69	PDB_definition_citation	PDB_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
273	http://www.ebi.ac.uk/efo/WBbt_definition_citation	58	\N	69	WBbt_definition_citation	WBbt_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
274	http://www.drugtargetontology.org/dto/geneSynonym	3727	\N	85	geneSynonym	geneSynonym	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
275	http://www.ebi.ac.uk/efo/TADS_definition_citation	44	\N	69	TADS_definition_citation	TADS_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
276	http://purl.org/spar/cito/citesAsAuthority	23	\N	87	citesAsAuthority	citesAsAuthority	f	20	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
277	http://xmlns.com/foaf/0.1/primaryTopic	8	\N	8	primaryTopic	primaryTopic	f	8	\N	\N	f	f	106	39	\N	t	f	\N	\N	\N	t	f	f
371	http://www.w3.org/ns/prov#wasDerivedFrom	103	\N	26	wasDerivedFrom	wasDerivedFrom	f	103	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
249	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A7	463	\N	72	[Has_Target (A7)]	A7	f	463	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
250	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A6	1805	\N	72	[Has_Free_Acid_Or_Base_Form (A6)]	A6	f	1805	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
252	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A5	1809	\N	72	[Has_Salt_Form (A5)]	A5	f	1809	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
253	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A9	23	\N	72	[Is_Related_To_Endogenous_Product (A9)]	A9	f	23	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
257	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A4	1	\N	72	[Qualifier_Applies_To (A4)]	A4	f	1	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
261	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A2	97	\N	72	[Role_Has_Range (A2)]	A2	f	97	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
264	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A1	97	\N	72	[Role_Has_Domain (A1)]	A1	f	97	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
271	http://semanticscience.org/resource/SIO_010078	17665	\N	70	[encodes (SIO_010078)]	SIO_010078	f	17665	\N	\N	f	f	76	3	\N	t	f	\N	\N	\N	t	f	f
324	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P175	2367	\N	72	[NSC_Code (P175)]	P175	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
278	http://www.ebi.ac.uk/efo/SNOMEDCT_definition_citation	3736	\N	69	SNOMEDCT_definition_citation	SNOMEDCT_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
279	http://purl.obolibrary.org/obo/GENO_0000834	9	\N	40	GENO_0000834	GENO_0000834	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
280	http://www.w3.org/2001/XMLSchema#maxInclusive	1	\N	3	maxInclusive	maxInclusive	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
281	http://purl.org/goodrelations/v1#legalName	1	\N	36	legalName	legalName	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
282	http://purl.obolibrary.org/obo/mondo#excluded_subClassOf	408	\N	82	excluded_subClassOf	excluded_subClassOf	f	408	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
283	http://purl.org/dc/terms/license	59	\N	5	license	license	f	58	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
284	http://purl.obolibrary.org/obo/HP_0040005	13	\N	40	HP_0040005	HP_0040005	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
285	http://www.geneontology.org/formats/oboInOwl#is_metadata_tag	19	\N	78	is_metadata_tag	is_metadata_tag	f	0	\N	\N	f	f	97	\N	\N	t	f	\N	\N	\N	t	f	f
286	http://www.w3.org/2002/07/owl#onProperty	421281	\N	7	onProperty	onProperty	f	421281	\N	\N	f	f	96	\N	\N	t	f	\N	\N	\N	t	f	f
287	http://purl.obolibrary.org/obo/created_by	481	\N	40	created_by	created_by	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
288	http://www.w3.org/ns/dcat#distribution	6	\N	15	distribution	distribution	f	6	\N	\N	f	f	39	2	\N	t	f	\N	\N	\N	t	f	f
289	http://www.co-ode.org/patterns#createdBy	28141	\N	88	createdBy	createdBy	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
290	http://www.ebi.ac.uk/efo/ABA_definition_citation	30	\N	69	ABA_definition_citation	ABA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
291	http://purl.org/dc/elements/1.1/alternativeName	1	\N	6	alternativeName	alternativeName	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
292	http://www.ebi.ac.uk/efo/CALOHA_definition_citation	231	\N	69	CALOHA_definition_citation	CALOHA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
293	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#default	3	\N	72	default	default	f	0	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
294	http://purl.obolibrary.org/obo/ECO_0000205	39842	\N	40	ECO_0000205	ECO_0000205	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
295	http://www.w3.org/ns/sparql-service-description#endpoint	2	\N	27	endpoint	endpoint	f	2	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
296	http://www.ebi.ac.uk/efo/MFO_definition_citation	46	\N	69	MFO_definition_citation	MFO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
297	http://www.w3.org/2002/07/owl#onDatatype	3	\N	7	onDatatype	onDatatype	f	3	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
298	http://www.drugtargetontology.org/dto/lincs_id	461	\N	85	lincs_id	lincs_id	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
299	http://purl.obolibrary.org/obo/mondo#BOAD	1	\N	82	BOAD	BOAD	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
300	http://www.ebi.ac.uk/efo/MAT_definition_citation	477	\N	69	MAT_definition_citation	MAT_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
301	http://www.ebi.ac.uk/efo/PdumDv_definition_citation	2	\N	69	PdumDv_definition_citation	PdumDv_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
302	http://purl.org/goodrelations/v1#eligibleCustomerTypes	9	\N	36	eligibleCustomerTypes	eligibleCustomerTypes	f	9	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
303	http://www.geneontology.org/formats/oboInOwl#is_anonymous	2	\N	78	is_anonymous	is_anonymous	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
304	http://www.ebi.ac.uk/efo/DMBA_definition_citation	3	\N	69	DMBA_definition_citation	DMBA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
305	http://www.w3.org/2002/07/owl#equivalentClass	92831	\N	7	equivalentClass	equivalentClass	f	92831	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
306	http://purl.org/goodrelations/v1#hasPriceSpecification	1	\N	36	hasPriceSpecification	hasPriceSpecification	f	1	\N	\N	f	f	60	101	\N	t	f	\N	\N	\N	t	f	f
307	http://purl.org/dc/elements/1.1/date	1581	\N	6	date	date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
308	http://www.ebi.ac.uk/efo/IDOMAL_definition_citation	5	\N	69	IDOMAL_definition_citation	IDOMAL_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
309	http://www.ebi.ac.uk/efo/FBtc_definition_citation	3	\N	69	FBtc_definition_citation	FBtc_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
310	http://purl.org/goodrelations/v1#availableDeliveryMethods	3	\N	36	availableDeliveryMethods	availableDeliveryMethods	f	3	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
311	http://www.geneontology.org/formats/oboInOwl#consider	93	\N	78	consider	consider	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
312	http://www.drugtargetontology.org/dto/geneSymbol	11030	\N	85	geneSymbol	geneSymbol	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
313	http://www.w3.org/2004/02/skos/core#closeMatch	39514	\N	4	closeMatch	closeMatch	f	39514	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
314	http://purl.org/goodrelations/v1#validThrough	3	\N	36	validThrough	validThrough	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
315	http://purl.org/dc/terms/creator	57	\N	5	creator	creator	f	56	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
316	http://purl.obolibrary.org/obo/IAO_alt_id	4	\N	40	IAO_alt_id	IAO_alt_id	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
317	http://www.ebi.ac.uk/efo/MedDRA_definition_citation	1042	\N	69	MedDRA_definition_citation	MedDRA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
318	http://rdfs.org/ns/void#subjectsTarget	9	\N	16	subjectsTarget	subjectsTarget	f	9	\N	\N	f	f	71	40	\N	t	f	\N	\N	\N	t	f	f
319	http://www.geneontology.org/formats/oboInOwl#hasRelatedSynonym	40032	\N	78	hasRelatedSynonym	hasRelatedSynonym	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
320	http://www.w3.org/2001/XMLSchema#minInclusive	1	\N	3	minInclusive	minInclusive	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
321	http://purl.org/dc/terms/isVersionOf	2	\N	5	isVersionOf	isVersionOf	f	2	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
322	http://www.ebi.ac.uk/efo/PBA_definition_citation	2	\N	69	PBA_definition_citation	PBA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
323	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	36	BusinessEntity	BusinessEntity	f	1	\N	\N	f	f	19	23	\N	t	f	\N	\N	\N	t	f	f
325	http://www.ebi.ac.uk/efo/PDBeChem_definition_citation	66	\N	69	PDBeChem_definition_citation	PDBeChem_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
326	http://www.ebi.ac.uk/efo/source_definition	10	\N	69	source_definition	source_definition	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
327	http://www.ebi.ac.uk/efo/EHDA_definition_citation	2	\N	69	EHDA_definition_citation	EHDA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
329	http://www.w3.org/2001/XMLSchema#maxExclusive	1	\N	3	maxExclusive	maxExclusive	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
330	http://www.ebi.ac.uk/efo/HAO_definition_citation	15	\N	69	HAO_definition_citation	HAO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
331	http://purl.org/dc/terms/rightsHolder	1	\N	5	rightsHolder	rightsHolder	f	1	\N	\N	f	f	108	34	\N	t	f	\N	\N	\N	t	f	f
332	http://www.geneontology.org/formats/oboInOwl#ontology	510	\N	78	ontology	ontology	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
333	http://www.ebi.ac.uk/efo/KEGG_DRUG_definition_citation	165	\N	69	KEGG_DRUG_definition_citation	KEGG_DRUG_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
334	http://purl.org/dc/terms/modified	1015	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
335	http://www.geneontology.org/formats/oboInOwl#evidence	12	\N	78	evidence	evidence	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
336	http://www.w3.org/2002/07/owl#sameAs	2	\N	7	sameAs	sameAs	f	2	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
337	http://www.ebi.ac.uk/efo/ChEBI_definition_citation	4	\N	69	ChEBI_definition_citation	ChEBI_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
338	http://identifiers.org/idot/preferredPrefix	8	\N	74	preferredPrefix	preferredPrefix	f	0	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
339	http://protege.stanford.edu/plugins/owl/protege#readOnly	2	\N	89	readOnly	readOnly	f	0	\N	\N	f	f	97	\N	\N	t	f	\N	\N	\N	t	f	f
341	http://www.ebi.ac.uk/efo/PATO_definition_citation	13	\N	69	PATO_definition_citation	PATO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
342	http://purl.org/dc/terms/language	19	\N	5	language	language	f	19	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
343	http://www.w3.org/2002/07/owl#members	35	\N	7	members	members	f	35	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
344	http://purl.org/goodrelations/v1#offers	3	\N	36	offers	offers	f	3	\N	\N	f	f	23	60	\N	t	f	\N	\N	\N	t	f	f
345	http://www.geneontology.org/formats/oboInOwl#date	3	\N	78	date	date	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
346	http://www.w3.org/2002/07/owl#withRestrictions	3	\N	7	withRestrictions	withRestrictions	f	3	\N	\N	f	f	16	\N	\N	t	f	\N	\N	\N	t	f	f
347	http://www.ebi.ac.uk/efo/Reactome_definition_citation	385	\N	69	Reactome_definition_citation	Reactome_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
348	http://www.w3.org/2000/01/rdf-schema#type	2	\N	2	type	type	f	2	\N	\N	f	f	18	\N	\N	t	f	\N	\N	\N	t	f	f
349	http://purl.org/dc/terms/references	106	\N	5	references	references	f	106	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
350	http://purl.org/dc/terms/title	8779705	\N	5	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
351	http://www.w3.org/2000/01/rdf-schema#label	9022744	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
352	http://www.ebi.ac.uk/efo/BTO_definition_citation	717	\N	69	BTO_definition_citation	BTO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
353	http://www.w3.org/2002/07/owl#hasValue	38722	\N	7	hasValue	hasValue	f	0	\N	\N	f	f	96	\N	\N	t	f	\N	\N	\N	t	f	f
354	http://semanticscience.org/resource/SIO_000900	392995	\N	70	SIO_000900	SIO_000900	f	392995	\N	\N	f	f	42	41	\N	t	f	\N	\N	\N	t	f	f
355	http://www.w3.org/2004/02/skos/core#prefLabel	7	\N	4	prefLabel	prefLabel	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
356	http://www.ebi.ac.uk/efo/FBdv_definition_citation	29	\N	69	FBdv_definition_citation	FBdv_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
357	http://purl.org/dc/elements/1.1/license	4	\N	6	license	license	f	2	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
358	http://www.w3.org/1999/02/22-rdf-syntax-ns#value	4	\N	1	value	value	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
359	http://www.geneontology.org/formats/oboInOwl#http://purl.obolibrary.org/obo/NCIT_P378	61	\N	78	http://purl.obolibrary.org/obo/NCIT_P378	http://purl.obolibrary.org/obo/NCIT_P378	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
360	http://www.ebi.ac.uk/efo/IDO_definition_citation	1	\N	69	IDO_definition_citation	IDO_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
361	http://purl.obolibrary.org/obo#SMILES	336	\N	79	SMILES	SMILES	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
362	http://www.ebi.ac.uk/efo/ICD9CM_definition_citation	9	\N	69	ICD9CM_definition_citation	ICD9CM_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
363	http://www.openlinksw.com/ontology/acl#hasApplicableAccess	2	\N	76	hasApplicableAccess	hasApplicableAccess	f	2	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
364	http://www.ebi.ac.uk/efo/OpenCyc_definition_citation	192	\N	69	OpenCyc_definition_citation	OpenCyc_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
365	http://www.ebi.ac.uk/efo/ZFS_definition_citation	53	\N	69	ZFS_definition_citation	ZFS_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
366	http://rdfs.org/ns/void#linkPredicate	10	\N	16	linkPredicate	linkPredicate	f	10	\N	\N	f	f	71	18	\N	t	f	\N	\N	\N	t	f	f
367	http://purl.org/pav/retrievedFrom	1	\N	80	retrievedFrom	retrievedFrom	f	1	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
368	http://www.ebi.ac.uk/efo/HMDB_definition_citation	10	\N	69	HMDB_definition_citation	HMDB_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
369	http://www.geneontology.org/formats/oboInOwl#date_retrieved	508	\N	78	date_retrieved	date_retrieved	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
370	http://purl.obolibrary.org/obo/uberon/core#fma_set_term	1	\N	90	fma_set_term	fma_set_term	f	1	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
328	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P171	601	\N	72	[PubMedID_Primary_Reference (P171)]	P171	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
340	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P167	6	\N	72	[Image_Link (P167)]	P167	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
372	http://www.ebi.ac.uk/efo/TGMA_definition_citation	39	\N	69	TGMA_definition_citation	TGMA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
373	http://www.ebi.ac.uk/efo/EHDAA_definition_citation	255	\N	69	EHDAA_definition_citation	EHDAA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
374	http://purl.org/ontology/wi/core#evidence	13	\N	91	evidence	evidence	f	13	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
375	http://purl.obolibrary.org/obo/IAO_xref	6	\N	40	IAO_xref	IAO_xref	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
376	http://purl.org/pav/version	35	\N	80	version	version	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
377	http://www.ebi.ac.uk/efo/primary_source	83	\N	69	primary_source	primary_source	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
378	http://rdfs.org/ns/void#entities	2	\N	16	entities	entities	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
379	http://www.w3.org/ns/sparql-service-description#resultFormat	9	\N	27	resultFormat	resultFormat	f	9	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
380	http://www.ebi.ac.uk/efo/ICD9_definition_citation	510	\N	69	ICD9_definition_citation	ICD9_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
381	http://www.ebi.ac.uk/efo/STRUCTURE_ChemicalName_IUPAC_definition_citation	3	\N	69	STRUCTURE_ChemicalName_IUPAC_definition_citation	STRUCTURE_ChemicalName_IUPAC_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
382	http://purl.org/pav/createdOn	19	\N	80	createdOn	createdOn	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
383	http://www.w3.org/2002/07/owl#complementOf	595	\N	7	complementOf	complementOf	f	595	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
384	http://purl.obolibrary.org/obo/mondo#pathogenesis	1	\N	82	pathogenesis	pathogenesis	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
385	http://www.ebi.ac.uk/efo/UM-BBD_definition_citation	8	\N	69	UM-BBD_definition_citation	UM-BBD_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
386	http://purl.obolibrary.org/obo/IAO_id	46	\N	40	IAO_id	IAO_id	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
387	http://purl.org/pav/previousVersion	28	\N	80	previousVersion	previousVersion	f	28	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
388	http://vocabularies.bridgedb.org/ops#linksetJustification	10	\N	84	linksetJustification	linksetJustification	f	10	\N	\N	f	f	71	55	\N	t	f	\N	\N	\N	t	f	f
389	http://www.ebi.ac.uk/efo/definition	9468	\N	69	definition	definition	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
390	http://www.w3.org/2000/01/rdf-schema#comment	8757822	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
391	http://www.ebi.ac.uk/efo/OBI_definition_citation	2	\N	69	OBI_definition_citation	OBI_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
392	http://semanticscience.org/resource/hasSynonym	114	\N	70	hasSynonym	hasSynonym	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
393	http://www.ebi.ac.uk/efo/AEO_definition_citation	20	\N	69	AEO_definition_citation	AEO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
394	http://semanticscience.org/resource/equivalentTo	51	\N	70	equivalentTo	equivalentTo	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
395	http://identifiers.org/idot/exampleIdentifier	26	\N	74	exampleIdentifier	exampleIdentifier	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
396	http://www.ebi.ac.uk/efo/BILS_definition_citation	5	\N	69	BILS_definition_citation	BILS_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
397	http://www.ebi.ac.uk/efo/NIF_Cell_definition_citation	2	\N	69	NIF_Cell_definition_citation	NIF_Cell_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
398	http://purl.org/dc/terms/createdBy	1	\N	5	createdBy	createdBy	f	1	\N	\N	f	f	2	107	\N	t	f	\N	\N	\N	t	f	f
399	http://www.w3.org/2000/01/rdf-schema#domain	415	\N	2	domain	domain	f	415	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
400	http://purl.org/dc/terms/alternative	70	\N	5	alternative	alternative	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
401	http://www.geneontology.org/formats/oboInOwl#source	278786	\N	78	source	source	f	5	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
402	http://www.geneontology.org/formats/oboInOwl#http://purl.obolibrary.org/obo/NCIT_P381	61	\N	78	http://purl.obolibrary.org/obo/NCIT_P381	http://purl.obolibrary.org/obo/NCIT_P381	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
403	http://www.ebi.ac.uk/efo/GAID_definition_citation	233	\N	69	GAID_definition_citation	GAID_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
405	http://www.ebi.ac.uk/efo/ATC_code_definition_citation	17	\N	69	ATC_code_definition_citation	ATC_code_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
408	http://www.ebi.ac.uk/efo/MedlinePlus_definition_citation	3	\N	69	MedlinePlus_definition_citation	MedlinePlus_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
409	http://purl.org/dc/elements/1.1/contributor	16	\N	6	contributor	contributor	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
410	http://www.geneontology.org/formats/oboInOwl#hasScope	6	\N	78	hasScope	hasScope	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
411	http://www.ebi.ac.uk/efo/OGEM_definition_citation	2	\N	69	OGEM_definition_citation	OGEM_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
414	http://www.ebi.ac.uk/efo/BAMS_definition_citation	4	\N	69	BAMS_definition_citation	BAMS_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
415	http://www.ebi.ac.uk/efo/ZEA_definition_citation	14	\N	69	ZEA_definition_citation	ZEA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
404	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A13	245	\N	72	[Related_To_Genetic_Biomarker (A13)]	A13	f	245	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
406	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A12	10	\N	72	[Has_Data_Element (A12)]	A12	f	10	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
407	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A11	5242	\N	72	[Has_NICHD_Parent (A11)]	A11	f	5242	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
412	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P351	43	\N	72	[US_Recommended_Intake (P351)]	P351	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
416	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P355	332	\N	72	[Unit (P355)]	P355	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
417	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P354	134	\N	72	[USDA_ID (P354)]	P354	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
420	http://www.ebi.ac.uk/efo/VHOG_definition_citation	255	\N	69	VHOG_definition_citation	VHOG_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
421	http://www.w3.org/2002/07/owl#annotatedTarget	995369	\N	7	annotatedTarget	annotatedTarget	f	107841	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
422	http://www.w3.org/2004/02/skos/core#narrowMatch	4110	\N	4	narrowMatch	narrowMatch	f	4110	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
423	http://www.ebi.ac.uk/efo/SUBMITTER_definition_citation	4	\N	69	SUBMITTER_definition_citation	SUBMITTER_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
424	http://www.ebi.ac.uk/efo/NIF_Subcellular_definition_citation	20	\N	69	NIF_Subcellular_definition_citation	NIF_Subcellular_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
425	http://www.ebi.ac.uk/efo/MBA_definition_citation	2	\N	69	MBA_definition_citation	MBA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
429	http://www.drugtargetontology.org/dto/pro_xref	1828	\N	85	pro_xref	pro_xref	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
431	http://purl.obolibrary.org/obo/BFO_0000179	2	\N	40	BFO_0000179	BFO_0000179	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
432	http://identifiers.org/idot/identifierPattern	4	\N	74	identifierPattern	identifierPattern	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
433	http://www.geneontology.org/formats/oboInOwl#modified_by	1	\N	78	modified_by	modified_by	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
434	http://semanticscience.org/resource/SIO_000772	3702959	\N	70	SIO_000772	SIO_000772	f	3702959	\N	\N	f	f	\N	38	\N	t	f	\N	\N	\N	t	f	f
438	http://www.openlinksw.com/schemas/VAD#packageDeveloper	1	\N	77	packageDeveloper	packageDeveloper	f	0	\N	\N	f	f	98	\N	\N	t	f	\N	\N	\N	t	f	f
439	http://purl.org/pav/authoredBy	108	\N	80	authoredBy	authoredBy	f	108	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
440	http://www.w3.org/2001/vcard-rdf/3.0#Street	2	\N	73	Street	Street	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
441	http://purl.org/dc/elements/1.1/rights	3	\N	6	rights	rights	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
442	http://www.ebi.ac.uk/efo/ZFA_definition_citation	646	\N	69	ZFA_definition_citation	ZFA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
443	http://purl.obolibrary.org/obo/hasOBONamespace	3740	\N	40	hasOBONamespace	hasOBONamespace	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
444	http://identifiers.org/idot/accessPattern	17	\N	74	accessPattern	accessPattern	f	17	\N	\N	f	f	2	21	\N	t	f	\N	\N	\N	t	f	f
445	http://rdfs.org/ns/void#distinctObjects	2	\N	16	distinctObjects	distinctObjects	f	0	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
446	http://www.ebi.ac.uk/efo/EFO_URI	748	\N	69	EFO_URI	EFO_URI	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
447	http://www.ebi.ac.uk/efo/TAO_definition_citation	346	\N	69	TAO_definition_citation	TAO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
448	http://purl.obolibrary.org/obo/RO_0001900	3	\N	40	RO_0001900	RO_0001900	f	3	\N	\N	f	f	68	32	\N	t	f	\N	\N	\N	t	f	f
449	http://www.w3.org/2001/vcard-rdf/3.0#ADR	2	\N	73	ADR	ADR	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
450	http://www.w3.org/2002/07/owl#someValuesFrom	381917	\N	7	someValuesFrom	someValuesFrom	f	381917	\N	\N	f	f	96	\N	\N	t	f	\N	\N	\N	t	f	f
451	http://purl.obolibrary.org/obo/uberon#spatially_disjoint_from	75	\N	92	spatially_disjoint_from	spatially_disjoint_from	f	75	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
453	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	58	58	\N	t	f	\N	\N	\N	t	f	f
454	http://www.geneontology.org/formats/oboInOwl#hasNarrowSynonym	1262	\N	78	hasNarrowSynonym	hasNarrowSynonym	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
455	http://www.ebi.ac.uk/efo/MCC_definition_citation	18	\N	69	MCC_definition_citation	MCC_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
458	http://purl.org/goodrelations/v1#typeOfGood	3	\N	36	typeOfGood	typeOfGood	f	3	\N	\N	f	f	25	61	\N	t	f	\N	\N	\N	t	f	f
464	http://www.w3.org/2001/XMLSchema#minExclusive	1	\N	3	minExclusive	minExclusive	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
466	http://www.ebi.ac.uk/efo/CL_definition_citation	16	\N	69	CL_definition_citation	CL_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
426	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P359	32	\N	72	[Micronutrient (P359)]	P359	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
427	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P358	55	\N	72	[Nutrient (P358)]	P358	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
428	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P357	6	\N	72	[Essential_Fatty_Acid (P357)]	P357	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
430	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P356	10	\N	72	[Essential_Amino_Acid (P356)]	P356	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
435	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P102	4807	\N	72	[GenBank_Accession_Number (P102)]	P102	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
437	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P100	13452	\N	72	[OMIM_Number (P100)]	P100	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
452	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P106	134030	\N	72	[Semantic_Type (P106)]	P106	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
456	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P108	126588	\N	72	[Preferred_Name (P108)]	P108	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
457	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P107	11441	\N	72	[Display_Name (P107)]	P107	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
459	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P333	341	\N	72	[Use_For (P333)]	P333	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
460	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P211	6267	\N	72	[GO_Annotation (P211)]	P211	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
462	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P210	12349	\N	72	[CAS_Registry (P210)]	P210	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
463	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P331	2203	\N	72	[NCBI_Taxon_ID (P331)]	P331	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
465	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P330	4998	\N	72	[PDQ_Closed_Trial_Search_ID (P330)]	P330	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
467	http://www.ebi.ac.uk/efo/PO_definition_citation	56	\N	69	PO_definition_citation	PO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
468	http://www.geneontology.org/formats/oboInOwl#external_class	505	\N	78	external_class	external_class	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
469	http://xmlns.com/foaf/0.1/maker	1	\N	8	maker	maker	f	1	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
470	http://www.openlinksw.com/schemas/DAV#ownerUser	1014	\N	18	ownerUser	ownerUser	f	1014	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
471	http://www.drugtargetontology.org/dto/definition	12	\N	85	definition	definition	f	0	\N	\N	f	f	68	\N	\N	t	f	\N	\N	\N	t	f	f
472	http://www.geneontology.org/formats/oboInOwl#hasOBOFormatVersion	4	\N	78	hasOBOFormatVersion	hasOBOFormatVersion	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
474	http://purl.obolibrary.org/obo/uberon/core#homologous_in	238	\N	90	homologous_in	homologous_in	f	238	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
476	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#NHC0	126589	\N	72	NHC0	NHC0	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
478	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#NHC4	4	\N	72	NHC4	NHC4	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
479	http://purl.obolibrary.org/obo/hasNarrowSynonym	12	\N	40	hasNarrowSynonym	hasNarrowSynonym	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
480	http://www.w3.org/2002/07/owl#versionIRI	9	\N	7	versionIRI	versionIRI	f	9	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
481	http://www.ebi.ac.uk/efo/NeuroNames_definition_citation	2	\N	69	NeuroNames_definition_citation	NeuroNames_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
485	http://purl.org/dc/terms/identifier	8504723	\N	5	identifier	identifier	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
487	http://www.w3.org/2002/07/owl#incompatibleWith	1	\N	7	incompatibleWith	incompatibleWith	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
488	http://rdfs.org/ns/void#subset	46	\N	16	subset	subset	f	46	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
489	http://purl.obolibrary.org/obo/BFO_0000180	2	\N	40	BFO_0000180	BFO_0000180	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
490	http://www.ebi.ac.uk/efo/Germplasm_definition_citation	2	\N	69	Germplasm_definition_citation	Germplasm_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
491	http://www.geneontology.org/formats/oboInOwl#logical-definition-view-relation	1	\N	78	logical-definition-view-relation	logical-definition-view-relation	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
492	http://www.ebi.ac.uk/efo/ERO_definition_citation	7	\N	69	ERO_definition_citation	ERO_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
496	http://semanticscience.org/resource/SIO_000628	8775700	\N	70	SIO_000628	SIO_000628	f	8775700	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
500	http://www.drugtargetontology.org/dto/entrez_xref	1793	\N	85	entrez_xref	entrez_xref	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
502	http://semanticscience.org/resource/subset	81	\N	70	subset	subset	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
503	http://purl.org/dc/terms/rights	19	\N	5	rights	rights	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
504	http://www.ebi.ac.uk/efo/ISBN_definition_citation	5	\N	69	ISBN_definition_citation	ISBN_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
505	http://www.w3.org/2004/02/skos/core#exactMatch	3425343	\N	4	exactMatch	exactMatch	f	3425343	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
506	http://purl.org/dc/terms/source	26	\N	5	source	source	f	26	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
507	http://www.ebi.ac.uk/efo/MIAA_definition_citation	163	\N	69	MIAA_definition_citation	MIAA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
510	http://www.w3.org/2002/07/owl#onClass	54	\N	7	onClass	onClass	f	54	\N	\N	f	f	96	55	\N	t	f	\N	\N	\N	t	f	f
511	http://www.w3.org/2002/07/owl#maxQualifiedCardinality	1	\N	7	maxQualifiedCardinality	maxQualifiedCardinality	f	0	\N	\N	f	f	96	\N	\N	t	f	\N	\N	\N	t	f	f
512	http://www.w3.org/2000/01/rdf-schema#subClassOf	454060	\N	2	subClassOf	subClassOf	f	454060	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
513	http://www.ebi.ac.uk/efo/FMA_definition_citation	604	\N	69	FMA_definition_citation	FMA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
514	http://www.ebi.ac.uk/efo/TE_definition_citation	2	\N	69	TE_definition_citation	TE_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
473	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P216	335	\N	72	[BioCarta_ID (P216)]	P216	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
477	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P334	1223	\N	72	[ICD-O-3_Code (P334)]	P334	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
482	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P201	2778	\N	72	[OLD_CHILD (P201)]	P201	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
483	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P322	51033	\N	72	[Contributing_Source (P322)]	P322	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
484	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P200	3993	\N	72	[OLD_PARENT (P200)]	P200	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
486	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P320	3	\N	72	[OID (P320)]	P320	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
493	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P205	7	\N	72	[OLD_STATE (P205)]	P205	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
494	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P204	608	\N	72	[OLD_ROLE (P204)]	P204	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
497	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P203	3024	\N	72	[OLD_KIND (P203)]	P203	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
498	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P208	7826	\N	72	[NCI_META_CUI (P208)]	P208	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
499	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P329	4998	\N	72	[PDQ_Open_Trial_Search_ID (P329)]	P329	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
501	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P207	110299	\N	72	[UMLS_CUI (P207)]	P207	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
508	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P391	6350	\N	72	[source-date (P391)]	P391	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
509	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P390	6350	\N	72	[go-source (P390)]	P390	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
515	http://www.w3.org/2002/07/owl#oneOf	17	\N	7	oneOf	oneOf	f	17	\N	\N	f	f	16	95	\N	t	f	\N	\N	\N	t	f	f
517	http://www.w3.org/2002/07/owl#equivalentProperty	192	\N	7	equivalentProperty	equivalentProperty	f	192	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
518	http://www.ebi.ac.uk/efo/ICD10_definition_citation	5406	\N	69	ICD10_definition_citation	ICD10_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
523	http://semanticscience.org/resource/broaderThan	1	\N	70	broaderThan	broaderThan	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
525	http://www.orpha.net/ORDO/Orphanet_#symbol	3951	\N	93	symbol	symbol	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
526	http://www.ebi.ac.uk/efo/ArrayExpress_label	45	\N	69	ArrayExpress_label	ArrayExpress_label	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
527	http://www.geneontology.org/formats/oboInOwl#exception	1	\N	78	exception	exception	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
528	http://rdfs.org/ns/void#objectsTarget	10	\N	16	objectsTarget	objectsTarget	f	10	\N	\N	f	f	71	\N	\N	t	f	\N	\N	\N	t	f	f
529	http://purl.obolibrary.org/obo/id	3750	\N	40	id	id	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
530	http://www.ebi.ac.uk/efo/XtroDO_definition_citation	2	\N	69	XtroDO_definition_citation	XtroDO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
531	http://www.ebi.ac.uk/efo/CiteXplore_definition_citation	1359	\N	69	CiteXplore_definition_citation	CiteXplore_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
532	http://www.ebi.ac.uk/efo/BilaDO_definition_citation	5	\N	69	BilaDO_definition_citation	BilaDO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
533	http://www.ebi.ac.uk/efo/MA_definition_citation	463	\N	69	MA_definition_citation	MA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
534	http://purl.org/vocab/vann/preferredNamespaceUri	1	\N	24	preferredNamespaceUri	preferredNamespaceUri	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
535	http://www.geneontology.org/formats/oboInOwl#hasBroadSynonym	844	\N	78	hasBroadSynonym	hasBroadSynonym	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
537	http://www.w3.org/2001/vcard-rdf/3.0#Country	2	\N	73	Country	Country	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
538	http://www.w3.org/2000/01/rdf-schema#seeAlso	1016476	\N	2	seeAlso	seeAlso	f	1013714	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
539	http://www.openlinksw.com/schemas/VAD#packageDownload	2	\N	77	packageDownload	packageDownload	f	0	\N	\N	f	f	98	\N	\N	t	f	\N	\N	\N	t	f	f
540	http://www.ebi.ac.uk/efo/JAX_definition_citation	11	\N	69	JAX_definition_citation	JAX_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
541	http://www.ebi.ac.uk/efo/alternative_term	76602	\N	69	alternative_term	alternative_term	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
542	http://www.ebi.ac.uk/efo/UniProt_definition_citation	1	\N	69	UniProt_definition_citation	UniProt_definition_citation	f	0	\N	\N	f	f	14	\N	\N	t	f	\N	\N	\N	t	f	f
543	http://www.geneontology.org/formats/oboInOwl#hasExactSynonym	88671	\N	78	hasExactSynonym	hasExactSynonym	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
544	http://www.ebi.ac.uk/efo/DHBA_definition_citation	3	\N	69	DHBA_definition_citation	DHBA_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
545	http://www.ebi.ac.uk/efo/EVM_definition_citation	9	\N	69	EVM_definition_citation	EVM_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
546	http://xmlns.com/foaf/0.1/depicted_by	49	\N	8	depicted_by	depicted_by	f	49	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
547	http://purl.obolibrary.org/obo/uberon#present_in_taxon	3	\N	92	present_in_taxon	present_in_taxon	f	3	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
548	http://www.openlinksw.com/schemas/VAD#packageCopyright	1	\N	77	packageCopyright	packageCopyright	f	0	\N	\N	f	f	98	\N	\N	t	f	\N	\N	\N	t	f	f
549	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
550	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
551	http://rdfs.org/ns/void#triples	14	\N	16	triples	triples	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
552	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
554	http://purl.org/goodrelations/v1#validFrom	3	\N	36	validFrom	validFrom	f	0	\N	\N	f	f	60	\N	\N	t	f	\N	\N	\N	t	f	f
555	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	66	\N	1	_1	_1	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
556	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
557	http://protege.stanford.edu/plugins/owl/protege#defaultLanguage	3	\N	89	defaultLanguage	defaultLanguage	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
558	http://www.w3.org/2001/vcard-rdf/3.0#TEL	2	\N	73	TEL	TEL	f	2	\N	\N	f	f	\N	92	\N	t	f	\N	\N	\N	t	f	f
560	http://www.ebi.ac.uk/efo/ENVO_definition_citation	6	\N	69	ENVO_definition_citation	ENVO_definition_citation	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
561	http://purl.org/vocab/vann/preferredNamespacePrefix	2	\N	24	preferredNamespacePrefix	preferredNamespacePrefix	f	0	\N	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
516	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P384	425668	\N	72	[term-source (P384)]	P384	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
519	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P383	425670	\N	72	[term-group (P383)]	P383	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
520	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P381	2806	\N	72	[attr (P381)]	P381	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
521	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P387	6350	\N	72	[go-id (P387)]	P387	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
524	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P385	56236	\N	72	[source-code (P385)]	P385	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
536	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P389	6350	\N	72	[go-evi (P389)]	P389	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
553	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P378	125330	\N	72	[def-source (P378)]	P378	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
559	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P362	176	\N	72	[miRBase_ID (P362)]	P362	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
563	http://www.ebi.ac.uk/efo/APweb_definition_citation	1	\N	69	APweb_definition_citation	APweb_definition_citation	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
564	http://www.openlinksw.com/ontology/acl#hasDefaultAccess	2	\N	76	hasDefaultAccess	hasDefaultAccess	f	2	\N	\N	f	f	28	\N	\N	t	f	\N	\N	\N	t	f	f
567	http://www.w3.org/ns/dcat#byteSize	7	\N	15	byteSize	byteSize	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
570	http://vocabularies.bridgedb.org/ops#assertionMethod	10	\N	84	assertionMethod	assertionMethod	f	10	\N	\N	f	f	71	97	\N	t	f	\N	\N	\N	t	f	f
571	http://www.w3.org/2002/07/owl#allValuesFrom	588	\N	7	allValuesFrom	allValuesFrom	f	588	\N	\N	f	f	96	\N	\N	t	f	\N	\N	\N	t	f	f
572	http://purl.org/dc/terms/created	1033	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
576	http://www.ebi.ac.uk/efo/SRA_label	26	\N	69	SRA_label	SRA_label	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
254	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	10752159	\N	1	type	type	f	10752159	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
15	http://purl.obolibrary.org/obo/UBPROP_0000100	1	\N	40	[is count of (UBPROP_0000100)]	UBPROP_0000100	f	1	\N	\N	f	f	97	55	\N	t	f	\N	\N	\N	t	f	f
39	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P96	1972	\N	72	[Gene_Encodes_Product (P96)]	P96	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
105	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P319	13019	\N	72	[FDA_UNII_Code (P319)]	P319	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
122	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P302	577	\N	72	[Accepted_Therapeutic_Use_For (P302)]	P302	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
141	http://semanticscience.org/resource/SIO_000791	194515	\N	70	[sequence start position (SIO_000791)]	SIO_000791	f	194515	\N	\N	f	f	44	43	\N	t	f	\N	\N	\N	t	f	f
167	http://purl.obolibrary.org/obo/IAO_0000234	1	\N	40	[ontology term requester (IAO_0000234)]	IAO_0000234	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
248	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A8	125288	\N	72	[Concept_In_Subset (A8)]	A8	f	125288	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
259	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#A3	11	\N	72	[Role_Has_Parent (A3)]	A3	f	11	\N	\N	f	f	55	55	\N	t	f	\N	\N	\N	t	f	f
413	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P350	10818	\N	72	[Chemical_Formula (P350)]	P350	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
418	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P353	203	\N	72	[INFOODS (P353)]	P353	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
419	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P352	27	\N	72	[Tolerable_Level (P352)]	P352	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
436	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P101	205	\N	72	[Homologous_Gene (P101)]	P101	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
461	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P332	154	\N	72	[MGI_Accession_ID (P332)]	P332	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
475	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P215	237	\N	72	[KEGG_ID (P215)]	P215	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
495	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P325	33679	\N	72	[ALT_DEFINITION (P325)]	P325	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
522	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P386	18970	\N	72	[subsource-name (P386)]	P386	f	0	\N	\N	f	f	94	\N	\N	t	f	\N	\N	\N	t	f	f
562	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P361	708	\N	72	[Extensible_List (P361)]	P361	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
565	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P360	23	\N	72	[Macronutrient (P360)]	P360	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
566	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P366	72309	\N	72	[Legacy_Concept_Name (P366)]	P366	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
568	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P364	94	\N	72	[OLD_ASSOCIATION (P364)]	P364	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
569	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P363	8985	\N	72	[Neoplastic_Status (P363)]	P363	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
573	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P369	4605	\N	72	[HGNC_ID (P369)]	P369	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
574	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P368	3530	\N	72	[CHEBI_ID (P368)]	P368	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
575	http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#P367	169	\N	72	[PID_ID (P367)]	P367	f	0	\N	\N	f	f	55	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

COPY http_rdf_disgenet_org_sparql_.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	10	8	dubious_for_taxon	\N
2	12	8	preceding element is	\N
3	15	8	is count of	\N
4	16	8	has source	en
5	21	8	priorVersion	\N
6	23	8	never_in_taxon	\N
7	23	8	never in taxon	\N
8	27	8	FULL_SYN	\N
9	28	8	rhombomere number	\N
10	29	8	has_quality	\N
11	29	8	has attribute	en
12	30	8	Swiss_Prot	\N
13	33	8	Subsource	\N
14	35	8	DesignNote	\N
15	37	8	DEFINITION	\N
16	39	8	Gene_Encodes_Product	\N
17	40	8	has property	en
18	48	8	taxon_notes	\N
19	49	8	has_relational_adjective	\N
20	51	8	imported from	en
21	52	8	homology_notes	\N
22	53	8	axiom_lost_from_external_ontology	\N
23	56	8	external_definition	\N
24	57	8	has measurement value	en
25	61	8	term replaced by	\N
26	61	8	term replaced by	\N
27	74	8	expand assertion to	\N
28	77	8	external_ontology_notes	\N
29	79	8	has_alternative_id	\N
30	82	8	structure_notes	\N
31	87	8	Concept_Status	\N
32	89	8	has_synonym_type	\N
33	101	8	SNP_ID	\N
34	105	8	FDA_UNII_Code	\N
35	106	8	FDA_Table	\N
36	107	8	Relative_Enzyme_Activity	\N
37	117	8	elucidation	en
38	119	8	has associated axiom(nl)	en
39	120	8	In_Clinical_Trial_For	\N
40	122	8	Accepted_Therapeutic_Use_For	\N
41	124	8	is represented by	en
42	125	8	has value	en
43	127	8	has associated axiom(fol)	en
44	130	8	intersectionOf	\N
45	132	8	shorthand	\N
46	139	8	fma_set_term	\N
47	139	8	fma_set_term	\N
48	141	8	sequence start position	en
49	156	8	inverseOf	\N
50	159	8	editor note	\N
51	159	8	editor note	en
52	160	8	term editor	\N
53	160	8	term editor	\N
54	161	8	MO_definition_citation	\N
55	162	8	has curation status	\N
56	162	8	has curation status	en
57	164	8	definition	\N
58	164	8	definition	en
59	165	8	example of usage	\N
60	165	8	example of usage	\N
61	165	8	example of usage	en
62	166	8	manual assertion	\N
63	166	8	manual_assertion	\N
64	166	8	manual_assertion	en
65	167	8	ontology term requester	\N
66	170	8	curator note	\N
67	170	8	curator note	en
68	171	8	editor preferred term	en
69	175	8	alternative term	en
70	176	8	definition source	\N
71	176	8	definition source	en
72	177	8	is member of	en
73	183	8	disjointWith	\N
74	187	8	unionOf	\N
75	189	8	versionInfo	\N
76	195	8	is located in	en
77	200	8	has_obo_namespace	\N
78	214	8	creator	\N
79	219	8	OAE_definition_citation	\N
80	226	8	in_subset	\N
81	248	8	Concept_In_Subset	\N
82	249	8	Has_Target	\N
83	250	8	Has_Free_Acid_Or_Base_Form	\N
84	252	8	Has_Salt_Form	\N
85	253	8	Is_Related_To_Endogenous_Product	\N
86	257	8	Qualifier_Applies_To	\N
87	258	8	ORDO_definition_citation	\N
88	259	8	Role_Has_Parent	\N
89	261	8	Role_Has_Range	\N
90	262	8	imports	\N
91	263	8	database_cross_reference	\N
92	264	8	Role_Has_Domain	\N
93	271	8	encodes	en
94	279	8	is_identity_criteria	en
95	282	8	excluded subClassOf	\N
96	283	8	license	\N
97	284	8	semi_formal_definition	\N
98	286	8	onProperty	\N
99	294	8	curator inference	\N
100	294	8	curator_inference	\N
101	294	8	curator_inference	en
102	305	8	equivalentClass	\N
103	309	8	FBtc_definition_citation	\N
104	311	8	consider	\N
105	319	8	has_related_synonym	\N
106	324	8	NSC_Code	\N
107	328	8	PubMedID_Primary_Reference	\N
108	336	8	sameAs	\N
109	340	8	Image_Link	\N
110	351	8	label	\N
111	353	8	hasValue	\N
112	354	8	has frequency	en
113	355	8	preferred label	\N
114	360	8	IDO_definition_citation	\N
115	370	8	fma_set_term	\N
116	383	8	complementOf	\N
117	389	8	definition	\N
118	390	8	comment	\N
119	391	8	OBI_definition_citation	\N
120	404	8	Related_To_Genetic_Biomarker	\N
121	406	8	Has_Data_Element	\N
122	407	8	Has_NICHD_Parent	\N
123	410	8	has_scope	\N
124	412	8	US_Recommended_Intake	\N
125	413	8	Chemical_Formula	\N
126	416	8	Unit	\N
127	417	8	USDA_ID	\N
128	418	8	INFOODS	\N
129	419	8	Tolerable_Level	\N
130	426	8	Micronutrient	\N
131	427	8	Nutrient	\N
132	428	8	Essential_Fatty_Acid	\N
133	430	8	Essential_Amino_Acid	\N
134	431	8	BFO OWL specification label	en
135	434	8	has evidence	en
136	435	8	GenBank_Accession_Number	\N
137	436	8	Homologous_Gene	\N
138	437	8	OMIM_Number	\N
139	448	8	temporal interpretation	en
140	450	8	someValuesFrom	\N
141	451	8	spatially_disjoint_from	\N
142	452	8	Semantic_Type	\N
143	454	8	has_narrow_synonym	\N
144	456	8	Preferred_Name	\N
145	457	8	Display_Name	\N
146	459	8	Use_For	\N
147	460	8	GO_Annotation	\N
148	461	8	MGI_Accession_ID	\N
149	462	8	CAS_Registry	\N
150	463	8	NCBI_Taxon_ID	\N
151	465	8	PDQ_Closed_Trial_Search_ID	\N
152	472	8	has_obo_format_version	\N
153	473	8	BioCarta_ID	\N
154	474	8	homologous_in	\N
155	475	8	KEGG_ID	\N
156	476	8	code	\N
157	477	8	ICD-O-3_Code	\N
158	478	8	Split_From	\N
159	482	8	OLD_CHILD	\N
160	483	8	Contributing_Source	\N
161	484	8	OLD_PARENT	\N
162	486	8	OID	\N
163	487	8	incompatibleWith	\N
164	489	8	BFO CLIF specification label	en
165	491	8	logical-definition-view-relation	\N
166	492	8	ERO_definition_citation	\N
167	493	8	OLD_STATE	\N
168	494	8	OLD_ROLE	\N
169	495	8	ALT_DEFINITION	\N
170	496	8	refers to	en
171	497	8	OLD_KIND	\N
172	498	8	NCI_META_CUI	\N
173	499	8	PDQ_Open_Trial_Search_ID	\N
174	501	8	UMLS_CUI	\N
175	508	8	source-date	\N
176	509	8	go-source	\N
177	515	8	oneOf	\N
178	516	8	term-source	\N
179	517	8	equivalentProperty	\N
180	519	8	term-group	\N
181	520	8	attr	\N
182	521	8	go-id	\N
183	522	8	subsource-name	\N
184	524	8	source-code	\N
185	535	8	has_broad_synonym	\N
186	536	8	go-evi	\N
187	538	8	see also	\N
188	538	8	seeAlso	\N
189	541	8	alternative_term	\N
190	543	8	has_exact_synonym	\N
191	546	8	depicted_by	\N
192	547	8	present_in_taxon	\N
193	553	8	def-source	\N
194	559	8	miRBase_ID	\N
195	562	8	Extensible_List	\N
196	565	8	Macronutrient	\N
197	566	8	Legacy_Concept_Name	\N
198	568	8	OLD_ASSOCIATION	\N
199	569	8	Neoplastic_Status	\N
200	571	8	allValuesFrom	\N
201	573	8	HGNC_ID	\N
202	574	8	CHEBI_ID	\N
203	575	8	PID_ID	\N
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.cc_rels_id_seq', 19, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.class_annots_id_seq', 71, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.classes_id_seq', 110, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.cp_rels_id_seq', 2445, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.ns_id_seq', 93, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.properties_id_seq', 576, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

SELECT pg_catalog.setval('http_rdf_disgenet_org_sparql_.property_annots_id_seq', 203, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_rdf_disgenet_org_sparql_.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_rdf_disgenet_org_sparql_.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_rdf_disgenet_org_sparql_.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_rdf_disgenet_org_sparql_.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_rdf_disgenet_org_sparql_.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_rdf_disgenet_org_sparql_.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_rdf_disgenet_org_sparql_.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_rdf_disgenet_org_sparql_.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_rdf_disgenet_org_sparql_.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_rdf_disgenet_org_sparql_.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_rdf_disgenet_org_sparql_.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_rdf_disgenet_org_sparql_.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_rdf_disgenet_org_sparql_.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_rdf_disgenet_org_sparql_.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_rdf_disgenet_org_sparql_.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_rdf_disgenet_org_sparql_.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_rdf_disgenet_org_sparql_.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_rdf_disgenet_org_sparql_.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_rdf_disgenet_org_sparql_.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_rdf_disgenet_org_sparql_.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_classes_data ON http_rdf_disgenet_org_sparql_.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_classes_iri ON http_rdf_disgenet_org_sparql_.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_rdf_disgenet_org_sparql_.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_rdf_disgenet_org_sparql_.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_rdf_disgenet_org_sparql_.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_rdf_disgenet_org_sparql_.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_rdf_disgenet_org_sparql_.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_rdf_disgenet_org_sparql_.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_instances_test ON http_rdf_disgenet_org_sparql_.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_rdf_disgenet_org_sparql_.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_rdf_disgenet_org_sparql_.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_rdf_disgenet_org_sparql_.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_rdf_disgenet_org_sparql_.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_rdf_disgenet_org_sparql_.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_rdf_disgenet_org_sparql_.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_rdf_disgenet_org_sparql_.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_rdf_disgenet_org_sparql_.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_properties_data ON http_rdf_disgenet_org_sparql_.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

CREATE INDEX idx_properties_iri ON http_rdf_disgenet_org_sparql_.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_rdf_disgenet_org_sparql_.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_rdf_disgenet_org_sparql_.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_rdf_disgenet_org_sparql_.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_rdf_disgenet_org_sparql_.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_rdf_disgenet_org_sparql_.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_rdf_disgenet_org_sparql_.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_rdf_disgenet_org_sparql_.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_rdf_disgenet_org_sparql_.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_rdf_disgenet_org_sparql_.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_rdf_disgenet_org_sparql_.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_rdf_disgenet_org_sparql_.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_rdf_disgenet_org_sparql_.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_rdf_disgenet_org_sparql_.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_rdf_disgenet_org_sparql_.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_rdf_disgenet_org_sparql_.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_rdf_disgenet_org_sparql_.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_rdf_disgenet_org_sparql_.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_rdf_disgenet_org_sparql_.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_rdf_disgenet_org_sparql_.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_rdf_disgenet_org_sparql_.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_rdf_disgenet_org_sparql_.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_rdf_disgenet_org_sparql_.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_rdf_disgenet_org_sparql_.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_rdf_disgenet_org_sparql_.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_rdf_disgenet_org_sparql_.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_rdf_disgenet_org_sparql_.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_rdf_disgenet_org_sparql_.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_rdf_disgenet_org_sparql_.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_rdf_disgenet_org_sparql_; Owner: -
--

ALTER TABLE ONLY http_rdf_disgenet_org_sparql_.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_rdf_disgenet_org_sparql_.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

