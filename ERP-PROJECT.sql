--
-- PostgreSQL database dump
--

-- Dumped from database version 12.10
-- Dumped by pg_dump version 13.3

-- Started on 2022-08-23 16:03:16

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
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3276 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 257 (class 1255 OID 31346)
-- Name: make_serial(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.make_serial(p_table_schema text, p_table_name text, p_column_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
  l_sql text;
  l_seq_name text;
  l_full_name text;
begin
--select make_serial('public', 'user', 'user_id');
  l_seq_name := concat(p_table_name, '_', p_column_name, '_seq');
  l_full_name := quote_ident(p_table_schema)||'.'||quote_ident(l_seq_name); 
  
  execute format('create sequence %I.%I', p_table_schema, l_seq_name);
  execute format('alter table %I.%I alter column %I set default nextval(%L)', p_table_schema, p_table_name, p_column_name, l_seq_name);
  execute format('alter table %I.%I alter column %I set not null', p_table_schema, p_table_name, p_column_name);
  execute format('alter sequence %I.%I owned by %I.%I', p_table_schema, l_seq_name, p_table_name, p_column_name);
  execute format('select setval(%L, coalesce(max(%I),1)) from %I', l_full_name, p_column_name, p_table_name);
end;
$$;


ALTER FUNCTION public.make_serial(p_table_schema text, p_table_name text, p_column_name text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 31347)
-- Name: approval; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.approval (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    approval_id integer NOT NULL,
    approval_ref_table character varying NOT NULL,
    approval_desc character varying,
    approval_user_id_1 integer NOT NULL,
    approval_user_id_2 integer,
    approval_user_id_3 integer,
    approval_user_id_4 integer,
    approval_user_id_5 integer
);


ALTER TABLE public.approval OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 31355)
-- Name: approval_approval_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.approval_approval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.approval_approval_id_seq OWNER TO postgres;

--
-- TOC entry 3277 (class 0 OID 0)
-- Dependencies: 203
-- Name: approval_approval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.approval_approval_id_seq OWNED BY public.approval.approval_id;


--
-- TOC entry 204 (class 1259 OID 31357)
-- Name: approval_flow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.approval_flow (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    approval_ref_table character varying NOT NULL,
    approval_desc character varying,
    approval_user_id_1 integer NOT NULL,
    approval_user_id_2 integer,
    approval_user_id_3 integer,
    approval_user_id_4 integer,
    approval_user_id_5 integer,
    approval_ref_id bigint NOT NULL,
    rejected_note text,
    approval_current_user_id integer NOT NULL,
    approval_flow_id integer NOT NULL,
    is_approve boolean
);


ALTER TABLE public.approval_flow OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 31364)
-- Name: approval_flow_approval_flow_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.approval_flow_approval_flow_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.approval_flow_approval_flow_id_seq OWNER TO postgres;

--
-- TOC entry 3278 (class 0 OID 0)
-- Dependencies: 205
-- Name: approval_flow_approval_flow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.approval_flow_approval_flow_id_seq OWNED BY public.approval_flow.approval_flow_id;


--
-- TOC entry 206 (class 1259 OID 31366)
-- Name: approval_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.approval_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.approval_seq OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 31368)
-- Name: audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_log (
    created_at timestamp without time zone,
    created_by integer,
    user_id integer,
    path character varying,
    type character varying,
    data text,
    user_agent character varying,
    ip_address character varying,
    id bigint NOT NULL
);


ALTER TABLE public.audit_log OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 36777)
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_log_id_seq OWNER TO postgres;

--
-- TOC entry 3279 (class 0 OID 0)
-- Dependencies: 250
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_log_id_seq OWNED BY public.audit_log.id;


--
-- TOC entry 208 (class 1259 OID 31376)
-- Name: base_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.base_table (
    created_at timestamp with time zone,
    created_by integer,
    updated_at timestamp with time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1
);


ALTER TABLE public.base_table OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 31381)
-- Name: mst_customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mst_customer (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    mst_customer_id integer NOT NULL,
    mst_customer_name character varying NOT NULL,
    mst_customer_email character varying,
    mst_customer_phone character varying,
    mst_customer_address character varying,
    mst_customer_pic character varying,
    mst_customer_ppn character varying,
    price_percentage character varying
);


ALTER TABLE public.mst_customer OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 31389)
-- Name: mst_customer_mst_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mst_customer_mst_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mst_customer_mst_customer_id_seq OWNER TO postgres;

--
-- TOC entry 3280 (class 0 OID 0)
-- Dependencies: 210
-- Name: mst_customer_mst_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mst_customer_mst_customer_id_seq OWNED BY public.mst_customer.mst_customer_id;


--
-- TOC entry 211 (class 1259 OID 31391)
-- Name: mst_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mst_item (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    mst_item_id bigint NOT NULL,
    mst_item_no character varying NOT NULL,
    mst_item_name character varying NOT NULL,
    mst_item_desc text,
    mst_item_code character varying
);


ALTER TABLE public.mst_item OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 31399)
-- Name: mst_item_mst_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mst_item_mst_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mst_item_mst_item_id_seq OWNER TO postgres;

--
-- TOC entry 3281 (class 0 OID 0)
-- Dependencies: 212
-- Name: mst_item_mst_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mst_item_mst_item_id_seq OWNED BY public.mst_item.mst_item_id;


--
-- TOC entry 213 (class 1259 OID 31401)
-- Name: mst_item_variant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mst_item_variant (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    mst_item_variant_id integer NOT NULL,
    mst_item_id bigint,
    mst_item_variant_name character varying NOT NULL,
    mst_item_variant_price real,
    mst_item_variant_qty integer,
    mst_packaging_id integer NOT NULL,
    barcode character varying
);


ALTER TABLE public.mst_item_variant OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 31409)
-- Name: mst_item_variant_mst_item_variant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mst_item_variant_mst_item_variant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mst_item_variant_mst_item_variant_id_seq OWNER TO postgres;

--
-- TOC entry 3282 (class 0 OID 0)
-- Dependencies: 214
-- Name: mst_item_variant_mst_item_variant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mst_item_variant_mst_item_variant_id_seq OWNED BY public.mst_item_variant.mst_item_variant_id;


--
-- TOC entry 215 (class 1259 OID 31411)
-- Name: mst_packaging; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mst_packaging (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    mst_packaging_id integer NOT NULL,
    mst_packaging_code character varying NOT NULL,
    mst_packaging_name character varying,
    mst_packaging_desc text
);


ALTER TABLE public.mst_packaging OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 31419)
-- Name: mst_packaging_mst_packaging_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mst_packaging_mst_packaging_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mst_packaging_mst_packaging_id_seq OWNER TO postgres;

--
-- TOC entry 3283 (class 0 OID 0)
-- Dependencies: 216
-- Name: mst_packaging_mst_packaging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mst_packaging_mst_packaging_id_seq OWNED BY public.mst_packaging.mst_packaging_id;


--
-- TOC entry 217 (class 1259 OID 31421)
-- Name: mst_supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mst_supplier (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    mst_supplier_id integer NOT NULL,
    mst_supplier_name character varying,
    mst_supplier_email character varying,
    mst_supplier_address character varying,
    mst_supplier_phone character varying,
    mst_supplier_pic character varying
);


ALTER TABLE public.mst_supplier OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 31429)
-- Name: mst_supplier_mst_supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mst_supplier_mst_supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mst_supplier_mst_supplier_id_seq OWNER TO postgres;

--
-- TOC entry 3284 (class 0 OID 0)
-- Dependencies: 218
-- Name: mst_supplier_mst_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mst_supplier_mst_supplier_id_seq OWNED BY public.mst_supplier.mst_supplier_id;


--
-- TOC entry 221 (class 1259 OID 31452)
-- Name: pos_branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_branch (
    created_at timestamp with time zone,
    created_by integer,
    updated_at timestamp with time zone,
    updated_by integer,
    allow_return_day integer DEFAULT 1 NOT NULL,
    pos_branch_name character varying,
    pos_branch_desc text,
    pos_branch_address character varying,
    pos_branch_phone bigint,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    pos_branch_id integer NOT NULL,
    pos_branch_code character varying NOT NULL
);


ALTER TABLE public.pos_branch OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 37617)
-- Name: pos_branch_pos_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pos_branch_pos_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pos_branch_pos_branch_id_seq OWNER TO postgres;

--
-- TOC entry 3285 (class 0 OID 0)
-- Dependencies: 256
-- Name: pos_branch_pos_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pos_branch_pos_branch_id_seq OWNED BY public.pos_branch.pos_branch_id;


--
-- TOC entry 219 (class 1259 OID 31441)
-- Name: pos_cashier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_cashier (
    created_at timestamp with time zone,
    created_by integer,
    updated_at timestamp with time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    pos_cashier_id integer NOT NULL,
    pos_cashier_capital_cash character varying,
    pos_cashier_shift character varying,
    is_cashier_open boolean DEFAULT true NOT NULL,
    pos_cashier_number integer,
    pos_user_branch_id integer NOT NULL
);


ALTER TABLE public.pos_cashier OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 31450)
-- Name: pos_cashier_pos_cashier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pos_cashier_pos_cashier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pos_cashier_pos_cashier_id_seq OWNER TO postgres;

--
-- TOC entry 3286 (class 0 OID 0)
-- Dependencies: 220
-- Name: pos_cashier_pos_cashier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pos_cashier_pos_cashier_id_seq OWNED BY public.pos_cashier.pos_cashier_id;


--
-- TOC entry 222 (class 1259 OID 31461)
-- Name: pos_discount; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_discount (
    created_at timestamp with time zone,
    created_by integer,
    updated_at timestamp with time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    pos_discount_id integer NOT NULL,
    mst_item_variant_id bigint NOT NULL,
    discount integer,
    pos_discount_starttime timestamp without time zone NOT NULL,
    pos_discount_endtime timestamp without time zone NOT NULL,
    discount_min_qty integer DEFAULT 1 NOT NULL,
    discount_free_qty integer,
    pos_discount_code character varying,
    discount_max_qty integer,
    pos_branch_code character varying NOT NULL
);


ALTER TABLE public.pos_discount OWNER TO postgres;

--
-- TOC entry 3287 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN pos_discount.discount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pos_discount.discount IS 'Per seratus';


--
-- TOC entry 223 (class 1259 OID 31469)
-- Name: pos_discount_pos_discount_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pos_discount_pos_discount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pos_discount_pos_discount_id_seq OWNER TO postgres;

--
-- TOC entry 3288 (class 0 OID 0)
-- Dependencies: 223
-- Name: pos_discount_pos_discount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pos_discount_pos_discount_id_seq OWNED BY public.pos_discount.pos_discount_id;


--
-- TOC entry 224 (class 1259 OID 31471)
-- Name: pos_item_stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_item_stock (
    created_at timestamp with time zone,
    created_by integer,
    updated_at timestamp with time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    pos_item_stock_id integer NOT NULL,
    mst_item_id bigint NOT NULL,
    qty integer
);


ALTER TABLE public.pos_item_stock OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 31476)
-- Name: pos_item_stock_pos_item_stock_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pos_item_stock_pos_item_stock_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pos_item_stock_pos_item_stock_id_seq OWNER TO postgres;

