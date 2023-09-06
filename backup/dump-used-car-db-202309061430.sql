--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

-- Started on 2023-09-06 14:30:06

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

DROP DATABASE "used-car-db";
--
-- TOC entry 3407 (class 1262 OID 27557)
-- Name: used-car-db; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "used-car-db" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_Indonesia.1252';


ALTER DATABASE "used-car-db" OWNER TO postgres;

\connect -reuse-previous=on "dbname='used-car-db'"

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3408 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 27634)
-- Name: advertisements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.advertisements (
    ad_id integer NOT NULL,
    user_id integer NOT NULL,
    title character varying(100) NOT NULL,
    price numeric NOT NULL,
    description text NOT NULL,
    car_id integer NOT NULL,
    date_posted timestamp without time zone NOT NULL
);


ALTER TABLE public.advertisements OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 27654)
-- Name: bids; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bids (
    bid_id integer NOT NULL,
    ad_id integer NOT NULL,
    user_id integer NOT NULL,
    bid_price numeric NOT NULL,
    bid_status character varying(10) NOT NULL,
    datetime_bid timestamp without time zone NOT NULL,
    CONSTRAINT bids_bid_price_check CHECK ((bid_price > (0)::numeric)),
    CONSTRAINT bids_bid_status_check CHECK (((bid_status)::text = ANY (ARRAY[('approved'::character varying)::text, ('rejected'::character varying)::text, ('sent'::character varying)::text])))
);


ALTER TABLE public.bids OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 27653)
-- Name: bids_bid_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bids_bid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bids_bid_id_seq OWNER TO postgres;

--
-- TOC entry 3409 (class 0 OID 0)
-- Dependencies: 221
-- Name: bids_bid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bids_bid_id_seq OWNED BY public.bids.bid_id;


--
-- TOC entry 214 (class 1259 OID 27558)
-- Name: body_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.body_types (
    body_type_id character varying(6) NOT NULL,
    body_type_name character varying(25) NOT NULL
);


ALTER TABLE public.body_types OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 27584)
-- Name: cars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cars (
    car_id integer NOT NULL,
    manufacture_id character varying(4) NOT NULL,
    model_id character varying(6) NOT NULL,
    body_type_id character varying(6) NOT NULL,
    year_manufactured integer NOT NULL,
    engine_capacity numeric NOT NULL,
    passenger_capacity integer NOT NULL,
    transmission_type character varying(10) NOT NULL,
    fuel_type character varying(10) NOT NULL,
    drive_system character varying(5) NOT NULL,
    odometer integer,
    additional_details text,
    CONSTRAINT cars_drive_system_check CHECK (((drive_system)::text = ANY (ARRAY[('FWD'::character varying)::text, ('RWD'::character varying)::text, ('AWD'::character varying)::text]))),
    CONSTRAINT cars_engine_capacity_check CHECK (((engine_capacity >= (0)::numeric) AND (engine_capacity < (10)::numeric))),
    CONSTRAINT cars_fuel_type_check CHECK (((fuel_type)::text = ANY (ARRAY[('gasoline'::character varying)::text, ('diesel'::character varying)::text, ('hybrid'::character varying)::text, ('electric'::character varying)::text]))),
    CONSTRAINT cars_odometer_check CHECK ((odometer > 0)),
    CONSTRAINT cars_passenger_capacity_check CHECK (((passenger_capacity > 0) AND (passenger_capacity <= 12))),
    CONSTRAINT cars_transmission_type_check CHECK (((transmission_type)::text = ANY (ARRAY[('manual'::character varying)::text, ('automatic'::character varying)::text]))),
    CONSTRAINT cars_year_manufactured_check CHECK (((year_manufactured > 2000) AND ((year_manufactured)::numeric <= EXTRACT(year FROM CURRENT_DATE))))
);


ALTER TABLE public.cars OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 27615)
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    location_id integer NOT NULL,
    city_name character varying(25) NOT NULL,
    location point
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 27565)
-- Name: manufactures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manufactures (
    manufacture_id character varying(4) NOT NULL,
    manufacture_name character varying(25) NOT NULL
);


ALTER TABLE public.manufactures OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 27572)
-- Name: models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.models (
    model_id character varying(6) NOT NULL,
    manufacture_id character varying(4) NOT NULL,
    model_name character varying(100) NOT NULL
);


ALTER TABLE public.models OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 27620)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    first_name character varying(25) NOT NULL,
    last_name character varying(25) NOT NULL,
    email character varying(75) NOT NULL,
    contact character varying(25) NOT NULL,
    location_id integer NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 3201 (class 2604 OID 27657)
-- Name: bids bid_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bids ALTER COLUMN bid_id SET DEFAULT nextval('public.bids_bid_id_seq'::regclass);


