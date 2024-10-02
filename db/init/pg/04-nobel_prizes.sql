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
-- Name: nobel_prizes; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA nobel_prizes;


--
-- Name: SCHEMA nobel_prizes; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA nobel_prizes IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: nobel_prizes; Owner: -
--

CREATE FUNCTION nobel_prizes.tapprox(integer) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: nobel_prizes; Owner: -
--

COMMENT ON TABLE nobel_prizes._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.classes (
    id integer NOT NULL,
    iri text NOT NULL,
    cnt integer,
    data jsonb,
    props_in_schema boolean DEFAULT false NOT NULL,
    ns_id integer,
    local_name text,
    display_name text,
    classification_property text,
    is_literal boolean DEFAULT false,
    datatype_id integer,
    instance_name_pattern jsonb,
    indirect_members boolean DEFAULT false NOT NULL,
    is_unique boolean DEFAULT false NOT NULL,
    large_superclass_id integer,
    hide_in_main boolean DEFAULT false
);


--
-- Name: cp_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cp_rels (
    id integer NOT NULL,
    class_id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    object_cnt integer,
    data_cnt_calc integer GENERATED ALWAYS AS (GREATEST((cnt - object_cnt), (0)::bigint)) STORED,
    max_cardinality integer,
    min_cardinality integer,
    cover_set_index integer,
    add_link_slots integer DEFAULT 1 NOT NULL,
    details_level integer DEFAULT 0 NOT NULL,
    sub_cover_complete boolean DEFAULT false NOT NULL,
    data_cnt integer,
    principal_class_id integer
);


--
-- Name: properties; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.properties (
    id integer NOT NULL,
    iri text NOT NULL,
    cnt integer,
    data jsonb,
    ns_id integer,
    display_name text,
    local_name text,
    is_unique boolean DEFAULT false NOT NULL,
    object_cnt integer,
    data_cnt_calc integer GENERATED ALWAYS AS (GREATEST((cnt - object_cnt), 0)) STORED,
    max_cardinality integer,
    inverse_max_cardinality integer,
    source_cover_complete boolean DEFAULT false NOT NULL,
    target_cover_complete boolean DEFAULT false NOT NULL,
    domain_class_id integer,
    range_class_id integer,
    data_cnt integer,
    classes_in_schema boolean DEFAULT false NOT NULL
);


