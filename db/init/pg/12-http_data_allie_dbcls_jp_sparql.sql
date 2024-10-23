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
-- Name: http_data_allie_dbcls_jp_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_data_allie_dbcls_jp_sparql;


--
-- Name: SCHEMA http_data_allie_dbcls_jp_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_data_allie_dbcls_jp_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE FUNCTION http_data_allie_dbcls_jp_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE FUNCTION http_data_allie_dbcls_jp_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COMMENT ON TABLE http_data_allie_dbcls_jp_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COMMENT ON COLUMN http_data_allie_dbcls_jp_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_data_allie_dbcls_jp_sparql.classes c1
     JOIN http_data_allie_dbcls_jp_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_data_allie_dbcls_jp_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_data_allie_dbcls_jp_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_data_allie_dbcls_jp_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE TABLE http_data_allie_dbcls_jp_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE http_data_allie_dbcls_jp_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_data_allie_dbcls_jp_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_cc_rels AS
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
   FROM http_data_allie_dbcls_jp_sparql.cc_rels r,
    http_data_allie_dbcls_jp_sparql.classes c1,
    http_data_allie_dbcls_jp_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_classes_ns AS
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
    http_data_allie_dbcls_jp_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_data_allie_dbcls_jp_sparql.classes c
     LEFT JOIN http_data_allie_dbcls_jp_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_classes_ns_main AS
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
   FROM http_data_allie_dbcls_jp_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_data_allie_dbcls_jp_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_classes_ns_plus AS
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
    http_data_allie_dbcls_jp_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_data_allie_dbcls_jp_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_data_allie_dbcls_jp_sparql.classes c
     LEFT JOIN http_data_allie_dbcls_jp_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_classes_ns_main_plus AS
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
   FROM http_data_allie_dbcls_jp_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_data_allie_dbcls_jp_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_data_allie_dbcls_jp_sparql.v_classes_ns v
     LEFT JOIN http_data_allie_dbcls_jp_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_cp_rels AS
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
    http_data_allie_dbcls_jp_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_data_allie_dbcls_jp_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_data_allie_dbcls_jp_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_data_allie_dbcls_jp_sparql.cp_rels r,
    http_data_allie_dbcls_jp_sparql.classes c,
    http_data_allie_dbcls_jp_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_cp_rels_card AS
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
   FROM http_data_allie_dbcls_jp_sparql.cp_rels r,
    http_data_allie_dbcls_jp_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_properties_ns AS
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
    http_data_allie_dbcls_jp_sparql.tapprox(p.cnt) AS cnt_x,
    http_data_allie_dbcls_jp_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_data_allie_dbcls_jp_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_data_allie_dbcls_jp_sparql.properties p
     LEFT JOIN http_data_allie_dbcls_jp_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_cp_sources_single AS
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
   FROM ((http_data_allie_dbcls_jp_sparql.v_cp_rels_card r
     JOIN http_data_allie_dbcls_jp_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_data_allie_dbcls_jp_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_cp_targets_single AS
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
   FROM ((http_data_allie_dbcls_jp_sparql.v_cp_rels_card r
     JOIN http_data_allie_dbcls_jp_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_data_allie_dbcls_jp_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_data_allie_dbcls_jp_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_data_allie_dbcls_jp_sparql.pp_rels r,
    http_data_allie_dbcls_jp_sparql.properties p1,
    http_data_allie_dbcls_jp_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_properties_sources AS
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
   FROM (http_data_allie_dbcls_jp_sparql.v_properties_ns v
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
           FROM http_data_allie_dbcls_jp_sparql.cp_rels r,
            http_data_allie_dbcls_jp_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_properties_sources_single AS
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
   FROM (http_data_allie_dbcls_jp_sparql.v_properties_ns v
     LEFT JOIN http_data_allie_dbcls_jp_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_properties_targets AS
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
   FROM (http_data_allie_dbcls_jp_sparql.v_properties_ns v
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
           FROM http_data_allie_dbcls_jp_sparql.cp_rels r,
            http_data_allie_dbcls_jp_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE VIEW http_data_allie_dbcls_jp_sparql.v_properties_targets_single AS
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
   FROM (http_data_allie_dbcls_jp_sparql.v_properties_ns v
     LEFT JOIN http_data_allie_dbcls_jp_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	6	18	1	\N	\N
2	11	7	1	\N	\N
3	13	3	1	\N	\N
4	19	38	1	\N	\N
5	31	18	1	\N	\N
6	32	7	1	\N	\N
7	36	18	1	\N	\N
8	39	7	1	\N	\N
9	43	8	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	4	8	PubMedIDList	en
2	5	8	InverseFunctionalProperty	\N
3	9	8	AnnotationProperty	\N
4	15	8	LongForm	en
5	16	8	ShortForm	en
6	17	8	PubMedID	en
7	19	8	OntologyProperty	\N
8	24	8	Ontology	\N
9	25	8	ObjectProperty	\N
10	26	8	DatatypeProperty	\N
11	27	8	EachPair	en
12	28	8	ResearchArea	en
13	29	8	Restriction	\N
14	30	8	Class	\N
15	34	8	PairList	en
16	40	8	PairCluster	en
17	41	8	CooccurringShortFormList	en
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	http://www.openlinksw.com/schemas/VSPX#	1	\N	t	71			80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
2	http://rdfs.org/ns/void#Linkset	1	\N	t	16	Linkset	Linkset	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
3	http://www.w3.org/2001/vcard-rdf/3.0#work	2	\N	t	72	work	work	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
4	http://purl.org/allie/ontology/201108#PubMedIDList	9071892	\N	t	73	PubMedIDList	PubMedIDList	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9071892
5	http://www.w3.org/2002/07/owl#InverseFunctionalProperty	3	\N	t	7	InverseFunctionalProperty	InverseFunctionalProperty	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
6	http://purl.org/goodrelations/v1#PriceSpecification	1	\N	t	36	PriceSpecification	PriceSpecification	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9
7	http://purl.org/goodrelations/v1#ProductOrServicesSomeInstancesPlaceholder	3	\N	t	36	ProductOrServicesSomeInstancesPlaceholder	ProductOrServicesSomeInstancesPlaceholder	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
8	http://rdfs.org/ns/void#Dataset	1	\N	t	16	Dataset	Dataset	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
9	http://www.w3.org/2002/07/owl#AnnotationProperty	5	\N	t	7	AnnotationProperty	AnnotationProperty	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7
10	http://purl.org/goodrelations/v1#Manufacturer	1	\N	t	36	Manufacturer	Manufacturer	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
11	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AAB316003-tax	1	\N	t	74	C_AAB316003-tax	C_AAB316003-tax	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
12	http://xmlns.com/foaf/0.1/Person	2	\N	t	8	Person	Person	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
13	http://www.w3.org/2001/vcard-rdf/3.0#voice	2	\N	t	72	voice	voice	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
14	http://purl.org/goodrelations/v1#LocationOfSalesOrServiceProvisioning	1	\N	t	36	LocationOfSalesOrServiceProvisioning	LocationOfSalesOrServiceProvisioning	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
15	http://purl.org/allie/ontology/201108#LongForm	4727601	\N	t	73	LongForm	LongForm	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9071893
16	http://purl.org/allie/ontology/201108#ShortForm	1281045	\N	t	73	ShortForm	ShortForm	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	89543065
17	http://purl.org/allie/ontology/201108#PubMedID	14618695	\N	t	73	PubMedID	PubMedID	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	68186653
18	http://www.w3.org/2000/01/rdf-schema#Class	56	\N	t	2	Class	Class	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	406
19	http://www.w3.org/2002/07/owl#OntologyProperty	4	\N	t	7	OntologyProperty	OntologyProperty	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
20	http://purl.org/goodrelations/v1#Offering	3	\N	t	36	Offering	Offering	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
21	http://purl.org/goodrelations/v1#TypeAndQuantityNode	3	\N	t	36	TypeAndQuantityNode	TypeAndQuantityNode	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
22	http://www.w3.org/2002/07/owl#inverseFunctionalProperty	4	\N	t	7	inverseFunctionalProperty	inverseFunctionalProperty	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	11
23	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
24	http://www.w3.org/2002/07/owl#Ontology	3	\N	t	7	Ontology	Ontology	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
25	http://www.w3.org/2002/07/owl#ObjectProperty	11	\N	t	7	ObjectProperty	ObjectProperty	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19
26	http://www.w3.org/2002/07/owl#DatatypeProperty	1	\N	t	7	DatatypeProperty	DatatypeProperty	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
27	http://purl.org/allie/ontology/201108#EachPair	5556051	\N	t	73	EachPair	EachPair	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5556051
28	http://purl.org/allie/ontology/201108#ResearchArea	1440	\N	t	73	ResearchArea	ResearchArea	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8635799
29	http://www.w3.org/2002/07/owl#Restriction	18	\N	t	7	Restriction	Restriction	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	18
30	http://www.w3.org/2002/07/owl#Class	17	\N	t	7	Class	Class	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	49976602
31	http://purl.org/goodrelations/v1#ActualProductOrServicesInstance	1	\N	t	36	ActualProductOrServicesInstance	ActualProductOrServicesInstance	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
32	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKJ315005-tax	1	\N	t	74	C_AKJ315005-tax	C_AKJ315005-tax	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
33	http://www.w3.org/ns/dcat#Distribution	1	\N	t	15	Distribution	Distribution	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
34	http://purl.org/allie/ontology/201108#PairList	3515841	\N	t	73	PairList	PairList	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3515841
35	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	t	36	BusinessEntity	BusinessEntity	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
36	http://purl.org/goodrelations/v1#ProductOrServiceSomeInstancePlaceholder	1	\N	t	36	ProductOrServiceSomeInstancePlaceholder	ProductOrServiceSomeInstancePlaceholder	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15
37	http://www.w3.org/2001/vcard-rdf/3.0#internet	2	\N	t	72	internet	internet	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
38	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	170	\N	t	1	Property	Property	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
39	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#C_AKE112003-tax	1	\N	t	74	C_AKE112003-tax	C_AKE112003-tax	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
40	http://purl.org/allie/ontology/201108#PairCluster	3515841	\N	t	73	PairCluster	PairCluster	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
41	http://purl.org/allie/ontology/201108#CooccurringShortFormList	7688144	\N	t	73	CooccurringShortFormList	CooccurringShortFormList	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7688144
42	http://rdfs.org/ns/void#DatasetDescription	1	\N	t	16	DatasetDescription	DatasetDescription	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
43	http://purl.org/dc/dcmitype/Dataset	1	\N	t	70	Dataset	Dataset	80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	33	1	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
2	8	2	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
3	43	2	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
4	33	2	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
5	21	3	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
6	25	4	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
7	25	4	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
8	27	5	2	4711828	\N	4711828	\N	\N	1	1	2	f	0	\N	\N
9	40	5	2	2976316	\N	2976316	\N	\N	2	1	2	f	0	\N	\N
10	41	5	1	7688144	\N	7688144	\N	\N	1	1	2	f	\N	\N	\N
11	27	7	2	5556051	\N	5556051	\N	\N	1	1	2	f	0	\N	\N
12	40	7	2	3515841	\N	3515841	\N	\N	2	1	2	f	0	\N	\N
13	4	7	1	9071892	\N	9071892	\N	\N	1	1	2	f	\N	\N	\N
14	20	8	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
15	30	9	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
16	35	9	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
17	10	9	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
18	29	9	1	18	\N	18	\N	\N	1	1	2	f	\N	\N	\N
19	20	10	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
20	6	10	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
21	18	10	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
22	24	11	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
23	20	11	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
24	38	11	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
25	35	11	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
26	14	11	2	1	\N	1	\N	\N	5	1	2	f	0	\N	\N
27	24	11	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
28	20	12	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
29	8	13	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
30	43	13	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
31	12	13	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
32	24	15	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
33	41	16	2	80471173	\N	80471173	\N	\N	1	1	2	f	0	\N	\N
34	4	16	2	68186653	\N	68186653	\N	\N	2	1	2	f	0	\N	\N
35	34	16	2	5556051	\N	5556051	\N	\N	3	1	2	f	0	\N	\N
36	16	16	1	80471173	\N	80471173	\N	\N	1	1	2	f	\N	\N	\N
37	17	16	1	68186653	\N	68186653	\N	\N	2	1	2	f	\N	\N	\N
38	27	16	1	5556051	\N	5556051	\N	\N	3	1	2	f	\N	\N	\N
39	8	17	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
40	43	17	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
41	20	18	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
42	40	19	2	3515841	\N	3515841	\N	\N	1	1	2	f	0	\N	\N
43	34	19	1	3515841	\N	3515841	\N	\N	1	1	2	f	\N	\N	\N
44	35	20	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
45	14	20	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
46	29	21	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
47	30	21	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
48	42	22	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
49	23	23	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
50	30	24	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
51	27	25	2	5556051	\N	5556051	\N	\N	1	1	2	f	0	\N	\N
52	15	25	1	5556051	\N	5556051	\N	\N	1	1	2	f	\N	\N	\N
53	23	26	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
54	23	26	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
55	33	27	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
56	24	28	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
57	35	29	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
58	21	30	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
59	7	30	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
60	32	30	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
61	11	30	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
62	39	30	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
63	24	31	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
64	35	31	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
65	35	32	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
66	20	33	2	738	\N	0	\N	\N	1	1	2	f	738	\N	\N
67	1	34	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
68	20	35	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
69	14	35	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
70	8	36	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
71	43	36	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
72	1	37	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
73	1	38	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
74	42	39	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
75	12	39	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
76	15	40	2	113469	\N	113469	\N	\N	1	1	2	f	0	\N	\N
77	35	40	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
78	38	41	2	44	\N	44	\N	\N	1	1	2	f	0	\N	\N
79	5	41	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
80	9	41	2	3	\N	3	\N	\N	3	1	2	f	0	\N	\N
81	18	41	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
82	22	41	1	9	\N	9	\N	\N	1	1	2	f	\N	\N	\N
83	9	41	1	6	\N	6	\N	\N	2	1	2	f	\N	\N	\N
84	38	41	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
85	18	41	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
86	35	42	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
87	30	43	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
88	23	44	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
89	35	45	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
90	20	45	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
91	20	46	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
92	31	46	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
93	36	46	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
94	18	46	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
95	24	47	2	3	\N	1	\N	\N	1	1	2	f	2	\N	\N
96	42	48	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
97	8	48	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
98	43	48	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
99	2	49	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
100	38	50	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
101	1	51	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
102	42	52	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
103	8	52	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
104	43	52	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
105	15	53	2	4958559	\N	0	\N	\N	1	1	2	f	4958559	\N	\N
106	16	53	2	1281045	\N	0	\N	\N	2	1	2	f	1281045	\N	\N
107	28	53	2	1563	\N	0	\N	\N	3	1	2	f	1563	\N	\N
108	38	53	2	170	\N	0	\N	\N	4	1	2	f	170	\N	\N
109	30	53	2	16	\N	0	\N	\N	5	1	2	f	16	\N	\N
110	25	53	2	10	\N	0	\N	\N	6	1	2	f	10	\N	\N
111	14	53	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
112	31	53	2	1	\N	0	\N	\N	8	1	2	f	1	\N	\N
113	36	53	2	1	\N	0	\N	\N	9	1	2	f	1	\N	\N
114	6	53	2	1	\N	0	\N	\N	10	1	2	f	1	\N	\N
115	24	53	2	1	\N	0	\N	\N	11	1	2	f	1	\N	\N
116	18	53	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
117	19	53	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
118	9	53	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
119	8	54	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
120	43	54	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
121	15	54	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
122	8	55	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
123	43	55	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
124	17	56	2	14618695	\N	0	\N	\N	1	1	2	f	14618695	\N	\N
125	21	57	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
126	37	58	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
127	40	59	2	151878	\N	151878	\N	\N	1	1	2	f	0	\N	\N
128	3	60	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
129	37	60	2	2	\N	0	\N	\N	2	1	2	f	2	\N	\N
130	13	60	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
131	42	61	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
132	8	61	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
133	43	61	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
134	8	62	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
135	43	62	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
136	1	63	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
137	29	64	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
138	30	64	1	10	\N	10	\N	\N	1	1	2	f	\N	\N	\N
139	38	65	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
140	24	65	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
141	29	66	2	11	\N	0	\N	\N	1	1	2	f	11	\N	\N
142	40	67	2	3515841	\N	3515841	\N	\N	1	1	2	f	0	\N	\N
143	16	67	1	3515841	\N	3515841	\N	\N	1	1	2	f	\N	\N	\N
144	30	68	2	9	\N	9	\N	\N	1	1	2	f	0	\N	\N
145	31	68	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
146	36	68	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
147	6	68	2	1	\N	1	\N	\N	4	1	2	f	0	\N	\N
148	18	68	2	49	\N	49	\N	\N	0	1	2	f	0	\N	\N
149	30	68	1	9	\N	9	\N	\N	1	1	2	f	\N	\N	\N
150	18	68	1	32	\N	32	\N	\N	0	1	2	f	\N	\N	\N
151	8	69	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
152	43	69	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
153	20	70	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
154	21	70	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
155	38	71	2	167	\N	167	\N	\N	1	1	2	f	0	\N	\N
156	25	71	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
157	19	71	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
158	30	71	1	11	\N	11	\N	\N	1	1	2	f	\N	\N	\N
159	6	71	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
160	36	71	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
161	18	71	1	45	\N	45	\N	\N	0	1	2	f	\N	\N	\N
162	24	72	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
163	5	73	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
164	22	73	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
165	9	73	1	1	\N	1	\N	\N	3	1	2	f	\N	\N	\N
166	8	75	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
167	43	75	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
168	20	76	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
169	23	77	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
170	35	79	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
171	39	79	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
172	20	79	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
173	7	79	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
174	17	80	2	14618695	\N	14618695	\N	\N	1	1	2	f	0	\N	\N
175	4	80	2	9071892	\N	9071892	\N	\N	2	1	2	f	0	\N	\N
176	41	80	2	7688144	\N	7688144	\N	\N	3	1	2	f	0	\N	\N
177	27	80	2	5556051	\N	5556051	\N	\N	4	1	2	f	0	\N	\N
178	15	80	2	4727601	\N	4727601	\N	\N	5	1	2	f	0	\N	\N
179	40	80	2	3515841	\N	3515841	\N	\N	6	1	2	f	0	\N	\N
180	34	80	2	3515841	\N	3515841	\N	\N	7	1	2	f	0	\N	\N
181	16	80	2	1281045	\N	1281045	\N	\N	8	1	2	f	0	\N	\N
182	28	80	2	1440	\N	1440	\N	\N	9	1	2	f	0	\N	\N
183	38	80	2	175	\N	175	\N	\N	10	1	2	f	0	\N	\N
184	29	80	2	18	\N	18	\N	\N	11	1	2	f	0	\N	\N
185	30	80	2	17	\N	17	\N	\N	12	1	2	f	0	\N	\N
186	25	80	2	11	\N	11	\N	\N	13	1	2	f	0	\N	\N
187	7	80	2	6	\N	6	\N	\N	14	1	2	f	0	\N	\N
188	9	80	2	6	\N	6	\N	\N	15	1	2	f	0	\N	\N
189	3	80	2	4	\N	4	\N	\N	16	1	2	f	0	\N	\N
190	22	80	2	4	\N	4	\N	\N	17	1	2	f	0	\N	\N
191	5	80	2	3	\N	3	\N	\N	17	1	2	f	0	\N	\N
192	24	80	2	3	\N	3	\N	\N	18	1	2	f	0	\N	\N
193	20	80	2	3	\N	3	\N	\N	20	1	2	f	0	\N	\N
194	21	80	2	3	\N	3	\N	\N	21	1	2	f	0	\N	\N
195	31	80	2	2	\N	2	\N	\N	22	1	2	f	0	\N	\N
196	36	80	2	2	\N	2	\N	\N	23	1	2	f	0	\N	\N
197	6	80	2	2	\N	2	\N	\N	24	1	2	f	0	\N	\N
198	8	80	2	2	\N	2	\N	\N	25	1	2	f	0	\N	\N
199	12	80	2	2	\N	2	\N	\N	26	1	2	f	0	\N	\N
200	37	80	2	2	\N	2	\N	\N	27	1	2	f	0	\N	\N
201	23	80	2	1	\N	1	\N	\N	28	1	2	f	0	\N	\N
202	35	80	2	1	\N	1	\N	\N	29	1	2	f	0	\N	\N
203	14	80	2	1	\N	1	\N	\N	30	1	2	f	0	\N	\N
204	10	80	2	1	\N	1	\N	\N	31	1	2	f	0	\N	\N
205	1	80	2	1	\N	1	\N	\N	32	1	2	f	0	\N	\N
206	26	80	2	1	\N	1	\N	\N	33	1	2	f	0	\N	\N
207	42	80	2	1	\N	1	\N	\N	34	1	2	f	0	\N	\N
208	33	80	2	1	\N	1	\N	\N	35	1	2	f	0	\N	\N
209	2	80	2	1	\N	1	\N	\N	36	1	2	f	0	\N	\N
210	18	80	2	59	\N	59	\N	\N	0	1	2	f	0	\N	\N
211	19	80	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
212	13	80	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
213	32	80	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
214	11	80	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
215	39	80	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
216	43	80	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
217	30	80	1	49976550	\N	49976550	\N	\N	1	1	2	f	\N	\N	\N
218	18	80	1	62	\N	62	\N	\N	0	1	2	f	\N	\N	\N
219	42	81	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
220	1	82	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
221	30	83	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
222	30	83	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
223	24	85	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
224	27	86	2	5290180	\N	5290180	\N	\N	1	1	2	f	0	\N	\N
225	40	86	2	3345630	\N	3345630	\N	\N	2	1	2	f	0	\N	\N
226	28	86	1	8635799	\N	8635799	\N	\N	1	1	2	f	\N	\N	\N
227	29	87	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
228	8	88	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
229	43	88	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
230	23	88	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
231	20	89	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
232	24	90	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
233	38	90	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
234	20	90	2	3	\N	0	\N	\N	3	1	2	f	3	\N	\N
235	21	90	2	3	\N	0	\N	\N	4	1	2	f	3	\N	\N
236	7	90	2	3	\N	0	\N	\N	5	1	2	f	3	\N	\N
237	31	90	2	1	\N	0	\N	\N	6	1	2	f	1	\N	\N
238	36	90	2	1	\N	0	\N	\N	7	1	2	f	1	\N	\N
239	6	90	2	1	\N	0	\N	\N	8	1	2	f	1	\N	\N
240	18	90	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
241	32	90	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
242	11	90	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
243	39	90	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
244	8	92	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
245	43	92	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
246	42	94	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
247	8	94	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
248	43	94	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
249	20	96	2	3	\N	0	\N	\N	1	1	2	f	3	\N	\N
250	40	98	2	3515841	\N	3515841	\N	\N	1	1	2	f	0	\N	\N
251	15	98	1	3515841	\N	3515841	\N	\N	1	1	2	f	\N	\N	\N
252	12	100	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
253	3	101	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
254	13	101	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
255	35	102	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
256	8	103	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
257	24	103	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
258	43	103	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
259	8	104	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
260	43	104	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
261	29	105	2	18	\N	18	\N	\N	1	1	2	f	0	\N	\N
262	25	105	1	17	\N	17	\N	\N	1	1	2	f	\N	\N	\N
263	26	105	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
264	38	106	2	279	\N	279	\N	\N	1	1	2	f	0	\N	\N
265	25	106	2	9	\N	9	\N	\N	2	1	2	f	0	\N	\N
266	19	106	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
267	36	106	1	13	\N	13	\N	\N	1	1	2	f	\N	\N	\N
268	30	106	1	11	\N	11	\N	\N	2	1	2	f	\N	\N	\N
269	6	106	1	6	\N	6	\N	\N	3	1	2	f	\N	\N	\N
270	31	106	1	4	\N	4	\N	\N	4	1	2	f	\N	\N	\N
271	18	106	1	262	\N	262	\N	\N	0	1	2	f	\N	\N	\N
272	12	107	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
273	29	108	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
274	30	108	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
275	1	109	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
276	24	109	2	1	\N	0	\N	\N	2	1	2	f	1	\N	\N
277	8	110	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
278	43	110	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
279	12	111	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
280	27	112	2	5556051	\N	5556051	\N	\N	1	1	2	f	0	\N	\N
281	16	112	1	5556051	\N	5556051	\N	\N	1	1	2	f	\N	\N	\N
282	27	113	2	5556051	\N	0	\N	\N	1	1	2	f	5556051	\N	\N
283	15	113	2	4727601	\N	0	\N	\N	2	1	2	f	4727601	\N	\N
284	40	113	2	3515841	\N	0	\N	\N	3	1	2	f	3515841	\N	\N
285	16	113	2	1281045	\N	0	\N	\N	4	1	2	f	1281045	\N	\N
286	23	114	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
287	23	114	1	1	\N	1	\N	\N	1	1	2	f	\N	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
73	n_3	http://purl.org/allie/ontology/201108#	0	f	0
37	org	http://www.w3.org/ns/org#	0	f	0
38	sioc	http://rdfs.org/sioc/ns#	0	f	0
39	vcard	http://www.w3.org/2006/vcard/ns#	0	f	0
40	obo	http://purl.obolibrary.org/obo/	0	f	0
68	bif	http://www.openlinksw.com/schemas/bif#	0	f	0
36		http://purl.org/goodrelations/v1#	0	t	0
70	dcmit	http://purl.org/dc/dcmitype/	0	f	0
71	n_1	http://www.openlinksw.com/schemas/VSPX#	0	f	0
72	n_2	http://www.w3.org/2001/vcard-rdf/3.0#	0	f	0
74	eco	http://www.ebusiness-unibw.org/ontologies/eclass/5.1.4/#	0	f	0
75	pav	http://purl.org/pav/	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_data_allie_dbcls_jp_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_data_allie_dbcls_jp_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://data.allie.dbcls.jp/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://data.allie.dbcls.jp/sparql", "correlationId": "4369567272589527505", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:27:58.337Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	http://www.w3.org/ns/dcat#downloadURL	1	\N	15	downloadURL	downloadURL	f	1	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://www.w3.org/ns/dcat#Distribution	1	\N	15	Distribution	Distribution	f	1	\N	\N	f	f	8	33	\N	t	f	\N	\N	\N	t	f	f
3	http://purl.org/goodrelations/v1#hasUnitOfMeasurement	3	\N	36	hasUnitOfMeasurement	hasUnitOfMeasurement	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
4	http://www.w3.org/2002/07/owl#inverseOf	2	\N	7	inverseOf	inverseOf	f	2	\N	\N	f	f	25	25	\N	t	f	\N	\N	\N	t	f	f
5	http://purl.org/allie/ontology/201108#cooccursWith	7688144	\N	73	cooccursWith	cooccursWith	f	7688144	\N	\N	f	f	\N	41	\N	t	f	\N	\N	\N	t	f	f
6	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	2	\N	1	rest	rest	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
7	http://purl.org/allie/ontology/201108#appearsIn	9071892	\N	73	appearsIn	appearsIn	f	9071892	\N	\N	f	f	\N	4	\N	t	f	\N	\N	\N	t	f	f
8	http://purl.org/goodrelations/v1#eligibleCustomerTypes	9	\N	36	eligibleCustomerTypes	eligibleCustomerTypes	f	9	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://www.w3.org/2002/07/owl#equivalentClass	82	\N	7	equivalentClass	equivalentClass	f	82	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
10	http://purl.org/goodrelations/v1#hasPriceSpecification	1	\N	36	hasPriceSpecification	hasPriceSpecification	f	1	\N	\N	f	f	20	6	\N	t	f	\N	\N	\N	t	f	f
11	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	10	\N	2	isDefinedBy	isDefinedBy	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
12	http://purl.org/goodrelations/v1#availableDeliveryMethods	3	\N	36	availableDeliveryMethods	availableDeliveryMethods	f	3	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://purl.org/pav/authoredBy	2	\N	75	authoredBy	authoredBy	f	2	\N	\N	f	f	8	12	\N	t	f	\N	\N	\N	t	f	f
14	http://www.w3.org/2001/vcard-rdf/3.0#Street	2	\N	72	Street	Street	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
16	http://purl.org/allie/ontology/201108#hasMemberOf	154213877	\N	73	hasMemberOf	hasMemberOf	f	154213877	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://rdfs.org/ns/void#distinctObjects	1	\N	16	distinctObjects	distinctObjects	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
18	http://purl.org/goodrelations/v1#validThrough	3	\N	36	validThrough	validThrough	f	0	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
19	http://purl.org/allie/ontology/201108#contains	3515841	\N	73	contains	contains	f	3515841	\N	\N	f	f	40	34	\N	t	f	\N	\N	\N	t	f	f
20	http://www.w3.org/2001/vcard-rdf/3.0#ADR	2	\N	72	ADR	ADR	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
21	http://www.w3.org/2002/07/owl#someValuesFrom	4	\N	7	someValuesFrom	someValuesFrom	f	4	\N	\N	f	f	29	30	\N	t	f	\N	\N	\N	t	f	f
22	http://purl.org/pav/createdWith	1	\N	75	createdWith	createdWith	f	1	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
23	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
24	http://www.w3.org/2002/07/owl#unionOf	1	\N	7	unionOf	unionOf	f	1	\N	\N	f	f	30	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://purl.org/allie/ontology/201108#hasLongFormOf	5556051	\N	73	hasLongFormOf	hasLongFormOf	f	5556051	\N	\N	f	f	27	15	\N	t	f	\N	\N	\N	t	f	f
26	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	23	23	\N	t	f	\N	\N	\N	t	f	f
27	http://www.w3.org/ns/dcat#mediaType	1	\N	15	mediaType	mediaType	f	0	\N	\N	f	f	33	\N	\N	t	f	\N	\N	\N	t	f	f
28	http://www.w3.org/2002/07/owl#versionInfo	2	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
29	http://xmlns.com/foaf/0.1/homepage	1	\N	8	homepage	homepage	f	1	\N	\N	f	f	35	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://purl.org/goodrelations/v1#typeOfGood	3	\N	36	typeOfGood	typeOfGood	f	3	\N	\N	f	f	21	7	\N	t	f	\N	\N	\N	t	f	f
31	http://purl.org/goodrelations/v1#BusinessEntity	1	\N	36	BusinessEntity	BusinessEntity	f	1	\N	\N	f	f	24	35	\N	t	f	\N	\N	\N	t	f	f
32	http://xmlns.com/foaf/0.1/maker	1	\N	8	maker	maker	f	1	\N	\N	f	f	35	\N	\N	t	f	\N	\N	\N	t	f	f
33	http://purl.org/goodrelations/v1#eligibleRegions	738	\N	36	eligibleRegions	eligibleRegions	f	0	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
34	http://www.openlinksw.com/schemas/DAV#ownerUser	1181	\N	18	ownerUser	ownerUser	f	1181	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://purl.org/goodrelations/v1#availableAtOrFrom	3	\N	36	availableAtOrFrom	availableAtOrFrom	f	3	\N	\N	f	f	20	14	\N	t	f	\N	\N	\N	t	f	f
36	http://www.w3.org/ns/dcat#landingPage	1	\N	15	landingPage	landingPage	f	1	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
37	http://www.openlinksw.com/schemas/VSPX#pageId	1	\N	71	pageId	pageId	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://purl.org/dc/terms/modified	1181	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
39	http://purl.org/pav/createdBy	1	\N	75	createdBy	createdBy	f	1	\N	\N	f	f	42	12	\N	t	f	\N	\N	\N	t	f	f
40	http://www.w3.org/2002/07/owl#sameAs	113471	\N	7	sameAs	sameAs	f	113471	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
41	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	481	\N	2	subPropertyOf	subPropertyOf	f	481	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
42	http://xmlns.com/foaf/0.1/logo	1	\N	8	logo	logo	f	1	\N	\N	f	f	35	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	2	\N	1	first	first	f	2	\N	\N	f	f	\N	30	\N	t	f	\N	\N	\N	t	f	f
44	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://purl.org/goodrelations/v1#offers	3	\N	36	offers	offers	f	3	\N	\N	f	f	35	20	\N	t	f	\N	\N	\N	t	f	f
46	http://purl.org/goodrelations/v1#includes	2	\N	36	includes	includes	f	2	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
47	http://purl.org/dc/elements/1.1/creator	3	\N	6	creator	creator	f	1	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://purl.org/dc/terms/issued	2	\N	5	issued	issued	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
49	http://rdfs.org/ns/void#target	3	\N	16	target	target	f	3	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
50	http://www.w3.org/2000/01/rdf-schema#type	2	\N	2	type	type	f	2	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
51	http://purl.org/dc/terms/extent	1148	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
52	http://purl.org/dc/terms/title	2	\N	5	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
53	http://www.w3.org/2000/01/rdf-schema#label	6241421	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
54	http://rdfs.org/ns/void#exampleResource	1	\N	16	exampleResource	exampleResource	f	1	\N	\N	f	f	8	15	\N	t	f	\N	\N	\N	t	f	f
55	http://rdfs.org/ns/void#distinctSubjects	1	\N	16	distinctSubjects	distinctSubjects	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
56	http://purl.org/allie/ontology/201108#publishedIn	14618695	\N	73	publishedIn	publishedIn	f	0	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
57	http://purl.org/goodrelations/v1#amountOfThisGood	3	\N	36	amountOfThisGood	amountOfThisGood	f	0	\N	\N	f	f	21	\N	\N	t	f	\N	\N	\N	t	f	f
58	http://www.w3.org/2001/vcard-rdf/3.0#EMAIL	2	\N	72	EMAIL	EMAIL	f	2	\N	\N	f	f	\N	37	\N	t	f	\N	\N	\N	t	f	f
59	http://www.w3.org/2004/02/skos/core#exactMatch	151878	\N	4	exactMatch	exactMatch	f	151878	\N	\N	f	f	40	\N	\N	t	f	\N	\N	\N	t	f	f
60	http://www.w3.org/1999/02/22-rdf-syntax-ns#value	4	\N	1	value	value	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
61	http://purl.org/dc/terms/description	2	\N	5	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
62	http://rdfs.org/ns/void#uriLookupEndpoint	1	\N	16	uriLookupEndpoint	uriLookupEndpoint	f	1	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
63	http://www.openlinksw.com/schemas/VSPX#title	1	\N	71	title	title	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
64	http://www.w3.org/2002/07/owl#onClass	10	\N	7	onClass	onClass	f	10	\N	\N	f	f	29	30	\N	t	f	\N	\N	\N	t	f	f
65	http://www.w3.org/2000/01/rdf-schema#isDescribedUsing	2	\N	2	isDescribedUsing	isDescribedUsing	f	2	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
66	http://www.w3.org/2002/07/owl#qualifiedCardinality	11	\N	7	qualifiedCardinality	qualifiedCardinality	f	0	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://purl.org/allie/ontology/201108#hasShortFormRepresentationOf	3515841	\N	73	hasShortFormRepresentationOf	hasShortFormRepresentationOf	f	3515841	\N	\N	f	f	40	16	\N	t	f	\N	\N	\N	t	f	f
68	http://www.w3.org/2000/01/rdf-schema#subClassOf	87	\N	2	subClassOf	subClassOf	f	87	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
69	http://rdfs.org/ns/void#dataDump	1	\N	16	dataDump	dataDump	f	1	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://purl.org/goodrelations/v1#includesObject	3	\N	36	includesObject	includesObject	f	3	\N	\N	f	f	20	21	\N	t	f	\N	\N	\N	t	f	f
71	http://www.w3.org/2000/01/rdf-schema#range	176	\N	2	range	range	f	176	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
72	http://purl.org/dc/elements/1.1/publisher	1	\N	6	publisher	publisher	f	1	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://www.w3.org/2002/07/owl#equivalentProperty	193	\N	7	equivalentProperty	equivalentProperty	f	193	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://www.w3.org/2001/vcard-rdf/3.0#Pcode	2	\N	72	Pcode	Pcode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
75	http://purl.org/dc/terms/publisher	1	\N	5	publisher	publisher	f	1	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
76	http://purl.org/goodrelations/v1#acceptedPaymentMethods	18	\N	36	acceptedPaymentMethods	acceptedPaymentMethods	f	18	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://www.w3.org/ns/sparql-service-description#resultFormat	8	\N	27	resultFormat	resultFormat	f	8	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://www.w3.org/2001/vcard-rdf/3.0#Country	2	\N	72	Country	Country	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://www.w3.org/2000/01/rdf-schema#seeAlso	5	\N	2	seeAlso	seeAlso	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
81	http://purl.org/pav/createdOn	1	\N	75	createdOn	createdOn	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://www.openlinksw.com/schemas/VSPX#type	1	\N	71	type	type	f	0	\N	\N	f	f	1	\N	\N	t	f	\N	\N	\N	t	f	f
83	http://www.w3.org/2002/07/owl#complementOf	2	\N	7	complementOf	complementOf	f	2	\N	\N	f	f	30	30	\N	t	f	\N	\N	\N	t	f	f
84	http://www.w3.org/2001/vcard-rdf/3.0#City	2	\N	72	City	City	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
85	http://www.w3.org/2002/07/owl#imports	3	\N	7	imports	imports	f	3	\N	\N	f	f	24	\N	\N	t	f	\N	\N	\N	t	f	f
86	http://purl.org/allie/ontology/201108#inResearchAreaOf	8635810	\N	73	inResearchAreaOf	inResearchAreaOf	f	8635810	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://www.w3.org/2002/07/owl#onDataRange	1	\N	7	onDataRange	onDataRange	f	1	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
88	http://rdfs.org/ns/void#sparqlEndpoint	1	\N	16	sparqlEndpoint	sparqlEndpoint	f	1	\N	\N	f	f	8	23	\N	t	f	\N	\N	\N	t	f	f
89	http://purl.org/goodrelations/v1#hasBusinessFunction	6	\N	36	hasBusinessFunction	hasBusinessFunction	f	6	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://www.w3.org/2000/01/rdf-schema#comment	58	\N	2	comment	comment	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
91	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	3	\N	1	_5	_5	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://rdfs.org/ns/void#triples	1	\N	16	triples	triples	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
93	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	10	\N	1	_3	_3	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
94	http://xmlns.com/foaf/0.1/primaryTopic	1	\N	8	primaryTopic	primaryTopic	f	1	\N	\N	f	f	42	8	\N	t	f	\N	\N	\N	t	f	f
95	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	3	\N	1	_4	_4	f	3	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
96	http://purl.org/goodrelations/v1#validFrom	3	\N	36	validFrom	validFrom	f	0	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	66	\N	1	_1	_1	f	66	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
98	http://purl.org/allie/ontology/201108#hasLongFormRepresentationOf	3515841	\N	73	hasLongFormRepresentationOf	hasLongFormRepresentationOf	f	3515841	\N	\N	f	f	40	15	\N	t	f	\N	\N	\N	t	f	f
99	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	13	\N	1	_2	_2	f	13	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
100	http://xmlns.com/foaf/0.1/mbox	2	\N	8	mbox	mbox	f	2	\N	\N	f	f	12	\N	\N	t	f	\N	\N	\N	t	f	f
101	http://www.w3.org/2001/vcard-rdf/3.0#TEL	2	\N	72	TEL	TEL	f	2	\N	\N	f	f	\N	3	\N	t	f	\N	\N	\N	t	f	f
102	http://purl.org/goodrelations/v1#legalName	1	\N	36	legalName	legalName	f	0	\N	\N	f	f	35	\N	\N	t	f	\N	\N	\N	t	f	f
103	http://purl.org/dc/terms/license	2	\N	5	license	license	f	2	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
104	http://purl.org/dc/terms/accrualPeriodicity	1	\N	5	accrualPeriodicity	accrualPeriodicity	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
105	http://www.w3.org/2002/07/owl#onProperty	18	\N	7	onProperty	onProperty	f	18	\N	\N	f	f	29	\N	\N	t	f	\N	\N	\N	t	f	f
106	http://www.w3.org/2000/01/rdf-schema#domain	288	\N	2	domain	domain	f	288	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
107	http://xmlns.com/foaf/0.1/family_name	2	\N	8	family_name	family_name	f	0	\N	\N	f	f	12	\N	\N	t	f	\N	\N	\N	t	f	f
108	http://www.w3.org/2002/07/owl#allValuesFrom	3	\N	7	allValuesFrom	allValuesFrom	f	3	\N	\N	f	f	29	30	\N	t	f	\N	\N	\N	t	f	f
109	http://purl.org/dc/terms/created	1182	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
110	http://rdfs.org/ns/void#vocabulary	2	\N	16	vocabulary	vocabulary	f	2	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
111	http://xmlns.com/foaf/0.1/givenname	2	\N	8	givenname	givenname	f	0	\N	\N	f	f	12	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://purl.org/allie/ontology/201108#hasShortFormOf	5556051	\N	73	hasShortFormOf	hasShortFormOf	f	5556051	\N	\N	f	f	27	16	\N	t	f	\N	\N	\N	t	f	f
113	http://purl.org/allie/ontology/201108#frequency	15080538	\N	73	frequency	frequency	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
114	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	23	23	\N	t	f	\N	\N	\N	t	f	f
80	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	49977145	\N	1	type	type	f	49977145	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

COPY http_data_allie_dbcls_jp_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	4	8	inverseOf	\N
2	5	8	cooccursWith	en
3	7	8	appearsIn	en
4	9	8	equivalentClass	\N
5	15	8	priorVersion	\N
6	16	8	hasMemberOf	en
7	19	8	contains	en
8	21	8	someValuesFrom	\N
9	24	8	unionOf	\N
10	25	8	hasLongFormOf	en
11	28	8	versionInfo	\N
12	40	8	sameAs	\N
13	67	8	hasShortFormRepresentationOf	en
14	73	8	equivalentProperty	\N
15	83	8	complementOf	\N
16	85	8	imports	\N
17	86	8	inResearchAreaOf	en
18	98	8	hasLongFormRepresentationOf	en
19	105	8	onProperty	\N
20	108	8	allValuesFrom	\N
21	112	8	hasShortFormOf	en
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.cc_rels_id_seq', 9, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.class_annots_id_seq', 17, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.classes_id_seq', 43, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.cp_rels_id_seq', 287, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.ns_id_seq', 75, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.properties_id_seq', 114, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

SELECT pg_catalog.setval('http_data_allie_dbcls_jp_sparql.property_annots_id_seq', 21, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_data_allie_dbcls_jp_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_data_allie_dbcls_jp_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_data_allie_dbcls_jp_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_data_allie_dbcls_jp_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_data_allie_dbcls_jp_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_data_allie_dbcls_jp_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_data_allie_dbcls_jp_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_data_allie_dbcls_jp_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_data_allie_dbcls_jp_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_data_allie_dbcls_jp_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_data_allie_dbcls_jp_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_data_allie_dbcls_jp_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_data_allie_dbcls_jp_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_data_allie_dbcls_jp_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_data_allie_dbcls_jp_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_data_allie_dbcls_jp_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_data_allie_dbcls_jp_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_data_allie_dbcls_jp_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_data_allie_dbcls_jp_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_data_allie_dbcls_jp_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_data_allie_dbcls_jp_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_data_allie_dbcls_jp_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_data_allie_dbcls_jp_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_data_allie_dbcls_jp_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_data_allie_dbcls_jp_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_data_allie_dbcls_jp_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_data_allie_dbcls_jp_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_data_allie_dbcls_jp_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_data_allie_dbcls_jp_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_data_allie_dbcls_jp_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_data_allie_dbcls_jp_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_data_allie_dbcls_jp_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_data_allie_dbcls_jp_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_data_allie_dbcls_jp_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_data_allie_dbcls_jp_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_data_allie_dbcls_jp_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_data_allie_dbcls_jp_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_data_allie_dbcls_jp_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_data_allie_dbcls_jp_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_data_allie_dbcls_jp_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_data_allie_dbcls_jp_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_data_allie_dbcls_jp_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_data_allie_dbcls_jp_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_data_allie_dbcls_jp_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_data_allie_dbcls_jp_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_data_allie_dbcls_jp_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_data_allie_dbcls_jp_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_data_allie_dbcls_jp_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_data_allie_dbcls_jp_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_data_allie_dbcls_jp_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_data_allie_dbcls_jp_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_data_allie_dbcls_jp_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_data_allie_dbcls_jp_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_data_allie_dbcls_jp_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_data_allie_dbcls_jp_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_data_allie_dbcls_jp_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_data_allie_dbcls_jp_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_data_allie_dbcls_jp_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_data_allie_dbcls_jp_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_data_allie_dbcls_jp_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_data_allie_dbcls_jp_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_data_allie_dbcls_jp_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_data_allie_dbcls_jp_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_data_allie_dbcls_jp_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_data_allie_dbcls_jp_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_data_allie_dbcls_jp_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_data_allie_dbcls_jp_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_data_allie_dbcls_jp_sparql; Owner: -
--

ALTER TABLE ONLY http_data_allie_dbcls_jp_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_data_allie_dbcls_jp_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

