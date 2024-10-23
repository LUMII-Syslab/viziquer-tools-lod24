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
-- Name: http_dati_isprambiente_it_sparql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA http_dati_isprambiente_it_sparql;


--
-- Name: SCHEMA http_dati_isprambiente_it_sparql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA http_dati_isprambiente_it_sparql IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE FUNCTION http_dati_isprambiente_it_sparql.tapprox(integer) RETURNS text
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
-- Name: tapprox(bigint); Type: FUNCTION; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE FUNCTION http_dati_isprambiente_it_sparql.tapprox(bigint) RETURNS text
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
-- Name: _h_classes; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COMMENT ON TABLE http_dati_isprambiente_it_sparql._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.classes (
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
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COMMENT ON COLUMN http_dati_isprambiente_it_sparql.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.cp_rels (
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
-- Name: properties; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.properties (
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
-- Name: c_links; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((http_dati_isprambiente_it_sparql.classes c1
     JOIN http_dati_isprambiente_it_sparql.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN http_dati_isprambiente_it_sparql.properties p ON ((cp1.property_id = p.id)))
     JOIN http_dati_isprambiente_it_sparql.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN http_dati_isprambiente_it_sparql.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.instances (
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
-- Name: instances_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE TABLE http_dati_isprambiente_it_sparql.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE http_dati_isprambiente_it_sparql.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME http_dati_isprambiente_it_sparql.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_cc_rels AS
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
   FROM http_dati_isprambiente_it_sparql.cc_rels r,
    http_dati_isprambiente_it_sparql.classes c1,
    http_dati_isprambiente_it_sparql.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_classes_ns AS
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
    http_dati_isprambiente_it_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_dati_isprambiente_it_sparql.classes c
     LEFT JOIN http_dati_isprambiente_it_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_classes_ns_main AS
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
   FROM http_dati_isprambiente_it_sparql.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM http_dati_isprambiente_it_sparql.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_classes_ns_plus AS
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
    http_dati_isprambiente_it_sparql.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM http_dati_isprambiente_it_sparql.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (http_dati_isprambiente_it_sparql.classes c
     LEFT JOIN http_dati_isprambiente_it_sparql.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_classes_ns_main_plus AS
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
   FROM http_dati_isprambiente_it_sparql.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM http_dati_isprambiente_it_sparql.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_classes_ns_main_v01 AS
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
   FROM (http_dati_isprambiente_it_sparql.v_classes_ns v
     LEFT JOIN http_dati_isprambiente_it_sparql.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_cp_rels AS
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
    http_dati_isprambiente_it_sparql.tapprox((r.cnt)::integer) AS cnt_x,
    http_dati_isprambiente_it_sparql.tapprox(r.object_cnt) AS object_cnt_x,
    http_dati_isprambiente_it_sparql.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM http_dati_isprambiente_it_sparql.cp_rels r,
    http_dati_isprambiente_it_sparql.classes c,
    http_dati_isprambiente_it_sparql.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_cp_rels_card AS
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
   FROM http_dati_isprambiente_it_sparql.cp_rels r,
    http_dati_isprambiente_it_sparql.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_properties_ns AS
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
    http_dati_isprambiente_it_sparql.tapprox(p.cnt) AS cnt_x,
    http_dati_isprambiente_it_sparql.tapprox(p.object_cnt) AS object_cnt_x,
    http_dati_isprambiente_it_sparql.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (http_dati_isprambiente_it_sparql.properties p
     LEFT JOIN http_dati_isprambiente_it_sparql.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_cp_sources_single AS
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
   FROM ((http_dati_isprambiente_it_sparql.v_cp_rels_card r
     JOIN http_dati_isprambiente_it_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_dati_isprambiente_it_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_cp_targets_single AS
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
   FROM ((http_dati_isprambiente_it_sparql.v_cp_rels_card r
     JOIN http_dati_isprambiente_it_sparql.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN http_dati_isprambiente_it_sparql.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    http_dati_isprambiente_it_sparql.tapprox((r.cnt)::integer) AS cnt_x
   FROM http_dati_isprambiente_it_sparql.pp_rels r,
    http_dati_isprambiente_it_sparql.properties p1,
    http_dati_isprambiente_it_sparql.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_properties_sources AS
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
   FROM (http_dati_isprambiente_it_sparql.v_properties_ns v
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
           FROM http_dati_isprambiente_it_sparql.cp_rels r,
            http_dati_isprambiente_it_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_properties_sources_single AS
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
   FROM (http_dati_isprambiente_it_sparql.v_properties_ns v
     LEFT JOIN http_dati_isprambiente_it_sparql.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_properties_targets AS
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
   FROM (http_dati_isprambiente_it_sparql.v_properties_ns v
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
           FROM http_dati_isprambiente_it_sparql.cp_rels r,
            http_dati_isprambiente_it_sparql.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE VIEW http_dati_isprambiente_it_sparql.v_properties_targets_single AS
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
   FROM (http_dati_isprambiente_it_sparql.v_properties_ns v
     LEFT JOIN http_dati_isprambiente_it_sparql.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
8	rdfs:label	\N	\N
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	1	34	1	\N	\N
2	2	81	1	\N	\N
3	5	63	1	\N	\N
4	7	29	1	\N	\N
5	15	17	1	\N	\N
6	16	92	1	\N	\N
7	25	47	1	\N	\N
8	27	74	1	\N	\N
9	30	63	1	\N	\N
10	37	53	1	\N	\N
11	38	67	1	\N	\N
12	39	3	1	\N	\N
13	46	48	1	\N	\N
14	47	90	1	\N	\N
15	50	17	1	\N	\N
16	57	17	1	\N	\N
17	60	25	1	\N	\N
18	60	39	1	\N	\N
19	60	9	1	\N	\N
20	65	1	1	\N	\N
21	70	113	1	\N	\N
22	70	94	1	\N	\N
23	72	103	1	\N	\N
24	79	20	1	\N	\N
25	80	115	1	\N	\N
26	82	101	1	\N	\N
27	83	63	1	\N	\N
28	100	103	1	\N	\N
29	105	104	1	\N	\N
30	106	51	1	\N	\N
31	107	25	1	\N	\N
32	107	39	1	\N	\N
33	107	9	1	\N	\N
34	107	63	1	\N	\N
35	108	15	1	\N	\N
36	113	40	1	\N	\N
37	114	66	1	\N	\N
38	122	37	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
1	1	8	Sampling Point	en
2	4	8	Serie di campionamenti	it
3	4	8	Series of samplings	en
4	5	8	Caratteristica di Interesse Meteorologica	it
5	5	8	Weather Feature of Interest	en
6	8	8	Dataset	en
7	8	8	Dataset	it
8	9	8	Organisation	en
9	9	8	Organizzazione	it
10	11	8	Municipality	en
11	11	8	Municipalità (Comune)	it
12	12	8	Observation parameter	en
13	12	8	Parametro di osservazione	it
14	13	8	Water Sample	en
15	15	8	TransitiveProperty	\N
16	16	8	OntologyProperty	\N
17	17	8	ObjectProperty	\N
18	18	8	Caratteristica	it
19	18	8	Characteristic	en
20	19	8	Identifier schema	en
21	19	8	Schema di identificatori	it
22	20	8	Luogo	it
23	20	8	Feature	en
24	21	8	Mare	it
25	21	8	Sea	en
26	22	8	Livello di Validazione	it
27	22	8	Validation Level	en
28	23	8	Contract	en
29	23	8	Lotto	it
30	24	8	Observation Value	en
31	26	8	Collection of samplings	en
32	26	8	Collezione di campionamenti	it
33	27	8	Water Indicator Calculation	en
34	31	8	Data schema	en
35	31	8	Schema di dati.	it
36	32	8	Unit of measure	en
37	32	8	Unità di misura	it
38	33	8	Città Metropolitana	it
39	33	8	Metropolitan City	en
40	34	8	Caratteristica di Interesse	it
41	34	8	Feature of interest	en
42	35	8	Modello del Sensore	it
43	35	8	Sensor Model	en
44	36	8	Action	en
45	36	8	Intervento	it
46	41	8	Campionatore	it
47	41	8	Sampler	en
48	42	8	Restriction	\N
49	43	8	Modello della Piattaforma	it
50	43	8	Platform Model	en
51	44	8	Authority kind	en
52	44	8	Autorità	it
53	45	8	Water Biological Quality Parameter/Element Observation	en
54	50	8	FunctionalProperty	\N
55	51	8	Ontology	\N
56	53	8	Entity	en
57	53	8	Entità	it
58	54	8	Parameter	en
59	54	8	Parametro	it
60	55	8	Province	en
61	55	8	Provincia	it
62	56	8	Serie di osservazioni	it
63	56	8	Series of observations	en
64	58	8	Lot step	en
65	58	8	Passi del lotto	it
66	59	8	Marine Water	en
67	61	8	AnnotationProperty	\N
68	62	8	DatatypeProperty	\N
69	64	8	Collection	en
70	64	8	Collezione	it
71	65	8	Luogo	it
72	65	8	Place	en
73	66	8	Intervallo di tempo	it
74	66	8	Time interval	en
75	67	8	Geometria	it
76	67	8	Geometry	en
77	68	8	Monitoring Network	en
78	68	8	Rete di Monitoraggio	it
79	69	8	Economic Indicator	en
80	69	8	Indicatore economico	it
81	73	8	Valore	it
82	73	8	Value	en
83	74	8	Indicator	en
84	74	8	Indicatore	it
85	75	8	Piattaforma	it
86	75	8	Platform	en
87	76	8	Sensor Type	en
88	76	8	Tipo di Sensore	it
89	77	8	Lithology	en
90	77	8	Litologia	it
91	85	8	Media	en
92	85	8	Media	it
93	86	8	Entità temporale	it
94	86	8	Temporal entity	en
95	87	8	Collection of observations	en
96	87	8	Collezione di osservazioni	it
97	88	8	Platform Type	en
98	88	8	Tipo di piattaforma	it
99	89	8	Water Observable Property	en
100	96	8	Country	en
101	96	8	Stato	it
102	97	8	Region	en
103	97	8	Regione	it
104	98	8	Collocamento del sistema	it
105	98	8	System deployment	en
106	99	8	Opera	it
107	99	8	Repair	en
108	100	8	Biological Agent	en
109	102	8	Class	\N
110	104	8	Observation	en
111	104	8	Osservazione	it
112	109	8	Concept	en
113	109	8	Concetto	it
114	110	8	Identificativo Univoco	it
115	110	8	Unique Identifier	en
116	111	8	Sensor	en
117	111	8	Sensore	it
118	112	8	Dissesto	it
119	112	8	Instability	en
120	116	8	Agent	en
121	116	8	Agente	it
122	117	8	Attributo dello Schema	it
123	117	8	Schema Attribute	en
124	118	8	Anno	it
125	118	8	Year	en
126	119	8	Collezione di indicatori	it
127	119	8	Indicator collection	en
128	120	8	Collezione di Piattaforme	it
129	120	8	Platform Collection	en
130	121	8	Abilità del sistema	it
131	121	8	System capability	en
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
85	https://w3id.org/italia/env/onto/top/Media	37745	\N	t	69	Media	Media	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	37745
1	https://w3id.org/whow/onto/water-monitoring/SamplingPoint	830	\N	t	74	SamplingPoint	SamplingPoint	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4764
2	http://dati.gov.it/onto/dcatapit#Distribution	26	\N	t	75	Distribution	Distribution	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34
3	http://xmlns.com/foaf/0.1/Agent	13	\N	t	8	Agent	Agent	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	122997724
4	https://w3id.org/italia/env/onto/inspire-mf/SamplingSeries	14122	\N	t	76	SamplingSeries	SamplingSeries	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7969243
5	https://w3id.org/whow/onto/weather-monitoring/WeatherFeatureOfInterest	5	\N	t	77	WeatherFeatureOfInterest	WeatherFeatureOfInterest	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
6	http://purl.org/procurement/public-contracts#FrameworkAgreement	25249	\N	t	70	FrameworkAgreement	FrameworkAgreement	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	25249
7	http://rs.tdwg.org/dwc/terms/Event	4217988	\N	t	78	Event	Event	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4217988
8	https://w3id.org/italia/env/onto/top/Dataset	24	\N	t	69	Dataset	Dataset	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	103773
9	https://w3id.org/italia/env/onto/top/Organisation	37	\N	t	69	Organisation	Organisation	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	123007038
10	http://www.w3.org/2002/07/owl#AllDisjointClasses	7	\N	t	7	AllDisjointClasses	AllDisjointClasses	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
11	https://w3id.org/italia/env/onto/place/Municipality	8995	\N	t	79	Municipality	Municipality	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	43267
12	https://w3id.org/italia/env/onto/inspire-mf/ObservationParameter	18	\N	t	76	ObservationParameter	ObservationParameter	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	83808
13	https://w3id.org/whow/onto/water-monitoring/WaterSample	4639	\N	t	74	WaterSample	WaterSample	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4800
14	http://purl.org/dc/terms/MediaTypeOrExtent	2	\N	t	5	MediaTypeOrExtent	MediaTypeOrExtent	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	28
15	http://www.w3.org/2002/07/owl#TransitiveProperty	10	\N	t	7	TransitiveProperty	TransitiveProperty	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34
16	http://www.w3.org/2002/07/owl#OntologyProperty	4	\N	t	7	OntologyProperty	OntologyProperty	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
17	http://www.w3.org/2002/07/owl#ObjectProperty	299	\N	t	7	ObjectProperty	ObjectProperty	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	659
18	https://w3id.org/italia/env/onto/top/Characteristic	4	\N	t	69	Characteristic	Characteristic	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	42
19	https://w3id.org/italia/env/onto/top/IdentifierSchema	8	\N	t	69	IdentifierSchema	IdentifierSchema	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3878395
20	https://w3id.org/italia/env/onto/place/Feature	33791	\N	t	79	Feature	Feature	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4275815
21	https://w3id.org/italia/env/onto/place/Sea	27	\N	t	79	Sea	Sea	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	279
22	https://w3id.org/italia/env/onto/inspire-mf/ValidationLevel	4	\N	t	76	ValidationLevel	ValidationLevel	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	37739
23	https://w3id.org/italia/env/onto/core#Contract	26530	\N	t	80	Contract	Contract	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	114169
24	https://w3id.org/whow/onto/water-monitoring/ObservationValue	2172	\N	t	74	ObservationValue	ObservationValue	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7241
25	http://dati.gov.it/onto/dcatapit#Organization	14	\N	t	75	Organization	Organization	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	49199255
26	https://w3id.org/italia/env/onto/inspire-mf/SamplingCollection	3185	\N	t	76	SamplingCollection	SamplingCollection	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14122
27	https://w3id.org/whow/onto/water-indicator/WaterIndicatorCalculation	162391	\N	t	81	WaterIndicatorCalculation	WaterIndicatorCalculation	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
28	http://purl.org/goodrelations/v1#BusinessEntity	6213	\N	t	36	BusinessEntity	BusinessEntity	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	79087
29	http://semanticweb.cs.vu.nl/2009/11/sem/Event	4217988	\N	t	82	Event	Event	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4217988
30	https://w3id.org/italia/onto/ADMS/SemanticAssetDistribution	12	\N	t	83	SemanticAssetDistribution	SemanticAssetDistribution	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
31	https://w3id.org/italia/env/onto/top/DataSchema	18	\N	t	69	DataSchema	DataSchema	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	37739
32	https://w3id.org/italia/env/onto/top/UnitOfMeasure	93	\N	t	69	UnitOfMeasure	UnitOfMeasure	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5441743
33	https://w3id.org/italia/env/onto/place/MetropolitanCity	14	\N	t	79	MetropolitanCity	MetropolitanCity	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1362
34	https://w3id.org/italia/env/onto/inspire-mf/FeatureOfInterest	14121	\N	t	76	FeatureOfInterest	FeatureOfInterest	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	125522
35	https://w3id.org/italia/env/onto/inspire-mf/SensorModel	69	\N	t	76	SensorModel	SensorModel	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	397
36	https://w3id.org/italia/env/onto/core#Intervention	25249	\N	t	80	Intervention	Intervention	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	26530
37	http://rs.tdwg.org/dwc/terms/Organism	3846953	\N	t	78	Organism	Organism	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12653964
38	https://w3id.org/italia/onto/CLV/Geometry	294	\N	t	84	Geometry	Geometry	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	858
39	http://dati.gov.it/onto/dcatapit#Agent	13	\N	t	75	Agent	Agent	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	122997724
40	http://www.w3.org/ns/dcat#Dataset	20	\N	t	15	Dataset	Dataset	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	78710
41	https://w3id.org/italia/env/onto/inspire-mf/Sampler	14122	\N	t	76	Sampler	Sampler	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14122
42	http://www.w3.org/2002/07/owl#Restriction	213	\N	t	7	Restriction	Restriction	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	213
43	https://w3id.org/italia/env/onto/inspire-mf/PlatformModel	43	\N	t	76	PlatformModel	PlatformModel	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	95
44	https://w3id.org/italia/env/onto/core#AuthorityKind	79090	\N	t	80	AuthorityKind	AuthorityKind	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	79090
45	https://w3id.org/whow/onto/water-monitoring/WaterBiologicalQualityParameterObservation	4800	\N	t	74	WaterBiologicalQualityParameterObservation	WaterBiologicalQualityParameterObservation	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
46	http://dati.gov.it/onto/dcatapit#LicenseDocument	2	\N	t	75	LicenseDocument	LicenseDocument	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22
47	http://www.w3.org/2006/vcard/ns#Kind	14	\N	t	39	Kind	Kind	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	49199255
48	http://purl.org/dc/terms/LicenseDocument	2	\N	t	5	LicenseDocument	LicenseDocument	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	22
49	http://xmlns.com/foaf/0.1/Document	2	\N	t	8	Document	Document	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
50	http://www.w3.org/2002/07/owl#FunctionalProperty	2	\N	t	7	FunctionalProperty	FunctionalProperty	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
51	http://www.w3.org/2002/07/owl#Ontology	14	\N	t	7	Ontology	Ontology	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	401
52	http://rs.tdwg.org/dwc/terms/Identification	4217988	\N	t	78	Identification	Identification	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4217988
53	https://w3id.org/italia/env/onto/top/Entity	3846953	\N	t	69	Entity	Entity	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12653964
54	https://w3id.org/italia/env/onto/top/Parameter	7418	\N	t	69	Parameter	Parameter	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5103311
55	https://w3id.org/italia/env/onto/place/Province	111	\N	t	79	Province	Province	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	7879
56	https://w3id.org/italia/env/onto/inspire-mf/ObservationSeries	37739	\N	t	76	ObservationSeries	ObservationSeries	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5000
57	http://www.w3.org/2002/07/owl#AsymmetricProperty	12	\N	t	7	AsymmetricProperty	AsymmetricProperty	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	19
58	https://w3id.org/italia/env/onto/core#LotStep	90047	\N	t	80	LotStep	LotStep	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
59	https://w3id.org/whow/onto/hydrography/MarineWaterBody	3	\N	t	85	MarineWaterBody	MarineWaterBody	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9439
60	http://www.w3.org/ns/org#Organization	5	\N	t	37	Organization	Organization	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	49199084
61	http://www.w3.org/2002/07/owl#AnnotationProperty	55	\N	t	7	AnnotationProperty	AnnotationProperty	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	5
62	http://www.w3.org/2002/07/owl#DatatypeProperty	57	\N	t	7	DatatypeProperty	DatatypeProperty	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	31
63	http://www.w3.org/2002/07/owl#NamedIndividual	44	\N	t	7	NamedIndividual	NamedIndividual	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	122998207
64	https://w3id.org/italia/env/onto/top/Collection	31299	\N	t	69	Collection	Collection	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	44110
65	https://w3id.org/italia/env/onto/top/Location	830	\N	t	69	Location	Location	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4764
66	https://w3id.org/italia/env/onto/top/TimeInterval	1403	\N	t	69	TimeInterval	TimeInterval	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	95210
67	https://w3id.org/italia/env/onto/place/Geometry	47978	\N	t	79	Geometry	Geometry	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	48556
68	https://w3id.org/italia/env/onto/inspire-mf/MonitoringNetwork	3	\N	t	76	MonitoringNetwork	MonitoringNetwork	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	95
69	https://w3id.org/italia/env/onto/core#EconomicIndicator	111951	\N	t	80	EconomicIndicator	EconomicIndicator	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	111951
70	http://www.w3.org/ns/adms#Asset	6	\N	t	71	Asset	Asset	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23
71	http://www.w3.org/ns/sparql-service-description#Service	1	\N	t	27	Service	Service	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
72	http://purl.org/dc/terms/Frequency	4	\N	t	5	Frequency	Frequency	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	24
73	https://w3id.org/italia/env/onto/top/Value	2946084	\N	t	69	Value	Value	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	190395817
74	https://w3id.org/italia/env/onto/inspire-mf/Indicator	14889493	\N	t	76	Indicator	Indicator	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
75	https://w3id.org/italia/env/onto/inspire-mf/Platform	14217	\N	t	76	Platform	Platform	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14540
76	https://w3id.org/italia/env/onto/inspire-mf/SensorType	114	\N	t	76	SensorType	SensorType	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1191
77	https://w3id.org/italia/env/onto/core#Lithology	5757	\N	t	80	Lithology	Lithology	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
78	http://rs.tdwg.org/dwc/terms/Taxon	2330	\N	t	78	Taxon	Taxon	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4217733
79	http://purl.org/dc/terms/Location	9836	\N	t	5	Location	Location	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4227824
80	http://dati.gov.it/onto/dcatapit#Catalog	2	\N	t	75	Catalog	Catalog	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
81	http://www.w3.org/ns/dcat#Distribution	26	\N	t	15	Distribution	Distribution	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	34
82	http://xmlns.com/foaf/0.1/Organization	1	\N	t	8	Organization	Organization	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
83	https://w3id.org/italia/onto/ADMS/Project	2	\N	t	83	Project	Project	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	8
84	http://www.w3.org/2000/01/rdf-schema#Datatype	8	\N	t	2	Datatype	Datatype	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	15
86	https://w3id.org/italia/env/onto/top/TemporalEntity	361	\N	t	69	TemporalEntity	TemporalEntity	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4800
87	https://w3id.org/italia/env/onto/inspire-mf/ObservationCollection	9893	\N	t	76	ObservationCollection	ObservationCollection	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4255727
88	https://w3id.org/italia/env/onto/inspire-mf/PlatformType	4	\N	t	76	PlatformType	PlatformType	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	138
89	https://w3id.org/whow/onto/water-monitoring/WaterObservableProperty	1	\N	t	74	WaterObservableProperty	WaterObservableProperty	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4800
90	http://www.w3.org/2006/vcard/ns#Organization	20	\N	t	39	Organization	Organization	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	122997881
91	http://purl.org/dc/terms/LinguisticSystem	4	\N	t	5	LinguisticSystem	LinguisticSystem	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	136
92	http://www.w3.org/1999/02/22-rdf-syntax-ns#Property	23	\N	t	1	Property	Property	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
93	http://www.w3.org/2000/01/rdf-schema#Class	15	\N	t	2	Class	Class	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1000
94	http://www.w3.org/2004/02/skos/core#ConceptScheme	16	\N	t	4	ConceptScheme	ConceptScheme	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	418
95	http://rs.tdwg.org/dwc/terms/Occurrence	4217988	\N	t	78	Occurrence	Occurrence	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4217988
96	https://w3id.org/italia/env/onto/place/Country	1	\N	t	79	Country	Country	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9143
97	https://w3id.org/italia/env/onto/place/Region	20	\N	t	79	Region	Region	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	9180
98	https://w3id.org/italia/env/onto/inspire-mf/SystemDeployment	454	\N	t	76	SystemDeployment	SystemDeployment	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	454
99	https://w3id.org/italia/env/onto/core#Repair	12873	\N	t	80	Repair	Repair	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
100	https://w3id.org/whow/onto/water-monitoring/BiologicalAgent	1	\N	t	74	BiologicalAgent	BiologicalAgent	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4800
101	https://www.w3.org/2002/07/owl#NamedIndividual	1	\N	t	86	NamedIndividual	NamedIndividual	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
102	http://www.w3.org/2002/07/owl#Class	316	\N	t	7	Class	Class	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	68613959
103	http://www.w3.org/2004/02/skos/core#Concept	423	\N	t	4	Concept	Concept	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	4648485
104	https://w3id.org/italia/env/onto/inspire-mf/Observation	4217988	\N	t	76	Observation	Observation	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
105	http://purl.org/dsw/Token	4217988	\N	t	87	Token	Token	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
106	https://w3id.org/italia/onto/ADMS/SemanticAsset	4	\N	t	83	SemanticAsset	SemanticAsset	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	292
107	http://www.w3.orgS/ns/org#Organization	6	\N	t	88	Organization	Organization	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	73798626
108	http://www.w3.org/2002/07/owl#ReflexiveProperty	2	\N	t	7	ReflexiveProperty	ReflexiveProperty	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12
109	https://w3id.org/italia/env/onto/top/Concept	13	\N	t	69	Concept	Concept	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	542
110	https://w3id.org/italia/env/onto/top/UniqueIdentifier	3878396	\N	t	69	UniqueIdentifier	UniqueIdentifier	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3885673
111	https://w3id.org/italia/env/onto/inspire-mf/Sensor	418	\N	t	76	Sensor	Sensor	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	35624
112	https://w3id.org/italia/env/onto/core#Instability	5532	\N	t	80	Instability	Instability	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
113	http://dati.gov.it/onto/dcatapit#Dataset	20	\N	t	75	Dataset	Dataset	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	78710
114	http://purl.org/dc/terms/PeriodOfTime	13	\N	t	5	PeriodOfTime	PeriodOfTime	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	23
115	http://www.w3.org/ns/dcat#Catalog	2	\N	t	15	Catalog	Catalog	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
116	https://w3id.org/italia/env/onto/top/Agent	1	\N	t	69	Agent	Agent	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
117	https://w3id.org/italia/env/onto/top/SchemaAttribute	42	\N	t	69	SchemaAttribute	SchemaAttribute	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	42
118	https://w3id.org/italia/env/onto/top/Year	111	\N	t	69	Year	Year	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	82780914
119	https://w3id.org/italia/env/onto/inspire-mf/IndicatorCollection	5104388	\N	t	76	IndicatorCollection	IndicatorCollection	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	20047609
120	https://w3id.org/italia/env/onto/inspire-mf/PlatformCollection	3242	\N	t	76	PlatformCollection	PlatformCollection	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	14217
121	https://w3id.org/italia/env/onto/inspire-mf/SystemCapability	1000	\N	t	76	SystemCapability	SystemCapability	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1179
122	http://purl.org/dc/terms/PhysicalResource	3846953	\N	t	5	PhysicalResource	PhysicalResource	245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	12653964
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	8	2	2	43	\N	43	\N	\N	1	1	2	f	0	\N	\N
2	80	2	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
3	94	2	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
4	113	2	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
5	40	2	2	29	\N	29	\N	\N	0	1	2	f	0	\N	\N
6	115	2	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
7	91	2	1	38	\N	38	\N	\N	1	1	2	f	\N	\N	\N
8	2	3	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
9	30	3	2	12	\N	12	\N	\N	2	1	2	f	0	\N	\N
10	81	3	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
11	63	3	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
12	39	5	2	210	\N	0	\N	\N	1	1	2	f	210	\N	\N
13	46	5	2	4	\N	0	\N	\N	2	1	2	f	4	\N	\N
14	3	5	2	210	\N	0	\N	\N	0	1	2	f	210	\N	\N
15	63	5	2	208	\N	0	\N	\N	0	1	2	f	208	\N	\N
16	9	5	2	202	\N	0	\N	\N	0	1	2	f	202	\N	\N
17	90	5	2	202	\N	0	\N	\N	0	1	2	f	202	\N	\N
18	107	5	2	120	\N	0	\N	\N	0	1	2	f	120	\N	\N
19	25	5	2	82	\N	0	\N	\N	0	1	2	f	82	\N	\N
20	47	5	2	82	\N	0	\N	\N	0	1	2	f	82	\N	\N
21	60	5	2	82	\N	0	\N	\N	0	1	2	f	82	\N	\N
22	48	5	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
23	106	8	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
24	51	8	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
25	63	8	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
26	43	9	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
27	23	11	2	5381	\N	0	\N	\N	1	1	2	f	5381	\N	\N
28	78	13	2	228	\N	0	\N	\N	1	1	2	f	228	\N	\N
29	44	14	2	25249	\N	0	\N	\N	1	1	2	f	25249	\N	\N
30	8	15	2	102	\N	102	\N	\N	1	1	2	f	0	\N	\N
31	80	15	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
32	113	15	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
33	40	15	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
34	115	15	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
35	90	17	2	266	\N	0	\N	\N	1	1	2	f	266	\N	\N
36	63	17	2	265	\N	0	\N	\N	0	1	2	f	265	\N	\N
37	9	17	2	201	\N	0	\N	\N	0	1	2	f	201	\N	\N
38	39	17	2	201	\N	0	\N	\N	0	1	2	f	201	\N	\N
39	3	17	2	201	\N	0	\N	\N	0	1	2	f	201	\N	\N
40	25	17	2	146	\N	0	\N	\N	0	1	2	f	146	\N	\N
41	47	17	2	146	\N	0	\N	\N	0	1	2	f	146	\N	\N
42	107	17	2	120	\N	0	\N	\N	0	1	2	f	120	\N	\N
43	60	17	2	81	\N	0	\N	\N	0	1	2	f	81	\N	\N
44	106	18	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
45	51	18	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
46	63	18	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
47	45	19	2	4800	\N	4800	\N	\N	1	1	2	f	0	\N	\N
48	86	19	1	4800	\N	4800	\N	\N	1	1	2	f	\N	\N	\N
49	4	20	2	14122	\N	14122	\N	\N	1	1	2	f	0	\N	\N
50	41	20	1	14122	\N	14122	\N	\N	1	1	2	f	\N	\N	\N
51	102	21	2	72	\N	72	\N	\N	1	1	2	f	0	\N	\N
52	102	21	1	41	\N	41	\N	\N	1	1	2	f	\N	\N	\N
53	80	22	2	14	\N	14	\N	\N	1	1	2	f	0	\N	\N
54	115	22	2	14	\N	14	\N	\N	0	1	2	f	0	\N	\N
55	8	22	1	34	\N	34	\N	\N	1	1	2	f	\N	\N	\N
56	113	22	1	22	\N	22	\N	\N	0	1	2	f	\N	\N	\N
57	40	22	1	22	\N	22	\N	\N	0	1	2	f	\N	\N	\N
58	58	25	2	89523	\N	0	\N	\N	1	1	2	f	89523	\N	\N
59	6	25	2	25249	\N	0	\N	\N	2	1	2	f	25249	\N	\N
60	51	25	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
61	112	27	2	5532	\N	5532	\N	\N	1	1	2	f	0	\N	\N
62	103	27	1	5532	\N	5532	\N	\N	1	1	2	f	\N	\N	\N
63	99	28	2	4524	\N	4524	\N	\N	1	1	2	f	0	\N	\N
64	103	28	1	4524	\N	4524	\N	\N	1	1	2	f	\N	\N	\N
65	8	29	2	371	\N	0	\N	\N	1	1	2	f	371	\N	\N
66	113	29	2	247	\N	0	\N	\N	2	1	2	f	247	\N	\N
67	106	29	2	53	\N	0	\N	\N	3	1	2	f	53	\N	\N
68	40	29	2	247	\N	0	\N	\N	0	1	2	f	247	\N	\N
69	51	29	2	53	\N	0	\N	\N	0	1	2	f	53	\N	\N
70	63	29	2	53	\N	0	\N	\N	0	1	2	f	53	\N	\N
71	94	29	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
72	70	29	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
73	13	31	2	4639	\N	4639	\N	\N	1	1	2	f	0	\N	\N
74	59	31	1	4639	\N	4639	\N	\N	1	1	2	f	\N	\N	\N
75	6	32	2	25249	\N	0	\N	\N	1	1	2	f	25249	\N	\N
76	39	32	2	42	\N	0	\N	\N	2	1	2	f	42	\N	\N
77	51	32	2	6	\N	5	\N	\N	3	1	2	f	1	\N	\N
78	9	32	2	42	\N	0	\N	\N	0	1	2	f	42	\N	\N
79	90	32	2	42	\N	0	\N	\N	0	1	2	f	42	\N	\N
80	3	32	2	42	\N	0	\N	\N	0	1	2	f	42	\N	\N
81	63	32	2	40	\N	0	\N	\N	0	1	2	f	40	\N	\N
82	107	32	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
83	25	32	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
84	47	32	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
85	60	32	2	18	\N	0	\N	\N	0	1	2	f	18	\N	\N
86	106	33	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
87	51	33	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
88	63	33	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
89	83	33	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
90	63	33	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
91	42	34	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
92	23	35	2	26530	\N	26530	\N	\N	1	1	2	f	0	\N	\N
93	58	36	2	90047	\N	90047	\N	\N	1	1	2	f	0	\N	\N
94	23	36	1	90045	\N	90045	\N	\N	1	1	2	f	\N	\N	\N
95	20	37	2	91	\N	91	\N	\N	1	1	2	f	0	\N	\N
96	11	37	1	90	\N	90	\N	\N	1	1	2	f	\N	\N	\N
97	96	37	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
98	51	38	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
99	11	39	2	2187	\N	2187	\N	\N	1	1	2	f	0	\N	\N
100	33	39	2	14	\N	14	\N	\N	2	1	2	f	0	\N	\N
101	11	39	1	332	\N	332	\N	\N	1	1	2	f	\N	\N	\N
102	55	39	1	14	\N	14	\N	\N	2	1	2	f	\N	\N	\N
103	65	40	2	852	\N	852	\N	\N	1	1	2	f	0	\N	\N
104	34	40	2	852	\N	852	\N	\N	0	1	2	f	0	\N	\N
105	1	40	2	852	\N	852	\N	\N	0	1	2	f	0	\N	\N
106	11	40	1	852	\N	852	\N	\N	1	1	2	f	\N	\N	\N
107	36	41	2	25249	\N	0	\N	\N	1	1	2	f	25249	\N	\N
108	8	43	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
109	113	43	2	28	\N	28	\N	\N	2	1	2	f	0	\N	\N
110	51	43	2	14	\N	14	\N	\N	3	1	2	f	0	\N	\N
111	80	43	2	2	\N	2	\N	\N	4	1	2	f	0	\N	\N
112	40	43	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
113	63	43	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
114	106	43	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
115	94	43	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
116	70	43	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
117	115	43	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
118	39	43	1	304	\N	304	\N	\N	1	1	2	f	\N	\N	\N
119	63	43	1	304	\N	304	\N	\N	0	1	2	f	\N	\N	\N
120	3	43	1	304	\N	304	\N	\N	0	1	2	f	\N	\N	\N
121	9	43	1	290	\N	290	\N	\N	0	1	2	f	\N	\N	\N
122	90	43	1	290	\N	290	\N	\N	0	1	2	f	\N	\N	\N
123	107	43	1	174	\N	174	\N	\N	0	1	2	f	\N	\N	\N
124	25	43	1	116	\N	116	\N	\N	0	1	2	f	\N	\N	\N
125	47	43	1	116	\N	116	\N	\N	0	1	2	f	\N	\N	\N
126	60	43	1	116	\N	116	\N	\N	0	1	2	f	\N	\N	\N
127	11	44	2	8995	\N	0	\N	\N	1	1	2	f	8995	\N	\N
128	55	44	2	111	\N	0	\N	\N	2	1	2	f	111	\N	\N
129	97	44	2	20	\N	0	\N	\N	3	1	2	f	20	\N	\N
130	33	44	2	14	\N	0	\N	\N	4	1	2	f	14	\N	\N
131	96	44	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
132	69	45	2	111951	\N	111951	\N	\N	1	1	2	f	0	\N	\N
133	70	45	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
134	46	45	2	4	\N	4	\N	\N	3	1	2	f	0	\N	\N
135	94	45	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
136	113	45	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
137	40	45	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
138	48	45	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
139	103	45	1	111955	\N	111955	\N	\N	1	1	2	f	\N	\N	\N
140	77	46	2	5757	\N	5757	\N	\N	1	1	2	f	0	\N	\N
141	23	46	1	5743	\N	5743	\N	\N	1	1	2	f	\N	\N	\N
142	67	47	2	47780	\N	0	\N	\N	1	1	2	f	47780	\N	\N
143	39	48	2	21	\N	21	\N	\N	1	1	2	f	0	\N	\N
144	80	48	2	2	\N	2	\N	\N	2	1	2	f	0	\N	\N
145	9	48	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
146	90	48	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
147	3	48	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
148	63	48	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
149	107	48	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
150	25	48	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
151	47	48	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
152	60	48	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
153	115	48	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
154	49	48	1	2	\N	2	\N	\N	1	1	2	f	\N	\N	\N
155	31	49	2	42	\N	42	\N	\N	1	1	2	f	0	\N	\N
156	117	49	1	42	\N	42	\N	\N	1	1	2	f	\N	\N	\N
157	80	50	2	3	\N	3	\N	\N	1	1	2	f	0	\N	\N
158	115	50	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
159	94	50	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
160	106	51	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
161	51	51	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
162	63	51	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
163	106	52	2	12	\N	0	\N	\N	1	1	2	f	12	\N	\N
164	51	52	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
165	63	52	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
166	75	53	2	95	\N	95	\N	\N	1	1	2	f	0	\N	\N
167	68	53	1	95	\N	95	\N	\N	1	1	2	f	\N	\N	\N
168	78	54	2	4584	\N	0	\N	\N	1	1	2	f	4584	\N	\N
169	36	55	2	50498	\N	50498	\N	\N	1	1	2	f	0	\N	\N
170	23	55	2	28610	\N	28610	\N	\N	2	1	2	f	0	\N	\N
171	44	55	1	79090	\N	79090	\N	\N	1	1	2	f	\N	\N	\N
172	20	56	2	29583	\N	29583	\N	\N	1	1	2	f	0	\N	\N
173	11	56	2	17990	\N	17990	\N	\N	2	1	2	f	0	\N	\N
174	34	56	2	6387	\N	6387	\N	\N	3	1	2	f	0	\N	\N
175	55	56	2	111	\N	111	\N	\N	4	1	2	f	0	\N	\N
176	33	56	2	14	\N	14	\N	\N	5	1	2	f	0	\N	\N
177	79	56	2	9836	\N	9836	\N	\N	0	1	2	f	0	\N	\N
178	65	56	2	858	\N	858	\N	\N	0	1	2	f	0	\N	\N
179	1	56	2	858	\N	858	\N	\N	0	1	2	f	0	\N	\N
180	67	56	1	48556	\N	48556	\N	\N	1	1	2	f	\N	\N	\N
181	38	56	1	858	\N	858	\N	\N	0	1	2	f	\N	\N	\N
182	8	57	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
183	113	57	2	28	\N	28	\N	\N	2	1	2	f	0	\N	\N
184	106	57	2	4	\N	4	\N	\N	3	1	2	f	0	\N	\N
185	40	57	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
186	94	57	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
187	70	57	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
188	51	57	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
189	63	57	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
190	39	57	1	240	\N	240	\N	\N	1	1	2	f	\N	\N	\N
191	63	57	1	240	\N	240	\N	\N	0	1	2	f	\N	\N	\N
192	9	57	1	240	\N	240	\N	\N	0	1	2	f	\N	\N	\N
193	90	57	1	240	\N	240	\N	\N	0	1	2	f	\N	\N	\N
194	3	57	1	240	\N	240	\N	\N	0	1	2	f	\N	\N	\N
195	107	57	1	144	\N	144	\N	\N	0	1	2	f	\N	\N	\N
196	25	57	1	96	\N	96	\N	\N	0	1	2	f	\N	\N	\N
197	47	57	1	96	\N	96	\N	\N	0	1	2	f	\N	\N	\N
198	60	57	1	96	\N	96	\N	\N	0	1	2	f	\N	\N	\N
199	95	58	2	4217988	\N	4217988	\N	\N	1	1	2	f	0	\N	\N
200	39	58	1	42179880	\N	42179880	\N	\N	1	1	2	f	\N	\N	\N
201	63	58	1	42179880	\N	42179880	\N	\N	0	1	2	f	\N	\N	\N
202	9	58	1	42179880	\N	42179880	\N	\N	0	1	2	f	\N	\N	\N
203	90	58	1	42179880	\N	42179880	\N	\N	0	1	2	f	\N	\N	\N
204	3	58	1	42179880	\N	42179880	\N	\N	0	1	2	f	\N	\N	\N
205	107	58	1	25307928	\N	25307928	\N	\N	0	1	2	f	\N	\N	\N
206	25	58	1	16871952	\N	16871952	\N	\N	0	1	2	f	\N	\N	\N
207	47	58	1	16871952	\N	16871952	\N	\N	0	1	2	f	\N	\N	\N
208	60	58	1	16871952	\N	16871952	\N	\N	0	1	2	f	\N	\N	\N
209	78	59	2	2315	\N	0	\N	\N	1	1	2	f	2315	\N	\N
210	56	60	2	37739	\N	0	\N	\N	1	1	2	f	37739	\N	\N
211	23	60	2	17668	\N	0	\N	\N	2	1	2	f	17668	\N	\N
212	8	60	2	34	\N	0	\N	\N	3	1	2	f	34	\N	\N
213	113	60	2	28	\N	0	\N	\N	4	1	2	f	28	\N	\N
214	2	60	2	22	\N	0	\N	\N	5	1	2	f	22	\N	\N
215	51	60	2	11	\N	0	\N	\N	6	1	2	f	11	\N	\N
216	80	60	2	2	\N	0	\N	\N	7	1	2	f	2	\N	\N
217	40	60	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
218	81	60	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
219	94	60	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
220	70	60	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
221	63	60	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
222	106	60	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
223	115	60	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
224	74	61	2	14889487	\N	14889487	\N	\N	1	1	2	f	0	\N	\N
225	121	61	2	904	\N	904	\N	\N	2	1	2	f	0	\N	\N
226	98	61	2	418	\N	418	\N	\N	3	1	2	f	0	\N	\N
227	27	61	2	162385	\N	162385	\N	\N	0	1	2	f	0	\N	\N
228	73	61	1	190395817	\N	190395817	\N	\N	1	1	2	f	\N	\N	\N
229	53	62	2	3846953	\N	3846953	\N	\N	1	1	2	f	0	\N	\N
230	20	62	2	15365	\N	15365	\N	\N	2	1	2	f	0	\N	\N
231	75	62	2	14217	\N	14217	\N	\N	3	1	2	f	0	\N	\N
232	11	62	2	8995	\N	8995	\N	\N	4	1	2	f	0	\N	\N
233	55	62	2	111	\N	111	\N	\N	5	1	2	f	0	\N	\N
234	97	62	2	20	\N	20	\N	\N	6	1	2	f	0	\N	\N
235	33	62	2	14	\N	14	\N	\N	7	1	2	f	0	\N	\N
236	100	62	2	1	\N	1	\N	\N	8	1	2	f	0	\N	\N
237	122	62	2	3846953	\N	3846953	\N	\N	0	1	2	f	0	\N	\N
238	37	62	2	3846953	\N	3846953	\N	\N	0	1	2	f	0	\N	\N
239	79	62	2	9836	\N	9836	\N	\N	0	1	2	f	0	\N	\N
240	34	62	2	5529	\N	5529	\N	\N	0	1	2	f	0	\N	\N
241	103	62	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
242	110	62	1	3885673	\N	3885673	\N	\N	1	1	2	f	\N	\N	\N
243	11	63	2	87320	\N	87320	\N	\N	1	1	2	f	0	\N	\N
244	78	63	2	2164	\N	2164	\N	\N	2	1	2	f	0	\N	\N
245	55	63	2	1623	\N	1623	\N	\N	3	1	2	f	0	\N	\N
246	97	63	2	140	\N	140	\N	\N	4	1	2	f	0	\N	\N
247	118	63	2	88	\N	88	\N	\N	5	1	2	f	0	\N	\N
248	21	63	2	81	\N	81	\N	\N	6	1	2	f	0	\N	\N
249	32	63	2	64	\N	64	\N	\N	7	1	2	f	0	\N	\N
250	54	63	2	56	\N	56	\N	\N	8	1	2	f	0	\N	\N
251	12	63	2	50	\N	50	\N	\N	9	1	2	f	0	\N	\N
252	9	63	2	42	\N	42	\N	\N	10	1	2	f	0	\N	\N
253	33	63	2	29	\N	29	\N	\N	11	1	2	f	0	\N	\N
254	96	63	2	6	\N	6	\N	\N	12	1	2	f	0	\N	\N
255	88	63	2	6	\N	0	\N	\N	13	1	2	f	6	\N	\N
256	109	63	2	4	\N	4	\N	\N	14	1	2	f	0	\N	\N
257	59	63	2	3	\N	3	\N	\N	15	1	2	f	0	\N	\N
258	100	63	2	1	\N	1	\N	\N	16	1	2	f	0	\N	\N
259	39	63	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
260	90	63	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
261	3	63	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
262	63	63	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
263	107	63	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
264	25	63	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
265	47	63	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
266	60	63	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
267	103	63	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
268	21	63	1	9	\N	9	\N	\N	1	1	2	f	\N	\N	\N
269	106	64	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
270	51	64	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
271	63	64	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
272	30	64	1	12	\N	12	\N	\N	1	1	2	f	\N	\N	\N
273	63	64	1	12	\N	12	\N	\N	0	1	2	f	\N	\N	\N
274	17	65	2	215	\N	215	\N	\N	1	1	2	f	0	\N	\N
275	61	65	2	3	\N	3	\N	\N	2	1	2	f	0	\N	\N
276	62	65	2	3	\N	3	\N	\N	3	1	2	f	0	\N	\N
277	92	65	2	2	\N	2	\N	\N	4	1	2	f	0	\N	\N
278	57	65	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
279	15	65	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
280	108	65	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
281	50	65	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
282	17	65	1	280	\N	280	\N	\N	1	1	2	f	\N	\N	\N
283	62	65	1	3	\N	3	\N	\N	2	1	2	f	\N	\N	\N
284	15	65	1	10	\N	10	\N	\N	0	1	2	f	\N	\N	\N
285	57	65	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
286	108	65	1	6	\N	6	\N	\N	0	1	2	f	\N	\N	\N
287	100	66	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
288	103	66	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
289	102	67	1	142	\N	142	\N	\N	1	1	2	f	\N	\N	\N
290	17	67	1	19	\N	19	\N	\N	2	1	2	f	\N	\N	\N
291	84	67	1	8	\N	8	\N	\N	3	1	2	f	\N	\N	\N
292	62	67	1	3	\N	3	\N	\N	4	1	2	f	\N	\N	\N
293	8	68	2	61	\N	61	\N	\N	1	1	2	f	0	\N	\N
294	113	68	2	51	\N	51	\N	\N	2	1	2	f	0	\N	\N
295	106	68	2	8	\N	8	\N	\N	3	1	2	f	0	\N	\N
296	80	68	2	4	\N	4	\N	\N	4	1	2	f	0	\N	\N
297	40	68	2	51	\N	51	\N	\N	0	1	2	f	0	\N	\N
298	94	68	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
299	70	68	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
300	51	68	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
301	63	68	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
302	115	68	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
303	91	68	1	98	\N	98	\N	\N	1	1	2	f	\N	\N	\N
304	10	69	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
305	2	70	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
306	30	70	2	12	\N	12	\N	\N	2	1	2	f	0	\N	\N
307	81	70	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
308	63	70	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
309	14	70	1	28	\N	28	\N	\N	1	1	2	f	\N	\N	\N
310	44	71	2	79087	\N	79087	\N	\N	1	1	2	f	0	\N	\N
311	28	71	1	79087	\N	79087	\N	\N	1	1	2	f	\N	\N	\N
312	42	72	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
313	74	74	2	29778986	\N	0	\N	\N	1	1	2	f	29778986	\N	\N
314	73	74	2	22257024	\N	0	\N	\N	2	1	2	f	22257024	\N	\N
315	119	74	2	10217751	\N	0	\N	\N	3	1	2	f	10217751	\N	\N
316	104	74	2	8435976	\N	0	\N	\N	4	1	2	f	8435976	\N	\N
317	7	74	2	8435976	\N	0	\N	\N	5	1	2	f	8435976	\N	\N
318	52	74	2	8435976	\N	0	\N	\N	6	1	2	f	8435976	\N	\N
319	95	74	2	8435976	\N	0	\N	\N	7	1	2	f	8435976	\N	\N
320	110	74	2	7756794	\N	0	\N	\N	8	1	2	f	7756794	\N	\N
321	53	74	2	7693906	\N	0	\N	\N	9	1	2	f	7693906	\N	\N
322	67	74	2	95956	\N	0	\N	\N	10	1	2	f	95956	\N	\N
323	58	74	2	89898	\N	0	\N	\N	11	1	2	f	89898	\N	\N
324	44	74	2	79087	\N	0	\N	\N	12	1	2	f	79087	\N	\N
325	85	74	2	75490	\N	0	\N	\N	13	1	2	f	75490	\N	\N
326	56	74	2	75478	\N	0	\N	\N	14	1	2	f	75478	\N	\N
327	20	74	2	67582	\N	0	\N	\N	15	1	2	f	67582	\N	\N
328	64	74	2	62602	\N	0	\N	\N	16	1	2	f	62602	\N	\N
329	75	74	2	28434	\N	0	\N	\N	17	1	2	f	28434	\N	\N
330	34	74	2	28312	\N	0	\N	\N	18	1	2	f	28312	\N	\N
331	4	74	2	28244	\N	0	\N	\N	19	1	2	f	28244	\N	\N
332	41	74	2	28244	\N	0	\N	\N	20	1	2	f	28244	\N	\N
333	23	74	2	26530	\N	0	\N	\N	21	1	2	f	26530	\N	\N
334	6	74	2	25249	\N	0	\N	\N	22	1	2	f	25249	\N	\N
335	36	74	2	25242	\N	0	\N	\N	23	1	2	f	25242	\N	\N
336	87	74	2	19788	\N	0	\N	\N	24	1	2	f	19788	\N	\N
337	54	74	2	14948	\N	0	\N	\N	25	1	2	f	14948	\N	\N
338	99	74	2	12873	\N	0	\N	\N	26	1	2	f	12873	\N	\N
339	45	74	2	9600	\N	0	\N	\N	27	1	2	f	9600	\N	\N
340	13	74	2	9528	\N	0	\N	\N	28	1	2	f	9528	\N	\N
341	11	74	2	9119	\N	0	\N	\N	29	1	2	f	9119	\N	\N
342	120	74	2	6488	\N	0	\N	\N	30	1	2	f	6488	\N	\N
343	26	74	2	6374	\N	0	\N	\N	31	1	2	f	6374	\N	\N
344	28	74	2	6213	\N	0	\N	\N	32	1	2	f	6213	\N	\N
345	77	74	2	5757	\N	0	\N	\N	33	1	2	f	5757	\N	\N
346	112	74	2	5532	\N	0	\N	\N	34	1	2	f	5532	\N	\N
347	78	74	2	4660	\N	0	\N	\N	35	1	2	f	4660	\N	\N
348	24	74	2	4344	\N	0	\N	\N	36	1	2	f	4344	\N	\N
349	66	74	2	2184	\N	0	\N	\N	37	1	2	f	2184	\N	\N
350	121	74	2	2000	\N	0	\N	\N	38	1	2	f	2000	\N	\N
351	98	74	2	908	\N	0	\N	\N	39	1	2	f	908	\N	\N
352	111	74	2	836	\N	0	\N	\N	40	1	2	f	836	\N	\N
353	86	74	2	722	\N	0	\N	\N	41	1	2	f	722	\N	\N
354	17	74	2	503	\N	0	\N	\N	42	1	2	f	503	\N	\N
355	76	74	2	468	\N	0	\N	\N	43	1	2	f	468	\N	\N
356	102	74	2	419	\N	0	\N	\N	44	1	2	f	419	\N	\N
357	103	74	2	358	\N	0	\N	\N	45	1	2	f	358	\N	\N
358	32	74	2	328	\N	0	\N	\N	46	1	2	f	328	\N	\N
359	118	74	2	286	\N	0	\N	\N	47	1	2	f	286	\N	\N
360	9	74	2	218	\N	0	\N	\N	48	1	2	f	218	\N	\N
361	21	74	2	162	\N	0	\N	\N	49	1	2	f	162	\N	\N
362	35	74	2	138	\N	0	\N	\N	50	1	2	f	138	\N	\N
363	55	74	2	111	\N	0	\N	\N	51	1	2	f	111	\N	\N
364	62	74	2	102	\N	0	\N	\N	52	1	2	f	102	\N	\N
365	43	74	2	86	\N	0	\N	\N	53	1	2	f	86	\N	\N
366	117	74	2	84	\N	0	\N	\N	54	1	2	f	84	\N	\N
367	63	74	2	68	\N	0	\N	\N	55	1	2	f	68	\N	\N
368	8	74	2	57	\N	0	\N	\N	56	1	2	f	57	\N	\N
369	113	74	2	45	\N	0	\N	\N	57	1	2	f	45	\N	\N
370	12	74	2	38	\N	0	\N	\N	58	1	2	f	38	\N	\N
371	31	74	2	36	\N	0	\N	\N	59	1	2	f	36	\N	\N
372	2	74	2	34	\N	0	\N	\N	60	1	2	f	34	\N	\N
373	109	74	2	26	\N	0	\N	\N	61	1	2	f	26	\N	\N
374	51	74	2	23	\N	0	\N	\N	62	1	2	f	23	\N	\N
375	92	74	2	23	\N	0	\N	\N	63	1	2	f	23	\N	\N
376	97	74	2	20	\N	0	\N	\N	64	1	2	f	20	\N	\N
377	19	74	2	16	\N	0	\N	\N	65	1	2	f	16	\N	\N
378	33	74	2	14	\N	0	\N	\N	66	1	2	f	14	\N	\N
379	88	74	2	12	\N	0	\N	\N	67	1	2	f	12	\N	\N
380	94	74	2	11	\N	0	\N	\N	68	1	2	f	11	\N	\N
381	22	74	2	8	\N	0	\N	\N	69	1	2	f	8	\N	\N
382	18	74	2	8	\N	0	\N	\N	70	1	2	f	8	\N	\N
383	68	74	2	6	\N	0	\N	\N	71	1	2	f	6	\N	\N
384	80	74	2	4	\N	0	\N	\N	72	1	2	f	4	\N	\N
385	59	74	2	3	\N	0	\N	\N	73	1	2	f	3	\N	\N
386	116	74	2	2	\N	0	\N	\N	74	1	2	f	2	\N	\N
387	89	74	2	2	\N	0	\N	\N	75	1	2	f	2	\N	\N
388	96	74	2	1	\N	0	\N	\N	76	1	2	f	1	\N	\N
389	105	74	2	8435976	\N	0	\N	\N	0	1	2	f	8435976	\N	\N
390	29	74	2	8435976	\N	0	\N	\N	0	1	2	f	8435976	\N	\N
391	122	74	2	7693906	\N	0	\N	\N	0	1	2	f	7693906	\N	\N
392	37	74	2	7693906	\N	0	\N	\N	0	1	2	f	7693906	\N	\N
393	27	74	2	324782	\N	0	\N	\N	0	1	2	f	324782	\N	\N
394	79	74	2	19672	\N	0	\N	\N	0	1	2	f	19672	\N	\N
395	65	74	2	1726	\N	0	\N	\N	0	1	2	f	1726	\N	\N
396	1	74	2	1726	\N	0	\N	\N	0	1	2	f	1726	\N	\N
397	38	74	2	588	\N	0	\N	\N	0	1	2	f	588	\N	\N
398	39	74	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
399	90	74	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
400	3	74	2	52	\N	0	\N	\N	0	1	2	f	52	\N	\N
401	40	74	2	45	\N	0	\N	\N	0	1	2	f	45	\N	\N
402	81	74	2	34	\N	0	\N	\N	0	1	2	f	34	\N	\N
403	107	74	2	30	\N	0	\N	\N	0	1	2	f	30	\N	\N
404	57	74	2	23	\N	0	\N	\N	0	1	2	f	23	\N	\N
405	25	74	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
406	47	74	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
407	60	74	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
408	114	74	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
409	15	74	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
410	93	74	2	15	\N	0	\N	\N	0	1	2	f	15	\N	\N
411	70	74	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
412	5	74	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
413	106	74	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
414	16	74	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
415	108	74	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
416	115	74	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
417	61	74	2	3	\N	0	\N	\N	0	1	2	f	3	\N	\N
418	100	74	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
419	50	74	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
420	8	75	2	68	\N	0	\N	\N	1	1	2	f	68	\N	\N
421	2	75	2	68	\N	0	\N	\N	2	1	2	f	68	\N	\N
422	113	75	2	56	\N	0	\N	\N	3	1	2	f	56	\N	\N
423	63	75	2	32	\N	0	\N	\N	4	1	2	f	32	\N	\N
424	51	75	2	20	\N	0	\N	\N	5	1	2	f	20	\N	\N
425	94	75	2	20	\N	0	\N	\N	6	1	2	f	20	\N	\N
426	46	75	2	4	\N	0	\N	\N	7	1	2	f	4	\N	\N
427	80	75	2	4	\N	0	\N	\N	8	1	2	f	4	\N	\N
428	81	75	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
429	40	75	2	56	\N	0	\N	\N	0	1	2	f	56	\N	\N
430	30	75	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
431	70	75	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
432	106	75	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
433	48	75	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
434	115	75	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
435	112	76	2	5532	\N	5532	\N	\N	1	1	2	f	0	\N	\N
436	23	76	1	5523	\N	5523	\N	\N	1	1	2	f	\N	\N	\N
437	103	77	2	484	\N	0	\N	\N	1	1	2	f	484	\N	\N
438	94	77	2	25	\N	0	\N	\N	2	1	2	f	25	\N	\N
439	14	77	2	8	\N	0	\N	\N	3	1	2	f	8	\N	\N
440	72	77	2	16	\N	0	\N	\N	0	1	2	f	16	\N	\N
441	100	77	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
442	51	78	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
443	104	79	2	4217988	\N	0	\N	\N	1	1	2	f	4217988	\N	\N
444	79	79	2	9836	\N	0	\N	\N	2	1	2	f	9836	\N	\N
445	105	79	2	4217988	\N	0	\N	\N	0	1	2	f	4217988	\N	\N
446	20	79	2	9836	\N	0	\N	\N	0	1	2	f	9836	\N	\N
447	110	80	2	3878395	\N	3878395	\N	\N	1	1	2	f	0	\N	\N
448	19	80	1	3878395	\N	3878395	\N	\N	1	1	2	f	\N	\N	\N
449	74	81	2	8058497	\N	0	\N	\N	1	1	2	f	8058497	\N	\N
450	119	81	2	4200579	\N	0	\N	\N	2	1	2	f	4200579	\N	\N
451	110	81	2	3878397	\N	0	\N	\N	3	1	2	f	3878397	\N	\N
452	54	81	2	7398	\N	0	\N	\N	4	1	2	f	7398	\N	\N
453	65	81	2	830	\N	0	\N	\N	5	1	2	f	830	\N	\N
454	19	81	2	8	\N	0	\N	\N	6	1	2	f	8	\N	\N
455	27	81	2	162385	\N	0	\N	\N	0	1	2	f	162385	\N	\N
456	34	81	2	830	\N	0	\N	\N	0	1	2	f	830	\N	\N
457	1	81	2	830	\N	0	\N	\N	0	1	2	f	830	\N	\N
458	69	82	2	111951	\N	0	\N	\N	1	1	2	f	111951	\N	\N
459	38	83	2	294	\N	0	\N	\N	1	1	2	f	294	\N	\N
460	67	83	2	294	\N	0	\N	\N	0	1	2	f	294	\N	\N
461	104	84	2	4217988	\N	0	\N	\N	1	1	2	f	4217988	\N	\N
462	20	84	2	29487	\N	0	\N	\N	2	1	2	f	29487	\N	\N
463	23	84	2	25509	\N	0	\N	\N	3	1	2	f	25509	\N	\N
464	75	84	2	14217	\N	0	\N	\N	4	1	2	f	14217	\N	\N
465	67	84	2	9931	\N	0	\N	\N	5	1	2	f	9931	\N	\N
466	11	84	2	8996	\N	0	\N	\N	6	1	2	f	8996	\N	\N
467	105	84	2	4217988	\N	0	\N	\N	0	1	2	f	4217988	\N	\N
468	79	84	2	9836	\N	0	\N	\N	0	1	2	f	9836	\N	\N
469	34	84	2	5529	\N	0	\N	\N	0	1	2	f	5529	\N	\N
470	95	85	2	4217988	\N	4217988	\N	\N	1	1	2	f	0	\N	\N
471	53	85	1	4217988	\N	4217988	\N	\N	1	1	2	f	\N	\N	\N
472	37	85	1	4217988	\N	4217988	\N	\N	0	1	2	f	\N	\N	\N
473	122	85	1	4217988	\N	4217988	\N	\N	0	1	2	f	\N	\N	\N
474	42	86	2	31	\N	0	\N	\N	1	1	2	f	31	\N	\N
475	104	87	2	4217988	\N	4217988	\N	\N	1	1	2	f	0	\N	\N
476	105	87	2	4217988	\N	4217988	\N	\N	0	1	2	f	0	\N	\N
477	95	87	1	4217988	\N	4217988	\N	\N	1	1	2	f	\N	\N	\N
478	103	88	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
479	32	89	2	107	\N	0	\N	\N	1	1	2	f	107	\N	\N
480	7	90	2	4217988	\N	4217988	\N	\N	1	1	2	f	0	\N	\N
481	29	90	2	4217988	\N	4217988	\N	\N	0	1	2	f	0	\N	\N
482	103	90	1	4217988	\N	4217988	\N	\N	1	1	2	f	\N	\N	\N
483	65	91	2	830	\N	0	\N	\N	1	1	2	f	830	\N	\N
484	34	91	2	830	\N	0	\N	\N	0	1	2	f	830	\N	\N
485	1	91	2	830	\N	0	\N	\N	0	1	2	f	830	\N	\N
486	70	92	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
487	94	92	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
488	113	92	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
489	40	92	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
490	45	93	2	4800	\N	4800	\N	\N	1	1	2	f	0	\N	\N
491	89	93	1	4800	\N	4800	\N	\N	1	1	2	f	\N	\N	\N
492	77	94	2	5757	\N	5757	\N	\N	1	1	2	f	0	\N	\N
493	103	94	1	5757	\N	5757	\N	\N	1	1	2	f	\N	\N	\N
494	110	95	2	3878396	\N	3878396	\N	\N	1	1	2	f	0	\N	\N
495	19	95	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
496	9	95	1	38646317	\N	38646317	\N	\N	1	1	2	f	\N	\N	\N
497	116	95	1	1	\N	1	\N	\N	2	1	2	f	\N	\N	\N
498	63	95	1	38637160	\N	38637160	\N	\N	0	1	2	f	\N	\N	\N
499	39	95	1	38637160	\N	38637160	\N	\N	0	1	2	f	\N	\N	\N
500	90	95	1	38637160	\N	38637160	\N	\N	0	1	2	f	\N	\N	\N
501	3	95	1	38637160	\N	38637160	\N	\N	0	1	2	f	\N	\N	\N
502	107	95	1	23182296	\N	23182296	\N	\N	0	1	2	f	\N	\N	\N
503	25	95	1	15454864	\N	15454864	\N	\N	0	1	2	f	\N	\N	\N
504	47	95	1	15454864	\N	15454864	\N	\N	0	1	2	f	\N	\N	\N
505	60	95	1	15454864	\N	15454864	\N	\N	0	1	2	f	\N	\N	\N
506	56	96	2	37739	\N	37739	\N	\N	1	1	2	f	0	\N	\N
507	4	96	2	14122	\N	14122	\N	\N	2	1	2	f	0	\N	\N
508	45	96	2	4800	\N	4800	\N	\N	3	1	2	f	0	\N	\N
509	34	96	1	108511	\N	108511	\N	\N	1	1	2	f	\N	\N	\N
510	59	96	1	4800	\N	4800	\N	\N	2	1	2	f	\N	\N	\N
511	2	97	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
512	30	97	2	12	\N	12	\N	\N	2	1	2	f	0	\N	\N
513	81	97	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
514	63	97	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
515	102	98	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
516	106	98	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
517	8	98	2	2	\N	2	\N	\N	3	1	2	f	0	\N	\N
518	51	98	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
519	63	98	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
520	113	98	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
521	40	98	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
522	11	99	2	8995	\N	8995	\N	\N	1	1	2	f	0	\N	\N
523	55	99	2	111	\N	111	\N	\N	2	1	2	f	0	\N	\N
524	33	99	2	14	\N	14	\N	\N	3	1	2	f	0	\N	\N
525	97	99	1	9120	\N	9120	\N	\N	1	1	2	f	\N	\N	\N
526	52	100	2	4217988	\N	4217988	\N	\N	1	1	2	f	0	\N	\N
527	78	100	1	4217733	\N	4217733	\N	\N	1	1	2	f	\N	\N	\N
528	106	101	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
529	51	101	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
530	63	101	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
531	118	102	2	435	\N	0	\N	\N	1	1	2	f	435	\N	\N
532	85	103	2	37739	\N	37739	\N	\N	1	1	2	f	0	\N	\N
533	31	103	1	37739	\N	37739	\N	\N	1	1	2	f	\N	\N	\N
534	119	104	2	5091963	\N	5091963	\N	\N	1	1	2	f	0	\N	\N
535	121	104	2	1000	\N	1000	\N	\N	2	1	2	f	0	\N	\N
536	98	104	2	454	\N	454	\N	\N	3	1	2	f	0	\N	\N
537	54	104	1	5095977	\N	5095977	\N	\N	1	1	2	f	\N	\N	\N
538	71	105	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
539	90	106	2	86	\N	86	\N	\N	1	1	2	f	0	\N	\N
540	63	106	2	85	\N	85	\N	\N	0	1	2	f	0	\N	\N
541	25	106	2	74	\N	74	\N	\N	0	1	2	f	0	\N	\N
542	47	106	2	74	\N	74	\N	\N	0	1	2	f	0	\N	\N
543	9	106	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
544	39	106	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
545	3	106	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
546	107	106	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
547	60	106	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
548	102	107	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
549	102	107	1	5	\N	5	\N	\N	1	1	2	f	\N	\N	\N
550	70	108	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
551	94	108	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
552	113	108	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
553	40	108	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
554	6	109	2	25249	\N	0	\N	\N	1	1	2	f	25249	\N	\N
555	102	110	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
556	64	111	2	31299	\N	31299	\N	\N	1	1	2	f	0	\N	\N
557	11	111	1	15640	\N	15640	\N	\N	1	1	2	f	\N	\N	\N
558	20	111	1	15365	\N	15365	\N	\N	2	1	2	f	\N	\N	\N
559	55	111	1	204	\N	204	\N	\N	3	1	2	f	\N	\N	\N
560	97	111	1	60	\N	60	\N	\N	4	1	2	f	\N	\N	\N
561	33	111	1	28	\N	28	\N	\N	5	1	2	f	\N	\N	\N
562	96	111	1	2	\N	2	\N	\N	6	1	2	f	\N	\N	\N
563	79	111	1	9836	\N	9836	\N	\N	0	1	2	f	\N	\N	\N
564	34	111	1	5529	\N	5529	\N	\N	0	1	2	f	\N	\N	\N
565	42	112	2	5	\N	5	\N	\N	1	1	2	f	0	\N	\N
566	84	112	1	3	\N	3	\N	\N	1	1	2	f	\N	\N	\N
567	17	113	2	502	\N	4	\N	\N	1	1	2	f	498	\N	\N
568	102	113	2	375	\N	0	\N	\N	2	1	2	f	375	\N	\N
569	62	113	2	94	\N	0	\N	\N	3	1	2	f	94	\N	\N
570	51	113	2	13	\N	0	\N	\N	4	1	2	f	13	\N	\N
571	70	113	2	12	\N	0	\N	\N	5	1	2	f	12	\N	\N
572	57	113	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
573	15	113	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
574	94	113	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
575	113	113	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
576	40	113	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
577	63	113	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
578	106	113	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
579	108	113	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
580	50	113	2	3	\N	1	\N	\N	0	1	2	f	2	\N	\N
581	51	113	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
582	103	114	2	93	\N	93	\N	\N	1	1	2	f	0	\N	\N
583	103	114	1	93	\N	93	\N	\N	1	1	2	f	\N	\N	\N
584	39	115	2	41	\N	41	\N	\N	1	1	2	f	0	\N	\N
585	9	115	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
586	90	115	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
587	3	115	2	41	\N	41	\N	\N	0	1	2	f	0	\N	\N
588	63	115	2	40	\N	40	\N	\N	0	1	2	f	0	\N	\N
589	107	115	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
590	25	115	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
591	47	115	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
592	60	115	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
593	36	116	2	25249	\N	0	\N	\N	1	1	2	f	25249	\N	\N
594	102	117	2	42	\N	0	\N	\N	1	1	2	f	42	\N	\N
595	17	117	2	31	\N	0	\N	\N	2	1	2	f	31	\N	\N
596	62	117	2	29	\N	0	\N	\N	3	1	2	f	29	\N	\N
597	61	117	2	1	\N	0	\N	\N	0	1	2	f	1	\N	\N
598	52	118	2	4217988	\N	4217988	\N	\N	1	1	2	f	0	\N	\N
599	39	118	1	42179880	\N	42179880	\N	\N	1	1	2	f	\N	\N	\N
600	63	118	1	42179880	\N	42179880	\N	\N	0	1	2	f	\N	\N	\N
601	9	118	1	42179880	\N	42179880	\N	\N	0	1	2	f	\N	\N	\N
602	90	118	1	42179880	\N	42179880	\N	\N	0	1	2	f	\N	\N	\N
603	3	118	1	42179880	\N	42179880	\N	\N	0	1	2	f	\N	\N	\N
604	107	118	1	25307928	\N	25307928	\N	\N	0	1	2	f	\N	\N	\N
605	25	118	1	16871952	\N	16871952	\N	\N	0	1	2	f	\N	\N	\N
606	47	118	1	16871952	\N	16871952	\N	\N	0	1	2	f	\N	\N	\N
607	60	118	1	16871952	\N	16871952	\N	\N	0	1	2	f	\N	\N	\N
608	36	119	2	1105	\N	1105	\N	\N	1	1	2	f	0	\N	\N
609	11	119	1	1105	\N	1105	\N	\N	1	1	2	f	\N	\N	\N
610	66	120	2	2184	\N	0	\N	\N	1	1	2	f	2184	\N	\N
611	114	120	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
612	103	121	2	56	\N	0	\N	\N	1	1	2	f	56	\N	\N
613	75	122	2	14217	\N	14217	\N	\N	1	1	2	f	0	\N	\N
614	4	122	2	14122	\N	14122	\N	\N	2	1	2	f	0	\N	\N
615	64	122	2	1	\N	1	\N	\N	3	1	2	f	0	\N	\N
616	20	122	1	28340	\N	28340	\N	\N	1	1	2	f	\N	\N	\N
617	23	123	2	6621	\N	0	\N	\N	1	1	2	f	6621	\N	\N
618	17	124	2	259	\N	259	\N	\N	1	1	2	f	0	\N	\N
619	62	124	2	52	\N	52	\N	\N	2	1	2	f	0	\N	\N
620	92	124	2	21	\N	21	\N	\N	3	1	2	f	0	\N	\N
621	57	124	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
622	15	124	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
623	16	124	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
624	108	124	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
625	50	124	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
626	61	124	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
627	102	124	1	485	\N	485	\N	\N	1	1	2	f	\N	\N	\N
628	93	124	1	18	\N	18	\N	\N	0	1	2	f	\N	\N	\N
629	9	125	2	23	\N	0	\N	\N	1	1	2	f	23	\N	\N
630	39	125	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
631	90	125	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
632	3	125	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
633	63	125	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
634	107	125	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
635	25	125	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
636	47	125	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
637	60	125	2	9	\N	0	\N	\N	0	1	2	f	9	\N	\N
638	70	126	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
639	94	126	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
640	113	126	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
641	40	126	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
642	11	127	2	8995	\N	8995	\N	\N	1	1	2	f	0	\N	\N
643	55	127	2	111	\N	111	\N	\N	2	1	2	f	0	\N	\N
644	97	127	2	20	\N	20	\N	\N	3	1	2	f	0	\N	\N
645	33	127	2	14	\N	14	\N	\N	4	1	2	f	0	\N	\N
646	96	127	1	9140	\N	9140	\N	\N	1	1	2	f	\N	\N	\N
647	103	128	2	98	\N	0	\N	\N	1	1	2	f	98	\N	\N
648	8	129	2	66	\N	66	\N	\N	1	1	2	f	0	\N	\N
649	113	129	2	50	\N	50	\N	\N	2	1	2	f	0	\N	\N
650	106	129	2	12	\N	12	\N	\N	3	1	2	f	0	\N	\N
651	40	129	2	50	\N	50	\N	\N	0	1	2	f	0	\N	\N
652	51	129	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
653	63	129	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
654	94	129	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
655	70	129	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
656	103	129	1	82	\N	82	\N	\N	1	1	2	f	\N	\N	\N
657	42	130	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
658	99	131	2	12873	\N	12873	\N	\N	1	1	2	f	0	\N	\N
659	23	131	1	12858	\N	12858	\N	\N	1	1	2	f	\N	\N	\N
660	7	132	2	4217988	\N	4217988	\N	\N	1	1	2	f	0	\N	\N
661	29	132	2	4217988	\N	4217988	\N	\N	0	1	2	f	0	\N	\N
662	79	132	1	4217988	\N	4217988	\N	\N	1	1	2	f	\N	\N	\N
663	20	132	1	4217988	\N	4217988	\N	\N	0	1	2	f	\N	\N	\N
664	66	133	2	2163	\N	0	\N	\N	1	1	2	f	2163	\N	\N
665	11	134	2	9119	\N	0	\N	\N	1	1	2	f	9119	\N	\N
666	34	134	2	6373	\N	0	\N	\N	2	1	2	f	6373	\N	\N
667	55	134	2	111	\N	0	\N	\N	3	1	2	f	111	\N	\N
668	75	134	2	95	\N	0	\N	\N	4	1	2	f	95	\N	\N
669	35	134	2	69	\N	0	\N	\N	5	1	2	f	69	\N	\N
670	117	134	2	42	\N	0	\N	\N	6	1	2	f	42	\N	\N
671	97	134	2	20	\N	0	\N	\N	7	1	2	f	20	\N	\N
672	33	134	2	14	\N	0	\N	\N	8	1	2	f	14	\N	\N
673	43	134	2	4	\N	0	\N	\N	9	1	2	f	4	\N	\N
674	32	134	2	4	\N	0	\N	\N	10	1	2	f	4	\N	\N
675	59	134	2	3	\N	0	\N	\N	11	1	2	f	3	\N	\N
676	116	134	2	2	\N	0	\N	\N	12	1	2	f	2	\N	\N
677	89	134	2	2	\N	0	\N	\N	13	1	2	f	2	\N	\N
678	83	134	2	2	\N	0	\N	\N	14	1	2	f	2	\N	\N
679	96	134	2	1	\N	0	\N	\N	15	1	2	f	1	\N	\N
680	20	134	2	5529	\N	0	\N	\N	0	1	2	f	5529	\N	\N
681	65	134	2	844	\N	0	\N	\N	0	1	2	f	844	\N	\N
682	1	134	2	844	\N	0	\N	\N	0	1	2	f	844	\N	\N
683	63	134	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
684	23	135	2	22536	\N	0	\N	\N	1	1	2	f	22536	\N	\N
685	78	136	2	2322	\N	0	\N	\N	1	1	2	f	2322	\N	\N
686	106	137	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
687	51	137	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
688	63	137	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
689	54	138	2	7334	\N	7334	\N	\N	1	1	2	f	0	\N	\N
690	54	138	1	7334	\N	7334	\N	\N	1	1	2	f	\N	\N	\N
691	43	139	2	42	\N	0	\N	\N	1	1	2	f	42	\N	\N
692	68	139	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
693	17	140	2	98	\N	98	\N	\N	1	1	2	f	0	\N	\N
694	15	140	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
695	57	140	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
696	108	140	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
697	50	140	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
698	17	140	1	91	\N	91	\N	\N	1	1	2	f	\N	\N	\N
699	15	140	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
700	57	140	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
701	108	140	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
702	50	140	1	1	\N	1	\N	\N	0	1	2	f	\N	\N	\N
703	102	141	2	6	\N	6	\N	\N	1	1	2	f	0	\N	\N
704	23	142	2	111951	\N	111951	\N	\N	1	1	2	f	0	\N	\N
705	69	142	1	111951	\N	111951	\N	\N	1	1	2	f	\N	\N	\N
706	8	144	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
707	113	144	2	28	\N	28	\N	\N	2	1	2	f	0	\N	\N
708	106	144	2	4	\N	4	\N	\N	3	1	2	f	0	\N	\N
709	40	144	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
710	94	144	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
711	70	144	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
712	51	144	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
713	63	144	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
714	25	144	1	171	\N	171	\N	\N	1	1	2	f	\N	\N	\N
715	63	144	1	171	\N	171	\N	\N	0	1	2	f	\N	\N	\N
716	47	144	1	171	\N	171	\N	\N	0	1	2	f	\N	\N	\N
717	90	144	1	171	\N	171	\N	\N	0	1	2	f	\N	\N	\N
718	103	145	2	46	\N	0	\N	\N	1	1	2	f	46	\N	\N
719	56	146	2	37739	\N	37739	\N	\N	1	1	2	f	0	\N	\N
720	12	146	1	83758	\N	83758	\N	\N	1	1	2	f	\N	\N	\N
721	56	147	2	37739	\N	37739	\N	\N	1	1	2	f	0	\N	\N
722	22	147	1	37739	\N	37739	\N	\N	1	1	2	f	\N	\N	\N
723	95	148	2	4217988	\N	4217988	\N	\N	1	1	2	f	0	\N	\N
724	7	148	1	4217988	\N	4217988	\N	\N	1	1	2	f	\N	\N	\N
725	29	148	1	4217988	\N	4217988	\N	\N	0	1	2	f	\N	\N	\N
726	23	149	2	26530	\N	0	\N	\N	1	1	2	f	26530	\N	\N
727	11	150	2	8995	\N	0	\N	\N	1	1	2	f	8995	\N	\N
728	55	150	2	111	\N	0	\N	\N	2	1	2	f	111	\N	\N
729	97	150	2	20	\N	0	\N	\N	3	1	2	f	20	\N	\N
730	33	150	2	14	\N	0	\N	\N	4	1	2	f	14	\N	\N
731	96	150	2	1	\N	0	\N	\N	5	1	2	f	1	\N	\N
732	17	151	2	230	\N	230	\N	\N	1	1	2	f	0	\N	\N
733	102	151	2	189	\N	189	\N	\N	2	1	2	f	0	\N	\N
734	62	151	2	25	\N	25	\N	\N	3	1	2	f	0	\N	\N
735	63	151	2	9	\N	9	\N	\N	4	1	2	f	0	\N	\N
736	51	151	2	8	\N	8	\N	\N	5	1	2	f	0	\N	\N
737	57	151	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
738	15	151	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
739	5	151	2	5	\N	5	\N	\N	0	1	2	f	0	\N	\N
740	106	151	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
741	108	151	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
742	50	151	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
743	51	151	1	391	\N	391	\N	\N	1	1	2	f	\N	\N	\N
744	63	151	1	288	\N	288	\N	\N	0	1	2	f	\N	\N	\N
745	106	151	1	288	\N	288	\N	\N	0	1	2	f	\N	\N	\N
746	75	152	2	95	\N	95	\N	\N	1	1	2	f	0	\N	\N
747	88	152	1	138	\N	138	\N	\N	1	1	2	f	\N	\N	\N
748	54	153	2	6718	\N	6718	\N	\N	1	1	2	f	0	\N	\N
749	34	153	1	6718	\N	6718	\N	\N	1	1	2	f	\N	\N	\N
750	78	154	2	2322	\N	0	\N	\N	1	1	2	f	2322	\N	\N
751	17	155	2	7	\N	7	\N	\N	1	1	2	f	0	\N	\N
752	41	156	2	14122	\N	14122	\N	\N	1	1	2	f	0	\N	\N
753	111	156	2	418	\N	418	\N	\N	2	1	2	f	0	\N	\N
754	75	156	1	14540	\N	14540	\N	\N	1	1	2	f	\N	\N	\N
755	114	157	2	21	\N	0	\N	\N	1	1	2	f	21	\N	\N
756	66	157	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
757	42	158	2	84	\N	84	\N	\N	1	1	2	f	0	\N	\N
758	102	158	1	121	\N	121	\N	\N	1	1	2	f	\N	\N	\N
759	42	158	1	2	\N	2	\N	\N	2	1	2	f	\N	\N	\N
760	104	159	2	4217988	\N	4217988	\N	\N	1	1	2	f	0	\N	\N
761	105	159	2	4217988	\N	4217988	\N	\N	0	1	2	f	0	\N	\N
762	53	159	1	4217988	\N	4217988	\N	\N	1	1	2	f	\N	\N	\N
763	37	159	1	4217988	\N	4217988	\N	\N	0	1	2	f	\N	\N	\N
764	122	159	1	4217988	\N	4217988	\N	\N	0	1	2	f	\N	\N	\N
765	102	160	2	28	\N	28	\N	\N	1	1	2	f	0	\N	\N
766	102	160	1	24	\N	24	\N	\N	1	1	2	f	\N	\N	\N
767	71	161	2	2	\N	2	\N	\N	1	1	2	f	0	\N	\N
768	71	162	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
769	99	163	2	12873	\N	12873	\N	\N	1	1	2	f	0	\N	\N
770	103	163	1	12873	\N	12873	\N	\N	1	1	2	f	\N	\N	\N
771	102	164	2	22	\N	22	\N	\N	1	1	2	f	0	\N	\N
772	84	164	2	4	\N	4	\N	\N	2	1	2	f	0	\N	\N
773	2	165	2	22	\N	22	\N	\N	1	1	2	f	0	\N	\N
774	81	165	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
775	102	166	2	64	\N	0	\N	\N	1	1	2	f	64	\N	\N
776	17	166	2	37	\N	0	\N	\N	2	1	2	f	37	\N	\N
777	63	166	2	18	\N	0	\N	\N	3	1	2	f	18	\N	\N
778	51	166	2	14	\N	0	\N	\N	4	1	2	f	14	\N	\N
779	70	166	2	12	\N	0	\N	\N	5	1	2	f	12	\N	\N
780	46	166	2	4	\N	0	\N	\N	6	1	2	f	4	\N	\N
781	62	166	2	4	\N	0	\N	\N	7	1	2	f	4	\N	\N
782	94	166	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
783	113	166	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
784	40	166	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
785	5	166	2	10	\N	0	\N	\N	0	1	2	f	10	\N	\N
786	106	166	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
787	48	166	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
788	38	167	2	294	\N	0	\N	\N	1	1	2	f	294	\N	\N
789	67	167	2	294	\N	0	\N	\N	0	1	2	f	294	\N	\N
790	45	168	2	4800	\N	4800	\N	\N	1	1	2	f	0	\N	\N
791	13	168	1	4800	\N	4800	\N	\N	1	1	2	f	\N	\N	\N
792	8	169	2	25	\N	0	\N	\N	1	1	2	f	25	\N	\N
793	113	169	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
794	40	169	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
795	45	170	2	4800	\N	4800	\N	\N	1	1	2	f	0	\N	\N
796	100	170	1	4800	\N	4800	\N	\N	1	1	2	f	\N	\N	\N
797	103	170	1	4800	\N	4800	\N	\N	0	1	2	f	\N	\N	\N
798	69	171	2	111951	\N	111951	\N	\N	1	1	2	f	0	\N	\N
799	56	172	2	37739	\N	37739	\N	\N	1	1	2	f	0	\N	\N
800	27	172	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
801	74	172	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
802	85	172	1	37745	\N	37745	\N	\N	1	1	2	f	\N	\N	\N
803	23	173	2	26530	\N	26530	\N	\N	1	1	2	f	0	\N	\N
804	36	173	1	26530	\N	26530	\N	\N	1	1	2	f	\N	\N	\N
805	85	174	2	37745	\N	0	\N	\N	1	1	2	f	37745	\N	\N
806	103	175	2	163	\N	163	\N	\N	1	1	2	f	0	\N	\N
807	103	175	1	163	\N	163	\N	\N	1	1	2	f	\N	\N	\N
808	35	176	2	51	\N	51	\N	\N	1	1	2	f	0	\N	\N
809	43	176	2	6	\N	6	\N	\N	2	1	2	f	0	\N	\N
810	9	176	1	171	\N	171	\N	\N	1	1	2	f	\N	\N	\N
811	70	177	2	19	\N	19	\N	\N	1	1	2	f	0	\N	\N
812	94	177	2	19	\N	19	\N	\N	0	1	2	f	0	\N	\N
813	113	177	2	19	\N	19	\N	\N	0	1	2	f	0	\N	\N
814	40	177	2	19	\N	19	\N	\N	0	1	2	f	0	\N	\N
815	103	177	1	19	\N	19	\N	\N	1	1	2	f	\N	\N	\N
816	121	179	2	42	\N	42	\N	\N	1	1	2	f	0	\N	\N
817	18	179	1	42	\N	42	\N	\N	1	1	2	f	\N	\N	\N
818	23	180	2	26521	\N	26521	\N	\N	1	1	2	f	0	\N	\N
819	36	180	2	25240	\N	25240	\N	\N	2	1	2	f	0	\N	\N
820	6	180	2	25215	\N	25215	\N	\N	3	1	2	f	0	\N	\N
821	34	180	2	5529	\N	5529	\N	\N	4	1	2	f	0	\N	\N
822	43	180	2	38	\N	38	\N	\N	5	1	2	f	0	\N	\N
823	20	180	2	5529	\N	5529	\N	\N	0	1	2	f	0	\N	\N
824	119	181	2	5176070	\N	5176070	\N	\N	1	1	2	f	0	\N	\N
825	56	181	2	37739	\N	37739	\N	\N	2	1	2	f	0	\N	\N
826	87	181	2	19729	\N	19729	\N	\N	3	1	2	f	0	\N	\N
827	64	181	2	15934	\N	15934	\N	\N	4	1	2	f	0	\N	\N
828	20	181	2	14212	\N	14212	\N	\N	5	1	2	f	0	\N	\N
829	45	181	2	4800	\N	4800	\N	\N	6	1	2	f	0	\N	\N
830	120	181	2	3242	\N	3242	\N	\N	7	1	2	f	0	\N	\N
831	26	181	2	3185	\N	3185	\N	\N	8	1	2	f	0	\N	\N
832	119	181	1	5158116	\N	5158116	\N	\N	1	1	2	f	\N	\N	\N
833	8	181	1	51070	\N	51070	\N	\N	2	1	2	f	\N	\N	\N
834	64	181	1	44110	\N	44110	\N	\N	3	1	2	f	\N	\N	\N
835	87	181	1	37739	\N	37739	\N	\N	4	1	2	f	\N	\N	\N
836	20	181	1	14122	\N	14122	\N	\N	5	1	2	f	\N	\N	\N
837	21	181	1	270	\N	270	\N	\N	6	1	2	f	\N	\N	\N
838	113	181	1	35136	\N	35136	\N	\N	0	1	2	f	\N	\N	\N
839	40	181	1	35136	\N	35136	\N	\N	0	1	2	f	\N	\N	\N
840	51	182	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
841	63	182	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
842	106	182	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
843	103	183	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
844	103	183	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
845	8	184	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
846	113	184	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
847	40	184	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
848	114	184	1	23	\N	23	\N	\N	1	1	2	f	\N	\N	\N
849	66	184	1	23	\N	23	\N	\N	0	1	2	f	\N	\N	\N
850	51	185	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
851	112	186	2	5532	\N	0	\N	\N	1	1	2	f	5532	\N	\N
852	78	187	2	2330	\N	0	\N	\N	1	1	2	f	2330	\N	\N
853	23	188	2	26530	\N	0	\N	\N	1	1	2	f	26530	\N	\N
854	36	188	2	24496	\N	0	\N	\N	2	1	2	f	24496	\N	\N
855	63	189	2	108	\N	0	\N	\N	1	1	2	f	108	\N	\N
856	39	189	2	105	\N	0	\N	\N	2	1	2	f	105	\N	\N
857	8	189	2	34	\N	0	\N	\N	3	1	2	f	34	\N	\N
858	113	189	2	28	\N	0	\N	\N	4	1	2	f	28	\N	\N
859	103	189	2	23	\N	0	\N	\N	5	1	2	f	23	\N	\N
860	51	189	2	7	\N	0	\N	\N	6	1	2	f	7	\N	\N
861	3	189	2	105	\N	0	\N	\N	0	1	2	f	105	\N	\N
862	9	189	2	101	\N	0	\N	\N	0	1	2	f	101	\N	\N
863	90	189	2	101	\N	0	\N	\N	0	1	2	f	101	\N	\N
864	107	189	2	60	\N	0	\N	\N	0	1	2	f	60	\N	\N
865	25	189	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
866	47	189	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
867	60	189	2	41	\N	0	\N	\N	0	1	2	f	41	\N	\N
868	40	189	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
869	94	189	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
870	70	189	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
871	106	189	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
872	38	190	2	294	\N	0	\N	\N	1	1	2	f	294	\N	\N
873	67	190	2	294	\N	0	\N	\N	0	1	2	f	294	\N	\N
874	78	191	2	2324	\N	0	\N	\N	1	1	2	f	2324	\N	\N
875	104	192	2	4217988	\N	4217988	\N	\N	1	1	2	f	0	\N	\N
876	105	192	2	4217988	\N	4217988	\N	\N	0	1	2	f	0	\N	\N
877	52	192	1	4217988	\N	4217988	\N	\N	1	1	2	f	\N	\N	\N
878	106	193	2	8	\N	8	\N	\N	1	1	2	f	0	\N	\N
879	51	193	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
880	63	193	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
881	71	194	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
882	65	195	2	844	\N	0	\N	\N	1	1	2	f	844	\N	\N
883	59	195	2	3	\N	0	\N	\N	2	1	2	f	3	\N	\N
884	89	195	2	2	\N	0	\N	\N	3	1	2	f	2	\N	\N
885	34	195	2	844	\N	0	\N	\N	0	1	2	f	844	\N	\N
886	1	195	2	844	\N	0	\N	\N	0	1	2	f	844	\N	\N
887	51	196	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
888	70	197	2	6	\N	0	\N	\N	1	1	2	f	6	\N	\N
889	94	197	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
890	113	197	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
891	40	197	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
892	36	198	2	25249	\N	25249	\N	\N	1	1	2	f	0	\N	\N
893	6	198	1	25249	\N	25249	\N	\N	1	1	2	f	\N	\N	\N
894	58	199	2	90047	\N	90047	\N	\N	1	1	2	f	0	\N	\N
895	103	199	1	90047	\N	90047	\N	\N	1	1	2	f	\N	\N	\N
896	7	200	2	4217988	\N	0	\N	\N	1	1	2	f	4217988	\N	\N
897	29	200	2	4217988	\N	0	\N	\N	0	1	2	f	4217988	\N	\N
898	8	201	2	34	\N	0	\N	\N	1	1	2	f	34	\N	\N
899	113	201	2	28	\N	0	\N	\N	2	1	2	f	28	\N	\N
900	2	201	2	22	\N	0	\N	\N	3	1	2	f	22	\N	\N
901	51	201	2	11	\N	0	\N	\N	4	1	2	f	11	\N	\N
902	80	201	2	2	\N	0	\N	\N	5	1	2	f	2	\N	\N
903	40	201	2	28	\N	0	\N	\N	0	1	2	f	28	\N	\N
904	81	201	2	22	\N	0	\N	\N	0	1	2	f	22	\N	\N
905	94	201	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
906	70	201	2	6	\N	0	\N	\N	0	1	2	f	6	\N	\N
907	63	201	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
908	106	201	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
909	115	201	2	2	\N	0	\N	\N	0	1	2	f	2	\N	\N
910	74	202	2	7974243	\N	7974243	\N	\N	1	1	2	f	0	\N	\N
911	4	202	1	7969243	\N	7969243	\N	\N	1	1	2	f	\N	\N	\N
912	56	202	1	5000	\N	5000	\N	\N	2	1	2	f	\N	\N	\N
913	104	203	2	4217988	\N	0	\N	\N	1	1	2	f	4217988	\N	\N
914	79	203	2	9836	\N	0	\N	\N	2	1	2	f	9836	\N	\N
915	105	203	2	4217988	\N	0	\N	\N	0	1	2	f	4217988	\N	\N
916	20	203	2	9836	\N	0	\N	\N	0	1	2	f	9836	\N	\N
917	27	204	2	162385	\N	162385	\N	\N	1	1	2	f	0	\N	\N
918	34	204	2	5529	\N	5529	\N	\N	2	1	2	f	0	\N	\N
919	111	204	2	452	\N	452	\N	\N	3	1	2	f	0	\N	\N
920	43	204	2	82	\N	82	\N	\N	4	1	2	f	0	\N	\N
921	35	204	2	57	\N	57	\N	\N	5	1	2	f	0	\N	\N
922	121	204	2	54	\N	54	\N	\N	6	1	2	f	0	\N	\N
923	98	204	2	36	\N	36	\N	\N	7	1	2	f	0	\N	\N
924	117	204	2	24	\N	24	\N	\N	8	1	2	f	0	\N	\N
925	74	204	2	162385	\N	162385	\N	\N	0	1	2	f	0	\N	\N
926	20	204	2	5529	\N	5529	\N	\N	0	1	2	f	0	\N	\N
927	103	204	1	167987	\N	167987	\N	\N	1	1	2	f	\N	\N	\N
928	109	204	1	542	\N	542	\N	\N	2	1	2	f	\N	\N	\N
929	12	204	1	50	\N	50	\N	\N	3	1	2	f	\N	\N	\N
930	73	205	2	11128508	\N	0	\N	\N	1	1	2	f	11128508	\N	\N
931	24	205	2	2172	\N	0	\N	\N	2	1	2	f	2172	\N	\N
932	106	206	2	4	\N	0	\N	\N	1	1	2	f	4	\N	\N
933	51	206	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
934	63	206	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
935	6	207	2	25249	\N	0	\N	\N	1	1	2	f	25249	\N	\N
936	42	208	2	2	\N	0	\N	\N	1	1	2	f	2	\N	\N
937	2	209	2	22	\N	22	\N	\N	1	1	2	f	0	\N	\N
938	81	209	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
939	45	210	2	7241	\N	7241	\N	\N	1	1	2	f	0	\N	\N
940	24	210	1	7241	\N	7241	\N	\N	1	1	2	f	\N	\N	\N
941	103	211	2	10	\N	10	\N	\N	1	1	2	f	0	\N	\N
942	38	212	2	294	\N	0	\N	\N	1	1	2	f	294	\N	\N
943	67	212	2	294	\N	0	\N	\N	0	1	2	f	294	\N	\N
944	78	213	2	2324	\N	0	\N	\N	1	1	2	f	2324	\N	\N
945	111	214	2	397	\N	397	\N	\N	1	1	2	f	0	\N	\N
946	76	214	1	1191	\N	1191	\N	\N	1	1	2	f	\N	\N	\N
947	8	215	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
948	113	215	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
949	40	215	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
950	56	216	2	37739	\N	37739	\N	\N	1	1	2	f	0	\N	\N
951	111	216	1	35624	\N	35624	\N	\N	1	1	2	f	\N	\N	\N
952	104	217	2	8435976	\N	0	\N	\N	1	1	2	f	8435976	\N	\N
953	52	217	2	8435976	\N	0	\N	\N	2	1	2	f	8435976	\N	\N
954	95	217	2	8435976	\N	0	\N	\N	3	1	2	f	8435976	\N	\N
955	110	217	2	7738392	\N	0	\N	\N	4	1	2	f	7738392	\N	\N
956	53	217	2	7693906	\N	0	\N	\N	5	1	2	f	7693906	\N	\N
957	20	217	2	39312	\N	0	\N	\N	6	1	2	f	39312	\N	\N
958	78	217	2	4658	\N	0	\N	\N	7	1	2	f	4658	\N	\N
959	54	217	2	1257	\N	0	\N	\N	8	1	2	f	1257	\N	\N
960	8	217	2	100	\N	0	\N	\N	9	1	2	f	100	\N	\N
961	113	217	2	74	\N	0	\N	\N	10	1	2	f	74	\N	\N
962	2	217	2	68	\N	0	\N	\N	11	1	2	f	68	\N	\N
963	63	217	2	52	\N	0	\N	\N	12	1	2	f	52	\N	\N
964	51	217	2	14	\N	0	\N	\N	13	1	2	f	14	\N	\N
965	19	217	2	8	\N	0	\N	\N	14	1	2	f	8	\N	\N
966	68	217	2	6	\N	0	\N	\N	15	1	2	f	6	\N	\N
967	46	217	2	4	\N	0	\N	\N	16	1	2	f	4	\N	\N
968	80	217	2	4	\N	0	\N	\N	17	1	2	f	4	\N	\N
969	105	217	2	8435976	\N	0	\N	\N	0	1	2	f	8435976	\N	\N
970	122	217	2	7693906	\N	0	\N	\N	0	1	2	f	7693906	\N	\N
971	37	217	2	7693906	\N	0	\N	\N	0	1	2	f	7693906	\N	\N
972	34	217	2	11066	\N	0	\N	\N	0	1	2	f	11066	\N	\N
973	40	217	2	74	\N	0	\N	\N	0	1	2	f	74	\N	\N
974	81	217	2	68	\N	0	\N	\N	0	1	2	f	68	\N	\N
975	30	217	2	24	\N	0	\N	\N	0	1	2	f	24	\N	\N
976	9	217	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
977	39	217	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
978	90	217	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
979	3	217	2	20	\N	0	\N	\N	0	1	2	f	20	\N	\N
980	94	217	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
981	70	217	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
982	107	217	2	12	\N	0	\N	\N	0	1	2	f	12	\N	\N
983	25	217	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
984	47	217	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
985	60	217	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
986	106	217	2	8	\N	0	\N	\N	0	1	2	f	8	\N	\N
987	48	217	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
988	115	217	2	4	\N	0	\N	\N	0	1	2	f	4	\N	\N
989	42	218	2	38	\N	38	\N	\N	1	1	2	f	0	\N	\N
990	102	218	1	66	\N	66	\N	\N	1	1	2	f	\N	\N	\N
991	104	219	2	4217988	\N	0	\N	\N	1	1	2	f	4217988	\N	\N
992	79	219	2	9836	\N	0	\N	\N	2	1	2	f	9836	\N	\N
993	105	219	2	4217988	\N	0	\N	\N	0	1	2	f	4217988	\N	\N
994	20	219	2	9836	\N	0	\N	\N	0	1	2	f	9836	\N	\N
995	103	220	2	412	\N	412	\N	\N	1	1	2	f	0	\N	\N
996	94	220	1	412	\N	412	\N	\N	1	1	2	f	\N	\N	\N
997	113	220	1	23	\N	23	\N	\N	0	1	2	f	\N	\N	\N
998	40	220	1	23	\N	23	\N	\N	0	1	2	f	\N	\N	\N
999	70	220	1	23	\N	23	\N	\N	0	1	2	f	\N	\N	\N
1000	11	221	2	8995	\N	8995	\N	\N	1	1	2	f	0	\N	\N
1001	55	221	1	7661	\N	7661	\N	\N	1	1	2	f	\N	\N	\N
1002	33	221	1	1334	\N	1334	\N	\N	2	1	2	f	\N	\N	\N
1003	42	222	2	10	\N	0	\N	\N	1	1	2	f	10	\N	\N
1004	38	223	2	294	\N	0	\N	\N	1	1	2	f	294	\N	\N
1005	67	223	2	294	\N	0	\N	\N	0	1	2	f	294	\N	\N
1006	102	224	2	502	\N	502	\N	\N	1	1	2	f	0	\N	\N
1007	93	224	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1008	102	224	1	354	\N	354	\N	\N	1	1	2	f	\N	\N	\N
1009	42	224	1	211	\N	211	\N	\N	2	1	2	f	\N	\N	\N
1010	93	224	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1011	8	225	2	92	\N	92	\N	\N	1	1	2	f	0	\N	\N
1012	113	225	2	66	\N	66	\N	\N	2	1	2	f	0	\N	\N
1013	40	225	2	66	\N	66	\N	\N	0	1	2	f	0	\N	\N
1014	94	225	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1015	70	225	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1016	111	226	2	898	\N	898	\N	\N	1	1	2	f	0	\N	\N
1017	75	226	2	281	\N	281	\N	\N	2	1	2	f	0	\N	\N
1018	121	226	1	1179	\N	1179	\N	\N	1	1	2	f	\N	\N	\N
1019	74	227	2	14889493	\N	14889493	\N	\N	1	1	2	f	0	\N	\N
1020	56	227	2	37739	\N	37739	\N	\N	2	1	2	f	0	\N	\N
1021	20	227	2	14122	\N	14122	\N	\N	3	1	2	f	0	\N	\N
1022	11	227	2	8995	\N	8995	\N	\N	4	1	2	f	0	\N	\N
1023	45	227	2	4800	\N	4800	\N	\N	5	1	2	f	0	\N	\N
1024	55	227	2	111	\N	111	\N	\N	6	1	2	f	0	\N	\N
1025	121	227	2	36	\N	36	\N	\N	7	1	2	f	0	\N	\N
1026	33	227	2	14	\N	14	\N	\N	8	1	2	f	0	\N	\N
1027	27	227	2	162391	\N	162391	\N	\N	0	1	2	f	0	\N	\N
1028	118	227	1	82780914	\N	82780914	\N	\N	1	1	2	f	\N	\N	\N
1029	66	227	1	95187	\N	95187	\N	\N	2	1	2	f	\N	\N	\N
1030	78	228	2	2330	\N	0	\N	\N	1	1	2	f	2330	\N	\N
1031	17	229	2	259	\N	259	\N	\N	1	1	2	f	0	\N	\N
1032	62	229	2	54	\N	54	\N	\N	2	1	2	f	0	\N	\N
1033	92	229	2	20	\N	20	\N	\N	3	1	2	f	0	\N	\N
1034	57	229	2	11	\N	11	\N	\N	0	1	2	f	0	\N	\N
1035	15	229	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1036	16	229	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1037	108	229	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1038	50	229	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1039	61	229	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1040	102	229	1	432	\N	432	\N	\N	1	1	2	f	\N	\N	\N
1041	84	229	1	4	\N	4	\N	\N	2	1	2	f	\N	\N	\N
1042	93	229	1	8	\N	8	\N	\N	0	1	2	f	\N	\N	\N
1043	51	230	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1044	17	231	2	46	\N	46	\N	\N	1	1	2	f	0	\N	\N
1045	62	231	2	11	\N	11	\N	\N	2	1	2	f	0	\N	\N
1046	15	231	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1047	17	231	1	34	\N	34	\N	\N	1	1	2	f	\N	\N	\N
1048	61	231	1	5	\N	5	\N	\N	2	1	2	f	\N	\N	\N
1049	62	231	1	4	\N	4	\N	\N	3	1	2	f	\N	\N	\N
1050	23	232	2	26530	\N	26530	\N	\N	1	1	2	f	0	\N	\N
1051	103	232	1	26530	\N	26530	\N	\N	1	1	2	f	\N	\N	\N
1052	106	233	2	4	\N	4	\N	\N	1	1	2	f	0	\N	\N
1053	51	233	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1054	63	233	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1055	78	234	2	2322	\N	0	\N	\N	1	1	2	f	2322	\N	\N
1056	34	235	2	922	\N	922	\N	\N	1	1	2	f	0	\N	\N
1057	2	236	2	17	\N	0	\N	\N	1	1	2	f	17	\N	\N
1058	81	236	2	17	\N	0	\N	\N	0	1	2	f	17	\N	\N
1059	36	237	2	25249	\N	25249	\N	\N	1	1	2	f	0	\N	\N
1060	8	237	2	34	\N	34	\N	\N	2	1	2	f	0	\N	\N
1061	113	237	2	28	\N	28	\N	\N	3	1	2	f	0	\N	\N
1062	106	237	2	4	\N	4	\N	\N	4	1	2	f	0	\N	\N
1063	80	237	2	2	\N	2	\N	\N	5	1	2	f	0	\N	\N
1064	40	237	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
1065	94	237	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1066	70	237	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1067	51	237	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1068	63	237	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1069	115	237	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1070	39	237	1	260	\N	260	\N	\N	1	1	2	f	\N	\N	\N
1071	63	237	1	260	\N	260	\N	\N	0	1	2	f	\N	\N	\N
1072	9	237	1	260	\N	260	\N	\N	0	1	2	f	\N	\N	\N
1073	90	237	1	260	\N	260	\N	\N	0	1	2	f	\N	\N	\N
1074	3	237	1	260	\N	260	\N	\N	0	1	2	f	\N	\N	\N
1075	107	237	1	156	\N	156	\N	\N	0	1	2	f	\N	\N	\N
1076	25	237	1	104	\N	104	\N	\N	0	1	2	f	\N	\N	\N
1077	47	237	1	104	\N	104	\N	\N	0	1	2	f	\N	\N	\N
1078	60	237	1	104	\N	104	\N	\N	0	1	2	f	\N	\N	\N
1079	111	238	2	397	\N	397	\N	\N	1	1	2	f	0	\N	\N
1080	35	238	1	397	\N	397	\N	\N	1	1	2	f	\N	\N	\N
1081	75	239	2	95	\N	95	\N	\N	1	1	2	f	0	\N	\N
1082	103	239	1	95	\N	95	\N	\N	1	1	2	f	\N	\N	\N
1083	36	240	2	25249	\N	25249	\N	\N	1	1	2	f	0	\N	\N
1084	11	240	1	25248	\N	25248	\N	\N	1	1	2	f	\N	\N	\N
1085	51	241	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1086	73	242	2	11128512	\N	11128512	\N	\N	1	1	2	f	0	\N	\N
1087	24	242	2	2172	\N	2172	\N	\N	2	1	2	f	0	\N	\N
1088	117	242	2	24	\N	24	\N	\N	3	1	2	f	0	\N	\N
1089	32	242	1	5441743	\N	5441743	\N	\N	1	1	2	f	\N	\N	\N
1090	78	243	2	887	\N	887	\N	\N	1	1	2	f	0	\N	\N
1091	60	243	2	1	\N	1	\N	\N	2	1	2	f	0	\N	\N
1092	17	243	2	1	\N	0	\N	\N	3	1	2	f	1	\N	\N
1093	9	243	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1094	39	243	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1095	25	243	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1096	47	243	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1097	90	243	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1098	3	243	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1099	106	244	2	27	\N	27	\N	\N	1	1	2	f	0	\N	\N
1100	51	244	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
1101	63	244	2	27	\N	27	\N	\N	0	1	2	f	0	\N	\N
1102	102	244	1	46	\N	46	\N	\N	1	1	2	f	\N	\N	\N
1103	74	245	2	15051884	\N	15051884	\N	\N	1	1	2	f	0	\N	\N
1104	53	245	2	11540859	\N	11540859	\N	\N	2	1	2	f	0	\N	\N
1105	73	245	2	11128512	\N	11128512	\N	\N	3	1	2	f	0	\N	\N
1106	104	245	2	8435976	\N	8435976	\N	\N	4	1	2	f	0	\N	\N
1107	7	245	2	8435976	\N	8435976	\N	\N	5	1	2	f	0	\N	\N
1108	119	245	2	5104388	\N	5104388	\N	\N	6	1	2	f	0	\N	\N
1109	52	245	2	4217988	\N	4217988	\N	\N	7	1	2	f	0	\N	\N
1110	95	245	2	4217988	\N	4217988	\N	\N	8	1	2	f	0	\N	\N
1111	110	245	2	3878396	\N	3878396	\N	\N	9	1	2	f	0	\N	\N
1112	69	245	2	111951	\N	111951	\N	\N	10	1	2	f	0	\N	\N
1113	58	245	2	90047	\N	90047	\N	\N	11	1	2	f	0	\N	\N
1114	44	245	2	79090	\N	79090	\N	\N	12	1	2	f	0	\N	\N
1115	20	245	2	49156	\N	49156	\N	\N	13	1	2	f	0	\N	\N
1116	67	245	2	48272	\N	48272	\N	\N	14	1	2	f	0	\N	\N
1117	85	245	2	37745	\N	37745	\N	\N	15	1	2	f	0	\N	\N
1118	56	245	2	37739	\N	37739	\N	\N	16	1	2	f	0	\N	\N
1119	64	245	2	31299	\N	31299	\N	\N	17	1	2	f	0	\N	\N
1120	23	245	2	26530	\N	26530	\N	\N	18	1	2	f	0	\N	\N
1121	6	245	2	25249	\N	25249	\N	\N	19	1	2	f	0	\N	\N
1122	36	245	2	25249	\N	25249	\N	\N	20	1	2	f	0	\N	\N
1123	34	245	2	21320	\N	21320	\N	\N	21	1	2	f	0	\N	\N
1124	75	245	2	14217	\N	14217	\N	\N	22	1	2	f	0	\N	\N
1125	4	245	2	14122	\N	14122	\N	\N	23	1	2	f	0	\N	\N
1126	41	245	2	14122	\N	14122	\N	\N	24	1	2	f	0	\N	\N
1127	99	245	2	12873	\N	12873	\N	\N	25	1	2	f	0	\N	\N
1128	87	245	2	9893	\N	9893	\N	\N	26	1	2	f	0	\N	\N
1129	11	245	2	8995	\N	8995	\N	\N	27	1	2	f	0	\N	\N
1130	54	245	2	7438	\N	7438	\N	\N	28	1	2	f	0	\N	\N
1131	28	245	2	6213	\N	6213	\N	\N	29	1	2	f	0	\N	\N
1132	77	245	2	5757	\N	5757	\N	\N	30	1	2	f	0	\N	\N
1133	112	245	2	5532	\N	5532	\N	\N	31	1	2	f	0	\N	\N
1134	45	245	2	4800	\N	4800	\N	\N	32	1	2	f	0	\N	\N
1135	13	245	2	4639	\N	4639	\N	\N	33	1	2	f	0	\N	\N
1136	120	245	2	3242	\N	3242	\N	\N	34	1	2	f	0	\N	\N
1137	26	245	2	3185	\N	3185	\N	\N	35	1	2	f	0	\N	\N
1138	66	245	2	2472	\N	2472	\N	\N	36	1	2	f	0	\N	\N
1139	78	245	2	2330	\N	2330	\N	\N	37	1	2	f	0	\N	\N
1140	24	245	2	2172	\N	2172	\N	\N	38	1	2	f	0	\N	\N
1141	63	245	2	1002	\N	1002	\N	\N	39	1	2	f	0	\N	\N
1142	121	245	2	1000	\N	1000	\N	\N	40	1	2	f	0	\N	\N
1143	90	245	2	947	\N	947	\N	\N	41	1	2	f	0	\N	\N
1144	9	245	2	761	\N	761	\N	\N	42	1	2	f	0	\N	\N
1145	98	245	2	454	\N	454	\N	\N	43	1	2	f	0	\N	\N
1146	103	245	2	450	\N	450	\N	\N	44	1	2	f	0	\N	\N
1147	118	245	2	435	\N	435	\N	\N	45	1	2	f	0	\N	\N
1148	102	245	2	432	\N	432	\N	\N	46	1	2	f	0	\N	\N
1149	111	245	2	418	\N	418	\N	\N	47	1	2	f	0	\N	\N
1150	17	245	2	366	\N	366	\N	\N	48	1	2	f	0	\N	\N
1151	86	245	2	361	\N	361	\N	\N	49	1	2	f	0	\N	\N
1152	76	245	2	228	\N	228	\N	\N	50	1	2	f	0	\N	\N
1153	42	245	2	213	\N	213	\N	\N	51	1	2	f	0	\N	\N
1154	32	245	2	155	\N	155	\N	\N	52	1	2	f	0	\N	\N
1155	8	245	2	124	\N	124	\N	\N	53	1	2	f	0	\N	\N
1156	55	245	2	111	\N	111	\N	\N	54	1	2	f	0	\N	\N
1157	113	245	2	102	\N	102	\N	\N	55	1	2	f	0	\N	\N
1158	61	245	2	87	\N	87	\N	\N	56	1	2	f	0	\N	\N
1159	21	245	2	81	\N	81	\N	\N	57	1	2	f	0	\N	\N
1160	35	245	2	69	\N	69	\N	\N	58	1	2	f	0	\N	\N
1161	2	245	2	68	\N	68	\N	\N	59	1	2	f	0	\N	\N
1162	62	245	2	67	\N	67	\N	\N	60	1	2	f	0	\N	\N
1163	43	245	2	43	\N	43	\N	\N	61	1	2	f	0	\N	\N
1164	117	245	2	42	\N	42	\N	\N	62	1	2	f	0	\N	\N
1165	94	245	2	38	\N	38	\N	\N	63	1	2	f	0	\N	\N
1166	12	245	2	38	\N	38	\N	\N	64	1	2	f	0	\N	\N
1167	92	245	2	28	\N	28	\N	\N	65	1	2	f	0	\N	\N
1168	51	245	2	22	\N	22	\N	\N	66	1	2	f	0	\N	\N
1169	97	245	2	20	\N	20	\N	\N	67	1	2	f	0	\N	\N
1170	31	245	2	18	\N	18	\N	\N	68	1	2	f	0	\N	\N
1171	33	245	2	14	\N	14	\N	\N	69	1	2	f	0	\N	\N
1172	109	245	2	13	\N	13	\N	\N	70	1	2	f	0	\N	\N
1173	46	245	2	8	\N	8	\N	\N	71	1	2	f	0	\N	\N
1174	91	245	2	8	\N	8	\N	\N	72	1	2	f	0	\N	\N
1175	84	245	2	8	\N	8	\N	\N	73	1	2	f	0	\N	\N
1176	19	245	2	8	\N	8	\N	\N	74	1	2	f	0	\N	\N
1177	10	245	2	7	\N	7	\N	\N	75	1	2	f	0	\N	\N
1178	88	245	2	6	\N	6	\N	\N	76	1	2	f	0	\N	\N
1179	14	245	2	4	\N	4	\N	\N	77	1	2	f	0	\N	\N
1180	80	245	2	4	\N	4	\N	\N	78	1	2	f	0	\N	\N
1181	22	245	2	4	\N	4	\N	\N	79	1	2	f	0	\N	\N
1182	18	245	2	4	\N	4	\N	\N	80	1	2	f	0	\N	\N
1183	59	245	2	3	\N	3	\N	\N	81	1	2	f	0	\N	\N
1184	68	245	2	3	\N	3	\N	\N	82	1	2	f	0	\N	\N
1185	101	245	2	2	\N	2	\N	\N	83	1	2	f	0	\N	\N
1186	49	245	2	2	\N	2	\N	\N	84	1	2	f	0	\N	\N
1187	71	245	2	1	\N	1	\N	\N	85	1	2	f	0	\N	\N
1188	96	245	2	1	\N	1	\N	\N	86	1	2	f	0	\N	\N
1189	116	245	2	1	\N	1	\N	\N	87	1	2	f	0	\N	\N
1190	89	245	2	1	\N	1	\N	\N	88	1	2	f	0	\N	\N
1191	122	245	2	11540859	\N	11540859	\N	\N	0	1	2	f	0	\N	\N
1192	37	245	2	11540859	\N	11540859	\N	\N	0	1	2	f	0	\N	\N
1193	105	245	2	8435976	\N	8435976	\N	\N	0	1	2	f	0	\N	\N
1194	29	245	2	8435976	\N	8435976	\N	\N	0	1	2	f	0	\N	\N
1195	27	245	2	324782	\N	324782	\N	\N	0	1	2	f	0	\N	\N
1196	79	245	2	19672	\N	19672	\N	\N	0	1	2	f	0	\N	\N
1197	65	245	2	2490	\N	2490	\N	\N	0	1	2	f	0	\N	\N
1198	1	245	2	2490	\N	2490	\N	\N	0	1	2	f	0	\N	\N
1199	39	245	2	699	\N	699	\N	\N	0	1	2	f	0	\N	\N
1200	3	245	2	699	\N	699	\N	\N	0	1	2	f	0	\N	\N
1201	38	245	2	588	\N	588	\N	\N	0	1	2	f	0	\N	\N
1202	25	245	2	539	\N	539	\N	\N	0	1	2	f	0	\N	\N
1203	47	245	2	539	\N	539	\N	\N	0	1	2	f	0	\N	\N
1204	107	245	2	408	\N	408	\N	\N	0	1	2	f	0	\N	\N
1205	60	245	2	279	\N	279	\N	\N	0	1	2	f	0	\N	\N
1206	40	245	2	102	\N	102	\N	\N	0	1	2	f	0	\N	\N
1207	81	245	2	68	\N	68	\N	\N	0	1	2	f	0	\N	\N
1208	114	245	2	42	\N	42	\N	\N	0	1	2	f	0	\N	\N
1209	70	245	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1210	30	245	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1211	57	245	2	24	\N	24	\N	\N	0	1	2	f	0	\N	\N
1212	15	245	2	22	\N	22	\N	\N	0	1	2	f	0	\N	\N
1213	72	245	2	16	\N	16	\N	\N	0	1	2	f	0	\N	\N
1214	93	245	2	15	\N	15	\N	\N	0	1	2	f	0	\N	\N
1215	106	245	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1216	5	245	2	10	\N	10	\N	\N	0	1	2	f	0	\N	\N
1217	16	245	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1218	48	245	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1219	108	245	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1220	83	245	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1221	115	245	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1222	50	245	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1223	100	245	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1224	82	245	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1225	102	245	1	68612137	\N	68612137	\N	\N	1	1	2	f	\N	\N	\N
1226	93	245	1	970	\N	970	\N	\N	0	1	2	f	\N	\N	\N
1227	103	247	2	12	\N	12	\N	\N	1	1	2	f	0	\N	\N
1228	46	247	2	8	\N	8	\N	\N	2	1	2	f	0	\N	\N
1229	48	247	2	8	\N	8	\N	\N	0	1	2	f	0	\N	\N
1230	103	247	1	8	\N	8	\N	\N	1	1	2	f	\N	\N	\N
1231	51	250	2	19	\N	19	\N	\N	1	1	2	f	0	\N	\N
1232	63	250	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1233	106	250	2	3	\N	3	\N	\N	0	1	2	f	0	\N	\N
1234	51	250	1	6	\N	6	\N	\N	1	1	2	f	\N	\N	\N
1235	63	250	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1236	106	250	1	4	\N	4	\N	\N	0	1	2	f	\N	\N	\N
1237	111	252	2	287	\N	287	\N	\N	1	1	2	f	0	\N	\N
1238	114	258	2	21	\N	0	\N	\N	1	1	2	f	21	\N	\N
1239	66	258	2	21	\N	0	\N	\N	0	1	2	f	21	\N	\N
1240	103	260	2	79	\N	0	\N	\N	1	1	2	f	79	\N	\N
1241	38	261	2	294	\N	294	\N	\N	1	1	2	f	0	\N	\N
1242	67	261	2	294	\N	294	\N	\N	0	1	2	f	0	\N	\N
1243	78	262	2	2322	\N	0	\N	\N	1	1	2	f	2322	\N	\N
1244	106	263	2	7	\N	0	\N	\N	1	1	2	f	7	\N	\N
1245	51	263	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1246	63	263	2	7	\N	0	\N	\N	0	1	2	f	7	\N	\N
1247	111	266	2	418	\N	418	\N	\N	1	1	2	f	0	\N	\N
1248	75	266	2	36	\N	36	\N	\N	2	1	2	f	0	\N	\N
1249	98	266	1	454	\N	454	\N	\N	1	1	2	f	\N	\N	\N
1250	66	270	2	2430	\N	0	\N	\N	1	1	2	f	2430	\N	\N
1251	86	270	2	361	\N	0	\N	\N	2	1	2	f	361	\N	\N
1252	51	271	2	1	\N	0	\N	\N	1	1	2	f	1	\N	\N
1253	2	272	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
1254	8	272	2	25	\N	25	\N	\N	2	1	2	f	0	\N	\N
1255	30	272	2	12	\N	12	\N	\N	3	1	2	f	0	\N	\N
1256	80	272	2	2	\N	2	\N	\N	4	1	2	f	0	\N	\N
1257	81	272	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1258	113	272	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1259	40	272	2	17	\N	17	\N	\N	0	1	2	f	0	\N	\N
1260	63	272	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1261	115	272	2	2	\N	2	\N	\N	0	1	2	f	0	\N	\N
1262	46	272	1	22	\N	22	\N	\N	1	1	2	f	\N	\N	\N
1263	48	272	1	22	\N	22	\N	\N	0	1	2	f	\N	\N	\N
1264	80	273	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
1265	115	273	2	1	\N	1	\N	\N	0	1	2	f	0	\N	\N
1266	8	274	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
1267	113	274	2	28	\N	28	\N	\N	2	1	2	f	0	\N	\N
1268	106	274	2	4	\N	4	\N	\N	3	1	2	f	0	\N	\N
1269	40	274	2	28	\N	28	\N	\N	0	1	2	f	0	\N	\N
1270	94	274	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1271	70	274	2	6	\N	6	\N	\N	0	1	2	f	0	\N	\N
1272	51	274	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1273	63	274	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1274	72	274	1	24	\N	24	\N	\N	1	1	2	f	\N	\N	\N
1275	103	274	1	24	\N	24	\N	\N	0	1	2	f	\N	\N	\N
1276	79	275	2	9836	\N	0	\N	\N	1	1	2	f	9836	\N	\N
1277	20	275	2	9836	\N	0	\N	\N	0	1	2	f	9836	\N	\N
1278	104	277	2	4217988	\N	0	\N	\N	1	1	2	f	4217988	\N	\N
1279	20	277	2	29487	\N	0	\N	\N	2	1	2	f	29487	\N	\N
1280	23	277	2	25509	\N	0	\N	\N	3	1	2	f	25509	\N	\N
1281	75	277	2	14217	\N	0	\N	\N	4	1	2	f	14217	\N	\N
1282	67	277	2	9931	\N	0	\N	\N	5	1	2	f	9931	\N	\N
1283	11	277	2	8996	\N	0	\N	\N	6	1	2	f	8996	\N	\N
1284	105	277	2	4217988	\N	0	\N	\N	0	1	2	f	4217988	\N	\N
1285	79	277	2	9836	\N	0	\N	\N	0	1	2	f	9836	\N	\N
1286	34	277	2	5529	\N	0	\N	\N	0	1	2	f	5529	\N	\N
1287	23	278	2	28753	\N	0	\N	\N	1	1	2	f	28753	\N	\N
1288	13	282	2	4764	\N	4764	\N	\N	1	1	2	f	0	\N	\N
1289	65	282	1	4764	\N	4764	\N	\N	1	1	2	f	\N	\N	\N
1290	34	282	1	4764	\N	4764	\N	\N	0	1	2	f	\N	\N	\N
1291	1	282	1	4764	\N	4764	\N	\N	0	1	2	f	\N	\N	\N
1292	42	283	2	213	\N	213	\N	\N	1	1	2	f	0	\N	\N
1293	17	283	1	235	\N	235	\N	\N	1	1	2	f	\N	\N	\N
1294	62	283	1	21	\N	21	\N	\N	2	1	2	f	\N	\N	\N
1295	15	283	1	19	\N	19	\N	\N	0	1	2	f	\N	\N	\N
1296	57	283	1	7	\N	7	\N	\N	0	1	2	f	\N	\N	\N
1297	108	283	1	5	\N	5	\N	\N	0	1	2	f	\N	\N	\N
1298	50	283	1	2	\N	2	\N	\N	0	1	2	f	\N	\N	\N
1299	28	284	2	6213	\N	0	\N	\N	1	1	2	f	6213	\N	\N
1300	103	284	2	25	\N	0	\N	\N	2	1	2	f	25	\N	\N
1301	39	284	2	21	\N	21	\N	\N	3	1	2	f	0	\N	\N
1302	46	284	2	4	\N	4	\N	\N	4	1	2	f	0	\N	\N
1303	9	284	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
1304	90	284	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
1305	3	284	2	21	\N	21	\N	\N	0	1	2	f	0	\N	\N
1306	63	284	2	20	\N	20	\N	\N	0	1	2	f	0	\N	\N
1307	107	284	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1308	25	284	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1309	47	284	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1310	60	284	2	9	\N	9	\N	\N	0	1	2	f	0	\N	\N
1311	48	284	2	4	\N	4	\N	\N	0	1	2	f	0	\N	\N
1312	103	284	1	4	\N	4	\N	\N	1	1	2	f	\N	\N	\N
1313	75	285	2	95	\N	95	\N	\N	1	1	2	f	0	\N	\N
1314	43	285	1	95	\N	95	\N	\N	1	1	2	f	\N	\N	\N
1315	52	286	2	4217988	\N	4217988	\N	\N	1	1	2	f	0	\N	\N
1316	53	286	1	4217988	\N	4217988	\N	\N	1	1	2	f	\N	\N	\N
1317	37	286	1	4217988	\N	4217988	\N	\N	0	1	2	f	\N	\N	\N
1318	122	286	1	4217988	\N	4217988	\N	\N	0	1	2	f	\N	\N	\N
1319	42	288	2	77	\N	77	\N	\N	1	1	2	f	0	\N	\N
1320	102	288	1	106	\N	106	\N	\N	1	1	2	f	\N	\N	\N
1321	56	289	2	8037	\N	8037	\N	\N	1	1	2	f	0	\N	\N
1322	78	289	2	2990	\N	2990	\N	\N	2	1	2	f	0	\N	\N
1323	43	289	2	40	\N	40	\N	\N	3	1	2	f	0	\N	\N
1324	78	290	2	2314	\N	0	\N	\N	1	1	2	f	2314	\N	\N
1325	74	291	2	14889493	\N	14889493	\N	\N	1	1	2	f	0	\N	\N
1326	104	291	2	4217988	\N	4217988	\N	\N	2	1	2	f	0	\N	\N
1327	36	291	2	25249	\N	25249	\N	\N	3	1	2	f	0	\N	\N
1328	75	291	2	14217	\N	14217	\N	\N	4	1	2	f	0	\N	\N
1329	4	291	2	14122	\N	14122	\N	\N	5	1	2	f	0	\N	\N
1330	11	291	2	8995	\N	8995	\N	\N	6	1	2	f	0	\N	\N
1331	55	291	2	111	\N	111	\N	\N	7	1	2	f	0	\N	\N
1332	97	291	2	20	\N	20	\N	\N	8	1	2	f	0	\N	\N
1333	33	291	2	14	\N	14	\N	\N	9	1	2	f	0	\N	\N
1334	105	291	2	4217988	\N	4217988	\N	\N	0	1	2	f	0	\N	\N
1335	27	291	2	162391	\N	162391	\N	\N	0	1	2	f	0	\N	\N
1336	119	291	1	14889493	\N	14889493	\N	\N	1	1	2	f	\N	\N	\N
1337	87	291	1	4217988	\N	4217988	\N	\N	2	1	2	f	\N	\N	\N
1338	8	291	1	52669	\N	52669	\N	\N	3	1	2	f	\N	\N	\N
1339	120	291	1	14217	\N	14217	\N	\N	4	1	2	f	\N	\N	\N
1340	26	291	1	14122	\N	14122	\N	\N	5	1	2	f	\N	\N	\N
1341	113	291	1	43529	\N	43529	\N	\N	0	1	2	f	\N	\N	\N
1342	40	291	1	43529	\N	43529	\N	\N	0	1	2	f	\N	\N	\N
1343	113	292	2	34	\N	34	\N	\N	1	1	2	f	0	\N	\N
1344	40	292	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1345	8	292	2	34	\N	34	\N	\N	0	1	2	f	0	\N	\N
1346	94	292	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1347	70	292	2	12	\N	12	\N	\N	0	1	2	f	0	\N	\N
1348	2	292	1	34	\N	34	\N	\N	1	1	2	f	\N	\N	\N
1349	81	292	1	34	\N	34	\N	\N	0	1	2	f	\N	\N	\N
1350	104	293	2	4217988	\N	0	\N	\N	1	1	2	f	4217988	\N	\N
1351	105	293	2	4217988	\N	0	\N	\N	0	1	2	f	4217988	\N	\N
1352	85	294	2	37745	\N	37745	\N	\N	1	1	2	f	0	\N	\N
1353	52	295	2	4217988	\N	0	\N	\N	1	1	2	f	4217988	\N	\N
1354	44	296	2	79087	\N	0	\N	\N	1	1	2	f	79087	\N	\N
1355	71	297	2	1	\N	1	\N	\N	1	1	2	f	0	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.datatypes (id, iri, ns_id, local_name) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
69		https://w3id.org/italia/env/onto/top/	0	t	0
70	pc	http://purl.org/procurement/public-contracts#	0	f	0
71	adms	http://www.w3.org/ns/adms#	0	f	0
72	time	http://www.w3.org/2006/time#	0	f	0
73	vs	http://www.w3.org/2003/06/sw-vocab-status/ns#	0	f	0
74	n_1	https://w3id.org/whow/onto/water-monitoring/	0	f	0
75	dcatapit	http://dati.gov.it/onto/dcatapit#	0	f	0
76	n_2	https://w3id.org/italia/env/onto/inspire-mf/	0	f	0
77	n_3	https://w3id.org/whow/onto/weather-monitoring/	0	f	0
78	dwc	http://rs.tdwg.org/dwc/terms/	0	f	0
79	n_4	https://w3id.org/italia/env/onto/place/	0	f	0
80	n_5	https://w3id.org/italia/env/onto/core#	0	f	0
81	n_6	https://w3id.org/whow/onto/water-indicator/	0	f	0
82	sem	http://semanticweb.cs.vu.nl/2009/11/sem/	0	f	0
83	n_7	https://w3id.org/italia/onto/ADMS/	0	f	0
84	n_8	https://w3id.org/italia/onto/CLV/	0	f	0
85	n_9	https://w3id.org/whow/onto/hydrography/	0	f	0
86	n_10	https://www.w3.org/2002/07/owl#	0	f	0
87	dsw	http://purl.org/dsw/	0	f	0
88	n_11	http://www.w3.orgS/ns/org#	0	f	0
89	n_12	https://	0	f	0
90	n_13		0	f	0
91	n_14	https://www.w3.org/ns/prov#	0	f	0
92	dwciri	http://rs.tdwg.org/dwc/iri/	0	f	0
93	n_15	https://w3id.org/italia/onto/l0/	0	f	0
94	n_16	https://w3id.org/italia/onto/NDC/	0	f	0
95	n_17	http://qudt.org/vocab/unit#	0	f	0
96	xkos	http://rdf-vocabulary.ddialliance.org/xkos#	0	f	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	http_dati_isprambiente_it_sparql	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	http_dati_isprambiente_it_sparql	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://dati.isprambiente.it/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"endpointUrl": "http://dati.isprambiente.it/sparql", "correlationId": "7088110439949778474", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "none", "excludedNamespaces": ["http://www.openlinksw.com/schemas/virtrdf#"], "includedProperties": [], "addIntersectionClasses": "no", "exactCountCalculations": "no", "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "none", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": false, "maxInstanceLimitForExactCount": 10000000, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "sampleLimitForDataTypeCalculation": 100000, "calculatePropertyPropertyRelations": false, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": []}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-07-11T12:29:20.336Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-05-23	\N	\N	30
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	https://property4	1	\N	89	property4	property4	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
2	http://purl.org/dc/elements/1.1/language	20	\N	6	language	language	f	19	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
3	http://www.w3.org/ns/dcat#downloadURL	38	\N	15	downloadURL	downloadURL	f	38	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
4	https://property5	1	\N	89	property5	property5	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
5	http://xmlns.com/foaf/0.1/name	28	\N	8	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
6	https://property6	1	\N	89	property6	property6	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
7	https://property7	1	\N	89	property7	property7	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
8	https://w3id.org/italia/onto/ADMS/type	4	\N	83	type	type	f	4	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
9	http://www.w3.org/2006/time#hasEnd	4	\N	72	hasEnd	hasEnd	f	0	\N	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
10	https://property8	1	\N	89	property8	property8	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
11	http://www.w3.org/2004/02/skos/core#note	5381	\N	4	note	note	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
12	https://property9	1	\N	89	property9	property9	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
13	http://rs.tdwg.org/dwc/terms/infraspecificEpithet	228	\N	78	infraspecificEpithet	infraspecificEpithet	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
14	https://w3id.org/italia/env/onto/core#isDistrictAuthority	25249	\N	80	isDistrictAuthority	isDistrictAuthority	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
15	http://purl.org/dc/terms/spatial	45	\N	5	spatial	spatial	f	45	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
16	https://property30	1	\N	89	property30	property30	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
17	http://www.w3.org/2006/vcard/ns#fn	30	\N	39	fn	fn	f	0	\N	\N	f	f	90	\N	\N	t	f	\N	\N	\N	t	f	f
18	https://w3id.org/italia/onto/ADMS/officialURI	4	\N	83	officialURI	officialURI	f	0	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
19	https://w3id.org/italia/env/onto/inspire-mf/generationTime	4800	\N	76	generationTime	generationTime	f	4800	\N	\N	f	f	45	86	\N	t	f	\N	\N	\N	t	f	f
20	https://w3id.org/italia/env/onto/inspire-mf/isSamplingMadeBySampler	14122	\N	76	isSamplingMadeBySampler	isSamplingMadeBySampler	f	14122	\N	\N	f	f	4	41	\N	t	f	\N	\N	\N	t	f	f
21	http://www.w3.org/2002/07/owl#equivalentClass	42	\N	7	equivalentClass	equivalentClass	f	42	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
22	http://www.w3.org/ns/dcat#dataset	14	\N	15	dataset	dataset	f	14	\N	\N	f	f	80	8	\N	t	f	\N	\N	\N	t	f	f
23	https://property1	1	\N	89	property1	property1	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
24	https://property2	1	\N	89	property2	property2	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
25	http://purl.org/dc/elements/1.1/date	114773	\N	6	date	date	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
26	https://property3	1	\N	89	property3	property3	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
27	https://w3id.org/italia/env/onto/core#instabilityType	5532	\N	80	instabilityType	instabilityType	f	5532	\N	\N	f	f	112	103	\N	t	f	\N	\N	\N	t	f	f
28	https://w3id.org/italia/env/onto/core#repairCategory	4524	\N	80	repairCategory	repairCategory	f	4524	\N	\N	f	f	99	103	\N	t	f	\N	\N	\N	t	f	f
29	http://www.w3.org/ns/dcat#keyword	216	\N	15	keyword	keyword	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
30	12	1	\N	90	12	12	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
31	https://w3id.org/whow/onto/water-monitoring/isSampleOf	4639	\N	74	isSampleOf	isSampleOf	f	4639	\N	\N	f	f	13	59	\N	t	f	\N	\N	\N	t	f	f
32	http://purl.org/dc/elements/1.1/description	25261	\N	6	description	description	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
33	https://w3id.org/italia/onto/ADMS/semanticAssetInUse	8	\N	83	semanticAssetInUse	semanticAssetInUse	f	8	\N	\N	f	f	106	83	\N	t	f	\N	\N	\N	t	f	f
34	http://www.w3.org/2002/07/owl#minQualifiedCardinality	2	\N	7	minQualifiedCardinality	minQualifiedCardinality	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
35	http://purl.org/dc/terms/relation	26530	\N	5	relation	relation	f	26530	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
36	https://w3id.org/italia/env/onto/core#lot	90047	\N	80	lot	lot	f	90047	\N	\N	f	f	58	\N	\N	t	f	\N	\N	\N	t	f	f
37	https://w3id.org/italia/env/onto/place/hasNearbyLocation	91	\N	79	hasNearbyLocation	hasNearbyLocation	f	91	\N	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
38	http://www.w3.org/2002/07/owl#priorVersion	1	\N	7	priorVersion	priorVersion	f	1	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
39	https://www.w3.org/ns/prov#wasDerivedFrom	2639	\N	91	wasDerivedFrom	wasDerivedFrom	f	2639	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
40	https://w3id.org/italia/env/onto/place/hasMunicipality	852	\N	79	hasMunicipality	hasMunicipality	f	852	\N	\N	f	f	65	11	\N	t	f	\N	\N	\N	t	f	f
41	https://w3id.org/italia/env/onto/core#amountFinanced	25249	\N	80	amountFinanced	amountFinanced	f	0	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
42	2	1	\N	90	2	2	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
43	http://purl.org/dc/terms/creator	36	\N	5	creator	creator	f	36	\N	\N	f	f	\N	39	\N	t	f	\N	\N	\N	t	f	f
44	https://w3id.org/italia/onto/CLV/hasRankOrder	9141	\N	84	hasRankOrder	hasRankOrder	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
45	http://purl.org/dc/terms/type	111959	\N	5	type	type	f	111959	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
46	https://w3id.org/italia/env/onto/core#lithologyRelatedTo	5757	\N	80	lithologyRelatedTo	lithologyRelatedTo	f	5757	\N	\N	f	f	77	\N	\N	t	f	\N	\N	\N	t	f	f
47	https://w3id.org/italia/env/onto/place/geometry	47780	\N	79	geometry	geometry	f	0	\N	\N	f	f	67	\N	\N	t	f	\N	\N	\N	t	f	f
48	http://xmlns.com/foaf/0.1/homepage	5	\N	8	homepage	homepage	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
49	https://w3id.org/italia/env/onto/top/hasSchemaAttribute	42	\N	69	hasSchemaAttribute	hasSchemaAttribute	f	42	\N	\N	f	f	31	117	\N	t	f	\N	\N	\N	t	f	f
50	http://www.w3.org/ns/dcat#themeTaxonomy	3	\N	15	themeTaxonomy	themeTaxonomy	f	3	\N	\N	f	f	80	94	\N	t	f	\N	\N	\N	t	f	f
51	https://w3id.org/italia/onto/ADMS/hasOntologyLanguage	4	\N	83	hasOntologyLanguage	hasOntologyLanguage	f	4	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
52	https://w3id.org/italia/onto/ADMS/target	12	\N	83	target	target	f	0	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
53	https://w3id.org/italia/env/onto/inspire-mf/isPlatformOf	95	\N	76	isPlatformOf	isPlatformOf	f	95	\N	\N	f	f	75	68	\N	t	f	\N	\N	\N	t	f	f
54	http://rs.tdwg.org/dwc/terms/vernacularName	4584	\N	78	vernacularName	vernacularName	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
55	https://w3id.org/italia/env/onto/core#contractingAuthority	79108	\N	80	contractingAuthority	contractingAuthority	f	79108	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
56	https://w3id.org/italia/env/onto/place/hasGeometry	48556	\N	79	hasGeometry	hasGeometry	f	48556	\N	\N	f	f	\N	67	\N	t	f	\N	\N	\N	t	f	f
57	http://purl.org/dc/terms/rightsHolder	24	\N	5	rightsHolder	rightsHolder	f	24	\N	\N	f	f	\N	39	\N	t	f	\N	\N	\N	t	f	f
58	http://rs.tdwg.org/dwc/iri/recordedBy	4217988	\N	92	recordedBy	recordedBy	f	4217988	\N	\N	f	f	95	39	\N	t	f	\N	\N	\N	t	f	f
59	http://rs.tdwg.org/dwc/terms/namePublishedInYear	2315	\N	78	namePublishedInYear	namePublishedInYear	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
60	http://purl.org/dc/terms/modified	56428	\N	5	modified	modified	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
61	https://w3id.org/italia/env/onto/top/hasValue	14890809	\N	69	hasValue	hasValue	f	14890809	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
62	https://w3id.org/italia/env/onto/top/hasUniqueIdentifier	3885676	\N	69	hasUniqueIdentifier	hasUniqueIdentifier	f	3885676	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
63	http://www.w3.org/2002/07/owl#sameAs	91427	\N	7	sameAs	sameAs	f	91423	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
64	https://w3id.org/italia/onto/ADMS/hasSemanticAssetDistribution	12	\N	83	hasSemanticAssetDistribution	hasSemanticAssetDistribution	f	12	\N	\N	f	f	106	30	\N	t	f	\N	\N	\N	t	f	f
65	http://www.w3.org/2000/01/rdf-schema#subPropertyOf	208	\N	2	subPropertyOf	subPropertyOf	f	208	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
66	http://www.w3.org/2004/02/skos/core#notation	1	\N	4	notation	notation	f	0	\N	\N	f	f	100	\N	\N	t	f	\N	\N	\N	t	f	f
67	http://www.w3.org/1999/02/22-rdf-syntax-ns#first	113	\N	1	first	first	f	113	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
68	http://purl.org/dc/terms/language	49	\N	5	language	language	f	49	\N	\N	f	f	\N	91	\N	t	f	\N	\N	\N	t	f	f
69	http://www.w3.org/2002/07/owl#members	7	\N	7	members	members	f	7	\N	\N	f	f	10	\N	\N	t	f	\N	\N	\N	t	f	f
70	http://purl.org/dc/terms/format	38	\N	5	format	format	f	38	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
71	https://w3id.org/italia/env/onto/core#entity	79087	\N	80	entity	entity	f	79087	\N	\N	f	f	44	28	\N	t	f	\N	\N	\N	t	f	f
72	http://www.w3.org/2002/07/owl#cardinality	6	\N	7	cardinality	cardinality	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
73	http://purl.org/dc/terms/extent	739	\N	5	extent	extent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
74	http://www.w3.org/2000/01/rdf-schema#label	95932164	\N	2	label	label	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
75	http://purl.org/dc/terms/title	146	\N	5	title	title	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
76	https://w3id.org/italia/env/onto/core#instabilityRelatedTo	5532	\N	80	instabilityRelatedTo	instabilityRelatedTo	f	5532	\N	\N	f	f	112	\N	\N	t	f	\N	\N	\N	t	f	f
77	http://www.w3.org/2004/02/skos/core#prefLabel	481	\N	4	prefLabel	prefLabel	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
78	http://purl.org/dc/elements/1.1/title	1	\N	6	title	title	f	0	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
79	http://rs.tdwg.org/dwc/terms/continent	4227824	\N	78	continent	continent	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
80	https://w3id.org/italia/env/onto/top/hasIdentifierSchema	3878395	\N	69	hasIdentifierSchema	hasIdentifierSchema	f	3878395	\N	\N	f	f	110	19	\N	t	f	\N	\N	\N	t	f	f
81	https://w3id.org/italia/env/onto/top/identifier	16145709	\N	69	identifier	identifier	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
82	http://www.w3.org/1999/02/22-rdf-syntax-ns#value	111951	\N	1	value	value	f	0	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
83	https://w3id.org/italia/onto/CLV/long	294	\N	84	long	long	f	0	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
84	http://www.w3.org/2003/01/geo/wgs84_pos#long	4306128	\N	25	long	long	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
85	http://purl.org/dsw/occurrenceOf	4217988	\N	87	occurrenceOf	occurrenceOf	f	4217988	\N	\N	f	f	95	53	\N	t	f	\N	\N	\N	t	f	f
86	http://www.w3.org/2002/07/owl#qualifiedCardinality	36	\N	7	qualifiedCardinality	qualifiedCardinality	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
87	http://purl.org/dsw/evidenceFor	4217988	\N	87	evidenceFor	evidenceFor	f	4217988	\N	\N	f	f	104	95	\N	t	f	\N	\N	\N	t	f	f
88	http://www.w3.org/2004/02/skos/core#scopeNote	1	\N	4	scopeNote	scopeNote	f	0	\N	\N	f	f	103	\N	\N	t	f	\N	\N	\N	t	f	f
89	https://w3id.org/italia/env/onto/top/symbol	70	\N	69	symbol	symbol	f	0	\N	\N	f	f	32	\N	\N	t	f	\N	\N	\N	t	f	f
90	http://semanticweb.cs.vu.nl/2009/11/sem/eventType	4217988	\N	82	eventType	eventType	f	4217988	\N	\N	f	f	7	103	\N	t	f	\N	\N	\N	t	f	f
91	https://w3id.org/italia/onto/l0/identifier	830	\N	93	identifier	identifier	f	0	\N	\N	f	f	65	\N	\N	t	f	\N	\N	\N	t	f	f
92	http://purl.org/dc/terms/conformsTo	6	\N	5	conformsTo	conformsTo	f	6	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
93	https://w3id.org/whow/onto/water-monitoring/hasWaterObservableProperty	4800	\N	74	hasWaterObservableProperty	hasWaterObservableProperty	f	4800	\N	\N	f	f	45	89	\N	t	f	\N	\N	\N	t	f	f
94	https://w3id.org/italia/env/onto/core#lithologyType	5757	\N	80	lithologyType	lithologyType	f	5757	\N	\N	f	f	77	103	\N	t	f	\N	\N	\N	t	f	f
95	https://w3id.org/italia/env/onto/top/isIssuedBy	3878404	\N	69	isIssuedBy	isIssuedBy	f	3878404	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
96	https://w3id.org/italia/env/onto/inspire-mf/hasFeatureOfInterest	56661	\N	76	hasFeatureOfInterest	hasFeatureOfInterest	f	56661	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
97	http://www.w3.org/ns/dcat#accessURL	38	\N	15	accessURL	accessURL	f	38	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
98	http://www.w3.org/ns/prov#wasDerivedFrom	11	\N	26	wasDerivedFrom	wasDerivedFrom	f	11	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
99	https://w3id.org/italia/env/onto/place/hasRegion	9120	\N	79	hasRegion	hasRegion	f	9120	\N	\N	f	f	\N	97	\N	t	f	\N	\N	\N	t	f	f
100	http://rs.tdwg.org/dwc/iri/toTaxon	4217988	\N	92	toTaxon	toTaxon	f	4217988	\N	\N	f	f	52	\N	\N	t	f	\N	\N	\N	t	f	f
101	https://w3id.org/italia/onto/ADMS/hasFormalityLevel	4	\N	83	hasFormalityLevel	hasFormalityLevel	f	4	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
102	https://w3id.org/italia/env/onto/top/year	111	\N	69	year	year	f	0	\N	\N	f	f	118	\N	\N	t	f	\N	\N	\N	t	f	f
103	https://w3id.org/italia/env/onto/top/hasDataSchema	37739	\N	69	hasDataSchema	hasDataSchema	f	37739	\N	\N	f	f	85	31	\N	t	f	\N	\N	\N	t	f	f
203	http://rs.tdwg.org/dwc/terms/countryCode	4227824	\N	78	countryCode	countryCode	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
104	https://w3id.org/italia/env/onto/top/isParametrisedBy	5093417	\N	69	isParametrisedBy	isParametrisedBy	f	5093417	\N	\N	f	f	\N	54	\N	t	f	\N	\N	\N	t	f	f
105	http://www.w3.org/ns/sparql-service-description#resultFormat	8	\N	27	resultFormat	resultFormat	f	8	\N	\N	f	f	71	\N	\N	t	f	\N	\N	\N	t	f	f
106	http://www.w3.org/2006/vcard/ns#hasEmail	12	\N	39	hasEmail	hasEmail	f	12	\N	\N	f	f	90	\N	\N	t	f	\N	\N	\N	t	f	f
107	http://www.w3.org/2002/07/owl#complementOf	5	\N	7	complementOf	complementOf	f	5	\N	\N	f	f	102	102	\N	t	f	\N	\N	\N	t	f	f
108	http://www.w3.org/ns/adms#representationTechnique	6	\N	71	representationTechnique	representationTechnique	f	6	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
109	http://purl.org/dc/elements/1.1/subject	25249	\N	6	subject	subject	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
110	http://www.w3.org/2002/07/owl#intersectionOf	2	\N	7	intersectionOf	intersectionOf	f	2	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
111	https://w3id.org/italia/env/onto/top/isCollectionOf	31299	\N	69	isCollectionOf	isCollectionOf	f	31299	\N	\N	f	f	64	\N	\N	t	f	\N	\N	\N	t	f	f
112	http://www.w3.org/2002/07/owl#onDataRange	5	\N	7	onDataRange	onDataRange	f	5	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
113	http://www.w3.org/2000/01/rdf-schema#comment	868	\N	2	comment	comment	f	4	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
114	https://w3id.org/italia/env/onto/core#iterStepType	93	\N	80	iterStepType	iterStepType	f	93	\N	\N	f	f	103	103	\N	t	f	\N	\N	\N	t	f	f
115	http://xmlns.com/foaf/0.1/mbox	5	\N	8	mbox	mbox	f	5	\N	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
116	https://w3id.org/italia/env/onto/core#officialInstabilityType	25249	\N	80	officialInstabilityType	officialInstabilityType	f	0	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
117	http://www.w3.org/2003/06/sw-vocab-status/ns#term_status	99	\N	73	term_status	term_status	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
118	http://rs.tdwg.org/dwc/iri/identifiedBy	4217988	\N	92	identifiedBy	identifiedBy	f	4217988	\N	\N	f	f	52	39	\N	t	f	\N	\N	\N	t	f	f
119	https://w3id.org/italia/env/onto/core#secondaryGeographicalFeature	1105	\N	80	secondaryGeographicalFeature	secondaryGeographicalFeature	f	1105	\N	\N	f	f	36	11	\N	t	f	\N	\N	\N	t	f	f
120	https://w3id.org/italia/env/onto/top/startTime	1136	\N	69	startTime	startTime	f	0	\N	\N	f	f	66	\N	\N	t	f	\N	\N	\N	t	f	f
121	https://w3id.org/italia/env/onto/core#phase	56	\N	80	phase	phase	f	0	\N	\N	f	f	103	\N	\N	t	f	\N	\N	\N	t	f	f
122	https://w3id.org/italia/env/onto/place/hasFeature	28340	\N	79	hasFeature	hasFeature	f	28340	\N	\N	f	f	\N	20	\N	t	f	\N	\N	\N	t	f	f
123	http://purl.org/procurement/public-contracts#contact	6621	\N	70	contact	contact	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
124	http://www.w3.org/2000/01/rdf-schema#domain	311	\N	2	domain	domain	f	311	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
125	https://w3id.org/italia/env/onto/top/acronym	5	\N	69	acronym	acronym	f	0	\N	\N	f	f	9	\N	\N	t	f	\N	\N	\N	t	f	f
126	https://w3id.org/italia/onto/NDC/keyConcept	6	\N	94	keyConcept	keyConcept	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
127	https://w3id.org/italia/env/onto/place/hasCountry	9140	\N	79	hasCountry	hasCountry	f	9140	\N	\N	f	f	\N	96	\N	t	f	\N	\N	\N	t	f	f
128	https://w3id.org/italia/env/onto/core#sequencePhase	98	\N	80	sequencePhase	sequencePhase	f	0	\N	\N	f	f	103	\N	\N	t	f	\N	\N	\N	t	f	f
129	http://www.w3.org/ns/dcat#theme	44	\N	15	theme	theme	f	44	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
130	http://www.w3.org/2002/07/owl#maxCardinality	1	\N	7	maxCardinality	maxCardinality	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
131	https://w3id.org/italia/env/onto/core#repairRelatedTo	12873	\N	80	repairRelatedTo	repairRelatedTo	f	12873	\N	\N	f	f	99	\N	\N	t	f	\N	\N	\N	t	f	f
132	http://rs.tdwg.org/dwc/terms/locatedAt	4217988	\N	78	locatedAt	locatedAt	f	4217988	\N	\N	f	f	7	79	\N	t	f	\N	\N	\N	t	f	f
133	https://w3id.org/italia/env/onto/top/endTime	1123	\N	69	endTime	endTime	f	0	\N	\N	f	f	66	\N	\N	t	f	\N	\N	\N	t	f	f
134	https://w3id.org/italia/env/onto/top/name	15861	\N	69	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
135	https://w3id.org/italia/env/onto/core#cup	22536	\N	80	cup	cup	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
136	http://rs.tdwg.org/dwc/terms/taxonRank	2322	\N	78	taxonRank	taxonRank	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
137	https://w3id.org/italia/onto/ADMS/prev	4	\N	83	prev	prev	f	4	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
138	https://w3id.org/italia/env/onto/top/hasBroader	7334	\N	69	hasBroader	hasBroader	f	7334	\N	\N	f	f	54	54	\N	t	f	\N	\N	\N	t	f	f
139	http://www.w3.org/2006/time#hasBeginning	45	\N	72	hasBeginning	hasBeginning	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
140	http://www.w3.org/2002/07/owl#inverseOf	86	\N	7	inverseOf	inverseOf	f	86	\N	\N	f	f	17	17	\N	t	f	\N	\N	\N	t	f	f
141	http://www.w3.org/2002/07/owl#hasKey	3	\N	7	hasKey	hasKey	f	3	\N	\N	f	f	102	\N	\N	t	f	\N	\N	\N	t	f	f
142	https://w3id.org/italia/env/onto/core#hasEconomicIndicator	111951	\N	80	hasEconomicIndicator	hasEconomicIndicator	f	111951	\N	\N	f	f	23	69	\N	t	f	\N	\N	\N	t	f	f
143	http://www.w3.org/1999/02/22-rdf-syntax-ns#rest	113	\N	1	rest	rest	f	113	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
144	http://www.w3.org/ns/dcat#contactPoint	24	\N	15	contactPoint	contactPoint	f	24	\N	\N	f	f	\N	25	\N	t	f	\N	\N	\N	t	f	f
145	http://www.w3.org/2004/02/skos/core#definition	46	\N	4	definition	definition	f	0	\N	\N	f	f	103	\N	\N	t	f	\N	\N	\N	t	f	f
146	https://w3id.org/italia/env/onto/inspire-mf/hasObservationParameter	37739	\N	76	hasObservationParameter	hasObservationParameter	f	37739	\N	\N	f	f	56	12	\N	t	f	\N	\N	\N	t	f	f
147	https://w3id.org/italia/env/onto/inspire-mf/hasValidationLevel	37739	\N	76	hasValidationLevel	hasValidationLevel	f	37739	\N	\N	f	f	56	22	\N	t	f	\N	\N	\N	t	f	f
148	http://purl.org/dsw/atEvent	4217988	\N	87	atEvent	atEvent	f	4217988	\N	\N	f	f	95	7	\N	t	f	\N	\N	\N	t	f	f
149	http://purl.org/procurement/public-contracts#procedureType	26530	\N	70	procedureType	procedureType	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
150	https://w3id.org/italia/env/onto/place/istat	9141	\N	79	istat	istat	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
151	http://www.w3.org/2000/01/rdf-schema#isDefinedBy	394	\N	2	isDefinedBy	isDefinedBy	f	394	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
152	https://w3id.org/italia/env/onto/inspire-mf/hasPlatformType	95	\N	76	hasPlatformType	hasPlatformType	f	95	\N	\N	f	f	75	88	\N	t	f	\N	\N	\N	t	f	f
257	https://property14	1	\N	89	property14	property14	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
153	https://w3id.org/italia/env/onto/top/parametrises	6718	\N	69	parametrises	parametrises	f	6718	\N	\N	f	f	54	34	\N	t	f	\N	\N	\N	t	f	f
154	http://rs.tdwg.org/dwc/terms/specificEpithet	2322	\N	78	specificEpithet	specificEpithet	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
155	http://www.w3.org/2002/07/owl#propertyChainAxiom	6	\N	7	propertyChainAxiom	propertyChainAxiom	f	6	\N	\N	f	f	17	\N	\N	t	f	\N	\N	\N	t	f	f
156	https://w3id.org/italia/env/onto/inspire-mf/isHostedBy	14540	\N	76	isHostedBy	isHostedBy	f	14540	\N	\N	f	f	\N	75	\N	t	f	\N	\N	\N	t	f	f
157	http://dati.gov.it/onto/dcatapit#startDate	13	\N	75	startDate	startDate	f	0	\N	\N	f	f	114	\N	\N	t	f	\N	\N	\N	t	f	f
158	http://www.w3.org/2002/07/owl#someValuesFrom	84	\N	7	someValuesFrom	someValuesFrom	f	84	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
159	http://purl.org/dsw/derivedFrom	4217988	\N	87	derivedFrom	derivedFrom	f	4217988	\N	\N	f	f	104	53	\N	t	f	\N	\N	\N	t	f	f
160	http://www.w3.org/2002/07/owl#disjointWith	19	\N	7	disjointWith	disjointWith	f	19	\N	\N	f	f	102	102	\N	t	f	\N	\N	\N	t	f	f
161	http://www.w3.org/ns/sparql-service-description#feature	2	\N	27	feature	feature	f	2	\N	\N	f	f	71	\N	\N	t	f	\N	\N	\N	t	f	f
162	http://www.w3.org/ns/sparql-service-description#url	1	\N	27	url	url	f	1	\N	\N	f	f	71	\N	\N	t	f	\N	\N	\N	t	f	f
163	https://w3id.org/italia/env/onto/core#repairType	12873	\N	80	repairType	repairType	f	12873	\N	\N	f	f	99	103	\N	t	f	\N	\N	\N	t	f	f
164	http://www.w3.org/2002/07/owl#unionOf	26	\N	7	unionOf	unionOf	f	26	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
165	http://www.w3.org/ns/dcat#mediaType	14	\N	15	mediaType	mediaType	f	14	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
166	http://www.w3.org/2002/07/owl#versionInfo	137	\N	7	versionInfo	versionInfo	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
167	https://w3id.org/italia/env/onto/place/long	294	\N	79	long	long	f	0	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
168	https://w3id.org/whow/onto/water-monitoring/hasObservationSample	4800	\N	74	hasObservationSample	hasObservationSample	f	4800	\N	\N	f	f	45	13	\N	t	f	\N	\N	\N	t	f	f
169	http://www.w3.org/ns/dcat#temporalResolution	9	\N	15	temporalResolution	temporalResolution	f	0	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
170	https://w3id.org/whow/onto/water-monitoring/hasBiologicalAgent	4800	\N	74	hasBiologicalAgent	hasBiologicalAgent	f	4800	\N	\N	f	f	45	100	\N	t	f	\N	\N	\N	t	f	f
171	http://qudt.org/vocab/unit#unit	111951	\N	95	unit	unit	f	111951	\N	\N	f	f	69	\N	\N	t	f	\N	\N	\N	t	f	f
172	https://w3id.org/italia/env/onto/top/hasMedia	37745	\N	69	hasMedia	hasMedia	f	37745	\N	\N	f	f	\N	85	\N	t	f	\N	\N	\N	t	f	f
173	https://w3id.org/italia/env/onto/core#isLotOf	26530	\N	80	isLotOf	isLotOf	f	26530	\N	\N	f	f	23	36	\N	t	f	\N	\N	\N	t	f	f
174	https://w3id.org/italia/env/onto/top/mediaType	37745	\N	69	mediaType	mediaType	f	0	\N	\N	f	f	85	\N	\N	t	f	\N	\N	\N	t	f	f
175	http://www.w3.org/2004/02/skos/core#broader	163	\N	4	broader	broader	f	163	\N	\N	f	f	103	103	\N	t	f	\N	\N	\N	t	f	f
176	https://w3id.org/italia/env/onto/inspire-mf/hasManufacturer	57	\N	76	hasManufacturer	hasManufacturer	f	57	\N	\N	f	f	\N	9	\N	t	f	\N	\N	\N	t	f	f
177	http://www.w3.org/2004/02/skos/core#hasTopConcept	19	\N	4	hasTopConcept	hasTopConcept	f	19	\N	\N	f	f	70	103	\N	t	f	\N	\N	\N	t	f	f
178	http://www.openlinksw.com/schemas/DAV#ownerUser	758	\N	18	ownerUser	ownerUser	f	758	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
179	https://w3id.org/italia/env/onto/top/hasCharacteristic	42	\N	69	hasCharacteristic	hasCharacteristic	f	42	\N	\N	f	f	121	18	\N	t	f	\N	\N	\N	t	f	f
180	http://purl.org/dc/terms/isReferencedBy	82543	\N	5	isReferencedBy	isReferencedBy	f	82543	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
181	https://w3id.org/italia/env/onto/top/isPartOf	5274911	\N	69	isPartOf	isPartOf	f	5274911	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
182	http://www.w3.org/2002/07/owl#versionIRI	12	\N	7	versionIRI	versionIRI	f	12	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
183	http://www.w3.org/2004/02/skos/core#narrower	4	\N	4	narrower	narrower	f	4	\N	\N	f	f	103	103	\N	t	f	\N	\N	\N	t	f	f
184	http://purl.org/dc/terms/temporal	14	\N	5	temporal	temporal	f	14	\N	\N	f	f	8	114	\N	t	f	\N	\N	\N	t	f	f
185	http://creativecommons.org/ns#license	1	\N	23	license	license	f	1	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
186	https://w3id.org/italia/env/onto/core#instabilityGroup	5532	\N	80	instabilityGroup	instabilityGroup	f	0	\N	\N	f	f	112	\N	\N	t	f	\N	\N	\N	t	f	f
187	http://rs.tdwg.org/dwc/terms/kingdom	2330	\N	78	kingdom	kingdom	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
188	http://www.w3.org/2003/01/geo/wgs84_pos#location	51026	\N	25	location	location	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
189	http://purl.org/dc/terms/identifier	63	\N	5	identifier	identifier	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
190	https://w3id.org/italia/onto/CLV/lat	294	\N	84	lat	lat	f	0	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
191	http://rs.tdwg.org/dwc/terms/class	2324	\N	78	class	class	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
192	http://purl.org/dsw/isBasisForId	4217988	\N	87	isBasisForId	isBasisForId	f	4217988	\N	\N	f	f	104	52	\N	t	f	\N	\N	\N	t	f	f
193	https://w3id.org/italia/onto/ADMS/hasTask	8	\N	83	hasTask	hasTask	f	8	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
194	http://www.w3.org/ns/sparql-service-description#supportedLanguage	1	\N	27	supportedLanguage	supportedLanguage	f	1	\N	\N	f	f	71	\N	\N	t	f	\N	\N	\N	t	f	f
195	https://w3id.org/italia/onto/l0/name	849	\N	93	name	name	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
196	http://purl.org/dc/elements/1.1/creator	1	\N	6	creator	creator	f	0	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
197	http://rdf-vocabulary.ddialliance.org/xkos#numberOfLevels	6	\N	96	numberOfLevels	numberOfLevels	f	0	\N	\N	f	f	70	\N	\N	t	f	\N	\N	\N	t	f	f
198	https://w3id.org/italia/env/onto/core#hasAgreement	25249	\N	80	hasAgreement	hasAgreement	f	25249	\N	\N	f	f	36	6	\N	t	f	\N	\N	\N	t	f	f
199	https://w3id.org/italia/env/onto/core#hasStep	90047	\N	80	hasStep	hasStep	f	90047	\N	\N	f	f	58	103	\N	t	f	\N	\N	\N	t	f	f
200	http://rs.tdwg.org/dwc/terms/eventDate	4217988	\N	78	eventDate	eventDate	f	0	\N	\N	f	f	7	\N	\N	t	f	\N	\N	\N	t	f	f
201	http://purl.org/dc/terms/issued	47	\N	5	issued	issued	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
202	https://w3id.org/italia/env/onto/top/hasSource	7974243	\N	69	hasSource	hasSource	f	7974243	\N	\N	f	f	74	\N	\N	t	f	\N	\N	\N	t	f	f
204	https://w3id.org/italia/env/onto/top/isClassifiedBy	168619	\N	69	isClassifiedBy	isClassifiedBy	f	168619	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
205	https://w3id.org/italia/env/onto/top/value	2948254	\N	69	value	value	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
206	https://w3id.org/italia/onto/ADMS/prefix	4	\N	83	prefix	prefix	f	0	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
207	http://purl.org/dc/elements/1.1/source	25249	\N	6	source	source	f	0	\N	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
208	http://www.w3.org/2002/07/owl#minCardinality	2	\N	7	minCardinality	minCardinality	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
209	http://purl.org/dc/terms/rights	14	\N	5	rights	rights	f	14	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
210	https://w3id.org/whow/onto/water-monitoring/hasResult	7241	\N	74	hasResult	hasResult	f	7241	\N	\N	f	f	45	24	\N	t	f	\N	\N	\N	t	f	f
211	http://www.w3.org/2004/02/skos/core#exactMatch	10	\N	4	exactMatch	exactMatch	f	10	\N	\N	f	f	103	\N	\N	t	f	\N	\N	\N	t	f	f
212	https://w3id.org/italia/env/onto/place/lat	294	\N	79	lat	lat	f	0	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
213	http://rs.tdwg.org/dwc/terms/order	2324	\N	78	order	order	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
214	https://w3id.org/italia/env/onto/inspire-mf/hasSensorType	397	\N	76	hasSensorType	hasSensorType	f	397	\N	\N	f	f	111	76	\N	t	f	\N	\N	\N	t	f	f
215	http://purl.org/dc/terms/accessRights	14	\N	5	accessRights	accessRights	f	14	\N	\N	f	f	8	\N	\N	t	f	\N	\N	\N	t	f	f
216	https://w3id.org/italia/env/onto/inspire-mf/isObservationMadeBySensor	37739	\N	76	isObservationMadeBySensor	isObservationMadeBySensor	f	37739	\N	\N	f	f	56	\N	\N	t	f	\N	\N	\N	t	f	f
217	http://purl.org/dc/terms/description	40785619	\N	5	description	description	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
218	http://www.w3.org/2002/07/owl#onClass	38	\N	7	onClass	onClass	f	38	\N	\N	f	f	42	102	\N	t	f	\N	\N	\N	t	f	f
219	http://rs.tdwg.org/dwc/terms/locality	4227824	\N	78	locality	locality	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
220	http://www.w3.org/2004/02/skos/core#inScheme	406	\N	4	inScheme	inScheme	f	406	\N	\N	f	f	103	94	\N	t	f	\N	\N	\N	t	f	f
221	https://w3id.org/italia/env/onto/place/hasDirectHigherRank	8995	\N	79	hasDirectHigherRank	hasDirectHigherRank	f	8995	\N	\N	f	f	11	\N	\N	t	f	\N	\N	\N	t	f	f
222	http://www.w3.org/2002/07/owl#maxQualifiedCardinality	10	\N	7	maxQualifiedCardinality	maxQualifiedCardinality	f	0	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
223	https://w3id.org/italia/onto/CLV/coordinate	294	\N	84	coordinate	coordinate	f	0	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
224	http://www.w3.org/2000/01/rdf-schema#subClassOf	411	\N	2	subClassOf	subClassOf	f	411	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
225	http://purl.org/dc/terms/subject	46	\N	5	subject	subject	f	46	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
226	https://w3id.org/italia/env/onto/inspire-mf/hasSystemCapability	1179	\N	76	hasSystemCapability	hasSystemCapability	f	1179	\N	\N	f	f	\N	121	\N	t	f	\N	\N	\N	t	f	f
227	https://w3id.org/italia/env/onto/top/atTime	14955310	\N	69	atTime	atTime	f	14955310	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
228	http://rs.tdwg.org/dwc/terms/scientificName	2330	\N	78	scientificName	scientificName	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
229	http://www.w3.org/2000/01/rdf-schema#range	310	\N	2	range	range	f	310	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
230	http://purl.org/dc/elements/1.1/publisher	1	\N	6	publisher	publisher	f	1	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
231	http://www.w3.org/2002/07/owl#equivalentProperty	51	\N	7	equivalentProperty	equivalentProperty	f	51	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
232	https://w3id.org/italia/env/onto/core#hasIter	26530	\N	80	hasIter	hasIter	f	26530	\N	\N	f	f	23	103	\N	t	f	\N	\N	\N	t	f	f
233	https://w3id.org/italia/onto/ADMS/last	4	\N	83	last	last	f	4	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
234	http://rs.tdwg.org/dwc/terms/genus	2322	\N	78	genus	genus	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
235	https://w3id.org/italia/env/onto/top/hasPart	922	\N	69	hasPart	hasPart	f	922	\N	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
236	http://purl.org/dc/elements/1.1/format	9	\N	6	format	format	f	0	\N	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
237	http://purl.org/dc/terms/publisher	25275	\N	5	publisher	publisher	f	25275	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
238	https://w3id.org/italia/env/onto/inspire-mf/hasSensorModel	397	\N	76	hasSensorModel	hasSensorModel	f	397	\N	\N	f	f	111	35	\N	t	f	\N	\N	\N	t	f	f
239	https://w3id.org/italia/env/onto/inspire-mf/hasOperationalStatus	95	\N	76	hasOperationalStatus	hasOperationalStatus	f	95	\N	\N	f	f	75	103	\N	t	f	\N	\N	\N	t	f	f
240	https://w3id.org/italia/env/onto/core#primaryGeographicalFeature	25249	\N	80	primaryGeographicalFeature	primaryGeographicalFeature	f	25249	\N	\N	f	f	36	\N	\N	t	f	\N	\N	\N	t	f	f
241	http://purl.org/vocab/vann/preferredNamespaceUri	1	\N	24	preferredNamespaceUri	preferredNamespaceUri	f	0	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
242	https://w3id.org/italia/env/onto/top/hasUnitOfMeasure	2948280	\N	69	hasUnitOfMeasure	hasUnitOfMeasure	f	2948280	\N	\N	f	f	\N	32	\N	t	f	\N	\N	\N	t	f	f
243	http://www.w3.org/2000/01/rdf-schema#seeAlso	889	\N	2	seeAlso	seeAlso	f	888	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
244	https://w3id.org/italia/onto/ADMS/hasKeyClass	27	\N	83	hasKeyClass	hasKeyClass	f	27	\N	\N	f	f	106	102	\N	t	f	\N	\N	\N	t	f	f
246	https://property19	1	\N	89	property19	property19	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
247	http://www.w3.org/1999/02/22-rdf-syntax-ns#about	10	\N	1	about	about	f	10	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
248	https://property15	1	\N	89	property15	property15	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
249	https://property16	1	\N	89	property16	property16	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
250	http://www.w3.org/2002/07/owl#imports	19	\N	7	imports	imports	f	19	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
251	https://property17	1	\N	89	property17	property17	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
252	https://w3id.org/italia/env/onto/inspire-mf/implementsProcedure	314	\N	76	implementsProcedure	implementsProcedure	f	314	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
253	https://property18	1	\N	89	property18	property18	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
254	https://property11	1	\N	89	property11	property11	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
255	https://property12	1	\N	89	property12	property12	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
256	https://property13	1	\N	89	property13	property13	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
258	http://www.w3.org/ns/dcat#startDate	13	\N	15	startDate	startDate	f	0	\N	\N	f	f	114	\N	\N	t	f	\N	\N	\N	t	f	f
259	https://property10	1	\N	89	property10	property10	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
260	http://purl.org/dc/elements/1.1/identifier	79	\N	6	identifier	identifier	f	0	\N	\N	f	f	103	\N	\N	t	f	\N	\N	\N	t	f	f
261	https://w3id.org/italia/onto/CLV/hasGeometryType	294	\N	84	hasGeometryType	hasGeometryType	f	294	\N	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
262	http://rs.tdwg.org/dwc/terms/family	2322	\N	78	family	family	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
263	https://w3id.org/italia/onto/ADMS/status	7	\N	83	status	status	f	0	\N	\N	f	f	106	\N	\N	t	f	\N	\N	\N	t	f	f
264	http://www.w3.org/1999/02/22-rdf-syntax-ns#_5	4	\N	1	_5	_5	f	4	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
265	http://www.w3.org/1999/02/22-rdf-syntax-ns#_3	11	\N	1	_3	_3	f	11	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
266	https://w3id.org/italia/env/onto/inspire-mf/hasSystemDeployment	454	\N	76	hasSystemDeployment	hasSystemDeployment	f	454	\N	\N	f	f	\N	98	\N	t	f	\N	\N	\N	t	f	f
267	http://www.w3.org/1999/02/22-rdf-syntax-ns#_4	4	\N	1	_4	_4	f	4	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
268	http://www.w3.org/1999/02/22-rdf-syntax-ns#_1	78	\N	1	_1	_1	f	78	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
269	http://www.w3.org/1999/02/22-rdf-syntax-ns#_2	15	\N	1	_2	_2	f	15	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
270	https://w3id.org/italia/env/onto/top/time	1751	\N	69	time	time	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
271	http://purl.org/vocab/vann/preferredNamespacePrefix	1	\N	24	preferredNamespacePrefix	preferredNamespacePrefix	f	0	\N	\N	f	f	51	\N	\N	t	f	\N	\N	\N	t	f	f
272	http://purl.org/dc/terms/license	49	\N	5	license	license	f	49	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
273	http://purl.org/dc/elements/1.1/spatial	1	\N	6	spatial	spatial	f	1	\N	\N	f	f	80	\N	\N	t	f	\N	\N	\N	t	f	f
274	http://purl.org/dc/terms/accrualPeriodicity	24	\N	5	accrualPeriodicity	accrualPeriodicity	f	24	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
275	http://rs.tdwg.org/dwc/terms/coordinateUncertaintyInMeters	9836	\N	78	coordinateUncertaintyInMeters	coordinateUncertaintyInMeters	f	0	\N	\N	f	f	79	\N	\N	t	f	\N	\N	\N	t	f	f
276	https://property26	1	\N	89	property26	property26	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
277	http://www.w3.org/2003/01/geo/wgs84_pos#lat	4306128	\N	25	lat	lat	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
278	http://www.georss.org/georss/point	28753	\N	29	point	point	f	0	\N	\N	f	f	23	\N	\N	t	f	\N	\N	\N	t	f	f
279	https://property27	1	\N	89	property27	property27	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
280	https://property28	1	\N	89	property28	property28	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
281	https://property29	1	\N	89	property29	property29	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
282	https://w3id.org/whow/onto/water-monitoring/isTakenAt	4764	\N	74	isTakenAt	isTakenAt	f	4764	\N	\N	f	f	13	65	\N	t	f	\N	\N	\N	t	f	f
283	http://www.w3.org/2002/07/owl#onProperty	213	\N	7	onProperty	onProperty	f	213	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
284	http://purl.org/dc/elements/1.1/type	6243	\N	6	type	type	f	5	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
285	https://w3id.org/italia/env/onto/inspire-mf/hasPlatformModel	95	\N	76	hasPlatformModel	hasPlatformModel	f	95	\N	\N	f	f	75	43	\N	t	f	\N	\N	\N	t	f	f
286	http://purl.org/dsw/identifies	4217988	\N	87	identifies	identifies	f	4217988	\N	\N	f	f	52	53	\N	t	f	\N	\N	\N	t	f	f
287	https://property20	1	\N	89	property20	property20	f	1	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
288	http://www.w3.org/2002/07/owl#allValuesFrom	77	\N	7	allValuesFrom	allValuesFrom	f	77	\N	\N	f	f	42	\N	\N	t	f	\N	\N	\N	t	f	f
289	http://xmlns.com/foaf/0.1/depiction	11067	\N	8	depiction	depiction	f	11067	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
290	http://rs.tdwg.org/dwc/terms/scientificNameAuthorship	2314	\N	78	scientificNameAuthorship	scientificNameAuthorship	f	0	\N	\N	f	f	78	\N	\N	t	f	\N	\N	\N	t	f	f
291	https://w3id.org/italia/env/onto/top/isMemberOf	19170209	\N	69	isMemberOf	isMemberOf	f	19170209	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
292	http://www.w3.org/ns/dcat#distribution	26	\N	15	distribution	distribution	f	26	\N	\N	f	f	113	2	\N	t	f	\N	\N	\N	t	f	f
293	http://purl.org/dc/terms/created	4218746	\N	5	created	created	f	0	\N	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
294	https://w3id.org/italia/env/onto/top/hasDownloadURL	37745	\N	69	hasDownloadURL	hasDownloadURL	f	37745	\N	\N	f	f	85	\N	\N	t	f	\N	\N	\N	t	f	f
295	http://rs.tdwg.org/dwc/terms/dateIdentified	4217988	\N	78	dateIdentified	dateIdentified	f	0	\N	\N	f	f	52	\N	\N	t	f	\N	\N	\N	t	f	f
296	https://w3id.org/italia/env/onto/core#role	79087	\N	80	role	role	f	0	\N	\N	f	f	44	\N	\N	t	f	\N	\N	\N	t	f	f
245	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	64528122	\N	1	type	type	f	64528122	\N	\N	f	f	\N	\N	\N	t	t	t	\N	t	t	f	f
297	http://www.w3.org/ns/sparql-service-description#endpoint	1	\N	27	endpoint	endpoint	f	1	\N	\N	f	f	71	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

COPY http_dati_isprambiente_it_sparql.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
1	14	8	E' autorità di distretto	it
2	14	8	Is district authority	en
3	19	8	temporal entity of observation (or sampling) generation	en
4	19	8	entità temporale di generazione dell'osservazione (o del campionamento)	it
5	20	8	is sampling made by sampler	en
6	20	8	è campionamento emesso da campionatore	it
7	21	8	equivalentClass	\N
8	27	8	Tipo di dissesto	it
9	27	8	Instability type	en
10	28	8	Categoria di opera	it
11	28	8	Repair category	en
12	31	8	is sample of	en
13	36	8	Lot	en
14	36	8	Lotto	it
15	37	8	ha luogo nelle vicinanze	it
16	37	8	has nearby location	en
17	38	8	priorVersion	\N
18	40	8	ha municipalità	it
19	40	8	has municipality	en
20	41	8	Amount financed	en
21	41	8	Importo finanziato	it
22	46	8	Lithology related to	en
23	46	8	Litologia collegata a	it
24	47	8	geometry serialisation	en
25	47	8	serializzazione della geometria	it
26	49	8	ha attributo di schema di dati	it
27	49	8	has data schema attribute	en
28	53	8	is platform of	en
29	53	8	è piattaforma di	it
30	55	8	Contracting authority	en
31	55	8	Ente legato all'intervento	it
32	56	8	ha geometria	it
33	56	8	has geometry	en
34	61	8	ha valore	it
35	61	8	has value	en
36	62	8	ha identificativo univoco	it
37	62	8	has unique identifier	en
38	63	8	sameAs	\N
39	71	8	Entity	en
40	71	8	Entità	it
41	72	8	cardinality	\N
42	76	8	Dissesto relativo a	it
43	76	8	Instability related to	en
44	80	8	ha schema di identificazione	it
45	80	8	has identifier schema	en
46	81	8	identificativo	it
47	81	8	identifier	en
48	89	8	simbolo	it
49	89	8	symbol	en
50	93	8	has water observable property	en
51	94	8	Lithology type	en
52	94	8	Tipo di litologia	it
53	95	8	ha creatore	it
54	95	8	has creator	en
55	96	8	ha caratteristica di interesse	it
56	96	8	has feature of interest	en
57	99	8	ha regione	it
58	102	8	anno	it
59	102	8	year	en
60	103	8	ha schema di dati	it
61	103	8	has data schema	en
62	104	8	is parametrised by	en
63	104	8	è parametrizzato da	it
64	107	8	complementOf	\N
65	110	8	intersectionOf	\N
66	111	8	is collection of	en
67	111	8	è collezione di	it
68	114	8	Iter step type	en
69	114	8	Passi dell'iter	it
70	116	8	Dissesto indicato nel decreto	it
71	116	8	Official instability type	en
72	119	8	Luogo secondario	it
73	119	8	Secondary geographical feature	en
74	120	8	start time	en
75	120	8	tempo di inizio	it
76	121	8	Fase	it
77	121	8	Phase	en
78	125	8	acronimo	it
79	125	8	acronym	en
80	127	8	ha paese	it
81	127	8	has country	en
82	130	8	maxCardinality	\N
83	131	8	Opera collegata a	it
84	131	8	Repair related to	en
85	133	8	end time	en
86	133	8	tempo di fine	it
87	134	8	name	en
88	134	8	nome	it
89	135	8	Codice Unico di Progetto	it
90	135	8	Project Unit Code	en
91	138	8	ha più generale	it
92	138	8	has broader	en
93	140	8	inverseOf	\N
94	142	8	Ha indicatori economici	it
95	142	8	Has economic indicator	en
96	146	8	ha parametro di osservazione	it
97	146	8	has observation parameter	en
98	147	8	ha livello di validazione	it
99	147	8	has validation level	en
100	150	8	ISTAT code	en
101	150	8	codice ISTAT	it
102	152	8	ha tipo di piattaforma	it
103	152	8	has platform type	en
104	153	8	parametrises	en
105	153	8	parametrizza	it
106	156	8	is hosted by	en
107	156	8	è ospitato da	it
108	158	8	someValuesFrom	\N
109	160	8	disjointWith	\N
110	163	8	Repair type	en
111	163	8	Tipologia di opera	it
112	164	8	unionOf	\N
113	166	8	versionInfo	\N
114	167	8	longitude	en
115	167	8	longitudine	it
116	168	8	has observation sample	en
117	170	8	has biological agent	en
118	172	8	ha media	it
119	172	8	has media	en
120	173	8	E' lotto di	it
121	173	8	Is lot of	en
122	174	8	media type	en
123	174	8	tipo di supporto	it
124	176	8	ha costruttore	it
125	176	8	has manufacturer	en
126	179	8	ha caratteristica	it
127	179	8	has characteristic	en
128	181	8	is part of	en
129	181	8	è parte di	it
130	186	8	Instability group	en
131	186	8	Raggruppamento di dissesto	it
132	198	8	Ha un accordo quadro	en
133	198	8	Has agreement	it
134	199	8	Ha passo di iter	it
135	199	8	Has step	en
136	202	8	ha sorgente	it
137	202	8	has source	en
138	204	8	is classified by	en
139	204	8	è classificato da	it
140	205	8	valore	it
141	205	8	value	en
142	208	8	minCardinality	\N
143	210	8	has result	en
144	212	8	latitude	en
145	212	8	latitudine	it
146	214	8	ha tipo di sensore	it
147	214	8	has sensor type	en
148	216	8	is observation made by sensor	en
149	216	8	è osservazione emessa da sensore	it
150	221	8	is direct lower rank of	en
151	221	8	è il livello diretto più basso di	it
152	226	8	ha proprietà del sistema	it
153	226	8	has system property	en
154	227	8	al tempo	it
155	227	8	at time	en
156	231	8	equivalentProperty	\N
157	232	8	Ha iter	it
158	232	8	Has iter	en
159	235	8	ha parte	it
160	235	8	has part	en
161	238	8	ha modello di sensore	it
162	238	8	has sensor model	en
163	239	8	ha stato operativo	it
164	239	8	has operational status	en
165	240	8	Luogo primario	it
166	240	8	Primary geographical feature	en
167	242	8	ha unità di misura	it
168	242	8	has unit of measure	en
169	250	8	imports	\N
170	252	8	implementa procedura	it
171	252	8	implements procedure	en
172	266	8	ha dislocamento del sistema	it
173	266	8	has system deployment	en
174	270	8	tempo	it
175	270	8	time	en
176	282	8	is taken at	en
177	283	8	onProperty	\N
178	285	8	ha modello di piattaforma	it
179	285	8	has platform model	en
180	288	8	allValuesFrom	\N
181	291	8	is member of	en
182	291	8	è membro di	it
183	294	8	ha URL di scaricamento	it
184	294	8	has download URL	en
185	296	8	Role	en
186	296	8	Ruolo	it
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.annot_types_id_seq', 8, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.cc_rels_id_seq', 38, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.class_annots_id_seq', 131, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.classes_id_seq', 122, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.cp_rels_id_seq', 1355, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.cpc_rels_id_seq', 1, false);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.cpd_rels_id_seq', 1, false);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.datatypes_id_seq', 1, false);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.ns_id_seq', 96, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.parameters_id_seq', 30, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.pd_rels_id_seq', 1, false);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.pp_rels_id_seq', 1, false);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.properties_id_seq', 297, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

SELECT pg_catalog.setval('http_dati_isprambiente_it_sparql.property_annots_id_seq', 186, true);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON http_dati_isprambiente_it_sparql.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON http_dati_isprambiente_it_sparql.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON http_dati_isprambiente_it_sparql.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON http_dati_isprambiente_it_sparql.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON http_dati_isprambiente_it_sparql.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON http_dati_isprambiente_it_sparql.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON http_dati_isprambiente_it_sparql.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON http_dati_isprambiente_it_sparql.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON http_dati_isprambiente_it_sparql.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON http_dati_isprambiente_it_sparql.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON http_dati_isprambiente_it_sparql.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON http_dati_isprambiente_it_sparql.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON http_dati_isprambiente_it_sparql.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON http_dati_isprambiente_it_sparql.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON http_dati_isprambiente_it_sparql.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON http_dati_isprambiente_it_sparql.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON http_dati_isprambiente_it_sparql.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON http_dati_isprambiente_it_sparql.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_cc_rels_data ON http_dati_isprambiente_it_sparql.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_classes_cnt ON http_dati_isprambiente_it_sparql.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_classes_data ON http_dati_isprambiente_it_sparql.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_classes_iri ON http_dati_isprambiente_it_sparql.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON http_dati_isprambiente_it_sparql.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON http_dati_isprambiente_it_sparql.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON http_dati_isprambiente_it_sparql.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_data ON http_dati_isprambiente_it_sparql.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON http_dati_isprambiente_it_sparql.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_instances_local_name ON http_dati_isprambiente_it_sparql.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_instances_test ON http_dati_isprambiente_it_sparql.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_data ON http_dati_isprambiente_it_sparql.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON http_dati_isprambiente_it_sparql.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON http_dati_isprambiente_it_sparql.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON http_dati_isprambiente_it_sparql.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON http_dati_isprambiente_it_sparql.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON http_dati_isprambiente_it_sparql.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON http_dati_isprambiente_it_sparql.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_properties_cnt ON http_dati_isprambiente_it_sparql.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_properties_data ON http_dati_isprambiente_it_sparql.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

CREATE INDEX idx_properties_iri ON http_dati_isprambiente_it_sparql.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES http_dati_isprambiente_it_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES http_dati_isprambiente_it_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES http_dati_isprambiente_it_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_dati_isprambiente_it_sparql.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES http_dati_isprambiente_it_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_dati_isprambiente_it_sparql.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_dati_isprambiente_it_sparql.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_dati_isprambiente_it_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES http_dati_isprambiente_it_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES http_dati_isprambiente_it_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_dati_isprambiente_it_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_dati_isprambiente_it_sparql.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_dati_isprambiente_it_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES http_dati_isprambiente_it_sparql.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES http_dati_isprambiente_it_sparql.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_dati_isprambiente_it_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES http_dati_isprambiente_it_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES http_dati_isprambiente_it_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES http_dati_isprambiente_it_sparql.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES http_dati_isprambiente_it_sparql.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES http_dati_isprambiente_it_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES http_dati_isprambiente_it_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES http_dati_isprambiente_it_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES http_dati_isprambiente_it_sparql.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES http_dati_isprambiente_it_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES http_dati_isprambiente_it_sparql.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES http_dati_isprambiente_it_sparql.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES http_dati_isprambiente_it_sparql.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: http_dati_isprambiente_it_sparql; Owner: -
--

ALTER TABLE ONLY http_dati_isprambiente_it_sparql.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES http_dati_isprambiente_it_sparql.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

