--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 13.3

-- Started on 2022-11-22 08:11:23

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 3478 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 263 (class 1255 OID 18435)
-- Name: make_serial(text, text, text); Type: FUNCTION; Schema: public; Owner: -
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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 18436)
-- Name: approval; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 203 (class 1259 OID 18444)
-- Name: approval_approval_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_approval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3479 (class 0 OID 0)
-- Dependencies: 203
-- Name: approval_approval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_approval_id_seq OWNED BY public.approval.approval_id;


--
-- TOC entry 204 (class 1259 OID 18446)
-- Name: approval_flow; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 205 (class 1259 OID 18453)
-- Name: approval_flow_approval_flow_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_flow_approval_flow_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3480 (class 0 OID 0)
-- Dependencies: 205
-- Name: approval_flow_approval_flow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_flow_approval_flow_id_seq OWNED BY public.approval_flow.approval_flow_id;


--
-- TOC entry 206 (class 1259 OID 18455)
-- Name: approval_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 207 (class 1259 OID 18457)
-- Name: audit_log; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 208 (class 1259 OID 18463)
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3481 (class 0 OID 0)
-- Dependencies: 208
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_log_id_seq OWNED BY public.audit_log.id;


--
-- TOC entry 209 (class 1259 OID 18465)
-- Name: base_table; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.base_table (
    created_at timestamp with time zone,
    created_by integer,
    updated_at timestamp with time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1
);


--
-- TOC entry 210 (class 1259 OID 18470)
-- Name: mst_customer; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 211 (class 1259 OID 18478)
-- Name: mst_customer_mst_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mst_customer_mst_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3482 (class 0 OID 0)
-- Dependencies: 211
-- Name: mst_customer_mst_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mst_customer_mst_customer_id_seq OWNED BY public.mst_customer.mst_customer_id;


--
-- TOC entry 212 (class 1259 OID 18480)
-- Name: mst_item; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 213 (class 1259 OID 18488)
-- Name: mst_item_mst_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mst_item_mst_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 213
-- Name: mst_item_mst_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mst_item_mst_item_id_seq OWNED BY public.mst_item.mst_item_id;


--
-- TOC entry 214 (class 1259 OID 18490)
-- Name: mst_item_variant; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 215 (class 1259 OID 18498)
-- Name: mst_item_variant_mst_item_variant_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mst_item_variant_mst_item_variant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3484 (class 0 OID 0)
-- Dependencies: 215
-- Name: mst_item_variant_mst_item_variant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mst_item_variant_mst_item_variant_id_seq OWNED BY public.mst_item_variant.mst_item_variant_id;


--
-- TOC entry 216 (class 1259 OID 18500)
-- Name: mst_packaging; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 217 (class 1259 OID 18508)
-- Name: mst_packaging_mst_packaging_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mst_packaging_mst_packaging_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 217
-- Name: mst_packaging_mst_packaging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mst_packaging_mst_packaging_id_seq OWNED BY public.mst_packaging.mst_packaging_id;


--
-- TOC entry 218 (class 1259 OID 18510)
-- Name: mst_supplier; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 219 (class 1259 OID 18518)
-- Name: mst_supplier_mst_supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mst_supplier_mst_supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3486 (class 0 OID 0)
-- Dependencies: 219
-- Name: mst_supplier_mst_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mst_supplier_mst_supplier_id_seq OWNED BY public.mst_supplier.mst_supplier_id;


--
-- TOC entry 220 (class 1259 OID 18520)
-- Name: pos_branch; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 221 (class 1259 OID 18529)
-- Name: pos_branch_pos_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pos_branch_pos_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3487 (class 0 OID 0)
-- Dependencies: 221
-- Name: pos_branch_pos_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pos_branch_pos_branch_id_seq OWNED BY public.pos_branch.pos_branch_id;


--
-- TOC entry 222 (class 1259 OID 18531)
-- Name: pos_cashier; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pos_cashier (
    created_at timestamp without time zone,
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
    pos_branch_code character varying NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 18540)
-- Name: pos_cashier_pos_cashier_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pos_cashier_pos_cashier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3488 (class 0 OID 0)
-- Dependencies: 223
-- Name: pos_cashier_pos_cashier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pos_cashier_pos_cashier_id_seq OWNED BY public.pos_cashier.pos_cashier_id;


--
-- TOC entry 224 (class 1259 OID 18542)
-- Name: pos_discount; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 3489 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN pos_discount.discount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pos_discount.discount IS 'Per seratus';


--
-- TOC entry 225 (class 1259 OID 18551)
-- Name: pos_discount_pos_discount_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pos_discount_pos_discount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3490 (class 0 OID 0)
-- Dependencies: 225
-- Name: pos_discount_pos_discount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pos_discount_pos_discount_id_seq OWNED BY public.pos_discount.pos_discount_id;


--
-- TOC entry 226 (class 1259 OID 18553)
-- Name: pos_item_stock; Type: TABLE; Schema: public; Owner: -
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
    qty integer,
    pos_branch_code character varying NOT NULL
);


--
-- TOC entry 227 (class 1259 OID 18561)
-- Name: pos_item_stock_pos_item_stock_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pos_item_stock_pos_item_stock_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3491 (class 0 OID 0)
-- Dependencies: 227
-- Name: pos_item_stock_pos_item_stock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pos_item_stock_pos_item_stock_id_seq OWNED BY public.pos_item_stock.pos_item_stock_id;


--
-- TOC entry 228 (class 1259 OID 18563)
-- Name: pos_receive; Type: TABLE; Schema: public; Owner: -
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
    is_received boolean,
    pos_branch_code character varying NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 18571)
-- Name: pos_receive_detail; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 230 (class 1259 OID 18579)
-- Name: pos_receive_detail_pos_receive_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pos_receive_detail_pos_receive_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3492 (class 0 OID 0)
-- Dependencies: 230
-- Name: pos_receive_detail_pos_receive_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pos_receive_detail_pos_receive_detail_id_seq OWNED BY public.pos_receive_detail.pos_receive_detail_id;


--
-- TOC entry 231 (class 1259 OID 18581)
-- Name: pos_trx_detail; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 232 (class 1259 OID 18586)
-- Name: pos_sale_detail_pos_sale_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pos_sale_detail_pos_sale_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3493 (class 0 OID 0)
-- Dependencies: 232
-- Name: pos_sale_detail_pos_sale_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pos_sale_detail_pos_sale_detail_id_seq OWNED BY public.pos_trx_detail.pos_trx_detail_id;


--
-- TOC entry 233 (class 1259 OID 18588)
-- Name: pos_trx_sale; Type: TABLE; Schema: public; Owner: -
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
    payment_type character varying,
    pos_branch_code character varying NOT NULL
);


--
-- TOC entry 234 (class 1259 OID 18597)
-- Name: pos_sale_pos_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pos_sale_pos_sale_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3494 (class 0 OID 0)
-- Dependencies: 234
-- Name: pos_sale_pos_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pos_sale_pos_sale_id_seq OWNED BY public.pos_trx_sale.pos_trx_sale_id;


--
-- TOC entry 235 (class 1259 OID 18599)
-- Name: pos_trx_destroy; Type: TABLE; Schema: public; Owner: -
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
    pos_trx_destroy_note text,
    pos_branch_code character varying NOT NULL
);


--
-- TOC entry 236 (class 1259 OID 18607)
-- Name: pos_trx_inbound; Type: TABLE; Schema: public; Owner: -
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
    pos_ref_table character varying,
    pos_branch_code character varying NOT NULL
);


--
-- TOC entry 237 (class 1259 OID 18613)
-- Name: pos_trx_return; Type: TABLE; Schema: public; Owner: -
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
    pos_trx_return_id bigint NOT NULL,
    pos_branch_code character varying NOT NULL
);


--
-- TOC entry 238 (class 1259 OID 18621)
-- Name: pos_user_branch; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 239 (class 1259 OID 18630)
-- Name: pos_user_branch_pos_user_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pos_user_branch_pos_user_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 239
-- Name: pos_user_branch_pos_user_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pos_user_branch_pos_user_branch_id_seq OWNED BY public.pos_user_branch.pos_user_branch_id;


--
-- TOC entry 240 (class 1259 OID 18632)
-- Name: sys_configuration; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 241 (class 1259 OID 18638)
-- Name: sys_menu; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 242 (class 1259 OID 18645)
-- Name: sys_menu_module; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sys_menu_module (
    status integer DEFAULT 1,
    sys_menu_module_id integer NOT NULL,
    sys_menu_module_name character varying NOT NULL,
    sys_menu_module_code character varying,
    sys_menu_module_icon character varying
);


--
-- TOC entry 243 (class 1259 OID 18652)
-- Name: sys_menu_module_sys_menu_module_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sys_menu_module_sys_menu_module_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3496 (class 0 OID 0)
-- Dependencies: 243
-- Name: sys_menu_module_sys_menu_module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sys_menu_module_sys_menu_module_id_seq OWNED BY public.sys_menu_module.sys_menu_module_id;


--
-- TOC entry 244 (class 1259 OID 18654)
-- Name: sys_relation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sys_relation (
    sys_relation_code character varying NOT NULL,
    sys_relation_ref_id bigint,
    sys_relation_desc text,
    sys_relation_name character varying NOT NULL,
    sys_relation_id smallint NOT NULL
);


--
-- TOC entry 245 (class 1259 OID 18660)
-- Name: sys_relation_sys_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sys_relation_sys_relation_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3497 (class 0 OID 0)
-- Dependencies: 245
-- Name: sys_relation_sys_relation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sys_relation_sys_relation_id_seq OWNED BY public.sys_relation.sys_relation_id;


--
-- TOC entry 246 (class 1259 OID 18662)
-- Name: sys_role_section; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 247 (class 1259 OID 18666)
-- Name: sys_role_section_role_section_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sys_role_section_role_section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3498 (class 0 OID 0)
-- Dependencies: 247
-- Name: sys_role_section_role_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sys_role_section_role_section_id_seq OWNED BY public.sys_role_section.sys_role_section_id;


--
-- TOC entry 248 (class 1259 OID 18668)
-- Name: sys_status_information; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 249 (class 1259 OID 18676)
-- Name: user; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 250 (class 1259 OID 18684)
-- Name: user_authentication; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 251 (class 1259 OID 18691)
-- Name: user_authentication_authentication_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_authentication_authentication_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 251
-- Name: user_authentication_authentication_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_authentication_authentication_id_seq OWNED BY public.user_authentication.authentication_id;


--
-- TOC entry 252 (class 1259 OID 18693)
-- Name: user_department; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 253 (class 1259 OID 18701)
-- Name: user_department_department_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_department_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 253
-- Name: user_department_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_department_department_id_seq OWNED BY public.user_department.user_department_id;


--
-- TOC entry 254 (class 1259 OID 18703)
-- Name: user_section; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 255 (class 1259 OID 18711)
-- Name: user_section_section_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_section_section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 255
-- Name: user_section_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_section_section_id_seq OWNED BY public.user_section.user_section_id;


--
-- TOC entry 256 (class 1259 OID 18713)
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 256
-- Name: user_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_user_id_seq OWNED BY public."user".user_id;


--
-- TOC entry 262 (class 1259 OID 19233)
-- Name: wh_mst_branch; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wh_mst_branch (
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    created_by integer,
    updated_by integer,
    status integer,
    id bigint NOT NULL,
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "desc" character varying(255),
    address character varying(255)
);


--
-- TOC entry 261 (class 1259 OID 19231)
-- Name: wh_mst_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wh_mst_branch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 261
-- Name: wh_mst_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wh_mst_branch_id_seq OWNED BY public.wh_mst_branch.id;


--
-- TOC entry 260 (class 1259 OID 19069)
-- Name: wh_mst_wh; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wh_mst_wh (
    created_at timestamp with time zone,
    created_by integer,
    updated_at timestamp with time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    wh_mst_wh_id integer NOT NULL,
    wh_mst_wh_code character varying NOT NULL,
    wh_mst_wh_name character varying,
    wh_mst_wh_desc character varying,
    wh_mst_wh_type_code character varying NOT NULL,
    wh_mst_branch_code character varying NOT NULL
);


--
-- TOC entry 258 (class 1259 OID 19033)
-- Name: wh_mst_wh_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wh_mst_wh_type (
    created_at timestamp with time zone,
    created_by integer,
    updated_at timestamp with time zone,
    updated_by integer,
    flag_delete integer DEFAULT 0,
    status integer DEFAULT 1,
    wh_mst_wh_type_id integer NOT NULL,
    wh_mst_wh_type_code character varying NOT NULL,
    wh_mst_wh_type_name character varying,
    wh_mst_wh_type_desc character varying,
    support_packing boolean DEFAULT false NOT NULL,
    support_operation boolean DEFAULT false NOT NULL,
    support_transfer boolean DEFAULT false NOT NULL,
    support_picking boolean DEFAULT false NOT NULL,
    support_return boolean DEFAULT false NOT NULL,
    transfer_to text,
    return_to text,
    "position" text
);


--
-- TOC entry 257 (class 1259 OID 19031)
-- Name: wh_mst_wh_type_wh_mst_wh_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wh_mst_wh_type_wh_mst_wh_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 257
-- Name: wh_mst_wh_type_wh_mst_wh_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wh_mst_wh_type_wh_mst_wh_type_id_seq OWNED BY public.wh_mst_wh_type.wh_mst_wh_type_id;


--
-- TOC entry 259 (class 1259 OID 19067)
-- Name: wh_mst_wh_wh_mst_wh_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wh_mst_wh_wh_mst_wh_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 259
-- Name: wh_mst_wh_wh_mst_wh_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wh_mst_wh_wh_mst_wh_id_seq OWNED BY public.wh_mst_wh.wh_mst_wh_id;


--
-- TOC entry 3048 (class 2604 OID 18715)
-- Name: approval approval_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval ALTER COLUMN approval_id SET DEFAULT nextval('public.approval_approval_id_seq'::regclass);


--
-- TOC entry 3050 (class 2604 OID 18716)
-- Name: approval_flow approval_flow_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_flow ALTER COLUMN approval_flow_id SET DEFAULT nextval('public.approval_flow_approval_flow_id_seq'::regclass);


--
-- TOC entry 3051 (class 2604 OID 18717)
-- Name: audit_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log ALTER COLUMN id SET DEFAULT nextval('public.audit_log_id_seq'::regclass);


--
-- TOC entry 3056 (class 2604 OID 18718)
-- Name: mst_customer mst_customer_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_customer ALTER COLUMN mst_customer_id SET DEFAULT nextval('public.mst_customer_mst_customer_id_seq'::regclass);


--
-- TOC entry 3061 (class 2604 OID 18719)
-- Name: mst_item_variant mst_item_variant_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_item_variant ALTER COLUMN mst_item_variant_id SET DEFAULT nextval('public.mst_item_variant_mst_item_variant_id_seq'::regclass);


--
-- TOC entry 3064 (class 2604 OID 18720)
-- Name: mst_packaging mst_packaging_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_packaging ALTER COLUMN mst_packaging_id SET DEFAULT nextval('public.mst_packaging_mst_packaging_id_seq'::regclass);


--
-- TOC entry 3067 (class 2604 OID 18721)
-- Name: mst_supplier mst_supplier_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_supplier ALTER COLUMN mst_supplier_id SET DEFAULT nextval('public.mst_supplier_mst_supplier_id_seq'::regclass);


--
-- TOC entry 3071 (class 2604 OID 18722)
-- Name: pos_branch pos_branch_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_branch ALTER COLUMN pos_branch_id SET DEFAULT nextval('public.pos_branch_pos_branch_id_seq'::regclass);


--
-- TOC entry 3075 (class 2604 OID 18723)
-- Name: pos_cashier pos_cashier_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_cashier ALTER COLUMN pos_cashier_id SET DEFAULT nextval('public.pos_cashier_pos_cashier_id_seq'::regclass);


--
-- TOC entry 3079 (class 2604 OID 18724)
-- Name: pos_discount pos_discount_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_discount ALTER COLUMN pos_discount_id SET DEFAULT nextval('public.pos_discount_pos_discount_id_seq'::regclass);


--
-- TOC entry 3082 (class 2604 OID 18725)
-- Name: pos_item_stock pos_item_stock_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_item_stock ALTER COLUMN pos_item_stock_id SET DEFAULT nextval('public.pos_item_stock_pos_item_stock_id_seq'::regclass);


--
-- TOC entry 3087 (class 2604 OID 18726)
-- Name: pos_receive_detail pos_receive_detail_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_receive_detail ALTER COLUMN pos_receive_detail_id SET DEFAULT nextval('public.pos_receive_detail_pos_receive_detail_id_seq'::regclass);


--
-- TOC entry 3090 (class 2604 OID 18727)
-- Name: pos_trx_detail pos_trx_detail_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_detail ALTER COLUMN pos_trx_detail_id SET DEFAULT nextval('public.pos_sale_detail_pos_sale_detail_id_seq'::regclass);


--
-- TOC entry 3101 (class 2604 OID 18728)
-- Name: pos_user_branch pos_user_branch_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_user_branch ALTER COLUMN pos_user_branch_id SET DEFAULT nextval('public.pos_user_branch_pos_user_branch_id_seq'::regclass);