--
-- TOC entry 3399 (class 0 OID 27634)
-- Dependencies: 220
-- Data for Name: advertisements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.advertisements (ad_id, user_id, title, price, description, car_id, date_posted) FROM stdin;
1	202	Jarak Mesin Kondisi Nego Ban Eksterior Kendaraan Langsung	675000000	Nihil dicta fuga beatae fuga fuga. Iste autem unde suscipit iure.	127	2023-06-26 00:21:23
2	102	Baru Terjamin Bekas Cat Murah Interior Service Negotiable	155000000	Fugit similique magnam commodi. Labore quos nostrum fugit nobis.	113	2023-03-16 07:34:15
3	105	Cat Harga Ban Pribadi Original Dp Surat Pajak Tangan	510000000	Ipsa officiis ratione non est voluptatibus quisquam. In accusantium quae alias beatae quisquam.	5	2022-11-14 06:04:13
4	325	Stnk Warna Pemakaian Langsung Oli	245000000	Non minima dolorem adipisci asperiores sint. Maxime earum repellat eligendi aperiam.	136	2023-02-26 05:43:22
5	266	Dp Nopol Tahun Ban Kilometer Stnk Kendaraan	500000000	Asperiores est numquam illo. Voluptatibus eum dicta illo.	123	2023-01-31 15:34:17
6	278	Tahun Cat Terjamin Mesin Jarang Service Bukan rental Pribadi	550000000	Deleniti omnis voluptas perferendis enim. Quod alias ducimus officia consequuntur. A sunt ad a commodi dolores.	22	2023-01-26 06:16:12
7	331	Baru Pemakaian Kilometer Jual Berkualitas Mulus Service	100000000	Asperiores ullam dolorem officiis nobis voluptate. Dicta quam odit doloribus impedit.	165	2023-02-19 08:14:07
8	213	Langsung Nopol Jual Pakai Baru	910000000	Harum vel non fugiat sapiente tempora. Quod temporibus et quos minus. Commodi reiciendis sit veritatis quaerat esse ullam.	171	2023-03-09 19:25:47
9	379	Warna Pemakaian Dp Berkualitas Pribadi	120000000	Ducimus ut dignissimos cum sequi. Dolorum quasi architecto praesentium impedit illum enim. Amet architecto nobis neque consectetur ex atque.	101	2023-05-09 23:54:51
10	128	Mobil Service Murah Pribadi Kendaraan Langsung Kilometer	5800000000	Repellat sunt tempore explicabo aperiam libero. Nam eveniet et animi quasi neque. Rem adipisci amet provident eum.	36	2023-06-13 21:08:59
11	281	Jarak Cat Terawat Service Velg Pemakaian Dp Kondisi Cicilan	135000000	Impedit cumque vitae laboriosam optio fugiat sunt. Harum dolor iusto voluptas iste accusantium voluptate. Sapiente temporibus vero expedita quam. Adipisci dolor deserunt ipsam.	131	2023-01-15 01:42:38
12	91	Berkualitas Stnk Baru Terjamin Mulus Velg Dokumen Cat	155000000	Animi voluptate commodi. Quidem aut non expedita. Deserunt illum totam molestias cum beatae officiis.	195	2022-10-16 05:46:53
13	307	Kendaraan Service Jarak Langsung Interior Murah Tangan	800000000	Inventore voluptatem quam natus. Itaque occaecati neque laudantium aspernatur expedita aut.	81	2023-03-18 09:49:15
14	24	Dokumen Pakai Baru Berkualitas Kendaraan Mesin Kondisi Oli Bukan rental Tahun	910000000	Modi vel vero recusandae odio. Provident maiores repellat iure. Maxime nemo pariatur culpa.	24	2022-11-18 18:37:51
15	18	Oli Original Terjamin Service Tangan Pribadi Negotiable Terawat	2750000000	Eaque molestias delectus occaecati iusto occaecati veniam nobis. Tempora necessitatibus sit magni mollitia quod autem. Mollitia iure voluptatem unde.	190	2023-06-29 19:32:04
16	41	Murah Mulus Full Mobil Nopol	850000000	Quam quidem non hic porro nemo nihil. Asperiores natus quia dolorem. Suscipit voluptas qui nesciunt totam maiores.	119	2022-12-18 21:21:35
17	322	Terjamin Jarang Murah Mulus Cat Tahun Pribadi Cicilan Bekas	181000000	Minima id consequatur itaque perspiciatis beatae. Laborum laudantium beatae autem voluptatem.	173	2022-11-07 12:31:41
18	85	Warna Cicilan Pajak Pakai Tahun Dokumen Siap Dp Cash	127000000	Animi fugit dicta magnam soluta corporis. Deserunt impedit omnis at. Nemo nisi facilis veniam exercitationem adipisci enim repudiandae. Officiis itaque ipsa porro modi impedit.	187	2022-09-12 05:39:13
19	147	Tangan Murah Eksterior Dp Cicilan Cash Kilometer Asli Langsung	1700000000	Itaque quibusdam in dolor. Quos neque veniam. Ipsam nihil commodi quo ipsum.	170	2023-07-26 23:18:43
20	86	Full Ban Tangan Velg Interior Cat Stnk Pribadi	285000000	Laborum voluptatem sed commodi provident itaque ipsam. Vero fugiat nihil cumque voluptatem iure reiciendis nulla.	114	2023-01-14 02:44:52
21	143	Surat Berkualitas Terjamin Oli Jual Negotiable	297000000	Quis quis voluptatibus dicta. Repellendus laboriosam laborum laboriosam dolorem. Fugiat veniam provident aut minus minima.	91	2022-12-30 04:46:08
22	390	Tangan Kilometer Pajak Dokumen Nego Terawat Oli	260000000	Voluptas quisquam veniam quas. Eum commodi quo dignissimos. Ipsa id temporibus rem.	178	2022-12-21 14:36:15
23	115	Cicilan Tahun Kredit Mobil Jual Service Velg Stnk Kendaraan	850000000	Nobis magnam totam neque reprehenderit. Ratione dolores doloremque non deleniti ipsam officia.	69	2023-05-23 21:49:24
24	355	Cat Terawat Pribadi Cicilan Kilometer Negotiable Tangan Oli Siap	225000000	Voluptatibus eos itaque dignissimos fugit eligendi. Quaerat nulla tempore aliquam. Dolorum autem sit voluptas. Quia commodi eligendi omnis est dolorem vel nesciunt.	44	2023-04-29 22:15:23
25	210	Interior Km Pemakaian Jarak Dp Harga Baru Stnk Cat	215000000	Quos hic provident dolore eos. Architecto labore expedita dolor. Beatae eius ab excepturi iure labore qui aliquid.	55	2023-06-23 08:23:20
26	313	Pajak Oli Kilometer Tahun Cash Berkualitas Siap Asli	195000000	Atque recusandae expedita eius inventore deserunt. Quam eos a aliquid rerum incidunt asperiores.	31	2023-03-31 04:38:26
27	272	Km Berkualitas Negotiable Langsung Original Jarak Tangan	130000000	Maxime illum consequatur nulla ad molestias cum. Laborum rem eos architecto voluptatum molestias culpa.	92	2022-11-13 01:35:52
28	377	Service Jarang Nopol Dp Eksterior	297000000	Quo ratione necessitatibus. Vitae error quisquam esse temporibus corporis deleniti.	78	2022-12-04 07:09:55
29	19	Dokumen Dp Tahun Nego Siap Baru Km Interior Service Berkualitas	775000000	Minima neque explicabo. Assumenda tenetur explicabo nostrum facilis eius.	180	2022-11-29 22:00:28
30	38	Siap Dokumen Langsung Service Berkualitas Cash	215000000	Repellat fuga eveniet deserunt sed nemo quas. Praesentium eveniet id asperiores voluptatibus. Vel provident quia ex dicta distinctio.	178	2022-12-18 19:43:09
31	205	Jarang Mesin Kendaraan Surat Nopol Murah Velg	1100000000	Ab quo architecto minima natus quam. Nesciunt voluptate tempora dignissimos officia.	171	2023-02-04 06:25:00
32	304	Dp Kendaraan Eksterior Harga Interior	276000000	Vitae beatae odio porro rerum. Nemo nobis doloribus voluptatum excepturi ducimus fugit.	55	2023-01-22 11:54:11
33	118	Service Jual Pemakaian Kendaraan Eksterior	650000000	Recusandae libero deleniti. Laborum culpa officiis ducimus laudantium. Iste esse accusantium dolore eveniet aliquid. Quos velit earum facilis quas voluptatibus.	61	2022-11-22 21:01:30
34	332	Negotiable Jarang Bekas Interior Berkualitas Murah Siap	4650000000	Voluptas alias voluptatem adipisci. Quis quam vero omnis delectus a aperiam optio.	36	2022-08-30 13:22:09
35	54	Asli Cash Berkualitas Velg Kilometer Warna Dokumen Bekas Jarang Cicilan	110000000	Dignissimos neque odit deleniti. Consectetur iure expedita numquam.	116	2023-04-10 15:15:45
36	241	Pajak Oli Pribadi Tangan Dokumen Pakai	775000000	Quisquam repellendus ipsum similique dolores eum. Odit sit ab distinctio quibusdam doloremque. Doloremque esse amet laudantium autem.	133	2023-04-16 02:54:50
37	280	Cat Pemakaian Warna Bukan rental Ban Stnk	860000000	Accusantium mollitia ipsam corrupti fugit et. Qui quis laboriosam amet.	67	2023-05-09 16:18:01
148	80	Jual Pemakaian Tangan Kilometer Mobil Baru Pakai Dp	159000000	Rerum deleniti alias adipisci tenetur.	1	2022-11-21 12:42:01
38	323	Km Pakai Jarak Surat Eksterior Cicilan Pajak Terjamin Jual Kendaraan	155000000	Facere voluptas debitis molestias at. Hic eos voluptatem laudantium nihil. Nulla atque accusamus ex fugit tempore ipsa.	17	2022-08-29 08:22:22
39	169	Bukan rental Warna Dp Ban Mobil Interior Cat	825000000	Eum officia ullam labore deserunt. Laboriosam quaerat autem voluptatem. Commodi adipisci esse ratione.	141	2022-11-22 07:14:30
40	15	Oli Ban Bekas Velg Terawat Mobil Murah	180000000	Aperiam magni perspiciatis magni ab eligendi. Vitae impedit eveniet libero accusantium.	105	2023-01-28 07:03:23
41	270	Jarak Siap Cicilan Berkualitas Pribadi Cash Kredit Terawat Harga Kondisi	100000000	Natus quidem sunt voluptate quo laudantium. Dignissimos atque sunt sapiente nemo doloremque maxime. Aut eligendi blanditiis.	188	2022-11-01 18:41:46
42	4	Velg Pakai Warna Mulus Original Km Cash Oli Kilometer Terjamin	517000000	Recusandae veritatis voluptatibus rerum quae voluptas sapiente inventore. Quasi voluptates similique molestiae. Ut asperiores delectus iure.	65	2023-05-01 20:33:14
43	67	Murah Kendaraan Service Interior Nopol Pajak Pakai Berkualitas Cat Dp	590000000	Vel deserunt sed animi esse. Esse assumenda minima accusamus accusamus. Magnam in eos eveniet harum laboriosam perferendis maxime.	139	2022-12-15 15:29:04
44	328	Interior Jual Mobil Jarak Cicilan Terjamin	500000000	Laboriosam dolorum delectus laudantium sit deleniti aut odio. Deserunt commodi omnis explicabo officiis ratione quisquam.	123	2022-10-06 15:22:10
45	17	Mulus Mesin Service Surat Cicilan	110000000	Quis ullam expedita nostrum culpa atque ducimus. Dolores dolor accusantium eveniet rem temporibus error. Reprehenderit quos eligendi sapiente aspernatur.	117	2023-02-22 04:32:48
46	302	Mobil Mulus Pemakaian Surat Terawat Tahun Pakai Siap Oli Stnk	325000000	Soluta incidunt blanditiis iusto voluptatem. Earum quaerat sequi cupiditate ipsa repellendus eius.	21	2023-06-07 20:59:11
47	96	Surat Harga Mulus Warna Jual Mobil Langsung Cat Kilometer Kendaraan	197000000	Adipisci explicabo maiores. Molestiae dolorum molestias illo placeat. Consectetur sint voluptas laudantium ut eveniet iste.	108	2023-03-12 17:27:21
48	372	Kondisi Jarang Bekas Cicilan Velg Pribadi Kendaraan Stnk Jual Full	135000000	Veniam nulla neque mollitia impedit tenetur.	185	2023-07-11 14:18:47
49	369	Jarak Kredit Full Nopol Bukan rental Baru Surat Jual	127000000	Excepturi perspiciatis perferendis aut consequatur natus quibusdam animi. Doloremque corporis accusantium alias doloribus quod deleniti.	117	2022-11-04 13:27:07
50	329	Pajak Bukan rental Harga Bekas Jual Warna Siap Original Tahun Mesin	260000000	Nemo aliquid dicta rem. Quaerat quia beatae consectetur minus non velit. Officia minima eius sit at hic omnis quibusdam.	200	2022-08-14 17:22:53
51	386	Cicilan Oli Jarang Warna Mesin Berkualitas Nopol	230000000	Nemo deserunt assumenda accusantium et fuga nulla. Exercitationem eveniet error optio quaerat.	31	2023-01-30 08:38:57
52	316	Kilometer Kendaraan Service Tahun Km	100000000	Sit dignissimos ut ipsam quibusdam possimus deleniti. Tempore eum nulla illo eum eius dignissimos voluptate. Repellat dignissimos vitae exercitationem explicabo excepturi ullam assumenda.	188	2023-04-01 03:28:33
53	399	Jual Mulus Tahun Berkualitas Dp	197000000	Voluptate temporibus optio rem soluta nobis. Ullam cumque nesciunt qui animi eum.	101	2023-04-08 15:38:32
54	326	Baru Pajak Dokumen Surat Kendaraan Bukan rental Pemakaian Cicilan Jual	245000000	Omnis incidunt eos quas. Quas totam beatae iure modi magni. Laborum error veniam quo natus quam dolorem maiores.	144	2023-03-21 00:08:04
55	353	Interior Pribadi Mobil Jarak Bekas Km Dp Baru Full Pajak	1950000000	Exercitationem magnam consequatur dolor.	107	2023-01-20 21:01:45
56	74	Pakai Cicilan Murah Mobil Tangan Terjamin Cash Kendaraan Original	159000000	Possimus mollitia quasi amet velit doloribus. Incidunt itaque error itaque.	163	2022-11-03 05:34:11
57	331	Dokumen Original Pajak Murah Cicilan	185000000	Provident iure magni officiis ducimus occaecati magni. Voluptatibus totam unde. Officia saepe corporis suscipit optio nostrum sint.	28	2023-07-04 08:39:16
58	305	Terjamin Original Surat Pakai Mobil Pribadi Warna Jarak Jual	1650000000	Cum ipsum sequi fugiat eaque aliquam autem id. Dolor repellendus aliquam minus labore facere consequuntur.	138	2023-03-09 21:30:27
59	66	Surat Pemakaian Mulus Pakai Original Km Interior Tangan	775000000	Iste ea dignissimos quos sunt culpa. Eligendi excepturi explicabo voluptas ab est fuga. Perferendis nesciunt voluptatem sapiente.	160	2023-02-07 16:43:37
60	296	Baru Nopol Nego Ban Mesin Km	95000	Temporibus ut nostrum. Ipsam dolorem tempore minus ut itaque numquam totam.	14	2023-06-18 23:59:25
61	202	Stnk Pajak Negotiable Cash Warna Km Dp Mesin Terawat Original	380000000	Fugit exercitationem molestiae eos harum. Distinctio nemo eveniet quo harum. Eum numquam harum corporis a quae doloribus quaerat.	198	2023-01-15 14:42:53
62	78	Original Berkualitas Negotiable Mulus Siap Kondisi Harga Service Murah Stnk	123000000	Ullam numquam assumenda veniam. Velit alias a vitae quam officia voluptatum.	118	2023-01-19 03:46:02
63	353	Dp Warna Jarang Harga Cat Kendaraan Service	300000000	Minus quis natus vitae. Cum eum modi accusantium voluptatum quae.	153	2023-02-21 04:58:28
64	282	Kendaraan Interior Terawat Eksterior Pajak Warna	181000000	Inventore voluptatum omnis rem suscipit sit amet consequuntur. Ex necessitatibus perspiciatis quidem.	168	2023-05-06 06:12:50
65	375	Langsung Service Interior Full Negotiable	500000000	Repudiandae consectetur modi officiis quod id cum. Ipsum totam aliquid ab vel. Provident iste dolores earum rem voluptatum quos.	13	2023-03-12 12:06:11
66	137	Kendaraan Service Original Pemakaian Mesin	155000000	Exercitationem minima beatae sint. Optio eius blanditiis nesciunt nemo. Asperiores laborum laudantium. Totam enim distinctio ex unde.	113	2022-08-20 22:41:02
67	112	Ban Negotiable Cicilan Tangan Km Pribadi Pemakaian	100000000	Pariatur ipsum impedit deleniti aperiam odio. Illum magni aliquid hic dolorem explicabo ducimus. Sit dolore voluptas.	47	2023-04-21 13:23:19
68	32	Jual Siap Tangan Langsung Terawat Cat Cash Km Tahun	155000000	Soluta iusto dolorem consequuntur natus. Tenetur molestiae occaecati quaerat modi veniam officia odit. Facilis iste minima.	131	2023-07-18 07:24:36
69	124	Harga Mesin Cash Negotiable Eksterior Asli Terawat Bekas	110000000	Molestiae voluptatum animi debitis neque nisi. Quas nemo quidem temporibus laborum ratione tempora sunt.	187	2023-05-29 03:33:14
70	305	Pribadi Tahun Mesin Interior Oli Baru Nopol Jual	819000000	Excepturi minima enim explicabo. Repudiandae nisi enim aperiam quisquam labore fugit.	199	2023-04-12 13:29:42
71	55	Full Interior Kendaraan Pakai Kilometer Surat	1075000000	Architecto minima doloribus perspiciatis nam maiores a. Rerum veritatis aut eius. Quod earum pariatur at quos.	94	2022-10-05 07:12:26
72	329	Kondisi Cicilan Pribadi Kendaraan Dp	600000000	Mollitia reprehenderit corrupti. Ut ipsum voluptate hic.	74	2023-04-24 10:09:37
73	63	Warna Pakai Eksterior Siap Stnk Dokumen Cash Kredit Pemakaian	1100000000	Nisi fugiat quidem voluptatem nesciunt accusantium perspiciatis corporis.	64	2022-09-27 12:20:30
264	400	Asli Pakai Mesin Stnk Nego	850000000	In voluptas perspiciatis rem ab occaecati amet praesentium. Quod dolores minima vitae alias.	120	2023-02-10 22:19:34
74	382	Oli Berkualitas Pajak Cicilan Pemakaian Nopol Asli	159000000	Optio voluptates impedit incidunt nesciunt vel temporibus. Atque voluptatibus maiores consequatur nam nobis. Ea fuga iure impedit dignissimos eum assumenda. In magnam eligendi eligendi dicta cum perspiciatis.	39	2023-02-13 13:46:50
75	96	Murah Kendaraan Langsung Negotiable Pemakaian Nego Terjamin Velg Warna	159000000	Voluptas debitis earum molestias. Velit numquam perferendis dolorum qui facilis recusandae. Minima eos mollitia eaque numquam inventore aspernatur unde.	165	2023-02-03 11:58:42
76	6	Kredit Terjamin Pakai Nopol Cicilan Mobil Dp Pribadi Mulus Jarak	850000000	Expedita error explicabo eius laudantium. Impedit consectetur dolorum illum neque omnis consequuntur. Totam iste odit vel esse reiciendis aliquam.	2	2023-02-20 19:52:39
77	42	Service Original Eksterior Dokumen Nopol Ban Jarak	107000000	Eveniet laborum minima cum quo consequuntur.	18	2023-07-29 20:23:06
78	382	Pakai Pribadi Harga Terjamin Pemakaian	100000000	Esse animi dicta dolorem. Placeat minima veritatis accusamus doloribus harum. Esse beatae qui error minima incidunt occaecati.	188	2023-04-17 22:35:54
79	89	Pemakaian Murah Dokumen Velg Tahun Nego Negotiable Asli	110000000	Deleniti qui ut voluptate suscipit. Tenetur doloremque minima est.	116	2023-07-08 05:25:53
80	206	Km Langsung Siap Kilometer Cicilan Jarang Negotiable	825000000	Nam voluptas numquam reprehenderit assumenda fugit qui. Accusamus quasi possimus praesentium eos consequatur. Culpa velit magni voluptate.	175	2022-10-31 03:24:29
81	159	Bukan rental Cat Berkualitas Original Service	154000000	Tempora voluptatum facilis inventore optio quam dignissimos temporibus. Perferendis laudantium reprehenderit.	86	2022-12-27 11:57:22
82	61	Mobil Jual Original Nopol Kondisi Pemakaian Service Eksterior Velg Pakai	520000000	Perferendis libero suscipit omnis itaque. Culpa itaque nisi. Amet vitae error aut reiciendis quod explicabo excepturi.	62	2023-01-10 15:50:29
83	88	Km Eksterior Terawat Tahun Velg Mobil Interior Pemakaian	147500000	Eos voluptatem soluta blanditiis. Illum neque corrupti aliquam suscipit.	117	2023-04-05 07:45:51
84	377	Tangan Oli Stnk Dokumen Mesin Cicilan	297000000	Nihil itaque neque totam nesciunt tempore. Suscipit neque mollitia placeat sunt iure.	139	2023-01-16 20:10:23
85	138	Dokumen Pemakaian Original Km Jual Tangan Bekas Siap Mulus Langsung	200000000	Est iusto dolorum eaque similique delectus magnam. Quidem error veritatis voluptate neque debitis dolorum. Sint impedit molestias beatae eaque. Id vel harum aliquid.	44	2023-07-19 09:08:47
86	145	Interior Berkualitas Surat Velg Terjamin Mesin Langsung Jarang Service Original	1450000000	Quos corporis nostrum omnis rerum. Enim itaque dolore dignissimos accusantium dolor asperiores. Occaecati quae natus sint animi similique perferendis.	128	2023-06-13 06:30:24
87	131	Mesin Nego Eksterior Ban Mobil Kilometer Original	380000000	A incidunt voluptatem doloribus aut iste. Enim dolores consequatur quidem. Et magnam dolor reprehenderit fugit dignissimos eius necessitatibus.	124	2022-11-28 09:18:02
88	130	Cicilan Terjamin Warna Jarang Terawat	100000000	Fugiat blanditiis amet rerum odit corporis. Tenetur maiores vel laboriosam velit. Numquam animi blanditiis quaerat culpa.	118	2023-03-26 20:58:18
89	301	Jarang Asli Tangan Dp Full Harga Bekas Stnk Oli Pajak	253000000	Consequatur odit autem vel. Sed praesentium veniam voluptatum laborum quisquam aspernatur. Necessitatibus neque unde autem dignissimos minima illum. Temporibus incidunt labore maxime voluptates quod reiciendis facere.	179	2022-12-23 10:00:45
90	99	Bukan rental Velg Murah Jarang Jual Stnk Oli	159000000	Esse necessitatibus aperiam rerum architecto. Libero minima quisquam harum vitae consequuntur neque. Provident atque facere sapiente ratione. Necessitatibus occaecati tempore mollitia itaque consectetur.	15	2023-02-20 16:02:29
91	48	Kilometer Tangan Berkualitas Cat Negotiable Terjamin Interior	850000000	Et veniam quia corrupti totam error. Exercitationem dolorem sapiente quisquam culpa et. Ratione consectetur dolore corporis.	129	2022-08-31 04:16:18
92	225	Terawat Kredit Langsung Jarak Tahun Asli	1950000000	Accusamus error qui voluptates. Quia a neque perspiciatis officiis architecto aperiam.	154	2023-04-25 14:11:56
93	16	Mulus Terawat Kredit Mobil Cash Tangan Jarak	225000000	Quis praesentium deleniti adipisci odio architecto. Quos aut sapiente voluptate.	112	2023-06-30 03:25:50
94	348	Tahun Mobil Murah Jarang Berkualitas Cash Terjamin Asli	125000000	Incidunt rerum quod pariatur. Cum quis sed deserunt quam aliquam cumque.	71	2022-10-11 03:55:46
95	229	Negotiable Pakai Warna Harga Kendaraan Bukan rental	800000000	Aperiam nulla autem sint beatae beatae. Corrupti sed repellat neque reiciendis. Quis itaque accusantium at expedita maiores.	191	2023-01-29 19:33:17
96	2	Bekas Km Nopol Jarang Kilometer Ban Jarak Kredit Pajak Dp	260000000	Asperiores nam quasi at hic voluptate voluptatibus eius. Consectetur minima veniam velit.	35	2022-10-30 20:44:59
97	140	Tahun Mesin Terawat Pakai Service Cash Terjamin	190000000	Ipsam incidunt nobis ea. Fuga possimus distinctio inventore asperiores.	16	2022-12-29 23:52:50
98	93	Kilometer Tahun Tangan Negotiable Km	228000000	Dolores dolore maiores maiores. Vitae vero vero unde aperiam reprehenderit.	137	2023-05-04 18:00:30
99	102	Siap Km Warna Surat Stnk	590000000	Iste qui quae nam. Temporibus labore maxime ipsa. Porro quod voluptate perferendis quos.	91	2023-05-13 09:54:53
100	111	Tahun Cat Siap Jarak Original Berkualitas Kilometer Mesin Bukan rental	398000000	Consequuntur accusantium magnam. Quidem architecto cupiditate.	59	2023-03-20 12:38:40
101	119	Original Pemakaian Nego Jarak Pakai	825000000	Ullam dolore voluptate blanditiis unde velit.	133	2023-03-20 10:38:49
102	10	Surat Velg Stnk Full Kredit Km Pajak Pemakaian Cat	1295000000	Saepe perferendis consequatur non excepturi cupiditate occaecati.	100	2023-07-21 12:52:56
103	363	Harga Berkualitas Cat Kilometer Asli Original	199000000	Harum tenetur perspiciatis sint totam minus repudiandae. Autem necessitatibus delectus repellendus at nisi alias. Sint voluptatibus aperiam minus eligendi expedita quia quo.	104	2023-04-01 17:08:59
104	160	Nopol Ban Mulus Negotiable Asli Pajak Berkualitas Cicilan Service Dp	159000000	Rerum ut laborum voluptatem illo. Cum velit facilis sunt odit fuga earum.	47	2023-08-03 05:25:59
105	252	Asli Original Langsung Kendaraan Dp Berkualitas Mobil	110000000	Doloremque similique magni minus. Odit ab perspiciatis officia impedit sapiente incidunt maxime. Quidem odio esse molestias hic maxime.	85	2022-12-31 00:56:18
106	358	Asli Cat Baru Original Siap Dp	1845000000	Et eveniet distinctio sed id commodi. Maxime perspiciatis harum porro.	45	2022-12-28 19:00:19
107	119	Pajak Bekas Harga Pakai Oli	500000000	Quaerat optio cum adipisci doloribus praesentium. Provident consequatur corrupti quasi voluptate ipsam labore. Voluptatem magni autem explicabo.	90	2023-05-04 12:49:43
108	79	Bukan rental Surat Tangan Ban Oli Cat Murah Harga Bekas	517000000	Ad vitae hic recusandae recusandae illo enim. Laboriosam totam ab quaerat corporis. Impedit veniam tenetur.	166	2022-09-15 07:59:40
147	312	Negotiable Ban Cicilan Jarang Eksterior Berkualitas Cat Kredit Terjamin	850000000	Dicta repudiandae molestias consectetur. Magni reprehenderit saepe reiciendis. Molestias possimus dolor.	74	2023-05-15 05:22:22
109	36	Tangan Bukan rental Harga Pakai Murah Kendaraan Surat Original Langsung Cicilan	127000000	Tempora magni rem excepturi quae velit. Voluptatibus reprehenderit ratione distinctio sapiente architecto quae. Quibusdam inventore nostrum iusto.	85	2022-10-09 23:33:49
110	149	Pajak Berkualitas Kondisi Velg Service Mulus	450000000	Culpa veritatis eum quaerat temporibus quia tenetur ducimus. Eaque voluptate tempore ex maiores. Dolorum itaque repellat a quibusdam ipsa perspiciatis minima.	198	2023-02-04 02:41:17
111	352	Surat Pribadi Dp Nopol Jual Oli Bekas Asli	463000000	Unde accusantium expedita explicabo. Saepe commodi molestiae nostrum optio.	197	2022-12-01 16:10:14
112	394	Kondisi Tahun Murah Cicilan Oli Pribadi	123000000	Corporis tenetur tempore veritatis placeat dolor id officia. Officia odit natus soluta nam. Officiis provident voluptas delectus nisi incidunt.	1	2023-05-06 10:10:28
113	263	Jarak Nego Oli Negotiable Kredit Pakai Mulus Bekas Surat	300000000	Architecto laboriosam possimus dolor sequi ipsa reprehenderit dolore. Quia labore quia ipsam nisi harum.	42	2022-10-31 06:08:52
114	84	Kendaraan Kilometer Nego Mulus Terawat Warna Surat	185000000	Quasi aliquam dignissimos assumenda. Corrupti eius eum quia sed amet voluptatum.	28	2023-01-20 10:44:42
115	190	Km Kilometer Bukan rental Terjamin Dp Terawat Berkualitas	190000000	Animi ea rem totam. Quos ratione quo doloremque sequi dicta.	63	2023-04-29 23:12:40
116	214	Original Mulus Terjamin Pajak Harga Nopol Kondisi Murah Velg	975000000	Nihil ut id error eum tempore. Illum accusantium corrupti facere dolores.	127	2023-04-20 01:24:23
117	279	Warna Ban Harga Bukan rental Kendaraan Tangan	112000	Soluta quae velit numquam eaque ea. Necessitatibus maxime consequatur accusantium perferendis.	18	2023-06-19 12:44:31
118	66	Mulus Asli Velg Pajak Jarang Tangan Surat	147500000	Pariatur id eveniet quidem beatae. Nisi mollitia saepe necessitatibus. Eum dolorum quia dolore.	187	2022-11-09 12:36:59
119	326	Original Langsung Pajak Ban Km Bekas	200000000	Rerum quisquam maxime nostrum. Excepturi deleniti distinctio mollitia.	112	2023-01-24 17:53:46
120	244	Original Bekas Jarak Terjamin Service Baru Interior Terawat Dp	181000000	Eaque modi quaerat voluptatibus ad illo. Repellat totam fuga harum. Officia dignissimos voluptates blanditiis sunt iste iusto.	103	2022-11-08 15:49:30
121	76	Tangan Terawat Cash Cat Warna Nopol Bukan rental Baru Siap	127000000	Dolore qui facere incidunt quod a atque. Nihil delectus libero molestias fugit.	83	2023-04-24 12:07:19
122	228	Pribadi Cicilan Nego Terawat Ban Jual	120000000	Quisquam odit deserunt autem minus esse maiores. Tenetur cupiditate occaecati magnam a ad assumenda. Harum doloribus eligendi nulla architecto incidunt.	101	2023-07-22 04:28:07
123	33	Jual Nopol Berkualitas Tahun Asli	450000000	Ipsa officiis ratione a rem cumque. Eveniet cumque suscipit quibusdam.	124	2023-06-15 19:03:38
124	137	Kondisi Langsung Mesin Tangan Full	445000000	Maxime amet corporis. Fuga quaerat at doloremque quisquam atque sunt. Dignissimos quam aperiam veniam nemo.	78	2023-03-25 00:28:41
125	235	Oli Asli Kendaraan Cash Eksterior Mulus	440000000	Esse explicabo facilis. Consequuntur animi neque dolor.	21	2022-10-24 03:15:49
126	268	Pajak Pakai Stnk Siap Dokumen Langsung Full Terjamin Cicilan Baru	180000000	Id ipsam atque delectus. Facere magnam provident minus sequi incidunt.	66	2023-02-06 09:50:43
127	31	Cat Dokumen Murah Full Cicilan Surat Terawat	127000000	Cum et nam ipsam magnam rem. Ipsum nam commodi voluptatibus porro quod quam.	135	2022-11-07 10:52:36
128	83	Mesin Pajak Dokumen Terjamin Nego Bukan rental Kendaraan Km Kilometer Velg	210000000	Cumque ducimus accusamus natus amet minima aut. Doloremque excepturi aut corrupti quo. Consequuntur neque asperiores repellendus suscipit.	106	2023-05-09 16:51:22
129	23	Mulus Ban Kilometer Asli Full Jual Dokumen Siap Oli Service	110000000	Dolor modi totam. Nesciunt nobis omnis vel voluptatem molestias. Placeat praesentium excepturi iste itaque libero laudantium velit. Sint sapiente esse harum debitis mollitia dicta.	56	2022-11-10 18:46:05
130	290	Langsung Stnk Eksterior Velg Siap Nego Original Kendaraan	1350000000	In doloribus voluptates nisi sapiente. Dolorem deleniti explicabo.	95	2023-04-26 16:04:19
131	378	Siap Jarak Kondisi Berkualitas Interior Nego Full Asli	210000000	Possimus modi asperiores nam similique. Repellendus harum facilis eaque ab autem ipsam expedita.	146	2023-05-09 17:20:29
132	370	Cat Mesin Harga Tahun Warna Kondisi Nopol Original Full	225000000	Corrupti modi quos illo vitae odit. Hic tempore rem neque.	54	2022-10-20 13:54:16
133	141	Pajak Jual Harga Dokumen Berkualitas Asli Terawat Cat Bukan rental Dp	155000000	Quo perspiciatis eum. Qui nulla accusamus tempore sunt ex nulla quisquam. Corrupti dicta ab iure magni dolore magni.	82	2023-07-07 16:02:39
134	366	Jarak Kondisi Kendaraan Interior Mulus Jarang Eksterior Service Bekas	470000000	Praesentium illo dolores non iusto ratione commodi. Labore veritatis exercitationem. Dicta nobis sint.	169	2023-05-18 07:52:59
135	217	Service Surat Interior Jual Mobil Baru	1700000000	Delectus consectetur cumque. Itaque dolor quibusdam neque vel. Rem illum totam vero sit rerum repellat commodi.	107	2022-09-13 15:31:47
136	213	Ban Original Tahun Dp Bekas Interior Mulus Murah Nopol	1450000000	Consequatur voluptates vitae. Ex cumque accusamus fugiat corporis ab. Reprehenderit error quo aliquid facilis libero commodi.	45	2022-10-30 04:45:01
137	377	Pribadi Km Kredit Terawat Harga	125000000	Quisquam quam earum. Ad quaerat maiores placeat. Cumque commodi aliquam nam.	57	2023-04-02 13:58:48
138	350	Ban Mesin Velg Surat Bukan rental Tahun Pajak Baru Eksterior Service	285000000	Quasi enim natus ipsum eum impedit error iure. Natus fugiat ea.	114	2022-12-18 20:02:19
139	131	Service Cicilan Mobil Full Dokumen	520000000	Inventore iusto deleniti quis tempore. Esse sequi fugit expedita nulla.	62	2023-05-01 02:53:25
140	266	Full Pemakaian Jual Murah Terjamin Mobil Mesin Tangan	230000000	Itaque reprehenderit sunt voluptates odit asperiores ipsum recusandae. Minima reiciendis molestiae exercitationem dolorem.	144	2023-03-30 14:02:55
141	305	Mulus Cat Oli Bekas Kondisi Pribadi Berkualitas	325000000	Nostrum placeat praesentium voluptatum itaque ducimus dolores soluta. Rem amet tenetur vitae. Totam delectus deserunt similique totam ratione officiis.	136	2023-01-25 14:22:06
142	206	Cat Kilometer Tahun Kondisi Terjamin Langsung Jarak Pemakaian Full Dp	520000000	Soluta quas aperiam alias reprehenderit vel voluptatibus. Sed magnam mollitia nemo repellendus animi libero assumenda.	197	2022-08-16 10:23:08
143	160	Kendaraan Nopol Mulus Oli Siap Jual Baru Tangan	125000000	Libero delectus ab adipisci exercitationem. Labore nisi iure magnam unde officia soluta.	195	2023-02-02 15:56:06
144	392	Pajak Surat Pribadi Jarak Service Pemakaian Original Murah	1700000000	Sequi explicabo nemo voluptatem nisi molestiae adipisci. Iusto laudantium eius iusto vitae rerum nam perspiciatis.	170	2023-06-04 15:38:43
145	367	Oli Jual Pemakaian Kendaraan Service Full Siap Kondisi	212500000	Accusamus veritatis dolorum dignissimos quam expedita ipsa. Esse dolore aspernatur nobis quo.	173	2022-12-11 06:07:35
146	203	Interior Kilometer Bukan rental Tangan Nego Dp Berkualitas Langsung	110000000	Quasi quibusdam quae exercitationem corporis quisquam non. Dolorum iure veritatis dolor.	178	2022-12-06 05:25:18
149	308	Berkualitas Terawat Surat Tahun Pemakaian Bekas Pakai Terjamin	590000000	Ratione assumenda dolore ducimus molestias maiores nemo. Eligendi facilis laboriosam eaque laudantium fuga commodi debitis.	96	2023-02-07 03:53:55
150	84	Service Terjamin Mobil Interior Dokumen Pribadi Velg Surat	450000000	Officiis ipsam illo repellat quia impedit. Odit porro debitis veniam est.	70	2023-07-03 03:34:05
151	207	Berkualitas Dokumen Kredit Warna Nego Siap Asli Tahun Kilometer	107000000	Dicta nesciunt iure tempore exercitationem ex nam. Quam facilis voluptas autem. Autem provident at nisi suscipit odio dignissimos.	49	2022-12-31 23:41:02
152	9	Service Full Interior Siap Baru Jual	210000000	Soluta perspiciatis iste ut dolorem enim voluptas numquam. Minus numquam ratione deleniti voluptas.	146	2023-06-14 02:58:28
153	47	Dokumen Cash Surat Kredit Km Warna Kilometer Stnk Asli Berkualitas	230000000	Cupiditate voluptas doloribus laborum molestias. Minus consequatur voluptates earum sit.	33	2023-02-23 07:03:08
154	240	Mulus Mesin Negotiable Ban Dp Warna Original Tangan Baru	1625000000	Sapiente hic non dolorum. Culpa provident dolore sint odit fuga pariatur. Iure sit dicta alias aut animi tempore.	199	2022-12-19 09:21:53
155	277	Kendaraan Harga Negotiable Cicilan Kondisi Siap Velg	850000000	Voluptatem ratione cum velit mollitia possimus maxime. Sunt facere nostrum non incidunt odio nihil. Rem suscipit perferendis optio debitis.	69	2023-04-27 01:09:51
156	112	Mesin Km Negotiable Kendaraan Nopol Cicilan Pemakaian	1700000000	Asperiores quaerat quae asperiores. Itaque soluta odio assumenda. Animi inventore dolore ipsa.	107	2023-03-18 04:40:23
157	307	Mesin Tangan Cash Cicilan Cat Kondisi Km Kendaraan	125000000	Nam sint culpa ea ipsam. Ratione fuga ipsam labore. Nisi ut saepe ad harum tempore magni.	193	2023-05-01 21:27:47
158	22	Nego Jarang Terawat Terjamin Kilometer	230000000	Placeat rerum earum aliquid. Sunt voluptas debitis repellendus quidem optio cumque.	121	2023-05-10 17:31:18
159	281	Full Original Eksterior Asli Berkualitas Km Interior	127000000	Deserunt ad cum veritatis. Deserunt ab aperiam sequi.	117	2023-02-06 08:49:59
160	320	Original Dp Mobil Murah Tangan	1450000000	Tempora ipsam laudantium facilis sint nisi neque. Ipsum maiores quo eos. Velit mollitia alias recusandae velit.	45	2022-11-12 14:24:12
161	70	Service Warna Km Kendaraan Pajak Jual Nego Interior Bukan rental Mulus	365000000	In blanditiis eos aliquam et. Cum distinctio et repellat rem voluptatum. Corrupti iste adipisci quaerat sit tempore fugit.	84	2022-12-30 09:26:24
162	45	Cat Surat Baru Negotiable Kondisi Terjamin Cicilan Tangan Bukan rental	110000000	Cupiditate ex blanditiis possimus beatae. Beatae deserunt suscipit. Natus dolorem modi velit optio aut.	35	2023-01-28 06:16:14
163	4	Negotiable Dokumen Terawat Service Ban Langsung Pajak Cash Jarang	325000000	Deleniti perspiciatis dignissimos sunt. A consectetur odio numquam.	34	2023-01-24 17:54:07
164	96	Terjamin Interior Jarak Pribadi Kondisi Pakai Negotiable	185000000	Quidem repellendus recusandae dolore a error. Eligendi sit alias laudantium. Consequuntur vero vel deserunt excepturi.	86	2022-10-10 08:59:28
165	299	Cicilan Jual Cash Nopol Mobil Nego Full Bukan rental	199000000	Ex aliquid laborum corrupti odit quis. Amet provident illum beatae.	38	2023-02-10 06:05:12
166	168	Kendaraan Bukan rental Terawat Interior Jarang Murah Velg	100000000	Quod ullam dolore deleniti. Tenetur adipisci consectetur tenetur ipsa expedita. In inventore quibusdam et commodi.	39	2023-03-23 11:43:50
167	185	Cicilan Mesin Pemakaian Oli Kredit Surat Kondisi Dokumen	147500000	Asperiores dolorum sequi quas ullam dignissimos dolores. Animi facilis placeat occaecati voluptates ut.	11	2023-02-27 01:32:45
168	125	Bekas Velg Kondisi Baru Jarang Pemakaian Tahun Full	463000000	Beatae quo vero ipsam ea. At aliquid commodi enim. Nemo perferendis cumque saepe deserunt beatae.	41	2023-05-18 21:39:56
169	393	Velg Tahun Siap Cicilan Jarang	5800000000	Doloribus commodi quisquam totam laboriosam. Voluptates iste quis rem molestiae saepe. Eos debitis sint incidunt. A eaque consectetur laudantium eum distinctio voluptatibus.	36	2023-03-16 19:31:34
170	339	Langsung Cicilan Dp Cash Warna Bekas Stnk Pakai	1295000000	Dolorum odit maxime asperiores dolorum voluptatum.	99	2023-02-11 07:47:31
171	74	Stnk Tangan Surat Jual Velg Jarak Kilometer Mulus Eksterior	190000000	Assumenda corporis vel. Ex quia deleniti asperiores.	16	2022-11-28 00:10:53
172	339	Surat Negotiable Terjamin Jarak Siap Oli	220000000	Corporis dolor veritatis eos veritatis tempora ut a. Sapiente nam non. Optio cumque animi ullam aliquid quos.	19	2023-02-05 03:59:38
173	198	Tahun Dp Kondisi Pemakaian Pajak Km	212500000	Veritatis nemo accusamus dolore. Reprehenderit nemo deserunt vero.	173	2023-01-07 16:24:49
174	103	Bekas Cash Murah Nego Pajak Berkualitas Terawat	197000000	Saepe pariatur ad rem accusamus eaque alias odit. Dolores placeat reprehenderit temporibus eius quas.	161	2023-02-07 03:15:08
175	19	Full Kondisi Kendaraan Jarak Dp Ban Jarang Harga	120000000	Voluptate dolor praesentium laboriosam facere deleniti reprehenderit est. Perspiciatis natus laborum pariatur officiis eveniet officia. Praesentium accusamus enim neque in accusamus culpa.	73	2023-05-31 01:46:15
176	171	Berkualitas Terawat Jarang Kredit Pajak	470000000	Esse sit optio. Facere minima quibusdam eum vitae similique voluptate.	84	2023-03-07 07:12:13
177	95	Cat Interior Terjamin Jarang Kondisi Km Kredit Pajak Cicilan	600000000	Sit tenetur voluptatem asperiores cumque. Velit at corrupti sit.	29	2022-10-11 09:16:36
178	286	Interior Tahun Jual Kredit Kendaraan Berkualitas	1295000000	Natus dignissimos ullam quasi voluptas ea consectetur blanditiis. Magnam velit voluptatem voluptatum veniam suscipit iste. Nobis commodi beatae itaque.	99	2022-11-29 23:31:53
179	205	Kondisi Warna Service Oli Kilometer Pajak Interior Full	135000000	Tenetur voluptate dolores commodi. Quas quasi error ratione provident. Quaerat illo exercitationem saepe.	58	2022-09-05 02:12:10
180	255	Nopol Dokumen Bekas Cash Mobil Harga	1700000000	Corporis necessitatibus molestiae ipsam molestias neque. Labore iusto eius.	40	2023-03-11 17:16:36
181	196	Full Pajak Mobil Eksterior Asli Jarang	1100000000	Non aspernatur blanditiis cumque veniam reiciendis. Numquam numquam reprehenderit sequi est nam vel. Occaecati debitis excepturi.	151	2023-07-07 03:20:55
182	339	Kendaraan Velg Full Stnk Dokumen Pajak Pemakaian Km Kredit Tangan	230000000	Cum nesciunt at odit culpa quod enim enim. Autem consequuntur sunt.	66	2023-04-25 02:58:15
183	360	Kendaraan Surat Cicilan Pemakaian Murah Original Negotiable Velg Km	130000000	Non dolorem suscipit labore.	25	2023-03-07 01:39:18
184	253	Murah Surat Eksterior Pakai Harga	130000000	Quis asperiores repudiandae adipisci perspiciatis sit provident. Dolor iusto eaque quaerat.	25	2022-11-11 03:43:50
185	1	Eksterior Cicilan Nopol Asli Harga Cash Jarak Stnk	463000000	Molestias impedit officiis qui ipsa omnis. Nihil blanditiis quo perspiciatis sint saepe ipsa. Adipisci vel optio sunt. Ipsa repellat debitis suscipit animi nobis accusantium.	62	2023-02-05 20:23:13
186	124	Murah Warna Kredit Dokumen Bekas Siap	254000000	Veritatis aut odio aliquid tenetur. Quod ullam voluptatibus dolor.	109	2023-03-24 17:30:17
265	359	Original Bekas Bukan rental Dp Dokumen	212500000	Esse corrupti cum id.	103	2023-04-17 12:10:31
187	176	Tangan Terawat Kredit Jarak Tahun Ban Negotiable Service Dokumen Nego	1450000000	Veniam corporis enim asperiores amet aspernatur. Cum dolor distinctio adipisci. Quos sapiente eligendi quis debitis mollitia.	194	2023-01-02 02:21:50
188	337	Negotiable Terjamin Baru Oli Pajak Murah Terawat Stnk	146000000	Sequi cupiditate quibusdam exercitationem laboriosam. Repellendus exercitationem laudantium culpa.	173	2022-10-23 00:59:19
189	229	Dokumen Nego Original Tangan Kilometer	125000000	Commodi animi expedita animi. Nisi mollitia autem accusamus.	193	2023-03-07 15:22:50
190	309	Harga Km Terawat Pakai Interior Jarak Service Oli Terjamin Nego	120000000	Eaque animi aspernatur repellendus dolore tempore impedit. Tempora quisquam reiciendis modi voluptatum reiciendis officiis accusantium. Dolorum amet ratione consequuntur velit. Tempore ad repudiandae ipsam velit aperiam inventore.	88	2022-12-22 17:15:02
191	104	Km Kilometer Pemakaian Pribadi Jarak Terjamin Bukan rental Kendaraan	230000000	Fugiat omnis eius eum ipsam sint ut. Expedita aspernatur modi magnam.	55	2022-12-18 04:45:52
192	302	Kendaraan Dp Eksterior Surat Berkualitas Oli Mulus Cat Pemakaian Siap	125000000	At distinctio ut at unde. Repellendus sint sit minus rerum tenetur.	183	2023-06-13 16:08:11
193	161	Kendaraan Surat Service Velg Full Pribadi Baru Siap	180000000	Veritatis quia cupiditate ad fugiat sequi. Omnis incidunt quod assumenda. Ipsa dignissimos esse animi voluptatem assumenda.	66	2022-12-30 22:16:49
194	358	Km Dokumen Bukan rental Jarang Mulus Harga Jual Murah	1295000000	Omnis cum culpa culpa ut nam iste. Fugit voluptate nam placeat doloremque quibusdam.	99	2023-04-11 03:25:12
195	361	Pajak Velg Dokumen Pakai Interior Negotiable Mobil	440000000	Maxime veniam natus voluptates quae. Repudiandae autem veniam culpa ipsam voluptatem. Fugiat laudantium magni at at.	21	2023-06-14 18:58:06
196	374	Pemakaian Eksterior Harga Km Cat	2750000000	Quod qui atque laboriosam id deleniti iste dolor. Deleniti laboriosam quas sint voluptatibus velit.	190	2023-01-31 16:45:34
197	368	Stnk Tangan Nopol Km Kondisi	135000000	Officiis dolorem odio sequi eos. Quam qui ducimus consectetur dolorem quo nam.	113	2022-11-23 01:49:44
198	112	Surat Warna Pajak Oli Jual Tahun	450000000	Pariatur optio dignissimos cumque. Necessitatibus repellat sed. Excepturi odit placeat debitis nulla.	29	2023-02-06 05:04:22
199	208	Original Jual Terjamin Pribadi Full Eksterior Warna Nopol Kilometer Interior	910000000	Nesciunt aliquam suscipit officia aperiam laudantium. Consequuntur tenetur excepturi et. Illo quasi voluptatem aliquid natus.	129	2023-03-28 22:18:12
200	114	Mesin Jarak Oli Bukan rental Cash Langsung Kendaraan Dokumen Terjamin Terawat	147500000	Corrupti nesciunt minus inventore eius fugit. Id quis laudantium illo sed. Excepturi labore a quibusdam enim dolorum iste.	85	2023-04-13 13:36:35
201	384	Kredit Cicilan Asli Surat Siap Murah Stnk Terawat Mesin Dokumen	130000000	Id aut unde facilis provident. Atque inventore iste dolorum earum voluptatum culpa modi.	80	2023-02-15 13:34:53
202	240	Interior Cat Berkualitas Harga Pakai Km Cash Dokumen	245000000	Eum culpa ab placeat repellat. Sint possimus a aperiam ullam vel dicta. Repellat quam cumque ad. Autem sunt sit.	189	2022-09-29 06:17:50
203	315	Mesin Surat Interior Asli Oli Bukan rental Negotiable Warna	139000000	Reprehenderit vero quos consequatur neque quas recusandae. Quia quas ab enim ex ratione tempore amet.	82	2023-02-21 09:33:45
204	369	Kilometer Nopol Surat Langsung Mobil Cat Tahun Terjamin Pajak	325000000	Cum in occaecati. Ipsa quas necessitatibus perferendis corrupti cum.	136	2023-01-31 05:37:44
205	262	Baru Kilometer Pakai Murah Original Langsung Pemakaian	590000000	Rerum facilis ut aliquid officia id. Dignissimos vitae officiis dolorem dignissimos.	97	2023-06-22 05:39:22
206	23	Stnk Bekas Velg Warna Mobil Pemakaian Oli Langsung Dp Bukan rental	850000000	Eum eligendi deleniti suscipit enim distinctio dolor. Fugiat exercitationem ex excepturi.	120	2023-04-20 12:44:13
207	37	Surat Oli Tangan Nego Ban	470000000	Totam dolorem sit omnis.	148	2023-08-08 08:43:36
208	150	Ban Eksterior Pakai Jarang Jarak Kredit Mulus Langsung	159000000	Adipisci quasi ipsa aut. Magni dolore laborum ea molestias placeat recusandae illum.	1	2023-01-22 02:06:19
209	249	Murah Pemakaian Nego Asli Surat Pajak Full Tahun Kilometer	154000000	Laboriosam assumenda minima. Corrupti magnam maxime dicta.	28	2023-03-17 13:19:49
210	65	Pribadi Velg Warna Pajak Terawat Dokumen Tangan	230000000	Quam reprehenderit voluptatem alias iusto incidunt. Sed dolor in debitis voluptatum autem magni occaecati. Est quia aspernatur ipsum nisi a.	200	2023-04-07 13:13:48
211	179	Stnk Mulus Negotiable Velg Cicilan Dokumen Tangan Bekas	1650000000	Nesciunt eos facere voluptates accusamus quidem. Ipsam veniam nihil minima itaque.	138	2023-01-09 06:03:59
212	226	Tahun Cash Pribadi Kondisi Original Mobil	199000000	Reiciendis pariatur iste repellat fuga fugiat. Inventore dolorem ab repellat. Id eligendi omnis accusamus.	104	2023-02-18 00:23:24
213	252	Harga Cicilan Nopol Negotiable Jarak Mulus Berkualitas Asli Jual Nego	355000000	Nobis quas veniam quidem. Nam vel quisquam placeat. Necessitatibus vitae nobis corrupti laboriosam rem accusamus. Itaque ab libero reprehenderit vel accusamus.	147	2023-05-06 00:36:04
214	283	Bukan rental Km Murah Siap Langsung Pemakaian Cash Berkualitas Tahun Warna	860000000	Deserunt consequuntur officiis quo iste. Quo corporis molestias magni.	68	2022-12-06 19:15:44
215	143	Mulus Nopol Terjamin Cicilan Jarak	398000000	Cupiditate illo fugit vero. Impedit ratione magnam ab. Rem suscipit nemo doloremque similique molestiae tempora.	156	2023-01-03 05:35:39
216	205	Murah Pakai Dp Negotiable Berkualitas Full Baru Jual Pribadi Surat	147500000	Vel in inventore eum quibusdam corrupti sint fuga. Praesentium quaerat vel eaque perspiciatis cupiditate numquam provident. Veritatis soluta facere.	187	2023-04-03 11:13:26
217	316	Kilometer Nego Mobil Pemakaian Ban Oli Mesin Interior Terawat Dp	975000000	Officiis fugit beatae suscipit et. Dolorum repellendus quaerat possimus.	93	2022-12-30 12:58:50
218	252	Oli Stnk Pajak Eksterior Mobil Tahun Pribadi	1750000000	Voluptas dolore consequatur tempora rem quasi ad.	145	2022-10-09 05:57:42
219	167	Terawat Kredit Jual Pakai Warna Interior Service Original	440000000	Velit odio nesciunt non modi ut ullam. Natus minus nihil. Illum doloribus mollitia sunt saepe eius.	34	2022-11-27 04:01:05
220	134	Eksterior Service Tangan Pakai Velg	130000000	Molestias blanditiis repellendus reiciendis ipsam. Minima excepturi earum quidem rerum rem dolorum. Et est repudiandae similique dolor voluptatibus. Ipsa recusandae tempora iure.	82	2022-12-14 15:03:36
221	119	Baru Jarang Interior Jarak Asli Cicilan	200000000	Eum dolorum nemo. Accusantium magnam asperiores beatae et.	44	2023-01-06 16:33:27
222	395	Eksterior Surat Jarang Jual Mulus Pakai Baru Nopol Cat Kendaraan	440000000	Voluptatum rem ipsum occaecati. In voluptatibus eum veritatis. Atque a quo maxime nostrum nesciunt nulla occaecati.	136	2022-08-27 01:56:12
223	175	Km Pakai Terawat Tahun Terjamin Service Murah Warna Negotiable Siap	850000000	Incidunt expedita fuga laboriosam debitis corrupti vitae. Molestiae deleniti incidunt dolorem tenetur culpa ex. Ea enim animi deleniti.	119	2023-04-23 09:52:38
224	81	Mulus Mobil Pribadi Velg Tangan Berkualitas Ban	167000000	Ab esse nemo mollitia inventore culpa odio pariatur. Et ea tempora consequatur maxime esse.	126	2023-04-10 14:49:41
225	33	Cash Siap Nopol Murah Mobil Cicilan Full	146000000	Consectetur iure neque veniam vel. Error eos veritatis alias maxime tempora repudiandae. Laudantium aut repellendus nobis temporibus inventore explicabo.	46	2022-11-19 08:45:05
226	238	Negotiable Harga Kendaraan Kondisi Dokumen Velg Mulus Jual Warna Cicilan	230000000	Nostrum itaque doloremque architecto accusantium dolorum quia. Quis dolore quasi. Praesentium enim asperiores.	66	2022-11-14 14:19:00
227	161	Stnk Bekas Kilometer Eksterior Berkualitas Pakai Nopol Baru Negotiable	125000000	Beatae vel nesciunt facere commodi. Assumenda voluptatibus earum libero laboriosam alias vel tenetur.	131	2023-04-15 10:23:06
228	294	Jarang Mulus Asli Baru Nego Cicilan Ban Kondisi	600000000	Quam quibusdam error veniam veritatis. Animi dolore molestias possimus similique.	3	2023-03-17 11:50:51
229	79	Kendaraan Bukan rental Kredit Pemakaian Bekas Murah	679000000	Odit nihil quod repudiandae. Architecto iusto earum alias.	141	2023-05-01 04:19:57
230	20	Pribadi Oli Negotiable Kredit Cash Service Ban Mulus Surat Harga	2575000000	Sit maiores quidem porro provident perferendis earum. Esse nisi ab ducimus doloribus mollitia. Iure inventore ab sequi aspernatur eum officia.	142	2023-02-12 04:35:47
231	400	Km Pakai Service Nego Eksterior	215000000	Recusandae alias magnam dolores. Optio culpa inventore perferendis dolorum suscipit recusandae. Beatae molestiae quibusdam aliquid.	35	2023-01-12 00:32:23
232	316	Service Mesin Cash Pemakaian Bukan rental Pajak Baru Langsung Terjamin Stnk	440000000	Rerum provident reiciendis quibusdam beatae cum. Eaque ex eveniet quae.	34	2023-04-30 15:42:00
233	309	Dp Kendaraan Pribadi Ban Terawat Murah Kredit	679000000	Odit asperiores nobis ipsa temporibus. Odio asperiores totam numquam illum exercitationem.	180	2023-03-26 15:54:12
234	347	Dokumen Nopol Mesin Baru Harga Bukan rental Cicilan	470000000	Impedit id at numquam necessitatibus. Enim placeat fugiat.	148	2023-03-06 09:36:30
235	373	Cash Berkualitas Pemakaian Baru Surat	135000000	Eos architecto at quae quibusdam. Qui eum doloribus consequuntur occaecati corporis pariatur. Asperiores tenetur ducimus.	23	2023-06-03 03:34:37
236	156	Pemakaian Terjamin Stnk Cash Warna Ban Pakai Nopol Cat	159000000	Voluptatem nemo mollitia. Laudantium placeat magnam corporis temporibus laboriosam amet officia. Autem minus quo. Iste ea amet reiciendis ratione.	47	2023-02-22 08:14:15
237	294	Service Murah Jarang Velg Dp Cicilan Pajak Berkualitas	1700000000	Quam ratione et inventore quasi dignissimos. Officia tempora debitis occaecati reprehenderit cupiditate. Odit tenetur sed aut iure asperiores.	149	2022-11-25 18:50:45
238	269	Kendaraan Kondisi Terjamin Bekas Pemakaian Terawat Nopol Stnk	100000000	Fugit molestiae odit facilis facere.	8	2022-11-23 12:05:45
239	84	Kilometer Kondisi Pribadi Cicilan Ban Interior Surat Oli Jual Cash	1350000000	Delectus deserunt error harum repudiandae. Optio accusamus magnam.	145	2023-07-24 16:19:02
240	227	Mesin Dokumen Harga Kendaraan Kondisi Warna	398000000	Cum fuga illum voluptate. Dolores soluta dicta doloremque.	159	2023-02-28 11:19:42
241	17	Terawat Terjamin Pakai Jual Jarak Baru	195000000	Quo placeat quisquam. Aliquam animi dignissimos.	31	2023-01-09 14:15:19
242	37	Km Ban Kredit Pakai Murah	2750000000	A optio ducimus facilis ratione. Nulla sint reiciendis eos nemo.	19	2022-12-22 03:18:05
243	139	Nopol Mesin Terawat Full Oli Kredit Ban Original Bekas	775000000	A soluta officiis eaque similique illo beatae. Reiciendis architecto consequuntur quia vitae itaque.	141	2023-01-07 05:38:59
244	24	Nego Kendaraan Interior Kilometer Mulus Negotiable	775000000	Recusandae enim velit eum. Porro cupiditate soluta officia. Perspiciatis eius quaerat tenetur pariatur eos.	141	2023-06-12 17:43:19
245	330	Berkualitas Baru Km Cash Interior Kendaraan Original	135000000	Saepe dolorum beatae commodi hic inventore. Fuga nostrum neque alias deserunt. Saepe nisi vitae eius eum distinctio deserunt.	57	2023-03-06 00:44:00
246	133	Bekas Dp Kredit Terawat Pemakaian Pajak	230000000	Enim veritatis totam fugiat quis alias consequatur.	20	2022-10-05 09:46:40
247	133	Siap Bekas Jarang Eksterior Jual Cicilan Interior Terjamin Harga Kondisi	212500000	Consequatur minus rerum illum dolores veniam. Quaerat reprehenderit quasi debitis distinctio tenetur.	168	2022-11-02 19:38:35
248	226	Jual Velg Warna Mulus Murah Jarak Dp Full	120000000	Repellendus reiciendis natus quisquam deserunt soluta deleniti. Laborum voluptatem consequuntur eaque quisquam vel. Dolorum quasi voluptatibus dolore iure.	101	2023-04-11 12:17:53
249	280	Kredit Cicilan Surat Terjamin Bukan rental Siap	220000000	Fugit numquam possimus labore. Facilis sequi eius harum saepe dolore. Laudantium illo laboriosam veritatis iusto.	174	2022-12-16 19:08:52
250	59	Berkualitas Mulus Kondisi Terjamin Harga Cicilan Service Pakai	230000000	Voluptatibus nihil praesentium placeat asperiores. Voluptate itaque nobis necessitatibus debitis suscipit quae.	33	2023-05-09 01:25:02
251	72	Berkualitas Terjamin Kilometer Service Nego Stnk	150000000	Eum a quaerat exercitationem vero ullam debitis saepe. Voluptatibus doloribus impedit voluptatibus hic. Earum deserunt excepturi expedita.	111	2023-02-03 10:57:37
252	166	Stnk Warna Tahun Berkualitas Eksterior Pribadi	1700000000	Necessitatibus tenetur ratione accusamus cupiditate vero eaque. Cupiditate quas ipsa.	110	2023-01-04 22:05:34
253	204	Km Mobil Original Kredit Interior Asli	500000000	Laudantium ratione cumque excepturi veniam dolores.	90	2023-06-08 13:24:49
254	225	Berkualitas Langsung Ban Kondisi Nopol Terawat Service	1845000000	Voluptate sed iusto dicta voluptatem. Earum optio iste eius earum. Porro quaerat qui.	194	2023-01-28 10:32:24
255	56	Negotiable Jarak Tangan Ban Stnk Dp	300000000	Sunt quasi veniam dolorum. Nemo expedita voluptas veniam.	114	2023-07-12 14:04:20
256	354	Surat Pakai Dokumen Kredit Tahun Mulus Siap Eksterior	95000	Magnam deserunt natus alias pariatur. Officia officia voluptatem perferendis debitis expedita dolores dolor.	49	2023-04-16 15:52:36
257	171	Kondisi Berkualitas Nego Eksterior Terjamin Stnk	254000000	Quisquam ad dolor saepe ex nobis praesentium. Unde laboriosam et quisquam excepturi totam corporis. Illum quod explicabo doloremque sequi mollitia sapiente expedita.	196	2023-05-29 22:46:22
258	251	Mobil Baru Terjamin Cat Pajak Surat Pribadi Kendaraan	200000000	Suscipit eum blanditiis eum provident. Sapiente voluptates tenetur nobis ratione.	44	2022-10-29 20:39:00
259	297	Full Mesin Jual Kredit Siap Asli Berkualitas Km Kondisi	225000000	Error consequuntur voluptatum quos quis voluptate repudiandae exercitationem. Laboriosam pariatur sed. Nobis similique vitae cum ipsam.	44	2023-07-01 21:59:11
260	242	Mobil Velg Asli Tahun Jual	100000000	Cumque esse fugit eius. Accusantium atque sit officia assumenda eum.	118	2023-03-15 02:44:57
261	202	Nopol Mobil Jarang Nego Oli Berkualitas Dp Siap Interior Cat	5800000000	Facilis illo doloribus minus aperiam fuga perspiciatis. Unde ab nisi. Maiores ipsam amet pariatur magni earum exercitationem.	177	2023-03-02 20:47:42
262	280	Full Eksterior Stnk Pribadi Langsung	300000000	Quas optio libero iusto. Omnis possimus saepe assumenda magnam.	153	2023-03-01 14:07:35
263	203	Interior Jarak Pajak Kondisi Ban Murah Pribadi Full Nego Bekas	181000000	Omnis cumque fugiat nulla dolorum. Facilis rerum dolor excepturi.	143	2023-06-28 07:35:43
266	160	Langsung Siap Berkualitas Velg Terjamin Ban	130000000	Natus ea sed suscipit exercitationem dolor. Dolores iste debitis eos necessitatibus unde.	80	2023-01-27 04:11:33
267	215	Mulus Interior Kendaraan Pribadi Oli Berkualitas	159000000	Atque doloribus deserunt. Non officia corrupti nobis iusto quam.	118	2023-04-21 04:17:08
268	160	Cat Bukan rental Jual Siap Murah Kendaraan Interior	1500000000	Modi hic est adipisci. Delectus numquam iusto dolor magnam.	154	2022-12-22 01:40:25
269	268	Cat Km Baru Pribadi Surat Pajak Service Dp Velg	215000000	Aspernatur beatae velit. Provident quis error. Laudantium dolores asperiores eligendi dolores corrupti aspernatur.	121	2023-01-01 03:18:11
270	28	Langsung Jarak Nopol Tahun Berkualitas Surat Warna Terawat	199000000	Ad similique fugit labore. Repellendus voluptate ipsa molestiae quis eveniet. Fugit rem quos.	86	2022-12-11 16:17:18
271	39	Bekas Siap Oli Dp Full Tahun Cat Langsung Jarang Eksterior	1980000000	Pariatur placeat quod expedita laboriosam vitae odit. Modi corrupti voluptatem aliquam. Temporibus praesentium facere sunt quisquam odit voluptatum.	67	2023-03-29 03:18:48
272	66	Kilometer Tangan Mulus Ban Siap Pakai Eksterior	600000000	Quo et voluptate. Sint fuga consequuntur iure.	140	2023-01-02 18:33:19
273	322	Tahun Pajak Kendaraan Terjamin Dokumen	245000000	Quo minima excepturi itaque qui libero. Recusandae officiis aspernatur similique unde magni architecto.	136	2022-10-11 06:31:20
274	7	Service Cash Jarang Kendaraan Mulus Terawat Pemakaian Berkualitas	146000000	Tenetur eaque voluptatem incidunt. Recusandae quo illum maiores suscipit officiis. Consequatur temporibus repudiandae culpa vero facilis.	143	2023-01-06 21:00:29
275	386	Stnk Tahun Bekas Pribadi Murah Tangan Kendaraan Nopol	1745000000	Corrupti perferendis accusantium enim. Omnis et cupiditate necessitatibus vero est. Voluptates magnam dolor voluptatibus.	32	2023-05-10 19:31:01
276	136	Bekas Oli Pribadi Jarang Cash Stnk Jual Dokumen Eksterior Nopol	155000000	Quisquam magnam velit consequatur expedita distinctio provident. Deserunt illo officiis veritatis dolor eaque. Iusto reiciendis cum sunt dolores.	113	2022-12-13 17:47:30
277	358	Jarang Mobil Mesin Kilometer Bukan rental Mulus	167000000	Totam corrupti sequi odio error. Voluptatum aperiam ullam nihil impedit quidem sint.	73	2023-03-11 11:04:05
278	144	Jarang Dp Interior Murah Nopol Surat	159000000	Harum amet culpa. Nisi ex ea. Reprehenderit in ea iusto dignissimos.	43	2023-06-30 19:52:24
279	277	Eksterior Nego Pakai Jarang Surat Pemakaian Ban Cicilan Asli	485000000	Minus ab nisi beatae neque. Laudantium voluptas tenetur eius.	75	2022-11-09 10:03:48
280	336	Terjamin Ban Pemakaian Bukan rental Kilometer Mulus Tangan	260000000	Nisi laudantium fuga dicta vel adipisci. Incidunt molestiae iusto asperiores saepe quos repellat.	200	2022-12-22 18:33:51
281	300	Eksterior Interior Langsung Warna Mesin Pemakaian	899000000	Ipsam doloribus illo fugit similique quibusdam. Earum nobis vero nobis repudiandae dolorem.	164	2023-03-22 06:47:00
282	296	Tangan Warna Nopol Km Pribadi	899000000	Dicta accusamus porro saepe. Aut nisi accusamus iure.	67	2023-03-29 04:43:23
283	332	Kendaraan Pakai Kredit Jarang Murah Pribadi Km Jarak Oli	895000000	Possimus maxime distinctio sint aut.	76	2023-04-24 02:30:41
284	297	Oli Cat Eksterior Interior Mulus Pemakaian Kondisi	1100000000	Est ad natus voluptatem commodi debitis. Sint cumque rem dolor placeat.	119	2022-12-03 12:44:54
285	39	Baru Km Mesin Mulus Negotiable	139000000	Cum ab perspiciatis tenetur ut tenetur. Similique soluta ea aut blanditiis.	82	2022-11-19 16:19:22
286	218	Full Kilometer Cash Harga Terawat Dokumen Dp Warna	800000000	Ipsam sit inventore cumque asperiores beatae libero libero. Deserunt rerum repellat qui.	65	2023-01-16 15:08:25
287	221	Mulus Service Stnk Bukan rental Pakai Pajak Asli	645000000	Quod ducimus voluptatum repellendus rem optio.	179	2023-03-11 06:24:06
288	67	Service Interior Terjamin Nego Cat Tangan Cash Kredit	220000000	Incidunt aspernatur ipsum sed dolorem deleniti. Minus qui minus dolorem. Nostrum consectetur aliquid corporis quia magnam id corrupti.	147	2022-11-15 17:10:18
289	21	Dokumen Eksterior Tangan Nego Nopol Jarak Bukan rental Tahun Ban	463000000	Ad reiciendis quasi itaque. Itaque animi molestiae consequuntur molestiae minus non recusandae.	41	2023-01-13 23:15:32
290	192	Cicilan Cash Kredit Jual Negotiable	470000000	Nihil quasi mollitia soluta. Omnis numquam placeat repellat.	159	2023-03-30 09:12:51
291	300	Surat Kredit Asli Dp Kilometer Mulus Warna	375000000	Dolor cumque ratione incidunt tempore dicta fugit. Quae nemo necessitatibus alias perspiciatis occaecati a.	192	2023-04-15 02:02:58
292	222	Cat Baru Siap Langsung Km Jarang Ban	4650000000	Voluptate expedita hic libero. Tempora pariatur nisi quod. Dolore quia itaque id. Debitis soluta perferendis voluptates nostrum blanditiis occaecati.	36	2023-04-26 05:19:45
293	295	Warna Interior Ban Tangan Nopol	1500000000	Ab dolorem optio quis. Debitis aperiam at neque dolorem magnam eligendi. Nam dicta illum tempora rerum officiis eos modi.	60	2023-01-29 15:35:03
294	388	Eksterior Jarang Cicilan Terjamin Bekas Kredit Murah Mulus Oli Velg	450000000	Voluptatibus repudiandae tempore nulla voluptatem. Facere quis mollitia voluptates. Labore similique blanditiis vero soluta.	5	2022-10-16 10:14:29
295	216	Jarak Pemakaian Dokumen Berkualitas Pajak Tangan Ban Kilometer Negotiable Cicilan	127000000	Quidem illum neque ipsum sint. Rerum rem libero aspernatur.	135	2023-05-23 17:18:17
296	289	Kilometer Cash Oli Nego Jual Harga Dp Pemakaian Terawat	159000000	Laborum quos laboriosam earum. Ad totam aspernatur animi velit hic.	165	2023-05-14 21:41:55
297	3	Dokumen Asli Km Pakai Pemakaian Harga Berkualitas Original	220000000	Ipsam eaque aut nisi hic eligendi voluptatum. Dolore ab quae veritatis.	147	2023-02-03 09:00:39
298	354	Terjamin Asli Cash Interior Pajak	139000000	Veniam illum excepturi. Perspiciatis dolores illo.	82	2023-01-21 20:21:41
299	14	Jual Kondisi Ban Bukan rental Mulus	355000000	Blanditiis minus corrupti. Modi enim quia minus quasi veritatis.	147	2023-03-27 16:36:14
300	94	Pakai Pajak Terjamin Nego Full Mulus Ban Kilometer Eksterior	1500000000	Autem commodi vitae voluptatibus similique. Iusto et repudiandae officia esse. Ducimus a rerum nesciunt asperiores quisquam nam libero.	60	2022-10-22 02:53:11
301	102	Original Warna Murah Surat Kendaraan Cat Stnk Pakai	125000000	In quae esse et natus. Quae odio eaque quaerat dolor voluptas.	113	2023-01-12 17:05:02
302	208	Berkualitas Nopol Warna Ban Asli	850000000	Repellendus fuga eveniet quia explicabo optio quas tenetur. Dignissimos tempore repellat porro. Aliquam deserunt itaque unde harum distinctio mollitia.	119	2023-07-17 05:11:35
303	129	Eksterior Jarak Terawat Tangan Bukan rental Kondisi Jarang Surat Pajak Ban	545000000	Sed recusandae veritatis tempore officiis.	76	2022-12-16 09:46:11
304	293	Stnk Warna Tahun Pajak Berkualitas Dokumen Siap Pribadi Full	215000000	Laudantium facilis incidunt. Alias doloremque eum animi dignissimos.	56	2023-01-05 07:36:06
305	105	Mesin Kredit Full Asli Eksterior Jarak	260000000	Commodi odio quisquam rerum corrupti deleniti blanditiis dicta. Minus dolorem facilis ratione doloribus minima. Impedit omnis rerum doloremque laudantium odio.	200	2023-07-01 03:39:47
306	259	Stnk Cash Pemakaian Bukan rental Pakai Original Pajak	123000000	Sint pariatur quos vel iure assumenda similique. Necessitatibus quidem suscipit ullam dolor pariatur.	43	2022-12-17 18:43:21
307	293	Pajak Original Cash Jarang Mulus Berkualitas Pemakaian Pakai	135000000	Illum incidunt quis rem. Quae nulla ut expedita deleniti excepturi minima. Hic commodi laboriosam.	122	2023-01-01 23:22:59
308	385	Surat Full Negotiable Dp Terjamin Pajak Jual Interior Oli	123000000	Error totam ad repellendus consequatur nesciunt placeat provident. Explicabo eius cumque distinctio provident deserunt.	165	2023-03-02 20:01:59
309	311	Jarang Stnk Cash Cicilan Tahun Velg	1845000000	Minus ipsa optio illum aliquid reiciendis iure. Assumenda exercitationem ad consectetur enim beatae.	45	2023-03-19 16:50:22
310	285	Negotiable Siap Berkualitas Murah Jual Dp Ban Oli Full	325000000	Repellat tempora hic neque neque assumenda. Soluta eaque facilis ipsa autem. Deserunt eius quibusdam reprehenderit facere voluptatem.	34	2023-03-18 19:19:02
311	27	Negotiable Kondisi Terawat Full Jarang Kendaraan	1075000000	Odio voluptatum repudiandae ducimus maxime.	138	2022-11-28 02:22:07
312	334	Pakai Negotiable Kondisi Pajak Interior Siap Baru Mobil Km	110000000	Quidem ducimus provident vel. Incidunt facilis voluptatum ratione in.	11	2023-05-01 17:12:40
313	362	Kilometer Tangan Bekas Surat Jual Ban Jarang Pajak Berkualitas Original	1450000000	Deserunt unde aliquam inventore. Quos fugit nobis praesentium corrupti.	45	2023-08-04 20:59:10
314	104	Service Kredit Jarang Ban Nopol Cat Bukan rental Eksterior Pemakaian	276000000	Asperiores facere odio reiciendis quas tempora. Eaque voluptatem quisquam dignissimos magni soluta.	98	2022-09-19 03:24:34
315	97	Surat Full Kondisi Siap Harga Mobil Cash Stnk Warna	297000000	Itaque consequatur eaque dolor. Inventore dicta accusamus quam eaque.	97	2023-04-05 12:50:59
316	12	Velg Cash Murah Service Oli Pakai Pemakaian	230000000	Velit facere reprehenderit fugit minus minima. Iste fuga odio delectus facere recusandae minima. Quae saepe alias quasi facere alias in.	200	2022-12-08 00:50:28
317	347	Berkualitas Negotiable Dokumen Interior Cat	123000000	Temporibus rem sapiente quod laboriosam excepturi. Cumque porro ratione esse libero ad. Tenetur optio excepturi.	118	2023-03-15 05:34:52
318	151	Langsung Cat Bekas Negotiable Pajak Asli Harga Terawat	350000000	Explicabo amet natus fugit. Doloribus ut omnis nam optio.	200	2023-03-23 12:10:48
319	106	Mesin Bekas Jarak Baru Original Nopol Terjamin Jual Asli	159000000	A alias vero. Aut praesentium delectus quam explicabo laudantium iure. Eveniet earum velit dignissimos vel.	118	2023-02-27 00:27:25
320	387	Original Dp Cat Warna Langsung Pribadi Bukan rental	225000000	Fugit rerum eius tempora possimus sint vero. Sunt tempore molestiae aliquam eum.	80	2022-09-15 19:14:07
321	27	Pemakaian Cicilan Surat Harga Oli Berkualitas Kredit Terjamin Negotiable Dokumen	550000000	Eligendi officiis rem incidunt.	75	2023-04-23 10:27:52
322	106	Mulus Surat Dokumen Jarang Ban Velg Original Service	1650000000	Ad vitae doloremque. Explicabo quos fugit beatae.	138	2022-11-17 09:09:10
323	297	Cash Km Siap Pemakaian Mulus Nego Kendaraan	245000000	Cupiditate reiciendis rem illo. Est earum repellat provident vitae voluptas quam. Cupiditate eveniet aperiam impedit laboriosam qui ipsa. Quos sapiente ratione odit fugiat aliquam praesentium.	106	2023-07-26 10:53:33
324	305	Bekas Nego Asli Eksterior Original Bukan rental Surat Warna Kondisi Negotiable	355000000	Numquam asperiores eos nesciunt eius. Delectus quia ex explicabo temporibus nostrum blanditiis tenetur. Aspernatur eius molestias dicta nihil amet voluptate.	190	2023-03-12 11:00:39
325	111	Mobil Pajak Tangan Stnk Berkualitas Interior Oli	180000000	Quibusdam ipsa error deserunt numquam.	66	2022-12-12 02:12:27
326	397	Km Cat Berkualitas Dokumen Kondisi Oli Negotiable	215000000	Beatae explicabo quibusdam. Magnam veritatis laborum quia alias nisi cupiditate rerum.	98	2023-02-21 02:36:50
327	132	Negotiable Baru Tahun Warna Tangan Ban	276000000	Hic culpa blanditiis ipsa doloribus eius. Necessitatibus eaque eligendi necessitatibus rem. Maxime mollitia perferendis enim mollitia.	102	2022-12-12 17:45:19
328	30	Original Km Full Berkualitas Terawat Terjamin Siap	850000000	Reiciendis commodi laboriosam assumenda ea ullam. Minima totam porro nulla eaque.	24	2023-06-25 15:55:17
329	325	Ban Mobil Bekas Kredit Baru	860000000	Accusamus ea dolorem occaecati officia voluptatum error excepturi.	68	2023-04-27 11:26:25
330	305	Bekas Tangan Pakai Dokumen Terjamin Oli Mesin Tahun Surat Warna	1500000000	Ex illum maiores totam. Dolorem blanditiis eum.	40	2023-03-27 20:14:47
331	186	Kondisi Warna Pajak Velg Service Interior Baru Mesin	120000000	Similique dolorem aspernatur dolorum sit voluptas. Perspiciatis adipisci in possimus fugit.	161	2023-01-08 17:37:40
332	347	Bekas Kendaraan Langsung Surat Pakai Cicilan Siap Jarang Nopol Interior	125000000	Consequatur repellendus exercitationem accusantium nemo necessitatibus. Amet maxime ipsam tempore excepturi blanditiis. Repellat minus nemo itaque vitae illum.	183	2023-07-20 19:40:11
333	284	Kredit Pakai Cat Terjamin Original Nopol Asli Kilometer	1745000000	Eaque reiciendis modi quisquam deserunt neque expedita. Ipsa excepturi cumque repellendus hic. Deserunt iusto tempora accusamus commodi.	128	2023-05-21 05:13:15
334	160	Nego Terjamin Jarak Kendaraan Cash Pakai	325000000	Aliquam blanditiis enim consequuntur.	136	2022-09-14 08:58:33
335	44	Pemakaian Kredit Bukan rental Berkualitas Nego Tahun	1700000000	Ea totam beatae beatae repudiandae reiciendis.	40	2022-12-12 15:46:51
336	40	Negotiable Dokumen Pajak Service Bukan rental Nopol Kilometer Pakai	245000000	Ullam sunt accusantium recusandae esse molestiae expedita. Quaerat eaque nemo blanditiis.	144	2023-01-06 21:39:53
337	339	Tangan Kredit Pemakaian Harga Tahun Mobil Dp Negotiable	485000000	Laborum numquam reprehenderit dolore. Veniam nostrum nemo fuga vero. Dolor similique atque dolorem consectetur ratione.	75	2023-05-10 17:55:52
338	334	Baru Tahun Mobil Tangan Jarak	230000000	Modi quidem culpa atque. Accusantium perferendis suscipit magni tempora.	102	2022-12-26 04:34:35
339	57	Surat Cicilan Baru Bekas Service Tangan Original	975000000	Nesciunt delectus autem id necessitatibus. Vitae magni iusto mollitia. Dolor nam ipsam corrupti.	6	2023-06-29 05:43:20
340	165	Stnk Surat Bukan rental Terjamin Langsung Bekas Cat Km	228000000	Vitae sapiente voluptatum illo laboriosam. Odio deleniti aperiam exercitationem optio animi unde.	196	2023-06-16 14:31:25
341	100	Kondisi Km Surat Jarak Bekas Negotiable Harga Pajak Oli Eksterior	285000000	Quam voluptatibus blanditiis quidem voluptate facilis assumenda. Veritatis modi laborum quisquam.	50	2023-05-21 08:27:37
342	364	Pakai Terjamin Cash Surat Mobil Murah Pajak Mesin Stnk Full	155000000	Impedit consequuntur labore expedita itaque placeat voluptatibus. Enim molestiae maiores necessitatibus at. Consequatur fuga accusamus pariatur. Animi unde numquam et atque quae soluta.	113	2023-02-20 14:26:38
343	27	Interior Dokumen Jual Warna Tahun Oli Surat Original Berkualitas	300000000	Consequuntur necessitatibus quasi tempora. Aperiam repudiandae explicabo officia expedita temporibus necessitatibus. Ut pariatur nostrum provident corporis quo nemo.	181	2022-09-03 06:14:10
344	135	Service Tahun Pemakaian Cicilan Nopol Interior Dp Pakai Harga	440000000	Enim est ut illo repudiandae placeat. Voluptatum vel eveniet similique nostrum rerum soluta. Perspiciatis culpa aperiam culpa hic odit quis.	136	2023-03-06 02:24:57
345	210	Warna Tangan Full Pajak Eksterior Nego Jarang	200000000	Quibusdam eos beatae odio libero. Dolorum eveniet voluptates sapiente rerum provident esse enim.	54	2023-04-27 10:01:46
346	377	Kondisi Jual Velg Dokumen Surat Bukan rental Oli	150000000	Incidunt laborum blanditiis facilis quas aliquam iusto. Sit maxime sed ab.	63	2023-04-23 06:10:51
347	268	Langsung Pribadi Cat Terjamin Dp Surat Mulus	123000000	Rerum explicabo culpa debitis molestias ea vero quas. Vitae error nisi quod minima magni nulla.	8	2023-06-17 05:58:37
348	30	Asli Kendaraan Nego Full Kondisi Bekas Oli Jarang Berkualitas	2750000000	Quae facere eveniet culpa non illum tenetur. Eveniet repellendus magni alias voluptates facere fugit eos.	147	2023-06-01 04:41:15
349	272	Service Kendaraan Interior Surat Original Pajak Tangan Kredit	245000000	Distinctio ea facere eum laborum accusamus. Ipsa dignissimos veniam ipsam recusandae laborum impedit.	30	2023-06-10 05:04:11
350	350	Langsung Baru Tahun Bekas Warna Velg Asli Cash Siap Dokumen	235000000	Molestiae repellendus saepe. Dolor nesciunt sunt vero.	89	2023-01-09 02:43:06
351	68	Stnk Murah Km Nopol Surat Jarang Dp	4650000000	Odit doloremque officia. Iusto ratione laudantium assumenda. Magni minus iusto molestiae.	150	2022-11-18 18:16:38
352	259	Terjamin Mesin Baru Pajak Original	445000000	Sequi tenetur quam quam nemo nisi facilis. Odio eum perspiciatis facilis ut natus. Molestias ea labore error tenetur officia.	97	2023-02-24 04:49:57
353	135	Cicilan Tahun Bekas Eksterior Langsung Service	180000000	Nesciunt reprehenderit ipsum natus amet. Amet consectetur iste accusantium.	31	2022-12-01 06:08:18
354	396	Murah Interior Cash Full Siap Tahun Velg Kondisi	254000000	Nesciunt modi rem. Delectus mollitia perferendis at. Modi laborum soluta est.	109	2023-02-05 08:32:38
355	311	Velg Full Tangan Pribadi Mesin Dp Cat Nopol Terawat	276000000	Ratione ut ipsa harum ipsum. Corporis libero qui quo blanditiis repudiandae tempora. Minus fugit aperiam nesciunt error nesciunt.	98	2022-12-18 03:20:31
356	327	Eksterior Service Bukan rental Kilometer Mulus	910000000	Voluptates consequuntur eius excepturi asperiores ratione in. Consequuntur impedit quod iure. Nisi facilis temporibus enim natus magni.	64	2022-10-13 14:39:06
357	346	Tangan Terjamin Pribadi Terawat Original Km Langsung Nego	130000000	Repellendus ratione magni illum sapiente omnis deserunt aspernatur. Velit eius odit sed nostrum in excepturi vitae.	17	2022-08-20 20:01:12
358	355	Bukan rental Tangan Pajak Cicilan Original	679000000	Eaque porro beatae adipisci odio molestias. Molestiae totam delectus placeat odio. Maxime eos placeat est.	133	2023-05-18 05:34:12
359	8	Jual Kredit Dp Surat Nego Velg Warna	975000000	Rem itaque suscipit laudantium ad minima eos. Eum magnam voluptatibus asperiores assumenda architecto.	93	2023-04-14 09:33:19
360	299	Mobil Jarak Nego Oli Dp Km Mesin Full Bekas	245000000	Sequi ipsam quae exercitationem et delectus eveniet aperiam. Deleniti impedit beatae ducimus. Qui magni quibusdam veritatis eaque suscipit aperiam.	21	2022-10-02 08:57:21
361	329	Murah Cicilan Mobil Interior Eksterior Pemakaian Nopol Mesin	210000000	Repellendus recusandae voluptatibus eligendi. Illum corporis aliquam labore. Aut animi eos eveniet ab illum aspernatur. Molestiae illo ipsa blanditiis officia ad autem.	106	2023-02-06 12:45:33
362	46	Kilometer Velg Jarak Negotiable Km Siap Dokumen Kredit	215000000	Repellat blanditiis numquam iusto ducimus sequi similique. Nihil veritatis harum nam assumenda hic id. Eaque incidunt fuga a eligendi.	35	2023-05-12 23:06:32
363	88	Cat Bukan rental Original Nego Tangan Baru Kilometer	245000000	Possimus amet esse suscipit accusantium sit necessitatibus mollitia. Rerum dolor cum sapiente deserunt occaecati tenetur. Excepturi est asperiores quod ipsa similique nulla. Vel odio id culpa deserunt nobis.	144	2022-11-21 02:35:46
364	12	Cat Surat Harga Velg Service Stnk Siap	320000000	Molestiae molestiae unde et. Sunt adipisci officiis consequatur dolor sit. Occaecati totam quasi corrupti earum.	192	2022-11-14 19:27:03
365	185	Km Pakai Mulus Original Nego	910000000	Perspiciatis velit corrupti hic sint. Consequatur saepe praesentium explicabo maxime eligendi natus. Odit temporibus harum minus.	120	2022-11-25 11:08:34
366	8	Velg Cat Pakai Siap Original Pemakaian Terjamin	120000000	Recusandae voluptate repudiandae mollitia error aspernatur distinctio. Aperiam minima tempora numquam nam tempore. Sunt repellat praesentium provident adipisci.	88	2023-03-07 04:35:59
367	270	Velg Kendaraan Cat Terawat Harga	260000000	Doloribus facere atque maxime eveniet iusto. Ipsum sunt dignissimos ipsum.	35	2023-03-17 00:09:36
368	162	Tahun Velg Warna Bekas Pemakaian Ban	1950000000	Omnis optio qui autem illo. Laborum quibusdam placeat alias illo neque. Modi nostrum modi nostrum.	107	2023-01-04 05:05:45
369	368	Mulus Mesin Pakai Pemakaian Kilometer Murah Langsung	1350000000	Perspiciatis numquam iste. Laborum porro ex sed doloribus quos nam. Occaecati nemo rem vero maiores.	95	2022-11-07 04:30:29
370	68	Mulus Full Mesin Langsung Negotiable Harga Tahun	100000000	Officiis autem aliquam voluptates itaque adipisci. Natus quisquam quidem. Debitis est tempora vero reprehenderit suscipit incidunt.	188	2023-01-16 16:35:04
371	320	Service Berkualitas Full Asli Surat Kredit	650000000	Amet alias tempore ratione occaecati inventore facilis. Ad excepturi corporis.	140	2023-03-22 14:22:21
372	22	Pajak Interior Velg Stnk Pribadi Terjamin Nego	146000000	Hic tempore libero nobis veritatis numquam.	168	2023-01-03 07:14:35
373	399	Harga Terjamin Cicilan Dp Warna Baru	230000000	Aut praesentium labore qui ipsum. Labore natus nulla tempora sed.	31	2023-06-27 20:34:43
374	173	Siap Kredit Negotiable Cat Bukan rental Stnk Dokumen Pribadi	975000000	Consequuntur ducimus quasi repellat dolorem ratione incidunt. Quis optio voluptatem architecto temporibus. Nulla inventore perferendis sunt ea. Repellendus molestias molestiae in deleniti ab molestiae.	138	2022-12-01 01:49:25
375	107	Original Pakai Kondisi Cicilan Asli Berkualitas Oli Kredit Cash Jarak	1745000000	Voluptatibus quo optio quaerat sit vitae labore. Officia reprehenderit dolorem in nulla. Molestiae repudiandae quam rerum amet excepturi.	4	2023-03-25 21:52:45
376	394	Warna Ban Negotiable Full Oli Jual Mobil Asli	1845000000	Dolor provident velit doloremque.	4	2023-01-02 21:53:46
377	239	Tangan Ban Kilometer Stnk Kondisi Murah Pemakaian Jarak Interior Baru	775000000	Vel earum cupiditate distinctio. Voluptate officia sit. Possimus culpa impedit quaerat.	180	2023-03-06 06:19:40
378	97	Terjamin Baru Full Murah Bekas Kilometer Kondisi Jarang Eksterior	215000000	Unde adipisci asperiores eum optio sed saepe. Tenetur suscipit fugit magni. Itaque ducimus quia.	56	2023-04-04 21:29:02
379	120	Nopol Tahun Terawat Full Mobil Harga Nego Kendaraan Asli Jarak	850000000	Quam itaque dolor reprehenderit. Optio natus exercitationem eum qui. Iusto porro ratione amet dicta ad voluptatum.	69	2022-10-17 05:54:02
380	357	Murah Harga Service Kondisi Cicilan Stnk Jarang Pajak Tangan	245000000	Magnam veritatis eligendi. Quasi dolores eos harum ratione eaque. Eveniet tenetur sint blanditiis possimus repellendus.	153	2023-06-01 08:31:04
381	266	Pajak Tahun Mesin Negotiable Pribadi Nego Murah Pemakaian Jarak Ban	5800000000	Illo optio numquam magni aut aperiam dicta molestiae. A cupiditate veritatis nulla culpa mollitia. Aspernatur officia neque voluptate.	177	2022-11-18 03:37:12
382	247	Baru Jual Kilometer Oli Mulus Mesin Cat Dp Surat Berkualitas	1295000000	Optio saepe expedita laudantium. Voluptate doloremque ducimus enim eum quae repellat.	7	2022-09-22 01:48:22
383	20	Siap Nopol Oli Tangan Warna Baru Terawat Pajak Cash Jarak	147500000	Recusandae repellendus nemo voluptas. Officiis consectetur hic minus.	116	2023-02-20 13:05:42
384	110	Pajak Bukan rental Siap Nopol Tangan Km Harga Mulus Mesin	4650000000	Maiores repudiandae adipisci ea provident. Ex deleniti odio dolor.	177	2023-02-24 19:54:48
385	80	Cicilan Kredit Stnk Jarak Ban Kendaraan Baru	899000000	Laborum tempore ipsa quis fugiat quibusdam reprehenderit. Ad maxime inventore exercitationem nostrum culpa. Animi provident natus quae accusamus ducimus illum.	67	2023-02-04 08:45:11
386	133	Pajak Bekas Pribadi Warna Dp Mulus Langsung	850000000	Ducimus aperiam aliquid vero eaque. Deleniti omnis eius voluptatibus quod est ullam. Voluptate deleniti voluptatum cumque odit quis maiores aut.	29	2022-11-11 02:54:35
387	398	Tangan Nopol Mulus Pakai Mesin	1980000000	Sunt sequi alias aut cupiditate in. Hic a voluptates at.	52	2023-01-29 15:24:23
388	399	Kondisi Velg Cat Surat Cicilan	135000000	Ex facilis commodi quod ad.	71	2023-05-01 20:20:34
389	159	Full Siap Bukan rental Eksterior Nopol Warna Mulus	899000000	Commodi amet voluptatum eos doloremque soluta. Ad provident praesentium quos enim deserunt.	52	2022-12-31 07:06:05
390	210	Jual Warna Tangan Langsung Cat Kredit Cash	245000000	Voluptates tempore nam. Minus debitis magnam excepturi.	146	2023-03-03 23:41:34
391	336	Full Eksterior Tahun Jarak Terjamin Bukan rental Negotiable	325000000	Omnis sequi quae commodi iure eligendi eveniet optio. Illum asperiores perferendis tenetur.	189	2022-10-16 06:39:27
392	345	Mesin Berkualitas Harga Pajak Pemakaian Velg Mobil Jarak Jual Cat	500000000	Ratione earum eos tempore aliquam neque unde.	123	2023-06-22 15:53:05
393	329	Terawat Jarak Bekas Cat Baru Eksterior Kilometer Tahun Dokumen Mesin	899000000	Quis necessitatibus consequatur magni. Numquam adipisci sit atque.	67	2023-04-11 09:06:48
394	291	Harga Pemakaian Langsung Stnk Negotiable Jarang Kendaraan Siap Terjamin Cicilan	285000000	Esse omnis ipsum velit maxime quas natus. Doloribus quasi odit dolorum repellendus laudantium libero. Soluta culpa earum architecto. Distinctio id quo earum.	41	2023-05-10 16:21:43
395	279	Asli Pajak Nego Dp Langsung Jarang Tangan Kondisi	95000	Possimus culpa facilis inventore est. Nesciunt exercitationem saepe.	18	2022-11-14 15:06:03
396	172	Km Bukan rental Mesin Cat Cicilan Pakai Terawat	225000000	Officia harum expedita nisi quod. Quibusdam ullam voluptas inventore nihil consequuntur maiores. Molestias delectus ipsa eligendi doloremque accusantium.	112	2023-01-12 15:08:24
397	242	Km Oli Service Kredit Jual Tahun Jarak	398000000	Libero error consequuntur laborum velit a. Ea corporis ea delectus. Sed asperiores deserunt.	156	2023-05-21 07:07:29
398	81	Surat Jarak Siap Jual Interior Asli	230000000	Iusto vitae maxime explicabo earum sapiente. Veniam eum animi hic explicabo non. Sed porro delectus corrupti esse voluptatum expedita.	20	2022-10-16 15:01:21
399	71	Cat Pajak Ban Tangan Nopol	159000000	Possimus perspiciatis beatae harum dignissimos quas velit. Ad cupiditate voluptatem veritatis cupiditate sunt delectus perspiciatis.	163	2022-10-03 04:47:55
400	326	Mesin Negotiable Pemakaian Mobil Jual Velg	850000000	Vel facilis quam voluptatem dolores quae dolorum. Sunt aperiam mollitia officiis corrupti nam.	151	2023-03-30 13:22:57
401	144	Terjamin Original Surat Baru Warna	228000000	Est sit commodi. Error fugit occaecati voluptatem. Architecto repellendus itaque quod. Dolorum corporis excepturi harum rem.	196	2022-12-18 22:35:07
402	312	Stnk Jarang Velg Original Km	350000000	Enim omnis sint laborum incidunt quisquam. Iusto consequuntur possimus deleniti culpa ab. Voluptatibus ducimus mollitia esse distinctio eum quas.	200	2023-08-11 20:11:54
403	129	Mesin Stnk Nego Km Terawat Jarak Nopol	375000000	Quam modi eum unde deserunt non. Voluptates laudantium quos odit quis aperiam. Alias nisi ea deleniti sit.	192	2023-08-03 19:03:24
404	95	Eksterior Terjamin Original Harga Interior Dokumen Asli Bekas Siap	500000000	Sint ea ex laudantium. Doloremque quos odit magnam consequatur reprehenderit id.	90	2023-05-07 10:11:45
405	280	Berkualitas Pakai Terjamin Kredit Mesin Pemakaian Tangan Negotiable Interior	355000000	Unde omnis eius dolore ratione. Cupiditate modi vero dolorum ipsam.	19	2023-01-17 18:53:10
406	58	Siap Negotiable Mulus Interior Tangan Stnk Berkualitas Kondisi	1700000000	Ad recusandae mollitia quo officia. Quod delectus ipsa maiores cupiditate ipsam.	130	2022-12-17 13:19:21
407	314	Nopol Dokumen Pakai Velg Pribadi Mesin Cicilan	285000000	Vero asperiores voluptatum dolore at.	41	2023-03-30 14:40:58
408	139	Langsung Jarang Jarak Asli Pemakaian Bukan rental Kendaraan Mobil	110000000	Tempora aspernatur perspiciatis enim. Consequatur saepe amet aspernatur culpa ducimus quibusdam corporis.	178	2023-03-12 04:24:59
409	91	Jual Harga Surat Nego Mesin	4650000000	Eaque vitae voluptatum ipsa doloremque voluptas itaque. Neque fugit tenetur sint tenetur nemo atque. Assumenda placeat earum est unde quisquam quo.	27	2023-02-26 12:39:33
410	394	Siap Kondisi Negotiable Pribadi Interior Cat Warna	220000000	Nostrum esse iste voluptates placeat.	174	2023-03-06 09:49:43
411	41	Bekas Baru Pajak Harga Mesin Jarak Original Oli Bukan rental	212500000	Est saepe sint occaecati beatae.	168	2023-04-24 05:50:09
412	35	Full Pajak Ban Asli Velg Service Kilometer Interior Terjamin	1500000000	Aut eos voluptas ratione. Ipsum natus dolorum alias quasi perspiciatis vitae. Quas voluptatem aliquam ab.	125	2023-02-05 05:41:03
413	13	Mulus Pribadi Tangan Full Service	450000000	Praesentium voluptatibus nesciunt consequuntur consequatur aut minus. Adipisci blanditiis autem beatae dignissimos illo accusamus.	2	2022-12-08 16:00:41
414	250	Mulus Velg Nego Cat Jarak Warna Asli Dp	679000000	Possimus cupiditate consequatur. Reprehenderit neque vel quis. Placeat assumenda accusantium deserunt.	160	2022-12-18 07:41:19
415	175	Terawat Pakai Negotiable Service Bekas Murah Asli Interior	285000000	Iste blanditiis sapiente nisi in repudiandae temporibus. Enim possimus id vel.	50	2023-01-07 23:09:35
416	158	Oli Ban Nopol Terjamin Mesin Velg Pakai Asli Stnk Bekas	110000000	Perferendis veritatis provident sed animi consequuntur veniam natus. Itaque voluptates eligendi consectetur est inventore qui. Esse tempore quas quo.	178	2022-11-30 19:36:00
417	175	Kendaraan Ban Kredit Surat Terawat Harga Tahun	1500000000	Perspiciatis distinctio pariatur neque. Voluptatem at dignissimos.	154	2023-05-04 18:48:59
418	210	Surat Berkualitas Terjamin Murah Jual Mulus	127000000	Vero ea quae consequuntur amet velit. Omnis maxime unde velit.	116	2023-02-25 12:54:39
419	279	Kredit Kilometer Service Cash Bekas Jual Asli Tahun Dp Terawat	860000000	Quod voluptatum voluptatum harum in. Ut eveniet hic totam.	52	2023-07-21 17:42:55
420	184	Dokumen Cash Warna Tahun Tangan Nopol Jual Kendaraan	325000000	Fuga sint a officia corporis assumenda. Explicabo cupiditate neque esse.	189	2023-04-05 22:54:04
421	6	Original Pakai Siap Eksterior Mobil Velg Stnk Kilometer	230000000	Sed ab est deserunt optio delectus. Magnam tempore impedit architecto amet.	102	2023-02-14 20:15:50
422	195	Bekas Terjamin Mesin Baru Pemakaian	975000000	Minima suscipit ipsum rem porro maiores sed. Neque placeat perferendis enim voluptatum quae. Doloribus et repudiandae in in animi deserunt.	138	2023-03-31 00:53:30
423	153	Terawat Tahun Baru Pajak Harga Cash Bukan rental Service	850000000	Amet qui impedit. Deleniti illo ipsum occaecati eum cupiditate culpa. Temporibus asperiores hic error eos alias.	2	2023-01-13 05:34:22
424	383	Terjamin Tahun Kondisi Bukan rental Harga Kredit Tangan	230000000	Expedita maxime magni saepe velit. Quos fugiat sit natus commodi maxime porro. Aperiam natus vero quos quidem nisi dolores.	102	2022-12-07 07:58:14
425	119	Interior Jarang Nego Km Warna Stnk Kondisi Terawat Siap Ban	517000000	Doloremque eos eius sapiente aliquid quod. Similique debitis asperiores deserunt.	166	2023-06-29 22:30:19
426	68	Kredit Bukan rental Kilometer Surat Bekas Baru	300000000	Veniam dolores ipsum occaecati optio exercitationem quidem. Odit totam eius nobis ratione. Facilis distinctio neque repellendus. Eos culpa deserunt similique sunt provident quis.	181	2023-05-23 00:15:24
427	124	Full Murah Siap Pribadi Stnk	245000000	Dicta dolorum esse dolor commodi id. Hic vel nostrum corrupti aut. Veniam praesentium rem quia deleniti facere. Repudiandae cum quisquam ad suscipit possimus.	12	2023-05-19 19:49:11
428	10	Nopol Cat Interior Jual Cash Dp Dokumen	679000000	Repellendus magnam accusamus nisi. Praesentium blanditiis laboriosam excepturi magnam. Quam perferendis vel cupiditate iste ratione unde modi.	160	2022-12-31 01:27:05
429	370	Kendaraan Kilometer Pribadi Terjamin Tangan Bekas	775000000	Impedit maiores optio. Voluptatum aut libero. Quae accusamus culpa autem.	160	2023-05-02 22:37:53
430	350	Kilometer Full Kendaraan Langsung Kondisi Mulus Velg	210000000	Totam labore perferendis voluptatibus maiores. Excepturi est dolor quos natus aspernatur.	106	2023-04-16 08:13:36
431	305	Tangan Eksterior Pribadi Full Bukan rental Berkualitas Cash Original Pemakaian	398000000	Illo et inventore ex. Labore unde explicabo doloremque. Alias deserunt cumque nam sint.	148	2023-01-20 12:40:37
432	62	Terawat Kendaraan Pribadi Dp Warna Bekas Tangan	1450000000	Necessitatibus perspiciatis consectetur similique. Eveniet dignissimos ullam sed reprehenderit voluptate. Nobis dolorem quibusdam repellat harum.	32	2022-10-10 14:21:00
433	258	Pemakaian Dokumen Berkualitas Mulus Stnk Oli Kilometer Kredit Nego Ban	650000000	Autem sunt fuga dolores. Fugiat id ab doloribus praesentium enim excepturi. Rem delectus aspernatur esse aut beatae cupiditate. Recusandae sapiente minus mollitia facilis ab possimus quis.	140	2023-06-11 07:07:13
434	46	Berkualitas Service Bukan rental Terjamin Mulus	212500000	Quae repellat perspiciatis sit dolore rerum. Amet architecto alias eaque. At praesentium repudiandae illum iusto dicta quidem.	168	2023-03-11 23:24:34
435	174	Negotiable Cat Eksterior Siap Pribadi	220000000	Voluptate possimus fugit corporis modi quia. Tenetur necessitatibus tempora odit quas.	147	2023-05-10 00:24:43
436	77	Bukan rental Surat Kondisi Terjamin Interior Harga Km	4000000000	Accusamus exercitationem labore similique. Occaecati rerum deleniti dolor ipsum consequatur quaerat. Molestias cum ipsam quos repellendus.	150	2023-04-22 02:55:48
437	187	Km Kondisi Stnk Full Baru	1700000000	Voluptatibus ea at. Dicta officiis dolore neque natus iure dolores.	154	2023-06-05 00:10:52
438	90	Dokumen Baru Terawat Dp Berkualitas Oli Velg Terjamin Cicilan	120000000	Quas ducimus in atque quod blanditiis. Neque illum esse similique eum sequi tempora. Facere delectus consectetur quisquam facere.	126	2023-01-23 07:19:08
439	65	Stnk Surat Full Pribadi Kilometer Harga Berkualitas	899000000	Laudantium consectetur sapiente vero. Voluptatem numquam incidunt aspernatur. Consequuntur necessitatibus nisi accusantium alias eius dolores. Quasi cum suscipit explicabo incidunt.	67	2023-06-13 16:26:43
440	368	Terjamin Service Km Oli Kondisi Cicilan Langsung	1500000000	Magni quisquam earum. Nulla soluta impedit ab nostrum eligendi in.	130	2023-02-02 09:31:23
441	135	Terjamin Kendaraan Original Interior Asli Surat Service Pajak	155000000	Autem corporis mollitia omnis officia quam molestias. Ullam numquam aspernatur deserunt quisquam eaque. Quas ipsum recusandae velit odit.	158	2023-01-14 07:06:32
442	126	Pribadi Tahun Langsung Eksterior Nopol Original Berkualitas Nego	146000000	Nihil aut voluptatum laborum illum numquam beatae. Doloribus tempora ipsam impedit. Deserunt enim quam recusandae eius dolorum.	46	2023-04-21 01:43:24
443	313	Pemakaian Eksterior Tahun Warna Jual Terawat	181000000	Sed modi possimus accusamus. Reiciendis sunt minus magnam labore numquam ullam.	143	2023-02-26 01:15:41
444	228	Full Kilometer Jarang Oli Tahun Jarak Nopol Negotiable Service Surat	110000000	Sapiente sequi maxime sed excepturi quod. Atque aut tempora quis. Quidem accusamus in quibusdam.	35	2023-05-06 06:28:04
445	238	Kondisi Full Bekas Harga Cash Service Mesin Eksterior Km Stnk	365000000	Similique deserunt pariatur nulla mollitia quam odit. Eius vitae quam voluptatem. Odit tenetur vel nesciunt tenetur.	159	2022-11-18 16:36:45
446	286	Bekas Siap Harga Dokumen Terjamin Tahun	440000000	Distinctio ad ipsum molestias. Quas nostrum error repellat asperiores laudantium nobis.	21	2022-11-07 08:03:43
447	312	Stnk Nopol Terawat Cat Langsung Pakai Eksterior Ban Tangan Kendaraan	775000000	Mollitia possimus inventore. Voluptate odit ex alias.	175	2023-01-10 11:06:36
448	383	Dp Service Kondisi Kredit Cash	1745000000	Odit nobis unde. Sed veniam repellendus animi nobis quos.	32	2023-05-11 14:15:44
449	210	Cash Dp Berkualitas Mulus Asli Dokumen Ban Warna Negotiable Velg	228000000	Debitis dolorem fugit assumenda omnis. Corrupti accusamus perferendis rerum voluptas consequuntur pariatur veritatis.	137	2023-07-03 18:44:32
450	137	Oli Terawat Ban Cicilan Bukan rental	510000000	Quis ullam sit delectus.	124	2023-01-15 15:55:49
451	165	Ban Asli Pajak Nego Kilometer	260000000	Necessitatibus non mollitia. Voluptatem esse veniam nam pariatur. Libero sapiente suscipit voluptate.	200	2022-10-21 12:26:20
452	19	Oli Kondisi Full Tahun Baru Warna Asli	1980000000	Accusantium quod possimus nulla facere animi. Repellendus debitis culpa autem eius iure consequuntur. Officiis ad eaque ut a aliquid repellat.	68	2023-04-08 08:52:08
453	330	Mesin Pribadi Pemakaian Tahun Kondisi Terjamin Warna Cat	365000000	Quam ut aspernatur doloremque dignissimos illum voluptatibus. Quod vel reprehenderit architecto incidunt iusto. Odio ad corporis neque.	84	2023-03-20 20:10:25
454	69	Mulus Jarang Pakai Jual Kredit Dokumen Terjamin Kendaraan	1980000000	Corrupti neque culpa aliquid suscipit explicabo. Ipsa eius quibusdam dolor sed dignissimos. Consectetur eligendi odit fugiat.	52	2023-01-04 08:43:03
455	175	Warna Nopol Kendaraan Service Tangan Cash	276000000	Nobis iste atque officiis vero magni molestias. Possimus voluptate fugiat aperiam quis illum dolore. Sit dolor nesciunt temporibus. Officia quisquam rerum illo.	98	2023-04-05 14:09:19
456	90	Cicilan Pakai Asli Service Jarang Berkualitas Dp	590000000	Incidunt eos eum earum.	91	2022-10-20 16:26:21
457	10	Cash Pemakaian Warna Tangan Full Harga Bekas	125000000	Temporibus ex ipsum debitis facere. Veritatis voluptates sapiente unde. Dignissimos reiciendis occaecati accusamus maxime illo.	195	2023-01-26 07:22:33
458	298	Nopol Pakai Kilometer Surat Pribadi Kendaraan Langsung	450000000	Illum consequatur enim earum. Impedit corporis ad porro magnam tempore aliquid.	5	2023-06-17 04:49:24
459	323	Tangan Cicilan Terawat Warna Pakai Interior Negotiable Original Terjamin Kredit	210000000	Error dicta adipisci quas quia iure ex. Sequi cum neque quibusdam quidem.	106	2023-02-17 09:44:05
460	92	Ban Eksterior Nopol Kondisi Murah Pajak Jual Km	200000000	Magnam dolorem similique voluptatum eveniet. Fugiat cumque corrupti possimus cupiditate in reprehenderit qui. Fuga quis repellat rerum architecto dolorem.	112	2022-12-20 10:33:29
461	112	Nopol Murah Mobil Tahun Jarang Jarak	285000000	Nihil necessitatibus ab fugit.	62	2022-12-06 00:06:40
462	354	Baru Mulus Murah Pemakaian Siap	517000000	Quia similique aperiam suscipit vitae voluptatem. Inventore vel sapiente at omnis voluptas eveniet. Cumque omnis incidunt iste reprehenderit. Autem ducimus quia voluptatem ipsa eum.	70	2022-12-19 17:48:51
463	27	Velg Ban Stnk Cash Dp Service Harga Tahun Full	159000000	Aspernatur nisi quia exercitationem culpa porro nam. Architecto vitae pariatur alias aliquam sunt. Tenetur eveniet reiciendis fugit.	157	2023-05-06 01:39:11
464	384	Full Kendaraan Terawat Langsung Tangan	1980000000	Asperiores quo perferendis nemo. Debitis aut occaecati excepturi impedit neque recusandae officiis. Minus voluptas dolore dolores vitae ipsum cum.	164	2023-06-15 10:21:11
465	315	Warna Kendaraan Pakai Siap Murah Terawat Km Berkualitas Kredit	590000000	Fugit delectus beatae odit. Ad facilis fugiat eaque dicta repellat. Fuga at natus.	96	2023-04-18 23:09:28
466	250	Eksterior Stnk Asli Kredit Pakai Service	123000000	Impedit nostrum tempora quam ut quisquam natus. Saepe expedita a consequatur laboriosam sit beatae. Voluptas optio ex optio.	15	2023-01-18 11:18:02
467	226	Berkualitas Oli Original Interior Asli Harga Dp	276000000	Ex corporis hic eligendi. Consectetur asperiores fugit.	98	2023-01-22 23:19:09
468	133	Jarang Kredit Dp Full Terjamin Bekas	1650000000	Inventore quod pariatur eligendi aut modi. Vero necessitatibus eius soluta officia sequi deleniti aperiam. Aliquid quisquam ipsam cupiditate. Deserunt ea mollitia exercitationem delectus neque aperiam beatae.	186	2023-01-10 04:31:26
469	127	Stnk Kredit Km Siap Harga Kondisi Langsung Pajak Bukan rental Surat	127000000	Labore eaque dolor veniam. Tenetur odio porro. Voluptate voluptatum praesentium recusandae.	11	2023-05-05 09:25:22
470	232	Siap Nego Mulus Eksterior Terawat	850000000	Ipsam quae modi accusantium tempora. Illo eum animi corporis aut est corrupti.	29	2022-12-21 06:29:05
471	358	Tangan Kondisi Pemakaian Jual Jarang	1425000000	Ratione voluptatibus sunt ipsam ipsam dignissimos at. Exercitationem beatae odio.	172	2023-05-28 12:20:56
472	364	Asli Jarak Harga Murah Pribadi Jual Ban	130000000	Laudantium error voluptate tenetur. Illo quos fugiat mollitia consequuntur.	111	2023-01-24 18:43:12
473	315	Kondisi Kilometer Langsung Warna Bukan rental Jarak Cicilan	159000000	Aspernatur aliquam occaecati iure temporibus. Doloremque accusantium sint.	184	2023-04-07 14:49:04
474	361	Pemakaian Mesin Jual Cicilan Km Tahun	125000000	Sunt eum perspiciatis repudiandae beatae at magni. Cupiditate repellat voluptates suscipit quidem quis suscipit. Quasi nemo impedit harum voluptatum.	122	2023-02-12 21:22:17
475	224	Negotiable Terawat Bekas Mobil Km	398000000	Laborum nihil culpa nam et. Corporis pariatur ipsa vero.	169	2022-10-14 05:08:23
476	80	Kredit Cash Mulus Kendaraan Full Velg Dokumen	230000000	Quae quos ratione sapiente. Neque explicabo vel ab ad explicabo quia.	115	2023-04-18 12:47:20
477	121	Full Km Baru Bukan rental Dp Jual Kondisi	125000000	At id autem.	92	2023-06-13 18:44:04
478	243	Dokumen Kilometer Warna Velg Jarak	127000000	Officia doloremque error odio aut repellat. Expedita facilis illum nemo fuga accusantium possimus sunt. Dolor aliquid ab quo architecto repellat nobis.	117	2023-06-09 05:18:08
479	87	Cat Pemakaian Original Mesin Asli Km Pakai Full Service Oli	520000000	Eligendi saepe quibusdam asperiores reiciendis a magnam. Officiis esse suscipit accusantium. Suscipit ut nisi minima occaecati.	197	2023-05-16 10:08:12
480	369	Jarak Kredit Pribadi Service Berkualitas Nego	300000000	Ipsum quia reiciendis necessitatibus animi dignissimos sit. A saepe consequuntur occaecati. Ratione numquam facere sequi soluta. Exercitationem incidunt vitae minus inventore autem.	50	2023-05-14 11:14:55
481	233	Cat Stnk Terjamin Warna Tahun Mobil Pemakaian	265000000	Fuga reiciendis vitae fugit tenetur minima. Ex rem esse culpa similique itaque beatae.	106	2023-02-12 18:07:05
482	400	Langsung Siap Berkualitas Harga Mobil	120000000	Quibusdam odit dolores nobis explicabo error quis. Hic nostrum fugit accusamus suscipit eum. Molestiae possimus adipisci nulla odio nam. Cum iste numquam facere ducimus id exercitationem voluptatum.	88	2023-04-05 18:00:50
483	256	Ban Velg Terawat Pakai Mesin	1500000000	Alias accusamus fuga possimus aspernatur. Illum totam quisquam pariatur odit quas.	154	2023-02-14 08:47:22
484	204	Pakai Eksterior Terjamin Velg Tangan Warna Original	123000000	Laboriosam explicabo autem nesciunt ipsam delectus. Natus illum aut.	15	2023-02-21 06:14:34
485	135	Service Asli Murah Dokumen Original	230000000	Nesciunt veniam aperiam incidunt nulla. Veritatis reiciendis velit maxime esse beatae. Unde a perferendis aperiam voluptatem repellendus repudiandae.	33	2023-04-20 21:46:57
486	17	Bekas Nego Pribadi Interior Jual Bukan rental Siap Km	398000000	Tempora nisi quod incidunt. Recusandae minus porro itaque quia quod fugiat.	59	2022-10-13 08:16:57
487	8	Kendaraan Mobil Negotiable Interior Jarang	155000000	Architecto vel suscipit maxime quo. Corporis iusto placeat.	58	2023-07-19 12:11:45
488	169	Berkualitas Langsung Murah Cicilan Mulus Cat Warna Bekas	225000000	Eos placeat dicta dolor sunt ullam laudantium. Nobis omnis id autem nihil optio autem.	77	2022-11-28 03:06:12
489	322	Service Bukan rental Mobil Baru Nego Stnk Kredit Langsung Terawat	181000000	Ex sed quis minus saepe sunt. Velit doloribus fuga. Repellat nulla deserunt nihil tempora sit consequuntur.	48	2023-06-20 05:22:48
490	242	Terjamin Kendaraan Asli Oli Km Baru Kondisi Pakai	230000000	Odit tempore delectus sit impedit placeat illo. Officia et dolores qui alias dolor cum. Facere facilis id provident ut.	89	2022-08-27 22:05:10
491	58	Terawat Service Harga Warna Kendaraan Tangan Pribadi	520000000	Vel quisquam id quidem explicabo. Dicta sapiente mollitia dicta fugiat expedita nam. Possimus neque asperiores provident est.	62	2022-09-29 18:39:14
492	241	Kondisi Original Harga Pakai Siap Cash Bukan rental	398000000	Deleniti nisi officiis omnis eius eos. Odit consequuntur illo ad commodi voluptatum sapiente. Vero deleniti voluptatum et sit dignissimos quisquam molestiae.	169	2022-10-16 15:19:53
493	73	Warna Jual Dokumen Siap Murah Kredit Full Oli Kilometer	325000000	Recusandae ex animi dolor est. Officiis quia quaerat fuga magnam assumenda harum.	136	2023-01-25 06:37:14
494	52	Jarak Terjamin Jarang Dp Full Tahun Kredit Interior Velg Pribadi	825000000	Nam expedita voluptatem.	51	2023-05-24 05:04:45
495	19	Kilometer Asli Tangan Terjamin Terawat Original Stnk Harga Interior Surat	190000000	Quia rem laborum impedit eligendi. Repudiandae porro accusantium voluptatum.	63	2022-12-28 05:13:00
496	86	Jarak Dokumen Asli Kendaraan Kondisi	850000000	Culpa officiis incidunt ex fuga ea quasi. Maxime quo natus odio praesentium unde eveniet. Mollitia temporibus eaque vitae eaque dolore.	64	2022-10-09 10:49:27
497	246	Pakai Mesin Bekas Kondisi Kilometer Terawat Baru Dp Jarang	200000000	Deserunt quod adipisci cum saepe accusantium vitae nisi. Occaecati dignissimos at aliquam doloremque nihil tenetur. Delectus maxime ipsa fugit.	54	2023-01-25 22:09:21
498	161	Siap Warna Terawat Cicilan Nopol Tahun Velg Mobil	120000000	Ducimus nihil accusantium. Vitae amet dignissimos nobis consequuntur accusantium. Ab blanditiis sequi aspernatur debitis eius.	73	2023-03-26 17:31:00
499	130	Bukan rental Nego Kredit Bekas Km Mesin Pajak	375000000	At nobis non. Ipsa culpa quae sapiente vel laborum repudiandae. Minima veritatis itaque asperiores a.	90	2023-04-14 06:29:17
500	190	Km Original Pajak Tangan Nego Cicilan Nopol	450000000	Molestias debitis ab incidunt quas amet exercitationem temporibus. Ad dolorum optio officia magni. Dolorum dolore labore laboriosam. Explicabo ut numquam veniam.	69	2023-04-21 16:17:06
\.