--
-- TOC entry 3289 (class 0 OID 0)
-- Dependencies: 225
-- Name: pos_item_stock_pos_item_stock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pos_item_stock_pos_item_stock_id_seq OWNED BY public.pos_item_stock.pos_item_stock_id;


--
-- TOC entry 226 (class 1259 OID 31478)
-- Name: pos_receive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_receive (
    created_at timestamp with time zone,
    created_by integer,
    updated_at timestamp with time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 0,
    pos_receive_id bigint NOT NULL,
    mst_supplier_id bigint,
    mst_warehous_id bigint,
    pos_receive_note text,
    is_received boolean
);


ALTER TABLE public.pos_receive OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 31486)
-- Name: pos_receive_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_receive_detail (
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    pos_receive_detail_id integer NOT NULL,
    pos_receive_id bigint NOT NULL,
    mst_item_id bigint NOT NULL,
    batch_no character varying,
    mfg_date date NOT NULL,
    exp_date date NOT NULL,
    qty bigint NOT NULL,
    qty_stock bigint,
    mst_item_variant_id bigint NOT NULL,
    mst_item_variant_qty bigint NOT NULL
);


ALTER TABLE public.pos_receive_detail OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 31494)
-- Name: pos_receive_detail_pos_receive_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pos_receive_detail_pos_receive_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pos_receive_detail_pos_receive_detail_id_seq OWNER TO postgres;

--
-- TOC entry 3290 (class 0 OID 0)
-- Dependencies: 228
-- Name: pos_receive_detail_pos_receive_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pos_receive_detail_pos_receive_detail_id_seq OWNED BY public.pos_receive_detail.pos_receive_detail_id;


--
-- TOC entry 229 (class 1259 OID 31496)
-- Name: pos_trx_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_trx_detail (
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    pos_trx_ref_id bigint,
    mst_item_variant_id integer NOT NULL,
    qty integer NOT NULL,
    price double precision,
    pos_trx_detail_id bigint NOT NULL,
    mst_item_id bigint,
    pos_discount_id bigint,
    discount integer,
    total double precision,
    capital_price double precision,
    mst_item_variant_qty integer,
    qty_stock bigint,
    discount_min_qty integer,
    discount_max_qty integer,
    discount_free_qty integer
);


ALTER TABLE public.pos_trx_detail OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 31501)
-- Name: pos_sale_detail_pos_sale_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pos_sale_detail_pos_sale_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pos_sale_detail_pos_sale_detail_id_seq OWNER TO postgres;

--
-- TOC entry 3291 (class 0 OID 0)
-- Dependencies: 230
-- Name: pos_sale_detail_pos_sale_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pos_sale_detail_pos_sale_detail_id_seq OWNED BY public.pos_trx_detail.pos_trx_detail_id;


--
-- TOC entry 231 (class 1259 OID 31503)
-- Name: pos_trx_sale; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_trx_sale (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    pos_trx_sale_id bigint NOT NULL,
    mst_customer_id integer NOT NULL,
    total_price double precision,
    ppn character varying,
    price_percentage integer,
    is_paid boolean DEFAULT false NOT NULL,
    grand_total double precision,
    payment_type character varying
);


ALTER TABLE public.pos_trx_sale OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 31512)
-- Name: pos_sale_pos_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pos_sale_pos_sale_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pos_sale_pos_sale_id_seq OWNER TO postgres;

--
-- TOC entry 3292 (class 0 OID 0)
-- Dependencies: 232
-- Name: pos_sale_pos_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pos_sale_pos_sale_id_seq OWNED BY public.pos_trx_sale.pos_trx_sale_id;


--
-- TOC entry 253 (class 1259 OID 37254)
-- Name: pos_trx_destroy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_trx_destroy (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    total_price double precision,
    price_percentage integer,
    is_destroyed boolean,
    grand_total double precision,
    pos_trx_destroy_id bigint NOT NULL,
    pos_trx_destroy_note text
);


ALTER TABLE public.pos_trx_destroy OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 31514)
-- Name: pos_trx_inbound; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_trx_inbound (
    created_at timestamp with time zone,
    created_by integer,
    pos_trx_inbound_id bigint NOT NULL,
    pos_trx_inbound_type character varying NOT NULL,
    mst_supplier_id integer,
    mst_customer_id integer,
    mst_warehouse_id integer,
    pos_ref_id bigint,
    pos_ref_table character varying
);


ALTER TABLE public.pos_trx_inbound OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 37098)
-- Name: pos_trx_return; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_trx_return (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    pos_trx_sale_id bigint NOT NULL,
    mst_customer_id integer NOT NULL,
    total_price double precision,
    ppn character varying,
    price_percentage integer,
    is_returned boolean,
    grand_total double precision,
    payment_type character varying,
    pos_trx_return_id bigint NOT NULL
);


ALTER TABLE public.pos_trx_return OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 37581)
-- Name: pos_user_branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pos_user_branch (
    created_at timestamp with time zone,
    created_by integer,
    updated_at timestamp with time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    user_id integer NOT NULL,
    pos_user_branch_id integer NOT NULL,
    is_cashier boolean DEFAULT false,
    pos_branch_code character varying NOT NULL
);


ALTER TABLE public.pos_user_branch OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 37579)
-- Name: pos_user_branch_pos_user_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pos_user_branch_pos_user_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pos_user_branch_pos_user_branch_id_seq OWNER TO postgres;

--
-- TOC entry 3293 (class 0 OID 0)
-- Dependencies: 254
-- Name: pos_user_branch_pos_user_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pos_user_branch_pos_user_branch_id_seq OWNED BY public.pos_user_branch.pos_user_branch_id;


--
-- TOC entry 234 (class 1259 OID 31539)
-- Name: sys_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_configuration (
    updated_at timestamp without time zone,
    id integer NOT NULL,
    app_name character varying,
    app_logo text,
    user_name character varying,
    user_password character varying,
    multi_login integer,
    expired_token integer,
    barcode_config text
);


ALTER TABLE public.sys_configuration OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 31547)
-- Name: sys_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_menu (
    status integer DEFAULT 1,
    sys_menu_id integer NOT NULL,
    sys_menu_name character varying,
    sys_menu_url character varying,
    sys_menu_icon character varying,
    sys_menu_parent_id integer,
    sys_menu_order real,
    sys_menu_module_id integer NOT NULL
);


ALTER TABLE public.sys_menu OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 31880)
-- Name: sys_menu_module; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_menu_module (
    status integer DEFAULT 1,
    sys_menu_module_id integer NOT NULL,
    sys_menu_module_name character varying NOT NULL,
    sys_menu_module_code character varying,
    sys_menu_module_icon character varying
);


ALTER TABLE public.sys_menu_module OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 31878)
-- Name: sys_menu_module_sys_menu_module_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sys_menu_module_sys_menu_module_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sys_menu_module_sys_menu_module_id_seq OWNER TO postgres;

--
-- TOC entry 3294 (class 0 OID 0)
-- Dependencies: 247
-- Name: sys_menu_module_sys_menu_module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sys_menu_module_sys_menu_module_id_seq OWNED BY public.sys_menu_module.sys_menu_module_id;


--
-- TOC entry 236 (class 1259 OID 31554)
-- Name: sys_relation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_relation (
    sys_relation_code character varying NOT NULL,
    sys_relation_ref_id bigint,
    sys_relation_desc text,
    sys_relation_name character varying NOT NULL,
    sys_relation_id smallint NOT NULL
);


ALTER TABLE public.sys_relation OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 36839)
-- Name: sys_relation_sys_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sys_relation_sys_relation_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sys_relation_sys_relation_id_seq OWNER TO postgres;

--
-- TOC entry 3295 (class 0 OID 0)
-- Dependencies: 251
-- Name: sys_relation_sys_relation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sys_relation_sys_relation_id_seq OWNED BY public.sys_relation.sys_relation_id;


--
-- TOC entry 237 (class 1259 OID 31560)
-- Name: sys_role_section; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_role_section (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    status integer DEFAULT 1,
    sys_menu_id integer NOT NULL,
    user_section_id integer,
    flag_read integer,
    flag_create integer,
    flag_update integer,
    flag_delete integer,
    flag_print integer,
    flag_download integer,
    sys_role_section_id integer NOT NULL
);


ALTER TABLE public.sys_role_section OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 31564)
-- Name: sys_role_section_role_section_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sys_role_section_role_section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sys_role_section_role_section_id_seq OWNER TO postgres;

--
-- TOC entry 3296 (class 0 OID 0)
-- Dependencies: 238
-- Name: sys_role_section_role_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sys_role_section_role_section_id_seq OWNED BY public.sys_role_section.sys_role_section_id;


--
-- TOC entry 239 (class 1259 OID 31566)
-- Name: sys_status_information; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_status_information (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    status_id integer NOT NULL,
    status_description character varying
);


ALTER TABLE public.sys_status_information OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 31574)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    user_id integer NOT NULL,
    user_name character varying NOT NULL,
    user_email character varying NOT NULL,
    user_password character varying NOT NULL,
    user_section_id integer NOT NULL,
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 31582)
-- Name: user_authentication; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_authentication (
    created_at timestamp without time zone,
    status integer DEFAULT 1,
    user_id integer NOT NULL,
    token character varying NOT NULL,
    expired_at timestamp without time zone,
    user_agent character varying,
    authentication_id integer NOT NULL
);


ALTER TABLE public.user_authentication OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 36754)
-- Name: user_authentication_authentication_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_authentication_authentication_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_authentication_authentication_id_seq OWNER TO postgres;

--
-- TOC entry 3297 (class 0 OID 0)
-- Dependencies: 249
-- Name: user_authentication_authentication_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_authentication_authentication_id_seq OWNED BY public.user_authentication.authentication_id;


--
-- TOC entry 242 (class 1259 OID 31590)
-- Name: user_department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_department (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    user_department_id integer NOT NULL,
    user_department_name character varying,
    user_department_code character varying
);


ALTER TABLE public.user_department OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 31598)
-- Name: user_department_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_department_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_department_department_id_seq OWNER TO postgres;

--
-- TOC entry 3298 (class 0 OID 0)
-- Dependencies: 243
-- Name: user_department_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_department_department_id_seq OWNED BY public.user_department.user_department_id;


--
-- TOC entry 244 (class 1259 OID 31600)
-- Name: user_section; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_section (
    created_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    user_section_id integer NOT NULL,
    user_department_id integer NOT NULL,
    user_section_code character varying,
    user_section_name character varying
);


ALTER TABLE public.user_section OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 31608)
-- Name: user_section_section_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_section_section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_section_section_id_seq OWNER TO postgres;

--
-- TOC entry 3299 (class 0 OID 0)
-- Dependencies: 245
-- Name: user_section_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_section_section_id_seq OWNED BY public.user_section.user_section_id;


--
-- TOC entry 246 (class 1259 OID 31610)
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_user_id_seq OWNER TO postgres;

--
-- TOC entry 3300 (class 0 OID 0)
-- Dependencies: 246
-- Name: user_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_user_id_seq OWNED BY public."user".user_id;