--
-- TOC entry 3104 (class 2604 OID 18729)
-- Name: sys_menu_module sys_menu_module_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_menu_module ALTER COLUMN sys_menu_module_id SET DEFAULT nextval('public.sys_menu_module_sys_menu_module_id_seq'::regclass);


--
-- TOC entry 3105 (class 2604 OID 18730)
-- Name: sys_relation sys_relation_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_relation ALTER COLUMN sys_relation_id SET DEFAULT nextval('public.sys_relation_sys_relation_id_seq'::regclass);


--
-- TOC entry 3107 (class 2604 OID 18731)
-- Name: sys_role_section sys_role_section_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_role_section ALTER COLUMN sys_role_section_id SET DEFAULT nextval('public.sys_role_section_role_section_id_seq'::regclass);


--
-- TOC entry 3112 (class 2604 OID 18732)
-- Name: user user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user" ALTER COLUMN user_id SET DEFAULT nextval('public.user_user_id_seq'::regclass);


--
-- TOC entry 3114 (class 2604 OID 18733)
-- Name: user_authentication authentication_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_authentication ALTER COLUMN authentication_id SET DEFAULT nextval('public.user_authentication_authentication_id_seq'::regclass);


--
-- TOC entry 3117 (class 2604 OID 18734)
-- Name: user_department user_department_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_department ALTER COLUMN user_department_id SET DEFAULT nextval('public.user_department_department_id_seq'::regclass);


--
-- TOC entry 3120 (class 2604 OID 18735)
-- Name: user_section user_section_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_section ALTER COLUMN user_section_id SET DEFAULT nextval('public.user_section_section_id_seq'::regclass);


--
-- TOC entry 3132 (class 2604 OID 19236)
-- Name: wh_mst_branch id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wh_mst_branch ALTER COLUMN id SET DEFAULT nextval('public.wh_mst_branch_id_seq'::regclass);


--
-- TOC entry 3131 (class 2604 OID 19074)
-- Name: wh_mst_wh wh_mst_wh_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wh_mst_wh ALTER COLUMN wh_mst_wh_id SET DEFAULT nextval('public.wh_mst_wh_wh_mst_wh_id_seq'::regclass);


--
-- TOC entry 3123 (class 2604 OID 19038)
-- Name: wh_mst_wh_type wh_mst_wh_type_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wh_mst_wh_type ALTER COLUMN wh_mst_wh_type_id SET DEFAULT nextval('public.wh_mst_wh_type_wh_mst_wh_type_id_seq'::regclass);


--
-- TOC entry 3412 (class 0 OID 18436)
-- Dependencies: 202
-- Data for Name: approval; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.approval VALUES ('2022-07-26 03:13:07', 0, NULL, NULL, 0, 1, 25, 'user', 'User Approval', 1, NULL, NULL, NULL, NULL);
INSERT INTO public.approval VALUES ('2022-07-26 03:15:23', 0, '2022-07-26 03:33:54', 0, 0, 1, 26, 'user_section', 'User Section', 1, NULL, NULL, NULL, NULL);
INSERT INTO public.approval VALUES ('2022-07-26 04:14:20', 0, NULL, NULL, 0, 1, 27, 'mst_customer', 'Customer', 1, NULL, NULL, NULL, NULL);
INSERT INTO public.approval VALUES ('2022-08-10 03:07:44', 0, NULL, NULL, 0, 1, 28, 'pos_discount', 'POS Discount', 1, NULL, NULL, NULL, NULL);


--
-- TOC entry 3414 (class 0 OID 18446)
-- Dependencies: 204
-- Data for Name: approval_flow; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.approval_flow VALUES (NULL, 0, '2022-07-26 03:20:59', 0, 0, 'user_section', 'User Section', 1, NULL, NULL, NULL, NULL, 7, 'Yes', 1, 36, true);
INSERT INTO public.approval_flow VALUES (NULL, 0, '2022-07-27 04:00:40', 0, 0, 'user_section', 'User Section', 1, NULL, NULL, NULL, NULL, 10, 'ERre', 1, 37, true);
INSERT INTO public.approval_flow VALUES (NULL, 1, '2022-07-27 04:15:45', 1, 0, 'user_section', 'User Section', 1, NULL, NULL, NULL, NULL, 11, '', 1, 39, true);
INSERT INTO public.approval_flow VALUES (NULL, 0, '2022-08-10 03:09:42', 0, 0, 'pos_discount', 'POS Discount', 1, NULL, NULL, NULL, NULL, 42, '5ere', 1, 40, false);
INSERT INTO public.approval_flow VALUES (NULL, 0, '2022-08-23 09:43:06', 0, 0, 'pos_discount', 'POS Discount', 1, NULL, NULL, NULL, NULL, 44, '', 1, 41, true);
INSERT INTO public.approval_flow VALUES (NULL, 0, NULL, NULL, 0, 'pos_discount', 'POS Discount', 1, NULL, NULL, NULL, NULL, 46, NULL, 1, 43, NULL);
INSERT INTO public.approval_flow VALUES (NULL, 0, '2022-08-23 03:53:22', 0, 0, 'pos_discount', 'POS Discount', 1, NULL, NULL, NULL, NULL, 45, '', 1, 42, true);
INSERT INTO public.approval_flow VALUES (NULL, 0, '2022-08-24 02:32:03', 0, 0, 'pos_discount', 'POS Discount', 1, NULL, NULL, NULL, NULL, 47, '', 1, 44, true);
INSERT INTO public.approval_flow VALUES (NULL, 0, '2022-08-24 02:33:25', 0, 0, 'pos_discount', 'POS Discount', 1, NULL, NULL, NULL, NULL, 48, '', 1, 45, true);
INSERT INTO public.approval_flow VALUES (NULL, 0, '2022-08-28 10:30:22', 0, 0, 'pos_discount', 'POS Discount', 1, NULL, NULL, NULL, NULL, 49, '', 1, 46, true);
INSERT INTO public.approval_flow VALUES (NULL, 0, '2022-08-29 08:42:17', 0, 0, 'pos_discount', 'POS Discount', 1, NULL, NULL, NULL, NULL, 50, '', 1, 47, true);
INSERT INTO public.approval_flow VALUES (NULL, 0, '2022-08-29 09:25:45', 0, 0, 'mst_customer', 'Customer', 1, NULL, NULL, NULL, NULL, 3, '', 1, 38, true);