--
-- TOC entry 3401 (class 0 OID 27654)
-- Dependencies: 222
-- Data for Name: bids; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bids (bid_id, ad_id, user_id, bid_price, bid_status, datetime_bid) FROM stdin;
1	318	36	314500000	rejected	2023-03-30 12:10:48
2	259	140	193500000	rejected	2023-07-03 21:59:11
3	197	65	124500000	approved	2022-11-28 01:49:44
4	260	390	89000000	rejected	2023-03-19 02:44:57
5	301	81	118000000	rejected	2023-01-19 17:05:02
6	118	179	134500000	rejected	2022-11-10 12:36:59
7	338	123	203500000	approved	2022-12-30 04:34:35
8	261	62	5126000000	approved	2023-03-03 20:47:42
9	411	152	177500000	rejected	2023-04-25 05:50:09
10	195	346	380500000	rejected	2023-06-15 18:58:06
11	374	167	823500000	approved	2022-12-03 01:49:25
12	319	338	148200000	rejected	2023-03-01 00:27:25
13	371	281	574000000	rejected	2023-03-26 14:22:21
14	41	153	83000000	approved	2022-11-05 18:41:46
15	320	140	199500000	rejected	2022-09-22 19:14:07
16	273	114	232000000	rejected	2022-10-14 06:31:20
17	451	277	242500000	rejected	2022-10-23 12:26:20
18	332	274	118000000	rejected	2023-07-21 19:40:11
19	440	148	1422000000	rejected	2023-02-03 09:31:23
20	200	86	130000000	rejected	2023-04-20 13:36:35
21	18	330	119600000	rejected	2022-09-19 05:39:13
22	360	176	224500000	rejected	2022-10-03 08:57:21
23	18	265	109100000	rejected	2022-09-15 05:39:13
24	135	280	1408000000	rejected	2022-09-14 15:31:47
25	227	252	103000000	rejected	2023-04-22 10:23:06
26	188	374	136300000	rejected	2022-10-28 00:59:19
27	497	100	188500000	approved	2023-02-01 22:09:21
28	366	336	109500000	rejected	2023-03-14 04:35:59
29	61	123	316000000	rejected	2023-01-20 14:42:53
30	414	312	582200000	rejected	2022-12-22 07:41:19
31	291	153	321000000	rejected	2023-04-21 02:02:58
32	278	308	133200000	approved	2023-07-02 19:52:24
33	97	208	162500000	approved	2023-01-02 23:52:50
34	234	136	421000000	rejected	2023-03-07 09:36:30
35	193	353	160500000	rejected	2023-01-04 22:16:49
36	433	135	536500000	rejected	2023-06-18 07:07:13
37	173	154	179000000	rejected	2023-01-09 16:24:49
38	168	292	419900000	rejected	2023-05-20 21:39:56
39	459	311	177000000	rejected	2023-02-19 09:44:05
40	330	24	1387500000	approved	2023-04-02 20:14:47
41	410	189	180500000	rejected	2023-03-12 09:49:43
42	115	104	180500000	approved	2023-04-30 23:12:40
43	35	355	100000000	approved	2023-04-16 15:15:45
44	251	281	132000000	rejected	2023-02-04 10:57:37
45	349	70	223000000	rejected	2023-06-12 05:04:11
46	29	174	627500000	rejected	2022-12-05 22:00:28
47	71	31	924500000	rejected	2022-10-06 07:12:26
48	353	371	157500000	approved	2022-12-02 06:08:18
49	346	144	142500000	rejected	2023-04-24 06:10:51
50	375	174	1471000000	approved	2023-03-31 21:52:45
51	97	80	176000000	approved	2022-12-31 23:52:50
52	349	214	199000000	rejected	2023-06-11 05:04:11
53	166	224	81500000	rejected	2023-03-28 11:43:50
54	415	312	259500000	rejected	2023-01-09 23:09:35
55	108	117	478100000	rejected	2022-09-20 07:59:40
56	220	374	116000000	rejected	2022-12-15 15:03:36
57	225	271	125800000	rejected	2022-11-23 08:45:05
58	85	84	187000000	approved	2023-07-20 09:08:47
59	118	288	130000000	rejected	2022-11-14 12:36:59
60	181	180	931000000	rejected	2023-07-12 03:20:55
61	220	140	117500000	rejected	2022-12-19 15:03:36
62	447	340	693500000	approved	2023-01-15 11:06:36
63	164	309	158500000	rejected	2022-10-11 08:59:28
64	337	26	446500000	approved	2023-05-14 17:55:52
65	348	167	2458000000	rejected	2023-06-06 04:41:15
66	119	331	164500000	rejected	2023-01-28 17:53:46
67	376	134	1743000000	approved	2023-01-08 21:53:46
68	155	37	743000000	rejected	2023-05-04 01:09:51
69	112	210	113400000	rejected	2023-05-09 10:10:28
70	113	141	241500000	rejected	2022-11-04 06:08:52
71	62	70	105900000	approved	2023-01-26 03:46:02
72	38	226	131500000	rejected	2022-09-01 08:22:22
73	33	375	602500000	rejected	2022-11-28 21:01:30
74	381	147	5421500000	rejected	2022-11-22 03:37:12
75	39	15	696000000	rejected	2022-11-29 07:14:30
76	214	33	751000000	rejected	2022-12-08 19:15:44
77	459	373	196500000	rejected	2023-02-23 09:44:05
78	435	232	197000000	approved	2023-05-12 00:24:43
79	459	286	180000000	rejected	2023-02-24 09:44:05
80	245	235	123000000	rejected	2023-03-10 00:44:00
81	429	118	668000000	rejected	2023-05-09 22:37:53
82	101	121	661500000	rejected	2023-03-22 10:38:49
83	354	222	231700000	rejected	2023-02-06 08:32:38
84	353	129	166500000	rejected	2022-12-02 06:08:18
85	130	35	1153500000	rejected	2023-04-27 16:04:19
86	420	101	300500000	approved	2023-04-12 22:54:04
87	449	388	197400000	rejected	2023-07-10 18:44:32
88	304	221	188500000	approved	2023-01-10 07:36:06
89	280	204	241000000	rejected	2022-12-23 18:33:51
90	457	324	107500000	rejected	2023-02-01 07:22:33
91	134	47	413500000	rejected	2023-05-20 07:52:59
92	454	283	1879500000	rejected	2023-01-11 08:43:03
93	481	20	234500000	rejected	2023-02-17 18:07:05
94	448	307	1516000000	approved	2023-05-18 14:15:44
95	279	313	394000000	rejected	2022-11-11 10:03:48
96	7	178	92000000	rejected	2023-02-26 08:14:07
97	436	87	3617000000	rejected	2023-04-28 02:55:48
98	346	306	121500000	rejected	2023-04-27 06:10:51
99	62	327	110400000	approved	2023-01-22 03:46:02
100	99	392	473500000	rejected	2023-05-15 09:54:53
101	494	1	774000000	rejected	2023-05-31 05:04:45
102	39	225	675000000	rejected	2022-11-25 07:14:30
103	333	368	1595500000	rejected	2023-05-24 05:13:15
104	447	31	717500000	rejected	2023-01-13 11:06:36
105	478	170	103100000	approved	2023-06-16 05:18:08
106	112	399	110400000	approved	2023-05-08 10:10:28
107	49	126	113600000	rejected	2022-11-09 13:27:07
108	259	369	186000000	rejected	2023-07-05 21:59:11
109	19	138	1553500000	approved	2023-07-27 23:18:43
110	210	162	206500000	rejected	2023-04-13 13:13:48
111	481	217	243500000	approved	2023-02-14 18:07:05
112	494	214	691500000	approved	2023-05-30 05:04:45
113	430	267	171000000	rejected	2023-04-18 08:13:36
114	286	284	715000000	rejected	2023-01-17 15:08:25
115	24	105	210000000	rejected	2023-04-30 22:15:23
116	391	184	291500000	approved	2022-10-20 06:39:27
117	471	213	1141500000	rejected	2023-05-30 12:20:56
118	122	78	96000000	rejected	2023-07-25 04:28:07
119	285	265	118700000	approved	2022-11-22 16:19:22
120	114	376	175000000	approved	2023-01-27 10:44:42
121	104	303	128700000	rejected	2023-08-06 05:25:59
122	433	358	592000000	rejected	2023-06-16 07:07:13
123	212	243	163700000	rejected	2023-02-24 00:23:24
124	30	362	190000000	rejected	2022-12-19 19:43:09
125	57	221	149500000	rejected	2023-07-11 08:39:16
126	297	145	209000000	approved	2023-02-05 09:00:39
127	126	128	151500000	rejected	2023-02-09 09:50:43
128	260	50	95000000	rejected	2023-03-22 02:44:57
129	321	287	509000000	approved	2023-04-26 10:27:52
130	202	342	205000000	rejected	2022-10-06 06:17:50
131	301	216	101500000	approved	2023-01-19 17:05:02
132	53	178	175600000	rejected	2023-04-13 15:38:32
133	298	352	126200000	rejected	2023-01-23 20:21:41
134	380	239	232000000	rejected	2023-06-07 08:31:04
135	372	283	137800000	rejected	2023-01-09 07:14:35
136	264	347	704000000	rejected	2023-02-13 22:19:34
137	306	22	111900000	approved	2022-12-24 18:43:21
138	212	275	168200000	approved	2023-02-23 00:23:24
139	79	318	89500000	rejected	2023-07-12 05:25:53
140	213	314	332000000	rejected	2023-05-11 00:36:04
141	19	5	1424500000	rejected	2023-08-02 23:18:43
142	336	119	208000000	rejected	2023-01-07 21:39:53
143	253	400	415000000	rejected	2023-06-11 13:24:49
144	249	396	189500000	rejected	2022-12-21 19:08:52
145	133	128	127000000	rejected	2023-07-08 16:02:39
146	291	276	337500000	rejected	2023-04-20 02:02:58
147	69	334	104500000	rejected	2023-06-03 03:33:14
148	18	220	101600000	rejected	2022-09-15 05:39:13
149	403	11	331500000	approved	2023-08-06 19:03:24
150	402	275	281500000	rejected	2023-08-14 20:11:54
151	50	106	236500000	rejected	2022-08-21 17:22:53
152	104	378	136200000	rejected	2023-08-10 05:25:59
153	351	44	4354500000	approved	2022-11-24 18:16:38
154	171	242	177500000	rejected	2022-11-29 00:10:53
155	281	175	735700000	rejected	2023-03-27 06:47:00
156	373	271	200500000	rejected	2023-07-02 20:34:43
157	336	342	200500000	rejected	2023-01-12 21:39:53
158	385	168	795700000	rejected	2023-02-05 08:45:11
159	117	321	89600	approved	2023-06-20 12:44:31
160	304	142	197500000	approved	2023-01-09 07:36:06
161	427	38	226000000	rejected	2023-05-24 19:49:11
162	81	154	139700000	rejected	2023-01-02 11:57:22
163	346	278	132000000	rejected	2023-04-24 06:10:51
164	129	11	100000000	rejected	2022-11-17 18:46:05
165	384	14	4252500000	approved	2023-02-25 19:54:48
166	200	372	125500000	rejected	2023-04-17 13:36:35
167	108	49	472100000	rejected	2022-09-17 07:59:40
168	212	95	174200000	rejected	2023-02-21 00:23:24
169	249	201	189500000	approved	2022-12-23 19:08:52
170	368	168	1594500000	rejected	2023-01-11 05:05:45
171	39	37	685500000	rejected	2022-11-25 07:14:30
172	346	347	141000000	rejected	2023-04-26 06:10:51
173	233	37	601700000	rejected	2023-03-28 15:54:12
174	303	158	469000000	rejected	2022-12-21 09:46:11
175	173	225	194000000	approved	2023-01-10 16:24:49
176	78	59	83000000	approved	2023-04-19 22:35:54
177	463	8	139200000	rejected	2023-05-11 01:39:11
178	427	107	229000000	rejected	2023-05-24 19:49:11
179	471	378	1333500000	approved	2023-06-04 12:20:56
180	364	116	296500000	approved	2022-11-21 19:27:03
181	111	66	430400000	rejected	2022-12-05 16:10:14
182	248	1	106500000	rejected	2023-04-13 12:17:53
183	283	15	732500000	rejected	2023-05-01 02:30:41
184	468	39	1423500000	rejected	2023-01-17 04:31:26
185	59	231	632000000	rejected	2023-02-13 16:43:37
186	61	335	352000000	rejected	2023-01-22 14:42:53
187	470	288	755000000	rejected	2022-12-23 06:29:05
188	478	5	116600000	approved	2023-06-14 05:18:08
189	94	84	113500000	rejected	2022-10-14 03:55:46
190	50	45	235000000	rejected	2022-08-16 17:22:53
191	206	115	794000000	rejected	2023-04-22 12:44:13
192	380	258	200500000	rejected	2023-06-03 08:31:04
193	171	381	179000000	rejected	2022-12-04 00:10:53
194	417	82	1368000000	approved	2023-05-07 18:48:59
195	31	377	953500000	rejected	2023-02-08 06:25:00
196	171	260	171500000	rejected	2022-12-04 00:10:53
197	32	97	222300000	rejected	2023-01-27 11:54:11
198	409	76	4020000000	rejected	2023-03-01 12:39:33
199	252	361	1513000000	approved	2023-01-06 22:05:34
200	449	341	204900000	rejected	2023-07-10 18:44:32
201	33	199	559000000	approved	2022-11-24 21:01:30
202	3	315	421500000	rejected	2022-11-21 06:04:13
203	389	163	825700000	rejected	2023-01-03 07:06:05
204	283	236	726500000	rejected	2023-04-26 02:30:41
205	321	175	461000000	approved	2023-04-28 10:27:52
206	120	300	147800000	rejected	2022-11-11 15:49:30
207	455	240	247800000	rejected	2023-04-08 14:09:19
208	363	62	196000000	rejected	2022-11-25 02:35:46
209	224	39	142600000	rejected	2023-04-14 14:49:41
210	108	195	448100000	rejected	2022-09-22 07:59:40
211	475	181	337900000	rejected	2022-10-17 05:08:23
212	211	2	1347000000	rejected	2023-01-13 06:03:59
213	167	34	131500000	approved	2023-03-03 01:32:45
214	341	237	256500000	rejected	2023-05-28 08:27:37
215	232	30	404500000	approved	2023-05-04 15:42:00
216	399	62	127200000	approved	2022-10-05 04:47:55
217	260	293	80000000	rejected	2023-03-20 02:44:57
218	436	290	3800000000	rejected	2023-04-24 02:55:48
219	79	28	97000000	rejected	2023-07-12 05:25:53
220	283	63	732500000	rejected	2023-04-30 02:30:41
221	235	229	124500000	rejected	2023-06-05 03:34:37
222	283	389	822500000	approved	2023-04-28 02:30:41
223	322	25	1461000000	rejected	2022-11-21 09:09:10
224	172	149	186500000	rejected	2023-02-08 03:59:38
225	150	258	402000000	rejected	2023-07-09 03:34:05
226	460	138	178000000	rejected	2022-12-22 10:33:29
227	242	284	2314000000	rejected	2022-12-23 03:18:05
228	348	18	2378500000	approved	2023-06-03 04:41:15
229	154	34	1339000000	rejected	2022-12-23 09:21:53
230	291	81	321000000	rejected	2023-04-20 02:02:58
231	280	103	236500000	rejected	2022-12-28 18:33:51
232	162	361	88000000	rejected	2023-02-04 06:16:14
233	297	203	180500000	rejected	2023-02-04 09:00:39
234	214	209	815500000	rejected	2022-12-08 19:15:44
235	20	98	253500000	rejected	2023-01-16 02:44:52
236	492	391	364900000	rejected	2022-10-20 15:19:53
237	186	298	239200000	rejected	2023-03-28 17:30:17
238	444	53	103000000	rejected	2023-05-12 06:28:04
239	392	328	442000000	rejected	2023-06-28 15:53:05
240	221	173	164500000	rejected	2023-01-07 16:33:27
241	393	350	851200000	rejected	2023-04-18 09:06:48
242	96	195	212500000	rejected	2022-11-06 20:44:59
243	184	3	113000000	rejected	2022-11-18 03:43:50
244	229	376	543200000	rejected	2023-05-04 04:19:57
245	189	228	116500000	approved	2023-03-11 15:22:50
246	174	14	169600000	approved	2023-02-10 03:15:08
247	91	376	728000000	rejected	2022-09-03 04:16:18
248	374	283	823500000	rejected	2022-12-07 01:49:25
249	167	364	118000000	rejected	2023-03-04 01:32:45
250	410	9	207500000	rejected	2023-03-08 09:49:43
251	414	321	615200000	approved	2022-12-24 07:41:19
252	298	338	120200000	rejected	2023-01-27 20:21:41
253	161	247	302500000	rejected	2023-01-06 09:26:24
254	85	381	161500000	rejected	2023-07-26 09:08:47
255	235	257	126000000	approved	2023-06-05 03:34:37
256	439	267	755200000	approved	2023-06-18 16:26:43
257	69	214	92500000	approved	2023-06-02 03:33:14
258	34	375	3936000000	approved	2022-09-01 13:22:09
259	138	47	255000000	rejected	2022-12-21 20:02:19
260	213	247	323000000	rejected	2023-05-12 00:36:04
261	298	70	124700000	rejected	2023-01-28 20:21:41
262	1	291	591000000	rejected	2023-07-03 00:21:23
263	482	38	109500000	rejected	2023-04-10 18:00:50
264	255	237	276000000	rejected	2023-07-19 14:04:20
265	84	217	279600000	rejected	2023-01-17 20:10:23
266	320	89	201000000	rejected	2022-09-18 19:14:07
267	74	384	134700000	rejected	2023-02-16 13:46:50
268	366	339	109500000	rejected	2023-03-09 04:35:59
269	205	163	547000000	rejected	2023-06-29 05:39:22
270	182	288	202000000	rejected	2023-05-02 02:58:15
271	166	170	80000000	rejected	2023-03-30 11:43:50
272	435	225	197000000	approved	2023-05-14 00:24:43
273	68	252	136000000	approved	2023-07-21 07:24:36
274	430	260	172500000	rejected	2023-04-20 08:13:36
275	248	327	112500000	rejected	2023-04-18 12:17:53
276	34	292	4324500000	rejected	2022-09-04 13:22:09
277	413	395	364500000	rejected	2022-12-15 16:00:41
278	422	316	843000000	approved	2023-04-02 00:53:30
279	320	193	202500000	rejected	2022-09-20 19:14:07
280	313	62	1259000000	rejected	2023-08-11 20:59:10
281	46	306	282500000	rejected	2023-06-13 20:59:11
282	324	245	314000000	rejected	2023-03-16 11:00:39
283	107	31	401500000	approved	2023-05-09 12:49:43
284	18	333	113600000	rejected	2022-09-13 05:39:13
285	155	117	744500000	rejected	2023-05-02 01:09:51
286	282	317	822700000	rejected	2023-04-05 04:43:23
287	274	163	121300000	rejected	2023-01-11 21:00:29
288	105	365	97000000	rejected	2023-01-02 00:56:18
289	127	304	119600000	rejected	2022-11-14 10:52:36
290	160	362	1319000000	rejected	2022-11-19 14:24:12
291	346	380	124500000	rejected	2023-04-24 06:10:51
292	384	217	4392000000	approved	2023-03-03 19:54:48
293	153	7	200500000	rejected	2023-02-26 07:03:08
294	432	294	1358000000	rejected	2022-10-17 14:21:00
295	39	242	697500000	rejected	2022-11-25 07:14:30
296	465	146	500500000	approved	2023-04-22 23:09:28
297	187	321	1311500000	rejected	2023-01-03 02:21:50
298	250	147	208000000	rejected	2023-05-11 01:25:02
299	378	212	188500000	rejected	2023-04-10 21:29:02
300	211	118	1563000000	approved	2023-01-15 06:03:59
301	193	316	162000000	rejected	2023-01-05 22:16:49
302	333	249	1456000000	approved	2023-05-24 05:13:15
303	286	97	688000000	rejected	2023-01-23 15:08:25
304	46	99	291500000	rejected	2023-06-11 20:59:11
305	34	288	4257000000	rejected	2022-09-01 13:22:09
306	285	93	124700000	rejected	2022-11-22 16:19:22
307	299	41	290000000	approved	2023-03-29 16:36:14
308	110	88	391500000	rejected	2023-02-08 02:41:17
309	201	152	116000000	approved	2023-02-16 13:34:53
310	473	360	128700000	rejected	2023-04-14 14:49:04
311	257	32	206200000	rejected	2023-05-31 22:46:22
312	320	366	190500000	rejected	2022-09-16 19:14:07
313	448	8	1588000000	rejected	2023-05-15 14:15:44
314	121	223	103100000	rejected	2023-04-25 12:07:19
315	56	135	140700000	rejected	2022-11-05 05:34:11
316	42	40	428600000	rejected	2023-05-05 20:33:14
317	187	153	1161500000	rejected	2023-01-03 02:21:50
318	397	166	334900000	rejected	2023-05-28 07:07:29
319	265	65	201500000	approved	2023-04-23 12:10:31
320	159	257	110600000	rejected	2023-02-10 08:49:59
321	216	12	136000000	rejected	2023-04-04 11:13:26
322	398	312	194500000	rejected	2022-10-17 15:01:21
323	386	193	749000000	approved	2022-11-12 02:54:35
324	229	23	633200000	rejected	2023-05-08 04:19:57
325	251	215	130500000	rejected	2023-02-10 10:57:37
326	238	3	89000000	rejected	2022-11-29 12:05:45
327	361	134	174000000	rejected	2023-02-07 12:45:33
328	89	160	226400000	rejected	2022-12-28 10:00:45
329	244	181	621500000	approved	2023-06-19 17:43:19
330	60	127	76000	rejected	2023-06-23 23:59:25
331	126	114	145500000	rejected	2023-02-07 09:50:43
332	240	163	366400000	rejected	2023-03-01 11:19:42
333	264	70	720500000	rejected	2023-02-11 22:19:34
334	51	189	194500000	rejected	2023-02-05 08:38:57
335	376	116	1585500000	approved	2023-01-06 21:53:46
336	255	180	247500000	approved	2023-07-14 14:04:20
337	273	17	229000000	rejected	2022-10-12 06:31:20
338	216	29	122500000	approved	2023-04-08 11:13:26
339	484	212	114900000	approved	2023-02-28 06:14:34
340	285	65	112700000	rejected	2022-11-25 16:19:22
341	358	260	576200000	approved	2023-05-23 05:34:12
342	297	211	191000000	approved	2023-02-06 09:00:39
343	394	145	234000000	rejected	2023-05-17 16:21:43
344	371	257	584500000	rejected	2023-03-27 14:22:21
345	175	195	102000000	rejected	2023-06-01 01:46:15
346	187	280	1376000000	rejected	2023-01-08 02:21:50
347	235	330	115500000	approved	2023-06-09 03:34:37
348	164	200	152500000	rejected	2022-10-15 08:59:28
349	478	192	116600000	rejected	2023-06-16 05:18:08
350	474	367	103000000	rejected	2023-02-13 21:22:17
351	22	277	238000000	rejected	2022-12-22 14:36:15
352	336	333	203500000	approved	2023-01-11 21:39:53
353	198	192	411000000	rejected	2023-02-13 05:04:22
354	74	318	137700000	approved	2023-02-15 13:46:50
355	223	208	744500000	rejected	2023-04-29 09:52:38
356	466	99	107400000	rejected	2023-01-21 11:18:02
357	483	26	1225500000	approved	2023-02-20 08:47:22
358	185	361	407900000	approved	2023-02-11 20:23:13
359	246	342	202000000	rejected	2022-10-10 09:46:40
360	109	178	113600000	rejected	2022-10-12 23:33:49
361	126	32	147000000	rejected	2023-02-09 09:50:43
362	433	118	604000000	rejected	2023-06-18 07:07:13
363	22	234	247000000	rejected	2022-12-27 14:36:15
364	410	227	201500000	rejected	2023-03-10 09:49:43
365	328	316	737000000	rejected	2023-07-01 15:55:17
366	426	377	247500000	rejected	2023-05-28 00:15:24
367	217	131	871500000	rejected	2022-12-31 12:58:50
368	114	297	152500000	approved	2023-01-24 10:44:42
369	140	106	209500000	rejected	2023-04-01 14:02:55
370	372	289	121300000	rejected	2023-01-04 07:14:35
371	235	14	121500000	approved	2023-06-10 03:34:37
372	294	240	427500000	rejected	2022-10-17 10:14:29
373	439	170	756700000	rejected	2023-06-18 16:26:43
374	113	235	255000000	approved	2022-11-07 06:08:52
375	262	339	241500000	rejected	2023-03-03 14:07:35
376	254	73	1666500000	rejected	2023-02-04 10:32:24
377	256	318	76000	rejected	2023-04-23 15:52:36
378	10	124	4679000000	rejected	2023-06-18 21:08:59
379	165	82	174200000	approved	2023-02-16 06:05:12
380	234	350	436000000	rejected	2023-03-08 09:36:30
381	284	280	1042000000	approved	2022-12-05 12:44:54
382	425	284	473600000	rejected	2023-07-01 22:30:19
383	71	97	987500000	rejected	2022-10-07 07:12:26
384	152	350	190500000	rejected	2023-06-17 02:58:28
385	298	244	117200000	approved	2023-01-27 20:21:41
386	16	33	704000000	rejected	2022-12-21 21:21:35
387	203	376	111200000	rejected	2023-02-25 09:33:45
388	496	363	792500000	approved	2022-10-12 10:49:27
389	449	170	209400000	approved	2023-07-09 18:44:32
390	286	379	683500000	approved	2023-01-17 15:08:25
391	118	286	136000000	rejected	2022-11-16 12:36:59
392	41	227	86000000	approved	2022-11-08 18:41:46
393	382	263	1138000000	rejected	2022-09-29 01:48:22
394	405	113	299000000	approved	2023-01-23 18:53:10
395	381	201	4710500000	rejected	2022-11-25 03:37:12
396	452	89	1660500000	rejected	2023-04-11 08:52:08
397	231	364	200500000	rejected	2023-01-16 00:32:23
398	332	175	118000000	rejected	2023-07-27 19:40:11
399	7	2	81500000	rejected	2023-02-21 08:14:07
400	444	265	103000000	rejected	2023-05-11 06:28:04
401	71	25	888500000	approved	2022-10-07 07:12:26
402	404	320	466000000	rejected	2023-05-10 10:11:45
403	412	268	1285500000	rejected	2023-02-10 05:41:03
404	194	270	1130500000	rejected	2023-04-17 03:25:12
405	172	87	201500000	approved	2023-02-08 03:59:38
406	453	352	326500000	approved	2023-03-23 20:10:25
407	428	206	571700000	rejected	2023-01-07 01:27:05
408	450	312	411000000	approved	2023-01-20 15:55:49
409	395	141	76000	rejected	2022-11-20 15:06:03
410	103	37	171200000	rejected	2023-04-07 17:08:59
411	314	335	247800000	rejected	2022-09-24 03:24:34
412	69	55	88000000	rejected	2023-06-01 03:33:14
413	321	212	518000000	approved	2023-04-27 10:27:52
414	143	84	113500000	rejected	2023-02-04 15:56:06
415	254	22	1690500000	approved	2023-02-02 10:32:24
416	178	344	1175500000	rejected	2022-12-05 23:31:53
417	428	322	610700000	rejected	2023-01-05 01:27:05
418	443	305	171800000	rejected	2023-03-04 01:15:41
419	394	227	256500000	rejected	2023-05-11 16:21:43
420	132	93	186000000	rejected	2022-10-24 13:54:16
421	30	113	197500000	rejected	2022-12-20 19:43:09
422	58	128	1546500000	approved	2023-03-13 21:30:27
423	4	284	209500000	approved	2023-03-02 05:43:22
424	181	155	989500000	rejected	2023-07-13 03:20:55
425	113	217	273000000	rejected	2022-11-07 06:08:52
426	189	173	115000000	rejected	2023-03-08 15:22:50
427	388	266	123000000	approved	2023-05-06 20:20:34
428	79	253	89500000	approved	2023-07-10 05:25:53
429	447	340	687500000	approved	2023-01-16 11:06:36
430	211	378	1324500000	rejected	2023-01-12 06:03:59
431	353	310	151500000	rejected	2022-12-04 06:08:18
432	73	248	1036000000	approved	2022-10-03 12:20:30
433	471	267	1207500000	rejected	2023-06-04 12:20:56
434	196	364	2321500000	rejected	2023-02-04 16:45:34
435	371	311	587500000	rejected	2023-03-24 14:22:21
436	175	290	109500000	rejected	2023-06-05 01:46:15
437	490	345	215500000	rejected	2022-09-02 22:05:10
438	486	254	373900000	approved	2022-10-14 08:16:57
439	10	205	5337500000	rejected	2023-06-16 21:08:59
440	365	101	764000000	approved	2022-11-27 11:08:34
441	97	243	161000000	rejected	2023-01-03 23:52:50
442	26	127	165000000	rejected	2023-04-07 04:38:26
443	51	179	206500000	rejected	2023-02-02 08:38:57
444	487	274	139000000	rejected	2023-07-25 12:11:45
445	95	168	688000000	approved	2023-02-02 19:33:17
446	258	304	182500000	rejected	2022-11-02 20:39:00
447	278	69	131700000	rejected	2023-07-04 19:52:24
448	94	347	104500000	approved	2022-10-15 03:55:46
449	35	121	89500000	rejected	2023-04-14 15:15:45
450	123	287	378000000	rejected	2023-06-17 19:03:38
451	12	88	131500000	approved	2022-10-20 05:46:53
452	84	172	254100000	rejected	2023-01-20 20:10:23
453	304	314	175000000	rejected	2023-01-07 07:36:06
454	168	117	407900000	rejected	2023-05-21 21:39:56
455	151	356	88600000	rejected	2023-01-04 23:41:02
456	296	124	142200000	approved	2023-05-21 21:41:55
457	375	205	1606000000	approved	2023-03-26 21:52:45
458	344	213	413500000	rejected	2023-03-08 02:24:57
459	283	23	789500000	rejected	2023-04-27 02:30:41
460	229	387	619700000	rejected	2023-05-05 04:19:57
461	383	68	119500000	approved	2023-02-25 13:05:42
462	472	29	123500000	rejected	2023-01-28 18:43:12
463	407	350	252000000	approved	2023-04-05 14:40:58
464	444	89	92500000	rejected	2023-05-09 06:28:04
465	149	74	550000000	approved	2023-02-13 03:53:55
466	401	22	200400000	rejected	2022-12-24 22:35:07
467	389	336	852700000	rejected	2023-01-06 07:06:05
468	23	375	737000000	rejected	2023-05-25 21:49:24
469	144	17	1379500000	approved	2023-06-08 15:38:43
470	449	306	188400000	approved	2023-07-09 18:44:32
471	472	283	107000000	approved	2023-01-29 18:43:12
472	269	275	199000000	approved	2023-01-08 03:18:11
473	207	7	431500000	rejected	2023-08-09 08:43:36
474	271	185	1596000000	rejected	2023-04-03 03:18:48
475	55	316	1782000000	approved	2023-01-22 21:01:45
476	449	378	198900000	rejected	2023-07-04 18:44:32
477	291	39	352500000	rejected	2023-04-21 02:02:58
478	339	100	820500000	rejected	2023-07-01 05:43:20
479	117	263	89600	rejected	2023-06-26 12:44:31
480	461	349	250500000	rejected	2022-12-12 00:06:40
481	88	22	87500000	rejected	2023-04-01 20:58:18
482	349	35	217000000	rejected	2023-06-14 05:04:11
483	303	365	458500000	rejected	2022-12-18 09:46:11
484	235	297	118500000	rejected	2023-06-06 03:34:37
485	441	241	131500000	rejected	2023-01-21 07:06:32
486	231	337	179500000	rejected	2023-01-14 00:32:23
487	380	322	221500000	approved	2023-06-02 08:31:04
488	96	342	245500000	rejected	2022-11-03 20:44:59
489	491	77	435500000	rejected	2022-10-06 18:39:14
490	303	161	484000000	rejected	2022-12-23 09:46:11
491	40	111	144000000	approved	2023-01-29 07:03:23
492	37	39	812500000	rejected	2023-05-14 16:18:01
493	456	149	556000000	rejected	2022-10-25 16:26:21
494	275	20	1655500000	rejected	2023-05-14 19:31:01
495	129	389	92500000	rejected	2022-11-17 18:46:05
496	249	329	188000000	rejected	2022-12-17 19:08:52
497	252	165	1483000000	approved	2023-01-07 22:05:34
498	343	55	246000000	rejected	2022-09-05 06:14:10
499	127	234	119600000	approved	2022-11-11 10:52:36
500	112	166	116400000	rejected	2023-05-09 10:10:28
501	198	295	403500000	rejected	2023-02-08 05:04:22
502	493	343	303500000	approved	2023-01-26 06:37:14
503	53	254	162100000	rejected	2023-04-12 15:38:32
504	165	397	180200000	rejected	2023-02-17 06:05:12
505	496	37	803000000	rejected	2022-10-10 10:49:27
506	207	167	439000000	approved	2023-08-13 08:43:36
507	465	83	556000000	approved	2023-04-20 23:09:28
508	112	14	116400000	rejected	2023-05-11 10:10:28
509	307	186	126000000	rejected	2023-01-07 23:22:59
510	264	376	711500000	rejected	2023-02-11 22:19:34
511	38	116	127000000	approved	2022-08-31 08:22:22
512	500	208	375000000	approved	2023-04-23 16:17:06
513	21	226	246600000	approved	2023-01-03 04:46:08
514	207	305	383500000	rejected	2023-08-09 08:43:36
515	70	242	725700000	approved	2023-04-15 13:29:42
516	338	245	188500000	approved	2023-01-02 04:34:35
517	448	263	1498000000	rejected	2023-05-13 14:15:44
518	243	380	621500000	rejected	2023-01-14 05:38:59
519	410	256	203000000	rejected	2023-03-12 09:49:43
520	228	100	561000000	approved	2023-03-24 11:50:51
521	419	223	724000000	approved	2023-07-22 17:42:55
522	11	120	108000000	rejected	2023-01-18 01:42:38
523	286	9	719500000	approved	2023-01-22 15:08:25
524	72	385	517500000	approved	2023-04-29 10:09:37
525	387	12	1818000000	approved	2023-01-30 15:24:23
526	101	168	727500000	approved	2023-03-26 10:38:49
527	76	92	720500000	rejected	2023-02-27 19:52:39
528	294	58	366000000	rejected	2022-10-22 10:14:29
529	337	120	389500000	rejected	2023-05-14 17:55:52
530	54	40	200500000	approved	2023-03-22 00:08:04
531	345	97	190000000	approved	2023-05-04 10:01:46
532	212	250	178700000	rejected	2023-02-24 00:23:24
533	57	280	154000000	rejected	2023-07-10 08:39:16
534	118	187	130000000	approved	2022-11-16 12:36:59
535	494	310	715500000	rejected	2023-05-30 05:04:45
536	40	241	159000000	rejected	2023-01-29 07:03:23
537	171	81	156500000	rejected	2022-12-03 00:10:53
538	209	212	139700000	rejected	2023-03-18 13:19:49
539	108	75	478100000	rejected	2022-09-19 07:59:40
540	24	329	201000000	rejected	2023-04-30 22:15:23
541	221	212	163000000	rejected	2023-01-10 16:33:27
542	347	304	114900000	rejected	2023-06-21 05:58:37
543	478	119	107600000	rejected	2023-06-13 05:18:08
544	140	240	218500000	approved	2023-04-03 14:02:55
545	194	385	1099000000	approved	2023-04-18 03:25:12
546	275	46	1519000000	rejected	2023-05-15 19:31:01
547	348	158	2311000000	rejected	2023-06-04 04:41:15
548	21	235	257100000	rejected	2023-01-03 04:46:08
549	40	265	165000000	rejected	2023-02-04 07:03:23
550	237	220	1520500000	approved	2022-11-27 18:50:45
551	266	133	120500000	approved	2023-01-28 04:11:33
552	176	218	422500000	rejected	2023-03-12 07:12:13
553	497	245	187000000	rejected	2023-01-28 22:09:21
554	18	276	106100000	approved	2022-09-16 05:39:13
555	387	163	1785000000	approved	2023-02-04 15:24:23
556	337	151	415000000	approved	2023-05-11 17:55:52
557	463	120	143700000	rejected	2023-05-10 01:39:11
558	235	21	115500000	approved	2023-06-10 03:34:37
559	94	361	101500000	rejected	2022-10-15 03:55:46
560	417	183	1381500000	rejected	2023-05-08 18:48:59
561	12	14	125500000	rejected	2022-10-23 05:46:53
562	165	81	162200000	rejected	2023-02-15 06:05:12
563	198	74	420000000	approved	2023-02-10 05:04:22
564	224	182	142600000	rejected	2023-04-17 14:49:41
565	102	198	1079500000	rejected	2023-07-25 12:52:56
566	467	189	229800000	rejected	2023-01-28 23:19:09
567	83	163	121000000	rejected	2023-04-12 07:45:51
568	213	117	285500000	rejected	2023-05-08 00:36:04
569	152	314	175500000	rejected	2023-06-21 02:58:28
570	250	47	190000000	approved	2023-05-11 01:25:02
571	48	364	114000000	rejected	2023-07-15 14:18:47
572	445	151	326500000	rejected	2022-11-20 16:36:45
573	124	200	356000000	approved	2023-03-28 00:28:41
574	10	335	5286500000	approved	2023-06-19 21:08:59
575	332	234	107500000	rejected	2023-07-27 19:40:11
576	127	139	107600000	approved	2022-11-10 10:52:36
577	196	101	2473000000	rejected	2023-02-06 16:45:34
578	297	236	201500000	rejected	2023-02-06 09:00:39
579	151	107	90100000	approved	2023-01-05 23:41:02
580	489	371	153800000	rejected	2023-06-27 05:22:48
581	374	274	921000000	rejected	2022-12-02 01:49:25
582	357	113	119000000	approved	2022-08-25 20:01:12
583	135	147	1430500000	rejected	2022-09-15 15:31:47
584	206	220	690500000	rejected	2023-04-22 12:44:13
585	315	233	260100000	rejected	2023-04-09 12:50:59
586	176	15	416500000	rejected	2023-03-09 07:12:13
587	104	210	148200000	approved	2023-08-10 05:25:59
588	478	56	119600000	rejected	2023-06-16 05:18:08
589	92	86	1836000000	approved	2023-04-27 14:11:56
590	362	190	197500000	rejected	2023-05-16 23:06:32
591	476	110	197500000	rejected	2023-04-19 12:47:20
592	18	183	109100000	approved	2022-09-19 05:39:13
593	245	359	127500000	rejected	2023-03-11 00:44:00
594	269	63	200500000	rejected	2023-01-04 03:18:11
595	93	88	199500000	rejected	2023-07-03 03:25:50
596	328	221	725000000	rejected	2023-06-26 15:55:17
597	392	24	412000000	rejected	2023-06-23 15:53:05
598	494	290	766500000	rejected	2023-05-25 05:04:45
599	82	169	465500000	rejected	2023-01-12 15:50:29
600	473	130	131700000	approved	2023-04-14 14:49:04
601	386	128	747500000	rejected	2022-11-15 02:54:35
602	282	21	726700000	rejected	2023-04-02 04:43:23
603	448	366	1534000000	approved	2023-05-14 14:15:44
604	173	169	186500000	rejected	2023-01-13 16:24:49
605	203	80	130700000	rejected	2023-02-25 09:33:45
606	150	280	390000000	approved	2023-07-05 03:34:05
607	51	270	194500000	approved	2023-01-31 08:38:57
608	257	321	209200000	approved	2023-06-03 22:46:22
609	247	348	195500000	rejected	2022-11-06 19:38:35
610	209	65	139700000	rejected	2023-03-21 13:19:49
611	19	186	1574500000	approved	2023-08-01 23:18:43
612	229	23	546200000	rejected	2023-05-04 04:19:57
613	467	178	223800000	rejected	2023-01-27 23:19:09
614	57	2	175000000	rejected	2023-07-05 08:39:16
615	367	230	235000000	rejected	2023-03-20 00:09:36
616	172	262	209000000	rejected	2023-02-11 03:59:38
617	366	12	111000000	rejected	2023-03-09 04:35:59
618	27	224	111500000	approved	2022-11-19 01:35:52
619	349	303	224500000	rejected	2023-06-16 05:04:11
620	313	136	1166000000	rejected	2023-08-11 20:59:10
621	258	50	190000000	rejected	2022-10-30 20:39:00
622	209	104	136700000	rejected	2023-03-18 13:19:49
623	158	116	200500000	rejected	2023-05-17 17:31:18
624	72	363	529500000	rejected	2023-04-28 10:09:37
625	411	180	197000000	rejected	2023-04-26 05:50:09
626	333	47	1537000000	rejected	2023-05-22 05:13:15
627	412	196	1369500000	approved	2023-02-08 05:41:03
628	174	15	180100000	rejected	2023-02-10 03:15:08
629	206	152	801500000	approved	2023-04-27 12:44:13
630	347	42	102900000	approved	2023-06-21 05:58:37
631	77	11	90100000	rejected	2023-08-05 20:23:06
632	86	328	1203500000	rejected	2023-06-16 06:30:24
633	95	154	742000000	approved	2023-02-04 19:33:17
634	437	306	1489000000	approved	2023-06-06 00:10:52
635	302	400	744500000	rejected	2023-07-23 05:11:35
636	136	4	1325000000	approved	2022-11-02 04:45:01
637	106	64	1609500000	rejected	2023-01-01 19:00:19
638	212	256	166700000	rejected	2023-02-21 00:23:24
639	286	92	653500000	approved	2023-01-17 15:08:25
640	174	48	165100000	rejected	2023-02-08 03:15:08
641	115	99	173000000	approved	2023-05-03 23:12:40
642	488	66	189000000	rejected	2022-12-02 03:06:12
643	355	302	244800000	rejected	2022-12-24 03:20:31
644	431	382	349900000	rejected	2023-01-27 12:40:37
645	476	86	191500000	approved	2023-04-25 12:47:20
646	463	176	139200000	rejected	2023-05-08 01:39:11
647	326	247	188500000	rejected	2023-02-22 02:36:50
648	2	167	137500000	rejected	2023-03-20 07:34:15
649	14	217	855500000	rejected	2022-11-25 18:37:51
650	497	294	169000000	rejected	2023-01-28 22:09:21
651	375	285	1403500000	approved	2023-03-27 21:52:45
652	108	135	463100000	rejected	2022-09-21 07:59:40
653	455	342	231300000	approved	2023-04-11 14:09:19
654	8	14	758000000	approved	2023-03-15 19:25:47
655	54	283	223000000	rejected	2023-03-28 00:08:04
656	407	25	264000000	rejected	2023-04-06 14:40:58
657	154	164	1300000000	rejected	2022-12-23 09:21:53
658	313	265	1289000000	rejected	2023-08-10 20:59:10
659	107	157	469000000	rejected	2023-05-08 12:49:43
660	221	264	173500000	rejected	2023-01-12 16:33:27
661	154	200	1423000000	rejected	2022-12-20 09:21:53
662	176	219	436000000	rejected	2023-03-14 07:12:13
663	166	157	80000000	rejected	2023-03-25 11:43:50
664	229	274	639200000	approved	2023-05-07 04:19:57
665	251	168	120000000	rejected	2023-02-07 10:57:37
666	364	350	257500000	rejected	2022-11-15 19:27:03
667	65	391	475000000	rejected	2023-03-17 12:06:11
668	460	363	169000000	rejected	2022-12-23 10:33:29
669	379	19	729500000	rejected	2022-10-19 05:54:02
670	297	60	203000000	approved	2023-02-05 09:00:39
671	346	191	120000000	approved	2023-04-25 06:10:51
672	381	55	5213000000	rejected	2022-11-21 03:37:12
673	94	44	101500000	approved	2022-10-16 03:55:46
674	189	61	113500000	rejected	2023-03-11 15:22:50
675	47	113	162100000	rejected	2023-03-16 17:27:21
676	188	369	134800000	approved	2022-10-30 00:59:19
677	315	182	260100000	approved	2023-04-07 12:50:59
678	291	173	316500000	approved	2023-04-18 02:02:58
679	443	369	147800000	rejected	2023-03-02 01:15:41
680	4	329	229000000	rejected	2023-03-05 05:43:22
681	268	350	1359000000	approved	2022-12-25 01:40:25
682	208	264	128700000	rejected	2023-01-26 02:06:19
683	289	185	422900000	rejected	2023-01-20 23:15:32
684	111	311	413900000	rejected	2022-12-08 16:10:14
685	211	191	1344000000	rejected	2023-01-15 06:03:59
686	260	104	84500000	approved	2023-03-17 02:44:57
687	382	64	1183000000	rejected	2022-09-23 01:48:22
688	286	301	673000000	rejected	2023-01-17 15:08:25
689	97	41	158000000	rejected	2023-01-04 23:52:50
690	22	358	217000000	approved	2022-12-24 14:36:15
691	474	233	106000000	approved	2023-02-14 21:22:17
692	363	135	224500000	approved	2022-11-28 02:35:46
693	406	267	1412500000	rejected	2022-12-21 13:19:21
694	188	158	121300000	rejected	2022-10-30 00:59:19
695	150	107	381000000	approved	2023-07-09 03:34:05
696	163	390	272000000	rejected	2023-01-27 17:54:07
697	167	335	130000000	rejected	2023-02-28 01:32:45
698	231	123	203500000	rejected	2023-01-15 00:32:23
699	193	93	148500000	rejected	2023-01-03 22:16:49
700	420	118	282500000	rejected	2023-04-08 22:54:04
701	169	142	4817000000	rejected	2023-03-23 19:31:34
702	222	256	407500000	rejected	2022-08-31 01:56:12
703	270	34	177200000	rejected	2022-12-16 16:17:18
704	468	85	1536000000	rejected	2023-01-11 04:31:26
705	73	185	908500000	rejected	2022-09-29 12:20:30
706	422	285	874500000	approved	2023-04-05 00:53:30
707	50	107	224500000	approved	2022-08-20 17:22:53
708	229	290	553700000	rejected	2023-05-02 04:19:57
709	9	163	99000000	approved	2023-05-15 23:54:51
710	3	328	451500000	approved	2022-11-21 06:04:13
711	184	88	116000000	approved	2022-11-13 03:43:50
712	459	187	193500000	rejected	2023-02-18 09:44:05
713	129	376	97000000	rejected	2022-11-11 18:46:05
714	307	106	126000000	approved	2023-01-07 23:22:59
715	371	285	554500000	rejected	2023-03-28 14:22:21
716	312	141	98500000	approved	2023-05-05 17:12:40
717	103	282	168200000	approved	2023-04-05 17:08:59
718	330	291	1342500000	approved	2023-03-30 20:14:47
719	253	228	452500000	rejected	2023-06-15 13:24:49
720	68	245	128500000	approved	2023-07-22 07:24:36
721	344	46	382000000	rejected	2023-03-13 02:24:57
722	221	225	182500000	approved	2023-01-08 16:33:27
723	30	23	199000000	rejected	2022-12-23 19:43:09
724	47	9	181600000	rejected	2023-03-13 17:27:21
725	222	36	385000000	rejected	2022-08-29 01:56:12
726	27	386	119000000	rejected	2022-11-19 01:35:52
727	475	57	367900000	rejected	2022-10-21 05:08:23
728	487	333	133000000	approved	2023-07-22 12:11:45
729	317	296	111900000	rejected	2023-03-21 05:34:52
730	290	274	431500000	approved	2023-04-03 09:12:51
731	194	290	1165000000	rejected	2023-04-13 03:25:12
732	250	95	196000000	approved	2023-05-11 01:25:02
733	241	251	169500000	rejected	2023-01-16 14:15:19
734	422	304	913500000	approved	2023-04-02 00:53:30
735	110	336	409500000	rejected	2023-02-09 02:41:17
736	61	72	343000000	approved	2023-01-19 14:42:53
737	49	389	118100000	approved	2022-11-10 13:27:07
738	230	32	2066000000	approved	2023-02-13 04:35:47
739	268	249	1405500000	rejected	2022-12-24 01:40:25
740	476	121	193000000	rejected	2023-04-19 12:47:20
741	459	132	186000000	rejected	2023-02-23 09:44:05
742	309	189	1653000000	rejected	2023-03-20 16:50:22
743	295	50	109100000	rejected	2023-05-25 17:18:17
744	345	370	187000000	approved	2023-04-28 10:01:46
745	235	13	108000000	rejected	2023-06-10 03:34:37
746	467	95	249300000	rejected	2023-01-25 23:19:09
747	224	217	156100000	rejected	2023-04-14 14:49:41
748	469	51	119600000	approved	2023-05-11 09:25:22
749	374	78	894000000	rejected	2022-12-04 01:49:25
750	193	325	154500000	approved	2022-12-31 22:16:49
751	184	80	111500000	approved	2022-11-15 03:43:50
752	439	175	849700000	rejected	2023-06-20 16:26:43
753	109	331	103100000	rejected	2022-10-15 23:33:49
754	391	271	276500000	rejected	2022-10-23 06:39:27
755	252	113	1505500000	approved	2023-01-07 22:05:34
756	280	334	242500000	rejected	2022-12-26 18:33:51
757	355	11	256800000	approved	2022-12-23 03:20:31
758	391	389	293000000	rejected	2022-10-19 06:39:27
759	144	63	1481500000	rejected	2023-06-08 15:38:43
760	418	27	118100000	rejected	2023-02-26 12:54:39
761	335	388	1424500000	rejected	2022-12-14 15:46:51
762	139	74	477500000	rejected	2023-05-04 02:53:25
763	253	366	430000000	rejected	2023-06-15 13:24:49
764	91	80	785000000	rejected	2022-09-07 04:16:18
765	71	290	861500000	rejected	2022-10-12 07:12:26
766	370	87	90500000	rejected	2023-01-17 16:35:04
767	270	209	174200000	rejected	2022-12-13 16:17:18
768	12	83	143500000	rejected	2022-10-19 05:46:53
769	50	53	224500000	rejected	2022-08-17 17:22:53
770	184	263	122000000	rejected	2022-11-15 03:43:50
771	158	48	202000000	rejected	2023-05-11 17:31:18
772	149	349	500500000	rejected	2023-02-08 03:53:55
773	334	248	300500000	rejected	2022-09-15 08:58:33
774	189	24	101500000	approved	2023-03-10 15:22:50
775	433	173	607000000	rejected	2023-06-16 07:07:13
776	130	327	1170000000	rejected	2023-05-03 16:04:19
777	69	309	103000000	rejected	2023-06-02 03:33:14
778	184	104	111500000	approved	2022-11-14 03:43:50
779	284	242	904000000	rejected	2022-12-08 12:44:54
780	120	146	161300000	rejected	2022-11-14 15:49:30
781	94	120	113500000	rejected	2022-10-16 03:55:46
782	42	356	449600000	rejected	2023-05-08 20:33:14
783	57	231	161500000	rejected	2023-07-10 08:39:16
784	229	354	550700000	rejected	2023-05-07 04:19:57
785	117	258	89600	approved	2023-06-20 12:44:31
786	9	265	97500000	rejected	2023-05-11 23:54:51
787	207	382	394000000	rejected	2023-08-13 08:43:36
788	375	223	1619500000	approved	2023-03-31 21:52:45
789	111	363	410900000	rejected	2022-12-08 16:10:14
790	270	69	184700000	rejected	2022-12-13 16:17:18
791	281	60	776200000	rejected	2023-03-29 06:47:00
792	485	237	206500000	rejected	2023-04-24 21:46:57
793	259	332	202500000	rejected	2023-07-08 21:59:11
794	412	296	1267500000	rejected	2023-02-07 05:41:03
795	153	349	184000000	rejected	2023-03-01 07:03:08
796	97	341	176000000	rejected	2023-01-05 23:52:50
797	66	193	145000000	rejected	2022-08-24 22:41:02
798	207	57	397000000	approved	2023-08-15 08:43:36
799	162	120	103000000	rejected	2023-02-03 06:16:14
800	301	386	113500000	rejected	2023-01-17 17:05:02
801	265	51	173000000	rejected	2023-04-20 12:10:31
802	108	374	469100000	rejected	2022-09-20 07:59:40
803	142	116	485000000	rejected	2022-08-21 10:23:08
804	161	93	335500000	rejected	2023-01-06 09:26:24
805	232	286	416500000	rejected	2023-05-04 15:42:00
806	57	151	152500000	rejected	2023-07-11 08:39:16
807	451	202	242500000	rejected	2022-10-27 12:26:20
808	57	391	155500000	approved	2023-07-11 08:39:16
809	360	391	232000000	approved	2022-10-04 08:57:21
810	391	349	305000000	approved	2022-10-22 06:39:27
811	42	249	451100000	approved	2023-05-02 20:33:14
812	70	270	704700000	rejected	2023-04-17 13:29:42
813	356	388	816500000	approved	2022-10-16 14:39:06
814	471	231	1243500000	approved	2023-05-30 12:20:56
815	300	380	1285500000	rejected	2022-10-24 02:53:11
816	393	23	821200000	approved	2023-04-18 09:06:48
817	398	382	193000000	rejected	2022-10-18 15:01:21
818	139	41	452000000	rejected	2023-05-03 02:53:25
819	465	217	493000000	rejected	2023-04-20 23:09:28
820	418	58	107600000	rejected	2023-02-28 12:54:39
821	13	90	718000000	approved	2023-03-23 09:49:15
822	121	318	103100000	approved	2023-04-27 12:07:19
823	213	219	306500000	rejected	2023-05-12 00:36:04
824	284	327	887500000	rejected	2022-12-09 12:44:54
825	296	302	133200000	approved	2023-05-15 21:41:55
826	192	348	101500000	rejected	2023-06-18 16:08:11
827	363	289	197500000	rejected	2022-11-22 02:35:46
828	334	271	306500000	approved	2022-09-16 08:58:33
829	23	105	720500000	rejected	2023-05-30 21:49:24
830	48	99	115500000	rejected	2023-07-14 14:18:47
831	173	123	197000000	approved	2023-01-11 16:24:49
832	95	117	734500000	approved	2023-01-31 19:33:17
833	337	96	460000000	rejected	2023-05-16 17:55:52
834	290	213	440500000	rejected	2023-04-04 09:12:51
835	318	317	286000000	approved	2023-03-25 12:10:48
836	11	337	115500000	rejected	2023-01-17 01:42:38
837	366	247	105000000	approved	2023-03-12 04:35:59
838	412	280	1330500000	rejected	2023-02-06 05:41:03
839	423	33	770000000	rejected	2023-01-19 05:34:22
840	349	84	226000000	rejected	2023-06-11 05:04:11
841	22	22	227500000	approved	2022-12-28 14:36:15
842	137	232	101500000	rejected	2023-04-05 13:58:48
843	73	32	920500000	rejected	2022-10-04 12:20:30
844	37	203	770500000	rejected	2023-05-14 16:18:01
845	54	304	214000000	rejected	2023-03-26 00:08:04
846	463	165	148200000	rejected	2023-05-13 01:39:11
847	127	124	103100000	approved	2022-11-14 10:52:36
848	340	331	192900000	rejected	2023-06-18 14:31:25
849	400	216	752000000	rejected	2023-04-05 13:22:57
850	37	294	694000000	rejected	2023-05-10 16:18:01
851	62	217	99900000	approved	2023-01-23 03:46:02
852	464	365	1863000000	rejected	2023-06-16 10:21:11
853	473	297	142200000	rejected	2023-04-10 14:49:04
854	110	330	400500000	approved	2023-02-08 02:41:17
855	164	322	154000000	rejected	2022-10-13 08:59:28
856	205	369	557500000	rejected	2023-06-23 05:39:22
857	183	258	105500000	rejected	2023-03-14 01:39:18
858	191	272	185500000	approved	2022-12-21 04:45:52
859	277	119	154600000	approved	2023-03-14 11:04:05
860	35	236	91000000	rejected	2023-04-12 15:15:45
861	418	237	109100000	rejected	2023-02-28 12:54:39
862	50	386	208000000	rejected	2022-08-20 17:22:53
863	194	253	1039000000	rejected	2023-04-15 03:25:12
864	400	332	687500000	approved	2023-04-06 13:22:57
865	180	169	1610500000	rejected	2023-03-13 17:16:36
866	129	262	95500000	rejected	2022-11-14 18:46:05
867	396	365	204000000	rejected	2023-01-17 15:08:24
868	165	349	169700000	rejected	2023-02-17 06:05:12
869	8	332	734000000	approved	2023-03-12 19:25:47
870	214	238	721000000	approved	2022-12-13 19:15:44
871	84	195	261600000	approved	2023-01-23 20:10:23
872	14	339	828500000	approved	2022-11-24 18:37:51
873	268	302	1393500000	approved	2022-12-28 01:40:25
874	352	282	389000000	approved	2023-03-03 04:49:57
875	176	208	439000000	rejected	2023-03-13 07:12:13
876	182	255	191500000	rejected	2023-04-29 02:58:15
877	386	76	798500000	approved	2022-11-18 02:54:35
878	405	41	315500000	rejected	2023-01-22 18:53:10
879	78	149	87500000	rejected	2023-04-18 22:35:54
880	298	103	124700000	rejected	2023-01-26 20:21:41
881	227	79	100000000	rejected	2023-04-20 10:23:06
882	325	204	163500000	rejected	2022-12-19 02:12:27
883	35	260	95500000	rejected	2023-04-17 15:15:45
884	369	141	1213500000	approved	2022-11-12 04:30:29
885	193	57	166500000	rejected	2023-01-06 22:16:49
886	418	339	101600000	rejected	2023-03-01 12:54:39
887	241	46	159000000	rejected	2023-01-16 14:15:19
888	216	341	122500000	approved	2023-04-08 11:13:26
889	77	123	97600000	rejected	2023-07-31 20:23:06
890	443	378	164300000	approved	2023-02-28 01:15:41
891	222	93	361000000	rejected	2022-08-29 01:56:12
892	126	282	166500000	approved	2023-02-13 09:50:43
893	303	332	505000000	rejected	2022-12-23 09:46:11
894	194	347	1217500000	rejected	2023-04-13 03:25:12
895	153	340	197500000	rejected	2023-03-01 07:03:08
896	254	241	1653000000	approved	2023-01-30 10:32:24
897	105	326	88000000	rejected	2023-01-07 00:56:18
898	229	127	637700000	rejected	2023-05-05 04:19:57
899	365	172	792500000	rejected	2022-11-29 11:08:34
900	414	305	598700000	rejected	2022-12-19 07:41:19
901	264	116	806000000	rejected	2023-02-16 22:19:34
902	59	268	732500000	rejected	2023-02-13 16:43:37
903	175	319	106500000	rejected	2023-06-04 01:46:15
904	442	320	121300000	rejected	2023-04-26 01:43:24
905	327	198	244800000	rejected	2022-12-13 17:45:19
906	137	88	109000000	rejected	2023-04-07 13:58:48
907	169	353	4913000000	rejected	2023-03-21 19:31:34
908	350	365	197000000	rejected	2023-01-16 02:43:06
909	304	371	173500000	rejected	2023-01-07 07:36:06
910	228	19	522000000	approved	2023-03-20 11:50:51
911	265	34	177500000	rejected	2023-04-19 12:10:31
912	297	178	207500000	rejected	2023-02-10 09:00:39
913	303	391	469000000	rejected	2022-12-19 09:46:11
914	32	185	222300000	rejected	2023-01-29 11:54:11
915	34	375	4213500000	rejected	2022-09-04 13:22:09
916	148	291	149700000	approved	2022-11-23 12:42:01
917	115	224	161000000	approved	2023-04-30 23:12:40
918	390	112	221500000	approved	2023-03-10 23:41:34
919	147	399	722000000	approved	2023-05-20 05:22:22
920	431	100	376900000	rejected	2023-01-23 12:40:37
921	256	156	76000	rejected	2023-04-18 15:52:36
922	450	256	409500000	rejected	2023-01-19 15:55:49
923	417	16	1284000000	rejected	2023-05-10 18:48:59
924	460	263	185500000	rejected	2022-12-27 10:33:29
925	186	23	231700000	approved	2023-03-30 17:30:17
926	214	49	770500000	rejected	2022-12-08 19:15:44
927	489	90	153800000	rejected	2023-06-23 05:22:48
928	460	269	173500000	rejected	2022-12-23 10:33:29
929	120	363	146300000	rejected	2022-11-09 15:49:30
930	327	91	228300000	rejected	2022-12-16 17:45:19
931	427	314	196000000	rejected	2023-05-24 19:49:11
932	452	301	1819500000	approved	2023-04-11 08:52:08
933	101	63	756000000	rejected	2023-03-22 10:38:49
934	204	374	299000000	rejected	2023-02-03 05:37:44
935	208	326	142200000	rejected	2023-01-26 02:06:19
936	139	19	453500000	rejected	2023-05-07 02:53:25
937	358	391	550700000	approved	2023-05-20 05:34:12
938	22	173	236500000	rejected	2022-12-25 14:36:15
939	204	279	308000000	rejected	2023-02-03 05:37:44
940	15	164	2465500000	rejected	2023-07-01 19:32:04
941	214	236	736000000	rejected	2022-12-11 19:15:44
942	115	252	179000000	approved	2023-05-02 23:12:40
943	403	69	324000000	rejected	2023-08-08 19:03:24
944	118	261	125500000	approved	2022-11-11 12:36:59
945	141	200	284000000	rejected	2023-01-26 14:22:06
946	403	173	325500000	rejected	2023-08-07 19:03:24
947	194	289	1042000000	rejected	2023-04-18 03:25:12
948	351	207	4033500000	rejected	2022-11-19 18:16:38
949	230	244	2342000000	rejected	2023-02-17 04:35:47
950	17	324	168800000	approved	2022-11-08 12:31:41
951	262	256	279000000	rejected	2023-03-05 14:07:35
952	347	390	110400000	approved	2023-06-24 05:58:37
953	213	90	321500000	rejected	2023-05-11 00:36:04
954	459	27	169500000	approved	2023-02-20 09:44:05
955	160	43	1196000000	approved	2022-11-13 14:24:12
956	166	120	92000000	approved	2023-03-30 11:43:50
957	487	314	133000000	approved	2023-07-26 12:11:45
958	425	50	467600000	rejected	2023-07-06 22:30:19
959	159	28	110600000	rejected	2023-02-09 08:49:59
960	468	135	1513500000	rejected	2023-01-16 04:31:26
961	134	334	425500000	approved	2023-05-21 07:52:59
962	92	143	1731000000	approved	2023-05-02 14:11:56
963	422	346	913500000	rejected	2023-04-06 00:53:30
964	83	209	127000000	rejected	2023-04-10 07:45:51
965	170	197	1126000000	rejected	2023-02-17 07:47:31
966	179	144	127500000	rejected	2022-09-10 02:12:10
967	359	238	795000000	rejected	2023-04-20 09:33:19
968	64	318	158300000	rejected	2023-05-12 06:12:50
969	152	135	187500000	rejected	2023-06-15 02:58:28
970	11	10	118500000	rejected	2023-01-19 01:42:38
971	224	115	136600000	rejected	2023-04-13 14:49:41
972	454	91	1735500000	rejected	2023-01-09 08:43:03
973	41	135	80000000	rejected	2022-11-03 18:41:46
974	63	6	253500000	rejected	2023-02-27 04:58:28
975	458	289	364500000	approved	2023-06-23 04:49:24
976	27	165	108500000	rejected	2022-11-15 01:35:52
977	227	177	116500000	approved	2023-04-22 10:23:06
978	381	349	5210000000	rejected	2022-11-23 03:37:12
979	407	264	252000000	approved	2023-04-04 14:40:58
980	198	353	411000000	rejected	2023-02-09 05:04:22
981	285	42	112700000	approved	2022-11-22 16:19:22
982	186	1	209200000	approved	2023-03-30 17:30:17
983	329	258	793000000	approved	2023-05-02 11:26:25
984	210	53	200500000	rejected	2023-04-09 13:13:48
985	211	114	1461000000	rejected	2023-01-12 06:03:59
986	4	162	197500000	rejected	2023-03-01 05:43:22
987	405	240	294500000	rejected	2023-01-22 18:53:10
988	414	99	555200000	rejected	2022-12-22 07:41:19
989	50	368	241000000	approved	2022-08-20 17:22:53
990	23	41	762500000	approved	2023-05-25 21:49:24
991	401	390	185400000	rejected	2022-12-23 22:35:07
992	115	114	164000000	approved	2023-05-03 23:12:40
993	350	265	197000000	rejected	2023-01-12 02:43:06
994	408	355	98500000	rejected	2023-03-19 04:24:59
995	418	161	118100000	rejected	2023-02-26 12:54:39
996	255	292	271500000	approved	2023-07-17 14:04:20
997	394	303	259500000	rejected	2023-05-16 16:21:43
998	404	187	452500000	rejected	2023-05-10 10:11:45
999	149	23	518500000	rejected	2023-02-11 03:53:55
1000	372	40	119800000	rejected	2023-01-06 07:14:35
1002	123	269	150000000	sent	2023-09-05 14:30:00
\.