--
-- TOC entry 2883 (class 2604 OID 31612)
-- Name: approval approval_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval ALTER COLUMN approval_id SET DEFAULT nextval('public.approval_approval_id_seq'::regclass);


--
-- TOC entry 2885 (class 2604 OID 31613)
-- Name: approval_flow approval_flow_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_flow ALTER COLUMN approval_flow_id SET DEFAULT nextval('public.approval_flow_approval_flow_id_seq'::regclass);


--
-- TOC entry 2886 (class 2604 OID 36779)
-- Name: audit_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log ALTER COLUMN id SET DEFAULT nextval('public.audit_log_id_seq'::regclass);


--
-- TOC entry 2891 (class 2604 OID 31614)
-- Name: mst_customer mst_customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_customer ALTER COLUMN mst_customer_id SET DEFAULT nextval('public.mst_customer_mst_customer_id_seq'::regclass);


--
-- TOC entry 2896 (class 2604 OID 31615)
-- Name: mst_item_variant mst_item_variant_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_item_variant ALTER COLUMN mst_item_variant_id SET DEFAULT nextval('public.mst_item_variant_mst_item_variant_id_seq'::regclass);


--
-- TOC entry 2899 (class 2604 OID 31616)
-- Name: mst_packaging mst_packaging_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_packaging ALTER COLUMN mst_packaging_id SET DEFAULT nextval('public.mst_packaging_mst_packaging_id_seq'::regclass);


--
-- TOC entry 2902 (class 2604 OID 31617)
-- Name: mst_supplier mst_supplier_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_supplier ALTER COLUMN mst_supplier_id SET DEFAULT nextval('public.mst_supplier_mst_supplier_id_seq'::regclass);


--
-- TOC entry 2909 (class 2604 OID 37619)
-- Name: pos_branch pos_branch_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_branch ALTER COLUMN pos_branch_id SET DEFAULT nextval('public.pos_branch_pos_branch_id_seq'::regclass);


--
-- TOC entry 2906 (class 2604 OID 31619)
-- Name: pos_cashier pos_cashier_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_cashier ALTER COLUMN pos_cashier_id SET DEFAULT nextval('public.pos_cashier_pos_cashier_id_seq'::regclass);


--
-- TOC entry 2913 (class 2604 OID 31621)
-- Name: pos_discount pos_discount_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_discount ALTER COLUMN pos_discount_id SET DEFAULT nextval('public.pos_discount_pos_discount_id_seq'::regclass);


--
-- TOC entry 2917 (class 2604 OID 31622)
-- Name: pos_item_stock pos_item_stock_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_item_stock ALTER COLUMN pos_item_stock_id SET DEFAULT nextval('public.pos_item_stock_pos_item_stock_id_seq'::regclass);


--
-- TOC entry 2922 (class 2604 OID 31623)
-- Name: pos_receive_detail pos_receive_detail_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_receive_detail ALTER COLUMN pos_receive_detail_id SET DEFAULT nextval('public.pos_receive_detail_pos_receive_detail_id_seq'::regclass);


--
-- TOC entry 2925 (class 2604 OID 31624)
-- Name: pos_trx_detail pos_trx_detail_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_detail ALTER COLUMN pos_trx_detail_id SET DEFAULT nextval('public.pos_sale_detail_pos_sale_detail_id_seq'::regclass);


--
-- TOC entry 2954 (class 2604 OID 37586)
-- Name: pos_user_branch pos_user_branch_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_user_branch ALTER COLUMN pos_user_branch_id SET DEFAULT nextval('public.pos_user_branch_pos_user_branch_id_seq'::regclass);


--
-- TOC entry 2947 (class 2604 OID 31884)
-- Name: sys_menu_module sys_menu_module_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_menu_module ALTER COLUMN sys_menu_module_id SET DEFAULT nextval('public.sys_menu_module_sys_menu_module_id_seq'::regclass);


--
-- TOC entry 2930 (class 2604 OID 36841)
-- Name: sys_relation sys_relation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_relation ALTER COLUMN sys_relation_id SET DEFAULT nextval('public.sys_relation_sys_relation_id_seq'::regclass);


--
-- TOC entry 2932 (class 2604 OID 31626)
-- Name: sys_role_section sys_role_section_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_role_section ALTER COLUMN sys_role_section_id SET DEFAULT nextval('public.sys_role_section_role_section_id_seq'::regclass);


--
-- TOC entry 2937 (class 2604 OID 31627)
-- Name: user user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN user_id SET DEFAULT nextval('public.user_user_id_seq'::regclass);


--
-- TOC entry 2939 (class 2604 OID 36756)
-- Name: user_authentication authentication_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_authentication ALTER COLUMN authentication_id SET DEFAULT nextval('public.user_authentication_authentication_id_seq'::regclass);


--
-- TOC entry 2942 (class 2604 OID 31628)
-- Name: user_department user_department_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_department ALTER COLUMN user_department_id SET DEFAULT nextval('public.user_department_department_id_seq'::regclass);


--
-- TOC entry 2945 (class 2604 OID 31629)
-- Name: user_section user_section_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_section ALTER COLUMN user_section_id SET DEFAULT nextval('public.user_section_section_id_seq'::regclass);


--
-- TOC entry 3216 (class 0 OID 31347)
-- Dependencies: 202
-- Data for Name: approval; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.approval (created_at, created_by, updated_at, updated_by, flag_delete, status, approval_id, approval_ref_table, approval_desc, approval_user_id_1, approval_user_id_2, approval_user_id_3, approval_user_id_4, approval_user_id_5) FROM stdin;
2022-07-26 03:13:07	0	\N	\N	0	1	25	user	User Approval	1	\N	\N	\N	\N
2022-07-26 03:15:23	0	2022-07-26 03:33:54	0	0	1	26	user_section	User Section	1	\N	\N	\N	\N
2022-07-26 04:14:20	0	\N	\N	0	1	27	mst_customer	Customer	1	\N	\N	\N	\N
2022-08-10 03:07:44	0	\N	\N	0	1	28	pos_discount	POS Discount	1	\N	\N	\N	\N
\.


--
-- TOC entry 3218 (class 0 OID 31357)
-- Dependencies: 204
-- Data for Name: approval_flow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.approval_flow (created_at, created_by, updated_at, updated_by, flag_delete, approval_ref_table, approval_desc, approval_user_id_1, approval_user_id_2, approval_user_id_3, approval_user_id_4, approval_user_id_5, approval_ref_id, rejected_note, approval_current_user_id, approval_flow_id, is_approve) FROM stdin;
\N	0	2022-07-26 03:20:59	0	0	user_section	User Section	1	\N	\N	\N	\N	7	Yes	1	36	t
\N	0	\N	\N	0	mst_customer	Customer	1	\N	\N	\N	\N	3	\N	1	38	\N
\N	0	2022-07-27 04:00:40	0	0	user_section	User Section	1	\N	\N	\N	\N	10	ERre	1	37	t
\N	1	2022-07-27 04:15:45	1	0	user_section	User Section	1	\N	\N	\N	\N	11		1	39	t
\N	0	2022-08-10 03:09:42	0	0	pos_discount	POS Discount	1	\N	\N	\N	\N	42	5ere	1	40	f
\N	0	2022-08-23 09:43:06	0	0	pos_discount	POS Discount	1	\N	\N	\N	\N	44		1	41	t
\N	0	\N	\N	0	pos_discount	POS Discount	1	\N	\N	\N	\N	46	\N	1	43	\N
\N	0	2022-08-23 03:53:22	0	0	pos_discount	POS Discount	1	\N	\N	\N	\N	45		1	42	t
\.