--
-- Name: c_links; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((nobel_prizes.classes c1
     JOIN nobel_prizes.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN nobel_prizes.properties p ON ((cp1.property_id = p.id)))
     JOIN nobel_prizes.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN nobel_prizes.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt integer,
    data jsonb,
    cover_set_index integer
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt integer,
    data jsonb
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt integer,
    data jsonb
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_cc_rels AS
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
   FROM nobel_prizes.cc_rels r,
    nobel_prizes.classes c1,
    nobel_prizes.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_classes_ns AS
 SELECT c.id,
    c.iri,
    c.cnt,
    c.ns_id,
    n.name AS prefix,
    c.props_in_schema,
    c.local_name,
    c.display_name,
    c.classification_property,
    c.is_literal,
    c.datatype_id,
    c.instance_name_pattern,
    c.indirect_members,
    c.is_unique,
    concat(n.name, ',', c.local_name, ',', c.display_name, ',', lower(c.display_name)) AS namestring,
    nobel_prizes.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id
   FROM (nobel_prizes.classes c
     LEFT JOIN nobel_prizes.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_classes_ns_main AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local,
    v.large_superclass_id
   FROM nobel_prizes.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM nobel_prizes.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_classes_ns_plus AS
 SELECT c.id,
    c.iri,
    c.cnt,
    c.ns_id,
    n.name AS prefix,
    c.props_in_schema,
    c.local_name,
    c.display_name,
    c.classification_property,
    c.is_literal,
    c.datatype_id,
    c.instance_name_pattern,
    c.indirect_members,
    c.is_unique,
    concat(n.name, ',', c.local_name, ',', c.display_name, ',', lower(c.display_name)) AS namestring,
    nobel_prizes.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM nobel_prizes.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id
   FROM (nobel_prizes.classes c
     LEFT JOIN nobel_prizes.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_classes_ns_main_plus AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local,
    v.has_subclasses,
    v.large_superclass_id
   FROM nobel_prizes.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM nobel_prizes.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_classes_ns_main_v01 AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local
   FROM (nobel_prizes.v_classes_ns v
     LEFT JOIN nobel_prizes.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_cp_rels AS
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
    nobel_prizes.tapprox((r.cnt)::integer) AS cnt_x,
    nobel_prizes.tapprox(r.object_cnt) AS object_cnt_x,
    nobel_prizes.tapprox(r.data_cnt_calc) AS data_cnt_x,
    c.iri AS class_iri,
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    p.iri AS property_iri
   FROM nobel_prizes.cp_rels r,
    nobel_prizes.classes c,
    nobel_prizes.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_cp_rels_card AS
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
        END, '-1'::integer) AS x_max_cardinality,
    r.principal_class_id
   FROM nobel_prizes.cp_rels r,
    nobel_prizes.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_properties_ns AS
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
    nobel_prizes.tapprox(p.cnt) AS cnt_x,
    nobel_prizes.tapprox(p.object_cnt) AS object_cnt_x,
    nobel_prizes.tapprox(p.data_cnt_calc) AS data_cnt_x,
    n.is_local,
    p.domain_class_id,
    p.range_class_id,
    n.basic_order_level,
        CASE
            WHEN (p.max_cardinality IS NOT NULL) THEN p.max_cardinality
            ELSE '-1'::integer
        END AS max_cardinality,
        CASE
            WHEN (p.inverse_max_cardinality IS NOT NULL) THEN p.inverse_max_cardinality
            ELSE '-1'::integer
        END AS inverse_max_cardinality
   FROM (nobel_prizes.properties p
     LEFT JOIN nobel_prizes.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_cp_sources_single AS
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
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    r.x_max_cardinality
   FROM ((nobel_prizes.v_cp_rels_card r
     JOIN nobel_prizes.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN nobel_prizes.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_cp_targets_single AS
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
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    r.x_max_cardinality
   FROM ((nobel_prizes.v_cp_rels_card r
     JOIN nobel_prizes.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN nobel_prizes.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    nobel_prizes.tapprox((r.cnt)::integer) AS cnt_x
   FROM nobel_prizes.pp_rels r,
    nobel_prizes.properties p1,
    nobel_prizes.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_properties_sources AS
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
    c.classification_property AS base_class_cprop,
    c.is_literal AS base_class_is_literal,
    c.datatype_id AS base_cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (nobel_prizes.v_properties_ns v
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
            c_1.classification_property,
            c_1.is_literal,
            c_1.datatype_id,
            c_1.indirect_members,
            c_1.is_unique,
            c_1.namestring,
            c_1.is_local
           FROM nobel_prizes.cp_rels r,
            nobel_prizes.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_properties_sources_single AS
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
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (nobel_prizes.v_properties_ns v
     LEFT JOIN nobel_prizes.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_properties_targets AS
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
    c.classification_property AS base_class_cprop,
    c.is_literal AS base_class_is_literal,
    c.datatype_id AS base_cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (nobel_prizes.v_properties_ns v
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
            c_1.classification_property,
            c_1.is_literal,
            c_1.datatype_id,
            c_1.indirect_members,
            c_1.is_unique,
            c_1.namestring,
            c_1.is_local
           FROM nobel_prizes.cp_rels r,
            nobel_prizes.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_properties_targets_single AS
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
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (nobel_prizes.v_properties_ns v
     LEFT JOIN nobel_prizes.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	5	4	1	\N	\N
2	10	3	1	\N	\N
3	11	4	1	\N	\N
4	13	3	1	\N	\N
5	17	13	1	\N	\N
6	18	13	1	\N	\N
7	19	10	1	\N	\N
8	20	10	1	\N	\N
9	21	13	1	\N	\N
10	22	13	1	\N	\N
11	23	10	1	\N	\N
12	24	13	1	\N	\N
13	25	13	1	\N	\N
14	26	10	1	\N	\N
15	27	10	1	\N	\N
16	28	10	1	\N	\N
17	29	5	1	\N	\N
18	30	5	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main) FROM stdin;
1	http://dbpedia.org/ontology/University	341	\N	t	10	University	University	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
2	http://purl.org/dc/terms/PeriodOfTime	1	\N	t	5	PeriodOfTime	PeriodOfTime	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
3	http://dbpedia.org/ontology/Award	1596	\N	t	10	Award	Award	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
4	http://data.nobelprize.org/terms/Laureate	976	\N	t	68	Laureate	Laureate	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
5	http://xmlns.com/foaf/0.1/Person	949	\N	t	8	Person	Person	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
6	http://dbpedia.org/ontology/Country	127	\N	t	10	Country	Country	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
7	http://www.w3.org/2006/vcard/ns#Individual	1	\N	t	39	Individual	Individual	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
8	http://www.w3.org/ns/dcat#Dataset	1	\N	t	15	Dataset	Dataset	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
9	http://dbpedia.org/ontology/City	951	\N	t	10	City	City	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
10	http://data.nobelprize.org/terms/LaureateAward	984	\N	t	68	LaureateAward	LaureateAward	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
11	http://xmlns.com/foaf/0.1/Organization	27	\N	t	8	Organization	Organization	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
12	http://purl.org/dc/terms/Standard	1	\N	t	5	Standard	Standard	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
13	http://data.nobelprize.org/terms/NobelPrize	612	\N	t	68	NobelPrize	NobelPrize	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
14	http://xmlns.com/foaf/0.1/Agent	1	\N	t	8	Agent	Agent	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
15	http://www.w3.org/ns/dcat#Distribution	3	\N	t	15	Distribution	Distribution	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
16	http://www.w3.org/ns/dcat#Catalog	1	\N	t	15	Catalog	Catalog	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	f	\N	\N	f	f	\N	f
17	http://data.nobelprize.org/terms/Chemistry	114	\N	t	68	Chemistry	Chemistry	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
18	http://data.nobelprize.org/terms/Literature	114	\N	t	68	Literature	Literature	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
19	http://data.nobelprize.org/resource/category/Chemistry	191	\N	t	73	Chemistry	Chemistry	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
20	http://data.nobelprize.org/resource/category/Physics	221	\N	t	73	Physics	Physics	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
21	http://data.nobelprize.org/terms/Economic_Sciences	53	\N	t	68	Economic_Sciences	Economic_Sciences	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
22	http://data.nobelprize.org/terms/Peace	103	\N	t	68	Peace	Peace	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
23	http://data.nobelprize.org/resource/category/Literature	118	\N	t	73	Literature	Literature	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
24	http://data.nobelprize.org/terms/Physics	115	\N	t	68	Physics	Physics	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
25	http://data.nobelprize.org/terms/Physiology_or_Medicine	113	\N	t	68	Physiology_or_Medicine	Physiology_or_Medicine	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
26	http://data.nobelprize.org/resource/category/Physiology_or_Medicine	225	\N	t	73	Physiology_or_Medicine	Physiology_or_Medicine	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
27	http://data.nobelprize.org/resource/category/Economic_Sciences	89	\N	t	73	Economic_Sciences	Economic_Sciences	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
28	http://data.nobelprize.org/resource/category/Peace	140	\N	t	73	Peace	Peace	http://data.nobelprize.org/terms/category	f	\N	\N	f	f	\N	f
29	female	60	\N	t	\N	female	female	http://xmlns.com/foaf/0.1/gender	t	1	\N	f	f	\N	f
30	male	889	\N	t	\N	male	male	http://xmlns.com/foaf/0.1/gender	t	1	\N	f	f	\N	f
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id) FROM stdin;
1	2	1	2	1	\N	0	1	1	1	1	2	t	1	\N
2	4	2	2	1024	\N	0	-1	1	1	1	2	t	1024	\N
3	14	2	2	1	\N	0	1	1	2	1	2	t	1	\N
4	5	2	2	949	\N	0	1	1	0	1	2	t	949	\N
5	30	2	2	889	\N	0	1	1	0	1	2	t	889	\N
6	11	2	2	75	\N	0	-1	1	0	1	2	t	75	\N
7	29	2	2	60	\N	0	1	1	0	1	2	t	60	\N
8	5	3	2	1308	\N	1308	-1	0	1	1	2	f	0	\N
9	4	3	2	1308	\N	1308	-1	0	0	1	2	f	0	\N
10	30	3	2	1254	\N	1254	-1	0	0	1	2	f	0	\N
11	29	3	2	54	\N	54	-1	0	0	1	2	f	0	\N
12	6	3	1	676	\N	676	-1	0	1	1	2	f	\N	\N
13	9	3	1	632	\N	632	-1	0	2	1	2	f	\N	\N
14	8	4	2	1	\N	1	1	1	1	1	2	f	0	\N
15	8	5	2	1	\N	0	1	1	1	1	2	t	1	\N
16	16	5	2	1	\N	0	1	1	2	1	2	t	1	\N
17	10	6	2	984	\N	984	1	1	1	1	2	f	0	\N
18	3	6	2	984	\N	984	1	0	0	1	2	f	0	\N
19	26	6	2	225	\N	225	1	1	0	1	2	f	0	\N
20	20	6	2	221	\N	221	1	1	0	1	2	f	0	\N
21	19	6	2	191	\N	191	1	1	0	1	2	f	0	\N
22	28	6	2	140	\N	140	1	1	0	1	2	f	0	\N
23	23	6	2	118	\N	118	1	1	0	1	2	f	0	\N
24	27	6	2	89	\N	89	1	1	0	1	2	f	0	\N
25	13	6	1	982	\N	982	-1	1	1	1	2	f	\N	\N
26	3	6	1	982	\N	982	-1	0	0	1	2	f	\N	\N
27	25	6	1	225	\N	225	-1	1	0	1	2	f	\N	\N
28	24	6	1	219	\N	219	-1	1	0	1	2	f	\N	\N
29	17	6	1	191	\N	191	-1	1	0	1	2	f	\N	\N
30	22	6	1	140	\N	140	-1	1	0	1	2	f	\N	\N
31	18	6	1	118	\N	118	-1	1	0	1	2	f	\N	\N
32	21	6	1	89	\N	89	-1	1	0	1	2	f	\N	\N
33	8	7	2	1	\N	1	1	1	1	1	2	f	0	\N
34	7	8	2	1	\N	0	1	1	1	1	2	t	1	\N
35	8	9	2	1	\N	1	1	1	1	1	2	f	0	\N
36	7	9	1	1	\N	1	1	1	1	1	2	f	\N	\N
37	11	10	2	26	\N	0	1	0	1	1	2	t	26	\N
38	4	10	2	26	\N	0	1	0	0	1	2	t	26	\N
39	5	11	2	797	\N	797	-1	0	1	1	2	f	0	\N
40	4	11	2	797	\N	797	-1	0	0	1	2	f	0	\N
41	30	11	2	771	\N	771	-1	0	0	1	2	f	0	\N
42	29	11	2	26	\N	26	-1	0	0	1	2	f	0	\N
43	1	11	1	797	\N	797	-1	1	1	1	2	f	\N	\N
44	16	12	2	1	\N	1	1	1	1	1	2	f	0	\N
45	8	12	1	1	\N	1	1	1	1	1	2	f	\N	\N
46	15	13	2	2	\N	2	1	0	1	1	2	f	0	\N
47	12	13	1	2	\N	2	-1	1	1	1	2	f	\N	\N
48	8	14	2	1	\N	0	1	1	1	1	2	t	1	\N
49	4	15	2	984	\N	984	-1	1	1	1	2	f	0	\N
50	5	15	2	954	\N	954	-1	1	0	1	2	f	0	\N
51	30	15	2	893	\N	893	-1	1	0	1	2	f	0	\N
52	29	15	2	61	\N	61	-1	1	0	1	2	f	0	\N
53	11	15	2	30	\N	30	-1	1	0	1	2	f	0	\N
54	13	15	1	982	\N	982	-1	1	1	1	2	f	\N	\N
55	3	15	1	982	\N	982	-1	0	0	1	2	f	\N	\N
56	25	15	1	225	\N	225	-1	1	0	1	2	f	\N	\N
57	24	15	1	219	\N	219	-1	1	0	1	2	f	\N	\N
58	17	15	1	191	\N	191	-1	1	0	1	2	f	\N	\N
59	22	15	1	140	\N	140	-1	1	0	1	2	f	\N	\N
60	18	15	1	118	\N	118	-1	1	0	1	2	f	\N	\N
61	21	15	1	89	\N	89	-1	1	0	1	2	f	\N	\N
62	15	16	2	2	\N	2	1	0	1	1	2	f	0	\N
63	4	17	2	984	\N	984	-1	1	1	1	2	f	0	\N
64	5	17	2	954	\N	954	-1	1	0	1	2	f	0	\N
65	30	17	2	893	\N	893	-1	1	0	1	2	f	0	\N
66	29	17	2	61	\N	61	-1	1	0	1	2	f	0	\N
67	11	17	2	30	\N	30	-1	1	0	1	2	f	0	\N
68	10	17	1	984	\N	984	1	1	1	1	2	f	\N	\N
69	3	17	1	984	\N	984	1	0	0	1	2	f	\N	\N
70	26	17	1	225	\N	225	1	1	0	1	2	f	\N	\N
71	20	17	1	221	\N	221	1	1	0	1	2	f	\N	\N
72	19	17	1	191	\N	191	1	1	0	1	2	f	\N	\N
73	28	17	1	140	\N	140	1	1	0	1	2	f	\N	\N
74	23	17	1	118	\N	118	1	1	0	1	2	f	\N	\N
75	27	17	1	89	\N	89	1	1	0	1	2	f	\N	\N
76	15	18	2	3	\N	3	1	1	1	1	2	f	0	\N
77	8	19	2	1	\N	1	1	1	1	1	2	f	0	\N
78	16	19	2	1	\N	1	1	1	2	1	2	f	0	\N
79	14	19	1	2	\N	2	-1	1	1	1	2	f	\N	\N
80	3	20	2	1966	\N	1966	-1	1	1	1	2	f	0	\N
81	10	20	2	984	\N	984	1	1	0	1	2	f	0	\N
82	13	20	2	982	\N	982	-1	1	0	1	2	f	0	\N
83	26	20	2	225	\N	225	1	1	0	1	2	f	0	\N
84	25	20	2	225	\N	225	-1	1	0	1	2	f	0	\N
85	20	20	2	221	\N	221	1	1	0	1	2	f	0	\N
86	24	20	2	219	\N	219	-1	1	0	1	2	f	0	\N
87	19	20	2	191	\N	191	1	1	0	1	2	f	0	\N
88	17	20	2	191	\N	191	-1	1	0	1	2	f	0	\N
89	28	20	2	140	\N	140	1	1	0	1	2	f	0	\N
90	22	20	2	140	\N	140	-1	1	0	1	2	f	0	\N
91	23	20	2	118	\N	118	1	1	0	1	2	f	0	\N
92	18	20	2	118	\N	118	-1	1	0	1	2	f	0	\N
93	27	20	2	89	\N	89	1	1	0	1	2	f	0	\N
94	21	20	2	89	\N	89	-1	1	0	1	2	f	0	\N
95	4	20	1	1966	\N	1966	-1	1	1	1	2	f	\N	\N
96	5	20	1	1906	\N	1906	-1	1	0	1	2	f	\N	\N
97	30	20	1	1784	\N	1784	-1	1	0	1	2	f	\N	\N
98	29	20	1	122	\N	122	-1	1	0	1	2	f	\N	\N
99	11	20	1	60	\N	60	-1	1	0	1	2	f	\N	\N
100	10	21	2	984	\N	0	1	1	1	1	2	t	984	\N
101	3	21	2	984	\N	0	1	0	0	1	2	t	984	\N
102	26	21	2	225	\N	0	1	1	0	1	2	t	225	\N
103	20	21	2	221	\N	0	1	1	0	1	2	t	221	\N
104	19	21	2	191	\N	0	1	1	0	1	2	t	191	\N
105	28	21	2	140	\N	0	1	1	0	1	2	t	140	\N
106	23	21	2	118	\N	0	1	1	0	1	2	t	118	\N
107	27	21	2	89	\N	0	1	1	0	1	2	t	89	\N
108	1	22	2	338	\N	338	1	0	1	1	2	f	0	\N
109	9	22	1	338	\N	338	-1	0	1	1	2	f	\N	\N
110	5	23	2	949	\N	0	1	1	1	1	2	t	949	\N
111	4	23	2	949	\N	0	1	0	0	1	2	t	949	\N
112	30	23	2	889	\N	0	1	1	0	1	2	t	889	\N
113	29	23	2	60	\N	0	1	1	0	1	2	t	60	\N
114	3	24	2	3192	\N	3192	-1	1	1	1	2	f	0	\N
115	4	24	2	1952	\N	1952	-1	1	2	1	2	f	0	\N
116	9	24	2	951	\N	951	1	1	3	1	2	f	0	\N
117	1	24	2	341	\N	341	1	1	4	1	2	f	0	\N
118	6	24	2	127	\N	127	1	1	5	1	2	f	0	\N
119	15	24	2	3	\N	3	1	1	6	1	2	f	0	\N
120	2	24	2	1	\N	1	1	1	7	1	2	f	0	\N
121	12	24	2	1	\N	1	1	1	8	1	2	f	0	\N
122	8	24	2	1	\N	1	1	1	9	1	2	f	0	\N
123	14	24	2	1	\N	1	1	1	10	1	2	f	0	\N
124	16	24	2	1	\N	1	1	1	11	1	2	f	0	\N
125	7	24	2	1	\N	1	1	1	12	1	2	f	0	\N
126	10	24	2	1968	\N	1968	-1	1	0	1	2	f	0	\N
127	5	24	2	1898	\N	1898	-1	1	0	1	2	f	0	\N
128	30	24	2	1778	\N	1778	-1	1	0	1	2	f	0	\N
129	13	24	2	1224	\N	1224	-1	1	0	1	2	f	0	\N
130	26	24	2	450	\N	450	-1	1	0	1	2	f	0	\N
131	20	24	2	442	\N	442	-1	1	0	1	2	f	0	\N
132	19	24	2	382	\N	382	-1	1	0	1	2	f	0	\N
133	28	24	2	280	\N	280	-1	1	0	1	2	f	0	\N
134	23	24	2	236	\N	236	-1	1	0	1	2	f	0	\N
135	24	24	2	230	\N	230	-1	1	0	1	2	f	0	\N
136	17	24	2	228	\N	228	-1	1	0	1	2	f	0	\N
137	18	24	2	228	\N	228	-1	1	0	1	2	f	0	\N
138	25	24	2	226	\N	226	-1	1	0	1	2	f	0	\N
139	22	24	2	206	\N	206	-1	1	0	1	2	f	0	\N
140	27	24	2	178	\N	178	-1	1	0	1	2	f	0	\N
141	29	24	2	120	\N	120	-1	1	0	1	2	f	0	\N
142	21	24	2	106	\N	106	-1	1	0	1	2	f	0	\N
143	11	24	2	54	\N	54	-1	1	0	1	2	f	0	\N
144	13	25	2	612	\N	0	1	1	1	1	2	t	612	\N
145	3	25	2	612	\N	0	1	0	0	1	2	t	612	\N
146	24	25	2	115	\N	0	1	1	0	1	2	t	115	\N
147	17	25	2	114	\N	0	1	1	0	1	2	t	114	\N
148	18	25	2	114	\N	0	1	1	0	1	2	t	114	\N
149	25	25	2	113	\N	0	1	1	0	1	2	t	113	\N
150	22	25	2	103	\N	0	1	1	0	1	2	t	103	\N
151	21	25	2	53	\N	0	1	1	0	1	2	t	53	\N
152	7	26	2	1	\N	1	1	1	1	1	2	f	0	\N
153	5	27	2	949	\N	0	1	1	1	1	2	t	949	\N
154	4	27	2	949	\N	0	1	0	0	1	2	t	949	\N
155	30	27	2	889	\N	0	1	1	0	1	2	t	889	\N
156	29	27	2	60	\N	0	1	1	0	1	2	t	60	\N
157	3	28	2	1968	\N	0	-1	0	1	1	2	t	1968	\N
158	10	28	2	1957	\N	0	-1	1	0	1	2	t	1957	\N
159	26	28	2	448	\N	0	-1	1	0	1	2	t	448	\N
160	20	28	2	439	\N	0	-1	1	0	1	2	t	439	\N
161	19	28	2	380	\N	0	-1	1	0	1	2	t	380	\N
162	28	28	2	280	\N	0	-1	1	0	1	2	t	280	\N
163	23	28	2	235	\N	0	-1	1	0	1	2	t	235	\N
164	27	28	2	175	\N	0	-1	1	0	1	2	t	175	\N
165	13	28	2	11	\N	0	-1	0	0	1	2	t	11	\N
166	24	28	2	8	\N	0	-1	0	0	1	2	t	8	\N
167	17	28	2	3	\N	0	1	0	0	1	2	t	3	\N
168	1	29	2	345	\N	345	-1	0	1	1	2	f	0	\N
169	6	29	1	345	\N	345	-1	0	1	1	2	f	\N	\N
170	5	30	2	650	\N	0	1	0	1	1	2	t	650	\N
171	4	30	2	650	\N	0	1	0	0	1	2	t	650	\N
172	30	30	2	623	\N	0	1	0	0	1	2	t	623	\N
173	29	30	2	27	\N	0	1	0	0	1	2	t	27	\N
174	5	31	2	947	\N	0	1	0	1	1	2	t	947	\N
175	4	31	2	947	\N	0	1	0	0	1	2	t	947	\N
176	30	31	2	888	\N	0	1	0	0	1	2	t	888	\N
177	29	31	2	59	\N	0	1	0	0	1	2	t	59	\N
178	8	32	2	1	\N	1	1	1	1	1	2	f	0	\N
179	10	33	2	799	\N	799	-1	0	1	1	2	f	0	\N
180	3	33	2	799	\N	799	-1	0	0	1	2	f	0	\N
181	26	33	2	248	\N	248	-1	0	0	1	2	f	0	\N
182	20	33	2	244	\N	244	-1	0	0	1	2	f	0	\N
183	19	33	2	211	\N	211	-1	0	0	1	2	f	0	\N
184	27	33	2	92	\N	92	-1	0	0	1	2	f	0	\N
185	28	33	2	4	\N	4	1	0	0	1	2	f	0	\N
186	1	33	1	799	\N	799	-1	1	1	1	2	f	\N	\N
187	4	34	2	976	\N	976	1	1	1	1	2	f	0	\N
188	9	34	2	881	\N	881	1	0	2	1	2	f	0	\N
189	6	34	2	90	\N	90	1	0	3	1	2	f	0	\N
190	5	34	2	949	\N	949	1	1	0	1	2	f	0	\N
191	30	34	2	889	\N	889	1	1	0	1	2	f	0	\N
192	29	34	2	60	\N	60	1	1	0	1	2	f	0	\N
193	11	34	2	27	\N	27	1	1	0	1	2	f	0	\N
194	15	35	2	3	\N	3	1	1	1	1	2	f	0	\N
195	8	36	2	1	\N	1	1	1	1	1	2	f	0	\N
196	5	37	2	2004	\N	2004	-1	1	1	1	2	f	0	\N
197	4	37	2	2004	\N	2004	-1	0	0	1	2	f	0	\N
198	30	37	2	1877	\N	1877	-1	1	0	1	2	f	0	\N
199	29	37	2	127	\N	127	-1	1	0	1	2	f	0	\N
200	6	37	1	1060	\N	1060	-1	0	1	1	2	f	\N	\N
201	9	37	1	944	\N	944	-1	0	2	1	2	f	\N	\N
202	8	38	2	3	\N	3	-1	1	1	1	2	f	0	\N
203	5	39	2	949	\N	0	1	1	1	1	2	t	949	\N
204	4	39	2	949	\N	0	1	0	0	1	2	t	949	\N
205	30	39	2	889	\N	0	1	1	0	1	2	t	889	\N
206	29	39	2	60	\N	0	1	1	0	1	2	t	60	\N
207	11	40	2	44	\N	44	-1	0	1	1	2	f	0	\N
208	4	40	2	44	\N	44	-1	0	0	1	2	f	0	\N
209	6	40	1	23	\N	23	-1	0	1	1	2	f	\N	\N
210	9	40	1	21	\N	21	-1	0	2	1	2	f	\N	\N
211	15	41	2	3	\N	0	1	1	1	1	2	t	3	\N
212	8	42	2	3	\N	3	-1	1	1	1	2	f	0	\N
213	15	42	1	3	\N	3	1	1	1	1	2	f	\N	\N
214	8	43	2	1	\N	0	1	1	1	1	2	t	1	\N
215	13	44	2	982	\N	982	-1	1	1	1	2	f	0	\N
216	3	44	2	982	\N	982	-1	0	0	1	2	f	0	\N
217	25	44	2	225	\N	225	-1	1	0	1	2	f	0	\N
218	24	44	2	219	\N	219	-1	1	0	1	2	f	0	\N
219	17	44	2	191	\N	191	-1	1	0	1	2	f	0	\N
220	22	44	2	140	\N	140	-1	1	0	1	2	f	0	\N
221	18	44	2	118	\N	118	-1	1	0	1	2	f	0	\N
222	21	44	2	89	\N	89	-1	1	0	1	2	f	0	\N
223	10	44	1	982	\N	982	1	0	1	1	2	f	\N	\N
224	3	44	1	982	\N	982	1	0	0	1	2	f	\N	\N
225	26	44	1	225	\N	225	1	1	0	1	2	f	\N	\N
226	20	44	1	219	\N	219	1	0	0	1	2	f	\N	\N
227	19	44	1	191	\N	191	1	1	0	1	2	f	\N	\N
228	28	44	1	140	\N	140	1	1	0	1	2	f	\N	\N
229	23	44	1	118	\N	118	1	1	0	1	2	f	\N	\N
230	27	44	1	89	\N	89	1	1	0	1	2	f	\N	\N
231	10	45	2	984	\N	0	1	1	1	1	2	t	984	\N
232	3	45	2	984	\N	0	1	0	0	1	2	t	984	\N
233	26	45	2	225	\N	0	1	1	0	1	2	t	225	\N
234	20	45	2	221	\N	0	1	1	0	1	2	t	221	\N
235	19	45	2	191	\N	0	1	1	0	1	2	t	191	\N
236	28	45	2	140	\N	0	1	1	0	1	2	t	140	\N
237	23	45	2	118	\N	0	1	1	0	1	2	t	118	\N
238	27	45	2	89	\N	0	1	1	0	1	2	t	89	\N
239	3	46	2	1596	\N	1596	1	1	1	1	2	f	0	\N
240	10	46	2	984	\N	984	1	1	0	1	2	f	0	\N
241	13	46	2	612	\N	612	1	1	0	1	2	f	0	\N
242	26	46	2	225	\N	225	1	1	0	1	2	f	0	\N
243	20	46	2	221	\N	221	1	1	0	1	2	f	0	\N
244	19	46	2	191	\N	191	1	1	0	1	2	f	0	\N
245	28	46	2	140	\N	140	1	1	0	1	2	f	0	\N
246	23	46	2	118	\N	118	1	1	0	1	2	f	0	\N
247	24	46	2	115	\N	115	1	1	0	1	2	f	0	\N
248	17	46	2	114	\N	114	1	1	0	1	2	f	0	\N
249	18	46	2	114	\N	114	1	1	0	1	2	f	0	\N
250	25	46	2	113	\N	113	1	1	0	1	2	f	0	\N
251	22	46	2	103	\N	103	1	1	0	1	2	f	0	\N
252	27	46	2	89	\N	89	1	1	0	1	2	f	0	\N
253	21	46	2	53	\N	53	1	1	0	1	2	f	0	\N
254	11	47	2	26	\N	0	1	0	1	1	2	t	26	\N
255	4	47	2	26	\N	0	1	0	0	1	2	t	26	\N
256	3	48	2	4788	\N	0	-1	1	1	1	2	t	4788	\N
257	9	48	2	2853	\N	0	-1	1	2	1	2	t	2853	\N
258	1	48	2	1023	\N	0	-1	1	3	1	2	t	1023	\N
259	4	48	2	975	\N	0	1	0	4	1	2	t	975	\N
260	6	48	2	381	\N	0	-1	1	5	1	2	t	381	\N
261	10	48	2	2952	\N	0	-1	1	0	1	2	t	2952	\N
262	13	48	2	1836	\N	0	-1	1	0	1	2	t	1836	\N
263	5	48	2	949	\N	0	1	1	0	1	2	t	949	\N
264	30	48	2	889	\N	0	1	1	0	1	2	t	889	\N
265	26	48	2	675	\N	0	-1	1	0	1	2	t	675	\N
266	20	48	2	663	\N	0	-1	1	0	1	2	t	663	\N
267	19	48	2	573	\N	0	-1	1	0	1	2	t	573	\N
268	28	48	2	420	\N	0	-1	1	0	1	2	t	420	\N
269	23	48	2	354	\N	0	-1	1	0	1	2	t	354	\N
270	24	48	2	345	\N	0	-1	1	0	1	2	t	345	\N
271	17	48	2	342	\N	0	-1	1	0	1	2	t	342	\N
272	18	48	2	342	\N	0	-1	1	0	1	2	t	342	\N
273	25	48	2	339	\N	0	-1	1	0	1	2	t	339	\N
274	22	48	2	309	\N	0	-1	1	0	1	2	t	309	\N
275	27	48	2	267	\N	0	-1	1	0	1	2	t	267	\N
276	21	48	2	159	\N	0	-1	1	0	1	2	t	159	\N
277	29	48	2	60	\N	0	1	1	0	1	2	t	60	\N
278	11	48	2	26	\N	0	1	0	0	1	2	t	26	\N
279	15	49	2	3	\N	0	1	1	1	1	2	t	3	\N
280	12	49	2	1	\N	0	1	1	2	1	2	t	1	\N
281	8	49	2	1	\N	0	1	1	3	1	2	t	1	\N
282	16	49	2	1	\N	0	1	1	4	1	2	t	1	\N
283	8	50	2	4	\N	4	-1	1	1	1	2	f	0	\N
284	5	51	2	949	\N	0	1	1	1	1	2	t	949	\N
285	4	51	2	949	\N	0	1	0	0	1	2	t	949	\N
286	30	51	2	889	\N	0	1	1	0	1	2	t	889	\N
287	29	51	2	60	\N	0	1	1	0	1	2	t	60	\N
288	3	52	2	1596	\N	0	1	1	1	1	2	t	1596	\N
289	10	52	2	984	\N	0	1	1	0	1	2	t	984	\N
290	13	52	2	612	\N	0	1	1	0	1	2	t	612	\N
291	26	52	2	225	\N	0	1	1	0	1	2	t	225	\N
292	20	52	2	221	\N	0	1	1	0	1	2	t	221	\N
293	19	52	2	191	\N	0	1	1	0	1	2	t	191	\N
294	28	52	2	140	\N	0	1	1	0	1	2	t	140	\N
295	23	52	2	118	\N	0	1	1	0	1	2	t	118	\N
296	24	52	2	115	\N	0	1	1	0	1	2	t	115	\N
297	17	52	2	114	\N	0	1	1	0	1	2	t	114	\N
298	18	52	2	114	\N	0	1	1	0	1	2	t	114	\N
299	25	52	2	113	\N	0	1	1	0	1	2	t	113	\N
300	22	52	2	103	\N	0	1	1	0	1	2	t	103	\N
301	27	52	2	89	\N	0	1	1	0	1	2	t	89	\N
302	21	52	2	53	\N	0	1	1	0	1	2	t	53	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index) FROM stdin;
1	8	6	676	\N	1
2	8	9	632	\N	2
3	9	9	632	\N	2
4	9	6	676	\N	1
5	10	9	605	\N	2
6	10	6	649	\N	1
7	11	6	27	\N	1
8	11	9	27	\N	2
9	12	5	676	\N	1
10	12	4	676	\N	0
11	12	29	27	\N	0
12	12	30	649	\N	0
13	13	4	632	\N	0
14	13	5	632	\N	1
15	13	29	27	\N	0
16	13	30	605	\N	0
17	17	3	982	\N	0
18	17	13	982	\N	1
19	17	21	89	\N	0
20	17	17	191	\N	0
21	17	22	140	\N	0
22	17	18	118	\N	0
23	17	25	225	\N	0
24	17	24	219	\N	0
25	18	13	982	\N	1
26	18	3	982	\N	0
27	18	18	118	\N	0
28	18	25	225	\N	0
29	18	17	191	\N	0
30	18	24	219	\N	0
31	18	22	140	\N	0
32	18	21	89	\N	0
33	19	3	225	\N	0
34	19	13	225	\N	0
35	19	25	225	\N	1
36	20	3	219	\N	0
37	20	13	219	\N	0
38	20	24	219	\N	1
39	21	13	191	\N	0
40	21	3	191	\N	0
41	21	17	191	\N	1
42	22	3	140	\N	0
43	22	13	140	\N	0
44	22	22	140	\N	1
45	23	3	118	\N	0
46	23	13	118	\N	0
47	23	18	118	\N	1
48	24	13	89	\N	0
49	24	3	89	\N	0
50	24	21	89	\N	1
51	25	3	982	\N	0
52	25	10	982	\N	1
53	25	19	191	\N	0
54	25	27	89	\N	0
55	25	26	225	\N	0
56	25	23	118	\N	0
57	25	20	219	\N	0
58	25	28	140	\N	0
59	26	10	982	\N	1
60	26	3	982	\N	0
61	26	23	118	\N	0
62	26	28	140	\N	0
63	26	26	225	\N	0
64	26	27	89	\N	0
65	26	20	219	\N	0
66	26	19	191	\N	0
67	27	3	225	\N	0
68	27	10	225	\N	0
69	27	26	225	\N	1
70	28	10	219	\N	0
71	28	3	219	\N	0
72	28	20	219	\N	1
73	29	10	191	\N	0
74	29	3	191	\N	0
75	29	19	191	\N	1
76	30	10	140	\N	0
77	30	3	140	\N	0
78	30	28	140	\N	1
79	31	3	118	\N	0
80	31	10	118	\N	0
81	31	23	118	\N	1
82	32	10	89	\N	0
83	32	3	89	\N	0
84	32	27	89	\N	1
85	35	7	1	\N	1
86	36	8	1	\N	1
87	39	1	797	\N	1
88	40	1	797	\N	1
89	41	1	771	\N	1
90	42	1	26	\N	1
91	43	5	797	\N	1
92	43	4	797	\N	0
93	43	29	26	\N	0
94	43	30	771	\N	0
95	44	8	1	\N	1
96	45	16	1	\N	1
97	46	12	2	\N	1
98	47	15	2	\N	1
99	49	13	982	\N	1
100	49	3	982	\N	0
101	49	24	219	\N	0
102	49	25	225	\N	0
103	49	22	140	\N	0
104	49	21	89	\N	0
105	49	18	118	\N	0
106	49	17	191	\N	0
107	50	13	952	\N	1
108	50	3	952	\N	0
109	50	21	89	\N	0
110	50	25	225	\N	0
111	50	22	110	\N	0
112	50	18	118	\N	0
113	50	24	219	\N	0
114	50	17	191	\N	0
115	51	13	891	\N	1
116	51	3	891	\N	0
117	51	24	215	\N	0
118	51	25	213	\N	0
119	51	22	92	\N	0
120	51	18	101	\N	0
121	51	21	87	\N	0
122	51	17	183	\N	0
123	52	13	61	\N	1
124	52	3	61	\N	0
125	52	21	2	\N	0
126	52	17	8	\N	0
127	52	18	17	\N	0
128	52	24	4	\N	0
129	52	25	12	\N	0
130	52	22	18	\N	0
131	53	13	30	\N	0
132	53	3	30	\N	0
133	53	22	30	\N	1
134	54	5	952	\N	0
135	54	4	982	\N	1
136	54	11	30	\N	0
137	54	30	891	\N	0
138	54	29	61	\N	0
139	55	5	952	\N	0
140	55	4	982	\N	1
141	55	11	30	\N	0
142	55	29	61	\N	0
143	55	30	891	\N	0
144	56	5	225	\N	1
145	56	4	225	\N	0
146	56	30	213	\N	0
147	56	29	12	\N	0
148	57	4	219	\N	0
149	57	5	219	\N	1
150	57	30	215	\N	0
151	57	29	4	\N	0
152	58	4	191	\N	0
153	58	5	191	\N	1
154	58	29	8	\N	0
155	58	30	183	\N	0
156	59	4	140	\N	1
157	59	11	30	\N	0
158	59	5	110	\N	0
159	59	30	92	\N	0
160	59	29	18	\N	0
161	60	4	118	\N	0
162	60	5	118	\N	1
163	60	30	101	\N	0
164	60	29	17	\N	0
165	61	5	89	\N	1
166	61	4	89	\N	0
167	61	29	2	\N	0
168	61	30	87	\N	0
169	63	10	984	\N	1
170	63	3	984	\N	0
171	63	26	225	\N	0
172	63	23	118	\N	0
173	63	19	191	\N	0
174	63	28	140	\N	0
175	63	27	89	\N	0
176	63	20	221	\N	0
177	64	3	954	\N	0
178	64	10	954	\N	1
179	64	26	225	\N	0
180	64	19	191	\N	0
181	64	28	110	\N	0
182	64	27	89	\N	0
183	64	20	221	\N	0
184	64	23	118	\N	0
185	65	10	893	\N	1
186	65	3	893	\N	0
187	65	20	217	\N	0
188	65	19	183	\N	0
189	65	27	87	\N	0
190	65	28	92	\N	0
191	65	23	101	\N	0
192	65	26	213	\N	0
193	66	3	61	\N	0
194	66	10	61	\N	1
195	66	27	2	\N	0
196	66	23	17	\N	0
197	66	26	12	\N	0
198	66	19	8	\N	0
199	66	28	18	\N	0
200	66	20	4	\N	0
201	67	3	30	\N	0
202	67	10	30	\N	0
203	67	28	30	\N	1
204	68	4	984	\N	1
205	68	5	954	\N	0
206	68	11	30	\N	0
207	68	30	893	\N	0
208	68	29	61	\N	0
209	69	5	954	\N	0
210	69	4	984	\N	1
211	69	11	30	\N	0
212	69	29	61	\N	0
213	69	30	893	\N	0
214	70	5	225	\N	1
215	70	4	225	\N	0
216	70	29	12	\N	0
217	70	30	213	\N	0
218	71	5	221	\N	1
219	71	4	221	\N	0
220	71	30	217	\N	0
221	71	29	4	\N	0
222	72	5	191	\N	1
223	72	4	191	\N	0
224	72	30	183	\N	0
225	72	29	8	\N	0
226	73	4	140	\N	1
227	73	5	110	\N	0
228	73	11	30	\N	0
229	73	30	92	\N	0
230	73	29	18	\N	0
231	74	4	118	\N	0
232	74	5	118	\N	1
233	74	29	17	\N	0
234	74	30	101	\N	0
235	75	5	89	\N	1
236	75	4	89	\N	0
237	75	29	2	\N	0
238	75	30	87	\N	0
239	77	14	1	\N	1
240	78	14	1	\N	1
241	79	16	1	\N	1
242	79	8	1	\N	2
243	80	11	60	\N	0
244	80	4	1966	\N	1
245	80	5	1906	\N	0
246	80	30	1784	\N	0
247	80	29	122	\N	0
248	81	11	30	\N	0
249	81	4	984	\N	1
250	81	5	954	\N	0
251	81	30	893	\N	0
252	81	29	61	\N	0
253	82	4	982	\N	1
254	82	5	952	\N	0
255	82	11	30	\N	0
256	82	29	61	\N	0
257	82	30	891	\N	0
258	83	4	225	\N	0
259	83	5	225	\N	1
260	83	29	12	\N	0
261	83	30	213	\N	0
262	84	5	225	\N	1
263	84	4	225	\N	0
264	84	30	213	\N	0
265	84	29	12	\N	0
266	85	5	221	\N	1
267	85	4	221	\N	0
268	85	29	4	\N	0
269	85	30	217	\N	0
270	86	4	219	\N	0
271	86	5	219	\N	1
272	86	30	215	\N	0
273	86	29	4	\N	0
274	87	4	191	\N	0
275	87	5	191	\N	1
276	87	30	183	\N	0
277	87	29	8	\N	0
278	88	5	191	\N	1
279	88	4	191	\N	0
280	88	29	8	\N	0
281	88	30	183	\N	0
282	89	4	140	\N	1
283	89	5	110	\N	0
284	89	11	30	\N	0
285	89	30	92	\N	0
286	89	29	18	\N	0
287	90	5	110	\N	0
288	90	4	140	\N	1
289	90	11	30	\N	0
290	90	29	18	\N	0
291	90	30	92	\N	0
292	91	4	118	\N	0
293	91	5	118	\N	1
294	91	29	17	\N	0
295	91	30	101	\N	0
296	92	5	118	\N	1
297	92	4	118	\N	0
298	92	29	17	\N	0
299	92	30	101	\N	0
300	93	4	89	\N	0
301	93	5	89	\N	1
302	93	29	2	\N	0
303	93	30	87	\N	0
304	94	5	89	\N	1
305	94	4	89	\N	0
306	94	29	2	\N	0
307	94	30	87	\N	0
308	95	13	982	\N	0
309	95	3	1966	\N	1
310	95	10	984	\N	0
311	95	24	219	\N	0
312	95	26	225	\N	0
313	95	19	191	\N	0
314	95	28	140	\N	0
315	95	17	191	\N	0
316	95	22	140	\N	0
317	95	27	89	\N	0
318	95	23	118	\N	0
319	95	18	118	\N	0
320	95	25	225	\N	0
321	95	21	89	\N	0
322	95	20	221	\N	0
323	96	13	952	\N	0
324	96	10	954	\N	0
325	96	3	1906	\N	1
326	96	22	110	\N	0
327	96	25	225	\N	0
328	96	20	221	\N	0
329	96	24	219	\N	0
330	96	17	191	\N	0
331	96	21	89	\N	0
332	96	18	118	\N	0
333	96	19	191	\N	0
334	96	26	225	\N	0
335	96	28	110	\N	0
336	96	27	89	\N	0
337	96	23	118	\N	0
338	97	10	893	\N	0
339	97	3	1784	\N	1
340	97	13	891	\N	0
341	97	19	183	\N	0
342	97	25	213	\N	0
343	97	17	183	\N	0
344	97	28	92	\N	0
345	97	24	215	\N	0
346	97	18	101	\N	0
347	97	22	92	\N	0
348	97	27	87	\N	0
349	97	23	101	\N	0
350	97	20	217	\N	0
351	97	26	213	\N	0
352	97	21	87	\N	0
353	98	10	61	\N	0
354	98	13	61	\N	0
355	98	3	122	\N	1
356	98	26	12	\N	0
357	98	21	2	\N	0
358	98	17	8	\N	0
359	98	20	4	\N	0
360	98	18	17	\N	0
361	98	19	8	\N	0
362	98	23	17	\N	0
363	98	28	18	\N	0
364	98	22	18	\N	0
365	98	25	12	\N	0
366	98	27	2	\N	0
367	98	24	4	\N	0
368	99	3	60	\N	1
369	99	10	30	\N	0
370	99	13	30	\N	0
371	99	22	30	\N	0
372	99	28	30	\N	0
373	108	9	338	\N	1
374	109	1	338	\N	1
375	168	6	345	\N	1
376	169	1	345	\N	1
377	179	1	799	\N	1
378	180	1	799	\N	1
379	181	1	248	\N	1
380	182	1	244	\N	1
381	183	1	211	\N	1
382	184	1	92	\N	1
383	185	1	4	\N	1
384	186	10	799	\N	1
385	186	3	799	\N	0
386	186	27	92	\N	0
387	186	19	211	\N	0
388	186	26	248	\N	0
389	186	28	4	\N	0
390	186	20	244	\N	0
391	196	6	1060	\N	1
392	196	9	944	\N	2
393	197	9	944	\N	2
394	197	6	1060	\N	1
395	198	9	885	\N	2
396	198	6	992	\N	1
397	199	6	68	\N	1
398	199	9	59	\N	2
399	200	5	1060	\N	1
400	200	4	1060	\N	0
401	200	29	68	\N	0
402	200	30	992	\N	0
403	201	4	944	\N	0
404	201	5	944	\N	1
405	201	29	59	\N	0
406	201	30	885	\N	0
407	207	9	21	\N	2
408	207	6	23	\N	1
409	208	9	21	\N	2
410	208	6	23	\N	1
411	209	4	23	\N	0
412	209	11	23	\N	1
413	210	4	21	\N	0
414	210	11	21	\N	1
415	212	15	3	\N	1
416	213	8	3	\N	1
417	215	3	982	\N	0
418	215	10	982	\N	1
419	215	20	219	\N	0
420	215	19	191	\N	0
421	215	27	89	\N	0
422	215	28	140	\N	0
423	215	23	118	\N	0
424	215	26	225	\N	0
425	216	10	982	\N	1
426	216	3	982	\N	0
427	216	19	191	\N	0
428	216	26	225	\N	0
429	216	28	140	\N	0
430	216	20	219	\N	0
431	216	27	89	\N	0
432	216	23	118	\N	0
433	217	3	225	\N	0
434	217	10	225	\N	0
435	217	26	225	\N	1
436	218	10	219	\N	0
437	218	3	219	\N	0
438	218	20	219	\N	1
439	219	10	191	\N	0
440	219	3	191	\N	0
441	219	19	191	\N	1
442	220	10	140	\N	0
443	220	3	140	\N	0
444	220	28	140	\N	1
445	221	10	118	\N	0
446	221	3	118	\N	0
447	221	23	118	\N	1
448	222	3	89	\N	0
449	222	10	89	\N	0
450	222	27	89	\N	1
451	223	13	982	\N	1
452	223	3	982	\N	0
453	223	24	219	\N	0
454	223	17	191	\N	0
455	223	18	118	\N	0
456	223	22	140	\N	0
457	223	25	225	\N	0
458	223	21	89	\N	0
459	224	13	982	\N	1
460	224	3	982	\N	0
461	224	25	225	\N	0
462	224	18	118	\N	0
463	224	17	191	\N	0
464	224	21	89	\N	0
465	224	22	140	\N	0
466	224	24	219	\N	0
467	225	3	225	\N	0
468	225	13	225	\N	0
469	225	25	225	\N	1
470	226	13	219	\N	0
471	226	3	219	\N	0
472	226	24	219	\N	1
473	227	3	191	\N	0
474	227	13	191	\N	0
475	227	17	191	\N	1
476	228	3	140	\N	0
477	228	13	140	\N	0
478	228	22	140	\N	1
479	229	3	118	\N	0
480	229	13	118	\N	0
481	229	18	118	\N	1
482	230	13	89	\N	0
483	230	3	89	\N	0
484	230	21	89	\N	1
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cpd_rels (id, cp_rel_id, datatype_id, cnt, data) FROM stdin;
1	1	2	1	\N
2	2	1	949	\N
3	2	3	75	\N
4	3	3	1	\N
5	4	1	949	\N
6	5	1	889	\N
7	6	3	75	\N
8	7	1	60	\N
9	15	3	1	\N
10	16	3	1	\N
11	34	1	1	\N
12	37	4	26	\N
13	38	4	26	\N
14	48	3	1	\N
15	100	5	984	\N
16	101	5	984	\N
17	102	5	225	\N
18	103	5	221	\N
19	104	5	191	\N
20	105	5	140	\N
21	106	5	118	\N
22	107	5	89	\N
23	110	1	949	\N
24	111	1	949	\N
25	112	1	889	\N
26	113	1	60	\N
27	144	5	612	\N
28	145	5	612	\N
29	146	5	115	\N
30	147	5	114	\N
31	148	5	114	\N
32	149	5	113	\N
33	150	5	103	\N
34	151	5	53	\N
35	153	4	949	\N
36	154	4	949	\N
37	155	4	889	\N
38	156	4	60	\N
39	157	3	1968	\N
40	158	3	1957	\N
41	159	3	448	\N
42	160	3	439	\N
43	161	3	380	\N
44	162	3	280	\N
45	163	3	235	\N
46	164	3	175	\N
47	165	3	11	\N
48	166	3	8	\N
49	167	3	3	\N
50	170	4	650	\N
51	171	4	650	\N
52	172	4	623	\N
53	173	4	27	\N
54	174	1	947	\N
55	175	1	947	\N
56	176	1	888	\N
57	177	1	59	\N
58	203	1	949	\N
59	204	1	949	\N
60	205	1	889	\N
61	206	1	60	\N
62	211	1	3	\N
63	214	2	1	\N
64	231	5	984	\N
65	232	5	984	\N
66	233	5	225	\N
67	234	5	221	\N
68	235	5	191	\N
69	236	5	140	\N
70	237	5	118	\N
71	238	5	89	\N
72	254	4	26	\N
73	255	4	26	\N
74	256	3	4788	\N
75	257	3	2853	\N
76	258	3	1023	\N
77	259	1	975	\N
78	260	3	381	\N
79	261	3	2952	\N
80	262	3	1836	\N
81	263	1	949	\N
82	264	1	889	\N
83	265	3	675	\N
84	266	3	663	\N
85	267	3	573	\N
86	268	3	420	\N
87	269	3	354	\N
88	270	3	345	\N
89	271	3	342	\N
90	272	3	342	\N
91	273	3	339	\N
92	274	3	309	\N
93	275	3	267	\N
94	276	3	159	\N
95	277	1	60	\N
96	278	1	26	\N
97	279	3	3	\N
98	280	3	1	\N
99	281	3	1	\N
100	282	3	1	\N
101	284	4	949	\N
102	285	4	949	\N
103	286	4	889	\N
104	287	4	60	\N
105	288	5	1596	\N
106	289	5	984	\N
107	290	5	612	\N
108	291	5	225	\N
109	292	5	221	\N
110	293	5	191	\N
111	294	5	140	\N
112	295	5	118	\N
113	296	5	115	\N
114	297	5	114	\N
115	298	5	114	\N
116	299	5	113	\N
117	300	5	103	\N
118	301	5	89	\N
119	302	5	53	\N
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.datatypes (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2001/XMLSchema#string	3	string
2	http://www.w3.org/2001/XMLSchema#gYear	3	gYear
3	http://www.w3.org/1999/02/22-rdf-syntax-ns#langString	1	langString
4	http://www.w3.org/2001/XMLSchema#date	3	date
5	http://www.w3.org/2001/XMLSchema#integer	3	integer
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
73	categ	http://data.nobelprize.org/resource/category/	0	f	0
3	xsd	http://www.w3.org/2001/XMLSchema#	0	f	0
4	skos	http://www.w3.org/2004/02/skos/core#	0	f	0
19	dbp	http://dbpedia.org/property/	0	f	0
6	dc	http://purl.org/dc/elements/1.1/	0	f	0
75	sschema	https://schema.org/	0	f	0
1	rdf	http://www.w3.org/1999/02/22-rdf-syntax-ns#	0	f	0
82	univ	http://data.nobelprize.org/resource/university/	0	f	0
9	schema	http://schema.org/	0	f	0
11	yago	http://dbpedia.org/class/yago/	0	f	0
12	wd	http://www.wikidata.org/entity/	0	f	0
13	wdt	http://www.wikidata.org/prop/direct/	0	f	0
14	shacl	http://www.w3.org/ns/shacl#	0	f	0
2	rdfs	http://www.w3.org/2000/01/rdf-schema#	0	f	0
16	void	http://rdfs.org/ns/void#	0	f	0
17	virtrdf	http://www.openlinksw.com/schemas/virtrdf#	0	f	0
18	dav	http://www.openlinksw.com/schemas/DAV#	0	f	0
68		http://data.nobelprize.org/terms/	0	t	0
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
35	voaf	 http://purl.org/vocommons/voaf#	0	f	0
36	gr	http://purl.org/goodrelations/v1#	0	f	0
37	org	http://www.w3.org/ns/org#	0	f	0
38	sioc	http://rdfs.org/sioc/ns#	0	f	0
80	adms	http://www.w3.org/ns/adms#	0	f	0
40	obo	http://purl.obolibrary.org/obo/	0	f	0
5	dct	http://purl.org/dc/terms/	0	f	0
15	dcat	http://www.w3.org/ns/dcat#	0	f	0
10	dbo	http://dbpedia.org/ontology/	0	f	0
8	foaf	http://xmlns.com/foaf/0.1/	0	f	0
39	vcard	http://www.w3.org/2006/vcard/ns#	0	f	0
7	owl	http://www.w3.org/2002/07/owl#	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
30	endpoint_url	http://85.254.199.72:8890/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	24
60	endpoint_public_url	http://85.254.199.72:8890/sparql	\N	Human readable web site of the endpoint, if available.	27
999	calculateSubClassRelations	true	\N	\N	15
999	calculatePropertyPropertyRelations	true	\N	\N	16
999	calculateDomainAndRangePairs	true	\N	\N	17
999	calculateDataTypes	true	\N	\N	18
999	calculateCardinalities	propertyLevelAndClassContext	\N	\N	19
999	checkInstanceNamespaces	true	\N	\N	20
999	minimalAnalyzedClassSize	1	\N	\N	21
20	schema_description	\N	\N	Description of the schema.	23
40	named_graph	\N	\N	Default named graph for visual environment projects using this schema.	25
110	tree_profile	\N	\N	A custom configuration of the entity lookup pane tree (copy the initial value from the parameters of a similar schema).	30
240	use_pp_rels	\N	\N	Use the property-property relationships from the data schema in the query auto-completion (the property-property relationships must be retrieved from the data and stored in the pp_rels table).	35
250	direct_class_role	\N	\N	Default property to be used for instance-to-class relationship. Leave empty in the most typical case of the property being rdf:type.	36
260	indirect_class_role	\N	\N	Fill in, if an indirect class membership is to be used in the environment, along with the direct membership (normally leave empty).	37
330	use_instance_table	\N	\N	Mark, if a dedicated instance table is installed within the data schema (requires a custom solution).	38
500	schema_extraction_details	\N	\N	JSON with parameters used in schema extraction.	39
510	schema_import_datetime	\N	\N	Date and time when the schema has been imported from extracted JSON data.	40
50	endpoint_type	virtuoso	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	26
10	display_name_default	NobelPrizes	\N	Recommended display name to be used in schema registry.	22
90	db_schema_name	nobel_prizes	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	28
100	tree_profile_name	default	\N	Look up public tree profile by this name (mutually exclusive with local tree_profile).	29
220	show_instance_tab	\N	true	Show instance tab in the entity lookup pane in the visual environment.	33
230	instance_lookup_mode	default	\N	table - use instances table, default - use data endpoint	34
210	instance_name_pattern	\N	{"label": {"property": "rdfs:label"}}	Default pattern for instance name presentation in visual query fields. Work in progress. Can be overriden on individual class level. Leave empty to present instances by their URIs.	32
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	31
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.pd_rels (id, property_id, datatype_id, cnt, data) FROM stdin;
1	1	2	1	\N
2	2	1	949	\N
3	2	3	76	\N
4	5	3	2	\N
5	8	1	1	\N
6	10	4	26	\N
7	14	3	1	\N
8	21	5	984	\N
9	23	1	949	\N
10	25	5	612	\N
11	27	4	949	\N
12	28	3	1968	\N
13	30	4	650	\N
14	31	1	947	\N
15	39	1	949	\N
16	41	1	3	\N
17	43	2	1	\N
18	45	5	984	\N
19	47	4	26	\N
20	48	1	975	\N
21	48	3	9046	\N
22	49	3	6	\N
23	51	4	949	\N
24	52	5	1596	\N
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data) FROM stdin;
1	1	1	2	1	\N
2	1	24	2	1	\N
3	2	37	2	2004	\N
4	2	24	2	1953	\N
5	2	3	2	1308	\N
6	2	2	2	1025	\N
7	2	17	2	984	\N
8	2	15	2	984	\N
9	2	34	2	976	\N
10	2	48	2	975	\N
11	2	27	2	949	\N
12	2	51	2	949	\N
13	2	23	2	949	\N
14	2	39	2	949	\N
15	2	31	2	947	\N
16	2	11	2	797	\N
17	2	30	2	650	\N
18	2	40	2	44	\N
19	2	47	2	26	\N
20	2	10	2	26	\N
21	3	48	1	1113	\N
22	3	24	1	371	\N
23	3	34	1	349	\N
24	3	3	3	1308	\N
25	3	37	3	1266	\N
26	3	29	3	345	\N
27	3	22	3	233	\N
28	3	40	3	38	\N
29	3	37	2	1368	\N
30	3	3	2	1308	\N
31	3	24	2	1278	\N
32	3	17	2	643	\N
33	3	15	2	643	\N
34	3	27	2	639	\N
35	3	30	2	639	\N
36	3	48	2	639	\N
37	3	34	2	639	\N
38	3	51	2	639	\N
39	3	23	2	639	\N
40	3	39	2	639	\N
41	3	2	2	639	\N
42	3	31	2	638	\N
43	3	11	2	492	\N
44	4	4	3	1	\N
45	4	50	2	4	\N
46	4	38	2	3	\N
47	4	42	2	3	\N
48	4	4	2	1	\N
49	4	36	2	1	\N
50	4	5	2	1	\N
51	4	43	2	1	\N
52	4	19	2	1	\N
53	4	7	2	1	\N
54	4	49	2	1	\N
55	4	24	2	1	\N
56	4	9	2	1	\N
57	4	14	2	1	\N
58	4	32	2	1	\N
59	5	50	2	4	\N
60	5	38	2	3	\N
61	5	42	2	3	\N
62	5	5	2	2	\N
63	5	19	2	2	\N
64	5	49	2	2	\N
65	5	24	2	2	\N
66	5	4	2	1	\N
67	5	36	2	1	\N
68	5	43	2	1	\N
69	5	7	2	1	\N
70	5	9	2	1	\N
71	5	12	2	1	\N
72	5	14	2	1	\N
73	5	32	2	1	\N
74	6	48	1	1836	\N
75	6	24	1	1224	\N
76	6	20	1	982	\N
77	6	44	1	982	\N
78	6	46	1	612	\N
79	6	25	1	612	\N
80	6	52	1	612	\N
81	6	28	1	11	\N
82	6	15	3	984	\N
83	6	6	3	984	\N
84	6	48	2	2952	\N
85	6	24	2	1968	\N
86	6	28	2	1957	\N
87	6	46	2	984	\N
88	6	20	2	984	\N
89	6	45	2	984	\N
90	6	21	2	984	\N
91	6	52	2	984	\N
92	6	6	2	984	\N
93	6	33	2	799	\N
94	7	48	1	1	\N
95	7	7	3	1	\N
96	7	50	2	4	\N
97	7	38	2	3	\N
98	7	42	2	3	\N
99	7	4	2	1	\N
100	7	36	2	1	\N
101	7	5	2	1	\N
102	7	43	2	1	\N
103	7	19	2	1	\N
104	7	7	2	1	\N
105	7	49	2	1	\N
106	7	24	2	1	\N
107	7	9	2	1	\N
108	7	14	2	1	\N
109	7	32	2	1	\N
110	8	24	2	1	\N
111	8	8	2	1	\N
112	8	26	2	1	\N
113	9	24	1	1	\N
114	9	8	1	1	\N
115	9	26	1	1	\N
116	9	9	3	1	\N
117	9	50	2	4	\N
118	9	38	2	3	\N
119	9	42	2	3	\N
120	9	4	2	1	\N
121	9	36	2	1	\N
122	9	5	2	1	\N
123	9	43	2	1	\N
124	9	19	2	1	\N
125	9	7	2	1	\N
126	9	49	2	1	\N
127	9	24	2	1	\N
128	9	9	2	1	\N
129	9	14	2	1	\N
130	9	32	2	1	\N
131	10	2	2	72	\N
132	10	24	2	52	\N
133	10	40	2	44	\N
134	10	17	2	29	\N
135	10	15	2	29	\N
136	10	47	2	26	\N
137	10	34	2	26	\N
138	10	10	2	26	\N
139	10	48	2	25	\N
140	11	48	1	1023	\N
141	11	29	1	345	\N
142	11	24	1	341	\N
143	11	22	1	338	\N
144	11	33	3	799	\N
145	11	11	3	797	\N
146	11	37	2	1508	\N
147	11	24	2	1438	\N
148	11	3	2	944	\N
149	11	11	2	797	\N
150	11	17	2	724	\N
151	11	15	2	724	\N
152	11	27	2	719	\N
153	11	48	2	719	\N
154	11	34	2	719	\N
155	11	51	2	719	\N
156	11	31	2	719	\N
157	11	23	2	719	\N
158	11	39	2	719	\N
159	11	2	2	719	\N
160	11	30	2	470	\N
161	12	50	1	4	\N
162	12	38	1	3	\N
163	12	42	1	3	\N
164	12	4	1	1	\N
165	12	36	1	1	\N
166	12	5	1	1	\N
167	12	43	1	1	\N
168	12	19	1	1	\N
169	12	7	1	1	\N
170	12	49	1	1	\N
171	12	24	1	1	\N
172	12	9	1	1	\N
173	12	14	1	1	\N
174	12	32	1	1	\N
175	12	12	3	1	\N
176	12	5	2	1	\N
177	12	19	2	1	\N
178	12	49	2	1	\N
179	12	24	2	1	\N
180	12	12	2	1	\N
181	13	49	1	1	\N
182	13	24	1	1	\N
183	13	13	3	2	\N
184	13	13	2	2	\N
185	13	41	2	2	\N
186	13	35	2	2	\N
187	13	49	2	2	\N
188	13	24	2	2	\N
189	13	16	2	2	\N
190	13	18	2	2	\N
191	14	50	2	4	\N
192	14	38	2	3	\N
193	14	42	2	3	\N
194	14	4	2	1	\N
195	14	36	2	1	\N
196	14	5	2	1	\N
197	14	43	2	1	\N
198	14	19	2	1	\N
199	14	7	2	1	\N
200	14	49	2	1	\N
201	14	24	2	1	\N
202	14	9	2	1	\N
203	14	14	2	1	\N
204	14	32	2	1	\N
205	15	48	1	1836	\N
206	15	24	1	1224	\N
207	15	20	1	982	\N
208	15	44	1	982	\N
209	15	46	1	612	\N
210	15	25	1	612	\N
211	15	52	1	612	\N
212	15	28	1	11	\N
213	15	15	3	984	\N
214	15	6	3	984	\N
215	15	37	2	2004	\N
216	15	24	2	1952	\N
217	15	3	2	1308	\N
218	15	2	2	1024	\N
219	15	17	2	984	\N
220	15	15	2	984	\N
221	15	34	2	976	\N
222	15	48	2	975	\N
223	15	27	2	949	\N
224	15	51	2	949	\N
225	15	23	2	949	\N
226	15	39	2	949	\N
227	15	31	2	947	\N
228	15	11	2	797	\N
229	15	30	2	650	\N
230	15	40	2	44	\N
231	15	47	2	26	\N
232	15	10	2	26	\N
233	16	16	3	2	\N
234	16	13	2	2	\N
235	16	41	2	2	\N
236	16	35	2	2	\N
237	16	49	2	2	\N
238	16	24	2	2	\N
239	16	16	2	2	\N
240	16	18	2	2	\N
241	17	48	1	2952	\N
242	17	24	1	1968	\N
243	17	28	1	1957	\N
244	17	46	1	984	\N
245	17	20	1	984	\N
246	17	45	1	984	\N
247	17	21	1	984	\N
248	17	52	1	984	\N
249	17	6	1	984	\N
250	17	33	1	799	\N
251	17	17	3	984	\N
252	17	44	3	982	\N
253	17	37	2	2004	\N
254	17	24	2	1952	\N
255	17	3	2	1308	\N
256	17	2	2	1024	\N
257	17	17	2	984	\N
258	17	15	2	984	\N
259	17	34	2	976	\N
260	17	48	2	975	\N
261	17	27	2	949	\N
262	17	51	2	949	\N
263	17	23	2	949	\N
264	17	39	2	949	\N
265	17	31	2	947	\N
266	17	11	2	797	\N
267	17	30	2	650	\N
268	17	40	2	44	\N
269	17	47	2	26	\N
270	17	10	2	26	\N
271	18	18	3	3	\N
272	18	41	2	3	\N
273	18	35	2	3	\N
274	18	49	2	3	\N
275	18	24	2	3	\N
276	18	18	2	3	\N
277	18	13	2	2	\N
278	18	16	2	2	\N
279	19	24	1	1	\N
280	19	2	1	1	\N
281	19	19	3	2	\N
282	19	50	2	4	\N
283	19	38	2	3	\N
284	19	42	2	3	\N
285	19	5	2	2	\N
286	19	19	2	2	\N
287	19	49	2	2	\N
288	19	24	2	2	\N
289	19	4	2	1	\N
290	19	36	2	1	\N
291	19	43	2	1	\N
292	19	7	2	1	\N
293	19	9	2	1	\N
294	19	12	2	1	\N
295	19	14	2	1	\N
296	19	32	2	1	\N
297	20	37	1	2004	\N
298	20	24	1	1952	\N
299	20	3	1	1308	\N
300	20	2	1	1024	\N
301	20	17	1	984	\N
302	20	15	1	984	\N
303	20	34	1	976	\N
304	20	48	1	975	\N
305	20	27	1	949	\N
306	20	51	1	949	\N
307	20	23	1	949	\N
308	20	39	1	949	\N
309	20	31	1	947	\N
310	20	11	1	797	\N
311	20	30	1	650	\N
312	20	40	1	44	\N
313	20	47	1	26	\N
314	20	10	1	26	\N
315	20	20	3	1966	\N
316	20	48	2	4788	\N
317	20	24	2	3192	\N
318	20	28	2	1968	\N
319	20	20	2	1966	\N
320	20	46	2	1596	\N
321	20	52	2	1596	\N
322	20	45	2	984	\N
323	20	21	2	984	\N
324	20	6	2	984	\N
325	20	44	2	982	\N
326	20	33	2	799	\N
327	20	25	2	612	\N
328	21	48	2	2952	\N
329	21	24	2	1968	\N
330	21	28	2	1957	\N
331	21	46	2	984	\N
332	21	20	2	984	\N
333	21	45	2	984	\N
334	21	21	2	984	\N
335	21	52	2	984	\N
336	21	6	2	984	\N
337	21	33	2	799	\N
338	22	48	1	558	\N
339	22	24	1	186	\N
340	22	34	1	181	\N
341	22	3	3	382	\N
342	22	22	3	338	\N
343	22	37	3	323	\N
344	22	40	3	18	\N
345	22	48	2	1014	\N
346	22	29	2	344	\N
347	22	22	2	338	\N
348	22	24	2	338	\N
349	23	37	2	2004	\N
350	23	24	2	1898	\N
351	23	3	2	1308	\N
352	23	17	2	954	\N
353	23	15	2	954	\N
354	23	27	2	949	\N
355	23	48	2	949	\N
356	23	34	2	949	\N
357	23	51	2	949	\N
358	23	23	2	949	\N
359	23	39	2	949	\N
360	23	2	2	949	\N
361	23	31	2	947	\N
362	23	11	2	797	\N
363	23	30	2	650	\N
364	24	24	3	6572	\N
365	24	48	2	10020	\N
366	24	24	2	6572	\N
367	24	37	2	2004	\N
368	24	28	2	1968	\N
369	24	20	2	1966	\N
370	24	34	2	1947	\N
371	24	46	2	1596	\N
372	24	52	2	1596	\N
373	24	3	2	1308	\N
374	24	2	2	1025	\N
375	24	17	2	984	\N
376	24	15	2	984	\N
377	24	45	2	984	\N
378	24	21	2	984	\N
379	24	6	2	984	\N
380	24	44	2	982	\N
381	24	27	2	949	\N
382	24	51	2	949	\N
383	24	23	2	949	\N
384	24	39	2	949	\N
385	24	31	2	947	\N
386	24	33	2	799	\N
387	24	11	2	797	\N
388	24	30	2	650	\N
389	24	25	2	612	\N
390	24	29	2	345	\N
391	24	22	2	338	\N
392	24	40	2	44	\N
393	24	47	2	26	\N
394	24	10	2	26	\N
395	24	49	2	6	\N
396	24	50	2	4	\N
397	24	41	2	3	\N
398	24	38	2	3	\N
399	24	35	2	3	\N
400	24	18	2	3	\N
401	24	42	2	3	\N
402	24	13	2	2	\N
403	24	5	2	2	\N
404	24	19	2	2	\N
405	24	16	2	2	\N
406	24	4	2	1	\N
407	24	36	2	1	\N
408	24	43	2	1	\N
409	24	7	2	1	\N
410	24	1	2	1	\N
411	24	8	2	1	\N
412	24	26	2	1	\N
413	24	9	2	1	\N
414	24	12	2	1	\N
415	24	14	2	1	\N
416	24	32	2	1	\N
417	25	48	2	1836	\N
418	25	24	2	1224	\N
419	25	20	2	982	\N
420	25	44	2	982	\N
421	25	46	2	612	\N
422	25	25	2	612	\N
423	25	52	2	612	\N
424	25	28	2	11	\N
425	26	26	3	1	\N
426	26	24	2	1	\N
427	26	8	2	1	\N
428	26	26	2	1	\N
429	27	37	2	2004	\N
430	27	24	2	1898	\N
431	27	3	2	1308	\N
432	27	17	2	954	\N
433	27	15	2	954	\N
434	27	27	2	949	\N
435	27	48	2	949	\N
436	27	34	2	949	\N
437	27	51	2	949	\N
438	27	23	2	949	\N
439	27	39	2	949	\N
440	27	2	2	949	\N
441	27	31	2	947	\N
442	27	11	2	797	\N
443	27	30	2	650	\N
444	28	48	2	2979	\N
445	28	24	2	1986	\N
446	28	28	2	1968	\N
447	28	20	2	1007	\N
448	28	46	2	993	\N
449	28	52	2	993	\N
450	28	45	2	984	\N
451	28	21	2	984	\N
452	28	6	2	984	\N
453	28	33	2	799	\N
454	28	44	2	23	\N
455	28	25	2	9	\N
456	29	48	1	81	\N
457	29	24	1	27	\N
458	29	34	1	24	\N
459	29	37	3	824	\N
460	29	3	3	605	\N
461	29	29	3	345	\N
462	29	40	3	21	\N
463	29	48	2	1017	\N
464	29	29	2	345	\N
465	29	24	2	339	\N
466	29	22	2	338	\N
467	30	37	2	1392	\N
468	30	3	2	1308	\N
469	30	24	2	1300	\N
470	30	17	2	654	\N
471	30	15	2	654	\N
472	30	27	2	650	\N
473	30	30	2	650	\N
474	30	48	2	650	\N
475	30	34	2	650	\N
476	30	51	2	650	\N
477	30	23	2	650	\N
478	30	39	2	650	\N
479	30	2	2	650	\N
480	30	31	2	649	\N
481	30	11	2	503	\N
482	31	37	2	1999	\N
483	31	24	2	1894	\N
484	31	3	2	1306	\N
485	31	17	2	952	\N
486	31	15	2	952	\N
487	31	27	2	947	\N
488	31	48	2	947	\N
489	31	34	2	947	\N
490	31	51	2	947	\N
491	31	31	2	947	\N
492	31	23	2	947	\N
493	31	39	2	947	\N
494	31	2	2	947	\N
495	31	11	2	797	\N
496	31	30	2	649	\N
497	32	32	3	1	\N
498	32	50	2	4	\N
499	32	38	2	3	\N
500	32	42	2	3	\N
501	32	4	2	1	\N
502	32	36	2	1	\N
503	32	5	2	1	\N
504	32	43	2	1	\N
505	32	19	2	1	\N
506	32	7	2	1	\N
507	32	49	2	1	\N
508	32	24	2	1	\N
509	32	9	2	1	\N
510	32	14	2	1	\N
511	32	32	2	1	\N
512	33	48	1	1023	\N
513	33	29	1	345	\N
514	33	24	1	341	\N
515	33	22	1	338	\N
516	33	33	3	799	\N
517	33	11	3	797	\N
518	33	48	2	2169	\N
519	33	24	2	1446	\N
520	33	28	2	1436	\N
521	33	33	2	799	\N
522	33	46	2	723	\N
523	33	20	2	723	\N
524	33	45	2	723	\N
525	33	21	2	723	\N
526	33	52	2	723	\N
527	33	6	2	723	\N
528	34	34	3	1947	\N
529	34	48	2	3888	\N
530	34	24	2	2923	\N
531	34	37	2	2004	\N
532	34	34	2	1947	\N
533	34	3	2	1308	\N
534	34	2	2	1024	\N
535	34	17	2	984	\N
536	34	15	2	984	\N
537	34	27	2	949	\N
538	34	51	2	949	\N
539	34	23	2	949	\N
540	34	39	2	949	\N
541	34	31	2	947	\N
542	34	11	2	797	\N
543	34	30	2	650	\N
544	34	40	2	44	\N
545	34	47	2	26	\N
546	34	10	2	26	\N
547	35	35	3	3	\N
548	35	41	2	3	\N
549	35	35	2	3	\N
550	35	49	2	3	\N
551	35	24	2	3	\N
552	35	18	2	3	\N
553	35	13	2	2	\N
554	35	16	2	2	\N
555	36	36	3	1	\N
556	36	50	2	4	\N
557	36	38	2	3	\N
558	36	42	2	3	\N
559	36	4	2	1	\N
560	36	36	2	1	\N
561	36	5	2	1	\N
562	36	43	2	1	\N
563	36	19	2	1	\N
564	36	7	2	1	\N
565	36	49	2	1	\N
566	36	24	2	1	\N
567	36	9	2	1	\N
568	36	14	2	1	\N
569	36	32	2	1	\N
570	37	48	1	2271	\N
571	37	24	1	757	\N
572	37	34	1	674	\N
573	37	37	3	2004	\N
574	37	3	3	1047	\N
575	37	29	3	345	\N
576	37	22	3	214	\N
577	37	40	3	41	\N
578	37	37	2	2004	\N
579	37	24	2	1898	\N
580	37	3	2	1308	\N
581	37	17	2	954	\N
582	37	15	2	954	\N
583	37	27	2	949	\N
584	37	48	2	949	\N
585	37	34	2	949	\N
586	37	51	2	949	\N
587	37	23	2	949	\N
588	37	39	2	949	\N
589	37	2	2	949	\N
590	37	31	2	947	\N
591	37	11	2	797	\N
592	37	30	2	650	\N
593	38	38	3	3	\N
594	38	50	2	4	\N
595	38	38	2	3	\N
596	38	42	2	3	\N
597	38	4	2	1	\N
598	38	36	2	1	\N
599	38	5	2	1	\N
600	38	43	2	1	\N
601	38	19	2	1	\N
602	38	7	2	1	\N
603	38	49	2	1	\N
604	38	24	2	1	\N
605	38	9	2	1	\N
606	38	14	2	1	\N
607	38	32	2	1	\N
608	39	37	2	2004	\N
609	39	24	2	1898	\N
610	39	3	2	1308	\N
611	39	17	2	954	\N
612	39	15	2	954	\N
613	39	27	2	949	\N
614	39	48	2	949	\N
615	39	34	2	949	\N
616	39	51	2	949	\N
617	39	23	2	949	\N
618	39	39	2	949	\N
619	39	2	2	949	\N
620	39	31	2	947	\N
621	39	11	2	797	\N
622	39	30	2	650	\N
623	40	48	1	72	\N
624	40	24	1	24	\N
625	40	34	1	24	\N
626	40	37	3	684	\N
627	40	3	3	525	\N
628	40	29	3	226	\N
629	40	22	3	56	\N
630	40	40	3	44	\N
631	40	2	2	63	\N
632	40	24	2	46	\N
633	40	40	2	44	\N
634	40	17	2	26	\N
635	40	15	2	26	\N
636	40	47	2	23	\N
637	40	34	2	23	\N
638	40	10	2	23	\N
639	40	48	2	22	\N
640	41	41	2	3	\N
641	41	35	2	3	\N
642	41	49	2	3	\N
643	41	24	2	3	\N
644	41	18	2	3	\N
645	41	13	2	2	\N
646	41	16	2	2	\N
647	42	41	1	3	\N
648	42	35	1	3	\N
649	42	49	1	3	\N
650	42	24	1	3	\N
651	42	18	1	3	\N
652	42	13	1	2	\N
653	42	16	1	2	\N
654	42	42	3	3	\N
655	42	50	2	4	\N
656	42	38	2	3	\N
657	42	42	2	3	\N
658	42	4	2	1	\N
659	42	36	2	1	\N
660	42	5	2	1	\N
661	42	43	2	1	\N
662	42	19	2	1	\N
663	42	7	2	1	\N
664	42	49	2	1	\N
665	42	24	2	1	\N
666	42	9	2	1	\N
667	42	14	2	1	\N
668	42	32	2	1	\N
669	43	50	2	4	\N
670	43	38	2	3	\N
671	43	42	2	3	\N
672	43	4	2	1	\N
673	43	36	2	1	\N
674	43	5	2	1	\N
675	43	43	2	1	\N
676	43	19	2	1	\N
677	43	7	2	1	\N
678	43	49	2	1	\N
679	43	24	2	1	\N
680	43	9	2	1	\N
681	43	14	2	1	\N
682	43	32	2	1	\N
683	44	48	1	2946	\N
684	44	24	1	1964	\N
685	44	28	1	1953	\N
686	44	46	1	982	\N
687	44	20	1	982	\N
688	44	45	1	982	\N
689	44	21	1	982	\N
690	44	52	1	982	\N
691	44	6	1	982	\N
692	44	33	1	796	\N
693	44	17	3	982	\N
694	44	44	3	982	\N
695	44	48	2	1836	\N
696	44	24	2	1224	\N
697	44	20	2	982	\N
698	44	44	2	982	\N
699	44	46	2	612	\N
700	44	25	2	612	\N
701	44	52	2	612	\N
702	44	28	2	11	\N
703	45	48	2	2952	\N
704	45	24	2	1968	\N
705	45	28	2	1957	\N
706	45	46	2	984	\N
707	45	20	2	984	\N
708	45	45	2	984	\N
709	45	21	2	984	\N
710	45	52	2	984	\N
711	45	6	2	984	\N
712	45	33	2	799	\N
713	46	46	3	1596	\N
714	46	48	2	4788	\N
715	46	24	2	3192	\N
716	46	28	2	1968	\N
717	46	20	2	1966	\N
718	46	46	2	1596	\N
719	46	52	2	1596	\N
720	46	45	2	984	\N
721	46	21	2	984	\N
722	46	6	2	984	\N
723	46	44	2	982	\N
724	46	33	2	799	\N
725	46	25	2	612	\N
726	47	2	2	72	\N
727	47	24	2	52	\N
728	47	40	2	44	\N
729	47	17	2	29	\N
730	47	15	2	29	\N
731	47	47	2	26	\N
732	47	34	2	26	\N
733	47	10	2	26	\N
734	47	48	2	25	\N
735	48	48	2	10021	\N
736	48	24	2	6561	\N
737	48	37	2	2004	\N
738	48	28	2	1968	\N
739	48	20	2	1966	\N
740	48	34	2	1946	\N
741	48	46	2	1596	\N
742	48	52	2	1596	\N
743	48	3	2	1308	\N
744	48	2	2	1021	\N
745	48	45	2	984	\N
746	48	21	2	984	\N
747	48	6	2	984	\N
748	48	17	2	983	\N
749	48	15	2	983	\N
750	48	44	2	982	\N
751	48	27	2	949	\N
752	48	51	2	949	\N
753	48	23	2	949	\N
754	48	39	2	949	\N
755	48	31	2	947	\N
756	48	33	2	799	\N
757	48	11	2	797	\N
758	48	30	2	650	\N
759	48	25	2	612	\N
760	48	29	2	345	\N
761	48	22	2	338	\N
762	48	40	2	42	\N
763	48	47	2	25	\N
764	48	10	2	25	\N
765	49	49	2	6	\N
766	49	24	2	6	\N
767	49	50	2	4	\N
768	49	41	2	3	\N
769	49	38	2	3	\N
770	49	35	2	3	\N
771	49	18	2	3	\N
772	49	42	2	3	\N
773	49	13	2	2	\N
774	49	5	2	2	\N
775	49	19	2	2	\N
776	49	16	2	2	\N
777	49	4	2	1	\N
778	49	36	2	1	\N
779	49	43	2	1	\N
780	49	7	2	1	\N
781	49	9	2	1	\N
782	49	12	2	1	\N
783	49	14	2	1	\N
784	49	32	2	1	\N
785	50	50	3	4	\N
786	50	50	2	4	\N
787	50	38	2	3	\N
788	50	42	2	3	\N
789	50	4	2	1	\N
790	50	36	2	1	\N
791	50	5	2	1	\N
792	50	43	2	1	\N
793	50	19	2	1	\N
794	50	7	2	1	\N
795	50	49	2	1	\N
796	50	24	2	1	\N
797	50	9	2	1	\N
798	50	14	2	1	\N
799	50	32	2	1	\N
800	51	37	2	2004	\N
801	51	24	2	1898	\N
802	51	3	2	1308	\N
803	51	17	2	954	\N
804	51	15	2	954	\N
805	51	27	2	949	\N
806	51	48	2	949	\N
807	51	34	2	949	\N
808	51	51	2	949	\N
809	51	23	2	949	\N
810	51	39	2	949	\N
811	51	2	2	949	\N
812	51	31	2	947	\N
813	51	11	2	797	\N
814	51	30	2	650	\N
815	52	48	2	4788	\N
816	52	24	2	3192	\N
817	52	28	2	1968	\N
818	52	20	2	1966	\N
819	52	46	2	1596	\N
820	52	52	2	1596	\N
821	52	45	2	984	\N
822	52	21	2	984	\N
823	52	6	2	984	\N
824	52	44	2	982	\N
825	52	33	2	799	\N
826	52	25	2	612	\N
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema) FROM stdin;
2	http://xmlns.com/foaf/0.1/name	1025	\N	8	name	name	f	0	-1	\N	f	f	\N	\N	\N	f
3	http://dbpedia.org/ontology/deathPlace	1308	\N	10	deathPlace	deathPlace	f	1308	-1	-1	f	f	\N	\N	\N	f
5	http://purl.org/dc/terms/description	2	\N	5	description	description	f	0	1	\N	f	f	\N	\N	\N	f
19	http://purl.org/dc/terms/publisher	2	\N	5	publisher	publisher	f	2	1	-1	f	f	\N	\N	\N	f
24	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	6572	\N	1	type	type	f	6572	-1	-1	f	f	\N	\N	\N	f
34	http://www.w3.org/2002/07/owl#sameAs	1947	\N	7	sameAs	sameAs	f	1947	1	-1	f	f	\N	\N	\N	f
37	http://dbpedia.org/ontology/birthPlace	2004	\N	10	birthPlace	birthPlace	f	2004	-1	-1	f	f	\N	\N	\N	f
40	https://schema.org/foundingLocation	44	\N	75	foundingLocation	foundingLocation	f	44	-1	-1	f	f	\N	\N	\N	f
48	http://www.w3.org/2000/01/rdf-schema#label	10021	\N	2	label	label	f	0	-1	\N	f	f	\N	\N	\N	f
49	http://purl.org/dc/terms/title	6	\N	5	title	title	f	0	1	\N	f	f	\N	\N	\N	f
1	http://schema.org/startDate	1	\N	9	startDate	startDate	f	0	1	\N	f	f	2	\N	\N	f
4	http://purl.org/dc/terms/accessRights	1	\N	5	accessRights	accessRights	f	1	1	1	f	f	8	\N	\N	f
7	http://purl.org/dc/terms/spatial	1	\N	5	spatial	spatial	f	1	1	1	f	f	8	\N	\N	f
8	http://www.w3.org/2006/vcard/ns#fn	1	\N	39	fn	fn	f	0	1	\N	f	f	7	\N	\N	f
10	https://schema.org/foundingDate	26	\N	75	foundingDate	foundingDate	f	0	1	\N	f	f	11	\N	\N	f
14	http://www.w3.org/ns/dcat#keyword	1	\N	15	keyword	keyword	f	0	1	\N	f	f	8	\N	\N	f
6	http://purl.org/dc/terms/isPartOf	984	\N	5	isPartOf	isPartOf	f	984	1	-1	f	f	13	\N	\N	f
9	http://www.w3.org/ns/dcat#contactPoint	1	\N	15	contactPoint	contactPoint	f	1	1	1	f	f	7	\N	\N	f
11	http://dbpedia.org/ontology/affiliation	797	\N	10	affiliation	affiliation	f	797	-1	-1	f	f	1	\N	\N	f
12	http://www.w3.org/ns/dcat#dataset	1	\N	15	dataset	dataset	f	1	1	1	f	f	8	\N	\N	f
13	http://purl.org/dc/terms/conformsTo	2	\N	5	conformsTo	conformsTo	f	2	1	-1	f	f	12	\N	\N	f
16	http://www.w3.org/ns/adms#status	2	\N	80	status	status	f	2	1	-1	f	f	15	\N	\N	f
18	http://www.w3.org/ns/dcat#accessURL	3	\N	15	accessURL	accessURL	f	3	1	1	f	f	15	\N	\N	f
21	http://data.nobelprize.org/terms/sortOrder	984	\N	68	sortOrder	sortOrder	f	0	1	\N	f	f	10	\N	\N	f
23	http://xmlns.com/foaf/0.1/gender	949	\N	8	gender	gender	f	0	1	\N	f	f	5	\N	\N	f
25	http://data.nobelprize.org/terms/categoryOrder	612	\N	68	categoryOrder	categoryOrder	f	0	1	\N	f	f	13	\N	\N	f
26	http://www.w3.org/2006/vcard/ns#hasEmail	1	\N	39	hasEmail	hasEmail	f	1	1	1	f	f	7	\N	\N	f
27	http://dbpedia.org/property/dateOfBirth	949	\N	19	dateOfBirth	dateOfBirth	f	0	1	\N	f	f	5	\N	\N	f
28	http://data.nobelprize.org/terms/motivation	1968	\N	68	motivation	motivation	f	0	-1	\N	f	f	3	\N	\N	f
30	http://dbpedia.org/property/dateOfDeath	650	\N	19	dateOfDeath	dateOfDeath	f	0	1	\N	f	f	5	\N	\N	f
31	http://xmlns.com/foaf/0.1/familyName	947	\N	8	familyName	familyName	f	0	1	\N	f	f	5	\N	\N	f
32	http://www.w3.org/ns/dcat#landingPage	1	\N	15	landingPage	landingPage	f	1	1	1	f	f	8	\N	\N	f
35	http://purl.org/dc/terms/license	3	\N	5	license	license	f	3	1	-1	f	f	15	\N	\N	f
36	http://purl.org/dc/terms/accrualPeriodicity	1	\N	5	accrualPeriodicity	accrualPeriodicity	f	1	1	1	f	f	8	\N	\N	f
38	http://purl.org/dc/terms/language	3	\N	5	language	language	f	3	-1	1	f	f	8	\N	\N	f
39	http://xmlns.com/foaf/0.1/givenName	949	\N	8	givenName	givenName	f	0	1	\N	f	f	5	\N	\N	f
41	http://purl.org/dc/terms/format	3	\N	5	format	format	f	0	1	\N	f	f	15	\N	\N	f
43	http://purl.org/dc/terms/issued	1	\N	5	issued	issued	f	0	1	\N	f	f	8	\N	\N	f
45	http://data.nobelprize.org/terms/share	984	\N	68	share	share	f	0	1	\N	f	f	10	\N	\N	f
46	http://data.nobelprize.org/terms/category	1596	\N	68	category	category	f	1596	1	-1	f	f	3	\N	\N	f
47	http://purl.org/dc/terms/created	26	\N	5	created	created	f	0	1	\N	f	f	11	\N	\N	f
50	http://www.w3.org/ns/dcat#theme	4	\N	15	theme	theme	f	4	-1	1	f	f	8	\N	\N	f
51	http://xmlns.com/foaf/0.1/birthday	949	\N	8	birthday	birthday	f	0	1	\N	f	f	5	\N	\N	f
52	http://data.nobelprize.org/terms/year	1596	\N	68	year	year	f	0	1	\N	f	f	3	\N	\N	f
15	http://data.nobelprize.org/terms/nobelPrize	984	\N	68	nobelPrize	nobelPrize	f	984	-1	-1	f	f	13	\N	\N	f
17	http://data.nobelprize.org/terms/laureateAward	984	\N	68	laureateAward	laureateAward	f	984	-1	1	f	f	10	\N	\N	f
20	http://data.nobelprize.org/terms/laureate	1966	\N	68	laureate	laureate	f	1966	-1	-1	f	f	4	\N	\N	f
22	http://dbpedia.org/ontology/city	338	\N	10	city	city	f	338	1	-1	f	f	9	\N	\N	f
29	http://dbpedia.org/ontology/country	345	\N	10	country	country	f	345	-1	-1	f	f	6	\N	\N	f
33	http://data.nobelprize.org/terms/university	799	\N	68	university	university	f	799	-1	-1	f	f	1	\N	\N	f
42	http://www.w3.org/ns/dcat#distribution	3	\N	15	distribution	distribution	f	3	-1	1	f	f	15	\N	\N	f
44	http://purl.org/dc/terms/hasPart	982	\N	5	hasPart	hasPart	f	982	-1	1	f	f	10	\N	\N	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.annot_types_id_seq', 7, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cc_rel_types_id_seq', 2, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cc_rels_id_seq', 18, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.class_annots_id_seq', 1, false);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.classes_id_seq', 30, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cp_rels_id_seq', 302, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cpc_rels_id_seq', 484, true);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cpd_rels_id_seq', 119, true);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.datatypes_id_seq', 5, true);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.ns_id_seq', 707, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.parameters_id_seq', 40, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.pd_rels_id_seq', 24, true);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.pp_rels_id_seq', 826, true);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.properties_id_seq', 52, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.property_annots_id_seq', 1, false);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.classes
    ADD CONSTRAINT classes_iri_key UNIQUE (iri);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON nobel_prizes.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON nobel_prizes.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON nobel_prizes.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON nobel_prizes.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON nobel_prizes.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON nobel_prizes.classes USING btree (ns_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON nobel_prizes.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON nobel_prizes.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON nobel_prizes.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON nobel_prizes.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON nobel_prizes.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON nobel_prizes.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON nobel_prizes.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON nobel_prizes.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON nobel_prizes.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON nobel_prizes.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON nobel_prizes.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_cc_rels_data ON nobel_prizes.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_classes_cnt ON nobel_prizes.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_classes_data ON nobel_prizes.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_classes_iri ON nobel_prizes.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON nobel_prizes.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON nobel_prizes.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON nobel_prizes.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_cp_rels_data ON nobel_prizes.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON nobel_prizes.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_instances_local_name ON nobel_prizes.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_instances_test ON nobel_prizes.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_data ON nobel_prizes.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON nobel_prizes.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON nobel_prizes.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON nobel_prizes.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON nobel_prizes.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON nobel_prizes.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON nobel_prizes.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_properties_cnt ON nobel_prizes.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_properties_data ON nobel_prizes.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_properties_iri ON nobel_prizes.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES nobel_prizes.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES nobel_prizes.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES nobel_prizes.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES nobel_prizes.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes.ns(id) ON DELETE SET NULL;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES nobel_prizes.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES nobel_prizes.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES nobel_prizes.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES nobel_prizes.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES nobel_prizes.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES nobel_prizes.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES nobel_prizes.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES nobel_prizes.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES nobel_prizes.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES nobel_prizes.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES nobel_prizes.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES nobel_prizes.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES nobel_prizes.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES nobel_prizes.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES nobel_prizes.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