--
-- TOC entry 3393 (class 0 OID 27558)
-- Dependencies: 214
-- Data for Name: body_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.body_types (body_type_id, body_type_name) FROM stdin;
BT-001	Convertible
BT-002	Crossover
BT-003	Double Cabin
BT-004	Elektrik
BT-005	Hatchback
BT-006	Hybrid
BT-007	LCGC
BT-008	MPV
BT-009	Offroad
BT-010	SUV
BT-011	Sedan
BT-012	Sport
BT-013	Station Wagon
\.


--
-- TOC entry 3396 (class 0 OID 27584)
-- Dependencies: 217
-- Data for Name: cars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cars (car_id, manufacture_id, model_id, body_type_id, year_manufactured, engine_capacity, passenger_capacity, transmission_type, fuel_type, drive_system, odometer, additional_details) FROM stdin;
1	M-03	CM0048	BT-007	2017	1.2	5	automatic	diesel	AWD	28847	Necessitatibus tenetur commodi. Quia adipisci aspernatur iure vitae. Unde quos laborum culpa architecto fuga.
2	M-02	CM0023	BT-012	2018	3.0	4	automatic	diesel	AWD	25342	Ab architecto quo inventore repudiandae.
3	M-02	CM0023	BT-012	2020	3.0	4	manual	gasoline	RWD	27897	Dolorum fuga impedit neque minima cum harum. Nulla saepe esse laboriosam distinctio sed.
4	M-10	CM0033	BT-013	2021	3.0	5	automatic	diesel	RWD	38503	Rem ducimus recusandae sequi quis sint officiis minus. Ea sit ipsum facilis animi consequuntur. Iste dolor veritatis mollitia.
5	M-15	CM0034	BT-009	2017	1.5	4	manual	diesel	FWD	100850	Voluptatibus quibusdam est iure accusantium. Dolores accusantium in voluptates. Quia quae nulla tempore quidem.
6	M-11	CM0031	BT-013	2016	2.0	5	manual	diesel	AWD	8481	Illo numquam inventore fugit deserunt est. Cupiditate veniam alias quas rem. Dignissimos necessitatibus repellendus quidem recusandae quod est laborum.
7	M-02	CM0027	BT-001	2019	3.0	2	manual	gasoline	RWD	31222	Cumque voluptas sapiente vel sequi aliquid inventore. Eveniet iure ullam perspiciatis. Ut facilis quas voluptas.
8	M-03	CM0048	BT-007	2019	1.2	5	manual	gasoline	AWD	89301	Cumque distinctio ex quae. Minus totam at voluptatum eius quasi nesciunt. Ex dolore possimus.
9	M-06	CM0042	BT-004	2023	0	5	automatic	electric	RWD	62811	Non veniam aliquam enim nesciunt omnis. Repellendus architecto laborum ea exercitationem. Asperiores reiciendis dolores eligendi.
10	M-09	CM0012	BT-002	2019	2.0	5	automatic	gasoline	AWD	64887	Inventore distinctio recusandae veritatis natus perspiciatis cumque at. Totam qui tempore aut cupiditate facere.
11	M-17	CM0047	BT-007	2016	1.2	5	automatic	diesel	RWD	22920	Culpa magni nisi consequuntur enim. Rerum magni culpa animi cumque.
12	M-17	CM0038	BT-003	2012	2.5	5	automatic	diesel	AWD	28340	Rerum dignissimos cum ipsa. Praesentium enim eligendi est esse.
13	M-13	CM0044	BT-006	2023	1.2	5	automatic	hybrid	RWD	104449	Enim laborum aliquam labore iure quos. Nobis mollitia nulla quasi.
14	M-05	CM0017	BT-005	2006	1.5	5	automatic	diesel	AWD	112255	Vero alias neque consequuntur.
15	M-03	CM0048	BT-007	2021	1.2	5	automatic	diesel	AWD	119764	Ab harum eligendi illum fugiat cupiditate molestias aperiam. Quaerat quis itaque placeat. Dolorum enim incidunt molestias commodi molestias maxime repudiandae.
16	M-17	CM0015	BT-005	2017	1.5	5	manual	gasoline	RWD	14467	Possimus totam officia occaecati eos rem sed. Necessitatibus inventore quam magnam.
17	M-17	CM0006	BT-008	2015	1.5	7	manual	gasoline	AWD	4309	Officiis placeat voluptas. Inventore nulla sint fuga dolore. Incidunt dolorem voluptatum molestias excepturi excepturi.
18	M-05	CM0017	BT-005	2008	1.5	5	manual	gasoline	AWD	108451	Aliquid voluptates atque recusandae. Eaque ratione aspernatur perspiciatis eius veniam totam. Eum eum suscipit voluptas.
19	M-17	CM0045	BT-006	2017	2.5	5	automatic	hybrid	AWD	113473	Hic voluptates necessitatibus voluptatem. Consectetur consequuntur corrupti quae explicabo eum. Ratione est itaque voluptatem tenetur.
20	M-09	CM0016	BT-005	2017	1.5	5	manual	diesel	AWD	57039	Rerum laborum voluptates illo fugit. Illum voluptatibus quos repudiandae esse minus assumenda.
21	M-17	CM0038	BT-003	2012	2.5	5	automatic	gasoline	AWD	90031	Non minus in saepe. Sequi molestiae repellendus iste.
22	M-01	CM0025	BT-012	2023	3.0	4	manual	diesel	AWD	87730	Itaque neque eaque vel iure. Rem similique vero at at eos ex.
23	M-13	CM0011	BT-002	2011	1.5	5	manual	diesel	RWD	16305	Nesciunt maiores tenetur illum odio ad quod. Facilis quibusdam ipsa nisi libero.
24	M-05	CM0022	BT-012	2018	2.0	4	manual	diesel	RWD	58263	Voluptates exercitationem fugiat provident. Ipsam voluptatem maiores mollitia voluptatibus deleniti quo. Minima dignissimos quasi atque in culpa.
25	M-17	CM0015	BT-005	2017	1.5	5	manual	gasoline	RWD	15468	Modi repudiandae similique quisquam esse neque. Vero occaecati quibusdam voluptatibus cupiditate commodi. Aut eum nulla voluptates quae accusantium architecto.
26	M-17	CM0038	BT-003	2014	2.5	5	manual	diesel	RWD	38503	Quidem adipisci amet fugit. Architecto vel voluptatibus sapiente eos deserunt deserunt. Rerum quisquam aliquid eaque fugiat.
27	M-10	CM0037	BT-009	2016	5.5	4	manual	diesel	FWD	44172	Laboriosam nam ullam recusandae. Hic provident quo reprehenderit repellat beatae eaque quo. Explicabo dignissimos veritatis excepturi eos laboriosam. Quis officiis nulla laudantium omnis impedit natus.
28	M-15	CM0014	BT-005	2019	1.4	5	automatic	diesel	RWD	74665	Architecto cumque cupiditate ex ea. Assumenda suscipit vitae neque quia temporibus.
29	M-02	CM0023	BT-012	2020	3.0	4	automatic	diesel	AWD	71501	Iste pariatur necessitatibus reiciendis quae voluptas. Dolorum repellendus vel corrupti incidunt distinctio. Quo nesciunt in perferendis.
30	M-19	CM0043	BT-004	2022	0	5	automatic	electric	RWD	91854	Odit quia eveniet omnis eos cum rem. Ut harum eius corporis sunt fugiat.
31	M-17	CM0009	BT-008	2019	1.5	7	manual	diesel	RWD	45047	Reprehenderit esse odio pariatur quod tenetur veritatis. Iste nisi alias quos culpa nisi. Dolores temporibus mollitia pariatur dolores aliquam.
32	M-10	CM0033	BT-013	2019	3.0	5	manual	diesel	RWD	117628	Tenetur asperiores iste officiis sed. Neque consectetur ipsum quia odit enim.
33	M-09	CM0021	BT-011	2014	2.5	5	automatic	gasoline	AWD	129750	Cupiditate alias nobis libero odio et. Ut ipsa sed id velit expedita. Eius inventore delectus tempore odio praesentium.
34	M-17	CM0038	BT-003	2023	2.5	5	automatic	diesel	AWD	81846	Fugit sint modi quod. Ducimus molestias deserunt nemo facilis ad.
35	M-17	CM0018	BT-011	2012	1.8	5	automatic	gasoline	RWD	132104	Minima occaecati veniam velit. Provident atque aspernatur ad. Officia iure optio necessitatibus id iusto quibusdam.
36	M-10	CM0037	BT-009	2019	5.5	4	automatic	gasoline	FWD	104627	Iste praesentium consectetur dolorum nisi. Veniam nisi quod non neque labore iste praesentium. Quos quae deleniti iste amet culpa sint esse.
37	M-03	CM0048	BT-007	2021	1.2	5	automatic	gasoline	RWD	97881	Dicta harum quisquam iste. Aliquid maxime iure amet.
38	M-15	CM0014	BT-005	2019	1.4	5	manual	gasoline	RWD	51350	Voluptate sit vitae inventore enim quod debitis. Inventore quos dolores alias cumque. Aspernatur itaque optio aut provident.
39	M-03	CM0048	BT-007	2017	1.2	5	manual	diesel	RWD	27046	Quod magni quae maiores doloribus tempora ipsum. Veritatis hic officiis dolore magnam.
40	M-18	CM0032	BT-013	2020	2.0	5	manual	diesel	AWD	64689	Quidem dignissimos dignissimos. Debitis praesentium tempora voluptates at vero possimus. Porro eveniet laboriosam aliquid exercitationem consequuntur.
41	M-17	CM0004	BT-010	2019	2.4	5	manual	gasoline	RWD	104999	Itaque repellat odio eligendi eum. Adipisci amet ab asperiores. Libero perspiciatis impedit quos voluptas recusandae.
42	M-09	CM0012	BT-002	2019	2.0	5	automatic	gasoline	RWD	57503	Perferendis error deleniti qui est. Ut expedita perspiciatis explicabo possimus. Doloribus expedita eius veritatis suscipit assumenda.
43	M-03	CM0048	BT-007	2017	1.2	5	automatic	gasoline	AWD	2488	Nisi velit maiores necessitatibus quam iste. Temporibus facere eaque quos consectetur laboriosam. Quas laboriosam hic adipisci ad distinctio facere.
44	M-17	CM0019	BT-011	2021	1.4	5	automatic	gasoline	RWD	92380	Modi fugit omnis temporibus debitis consequuntur. Numquam impedit iure iusto atque ipsum quas. Dolore cumque eaque adipisci odit mollitia. Ipsa illo at sit cupiditate recusandae at.
45	M-10	CM0033	BT-013	2019	3.0	5	automatic	gasoline	AWD	65923	Minus provident ullam temporibus. Voluptatibus deleniti consectetur. Exercitationem ad voluptatum quas modi cupiditate.
46	M-05	CM0007	BT-008	2015	1.5	7	manual	diesel	RWD	131678	Cumque temporibus neque non. Ipsam et unde placeat nemo cumque assumenda.
47	M-03	CM0048	BT-007	2017	1.2	5	automatic	diesel	AWD	16466	Voluptates illo placeat commodi. Assumenda dolor est repellendus.
48	M-05	CM0007	BT-008	2015	1.5	7	manual	diesel	RWD	149745	Corporis porro culpa ratione fugit ducimus optio. Facere praesentium nesciunt id natus quisquam. Omnis at atque voluptates explicabo quisquam incidunt sed. Harum tempora reprehenderit corrupti laboriosam fuga.
49	M-05	CM0017	BT-005	2006	1.5	5	manual	gasoline	AWD	10838	Suscipit incidunt expedita inventore. Aliquid vel atque. Doloremque ab aut quos.
50	M-09	CM0012	BT-002	2019	2.0	5	automatic	diesel	AWD	7715	Vitae nesciunt distinctio rem quae. Aliquam asperiores eaque quibusdam quia. Eaque harum corrupti provident perferendis dolorem. Vel quo iure at itaque quis.
51	M-06	CM0042	BT-004	2021	0	5	automatic	electric	AWD	51836	Quos quidem iure adipisci sed fugit. Officiis eaque delectus a facilis expedita. Nam accusantium distinctio corporis.
52	M-07	CM0035	BT-009	2023	3.6	4	manual	gasoline	FWD	54902	Sint accusantium occaecati ab debitis aperiam aliquid tenetur. Voluptates quo aspernatur quibusdam.
53	M-19	CM0008	BT-008	2019	1.5	7	automatic	gasoline	RWD	78315	Minima quas beatae sit accusamus quaerat. Amet ad perspiciatis est facilis. Deserunt delectus nesciunt adipisci in. Enim dolores ducimus.
54	M-17	CM0019	BT-011	2021	1.4	5	automatic	gasoline	RWD	106884	Voluptates dolore id harum. Facere ipsa provident perspiciatis libero quaerat ipsam.
55	M-12	CM0010	BT-002	2020	1.5	5	manual	gasoline	AWD	118315	Placeat facere doloremque laudantium dolore dolorum similique. Ipsa magnam enim itaque voluptatibus temporibus. Consectetur quidem nemo quidem.
56	M-17	CM0018	BT-011	2018	1.8	5	manual	gasoline	RWD	82013	Minima eaque autem expedita provident ut porro. Nam vero maxime autem itaque debitis. Facere neque vero culpa nostrum.
57	M-13	CM0011	BT-002	2015	1.5	5	manual	gasoline	RWD	34979	Suscipit rerum magni eligendi maiores dolorum. Molestiae in animi voluptatibus quaerat fugit. Placeat ducimus a sint totam fugit.
58	M-05	CM0013	BT-005	2018	1.2	5	automatic	diesel	AWD	92854	Dolore exercitationem mollitia. Quisquam tenetur sit. Aliquid magni quisquam dolorem temporibus sint.
59	M-12	CM0040	BT-003	2022	2.5	5	automatic	gasoline	RWD	47704	Quia est dolor voluptate. Quia eveniet eveniet possimus harum. Vel officiis voluptatibus. Laudantium porro quas ut aliquid enim dicta.
60	M-18	CM0032	BT-013	2020	2.0	5	manual	gasoline	AWD	75475	Totam veniam animi ipsa odit esse.
61	M-10	CM0024	BT-012	2019	4.0	4	automatic	diesel	AWD	3961	Dolorum quidem tempore voluptate quasi animi. Ex aspernatur voluptatum vero quaerat doloremque. Nam iusto voluptatibus.
62	M-17	CM0004	BT-010	2017	2.4	5	automatic	gasoline	AWD	57336	Optio molestiae deserunt consequatur. Saepe minus repellendus ut esse nam. Ducimus non vel officia. Deserunt nobis repellendus vero quod esse dicta.
63	M-17	CM0015	BT-005	2017	1.5	5	automatic	gasoline	RWD	133939	Amet beatae minima architecto.
64	M-05	CM0022	BT-012	2018	2.0	4	manual	diesel	AWD	147719	Autem culpa veniam porro fugiat. Beatae optio a. Rem dolorum aliquid quidem dolorem natus veniam. Quam nostrum delectus.
65	M-10	CM0030	BT-001	2012	3.5	2	automatic	diesel	RWD	98069	Reiciendis sit laudantium ipsa minus nisi. Ducimus nihil repudiandae quidem ut sapiente.
66	M-17	CM0009	BT-008	2017	1.5	7	automatic	diesel	AWD	10928	Aliquam rem tempora perferendis laborum impedit distinctio. Voluptates dolorem vitae veritatis ut ex repellat quis.
67	M-07	CM0035	BT-009	2023	3.6	4	manual	diesel	FWD	66488	Eius id aperiam veniam ducimus possimus laborum.
68	M-07	CM0035	BT-009	2023	3.6	4	manual	diesel	FWD	71416	Molestiae maiores animi vero fuga.
69	M-02	CM0023	BT-012	2016	3.0	4	manual	gasoline	AWD	52474	Qui error hic placeat ex. Repudiandae eaque laboriosam explicabo accusantium minus.
70	M-10	CM0030	BT-001	2010	3.5	2	automatic	gasoline	RWD	141696	Iusto itaque beatae ipsa dolores id. Quo eius neque consequatur voluptates voluptates nostrum. Illum expedita voluptatum inventore.
71	M-05	CM0013	BT-005	2016	1.2	5	manual	diesel	RWD	78390	Dolorum nesciunt laborum itaque veniam natus laboriosam.
72	M-15	CM0034	BT-009	2021	1.5	4	manual	diesel	FWD	139921	Maiores accusantium cumque quos. Repudiandae dignissimos deleniti. Ratione facere est porro ex odio et ad. Culpa quas doloremque eligendi numquam.
73	M-03	CM0003	BT-010	2016	1.5	5	automatic	diesel	RWD	120151	Quas ipsa cupiditate aspernatur eius. Voluptas in iure eius numquam laudantium. Mollitia veritatis sequi ut quis ab.
74	M-02	CM0023	BT-012	2020	3.0	4	manual	diesel	AWD	1406	Sequi officiis occaecati eum perferendis. Laborum libero animi rem veniam. Iusto sequi eaque quasi odio rerum.
75	M-01	CM0025	BT-012	2013	3.0	4	manual	diesel	AWD	132927	Mollitia assumenda adipisci velit esse. Rem fuga numquam ab dolores laudantium. Unde quibusdam vero illum iste ut unde nihil.
76	M-11	CM0029	BT-001	2012	2.0	2	manual	gasoline	RWD	49408	Blanditiis magnam nihil sed voluptate eligendi. Incidunt doloremque ducimus quisquam voluptatem eaque possimus. Quia alias ullam sapiente quo velit.
77	M-17	CM0019	BT-011	2015	1.4	5	automatic	diesel	AWD	108406	Impedit officia sint accusamus beatae officiis numquam. Accusamus mollitia eaque. Nemo voluptas quidem placeat corrupti voluptatum.
78	M-04	CM0039	BT-003	2012	2.2	5	automatic	gasoline	RWD	131909	Deleniti id cumque quidem. Culpa delectus quasi iusto. Ullam tenetur minus cumque.
79	M-02	CM0023	BT-012	2016	3.0	4	automatic	diesel	RWD	101469	Odit tempore nam tenetur possimus doloremque. Tenetur blanditiis quo exercitationem optio.
80	M-17	CM0019	BT-011	2018	1.4	5	automatic	diesel	AWD	100782	Debitis tempora quia debitis iure corporis. Incidunt facilis dicta. Error aperiam hic alias porro similique.
81	M-10	CM0030	BT-001	2006	3.5	2	automatic	gasoline	RWD	55635	Consequatur quaerat incidunt numquam non. Ut quos quasi delectus quod rerum.
82	M-15	CM0005	BT-010	2018	1.2	5	automatic	diesel	RWD	77494	Porro tempore repellendus veniam. Reiciendis odit eaque architecto culpa maiores.
83	M-17	CM0047	BT-007	2022	1.2	5	manual	gasoline	RWD	64314	Reiciendis tempora quidem cupiditate aliquam quibusdam. Enim ipsa assumenda possimus eveniet.
84	M-12	CM0040	BT-003	2022	2.5	5	automatic	diesel	AWD	42608	Ratione autem labore modi. Non soluta corporis nihil neque perspiciatis odit. Nemo excepturi sint ad vel repellendus.
85	M-17	CM0047	BT-007	2022	1.2	5	manual	gasoline	RWD	64630	Assumenda eaque ipsa quidem quas.
86	M-15	CM0014	BT-005	2017	1.4	5	automatic	gasoline	AWD	125485	Hic quae eum suscipit accusamus repellat suscipit amet. Deleniti eum tempora nisi.
87	M-01	CM0025	BT-012	2014	3.0	4	manual	gasoline	RWD	78185	Eveniet sed debitis id. Iure autem quam veniam omnis. Ea odio accusantium reiciendis consequuntur quasi iusto.
88	M-03	CM0003	BT-010	2016	1.5	5	automatic	gasoline	RWD	2750	Sunt quam saepe consectetur ducimus nihil eveniet assumenda. Asperiores necessitatibus sed cumque. Consequuntur cumque minus expedita ipsum.
89	M-09	CM0016	BT-005	2018	1.5	5	automatic	diesel	RWD	4409	Hic magnam odit facere. Id eaque hic perferendis expedita eius ab minima.
90	M-13	CM0044	BT-006	2020	1.2	5	automatic	hybrid	RWD	75742	Assumenda perferendis quasi laborum. Exercitationem qui aperiam sit consequuntur culpa. Fuga iste iusto veritatis natus ipsum atque.
91	M-04	CM0039	BT-003	2022	2.2	5	automatic	diesel	AWD	93458	Quo laboriosam earum alias quod dolorem illo. Necessitatibus asperiores saepe veniam ea. Quaerat aut ipsam beatae unde qui.
92	M-13	CM0011	BT-002	2015	1.5	5	automatic	gasoline	AWD	120162	Iste nobis hic nisi. Delectus necessitatibus molestiae. Occaecati possimus rerum officiis tempora esse at. Aperiam laborum architecto velit ad.
93	M-16	CM0041	BT-004	2022	0	5	automatic	electric	RWD	136892	Corrupti ad veniam nesciunt rerum commodi. Incidunt ex occaecati amet nihil iusto voluptatibus.
94	M-16	CM0041	BT-004	2021	0	5	automatic	electric	RWD	126241	Ad numquam asperiores doloremque nam labore cupiditate. Ab recusandae voluptatem assumenda eum.
95	M-08	CM0036	BT-009	2016	2.2	4	manual	diesel	FWD	48847	Accusantium doloribus adipisci ut maiores natus ullam. Modi cupiditate doloremque quas in quos. Nesciunt quae porro consequatur dolor dolorum.
96	M-04	CM0039	BT-003	2012	2.2	5	manual	gasoline	RWD	62108	Eius quibusdam exercitationem. Dolor hic facilis minima culpa nulla sint.
97	M-04	CM0039	BT-003	2015	2.2	5	manual	diesel	AWD	89574	Suscipit veniam laudantium cumque. Doloribus repellendus quod facilis harum.
98	M-12	CM0010	BT-002	2020	1.5	5	automatic	gasoline	RWD	4505	Voluptas iusto perferendis alias magnam occaecati neque eaque. Quia rem natus velit.
99	M-02	CM0027	BT-001	2021	3.0	2	automatic	diesel	RWD	108306	Facilis recusandae odit aspernatur. Id blanditiis reprehenderit ex omnis voluptatibus. Enim magnam aut doloremque modi libero.
100	M-02	CM0027	BT-001	2019	3.0	2	automatic	diesel	RWD	87118	Libero aperiam magni quos nihil. Exercitationem vero commodi velit adipisci nihil possimus.
101	M-03	CM0003	BT-010	2016	1.5	5	manual	gasoline	AWD	135598	Non debitis cupiditate velit. Autem repellendus est voluptas velit soluta ipsum. Sequi laudantium natus commodi eius sequi.
102	M-12	CM0010	BT-002	2020	1.5	5	automatic	diesel	RWD	31897	Repellat quod repellat dicta eligendi. Voluptates doloribus inventore nihil quo. Ipsa debitis aperiam adipisci deleniti.
103	M-05	CM0007	BT-008	2020	1.5	7	automatic	diesel	RWD	22760	A voluptate debitis earum explicabo. Dolor in facilis nisi nam suscipit aperiam id. Vitae voluptas quas iure corporis expedita nihil.
104	M-15	CM0014	BT-005	2019	1.4	5	automatic	gasoline	RWD	6394	Sint in tenetur quisquam et. Et exercitationem saepe ipsam. Quae pariatur cumque iure soluta.
105	M-17	CM0009	BT-008	2019	1.5	7	manual	diesel	AWD	142376	Sequi dolorem provident voluptate. Impedit perferendis possimus accusamus. Dolorum eveniet atque suscipit ratione repellendus natus.
106	M-05	CM0001	BT-010	2016	1.5	5	automatic	diesel	AWD	118106	Magnam maxime alias dicta vero magnam est. Vel doloremque inventore facere quibusdam.
107	M-18	CM0032	BT-013	2022	2.0	5	automatic	gasoline	AWD	5576	Expedita at reprehenderit ullam. Voluptate sit sit necessitatibus. Qui ea ipsum atque voluptas odit.
108	M-03	CM0003	BT-010	2013	1.5	5	manual	gasoline	AWD	86998	Ut accusamus sunt iste quibusdam. Eos voluptas vero a.
109	M-17	CM0002	BT-010	2021	1.5	5	automatic	diesel	AWD	18308	Sequi quam incidunt debitis officia. Tenetur optio illo nihil cum totam vitae. Delectus quod quam neque.
110	M-18	CM0032	BT-013	2022	2.0	5	automatic	diesel	AWD	70913	Eveniet suscipit non commodi fugiat. Voluptatum aperiam ea illum quidem omnis animi. Atque fugiat voluptatibus rerum vero.
111	M-17	CM0015	BT-005	2017	1.5	5	manual	diesel	RWD	50359	Rerum quis quibusdam voluptas ratione. Libero in excepturi ipsam quasi. Rem placeat quam eius odit at maiores.
112	M-15	CM0046	BT-006	2021	1.5	5	automatic	hybrid	RWD	61225	Iure natus aut quo veritatis veniam. Est quam alias incidunt autem. Soluta laborum natus eum nihil.
113	M-05	CM0013	BT-005	2014	1.2	5	manual	gasoline	AWD	65221	Fugit iste sit esse. Necessitatibus dolorem voluptatibus pariatur minus debitis consequatur temporibus.
114	M-09	CM0012	BT-002	2018	2.0	5	manual	gasoline	AWD	46033	Odio in sed deleniti nihil consequatur. Suscipit a ipsum repellat excepturi quasi. Libero repellendus ipsum deleniti doloremque consequuntur.
115	M-12	CM0010	BT-002	2019	1.5	5	manual	diesel	AWD	80838	Aspernatur repudiandae mollitia maiores perferendis placeat. Nulla dolorem nihil temporibus aspernatur inventore.
116	M-17	CM0047	BT-007	2019	1.2	5	manual	gasoline	RWD	32761	Molestiae tempora aut optio corrupti enim aperiam. Debitis praesentium provident quia architecto. Neque eligendi dolores blanditiis soluta tempora veritatis.
117	M-17	CM0047	BT-007	2022	1.2	5	automatic	diesel	RWD	144629	Quia alias omnis cupiditate aliquid. In molestias est.
118	M-03	CM0048	BT-007	2017	1.2	5	automatic	gasoline	AWD	36347	Et necessitatibus nostrum. Quisquam et ab doloremque quos adipisci tempora. Nobis esse expedita impedit iusto.
119	M-05	CM0022	BT-012	2017	2.0	4	automatic	diesel	RWD	66021	Vel adipisci deleniti placeat minus. Quidem eos dolore. Culpa eum officiis perspiciatis provident. Ullam accusamus totam aut sed mollitia.
120	M-05	CM0022	BT-012	2017	2.0	4	automatic	gasoline	AWD	133418	Sunt aut veniam. Quasi suscipit assumenda culpa. Natus rem numquam sapiente.
121	M-12	CM0010	BT-002	2019	1.5	5	automatic	diesel	RWD	54108	Asperiores sapiente molestiae sed iusto quod. Iste dolor distinctio perspiciatis.
122	M-05	CM0013	BT-005	2014	1.2	5	automatic	gasoline	AWD	106297	Ipsum in molestias eveniet. Necessitatibus tenetur facilis fugit. Corporis nemo tempora maxime animi.
123	M-13	CM0044	BT-006	2021	1.2	5	automatic	hybrid	AWD	61620	Cumque eligendi rerum quam molestiae. Magnam ad sapiente labore quo iure in.
124	M-15	CM0034	BT-009	2017	1.5	4	manual	diesel	FWD	127034	Ea laborum ut. Ad laudantium possimus quia ducimus consequatur earum. Pariatur vel saepe asperiores temporibus.
125	M-18	CM0032	BT-013	2023	2.0	5	automatic	gasoline	AWD	27960	Iure fugiat veniam consequatur. Quas officia ducimus nisi. Aspernatur deserunt doloribus reprehenderit rem quod maiores. Deserunt deserunt in cupiditate labore in reprehenderit.
126	M-03	CM0003	BT-010	2016	1.5	5	manual	gasoline	AWD	75560	Maiores libero quam. Atque id maxime aliquam.
127	M-11	CM0031	BT-013	2016	2.0	5	automatic	diesel	RWD	40932	Accusantium animi assumenda soluta.
128	M-10	CM0033	BT-013	2020	3.0	5	automatic	diesel	AWD	109239	Id perferendis provident. Quae temporibus et veritatis occaecati fugit.
129	M-05	CM0022	BT-012	2017	2.0	4	automatic	gasoline	AWD	138370	Quia eaque cumque ad ipsum.
130	M-18	CM0032	BT-013	2022	2.0	5	manual	diesel	AWD	91895	Qui voluptatum eaque iusto. Aut praesentium vitae corporis maxime soluta. Facilis cum ipsum totam in.
131	M-05	CM0013	BT-005	2014	1.2	5	manual	diesel	AWD	32857	Ex ad doloremque assumenda suscipit sequi neque. Rerum rem et perspiciatis nobis eaque eos. Temporibus vero occaecati aperiam amet voluptatibus expedita quibusdam.
132	M-09	CM0016	BT-005	2018	1.5	5	manual	gasoline	RWD	117546	Saepe inventore praesentium eum harum. Fugit voluptatum corrupti.
133	M-06	CM0042	BT-004	2022	0	5	automatic	electric	RWD	22293	Nobis sequi quibusdam quisquam. Veniam aperiam molestiae ducimus. Porro mollitia accusamus est facere dolorum.
134	M-10	CM0033	BT-013	2021	3.0	5	manual	gasoline	RWD	134965	Distinctio eaque natus assumenda debitis. Repellendus nostrum modi possimus iste architecto recusandae.
135	M-17	CM0047	BT-007	2016	1.2	5	automatic	diesel	RWD	115100	Expedita rerum placeat qui corrupti reprehenderit eius. Recusandae atque laboriosam porro. Corporis dolorum consectetur mollitia mollitia. Corrupti doloribus autem sapiente in.
136	M-17	CM0038	BT-003	2012	2.5	5	automatic	gasoline	RWD	122396	Quasi nihil hic deserunt praesentium qui. Labore enim commodi excepturi. Quo fugit ea est.
137	M-17	CM0002	BT-010	2021	1.5	5	automatic	diesel	AWD	31939	Corrupti officia nisi eum nobis. Eveniet adipisci odio. Repellendus debitis vero reprehenderit dolor.
138	M-16	CM0041	BT-004	2021	0	5	automatic	electric	RWD	50005	Adipisci cum explicabo sit. Officiis autem inventore placeat rerum tempora. Corrupti impedit doloremque nesciunt consectetur ipsa.
139	M-04	CM0039	BT-003	2012	2.2	5	manual	diesel	AWD	61776	Vel fuga autem deleniti qui dolores. Ipsa quia quidem dolor. Temporibus dolore magni ipsa necessitatibus quas.
140	M-10	CM0024	BT-012	2019	4.0	4	automatic	gasoline	AWD	82839	Vitae dolores commodi ipsa maiores a quibusdam. Omnis quaerat reprehenderit doloremque. Tenetur deleniti tempora sed perferendis cupiditate quae.
141	M-06	CM0042	BT-004	2021	0	5	automatic	electric	RWD	115665	Qui vero praesentium debitis repudiandae repellendus sint minus. Architecto ut veniam voluptate voluptas facilis nisi. Deserunt veniam qui repellendus voluptate qui voluptatibus esse.
142	M-14	CM0026	BT-001	2018	2.0	2	manual	gasoline	AWD	49142	Itaque consequatur numquam repellendus neque doloribus. Tenetur ea magni beatae tempora blanditiis.
143	M-05	CM0007	BT-008	2015	1.5	7	manual	diesel	AWD	95918	Illo nihil incidunt tempore. Non recusandae aspernatur sed facilis explicabo. Omnis ut alias quasi sequi facilis vel ducimus.
144	M-19	CM0043	BT-004	2022	0	5	automatic	electric	RWD	105970	Quaerat labore minima. Provident voluptatibus earum porro molestiae eveniet.
145	M-08	CM0036	BT-009	2014	2.2	4	manual	gasoline	FWD	13901	Reiciendis animi beatae dolore dolorem distinctio laudantium porro. Nam amet asperiores magnam ad consequatur impedit autem. Provident alias eligendi in tempora facere dignissimos.
146	M-05	CM0001	BT-010	2016	1.5	5	automatic	diesel	RWD	27182	Labore amet deserunt mollitia aspernatur. Molestias eaque laborum in. Labore placeat doloremque in vero. Vitae omnis ab beatae explicabo in error.
147	M-17	CM0045	BT-006	2013	2.5	5	automatic	hybrid	AWD	149571	Molestiae eligendi impedit. Maxime nobis fugiat occaecati voluptate optio blanditiis.
148	M-12	CM0040	BT-003	2016	2.5	5	manual	diesel	RWD	90340	Architecto occaecati repudiandae velit. Tenetur quibusdam explicabo optio nostrum nostrum. Sit ipsum fugit aliquam laborum sed aut.
149	M-18	CM0032	BT-013	2020	2.0	5	manual	diesel	RWD	61889	Repellat repudiandae accusantium non adipisci eligendi excepturi ullam. Voluptatibus esse modi placeat accusamus. Omnis reiciendis minima. Officia animi quod ullam quas natus harum.
150	M-10	CM0037	BT-009	2013	5.5	4	automatic	gasoline	FWD	15889	Voluptas officiis autem voluptatem atque tempore.
151	M-05	CM0022	BT-012	2019	2.0	4	automatic	diesel	RWD	99797	Ea nostrum rem explicabo perspiciatis quisquam quam tenetur. Explicabo sapiente aspernatur quis tenetur odit reiciendis. Beatae recusandae aperiam porro quaerat.
152	M-17	CM0019	BT-011	2018	1.4	5	automatic	diesel	AWD	48487	Nemo aspernatur iure provident vitae delectus repudiandae voluptates. Corrupti id nisi quod reprehenderit placeat. Iusto esse dicta sit ipsam.
153	M-19	CM0043	BT-004	2022	0	5	automatic	electric	RWD	121054	Vero sed vel occaecati iure dolorum.
154	M-18	CM0032	BT-013	2022	2.0	5	automatic	diesel	RWD	118653	Ipsum reprehenderit in quas cum sed. Sint possimus facilis quos eius veniam ipsam saepe. Nulla sint labore mollitia.
155	M-15	CM0005	BT-010	2018	1.2	5	automatic	diesel	RWD	114281	Explicabo ut debitis quod sapiente repudiandae voluptates. Sunt aut officiis odit nostrum autem aliquam molestias. Fugit optio molestias impedit.
156	M-12	CM0040	BT-003	2018	2.5	5	manual	gasoline	AWD	58482	Dolores consequuntur voluptatibus accusantium accusantium pariatur. Illum odio atque. Minima cum accusantium sunt nesciunt vitae odio.
157	M-03	CM0048	BT-007	2021	1.2	5	manual	gasoline	RWD	116998	Voluptatibus officia neque iusto illo. Ut impedit eligendi.
158	M-17	CM0006	BT-008	2014	1.5	7	automatic	gasoline	AWD	19481	Temporibus nisi ratione magnam facere voluptate. Incidunt quasi numquam fugiat animi sequi saepe voluptate.
159	M-12	CM0040	BT-003	2018	2.5	5	automatic	gasoline	AWD	127789	Inventore magnam mollitia dolorum ut necessitatibus perspiciatis. Non necessitatibus voluptatum provident laborum. Quaerat maiores cumque recusandae incidunt ipsam.
160	M-06	CM0042	BT-004	2022	0	5	automatic	electric	AWD	99595	Sit vel unde praesentium assumenda vitae consequatur. Vel quisquam ut aliquid provident nulla. Officia delectus voluptas molestiae maxime porro sit nam.
161	M-03	CM0003	BT-010	2018	1.5	5	manual	gasoline	RWD	80536	Neque quidem magni nemo rerum voluptas. Laudantium modi corporis non. Fugiat officia saepe deleniti sequi nostrum.
162	M-05	CM0022	BT-012	2017	2.0	4	manual	gasoline	AWD	5793	Tempore fugiat officia reprehenderit. Magni veniam voluptatibus iusto consequatur quam. At eum est quas iure dolorum repellat.
163	M-03	CM0048	BT-007	2017	1.2	5	automatic	gasoline	AWD	58414	Ratione eveniet perspiciatis modi repellat corporis. Quidem autem nisi laboriosam perferendis doloribus blanditiis.
164	M-07	CM0035	BT-009	2014	3.6	4	manual	gasoline	FWD	92257	Soluta officiis occaecati optio omnis nam. Fuga dolor architecto ipsa.
165	M-03	CM0048	BT-007	2019	1.2	5	automatic	diesel	AWD	47697	Dolorum id mollitia nisi assumenda adipisci eaque animi. Similique nobis laudantium velit nam eius voluptatem consectetur. Quidem natus repudiandae ab.
166	M-10	CM0030	BT-001	2010	3.5	2	manual	diesel	RWD	140766	Nemo nihil asperiores explicabo accusamus provident officiis. Temporibus voluptate magni cumque alias odio. Dicta illum veniam omnis ducimus explicabo ipsam quasi.
167	M-06	CM0042	BT-004	2021	0	5	automatic	electric	AWD	134183	Dolor placeat eos debitis aliquam. Debitis fuga vero accusamus.
168	M-05	CM0007	BT-008	2015	1.5	7	automatic	diesel	AWD	36149	Illo numquam officiis doloribus recusandae dolores itaque. Natus rem aliquid perspiciatis magni. Saepe unde consequatur impedit sequi.
169	M-12	CM0040	BT-003	2018	2.5	5	manual	diesel	AWD	70218	Ratione beatae aperiam. A vel amet similique. Et aliquam vitae minima quae ullam.
170	M-18	CM0032	BT-013	2020	2.0	5	manual	gasoline	AWD	69018	Error quo neque. Numquam quod molestias unde molestiae cum natus. Voluptate error fugiat incidunt quaerat corrupti. Ut in sed.
171	M-05	CM0022	BT-012	2017	2.0	4	automatic	diesel	RWD	133995	Nesciunt consequatur vitae impedit similique quibusdam natus. Perspiciatis distinctio quaerat maxime architecto. Libero fugiat magni ipsam libero culpa aliquam. Voluptates odio assumenda nihil adipisci reiciendis.
172	M-01	CM0025	BT-012	2013	3.0	4	automatic	diesel	AWD	129785	Consequatur vitae saepe dicta.
173	M-05	CM0007	BT-008	2020	1.5	7	manual	gasoline	RWD	72065	Veritatis quis excepturi adipisci in a. Animi adipisci perspiciatis illum praesentium illo.
174	M-17	CM0045	BT-006	2014	2.5	5	automatic	hybrid	RWD	138335	Quis sint maxime itaque odit quaerat distinctio ipsum. Alias atque unde iusto. Illum laborum cumque in consequatur pariatur officia.
175	M-06	CM0042	BT-004	2021	0	5	automatic	electric	RWD	37573	Magnam vel qui architecto doloremque quas quae dolorem. Vel neque commodi non eveniet.
176	M-15	CM0005	BT-010	2018	1.2	5	manual	gasoline	RWD	78623	Officia iure nihil provident hic excepturi ex aliquid. A recusandae maiores quae porro tempora ipsa earum.
177	M-10	CM0037	BT-009	2016	5.5	4	manual	diesel	FWD	141284	Sequi ipsam alias reprehenderit quas. Ab quia suscipit enim consectetur. Quia cum in voluptate iste inventore ea.
178	M-17	CM0018	BT-011	2018	1.8	5	manual	diesel	RWD	136169	Laudantium explicabo delectus ea iure. Dignissimos quibusdam saepe incidunt nesciunt cumque molestiae. Similique doloremque illum. Quas temporibus cum iusto ducimus doloribus magni.
179	M-09	CM0028	BT-001	2018	2.0	2	manual	gasoline	RWD	93770	Nulla a dolor officiis consequuntur. Enim perferendis velit non nam consequatur.
180	M-06	CM0042	BT-004	2022	0	5	automatic	electric	AWD	101684	Dolorum tempore saepe dolorem sed amet similique. Omnis accusamus praesentium impedit.
181	M-17	CM0020	BT-011	2017	2.5	5	automatic	diesel	RWD	36206	Dicta quos iure suscipit. Molestiae aliquid quos consectetur occaecati repudiandae. Iure doloremque laboriosam asperiores voluptate. Magnam facere voluptas deserunt quam.
182	M-17	CM0045	BT-006	2017	2.5	5	automatic	hybrid	AWD	27019	Odit voluptate rem alias. Itaque corporis tempore quo sunt iure inventore.
183	M-05	CM0013	BT-005	2018	1.2	5	manual	diesel	AWD	128334	Tempore voluptates velit quo. Harum eos libero. Molestiae at excepturi voluptate.
184	M-03	CM0048	BT-007	2021	1.2	5	automatic	gasoline	AWD	35029	Officiis omnis exercitationem modi ipsa odit. Ducimus totam eos sint. Illo vel quo delectus. Eos officiis laudantium dolores exercitationem.
185	M-17	CM0006	BT-008	2015	1.5	7	automatic	gasoline	RWD	54042	Enim repellendus voluptatem occaecati cumque. Nisi quae facere ab molestias eius.
186	M-16	CM0041	BT-004	2022	0	5	automatic	electric	RWD	27548	Incidunt a ipsam. Porro tempore qui dolores. Architecto voluptate modi voluptas quia.
187	M-17	CM0047	BT-007	2022	1.2	5	automatic	diesel	AWD	8807	Assumenda fugiat corrupti veritatis alias. Velit quidem libero animi.
188	M-03	CM0048	BT-007	2019	1.2	5	manual	gasoline	AWD	120277	Ullam dolor quam reprehenderit ipsa eligendi unde inventore. Tempore sit cupiditate ex. Facilis dicta at expedita. Exercitationem veniam magnam soluta.
189	M-17	CM0038	BT-003	2023	2.5	5	automatic	gasoline	RWD	9611	Sed beatae reiciendis tenetur. Error omnis rerum consequatur. Voluptate unde dignissimos nulla.
190	M-17	CM0045	BT-006	2014	2.5	5	automatic	hybrid	RWD	88940	Officiis molestiae delectus. A dolore suscipit suscipit vitae quaerat dolor. Aut veniam possimus pariatur odit officia est.
191	M-10	CM0030	BT-001	2010	3.5	2	manual	gasoline	AWD	8781	Ad atque ducimus natus quo excepturi sunt blanditiis. Voluptatem ex eveniet itaque aspernatur.
192	M-13	CM0044	BT-006	2023	1.2	5	automatic	hybrid	RWD	27762	Sint non saepe. Neque laborum ullam. Delectus dignissimos iste ab.
193	M-13	CM0011	BT-002	2015	1.5	5	automatic	diesel	RWD	105136	Vel nemo commodi animi quaerat corrupti. Eveniet magnam architecto ducimus. Sunt ad dolorem distinctio quae.
194	M-10	CM0033	BT-013	2020	3.0	5	automatic	gasoline	RWD	132696	Earum quos quae totam fugit. Molestiae cum fugiat eum est impedit quia.
195	M-05	CM0013	BT-005	2018	1.2	5	manual	gasoline	AWD	135296	Sapiente et voluptatum optio quod.
196	M-17	CM0002	BT-010	2023	1.5	5	automatic	gasoline	RWD	110871	Ad quod esse quod. Harum quae animi occaecati. Doloribus id magnam quibusdam.
197	M-17	CM0004	BT-010	2017	2.4	5	manual	gasoline	AWD	142503	Maxime vitae deserunt. Fugit unde incidunt molestias magnam. Inventore voluptatum animi corporis exercitationem sapiente.
198	M-15	CM0034	BT-009	2019	1.5	4	automatic	diesel	FWD	59763	Possimus commodi maiores veniam voluptas nemo similique. Ab quae consequuntur veritatis laudantium provident nobis tempore.
199	M-02	CM0027	BT-001	2019	3.0	2	manual	gasoline	RWD	99035	Saepe veritatis quas fugit fugit tempore quas. Cumque dolorum libero reiciendis debitis deleniti.
200	M-09	CM0021	BT-011	2014	2.5	5	automatic	gasoline	RWD	109653	Eveniet qui quia accusamus explicabo id illo. Laborum totam quo autem.
\.