--
-- TOC entry 3221 (class 0 OID 31368)
-- Dependencies: 207
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_log (created_at, created_by, user_id, path, type, data, user_agent, ip_address, id) FROM stdin;
2022-07-27 16:24:46	\N	1	/api/master/user	POST	{"user_name":"sada","user_email":"asda@gmail.com","user_department_id":1,"user_section_id":1,"status":1,"user_id":"32","updated_by":1,"updated_at":"2022-07-27 16:24:46"}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	::ffff:127.0.0.1	6
2022-07-27 16:25:12	\N	1	/api/master/user	POST	{"user_name":"sada","user_email":"asda@gmail.com","user_department_id":1,"user_section_id":1,"status":1,"user_id":"32","updated_by":1,"updated_at":"2022-07-27 16:25:12"}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	::ffff:127.0.0.1	7
2022-08-23 09:52:05	\N	32	/api/master/pos/discount	PUT	{"discount_free_qty":0,"discount_max_qty":0,"discount_min_qty":1,"discount":13,"status":1,"pos_branch_id":5,"mst_item_variant_id":29,"date_time":["2022-08-02T02:51:52.724Z","2022-08-31T02:51:55.724Z"],"pos_discount_starttime":"2022-08-02 09:51:52","pos_discount_endtime":"2022-08-31 09:51:55","created_by":32,"created_at":"2022-08-23 09:52:05"}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36	::ffff:127.0.0.1	8
2022-08-23 14:06:29	\N	32	/api/master/pos/user-branch	PUT	{"pos_branch_id":1,"user_id":1,"status":1,"is_cashier":true,"created_by":32,"created_at":"2022-08-23 14:06:29"}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36	::ffff:127.0.0.1	9
2022-08-23 14:06:51	\N	32	/api/master/pos/user-branch	PUT	{"pos_branch_id":1,"user_id":1,"status":1,"is_cashier":true,"created_by":32,"created_at":"2022-08-23 14:06:51"}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36	::ffff:127.0.0.1	10
2022-08-23 14:07:15	\N	32	/api/master/pos/user-branch	PUT	{"pos_branch_id":1,"user_id":1,"status":1,"is_cashier":true,"pos_branch_code":"AMD2","created_by":32,"created_at":"2022-08-23 14:07:15"}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36	::ffff:127.0.0.1	11
2022-08-23 14:08:29	\N	32	/api/master/pos/user-branch	POST	{"created_at":"2022-06-15T02:00:36.000Z","created_by":0,"updated_at":"2022-08-23 14:08:29","updated_by":32,"flag_delete":0,"status":1,"user_id":1,"pos_user_branch_id":21,"is_cashier":false,"pos_branch_code":"AMD2","user_name":"gesang","user_email":"gesangseto@gmail.com","user_password":"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92","user_section_id":1,"approval":null}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36	::ffff:127.0.0.1	12
2022-08-23 14:08:58	\N	32	/api/master/pos/user-branch	PUT	{"pos_branch_id":3,"user_id":32,"status":1,"is_cashier":true,"pos_branch_code":"AMD3","created_by":32,"created_at":"2022-08-23 14:08:58"}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36	::ffff:127.0.0.1	13
2022-08-23 14:10:19	\N	32	/api/master/pos/user-branch	PUT	{"pos_branch_id":3,"user_id":1,"status":1,"is_cashier":false,"pos_branch_code":"AMD3","created_by":32,"created_at":"2022-08-23 14:10:19"}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36	::ffff:127.0.0.1	14
2022-08-23 15:19:02	\N	32	/api/master/pos/discount	PUT	{"discount_free_qty":0,"discount_max_qty":0,"discount_min_qty":0,"discount":5,"status":1,"pos_branch_id":3,"mst_item_variant_id":29,"date_time":["2022-08-01T08:18:48.932Z","2022-08-31T08:18:51.932Z"],"pos_discount_starttime":"2022-08-01 15:18:48","pos_discount_endtime":"2022-08-31 15:18:51","created_by":32,"created_at":"2022-08-23 15:19:02"}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36	::ffff:127.0.0.1	15
2022-08-23 16:02:44	\N	32	/api/master/pos/discount	POST	{"pos_discount_id":46,"mst_item_variant_id":"29","discount":5,"pos_discount_starttime":"2022-08-01 03:18:48","pos_discount_endtime":"2022-08-31 03:18:51","discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"pos_branch_code":"AMD3","status":0,"flag_delete":0,"mst_item_variant_name":"@1","barcode":"33334","mst_item_name":"Ultramilk Kids Strawbery 120 ML","approval":{"created_at":null,"created_by":0,"updated_at":null,"updated_by":null,"flag_delete":0,"approval_ref_table":"pos_discount","approval_desc":"POS Discount","approval_user_id_1":1,"approval_user_id_2":null,"approval_user_id_3":null,"approval_user_id_4":null,"approval_user_id_5":null,"approval_ref_id":"46","rejected_note":null,"approval_current_user_id":1,"is_approve":null,"approval_user_name":"gesang","approval_user_email":"gesangseto@gmail.com"},"date_time":["2022-07-31T20:18:48.000Z","2022-08-30T20:18:51.000Z"],"updated_by":32,"updated_at":"2022-08-23 16:02:44"}	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36	::ffff:127.0.0.1	16
\.


--
-- TOC entry 3222 (class 0 OID 31376)
-- Dependencies: 208
-- Data for Name: base_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_table (created_at, created_by, updated_at, updated_by, flag_delete, status) FROM stdin;
\.


--
-- TOC entry 3223 (class 0 OID 31381)
-- Dependencies: 209
-- Data for Name: mst_customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mst_customer (created_at, created_by, updated_at, updated_by, flag_delete, status, mst_customer_id, mst_customer_name, mst_customer_email, mst_customer_phone, mst_customer_address, mst_customer_pic, mst_customer_ppn, price_percentage) FROM stdin;
2022-07-26 16:13:32	0	2022-07-26 16:13:40	0	0	1	2	ewq	wqeq@sda	123131	1231dsaed	sda	12	1234
2022-07-26 16:14:37	0	\N	\N	0	1	3	Test	gesang@gmail.com	08215415412sa	da	Test	12	12
2022-06-30 11:02:30	0	2022-08-02 11:51:34	0	0	1	1	Guest	admin@admin.com	082122222657	JL Bambu	Gesang	10	12
\.


--
-- TOC entry 3225 (class 0 OID 31391)
-- Dependencies: 211
-- Data for Name: mst_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mst_item (created_at, created_by, updated_at, updated_by, flag_delete, status, mst_item_id, mst_item_no, mst_item_name, mst_item_desc, mst_item_code) FROM stdin;
2022-07-30 08:47:50	0	2022-07-30 08:48:20	0	0	1	1659145670680	INDMIES	Indomie Soto	-	INDMIES
2022-08-08 10:28:49	0	\N	\N	0	1	1659929329253	BCG1	Ultramilk Kids Coklat 120ML	-	BCG1
2022-08-08 10:30:11	0	\N	\N	0	1	1659929411583	BCG2	Ultramilk Kids Strawbery 120 ML	-	BCG2
2022-06-29 04:46:14	0	2022-08-11 03:13:47	0	0	1	1656477974626	DJS12	Djarum Super @12	-	DJS12
\.


--
-- TOC entry 3227 (class 0 OID 31401)
-- Dependencies: 213
-- Data for Name: mst_item_variant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mst_item_variant (created_at, created_by, updated_at, updated_by, flag_delete, status, mst_item_variant_id, mst_item_id, mst_item_variant_name, mst_item_variant_price, mst_item_variant_qty, mst_packaging_id, barcode) FROM stdin;
2022-06-27 11:28:53	0	2022-07-30 08:39:09	0	0	1	23	1659145670680	Bungkus	2500	1	1	11111
2022-07-30 08:39:35	0	\N	\N	0	1	24	1659145670680	Dus	90000	40	1	22222
\N	\N	\N	\N	0	1	29	1659929411583	@1	2450	1	1	33334
\N	\N	\N	\N	0	1	30	1659929411583	@24	124500	24	9	44443
\N	\N	\N	\N	1	1	27	1659929329253	-	2400	1	1	33333
\N	\N	\N	\N	1	1	28	1659929329253	-	124000	24	9	44444
2022-07-30 08:39:35	0	2022-07-30 08:39:09	0	0	1	22	1656477974626	Selop	200000	12	8	8994171101289
2022-06-27 11:28:53	0	2022-07-30 08:39:09	0	0	1	20	1656477974626	Pack	20000	1	1	123456
\.


--
-- TOC entry 3229 (class 0 OID 31411)
-- Dependencies: 215
-- Data for Name: mst_packaging; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mst_packaging (created_at, created_by, updated_at, updated_by, flag_delete, status, mst_packaging_id, mst_packaging_code, mst_packaging_name, mst_packaging_desc) FROM stdin;
2022-06-27 11:28:53	0	2022-07-30 08:39:09	0	0	1	1	Bks	bungkus	Nothing
2022-07-30 08:39:35	0	\N	\N	0	1	8	Slop	Selop	-
2022-07-30 08:48:06	0	\N	\N	0	1	9	Dus	Dus	-
\.


--
-- TOC entry 3231 (class 0 OID 31421)
-- Dependencies: 217
-- Data for Name: mst_supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mst_supplier (created_at, created_by, updated_at, updated_by, flag_delete, status, mst_supplier_id, mst_supplier_name, mst_supplier_email, mst_supplier_address, mst_supplier_phone, mst_supplier_pic) FROM stdin;
2022-06-30 10:55:18	0	2022-07-27 16:24:29	0	0	1	1	Agen Erna	admin@admin.com	JL Bambu	082122222657	Gesang
\.


--
-- TOC entry 3235 (class 0 OID 31452)
-- Dependencies: 221
-- Data for Name: pos_branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_branch (created_at, created_by, updated_at, updated_by, allow_return_day, pos_branch_name, pos_branch_desc, pos_branch_address, pos_branch_phone, flag_delete, status, pos_branch_id, pos_branch_code) FROM stdin;
2022-08-19 01:36:46+07	0	2022-08-22 10:19:59+07	0	1	AMD - 2	Test	JL.Bambu	82122222657	0	1	1	AMD2
2022-08-23 09:40:04+07	0	\N	\N	0	Tes2	123	kljljasfd	854541212	0	1	8	ASC
2022-08-22 10:18:49+07	0	2022-08-23 03:56:07+07	0	1	Bambu 	No 53 my home	JL Bambu	82122222657	0	1	5	AMD1
2022-08-19 04:08:55+07	0	2022-08-23 03:56:15+07	0	1	AMD - 1	Cabang tangerang	JL.Bambu	895545646	0	0	3	AMD3
\.


--
-- TOC entry 3233 (class 0 OID 31441)
-- Dependencies: 219
-- Data for Name: pos_cashier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_cashier (created_at, created_by, updated_at, updated_by, flag_delete, status, pos_cashier_id, pos_cashier_capital_cash, pos_cashier_shift, is_cashier_open, pos_cashier_number, pos_user_branch_id) FROM stdin;
\.


--
-- TOC entry 3236 (class 0 OID 31461)
-- Dependencies: 222
-- Data for Name: pos_discount; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_discount (created_at, created_by, updated_at, updated_by, flag_delete, status, pos_discount_id, mst_item_variant_id, discount, pos_discount_starttime, pos_discount_endtime, discount_min_qty, discount_free_qty, pos_discount_code, discount_max_qty, pos_branch_code) FROM stdin;
2022-08-19 01:36:46+07	0	2022-08-23 09:44:52+07	0	0	1	44	20	12	2022-01-02 12:00:00	2022-10-03 12:00:00	1	\N	null	\N	AMD2
2022-08-23 15:19:02+07	32	\N	\N	0	0	46	29	5	2022-08-01 03:18:48	2022-08-31 03:18:51	0	0	\N	0	AMD3
2022-08-23 09:52:05+07	32	2022-08-23 03:53:24+07	0	0	1	45	29	13	2022-08-02 09:51:52	2022-08-31 09:51:55	1	0	\N	0	AMD2
\.


--
-- TOC entry 3238 (class 0 OID 31471)
-- Dependencies: 224
-- Data for Name: pos_item_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_item_stock (created_at, created_by, updated_at, updated_by, flag_delete, status, pos_item_stock_id, mst_item_id, qty) FROM stdin;
2022-06-29 04:46:14+07	0	2022-08-11 03:13:47+07	0	0	1	55	1656477974626	15
2022-07-30 08:47:50+07	0	2022-07-30 08:48:20+07	0	0	1	56	1659145670680	221
\.


--
-- TOC entry 3240 (class 0 OID 31478)
-- Dependencies: 226
-- Data for Name: pos_receive; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_receive (created_at, created_by, updated_at, updated_by, flag_delete, status, pos_receive_id, mst_supplier_id, mst_warehous_id, pos_receive_note, is_received) FROM stdin;
2022-08-12 11:19:49+07	0	\N	\N	0	1	1660277989736	1	\N	-	t
2022-08-12 11:24:05+07	0	\N	\N	0	1	1660278245422	1	\N	-	t
\.


--
-- TOC entry 3241 (class 0 OID 31486)
-- Dependencies: 227
-- Data for Name: pos_receive_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_receive_detail (flag_delete, status, pos_receive_detail_id, pos_receive_id, mst_item_id, batch_no, mfg_date, exp_date, qty, qty_stock, mst_item_variant_id, mst_item_variant_qty) FROM stdin;
0	1	110	1660277989736	1656477974626		2022-08-12	2025-08-12	15	15	20	1
0	1	111	1660277989736	1659145670680		2022-08-12	2025-08-12	5	200	24	40
0	1	112	1660278245422	1659145670680		2022-08-12	2025-08-12	21	21	23	1
\.


--
-- TOC entry 3267 (class 0 OID 37254)
-- Dependencies: 253
-- Data for Name: pos_trx_destroy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_trx_destroy (created_at, created_by, updated_at, updated_by, flag_delete, status, total_price, price_percentage, is_destroyed, grand_total, pos_trx_destroy_id, pos_trx_destroy_note) FROM stdin;
\.


--
-- TOC entry 3243 (class 0 OID 31496)
-- Dependencies: 229
-- Data for Name: pos_trx_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_trx_detail (updated_at, updated_by, flag_delete, status, pos_trx_ref_id, mst_item_variant_id, qty, price, pos_trx_detail_id, mst_item_id, pos_discount_id, discount, total, capital_price, mst_item_variant_qty, qty_stock, discount_min_qty, discount_max_qty, discount_free_qty) FROM stdin;
\.


--
-- TOC entry 3247 (class 0 OID 31514)
-- Dependencies: 233
-- Data for Name: pos_trx_inbound; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_trx_inbound (created_at, created_by, pos_trx_inbound_id, pos_trx_inbound_type, mst_supplier_id, mst_customer_id, mst_warehouse_id, pos_ref_id, pos_ref_table) FROM stdin;
2022-08-12 11:19:49+07	0	1660278185886	receive	1	\N	\N	1660277989736	pos_receive
2022-08-12 11:24:05+07	0	1660278251996	receive	1	\N	\N	1660278245422	pos_receive
\.


--
-- TOC entry 3266 (class 0 OID 37098)
-- Dependencies: 252
-- Data for Name: pos_trx_return; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_trx_return (created_at, created_by, updated_at, updated_by, flag_delete, status, pos_trx_sale_id, mst_customer_id, total_price, ppn, price_percentage, is_returned, grand_total, payment_type, pos_trx_return_id) FROM stdin;
\.


--
-- TOC entry 3245 (class 0 OID 31503)
-- Dependencies: 231
-- Data for Name: pos_trx_sale; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_trx_sale (created_at, created_by, updated_at, updated_by, flag_delete, status, pos_trx_sale_id, mst_customer_id, total_price, ppn, price_percentage, is_paid, grand_total, payment_type) FROM stdin;
\.


--
-- TOC entry 3269 (class 0 OID 37581)
-- Dependencies: 255
-- Data for Name: pos_user_branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pos_user_branch (created_at, created_by, updated_at, updated_by, flag_delete, status, user_id, pos_user_branch_id, is_cashier, pos_branch_code) FROM stdin;
2022-06-15 09:00:36+07	0	2022-08-23 02:08:29+07	32	0	1	1	21	f	AMD2
2022-08-23 14:10:19+07	32	\N	\N	0	1	1	23	f	AMD3
2022-07-19 03:20:23+07	0	2022-08-23 04:00:23+07	0	0	0	32	22	t	AMD3
\.


--
-- TOC entry 3248 (class 0 OID 31539)
-- Dependencies: 234
-- Data for Name: sys_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_configuration (updated_at, id, app_name, app_logo, user_name, user_password, multi_login, expired_token, barcode_config) FROM stdin;
2022-08-11 03:15:12	1	ERP	data:image/jpeg;base64,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	super_admin	a075d17f3d453073853f813838c15b8023b8c487038436354fe599c3942e1f95	1	30	{"text":"","bcid":"ean13","includetext":true,"height":13,"scale":3,"textxalign":"center"}
\.


--
-- TOC entry 3249 (class 0 OID 31547)
-- Dependencies: 235
-- Data for Name: sys_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_menu (status, sys_menu_id, sys_menu_name, sys_menu_url, sys_menu_icon, sys_menu_parent_id, sys_menu_order, sys_menu_module_id) FROM stdin;
1	1	Dashboard	/Dashboard	FundOutlined	\N	1	1
1	2	Master	/Master	HddOutlined	\N	2	1
1	5	Department	/Master/Department		2	2.1	1
1	6	Role	/Master/Role		2	2.4	1
1	3	User	/Master/User	\N	2	2.3	1
1	4	Section	/Master/Section		2	2.2	1
1	10	Customer	/Masterdata/Customer	\N	9	3.1	1
1	9	Master data	/Masterdata	FolderOpenOutlined	\N	3	1
1	12	Packaging	/Masterdata/Packaging	\N	9	3.3	1
1	11	Supplier	/Masterdata/Supplier	\N	9	3.2	1
1	111	Receive	/pos/transaction/receive		110	111	2
1	13	Product / Item	/Masterdata/item	\N	9	3.4	1
1	112	Inbound	/pos/transaction/inbound		110	112	2
1	8	Workflow Approval	/System/Approval	\N	7	4.1	1
1	7	System	/System	SettingOutlined	\N	4	1
1	14	Audit	/System/Audit	\N	7	4.2	1
1	113	Sale	/pos/transaction/sale		110	113	2
1	114	Return	/pos/transaction/return		110	114	2
1	115	Destroy	/pos/transaction/destroy		110	115	2
1	120	Stock	/pos/transaction/stock	ContainerOutlined	\N	120	2
1	130	Report	/pos/report	FileTextOutlined	\N	130	2
1	15	Config Relation	/System/Config-Relation	\N	7	4.3	1
1	131	Sale	/pos/report/sale		130	131	2
1	101	Branch	/pos/master/branch		100	101	2
1	103	Discount	/pos/master/discount		100	103	2
1	100	Master	/pos/master	FolderOpenOutlined	\N	100	2
1	110	Transaction	/pos/transaction	FundOutlined	\N	110	2
1	102	User Branch	/pos/master/user-branch		100	102	2
\.


--
-- TOC entry 3262 (class 0 OID 31880)
-- Dependencies: 248
-- Data for Name: sys_menu_module; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_menu_module (status, sys_menu_module_id, sys_menu_module_name, sys_menu_module_code, sys_menu_module_icon) FROM stdin;
1	2	Point Of Sales	POS	\N
1	1	Administrator	ADM	BarChartOutlined
\.


--
-- TOC entry 3250 (class 0 OID 31554)
-- Dependencies: 236
-- Data for Name: sys_relation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_relation (sys_relation_code, sys_relation_ref_id, sys_relation_desc, sys_relation_name, sys_relation_id) FROM stdin;
mst_customer_default	1	Default Customer Point Of Sales	Customer Default	2
\.


--
-- TOC entry 3251 (class 0 OID 31560)
-- Dependencies: 237
-- Data for Name: sys_role_section; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_role_section (created_at, created_by, updated_at, updated_by, status, sys_menu_id, user_section_id, flag_read, flag_create, flag_update, flag_delete, flag_print, flag_download, sys_role_section_id) FROM stdin;
\N	\N	\N	\N	1	104	1	1	0	0	0	0	0	107
\N	\N	\N	\N	1	105	1	1	0	0	0	0	0	108
\N	\N	\N	\N	1	1	1	1	1	1	1	0	0	37
\N	\N	\N	\N	1	2	1	0	0	0	0	0	0	36
\N	\N	\N	\N	1	5	1	1	1	1	1	0	0	32
\N	\N	\N	\N	1	4	1	1	1	1	1	0	0	31
\N	\N	\N	\N	1	3	1	1	1	1	1	0	0	34
\N	\N	\N	\N	1	6	1	1	1	1	1	0	0	33
\N	\N	\N	\N	1	9	1	0	0	0	0	0	0	91
\N	\N	\N	\N	1	7	1	0	0	0	0	0	0	96
\N	\N	\N	\N	1	8	1	0	0	0	0	0	0	97
\N	\N	\N	\N	1	14	1	0	0	0	0	0	0	98
\N	\N	\N	\N	1	15	1	0	0	0	0	0	0	99
\N	\N	\N	\N	1	100	1	0	0	0	0	0	0	100
\N	\N	\N	\N	1	110	1	0	0	0	0	0	0	101
\N	\N	\N	\N	1	130	1	0	0	0	0	0	0	102
\N	\N	\N	\N	1	10	1	1	1	1	1	0	0	92
\N	\N	\N	\N	1	11	1	1	1	1	1	0	0	93
\N	\N	\N	\N	1	12	1	1	1	1	1	0	0	94
\N	\N	\N	\N	1	13	1	1	1	1	1	0	0	95
\N	\N	\N	\N	1	101	1	1	1	1	1	0	0	104
\N	\N	\N	\N	1	102	1	1	1	1	1	0	0	105
\N	\N	\N	\N	1	103	1	1	1	1	1	0	0	106
\N	\N	\N	\N	1	111	1	1	1	1	1	0	0	111
\N	\N	\N	\N	1	1	7	0	0	0	0	0	0	39
\N	\N	\N	\N	1	2	7	0	0	0	0	0	0	40
\N	\N	\N	\N	1	5	7	0	0	0	0	0	0	41
\N	\N	\N	\N	1	4	7	0	0	0	0	0	0	42
\N	\N	\N	\N	1	112	1	1	1	1	1	0	0	112
\N	\N	\N	\N	1	113	1	1	1	1	1	0	0	109
\N	\N	\N	\N	1	114	1	1	1	1	1	0	0	113
\N	\N	\N	\N	1	115	1	1	1	1	1	0	0	114
\N	\N	\N	\N	1	120	1	1	1	1	1	0	0	110
\N	\N	\N	\N	1	131	1	1	1	1	1	0	0	103
\N	\N	\N	\N	1	3	7	0	0	0	0	0	0	43
\N	\N	\N	\N	1	6	7	0	0	0	0	0	0	44
\N	\N	\N	\N	1	9	7	0	0	0	0	0	0	45
\N	\N	\N	\N	1	10	7	0	0	0	0	0	0	46
\N	\N	\N	\N	1	11	7	0	0	0	0	0	0	47
\N	\N	\N	\N	1	12	7	0	0	0	0	0	0	48
\N	\N	\N	\N	1	13	7	0	0	0	0	0	0	49
\N	\N	\N	\N	1	7	7	0	0	0	0	0	0	50
\N	\N	\N	\N	1	8	7	0	0	0	0	0	0	51
\N	\N	\N	\N	1	14	7	0	0	0	0	0	0	52
\N	\N	\N	\N	1	15	7	0	0	0	0	0	0	53
\N	\N	\N	\N	1	100	7	0	0	0	0	0	0	54
\N	\N	\N	\N	1	101	7	0	0	0	0	0	0	55
\N	\N	\N	\N	1	102	7	0	0	0	0	0	0	56
\N	\N	\N	\N	1	103	7	0	0	0	0	0	0	57
\N	\N	\N	\N	1	104	7	0	0	0	0	0	0	58
\N	\N	\N	\N	1	105	7	0	0	0	0	0	0	59
\N	\N	\N	\N	1	110	7	0	0	0	0	0	0	60
\N	\N	\N	\N	1	113	7	0	0	0	0	0	0	61
\N	\N	\N	\N	1	120	7	0	0	0	0	0	0	62
\N	\N	\N	\N	1	130	7	0	0	0	0	0	0	63
\N	\N	\N	\N	1	131	7	0	0	0	0	0	0	64
\N	\N	\N	\N	1	1	10	0	0	0	0	0	0	65
\N	\N	\N	\N	1	2	10	0	0	0	0	0	0	66
\N	\N	\N	\N	1	5	10	0	0	0	0	0	0	67
\N	\N	\N	\N	1	4	10	0	0	0	0	0	0	68
\N	\N	\N	\N	1	3	10	0	0	0	0	0	0	69
\N	\N	\N	\N	1	6	10	0	0	0	0	0	0	70
\N	\N	\N	\N	1	9	10	0	0	0	0	0	0	71
\N	\N	\N	\N	1	10	10	0	0	0	0	0	0	72
\N	\N	\N	\N	1	12	10	0	0	0	0	0	0	73
\N	\N	\N	\N	1	7	10	0	0	0	0	0	0	74
\N	\N	\N	\N	1	8	10	0	0	0	0	0	0	75
\N	\N	\N	\N	1	14	10	0	0	0	0	0	0	76
\N	\N	\N	\N	1	15	10	0	0	0	0	0	0	77
\N	\N	\N	\N	1	100	10	0	0	0	0	0	0	78
\N	\N	\N	\N	1	101	10	0	0	0	0	0	0	79
\N	\N	\N	\N	1	102	10	0	0	0	0	0	0	80
\N	\N	\N	\N	1	103	10	0	0	0	0	0	0	81
\N	\N	\N	\N	1	104	10	0	0	0	0	0	0	82
\N	\N	\N	\N	1	105	10	0	0	0	0	0	0	83
\N	\N	\N	\N	1	110	10	0	0	0	0	0	0	84
\N	\N	\N	\N	1	113	10	0	0	0	0	0	0	85
\N	\N	\N	\N	1	120	10	0	0	0	0	0	0	86
\N	\N	\N	\N	1	130	10	0	0	0	0	0	0	87
\N	\N	\N	\N	1	131	10	0	0	0	0	0	0	88
\N	\N	\N	\N	1	13	10	0	0	1	0	0	0	89
\N	\N	\N	\N	1	11	10	0	1	0	0	0	0	90
\.


--
-- TOC entry 3253 (class 0 OID 31566)
-- Dependencies: 239
-- Data for Name: sys_status_information; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_status_information (created_at, created_by, updated_at, updated_by, flag_delete, status, status_id, status_description) FROM stdin;
\N	\N	\N	\N	0	1	1	Active
\N	\N	\N	\N	0	0	2	Inactive
\N	\N	\N	\N	0	10	3	Pending
\N	\N	\N	\N	0	11	4	Approve
\N	\N	\N	\N	0	9	5	Reject
\.


--
-- TOC entry 3254 (class 0 OID 31574)
-- Dependencies: 240
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (user_id, user_name, user_email, user_password, user_section_id, created_at, created_by, updated_at, updated_by, flag_delete, status) FROM stdin;
29	Admin Utama	gesang@gmail.com	15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225	1	2022-07-18 10:59:23	0	2022-07-18 11:38:36	0	1	0
1	gesang	gesangseto@gmail.com	8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92	1	2022-06-15 09:00:36	0	2022-08-12 11:10:02	0	0	1
31	admins	johnsmith@doctor.co.id	8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92	1	2022-07-18 11:01:10	0	2022-08-12 11:10:10	0	0	1
32	admin	admin@gmail.com	8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92	1	2022-07-19 15:20:23	0	2022-08-23 09:48:34	0	0	1
\.


--
-- TOC entry 3255 (class 0 OID 31582)
-- Dependencies: 241
-- Data for Name: user_authentication; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_authentication (created_at, status, user_id, token, expired_at, user_agent, authentication_id) FROM stdin;
\N	1	1	4bd75474c49fa6f0517384206353d322f6896e23a4cab37fee575b20558ccf84	2022-08-20 15:17:40	\N	1
2022-07-21 15:18:58	1	1	cb3bdf9737ef715450edea1058963393cacdda3d3c283b911f836fabdf529350	2022-08-20 15:18:58	\N	2
2022-07-21 15:19:54	1	1	fa60904b02dace6a5594957d2e3655824455cb63877a72b97975fe49fc67d389	2022-08-20 15:19:54	\N	3
2022-07-21 15:20:42	1	1	7dc1a1d464a78caf03fde175b571846052e9cc0434032f1fac36091700292ec5	2022-08-20 15:20:43	\N	4
2022-07-21 15:21:05	1	1	daaa23768437cfcd0f78a5ab428c925aeb9d27711be955ec9de3c14e6e726af0	2022-08-20 15:21:05	\N	5
2022-07-21 15:53:56	1	1	a59beb257b05730fd0d71ddef7e42649389f391a69444c3e21ea03b6a341f8b6	2022-08-20 15:54:11	\N	12
2022-07-21 16:04:17	1	1	085b021647e7ed7962a92b0f6ee0380247b090a73d49b8377f062c33b68e46d2	2022-08-20 16:04:17	\N	13
2022-07-21 16:07:32	1	1	dc972320910896d78a13a787885339be3c92ab05ae0e38592b8f386102c34adb	2022-08-20 16:07:32	\N	14
2022-07-26 14:46:06	1	1	68ec031d5e922822099e868f25955d0b2d0f988725914f99e90b0aa3db2b553c	2022-08-25 14:58:42	\N	27
2022-07-22 14:04:37	1	1	ab28560ecb84d34e938f4e479986f2fa30be7349643c69644364743a67c632d9	2022-08-21 14:04:44	\N	22
2022-07-26 14:44:43	1	1	06b759a82c91e708417c63742a13644be033b70ae1dc91f52524a347cd52050b	2022-08-25 14:45:34	\N	26
2022-07-21 15:21:23	1	1	b2c83945ce5425e7f8b9e101210f6e837966559510fd87a4e413448b4c96dd7b	2022-08-20 15:22:01	\N	6
2022-07-21 15:40:24	1	1	e9ee813f453afaa00d6dec21469733285f30d6f749e83b34b450bc69aac32c7d	2022-08-20 15:44:25	\N	8
2022-07-21 15:49:08	1	1	88d1d41c3b042ff7103743974fa02c861398aa5fc8b07ff1c5f1ede37d8790e7	2022-08-20 15:49:08	\N	9
2022-07-21 16:16:31	1	1	ead35af434d80220d09d04507235561ebf3d0471ce2794441bb8c7d312c0695f	2022-08-20 16:50:36	\N	15
\N	1	1	c886af98461ef54df6e45521e9a56e1e9b8fcb12697279243e0f5a5062dc1c63	2022-08-21 10:20:24	\N	16
\N	1	1	186be2529b3ce4f38ca1ebc0dc24d34c14362760644b2e73c62c8ffcb05b7a63	2022-08-21 10:28:39	\N	17
2022-07-21 15:49:43	1	1	59ac9e10dea670f658e4fc8de63b19421416914094fa20bd17c34a80cd673efe	2022-08-20 15:52:26	\N	10
2022-08-18 09:15:43	1	1	61613bde470f802f825edc607e8d331a28ccd8f3b4ad3edc894c5dd86550ab20	2022-09-17 10:25:33	\N	31
2022-07-27 16:24:39	1	1	0430e3fd7c137d224cdf4bd5ef5c52fc7a48fb03c9d1328916089bdc46ffc2e5	2022-08-26 16:25:12	\N	29
2022-07-28 10:13:08	1	1	5b3ecf8fe1e6b562575aa3e70a35403e04cd948236855381811c0496f2569d0d	2022-08-27 10:13:08	\N	30
2022-07-22 10:54:07	1	1	6fa9f86a31b87b6c0402bb40be615b794ff1b90345515149f4eaf2ea68cc1855	2022-08-21 10:55:36	\N	18
2022-07-21 15:38:15	1	1	60a530458ebd6d1d88996e244b53ce23a6f8b33ceb76d4d3a3d5c3acc5af11db	2022-08-20 15:40:17	\N	7
2022-07-22 14:05:30	1	1	23d845cbe01f3fb9d317e3464dbd792dc564fec7e91e9a6a3a5e4bbca1f91523	2022-08-21 14:10:01	\N	24
2022-07-21 15:53:16	1	1	6fdd4a897c2bc211f3b0ea80ec385338612512222f49a6bebeaa9577868c17bc	2022-08-20 15:53:40	\N	11
2022-07-22 10:55:58	1	1	2c48e835b4affb53955688c5a20a436656d6546c9a98214b1c99abe29a2916b8	2022-08-21 10:56:18	\N	19
2022-07-22 14:04:53	1	31	21ba2ea7c51848ec908a75d6855c7dc0fef64e7ba280b32c0b878afa292b51b9	2022-08-21 14:05:23	\N	23
2022-08-23 09:48:41	1	32	340d898553b19bccf391e88c149bca71ab2efc7ca0e30d438dd69bdf089eae7b	2022-09-22 03:34:00	\N	32
2022-07-22 11:15:01	1	1	7929b6842e222c95c5ab49345ad0f9759db8504eb789b54bea9abf25fe9fd746	2022-08-21 11:15:09	\N	20
2022-07-22 14:03:18	1	1	ac0932e9abff936113399da9e9c82bc8c7257967850478c472a15373cd3a0986	2022-08-21 14:03:18	\N	21
2022-07-27 16:15:22	1	1	e396dc4fa7e30af9e522fb928e33472de5c8dbc5d6a3150e4e99a97f2f20ba05	2022-08-26 16:15:50	\N	28
2022-07-26 14:44:23	1	31	48f832ad361abe28fa732f95f58e9a599c6678b99e846dfc2fe0aa4b6001e981	2022-08-25 14:44:33	\N	25
2022-08-23 16:02:37	1	32	fb5ec4dc6501eb64567ab7e48aa1e8d9cc5502a0c97959e05f244faf44e8e469	2022-09-22 04:03:00	\N	33
\.


--
-- TOC entry 3256 (class 0 OID 31590)
-- Dependencies: 242
-- Data for Name: user_department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_department (created_at, created_by, updated_at, updated_by, flag_delete, status, user_department_id, user_department_name, user_department_code) FROM stdin;
2022-06-15 09:00:36	0	2022-07-21 11:01:20	0	0	0	1	Information Technology	IT
2022-06-21 10:53:23	0	2022-07-21 11:27:37	0	0	1	7	Administration	ADM
2022-07-22 14:04:13	0	\N	\N	0	0	15	Approval Test	AppTest
2022-07-26 14:43:36	0	2022-07-26 15:14:49	0	0	1	16	hgsdahjgdjas	TESTIGN
\.


--
-- TOC entry 3258 (class 0 OID 31600)
-- Dependencies: 244
-- Data for Name: user_section; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_section (created_at, created_by, updated_at, updated_by, flag_delete, status, user_section_id, user_department_id, user_section_code, user_section_name) FROM stdin;
2022-06-15 09:00:36	0	2022-07-21 11:27:19	0	0	1	1	1	MG	Manager IT
2022-07-26 15:15:38	0	2022-07-26 15:32:26	0	0	1	7	7	STE	Assas
2022-07-21 11:28:03	0	2022-07-26 15:32:29	0	0	1	6	7	Finance	Finance
2022-07-26 15:33:43	0	\N	\N	0	1	8	7	Warehouse	Warehoiuse
2022-07-27 16:15:41	1	2022-07-27 16:15:49	1	0	1	11	7	AJI	Sadjh
2022-07-26 15:34:21	0	2022-08-12 11:19:17	0	0	1	10	7	Finances	Pion
\.


--
-- TOC entry 3301 (class 0 OID 0)
-- Dependencies: 203
-- Name: approval_approval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.approval_approval_id_seq', 28, true);


--
-- TOC entry 3302 (class 0 OID 0)
-- Dependencies: 205
-- Name: approval_flow_approval_flow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.approval_flow_approval_flow_id_seq', 43, true);


--
-- TOC entry 3303 (class 0 OID 0)
-- Dependencies: 206
-- Name: approval_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.approval_seq', 1, false);


--
-- TOC entry 3304 (class 0 OID 0)
-- Dependencies: 250
-- Name: audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_log_id_seq', 16, true);


--
-- TOC entry 3305 (class 0 OID 0)
-- Dependencies: 210
-- Name: mst_customer_mst_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mst_customer_mst_customer_id_seq', 3, true);


--
-- TOC entry 3306 (class 0 OID 0)
-- Dependencies: 212
-- Name: mst_item_mst_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mst_item_mst_item_id_seq', 11, true);


--
-- TOC entry 3307 (class 0 OID 0)
-- Dependencies: 214
-- Name: mst_item_variant_mst_item_variant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mst_item_variant_mst_item_variant_id_seq', 30, true);


--
-- TOC entry 3308 (class 0 OID 0)
-- Dependencies: 216
-- Name: mst_packaging_mst_packaging_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mst_packaging_mst_packaging_id_seq', 9, true);


--
-- TOC entry 3309 (class 0 OID 0)
-- Dependencies: 218
-- Name: mst_supplier_mst_supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mst_supplier_mst_supplier_id_seq', 2, true);


--
-- TOC entry 3310 (class 0 OID 0)
-- Dependencies: 256
-- Name: pos_branch_pos_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pos_branch_pos_branch_id_seq', 8, true);


--
-- TOC entry 3311 (class 0 OID 0)
-- Dependencies: 220
-- Name: pos_cashier_pos_cashier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pos_cashier_pos_cashier_id_seq', 17, true);


--
-- TOC entry 3312 (class 0 OID 0)
-- Dependencies: 223
-- Name: pos_discount_pos_discount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pos_discount_pos_discount_id_seq', 46, true);


--
-- TOC entry 3313 (class 0 OID 0)
-- Dependencies: 225
-- Name: pos_item_stock_pos_item_stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pos_item_stock_pos_item_stock_id_seq', 56, true);


--
-- TOC entry 3314 (class 0 OID 0)
-- Dependencies: 228
-- Name: pos_receive_detail_pos_receive_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pos_receive_detail_pos_receive_detail_id_seq', 112, true);


--
-- TOC entry 3315 (class 0 OID 0)
-- Dependencies: 230
-- Name: pos_sale_detail_pos_sale_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pos_sale_detail_pos_sale_detail_id_seq', 165, true);


--
-- TOC entry 3316 (class 0 OID 0)
-- Dependencies: 232
-- Name: pos_sale_pos_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pos_sale_pos_sale_id_seq', 1, false);


--
-- TOC entry 3317 (class 0 OID 0)
-- Dependencies: 254
-- Name: pos_user_branch_pos_user_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pos_user_branch_pos_user_branch_id_seq', 23, true);


--
-- TOC entry 3318 (class 0 OID 0)
-- Dependencies: 247
-- Name: sys_menu_module_sys_menu_module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sys_menu_module_sys_menu_module_id_seq', 2, true);


--
-- TOC entry 3319 (class 0 OID 0)
-- Dependencies: 251
-- Name: sys_relation_sys_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sys_relation_sys_relation_id_seq', 2, true);


--
-- TOC entry 3320 (class 0 OID 0)
-- Dependencies: 238
-- Name: sys_role_section_role_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sys_role_section_role_section_id_seq', 114, true);


--
-- TOC entry 3321 (class 0 OID 0)
-- Dependencies: 249
-- Name: user_authentication_authentication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_authentication_authentication_id_seq', 33, true);


--
-- TOC entry 3322 (class 0 OID 0)
-- Dependencies: 243
-- Name: user_department_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_department_department_id_seq', 16, true);


--
-- TOC entry 3323 (class 0 OID 0)
-- Dependencies: 245
-- Name: user_section_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_section_section_id_seq', 11, true);


--
-- TOC entry 3324 (class 0 OID 0)
-- Dependencies: 246
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_user_id_seq', 32, true);


--
-- TOC entry 2957 (class 2606 OID 31632)
-- Name: approval Approval Primary Key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "Approval Primary Key" PRIMARY KEY (approval_id);


--
-- TOC entry 2961 (class 2606 OID 31634)
-- Name: approval_flow Approval Table - ID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "Approval Table - ID" UNIQUE (approval_ref_id, approval_ref_table);


--
-- TOC entry 2977 (class 2606 OID 31638)
-- Name: mst_item_variant Barcode; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_item_variant
    ADD CONSTRAINT "Barcode" UNIQUE (barcode);


--
-- TOC entry 2993 (class 2606 OID 37644)
-- Name: pos_branch Branch Code Pos; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_branch
    ADD CONSTRAINT "Branch Code Pos" UNIQUE (pos_branch_code);


--
-- TOC entry 2967 (class 2606 OID 31640)
-- Name: mst_customer Customer PK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_customer
    ADD CONSTRAINT "Customer PK" PRIMARY KEY (mst_customer_id);


--
-- TOC entry 3039 (class 2606 OID 31642)
-- Name: user_department Department Code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_department
    ADD CONSTRAINT "Department Code" UNIQUE (user_department_code);


--
-- TOC entry 3041 (class 2606 OID 31644)
-- Name: user_department Department Primary Key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_department
    ADD CONSTRAINT "Department Primary Key" PRIMARY KEY (user_department_id);


--
-- TOC entry 3055 (class 2606 OID 37653)
-- Name: pos_user_branch Duplicate User On Branch; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_user_branch
    ADD CONSTRAINT "Duplicate User On Branch" UNIQUE (pos_branch_code, user_id);


--
-- TOC entry 2969 (class 2606 OID 31646)
-- Name: mst_customer Email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_customer
    ADD CONSTRAINT "Email" UNIQUE (mst_customer_email);


--
-- TOC entry 3009 (class 2606 OID 31648)
-- Name: pos_trx_detail FK Item; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_detail
    ADD CONSTRAINT "FK Item" UNIQUE (mst_item_variant_id, pos_trx_ref_id);


--
-- TOC entry 3001 (class 2606 OID 31650)
-- Name: pos_item_stock Item ID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_item_stock
    ADD CONSTRAINT "Item ID" UNIQUE (mst_item_id);


--
-- TOC entry 2973 (class 2606 OID 31652)
-- Name: mst_item Item Primary Key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_item
    ADD CONSTRAINT "Item Primary Key" PRIMARY KEY (mst_item_id);


--
-- TOC entry 2975 (class 2606 OID 31654)
-- Name: mst_item Item Unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_item
    ADD CONSTRAINT "Item Unique" UNIQUE (mst_item_no);


--
-- TOC entry 3025 (class 2606 OID 31656)
-- Name: sys_role_section Menu - Section; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_role_section
    ADD CONSTRAINT "Menu - Section" UNIQUE (sys_menu_id, user_section_id);


--
-- TOC entry 2997 (class 2606 OID 31660)
-- Name: pos_discount PK Discount; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_discount
    ADD CONSTRAINT "PK Discount" PRIMARY KEY (pos_discount_id);


--
-- TOC entry 3005 (class 2606 OID 31664)
-- Name: pos_receive PK Receive; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_receive
    ADD CONSTRAINT "PK Receive" PRIMARY KEY (pos_receive_id);


--
-- TOC entry 3007 (class 2606 OID 31666)
-- Name: pos_receive_detail PK Receive Detail; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_receive_detail
    ADD CONSTRAINT "PK Receive Detail" PRIMARY KEY (pos_receive_detail_id);


--
-- TOC entry 3011 (class 2606 OID 31668)
-- Name: pos_trx_detail PK Trx Detail; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_detail
    ADD CONSTRAINT "PK Trx Detail" PRIMARY KEY (pos_trx_detail_id);


--
-- TOC entry 2981 (class 2606 OID 31670)
-- Name: mst_packaging Packaging Code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_packaging
    ADD CONSTRAINT "Packaging Code" UNIQUE (mst_packaging_code);


--
-- TOC entry 2983 (class 2606 OID 31672)
-- Name: mst_packaging Packaging PK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_packaging
    ADD CONSTRAINT "Packaging PK" PRIMARY KEY (mst_packaging_id);


--
-- TOC entry 2971 (class 2606 OID 31674)
-- Name: mst_customer Phone; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_customer
    ADD CONSTRAINT "Phone" UNIQUE (mst_customer_phone);


--
-- TOC entry 2995 (class 2606 OID 37628)
-- Name: pos_branch Pos Branch PK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_branch
    ADD CONSTRAINT "Pos Branch PK" PRIMARY KEY (pos_branch_id);


--
-- TOC entry 3015 (class 2606 OID 31676)
-- Name: pos_trx_inbound Pos Trx Inbound; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_inbound
    ADD CONSTRAINT "Pos Trx Inbound" PRIMARY KEY (pos_trx_inbound_id);


--
-- TOC entry 3027 (class 2606 OID 31678)
-- Name: sys_role_section Role Section Primary Key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_role_section
    ADD CONSTRAINT "Role Section Primary Key" PRIMARY KEY (sys_role_section_id);


--
-- TOC entry 3043 (class 2606 OID 31680)
-- Name: user_section Section Code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_section
    ADD CONSTRAINT "Section Code" UNIQUE (user_section_code);


--
-- TOC entry 3045 (class 2606 OID 31682)
-- Name: user_section Section Primary Key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_section
    ADD CONSTRAINT "Section Primary Key" PRIMARY KEY (user_section_id);


--
-- TOC entry 3029 (class 2606 OID 31684)
-- Name: sys_status_information Status; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_status_information
    ADD CONSTRAINT "Status" UNIQUE (status);


--
-- TOC entry 2985 (class 2606 OID 31686)
-- Name: mst_supplier Supplier ID; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_supplier
    ADD CONSTRAINT "Supplier ID" PRIMARY KEY (mst_supplier_id);


--
-- TOC entry 3047 (class 2606 OID 31889)
-- Name: sys_menu_module Sys Menu Module PK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_menu_module
    ADD CONSTRAINT "Sys Menu Module PK" PRIMARY KEY (sys_menu_module_id);


--
-- TOC entry 3049 (class 2606 OID 31891)
-- Name: sys_menu_module Sys Menu Module UN; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_menu_module
    ADD CONSTRAINT "Sys Menu Module UN" UNIQUE (sys_menu_module_code);


--
-- TOC entry 3019 (class 2606 OID 31724)
-- Name: sys_menu Sys Menu PK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_menu
    ADD CONSTRAINT "Sys Menu PK" PRIMARY KEY (sys_menu_id);


--
-- TOC entry 3021 (class 2606 OID 31692)
-- Name: sys_relation Unique Code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_relation
    ADD CONSTRAINT "Unique Code" UNIQUE (sys_relation_code);


--
-- TOC entry 2999 (class 2606 OID 31694)
-- Name: pos_discount Unique Code Discount; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_discount
    ADD CONSTRAINT "Unique Code Discount" UNIQUE (pos_discount_code);


--
-- TOC entry 2959 (class 2606 OID 31696)
-- Name: approval Unique Key Table; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "Unique Key Table" UNIQUE (approval_ref_table);


--
-- TOC entry 3033 (class 2606 OID 31700)
-- Name: user User Email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "User Email" UNIQUE (user_email);


--
-- TOC entry 2963 (class 2606 OID 31702)
-- Name: approval_flow User ID Unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID Unique" UNIQUE (approval_user_id_1, approval_user_id_2, approval_user_id_3, approval_user_id_4, approval_user_id_5);


--
-- TOC entry 3035 (class 2606 OID 31704)
-- Name: user User Primary Key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "User Primary Key" PRIMARY KEY (user_id);


--
-- TOC entry 2965 (class 2606 OID 36787)
-- Name: audit_log audit_log_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pk PRIMARY KEY (id);


--
-- TOC entry 2987 (class 2606 OID 31708)
-- Name: mst_supplier email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_supplier
    ADD CONSTRAINT email UNIQUE (mst_supplier_email);


--
-- TOC entry 2979 (class 2606 OID 31710)
-- Name: mst_item_variant item_variant_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_item_variant
    ADD CONSTRAINT item_variant_pk PRIMARY KEY (mst_item_variant_id);


--
-- TOC entry 2989 (class 2606 OID 31712)
-- Name: mst_supplier phone; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_supplier
    ADD CONSTRAINT phone UNIQUE (mst_supplier_phone);


--
-- TOC entry 2991 (class 2606 OID 31714)
-- Name: pos_cashier pos_cashier_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_cashier
    ADD CONSTRAINT pos_cashier_pk PRIMARY KEY (pos_cashier_id);


--
-- TOC entry 3003 (class 2606 OID 31716)
-- Name: pos_item_stock pos_item_stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_item_stock
    ADD CONSTRAINT pos_item_stock_pk PRIMARY KEY (pos_item_stock_id);


--
-- TOC entry 3013 (class 2606 OID 31718)
-- Name: pos_trx_sale pos_sale_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_sale
    ADD CONSTRAINT pos_sale_pk PRIMARY KEY (pos_trx_sale_id);


--
-- TOC entry 3053 (class 2606 OID 37263)
-- Name: pos_trx_destroy pos_trx_destroy_pk_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_destroy
    ADD CONSTRAINT pos_trx_destroy_pk_1 PRIMARY KEY (pos_trx_destroy_id);


--
-- TOC entry 3051 (class 2606 OID 37110)
-- Name: pos_trx_return pos_trx_return_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_return
    ADD CONSTRAINT pos_trx_return_pk PRIMARY KEY (pos_trx_return_id);


--
-- TOC entry 3057 (class 2606 OID 37588)
-- Name: pos_user_branch pos_user_branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_user_branch
    ADD CONSTRAINT pos_user_branch_pk PRIMARY KEY (pos_user_branch_id);


--
-- TOC entry 3017 (class 2606 OID 31722)
-- Name: sys_configuration sys_configuration_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_configuration
    ADD CONSTRAINT sys_configuration_pk PRIMARY KEY (id);


--
-- TOC entry 3023 (class 2606 OID 36850)
-- Name: sys_relation sys_relation_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_relation
    ADD CONSTRAINT sys_relation_pk PRIMARY KEY (sys_relation_id);


--
-- TOC entry 3031 (class 2606 OID 31726)
-- Name: sys_status_information sys_status_information_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_status_information
    ADD CONSTRAINT sys_status_information_pk PRIMARY KEY (status_id);


--
-- TOC entry 3037 (class 2606 OID 36764)
-- Name: user_authentication user_authentication_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_authentication
    ADD CONSTRAINT user_authentication_pk PRIMARY KEY (authentication_id);


--
-- TOC entry 3089 (class 2606 OID 37665)
-- Name: pos_user_branch BRANCH; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_user_branch
    ADD CONSTRAINT "BRANCH" FOREIGN KEY (pos_branch_code) REFERENCES public.pos_branch(pos_branch_code);


--
-- TOC entry 3076 (class 2606 OID 31732)
-- Name: pos_receive_detail FK Item; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_receive_detail
    ADD CONSTRAINT "FK Item" FOREIGN KEY (mst_item_id) REFERENCES public.mst_item(mst_item_id);


--
-- TOC entry 3075 (class 2606 OID 31742)
-- Name: pos_receive FK Supplier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_receive
    ADD CONSTRAINT "FK Supplier" FOREIGN KEY (mst_supplier_id) REFERENCES public.mst_supplier(mst_supplier_id);


--
-- TOC entry 3072 (class 2606 OID 31752)
-- Name: pos_discount FK Variant Item; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_discount
    ADD CONSTRAINT "FK Variant Item" FOREIGN KEY (mst_item_variant_id) REFERENCES public.mst_item_variant(mst_item_variant_id);


--
-- TOC entry 3083 (class 2606 OID 31892)
-- Name: sys_menu Module FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_menu
    ADD CONSTRAINT "Module FK" FOREIGN KEY (sys_menu_module_id) REFERENCES public.sys_menu_module(sys_menu_module_id);


--
-- TOC entry 3081 (class 2606 OID 31757)
-- Name: pos_trx_inbound PK Customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_inbound
    ADD CONSTRAINT "PK Customer" FOREIGN KEY (mst_customer_id) REFERENCES public.mst_customer(mst_customer_id);


--
-- TOC entry 3077 (class 2606 OID 31762)
-- Name: pos_trx_detail PK Item; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_detail
    ADD CONSTRAINT "PK Item" FOREIGN KEY (mst_item_id) REFERENCES public.mst_item(mst_item_id);


--
-- TOC entry 3078 (class 2606 OID 31767)
-- Name: pos_trx_detail PK Item Variant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_detail
    ADD CONSTRAINT "PK Item Variant" FOREIGN KEY (mst_item_variant_id) REFERENCES public.mst_item_variant(mst_item_variant_id);


--
-- TOC entry 3082 (class 2606 OID 31772)
-- Name: pos_trx_inbound PK Supplier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_inbound
    ADD CONSTRAINT "PK Supplier" FOREIGN KEY (mst_supplier_id) REFERENCES public.mst_supplier(mst_supplier_id);


--
-- TOC entry 3069 (class 2606 OID 31777)
-- Name: mst_item_variant Packaging ID FK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_item_variant
    ADD CONSTRAINT "Packaging ID FK" FOREIGN KEY (mst_packaging_id) REFERENCES public.mst_packaging(mst_packaging_id);


--
-- TOC entry 3088 (class 2606 OID 37602)
-- Name: pos_user_branch USER - BRANCH; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_user_branch
    ADD CONSTRAINT "USER - BRANCH" FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- TOC entry 3058 (class 2606 OID 31782)
-- Name: approval User Approval 1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "User Approval 1" FOREIGN KEY (approval_user_id_1) REFERENCES public."user"(user_id);


--
-- TOC entry 3059 (class 2606 OID 31787)
-- Name: approval User Approval 2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "User Approval 2" FOREIGN KEY (approval_user_id_2) REFERENCES public."user"(user_id);


--
-- TOC entry 3060 (class 2606 OID 31792)
-- Name: approval User Approval 3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "User Approval 3" FOREIGN KEY (approval_user_id_3) REFERENCES public."user"(user_id);


--
-- TOC entry 3061 (class 2606 OID 31797)
-- Name: approval User Approval 4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "User Approval 4" FOREIGN KEY (approval_user_id_4) REFERENCES public."user"(user_id);


--
-- TOC entry 3062 (class 2606 OID 31802)
-- Name: approval User Approval 5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "User Approval 5" FOREIGN KEY (approval_user_id_5) REFERENCES public."user"(user_id);


--
-- TOC entry 3063 (class 2606 OID 31807)
-- Name: approval_flow User ID 1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID 1" FOREIGN KEY (approval_user_id_1) REFERENCES public."user"(user_id);


--
-- TOC entry 3064 (class 2606 OID 31812)
-- Name: approval_flow User ID 2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID 2" FOREIGN KEY (approval_user_id_2) REFERENCES public."user"(user_id);


--
-- TOC entry 3065 (class 2606 OID 31817)
-- Name: approval_flow User ID 3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID 3" FOREIGN KEY (approval_user_id_3) REFERENCES public."user"(user_id);


--
-- TOC entry 3066 (class 2606 OID 31822)
-- Name: approval_flow User ID 4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID 4" FOREIGN KEY (approval_user_id_4) REFERENCES public."user"(user_id);


--
-- TOC entry 3067 (class 2606 OID 31827)
-- Name: approval_flow User ID 5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID 5" FOREIGN KEY (approval_user_id_5) REFERENCES public."user"(user_id);


--
-- TOC entry 3068 (class 2606 OID 31832)
-- Name: audit_log audit_log_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_fk FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- TOC entry 3070 (class 2606 OID 31837)
-- Name: mst_item_variant mst_item_id at mst_item_variant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mst_item_variant
    ADD CONSTRAINT "mst_item_id at mst_item_variant" FOREIGN KEY (mst_item_id) REFERENCES public.mst_item(mst_item_id);


--
-- TOC entry 3071 (class 2606 OID 37608)
-- Name: pos_cashier pos_cashier_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_cashier
    ADD CONSTRAINT pos_cashier_fk FOREIGN KEY (pos_user_branch_id) REFERENCES public.pos_user_branch(pos_user_branch_id);


--
-- TOC entry 3073 (class 2606 OID 37671)
-- Name: pos_discount pos_discount_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_discount
    ADD CONSTRAINT pos_discount_fk FOREIGN KEY (pos_branch_code) REFERENCES public.pos_branch(pos_branch_code);


--
-- TOC entry 3074 (class 2606 OID 31842)
-- Name: pos_item_stock pos_item_stock_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_item_stock
    ADD CONSTRAINT pos_item_stock_fk FOREIGN KEY (mst_item_id) REFERENCES public.mst_item(mst_item_id);


--
-- TOC entry 3080 (class 2606 OID 31847)
-- Name: pos_trx_sale pos_sale_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_sale
    ADD CONSTRAINT pos_sale_fk FOREIGN KEY (mst_customer_id) REFERENCES public.mst_customer(mst_customer_id);


--
-- TOC entry 3079 (class 2606 OID 31852)
-- Name: pos_trx_detail pos_trx_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pos_trx_detail
    ADD CONSTRAINT pos_trx_detail_fk FOREIGN KEY (pos_discount_id) REFERENCES public.pos_discount(pos_discount_id);


--
-- TOC entry 3084 (class 2606 OID 31857)
-- Name: sys_role_section sys_role_section_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_role_section
    ADD CONSTRAINT sys_role_section_fk FOREIGN KEY (user_section_id) REFERENCES public.user_section(user_section_id);


--
-- TOC entry 3086 (class 2606 OID 31862)
-- Name: user_authentication user_authentication_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_authentication
    ADD CONSTRAINT user_authentication_fk FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- TOC entry 3085 (class 2606 OID 31867)
-- Name: user user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_fk FOREIGN KEY (user_section_id) REFERENCES public.user_section(user_section_id);


--
-- TOC entry 3087 (class 2606 OID 31872)
-- Name: user_section user_section_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_section
    ADD CONSTRAINT user_section_fk FOREIGN KEY (user_department_id) REFERENCES public.user_department(user_department_id);


-- Completed on 2022-08-23 16:03:19

--
-- PostgreSQL database dump complete
--