--
-- TOC entry 3417 (class 0 OID 18457)
-- Dependencies: 207
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.audit_log VALUES ('2022-07-27 16:24:46', NULL, 1, '/api/master/user', 'POST', '{"user_name":"sada","user_email":"asda@gmail.com","user_department_id":1,"user_section_id":1,"status":1,"user_id":"32","updated_by":1,"updated_at":"2022-07-27 16:24:46"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 6);
INSERT INTO public.audit_log VALUES ('2022-07-27 16:25:12', NULL, 1, '/api/master/user', 'POST', '{"user_name":"sada","user_email":"asda@gmail.com","user_department_id":1,"user_section_id":1,"status":1,"user_id":"32","updated_by":1,"updated_at":"2022-07-27 16:25:12"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 7);
INSERT INTO public.audit_log VALUES ('2022-08-23 09:52:05', NULL, 32, '/api/master/pos/discount', 'PUT', '{"discount_free_qty":0,"discount_max_qty":0,"discount_min_qty":1,"discount":13,"status":1,"pos_branch_id":5,"mst_item_variant_id":29,"date_time":["2022-08-02T02:51:52.724Z","2022-08-31T02:51:55.724Z"],"pos_discount_starttime":"2022-08-02 09:51:52","pos_discount_endtime":"2022-08-31 09:51:55","created_by":32,"created_at":"2022-08-23 09:52:05"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 8);
INSERT INTO public.audit_log VALUES ('2022-08-23 14:06:29', NULL, 32, '/api/master/pos/user-branch', 'PUT', '{"pos_branch_id":1,"user_id":1,"status":1,"is_cashier":true,"created_by":32,"created_at":"2022-08-23 14:06:29"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 9);
INSERT INTO public.audit_log VALUES ('2022-08-23 14:06:51', NULL, 32, '/api/master/pos/user-branch', 'PUT', '{"pos_branch_id":1,"user_id":1,"status":1,"is_cashier":true,"created_by":32,"created_at":"2022-08-23 14:06:51"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 10);
INSERT INTO public.audit_log VALUES ('2022-08-23 14:07:15', NULL, 32, '/api/master/pos/user-branch', 'PUT', '{"pos_branch_id":1,"user_id":1,"status":1,"is_cashier":true,"pos_branch_code":"AMD2","created_by":32,"created_at":"2022-08-23 14:07:15"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 11);
INSERT INTO public.audit_log VALUES ('2022-08-23 14:08:29', NULL, 32, '/api/master/pos/user-branch', 'POST', '{"created_at":"2022-06-15T02:00:36.000Z","created_by":0,"updated_at":"2022-08-23 14:08:29","updated_by":32,"flag_delete":0,"status":1,"user_id":1,"pos_user_branch_id":21,"is_cashier":false,"pos_branch_code":"AMD2","user_name":"gesang","user_email":"gesangseto@gmail.com","user_password":"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92","user_section_id":1,"approval":null}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 12);
INSERT INTO public.audit_log VALUES ('2022-08-23 14:08:58', NULL, 32, '/api/master/pos/user-branch', 'PUT', '{"pos_branch_id":3,"user_id":32,"status":1,"is_cashier":true,"pos_branch_code":"AMD3","created_by":32,"created_at":"2022-08-23 14:08:58"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 13);
INSERT INTO public.audit_log VALUES ('2022-08-23 14:10:19', NULL, 32, '/api/master/pos/user-branch', 'PUT', '{"pos_branch_id":3,"user_id":1,"status":1,"is_cashier":false,"pos_branch_code":"AMD3","created_by":32,"created_at":"2022-08-23 14:10:19"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 14);
INSERT INTO public.audit_log VALUES ('2022-08-23 15:19:02', NULL, 32, '/api/master/pos/discount', 'PUT', '{"discount_free_qty":0,"discount_max_qty":0,"discount_min_qty":0,"discount":5,"status":1,"pos_branch_id":3,"mst_item_variant_id":29,"date_time":["2022-08-01T08:18:48.932Z","2022-08-31T08:18:51.932Z"],"pos_discount_starttime":"2022-08-01 15:18:48","pos_discount_endtime":"2022-08-31 15:18:51","created_by":32,"created_at":"2022-08-23 15:19:02"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 15);
INSERT INTO public.audit_log VALUES ('2022-08-23 16:02:44', NULL, 32, '/api/master/pos/discount', 'POST', '{"pos_discount_id":46,"mst_item_variant_id":"29","discount":5,"pos_discount_starttime":"2022-08-01 03:18:48","pos_discount_endtime":"2022-08-31 03:18:51","discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"pos_branch_code":"AMD3","status":0,"flag_delete":0,"mst_item_variant_name":"@1","barcode":"33334","mst_item_name":"Ultramilk Kids Strawbery 120 ML","approval":{"created_at":null,"created_by":0,"updated_at":null,"updated_by":null,"flag_delete":0,"approval_ref_table":"pos_discount","approval_desc":"POS Discount","approval_user_id_1":1,"approval_user_id_2":null,"approval_user_id_3":null,"approval_user_id_4":null,"approval_user_id_5":null,"approval_ref_id":"46","rejected_note":null,"approval_current_user_id":1,"is_approve":null,"approval_user_name":"gesang","approval_user_email":"gesangseto@gmail.com"},"date_time":["2022-07-31T20:18:48.000Z","2022-08-30T20:18:51.000Z"],"updated_by":32,"updated_at":"2022-08-23 16:02:44"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 16);
INSERT INTO public.audit_log VALUES ('2022-08-24 09:00:29', NULL, 32, '/api/master/pos/user-branch', 'POST', '{"created_at":"2022-07-19T08:20:23.000Z","created_by":0,"updated_at":"2022-08-24 09:00:29","updated_by":32,"flag_delete":0,"status":1,"user_id":32,"pos_user_branch_id":22,"is_cashier":true,"pos_branch_code":"AMD3","user_name":"admin","user_email":"admin@gmail.com","user_password":"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92","user_section_id":1,"approval":null}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 17);
INSERT INTO public.audit_log VALUES ('2022-08-24 09:01:32', NULL, 32, '/api/master/pos/branch', 'POST', '{"created_at":"2022-08-18T21:08:55.000Z","created_by":0,"updated_at":"2022-08-24 09:01:32","updated_by":32,"allow_return_day":1,"pos_branch_name":"AMD - 3","pos_branch_desc":"Cabang tangerang","pos_branch_address":"JL.Bambu","pos_branch_phone":"895545646","flag_delete":0,"status":1,"pos_branch_id":3,"pos_branch_code":"AMD3","approval":null}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 18);
INSERT INTO public.audit_log VALUES ('2022-08-24 09:01:45', NULL, 32, '/api/master/pos/branch', 'POST', '{"created_at":"2022-08-22T03:18:49.000Z","created_by":0,"updated_at":"2022-08-24 09:01:45","updated_by":32,"allow_return_day":1,"pos_branch_name":"AMD - 1","pos_branch_desc":"No 53 my home","pos_branch_address":"JL Bambu","pos_branch_phone":"82122222657","flag_delete":0,"status":1,"pos_branch_id":5,"pos_branch_code":"AMD1","approval":null}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 19);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:06:24', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":null,"sale_item":[],"created_by":32,"created_at":"2022-08-27 21:06:23"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 45);
INSERT INTO public.audit_log VALUES ('2022-08-24 10:23:59', NULL, 32, '/api/transaction/pos/receive', 'PUT', '{"item":[{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"koWoA","qty":1,"_id":20},{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":23,"mst_item_id":"1659145670680","mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"Ab0e9","qty":1,"_id":23}],"pos_branch_code":"AMD3","mst_supplier_id":1,"status":0,"created_by":32,"created_at":"2022-08-24 10:23:59"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 20);
INSERT INTO public.audit_log VALUES ('2022-08-24 10:25:10', NULL, 32, '/api/transaction/pos/receive', 'PUT', '{"item":[{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"koWoA","qty":1,"_id":20},{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":23,"mst_item_id":"1659145670680","mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"Ab0e9","qty":1,"_id":23}],"pos_branch_code":"AMD3","mst_supplier_id":1,"status":0,"created_by":32,"created_at":"2022-08-24 10:25:10"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 21);
INSERT INTO public.audit_log VALUES ('2022-08-24 10:26:23', NULL, 32, '/api/transaction/pos/receive', 'PUT', '{"item":[{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"koWoA","qty":1,"_id":20},{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":23,"mst_item_id":"1659145670680","mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"Ab0e9","qty":1,"_id":23}],"pos_branch_code":"AMD3","mst_supplier_id":1,"status":0,"created_by":32,"created_at":"2022-08-24 10:26:23"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 22);
INSERT INTO public.audit_log VALUES ('2022-08-24 10:26:43', NULL, 32, '/api/transaction/pos/receive', 'PUT', '{"item":[{"key":"Uwxw3","batch_no":"","mst_item_variant_id":20,"mfg_date":"2022-08-24T03:26:37.164Z","exp_date":"2025-08-24T03:26:37.164Z","qty":1,"barcode":"123456","created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"_id":20}],"pos_branch_code":"AMD3","mst_supplier_id":1,"status":0,"created_by":32,"created_at":"2022-08-24 10:26:42"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 23);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:05:28', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661311603146","pos_receive_note":"-","created_at":"2022-08-24T03:26:42.000Z","created_by":32,"user_name":"admin","mst_item_id":"1656477974626","mst_item_name":"Djarum Super @12","mst_item_variant_qty":"1","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"1","qty_stock":"1","status":0,"batch":"","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":113,"pos_receive_id":"1661311603146","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"1","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":113,"pos_receive_id":"1661311603146","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"1","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-24 14:05:28"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 24);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:06:30', NULL, 32, '/api/transaction/pos/receive', 'PUT', '{"item":[{"key":"dyq3s","batch_no":"","mst_item_variant_id":20,"mfg_date":"2022-08-24T07:05:38.649Z","exp_date":"2025-08-24T07:05:38.649Z","qty":3,"barcode":"123456","created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"_id":20},{"key":"k3NH9","batch_no":"","mst_item_variant_id":24,"mfg_date":"2022-08-24T07:06:28.223Z","exp_date":"2025-08-24T07:06:28.223Z","qty":1,"barcode":"22222","created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_id":"1659145670680","mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_item_variant_qty":40,"mst_packaging_id":1,"mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"_id":24}],"pos_branch_code":"AMD3","mst_supplier_id":1,"status":0,"created_by":32,"created_at":"2022-08-24 14:06:30"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 25);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:07:05', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661324790443","pos_receive_note":"-","created_at":"2022-08-24T07:06:30.000Z","created_by":32,"user_name":"admin","mst_item_id":"1659145670680","mst_item_name":"Djarum Super @12,Indomie Soto","mst_item_variant_qty":"1;40","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"4","qty_stock":"43","status":0,"batch":",","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-24 14:07:05"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 26);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:07:47', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661324790443","pos_receive_note":"-","created_at":"2022-08-24T07:06:30.000Z","created_by":32,"user_name":"admin","mst_item_id":"1659145670680","mst_item_name":"Djarum Super @12,Indomie Soto","mst_item_variant_qty":"1;40","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"4","qty_stock":"43","status":0,"batch":",","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-24 14:07:47"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 27);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:08:21', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661324790443","pos_receive_note":"-","created_at":"2022-08-24T07:06:30.000Z","created_by":32,"user_name":"admin","mst_item_id":"1659145670680","mst_item_name":"Djarum Super @12,Indomie Soto","mst_item_variant_qty":"1;40","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"4","qty_stock":"43","status":0,"batch":",","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-24 14:08:20"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 28);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:12:32', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661324790443","pos_receive_note":"-","created_at":"2022-08-24T07:06:30.000Z","created_by":32,"user_name":"admin","mst_item_id":"1659145670680","mst_item_name":"Djarum Super @12,Indomie Soto","mst_item_variant_qty":"1;40","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"4","qty_stock":"43","status":0,"batch":",","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-24 14:12:32"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 29);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:13:25', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661324790443","pos_receive_note":"-","created_at":"2022-08-24T07:06:30.000Z","created_by":32,"user_name":"admin","mst_item_id":"1659145670680","mst_item_name":"Djarum Super @12,Indomie Soto","mst_item_variant_qty":"1;40","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"4","qty_stock":"43","status":0,"batch":",","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-24 14:13:25"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 30);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:13:25', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661324790443","pos_receive_note":"-","created_at":"2022-08-24T07:06:30.000Z","created_by":32,"user_name":"admin","mst_item_id":"1659145670680","mst_item_name":"Djarum Super @12,Indomie Soto","mst_item_variant_qty":"1;40","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"4","qty_stock":"43","status":0,"batch":",","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-24 14:13:25"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 31);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:13:50', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661324790443","pos_receive_note":"-","created_at":"2022-08-24T07:06:30.000Z","created_by":32,"user_name":"admin","mst_item_id":"1659145670680","mst_item_name":"Djarum Super @12,Indomie Soto","mst_item_variant_qty":"1;40","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"4","qty_stock":"43","status":0,"batch":",","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-24 14:13:50"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 32);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:14:06', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661324790443","pos_receive_note":"-","created_at":"2022-08-24T07:06:30.000Z","created_by":32,"user_name":"admin","mst_item_id":"1659145670680","mst_item_name":"Djarum Super @12,Indomie Soto","mst_item_variant_qty":"1;40","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"4","qty_stock":"43","status":0,"batch":",","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-24 14:14:06"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 33);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:15:46', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661324790443","pos_receive_note":"-","created_at":"2022-08-24T07:06:30.000Z","created_by":32,"user_name":"admin","mst_item_id":"1659145670680","mst_item_name":"Djarum Super @12,Indomie Soto","mst_item_variant_qty":"1;40","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"4","qty_stock":"43","status":0,"batch":",","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-24 14:15:46"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 34);
INSERT INTO public.audit_log VALUES ('2022-08-24 14:16:15', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661324790443","pos_receive_note":"-","created_at":"2022-08-24T07:06:30.000Z","created_by":32,"user_name":"admin","mst_item_id":"1659145670680","mst_item_name":"Djarum Super @12,Indomie Soto","mst_item_variant_qty":"1;40","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"4","qty_stock":"43","status":0,"batch":",","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":114,"pos_receive_id":"1661324790443","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"3","qty_stock":"3","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":115,"pos_receive_id":"1661324790443","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-23T17:00:00.000Z","exp_date":"2025-08-23T17:00:00.000Z","qty":"1","qty_stock":"40","mst_item_variant_id":24,"mst_item_variant_qty":40,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_packaging_id":1,"barcode":"22222","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-24 14:16:15"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 35);
INSERT INTO public.audit_log VALUES ('2022-08-27 20:41:34', NULL, 32, '/api/transaction/pos/cashier', 'PUT', '{"pos_cashier_shift":2,"pos_cashier_capital_cash":150000,"created_by":32,"created_at":"2022-08-27 20:41:33"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 36);
INSERT INTO public.audit_log VALUES ('2022-08-27 20:43:31', NULL, 32, '/api/transaction/pos/cashier', 'PUT', '{"pos_cashier_shift":2,"pos_cashier_capital_cash":150000,"created_by":32,"created_at":"2022-08-27 20:43:30"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 37);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:01:45', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"pO3YL","qty":1,"_id":20},{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":23,"mst_item_id":"1659145670680","mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"lC8HN","qty":1,"_id":23}],"mst_customer_id":"1","created_by":32,"created_at":"2022-08-27 21:01:45"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 38);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:06:04', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":null,"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"XRB7e","qty":1,"_id":20}],"mst_customer_id":"1","created_by":32,"created_at":"2022-08-27 21:06:03"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 44);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:01:54', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"pO3YL","qty":1,"_id":20},{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":23,"mst_item_id":"1659145670680","mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"lC8HN","qty":1,"_id":23}],"mst_customer_id":"1","created_by":32,"created_at":"2022-08-27 21:01:54"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 39);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:03:34', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"pO3YL","qty":1,"_id":20},{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":23,"mst_item_id":"1659145670680","mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"lC8HN","qty":1,"_id":23}],"mst_customer_id":"1","created_by":32,"created_at":"2022-08-27 21:03:34"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 40);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:04:39', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"pO3YL","qty":1,"_id":20},{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":23,"mst_item_id":"1659145670680","mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"lC8HN","qty":1,"_id":23}],"mst_customer_id":"1","created_by":32,"created_at":"2022-08-27 21:04:38"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 41);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:04:50', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"5IEoR","qty":1,"_id":20}],"mst_customer_id":"1","created_by":32,"created_at":"2022-08-27 21:04:50"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 42);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:05:24', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"5IEoR","qty":1,"_id":20}],"mst_customer_id":"1","created_by":32,"created_at":"2022-08-27 21:05:24"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 43);
INSERT INTO public.audit_log VALUES ('2022-08-29 21:32:18', NULL, 32, '/api/master/user', 'DELETE', '{"user_id":32,"updated_by":32,"updated_at":"2022-08-29 21:32:18"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 114);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:06:50', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":null,"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"ssdUB","qty":1,"_id":20}],"created_by":32,"created_at":"2022-08-27 21:06:50"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 46);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:08:31', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":null,"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"ssdUB","qty":1,"_id":20}],"created_by":32,"created_at":"2022-08-27 21:08:30"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 47);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:08:39', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":null,"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"ssdUB","qty":1,"_id":20}],"created_by":32,"created_at":"2022-08-27 21:08:38"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 48);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:10:11', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":null,"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"ssdUB","qty":1,"_id":20}],"created_by":32,"created_at":"2022-08-27 21:10:09"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 49);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:10:16', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":null,"mst_customer_id":"1","sale_item":[],"created_by":32,"created_at":"2022-08-27 21:10:15"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 50);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:10:59', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":null,"mst_customer_id":"1","sale_item":[],"created_by":32,"created_at":"2022-08-27 21:10:59"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 51);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:11:04', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":null,"mst_customer_id":null,"sale_item":[],"created_by":32,"created_at":"2022-08-27 21:11:04"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 52);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:13:02', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"m2Vlh","qty":1,"_id":20}],"created_by":32,"created_at":"2022-08-27 21:13:02"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 53);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:14:19', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"created_at":"2022-08-24T07:32:00.000Z","created_by":0,"updated_at":"2022-08-23T19:32:06.000Z","updated_by":0,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":47,"discount":12,"pos_discount_starttime":"2022-08-24T05:00:07.000Z","pos_discount_endtime":"2022-08-30T19:31:55.000Z","discount_min_qty":0,"discount_free_qty":0,"pos_discount_code":null,"discount_max_qty":0,"pos_branch_code":"AMD2","approval":null,"key":"m2Vlh","qty":1,"_id":20}],"created_by":32,"created_at":"2022-08-27 21:14:18"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 54);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:16:16', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661609659499","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661609659499","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"166","mst_item_id":"1656477974626","pos_discount_id":"47","discount":12,"total":19712,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"r4iaY"}],"created_at":"2022-08-27T02:14:18.000Z","created_by":32,"updated_at":"2022-08-27 21:16:15","updated_by":32,"flag_delete":0,"status":1,"total_price":19712,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":21683.2,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661609659499","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661609659499","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"166","mst_item_id":"1656477974626","pos_discount_id":"47","discount":12,"total":19712,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"r4iaY"}],"payment_cash":30000,"payment_change":8316.8}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 55);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:25:48', NULL, 32, '/api/transaction/pos/receive', 'PUT', '{"item":[{"key":"1otij","batch_no":"","mst_item_variant_id":20,"mfg_date":"2022-08-27T14:25:23.614Z","exp_date":"2025-08-27T14:25:23.614Z","qty":10,"barcode":"123456","created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"_id":20},{"key":"eDytW","batch_no":"","mst_item_variant_id":23,"mfg_date":"2022-08-27T14:25:44.842Z","exp_date":"2025-08-27T14:25:44.842Z","qty":10,"barcode":"11111","created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_id":"1659145670680","mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_item_variant_qty":1,"mst_packaging_id":1,"mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"_id":23}],"pos_branch_code":"AMD3","mst_supplier_id":1,"status":0,"created_by":32,"created_at":"2022-08-27 21:25:48"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 56);
INSERT INTO public.audit_log VALUES ('2022-08-27 21:26:11', NULL, 32, '/api/transaction/pos/receive', 'POST', '{"pos_receive_id":"1661610348914","pos_receive_note":"-","created_at":"2022-08-27T19:25:48.000Z","created_by":32,"user_name":"admin","mst_item_id":"1659145670680","mst_item_name":"Djarum Super @12,Indomie Soto","mst_item_variant_qty":"1;1","mst_supplier_id":1,"mst_supplier_name":"Agen Erna","qty":"20","qty_stock":"20","status":0,"batch":",","is_received":null,"pos_branch_code":"AMD3","approval":null,"detail":[{"flag_delete":0,"status":1,"pos_receive_detail_id":124,"pos_receive_id":"1661610348914","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-26T17:00:00.000Z","exp_date":"2025-08-26T17:00:00.000Z","qty":"10","qty_stock":"10","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":125,"pos_receive_id":"1661610348914","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-26T17:00:00.000Z","exp_date":"2025-08-26T17:00:00.000Z","qty":"10","qty_stock":"10","mst_item_variant_id":23,"mst_item_variant_qty":1,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"item":[{"flag_delete":0,"status":1,"pos_receive_detail_id":124,"pos_receive_id":"1661610348914","mst_item_id":"1656477974626","batch_no":"","mfg_date":"2022-08-26T17:00:00.000Z","exp_date":"2025-08-26T17:00:00.000Z","qty":"10","qty_stock":"10","mst_item_variant_id":20,"mst_item_variant_qty":1,"created_at":"2022-06-28T21:46:14.000Z","created_by":0,"updated_at":"2022-08-10T20:13:47.000Z","updated_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12"},{"flag_delete":0,"status":1,"pos_receive_detail_id":125,"pos_receive_id":"1661610348914","mst_item_id":"1659145670680","batch_no":"","mfg_date":"2022-08-26T17:00:00.000Z","exp_date":"2025-08-26T17:00:00.000Z","qty":"10","qty_stock":"10","mst_item_variant_id":23,"mst_item_variant_qty":1,"created_at":"2022-07-30T01:47:50.000Z","created_by":0,"updated_at":"2022-07-30T01:48:20.000Z","updated_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES"}],"is_approve":"true","updated_by":32,"updated_at":"2022-08-27 21:26:11"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 57);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:00:01', NULL, 32, '/api/transaction/pos/cashier', 'PUT', '{"pos_cashier_shift":1,"pos_cashier_capital_cash":150000,"created_by":32,"created_at":"2022-08-28 06:00:00"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 58);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:02:02', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"FudTZ","qty":1,"_id":20},{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":23,"mst_item_id":"1659145670680","mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"bkIKF","qty":1,"_id":23}],"created_by":32,"created_at":"2022-08-28 06:02:02"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 59);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:02:09', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:02:09","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 60);
INSERT INTO public.audit_log VALUES ('2022-09-02 14:25:24', NULL, 32, '/api/transaction/pos/return', 'PUT', '{"pos_trx_sale_id":"1661642506165","created_by":32,"created_at":"2022-09-02 14:25:24"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:36.90.70.64', 115);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:02:23', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:02:23","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 61);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:03:55', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:03:55","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 62);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:04:35', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:04:35","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 63);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:05:53', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:05:53","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 64);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:06:21', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:06:21","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 65);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:07:22', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:07:22","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 66);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:08:04', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:08:03","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 67);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:08:16', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:08:16","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"Uftif"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"OOo7Q"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 68);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:11:01', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"vKU8u"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"zwmq0"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:11:01","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"vKU8u"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"zwmq0"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 69);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:11:23', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"vKU8u"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"zwmq0"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:11:23","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"vKU8u"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"zwmq0"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 70);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:12:03', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"vKU8u"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"zwmq0"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:12:02","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"vKU8u"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"zwmq0"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 71);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:15:07', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:15:07","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 72);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:16:21', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:16:20","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 73);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:17:50', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:17:50","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 74);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:18:15', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:18:15","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 75);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:18:53', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:18:53","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 76);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:20:01', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661641322411","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"created_at":"2022-08-27T23:02:02.000Z","created_by":32,"updated_at":"2022-08-28 06:20:01","updated_by":32,"flag_delete":0,"status":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":27720,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661641322411","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"168","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"gZdHT"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661641322411","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"167","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"dsHGZ"}],"payment_cash":30000,"payment_change":2280}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 77);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:21:45', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"qlC8s","qty":4,"_id":20},{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":23,"mst_item_id":"1659145670680","mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"hjioT","qty":4,"_id":23}],"created_by":32,"created_at":"2022-08-28 06:21:45"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 78);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:22:06', NULL, 32, '/api/transaction/pos/sale', 'POST', '{"updated_at":"2022-08-28 06:22:06","updated_by":32,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661642506165","mst_item_variant_id":20,"qty":9,"price":22400,"pos_trx_detail_id":"169","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":89600,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":4,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"LeTwJ","pos_trx_sale_id":"1661642506165"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 79);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:23:10', NULL, 32, '/api/transaction/pos/sale', 'POST', '{"updated_at":"2022-08-28 06:23:09","updated_by":32,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661642506165","mst_item_variant_id":20,"qty":9,"price":22400,"pos_trx_detail_id":"169","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":89600,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":4,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"LeTwJ","pos_trx_sale_id":"1661642506165"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 80);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:23:40', NULL, 32, '/api/transaction/pos/sale', 'POST', '{"updated_at":"2022-08-28 06:23:39","updated_by":32,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661642506165","mst_item_variant_id":20,"qty":4,"price":22400,"pos_trx_detail_id":"169","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":201600,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":9,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"92tU1","pos_trx_sale_id":"1661642506165"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 81);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:23:48', NULL, 32, '/api/transaction/pos/sale', 'POST', '{"updated_at":"2022-08-28 06:23:48","updated_by":32,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661642506165","mst_item_variant_id":23,"qty":0,"price":2800,"pos_trx_detail_id":"170","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":11200,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":4,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"r1y7p","pos_trx_sale_id":"1661642506165"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 82);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:24:40', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661642506165","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661642506165","mst_item_variant_id":23,"qty":0,"price":2800,"pos_trx_detail_id":"170","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":0,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":0,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"1FXNF"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661642506165","mst_item_variant_id":20,"qty":4,"price":22400,"pos_trx_detail_id":"169","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":89600,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":4,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"MaXVr"}],"created_at":"2022-08-27T23:21:45.000Z","created_by":32,"updated_at":"2022-08-28 06:24:40","updated_by":32,"flag_delete":0,"status":1,"total_price":89600,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":98560,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661642506165","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661642506165","mst_item_variant_id":23,"qty":0,"price":2800,"pos_trx_detail_id":"170","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":0,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":0,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"1FXNF"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661642506165","mst_item_variant_id":20,"qty":4,"price":22400,"pos_trx_detail_id":"169","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":89600,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":4,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"MaXVr"}],"payment_cash":100000,"payment_change":1440}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 83);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:32:40', NULL, 32, '/api/transaction/pos/return', 'PUT', '{"pos_trx_sale_id":"1661641322411","created_by":32,"created_at":"2022-08-28 06:32:39"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 84);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:33:31', NULL, 32, '/api/transaction/pos/return', 'PUT', '{"pos_trx_sale_id":"1661641322411","created_by":32,"created_at":"2022-08-28 06:33:31"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 85);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:55:53', NULL, 32, '/api/transaction/pos/return', 'PUT', '{"pos_trx_sale_id":"1661641322411","created_by":32,"created_at":"2022-08-28 06:55:53"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 86);
INSERT INTO public.audit_log VALUES ('2022-08-28 06:56:49', NULL, 32, '/api/transaction/pos/return', 'PUT', '{"pos_trx_sale_id":"1661642506165","created_by":32,"created_at":"2022-08-28 06:56:49"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 87);
INSERT INTO public.audit_log VALUES ('2022-08-28 07:01:11', NULL, 32, '/api/transaction/pos/return', 'PUT', '{"pos_trx_sale_id":"1661641322411","created_by":32,"created_at":"2022-08-28 07:01:11"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 88);
INSERT INTO public.audit_log VALUES ('2022-08-28 07:01:49', NULL, 32, '/api/transaction/pos/return', 'PUT', '{"pos_trx_sale_id":"1661641322411","pos_branch_code":"AMD3","created_by":32,"created_at":"2022-08-28 07:01:49"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 89);
INSERT INTO public.audit_log VALUES ('2022-08-28 07:03:13', NULL, 32, '/api/transaction/pos/return', 'PUT', '{"pos_trx_sale_id":"1661641322411","pos_branch_code":null,"created_by":32,"created_at":"2022-08-28 07:03:12"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 90);
INSERT INTO public.audit_log VALUES ('2022-08-28 07:04:05', NULL, 32, '/api/transaction/pos/return', 'PUT', '{"pos_trx_sale_id":"1661641322411","pos_branch_code":null,"created_by":32,"created_at":"2022-08-28 07:04:05"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 91);
INSERT INTO public.audit_log VALUES ('2022-08-28 07:05:19', NULL, 32, '/api/transaction/pos/return', 'PUT', '{"pos_trx_sale_id":"1661641322411","created_by":32,"created_at":"2022-08-28 07:05:18"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 92);
INSERT INTO public.audit_log VALUES ('2022-08-28 07:06:08', NULL, 32, '/api/transaction/pos/return', 'PUT', '{"pos_trx_sale_id":"1661641322411","created_by":32,"created_at":"2022-08-28 07:06:08"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 93);
INSERT INTO public.audit_log VALUES ('2022-08-28 07:09:51', NULL, 32, '/api/transaction/pos/return', 'POST', '{"created_at":"2022-08-28T00:06:08.000Z","created_by":32,"updated_at":"2022-08-28 07:09:50","updated_by":32,"flag_delete":0,"status":0,"pos_trx_sale_id":"1661641322411","mst_customer_id":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_returned":null,"grand_total":27720,"payment_type":"Cash","pos_trx_return_id":"1661645169372","pos_branch_code":"AMD3","mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","user_id":32,"user_name":"admin","user_email":"admin@gmail.com","user_password":"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92","user_section_id":1,"pos_trx_ref_id":"1661645169372","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661645169372","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"171","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661645169372","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"172","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing"}],"is_approve":"true"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 94);
INSERT INTO public.audit_log VALUES ('2022-08-28 07:11:38', NULL, 32, '/api/transaction/pos/return', 'POST', '{"created_at":"2022-08-28T00:06:08.000Z","created_by":32,"updated_at":"2022-08-28 07:11:37","updated_by":32,"flag_delete":0,"status":0,"pos_trx_sale_id":"1661641322411","mst_customer_id":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_returned":null,"grand_total":27720,"payment_type":"Cash","pos_trx_return_id":"1661645169372","pos_branch_code":"AMD3","mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","user_id":32,"user_name":"admin","user_email":"admin@gmail.com","user_password":"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92","user_section_id":1,"pos_trx_ref_id":"1661645169372","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661645169372","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"171","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661645169372","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"172","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing"}],"is_approve":"true"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 95);
INSERT INTO public.audit_log VALUES ('2022-08-28 07:12:39', NULL, 32, '/api/transaction/pos/return', 'POST', '{"created_at":"2022-08-28T00:06:08.000Z","created_by":32,"updated_at":"2022-08-28 07:12:38","updated_by":32,"flag_delete":0,"status":0,"pos_trx_sale_id":"1661641322411","mst_customer_id":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_returned":null,"grand_total":27720,"payment_type":"Cash","pos_trx_return_id":"1661645169372","pos_branch_code":"AMD3","mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","user_id":32,"user_name":"admin","user_email":"admin@gmail.com","user_password":"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92","user_section_id":1,"pos_trx_ref_id":"1661645169372","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661645169372","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"171","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661645169372","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"172","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing"}],"is_approve":"true"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 96);
INSERT INTO public.audit_log VALUES ('2022-08-28 07:13:24', NULL, 32, '/api/transaction/pos/return', 'POST', '{"created_at":"2022-08-28T00:06:08.000Z","created_by":32,"updated_at":"2022-08-28 07:13:22","updated_by":32,"flag_delete":0,"status":0,"pos_trx_sale_id":"1661641322411","mst_customer_id":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_returned":null,"grand_total":27720,"payment_type":"Cash","pos_trx_return_id":"1661645169372","pos_branch_code":"AMD3","mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","user_id":32,"user_name":"admin","user_email":"admin@gmail.com","user_password":"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92","user_section_id":1,"pos_trx_ref_id":"1661645169372","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661645169372","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"171","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661645169372","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"172","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing"}],"is_approve":"true"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 97);
INSERT INTO public.audit_log VALUES ('2022-08-28 07:13:47', NULL, 32, '/api/transaction/pos/return', 'POST', '{"created_at":"2022-08-28T00:06:08.000Z","created_by":32,"updated_at":"2022-08-28 07:13:46","updated_by":32,"flag_delete":0,"status":0,"pos_trx_sale_id":"1661641322411","mst_customer_id":1,"total_price":25200,"ppn":"10","price_percentage":"12","is_returned":null,"grand_total":27720,"payment_type":"Cash","pos_trx_return_id":"1661645169372","pos_branch_code":"AMD3","mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","user_id":32,"user_name":"admin","user_email":"admin@gmail.com","user_password":"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92","user_section_id":1,"pos_trx_ref_id":"1661645169372","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661645169372","mst_item_variant_id":23,"qty":1,"price":2800,"pos_trx_detail_id":"171","mst_item_id":"1659145670680","pos_discount_id":null,"discount":0,"total":2800,"capital_price":2500,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Bungkus","mst_item_variant_price":2500,"mst_packaging_id":1,"barcode":"11111","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing"},{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661645169372","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"172","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing"}],"is_approve":"true"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:127.0.0.1', 98);
INSERT INTO public.audit_log VALUES ('2022-08-28 10:07:14', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":24,"mst_item_id":"1659145670680","mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_item_variant_qty":40,"mst_packaging_id":1,"barcode":"22222","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"tZHyv","qty":1,"_id":24}],"created_by":32,"created_at":"2022-08-28 10:07:14"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 99);
INSERT INTO public.audit_log VALUES ('2022-08-28 10:07:22', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":24,"mst_item_id":"1659145670680","mst_item_variant_name":"Dus","mst_item_variant_price":90000,"mst_item_variant_qty":40,"mst_packaging_id":1,"barcode":"22222","mst_item_no":"INDMIES","mst_item_name":"Indomie Soto","mst_item_desc":"-","mst_item_code":"INDMIES","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"tZHyv","qty":1,"_id":24}],"created_by":32,"created_at":"2022-08-28 10:07:22"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 100);
INSERT INTO public.audit_log VALUES ('2022-08-28 10:07:36', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"lBB0C","qty":1,"_id":20}],"created_by":32,"created_at":"2022-08-28 10:07:36"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 101);
INSERT INTO public.audit_log VALUES ('2022-08-28 10:07:41', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661656056632","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661656056632","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"176","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"NH3JO"}],"created_at":"2022-08-28T03:07:36.000Z","created_by":32,"updated_at":"2022-08-28 10:07:41","updated_by":32,"flag_delete":0,"status":1,"total_price":22400,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":24640,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661656056632","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661656056632","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"176","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"NH3JO"}],"payment_cash":25000,"payment_change":360}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 102);
INSERT INTO public.audit_log VALUES ('2022-08-29 16:09:07', NULL, 32, '/api/master/user_department', 'POST', '{"user_department_code":"IT","user_department_name":"Information Technology","status":1,"user_department_id":"1","updated_by":32,"updated_at":"2022-08-29 16:09:07"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:36.71.53.88', 103);
INSERT INTO public.audit_log VALUES ('2022-08-29 16:09:16', NULL, 32, '/api/master/user_department', 'DELETE', '{"user_department_id":7,"updated_by":32,"updated_at":"2022-08-29 16:09:16"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:36.71.53.88', 104);
INSERT INTO public.audit_log VALUES ('2022-08-29 16:16:42', NULL, 32, '/api/master/user_department', 'DELETE', '{"user_department_id":7,"updated_by":32,"updated_at":"2022-08-29 16:16:42"}', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:36.71.53.88', 105);
INSERT INTO public.audit_log VALUES ('2022-08-29 20:16:06', NULL, 32, '/api/transaction/pos/sale', 'PUT', '{"pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"created_at":null,"created_by":null,"updated_at":null,"updated_by":null,"flag_delete":0,"status":1,"mst_item_variant_id":20,"mst_item_id":"1656477974626","mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_item_variant_qty":1,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","pos_discount_id":null,"discount":null,"pos_discount_starttime":null,"pos_discount_endtime":null,"discount_min_qty":null,"discount_free_qty":null,"pos_discount_code":null,"discount_max_qty":null,"pos_branch_code":null,"approval":null,"key":"wCd0K","qty":1,"_id":20}],"created_by":32,"created_at":"2022-08-29 20:16:06"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 106);
INSERT INTO public.audit_log VALUES ('2022-08-29 20:16:17', NULL, 32, '/api/transaction/pos/sale/payment', 'POST', '{"pos_trx_sale_id":"1661778966477","payment_type":"Cash","pos_branch_code":"AMD3","mst_customer_id":1,"sale_item":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661778966477","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"177","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"aM5ju"}],"created_at":"2022-08-29T01:16:06.000Z","created_by":32,"updated_at":"2022-08-29 20:16:17","updated_by":32,"flag_delete":0,"status":1,"total_price":22400,"ppn":"10","price_percentage":"12","is_paid":false,"grand_total":24640,"mst_customer_name":"Guest","mst_customer_email":"admin@admin.com","mst_customer_phone":"082122222657","mst_customer_address":"JL Bambu","mst_customer_pic":"Gesang","mst_customer_ppn":"10","approval":null,"pos_trx_ref_id":"1661778966477","detail":[{"updated_at":"2022-07-30T01:39:09.000Z","updated_by":0,"flag_delete":0,"status":1,"pos_trx_ref_id":"1661778966477","mst_item_variant_id":20,"qty":1,"price":22400,"pos_trx_detail_id":"177","mst_item_id":"1656477974626","pos_discount_id":null,"discount":0,"total":22400,"capital_price":20000,"mst_item_variant_qty":1,"qty_stock":1,"discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"created_at":"2022-06-27T04:28:53.000Z","created_by":0,"mst_item_variant_name":"Pack","mst_item_variant_price":20000,"mst_packaging_id":1,"barcode":"123456","mst_item_no":"DJS12","mst_item_name":"Djarum Super @12","mst_item_desc":"-","mst_item_code":"DJS12","mst_packaging_code":"Bks","mst_packaging_name":"bungkus","mst_packaging_desc":"Nothing","key":"aM5ju"}],"payment_cash":25000,"payment_change":360}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 107);
INSERT INTO public.audit_log VALUES ('2022-08-29 20:41:07', NULL, 32, '/api/master/pos/discount', 'PUT', '{"discount_free_qty":0,"discount_max_qty":0,"discount_min_qty":0,"discount":90,"status":1,"pos_branch_code":"AMD3","mst_item_variant_id":20,"date_time":["2022-08-01T13:40:51.352Z","2022-08-31T13:40:55.352Z"],"pos_discount_starttime":"2022-08-01 20:40:51","pos_discount_endtime":"2022-08-31 20:40:55","created_by":32,"created_at":"2022-08-29 20:41:07"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 108);
INSERT INTO public.audit_log VALUES ('2022-08-29 20:41:14', NULL, 32, '/api/master/pos/discount', 'POST', '{"pos_discount_id":50,"mst_item_variant_id":"20","discount":90,"pos_discount_starttime":"2022-08-01 08:40:51","pos_discount_endtime":"2022-08-31 08:40:55","discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"status":1,"flag_delete":0,"mst_item_variant_name":"Pack","barcode":"123456","mst_item_name":"Djarum Super @12","pos_branch_code":"AMD3","approval":{"created_at":null,"created_by":0,"updated_at":null,"updated_by":null,"flag_delete":0,"approval_ref_table":"pos_discount","approval_desc":"POS Discount","approval_user_id_1":1,"approval_user_id_2":null,"approval_user_id_3":null,"approval_user_id_4":null,"approval_user_id_5":null,"approval_ref_id":"50","rejected_note":null,"approval_current_user_id":1,"is_approve":null,"approval_user_name":"gesang","approval_user_email":"gesangseto@gmail.com"},"date_time":["2022-08-01T01:40:51.000Z","2022-08-31T01:40:55.000Z"],"updated_by":32,"updated_at":"2022-08-29 20:41:14"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 109);
INSERT INTO public.audit_log VALUES ('2022-08-29 20:42:00', NULL, 32, '/api/master/pos/discount', 'POST', '{"pos_discount_id":50,"mst_item_variant_id":"20","discount":90,"pos_discount_starttime":"2022-08-01 08:40:51","pos_discount_endtime":"2022-08-31 08:40:55","discount_min_qty":0,"discount_max_qty":0,"discount_free_qty":0,"status":1,"flag_delete":0,"mst_item_variant_name":"Pack","barcode":"123456","mst_item_name":"Djarum Super @12","pos_branch_code":"AMD3","approval":{"created_at":null,"created_by":0,"updated_at":null,"updated_by":null,"flag_delete":0,"approval_ref_table":"pos_discount","approval_desc":"POS Discount","approval_user_id_1":1,"approval_user_id_2":null,"approval_user_id_3":null,"approval_user_id_4":null,"approval_user_id_5":null,"approval_ref_id":"50","rejected_note":null,"approval_current_user_id":1,"is_approve":null,"approval_user_name":"gesang","approval_user_email":"gesangseto@gmail.com"},"date_time":["2022-08-01T01:40:51.000Z","2022-08-31T01:40:55.000Z"],"updated_by":32,"updated_at":"2022-08-29 20:42:00"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 110);
INSERT INTO public.audit_log VALUES ('2022-08-29 21:31:24', NULL, 32, '/api/master/user_department', 'POST', '{"user_department_code":"AppTest","user_department_name":"Approval Test","status":1,"user_department_id":"15","updated_by":32,"updated_at":"2022-08-29 21:31:24"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 111);
INSERT INTO public.audit_log VALUES ('2022-08-29 21:31:28', NULL, 32, '/api/master/user_department', 'POST', '{"user_department_code":"TESTIGN","user_department_name":"hgsdahjgdjas","status":0,"user_department_id":"16","updated_by":32,"updated_at":"2022-08-29 21:31:28"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 112);
INSERT INTO public.audit_log VALUES ('2022-08-29 21:32:12', NULL, 32, '/api/master/user_department', 'DELETE', '{"user_department_id":16,"updated_by":32,"updated_at":"2022-08-29 21:32:12"}', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36', '::ffff:110.137.195.72', 113);


--
-- TOC entry 3419 (class 0 OID 18465)
-- Dependencies: 209
-- Data for Name: base_table; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3420 (class 0 OID 18470)
-- Dependencies: 210
-- Data for Name: mst_customer; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.mst_customer VALUES ('2022-07-26 16:13:32', 0, '2022-07-26 16:13:40', 0, 0, 1, 2, 'ewq', 'wqeq@sda', '123131', '1231dsaed', 'sda', '12', '1234');
INSERT INTO public.mst_customer VALUES ('2022-06-30 11:02:30', 0, '2022-08-02 11:51:34', 0, 0, 1, 1, 'Guest', 'admin@admin.com', '082122222657', 'JL Bambu', 'Gesang', '10', '12');
INSERT INTO public.mst_customer VALUES ('2022-07-26 16:14:37', 0, '2022-08-29 09:25:48', 0, 0, 1, 3, 'Test', 'gesang@gmail.com', '08215415412sa', 'da', 'Test', '12', '12');


--
-- TOC entry 3422 (class 0 OID 18480)
-- Dependencies: 212
-- Data for Name: mst_item; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.mst_item VALUES ('2022-07-30 08:47:50', 0, '2022-07-30 08:48:20', 0, 0, 1, 1659145670680, 'INDMIES', 'Indomie Soto', '-', 'INDMIES');
INSERT INTO public.mst_item VALUES ('2022-08-08 10:28:49', 0, NULL, NULL, 0, 1, 1659929329253, 'BCG1', 'Ultramilk Kids Coklat 120ML', '-', 'BCG1');
INSERT INTO public.mst_item VALUES ('2022-08-08 10:30:11', 0, NULL, NULL, 0, 1, 1659929411583, 'BCG2', 'Ultramilk Kids Strawbery 120 ML', '-', 'BCG2');
INSERT INTO public.mst_item VALUES ('2022-06-29 04:46:14', 0, '2022-08-11 03:13:47', 0, 0, 1, 1656477974626, 'DJS12', 'Djarum Super @12', '-', 'DJS12');


--
-- TOC entry 3424 (class 0 OID 18490)
-- Dependencies: 214
-- Data for Name: mst_item_variant; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.mst_item_variant VALUES ('2022-06-27 11:28:53', 0, '2022-07-30 08:39:09', 0, 0, 1, 23, 1659145670680, 'Bungkus', 2500, 1, 1, '11111');
INSERT INTO public.mst_item_variant VALUES ('2022-07-30 08:39:35', 0, NULL, NULL, 0, 1, 24, 1659145670680, 'Dus', 90000, 40, 1, '22222');
INSERT INTO public.mst_item_variant VALUES (NULL, NULL, NULL, NULL, 0, 1, 29, 1659929411583, '@1', 2450, 1, 1, '33334');
INSERT INTO public.mst_item_variant VALUES (NULL, NULL, NULL, NULL, 0, 1, 30, 1659929411583, '@24', 124500, 24, 9, '44443');
INSERT INTO public.mst_item_variant VALUES (NULL, NULL, NULL, NULL, 1, 1, 27, 1659929329253, '-', 2400, 1, 1, '33333');
INSERT INTO public.mst_item_variant VALUES (NULL, NULL, NULL, NULL, 1, 1, 28, 1659929329253, '-', 124000, 24, 9, '44444');
INSERT INTO public.mst_item_variant VALUES ('2022-07-30 08:39:35', 0, '2022-07-30 08:39:09', 0, 0, 1, 22, 1656477974626, 'Selop', 200000, 12, 8, '8994171101289');
INSERT INTO public.mst_item_variant VALUES ('2022-06-27 11:28:53', 0, '2022-07-30 08:39:09', 0, 0, 1, 20, 1656477974626, 'Pack', 20000, 1, 1, '123456');


--
-- TOC entry 3426 (class 0 OID 18500)
-- Dependencies: 216
-- Data for Name: mst_packaging; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.mst_packaging VALUES ('2022-06-27 11:28:53', 0, '2022-07-30 08:39:09', 0, 0, 1, 1, 'Bks', 'bungkus', 'Nothing');
INSERT INTO public.mst_packaging VALUES ('2022-07-30 08:39:35', 0, NULL, NULL, 0, 1, 8, 'Slop', 'Selop', '-');
INSERT INTO public.mst_packaging VALUES ('2022-07-30 08:48:06', 0, NULL, NULL, 0, 1, 9, 'Dus', 'Dus', '-');


--
-- TOC entry 3428 (class 0 OID 18510)
-- Dependencies: 218
-- Data for Name: mst_supplier; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.mst_supplier VALUES ('2022-06-30 10:55:18', 0, '2022-07-27 16:24:29', 0, 0, 1, 1, 'Agen Erna', 'admin@admin.com', 'JL Bambu', '082122222657', 'Gesang');


--
-- TOC entry 3430 (class 0 OID 18520)
-- Dependencies: 220
-- Data for Name: pos_branch; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_branch VALUES ('2022-08-18 20:36:46+02', 0, '2022-08-22 05:19:59+02', 0, 1, 'AMD - 2', 'Test', 'JL.Bambu', 82122222657, 0, 1, 1, 'AMD2');
INSERT INTO public.pos_branch VALUES ('2022-08-23 04:40:04+02', 0, NULL, NULL, 0, 'Tes2', '123', 'kljljasfd', 854541212, 0, 1, 8, 'ASC');
INSERT INTO public.pos_branch VALUES ('2022-08-18 23:08:55+02', 0, '2022-08-24 04:01:32+02', 32, 1, 'AMD - 3', 'Cabang tangerang', 'JL.Bambu', 895545646, 0, 1, 3, 'AMD3');
INSERT INTO public.pos_branch VALUES ('2022-08-22 05:18:49+02', 0, '2022-08-24 04:01:45+02', 32, 1, 'AMD - 1', 'No 53 my home', 'JL Bambu', 82122222657, 0, 1, 5, 'AMD1');


--
-- TOC entry 3432 (class 0 OID 18531)
-- Dependencies: 222
-- Data for Name: pos_cashier; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_cashier VALUES ('2022-08-28 06:00:00', 32, NULL, NULL, 0, 1, 20, '150000', '1', true, NULL, 'AMD3');


--
-- TOC entry 3434 (class 0 OID 18542)
-- Dependencies: 224
-- Data for Name: pos_discount; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_discount VALUES ('2022-08-28 10:30:12+02', 0, '2022-08-28 10:30:23+02', 0, 0, 0, 49, 29, 7, '2022-08-04 10:29:51', '2022-08-31 10:29:55', 0, 0, NULL, 0, 'AMD2');
INSERT INTO public.pos_discount VALUES ('2022-08-29 20:41:07+02', 32, '2022-08-29 08:42:23+02', 0, 0, 0, 50, 20, 90, '2022-08-01 08:40:51', '2022-08-31 08:40:55', 0, 0, NULL, 0, 'AMD3');


--
-- TOC entry 3436 (class 0 OID 18553)
-- Dependencies: 226
-- Data for Name: pos_item_stock; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_item_stock VALUES ('2022-07-30 08:47:50+02', 0, '2022-07-30 08:48:20+02', 0, 0, 1, 64, 1659145670680, 10, 'AMD1');
INSERT INTO public.pos_item_stock VALUES ('2022-06-27 11:28:53+02', 0, '2022-07-30 08:39:09+02', 0, 0, 1, 63, 1656477974626, 9, 'AMD1');
INSERT INTO public.pos_item_stock VALUES ('2022-06-27 11:28:53+02', 0, '2022-07-30 08:39:09+02', 0, 0, 1, 65, 1656477974626, 4, 'AMD3');
INSERT INTO public.pos_item_stock VALUES ('2022-07-30 08:47:50+02', 0, '2022-07-30 08:48:20+02', 0, 0, 1, 66, 1659145670680, 10, 'AMD3');


--
-- TOC entry 3438 (class 0 OID 18563)
-- Dependencies: 228
-- Data for Name: pos_receive; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_receive VALUES ('2022-08-27 21:25:48+02', 32, NULL, NULL, 0, 1, 1661610348914, 1, NULL, '-', true, 'AMD3');
INSERT INTO public.pos_receive VALUES ('2022-08-28 05:58:12+02', 0, NULL, NULL, 0, 1, 1661641092006, 1, NULL, '-', true, 'AMD1');
INSERT INTO public.pos_receive VALUES ('2022-08-29 21:26:19+02', 0, NULL, NULL, 0, 1, 1661783179013, 1, NULL, '-', true, 'AMD3');
INSERT INTO public.pos_receive VALUES ('2022-09-02 14:34:48+02', 0, NULL, NULL, 0, 0, 1662104088232, 1, NULL, NULL, NULL, 'AMD2');


--
-- TOC entry 3439 (class 0 OID 18571)
-- Dependencies: 229
-- Data for Name: pos_receive_detail; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_receive_detail VALUES (0, 1, 124, 1661610348914, 1656477974626, '', '2022-08-27', '2025-08-27', 10, 10, 20, 1);
INSERT INTO public.pos_receive_detail VALUES (0, 1, 125, 1661610348914, 1659145670680, '', '2022-08-27', '2025-08-27', 10, 10, 23, 1);
INSERT INTO public.pos_receive_detail VALUES (0, 1, 126, 1661641092006, 1656477974626, '', '2022-08-27', '2025-08-27', 10, 10, 20, 1);
INSERT INTO public.pos_receive_detail VALUES (0, 1, 127, 1661641092006, 1659145670680, '', '2022-08-27', '2025-08-27', 10, 10, 23, 1);
INSERT INTO public.pos_receive_detail VALUES (0, 1, 128, 1661783179013, 1659145670680, '', '2022-08-29', '2025-08-29', 1, 1, 23, 1);
INSERT INTO public.pos_receive_detail VALUES (0, 1, 129, 1662104088232, 1656477974626, '', '2022-09-02', '2025-09-02', 2, 2, 20, 1);
INSERT INTO public.pos_receive_detail VALUES (0, 1, 130, 1662104088232, 1659145670680, '', '2022-09-02', '2025-09-02', 2, 2, 23, 1);


--
-- TOC entry 3445 (class 0 OID 18599)
-- Dependencies: 235
-- Data for Name: pos_trx_destroy; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_trx_destroy VALUES ('2022-08-28 07:28:00', 0, NULL, NULL, 0, 1, 20000, 0, true, 20000, 1661646480119, '-', 'AMD2');
INSERT INTO public.pos_trx_destroy VALUES ('2022-08-28 07:37:49', 0, '2022-08-28 07:45:43', 0, 0, 0, 2500, 0, NULL, 2500, 1661647069069, '-', 'ASC');
INSERT INTO public.pos_trx_destroy VALUES ('2022-08-28 07:33:38', 0, '2022-08-28 07:46:09', 0, 0, 1, 2500, 0, true, 2500, 1661646818379, '-', 'AMD3');


--
-- TOC entry 3441 (class 0 OID 18581)
-- Dependencies: 231
-- Data for Name: pos_trx_detail; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1661641322411, 20, 1, 22400, 167, 1656477974626, NULL, 0, 22400, 20000, 1, 1, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1661641322411, 23, 1, 2800, 168, 1659145670680, NULL, 0, 2800, 2500, 1, 1, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1661642506165, 23, 0, 2800, 170, 1659145670680, NULL, 0, 0, 2500, 1, 0, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1661642506165, 20, 4, 22400, 169, 1656477974626, NULL, 0, 89600, 20000, 1, 4, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1661645169372, 23, 1, 2800, 171, 1659145670680, NULL, 0, 2800, 2500, 1, 1, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1661645169372, 20, 1, 22400, 172, 1656477974626, NULL, 0, 22400, 20000, 1, 1, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1661646480119, 20, 1, 20000, 173, 1656477974626, NULL, 0, 20000, 20000, 1, 1, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1661646818379, 23, 1, 2500, 174, 1659145670680, NULL, 0, 2500, 2500, 1, 1, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1661647069069, 23, 1, 2500, 175, 1659145670680, NULL, 0, 2500, 2500, 1, 1, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1661656056632, 20, 1, 22400, 176, 1656477974626, NULL, 0, 22400, 20000, 1, 1, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1661778966477, 20, 1, 22400, 177, 1656477974626, NULL, 0, 22400, 20000, 1, 1, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1662103524421, 23, 0, 2800, 178, 1659145670680, NULL, 0, 0, 2500, 1, 0, 0, 0, 0);
INSERT INTO public.pos_trx_detail VALUES (NULL, NULL, 0, 1, 1662103524421, 20, 4, 22400, 179, 1656477974626, NULL, 0, 89600, 20000, 1, 4, 0, 0, 0);


--
-- TOC entry 3446 (class 0 OID 18607)
-- Dependencies: 236
-- Data for Name: pos_trx_inbound; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_trx_inbound VALUES ('2022-08-28 02:25:48+02', 32, 1661610373412, 'receive', 1, NULL, NULL, 1661610348914, 'pos_receive', 'AMD3');
INSERT INTO public.pos_trx_inbound VALUES ('2022-08-28 10:58:12+02', 0, 1661641096803, 'receive', 1, NULL, NULL, 1661641092006, 'pos_receive', 'AMD1');
INSERT INTO public.pos_trx_inbound VALUES ('2022-08-28 07:06:08+02', 32, 1661645627559, 'return', NULL, 1, NULL, 1661645169372, 'pos_trx_return', 'AMD3');
INSERT INTO public.pos_trx_inbound VALUES ('2022-08-30 02:26:19+02', 0, 1661783186141, 'receive', 1, NULL, NULL, 1661783179013, 'pos_receive', 'AMD3');


--
-- TOC entry 3447 (class 0 OID 18613)
-- Dependencies: 237
-- Data for Name: pos_trx_return; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_trx_return VALUES ('2022-08-28 07:06:08', 32, '2022-08-28 07:13:46', 32, 0, 1, 1661641322411, 1, 25200, '10', 12, true, 27720, 'Cash', 1661645169372, 'AMD3');
INSERT INTO public.pos_trx_return VALUES ('2022-09-02 14:25:24', 32, NULL, NULL, 0, 0, 1661642506165, 1, 89600, '10', 12, NULL, 98560, 'Cash', 1662103524421, 'AMD3');


--
-- TOC entry 3443 (class 0 OID 18588)
-- Dependencies: 233
-- Data for Name: pos_trx_sale; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_trx_sale VALUES ('2022-08-28 06:02:02', 32, '2022-08-28 06:20:01', 32, 0, 1, 1661641322411, 1, 25200, '10', 12, true, 27720, 'Cash', 'AMD3');
INSERT INTO public.pos_trx_sale VALUES ('2022-08-28 06:21:45', 32, '2022-08-28 06:24:40', 32, 0, 1, 1661642506165, 1, 89600, '10', 12, true, 98560, 'Cash', 'AMD3');
INSERT INTO public.pos_trx_sale VALUES ('2022-08-28 10:07:36', 32, '2022-08-28 10:07:41', 32, 0, 1, 1661656056632, 1, 22400, '10', 12, true, 24640, 'Cash', 'AMD3');
INSERT INTO public.pos_trx_sale VALUES ('2022-08-29 08:16:06', 32, '2022-08-29 08:16:17', 32, 0, 1, 1661778966477, 1, 22400, '10', 12, true, 24640, 'Cash', 'AMD3');


--
-- TOC entry 3448 (class 0 OID 18621)
-- Dependencies: 238
-- Data for Name: pos_user_branch; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pos_user_branch VALUES ('2022-06-15 04:00:36+02', 0, '2022-08-22 21:08:29+02', 32, 0, 1, 1, 21, false, 'AMD2');
INSERT INTO public.pos_user_branch VALUES ('2022-08-23 09:10:19+02', 32, NULL, NULL, 0, 1, 1, 23, false, 'AMD3');
INSERT INTO public.pos_user_branch VALUES ('2022-07-18 22:20:23+02', 0, '2022-08-24 04:00:29+02', 32, 0, 1, 32, 22, true, 'AMD3');
INSERT INTO public.pos_user_branch VALUES ('2022-08-29 19:05:28+02', 0, NULL, NULL, 0, 1, 31, 24, true, 'AMD3');


--
-- TOC entry 3450 (class 0 OID 18632)
-- Dependencies: 240
-- Data for Name: sys_configuration; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sys_configuration VALUES ('2022-09-06 10:18:58', 1, 'ERP-By Gesang', 'data:image/jpeg;base64,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', 'super_admin', 'a075d17f3d453073853f813838c15b8023b8c487038436354fe599c3942e1f95', 1, 30, '{"text":"","bcid":"ean13","includetext":true,"height":13,"scale":3,"textxalign":"center"}');


--
-- TOC entry 3451 (class 0 OID 18638)
-- Dependencies: 241
-- Data for Name: sys_menu; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sys_menu VALUES (1, 1, 'Dashboard', '/Dashboard', 'FundOutlined', NULL, 1, 1);
INSERT INTO public.sys_menu VALUES (1, 2, 'Master', '/Master', 'HddOutlined', NULL, 2, 1);
INSERT INTO public.sys_menu VALUES (1, 5, 'Department', '/Master/Department', '', 2, 2.1, 1);
INSERT INTO public.sys_menu VALUES (1, 6, 'Role', '/Master/Role', '', 2, 2.4, 1);
INSERT INTO public.sys_menu VALUES (1, 3, 'User', '/Master/User', NULL, 2, 2.3, 1);
INSERT INTO public.sys_menu VALUES (1, 4, 'Section', '/Master/Section', '', 2, 2.2, 1);
INSERT INTO public.sys_menu VALUES (1, 10, 'Customer', '/Masterdata/Customer', NULL, 9, 3.1, 1);
INSERT INTO public.sys_menu VALUES (1, 9, 'Master data', '/Masterdata', 'FolderOpenOutlined', NULL, 3, 1);
INSERT INTO public.sys_menu VALUES (1, 12, 'Packaging', '/Masterdata/Packaging', NULL, 9, 3.3, 1);
INSERT INTO public.sys_menu VALUES (1, 11, 'Supplier', '/Masterdata/Supplier', NULL, 9, 3.2, 1);
INSERT INTO public.sys_menu VALUES (1, 111, 'Receive', '/pos/transaction/receive', '', 110, 111, 2);
INSERT INTO public.sys_menu VALUES (1, 13, 'Product / Item', '/Masterdata/item', NULL, 9, 3.4, 1);
INSERT INTO public.sys_menu VALUES (1, 112, 'Inbound', '/pos/transaction/inbound', '', 110, 112, 2);
INSERT INTO public.sys_menu VALUES (1, 8, 'Workflow Approval', '/System/Approval', NULL, 7, 4.1, 1);
INSERT INTO public.sys_menu VALUES (1, 7, 'System', '/System', 'SettingOutlined', NULL, 4, 1);
INSERT INTO public.sys_menu VALUES (1, 14, 'Audit', '/System/Audit', NULL, 7, 4.2, 1);
INSERT INTO public.sys_menu VALUES (1, 113, 'Sale', '/pos/transaction/sale', '', 110, 113, 2);
INSERT INTO public.sys_menu VALUES (1, 114, 'Return', '/pos/transaction/return', '', 110, 114, 2);
INSERT INTO public.sys_menu VALUES (1, 115, 'Destroy', '/pos/transaction/destroy', '', 110, 115, 2);
INSERT INTO public.sys_menu VALUES (1, 120, 'Stock', '/pos/transaction/stock', 'ContainerOutlined', NULL, 120, 2);
INSERT INTO public.sys_menu VALUES (1, 130, 'Report', '/pos/report', 'FileTextOutlined', NULL, 130, 2);
INSERT INTO public.sys_menu VALUES (1, 15, 'Config Relation', '/System/Config-Relation', NULL, 7, 4.3, 1);
INSERT INTO public.sys_menu VALUES (1, 131, 'Sale', '/pos/report/sale', '', 130, 131, 2);
INSERT INTO public.sys_menu VALUES (1, 101, 'Branch', '/pos/master/branch', '', 100, 101, 2);
INSERT INTO public.sys_menu VALUES (1, 103, 'Discount', '/pos/master/discount', '', 100, 103, 2);
INSERT INTO public.sys_menu VALUES (1, 100, 'Master', '/pos/master', 'FolderOpenOutlined', NULL, 100, 2);
INSERT INTO public.sys_menu VALUES (1, 110, 'Transaction', '/pos/transaction', 'FundOutlined', NULL, 110, 2);
INSERT INTO public.sys_menu VALUES (1, 102, 'User Branch', '/pos/master/user-branch', '', 100, 102, 2);
INSERT INTO public.sys_menu VALUES (1, 200, 'Master', '/warehouse/master', 'FolderOpenOutlined', NULL, 200, 3);
INSERT INTO public.sys_menu VALUES (1, 201, 'Branch', '/warehouse/master/branch', '', 200, 201, 3);
INSERT INTO public.sys_menu VALUES (1, 202, 'Warehouse Type', '/warehouse/master/wh-type', '', 200, 202, 3);
INSERT INTO public.sys_menu VALUES (1, 203, 'Warehouse', '/warehouse/master/wh', '', 200, 203, 3);


--
-- TOC entry 3452 (class 0 OID 18645)
-- Dependencies: 242
-- Data for Name: sys_menu_module; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sys_menu_module VALUES (1, 2, 'Point Of Sales', 'POS', NULL);
INSERT INTO public.sys_menu_module VALUES (1, 1, 'Administrator', 'ADM', 'BarChartOutlined');
INSERT INTO public.sys_menu_module VALUES (1, 3, 'Warehouse', 'WH', '');


--
-- TOC entry 3454 (class 0 OID 18654)
-- Dependencies: 244
-- Data for Name: sys_relation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sys_relation VALUES ('mst_customer_default', 1, 'Default Customer Point Of Sales', 'Customer Default', 2);


--
-- TOC entry 3456 (class 0 OID 18662)
-- Dependencies: 246
-- Data for Name: sys_role_section; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 104, 1, 1, 0, 0, 0, 0, 0, 107);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 105, 1, 1, 0, 0, 0, 0, 0, 108);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 1, 1, 1, 1, 1, 1, 0, 0, 37);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 2, 1, 0, 0, 0, 0, 0, 0, 36);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 5, 1, 1, 1, 1, 1, 0, 0, 32);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 4, 1, 1, 1, 1, 1, 0, 0, 31);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 3, 1, 1, 1, 1, 1, 0, 0, 34);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 6, 1, 1, 1, 1, 1, 0, 0, 33);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 9, 1, 0, 0, 0, 0, 0, 0, 91);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 7, 1, 0, 0, 0, 0, 0, 0, 96);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 8, 1, 0, 0, 0, 0, 0, 0, 97);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 14, 1, 0, 0, 0, 0, 0, 0, 98);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 15, 1, 0, 0, 0, 0, 0, 0, 99);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 100, 1, 0, 0, 0, 0, 0, 0, 100);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 110, 1, 0, 0, 0, 0, 0, 0, 101);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 130, 1, 0, 0, 0, 0, 0, 0, 102);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 10, 1, 1, 1, 1, 1, 0, 0, 92);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 11, 1, 1, 1, 1, 1, 0, 0, 93);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 12, 1, 1, 1, 1, 1, 0, 0, 94);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 13, 1, 1, 1, 1, 1, 0, 0, 95);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 101, 1, 1, 1, 1, 1, 0, 0, 104);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 102, 1, 1, 1, 1, 1, 0, 0, 105);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 103, 1, 1, 1, 1, 1, 0, 0, 106);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 111, 1, 1, 1, 1, 1, 0, 0, 111);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 1, 7, 0, 0, 0, 0, 0, 0, 39);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 2, 7, 0, 0, 0, 0, 0, 0, 40);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 5, 7, 0, 0, 0, 0, 0, 0, 41);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 4, 7, 0, 0, 0, 0, 0, 0, 42);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 112, 1, 1, 1, 1, 1, 0, 0, 112);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 113, 1, 1, 1, 1, 1, 0, 0, 109);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 114, 1, 1, 1, 1, 1, 0, 0, 113);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 115, 1, 1, 1, 1, 1, 0, 0, 114);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 120, 1, 1, 1, 1, 1, 0, 0, 110);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 131, 1, 1, 1, 1, 1, 0, 0, 103);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 3, 7, 0, 0, 0, 0, 0, 0, 43);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 6, 7, 0, 0, 0, 0, 0, 0, 44);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 9, 7, 0, 0, 0, 0, 0, 0, 45);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 10, 7, 0, 0, 0, 0, 0, 0, 46);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 11, 7, 0, 0, 0, 0, 0, 0, 47);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 12, 7, 0, 0, 0, 0, 0, 0, 48);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 13, 7, 0, 0, 0, 0, 0, 0, 49);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 7, 7, 0, 0, 0, 0, 0, 0, 50);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 8, 7, 0, 0, 0, 0, 0, 0, 51);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 14, 7, 0, 0, 0, 0, 0, 0, 52);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 15, 7, 0, 0, 0, 0, 0, 0, 53);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 100, 7, 0, 0, 0, 0, 0, 0, 54);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 101, 7, 0, 0, 0, 0, 0, 0, 55);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 102, 7, 0, 0, 0, 0, 0, 0, 56);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 103, 7, 0, 0, 0, 0, 0, 0, 57);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 104, 7, 0, 0, 0, 0, 0, 0, 58);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 105, 7, 0, 0, 0, 0, 0, 0, 59);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 110, 7, 0, 0, 0, 0, 0, 0, 60);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 113, 7, 0, 0, 0, 0, 0, 0, 61);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 120, 7, 0, 0, 0, 0, 0, 0, 62);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 130, 7, 0, 0, 0, 0, 0, 0, 63);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 131, 7, 0, 0, 0, 0, 0, 0, 64);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 1, 10, 0, 0, 0, 0, 0, 0, 65);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 2, 10, 0, 0, 0, 0, 0, 0, 66);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 5, 10, 0, 0, 0, 0, 0, 0, 67);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 4, 10, 0, 0, 0, 0, 0, 0, 68);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 3, 10, 0, 0, 0, 0, 0, 0, 69);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 6, 10, 0, 0, 0, 0, 0, 0, 70);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 9, 10, 0, 0, 0, 0, 0, 0, 71);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 10, 10, 0, 0, 0, 0, 0, 0, 72);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 12, 10, 0, 0, 0, 0, 0, 0, 73);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 7, 10, 0, 0, 0, 0, 0, 0, 74);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 8, 10, 0, 0, 0, 0, 0, 0, 75);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 14, 10, 0, 0, 0, 0, 0, 0, 76);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 15, 10, 0, 0, 0, 0, 0, 0, 77);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 100, 10, 0, 0, 0, 0, 0, 0, 78);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 101, 10, 0, 0, 0, 0, 0, 0, 79);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 102, 10, 0, 0, 0, 0, 0, 0, 80);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 103, 10, 0, 0, 0, 0, 0, 0, 81);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 104, 10, 0, 0, 0, 0, 0, 0, 82);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 105, 10, 0, 0, 0, 0, 0, 0, 83);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 110, 10, 0, 0, 0, 0, 0, 0, 84);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 113, 10, 0, 0, 0, 0, 0, 0, 85);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 120, 10, 0, 0, 0, 0, 0, 0, 86);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 130, 10, 0, 0, 0, 0, 0, 0, 87);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 131, 10, 0, 0, 0, 0, 0, 0, 88);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 13, 10, 0, 0, 1, 0, 0, 0, 89);
INSERT INTO public.sys_role_section VALUES (NULL, NULL, NULL, NULL, 1, 11, 10, 0, 1, 0, 0, 0, 0, 90);