--
-- TOC entry 3397 (class 0 OID 27615)
-- Dependencies: 218
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (location_id, city_name, location) FROM stdin;
3171	Kota Jakarta Pusat	(-6.186486,106.834091)
3172	Kota Jakarta Utara	(-6.121435,106.774124)
3173	Kota Jakarta Barat	(-6.1352,106.813301)
3174	Kota Jakarta Selatan	(-6.300641,106.814095)
3175	Kota Jakarta Timur	(-6.264451,106.895859)
3573	Kota Malang	(-7.981894,112.626503)
3578	Kota Surabaya	(-7.289166,112.734398)
3471	Kota Yogyakarta	(-7.797224,110.368797)
3273	Kota Bandung	(-6.9147444,107.6098111)
1371	Kota Padang	(-0.95,100.3530556)
1375	Kota Bukittinggi	(-0.3055556,100.3691667)
6471	Kota Balikpapan	(-1.2635389,116.8278833)
6472	Kota Samarinda	(-0.502183,117.153801)
7371	Kota Makassar	(-5.1333333,119.4166667)
5171	Kota Denpasar	(-8.65629,115.222099)
\.


--
-- TOC entry 3394 (class 0 OID 27565)
-- Dependencies: 215
-- Data for Name: manufactures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manufactures (manufacture_id, manufacture_name) FROM stdin;
M-01	Audi
M-02	BMW
M-03	Daihatsu
M-04	Ford
M-05	Honda
M-06	Hyundai
M-07	Jeep
M-08	Land Rover
M-09	Mazda
M-10	Mercedes
M-11	Mini
M-12	Mitsubishi
M-13	Nissan
M-14	Porsche
M-15	Suzuki
M-16	Tesla
M-17	Toyota
M-18	Volkswagen
M-19	Wuling
\.


--
-- TOC entry 3395 (class 0 OID 27572)
-- Dependencies: 216
-- Data for Name: models; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.models (model_id, manufacture_id, model_name) FROM stdin;
CM0001	M-05	Honda HR-V
CM0002	M-17	Toyota Rush
CM0003	M-03	Daihatsu Terios
CM0004	M-17	Toyota Fortuner
CM0005	M-15	Suzuki Ignis
CM0006	M-17	Toyota Avanza
CM0007	M-05	Honda Mobilio
CM0008	M-19	Wuling Confero
CM0009	M-17	Toyota Sienta
CM0010	M-12	Mitsubishi Xpander Cross
CM0011	M-13	Nissan Juke
CM0012	M-09	Mazda CX-3
CM0013	M-05	Honda Brio
CM0014	M-15	Suzuki Baleno GL
CM0015	M-17	Toyota Yaris
CM0016	M-09	Mazda 2
CM0017	M-05	Honda Jazz
CM0018	M-17	Toyota Corolla Altis
CM0019	M-17	Toyota Vios
CM0020	M-17	Toyota Camry
CM0021	M-09	Mazda 6
CM0022	M-05	Honda Civic Type-R
CM0023	M-02	BMW Series 3
CM0024	M-10	Mercedes-Benz C-Class
CM0025	M-01	Audi A5
CM0026	M-14	Porsche 718
CM0027	M-02	BMW Z4
CM0028	M-09	Mazda MX-5
CM0029	M-11	Mini Cabrio John Cooper Works
CM0030	M-10	Mercedes-Benz SLK-Class
CM0031	M-11	Mini Clubman Cooper S
CM0032	M-18	Volkswagen Golf
CM0033	M-10	Mercedes-Benz GLE-Class
CM0034	M-15	Suzuki Jimny
CM0035	M-07	Jeep Wrangler Sahara
CM0036	M-08	Land Rover Defender
CM0037	M-10	Mercedes-Benz G63 AMG
CM0038	M-17	Toyota Hilux G
CM0039	M-04	Ford Ranger XLT
CM0040	M-12	Mitsubishi Triton Exceed
CM0041	M-16	Tesla Model 3
CM0042	M-06	Hyundai IONIQ 5
CM0043	M-19	Wuling Air EV
CM0044	M-13	Nissan Kicks
CM0045	M-17	Toyota Camry Hybrid
CM0046	M-15	Suzuki Ertiga GX Hybrid
CM0047	M-17	Toyota Calya
CM0048	M-03	Daihatsu Sigra
\.