--
-- TOC entry 3458 (class 0 OID 18668)
-- Dependencies: 248
-- Data for Name: sys_status_information; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sys_status_information VALUES (NULL, NULL, NULL, NULL, 0, 1, 1, 'Active');
INSERT INTO public.sys_status_information VALUES (NULL, NULL, NULL, NULL, 0, 0, 2, 'Inactive');
INSERT INTO public.sys_status_information VALUES (NULL, NULL, NULL, NULL, 0, 10, 3, 'Pending');
INSERT INTO public.sys_status_information VALUES (NULL, NULL, NULL, NULL, 0, 11, 4, 'Approve');
INSERT INTO public.sys_status_information VALUES (NULL, NULL, NULL, NULL, 0, 9, 5, 'Reject');


--
-- TOC entry 3459 (class 0 OID 18676)
-- Dependencies: 249
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public."user" VALUES (29, 'Admin Utama', 'gesang@gmail.com', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 1, '2022-07-18 10:59:23', 0, '2022-07-18 11:38:36', 0, 1, 0);
INSERT INTO public."user" VALUES (31, 'admins', 'johnsmith@doctor.co.id', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 1, '2022-07-18 11:01:10', 0, '2022-08-12 11:10:10', 0, 0, 1);
INSERT INTO public."user" VALUES (32, 'admin', 'admin@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 1, '2022-07-19 15:20:23', 0, '2022-08-23 09:48:34', 0, 0, 1);
INSERT INTO public."user" VALUES (1, 'gesang', 'gesangseto@gmail.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 1, '2022-06-15 09:00:36', 0, '2022-09-05 02:49:25', 0, 1, 0);


--
-- TOC entry 3460 (class 0 OID 18684)
-- Dependencies: 250
-- Data for Name: user_authentication; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.user_authentication VALUES (NULL, 1, 1, '4bd75474c49fa6f0517384206353d322f6896e23a4cab37fee575b20558ccf84', '2022-08-20 15:17:40', NULL, 1);
INSERT INTO public.user_authentication VALUES ('2022-07-21 15:18:58', 1, 1, 'cb3bdf9737ef715450edea1058963393cacdda3d3c283b911f836fabdf529350', '2022-08-20 15:18:58', NULL, 2);
INSERT INTO public.user_authentication VALUES ('2022-07-21 15:19:54', 1, 1, 'fa60904b02dace6a5594957d2e3655824455cb63877a72b97975fe49fc67d389', '2022-08-20 15:19:54', NULL, 3);
INSERT INTO public.user_authentication VALUES ('2022-07-21 15:20:42', 1, 1, '7dc1a1d464a78caf03fde175b571846052e9cc0434032f1fac36091700292ec5', '2022-08-20 15:20:43', NULL, 4);
INSERT INTO public.user_authentication VALUES ('2022-07-21 15:21:05', 1, 1, 'daaa23768437cfcd0f78a5ab428c925aeb9d27711be955ec9de3c14e6e726af0', '2022-08-20 15:21:05', NULL, 5);
INSERT INTO public.user_authentication VALUES ('2022-07-21 15:53:56', 1, 1, 'a59beb257b05730fd0d71ddef7e42649389f391a69444c3e21ea03b6a341f8b6', '2022-08-20 15:54:11', NULL, 12);
INSERT INTO public.user_authentication VALUES ('2022-07-21 16:04:17', 1, 1, '085b021647e7ed7962a92b0f6ee0380247b090a73d49b8377f062c33b68e46d2', '2022-08-20 16:04:17', NULL, 13);
INSERT INTO public.user_authentication VALUES ('2022-07-21 16:07:32', 1, 1, 'dc972320910896d78a13a787885339be3c92ab05ae0e38592b8f386102c34adb', '2022-08-20 16:07:32', NULL, 14);
INSERT INTO public.user_authentication VALUES ('2022-07-26 14:46:06', 1, 1, '68ec031d5e922822099e868f25955d0b2d0f988725914f99e90b0aa3db2b553c', '2022-08-25 14:58:42', NULL, 27);
INSERT INTO public.user_authentication VALUES ('2022-07-22 14:04:37', 1, 1, 'ab28560ecb84d34e938f4e479986f2fa30be7349643c69644364743a67c632d9', '2022-08-21 14:04:44', NULL, 22);
INSERT INTO public.user_authentication VALUES ('2022-07-26 14:44:43', 1, 1, '06b759a82c91e708417c63742a13644be033b70ae1dc91f52524a347cd52050b', '2022-08-25 14:45:34', NULL, 26);
INSERT INTO public.user_authentication VALUES ('2022-07-21 15:21:23', 1, 1, 'b2c83945ce5425e7f8b9e101210f6e837966559510fd87a4e413448b4c96dd7b', '2022-08-20 15:22:01', NULL, 6);
INSERT INTO public.user_authentication VALUES ('2022-07-21 15:40:24', 1, 1, 'e9ee813f453afaa00d6dec21469733285f30d6f749e83b34b450bc69aac32c7d', '2022-08-20 15:44:25', NULL, 8);
INSERT INTO public.user_authentication VALUES ('2022-07-21 15:49:08', 1, 1, '88d1d41c3b042ff7103743974fa02c861398aa5fc8b07ff1c5f1ede37d8790e7', '2022-08-20 15:49:08', NULL, 9);
INSERT INTO public.user_authentication VALUES ('2022-07-21 16:16:31', 1, 1, 'ead35af434d80220d09d04507235561ebf3d0471ce2794441bb8c7d312c0695f', '2022-08-20 16:50:36', NULL, 15);
INSERT INTO public.user_authentication VALUES (NULL, 1, 1, 'c886af98461ef54df6e45521e9a56e1e9b8fcb12697279243e0f5a5062dc1c63', '2022-08-21 10:20:24', NULL, 16);
INSERT INTO public.user_authentication VALUES (NULL, 1, 1, '186be2529b3ce4f38ca1ebc0dc24d34c14362760644b2e73c62c8ffcb05b7a63', '2022-08-21 10:28:39', NULL, 17);
INSERT INTO public.user_authentication VALUES ('2022-07-21 15:49:43', 1, 1, '59ac9e10dea670f658e4fc8de63b19421416914094fa20bd17c34a80cd673efe', '2022-08-20 15:52:26', NULL, 10);
INSERT INTO public.user_authentication VALUES ('2022-08-18 09:15:43', 1, 1, '61613bde470f802f825edc607e8d331a28ccd8f3b4ad3edc894c5dd86550ab20', '2022-09-17 10:25:33', NULL, 31);
INSERT INTO public.user_authentication VALUES ('2022-07-27 16:24:39', 1, 1, '0430e3fd7c137d224cdf4bd5ef5c52fc7a48fb03c9d1328916089bdc46ffc2e5', '2022-08-26 16:25:12', NULL, 29);
INSERT INTO public.user_authentication VALUES ('2022-07-28 10:13:08', 1, 1, '5b3ecf8fe1e6b562575aa3e70a35403e04cd948236855381811c0496f2569d0d', '2022-08-27 10:13:08', NULL, 30);
INSERT INTO public.user_authentication VALUES ('2022-07-22 10:54:07', 1, 1, '6fa9f86a31b87b6c0402bb40be615b794ff1b90345515149f4eaf2ea68cc1855', '2022-08-21 10:55:36', NULL, 18);
INSERT INTO public.user_authentication VALUES ('2022-07-21 15:38:15', 1, 1, '60a530458ebd6d1d88996e244b53ce23a6f8b33ceb76d4d3a3d5c3acc5af11db', '2022-08-20 15:40:17', NULL, 7);
INSERT INTO public.user_authentication VALUES ('2022-08-24 09:00:10', 1, 32, '1b96e5c693d55dfcf7bfde1cd040c8982c1f4212731a8e8f02516cc5bbd327bf', '2022-09-23 02:04:11', NULL, 34);
INSERT INTO public.user_authentication VALUES ('2022-07-22 14:05:30', 1, 1, '23d845cbe01f3fb9d317e3464dbd792dc564fec7e91e9a6a3a5e4bbca1f91523', '2022-08-21 14:10:01', NULL, 24);
INSERT INTO public.user_authentication VALUES ('2022-07-21 15:53:16', 1, 1, '6fdd4a897c2bc211f3b0ea80ec385338612512222f49a6bebeaa9577868c17bc', '2022-08-20 15:53:40', NULL, 11);
INSERT INTO public.user_authentication VALUES ('2022-07-22 10:55:58', 1, 1, '2c48e835b4affb53955688c5a20a436656d6546c9a98214b1c99abe29a2916b8', '2022-08-21 10:56:18', NULL, 19);
INSERT INTO public.user_authentication VALUES ('2022-07-22 14:04:53', 1, 31, '21ba2ea7c51848ec908a75d6855c7dc0fef64e7ba280b32c0b878afa292b51b9', '2022-08-21 14:05:23', NULL, 23);
INSERT INTO public.user_authentication VALUES ('2022-08-23 09:48:41', 1, 32, '340d898553b19bccf391e88c149bca71ab2efc7ca0e30d438dd69bdf089eae7b', '2022-09-22 03:34:00', NULL, 32);
INSERT INTO public.user_authentication VALUES ('2022-07-22 11:15:01', 1, 1, '7929b6842e222c95c5ab49345ad0f9759db8504eb789b54bea9abf25fe9fd746', '2022-08-21 11:15:09', NULL, 20);
INSERT INTO public.user_authentication VALUES ('2022-07-22 14:03:18', 1, 1, 'ac0932e9abff936113399da9e9c82bc8c7257967850478c472a15373cd3a0986', '2022-08-21 14:03:18', NULL, 21);
INSERT INTO public.user_authentication VALUES ('2022-07-27 16:15:22', 1, 1, 'e396dc4fa7e30af9e522fb928e33472de5c8dbc5d6a3150e4e99a97f2f20ba05', '2022-08-26 16:15:50', NULL, 28);
INSERT INTO public.user_authentication VALUES ('2022-07-26 14:44:23', 1, 31, '48f832ad361abe28fa732f95f58e9a599c6678b99e846dfc2fe0aa4b6001e981', '2022-08-25 14:44:33', NULL, 25);
INSERT INTO public.user_authentication VALUES ('2022-08-23 16:02:37', 1, 32, 'fb5ec4dc6501eb64567ab7e48aa1e8d9cc5502a0c97959e05f244faf44e8e469', '2022-09-23 08:59:56', NULL, 33);
INSERT INTO public.user_authentication VALUES ('2022-08-24 14:04:22', 1, 32, '0258d9a2dfe9d91c2aff6732dbd0a24238296d88ccd95def8503ee051358877c', '2022-09-23 02:19:57', NULL, 35);
INSERT INTO public.user_authentication VALUES ('2022-08-24 14:20:48', 1, 32, '3f7c8750fe016ea191c7e2495c64b1cb88a88b3bea58e11463817f67020bea04', '2022-09-23 02:24:04', NULL, 36);
INSERT INTO public.user_authentication VALUES ('2022-08-24 15:34:45', 1, 32, '99e540bad9137b6fdcb4b68187d218cce0812e7e1a421bf07c0a28a12750c391', '2022-09-23 03:35:21', NULL, 39);
INSERT INTO public.user_authentication VALUES ('2022-08-24 14:42:29', 1, 32, '346e2044641f9692e20215633fb76111fec591c87124ac2b85929f0b815c44fd', '2022-09-23 03:14:00', NULL, 37);
INSERT INTO public.user_authentication VALUES ('2022-08-24 15:22:54', 1, 32, '3ae6836d3f8ff84339bf97e7434165c2df0ecf6f26241203da61c4718a2d52aa', '2022-09-23 03:24:53', NULL, 38);
INSERT INTO public.user_authentication VALUES ('2022-08-28 06:21:09', 1, 32, '5ea809d18dbeabf93041049dc738c9bbc46bbe4690b548399ed41442c1a2aaa4', '2022-09-27 07:13:58', NULL, 42);
INSERT INTO public.user_authentication VALUES ('2022-08-28 07:14:08', 1, 32, '1d521ca23b38a0a2918b2b8dfb1abdc079ce1e44b812cdf6d95c7ae36f0c213c', '2022-09-27 07:14:08', NULL, 43);
INSERT INTO public.user_authentication VALUES ('2022-08-27 20:41:05', 1, 32, '344601ad280385dd5de2c35f992d644ff5afccc7f0232ab5907d0d667e2f071f', '2022-09-27 05:57:15', NULL, 40);
INSERT INTO public.user_authentication VALUES ('2022-09-02 14:13:34', 1, 32, 'ce7cb3e2b4fb37f112ef679568cac501749e732abd22c62a8280ad1b754440da', '2022-10-02 02:25:29', NULL, 49);
INSERT INTO public.user_authentication VALUES ('2022-08-28 05:59:41', 1, 32, '656fc27c581f40d69836c88fd71a692217de639a5c2e56e86469a9823e508093', '2022-09-27 06:20:25', NULL, 41);
INSERT INTO public.user_authentication VALUES ('2022-08-28 10:06:50', 1, 32, '01fc9db450bbedbe58190e19eaefedb8c5becc02253ca2e560c5ba9d82afc392', '2022-09-28 09:32:26', NULL, 45);
INSERT INTO public.user_authentication VALUES ('2022-08-29 19:56:11', 1, 32, '0048bf071916f9f7307f18145579676def721aec52498fff221dcb8688e3055a', '2022-09-28 08:42:00', NULL, 47);
INSERT INTO public.user_authentication VALUES ('2022-08-28 08:57:51', 1, 32, '157ddca90d9eb0b3b9c716eb1bf4374c16e852ae49a7f1a9d66c2d2da736798c', '2022-09-27 09:23:37', NULL, 44);
INSERT INTO public.user_authentication VALUES ('2022-08-30 11:25:56', 1, 32, '0a30f960dfe680a2223b9151ab59e5d309f93345dfcaee8f2987d92e6edc1c10', '2022-09-29 11:26:12', NULL, 48);
INSERT INTO public.user_authentication VALUES ('2022-09-06 10:19:06', 1, 32, 'eec0f2f8ee9ed9b62611a8c94bb80bdc07b515636b2b69f8b51ad6ea0af946a2', '2022-10-06 10:19:06', NULL, 50);
INSERT INTO public.user_authentication VALUES ('2022-08-29 09:34:29', 1, 32, 'ba40f4f57b0402861076618cf5a99b84736454a38a0fae74aaaee8a2802a7664', '2022-09-28 04:38:23', NULL, 46);
INSERT INTO public.user_authentication VALUES ('2022-09-06 10:51:35', 1, 32, 'fb4c85302fd17be91e393aeb3b0905731b5976d4d2d7652e2075a637dd0d5961', '2022-10-06 10:51:35', NULL, 51);


--
-- TOC entry 3462 (class 0 OID 18693)
-- Dependencies: 252
-- Data for Name: user_department; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.user_department VALUES ('2022-06-21 10:53:23', 0, '2022-07-21 11:27:37', 0, 0, 1, 7, 'Administration', 'ADM');
INSERT INTO public.user_department VALUES ('2022-06-15 09:00:36', 0, '2022-08-29 04:09:07', 32, 0, 1, 1, 'Information Technology', 'IT');
INSERT INTO public.user_department VALUES ('2022-07-22 14:04:13', 0, '2022-08-29 09:31:24', 32, 0, 1, 15, 'Approval Test', 'AppTest');


--
-- TOC entry 3464 (class 0 OID 18703)
-- Dependencies: 254
-- Data for Name: user_section; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.user_section VALUES ('2022-06-15 09:00:36', 0, '2022-07-21 11:27:19', 0, 0, 1, 1, 1, 'MG', 'Manager IT');
INSERT INTO public.user_section VALUES ('2022-07-26 15:15:38', 0, '2022-07-26 15:32:26', 0, 0, 1, 7, 7, 'STE', 'Assas');
INSERT INTO public.user_section VALUES ('2022-07-21 11:28:03', 0, '2022-07-26 15:32:29', 0, 0, 1, 6, 7, 'Finance', 'Finance');
INSERT INTO public.user_section VALUES ('2022-07-26 15:33:43', 0, NULL, NULL, 0, 1, 8, 7, 'Warehouse', 'Warehoiuse');
INSERT INTO public.user_section VALUES ('2022-07-27 16:15:41', 1, '2022-07-27 16:15:49', 1, 0, 1, 11, 7, 'AJI', 'Sadjh');
INSERT INTO public.user_section VALUES ('2022-07-26 15:34:21', 0, '2022-08-12 11:19:17', 0, 0, 1, 10, 7, 'Finances', 'Pion');


--
-- TOC entry 3472 (class 0 OID 19233)
-- Dependencies: 262
-- Data for Name: wh_mst_branch; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.wh_mst_branch VALUES ('2022-09-30 08:24:55.511+02', '2022-09-30 08:24:55.511+02', NULL, 0, NULL, NULL, 1, 'JAB', '', '-', '-');


--
-- TOC entry 3470 (class 0 OID 19069)
-- Dependencies: 260
-- Data for Name: wh_mst_wh; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3468 (class 0 OID 19033)
-- Dependencies: 258
-- Data for Name: wh_mst_wh_type; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.wh_mst_wh_type VALUES ('2022-09-06 16:01:44+02', 0, '2022-09-06 04:02:53+02', 0, 0, 1, 4, 'QUARANTINE', 'Quaratine', '-', true, true, true, false, false, 'null', 'null', '{ x: 250, y: 250 }');
INSERT INTO public.wh_mst_wh_type VALUES (NULL, NULL, '2022-09-06 04:03:01+02', 0, 0, 1, 1, 'STAGGING', 'Stagging', 'Untuk stagging saja', true, true, true, true, false, 'null', 'null', '{ x: 100, y: 125 }');


--
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 203
-- Name: approval_approval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.approval_approval_id_seq', 28, true);


--
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 205
-- Name: approval_flow_approval_flow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.approval_flow_approval_flow_id_seq', 47, true);


--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 206
-- Name: approval_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.approval_seq', 1, false);


--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 208
-- Name: audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.audit_log_id_seq', 115, true);


--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 211
-- Name: mst_customer_mst_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mst_customer_mst_customer_id_seq', 3, true);


--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 213
-- Name: mst_item_mst_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mst_item_mst_item_id_seq', 11, true);


--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 215
-- Name: mst_item_variant_mst_item_variant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mst_item_variant_mst_item_variant_id_seq', 30, true);


--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 217
-- Name: mst_packaging_mst_packaging_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mst_packaging_mst_packaging_id_seq', 9, true);


--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 219
-- Name: mst_supplier_mst_supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mst_supplier_mst_supplier_id_seq', 2, true);


--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 221
-- Name: pos_branch_pos_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pos_branch_pos_branch_id_seq', 8, true);


--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 223
-- Name: pos_cashier_pos_cashier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pos_cashier_pos_cashier_id_seq', 20, true);


--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 225
-- Name: pos_discount_pos_discount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pos_discount_pos_discount_id_seq', 50, true);


--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 227
-- Name: pos_item_stock_pos_item_stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pos_item_stock_pos_item_stock_id_seq', 66, true);


--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 230
-- Name: pos_receive_detail_pos_receive_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pos_receive_detail_pos_receive_detail_id_seq', 130, true);


--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 232
-- Name: pos_sale_detail_pos_sale_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pos_sale_detail_pos_sale_detail_id_seq', 179, true);


--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 234
-- Name: pos_sale_pos_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pos_sale_pos_sale_id_seq', 1, false);


--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 239
-- Name: pos_user_branch_pos_user_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pos_user_branch_pos_user_branch_id_seq', 24, true);


--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 243
-- Name: sys_menu_module_sys_menu_module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sys_menu_module_sys_menu_module_id_seq', 3, true);


--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 245
-- Name: sys_relation_sys_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sys_relation_sys_relation_id_seq', 2, true);


--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 247
-- Name: sys_role_section_role_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sys_role_section_role_section_id_seq', 114, true);


--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 251
-- Name: user_authentication_authentication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_authentication_authentication_id_seq', 51, true);


--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 253
-- Name: user_department_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_department_department_id_seq', 16, true);


--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 255
-- Name: user_section_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_section_section_id_seq', 11, true);


--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 256
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_user_id_seq', 32, true);


--
-- TOC entry 3530 (class 0 OID 0)
-- Dependencies: 261
-- Name: wh_mst_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.wh_mst_branch_id_seq', 1, true);


--
-- TOC entry 3531 (class 0 OID 0)
-- Dependencies: 257
-- Name: wh_mst_wh_type_wh_mst_wh_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.wh_mst_wh_type_wh_mst_wh_type_id_seq', 4, true);


--
-- TOC entry 3532 (class 0 OID 0)
-- Dependencies: 259
-- Name: wh_mst_wh_wh_mst_wh_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.wh_mst_wh_wh_mst_wh_id_seq', 2, true);


--
-- TOC entry 3134 (class 2606 OID 18738)
-- Name: approval Approval Primary Key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "Approval Primary Key" PRIMARY KEY (approval_id);


--
-- TOC entry 3138 (class 2606 OID 18740)
-- Name: approval_flow Approval Table - ID; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "Approval Table - ID" UNIQUE (approval_ref_id, approval_ref_table);


--
-- TOC entry 3154 (class 2606 OID 18742)
-- Name: mst_item_variant Barcode; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_item_variant
    ADD CONSTRAINT "Barcode" UNIQUE (barcode);


--
-- TOC entry 3168 (class 2606 OID 18744)
-- Name: pos_branch Branch Code Pos; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_branch
    ADD CONSTRAINT "Branch Code Pos" UNIQUE (pos_branch_code);


--
-- TOC entry 3144 (class 2606 OID 18746)
-- Name: mst_customer Customer PK; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_customer
    ADD CONSTRAINT "Customer PK" PRIMARY KEY (mst_customer_id);


--
-- TOC entry 3228 (class 2606 OID 18748)
-- Name: user_department Department Code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_department
    ADD CONSTRAINT "Department Code" UNIQUE (user_department_code);


--
-- TOC entry 3230 (class 2606 OID 18750)
-- Name: user_department Department Primary Key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_department
    ADD CONSTRAINT "Department Primary Key" PRIMARY KEY (user_department_id);


--
-- TOC entry 3198 (class 2606 OID 18752)
-- Name: pos_user_branch Duplicate User On Branch; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_user_branch
    ADD CONSTRAINT "Duplicate User On Branch" UNIQUE (pos_branch_code, user_id);


--
-- TOC entry 3146 (class 2606 OID 18754)
-- Name: mst_customer Email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_customer
    ADD CONSTRAINT "Email" UNIQUE (mst_customer_email);


--
-- TOC entry 3186 (class 2606 OID 18756)
-- Name: pos_trx_detail FK Item; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_detail
    ADD CONSTRAINT "FK Item" UNIQUE (mst_item_variant_id, pos_trx_ref_id);


--
-- TOC entry 3150 (class 2606 OID 18758)
-- Name: mst_item Item Primary Key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_item
    ADD CONSTRAINT "Item Primary Key" PRIMARY KEY (mst_item_id);


--
-- TOC entry 3152 (class 2606 OID 18760)
-- Name: mst_item Item Unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_item
    ADD CONSTRAINT "Item Unique" UNIQUE (mst_item_no);


--
-- TOC entry 3214 (class 2606 OID 18762)
-- Name: sys_role_section Menu - Section; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_role_section
    ADD CONSTRAINT "Menu - Section" UNIQUE (sys_menu_id, user_section_id);


--
-- TOC entry 3174 (class 2606 OID 18764)
-- Name: pos_discount PK Discount; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_discount
    ADD CONSTRAINT "PK Discount" PRIMARY KEY (pos_discount_id);


--
-- TOC entry 3182 (class 2606 OID 18766)
-- Name: pos_receive PK Receive; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_receive
    ADD CONSTRAINT "PK Receive" PRIMARY KEY (pos_receive_id);


--
-- TOC entry 3184 (class 2606 OID 18768)
-- Name: pos_receive_detail PK Receive Detail; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_receive_detail
    ADD CONSTRAINT "PK Receive Detail" PRIMARY KEY (pos_receive_detail_id);


--
-- TOC entry 3188 (class 2606 OID 18770)
-- Name: pos_trx_detail PK Trx Detail; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_detail
    ADD CONSTRAINT "PK Trx Detail" PRIMARY KEY (pos_trx_detail_id);


--
-- TOC entry 3158 (class 2606 OID 18772)
-- Name: mst_packaging Packaging Code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_packaging
    ADD CONSTRAINT "Packaging Code" UNIQUE (mst_packaging_code);


--
-- TOC entry 3160 (class 2606 OID 18774)
-- Name: mst_packaging Packaging PK; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_packaging
    ADD CONSTRAINT "Packaging PK" PRIMARY KEY (mst_packaging_id);


--
-- TOC entry 3148 (class 2606 OID 18776)
-- Name: mst_customer Phone; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_customer
    ADD CONSTRAINT "Phone" UNIQUE (mst_customer_phone);


--
-- TOC entry 3170 (class 2606 OID 18778)
-- Name: pos_branch Pos Branch PK; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_branch
    ADD CONSTRAINT "Pos Branch PK" PRIMARY KEY (pos_branch_id);


--
-- TOC entry 3194 (class 2606 OID 18780)
-- Name: pos_trx_inbound Pos Trx Inbound; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_inbound
    ADD CONSTRAINT "Pos Trx Inbound" PRIMARY KEY (pos_trx_inbound_id);


--
-- TOC entry 3216 (class 2606 OID 18782)
-- Name: sys_role_section Role Section Primary Key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_role_section
    ADD CONSTRAINT "Role Section Primary Key" PRIMARY KEY (sys_role_section_id);


--
-- TOC entry 3232 (class 2606 OID 18784)
-- Name: user_section Section Code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_section
    ADD CONSTRAINT "Section Code" UNIQUE (user_section_code);


--
-- TOC entry 3234 (class 2606 OID 18786)
-- Name: user_section Section Primary Key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_section
    ADD CONSTRAINT "Section Primary Key" PRIMARY KEY (user_section_id);


--
-- TOC entry 3218 (class 2606 OID 18788)
-- Name: sys_status_information Status; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_status_information
    ADD CONSTRAINT "Status" UNIQUE (status);


--
-- TOC entry 3162 (class 2606 OID 18790)
-- Name: mst_supplier Supplier ID; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_supplier
    ADD CONSTRAINT "Supplier ID" PRIMARY KEY (mst_supplier_id);


--
-- TOC entry 3206 (class 2606 OID 18792)
-- Name: sys_menu_module Sys Menu Module PK; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_menu_module
    ADD CONSTRAINT "Sys Menu Module PK" PRIMARY KEY (sys_menu_module_id);


--
-- TOC entry 3208 (class 2606 OID 18794)
-- Name: sys_menu_module Sys Menu Module UN; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_menu_module
    ADD CONSTRAINT "Sys Menu Module UN" UNIQUE (sys_menu_module_code);


--
-- TOC entry 3204 (class 2606 OID 18796)
-- Name: sys_menu Sys Menu PK; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_menu
    ADD CONSTRAINT "Sys Menu PK" PRIMARY KEY (sys_menu_id);


--
-- TOC entry 3178 (class 2606 OID 18798)
-- Name: pos_item_stock Unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_item_stock
    ADD CONSTRAINT "Unique" UNIQUE (pos_branch_code, mst_item_id);


--
-- TOC entry 3210 (class 2606 OID 18800)
-- Name: sys_relation Unique Code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_relation
    ADD CONSTRAINT "Unique Code" UNIQUE (sys_relation_code);


--
-- TOC entry 3176 (class 2606 OID 18802)
-- Name: pos_discount Unique Code Discount; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_discount
    ADD CONSTRAINT "Unique Code Discount" UNIQUE (pos_discount_code);


--
-- TOC entry 3136 (class 2606 OID 18804)
-- Name: approval Unique Key Table; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "Unique Key Table" UNIQUE (approval_ref_table);


--
-- TOC entry 3222 (class 2606 OID 18806)
-- Name: user User Email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "User Email" UNIQUE (user_email);


--
-- TOC entry 3140 (class 2606 OID 18808)
-- Name: approval_flow User ID Unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID Unique" UNIQUE (approval_user_id_1, approval_user_id_2, approval_user_id_3, approval_user_id_4, approval_user_id_5);


--
-- TOC entry 3224 (class 2606 OID 18810)
-- Name: user User Primary Key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "User Primary Key" PRIMARY KEY (user_id);


--
-- TOC entry 3240 (class 2606 OID 19081)
-- Name: wh_mst_wh Warehouse Code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wh_mst_wh
    ADD CONSTRAINT "Warehouse Code" UNIQUE (wh_mst_wh_code);


--
-- TOC entry 3236 (class 2606 OID 19046)
-- Name: wh_mst_wh_type Warehouse Type Code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wh_mst_wh_type
    ADD CONSTRAINT "Warehouse Type Code" UNIQUE (wh_mst_wh_type_code);


--
-- TOC entry 3142 (class 2606 OID 18812)
-- Name: audit_log audit_log_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pk PRIMARY KEY (id);


--
-- TOC entry 3164 (class 2606 OID 18814)
-- Name: mst_supplier email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_supplier
    ADD CONSTRAINT email UNIQUE (mst_supplier_email);


--
-- TOC entry 3156 (class 2606 OID 18816)
-- Name: mst_item_variant item_variant_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_item_variant
    ADD CONSTRAINT item_variant_pk PRIMARY KEY (mst_item_variant_id);


--
-- TOC entry 3166 (class 2606 OID 18818)
-- Name: mst_supplier phone; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_supplier
    ADD CONSTRAINT phone UNIQUE (mst_supplier_phone);


--
-- TOC entry 3172 (class 2606 OID 18820)
-- Name: pos_cashier pos_cashier_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_cashier
    ADD CONSTRAINT pos_cashier_pk PRIMARY KEY (pos_cashier_id);


--
-- TOC entry 3180 (class 2606 OID 18822)
-- Name: pos_item_stock pos_item_stock_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_item_stock
    ADD CONSTRAINT pos_item_stock_pk PRIMARY KEY (pos_item_stock_id);


--
-- TOC entry 3190 (class 2606 OID 18824)
-- Name: pos_trx_sale pos_sale_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_sale
    ADD CONSTRAINT pos_sale_pk PRIMARY KEY (pos_trx_sale_id);


--
-- TOC entry 3192 (class 2606 OID 18826)
-- Name: pos_trx_destroy pos_trx_destroy_pk_1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_destroy
    ADD CONSTRAINT pos_trx_destroy_pk_1 PRIMARY KEY (pos_trx_destroy_id);


--
-- TOC entry 3196 (class 2606 OID 18828)
-- Name: pos_trx_return pos_trx_return_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_return
    ADD CONSTRAINT pos_trx_return_pk PRIMARY KEY (pos_trx_return_id);


--
-- TOC entry 3200 (class 2606 OID 18830)
-- Name: pos_user_branch pos_user_branch_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_user_branch
    ADD CONSTRAINT pos_user_branch_pk PRIMARY KEY (pos_user_branch_id);


--
-- TOC entry 3202 (class 2606 OID 18832)
-- Name: sys_configuration sys_configuration_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_configuration
    ADD CONSTRAINT sys_configuration_pk PRIMARY KEY (id);


--
-- TOC entry 3212 (class 2606 OID 18834)
-- Name: sys_relation sys_relation_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_relation
    ADD CONSTRAINT sys_relation_pk PRIMARY KEY (sys_relation_id);


--
-- TOC entry 3220 (class 2606 OID 18836)
-- Name: sys_status_information sys_status_information_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_status_information
    ADD CONSTRAINT sys_status_information_pk PRIMARY KEY (status_id);


--
-- TOC entry 3226 (class 2606 OID 18838)
-- Name: user_authentication user_authentication_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_authentication
    ADD CONSTRAINT user_authentication_pk PRIMARY KEY (authentication_id);


--
-- TOC entry 3244 (class 2606 OID 19243)
-- Name: wh_mst_branch wh_mst_branch_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wh_mst_branch
    ADD CONSTRAINT wh_mst_branch_code_key UNIQUE (code);


--
-- TOC entry 3246 (class 2606 OID 19241)
-- Name: wh_mst_branch wh_mst_branch_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wh_mst_branch
    ADD CONSTRAINT wh_mst_branch_pkey PRIMARY KEY (id);


--
-- TOC entry 3242 (class 2606 OID 19079)
-- Name: wh_mst_wh wh_mst_wh_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wh_mst_wh
    ADD CONSTRAINT wh_mst_wh_pk PRIMARY KEY (wh_mst_wh_id);


--
-- TOC entry 3238 (class 2606 OID 19044)
-- Name: wh_mst_wh_type wh_mst_wh_type_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wh_mst_wh_type
    ADD CONSTRAINT wh_mst_wh_type_pk PRIMARY KEY (wh_mst_wh_type_id);


--
-- TOC entry 3278 (class 2606 OID 18839)
-- Name: pos_user_branch BRANCH; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_user_branch
    ADD CONSTRAINT "BRANCH" FOREIGN KEY (pos_branch_code) REFERENCES public.pos_branch(pos_branch_code);


--
-- TOC entry 3260 (class 2606 OID 18844)
-- Name: pos_cashier Cashier-Branch-Pos; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_cashier
    ADD CONSTRAINT "Cashier-Branch-Pos" FOREIGN KEY (pos_branch_code) REFERENCES public.pos_branch(pos_branch_code);


--
-- TOC entry 3273 (class 2606 OID 18849)
-- Name: pos_trx_destroy Destroy-Branch-Pos; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_destroy
    ADD CONSTRAINT "Destroy-Branch-Pos" FOREIGN KEY (pos_branch_code) REFERENCES public.pos_branch(pos_branch_code);


--
-- TOC entry 3267 (class 2606 OID 18854)
-- Name: pos_receive_detail FK Item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_receive_detail
    ADD CONSTRAINT "FK Item" FOREIGN KEY (mst_item_id) REFERENCES public.mst_item(mst_item_id);


--
-- TOC entry 3265 (class 2606 OID 18859)
-- Name: pos_receive FK Supplier; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_receive
    ADD CONSTRAINT "FK Supplier" FOREIGN KEY (mst_supplier_id) REFERENCES public.mst_supplier(mst_supplier_id);


--
-- TOC entry 3261 (class 2606 OID 18864)
-- Name: pos_discount FK Variant Item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_discount
    ADD CONSTRAINT "FK Variant Item" FOREIGN KEY (mst_item_variant_id) REFERENCES public.mst_item_variant(mst_item_variant_id);


--
-- TOC entry 3280 (class 2606 OID 18869)
-- Name: sys_menu Module FK; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_menu
    ADD CONSTRAINT "Module FK" FOREIGN KEY (sys_menu_module_id) REFERENCES public.sys_menu_module(sys_menu_module_id);


--
-- TOC entry 3274 (class 2606 OID 18874)
-- Name: pos_trx_inbound PK Customer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_inbound
    ADD CONSTRAINT "PK Customer" FOREIGN KEY (mst_customer_id) REFERENCES public.mst_customer(mst_customer_id);


--
-- TOC entry 3268 (class 2606 OID 18879)
-- Name: pos_trx_detail PK Item; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_detail
    ADD CONSTRAINT "PK Item" FOREIGN KEY (mst_item_id) REFERENCES public.mst_item(mst_item_id);


--
-- TOC entry 3269 (class 2606 OID 18884)
-- Name: pos_trx_detail PK Item Variant; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_detail
    ADD CONSTRAINT "PK Item Variant" FOREIGN KEY (mst_item_variant_id) REFERENCES public.mst_item_variant(mst_item_variant_id);


--
-- TOC entry 3275 (class 2606 OID 18889)
-- Name: pos_trx_inbound PK Supplier; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_inbound
    ADD CONSTRAINT "PK Supplier" FOREIGN KEY (mst_supplier_id) REFERENCES public.mst_supplier(mst_supplier_id);


--
-- TOC entry 3258 (class 2606 OID 18894)
-- Name: mst_item_variant Packaging ID FK; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_item_variant
    ADD CONSTRAINT "Packaging ID FK" FOREIGN KEY (mst_packaging_id) REFERENCES public.mst_packaging(mst_packaging_id);


--
-- TOC entry 3271 (class 2606 OID 18899)
-- Name: pos_trx_sale Sale-Branch-Pos; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_sale
    ADD CONSTRAINT "Sale-Branch-Pos" FOREIGN KEY (pos_branch_code) REFERENCES public.pos_branch(pos_branch_code);


--
-- TOC entry 3263 (class 2606 OID 18904)
-- Name: pos_item_stock Stock-Branch-Pos; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_item_stock
    ADD CONSTRAINT "Stock-Branch-Pos" FOREIGN KEY (pos_branch_code) REFERENCES public.pos_branch(pos_branch_code);


--
-- TOC entry 3279 (class 2606 OID 18909)
-- Name: pos_user_branch USER - BRANCH; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_user_branch
    ADD CONSTRAINT "USER - BRANCH" FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- TOC entry 3247 (class 2606 OID 18914)
-- Name: approval User Approval 1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "User Approval 1" FOREIGN KEY (approval_user_id_1) REFERENCES public."user"(user_id);


--
-- TOC entry 3248 (class 2606 OID 18919)
-- Name: approval User Approval 2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "User Approval 2" FOREIGN KEY (approval_user_id_2) REFERENCES public."user"(user_id);


--
-- TOC entry 3249 (class 2606 OID 18924)
-- Name: approval User Approval 3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "User Approval 3" FOREIGN KEY (approval_user_id_3) REFERENCES public."user"(user_id);


--
-- TOC entry 3250 (class 2606 OID 18929)
-- Name: approval User Approval 4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "User Approval 4" FOREIGN KEY (approval_user_id_4) REFERENCES public."user"(user_id);


--
-- TOC entry 3251 (class 2606 OID 18934)
-- Name: approval User Approval 5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval
    ADD CONSTRAINT "User Approval 5" FOREIGN KEY (approval_user_id_5) REFERENCES public."user"(user_id);


--
-- TOC entry 3252 (class 2606 OID 18939)
-- Name: approval_flow User ID 1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID 1" FOREIGN KEY (approval_user_id_1) REFERENCES public."user"(user_id);


--
-- TOC entry 3253 (class 2606 OID 18944)
-- Name: approval_flow User ID 2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID 2" FOREIGN KEY (approval_user_id_2) REFERENCES public."user"(user_id);


--
-- TOC entry 3254 (class 2606 OID 18949)
-- Name: approval_flow User ID 3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID 3" FOREIGN KEY (approval_user_id_3) REFERENCES public."user"(user_id);


--
-- TOC entry 3255 (class 2606 OID 18954)
-- Name: approval_flow User ID 4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID 4" FOREIGN KEY (approval_user_id_4) REFERENCES public."user"(user_id);


--
-- TOC entry 3256 (class 2606 OID 18959)
-- Name: approval_flow User ID 5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_flow
    ADD CONSTRAINT "User ID 5" FOREIGN KEY (approval_user_id_5) REFERENCES public."user"(user_id);


--
-- TOC entry 3285 (class 2606 OID 19082)
-- Name: wh_mst_wh Warehouse-Warehouse Type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wh_mst_wh
    ADD CONSTRAINT "Warehouse-Warehouse Type" FOREIGN KEY (wh_mst_wh_type_code) REFERENCES public.wh_mst_wh_type(wh_mst_wh_type_code);


--
-- TOC entry 3257 (class 2606 OID 18964)
-- Name: audit_log audit_log_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_fk FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- TOC entry 3259 (class 2606 OID 18969)
-- Name: mst_item_variant mst_item_id at mst_item_variant; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mst_item_variant
    ADD CONSTRAINT "mst_item_id at mst_item_variant" FOREIGN KEY (mst_item_id) REFERENCES public.mst_item(mst_item_id);


--
-- TOC entry 3262 (class 2606 OID 18974)
-- Name: pos_discount pos_discount_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_discount
    ADD CONSTRAINT pos_discount_fk FOREIGN KEY (pos_branch_code) REFERENCES public.pos_branch(pos_branch_code);


--
-- TOC entry 3264 (class 2606 OID 18979)
-- Name: pos_item_stock pos_item_stock_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_item_stock
    ADD CONSTRAINT pos_item_stock_fk FOREIGN KEY (mst_item_id) REFERENCES public.mst_item(mst_item_id);


--
-- TOC entry 3266 (class 2606 OID 18984)
-- Name: pos_receive pos_receive_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_receive
    ADD CONSTRAINT pos_receive_fk FOREIGN KEY (pos_branch_code) REFERENCES public.pos_branch(pos_branch_code);


--
-- TOC entry 3272 (class 2606 OID 18989)
-- Name: pos_trx_sale pos_sale_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_sale
    ADD CONSTRAINT pos_sale_fk FOREIGN KEY (mst_customer_id) REFERENCES public.mst_customer(mst_customer_id);


--
-- TOC entry 3270 (class 2606 OID 18994)
-- Name: pos_trx_detail pos_trx_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_detail
    ADD CONSTRAINT pos_trx_detail_fk FOREIGN KEY (pos_discount_id) REFERENCES public.pos_discount(pos_discount_id);


--
-- TOC entry 3276 (class 2606 OID 18999)
-- Name: pos_trx_inbound pos_trx_inbound_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_inbound
    ADD CONSTRAINT pos_trx_inbound_fk FOREIGN KEY (pos_branch_code) REFERENCES public.pos_branch(pos_branch_code);


--
-- TOC entry 3277 (class 2606 OID 19004)
-- Name: pos_trx_return pos_trx_return_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_trx_return
    ADD CONSTRAINT pos_trx_return_fk FOREIGN KEY (pos_branch_code) REFERENCES public.pos_branch(pos_branch_code);


--
-- TOC entry 3281 (class 2606 OID 19009)
-- Name: sys_role_section sys_role_section_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_role_section
    ADD CONSTRAINT sys_role_section_fk FOREIGN KEY (user_section_id) REFERENCES public.user_section(user_section_id);


--
-- TOC entry 3283 (class 2606 OID 19014)
-- Name: user_authentication user_authentication_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_authentication
    ADD CONSTRAINT user_authentication_fk FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- TOC entry 3282 (class 2606 OID 19019)
-- Name: user user_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_fk FOREIGN KEY (user_section_id) REFERENCES public.user_section(user_section_id);


--
-- TOC entry 3284 (class 2606 OID 19024)
-- Name: user_section user_section_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_section
    ADD CONSTRAINT user_section_fk FOREIGN KEY (user_department_id) REFERENCES public.user_department(user_department_id);


-- Completed on 2022-11-22 08:11:31

--
-- PostgreSQL database dump complete
--