--
-- TOC entry 3398 (class 0 OID 27620)
-- Dependencies: 219
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, first_name, last_name, email, contact, location_id) FROM stdin;
1	Karman	Prastuti	karman.prastuti@gmail.com	+62-977-642-5154	3175
2	Johan	Simanjuntak	johan.simanjuntak@hotmail.com	(0661) 180-4851	3578
3	Hari	Permata	hari.permata@yahoo.com	+62-016-770-2266	6472
4	Intan	Irawan	intan.irawan@gmail.com	+62 (010) 167 9817	3172
5	Nardi	Wibowo	nardi.wibowo@yahoo.com	(0980) 979 0625	3471
6	Marsudi	Sitompul	marsudi.sitompul@hotmail.com	+62 (53) 664 9872	7371
7	Lalita	Sihombing	lalita.sihombing@gmail.com	(0052) 894-7179	3172
8	Paiman	Palastri	paiman.palastri@gmail.com	+62 (098) 252 7298	6471
9	Icha	Nasyidah	icha.nasyidah@yahoo.com	+62-302-586-7120	3171
10	Ajeng	Namaga	ajeng.namaga@hotmail.com	(0372) 893-6142	1371
11	Kenari	Purwanti	kenari.purwanti@hotmail.com	+62 (932) 258-8532	6472
12	Sidiq	Kusumo	sidiq.kusumo@yahoo.com	+62-838-629-2228	7371
13	Purwadi	Fujiati	purwadi.fujiati@gmail.com	+62-20-580-6408	5171
14	Najib	Ramadan	najib.ramadan@yahoo.com	+62 (942) 226-9421	7371
15	Hartana	Wijayanti	hartana.wijayanti@gmail.com	+62 (094) 861-7671	3174
16	Kenari	Rahimah	kenari.rahimah@hotmail.com	+62 (0269) 042 1932	1375
17	Dodo	Wahyuni	dodo.wahyuni@yahoo.com	+62 (96) 622-1685	1371
18	Paris	Prasetya	paris.prasetya@gmail.com	+62 (427) 270-4735	3573
19	Galak	Salahudin	galak.salahudin@gmail.com	+62 (093) 189 4517	3578
20	Rafid	Zulkarnain	rafid.zulkarnain@yahoo.com	+62 (402) 728-4408	1375
21	Hilda	Salahudin	hilda.salahudin@yahoo.com	(089) 586 8769	6471
22	Among	Jailani	among.jailani@gmail.com	(014) 540 1560	3171
23	Jatmiko	Purnawati	jatmiko.purnawati@gmail.com	(071) 410 2983	1371
24	Nadine	Wahyuni	nadine.wahyuni@gmail.com	+62 (0495) 438-3813	3471
25	Jail	Haryanti	jail.haryanti@gmail.com	(0610) 028-8508	1375
26	Prima	Utama	prima.utama@gmail.com	+62 (124) 650 1603	3172
27	Yessi	Rahayu	yessi.rahayu@yahoo.com	+62 (20) 822-2496	6471
28	Mahfud	Andriani	mahfud.andriani@hotmail.com	0857191016	3273
29	Wage	Wahyudin	wage.wahyudin@hotmail.com	+62 (033) 371 0052	3173
30	Aurora	Saragih	aurora.saragih@hotmail.com	+62 (0519) 724-3796	1375
31	Nardi	Putra	nardi.putra@hotmail.com	(0554) 269 9631	1371
32	Danu	Marbun	danu.marbun@yahoo.com	+62 (0522) 565 8548	1371
33	Nadia	Nainggolan	nadia.nainggolan@yahoo.com	+62 (84) 363 4852	3175
34	Shania	Sitorus	shania.sitorus@yahoo.com	+62 (239) 467 9302	1371
35	Karma	Saefullah	karma.saefullah@gmail.com	+62 (61) 105-0576	3172
36	Nabila	Hartati	nabila.hartati@gmail.com	+62-15-928-0356	7371
37	Harimurti	Hutasoit	harimurti.hutasoit@gmail.com	(097) 354-6350	6471
38	Vivi	Halimah	vivi.halimah@hotmail.com	+62-0455-014-6676	6471
39	Jasmani	Manullang	jasmani.manullang@hotmail.com	+62 (51) 279-3118	3273
40	Surya	Budiman	surya.budiman@yahoo.com	+62 (71) 888-4961	3573
41	Juli	Tamba	juli.tamba@hotmail.com	080 880 0186	3171
42	Rama	Yuliarti	rama.yuliarti@gmail.com	+62 (0228) 285-7383	7371
43	Karma	Prastuti	karma.prastuti@gmail.com	084 263 0191	3171
44	Ulya	Usamah	ulya.usamah@hotmail.com	(0442) 074-6002	6471
45	Soleh	Padmasari	soleh.padmasari@gmail.com	+62 (0803) 242-9793	7371
46	Lasmanto	Wastuti	lasmanto.wastuti@yahoo.com	+62 (0526) 627-0091	7371
47	Rina	Hartati	rina.hartati@hotmail.com	(0489) 926 1353	6471
48	Argono	Wasita	argono.wasita@hotmail.com	0818560759	5171
49	Ade	Nababan	ade.nababan@yahoo.com	(0188) 609-7070	7371
50	Muni	Pradana	muni.pradana@gmail.com	(0763) 583 9936	6471
51	Tirtayasa	Ardianto	tirtayasa.ardianto@hotmail.com	+62 (060) 114 2389	7371
52	Sakura	Purwanti	sakura.purwanti@yahoo.com	+62 (058) 897-6341	7371
53	Nasim	Widiastuti	nasim.widiastuti@yahoo.com	+62 (227) 629-2165	3171
54	Yuni	Aryani	yuni.aryani@hotmail.com	0877595388	3573
55	Jaiman	Purnawati	jaiman.purnawati@gmail.com	087 673 0665	5171
56	Cemeti	Ramadan	cemeti.ramadan@gmail.com	+62-97-129-7655	3273
57	Kala	Nuraini	kala.nuraini@gmail.com	(084) 249 3475	7371
58	Lasmono	Halim	lasmono.halim@gmail.com	+62 (812) 487 5634	3173
59	Ghani	Riyanti	ghani.riyanti@hotmail.com	0845518580	3173
60	Yoga	Rahmawati	yoga.rahmawati@hotmail.com	0863230732	1375
61	Kayla	Haryanto	kayla.haryanto@yahoo.com	(072) 941-2809	5171
62	Hardana	Laksmiwati	hardana.laksmiwati@yahoo.com	085 241 5532	3174
63	Safina	Sihotang	safina.sihotang@yahoo.com	+62-401-718-3791	5171
64	Baktianto	Siregar	baktianto.siregar@yahoo.com	+62-0692-237-3263	1375
65	Paramita	Astuti	paramita.astuti@yahoo.com	+62 (93) 073 7251	3171
66	Slamet	Hariyah	slamet.hariyah@yahoo.com	(0685) 449 9256	3171
67	Elon	Mansur	elon.mansur@yahoo.com	+62-075-652-9294	3174
68	Asirwanda	Mansur	asirwanda.mansur@hotmail.com	(0036) 329 0079	3273
69	Galih	Adriansyah	galih.adriansyah@gmail.com	+62 (13) 325-2843	5171
70	Ozy	Hutagalung	ozy.hutagalung@yahoo.com	+62 (0160) 375-5777	1375
71	Ajimin	Setiawan	ajimin.setiawan@hotmail.com	(0995) 504 0869	1371
72	Ilsa	Habibi	ilsa.habibi@gmail.com	(0902) 338 0288	3175
73	Umaya	Wahyudin	umaya.wahyudin@hotmail.com	+62-279-708-8530	3471
74	Dodo	Lazuardi	dodo.lazuardi@hotmail.com	(0649) 018-4951	3171
75	Anastasia	Yulianti	anastasia.yulianti@yahoo.com	+62 (0788) 030-6296	1375
76	Jayadi	Susanti	jayadi.susanti@yahoo.com	+62 (086) 246-6000	7371
77	Eja	Nurdiyanti	eja.nurdiyanti@yahoo.com	+62 (02) 219 9814	5171
78	Yance	Samosir	yance.samosir@hotmail.com	+62 (897) 393-3098	3173
79	Restu	Hutagalung	restu.hutagalung@yahoo.com	+62 (318) 376 3588	3171
80	Usyi	Maryati	usyi.maryati@gmail.com	0836822916	3578
81	Artanto	Sihombing	artanto.sihombing@yahoo.com	(0055) 374-2091	3471
82	Waluyo	Natsir	waluyo.natsir@yahoo.com	0875560821	3174
83	Kiandra	Santoso	kiandra.santoso@gmail.com	+62 (04) 170-1828	3578
84	Atma	Sinaga	atma.sinaga@hotmail.com	0814647562	3173
85	Cahya	Nainggolan	cahya.nainggolan@gmail.com	084 141 5831	3174
86	Estiono	Ramadan	estiono.ramadan@hotmail.com	+62 (0982) 566 8992	3171
87	Tiara	Usamah	tiara.usamah@yahoo.com	+62 (60) 520 5258	3573
88	Pangeran	Wijaya	pangeran.wijaya@gmail.com	+62 (53) 312-3896	3471
89	Harjasa	Ardianto	harjasa.ardianto@gmail.com	087 199 7930	3573
90	Lasmanto	Uyainah	lasmanto.uyainah@hotmail.com	(0956) 032-5797	6471
91	Dimaz	Tamba	dimaz.tamba@gmail.com	+62-090-742-9582	3174
92	Baktianto	Sitorus	baktianto.sitorus@hotmail.com	(0811) 493-1858	7371
93	Wisnu	Ardianto	wisnu.ardianto@hotmail.com	+62 (824) 163-0596	3578
94	Raditya	Suartini	raditya.suartini@yahoo.com	(0479) 234-4761	3471
95	Gandi	Latupono	gandi.latupono@gmail.com	+62 (026) 966-6206	3173
96	Usyi	Yuliarti	usyi.yuliarti@yahoo.com	+62 (009) 723 3030	3173
97	Saiful	Pangestu	saiful.pangestu@yahoo.com	+62 (120) 155 5012	3173
98	Emil	Simbolon	emil.simbolon@yahoo.com	+62 (443) 771 9576	3175
99	Sari	Halim	sari.halim@hotmail.com	(0555) 249-1122	5171
100	Endra	Siregar	endra.siregar@yahoo.com	(0192) 124-1171	1375
101	Ifa	Marpaung	ifa.marpaung@gmail.com	(073) 661-2834	6472
102	Kambali	Pertiwi	kambali.pertiwi@gmail.com	(053) 286 1919	3171
103	Cahyo	Farida	cahyo.farida@yahoo.com	0846591827	6471
104	Naradi	Rajata	naradi.rajata@hotmail.com	(0344) 952 7904	3578
105	Yoga	Setiawan	yoga.setiawan@gmail.com	(000) 872-4499	5171
106	Jayadi	Wijayanti	jayadi.wijayanti@yahoo.com	+62-437-575-1092	6471
107	Marwata	Haryanti	marwata.haryanti@hotmail.com	(073) 348-8495	3573
108	Cengkal	Putra	cengkal.putra@yahoo.com	+62 (017) 044-9405	5171
109	Dirja	Hutagalung	dirja.hutagalung@gmail.com	(094) 143-1039	3273
110	Ikin	Maulana	ikin.maulana@hotmail.com	089 813 9548	3573
111	Hasim	Prayoga	hasim.prayoga@yahoo.com	+62 (015) 861-2460	6471
112	Adikara	Hidayat	adikara.hidayat@yahoo.com	+62-064-846-6838	3174
113	Bancar	Setiawan	bancar.setiawan@gmail.com	+62 (00) 151-2269	3273
114	Atmaja	Tampubolon	atmaja.tampubolon@hotmail.com	(090) 855-0016	5171
115	Prasetya	Setiawan	prasetya.setiawan@yahoo.com	+62 (79) 036 8831	3578
116	Febi	Marbun	febi.marbun@gmail.com	0876069913	3471
117	Malik	Pradana	malik.pradana@gmail.com	+62-015-098-8250	6471
118	Kariman	Firgantoro	kariman.firgantoro@gmail.com	+62 (163) 920 0291	7371
119	Cici	Saptono	cici.saptono@hotmail.com	+62 (66) 906-6925	3174
120	Jindra	Suartini	jindra.suartini@hotmail.com	+62-89-747-2744	3175
121	Ida	Saptono	ida.saptono@gmail.com	081 236 7808	3273
122	Joko	Lestari	joko.lestari@yahoo.com	+62 (983) 653-7912	3173
123	Heryanto	Gunawan	heryanto.gunawan@yahoo.com	+62-52-837-7871	3171
124	Paramita	Mahendra	paramita.mahendra@yahoo.com	(061) 442-0098	3173
125	Carla	Kusmawati	carla.kusmawati@hotmail.com	+62 (504) 670 7942	5171
126	Labuh	Fujiati	labuh.fujiati@hotmail.com	+62 (933) 807-1013	1375
127	Argono	Ramadan	argono.ramadan@gmail.com	+62-0984-686-9346	3175
128	Puji	Latupono	puji.latupono@yahoo.com	+62 (74) 546 2912	3175
129	Eluh	Novitasari	eluh.novitasari@hotmail.com	+62-44-647-0868	3471
130	Endah	Prasasta	endah.prasasta@gmail.com	+62 (060) 728-9912	7371
131	Oman	Utama	oman.utama@hotmail.com	+62 (99) 071-8706	3173
132	Eka	Rahimah	eka.rahimah@hotmail.com	+62 (0800) 300-3416	3172
133	Marsudi	Wasita	marsudi.wasita@gmail.com	(0074) 188-8547	3471
134	Kawaca	Wahyudin	kawaca.wahyudin@hotmail.com	(0566) 447-5838	6472
135	Harsanto	Handayani	harsanto.handayani@hotmail.com	+62 (096) 407-8370	7371
136	Okta	Marpaung	okta.marpaung@yahoo.com	+62 (78) 253-5839	3173
137	Restu	Tarihoran	restu.tarihoran@yahoo.com	0831508656	6471
138	Harsaya	Yuliarti	harsaya.yuliarti@yahoo.com	0839973348	3578
139	Cahya	Rahimah	cahya.rahimah@gmail.com	(0591) 003 8037	1375
140	Mitra	Sinaga	mitra.sinaga@gmail.com	(035) 495-1030	6472
141	Wasis	Hutasoit	wasis.hutasoit@gmail.com	+62 (38) 153 8170	3578
142	Ikhsan	Irawan	ikhsan.irawan@yahoo.com	+62 (700) 276-2583	3172
143	Cawuk	Narpati	cawuk.narpati@yahoo.com	+62 (278) 373-4053	6472
144	Ina	Hidayat	ina.hidayat@hotmail.com	+62 (608) 749 8288	3273
145	Betania	Firmansyah	betania.firmansyah@hotmail.com	+62 (27) 609-4440	3174
146	Ifa	Namaga	ifa.namaga@hotmail.com	+62 (0596) 777 6547	1375
147	Novi	Prayoga	novi.prayoga@gmail.com	+62 (71) 724-1921	3174
148	Galang	Farida	galang.farida@hotmail.com	+62 (920) 754-8439	3471
149	Bakidin	Melani	bakidin.melani@hotmail.com	+62 (85) 880-1076	3578
150	Jayadi	Mardhiyah	jayadi.mardhiyah@gmail.com	0857156729	3578
151	Banawi	Rajata	banawi.rajata@yahoo.com	+62-0304-543-7726	1375
152	Laila	Utami	laila.utami@gmail.com	0839767408	3273
153	Keisha	Latupono	keisha.latupono@hotmail.com	(0853) 549 9970	5171
154	Heru	Wibisono	heru.wibisono@hotmail.com	+62 (683) 394-4996	5171
155	Agnes	Zulaika	agnes.zulaika@yahoo.com	+62 (638) 403 9343	6471
156	Hesti	Habibi	hesti.habibi@gmail.com	+62 (466) 025-9711	3273
157	Elisa	Wibowo	elisa.wibowo@yahoo.com	+62 (189) 818-1662	3573
158	Laswi	Damanik	laswi.damanik@hotmail.com	+62 (081) 301-6047	3173
159	Darsirah	Permata	darsirah.permata@hotmail.com	+62-69-714-4548	1371
160	Artawan	Latupono	artawan.latupono@gmail.com	(062) 650 8548	7371
161	Alambana	Hassanah	alambana.hassanah@gmail.com	(064) 298-3225	3171
162	Lintang	Zulkarnain	lintang.zulkarnain@gmail.com	+62-012-133-4782	1371
163	Puspa	Narpati	puspa.narpati@gmail.com	+62-069-935-4082	3171
164	Sakura	Kuswandari	sakura.kuswandari@hotmail.com	+62 (090) 827 8816	3578
165	Gada	Waluyo	gada.waluyo@yahoo.com	(0222) 883 7299	3171
166	Talia	Wijayanti	talia.wijayanti@gmail.com	+62 (82) 974-5424	5171
167	Irma	Prastuti	irma.prastuti@hotmail.com	+62-379-598-2974	3172
168	Danu	Sinaga	danu.sinaga@gmail.com	(0834) 503 6105	3471
169	Ega	Widodo	ega.widodo@hotmail.com	(0037) 439-0088	3273
170	Ganep	Mulyani	ganep.mulyani@hotmail.com	086 894 1351	3471
171	Danang	Puspita	danang.puspita@yahoo.com	+62-818-647-8979	1371
172	Lili	Hassanah	lili.hassanah@yahoo.com	+62 (23) 683-8731	3273
173	Michelle	Putra	michelle.putra@gmail.com	+62 (92) 572-8535	3173
174	Gatra	Nainggolan	gatra.nainggolan@hotmail.com	+62-511-024-1970	6472
175	Kani	Pradana	kani.pradana@gmail.com	+62 (27) 169-0160	7371
176	Candrakanta	Andriani	candrakanta.andriani@gmail.com	+62 (82) 567 4970	1371
177	Abyasa	Hidayat	abyasa.hidayat@yahoo.com	084 997 9689	3471
178	Dadap	Permata	dadap.permata@hotmail.com	+62 (108) 740 9912	3273
179	Juli	Halim	juli.halim@gmail.com	+62 (759) 024 3546	3173
180	Kardi	Agustina	kardi.agustina@yahoo.com	(009) 063 3154	3174
181	Kani	Wastuti	kani.wastuti@hotmail.com	+62-04-883-5870	3471
182	Wawan	Uwais	wawan.uwais@hotmail.com	0841388042	3578
183	Galar	Susanti	galar.susanti@gmail.com	+62-015-672-1748	3175
184	Umaya	Marbun	umaya.marbun@gmail.com	+62 (0217) 111-5439	1371
185	Laswi	Agustina	laswi.agustina@hotmail.com	+62 (735) 555 1224	3172
186	Rizki	Wibisono	rizki.wibisono@yahoo.com	(019) 971 8049	3172
187	Okto	Kusumo	okto.kusumo@gmail.com	+62 (70) 497-1012	3273
188	Tasnim	Hidayanto	tasnim.hidayanto@gmail.com	+62 (058) 850 4777	6471
189	Gangsa	Wastuti	gangsa.wastuti@hotmail.com	+62 (910) 376-0289	1371
190	Kurnia	Sitorus	kurnia.sitorus@hotmail.com	(044) 927-5030	3273
191	Belinda	Simbolon	belinda.simbolon@gmail.com	+62 (0216) 157-9924	6472
192	Genta	Yolanda	genta.yolanda@yahoo.com	+62-0374-012-1296	5171
193	Sakura	Uwais	sakura.uwais@yahoo.com	(048) 206 9423	3578
194	Pranawa	Rahayu	pranawa.rahayu@gmail.com	+62 (43) 889 6632	6472
195	Clara	Utami	clara.utami@yahoo.com	+62 (068) 121 5421	3175
196	Bakijan	Sinaga	bakijan.sinaga@hotmail.com	(032) 922 0019	3573
197	Ella	Wahyuni	ella.wahyuni@yahoo.com	+62 (65) 280-4560	5171
198	Bagus	Lailasari	bagus.lailasari@yahoo.com	+62 (0273) 902 9744	3578
199	Bagus	Haryanto	bagus.haryanto@yahoo.com	(0426) 140-5629	1371
200	Parman	Pratiwi	parman.pratiwi@hotmail.com	+62 (41) 611 9151	3175
201	Digdaya	Purwanti	digdaya.purwanti@yahoo.com	0813947118	3273
202	Gawati	Permadi	gawati.permadi@hotmail.com	080 212 7325	6471
203	Lembah	Nuraini	lembah.nuraini@yahoo.com	+62 (78) 963 2144	3578
204	Icha	Mangunsong	icha.mangunsong@hotmail.com	+62-071-832-2141	5171
205	Hamzah	Permata	hamzah.permata@hotmail.com	+62 (125) 986-5995	3173
206	Vero	Irawan	vero.irawan@yahoo.com	(0868) 351 0857	3171
207	Patricia	Saptono	patricia.saptono@gmail.com	(021) 213-6198	5171
208	Cemeti	Mansur	cemeti.mansur@yahoo.com	+62 (0067) 467 7875	3273
209	Atmaja	Ardianto	atmaja.ardianto@yahoo.com	+62 (633) 900-9689	5171
210	Tirta	Haryanto	tirta.haryanto@gmail.com	084 545 1293	3175
211	Surya	Zulkarnain	surya.zulkarnain@hotmail.com	+62-49-420-9237	1375
212	Cakrajiya	Pradana	cakrajiya.pradana@yahoo.com	+62-082-973-2659	3175
213	Lasmanto	Agustina	lasmanto.agustina@yahoo.com	0800496522	3273
214	Intan	Adriansyah	intan.adriansyah@hotmail.com	+62 (0997) 087 3686	6471
215	Aris	Mandasari	aris.mandasari@yahoo.com	(0378) 930-5166	3172
216	Gaman	Mayasari	gaman.mayasari@yahoo.com	+62-621-657-4135	3173
217	Bagas	Putra	bagas.putra@yahoo.com	(0993) 304 0446	3573
218	Jarwa	Palastri	jarwa.palastri@gmail.com	+62-0382-923-4648	3578
219	Karimah	Uwais	karimah.uwais@yahoo.com	+62-527-370-3353	1371
220	Saiful	Yuliarti	saiful.yuliarti@yahoo.com	+62 (265) 455 4952	3172
221	Tasnim	Pradana	tasnim.pradana@hotmail.com	+62-55-725-2534	3573
222	Labuh	Budiman	labuh.budiman@hotmail.com	+62-030-467-6602	3171
223	Yahya	Mangunsong	yahya.mangunsong@hotmail.com	(0831) 481 3318	3174
224	Tirta	Widiastuti	tirta.widiastuti@gmail.com	(032) 612 9016	1371
225	Jinawi	Yuniar	jinawi.yuniar@hotmail.com	+62-43-429-3530	3175
226	Ajimin	Hakim	ajimin.hakim@hotmail.com	+62 (020) 214-4466	1371
227	Gamblang	Siregar	gamblang.siregar@hotmail.com	+62 (736) 132 3844	5171
228	Embuh	Gunawan	embuh.gunawan@gmail.com	+62 (98) 599-9547	3273
229	Wira	Prasasta	wira.prasasta@yahoo.com	+62-237-058-4400	3173
230	Sadina	Mayasari	sadina.mayasari@gmail.com	+62 (04) 648 6451	5171
231	Muni	Gunawan	muni.gunawan@hotmail.com	+62 (387) 178 3270	6471
232	Jarwadi	Hartati	jarwadi.hartati@yahoo.com	+62 (052) 194-2641	5171
233	Bakiman	Utama	bakiman.utama@yahoo.com	+62 (12) 444 4499	6472
234	Jasmin	Suryatmi	jasmin.suryatmi@yahoo.com	+62 (18) 369 5876	1375
235	Hartaka	Sinaga	hartaka.sinaga@yahoo.com	+62 (10) 571-9284	7371
236	Legawa	Astuti	legawa.astuti@hotmail.com	0872394224	3578
237	Eka	Mardhiyah	eka.mardhiyah@gmail.com	(0275) 987 5426	3172
238	Wasis	Anggriawan	wasis.anggriawan@hotmail.com	+62 (0915) 194 6061	6472
239	Jasmin	Iswahyudi	jasmin.iswahyudi@hotmail.com	+62 (840) 820 0272	3573
240	Tina	Suartini	tina.suartini@yahoo.com	+62 (243) 406-9406	3578
241	Puti	Manullang	puti.manullang@gmail.com	(0452) 970 9712	6471
242	Prabawa	Habibi	prabawa.habibi@yahoo.com	+62-0313-213-9319	3578
243	Bambang	Suryatmi	bambang.suryatmi@gmail.com	(073) 388-0587	3573
244	Harja	Tarihoran	harja.tarihoran@hotmail.com	+62 (065) 488-7842	3173
245	Respati	Saputra	respati.saputra@yahoo.com	(016) 886-9785	5171
246	Kardi	Sitompul	kardi.sitompul@yahoo.com	+62 (0029) 420-4067	1371
247	Anom	Maheswara	anom.maheswara@gmail.com	+62 (117) 477-3443	6471
248	Widya	Wasita	widya.wasita@gmail.com	+62 (35) 436 9576	3174
249	Uli	Waskita	uli.waskita@yahoo.com	+62 (0043) 669-4837	1375
250	Cemani	Kusumo	cemani.kusumo@gmail.com	085 576 3353	3173
251	Jindra	Prasetya	jindra.prasetya@gmail.com	(0292) 189 9918	6472
252	Gamani	Tampubolon	gamani.tampubolon@yahoo.com	(0602) 519 3600	3174
253	Lasmanto	Narpati	lasmanto.narpati@hotmail.com	+62 (066) 916 5662	3471
254	Anita	Jailani	anita.jailani@gmail.com	+62-036-021-2634	7371
255	Hasim	Sudiati	hasim.sudiati@gmail.com	+62 (0590) 755-8546	3578
256	Ayu	Mustofa	ayu.mustofa@hotmail.com	+62-016-421-5668	3471
257	Eka	Farida	eka.farida@yahoo.com	+62 (0628) 258 6768	6471
258	Fathonah	Susanti	fathonah.susanti@hotmail.com	(007) 014 8795	3578
259	Hasna	Hartati	hasna.hartati@gmail.com	+62 (175) 160 7253	1371
260	Sabri	Wasita	sabri.wasita@hotmail.com	+62 (068) 684-8434	3174
261	Julia	Hidayat	julia.hidayat@yahoo.com	+62 (320) 953 9770	3273
262	Iriana	Sitorus	iriana.sitorus@gmail.com	+62-15-132-4388	3174
263	Rahmi	Maryati	rahmi.maryati@yahoo.com	(013) 049 5024	3573
264	Widya	Simbolon	widya.simbolon@gmail.com	(0181) 317-9899	6471
265	Bancar	Pradana	bancar.pradana@gmail.com	+62 (006) 077 5731	3174
266	Arta	Napitupulu	arta.napitupulu@hotmail.com	+62-49-862-0704	6472
267	Suci	Dongoran	suci.dongoran@gmail.com	+62 (53) 919 2961	7371
268	Oman	Kuswandari	oman.kuswandari@yahoo.com	+62-042-537-9011	3471
269	Candra	Mangunsong	candra.mangunsong@hotmail.com	+62 (702) 686-3452	6472
270	Artanto	Wibowo	artanto.wibowo@gmail.com	+62 (26) 160 9094	3171
271	Digdaya	Ardianto	digdaya.ardianto@yahoo.com	+62 (29) 654-1135	3573
272	Laswi	Kusmawati	laswi.kusmawati@hotmail.com	0865879566	6471
273	Eluh	Iswahyudi	eluh.iswahyudi@gmail.com	+62 (21) 704-6884	3573
274	Bakiono	Anggriawan	bakiono.anggriawan@yahoo.com	(0703) 657-3556	3173
275	Heryanto	Widodo	heryanto.widodo@hotmail.com	(0147) 858 7488	6472
276	Wani	Tampubolon	wani.tampubolon@gmail.com	+62-217-722-8519	3273
277	Jasmani	Utama	jasmani.utama@hotmail.com	+62 (66) 680 0708	3573
278	Karja	Lazuardi	karja.lazuardi@yahoo.com	(024) 872 5666	6472
279	Lanang	Waskita	lanang.waskita@yahoo.com	+62-91-391-5184	5171
280	Harja	Maryati	harja.maryati@hotmail.com	+62-756-565-8968	3171
281	Luwes	Astuti	luwes.astuti@gmail.com	(045) 352 1828	3173
282	Prabawa	Setiawan	prabawa.setiawan@gmail.com	(0245) 626-8206	3173
283	Jaga	Simanjuntak	jaga.simanjuntak@hotmail.com	(050) 786 5195	6472
284	Putri	Megantara	putri.megantara@gmail.com	+62-0201-888-8160	7371
285	Enteng	Saragih	enteng.saragih@yahoo.com	+62 (20) 782-6947	3172
286	Hasim	Wibisono	hasim.wibisono@yahoo.com	+62 (253) 497-2502	3174
287	Bagiya	Lailasari	bagiya.lailasari@gmail.com	+62 (0045) 705-1464	3471
288	Harjo	Yulianti	harjo.yulianti@yahoo.com	+62 (77) 324-3298	5171
289	Lalita	Waluyo	lalita.waluyo@yahoo.com	(005) 318-6430	6471
290	Cakrabirawa	Tarihoran	cakrabirawa.tarihoran@yahoo.com	+62-021-022-1802	3175
291	Hairyanto	Nashiruddin	hairyanto.nashiruddin@gmail.com	(069) 844 4339	1375
292	Kajen	Megantara	kajen.megantara@gmail.com	+62-874-557-4528	7371
293	Eko	Mandala	eko.mandala@gmail.com	+62-0381-598-9633	3471
294	Harsanto	Oktaviani	harsanto.oktaviani@gmail.com	+62-0909-473-6743	5171
295	Langgeng	Widiastuti	langgeng.widiastuti@gmail.com	+62 (602) 837-4913	7371
296	Harsana	Hutapea	harsana.hutapea@yahoo.com	(0810) 176 8078	6472
297	Sabar	Nurdiyanti	sabar.nurdiyanti@hotmail.com	(087) 592 9963	1375
298	Violet	Puspasari	violet.puspasari@gmail.com	+62-498-662-6653	3578
299	Bagas	Mardhiyah	bagas.mardhiyah@hotmail.com	+62 (0218) 682-5125	6472
300	Muhammad	Nababan	muhammad.nababan@gmail.com	+62 (072) 278-4829	3172
301	Estiawan	Yuliarti	estiawan.yuliarti@hotmail.com	(0861) 581 3316	7371
302	Bahuwarna	Permadi	bahuwarna.permadi@yahoo.com	+62-36-083-5333	3172
303	Bala	Narpati	bala.narpati@gmail.com	(077) 404-6619	3175
304	Mujur	Manullang	mujur.manullang@hotmail.com	(0606) 263-2145	3171
305	Gambira	Saptono	gambira.saptono@hotmail.com	+62 (0368) 592 0709	3573
306	Cakrabirawa	Haryanto	cakrabirawa.haryanto@gmail.com	+62-60-951-2262	3173
307	Dacin	Lazuardi	dacin.lazuardi@hotmail.com	0804242056	5171
308	Rini	Dabukke	rini.dabukke@hotmail.com	+62 (269) 261-9129	3173
309	Raditya	Pradana	raditya.pradana@gmail.com	+62 (0042) 012 7697	6471
310	Harsanto	Rahmawati	harsanto.rahmawati@yahoo.com	+62-69-148-2577	3573
311	Vanesa	Laksmiwati	vanesa.laksmiwati@gmail.com	+62 (460) 947 0494	6471
312	Wardi	Wulandari	wardi.wulandari@gmail.com	+62 (11) 787-5907	3173
313	Emong	Mahendra	emong.mahendra@hotmail.com	+62-82-085-9041	3175
314	Mursinin	Kuswoyo	mursinin.kuswoyo@gmail.com	(0577) 889 0766	1375
315	Victoria	Kusumo	victoria.kusumo@gmail.com	+62 (0073) 314 4209	3172
316	Narji	Halim	narji.halim@hotmail.com	+62-681-390-7003	6471
317	Jayadi	Handayani	jayadi.handayani@hotmail.com	(017) 901 6689	3173
318	Lanang	Lazuardi	lanang.lazuardi@gmail.com	088 404 5996	7371
319	Aslijan	Pratiwi	aslijan.pratiwi@gmail.com	+62 (082) 989 4488	3174
320	Wahyu	Mansur	wahyu.mansur@yahoo.com	+62-028-905-7934	3175
321	Bakiadi	Sihombing	bakiadi.sihombing@hotmail.com	+62 (0439) 055 0474	3173
322	Dadi	Widiastuti	dadi.widiastuti@gmail.com	+62 (53) 034 9237	1371
323	Jamil	Pangestu	jamil.pangestu@hotmail.com	(0825) 188 8500	1375
324	Kiandra	Suartini	kiandra.suartini@hotmail.com	+62-0028-027-5700	7371
325	Setya	Saragih	setya.saragih@gmail.com	+62 (035) 767 2083	6471
326	Kasiyah	Kuswoyo	kasiyah.kuswoyo@gmail.com	+62 (0131) 086-1214	3578
327	Emin	Anggraini	emin.anggraini@yahoo.com	+62-756-421-8481	3471
328	Cengkal	Widodo	cengkal.widodo@gmail.com	0818828445	3173
329	Candrakanta	Maryati	candrakanta.maryati@hotmail.com	(010) 339 2182	3172
330	Wakiman	Winarsih	wakiman.winarsih@hotmail.com	+62 (815) 903-3169	3171
331	Putri	Hutasoit	putri.hutasoit@yahoo.com	+62 (056) 194-5715	6471
332	Sabri	Mulyani	sabri.mulyani@hotmail.com	(026) 567 5034	3173
333	Harsanto	Nababan	harsanto.nababan@yahoo.com	(0818) 311-1352	5171
334	Sabri	Marbun	sabri.marbun@gmail.com	(0203) 150 0490	5171
335	Saka	Simanjuntak	saka.simanjuntak@yahoo.com	(0160) 892-8971	3172
336	Anastasia	Marbun	anastasia.marbun@gmail.com	+62-061-399-8700	6471
337	Fathonah	Sirait	fathonah.sirait@hotmail.com	+62-041-723-6034	3173
338	Titin	Nuraini	titin.nuraini@gmail.com	+62-667-825-9253	1375
339	Nadia	Sihotang	nadia.sihotang@gmail.com	+62 (592) 592 5741	3174
340	Dirja	Nuraini	dirja.nuraini@gmail.com	089 696 0408	3172
341	Mursita	Rahimah	mursita.rahimah@yahoo.com	082 595 9037	3174
342	Iriana	Maheswara	iriana.maheswara@gmail.com	+62 (092) 904-0494	3573
343	Karna	Rajata	karna.rajata@gmail.com	+62-0898-510-9708	3171
344	Marsito	Rajata	marsito.rajata@yahoo.com	+62 (614) 197-5418	3578
345	Salman	Novitasari	salman.novitasari@yahoo.com	+62-175-405-8521	7371
346	Yessi	Ramadan	yessi.ramadan@yahoo.com	+62 (097) 894 0695	3174
347	Harjo	Prabowo	harjo.prabowo@yahoo.com	0890416384	1375
348	Halim	Lazuardi	halim.lazuardi@hotmail.com	+62 (086) 853-1716	3171
349	Muni	Aryani	muni.aryani@hotmail.com	+62 (78) 430 9151	3174
350	Galih	Lestari	galih.lestari@hotmail.com	+62 (69) 639 5925	1375
351	Qori	Jailani	qori.jailani@hotmail.com	(0327) 073-5207	3573
352	Elvin	Gunarto	elvin.gunarto@hotmail.com	+62-011-412-3710	5171
353	Hadi	Iswahyudi	hadi.iswahyudi@hotmail.com	(039) 805-1164	5171
354	Hasim	Latupono	hasim.latupono@yahoo.com	+62 (0115) 005-1501	1375
355	Bakda	Marpaung	bakda.marpaung@hotmail.com	(040) 701-2240	3175
356	Ayu	Narpati	ayu.narpati@yahoo.com	+62 (692) 581 4677	1371
357	Raisa	Usada	raisa.usada@hotmail.com	(093) 644-0071	5171
358	Nabila	Saptono	nabila.saptono@hotmail.com	0812045570	3471
359	Parman	Namaga	parman.namaga@hotmail.com	+62-0432-397-0426	3273
360	Kamaria	Wulandari	kamaria.wulandari@yahoo.com	+62 (732) 686-9980	3171
361	Edi	Yuniar	edi.yuniar@yahoo.com	+62 (794) 494 3147	3471
362	Virman	Yuliarti	virman.yuliarti@hotmail.com	+62 (082) 352 8451	7371
363	Kasiyah	Utami	kasiyah.utami@hotmail.com	(009) 107 4638	6471
364	Gaman	Putra	gaman.putra@hotmail.com	(043) 415-4841	1371
365	Laras	Hakim	laras.hakim@hotmail.com	(0101) 507 3340	3573
366	Padmi	Latupono	padmi.latupono@hotmail.com	0810173425	6472
367	Cahyono	Handayani	cahyono.handayani@yahoo.com	+62 (086) 619 1641	3175
368	Paris	Nababan	paris.nababan@gmail.com	(0809) 943 9639	6472
369	Darmanto	Yuniar	darmanto.yuniar@hotmail.com	+62-963-262-7553	3273
370	Artanto	Permata	artanto.permata@hotmail.com	+62-320-483-9861	3573
371	Adikara	Suartini	adikara.suartini@yahoo.com	+62 (0247) 451 5832	3471
372	Jasmin	Sitompul	jasmin.sitompul@hotmail.com	089 726 2994	1371
373	Dalimin	Prasetyo	dalimin.prasetyo@hotmail.com	(075) 465 9918	3172
374	Jarwi	Kuswoyo	jarwi.kuswoyo@yahoo.com	+62 (0097) 686 4188	1371
375	Padma	Wulandari	padma.wulandari@yahoo.com	+62-0776-327-5050	3273
376	Amalia	Lestari	amalia.lestari@gmail.com	+62 (82) 846-7021	3273
377	Wani	Kusumo	wani.kusumo@yahoo.com	+62 (067) 079-4775	3173
378	Elma	Sirait	elma.sirait@gmail.com	+62 (72) 989-4837	3471
379	Jaswadi	Pratama	jaswadi.pratama@hotmail.com	+62 (184) 722-0716	7371
380	Kuncara	Setiawan	kuncara.setiawan@hotmail.com	+62-0393-176-8094	3578
381	Elma	Dongoran	elma.dongoran@gmail.com	+62-39-229-5883	3578
382	Eli	Rahimah	eli.rahimah@hotmail.com	(003) 616-8206	3273
383	Cahyanto	Pertiwi	cahyanto.pertiwi@gmail.com	+62 (696) 834 5616	3173
384	Jaswadi	Halimah	jaswadi.halimah@gmail.com	+62 (007) 326-9139	3175
385	Ikin	Santoso	ikin.santoso@gmail.com	+62 (0459) 143-6893	6472
386	Laras	Kuswoyo	laras.kuswoyo@gmail.com	+62 (945) 627 2784	7371
387	Nrima	Hidayat	nrima.hidayat@hotmail.com	+62 (0020) 122 9976	5171
388	Makara	Haryanto	makara.haryanto@gmail.com	+62-086-608-4076	6472
389	Dalimin	Puspasari	dalimin.puspasari@hotmail.com	+62-703-021-5750	3173
390	Farah	Lestari	farah.lestari@gmail.com	+62 (0624) 566 7392	5171
391	Catur	Sirait	catur.sirait@yahoo.com	+62 (841) 319-1410	1375
392	Luis	Nurdiyanti	luis.nurdiyanti@yahoo.com	+62 (904) 482-0070	3573
393	Bakti	Habibi	bakti.habibi@hotmail.com	+62-641-431-5371	3471
394	Bakiadi	Winarsih	bakiadi.winarsih@hotmail.com	+62 (908) 368-0126	3174
395	Ilyas	Hidayanto	ilyas.hidayanto@gmail.com	+62-10-004-0270	5171
396	Omar	Mayasari	omar.mayasari@hotmail.com	0829555307	7371
397	Opung	Setiawan	opung.setiawan@hotmail.com	+62 (373) 214-3374	3172
398	Tri	Hutasoit	tri.hutasoit@yahoo.com	+62 (0514) 698 3979	5171
399	Jagaraga	Utami	jagaraga.utami@yahoo.com	+62 (0460) 185-7072	3471
400	Rika	Halimah	rika.halimah@gmail.com	+62 (0289) 496-2290	5171
\.


--
-- TOC entry 3410 (class 0 OID 0)
-- Dependencies: 221
-- Name: bids_bid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bids_bid_id_seq', 1002, true);


--
-- TOC entry 3237 (class 2606 OID 27640)
-- Name: advertisements advertisements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertisements
    ADD CONSTRAINT advertisements_pkey PRIMARY KEY (ad_id);


--
-- TOC entry 3241 (class 2606 OID 27663)
-- Name: bids bids_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_pkey PRIMARY KEY (bid_id);


--
-- TOC entry 3212 (class 2606 OID 27564)
-- Name: body_types body_types_body_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.body_types
    ADD CONSTRAINT body_types_body_type_name_key UNIQUE (body_type_name);


--
-- TOC entry 3214 (class 2606 OID 27562)
-- Name: body_types body_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.body_types
    ADD CONSTRAINT body_types_pkey PRIMARY KEY (body_type_id);


--
-- TOC entry 3224 (class 2606 OID 27597)
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (car_id);


--
-- TOC entry 3229 (class 2606 OID 27619)
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (location_id);


--
-- TOC entry 3216 (class 2606 OID 27571)
-- Name: manufactures manufactures_manufacture_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufactures
    ADD CONSTRAINT manufactures_manufacture_name_key UNIQUE (manufacture_name);


--
-- TOC entry 3218 (class 2606 OID 27569)
-- Name: manufactures manufactures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufactures
    ADD CONSTRAINT manufactures_pkey PRIMARY KEY (manufacture_id);


--
-- TOC entry 3220 (class 2606 OID 27578)
-- Name: models models_model_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_model_name_key UNIQUE (model_name);


--
-- TOC entry 3222 (class 2606 OID 27576)
-- Name: models models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_pkey PRIMARY KEY (model_id);


--
-- TOC entry 3231 (class 2606 OID 27626)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3233 (class 2606 OID 27628)
-- Name: users users_first_name_last_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_first_name_last_name_key UNIQUE (first_name, last_name);


--
-- TOC entry 3235 (class 2606 OID 27624)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3238 (class 1259 OID 27641)
-- Name: idx_ads_car; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ads_car ON public.advertisements USING btree (car_id);


--
-- TOC entry 3239 (class 1259 OID 27642)
-- Name: idx_ads_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ads_user ON public.advertisements USING btree (user_id);


--
-- TOC entry 3225 (class 1259 OID 27598)
-- Name: idx_cars_body_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cars_body_type ON public.cars USING btree (body_type_id);


--
-- TOC entry 3226 (class 1259 OID 27599)
-- Name: idx_cars_manufacture_model; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cars_manufacture_model ON public.cars USING btree (manufacture_id, model_id);


--
-- TOC entry 3227 (class 1259 OID 27674)
-- Name: idx_locations_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_locations_location ON public.locations USING gist (location);


--
-- TOC entry 3247 (class 2606 OID 27643)
-- Name: advertisements fk_ads_car; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertisements
    ADD CONSTRAINT fk_ads_car FOREIGN KEY (car_id) REFERENCES public.cars(car_id);


--
-- TOC entry 3248 (class 2606 OID 27648)
-- Name: advertisements fk_ads_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advertisements
    ADD CONSTRAINT fk_ads_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3249 (class 2606 OID 27664)
-- Name: bids fk_bid_ads; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bids
    ADD CONSTRAINT fk_bid_ads FOREIGN KEY (ad_id) REFERENCES public.advertisements(ad_id);


--
-- TOC entry 3250 (class 2606 OID 27669)
-- Name: bids fk_bid_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bids
    ADD CONSTRAINT fk_bid_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3243 (class 2606 OID 27600)
-- Name: cars fk_car_body_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT fk_car_body_type FOREIGN KEY (body_type_id) REFERENCES public.body_types(body_type_id);


--
-- TOC entry 3244 (class 2606 OID 27605)
-- Name: cars fk_car_manufacture; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT fk_car_manufacture FOREIGN KEY (manufacture_id) REFERENCES public.manufactures(manufacture_id);


--
-- TOC entry 3245 (class 2606 OID 27610)
-- Name: cars fk_car_model; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT fk_car_model FOREIGN KEY (model_id) REFERENCES public.models(model_id);


--
-- TOC entry 3242 (class 2606 OID 27579)
-- Name: models fk_car_model_manufacture; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT fk_car_model_manufacture FOREIGN KEY (manufacture_id) REFERENCES public.manufactures(manufacture_id);


--
-- TOC entry 3246 (class 2606 OID 27629)
-- Name: users fk_user_location; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_location FOREIGN KEY (location_id) REFERENCES public.locations(location_id);


-- Completed on 2023-09-06 14:30:07

--
-- PostgreSQL database dump complete
--

