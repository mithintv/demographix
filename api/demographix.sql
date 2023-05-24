--
-- PostgreSQL database dump
--

-- Dumped from database version 13.10 (Ubuntu 13.10-1.pgdg20.04+1)
-- Dumped by pg_dump version 13.10 (Ubuntu 13.10-1.pgdg20.04+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO mithin;

--
-- Name: also_known_as; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.also_known_as (
    id integer NOT NULL,
    name character varying NOT NULL,
    cast_member_id integer
);


ALTER TABLE public.also_known_as OWNER TO mithin;

--
-- Name: also_known_as_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.also_known_as_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.also_known_as_id_seq OWNER TO mithin;

--
-- Name: also_known_as_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.also_known_as_id_seq OWNED BY public.also_known_as.id;


--
-- Name: alt_countries; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.alt_countries (
    id integer NOT NULL,
    country_id character varying(3),
    alt_name character varying(75)
);


ALTER TABLE public.alt_countries OWNER TO mithin;

--
-- Name: alt_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.alt_countries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alt_countries_id_seq OWNER TO mithin;

--
-- Name: alt_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.alt_countries_id_seq OWNED BY public.alt_countries.id;


--
-- Name: alt_ethnicities; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.alt_ethnicities (
    id integer NOT NULL,
    ethnicity_id integer NOT NULL,
    alt_name character varying(75)
);


ALTER TABLE public.alt_ethnicities OWNER TO mithin;

--
-- Name: alt_ethnicities_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.alt_ethnicities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alt_ethnicities_id_seq OWNER TO mithin;

--
-- Name: alt_ethnicities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.alt_ethnicities_id_seq OWNED BY public.alt_ethnicities.id;


--
-- Name: cast_ethnicities; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.cast_ethnicities (
    id integer NOT NULL,
    ethnicity_id integer,
    cast_member_id integer
);


ALTER TABLE public.cast_ethnicities OWNER TO mithin;

--
-- Name: cast_ethnicities_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.cast_ethnicities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cast_ethnicities_id_seq OWNER TO mithin;

--
-- Name: cast_ethnicities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.cast_ethnicities_id_seq OWNED BY public.cast_ethnicities.id;


--
-- Name: cast_ethnicity_source_links; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.cast_ethnicity_source_links (
    id integer NOT NULL,
    source_link_id integer,
    cast_ethnicity_id integer
);


ALTER TABLE public.cast_ethnicity_source_links OWNER TO mithin;

--
-- Name: cast_ethnicity_source_links_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.cast_ethnicity_source_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cast_ethnicity_source_links_id_seq OWNER TO mithin;

--
-- Name: cast_ethnicity_source_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.cast_ethnicity_source_links_id_seq OWNED BY public.cast_ethnicity_source_links.id;


--
-- Name: cast_members; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.cast_members (
    id integer NOT NULL,
    imdb_id character varying(15),
    name character varying(50) NOT NULL,
    gender_id integer NOT NULL,
    birthday timestamp without time zone,
    deathday timestamp without time zone,
    biography character varying,
    country_of_birth_id character varying(3),
    profile_path character varying(35)
);


ALTER TABLE public.cast_members OWNER TO mithin;

--
-- Name: cast_members_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.cast_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cast_members_id_seq OWNER TO mithin;

--
-- Name: cast_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.cast_members_id_seq OWNED BY public.cast_members.id;


--
-- Name: cast_races; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.cast_races (
    id integer NOT NULL,
    race_id integer,
    cast_member_id integer
);


ALTER TABLE public.cast_races OWNER TO mithin;

--
-- Name: cast_races_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.cast_races_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cast_races_id_seq OWNER TO mithin;

--
-- Name: cast_races_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.cast_races_id_seq OWNED BY public.cast_races.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.countries (
    id character varying(3) NOT NULL,
    name character varying(75) NOT NULL,
    demonym character varying(75),
    region_id integer NOT NULL,
    subregion_id integer NOT NULL
);


ALTER TABLE public.countries OWNER TO mithin;

--
-- Name: credits; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.credits (
    id character varying NOT NULL,
    movie_id integer NOT NULL,
    "character" character varying(50),
    "order" integer,
    cast_member_id integer NOT NULL
);


ALTER TABLE public.credits OWNER TO mithin;

--
-- Name: ethnicities; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.ethnicities (
    id integer NOT NULL,
    name character varying(75) NOT NULL,
    region_id integer,
    subregion_id integer
);


ALTER TABLE public.ethnicities OWNER TO mithin;

--
-- Name: ethnicities_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.ethnicities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ethnicities_id_seq OWNER TO mithin;

--
-- Name: ethnicities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.ethnicities_id_seq OWNED BY public.ethnicities.id;


--
-- Name: genders; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.genders (
    id integer NOT NULL,
    name character varying(20)
);


ALTER TABLE public.genders OWNER TO mithin;

--
-- Name: genders_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.genders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.genders_id_seq OWNER TO mithin;

--
-- Name: genders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.genders_id_seq OWNED BY public.genders.id;


--
-- Name: genres; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.genres (
    id integer NOT NULL,
    name character varying(15)
);


ALTER TABLE public.genres OWNER TO mithin;

--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.genres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.genres_id_seq OWNER TO mithin;

--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.genres_id_seq OWNED BY public.genres.id;


--
-- Name: media_genres; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.media_genres (
    id integer NOT NULL,
    genre_id integer,
    movie_id integer
);


ALTER TABLE public.media_genres OWNER TO mithin;

--
-- Name: media_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.media_genres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.media_genres_id_seq OWNER TO mithin;

--
-- Name: media_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.media_genres_id_seq OWNED BY public.media_genres.id;


--
-- Name: movies; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.movies (
    id integer NOT NULL,
    imdb_id character varying(15),
    title character varying(255),
    overview character varying,
    runtime integer,
    poster_path character varying,
    release_date timestamp without time zone,
    budget integer,
    revenue integer
);


ALTER TABLE public.movies OWNER TO mithin;

--
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.movies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movies_id_seq OWNER TO mithin;

--
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.movies_id_seq OWNED BY public.movies.id;


--
-- Name: races; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.races (
    id integer NOT NULL,
    name character varying(75),
    short character varying(5),
    description character varying
);


ALTER TABLE public.races OWNER TO mithin;

--
-- Name: races_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.races_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.races_id_seq OWNER TO mithin;

--
-- Name: races_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.races_id_seq OWNED BY public.races.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    name character varying(15)
);


ALTER TABLE public.regions OWNER TO mithin;

--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.regions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.regions_id_seq OWNER TO mithin;

--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: source_links; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.source_links (
    id integer NOT NULL,
    source_id integer,
    link character varying
);


ALTER TABLE public.source_links OWNER TO mithin;

--
-- Name: source_links_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.source_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.source_links_id_seq OWNER TO mithin;

--
-- Name: source_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.source_links_id_seq OWNED BY public.source_links.id;


--
-- Name: sources; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.sources (
    id integer NOT NULL,
    name character varying(25),
    domain character varying
);


ALTER TABLE public.sources OWNER TO mithin;

--
-- Name: sources_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.sources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sources_id_seq OWNER TO mithin;

--
-- Name: sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.sources_id_seq OWNED BY public.sources.id;


--
-- Name: subregions; Type: TABLE; Schema: public; Owner: mithin
--

CREATE TABLE public.subregions (
    id integer NOT NULL,
    name character varying(25),
    region_id integer
);


ALTER TABLE public.subregions OWNER TO mithin;

--
-- Name: subregions_id_seq; Type: SEQUENCE; Schema: public; Owner: mithin
--

CREATE SEQUENCE public.subregions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subregions_id_seq OWNER TO mithin;

--
-- Name: subregions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mithin
--

ALTER SEQUENCE public.subregions_id_seq OWNED BY public.subregions.id;


--
-- Name: also_known_as id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.also_known_as ALTER COLUMN id SET DEFAULT nextval('public.also_known_as_id_seq'::regclass);


--
-- Name: alt_countries id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.alt_countries ALTER COLUMN id SET DEFAULT nextval('public.alt_countries_id_seq'::regclass);


--
-- Name: alt_ethnicities id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.alt_ethnicities ALTER COLUMN id SET DEFAULT nextval('public.alt_ethnicities_id_seq'::regclass);


--
-- Name: cast_ethnicities id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_ethnicities ALTER COLUMN id SET DEFAULT nextval('public.cast_ethnicities_id_seq'::regclass);


--
-- Name: cast_ethnicity_source_links id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_ethnicity_source_links ALTER COLUMN id SET DEFAULT nextval('public.cast_ethnicity_source_links_id_seq'::regclass);


--
-- Name: cast_members id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_members ALTER COLUMN id SET DEFAULT nextval('public.cast_members_id_seq'::regclass);


--
-- Name: cast_races id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_races ALTER COLUMN id SET DEFAULT nextval('public.cast_races_id_seq'::regclass);


--
-- Name: ethnicities id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.ethnicities ALTER COLUMN id SET DEFAULT nextval('public.ethnicities_id_seq'::regclass);


--
-- Name: genders id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.genders ALTER COLUMN id SET DEFAULT nextval('public.genders_id_seq'::regclass);


--
-- Name: genres id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.genres ALTER COLUMN id SET DEFAULT nextval('public.genres_id_seq'::regclass);


--
-- Name: media_genres id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.media_genres ALTER COLUMN id SET DEFAULT nextval('public.media_genres_id_seq'::regclass);


--
-- Name: movies id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);


--
-- Name: races id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.races ALTER COLUMN id SET DEFAULT nextval('public.races_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: source_links id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.source_links ALTER COLUMN id SET DEFAULT nextval('public.source_links_id_seq'::regclass);


--
-- Name: sources id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.sources ALTER COLUMN id SET DEFAULT nextval('public.sources_id_seq'::regclass);


--
-- Name: subregions id; Type: DEFAULT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.subregions ALTER COLUMN id SET DEFAULT nextval('public.subregions_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.alembic_version (version_num) FROM stdin;
dfd6c723d08b
\.


--
-- Data for Name: also_known_as; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.also_known_as (id, name, cast_member_id) FROM stdin;
\.


--
-- Data for Name: alt_countries; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.alt_countries (id, country_id, alt_name) FROM stdin;
1	ESP	ES
2	ESP	Kingdom of Spain
3	ESP	Reino de España
4	AFG	AF
5	AFG	Afġānistān
6	SDN	SD
7	SDN	Republic of the Sudan
8	SDN	Jumhūrīyat as-Sūdān
9	BGR	BG
10	BGR	Republic of Bulgaria
11	BGR	Република България
12	DEU	DE
13	DEU	Federal Republic of Germany
14	DEU	Bundesrepublik Deutschland
15	LTU	LT
16	LTU	Republic of Lithuania
17	LTU	Lietuvos Respublika
18	MYT	YT
19	MYT	Department of Mayotte
20	MYT	Département de Mayotte
21	MHL	MH
22	MHL	Republic of the Marshall Islands
23	MHL	Aolepān Aorōkin M̧ajeļ
24	POL	PL
25	POL	Republic of Poland
26	POL	Rzeczpospolita Polska
27	TKL	TK
28	TZA	TZ
29	TZA	Tanzania, United Republic of
30	TZA	United Republic of Tanzania
31	TZA	Jamhuri ya Muungano wa Tanzania
32	MAC	MO
33	MAC	澳门
34	MAC	Macao
35	MAC	Macao Special Administrative Region of the People's Republic of China
36	MAC	中華人民共和國澳門特別行政區
37	MAC	Região Administrativa Especial de Macau da República Popular da China
38	TLS	TL
39	TLS	East Timor
40	TLS	Democratic Republic of Timor-Leste
41	TLS	República Democrática de Timor-Leste
42	TLS	Repúblika Demokrátika Timór-Leste
43	TLS	Timór Lorosa'e
44	TLS	Timor Lorosae
45	TGO	TG
46	TGO	Togolese
47	TGO	Togolese Republic
48	TGO	République Togolaise
49	CZE	CZ
50	CZE	Česká republika
51	CZE	Česko
52	MCO	MC
53	MCO	Principality of Monaco
54	MCO	Principauté de Monaco
55	UGA	UG
56	UGA	Republic of Uganda
57	UGA	Jamhuri ya Uganda
58	TTO	TT
59	TTO	Republic of Trinidad and Tobago
60	DZA	DZ
61	DZA	Dzayer
62	DZA	Algérie
63	UKR	UA
64	UKR	Ukrayina
65	EST	EE
66	EST	Eesti
67	EST	Republic of Estonia
68	EST	Eesti Vabariik
69	GRC	GR
70	GRC	Elláda
71	GRC	Hellenic Republic
72	GRC	Ελληνική Δημοκρατία
73	MRT	MR
74	MRT	Islamic Republic of Mauritania
75	MRT	al-Jumhūriyyah al-ʾIslāmiyyah al-Mūrītāniyyah
76	GEO	GE
77	GEO	Sakartvelo
78	SXM	SX
79	SXM	Sint Maarten (Dutch part)
80	NAM	NA
81	NAM	Namibië
82	NAM	Republic of Namibia
83	MKD	MK
84	MKD	The former Yugoslav Republic of Macedonia
85	MKD	Republic of North Macedonia
86	MKD	Macedonia, The Former Yugoslav Republic of
87	MKD	Република Северна Македонија
88	MUS	MU
89	MUS	Republic of Mauritius
90	MUS	République de Maurice
91	KIR	KI
92	KIR	Republic of Kiribati
93	KIR	Ribaberiki Kiribati
94	COG	CG
95	COG	Congo
96	COG	Congo-Brazzaville
97	GNQ	GQ
98	GNQ	Republic of Equatorial Guinea
99	GNQ	República de Guinea Ecuatorial
100	GNQ	République de Guinée équatoriale
101	GNQ	República da Guiné Equatorial
102	IOT	IO
103	NIU	NU
104	UNK	XK
105	UNK	Република Косово
106	PLW	PW
107	PLW	Republic of Palau
108	PLW	Beluu er a Belau
109	QAT	QA
110	QAT	State of Qatar
111	QAT	Dawlat Qaṭar
112	USA	US
113	USA	USA
114	USA	United States of America
115	CYM	KY
116	BWA	BW
117	BWA	Republic of Botswana
118	BWA	Lefatshe la Botswana
119	PSE	PS
120	PSE	Palestine, State of
121	PSE	State of Palestine
122	PSE	Dawlat Filasṭin
123	ZAF	ZA
124	ZAF	RSA
125	ZAF	Suid-Afrika
126	ZAF	Republic of South Africa
127	VNM	VN
128	VNM	Socialist Republic of Vietnam
129	VNM	Cộng hòa Xã hội chủ nghĩa Việt Nam
130	VNM	Viet Nam
131	JEY	JE
132	JEY	Bailiwick of Jersey
133	JEY	Bailliage de Jersey
134	JEY	Bailliage dé Jèrri
135	GUY	GY
136	GUY	Co-operative Republic of Guyana
137	TUV	TV
138	JOR	JO
139	JOR	Hashemite Kingdom of Jordan
140	JOR	al-Mamlakah al-Urdunīyah al-Hāshimīyah
141	PNG	PG
142	PNG	Independent State of Papua New Guinea
143	PNG	Independen Stet bilong Papua Niugini
144	BHS	BS
145	BHS	Commonwealth of the Bahamas
146	CPV	CV
147	CPV	Republic of Cabo Verde
148	CPV	República de Cabo Verde
149	OMN	OM
150	OMN	Sultanate of Oman
151	OMN	Salṭanat ʻUmān
152	VEN	VE
153	VEN	Bolivarian Republic of Venezuela
154	VEN	Venezuela, Bolivarian Republic of
155	VEN	República Bolivariana de Venezuela
156	BOL	BO
157	BOL	Buliwya
158	BOL	Wuliwya
159	BOL	Bolivia, Plurinational State of
160	BOL	Plurinational State of Bolivia
161	BOL	Estado Plurinacional de Bolivia
162	BOL	Buliwya Mamallaqta
163	BOL	Wuliwya Suyu
164	BOL	Tetã Volívia
165	EGY	EG
166	EGY	Arab Republic of Egypt
167	CAN	CA
168	NOR	NO
169	NOR	Norge
170	NOR	Noreg
171	NOR	Kingdom of Norway
172	NOR	Kongeriket Norge
173	NOR	Kongeriket Noreg
174	KGZ	KG
175	KGZ	Киргизия
176	KGZ	Kyrgyz Republic
177	KGZ	Кыргыз Республикасы
178	KGZ	Kyrgyz Respublikasy
179	ARM	AM
180	ARM	Hayastan
181	ARM	Republic of Armenia
182	ARM	Հայաստանի Հանրապետություն
183	COD	CD
184	COD	DR Congo
185	COD	Congo-Kinshasa
186	COD	Congo, the Democratic Republic of the
187	COD	DRC
188	PRI	PR
189	PRI	Commonwealth of Puerto Rico
190	PRI	Estado Libre Asociado de Puerto Rico
191	LIE	LI
192	LIE	Principality of Liechtenstein
193	LIE	Fürstentum Liechtenstein
194	SWZ	SZ
195	SWZ	Swaziland
196	SWZ	weSwatini
197	SWZ	Swatini
198	SWZ	Ngwane
199	SWZ	Kingdom of Eswatini
200	SWZ	Umbuso weSwatini
201	FRO	FO
202	FRO	Føroyar
203	FRO	Færøerne
204	NGA	NG
205	NGA	Nijeriya
206	NGA	Naíjíríà
207	NGA	Federal Republic of Nigeria
208	MAF	MF
209	MAF	Collectivity of Saint Martin
210	MAF	Collectivité de Saint-Martin
211	MAF	Saint Martin (French part)
212	GUM	GU
213	GUM	Guåhån
214	MWI	MW
215	MWI	Republic of Malawi
216	ALA	AX
217	ALA	Aaland
218	ALA	Aland
219	ALA	Ahvenanmaa
220	STP	ST
221	STP	Democratic Republic of São Tomé and Príncipe
222	STP	Sao Tome and Principe
223	STP	República Democrática de São Tomé e Príncipe
224	FLK	FK
225	FLK	Islas Malvinas
226	FLK	Falkland Islands (Malvinas)
227	GTM	GT
228	BRB	BB
229	GHA	GH
230	NIC	NI
231	NIC	Republic of Nicaragua
232	NIC	República de Nicaragua
233	IMN	IM
234	IMN	Ellan Vannin
235	IMN	Mann
236	IMN	Mannin
237	PRT	PT
238	PRT	Portuguesa
239	PRT	Portuguese Republic
240	PRT	República Portuguesa
241	AGO	AO
242	AGO	República de Angola
243	AGO	ʁɛpublika de an'ɡɔla
244	DOM	DO
245	ALB	AL
246	ALB	Shqipëri
247	ALB	Shqipëria
248	ALB	Shqipnia
249	GNB	GW
250	GNB	Republic of Guinea-Bissau
251	GNB	República da Guiné-Bissau
252	LBY	LY
253	LBY	State of Libya
254	LBY	Dawlat Libya
255	KWT	KW
256	KWT	State of Kuwait
257	KWT	Dawlat al-Kuwait
258	BHR	BH
259	BHR	Kingdom of Bahrain
260	BHR	Mamlakat al-Baḥrayn
261	TKM	TM
262	LBR	LR
263	LBR	Republic of Liberia
264	BFA	BF
265	LVA	LV
266	LVA	Republic of Latvia
267	LVA	Latvijas Republika
268	RUS	RU
269	RUS	Russian Federation
270	RUS	Российская Федерация
271	PHL	PH
272	PHL	Republic of the Philippines
273	PHL	Repúblika ng Pilipinas
274	NZL	NZ
275	NZL	Aotearoa
276	CMR	CM
277	CMR	Republic of Cameroon
278	CMR	République du Cameroun
279	ECU	EC
280	ECU	Republic of Ecuador
281	ECU	República del Ecuador
282	AIA	AI
283	ROU	RO
284	ROU	Rumania
285	ROU	Roumania
286	ROU	România
287	IND	IN
288	IND	Bhārat
289	IND	Republic of India
290	IND	Bharat Ganrajya
291	IND	இந்தியா
292	GAB	GA
293	GAB	Gabonese Republic
294	GAB	République Gabonaise
295	MMR	MM
296	MMR	Burma
297	MMR	Republic of the Union of Myanmar
298	MMR	Pyidaunzu Thanmăda Myăma Nainngandaw
299	REU	RE
300	REU	Reunion
301	ASM	AS
302	ASM	Amerika Sāmoa
303	ASM	Amelika Sāmoa
304	ASM	Sāmoa Amelika
305	MNE	ME
306	MNE	Crna Gora
307	BLZ	BZ
308	MNG	MN
309	AUT	AT
310	AUT	Osterreich
311	AUT	Oesterreich
312	MSR	MS
313	SAU	Saudi
314	SAU	SA
315	SAU	Kingdom of Saudi Arabia
316	SAU	Al-Mamlakah al-‘Arabiyyah as-Su‘ūdiyyah
317	HUN	HU
318	NRU	NR
319	NRU	Naoero
320	NRU	Pleasant Island
321	NRU	Republic of Nauru
322	NRU	Ripublik Naoero
323	ARG	AR
324	ARG	Argentine Republic
325	ARG	República Argentina
326	PCN	PN
327	PCN	Pitcairn
328	PCN	Pitcairn Henderson Ducie and Oeno Islands
329	WLF	WF
330	WLF	Territory of the Wallis and Futuna Islands
331	WLF	Territoire des îles Wallis et Futuna
332	YEM	YE
333	YEM	Yemeni Republic
334	YEM	al-Jumhūriyyah al-Yamaniyyah
335	SVK	SK
336	SVK	Slovak Republic
337	SVK	Slovenská republika
338	TCA	TC
339	SWE	SE
340	SWE	Kingdom of Sweden
341	SWE	Konungariket Sverige
342	SHN	Saint Helena
343	SHN	St. Helena, Ascension and Tristan da Cunha
344	ITA	IT
345	ITA	Italian Republic
346	ITA	Repubblica italiana
347	BRA	BR
348	BRA	Brasil
349	BRA	Federative Republic of Brazil
350	BRA	República Federativa do Brasil
351	SSD	SS
352	CYP	CY
353	CYP	Kýpros
354	CYP	Kıbrıs
355	CYP	Republic of Cyprus
356	CYP	Κυπριακή Δημοκρατία
357	CYP	Kıbrıs Cumhuriyeti
358	THA	TH
359	THA	Prathet
360	THA	Thai
361	THA	Kingdom of Thailand
362	THA	ราชอาณาจักรไทย
363	THA	Ratcha Anachak Thai
364	TUR	TR
365	TUR	Turkiye
366	TUR	Republic of Turkey
367	TUR	Türkiye Cumhuriyeti
368	BMU	BM
369	BMU	The Islands of Bermuda
370	BMU	The Bermudas
371	BMU	Somers Isles
372	AUS	AU
373	BGD	BD
374	BGD	People's Republic of Bangladesh
375	BGD	Gônôprôjatôntri Bangladesh
376	GRD	GD
377	SGP	SG
378	SGP	Singapura
379	SGP	Republik Singapura
380	SGP	新加坡共和国
381	MDA	MD
382	MDA	Moldova, Republic of
383	MDA	Republic of Moldova
384	MDA	Republica Moldova
385	MLI	ML
386	MLI	Republic of Mali
387	MLI	République du Mali
388	KEN	KE
389	KEN	Republic of Kenya
390	KEN	Jamhuri ya Kenya
391	URY	UY
392	URY	Oriental Republic of Uruguay
393	URY	República Oriental del Uruguay
394	CHE	CH
395	CHE	Swiss Confederation
396	CHE	Schweiz
397	CHE	Suisse
398	CHE	Svizzera
399	CHE	Svizra
400	SLV	SV
401	SLV	Republic of El Salvador
402	SLV	República de El Salvador
403	TCD	TD
404	TCD	Tchad
405	TCD	Republic of Chad
406	TCD	République du Tchad
407	GRL	GL
408	GRL	Grønland
409	BLR	BY
410	BLR	Bielaruś
411	BLR	Republic of Belarus
412	BLR	Белоруссия
413	BLR	Республика Белоруссия
414	CIV	CI
415	CIV	Côte d'Ivoire
416	CIV	Ivory Coast
417	CIV	Republic of Côte d'Ivoire
418	CIV	République de Côte d'Ivoire
419	LBN	LB
420	LBN	Lebanese Republic
421	LBN	Al-Jumhūrīyah Al-Libnānīyah
422	NLD	NL
423	NLD	Holland
424	NLD	Nederland
425	NLD	The Netherlands
426	SMR	SM
427	SMR	Republic of San Marino
428	SMR	Repubblica di San Marino
429	BTN	BT
430	BTN	Kingdom of Bhutan
431	MYS	MY
432	KAZ	KZ
433	KAZ	Qazaqstan
434	KAZ	Казахстан
435	KAZ	Republic of Kazakhstan
436	KAZ	Қазақстан Республикасы
437	KAZ	Qazaqstan Respublïkası
438	KAZ	Республика Казахстан
439	KAZ	Respublika Kazakhstan
440	FIN	FI
441	FIN	Suomi
442	FIN	Republic of Finland
443	FIN	Suomen tasavalta
444	FIN	Republiken Finland
445	TUN	TN
446	TUN	Republic of Tunisia
447	TUN	al-Jumhūriyyah at-Tūnisiyyah
448	GMB	GM
449	GMB	Republic of the Gambia
450	SYR	SY
451	SYR	Syrian Arab Republic
452	SYR	Al-Jumhūrīyah Al-ʻArabīyah As-Sūrīyah
453	ATF	TF
454	ATF	French Southern Territories
455	NFK	NF
456	NFK	Territory of Norfolk Island
457	NFK	Teratri of Norf'k Ailen
458	GIN	GN
459	GIN	Republic of Guinea
460	GIN	République de Guinée
461	BES	BES islands
462	MOZ	MZ
463	MOZ	Republic of Mozambique
464	MOZ	República de Moçambique
465	WSM	WS
466	WSM	Independent State of Samoa
467	WSM	Malo Saʻoloto Tutoʻatasi o Sāmoa
468	TWN	TW
469	TWN	Táiwān
470	TWN	Republic of China
471	TWN	中華民國
472	TWN	Zhōnghuá Mínguó
473	TWN	Chinese Taipei
474	SGS	GS
475	SGS	South Georgia and the South Sandwich Islands
476	PRK	KP
477	PRK	Democratic People's Republic of Korea
478	PRK	DPRK
479	PRK	조선민주주의인민공화국
480	PRK	Chosŏn Minjujuŭi Inmin Konghwaguk
481	PRK	Korea, Democratic People's Republic of
482	PRK	북한
483	PRK	북조선
484	DJI	DJ
485	DJI	Jabuuti
486	DJI	Gabuuti
487	DJI	Republic of Djibouti
488	DJI	République de Djibouti
489	DJI	Gabuutih Ummuuno
490	DJI	Jamhuuriyadda Jabuuti
491	SUR	SR
492	SUR	Sarnam
493	SUR	Sranangron
494	SUR	Republic of Suriname
495	SUR	Republiek Suriname
496	FRA	FR
497	FRA	French Republic
498	FRA	République française
499	RWA	RW
500	RWA	Republic of Rwanda
501	RWA	Repubulika y'u Rwanda
502	RWA	République du Rwanda
503	KOR	KR
504	KOR	Korea, Republic of
505	KOR	Republic of Korea
506	KOR	남한
507	KOR	남조선
508	ATA	AQ
509	CUW	CW
510	CUW	Curacao
511	CUW	Kòrsou
512	CUW	Country of Curaçao
513	CUW	Land Curaçao
514	CUW	Pais Kòrsou
515	JAM	JM
516	MDV	MV
517	MDV	Maldive Islands
518	MDV	Republic of the Maldives
519	MDV	Dhivehi Raajjeyge Jumhooriyya
520	SVN	SI
521	SVN	Republic of Slovenia
522	SVN	Republika Slovenija
523	CXR	CX
524	CXR	Territory of Christmas Island
525	VIR	VI
526	VIR	Virgin Islands, U.S.
527	PRY	PY
528	PRY	Republic of Paraguay
529	PRY	República del Paraguay
530	PRY	Tetã Paraguái
531	IDN	ID
532	IDN	Republic of Indonesia
533	IDN	Republik Indonesia
534	MDG	MG
535	MDG	Republic of Madagascar
536	MDG	Repoblikan'i Madagasikara
537	MDG	République de Madagascar
538	IRQ	IQ
539	IRQ	Republic of Iraq
540	IRQ	Jumhūriyyat al-‘Irāq
541	HND	HN
542	HND	Republic of Honduras
543	HND	República de Honduras
544	MAR	MA
545	MAR	Kingdom of Morocco
546	MAR	Al-Mamlakah al-Maġribiyah
547	HKG	HK
548	ATG	AG
549	LKA	LK
550	LKA	ilaṅkai
551	LKA	Democratic Socialist Republic of Sri Lanka
552	HTI	HT
553	HTI	Republic of Haiti
554	HTI	République d'Haïti
555	HTI	Repiblik Ayiti
556	CUB	CU
557	CUB	Republic of Cuba
558	CUB	República de Cuba
559	TJK	TJ
560	TJK	Toçikiston
561	TJK	Republic of Tajikistan
562	TJK	Ҷумҳурии Тоҷикистон
563	TJK	Çumhuriyi Toçikiston
564	COK	CK
565	COK	Kūki 'Āirani
566	COL	CO
567	COL	Republic of Colombia
568	COL	República de Colombia
569	FSM	FM
570	FSM	Federated States of Micronesia
571	FSM	Micronesia, Federated States of
572	MNP	MP
573	MNP	Commonwealth of the Northern Mariana Islands
574	MNP	Sankattan Siha Na Islas Mariånas
575	KNA	KN
576	KNA	Federation of Saint Christopher and Nevis
577	UZB	UZ
578	UZB	Republic of Uzbekistan
579	UZB	O‘zbekiston Respublikasi
580	UZB	Ўзбекистон Республикаси
581	GIB	GI
582	IRL	IE
583	IRL	Éire
584	IRL	Republic of Ireland
585	IRL	Poblacht na hÉireann
586	PER	PE
587	PER	Republic of Peru
588	PER	República del Perú
589	PAK	PK
590	PAK	Pākistān
591	PAK	Islamic Republic of Pakistan
592	PAK	Islāmī Jumhūriya'eh Pākistān
593	CHL	CL
594	CHL	Republic of Chile
595	CHL	República de Chile
596	ZMB	ZM
597	ZMB	Republic of Zambia
598	LCA	LC
599	SYC	SC
600	SYC	Republic of Seychelles
601	SYC	Repiblik Sesel
602	SYC	République des Seychelles
603	BEN	BJ
604	BEN	Republic of Benin
605	BEN	République du Bénin
606	GBR	GB
607	GBR	UK
608	GBR	Great Britain
609	BVT	BV
610	BVT	Bouvetøya
611	BVT	Bouvet-øya
612	CRI	CR
613	CRI	Republic of Costa Rica
614	CRI	República de Costa Rica
615	COM	KM
616	COM	Union of the Comoros
617	COM	Union des Comores
618	COM	Udzima wa Komori
619	COM	al-Ittiḥād al-Qumurī
620	ISL	IS
621	ISL	Island
622	ISL	Republic of Iceland
623	ISL	Lýðveldið Ísland
624	JPN	JP
625	JPN	Nippon
626	JPN	Nihon
627	VAT	VA
628	VAT	Holy See (Vatican City State)
629	VAT	Vatican City State
630	VAT	Stato della Città del Vaticano
631	VGB	VG
632	VGB	Virgin Islands, British
633	NCL	NC
634	FJI	FJ
635	FJI	Viti
636	FJI	Republic of Fiji
637	FJI	Matanitu ko Viti
638	FJI	Fijī Gaṇarājya
639	BIH	BA
640	BIH	Bosnia-Herzegovina
641	BIH	Босна и Херцеговина
642	CCK	CC
643	CCK	Keeling Islands
644	CCK	Cocos Islands
645	ESH	EH
646	ESH	Taneẓroft Tutrimt
647	MEX	MX
648	MEX	Mexicanos
649	MEX	United Mexican States
650	MEX	Estados Unidos Mexicanos
651	KHM	KH
652	KHM	Kingdom of Cambodia
653	VCT	VC
654	IRN	IR
655	IRN	Islamic Republic of Iran
656	IRN	Iran, Islamic Republic of
657	IRN	Jomhuri-ye Eslāmi-ye Irān
658	MLT	MT
659	MLT	Republic of Malta
660	MLT	Repubblika ta' Malta
661	SRB	RS
662	SRB	Srbija
663	SRB	Republic of Serbia
664	SRB	Република Србија
665	SRB	Republika Srbija
666	ARE	AE
667	ARE	UAE
668	ARE	Emirates
669	AZE	AZ
670	AZE	Republic of Azerbaijan
671	AZE	Azərbaycan Respublikası
672	HMD	HM
673	HMD	Heard Island and McDonald Islands
674	PYF	PF
675	PYF	Polynésie française
676	PYF	French Polynesia
677	PYF	Pōrīnetia Farāni
678	VUT	VU
679	VUT	Republic of Vanuatu
680	VUT	Ripablik blong Vanuatu
681	VUT	République de Vanuatu
682	NER	NE
683	NER	Nijar
684	ERI	ER
685	ERI	State of Eritrea
686	ERI	ሃገረ ኤርትራ
687	ERI	Dawlat Iritriyá
688	ERI	ʾErtrā
689	ERI	Iritriyā
690	CAF	CF
691	CAF	Central African Republic
692	CAF	République centrafricaine
693	ISR	IL
694	ISR	State of Israel
695	ISR	Medīnat Yisrā'el
696	NPL	NP
697	NPL	Federal Democratic Republic of Nepal
698	NPL	Loktāntrik Ganatantra Nepāl
699	PAN	PA
700	PAN	Republic of Panama
701	PAN	República de Panamá
702	GGY	GG
703	GGY	Bailiwick of Guernsey
704	GGY	Bailliage de Guernesey
705	SLB	SB
706	ZWE	ZW
707	ZWE	Republic of Zimbabwe
708	ABW	AW
709	BRN	BN
710	BRN	Brunei Darussalam
711	BRN	Nation of Brunei
712	BRN	the Abode of Peace
713	DNK	DK
714	DNK	Danmark
715	DNK	Kingdom of Denmark
716	DNK	Kongeriget Danmark
717	BEL	BE
718	BEL	België
719	BEL	Belgie
720	BEL	Belgien
721	BEL	Belgique
722	BEL	Kingdom of Belgium
723	BEL	Koninkrijk België
724	BEL	Royaume de Belgique
725	BEL	Königreich Belgien
726	GUF	GF
727	GUF	Guiana
728	GUF	Guyane
729	LAO	LA
730	LAO	Lao
731	LAO	Lao People's Democratic Republic
732	LAO	Sathalanalat Paxathipatai Paxaxon Lao
733	TON	TO
734	AND	AD
735	AND	Principality of Andorra
736	AND	Principat d'Andorra
737	GLP	GP
738	GLP	Gwadloup
739	MTQ	MQ
740	LSO	LS
741	LSO	Kingdom of Lesotho
742	LSO	Muso oa Lesotho
743	DMA	DM
744	DMA	Dominique
745	DMA	Wai‘tu kubuli
746	DMA	Commonwealth of Dominica
747	SOM	SO
748	SOM	aṣ-Ṣūmāl
749	SOM	Federal Republic of Somalia
750	SOM	Jamhuuriyadda Federaalka Soomaaliya
751	SOM	Jumhūriyyat aṣ-Ṣūmāl al-Fiderāliyya
752	HRV	HR
753	HRV	Hrvatska
754	HRV	Republic of Croatia
755	HRV	Republika Hrvatska
756	SLE	SL
757	SLE	Republic of Sierra Leone
758	BLM	BL
759	BLM	St. Barthelemy
760	BLM	Collectivity of Saint Barthélemy
761	BLM	Collectivité de Saint-Barthélemy
762	SJM	SJ
763	SJM	Svalbard and Jan Mayen Islands
764	SPM	PM
765	SPM	Collectivité territoriale de Saint-Pierre-et-Miquelon
766	UMI	UM
767	BDI	BI
768	BDI	Republic of Burundi
769	BDI	Republika y'Uburundi
770	BDI	République du Burundi
771	SEN	SN
772	SEN	Republic of Senegal
773	SEN	République du Sénégal
774	ETH	ET
775	ETH	ʾĪtyōṗṗyā
776	ETH	Federal Democratic Republic of Ethiopia
777	ETH	የኢትዮጵያ ፌዴራላዊ ዲሞክራሲያዊ ሪፐብሊክ
778	LUX	LU
779	LUX	Grand Duchy of Luxembourg
780	LUX	Grand-Duché de Luxembourg
781	LUX	Großherzogtum Luxemburg
782	LUX	Groussherzogtum Lëtzebuerg
783	CHN	CN
784	CHN	Zhōngguó
785	CHN	Zhongguo
786	CHN	Zhonghua
787	CHN	People's Republic of China
788	CHN	中华人民共和国
789	CHN	Zhōnghuá Rénmín Gònghéguó
\.


--
-- Data for Name: alt_ethnicities; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.alt_ethnicities (id, ethnicity_id, alt_name) FROM stdin;
1	4	Cajun
2	6	Afghanistani
3	13	Kikuyu
4	24	Amhara
5	25	Imazighen
6	25	Berber
7	29	Indigena
8	29	Indio
9	37	Barbudan
10	41	Arabic
11	44	Argentine
12	51	Chaldean
13	51	Syriac
14	62	Barbadian
15	65	Burman
16	74	Belorussian
17	93	Herzegovinian
18	101	British
19	139	Chicana
20	170	Criolla
21	171	Croat
22	180	Dane
23	208	Philippine
24	209	Finn
25	211	Flemish
26	220	Hausa
27	231	Ghanian
28	252	Native Hawaiian
29	261	Igbo
30	273	Northern Irish
31	273	Irish Protestant
32	281	Java
33	281	Jawa
34	283	Jew
35	283	Ashkenazi Jewish
36	283	Sephardic Jewish
37	292	Qazaq
38	299	Viet
39	303	Nevisian
40	304	Nevis Islander
41	307	Kurd
42	313	Lowland Lao
43	314	Lao
44	320	Latina
45	377	Moldavian
46	405	Nepali
47	433	Oneida
48	448	Pathan
49	455	Pole
50	498	Saudi
51	501	Nordic
52	506	Serb
53	516	Sinhalese
54	518	Slav
55	521	Sloven
56	523	Somali
57	524	Wend
58	539	Vincent-Grenadine Islander
59	547	Dutch Guiana
60	549	Swede
61	564	Tejana
62	565	Temme
63	565	Themne
64	571	Tigray
65	571	Tigraway
66	578	Togo
67	586	Tobagonian
68	595	Turk
69	612	Uzbeg
70	647	Yup'ik Eskimo
71	185	Dominican Republic
72	1	French Breton
74	265	Tamil Indian
75	142	Hoa Chinese
76	461	Azorean Portuguese
\.


--
-- Data for Name: cast_ethnicities; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.cast_ethnicities (id, ethnicity_id, cast_member_id) FROM stdin;
1	550	71580
2	273	71580
3	1	71580
4	229	71580
5	160	71580
6	198	71580
7	502	71580
8	186	71580
9	627	71580
10	198	113505
11	502	113505
12	186	113505
13	229	205
14	455	205
15	549	205
16	550	88124
17	273	88124
18	229	88124
19	198	88124
20	502	88124
21	186	88124
22	627	88124
23	198	1356758
24	135	1356758
25	502	1356758
26	198	4432
27	273	4432
28	273	147056
29	273	1254583
30	198	5309
31	273	5309
32	273	8785
33	273	228866
34	627	228866
35	198	1331023
36	627	1331023
37	283	19797
38	603	1571661
39	273	1571661
40	484	1571661
41	229	1571661
42	198	1571661
43	502	1571661
44	520	1571661
45	1	239574
46	369	239574
47	273	1539216
48	1	1514387
49	114	1514387
50	273	1190668
51	1	1190668
52	198	1190668
53	502	1190668
54	283	1190668
55	273	933238
56	502	933238
57	549	933238
58	242	25072
59	174	25072
60	1	25072
61	283	25072
62	529	25072
63	550	16851
64	273	16851
65	229	16851
66	198	16851
67	502	16851
68	627	16851
69	208	543530
70	235	543530
71	198	543530
72	273	543530
73	8	505710
74	273	505710
75	229	505710
76	198	505710
77	502	505710
78	556	1622
79	198	44079
80	198	117642
81	229	117642
82	252	117642
83	273	3810
84	98	3810
85	71	3810
86	529	3810
87	198	3810
88	2	83854
89	273	83854
90	1	83854
91	277	83854
92	198	83854
93	271	83854
94	8	2888
95	8	53923
96	8	1607523
97	283	19498
98	273	3417
99	229	3417
100	198	3417
101	502	3417
102	283	3417
103	273	32597
104	1	32597
105	277	32597
106	198	32597
107	273	85824
108	1	85824
109	114	85824
110	422	85824
111	198	85824
112	209	85824
113	273	1330888
114	229	1330888
115	422	1330888
116	198	1330888
117	502	1330888
118	455	1330888
119	229	14721
120	198	14721
121	273	14721
122	502	14721
123	283	1741367
124	273	2764542
125	229	2764542
126	277	2764542
127	198	2764542
128	186	2764542
129	273	2228
130	283	2228
131	277	2228
132	550	2887
133	273	2887
134	229	2887
135	422	2887
136	198	2887
137	502	2887
138	627	2887
139	277	51329
140	273	51329
141	283	227564
142	283	61263
143	277	61263
144	273	8265
145	550	4003
146	273	4003
147	229	4003
148	198	4003
149	186	4003
150	273	33528
151	283	1741368
152	283	1741366
153	273	108916
154	1	108916
155	114	108916
156	229	108916
157	277	108916
158	273	112
159	1	112
160	160	112
161	198	112
162	502	112
163	186	112
164	627	112
165	198	3051
166	273	3051
167	502	3051
168	229	28633
169	198	28633
170	273	28633
171	627	28633
172	550	5293
173	273	5293
174	1	5293
175	229	5293
176	198	5293
177	502	5293
178	273	11064
179	252	11064
180	198	11064
181	502	11064
182	142	11064
183	283	2372
184	550	7497
185	273	7497
186	1	7497
187	229	7497
188	198	7497
189	502	7497
190	549	7497
191	186	2453
192	198	2453
193	502	2453
194	627	2453
195	283	1462
196	369	5365
197	229	5365
198	8	5292
199	8	1154054
200	198	178634
201	235	72309
202	198	216425
203	273	2039
204	198	10982
205	8	2042908
206	198	17401
207	502	17401
208	186	17401
209	549	17401
210	627	17401
211	273	1159982
212	229	1159982
213	422	1159982
214	198	1159982
215	149	2217977
216	455	2217977
217	8	1437491
218	1	1437491
219	277	1437491
220	198	1437491
221	502	1437491
222	466	1437491
223	529	2225865
224	7	2225865
225	174	2225865
226	198	175829
227	273	175829
228	627	175829
229	283	74541
230	466	13299
231	1	38673
232	627	38673
233	502	38673
234	273	38673
235	198	38673
236	229	38673
481	550	73457
238	627	824
239	502	824
240	198	824
241	229	824
242	502	109708
243	198	109708
244	229	109708
245	273	109708
246	450	69225
247	1	69225
248	472	69225
249	550	69225
250	229	69225
251	267	1300637
252	502	1300637
253	273	1300637
254	198	1300637
255	229	1300637
256	186	1300637
257	277	98804
258	511	98804
259	627	98804
260	198	98804
261	229	98804
482	229	73457
483	114	73457
484	422	73457
485	198	73457
486	1	73457
487	466	8691
488	322	8691
489	185	8691
490	247	8691
491	502	543261
492	1	139820
493	305	139820
494	483	139820
495	273	12835
277	627	587823
278	198	587823
279	502	587823
280	229	587823
281	273	587823
282	186	565447
283	114	565447
284	198	565447
285	229	565447
286	529	565447
287	273	565447
288	369	565447
289	1	565447
290	8	979216
291	7	979216
292	283	1253648
293	277	1253648
294	198	10581
295	273	10581
296	229	10581
297	283	8700
298	198	8700
299	229	8700
300	198	150062
301	502	150062
302	208	150062
303	8	150062
304	114	4764
305	502	4764
306	229	4764
307	273	4764
308	329	4764
309	1	4764
310	198	1774266
311	273	1774266
312	229	1774266
313	550	1774266
314	195	1473232
315	466	1473232
316	502	1483976
317	229	1483976
318	455	1483976
319	277	1483976
320	198	202032
321	273	202032
322	198	111945
323	273	111945
324	114	111945
325	1	111945
326	114	2475409
327	627	2475409
328	198	2475409
329	502	2475409
330	550	2475409
331	229	2475409
332	455	2475409
333	273	2475409
334	277	2475409
335	1	2475409
336	186	1562074
337	114	1562074
338	198	1562074
339	511	1562074
340	529	1562074
341	277	1562074
342	1	1562074
343	142	2614781
344	283	60960
345	627	60960
346	198	60960
347	502	60960
348	229	60960
349	4	60960
350	273	60960
351	1	60960
352	283	52792
353	8	52792
354	7	11868
355	246	11868
356	186	1277794
357	627	1277794
358	198	1277794
359	502	1277794
360	229	1277794
361	422	1277794
362	1	1277794
363	198	1929092
364	502	1929092
365	186	1929092
366	466	979216
367	654	33527
368	655	33527
371	229	1929092
372	273	1929092
496	229	12835
497	55	12835
498	8	12835
499	198	12835
500	502	12835
501	273	51663
502	229	51663
503	89	51663
504	198	51663
505	178	51663
506	413	105238
507	627	93491
508	198	93491
509	502	93491
510	273	93491
511	103	2408703
512	455	1133349
513	273	1133349
514	283	16483
515	229	16483
516	1	16483
517	277	16483
518	549	18273
519	283	18273
520	273	1817
521	277	1817
522	229	1817
523	198	1817
524	502	1817
525	229	1363394
526	271	1363394
527	277	1363394
528	627	20750
529	506	20750
530	273	20750
531	382	20750
532	229	20750
533	455	20750
534	186	20750
535	198	20750
536	502	20750
537	283	15762
538	283	19975
539	198	96349
540	273	96349
541	229	23680
542	198	23680
543	502	23680
544	273	23680
545	209	51797
546	549	51797
547	550	51797
548	229	51797
549	114	51797
550	422	51797
551	1	51797
552	461	1784612
553	273	12132
554	198	12132
555	502	12132
556	273	15218
557	229	15218
558	89	15218
559	198	15218
560	178	15218
561	198	53266
562	502	53266
563	273	53266
564	283	13922
565	273	1427948
566	277	1427948
567	229	1427948
568	511	1427948
569	283	1427948
570	198	1427948
571	502	1427948
606	142	1620
607	142	690
608	620	690
609	556	1381186
610	142	1381186
611	627	8944
612	273	8944
613	550	8944
614	180	8944
615	283	8944
616	198	8944
617	229	8944
618	1	8944
619	283	213001
620	142	232499
621	265	1375002
622	627	1317730
623	273	1317730
624	502	1317730
625	198	1317730
626	229	1317730
627	556	1383612
628	142	1383612
630	369	1071151
631	502	10982
632	273	10982
633	277	2217977
634	229	2217977
635	186	10581
636	1	10581
637	185	1473232
638	502	1562074
639	229	1562074
640	321	60960
641	277	60960
642	461	11064
\.


--
-- Data for Name: cast_ethnicity_source_links; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.cast_ethnicity_source_links (id, source_link_id, cast_ethnicity_id) FROM stdin;
1	30	1
2	30	2
3	30	3
4	30	4
5	30	5
6	30	6
7	30	7
8	30	8
9	30	9
10	31	10
11	31	11
12	31	12
13	32	13
14	32	14
15	32	15
16	33	16
17	33	17
18	33	18
19	33	19
20	33	20
21	33	21
22	33	22
23	34	23
24	34	24
25	34	25
26	35	26
27	35	27
28	36	28
29	37	29
30	38	30
31	38	31
32	39	32
33	40	33
34	40	34
35	41	35
36	41	36
37	42	37
38	43	38
39	43	39
40	43	40
41	43	41
42	43	42
43	43	43
44	43	44
45	44	45
46	44	46
47	45	47
48	46	48
49	46	49
50	47	50
51	47	51
52	47	52
53	47	53
54	47	54
55	48	55
56	48	56
57	48	57
58	49	58
59	49	59
60	49	60
61	49	61
62	49	62
63	50	63
64	50	64
65	50	65
66	50	66
67	50	67
68	50	68
69	51	69
70	51	70
71	51	71
72	51	72
73	52	73
74	52	74
75	52	75
76	52	76
77	52	77
78	53	78
79	54	79
80	55	80
81	55	81
82	55	82
83	56	83
84	56	84
85	56	85
86	56	86
87	56	87
88	57	88
89	57	89
90	57	90
91	57	91
92	57	92
93	57	93
94	58	94
95	59	95
96	60	96
97	61	97
98	62	98
99	62	99
100	62	100
101	62	101
102	62	102
103	63	103
104	63	104
105	63	105
106	63	106
107	64	107
108	64	108
109	64	109
110	64	110
111	64	111
112	64	112
113	65	113
114	65	114
115	65	115
116	65	116
117	65	117
118	65	118
119	66	119
120	66	120
121	66	121
122	66	122
123	67	123
124	68	124
125	68	125
126	68	126
127	68	127
128	68	128
129	69	129
130	69	130
131	69	131
132	70	132
133	70	133
134	70	134
135	70	135
136	70	136
137	70	137
138	70	138
139	71	139
140	71	140
141	72	141
142	73	142
143	73	143
144	74	144
145	75	145
146	75	146
147	75	147
148	75	148
149	75	149
150	76	150
151	77	151
152	78	152
153	79	153
154	79	154
155	79	155
156	79	156
157	79	157
158	80	158
159	80	159
160	80	160
161	80	161
162	80	162
163	80	163
164	80	164
165	81	165
166	81	166
167	81	167
168	82	168
169	82	169
170	82	170
171	82	171
172	83	172
173	83	173
174	83	174
175	83	175
176	83	176
177	83	177
178	84	178
179	84	179
180	84	180
181	84	181
182	84	182
183	85	183
184	86	184
185	86	185
186	86	186
187	86	187
188	86	188
189	86	189
190	86	190
191	87	191
192	87	192
193	87	193
194	87	194
195	88	195
196	89	196
197	89	197
198	90	198
199	91	199
200	92	200
201	93	201
202	94	202
203	95	203
204	96	204
205	96	631
206	96	632
207	97	205
208	98	206
209	98	207
210	98	208
211	98	209
212	98	210
213	99	211
214	99	212
215	99	213
216	99	214
217	100	215
218	100	216
219	100	633
220	100	634
221	101	217
222	101	218
223	101	219
224	101	220
225	101	221
226	101	222
227	102	223
228	102	224
229	102	225
230	103	226
231	103	227
232	103	228
233	104	229
234	105	230
235	106	277
236	106	278
237	106	279
238	106	280
239	106	281
240	107	282
241	107	283
242	107	284
243	107	285
244	107	286
245	107	287
246	107	288
247	107	289
248	108	290
249	108	291
250	108	366
251	109	292
252	109	293
253	110	294
254	110	295
255	110	296
256	110	635
257	110	636
258	111	297
259	111	298
260	111	299
261	112	300
262	112	301
263	112	302
264	112	303
265	113	304
266	113	305
267	113	306
268	113	307
269	113	308
270	113	309
271	114	310
272	114	311
273	114	312
274	114	313
275	115	314
276	115	315
277	115	637
278	116	367
279	116	368
280	117	316
281	117	317
282	117	318
283	117	319
284	118	320
285	118	321
286	119	322
287	119	323
288	119	324
289	119	325
290	120	326
291	120	327
292	120	328
293	120	329
294	120	330
295	120	331
296	120	332
297	120	333
298	120	334
299	120	335
300	121	336
301	121	337
302	121	338
303	121	339
304	121	340
305	121	341
306	121	342
307	121	638
308	121	639
309	122	343
310	123	344
311	123	345
312	123	346
313	123	347
314	123	348
315	123	349
316	123	350
317	123	351
318	123	640
319	123	641
320	124	352
321	124	353
322	125	354
323	125	355
324	126	356
325	126	357
326	126	358
327	126	359
328	126	360
329	126	361
330	126	362
331	127	363
332	127	364
333	127	365
334	127	371
335	127	372
336	84	642
\.


--
-- Data for Name: cast_members; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.cast_members (id, imdb_id, name, gender_id, birthday, deathday, biography, country_of_birth_id, profile_path) FROM stdin;
8944	nm0000130	Jamie Lee Curtis	1	1958-11-22 00:00:00	\N	Jamie Lee Curtis (born November 22, 1958) is an American actress, producer, and children's author. Known for her performances in the horror and slasher genres, she is regarded as a scream queen, in addition to roles in comedies. Curtis has received multiple accolades, including an Academy Award, a BAFTA, two Golden Globes, and two Screen Actors Guild Awards, as well as nominations for an Emmy and a Grammy.\n\nCurtis came to prominence with the ABC sitcom Operation Petticoat (1977–1978). She made her feature film debut playing Laurie Strode in John Carpenter's slasher film Halloween (1978), which established her as a scream queen and led to a string of parts in horror films such as The Fog, Prom Night, Terror Train (all 1980), and Roadgames (1981). She reprised the role of Laurie in the Halloween franchise, until 2022.\n\nCurtis's film work spans many genres outside of horror, including the comedies Trading Places (1983), for which she won a BAFTA for Best Supporting Actress, and A Fish Called Wanda (1988), for which she received a nomination for the BAFTA for Best Actress. Her role as a workout instructor in the film Perfect (1985) earned her a reputation as a sex symbol. She won a Golden Globe Award for her portrayal of Helen Tasker in James Cameron's True Lies (1994). Her other notable film credits include Freaky Friday (2003) and Knives Out (2019). Her performance in Everything Everywhere All at Once (2022) won her the Academy Award for Best Supporting Actress. She received a star on the Hollywood Walk of Fame in 1998. As of 2021, her films have grossed over $2.3 billion at the box office.\n\nCurtis received a Golden Globe and a People's Choice Award for her portrayal of Hannah Miller on ABC's Anything But Love (1989–1992), and earned a Primetime Emmy nomination for the television film Nicholas' Gift (1998). She also starred as Cathy Munsch on the Fox series Scream Queens (2015–16), for which she received her seventh Golden Globe nomination. Curtis has written numerous children's books, including Today I Feel Silly, and Other Moods That Make My Day (1998), which made The New York Times's best-seller list. Curtis is a daughter of actors Janet Leigh and Tony Curtis. She is married to British-American filmmaker Christopher Guest, with whom she has two adopted children.\n\nHer marriage to Guest, who holds the British title of 5th Baron Haden-Guest, makes her a baroness who is entitled to use the name "The Right Honourable The Lady Haden-Guest", though she opts not to use it.	USA	/9KWvPVeiLOXlOGl0XVyHZtJWQtx.jpg
62426	nm0632811	Michiko Nishiwaki	1	1957-11-21 00:00:00	\N	Michiko Nishiwaki (西脇 美智子, Nishiwaki Michiko, born November 21, 1957) is a Japanese actress and stunt woman, martial artist, fight choreographer, and former female bodybuilder and powerlifter. She performed the high-risk stunts as a double for Lucy Liu in the film Charlie's Angels.	JPN	/aToxF8fTOLUmFL5iXlVYXGI2HlA.jpg
86170	nm0913585	Audrey Wasilewski	1	1967-06-26 00:00:00	\N	From Wikipedia, the free encyclopedia. Audrey Wasilewski (born June 26, 1967) is an American actress and voice actress.\n\nDescription above from the Wikipedia article Audrey Wasilewski, licensed under CC-BY-SA,full list of contributors on Wikipedia.  	USA	/4iUq8nA7hm2taO0vMMvvwtQvLr2.jpg
1101375	nm0463158	Boon Pin Koh	2	\N	\N		\N	/dMdb08oYsKBEN8WyQrKQ5DAL0JB.jpg
3444951	\N	Neravana Cabral	0	\N	\N		\N	\N
3341013	\N	Chelsey Goldsmith	0	\N	\N		\N	\N
2899647	nm5836040	Cara Marie Chooljian	1	\N	\N		\N	\N
1099428	nm1313581	Randall Archer	2	\N	\N		\N	\N
3444959	nm4826941	Jane Lui	1	\N	\N		\N	\N
403314	nm0357595	Jason Hamer	2	\N	\N		\N	\N
2019612	nm1337928	Timothy Ralston	2	\N	\N		\N	\N
1394743	nm0944822	Hiroshi Yada	0	\N	\N		\N	\N
3334740	\N	Moti Haim	0	\N	\N		\N	\N
7885	nm0005271	Randy Newman	2	1943-11-28 00:00:00	\N	Randall Stuart Newman (born November 28, 1943) is an American singer-songwriter, arranger, composer, and pianist known for his Southern-accented singing style, early Americana-influenced soul songs (often with mordant or satirical lyrics), and various film scores. His best-known songs as a recording artist are "Short People" (1977), "I Love L.A." (1983), and "You've Got a Friend in Me" (1995), while other artists have enjoyed more success with cover versions of his "Mama Told Me Not to Come" (1966), "I Think It's Going to Rain Today" (1968) and "You Can Leave Your Hat On" (1972).\n\nDescription above from the Wikipedia article Randy Newman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/u4b5Jaqyd5QAl407Zf3PHEf1HWD.jpg
1200895	nm3029577	Waymond Lee	2	1952-03-07 00:00:00	\N		USA	/PXkskFrvX5onDvBMHgF4k5X0Fn.jpg
1253106	nm0018400	Elle Alexander	1	\N	\N		USA	/6MZFAolCYO4Gq3GyhdRbvf1XbhN.jpg
1302221	nm1312322	Amanda Booth	1	\N	\N		\N	/jNK6mzoJVMhe7EQn2XLeMhwepdk.jpg
1383612	nm3453283	Daniel Kwan	2	1988-02-10 00:00:00	\N	Daniel Kwan is one half of the filmmaking duo known as DANIELS, along with Daniel Scheinert. Together, they’ve directed several award-winning music videos and commercials including the MTV VMA-winning video for DJ Snake and Lil’ Jon’s “Turn Down For What,” as well as the dark comedy-drama Swiss Army Man and the absurdist science-fiction film Everything, Everywhere, All At Once, for which the duo received the Academy Awards for Best Picture, Best Director, and Best Original Screenplay.	USA	/pwzfO4BUd49jLrcrrb9u0DOi30b.jpg
1466559	nm2832782	D.Y. Sao	2	1979-10-03 00:00:00	\N		KHM	/1CRoavLS9F5qvJBxos3wVzBblAd.jpg
3840579	\N	Emmett Ferguson	0	\N	\N		\N	\N
3446125	\N	Amanda MacLeod	1	\N	\N		\N	\N
3169828	nm11239285	Freya Fox	0	\N	\N		\N	\N
1190668	nm3154303	Timothée Chalamet	2	1995-12-27 00:00:00	\N	Timothée Hal Chalamet (born December 27, 1995) is an American actor. He began his career appearing in the drama series Homeland in 2012. Two years later, hemade his film debut in the comedy-drama Men, Women & Children and appeared in Christopher Nolan's science fiction film Interstellar. He came into attention in Luca Guadagnino's coming-of-age film Call Me by Your Name (2017). Alongside supporting roles in Greta Gerwig's films Lady Bird (2017) and Little Women (2019), he took on starring roles in Beautiful Boy (2018) and Dune (2021).	USA	/BE2sdjpgsa2rNTFa66f7upkaOP.jpg
20750	nm0339460	Judy Greer	1	1975-07-20 00:00:00	\N	Judith Therese Evans (born July 20, 1975), known professionally as Judy Greer, is an American actress. She is primarily known as a character actress, who has appeared in a wide variety of films. She first rose to prominence in the late 1990s to early 2000s, appearing in the films Jawbreaker (1999), What Women Want (2000), 13 Going on 30 (2004), 27 Dresses (2008), and Love & Other Drugs (2010). Greer also expanded into other genres, with roles in such films as Adaptation (2002), The Village (2004), The Descendants (2011), Carrie (2013), Dawn of the Planet of the Apes (2014), Jurassic World (2015), Ant-Man (2015), War for the Planet of the Apes (2017), Ant-Man and the Wasp (2018), Halloween (2018), and Halloween Kills (2021). She made her directorial debut with the comedy-drama film A Happening of Monumental Proportions (2017). On television, Greer is best known for her starring voice role as Cheryl Tunt in the FXX animated comedy series Archer (2009–present). She also had roles in the comedy series The Big Bang Theory (2007–2019), Arrested Development (2003–2006, 2013-2019), Two and a Half Men (2003–2015), Married (2014–2015), and Kidding (2018–2020).\n\nDescription above from the Wikipedia article Judy Greer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/pTLjIjh83R424RGxIfq4U0yx947.jpg
53266	nm1740127	Clare Grant	1	1979-08-23 00:00:00	\N	Clare Grant is a Memphis born actress who grew up heavily involved in the local theater scene. Upon graduating from the University of Memphis for Theater Performance, she had a short modeling career overseas before she began acting professionally after booking a small but pivotal role in Walk the Line, after which, she moved to LA to pursue acting full time.\n\nWhile in Memphis, Clare met local director, Craig Brewer, who cast her in several independent films before casting her in his first studio film Black Snake Moan &amp; then later in his MTV series $5 Cover. Since then, Clare has found luck in LA, booking leading roles in the Emmy award winning Showtime series Masters of Horror as well as several other films and television shows, including voicing characters on Robot Chicken.\n\nAs a producer, Clare created &amp; starred in the short film Saber, which won two awards in the LucasFilm Star Wars Fan Film Awards. With her creative partners, Team Unicorn, she has helped to create and produce viral sensations such as G33K &amp; G4M3R Girls, A Very Zombie Holiday and Super Harmony.	USA	/uCPsHBUYuDAdOyTpDYDften00El.jpg
96349	nm2829369	Molly C. Quinn	1	1993-10-08 00:00:00	\N	Molly C. Quinn (born October 8, 1993, height 5' 5" (1,65 m)) is an American actress whose works have included theatre, film, and television. Since March 2009, she has played Alexis Castle, the main character's daughter, in ABC's Castle.\n\nLife and career\n\nQuinn is of Irish descent and was born in Texarkana, Texas. She began taking weekly acting lessons from retired director and producer Martin Beck after performing in her community's performance of The Nutcracker at age six. In the sixth grade, she auditioned at the Young Actors Studio where she performed for the program's director, Linda Seto, and representatives from the Osbrink Talent Agency. After six months of "intensive [acting] training", Quinn signed a contract with the Osbrink agency. Subsequently, she signed with Management 360.	\N	/pny0M1U8Z6OgQL4Pgjq5iLwenL9.jpg
139820	nm2962353	Pom Klementieff	1	1986-05-03 00:00:00	\N	Pom Alexandra Klementieff (born 3 May 1986) is a French actress and model. She was trained at the Cours Florent drama school in Paris. Her first professional acting job was the French independent film Après lui (2007). Her first leading role was in Loup (2009). She made her Hollywood debut in Oldboy (2013), a remake of the South Korean film of the same name.\n\nShe moved to Los Angeles after Oldboy was filmed and began pursuing more Hollywood auditions. Her next acting role was the film Hacker's Game (2015), in which she plays a hacker she compared to Lisbeth Salander from the novel The Girl with the Dragon Tattoo. In 2017, she appeared in the romance drama Newness and the black comedy-drama Ingrid Goes West.\n\nShe received worldwide recognition when she joined the Marvel Cinematic Universe as Mantis, appearing in the films Guardians of the Galaxy Vol. 2 (2017), Avengers: Infinity War (2018), and Avengers: Endgame (2019) and Thor: Love and Thunder (2022). In 2019, she appeared in an episode of the Netflix science fiction anthology series Black Mirror, the thriller film Uncut Gems, and had voice roles in the animated supernatural comedy film The Addams Family. In 2020, she had a recurring role as Martel in the HBO science-fiction series Westworld.\n\nDescription above is from the Wikipedia article Pom Klementieff, licensed under CC-BY-SA, full list of contributors on Wikipedia.	CAN	/hfUKAI2kXTMMWjno0i4sLPJud5N.jpg
3204229	\N	Molly Beth Thomas	1	\N	\N		\N	/pDZvlDpuk1pz6sZ7JTYhY6WdEEQ.jpg
1514387	nm3310289	Daniel Durant	2	1989-12-24 00:00:00	\N	Daniel Durant is an American stage and screen actor. He is a member of the Deaf community. He is best known for portraying Moritz Stiefel in the 2015 Broadway Revival of Spring Awakening, and for his recurring role as Matthew on the television series Switched at Birth.	USA	/iG1GRiYy3JGlnoBKSnuNF6umtp6.jpg
85824	nm1640523	Katrina Begin	1	1982-08-10 00:00:00	\N	Katrina Begin was born on August 10, 1982 in Minneapolis, Minnesota, USA. Katrina is an actor and writer, known for Single Parents (2018), Good Behavior (2016) and Christmas Break-In (2018).	USA	/6kcjQWWfUGdOKBiRF6VNCkpf60w.jpg
113734	nm1423270	Erin Cummings	1	1977-07-19 00:00:00	\N	From Wikipedia, the free encyclopedia.\n\nErin Lynn Cummings is an American actress. She has appeared in the television shows Star Trek: Enterprise, Charmed, Dante's Cove, The Bold and the Beautiful, Cold Case, Dollhouse, Spartacus: Blood and Sand, and Detroit 1-8-7.\n\nDescription above from the Wikipedia article Erin Cummings, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/4GpursPJJ6eImqos5XM5RlkDqI8.jpg
1330888	nm2811167	Andy Bean	2	1984-10-07 00:00:00	\N		\N	/4BiltJsO0KO7E9Mgyj8wMekbEBA.jpg
14721	nm0242656	Kevin Dunn	2	1956-08-24 00:00:00	\N	Kevin Dunn (born August 24, 1956) is an American actor who has appeared in supporting roles in a number of films and television series since the 1980s.	USA	/7dqLQjMNCQnuxQJQwQ5Ozz16LBq.jpg
1299192	nm5164937	Craig Tate	0	\N	\N		\N	/509fvrZgzAcXrJ3zKSIvwb7J3Ck.jpg
1741367	nm6076229	Alana Haim	1	1991-12-15 00:00:00	\N	Alana Mychal Haim (born December 15, 1991) is an American musician and actress. She is a pianist, guitarist, and vocalist of the American pop-rock band Haim, which also consists of her two older sisters, Este Haim and Danielle Haim. In 2021, she starred in Paul Thomas Anderson's film Licorice Pizza alongside Cooper Hoffman and the rest of Haim.	USA	/uOU4uueRxH5BYhzNjzPxJOxZStJ.jpg
2764542	nm11866274	Cooper Hoffman	2	2003-03-01 00:00:00	\N	Cooper Hoffman was born to actor Philip Seymour Hoffman and costume designer Mimi O'Donnell in March of 2003. Cooper Hoffman lived with his parents in New York City until his father's death in February of 2014. He made his acting debut in Paul Thomas Anderson's 1970s-set coming-of-age film Licorice Pizza.	USA	/3KEX72zCYwS0pub1DnpMbdJ9uC5.jpg
1759243	\N	Rogelio Camarillo	0	\N	\N		\N	/cQ3BRNdRnuB5DDXn82sxZbqAQz3.jpg
213001	nm2809577	Jenny Slate	1	1982-03-25 00:00:00	\N	Jenny Sarah Slate (born March 25, 1982) is an American stand-up comedian, actress, voice actress and author, known for her role as Mona Lisa Saperstein on 'Parks and Recreation' as well as being the co-creator of the 'Marcel the Shell with Shoes On' short films and children's book series. She was a cast member on 'Saturday Night Live' for the 2009/10 season and appeared in shows such as 'House of Lies', 'Married', 'Bob's Burgers', 'Hello Ladies', 'Kroll Show', 'Bored to Death', and 'Girls', as well as movies like 'Zootopia', 'The Secret Life of Pets', and 'Despicable Me 3'. Slate played the lead role in the critically acclaimed 2014 film 'Obvious Child', which earned her various accolades.\n\nDescription above from the Wikipedia article Jenny Slate, licensed under CC-BY-SA, full list of contributors on Wikipedia.  	USA	/iNpXig5Djkh5moYG4TCekIATs5B.jpg
232499	nm1484270	Harry Shum Jr.	2	1982-04-28 00:00:00	\N	Harry Shum Jr. (born April 28, 1982) is a Costa Rican-American actor, singer, dancer, and choreographer. He is best known for his roles as Mike Chang on the Fox television series Glee (2009–15) and as Magnus Bane on the Freeform television series Shadowhunters (2016–19). He was nominated for four Screen Actors Guild Awards for his performance in Glee, winning once. He won the award for The Male TV Star of 2018 in the E! People's Choice Awards for Shadowhunters.\n\nShum has appeared in the films Step Up 2: The Streets (2008), Step Up 3D (2010), White Frog (2012), Revenge of the Green Dragons (2014), Crouching Tiger, Hidden Dragon: Sword of Destiny (2016), Crazy Rich Asians (2018), the Hulu web series The Legion of Extraordinary Dancers (2010–2011) and the YouTube Originals series Single by 30 (2016). In 2020, he starred in Universal's romantic drama All My Life.	CRI	/xFQsThmdyuOk9jt3zgZL08ixf2b.jpg
964421	nm1594381	Aaron Lazar	2	1976-06-21 00:00:00	\N	Aaron Scott Lazar is an American actor, artist and entrepreneur. He originated the role of Enjolras in the 2006 Broadway revival of Les Misérables.	USA	/87xfF3QmQtYtlENybOvFL3bfMcr.jpg
968692	nm0246286	Gerardo Davila	2	\N	\N		\N	/ba90ieL9PZVj7buy3FehvqPS3LK.jpg
1068877	nm5147838	Andy Le	2	1991-10-14 00:00:00	\N	Andy Le is a southern Californian actor, producer, and stunt performer who has worked in multiple films. Le has starred in Shang-Chi and the Legend of the Ten Rings, The Paper Tigers, and his only self-produced project the Supreme Art of War. Andy also appeared in Wu-Tang: An American Saga as Fang. In 2011, Andy co-founded a martial arts club called "Martial Club" (disambiguation), which went on to direct stunts for multiple movies including Shang-Chi and the Legend of the Ten Rings and Everything Everywhere All at Once with Michelle Yeoh. Despite his part in creating the club, Le has done multiple solo-stunting jobs without the group.	\N	/rwcJKFHN419CuNgEk57OEp16XLE.jpg
1071151	nm3303059	Tallie Medel	1	1986-05-10 00:00:00	\N	Tallie Medel is an American actress, writer, dancer, choreographer, and comedienne, best known for her work in independent films. She graduated from Emerson College, Boston, MA, in 2008 with a degree in Acting and Theater Education, and is a co-founder of dance-comedy trio Cocoon Central Dance Team alongside Sunita Mani and Eleanore Pienta.	USA	/yXCW6VsmAjW2JQCHEYhAUapVt18.jpg
1272901	nm2788450	Efka Kvaraciejus	2	\N	\N	Efka Kvaraciejus is known for Logan (2017), Captain America: Civil War (2016) and The Dark Knight Rises (2012).	\N	/xC12DoEHB9h3jJQ5YrJ1WSoLEWs.jpg
1741368	nm6076230	Danielle Haim	1	1989-02-16 00:00:00	\N	Danielle Sari Haim (born February 16, 1989) is an American musician, singer and songwriter from Los Angeles, California, the daughter of Israeli footballer Mordechai Haim. She is the lead guitarist of the American pop rock band Haim, which also consists of her two sisters, Este Haim and Alana Haim. In 2021, she appeared in Paul Thomas Anderson's film Licorice Pizza alongside Cooper Hoffman and the rest of Haim.	USA	/hvDVZHgafVuRbzbvktHHYPXLQIr.jpg
1741366	nm6076231	Este Haim	1	1986-03-14 00:00:00	\N	Este Arielle Haim (born March 14, 1986) is an American musician, singer and songwriter from Los Angeles, California, the daughter of Israeli footballer Mordechai Haim. She is the bass player for the American pop rock band Haim, which also consists of her two sisters, Danielle Haim and Alana Haim. In 2021, she appeared in Paul Thomas Anderson's film Licorice Pizza alongside Cooper Hoffman and the rest of Haim.	USA	/yGXIdcyTqm577PMQthA1EdiHlv3.jpg
108916	nm1913734	Rooney Mara	1	1985-04-17 00:00:00	\N	Patricia Rooney Mara (born April 17, 1985) is an American film and television actress. Mara made her acting debut in 2005 and has gone on to star in films including A Nightmare on Elm Street, the remake of the 1984 horror film, and The Social Network. Mara also portrayed Lisbeth Salander, the title character in The Girl with the Dragon Tattoo, a Sony Pictures film based on Stieg Larsson’s Millennium book series.\n\nMara is also known for her charity work. She oversees the charity Faces of Kibera, which benefits orphans from the Kibera slum in Nairobi, Kenya, one of the largest slums in Africa.  Description above from the Wikipedia article Rooney Mara, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/zT6UyHFHEQ9RcKykplWCycKBnoS.jpg
1462	nm0625789	Tim Blake Nelson	2	1964-05-11 00:00:00	\N	Timothy Blake Nelson (born May 11, 1964) is an American actor and playwright.\n\nDescribed as a "modern character actor", his roles include Delmar O'Donnell in O Brother, Where Art Thou? (2000), Gideon in Minority Report (2002), Dr. Pendanski in Holes (2003), Danny Dalton Jr. in Syriana (2005), Samuel Sterns in the Marvel Cinematic Universe, Richard Schell in Lincoln (2012), the title character in The Ballad of Buster Scruggs (2018), and Henry McCarty in Old Henry (2021). He portrayed Wade Tillman / Looking Glass in the HBO limited series Watchmen (2019), for which he received a Critics' Choice Television Awards nomination for Best Supporting Actor in a Drama Series in 2020.\n\nNelson's directorial credits include Eye of God (1997), which was nominated for the Sundance Grand Jury Prize and an Independent Spirit Award; O (2001), a modern-day adaptation of Othello; and the Holocaust drama The Grey Zone (2001). Eye of God and The Grey Zone were both adapted from Nelson's own plays.\n\nDescription above from the Wikipedia article Tim Blake Nelson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/rWuTGiAMaaHIJ30eRkQS23LbRSW.jpg
1300637	nm5032019	Aqueela Zoll	1	1988-12-17 00:00:00	\N	With training in theatre arts, improvisation, &amp; creative writing, Aqueela holds a degree in Human Development from the University of Long Beach, California.\n\nHaving studied with Inner Circle Theatre, The Improv Space, Sarah Underwood, Craig Anton, and many others she has found success in her entertainment career as an actress, model, &amp; host. Her driven inspiration for film &amp; vibrant work ethic has landed Aqueela working with Liev Schreiber (X-Men Origins: Wolverine 2009), Jamie Marshall (Warrior 2011, Twilight 2008), James Byrkit (Coherence 2013, Rango 2011, Pirates of the Caribbean 2003), and Emily Baldoni (Ghosts of Girlfriends Past) among many others.\n\nFilm &amp; television are where Aqueela's hunger peaks, yet as a young woman fascinated with all creative sides to the business she has also found success modeling with brands such as Adidas, ASCIS, Harley Davidson, Rockstar, &amp; JVC. Her natural presence on camera has complimented hosting for major companies such as ACER, Honda, &amp; Rumchata. Believing training never ceases, she is constantly redefining her strengths &amp; craft. She is well rounded in beginning level French, acoustic guitar, quantum physics &amp; the Krav Maga martial arts. She's well versed in psychology, anatomy, &amp; physiology. As an actress, she views an intelligent mind as the creative mind's best companion, &amp; vice versa. Aqueela's journey as an actress has been an inspiring adventure so far. Having recently returned from filming in the UK, you'll see Aqueela as a lead role in Fox Home Entertainment's Wrong Turn 6.  - IMDb Mini Biography	\N	/cvN1Bg4uEoBzCA03jjyHPtbzkNg.jpg
1310386	nm1874027	Panuvat Anthony Nanakornpanom	2	\N	\N		\N	/gygeFtJuxw5SUlfvI12CbfsCVph.jpg
1317730	nm3215397	Daniel Scheinert	2	1987-06-07 00:00:00	\N	Daniel Scheinert is best known as the redneck half of the filmmaking duo DANIELS along with Daniel Kwan. Together, they’ve directed several award-winning music videos and commercials including the MTV VMA-winning video for DJ Snake and Lil’ Jon’s “Turn Down For What,” as well as the dark comedy-drama Swiss Army Man and the absurdist science-fiction film Everything, Everywhere, All At Once, for which the duo received the Academy Awards for Best Picture, Best Director, and Best Original Screenplay.	USA	/5VSpMLDEmygCu4bfB89Y7NV6YjM.jpg
1334321	nm2359285	Craig Henningsen	2	1987-08-20 00:00:00	\N		USA	/mWittaEYFxIFCaskmYFE0m9bJr9.jpg
1363394	nm2409479	Mikaela Hoover	1	1984-07-12 00:00:00	\N	Mikaela Hoover was born on July 12 in Colbert, Washington and is the first of 4 siblings. Mikaela started taking dance classes at age 2 and stared school plays and local commercials as a child. She was a cheerleader in high school and the captain of her high school dance team as well as being on the Debate team. After graduation she was accepted to Loyola Marymount University's theatre program in Los Angeles. After getting her BA in theatre she booked the first movie she auditioned for called "Frank". She later went on to play the role of Madison in the WB's "Sorority Forever" and landed a recurring role on the ABC show "Happy Endings". She has guest starred on many extremely popular sitcoms including "How I Met Your Mother", "Two and a Half Men", "Saint George", "The League", and "Anger Management". She has done many projects with writer/director James Gunn (Guardians of the Galaxy) including "The Sparky and Mikaela Show", "PG Porn", "Humanzee", and the movie "Super".  - IMDb Mini Biography By: Mikaela Hoover	USA	/vH7XYI6cw6PFRDflOJY8iQEEg7g.jpg
1367516	nm2361928	Timothy Eulich	2	\N	\N	Born and raised in St. Louis Missouri, Timothy never had the opportunity to meet anyone who worked professionally in film and television. He did, however, love creating action films with his parents old cameras. What some called procrastination, others saw as a developing craft. When he got caught editing one of his super 8 films in the basement instead of studying for calculus midterms, his supportive parents agreed that a career in the creative arts was probably best for this young man.\n\nWhile attending the University of North Carolina School of the Arts, he began training in fencing and martial arts. After graduating with a BFA in Theater, he moved to New York City where he made a name for himself as a highly sought after fight choreographer for theater, opera and ballet companies all over the United States. During this time, he got his SAG card doing stunts on a small feature film. That was when everything changed. He packed up his car and drove to Hollywood where he devoted all of his time, energy and resources in pursuit of a newly realized dream... to be a professional stuntman.\n\nAfter many years of professional credits as a performer, Timothy found the support of a few great mentors who began helping him transition into stunt coordinating. It was a natural progression for him and he particularly loved being part of the creative process. He has since been designing action sequences for television and feature films.	\N	/xIfRmiBGtWogkRYAjbgIX7i4cuv.jpg
205923	nm2129802	Babs Olusanmokun	2	1984-09-18 00:00:00	\N	Babs Olusanmokun (born 18 September 1984) is a Nigerian-American actor.	NGA	/bqycmpUrpISeLzQniiYwAZ5X1RN.jpg
1921320	nm3347682	Jonalyn Saxer	1	1992-05-12 00:00:00	\N	Jonalyn Saxer (born May 12, 1992) is an American actress who is most known for being a member of the Ensemble in the original Broadway company of Mean Girls as well as an understudy for Cady, Regina, and Karen. Later, she played Karen in the first national tour. Saxer made her film debut in West Side Story (2021).	USA	/bBxXlnLwTD85ecMtG2wezoPX3dY.jpg
1542446	nm2865017	Yvette Parsons	1	\N	\N		\N	/rviTXu0eq0OJDWQ8hVxLCEyYUPQ.jpg
1517871	nm5930685	Elly Condron	1	\N	\N	Elly Condron is an actress and costume designer, known for Wasp (2015), Six Wives with Lucy Worsley (2016) and Years and Years (2019).	\N	/AbBjL2IUG7fLrfUnzfrX3gnCWyj.jpg
999737	nm3599667	Erica McDermott	1	1973-04-26 00:00:00	\N		USA	/gDYmn7ojelzEEuvFH2cF7ZSkR0q.jpg
1681734	\N	Doreen Montalvo	1	1963-11-15 00:00:00	2020-10-17 00:00:00		USA	/vMZEIOUDfEwPZCodfeMlEQ337d3.jpg
55624	nm0045379	Dian Bachar	2	1970-10-26 00:00:00	\N	Dian Bachar (born October 26, 1970 in Denver, Colorado) is an American actor. He is most notable for his roles in various films by or starring his friends Trey Parker and Matt Stone, such as Cannibal! The Musical (George Noon), Orgazmo (Ben Chapleski) and his most famous role as Kenny "Squeak" Scolari in 1998's BASEketball, as well as making the occasional appearance on South Park. He also appeared as an alien engineer in Galaxy Quest, although the bulk of his scenes were cut (but can be seen on the DVD).\n\nDescription above from the Wikipedia article Dian Bachar, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/hAWmksHpp0ZiUN5e9RkJcRlYHgm.jpg
209227	nm2942900	Paul Niebanck	2	\N	\N	Paul Niebanck is an American stage and screen actor. He holds an BFA from Boston University and an MFA from the Yale School of Drama, New Haven, Connecticut.	\N	/4LnKx8XEIPaP9YOQNd2NqrIkBAu.jpg
10581	nm1360860	Rich Sommer	2	1978-02-02 00:00:00	\N	Rich Sommer (born February 2, 1978) is an American actor best known for his portrayal of Harry Crane on Mad Men.	USA	/tqpwfXczNvvel5Dep5ejUD4X9ie.jpg
1375002	nm4576371	Sunita Mani	1	1986-12-13 00:00:00	\N	Sunita Mani is an actress, dancer, and comedian most commonly recognized for her gyrations in the viral music video "Turn Down for What" (dir. The Daniels) and as part of the Cocoon Central Dance Team. She also appears in "Don't Think Twice" as Amy, "Mr. Robot" as Trenton, and in the Netflix original series, G.L.O.W as Arthie. Sunita has also guest starred on network television shows including "Broad City" on Comedy Central, Search Party on TBS, and The Good Place on NBC.	USA	/xQo4rkMEphSAt8F9D1OyWv0GBLx.jpg
1427948	nm0203457	Pete Davidson	2	1993-11-16 00:00:00	\N	Peter Michael Davidson (born November 16, 1993) is an American comedian and actor. He is a cast member on Saturday Night Live. Davidson has also appeared on the MTV shows Guy Code, Wild 'n Out, and Failosophy. He has performed stand-up comedy on Adam DeVine's House Party, Jimmy Kimmel Live!, and Comedy Underground with Dave Attell, and guest-starred in Brooklyn Nine-Nine.	USA	/l8xpAV5zBiOFZA2I1Cgz3Yb92AY.jpg
1465297	nm4456672	Nico Santos	2	1979-04-07 00:00:00	\N	Nico Santos is a Filipino-American actor known for portraying Oliver T'sien in Crazy Rich Asians and sales associate Mateo Liwanag in the NBC series Superstore. On December 10, 2018, Santos was nominated for the Critics' Choice Television Award for Best Supporting Actor in a Comedy Series.	PHL	/e96iYbxaqC9zGaFPxZ2fH82MBNu.jpg
1502438	nm5219130	Asim Chaudhry	2	1987-11-24 00:00:00	\N		GBR	/1F0DwOpxUAEpw5iovMHZ5Y1C8n6.jpg
1535095	nm1640149	Dan Brown	2	1982-05-04 00:00:00	\N		USA	/Aa65AAZkoxPGt7L5royKFHIehYb.jpg
1561485	nm2467531	Peter Banifaz	2	\N	\N		IRN	/fQXcGOpKU8mzkYNyzXrmtXP5In4.jpg
1591198	nm4016192	Sarah Alami	1	\N	\N	Sarah Alami is an American stage, film and television actress and model.	USA	/9FukH6xhQpxymjHNF6WpCLT6s9z.jpg
1784612	nm6403016	Daniela Melchior	1	1996-11-01 00:00:00	\N	Daniela Melchior (born November 1, 1996) is a Portuguese actress. After beginning her career in her home country, she made her English-language debut as Ratcatcher 2 in the DC Extended Universe (DCEU) film The Suicide Squad (2021).	PRT	/iLO8qrSldSTC1omutFiO9oyIz6m.jpg
2408703	nm7210025	Maria Bakalova	1	1996-06-04 00:00:00	\N	Maria Valcheva Bakalova (born 4 June 1996) is a Bulgarian actress. She is best known for her role as Tutar Sagdiyev in the 2020 mockumentary Borat Subsequent Moviefilm. For her performance in the film, she won the Critics' Choice Movie Award for Best Supporting Actress, and received nominations at the Academy Awards, the BAFTA Film Awards, the Golden Globe Awards and the Screen Actors Guild Awards.\n\nBorn and raised in Burgas, Bakalova began her career in Bulgarian cinema by starring in film productions while attending the National Academy for Theatre and Film Arts in Sofia. She appeared in films such as Transgression (2017), The Father (2019), Last Call (2020) and Women Do Cry (2021). Since her international breakthrough in 2020, she has been a part of several American productions including Judd Apatow's The Bubble (2022) and the A24 horror film Bodies Bodies Bodies (2022).	BGR	/nUivgeC0kyhkI6QOAhw2k5VGhBk.jpg
2410189	nm5260295	Brian Le	2	1993-06-27 00:00:00	\N	Brian Le is an American actor, martial artist, stuntman, and one of the founding members of the Martial Club Stunt Team. He is the brother of Andy Le.	USA	/4iS0aIViQ9d81sma9HtxWnNE74t.jpg
2422999	nm8886849	Jonathan Mercedes	2	\N	\N		\N	/gYHqbkELVQ0oPblACYxRUtBXOls.jpg
2486881	nm5752190	Max Bickelhaup	2	\N	\N		\N	/6FMDwtzToz68NQckTvMn0r0siAB.jpg
2776852	nm9139663	Tara Warren	0	\N	\N		\N	/sRzZ8WZfJ8e5RwgbYSaYgaYAyug.jpg
2883298	nm8835245	Dylan Henry Lau	2	\N	\N	Dylan Henry Lau is an actor, known for We Can Be Heroes (2020), Fresh Off the Boat (2015) and Drunk History (2013).	\N	/ho9oGn9ZtKxQjSZlkLv70ouPqZM.jpg
3543715	nm1696092	Li Jing	1	\N	\N		\N	/n8VLOqVAlnbVW3ok8d3qxDcubFc.jpg
2887	nm0001823	Tom Waits	2	1949-12-07 00:00:00	\N	Thomas Alan Waits (born December 7, 1949) is an American musician, composer, songwriter and actor. His lyrics often focus on the underbelly of society and are delivered in his trademark deep, gravelly voice. He worked primarily in jazz during the 1970s, but his music since the 1980s has reflected greater influence from blues, rock, vaudeville, and experimental genres.\n\nWaits was born and raised in a middle-class family in Whittier, California. Inspired by the work of Bob Dylan and the Beat Generation, he began singing on the San Diego folk music circuit as a young boy. He relocated to Los Angeles in 1972, where he worked as a songwriter before signing a recording contract with Asylum Records. His first albums were the jazz-oriented Closing Time (1973) and The Heart of Saturday Night (1974), which reflected his lyrical interest in nightlife, poverty, and criminality. He repeatedly toured the United States, Europe, and Japan, and attracted greater critical recognition and commercial success with Small Change (1976), Blue Valentine (1978), and Heartattack and Vine (1980). He produced the soundtrack for Francis Ford Coppola's film One from the Heart (1981), and subsequently made cameo appearances in several Coppola films.\n\nIn 1980, Waits married Kathleen Brennan, split from his manager and record label, and moved to New York City. With Brennan's encouragement and frequent collaboration, he pursued a more experimental and eclectic musical aesthetic influenced by the work of Harry Partch and Captain Beefheart. This was reflected in a series of albums released by Island Records, including Swordfishtrombones (1983), Rain Dogs (1985), and Franks Wild Years (1987). He continued appearing in films, notably starring in Jim Jarmusch's Down by Law (1986), and also made theatrical appearances. With theatre director Robert Wilson, he produced the musicals The Black Rider (1990) and Alice (1992), first performed in Hamburg. Having returned to California in the 1990s, his albums Bone Machine (1992), The Black Rider (1993), and Mule Variations (1999) earned him increasing critical acclaim and multiple Grammy Awards. In the late 1990s, he switched to the record label ANTI-, which released Blood Money (2002), Alice (2002), Real Gone (2004), and Bad as Me (2011).\n\nDespite a lack of mainstream commercial success, Waits has influenced many musicians and gained an international cult following, and several biographies have been written about him. In 2015, he was ranked at No. 55 on Rolling Stone's "100 Greatest Songwriters of All Time". He was inducted into the Rock and Roll Hall of Fame in 2011.\n\nDescription above from the Wikipedia article Tom Waits, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/uxDkURjzHnaglIH2YRWUMJjoDx.jpg
2089332	nm5697061	Alice May Connolly	0	\N	\N		\N	/a16fQ0jLSaFcWFp7gY4QUkTyo1Y.jpg
102777	nm1292126	Mel Fair	2	1964-03-22 00:00:00	\N		USA	/9Q9sIiikHS5HvDO89KscfnruZrb.jpg
1444798	nm0962120	Tom Beyer	2	\N	\N		\N	/kBQ9bqns4ipSMQbbkCkS7UBRJjo.jpg
2923038	nm9728295	Evan A. Dunn	2	\N	\N		\N	\N
1502670	nm2524200	Junes Zahdi	2	\N	\N		\N	/qBrQuvl2WVZEM2nikmPaoLuMtxi.jpg
1517706	nm2750563	Luke Jones	2	\N	\N		\N	/cwwKbw74j5W2MQse64keCl7eGIi.jpg
2180811	nm1529256	JoAnne McGrath	1	\N	\N		\N	/7EFTecqSGalmC1XMdgiEPUuaFbe.jpg
2323106	nm6672333	Alex West	2	1984-11-07 00:00:00	\N	Alex Chatmon West is an actor and 23X international award-winning filmmaker (4X Platinum) that is best known for his work on Harvested 2, Harvested, Blood & Water, Angie's Cure, A Holiday Change, Dread, Space Juice and Don't Shoot. As a brass knuckle self taught filmmaker, Alex's films are streaming on Roku, Samsung TV, LG TV and multiple other platforms. He is enthralled with inspiring, helping and motivating other's by creating content and opportunities through his companies, Culture Forward Media Group and Culture Forward TV.\n\nThe LA native is married to Ruby Lee Dove II who is also an actor and filmmaker. A former semi-professional basketball player, Alex is also a polymath, artist, and philanthropist.	USA	/uN0H9EzR7cs4XW7fLxka8xf8mPw.jpg
2644960	nm2566115	Brett Holland	2	\N	\N		\N	/tt6fwezBDEUq193jVNFy8ezYNog.jpg
3304752	nm12664730	Everly Wild Goerdel	1	\N	\N		\N	/8dy5f7SQlmKQtEWmIOyzwHql9yM.jpg
1942150	nm3545770	Marilyn Busch	1	1977-09-18 00:00:00	\N	Born in South Boston and Irish through and through. Marilyn is a proud member of SAG-AFTRA and has made her career playing working-class women, chock full of sunshine and laughter - until they burn you with shade. Actress in Best Picture Academy Award Winning film "CODA" with Marlee Matlin and Emilia Jones, directed by Sian Heder. Seen on NBC, Netflix, Showtime, HULU, Apple TV+ and more.	\N	/71FMZ0cMoGwGNAdj08RnhI8HS3T.jpg
2243207	\N	Eman Esfandi	2	\N	\N		\N	/qC7GMBvuMMGOrs2ahcROsdmkkz1.jpg
2290310	\N	Paloma Garcia-Lee	1	\N	\N		\N	/i9bAJ4zpikvXvwjjXxCvSXTvAsq.jpg
1731223	nm4316136	Edith Poor	1	\N	\N		\N	/tXFBvyksqdNoZROTJAYZ00YMqCA.jpg
4764	nm0000604	John C. Reilly	2	1965-05-24 00:00:00	\N	John Christopher Reilly (born May 24, 1965), better known as John C. Reilly is an American film and theatre actor. Debuting in Casualties of War in 1989, he is one of several actors whose careers were launched by Brian De Palma. To date, he has appeared in more than fifty films, including three separate films in 2002, each of which was nominated for the Academy Award for Best Picture. He was nominated for an Academy Award for Best Supporting Actor for his role in Chicago and a Grammy Award for the song "Walk Hard", which he performed in Walk Hard: The Dewey Cox Story.\n\nDescription above from the Wikipedia article John C. Reilly, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/iDQ8w4qcxU3le5ZWoCKpHs1QNok.jpg
53934	nm0239294	Ellen Dubin	1	\N	\N	Ellen Dubin is a Canadian film and television actress.	CAN	/cvf1pX4t6ZzDPsRi9J2xGrGj78c.jpg
1774266	nm4279268	Emily Althaus	1	1986-11-25 00:00:00	\N		USA	/2X4Ig3KrvHy9An4mQoZtU3yZaCe.jpg
166594	nm0628392	David Newsom	2	1962-03-10 00:00:00	\N		USA	/mI2K8fYOgpPSO61idEN6aWS4nrc.jpg
1956550	nm2728453	Rena Maliszewski	1	1966-04-06 00:00:00	\N		\N	/2Rm80y6RN8p8sLoOKCJRNfvrrGC.jpg
10960	nm0048755	Max Baker	2	1960-07-05 00:00:00	\N		\N	/z3hNp4zntZJVQPBUd08IXSAiWAL.jpg
1903319	nm8911148	Troy James	2	\N	\N		\N	/oDu8ESqlD6nNdPdntWmhoJOnU5X.jpg
1531618	nm5013848	Jay Washington	0	\N	\N		\N	/qlJXBDdEAIFPe6TnuxCLCtGra7K.jpg
3116820	nm10404702	Toby Larsen	2	\N	\N		\N	/hfCDYmOC6VzuBfi7nslynvaybvb.jpg
3304753	nm2897767	Eric Urbiztondo	2	\N	\N		\N	/gtwRoEta5ePp6yzaKVtTouD0vXP.jpg
7497	nm0564697	Holt McCallany	2	1963-09-03 00:00:00	\N	Holt McCallany (born Holt Quinn McAloney; September 3, 1963) is an American actor, writer, and producer. He is known for portraying Bill Tench on the series Mindhunter (2017–present) and has had several supporting roles in various television series and films.  His first job in the professional theater was as an apprentice actor at the Great Lakes Shakespeare Festival in Cleveland, Ohio, in the same apprenticeship once served by Tom Hanks, among others. Subsequently, he returned to New York City and was cast as an understudy in the Broadway production of Biloxi Blues.\n\nMcCallany landed a series of supporting parts in such films as Casualties of War, Alien 3, Creepshow 2, The Search for One-eye Jimmy, and Jade, as well as the TV miniseries Rough Riders. After playing the legendary boxing trainer Teddy Atlas in the HBO telefilm Tyson, he became a supporter of the Atlas Foundation Charity, a grassroots organization dedicated to helping children and families with medical and financial hardships.\n\nHe continued working in films and television throughout the nineties and 2000s with roles in films such as Fight Club, Three Kings, Men of Honor, and Below, among others. He played a detective with psychological problems in CSI: Miami and a soldier with post-traumatic stress disorder on Criminal Minds.\n\nHe appeared in the 2010 Warner Bros. film, The Losers, based on the graphic novel from DC Comics. McCallany also was the star of the 2011 FX television series, Lights Out, playing an aging boxer ("Patrick 'Lights' Leary") forced out of retirement and into a comeback bid to regain the heavyweight title, despite having pugilistic dementia.\n\nHe followed this with roles in films like Sully, Shot Caller, and Blackhat, among many others.\n\nSince 2017, McCallany co-stars in the Netflix series Mindhunter for director David Fincher. He plays Bill Tench, an FBI agent researching serial killers in the late-1970s. His first French language film will be released in September, 2019, an adaptation of the George Feydeau comedy Le Dindon.	USA	/a5ax2ICLrV6l0T74OSFvzssCQyQ.jpg
2453	nm0005460	Mary Steenburgen	1	1953-02-08 00:00:00	\N	Mary Nell Steenburgen (born February 8, 1953) is an American actress. She was most successful for playing the role of Lynda Dummar in Jonathan Demme's Melvin and Howard, which earned her an Academy Award and a Golden Globe.	USA	/yJhfuqS3yXW7kLSyvRU6n3b35mq.jpg
229	nm0534132	Peter MacNeill	2	\N	\N	​From Wikipedia, the free encyclopedia.  \n\nPeter MacNeill is a Canadian film and television actor who has starred in several TV shows and movies. His film credits have included The Hanging Garden (for which MacNeill won a Genie Award for Best Supporting Actor in 1997), Geraldine's Fortune, Giant Mine, Lives of Girls and Women, The Events Leading Up to My Death, Dog Park, Something Beneath and A History of Violence. On television, he has had roles in Queer as Folk (as Detective Carl Horvath), Katts and Dog (as Sgt. Callahan), Traders (as Frank Larkin) Star Wars: Droids (as Jord Dusat), The Eleventh Hour (as Warren Donohue) and PSI Factor: Chronicles of the Paranormal as Ray Donahue	\N	/9Y2O97Awq5BUH3qfWL3EUveurqI.jpg
29862	nm0064769	Jim Beaver	2	1950-08-12 00:00:00	\N	James Norman "Jim" Beaver, Jr. (born August 12, 1950) is an American stage, film, and television actor, playwright, screenwriter, and film historian. He is perhaps most familiar to worldwide audiences as the gruff but tenderhearted prospector Whitney Ellsworth on the HBO Western drama series Deadwood, a starring role which brought him acclaim and a Screen Actors Guild Awards nomination for Ensemble Acting after three decades of supporting work in films and TV. He currently portrays Bobby Singer in the CW television series Supernatural. His memoir Life's That Way was published in April 2009.\n\nDescription above from the Wikipedia article Jim Beaver, licensed under CC-BY-SA, full list of contributors on Wikipedia	USA	/c3Cqp1XAdcyeUZKkcrdQsPwb010.jpg
209	nm0011038	Jane Adams	1	1965-04-01 00:00:00	\N	Jane Adams is an American actress. She made her Broadway debut in the original production of I Hate Hamlet in 1991, and won the Tony Award for Best Featured Actress in a Play for the 1994 revival of An Inspector Calls. Her film roles include Happiness (1998), Wonder Boys (2000), Eternal Sunshine of the Spotless Mind (2004), and Little Children (2006). She also had a recurring role on the NBC sitcom Frasier (1999–2000), and was nominated for the 2010 Golden Globe Award for Best Supporting Actress on Television for the HBO series Hung (2009–11).	USA	/2FsPAoatMkUZ7khJ9r4Fa7ZxQzS.jpg
38673	nm1475594	Channing Tatum	2	1980-04-26 00:00:00	\N	Channing Matthew Tatum (born April 26, 1980) is an American actor. Tatum made his film debut in the drama Coach Carter (2005), and had his breakthrough role in the 2006 dance film Step Up. He gained wider attention for his leading roles in the sports comedy She's the Man (2006), the comedy-drama Magic Mike (2012) and its sequels Magic Mike XXL (2015) and Magic Mike's Last Dance (2023), the latter two of which he also produced, and in the action-comedy 21 Jump Street (2012) and its sequel 22 Jump Street (2014).\n\nTatum has also appeared as Duke in the action film G.I. Joe: The Rise of Cobra (2009) and its sequel G.I. Joe: Retaliation (2013). His other films include White House Down (2013), Foxcatcher (2014), The Hateful Eight (2015), Hail, Caesar! (2016), Logan Lucky (2017), and The Lost City (2022). Tatum has also starred in, produced and co-directed the road film Dog (2022). Time magazine named him one of the 100 most influential people in the world in 2022.	USA	/xdnstENLdWMPWt9qyhtf695L4t6.jpg
17401	nm0740535	Stephen Root	2	1951-11-17 00:00:00	\N	Stephen Root (born November 17, 1951) is an American actor. He has starred as Jimmy James on the NBC sitcom NewsRadio, as Milton Waddams in the film Office Space (1999), and voiced Bill Dauterive and Buck Strickland on the animated series King of the Hill (1997–2010).\n\nRoot has appeared in numerous Coen brothers films including O Brother, Where Art Thou? (2000), The Ladykillers (2004), No Country for Old Men (2007), The Ballad of Buster Scruggs (2018), The Tragedy of Macbeth (2021). Other notable film roles include in Dave (1993), DodgeBall (2004), Idiocracy (2006), Cedar Rapids (2011), Selma (2014), Trumbo (2015), Get Out (2017), and On the Basis of Sex (2018).\n\nHis television roles have included Capt. K'Vada in the Star Trek: The Next Generation two-part episode "Unification" (1991), Hawthorne Abendsen in seasons 2–4 of the series The Man in the High Castle. He has supporting roles in a variety of HBO series, including Boardwalk Empire, True Blood, Perry Mason, and Succession. He currently stars as Monroe Fuches / The Raven on the HBO dark comedy series Barry (2018–present), for which he was nominated for a Primetime Emmy Award for Outstanding Supporting Actor in a Comedy Series in 2019.	USA	/u1JtE940hFrYFNAQHNJvGnPILoy.jpg
13299	nm0001549	Rita Moreno	1	1931-12-11 00:00:00	\N	Rita Moreno (born Rosa Dolores Alverío Marcano; December 11, 1931) is a Puerto Rican actress, dancer, and singer. Noted for her work across different areas of the entertainment industry, she has appeared in numerous film, television, and theater projects throughout her extensive career spanning over seven decades.\n\nHer work includes supporting roles in the classic musical films Singin' in the Rain (1952), The King and I (1956), and the 1961 and 2021 film adaptations of West Side Story. Her other notable films include Popi (1969), Carnal Knowledge (1971), The Four Seasons (1981), I Like It Like That (1994) and the cult film Slums of Beverly Hills (1998). She is also known for her work on television including the children's television series The Electric Company (1971–1977), and as Sister Peter Marie Reimondo on the HBO series Oz (1997–2003). She voiced the titular role of in Where on Earth Is Carmen Sandiego? from 1994 to 1999. She also gained acclaim for her roles in Jane the Virgin (2015–2019) and the revival of Norman Lear's One Day at a Time (2017–2020). In theater, she is best known for her role as Googie Gomez in the 1975 musical The Ritz.\n\nAmong her numerous accolades, Moreno is one of a few performers to have been awarded an Emmy, a Grammy, an Oscar, and a Tony (EGOT). She is also one of 24 people who have achieved what is called the Triple Crown of Acting, with individual competitive Academy, Emmy and Tony awards for acting. In 2004, she received the Presidential Medal of Freedom, America's highest civilian honor bestowed upon her by George W. Bush. In 2009, President Barack Obama presented her with the National Medal of Arts. In 2013, she received the Screen Actors Guild Life Achievement Award. In 2015, she was awarded a Kennedy Center Honor for her contribution to American culture through performing arts. She was awarded the Peabody Award in 2019. Her life was profiled in the 2021 documentary Rita Moreno: Just a Girl Who Decided to Go for It.	PRI	/zB0M77jr7tmsmWHEr2bWO2Xq66L.jpg
1636954	nm3677062	Ana Isabelle	1	1986-04-11 00:00:00	\N		\N	/7Nxp17PyLleWns6iiKfD1bEk7Ei.jpg
2840908	nm9303275	Ilda Mason	1	\N	\N		\N	\N
2144644	nm2323802	Yvette Reid	0	\N	\N		\N	/xvOQGmSbdtDqfjooe0J4TCAE1db.jpg
824	nm0839486	Ethan Suplee	2	1976-05-25 00:00:00	\N	Ethan Suplee (born May 25, 1976) is an American film and television actor best known for his roles as Seth Ryan in American History X, Louie Lastik in Remember the Titans, Frankie in Boy Meets World, Randy Hickey in My Name Is Earl, Thumper in The Butterfly Effect, Dewey in Unstoppable, and his roles in Kevin Smith films.\n\nDescription above from the Wikipedia article Ethan Suplee, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/gGSb8P9nQdDNu0JC65zyAyMUFhS.jpg
69225	nm0452963	Q'orianka Kilcher	1	1990-02-11 00:00:00	\N	Q'orianka Waira Qoiana Kilcher is a German born American-Peruvian actress, singer, and activist. She played Pocahontas in the 2005 film The New World, and Kaʻiulani in Princess Kaiulani.	DEU	/uduApOlv4MumUKdc9LtLSBL0bW8.jpg
98804	nm1237235	Ronnie Gene Blevins	2	1977-06-20 00:00:00	\N	Ronnie Gene Blevins is an actor and writer.	USA	/28O4ALimfSVQgMOvkstDJpzHKDc.jpg
109708	nm0122987	Bill Burr	2	1968-06-10 00:00:00	\N	William Frederick Burr (born June 10, 1968) is an American stand-up comedian, actor, and podcaster. Outside of stand-up, he is known for creating and starring in the Netflix animated sitcom F Is for Family (2015–present), playing Patrick Kuby in the AMC crime drama series Breaking Bad (2008–2013), and co-founding the All Things Comedy network. He has hosted the twice-weekly comedy podcast, titled The Monday Morning Podcast, since May 2007.\n\nDescription above from the Wikipedia article Bill Burr,  licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/g8VqrigObjAE3QP1Xei1qgO4kfx.jpg
1369336	nm5046593	Amy Forsyth	1	1995-08-06 00:00:00	\N	Amy Forsyth (Born August 6, 1995) is an Canadian Actress,  who won critical acclaim for her performance as Ashley Fields in the Hulu original series “The Path”. She gained huge fame for played the starring role of Natalie in the 2018 Gregory Plotkin directed horror and thriller film “Hell Fest”. In her acting career, she has been cast in the number of popular TV shows including “Rise”, “Channel Zero”, “Defiance” and “Degrassi: The Next Generation”. She began her acting career with 2013 horror and thriller film “Torment” as Mary Bronson.	CAN	/ii3DqSprC4MTFsqzjAloynqVOKB.jpg
135352	nm0621760	Kevin Nash	2	1959-07-09 00:00:00	\N	Kevin Scott Nash is an inactive American professional wrestler and actor, who is signed to WWE. Nash has wrestled under various ring names, but is most notably known by his real name in World Championship Wrestling (WCW), and in WWE/World Wrestling Federation/Entertainment, where he was known as Diesel during his first and current run with the company.\n\nBetween WWE, WCW, and TNA, Nash has won 21 total championships, including six world championships (having won the WCW World Heavyweight Championship five times and the WWF Championship once). He has achieved notable success in the tag team division as well, being a twelve-time world tag team champion: a nine-time WCW World Tag Team Champion, two-time WWF World Tag Team Champion and one-time TNA World Tag Team Champion. He is also a one-time WWF Intercontinental Champion and a two-time winner of the TNA Legends Championship (now known as the TNA Television Championship). In addition to championships, he won the 1998 WCW World War 3. Nash is a member of The Kliq, a group which includes Shawn Michaels, Triple H, Scott Hall and Sean Waltman and was known in the WWE during the 90's as a backstage group were shown favoritism by owner Vince McMahon and often refused to work with others outside of their group. He is also one of the three founding members of the New World Order (nWo), along with Hulk Hogan and Scott Hall.	USA	/voSs3NTtgBHZRO4yCqQxwMhEngc.jpg
4741	nm1064823	Cayden Boyd	2	1994-05-24 00:00:00	\N	Boyd was born in Bedford, Texas. He currently lives in Los Angeles, California with his parents and actress sister, Jenna Boyd. Cayden plays the violin and cello, is on a football team, and is also a proud Christian. Cayden is more experienced in the acting world than most children his age. Growing up in Texas with his parents and sister Jenna Boyd he has been able to stay grounded and says, "My parents are a big help, and they're always making sure I have a normal life and my life isn't all just about acting and stuff."\n\nCayden landed his first roles, small television roles and commercials, as young as 6 and 7. He was cast alongside Sean Penn and Tim Robbins in film "Mystic River". In 2004, Cayden won the lead role in children's film "The Adventures of Sharkboy and Lavagirl". Cayden has also appeared in a number of TV dramas, including "Crossing Jordan", "Cold Case" and "Close to Home". He also had a small but crucial role in the film "X-Men: The Last Stand". In 2008, Cayden starred alongside Julia Roberts and Willem Dafoe in "Fireflies in the Garden", with a strong performance as young Michael.\n\nIn 2010 Cayden took the leading role in the pilot episode of a new TV show "Past Life" giving a very strong performance, and is in possible talks to be returning to the show at a later date.\n\nBoyd has had bit parts in several feature films, including Freaky Friday and Dodgeball: A True Underdog Story. He also played Tim Robbins's son in Mystic River and appeared on the sitcom Scrubs. Boyd's biggest role to date may have been as Max in The Adventures of Shark Boy and Lava Girl. Most recently, he played young Warren Worthington III in X-Men: The Last Stand, and he also had a starring role in the 2007 film Have Dreams, Will Travel.\n\nDescription above from the Wikipedia article Cayden Boyd, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/5PyOB5F8mSp0n0ZNS6iX6rpXOTv.jpg
227477	nm2674140	Nicole LaLiberte	1	1981-12-01 00:00:00	\N	Nicole LaLiberte (born c. 1985) is an American actress. She has had recurring roles on the television series How to Make It in America (2011) and Dexter (2012–2013) and played one of the lead roles alongside Danielle Panabaker in the film Girls Against Boys (2012).	USA	/kizEzG8ApsRhfuwxY2mrbzmtqY1.jpg
1387665	nm4380467	Luke Forbes	2	\N	\N	Luke Forbes is an actor.	\N	/1M69Oj6tKckMJ85RZBEOWbpDiic.jpg
1459439	nm2111860	Patricia Isaac	1	\N	\N		\N	/coyXEuD66wLJloHpCOqUcQcvD9Y.jpg
1564257	\N	Neraida Bega	1	1987-07-01 00:00:00	\N		ALB	/kOTrq23qsgE18uYpyAOafqIEjvh.jpg
1855491	nm6530137	Skyler Joy	1	\N	\N		\N	/1Q41pqvZqnjp7SI3lYRO9xvvtsf.jpg
2026050	nm8287501	Emmy Raver-Lampman	1	1988-09-05 00:00:00	\N		USA	/cBkHUBzqoqrnkxDXWlqQmm91pD2.jpg
2189049	nm8137263	Joy Sunday	1	1995-04-17 00:00:00	\N	Joy Sunday is an actress and filmmaker.	USA	/fTajkqbVGMU4O2LMteuYlffhfJI.jpg
2491917	nm10705229	Trent Buxton	2	\N	\N		\N	/fIyiHdkshDTQSWr2Piyz5MV3Jx.jpg
3255984	\N	Darren keilan	2	\N	\N		\N	/rSBxD5GhPTcoCdofT8HvGUvn7If.jpg
1067065	nm1968931	Cameron Hood	0	\N	\N		\N	\N
3304751	nm6142006	Neiko Neal	2	\N	\N		\N	\N
73620	nm1719608	Ken Lyle	2	\N	\N		\N	/gNJ6YnTVE4WNK0Jy9crauHgJHuq.jpg
3116821	\N	Darin Keith Martin	0	\N	\N		\N	\N
3304754	nm3122003	Chris Borden	2	1981-01-08 00:00:00	\N		USA	\N
1464399	\N	Mike Vaughn	0	\N	\N		\N	\N
3376396	nm3590810	Aavi Haas	1	\N	\N		\N	\N
1593376	nm4379401	Pablo Ramos	0	\N	\N		\N	\N
1539711	\N	Devin White	0	\N	\N		\N	\N
105238	nm1030244	Chukwudi Iwuji	2	1975-10-15 00:00:00	\N	Chukwudi Iwuji (born 15 October 1975) is a Nigerian-British actor. He is an Associate Artist for the Royal Shakespeare Company.	NGA	/5JILtFNmAmA8T4gRQrO5sn8krDv.jpg
1381393	nm1670129	Randy Havens	2	\N	\N	Randall P. "Randy" Havens is an actor, known for STRANGER THINGS (2016), GODZILLA: KING OF THE MONSTERS (2019), and LET'S BE COPS (2014).	\N	/7Lh5eGcXZUoPJcTWaUw369R706E.jpg
1451079	nm3196821	Andrew Constantini	2	\N	\N	Andrew Constantini is known for his work on The Tudors (2007),Captain America: The Winter Soldier (2014) and Time Hunter (2014).	\N	/9rrYhMlKsDFOAAYqNhOWAMXDfc8.jpg
1679132	nm3532912	Andrea Zirio	2	1986-03-15 00:00:00	\N	Born on March 15, 1986 in Turin – Italy – Andrea Zirio is a talented and versatile actor. He has lived in the United States and speaks excellent english. He works in theater, where he plays throughout Europe, and also in national and international film productions. Andrea Zirio is known for his roles in the films “Ulysses – A Dark Odyssey” (2016) alongside Danny Glover and Udo Kier, “Richard the Lionheart” (2013), “Richard the Lionheart: Rebellion” (2014) alongside Malcm McDowell, “L’uomo col cappello” (2013), “Lost in Florence” (2015) alongside Brett Dalton and “Venuto al mondo” (2012) alongside Penelope Cruz.\n\n° Winner of the press award “BEST YOUNG ACTOR” at Theater der Stadt, Theaterfest Greiz – Berlin.\n\n° Winner of “BEST ACTOR” at the Beverly Hills Film Festival 2014 for his role in the film “I see monsters”, also winner of “Best Foreign Film”.	ITA	/e3rFhmDevqAfe5mOk1dESJdx6yM.jpg
2045023	nm3121198	Tory Freeth	1	\N	\N		\N	/ygeLfxcsQCqlLjam7KA9tRnNzBg.jpg
2092052	nm9208180	Ryder McLaughlin	2	1998-04-17 00:00:00	\N		CAN	/iuxff18BZMFH9EUZ5jwaTAmssmi.jpg
2131693	nm6969074	Jamaal Lewis	2	\N	\N		\N	/eG2S2CYigneliGEjJwK4Or6Aehd.jpg
2532648	nm1842975	John William Wright	2	\N	\N	John William Wright is known for Pretty Little Victim (2021), Dating a Killer (2021) and Love in the Sun (2019). He is married to Labri Langston Wright. They have two children.	\N	/8CrPANpRT8vaUsF4paVmbNbXkNJ.jpg
2625316	nm13072633	Ortensia Fioravanti	1	\N	\N	Ortensia Fioravanti is an actor	\N	/rL72JcGLRMrI7emo0Pvk6pUKrMF.jpg
3376382	\N	Justin Louis Weiss	0	\N	\N		\N	/2vG1TQdCCW0cAwb0KvuJzIa0PKf.jpg
4040051	\N	Elodie Clarke	0	\N	\N		\N	\N
4040052	\N	Autumn Griffin	0	\N	\N		\N	\N
4040053	\N	Skylar Huntley	0	\N	\N		\N	\N
1907258	nm7946304	Scarlett Blum	1	\N	\N		\N	/5Dy1xkJYm9g03jRx5RVgOtVNoay.jpg
2437734	nm9863947	Adelynn Spoon	1	2012-07-27 00:00:00	\N	Adelynn Spoon is an actress, known for Watchmen (2019) and Tell Me Your Secrets (2019).	\N	/gw9Van9nmkdaUoGdE2YVinL2Raj.jpg
2651186	nm10880565	Kai Zen	1	2007-02-06 00:00:00	\N	Kai Zen is an American actress. She has acted in the Netflix film, Feel the Beat.\n\nFor Disney, she voiced River in The Rocketeer, Young Anne Boonchuy in Amphibia in the episode "Lost in Newtopia", Pepper in Eureka and played Kid in Classroom in Chip 'n Dale Rescue Rangers. She played Phyla in the 2023 Marvel Cinematic Universe film Guardians of the Galaxy Vol. 3.	USA	/cF15QimDJrSvSvMbYtz8Z9UHIcs.jpg
3158773	nm10867068	Dane DiLiegro	2	1988-08-06 00:00:00	\N	Dane DiLiegro (born August 6, 1988) is a professional basketball player turned actor.	USA	/dBaJs1QNTpYL3RIdBz8VN01mmDf.jpg
4040056	\N	Sarah Anne Li	1	2012-05-05 00:00:00	\N	Sarah Anne is a young actress who discovered her love for acting by participating in musical theatre and dance performances from an early age. Her first debut was in the short film "Living Sent" at age 7. Since then, she has starred as Latti in Guardians of the Galaxy Vol. 3 and Young Kim Da-Eun in Netflix's hit show Cobra Kai. She was in Hulu's The Valet alongside Eugenio Derbez and Samara Weaving. She can also be seen on Sesame Street and in national television commercials for Bissell®, T-Mobile®, and End the Night Right.	USA	\N
4040059	\N	Yael Ocasio	2	\N	\N		\N	\N
4038968	\N	Henry Heffernan	0	\N	\N		\N	\N
3325844	\N	Brooklyn Skye Oliver	0	\N	\N		\N	\N
4040061	\N	Baby Dro	0	\N	\N		\N	\N
4040062	\N	Emery Grilliot	0	\N	\N		\N	\N
4040063	\N	Amelia Waters	0	\N	\N		\N	\N
3118542	nm8238877	Steven Herrera	2	\N	\N		USA	/x8XPgoA5eU9hvghxLu2K6QT6fkQ.jpg
1782149	nm4081195	Kyle Coffman	2	1985-09-21 00:00:00	\N	Kyle Coffman was born on September 21, 1985 in Boise, Idaho, USA. He is an actor, known for West Side Story (2021), Someday This Pain Will Be Useful to You (2011) and Desert Heart (2020).	USA	/4kGxPfwCOGjU5aKGVUK6YicNvQ0.jpg
1669510	nm0925974	Clyde Whitham	2	\N	\N		\N	/bx4005EgyjYidQU6EzrT40cwcoi.jpg
553381	nm1617010	Perry Mucci	0	1977-07-11 00:00:00	\N		\N	/4z8aIXxBL9EwVukgEXIUUbYvC1E.jpg
113505	nm2240346	Kodi Smit-McPhee	2	1996-06-13 00:00:00	\N	Kodi Smit-McPhee (born 13 June 1996) is an Australian actor. He gained recognition as a child actor for his leading roles in The Road (2009) and Let Me In (2010). In 2021, Smit-McPhee garnered critical acclaim for his performance as Peter Gordon in Jane Campion's western film The Power of the Dog, for which he earned nominations for an Academy Award, a BAFTA Award, and a Screen Actors Guild Award, and won the Golden Globe Award for Best Supporting Actor.\n\nHe provided the voice of the titular character in ParaNorman (2012) and appeared in Dawn of the Planet of the Apes (2014), X-Men: Apocalypse (2016), Alpha (2018), and Dark Phoenix (2019).	AUS	/bMg2GipFRXnbk1dKGy1yxr3OeP0.jpg
505710	nm3918035	Zendaya	1	1996-09-01 00:00:00	\N	Zendaya Maree Stoermer Coleman (born September 1, 1996) is an American actress and singer. She began her career as a child model and backup dancer. She rose to mainstream prominence for her role as Rocky Blue on the Disney Channel sitcom Shake It Up (2010–2013).\n\nIn 2013, Zendaya was a contestant on the 16th season of the dance competition series Dancing with the Stars. She produced and starred as the titular spy, K.C. Cooper, in the sitcom K.C. Undercover (2015–2018). Her film roles include the musical drama The Greatest Showman (2017), the superhero film Spider-Man: Homecoming (2017) and its sequels, the computer-animated musical comedy Smallfoot (2018), the romantic drama Malcolm & Marie (2021), the live-action/animation hybrid sports comedy Space Jam: A New Legacy (2021), and the science fiction epic Dune (2021).	USA	/6TE2AlOUqcrs7CyJiWYgodmee1r.jpg
30613	nm0001018	Keith Carradine	2	1949-08-08 00:00:00	\N	Keith Ian Carradine (born August 8, 1949) is an American actor and singer-songwriter.	USA	/5gayZWGqjTAVJXr1bXovk3oqOxW.jpg
3521003	\N	Kenneth Radley	0	\N	\N		\N	\N
1404367	nm7212536	David Denis	0	\N	\N		\N	\N
3065081	\N	Lewis McAskie	0	\N	\N		\N	\N
56101	nm0394531	Gerard Horan	2	1962-11-11 00:00:00	\N		GBR	/crvohW6KrgAZUgoBE8IwKN5ErxQ.jpg
1539216	nm6916321	Ferdia Walsh-Peelo	2	1999-10-12 00:00:00	\N	Ferdia Walsh-Peelo was born on October 12, 1999 in Ashford, County Wicklow, Ireland. He is an actor, known for Sing Street (2016), CODA (2021) and Love Gets a Room (2021).	IRL	/zkBUotUEE6WNlKzd0QPwqf8PE3T.jpg
3280234	\N	Calvin Clausell Jr.	0	\N	\N		\N	\N
154785	nm0693957	Mark Povinelli	2	1971-08-09 00:00:00	\N	Mark Povinelli is an actor and stunt.	\N	/yG4uwd6VaX9ThGC4V9cXyIWJ1Hj.jpg
1437491	nm3663196	Ariana DeBose	1	1991-01-25 00:00:00	\N	Ariana DeBose (born January 25, 1991) is an American actress, dancer, and singer. Known for her performances on stage and screen, she has received multiple accolades, including an Academy Award, a British Academy Film Award and a Golden Globe Award. In 2022, Time magazine named her one of the 100 most influential people in the world.\n\nDescription above from the Wikipedia article Ariana DeBose, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/8HTSA2iVTsDN83OncAvFTcqxsAr.jpg
2225865	nm3174725	David Alvarez	2	1994-05-11 00:00:00	\N		\N	/gQ9VIVXq6N11LMhVaEEGmRD5uqA.jpg
1423520	nm4576311	Mike Faist	2	1992-01-05 00:00:00	\N	Mike Faist is an American actor, dancer, and singer. He's starred in the original Broadway productions of Newsies and Dear Evan Hansen, and has starred in movies such as West Side Story (2021), The Grief of Others (2015), and I Can I Will I Did (2017).	USA	/fk7zMd0PAPyhUbEMVH0zzyzzDM7.jpg
175829	nm0195421	Brian d'Arcy James	2	1968-06-29 00:00:00	\N	Brian d'Arcy James (born June 29, 1968) is an American actor and musician. He is known primarily for his Broadway roles, including Shrek in Shrek The Musical, Nick Bottom in Something Rotten!, King George III in Hamilton, and the Baker in Into the Woods, and has received three Tony Award nominations for his work.\n\nOn-screen, he is known for his recurring role as Andy Baker on the Netflix series 13 Reasons Why, Officer Krupke in West Side Story, and reporter Matt Carroll in Spotlight.\n\nDescription above from the Wikipedia article Brian d'Arcy James, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/2Gz3b0A20Vrq7aadGfjZekdgGFK.jpg
74541	nm1015684	Corey Stoll	2	1976-03-14 00:00:00	\N	Corey Daniel Stoll (born March 14, 1976) is an American actor. He is best known for his roles as Congressman Peter Russo on the Netflix political thriller series House of Cards (2013–2016), for which he received a Golden Globe nomination in 2013, and Dr. Ephraim Goodweather on the FX horror drama series The Strain (2014–2017). Since 2020, he has portrayed Michael Prince, a business rival to protagonist Bobby Axelrod, in the Showtime series Billions. He was also a regular cast member on the NBC drama series Law & Order: LA (2010–2011) and portrayed Darren Cross / Yellowjacket in the Marvel Cinematic Universe film Ant-Man (2015). Other notable roles include an off-Broadway performance of Intimate Apparel (2004), Ernest Hemingway in the romantic comedy film Midnight in Paris (2011) a performance for which he was nominated for the Independent Spirit Award for Best Supporting Male, bulldog prosecutor Fred Wyshak in Black Mass (2015), and astronaut Buzz Aldrin in the biopic First Man (2018).\n\nDescription above from the Wikipedia article Corey Stoll, licensed under CC-BY-SA, full list of contributors on Wikipedia	USA	/etqmosIyf1xePKpi3i6rHJCm9GE.jpg
2269067	nm10399506	Josh Andrés Rivera	2	1995-05-01 00:00:00	\N	Josh Andrés Rivera is an actor, known for West Side Story (2021), The Hunger Games: The Ballad of Songbirds and Snakes (2023) and Cat Person.	\N	/wO4lqUyQqOTPWo0cWrLuukses68.jpg
2531140	nm10772681	iris menas	1	\N	\N		\N	\N
2531143	nm4029272	Julius Anthony Rubio	2	\N	\N		\N	\N
2721914	nm3433552	Tanairi Sade Vazquez	1	\N	\N		\N	/AvZ1DjSXCNT4Bvi0SzPftS1swnx.jpg
3441020	nm5822012	David Aviles Morales	2	\N	\N		\N	\N
1638835	nm1302113	Oliver Ryan	2	\N	\N		\N	/S0YPiYOSikfqjR6HMuxoFDzh0f.jpg
1102260	nm1892299	Lara Jean Chorostecki	1	1984-09-24 00:00:00	\N	Lara Jean Chorostecki is a Canadian stage and screen actress.	CAN	/gBuEZfohaCyZS8FeOUYeJEqLpRY.jpg
1982903	nm7950698	Gloria Obianyo	1	\N	\N		\N	/8vRsNhtxFzYsHQItIKwcMW9flts.jpg
1759682	nm3052397	Katie McCabe	1	\N	\N		\N	/eNMnnls2wPN7LeE70jK5BkQtPQ6.jpg
16483	nm0000230	Sylvester Stallone	2	1946-07-06 00:00:00	\N	Sylvester Stallone (born Michael Sylvester Gardenzio Stallone, July 6, 1946) is an American actor and filmmaker. After his beginnings as a struggling actor for a number of years upon arriving to New York City in 1969 and later Hollywood in 1974, he won his first critical acclaim as an actor for his co-starring role as Stanley Rosiello in The Lords of Flatbush.\n\nHe subsequently found gradual work as an extra or side character in films with a sizable budget until he achieved his greatest critical and commercial success as an actor and screenwriter, starting in 1976 with his role as boxer Rocky Balboa, in the first film of the successful Rocky series (1976–present), for which he also wrote the screenplays. In the films, Rocky is portrayed as an underdog boxer who fights numerous brutal opponents, and wins the world heavyweight championship twice.\n\nIn 1977, he was the third actor in cinema to be nominated for two Academy Awards for Best Original Screenplay and Best Actor. His film Rocky was inducted into the National Film Registry, and had its props placed in the Smithsonian Museum. His use of the front entrance to the Philadelphia Museum of Art in the Rocky series led the area to be nicknamed the Rocky Steps. Philadelphia has a statue of his Rocky placed permanently near the museum, and he was voted into the International Boxing Hall of Fame.\n\nUp until 1982, his films were not big box office successes unless they were Rocky sequels, and none received the critical acclaim achieved with the first Rocky. This changed with the successful action film First Blood in which he portrayed the PTSD-plagued soldier John Rambo. Originally an adaptation of the eponymous novel by David Morell, First Blood’s script was significantly altered by Stallone during the film’s production. He would play the role in a total of five Rambo films (1982–2019). From the mid-1980s through to the late 1990s, he would go on to become one of Hollywood's highest-paid actors of that era by appearing in a slew of commercially successful action films which were however generally panned by critics. These include Cobra, Tango and Cash, Cliffhanger, the better received Demolition Man, and The Specialist.\n\nHe declined in popularity in the early 2000s but rebounded back to prominence in 2006 with a sixth installment in the Rocky series and 2008 with a fourth in the Rambo series. In the 2010s, he launched The Expendables films series (2010–2014), in which he played the lead as the mercenary Barney Ross. In 2013, he starred in the successful Escape Plan, and acted in its sequels. In 2015, he returned to the Rocky series with Creed, that serve as spin-off films focusing on Adonis "Donnie" Creed played by Michael B. Jordan, the son of the ill-fated boxer Apollo Creed, to whom the long-retired Rocky is a mentor. Reprising the role brought him praise, and his first Golden Globe award for the first Creed, as well as a third Oscar nomination, having been first nominated for the same role 40 years prior.	USA	/pOpbPofjwpynRkWPZZZkyGds6rx.jpg
93491	nm2401020	Will Poulter	2	1993-01-28 00:00:00	\N	William Jack Poulter (born January 28, 1993) is an English actor. He first gained recognition for his role as Eustace Scrubb in the fantasy adventure film The Chronicles of Narnia: The Voyage of the Dawn Treader (2010). He received critical praise for his starring role in the comedy film We're the Millers (2013), for which he won the BAFTA Rising Star Award.\n\nPoulter starred in the dystopian science fiction film The Maze Runner (2014) and the sequel Maze Runner: The Death Cure (2018), the period epic film The Revenant (2015), the crime drama film Detroit (2017), the interactive science fiction film Black Mirror: Bandersnatch (2018), and the folk horror film Midsommar (2019). In 2021, he had a leading role in the Hulu miniseries Dopesick, for which he received an Emmy nomination for Outstanding Supporting Actor in a Limited or Anthology Series or Movie. In 2023, he joined the Marvel Cinematic Universe as Adam Warlock in Guardians of the Galaxy Vol. 3.	GBR	/9blYMaj79VGC6BHTLmJp3V5S8r3.jpg
1133349	nm4456120	Elizabeth Debicki	1	1990-08-24 00:00:00	\N	Elizabeth Debicki (born 24 August 1990) is an Australian actress. After making her feature film debut in A Few Best Men (2011), she appeared in The Great Gatsby (2013) as Jordan Baker. Other roles are in the limited series The Night Manager (2016) and Widows (2018).	FRA	/nXXbGG1vCrHlscwqD55EGI9aHpA.jpg
1696434	nm5837211	Austin Freeman	2	\N	\N	Austin Freeman is an American actor, born in Anderson, SC to Deana and Robert Roach, and Roger Freeman. He began acting in theatrical productions at the age of 16 where he discovered a love for entertainment. He received his Bachelor's in Theatre Performance with a Minor in Religious Studies from Young Harris College in 2012 and has been pursuing a career in entertainment with a passion. While he is a classically trained stage actor, Austin has performed in productions for theatre, feature film, short film, television, commercial, voice over, web series, and improv performances. He is a singer, musician, dancer, voice actor and combatant. He loves having the ability and opportunity to act and create stories about the human experience while fully experiencing and learning what it means to be human.	USA	/ayMPH1a0QKAeiCVk77L5i5IZdlc.jpg
565447	nm0694454	Romina Power	1	1951-10-02 00:00:00	\N	Romina Francesca Power is an American actress and singer born in Los Angeles, California. She is the daughter of Hollywood matinée idol Tyrone Power and actress Linda Christian. Romina Power was half of the music duo Al Bano and Romina Power, which gained popularity in many parts of the world during the 1980s.	USA	/mwrPRD0g0oZCQkPKASMyzsNQy3G.jpg
2254	nm1478007	Curtiss Cook	2	\N	\N	Curtiss Cook is a film actor.	USA	/3mk5CZBzdjYUzmrfMDSnGJL4QIb.jpg
2242772	nm7408602	Annelise Cepero	1	\N	\N	Annelise Cepero is an American actress, singer and dancer hailing from Yonkers, New York. She is now based in New York City.	\N	/vxtWQFZF70gsaDyHA6y2uQnEWgO.jpg
230	nm0565569	Stephen McHattie	2	1947-02-03 00:00:00	\N	Stephen McHattie is a Canadian stage, film and television actor. He's a graduate of the American Academy of Dramatic Arts, Manhattan, New York, USA.	CAN	/v1fIX9IVrZdG9PWNtvdwrbgfJuG.jpg
26860	nm0785938	John Sessions	2	1953-01-11 00:00:00	2020-11-02 00:00:00	Actor, comedian and impressionist who was better known for his improvisation comedy.	GBR	/8bN5H7T9XtOMijCwGndaMVCQ2sI.jpg
8399	nm0265457	Christopher Fairbank	2	1953-10-04 00:00:00	\N	Christopher Fairbank (sometimes credited as Chris Fairbank; born 4 October 1953) is an English actor best known for his role as Moxey in the hit comedy-drama series Auf Wiedersehen, Pet. Fairbank was born in Hertfordshire, England. He has numerous television credits to his name, notably in Sapphire and Steel, The Professionals, The Scarlet Pimpernel and provided minor voice talent for both the hit Wallace and Gromit feature-length film Curse of the Were-Rabbit and Flushed Away (both produced by Aardman). Fairbank also appeared as one of the pair of muggers who rob an out-of-town family, heralding the first appearance of the Batman in Tim Burton's 1989 film. Fairbank also had roles as Mactilburgh the scientist in the film The Fifth Element, the prisoner Murphy in Alien 3, and the Player Queen in the Franco Zeffirelli version of Hamlet, opposite Mel Gibson. Recently, he provided the voice of Old King Doran in the video game Demon's Souls and provides a number of voice accents in the PS2 video game Prisoner of War. Chris also appeared in Goal! trilogy in the character of a Newcastle United fan. In 2010, Chris appeared as a detective in the BBC Drama, Five Daughters, and as Alfred "Freddie" Lennon in the biopicLennon Naked with Christopher Eccleston. In 2011 Fairbank starred in Pirates of the Caribbean: On Stranger Tidesas a pirate called Ezekiel. In 2012 he appeared as an Australian in Sky 1's Starlings.	\N	/eSOuf8dTGjwjlConY7d1FGgRNY7.jpg
12132	nm0740264	Michael Rooker	2	1955-04-06 00:00:00	\N	Michael Rooker (born April 6, 1955) is an American actor known for his roles as Henry in Henry: Portrait of a Serial Killer (1986), Chick Gandil in Eight Men Out (1988), Terry Cruger in Sea of Love (1989), Rowdy Burns in Days of Thunder (1990), Bill Broussard in JFK (1991), Hal Tucker in Cliffhanger (1993), Jared Svenning in Mallrats (1995), Detective Howard Cheney in The Bone Collector (1999), Grant Grant in Slither (2006), Merle Dixon in AMC's The Walking Dead (2010–2013) and Yondu Udonta in Guardians of the Galaxy (2014), its sequel, Guardians of the Galaxy Vol. 2 (2017), and the animated TV series What If...? (2021).\n\nSince 2006, he has been a frequent collaborator of filmmaker James Gunn.	USA	/dq3xFKDWJsQjPffm1bmB3TbMilq.jpg
20755	nm0418853	Natalia Safran	1	1970-09-18 00:00:00	\N	Natalia Safran was born on September 18, 1970 as Natalia Karolina Maria von Laskowska Jaroszyk. She is an actress and producer, known for Hours (2013), Aquaman (2018) and Flatliners (2017). She is married to Peter Safran.	POL	/3luVtifpeQvF54jEf6NbK2Oz0dE.jpg
78021	nm0442207	Lloyd Kaufman	2	1945-12-30 00:00:00	\N	Stanley Lloyd Kaufman Jr. (born December 30, 1945) is an American film director, screenwriter, producer and actor. Alongside producer Michael Herz, he is the co-founder of Troma Entertainment film studio, and the director of many of their feature films, such as The Toxic Avenger and Tromeo and Juliet.\n\nDescription above from the Wikipedia article Lloyd Kaufman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/jOkuLNusxT07mxTIJ3ApAdjPy6M.jpg
4040064	\N	Murphy Weed	0	\N	\N		\N	\N
1528191	nm1534561	Rhett Miller	2	\N	\N		\N	/pu1pcZBbkq43qxECHi3YzbZfLnn.jpg
236	nm0531628	Bill MacDonald	2	\N	\N	Bill MacDonald is known for A History of Violence (2005), The Long Kiss Goodnight (1996) and Nightmare Alley (2021).	\N	/rxbAbufSIWNo8OJvK2BO4cvWC41.jpg
96510	nm0496606	Vadim Ledogorov	2	1957-05-05 00:00:00	\N		\N	/wgLcf6RCZeU3iB0PvUdqUxiViKC.jpg
979216	nm1497615	Victor Cruz	2	1980-08-05 00:00:00	\N	Victor Cruz is an American actor, filmmaker and acting coach. He is known for guest roles in film and television, such as "Annie", "The Other Woman", "Law &amp; Order", and "The Humbling".	USA	/qPjjedetherS1O4W0Uv4A2usfOo.jpg
1253648	nm0911604	Jeff Ward	2	\N	\N	Jeffrey Ward is an actor and stunt performer.	\N	/mgFudU2FAOHUcYJDccPQipjAoQK.jpg
1720614	nm4016292	Michael Andrew Baker	2	\N	\N		\N	/yww1ArQy1dRZFu5w7iwpT7AhSfe.jpg
200999	nm0198489	Nancy Daly	0	\N	\N		\N	/8bk5wOqmN4l0eFOZ4JnieLgemWP.jpg
8691	nm0757855	Zoe Saldaña	1	1978-06-19 00:00:00	\N	Zoe Yadira Saldaña-Perego (née Saldaña Nazario; born June 19, 1978) is an American actress. After performing with the theater group Faces she appeared in two 1999 episodes of Law & Order. Her film career began a year later with Center Stage (2000) in which she portrayed a ballet dancer.\n\nAfter receiving early recognition for her work opposite Britney Spears in the road film Crossroads (2001), Saldaña achieved her career breakthrough with her work in numerous science fiction films, beginning in 2009 with her first of multiple appearances as Nyota Uhura in the Star Trek film series and her first appearance as Neytiri in the Avatar film series. She portrays Gamora in the Marvel Cinematic Universe, beginning with Guardians of the Galaxy (2014). Saldaña appeared in three of the five highest-grossing films of all time (Avatar, Avengers: Infinity War, and Avengers: Endgame), a feat not achieved by any other actor. Her films grossed more than $11 billion worldwide, and she is the second-highest-grossing film actress of all time as of 2019.\n\nDescription above from the Wikipedia article Zoe Saldaña, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/iOVbUH20il632nj2v01NCtYYeSg.jpg
73457	nm0695435	Chris Pratt	2	1979-06-21 00:00:00	\N	Christopher Michael Pratt (born 21 June 1979) is an American actor, known for starring in both television and action films. He rose to prominence for his television roles, particularly in the NBC sitcom Parks and Recreation (2009–2015), for which he received critical acclaim and was nominated for the Critics' Choice Television Award for Best Supporting Actor in a Comedy Series in 2013. He also starred earlier in his career as Bright Abbott in The WB drama series Everwood (2002–2006) and had roles in Wanted (2008), Jennifer's Body (2009), Moneyball (2011), The Five-Year Engagement (2012), Zero Dark Thirty (2013), Delivery Man (2013), and Her (2013).\n\nPratt achieved leading man status in 2014, starring in two critically and commercially successful films: The Lego Movie as Emmet Brickowski, and Marvel Studios' Guardians of the Galaxy as Star-Lord. He starred in Jurassic World (2015) and Jurassic World: Fallen Kingdom (2018), and he reprised his Marvel role in Guardians of the Galaxy Vol. 2 (2017), Avengers: Infinity War (2018), Avengers: Endgame (2019), and the planned Guardians of the Galaxy Vol. 3. Meanwhile, in 2016 he was part of an ensemble cast in The Magnificent Seven and the male lead in Passengers.\n\nDescription above is from the Wikipedia article Chris Pratt, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/83o3koL82jt30EJ0rz4Bnzrt2dd.jpg
543261	nm2394794	Karen Gillan	1	1987-11-28 00:00:00	\N	Karen Gillan (born 28 November 1987) is a Scottish actress, director, and screenwriter from Inverness, Scotland. She played the role of Amy Pond, companion to the Eleventh Doctor, in the BBC One science fiction series Doctor Who (2010–2013). In film, she portrayed Nebula in the Marvel Cinematic Universe films Guardians of the Galaxy (2014) and Guardians of the Galaxy Vol. 2 (2017), Avengers: Infinity War (2018), Avengers: Endgame (2019) and Thor: Love and Thunder (2022), and also played Ruby Roundhouse in the box-office hit Jumanji: Welcome to the Jungle (2017). In 2018, she released her first feature film as writer and director, titled The Party's Just Beginning.\n\nDescription above from the Wikipedia article Karen Gillan, licensed under CC-BY-SA, full list of contributors on Wikipedia.	GBR	/kFLXcFdok3ShDxylr3WNreQphQm.jpg
12835	nm0004874	Vin Diesel	2	1967-07-18 00:00:00	\N	Mark Sinclair (born July 18, 1967), known professionally as Vin Diesel, is an American actor and producer. One of the world's highest-grossing actors, he is best known for playing Dominic Toretto in the Fast & Furious franchise.\n\nDiesel began his career in 1990, but faced difficulty achieving recognition until he wrote, directed and starred in the short film Multi-Facial (1995) and his debut feature Strays (1997); the films prompted Steven Spielberg to cast Diesel in the war epic Saving Private Ryan (1998). Diesel subsequently voiced the titular character in The Iron Giant (1999) and then gained a reputation as an action star after headlining the Fast & Furious, XXX, and The Chronicles of Riddick franchises. He is slated to appear in the upcoming Avatar films.\n\nDiesel voices Groot and Groot II in the Marvel Cinematic Universe (MCU); he portrayed the characters in six superhero films, beginning with Guardians of the Galaxy (2014). Diesel has reprised his role as Groot for the Disney+ animated shorts series I Am Groot (2022–present), the television special The Guardians of the Galaxy Holiday Special (2022), and the animated film Ralph Breaks the Internet (2018). Diesel achieved commercial success in the comedy The Pacifier (2005) and his portrayal of Jackie DiNorscio in Find Me Guilty (2006) was praised.\n\nHe founded the production company One Race Films, where he has also served as a producer or executive producer for his star vehicles. Diesel also founded the record label Racetrack Records and video game developer Tigon Studios, providing his voice and motion capture for all of Tigon's releases.\n\nDescription above from the Wikipedia article Vin Diesel, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/7rwSXluNWZAluYMOEWBxkPmckES.jpg
51663	nm0348231	Sean Gunn	2	1974-05-22 00:00:00	\N	Sean Gunn (born May 22, 1974) is an American actor. He is known for his roles as Kirk Gleason on The WB series Gilmore Girls (2000–2007), Kraglin Obfonteri in the Marvel Cinematic Universe films Guardians of the Galaxy (2014), Guardians of the Galaxy Vol. 2 (2017), Avengers: Endgame (2019), Thor: Love and Thunder (2022) and Guardians of the Galaxy Vol. 3 (2023), and Weasel and Calendar Man in the Warner Bros./DCEU film The Suicide Squad (2021).\n\nDescription above from the Wikipedia article Sean Gunn, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/jXCNsh2c7vKWhWgpSGEdgFSLjxm.jpg
4024360	\N	Jasmine Sunshine Munoz	0	\N	\N		\N	\N
3125907	nm4530613	Giovannie Cruz	1	\N	\N		\N	\N
4028624	nm14819380	Noa Raskin	0	\N	\N		\N	\N
18273	nm0794896	Miriam Shor	1	1971-07-25 00:00:00	\N	From Wikipedia, the free encyclopedia\n\nMiriam Shor (born July 25, 1971) is an American film and television actress.\n\nDescription above from the Wikipedia article Miriam Shor, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/mT3sSMwk0opAQze2bJvu2JWyHoe.jpg
85096	nm0002888	Stephen Blackehart	2	1967-12-01 00:00:00	\N	From Wikipedia, the free encyclopedia.\n\nStephen Blackehart (born 1 December 1967 in New York City) is an American actor and producer from Hell's Kitchen, New York. It has been reported that Blackehart was born Stefano Brando and is the son of actor Marlon Brando. A graduate of the London Academy of Music and Dramatic Art, Blackehart is most known for playing Benny Que in the cult classic film Tromeo and Juliet, though he has also acted in many other B-movies, such as Rockabilly Vampire, Retro Puppet Master and 100 Million BC.\n\nIn addition to his film work, Blackehart has acted in such TV series as Grey's Anatomy, The Big Apple, and as Lt. Pa'ak in Star Trek: Deep Space Nine. He was a regular on the BBC's The Tromaville Cafe, where he originated the role of Felix, the French Trickster.\n\nIn 2004, Blackehart produced Jenna Fischer's mockumentary film LolliLove, and was among the first ever producers to make extensive use of social networking sites like MySpace to aggressively promote a feature film.[citation needed] It was subsequently picked up for distribution by Troma and garnered DVD Talk's distinction as a "Collector's Series" disc immediately upon its video release. It was also voted #2 by the editors of Amazon in their list of Best DVDs of the Year - Comedy, and completely sold out of all copies within the first day of release.\n\nMost recently, he has produced hit comedy web series like James Gunn's PG Porn and Humanzee!\n\nDescription above from the Wikipedia article Stephen Blackehart, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/v5niazocH1HjyCIxrnbrf93P1dK.jpg
1411625	nm0741893	Terence Rosemore	2	1964-07-29 00:00:00	\N	Terence Rosemore was born in Great Falls, Montana and raised in New Orleans where he got his start as an Actor in Ted Gilliam's Dashiki Theatre Company.\n\nHe is an award winning Filmmaker and Actor who has worked with some of the biggest names in the industry including Robert Duvall, Halle Berry, Matthew McConaughy, Kevin Hart, Nicolas Cage, Don Cheadle, and Will Ferrell.\n\nRosemore is the founder of digital media company Out of Nowhere Films. Content created by Rosemore has been featured on NBC/Universal's DotComedy.com, ChannelME.TV and Columbia/Sony's Crackle.com.\n\nHe lives in Los Angeles writing, directing, producing and developing Film, Television and Web based projects. IMDb Mini Biography	\N	/mjBaREqAREvJLxDpOlUGLxaYrIP.jpg
5365	nm0004286	Clifton Collins Jr.	2	1970-06-16 00:00:00	\N	Clifton Collins Jr. is an American film and television actor, best known for playing student Cesar Sanchez opposite substitute teacher Samuel L. Jackson in the feature film "One Eight Seven", and as the killer Perry Smith in the independent movie "Capote". He also played recurring characters in many television shows and is a series regular in HBO's "Westworld".	USA	/ceryVVubF74pgu13Y0KUqIzxOae.jpg
5292	nm0000243	Denzel Washington	2	1954-12-28 00:00:00	\N	Denzel Hayes Washington, Jr. is an American actor, screenwriter, director and film producer. He first rose to prominence when he joined the cast of the medical drama St. Elsewhere, playing Dr. Philip Chandler for six years. He has received much critical acclaim for his work in film since the 1990s, including for his portrayals of real-life figures, such as Steve Biko, Malcolm X, Rubin ‘Hurricane’ Carter, Melvin B. Tolson, Frank Lucas, and Herman Boone. Washington has received two Academy Awards, two Golden Globe awards, and a Tony Award. He is notable for winning the Best Supporting Actor Oscar for his part in Glory in 1989, and the Academy Award for Best Actor in 2001 for his role in the film Training Day.	USA	/jj2Gcobpopokal0YstuCQW0ldJ4.jpg
1817	nm0004802	Linda Cardellini	1	1975-06-25 00:00:00	\N	Linda Edna Cardellini (born June 25, 1975) is an American actress. In television, she is known for her leading roles in the teen drama Freaks and Geeks (1999–2000), the medical drama ER (2003–09), the drama thriller Bloodline (2015–17), and the tragicomedy Dead to Me (2019–present), the latter of which earned her a nomination for the Primetime Emmy Award for Outstanding Lead Actress in a Comedy Series. She also guest starred in the period drama Mad Men (2013–15), for which she received a Primetime Emmy Award nomination. Her voice work includes the animated series Scooby-Doo! Mystery Incorporated (2010–13), Regular Show (2012–15), Gravity Falls (2012–16), and Sanjay and Craig (2013–16).\n\nIn film, Cardellini is best known for her portrayal of Velma Dinkley in Scooby-Doo (2002) and its sequel Scooby-Doo 2: Monsters Unleashed (2004), and her supporting roles in Legally Blonde (2001), Brokeback Mountain (2005), Grandma’s Boy (2006), Kill the Irishman (2011), Avengers: Age of Ultron (2015), The Founder (2016), Green Book, A Simple Favor (both 2018), and Avengers: Endgame (2019). She also starred in the drama Return (2011), earning an Independent Spirit Award for Best Female Lead nomination, the comedies Daddy's Home (2015) and Daddy's Home 2 (2017), and the horror film The Curse of La Llorona (2019).\n\nDescription above from the Wikipedia article Linda Cardellini, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/bcycvynDprC1rrhBNrnBjn5uOUd.jpg
1159982	nm5052065	Ansel Elgort	2	1994-03-14 00:00:00	\N	Ansel Elgort (born March 14, 1994) is an American actor and singer. He began his acting career with a supporting role in the horror film Carrie (2013) and gained wider recognition for starring as a teenage cancer patient in the romantic drama film The Fault in Our Stars (2014) and for his supporting role in The Divergent Series (2014–2016). In 2017, he played the title character in Edgar Wright's action thriller Baby Driver, for which he received a Golden Globe Award nomination for Best Actor in a Motion Picture – Musical or Comedy. He is also known for his lead role in The Goldfinch (2019) and his performance in the lead role of Tony in Steven Spielberg's 2021 film version of West Side Story.	USA	/ynceZwoR41V4FBiElUpgG5aFi9i.jpg
2217977	nm10399505	Rachel Zegler	1	2001-05-03 00:00:00	\N	Rachel Anne Zegler (born May 3, 2001) is an American actress and singer. She made her film debut playing Maria Vasquez in the 2021 musical drama West Side Story, for which she won the Golden Globe Award for Best Actress – Motion Picture Comedy or Musical.	USA	/ycseVLFDnnTQ9QubleZjdbrGl4r.jpg
1730574	nm5091224	Kika Cicmanec	0	\N	\N		\N	/l5qJsjzmtYY17vRHM3NwOvHZEd1.jpg
1656863	nm2616557	Ray Chase	2	\N	\N		\N	/xeJKJnvIwItI90roo7mMUduBbbq.jpg
931876	nm1033625	Chryssie Whitehead	1	\N	\N	Chryssie Whitehead is an actress.	USA	/9kUVzfjtq77tPeSKMUaMrLNEJRK.jpg
2215982	\N	Jimmy Walker Jr.	2	1949-02-12 00:00:00	\N		USA	/ucTGwh5gTwU3063omYa6FXtSZkC.jpg
587823	nm2129444	Alice Englert	1	1994-06-15 00:00:00	\N	New Zealand-born Alice Allegra Englert was born on June 15, 1994. She made her screen debut in the short films ‘Listen’ by Paula Maling in 2001 and ‘The Water Diary’, written and directed by Englert’s mother, Academy Award-winner Jane Campion. Her father is film-maker Colin Englert and she has a young half-brother named Gabriel.\n\nEarly in Englert’s career, she managed to land a supporting role in the romantic comedy ‘Singularity’, starring Josh Hartnett and Neve Campbell. Englert also stars as a young girl caught in the middle of the 1960′s “Ban the Bomb” movement alongside Elle Fanning in Sally Potter’s ‘Ginger and Rosa’. The Kiwi actress plays her first romantic lead opposite British actor Alden Ehrenreich in Warner Bros.’ supernatural thriller ‘Beautiful Creatures’, a film adapted from the first book of the Caster Chronicles series.\n\nBut acting is not her only passion, Alice also is a talented singer, guitarist, songwriter, and poetess. She named one of her song Necessary Pains.	AUS	/lEXLJpH29u2fTTqOIEsxEtSQP8C.jpg
1833006	nm5501634	Calvin Desautels	2	\N	\N	Calvin Desautels is a Canadian film and television actor. He's a graduate in Acting from Ryerson University, Toronto, Ontario, Canada.	CAN	/3Y8mWg60SjIgYlatW4ZNKX48s44.jpg
2160722	nm8458059	Fehinti Balogun	2	\N	\N		\N	/lgwljS8zU7KWRlXMdyow34O7kvJ.jpg
118895	nm3402269	Tory N. Thompson	2	\N	\N		\N	/bA5XgQBhWzzRZfRHFDjAUWSjX0W.jpg
2035828	nm7347679	Pamela Jayne Morgan	1	\N	\N	Pamela Jayne Morgan is an actress.	USA	/zaeCnBH0BvWhXopMHmT4sN3yuxz.jpg
2211961	\N	Wayne T. Carr	0	\N	\N		\N	/9TBD3GoEH3SR29fyZF4jJcHu4kl.jpg
1937912	\N	Reinaldo Faberlle	0	\N	\N		\N	\N
3192808	nm3459297	Jared Leland Gore	2	\N	\N		\N	\N
4040040	\N	Hanna Pak	0	\N	\N		\N	\N
1437829	nm3456228	Danya LaBelle	0	\N	\N		\N	/5U6EVYgvyqhioe1tQCw1VcQFrbT.jpg
15762	nm0152839	Tara Strong	1	1973-02-12 00:00:00	\N	Tara Lyn Charendoff-Strong (born February 12, 1973) is a Canadian-American actress, voice-over artist, comedian, musician, singer, and businesswoman, who is best known for her roles as Timmy Turner in the The Fairly OddParents, Bubbles in The Powerpuff Girls, Ben Tennyson in Ben 10 and Ben 10: Ultimate Alien, Dil Pickles in Rugrats and All Grown Up, and her recurring role as Miss Collins in Big Time Rush.\n\nDescription above from the Wikipedia article Tara Strong, licensed under CC-BY-SA, full list of contributors on Wikipedia.	CAN	/y9S3QzI3L5aARP8GYYO86rREKxU.jpg
19975	nm0742146	Michael Rosenbaum	2	1972-07-11 00:00:00	\N	Michael Rosenbaum (born July 11, 1972) is an American actor and director. He is best known for portraying Lex Luthor on Smallville and Flash in the DC animated universe.	USA	/9a1wACjRIAg1cbTEsL5WrzPwnFi.jpg
141448	nm0303284	Gary Galone	2	1954-06-25 00:00:00	\N	Massachusetts native born June 25, 1964. High school three-sport athlete and class president who went on to the University of Massachusetts to play baseball and study business. Graduated in 1986 with a major in marketing and a minor in communications. Began pursuing acting in 1988 when he worked as an extra on his first film, "Field of Dreams," where he pitched batting practice to Kevin Costner in dream sequence scenes that were eventually cut from the film. Joined AFTRA in March of 1989, and became eligible for SAG through principal work shortly thereafter. Joined his family's incentive and awards company in 1990, helping to grow it to over $30 million in annual revenue, while at the same time pursuing acting by appearing in numerous commercials, industrial training films, independent films and television.	USA	/nAjZA1W3y5rSDmRKHRXLcApaiWW.jpg
23680	nm0048389	Dee Bradley Baker	2	1962-08-31 00:00:00	\N	Dee Bradley Baker (born August 31, 1962) is an American voice actor. Noted as his long-running-role as Squilliam Fancyson and other various characters in the hit TV series SpongeBob SquarePants. He is best known for his voice-work on Avatar: The Last Airbender, Codename: Kids Next Door, Phineas and Ferb, Adventure Time with Finn and Jake, American Dad!, Ben 10, Star Wars: The Clone Wars, Halo, Gears of War, Portal 2, and Left 4 Dead.\n\nDescription above from the Wikipedia article Dee Bradley Baker, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/9oFnToDZWp0I484s7Ua1EzNQQ2m.jpg
87165	nm1684744	Jennifer Holland	1	1984-06-04 00:00:00	\N	Jennifer Holland is an American actress. She is known for her work as Emilia Harcourt in the film The Suicide Squad and the television series Peacemaker. She also worked in American Pie Presents: The Book of Love.	USA	/ynuKq1Pd6aVGwhb07uJ0PiYV4F6.jpg
149641	nm1265899	Chet Grissom	2	1965-01-27 00:00:00	\N	Chet Grissom is an actor.	USA	/yTfrcarwGM9H8F47VA2Z0sXATCF.jpg
939406	nm0301842	Elan Gale	2	1983-10-27 00:00:00	\N		USA	/An6kvqA5gkQnNO9aOqxSiY4U54w.jpg
1827845	\N	Kyle Mclean	0	\N	\N		\N	\N
3061301	nm9757312	Joe Daru	2	\N	\N		\N	\N
1635223	nm6724964	Diego Ward	2	\N	\N		\N	\N
1768007	\N	Renae Moneymaker	1	\N	\N		\N	\N
4040048	\N	Alexis Hadesty	0	\N	\N		\N	\N
2510475	\N	Candi VandiZandi	0	\N	\N		\N	\N
3359669	\N	Grecia Balboa	0	\N	\N		\N	\N
3245755	nm4675742	Michelle Civile	1	\N	\N		\N	\N
51797	nm0277213	Nathan Fillion	2	1971-03-27 00:00:00	\N	Nathan Fillion (born March 27, 1971) is a Canadian-American actor. He played the leading roles of Captain Malcolm "Mal" Reynolds on Firefly and its film continuation Serenity, and Richard Castle on Castle. As of 2018, he was starring as John Nolan on The Rookie.\n\nFillion has acted in traditionally distributed films like Slither and Trucker, Internet-distributed films like Dr. Horrible's Sing-Along Blog, television soap operas, sitcoms and theater. His voice is also featured in animation and video games, such as Hal Jordan / Green Lantern in various DC Comics projects, the Bungie games Halo 3, Halo 3: ODST, Halo: Reach, Destiny and Destiny 2, along with the 343 Industries game Halo 5: Guardians, and Wonder Man in Marvel's Guardians of the Galaxy Vol. 2 (2017) and M.O.D.O.K. (2021).\n\nFillion first gained recognition for his work on One Life to Live in the contract role of Joey Buchanan, for which he was nominated for the Daytime Emmy Award for Outstanding Younger Actor in a Drama Series, as well as for his supporting role as Johnny Donnelly in the sitcom Two Guys and a Girl.	CAN	/6arEYF9gD9mqjwGXv1QfqmLw445.jpg
967944	nm1770421	Darla Delgado	1	1969-01-21 00:00:00	\N		USA	/5BZyQGMxVQ0DIwjsZuvB6YWCQdh.jpg
1290604	nm4973032	Jonathan Fritschi	0	\N	\N		\N	/fUUlHNQLQinFlHZN3q0OAnNyrzH.jpg
1356013	nm1177880	Benjamin Byron Davis	2	1972-06-21 00:00:00	\N	Benjamin Byron Davis (born June 21, 1972) is an American actor, writer, director and acting coach. He is known for his performance as Dutch van der Linde in the video games Red Dead Redemption and Red Dead Redemption 2.\n\nFrom Wikipedia, the free encyclopedia	USA	/5WHDh9l9Ylsbf5ZKt3nQ4FRweUi.jpg
1404452	nm4227751	Tiffany Smith	1	1982-11-29 00:00:00	\N	Tiffany Smith has appeared on The CW's Supernatural and Jane The Virgin, the McG FOX pilot Behind Enemy Lines, and the recent psychological thriller, House of Demons. She is also an On-Camera Host, Actress, Influencer and go-to Geek Gal. From cons and carpets to set visits and #setlife, Tiffany succeeds in various live and on-camera roles, in all realms of media. She has hosted network/cable TV shows and specials (AMC's Geeking Out, CW Fan Feast, G4's Attack of The Show!); digitally live-streamed premiere and award show red carpets (WB, CW, NBCU, Syfy/Syfy Wire, DCE, IGN, Oxygen, Disney, Netflix, E!, Focus Features, Marvel, Sony Pictures) and con/expo coverage (SDCC, NYCC, C2E2, WonderCon, E3); and multiple digital/new media series' (CW Fan Talk: The Flash, Collider Jedi Council, DC All Access, Syfy's Krypton Trivia Series, Fandango Movie3Some and Weekend Ticket, Screenvision, Nerdist, The Chive, Crafting Comics, AT&T U-Verse Buzz). She has also appeared as a film/TV expert and correspondent on Dr. Drew On Call, Michaela HLN, E!'s ATT Live 360 and HLN's The Daily Share, to name a few. Her collective social following of 150k+ and ability to reach millions across her platforms, has landed her branded digital and social media partnerships with Dairy Queen/Marvel, Warner Bros., Hershey's, Delta, Xbox, Cricket Wireless and Ford.	USA	/7kPvIwIEJ5WuoQgOnrxjngyl3Sp.jpg
1717376	nm3710906	Caleb Spillyards	2	\N	\N		\N	/5r7Q82C3g8CCIR2Eew6gc2oWSK2.jpg
1543993	\N	Jessica Fontaine	0	\N	\N		\N	\N
1504236	nm3537390	Bonnie Discepolo	1	\N	\N		\N	\N
4040065	\N	Grace Gunn	0	\N	\N		\N	\N
4040066	\N	Will Gunn	0	\N	\N		\N	\N
2518	nm0001344	Gregg Henry	2	1952-05-06 00:00:00	\N	From Wikipedia, the free encyclopedia.\n\nGregg Lee Henry (born May 6, 1952) is an American theatre, film and television character actor and rock, blues and country musician.	USA	/j17nuAFulrbYP34g4Qw8SZRDNUo.jpg
13922	nm0001293	Seth Green	2	1974-02-08 00:00:00	\N	Seth Benjamin Gesshel-Green (born February 8, 1974) is an American actor, comedian, voice actor, and television producer. He is well known for his role as Daniel "Oz" Osbourne in Buffy the Vampire Slayer, as well as Dr. Evil's son Scott in the Austin Powers series of comedy films and Mitch Miller in That '70s Show. He also voices the characters of Chris Griffin on Family Guy, Lieutenant Gibbs in Titan Maximum, Jeff "Joker" Moreau in the Mass Effect video game series, and is one of the creators and producers of the stop motion comedy series Robot Chicken, in which he also voices many characters. Green has appeared in many other movies, such as Rat Race, The Italian Job, Can't Hardly Wait, Without a Paddle, and as a child in the horror film Stephen King's It.\n\nDescription above from the Wikipedia article Seth Green, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/l4No5Eu6j0U80hCIkaSn17AOWrj.jpg
15218	nm0348181	James Gunn	2	1966-08-05 00:00:00	\N	James Francis Gunn Jr. (born August 5, 1966) is an American filmmaker, executive and actor. He began his career as a screenwriter in the mid-1990s, starting at Troma Entertainment with Tromeo and Juliet (1997). He then began working as a director, starting with the horror-comedy film Slither (2006), and moving to the superhero genre with Super (2010), Guardians of the Galaxy (2014), Guardians of the Galaxy Vol. 2 (2017), The Suicide Squad (2021), and Guardians of the Galaxy Vol. 3 (2023). In 2022, Warner Bros. Discovery hired Gunn to become co-chairman and co-CEO of DC Studios.\n\nHe also wrote and directed the web series James Gunn's PG Porn (2008–2009), the HBO Max original series Peacemaker (2022–present), and the Disney+ original special The Guardians of the Galaxy Holiday Special (2022). Other projects he is known for is writing for the 2004 remake of George A. Romero's Dawn of the Dead (1978), writing the live-action adaptation of Scooby Doo (2002), and its sequel Scooby-Doo 2: Monsters Unleashed (2004), writing and producing the horror-action film The Belko Experiment (2016), producing the superhero-horror film Brightburn (2019), and contributing to comedy-anthology film Movie 43 (2013) (directing the segment "Beezel") and the 2012 hack-and-slash video game Lollipop Chainsaw.\n\nDescription above from the Wikipedia article James Gunn, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/2kFzvqCGeYBrgbuuvvyGE75d9gM.jpg
167132	nm1620433	Karen Abercrombie	1	\N	\N		\N	/yDTPfrVXge69QZo8hc8GTDPnW9U.jpg
1391876	nm4412982	Adriana Leonard	0	\N	\N		\N	/5bGKWNYkYb2KgsrrIVElUZoKPKg.jpg
2885791	nm6597834	Robert Walker Jeffery	2	\N	\N	Robert Walker Jeffery is an actor and writer based in New York City. Robert will next be seen in the upcoming feature film Your Dying Eyes, directed by Onur Tukel (Catfight, Room 104). He recently landed a supporting role in the Netflix original series Bonding. Robert wrote and stars in the independent half-hour TV pilot Inpatient which premiered in competition at 2019 Seriesfest. Among his several theatre credits in NYC, he played leading roles in The Flea's Waiting for Giovanni and in Love Cures at The Players Theatre. He graduated from Yale College and received his MFA from Columbia University in May 2018.	\N	/eWuHBlE200sIki0QJQjdu98aUsJ.jpg
2158768	nm7148976	Jimmy Walker	2	\N	\N		\N	/2YZA7E7aIf8EjyZ6PUIk67U2glW.jpg
202930	nm1190376	Anthony Molinari	2	1974-05-09 00:00:00	\N	From Wikipedia, the free encyclopedia\n\nAnthony Molinari (born May 9, 1974) is an American actor, stunt performer and stunt coordinator. He played Neary in The Fighter. Three-time Screen Actors Guild Award nominee.\n\nDescription above from the Wikipedia article Anthony Molinari, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/8Gl1b5Y7QLrdv5vvOwAmJk29joM.jpg
3063993	nm10661353	Elmi Rashid Elmi	2	\N	\N		\N	/kMH7mX7rzVrrPuWL0qVeYExXVcx.jpg
104635	nm0535019	Natalie Brown	1	1973-05-17 00:00:00	\N	​From Wikipedia, the free encyclopedia.  \n\nNatalie Brown (born May 17, 1973 ) is a Canadian actress who grew up in Timmins, Ontario. Brown landed her first print campaign for Bonne Bell when she was sixteen and went on to become the Heinz Ketchup girl. She modeled for Noxema and Max Factor. She studied fine arts at York University in Toronto. Brown played talent agent Sophie Parker on the television sitcom Sophie, which ran for two seasons, and grieving mother Carol Haplin on six of the eight episodes of the ABC series Happy Town. Her other credits include ReGenesis, Naked Josh, Mutant X, Zoe Busiek: Wild Card, Something Beneath, Dawn of the Dead, Welcome to Mooseport, How to Lose a Guy in 10 Days, MTV's Undressed, Tracker, Flashpoint, and the travel + escape channel's Living the Life. Natalie Brown is also known in Canada for her other work in television commercials, particularly those for Baileys Irish Cream, Salon Selectives, Canada Post, London Life, and Yoplait (2011)\n\nDescription above from the Wikipedia article Natalie Brown,  licensed under CC-BY-SA, full list of contributors on Wikipedia.	CAN	/2q0LPb7pTGAADUD2UJDtudCwPX5.jpg
690	nm0702841	Ke Huy Quan	2	1971-08-20 00:00:00	\N	Ke Huy Quan (born August 20, 1971), also known as Jonathan Ke Quan, is an American actor. As a young actor, Quan rose to fame playing Short Round in Indiana Jones and the Temple of Doom (1984) and Data in The Goonies (1985).\n\nFollowing a few roles in the 1990s, Quan took an almost 20-year acting hiatus during which he worked as a stunt choreographer and assistant director. He returned to acting with the science fiction film Everything Everywhere All at Once (2022). His performance was widely praised and won him many accolades, including an Academy Award, Critics Choice, Golden Globe, Independent Spirit, and SAG Award.	\N	/5PfYVcNLs1gGKIo0qwJrvyc2UOZ.jpg
1620	nm0000706	Michelle Yeoh	1	1962-08-06 00:00:00	\N	Michelle Yeoh Choo Kheng (born Yeoh Choo Kheng; 6 August 1962) is a Malaysian actress. Credited as Michelle Khan in her early films in Hong Kong, she rose to fame in the 1990s after starring in a series of Hong Kong action films where she performed her own stunts, such as Yes, Madam (1985), Magnificent Warriors (1987), Police Story 3: Supercop (1992), The Heroic Trio (1993), and Holy Weapon (1993).\n\nAfter moving to the United States, Yeoh gained recognition for starring in the James Bond film Tomorrow Never Dies (1997) and in Ang Lee's martial arts film Crouching Tiger, Hidden Dragon (2000), for which she was nominated for the BAFTA Award for Best Actress in a Leading Role. For her role as an overwhelmed mother navigating the multiverse in Everything Everywhere All at Once (2022) she won the Academy Award for Best Actress, becoming the first Asian woman to win the award.  Yeoh's other works include Memoirs of a Geisha (2005), Sunshine (2007), The Mummy: Tomb of the Dragon Emperor (2008), Reign of Assassins (2010), Kung Fu Panda 2 (2011), and The Lady (2011), where she portrayed Aung San Suu Kyi. She played supporting roles in the romantic comedies Crazy Rich Asians (2018) and Last Christmas (2019), and the Marvel Cinematic Universe film Shang-Chi and the Legend of the Ten Rings (2021). On television, Yeoh has starred in Star Trek: Discovery (2017–2020) and The Witcher: Blood Origin (2022).	MYS	/klATAW2KEfV2Glm5uhWAhJWt2ip.jpg
20904	nm0393222	James Hong	2	1929-02-22 00:00:00	\N	James Hong (born February 22, 1929) is a Chinese American actor and former president of the Association of Asian/Pacific American Artists (AAPAA). A prolific acting veteran, Hong's career spans over 50 years and includes more than 350 roles in film, television, and video games.	USA	/v3lfw5aHOy0paOCx6WHiSnwzbH0.jpg
1367122	nm0927706	Biff Wiff	2	\N	\N	Biff Wiff is an American film and television actor.	\N	/hfXXxpwugRUHX4sxEP7njAnYXTy.jpg
1381186	nm3513533	Stephanie Hsu	1	1990-11-25 00:00:00	\N	Stephanie Ann Hsu (born November 25, 1990) is an American actress. She originated the theatrical roles of Christine Canigula in Be More Chill and Karen the Computer in The SpongeBob Musical, performing in the Broadway runs of both. On screen, she had a recurring role in The Marvelous Mrs. Maisel (2019–present) before starring in the film Everything Everywhere All at Once (2022) as Joy Wang/Jobu Tupaki, for which she received a nomination for the Academy Award for Best Supporting Actress.	USA	/8gb3lfIHKQAGOQyeC4ynQPsCiHr.jpg
71580	nm1212722	Benedict Cumberbatch	2	1976-07-19 00:00:00	\N	Benedict Timothy Carlton Cumberbatch (born 19 July 1976) is an English actor. Known for his roles on the screen and stage, he has received various accolades throughout his career, including a Primetime Emmy Award, a British Academy Television Award, and a Laurence Olivier Award. Cumberbatch won the Laurence Olivier Award for Best Actor in a Leading Role in a Play for Frankenstein and a Primetime Emmy Award for Outstanding Lead Actor in a Miniseries or Movie for Sherlock. His performances in the dramas The Imitation Game (2014) and The Power of the Dog (2021) earned him nominations for an Academy Award, a BAFTA Award, a Screen Actors Guild Award, and a Golden Globe Award, all for Best Actor in a Leading Role. For playing the title role in five-part drama miniseries Patrick Melrose, he won a BAFTA TV Award for Best Actor in a Leading Role.\n\nIn 2014 Time magazine included him in its annual list of the 100 most influential people in the world, and in 2015 he was appointed a CBE by Queen Elizabeth II in the 2015 Birthday Honours for services to the performing arts and to charity. A graduate of the Victoria University of Manchester, Cumberbatch continued his training at the London Academy of Music and Dramatic Art, obtaining a Master of Arts in Classical Acting. He first performed at the Open Air Theatre, Regent's Park in Shakespearean productions and made his West End debut in Richard Eyre's revival of Hedda Gabler in 2005. Since then, he has starred in the Royal National Theatre productions After the Dance (2010) and Frankenstein (2011). In 2015, he played the title role in Hamlet at the Barbican Theatre.\n\nCumberbatch's television work includes his performance as Stephen Hawking in the television film Hawking in 2004. He gained worldwide recognition for his performance as Sherlock Holmes in the BBC series Sherlock from 2010 to 2017. He has also headlined Tom Stoppard's adaptation of Parade's End (2012), The Hollow Crown: The Wars of the Roses (2016), Patrick Melrose (2018), and Brexit: The Uncivil War (2019). In films, Cumberbatch has starred in Amazing Grace (2006) as William Pitt the Younger, Star Trek Into Darkness (2013) as Khan, 12 Years a Slave (2013) as William Prince Ford, The Fifth Estate (2013) as Julian Assange, and The Imitation Game (2014) as Alan Turing. He also acted in the historical dramas The Current War (2017), 1917 (2019) and The Courier (2020), and received critical acclaim for his performance in Jane Campion's Western drama The Power of the Dog (2021). From 2012 to 2014, through voice and motion capture, he played the characters of Smaug and Sauron in The Hobbit film series. Cumberbatch portrays Dr. Stephen Strange in the Marvel Cinematic Universe films, beginning with Doctor Strange (2016), and also voiced the character in the animated series What If...? (2021).	GBR	/fBEucxECxGLKVHBznO0qHtCGiMO.jpg
205	nm0000379	Kirsten Dunst	1	1982-04-30 00:00:00	\N	Kirsten Caroline Dunst (born April 30, 1982) is an American actress. She has received various accolades, including a Cannes Film Festival Award for Best Actress, in addition to nominations for an Academy Award, a Primetime Emmy Award, and four Golden Globe Awards. She made her acting debut in the short Oedipus Wrecks directed by Woody Allen in the anthology film New York Stories (1989). She then gained recognition for her role as child vampiress Claudia in the horror film Interview with the Vampire (1994), which earned her a Golden Globe nomination for Best Supporting Actress. She also had roles in her youth in Little Women (1994) and the fantasy films Jumanji (1995) and Small Soldiers (1998).\n\nIn the late 1990s, Dunst transitioned to leading roles in a number of teen films, including the political satire Dick (1999) and the Sofia Coppola-directed drama The Virgin Suicides (1999). In 2000, she starred in the lead role in the cheerleading film Bring It On, which has become a cult classic. She gained further wide attention for her role as Mary Jane Watson in Sam Raimi's Spider-Man (2002) and its sequels Spider-Man 2 (2004) and Spider-Man 3 (2007). Her career progressed with a supporting role in Eternal Sunshine of the Spotless Mind (2004), followed by a lead role in Cameron Crowe's tragicomedy Elizabethtown (2005), and as the title character in Coppola's Marie Antoinette (2006).\n\nIn 2011, Dunst starred as a depressed newlywed in Lars von Trier's science fiction drama Melancholia, which earned her the Cannes Film Festival Award for Best Actress. In 2015, she played Peggy Blumquist in the second season of the FX series Fargo, which earned Dunst a Primetime Emmy Award nomination. She then had a supporting role in the film Hidden Figures (2016) and leading roles in The Beguiled (2017), and the black comedy series On Becoming a God in Central Florida (2019), for which she received a third Golden Globe nomination. She earned nominations for her fourth Golden Globe and first Academy Award nomination for her performance in the psychological drama The Power of the Dog (2021).	USA	/6RAAxI4oPnDMzXpXWgkkzSgnIAJ.jpg
4728	nm0152430	Kevin Chapman	2	1962-07-29 00:00:00	\N	Kevin Chapman is an American actor known for his big build and ability to play an assortment of characters ranging from the obnoxious brother, Terrence in FX's Rescue Me to street enforcer Val Savage in Clint Eastwood's critically acclaimed film, Mystic River.\n\nChapman was discovered by the late director Ted Demme and was casted as Mickey Pat in Monument Ave. (1998). Other notable film roles of his include The Cider House Rules, 21 Grams, In Good Company, an Italian mobster in Boondock Saints (1999), Val Savage in Mystic River (2003), and Fire Lt. Frank McKinney in Ladder 49 (2004). Chapman starred as Irish Mob boss, Freddie Cork, for three seasons in the Showtime original series Brotherhood. Chapman plays CIA operative O'Leary in the independent comedy, Black Dynamite. In 2010, Chapman played Bunny in the Tony Scott action film Unstoppable, starring Denzel Washington and Chris Pine. He is attached to J.J. Abrams' Person of Interest.\n\nDescription above from the Wikipedia article Kevin Chapman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/sCUwtlhaT2MspHCUx2veRAA9ZXx.jpg
88124	nm0687146	Jesse Plemons	2	1988-04-02 00:00:00	\N	Jesse Plemons (born April 2, 1988) is an American actor. He began his career as a child actor and achieved a career breakthrough with his major role as Landry Clarke in the NBC drama series Friday Night Lights (2006–2011). He subsequently portrayed Todd Alquist in season 5 of the AMC crime drama series Breaking Bad (2012–2013) and its sequel film El Camino: A Breaking Bad Movie (2019). For his role as Ed Blumquist in season 2 of the FX anthology series Fargo (2015), he received his first Primetime Emmy Award nomination and won a Critics' Choice Television Award. He received a second Emmy nomination for his portrayal of Robert Daly in "USS Callister", an episode of the Netflix anthology series Black Mirror (2017).\n\nPlemons has appeared in supporting roles in several films including The Master (2012), The Homesman (2014), Black Mass, Bridge of Spies (both 2015), Game Night, Vice (both 2018), The Irishman (2019), Judas and the Black Messiah, Jungle Cruise, and The Power of the Dog (all in 2021). He starred in the psychological thriller film I'm Thinking of Ending Things (2020). He was nominated for the Independent Spirit Award for Best Male Lead for his role as David Mulcahey in Other People (2016). For his performance in The Power of the Dog, he was nominated for a BAFTA Award for Best Actor in a Supporting Role and the Academy Award for Best Supporting Actor.\n\nDescription above from the Wikipedia article Jesse Plemons, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/nx5BJs7anBcuZiqvXC9nInMwMSM.jpg
1356758	nm5057169	Thomasin McKenzie	1	2000-07-26 00:00:00	\N	Thomasin Harcourt McKenzie (born 26 July 2000) is an actress from New Zealand. After a minor role in The Hobbit: The Battle of Five Armies, she rose to critical prominece with the lead role in Debra Granik's 2018 drama film Leave No Trace. After supporting roles in the 2019 films The King, Jojo Rabbit and True History of the Kelly Gang, as well as the 2021 thriller Old, Edgar Wright's psychological horror film Last Night in Soho established her as one of the industry's lead actresses.	NZL	/of8zI5FA5cNBbZK8KdgTSw0znXK.jpg
10760	nm0501501	Geneviève Lemon	1	1958-04-21 00:00:00	\N	​From Wikipedia, the free encyclopedia.  \n\nGenevieve Lemon is an Australian actress who has appeared in a number of soap operas – as Zelda Baker in The Young Doctors, Marlene "Rabbit" Warren in Prisoner and Brenda Riley in Neighbours. She showed her comedic and singing talents in the televised revue show Three Men and a Baby Grand.\n\nLemon has also appeared in a number of films directed by Jane Campion – Sweetie, The Piano and Holy Smoke. She played in the stage production "Priscilla, Queen of the Desert – the Musical" as the barmaid and owner of the Broken Hill Hotel, Shirley. Her first CD, with her band, is called "Angels in the City". It is a live recording of a concert she performed in the Studio at the Sydney Opera House as part of the Singing around the House series.\n\nGenevieve Lemon is currently on stage at London's Victoria Palace Theatre, portraying Mrs Wilkinson in Billy Elliot the Musical, a role she performed firstly in Sydney then Melbourne. On 21 January 2008 she won the Best Actress in a Musical award at the 2007 Sydney Theatre Awards. Lemon won a 2008 Helpmann Award for Best Actress in a Musical for her role in Billy Elliot the Musical. Lemon has worked extensively for a number of major state theatre companies in Australia.\n\nLemon began her career with the Leichhardt-based amateur theater company, The Rocks Players.\n\nDescription above from the Wikipedia article Genevieve Lemon, licensed under CC-BY-SA, full list of contributors on Wikipedia.	AUS	/k93Xs9K7eX06FKIePWD05eDuqBD.jpg
4432	nm0175814	Frances Conroy	1	1953-03-15 00:00:00	\N	Frances Conroy (born November 13, 1953) is an American actress. She is most widely known for playing the matriarch Ruth O'Connor Fisher Sibley on the HBO funeral drama series Six Feet Under, which earned her a Golden Globe in 2004.\n\nDescription above from the Wikipedia article Frances Conroy, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/aJRQAkO24L6bH8qkkE5Iv1nA3gf.jpg
962109	nm2407067	Sean Keenan	2	1993-01-18 00:00:00	\N	Sean Keenan was born on January 18, 1993 in Australia. He is an actor, known for Lockie Leonard (2007), Wake in Fright (2017) and Glitch (2015).	\N	/w6zfDPiprbzI5fYavP4ZreMnBU1.jpg
1399811	nm2277047	George Mason	2	\N	\N		\N	/fLUXBgeSwXFG5GRveROIniYXIpk.jpg
3233123	nm9078712	Ramontay McConnell	0	\N	\N		\N	\N
939388	nm1959207	Cohen Holloway	2	\N	\N		\N	/7qWqBZk4arFgx7TJpi7uXe6eH2z.jpg
3233124	nm12858638	Max Mata	0	\N	\N		\N	\N
3232669	nm11879379	Jude Hill	2	2010-01-01 00:00:00	\N		\N	/hKPl5S2ROF9wW3Bu4QNgn9TIEbz.jpg
147056	nm1495520	Caitríona Balfe	1	1979-10-04 00:00:00	\N	Caitríona Mary Balfe (/kəˈtriːnə ˈbælf/; born 4 October 1979) is an Irish actress, producer, and former fashion model. She is best known for her starring role as Claire Fraser in the Starz historical drama series Outlander, for which she received a British Academy Scotland Award, an Irish Film and Television Award, two People's Choice Awards, and three Saturn Awards. She also earned nominations for two Critics' Choice Television Awards and four Golden Globe Awards for Best Actress in a Television Series – Drama.\n\nAt age eighteen, while studying Drama at the Dublin Institute of Technology, Balfe was offered work as a fashion model in Paris. She was featured both in advertising campaigns and on runways for such brands as Chanel, Dolce & Gabbana, Roberto Cavalli, Alexander McQueen, Balenciaga, Givenchy, Marc Jacobs, Bottega Veneta, Oscar de la Renta and many others over ten years before refocusing on acting. She had leading roles in the web series The Beauty Inside (2012) and H+: The Digital Series (2012–2013), and appeared in the films Super 8 (2011), Now You See Me (2013), Escape Plan (2013), Money Monster (2016), Ford v Ferrari (2019), and Belfast (2021).\n\nDescription above from the Wikipedia article Caitríona Balfe, licensed under CC-BY-SA, full list of contributors on Wikipedia.	IRL	/4KQRDj74lKwU52Ewmzz7sVIakgn.jpg
1254583	nm1946193	Jamie Dornan	2	1982-05-01 00:00:00	\N	James Dornan (born 1 May 1982) is an Irish actor, model, and musician. He played Axel von Fersen in Sofia Coppola's film Marie Antoinette (2006), Sheriff Graham Humbert in the ABC series Once Upon a Time, serial killer Paul Spector in the BBC Two and RTÉ One crime drama series The Fall, and Christian Grey in the Fifty Shades franchise (2015-2018).\n\nDescription above from the Wikipedia article Jamie Dornan licensed under CC-BY-SA, full list of contributors on Wikipedia.	\N	/qmTiAm3LII5moykSriVkJCeysKC.jpg
935624	nm0278468	John Fiore	2	\N	\N		\N	/4yslMrAqVg1nTtVsNj3x2DMQ24g.jpg
188049	nm0267772	Lonnie Farmer	2	\N	\N	Lonnie Farmer is known for Black Mass (2015), The Cider House Rules (1999) and The Judge (2014).	\N	/sXubJWHxeQ9TKptKKzSpUA3OJ4f.jpg
1974354	nm2972597	Courtland Jones	1	1984-07-13 00:00:00	\N		USA	/eoGmGe77mgZRfAAMrD3GMlznWpE.jpg
2559002	nm3008060	Ayana Brown	1	\N	\N		\N	/1A0ftNUy2TyRidIlRwcX8zXAeXW.jpg
2357138	nm1655232	Jason Pugatch	2	\N	\N		\N	\N
3204232	nm9809074	Kyana Fanene	1	\N	\N		\N	/rgTJIp5vP2VzUUSSOhIGAumrnjm.jpg
5309	nm0001132	Judi Dench	1	1934-12-09 00:00:00	\N	Dame Judith Olivia "Judi" Dench, CH, DBE, FRSA (born 9 December 1934) is an English film, stage and television actress.\n\nDench made her professional debut in 1957 with the Old Vic Company. Over the following few years she played in several of William Shakespeare's plays in such roles as Ophelia in Hamlet, Juliet in Romeo and Juliet and Lady Macbeth in Macbeth. She branched into film work, and won a BAFTA Award as Most Promising Newcomer; however, most of her work during this period was in theatre. Not generally known as a singer, she drew strong reviews for her leading role in the musical Cabaret in 1968.\n\nDuring the next two decades, she established herself as one of the most significant British theatre performers, working for the National Theatre Company and the Royal Shakespeare Company. In television, she achieved success during this period, in the series A Fine Romance from 1981 until 1984 and in 1992 began a continuing role in the television romantic comedy series As Time Goes By.\n\nHer film appearances were infrequent until she was cast as M in GoldenEye (1995), a role she played in each James Bond film until Skyfall (2012). She received several notable film awards for her role as Queen Victoria in Mrs. Brown (1997), and has since been acclaimed for her work in such films as Shakespeare in Love (1998), Chocolat (2000), Iris (2001), Mrs Henderson Presents (2005) and Notes on a Scandal (2006), and the television production The Last of the Blonde Bombshells (2001).\n\nRegarded by critics as one of the greatest actresses of the post-war period, and frequently named as the leading British actress in polls, Dench has received many award nominations for her acting in theatre, film and television; her awards include ten BAFTAs, seven Laurence Olivier Awards, two Screen Actors Guild Awards, two Golden Globes, an Academy Award, and a Tony Award.\n\nShe was married to actor Michael Williams from 1971 until his death in 2001. They are the parents of actress Finty Williams.	\N	/cpna5VGvAxuKuC31xJPBKy9zbnv.jpg
8785	nm0001354	Ciarán Hinds	2	1953-02-09 00:00:00	\N	From Wikipedia, the free encyclopedia\n\nCiarán Hinds (born 9 February 1953) is an Irish actor. A versatile character actor, he has appeared in feature films such as The Sum of All Fears, Road to Perdition, Munich, There Will Be Blood, Harry Potter and the Deathly Hallows – Part 2, Tinker Tailor Soldier Spy, Frozen, Silence, Red Sparrow, Justice League, First Man, and Frozen II.\n\nHis television roles include Gaius Julius Caesar in the series Rome, DCI James Langton in Above Suspicion, and Mance Rayder in Game of Thrones. As a stage actor Hinds has enjoyed spells with the Royal Shakespeare Company, the Royal National Theatre in London, and six seasons with Glasgow Citizens' Theatre, and he has continued to work on stage throughout his career.	GBR	/d8wLIX9VYgwXRGSp1gmUdUxmApv.jpg
228866	nm2959880	Colin Morgan	2	1986-01-01 00:00:00	\N	Colin Morgan is a British stage, film and television actor from Northern Ireland, best known for playing the title role in the BBC television series "Merlin." He's a graduate from the Royal Scottish Academy of Music and Drama, Glasgow, Scotland, UK.	GBR	/jeSLhhfUIZR3UQGGhtYTk0J2I5.jpg
1726976	nm7107447	Lara McDonnell	1	2003-11-07 00:00:00	\N	Lara McDonnell is an Irish actress. She starred as the alternating titular role in the West End production of Matilda the Musical from 2015 to 2016. She has since landed roles in a number of films. McDonnell appeared on the 2021 Irish Independent list of actors to go stellar. Wikipedia	IRL	/qm5WAiX5YU6KoWMn5Ts4vW8eddo.jpg
1709739	nm0907905	Josie Walker	1	\N	\N		\N	/tnCtnm6eOAVQ5JXXltG40ZwYAPO.jpg
2893134	nm11888100	Olive Tennant	1	2011-03-29 00:00:00	\N	Olive is the oldest daughter of David and Georgia Tennant	GBR	/1QuQFEAd5VM7E5ZFmEPFHqBcRYV.jpg
17483	nm0540585	Michael Maloney	2	1957-06-19 00:00:00	\N		GBR	/sE5K1f3TW1foDTT6yrGaeW4grun.jpg
1474032	nm6100857	Turlough Convery	2	\N	\N	Turlough Convery is an Irish actor. Convery grew up in Northern Ireland and attended Rockport School, and Our Lady and St Patrick’s college, Knockwhere he received a number of prizes for Drama.	IRL	/comNqH43CXrweE6L5kpuyRLHLi9.jpg
82149	nm2736817	Conor MacNeill	2	1988-07-04 00:00:00	\N		IRL	/j8bZwSKUe8ZkmO9RJiLC3zD1aPl.jpg
2163883	\N	Chris McCurry	2	\N	\N		\N	/vgpu3Kuw7WzELTBMmLhyVoUHocz.jpg
1331023	nm4454223	Emilia Jones	1	2002-02-23 00:00:00	\N	Emilia Jones (born 23 February 2002) is an English actress, singer, and songwriter. She is best known for playing the lead role in the Academy Award-winning 2021 film CODA as Ruby Rossi, for which she received several accolades for her performance, including a BAFTA Award nomination for Best Actress in a Leading Role.\n\nJones is also known for playing Kinsey Locke in the Netflix series Locke & Key (2020–present), while also having additional early roles in television, such as Doctor Who (2013) and Utopia (2013–2014), and lead roles in films like Brimstone (2016), Ghostland (2018), and Horrible Histories (2019). She also performed in several theatrical productions in the West End in London.\n\nDescription above from the Wikipedia article Emilia Jones, licensed under CC-BY-SA, full list of contributors on Wikipedia.	GBR	/vQHfiR6bSKf7bJcYyDvfUSXlB9Q.jpg
19797	nm0559144	Marlee Matlin	1	1965-08-24 00:00:00	\N	Marlee Bethany Matlin (born August 24, 1965) is an American actress. She is the youngest woman and the only deaf actress to date to win the Academy Award for Best Actress in a Leading Role, which she won at age 21 for Children of a Lesser God.  Her work in film and television has resulted in a Golden Globe award, with two additional nominations, and four Emmy nominations. Deaf since she was 2 years old, she is also a prominent member of the National Association of the Deaf.	USA	/1iV3yA07kdj7RFj2yyzwO2T6M8o.jpg
1571661	nm1319274	Troy Kotsur	2	1968-07-24 00:00:00	\N	Troy Kotsur has been acting and directing for over 20 years. Deaf since birth, he was raised in Mesa, AZ. In his career he has had critically acclaimed performances in major films, a lead role in the Broadway run of a Tony Award-winning play, and numerous memorable roles on Television.\n\nTroy has garnered rave reviews for his leading role in the 2021 feature CODA, which was awarded Best Ensemble Cast at Sundance. He is credited with being one of the prime reasons for the feature's festival success, which lead to its $25 million sale to Apple. Previous to this, Troy had a supporting role in The Number 23 starring Jim Carrey, and in subsequent years became known for stand-out performances in indie features.\n\nIn television, Troy made headlines in 2019 for his acting role in The Mandalorian on Disney+ because along with acting, he choreographed an adapted form of sign language for the series. Other notable television roles include guest star appearances on Criminal Minds, Scrubs, CSI: NY, and a fan-favorite recurring character on PAX's Sue Thomas: FB-Eye.\n\nMuch of Troy's success has stemmed from his highly respected career on stage. This includes a role in the Tony Award-winning run of Big River on Broadway, performing at the Mark Taper Forum, and the 2015 LA Drama Critics Circle Award nominee Spring Awakening.	\N	/24K3og12jGBGL9dqH5OYFdjF9wu.jpg
239574	nm0220240	Eugenio Derbez	2	1962-09-02 00:00:00	\N	Actor, writer, director and producer, Eugenio has a degree in Film Directing from the Mexican Institute of Cinematography and Theater, as well as a degree in Acting from Televisa's Acting School. He has also studied and is trained in the arts of Dance, Music and Singing, and still today he continues prepping himself in L.A. and in New York City. His latest feature film "Instructions Not Included" became the most successful Spanish-language film ever in the US and worldwide, and broke numerous box office records everywhere, earning over $100M. Variety recently recognized him as the "#1 most influential Hispanic male in the world".	MEX	/6o1w3mYF947N6TTakQXcs3NNy4w.jpg
933238	nm0272581	Rebecca Ferguson	1	1983-10-19 00:00:00	\N	Rebecca Louisa Ferguson Sundström (born 19 October 1983) is a Swedish actress. She began her acting career with the Swedish soap opera Nya tider (1999–2000) and went on to star in the slasher film Drowning Ghost (2004). She came to international prominence with her portrayal of Elizabeth Woodville in the British television miniseries The White Queen (2013), for which she was nominated for a Golden Globe for Best Actress in a Miniseries or Television Film.\n\nFerguson starred as MI6 agent Ilsa Faust in the action spy film Mission: Impossible – Rogue Nation (2015) and its sequel Mission: Impossible – Fallout (2018). She also played Jenny Lind in the musical film The Greatest Showman (2017) and acted in science fiction horror film Life (2017), starred in the horror film Doctor Sleep (2019), and had supporting parts in the comedy-drama Florence Foster Jenkins (2016), the mystery thriller The Girl on the Train (2016), and the science fiction film Men in Black: International (2019). She portrayed Lady Jessica in the sci-fi epic Dune (2021).	SWE	/6NRlV9oUipeak7r00V6k73Jb7we.jpg
25072	nm1209966	Oscar Isaac	2	1979-03-09 00:00:00	\N	Óscar Isaac Hernández Estrada (born March 9, 1979) is an American actor. After making his acting debut in the late 1990s, he studied acting at the Juilliard School and played small roles for a majority of the 2000s. For portraying José Ramos-Horta in the Australian film Balibo (2006), Isaac won the AACTA Award for Best Actor in a Supporting Role. Following supporting roles in major films such as Body of Lies (2008), Robin Hood (2010) and Drive (2011), Isaac had his breakthrough with the starring role of a singer in the Coen brothers' black comedy Inside Llewyn Davis (2013), earning a nomination for a Golden Globe Award.\n\nIsaac's career progressed with leading roles in the crime drama A Most Violent Year (2014), the thriller Ex Machina (2015), and the superhero film X-Men: Apocalypse (2016). He became a global star with his starring role as Poe Dameron in the Star Wars sequel trilogy (2015–2019). He has since starred in the science fiction films Annihilation (2018) and Dune (2021), and the crime drama The Card Counter (2021).\n\nOn television, Isaac has starred in the HBO miniseries Show Me a Hero (2015) and Scenes from a Marriage (2021), winning the Golden Globe Award for Best Actor – Miniseries or Television Film for portraying Nick Wasicsko in the former. In 2022, he began starring as the Marvel Cinematic Universe character Moon Knight in the Disney+ series Moon Knight (2022).\n\nDescription above from the Wikipedia article Oscar Isaac, licensed under CC-BY-SA, full list of contributors on Wikipedia.	GTM	/dW5U5yrIIPmMjRThR9KT2xH6nTz.jpg
16851	nm0000982	Josh Brolin	2	1968-02-12 00:00:00	\N	Joshua James Brolin (born February 12, 1968) is an American actor. He has appeared in films such as The Goonies (1985), Mimic (1997), Hollow Man (2000), Grindhouse (2007), No Country for Old Men (2007), American Gangster (2007), W. (2008), Milk (2008), True Grit (2010), and Men in Black 3 (2012). He has also appeared in films such as Oldboy (2013), Inherent Vice (2014), Everest (2015), Sicario (2015), Hail, Caesar! (2016), and Deadpool 2 (2018).\n\nIn the MCU, he appeared as Thanos in Guardians of the Galaxy (2014), Avengers: Age of Ultron (2015) and later starring in Avengers: Infinity War (2018) and Avengers: Endgame (2019). In 2021, he returned to provide the voice for an alternate timeline version of Thanos in the animated series What If...? and portrayed Gurney Halleck in Denis Villeneuve's sci-fi epic Dune (2021) and in the upcoming sequel in 2023. In 2022, he starred in the supernatural mystery series Outer Range.	USA	/sX2etBbIkxRaCsATyw5ZpOVMPTD.jpg
1640	nm0001745	Stellan Skarsgård	2	1951-06-13 00:00:00	\N	Stellan Skarsgård is a Swedish actor, known internationally for his film roles in Angels & Demons, Breaking the Waves, The Hunt for Red October, Ronin, Good Will Hunting, Pirates of the Caribbean: Dead Man's Chest, Pirates of the Caribbean: At World's End, Dominion: Prequel to the Exorcist, Mamma Mia! and Mamma Mia! Here We Go Again. He also portrays Dr. Erik Selvig in the Marvel Cinematic Universe. He has appeared as the character in Thor (2011), The Avengers (2012), Thor: The Dark World (2013), and Avengers: Age of Ultron (2015) and Thor: Love and Thunder (2022).	SWE	/x78BtYHElirO7Iw8bL4m8CnzRDc.jpg
543530	nm1176985	Dave Bautista	2	1969-01-18 00:00:00	\N	David Michael Bautista Jr. (born January 18, 1969) is an American actor and retired professional wrestler. He had several stints in WWE between 2002 and 2019. In his acting career, he is most widely known for his portrayal of Drax the Destroyer in the Marvel Cinematic Universe since Guardians of the Galaxy (2014).\n\nBautista began his wrestling career in 1999, and in 2000 signed with the then-World Wrestling Federation (WWF, renamed WWE in 2002). From 2002 to 2010, he gained fame under the ring name Batista and became a six-time world champion by winning the World Heavyweight Championship four times and the WWE Championship twice. His first reign with the World Heavyweight Championship is the longest reign for that title at 282 days. He has also held the World Tag Team Championship three times (twice with Ric Flair and once with John Cena) and the WWE Tag Team Championship once (with Rey Mysterio). He was the winner of the 2005 Royal Rumble match and went on to headline WrestleMania 21, one of the top five highest-grossing pay-per-view events in professional wrestling history. After leaving WWE in 2010, he re-signed in December 2013, making his first appearance back in January 2014 and won that year's Royal Rumble match. He headlined WrestleMania XXX before again departing that June. In October 2018, Bautista made his second return to WWE and faced Triple H at WrestleMania 35 in April 2019, before retiring from wrestling. Altogether Bautista won a total of eleven championships throughout his wrestling career.\n\nBautista began acting in 2006 and has starred in The Man with the Iron Fists (2012), Riddick (2013), the James Bond film Spectre (2015), Blade Runner 2049 (2017), Army of the Dead (2021), and Dune (2021). He has also appeared in several direct-to-video films since 2009.\n\nIn August 2012, Bautista signed a contract with Classic Entertainment & Sports to fight in mixed martial arts (MMA). He won his lone MMA fight on October 6, 2012, defeating Vince Lucero via technical knockout in the first round.	USA	/snk6JiXOOoRjPtHU5VMoy6qbd32.jpg
195666	nm1004267	Sharon Duncan-Brewster	1	1976-02-08 00:00:00	\N	Sharon Duncan-Brewster (born 8 February 1976) is a British actress. She is known for her role as Crystal Gordon in Bad Girls during the first four series; her role as Trina Johnson on EastEnders; and her role as Maggie Cain in the autumn 2009 Doctor Who special, The Waters of Mars. More recently, she has played Imperial Planetologist Dr. Liet-Kynes in Denis Villeneuve's adaptation of Frank Herbert's Dune.	GBR	/gp5h6rOrqBrIGgID4AMd58O6Ow6.jpg
32597	nm0001518	Dylan McDermott	2	1961-10-26 00:00:00	\N	Dylan McDermott (born Mark Anthony McDermott; October 26, 1961) is an American actor. He is known for his role as lawyer and law firm head Bobby Donnell on the legal drama series The Practice, which earned him a Golden Globe Award for Best Performance by an Actor in a Television Series – Drama and a nomination for the Primetime Emmy Award for Outstanding Lead Actor in a Drama Series.\n\nMcDermott is also known for his roles in four seasons (first, second, eighth and ninth) of the FX horror anthology series American Horror Story, subtitled Murder House, Asylum, Apocalypse, and 1984 portraying Ben Harmon, Johnny Morgan and Bruce, respectively. He also starred as narcotics crime lord Richard Wheatley on the Law & Order: Special Victims Unit spinoff Law & Order: Organized Crime; Lt. Carter Shaw on the TNT series Dark Blue; in two short-lived CBS dramas, Hostages and Stalker; and in the 1994 remake of the film Miracle on 34th Street. In 2022, he joined FBI: Most Wanted as the new lead, replacing the departing Julian McMahon.\n\nDescription above from the Wikipedia article Dylan McDermott, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/3i69RNLuL7KOD9pCmHQYruhcOdn.jpg
2451805	nm8118575	Kayden Alexander Koshelev	2	\N	\N		\N	/ynx2cgVA1BefCGmRTw5k1coh08X.jpg
196179	nm0376610	Stephen McKinley Henderson	2	1949-08-31 00:00:00	\N	Henderson is known mostly for his stage work. He won the 2015 Obie Award for Best Actor for his starring role of Walter "Pops" Washington in the Atlantic Theatre Company and Second Stage productions of the Pulitzer Prize-winning play Between Riverside and Crazy. He portrayed Jim Bono in the Broadway revival of August Wilson's Fences, starring Denzel Washington, for which Henderson received a Tony Award nomination as a supporting actor, as well as the Richard Seff Award from Actor's Equity; he reprised the role in Washington's 2016 film adaptation. Also in 2016, Henderson appeared in Kenneth Lonergan's Manchester by the Sea, starring Casey Affleck and Michelle Williams, playing the boss of Affleck's character. Previously, he appeared as Van Helsing in the Broadway production of Dracula, the Musical. More recently, he played the role of Father Leviatch in Greta Gerwig's 2017 film Lady Bird. On Broadway, he has performed in Drowning Crow, the revival of Ma Rainey's Black Bottom, and the premiere of King Hedley II. Henderson is recognized as a veteran performer of August Wilson's oeuvre.\n\nHis signature August Wilson role is the gossipy Turnbo in Jitney for which he won a Drama Desk Award. He had created the role in the 1996 premiere at the Pittsburgh Public Theater, then honed it (as Wilson was honing the script) in other regional theatres before its arrival Off-Broadway in 2000. Though they did not transfer to Broadway, he and the core of the cast took Jitney to London where it won the 2002 Olivier Award for the best new play. In addition, he appeared in A Raisin in the Sun and directed Zooman and the Sign. With the LAByrinth Theatre Company, he portrayed Pontius Pilate in The Last Days of Judas Iscariot.\n\nHis films include his role as Arthur in Everyday People, White House servant William Slade in Steven Spielberg's film Lincoln (2012), Lester in the film Tower Heist (2011), Bobo in A Raisin in the Sun (1989), Cooper's husband in the TV movie Marie (1985), and roles in the films Keane (2004), If You Could Say It in Words (2008) and Lady Bird (2017). In addition to his films, Henderson was a series regular on the FOX series New Amsterdam, which premiered in early 2018.\n\nTelevision work includes Law & Order, Law & Order: Special Victims Unit, The Newsroom, Law & Order: Criminal Intent, Tyler Perry's House of Payne, Third Watch, New Amsterdam, Blue Bloods and Devs.	USA	/utsApLREJWm13jyCLMkFwPYYU0M.jpg
1622	nm0151654	Chang Chen	2	1976-10-14 00:00:00	\N	Chang Chen (Chinese: 張震; born October 14, 1976) is a Taiwanese actor, born in Taipei, Taiwan. His name is sometimes seen in the Western order (Chen Chang). He is the son of a Taiwanese actor Chang Kuo Chu and brother of a Taiwanese actor, Chang Ha	TWN	/4BOQ5pJXdsArkMHvyVhrV8Ditnr.jpg
44079	nm0001648	Charlotte Rampling	1	1946-02-05 00:00:00	\N	Tessa Charlotte Rampling OBE (born 5 February 1946) is an English actress, model and singer, known for her work in European arthouse films in English, French, and Italian. An icon of the Swinging Sixties, she began her career as a model and later became a fashion icon and muse.	GBR	/7fhg5FCcl0VfYERP5D0unpybqgx.jpg
117642	nm0597388	Jason Momoa	2	1979-08-01 00:00:00	\N	Joseph Jason Namakaeha Momoa (born August 1, 1979) is an American actor and filmmaker. He made his acting debut as Jason Ioane on the syndicated action drama series Baywatch: Hawaii (1999–2001), which was followed by his portrayal of Ronon Dex on the Syfy science fiction series Stargate Atlantis (2005–2009), Khal Drogo in the first two seasons of the HBO fantasy drama series Game of Thrones (2011–2012), Declan Harp on the Discovery Channel historical drama series Frontier (2016–2018), and Baba Voss on the Apple TV+ science fiction series See (2019–present). Momoa was featured as the lead of the two lattermost series.\n\nSince 2016, Momoa portrays Arthur Curry / Aquaman in the DC Extended Universe (DCEU), headlining the eponymous 2018 film and its 2023 sequel. Momoa also played Duncan Idaho in the 2021 film adaptation of the science fiction novel Dune.\n\nDescription above from the Wikipedia article Jason Momoa, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/tsfL6u1WW6zHYS1lhWGPHuk6JON.jpg
3810	nm0000849	Javier Bardem	2	1969-03-01 00:00:00	\N	Javier Ángel Encinas Bardem is a Spanish actor from the Canary Islands. He is best known for his role in the 2007 film No Country for Old Men, for which he won the Academy Award for Best Supporting Actor portraying the psychopathic assassin Anton Chigurh. He has also received critical acclaim for roles in films such as Jamón, jamón, Carne trémula, Boca a boca, Los Lunes al sol, Mar adentro, and Skyfall, for which he received both a BAFTA and a SAG nomination for Best Supporting Actor.\n\nBardem has also won a Screen Actors Guild Award, a BAFTA, five Goya Awards, two European Film Awards, a Prize for Best Actor at Cannes and two Volpi Cups at Venice for his work. He is the first Spaniard actor to be nominated for an Oscar (Best Actor, 2000, for Before Night Falls), as well as the first Spanish actor to win an Academy Award. He received his third Academy Award nomination, and second Best Actor nomination, for the film Biutiful.	ESP	/gJTtH22fk7nAi45f7BN2P7DjvuE.jpg
83854	nm2810287	David Dastmalchian	2	1977-07-21 00:00:00	\N	David Dastmalchian is an American actor. Raised in Kansas, he studied at The Theatre School at DePaul University. In Chicago, he received acclaim for lead roles in Tennessee Williams' The Glass Menagerie and Sam Shepard's Buried Child at Shattered Globe Theatre. Wikipedia	USA	/sF7yHISn8kuBy7T39gB5dMpObpk.jpg
2888	nm0000226	Will Smith	2	1968-09-25 00:00:00	\N	Willard Carroll Smith II (born September 25, 1968) is an American actor and rapper. Known for variety of roles, Smith has received various accolades, including an Academy Award, a British Academy Film Award and four Grammy Awards.\n\nSmith began his acting career starring as a fictionalized version of himself on the NBC sitcom The Fresh Prince of Bel-Air (1990–1996). He first gained recognition as part of a hip hop duo with DJ Jazzy Jeff, with whom he released five studio albums and the US Billboard Hot 100 top 20 singles "Parents Just Don't Understand", "A Nightmare on My Street", "Summertime", "Ring My Bell", and "Boom! Shake the Room" from 1984 to 1994. He released the solo albums Big Willie Style (1997), Willennium (1999), Born to Reign (2002), and Lost and Found (2005), which contained the US number-one singles "Gettin' Jiggy wit It" and "Wild Wild West". He has received four Grammy Awards for his rap performances.\n\nSmith achieved wider fame as a leading man in films such as the action film Bad Boys (1995), its sequels Bad Boys II (2003) and Bad Boys for Life (2020), and the sci-fi comedies Men in Black (1997), Men in Black II (2002), and Men in Black 3 (2012). After starring in the thrillers Independence Day (1996) and Enemy of the State (1998), he received Academy Award for Best Actor nominations for his portrayal as Muhammad Ali in Ali (2001), and as Chris Gardner in The Pursuit of Happyness (2006). He then starred in a range of commercially successful films, including I, Robot (2004), Shark Tale (2004), Hitch (2005), I Am Legend (2007), Hancock (2008), Seven Pounds (2008), Suicide Squad (2016) and Aladdin (2019).\n\nFor his portrayal of Richard Williams in the biographical sports drama King Richard (2021), Smith won the Academy Award, BAFTA Award, Golden Globe Award, and Screen Actors Guild Award for Best Actor. At the 2022 Academy Awards ceremony, shortly before winning, Smith faced public backlash for slapping and shouting at Oscar presenter Chris Rock after Rock made an unscripted joke referencing Smith's wife, Jada Pinkett Smith. Smith subsequently resigned from the Academy and was banned from attending all Academy functions, including the Oscars, for ten years.	USA	/6a6cl4ZNufJzrx5HZKWPU1BjjRF.jpg
53923	nm0254712	Aunjanue Ellis	1	1969-02-21 00:00:00	\N	​Aunjanue L. Ellis is an American producer, stage and screen actress, best known for her film roles in "Ray", "Undercover Brother", and on the television series "The Mentalist". She has an BA in African-American Studies from Brown University, and an MFA in Acting from the Tisch School of the Arts, New York University.	USA	/rKLTo72uhxvQbkGw27nTjH1uCHA.jpg
1607523	nm5181138	Saniyya Sidney	1	2006-10-30 00:00:00	\N	Saniyya Sidney is an American actress. She is most known for her roles in the series American Horror Story: Roanoke, and the films Fences, Hidden Figures, and Fox's new vampire drama, The Passage. Wikipedia	\N	/y47xWvuXipPgPEkz7uOvYx5XR7s.jpg
2214765	nm9403098	Demi Singleton	1	2007-02-27 00:00:00	\N		USA	/A11knIgd0doXeZYdiwIpNkskRoy.jpg
19498	nm1256532	Jon Bernthal	2	1976-09-20 00:00:00	\N	Jonathan E. "Jon" Bernthal (born September 20, 1976) is an American actor, best known for his role on the AMC television series The Walking Dead. He has performed in over 30 plays regionally and off-Broadway, including many with his own award-winning theatre company Fovea Floods. He also appeared in several TV shows such as Law & Order: Criminal Intent in 2002, The Class from 2006 to 2007 and The Pacific in early 2010.	USA	/dmFO9aBsGMFh7N0TWFYN4fcumGZ.jpg
3417	nm0001282	Tony Goldwyn	2	1960-05-20 00:00:00	\N	Anthony Howard "Tony" Goldwyn (born May 20, 1960) is an American actor and director. He portrayed the villain Carl Bruner in Ghost, Colonel Bagley in The Last Samurai, and the voice of the title character of the Disney animated Tarzan.\n\nDescription above from the Wikipedia article Tony Goldwyn, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/m4CJX4QwjZsdYJKe8OJamLRnlQh.jpg
108696	nm2608932	Susie Abromeit	1	1982-11-15 00:00:00	\N	Susie Abromeit is mostly known for her breakout role in the hit Netflix/Marvel show Jessica Jones starring alongside Carrie Anne Moss and Krysten Ritter.	USA	/7tMmET3hW1q1l78jDvQJd4XQGlo.jpg
140198	nm0152420	Judith Chapman	1	1951-11-15 00:00:00	\N	Judith Chapman is an American actress, best known for soap opera roles, particularly as Natalie Bannon Hughes in As the World Turns, Charlotte Greer on Ryan's Hope, Ginny Blake Webber on General Hospital, Sandra Montaigne on One Life to Live, Anjelica Deveraux Curtis on Days of Our Lives, and Gloria Abbott Bardwell on The Young and the Restless.	USA	/h9Yw9aGeq7tKIxg2VVNPna8cnY8.jpg
2228	nm0000576	Sean Penn	2	1960-08-17 00:00:00	\N	Sean Justin Penn (born August 17, 1960) is an American actor and film director. He has won two Academy Awards, for his roles in the mystery drama Mystic River (2003) and the biopic Milk (2008).\n\nPenn began his acting career in television, with a brief appearance in episode 112 of Little House on the Prairie on December 4, 1974, directed by his father Leo Penn. Following his film debut in the drama Taps (1981), and a diverse range of film roles in the 1980s, including Fast Times at Ridgemont High (1982) and Bad Boys (1983), Penn garnered critical attention for his roles in the crime dramas At Close Range (1986), State of Grace (1990), and Carlito's Way (1993). He became known as a prominent leading actor with the drama Dead Man Walking (1995), for which he earned his first Academy Award nomination and the Silver Bear for Best Actor at the Berlin Film Festival. Penn received another two Oscar nominations for Woody Allen's comedy-drama Sweet and Lowdown (1999) and the drama I Am Sam (2001), before winning his first Academy Award for Best Actor in 2003 for Mystic River and a second one in 2008 for Milk. He has also won a Best Actor Award at the Cannes Film Festival for the Nick Cassavetes-directed She's So Lovely (1997), and two Volpi Cups for Best Actor at the Venice Film Festival for the indie film Hurlyburly (1998) and the drama 21 Grams (2003).\n\nPenn made his feature film directorial debut with The Indian Runner (1991), followed by the drama film The Crossing Guard (1995) and the mystery film The Pledge (2001); all three were critically well received. Penn directed one of the 11 segments of 11'09"01 September 11 (2002), a compilation film made in response to the September 11 attacks. His fourth feature film, the biographical drama survival movie Into the Wild (2007), garnered critical acclaim and two Academy Award nominations.\n\nIn addition to his film work, Penn has engaged in political and social activism, including his criticism of the George W. Bush administration, his contact with the Presidents of Cuba and Venezuela, and his humanitarian work in the aftermath of Hurricane Katrina in 2005 and the 2010 Haiti earthquake.	USA	/9glqNTVpFpdN1nFklKaHPUyCwR6.jpg
51329	nm0177896	Bradley Cooper	2	1975-01-05 00:00:00	\N	Bradley Charles Cooper (born January 5, 1975) is an American actor and filmmaker. He is the recipient of various accolades, including a British Academy Film Award and two Grammy Awards, in addition to nominations for nine Academy Awards, six Golden Globe Awards, and a Tony Award. Cooper appeared on the Forbes Celebrity 100 three times and on Time's list of the 100 most influential people in the world in 2015. His films have grossed $11 billion worldwide and he has placed four times in annual rankings of the world's highest-paid actors.\n\nCooper enrolled in the MFA program at the Actors Studio in 2000 after beginning his career in 1999 with a guest role in the television series Sex and the City. He made his film debut in the comedy Wet Hot American Summer (2001). He first gained recognition as Will Tippin in the spy-action television show Alias (2001–2006), and achieved minor success with a supporting part in the comedy film Wedding Crashers (2005). His breakthrough role came in 2009 with The Hangover, a critically and commercially successful comedy, which spawned two sequels in 2011 and 2013. Cooper's portrayal of a struggling writer in the thriller Limitless (2011) and a rookie police officer in the crime drama The Place Beyond the Pines (2012) drew praise from critics.\n\nCooper found greater success with the romantic comedy Silver Linings Playbook (2012), the black comedy American Hustle (2013), and the war biopic American Sniper (2014), which he also produced. For his work in these films, he was nominated for four Academy Awards, becoming the tenth actor to receive an Oscar nomination in three consecutive years. In 2014, he portrayed Joseph Merrick in a Broadway revival of The Elephant Man, garnering a nomination for the Tony Award for Best Actor in a Play, and began voicing Rocket Raccoon in the Marvel Cinematic Universe. In 2018, Cooper produced, wrote, directed and starred in a remake of the musical romance A Star Is Born. He earned three Oscar nominations for the film, as well as a BAFTA Award and two Grammys for his contributions to its U.S. Billboard 200 number one soundtrack and its chart-topping lead single "Shallow". He gained Academy Award nominations for producing Joker (2019) and Nightmare Alley (2021).\n\nLabeled a sex symbol by the media, Cooper was named People magazine's "Sexiest Man Alive" in 2011. He supports several charities that help fight cancer. Cooper was briefly married to actress Jennifer Esposito, and has a daughter from his relationship with model Irina Shayk.	USA	/DPnessSsWqVXRbKm93PtMjB4Us.jpg
227564	nm1509478	Benny Safdie	2	1986-02-24 00:00:00	\N	Benjamin "Benny" Safdie (born February 24, 1986 in New York City) is an American director, screenwriter and actor, best known for the New York-set thrillers Good Time (2017) and Uncut Gems (2019). Together with his brother and frequent collaborator Josh Safdie, they are of Syrian-Jewish ancestry and grew up between their European father in Queens and their New Yorker mother in Manhattan. The brothers began making movies when they were kids, inspired by their film-enthusiastic father who translated his love of cinema to Benny and his brother by constantly filming them.	USA	/vrGyNcAW1Cuwkt1nyqAQQOOUQnv.jpg
61263	nm1711114	Skyler Gisondo	2	1996-07-22 00:00:00	\N	Skyler Gisondo (July 22, 1996 in Palm Beach County, Florida, USA) is an actor known for the Air Bud movies, The Amazing Spider-Man (2012), Night at the Museum: Secret of the Tomb (2014), Vacation (2015), Santa Clarita Diet (2017-2019) and Feast of the Seven Fishes (2019).	USA	/lJ6Sh5duegwjpoKF0QmiFHbBDXr.jpg
139309	nm1634944	Mary Elizabeth Ellis	1	1979-05-11 00:00:00	\N	Mary Elizabeth Ellis (born May 11, 1979 in Laurel, Mississippi, height 5' 4" (1,63 m)) is an American actress and writer best known for her recurring role as "The Waitress" on the FX comedy series It's Always Sunny in Philadelphia. She also starred in the NBC sitcom Perfect Couples.\n\nDescription above from the Wikipedia article Mary Elizabeth Ellis, licensed under CC-BY-SA, full list of contributors on Wikipedia.	\N	/9T98RZCLFuUV5oXqxJHGiw5AuPB.jpg
8265	nm0383422	John Michael Higgins	2	1963-02-12 00:00:00	\N	John Michael Higgins (born February 12, 1963) is an American comic actor whose film credits include Christopher Guest's mockumentaries, the role of David Letterman in HBO's The Late Shift, and a starring role in the American version of Kath &amp; Kim.\n\nDescription above from the Wikipedia article John Michael Higgins, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/1McAEXIhRW2Q3LJsX3os90UXcJz.jpg
4003	nm0002056	Christine Ebersole	1	1953-02-21 00:00:00	\N	Christine Ebersole won the 2007 Tony Award for Best Actress in a Musical for her work in "Grey Gardens". Previously, she was awarded the Drama Desk Award, the Outer Critics Circle Award, the Drama League awarded her both a citation and the Outstanding Performance of the Year, and she was named to its dais for 2007. She also received a special citation from the New York Drama Critics' Circle and the Obie for her off-Broadway turn in "Grey Gardens".	USA	/6Y2O0MrCWNsrvDIkjyK6cZ6KjK3.jpg
538	nm0364748	Harriet Sansom Harris	1	1955-01-08 00:00:00	\N	Born in Texas, Harriet Sansom Harris got involved in acting as a youngster. At seventeen, Harris was accepted at New York's famed Juilliard School. Upon graduation, Harris joined The Acting Company, a repertory group formed by the first alumni of John Houseman's Drama Division of The Juilliard School. She spent three years with the Company before she left to work primarily in regional theater. This led to a successful Broadway and Off-Broadway career. Her life changed after appearing as the sole female in the original cast of "Jeffrey", Paul Rudnick's smash Off-Broadway hit about love in the time of AIDS. "Jeffrey" led to guest shots on series television, including "Frasier" (1993), where she created the memorable role of "Bebe Glazer", Frasier's cutthroat, neurotic, chain-smoking agent. She also won raves from critics for her role of "Vivian Buchanan" on CBS's "The 5 Mrs. Buchanans" (1994). She now calls New York her home, but frequently travels to California for film and television appearances.  IMDb Mini Biography By: Dan Flave-Novak	USA	/1ShvYCWkZycAGb27ZivGrLx1PhS.jpg
33528	nm0189200	Joseph Cross	2	1986-05-28 00:00:00	\N	From Wikipedia, the free encyclopedia\n\nJoseph Michael Cross (born May 28, 1986) is an American actor.\n\nDescription above from the Wikipedia article Joseph Cross (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/exxcI1BPy7BFQvXWM5DiH7xpwPO.jpg
112	nm0000949	Cate Blanchett	1	1969-05-14 00:00:00	\N	Catherine Elise Blanchett (born 14 May 1969) is an Australian actor and producer. Regarded as one of the best actresses of her generation, she is known for her versatile work across independent films, blockbusters, and the stage. Blanchett is the recipient of numerous accolades, including two Academy Awards, three British Academy Film Awards, three Screen Actors Guild Awards, and three Golden Globe Awards.\n\nAfter graduating from the National Institute of Dramatic Art, Blanchett began her acting career on the Australian stage, taking on roles in Electra in 1992 and Hamlet in 1994. She came to international attention as Elizabeth I in the drama film Elizabeth (1998), for which she won the Golden Globe and BAFTA Award for Best Actress, and received her first of seven Academy Award nominations. Her portrayal of Katharine Hepburn in Martin Scorsese's The Aviator (2004) won her the Academy Award for Best Supporting Actress. She later won the Academy Award for Best Actress for playing a neurotic former socialite in Woody Allen's comedy-drama Blue Jasmine (2013). Blanchett's other Oscar-nominated roles include Notes on a Scandal (2006), I'm Not There (2007), Elizabeth: The Golden Age (2007), and Carol (2015). Her highest-grossing films include The Lord of the Rings (2001–2003) and The Hobbit (2012–2014) trilogies, The Curious Case of Benjamin Button (2008), Indiana Jones and the Kingdom of the Crystal Skull (2008), Cinderella (2015), Thor: Ragnarok (2017), and Ocean's 8 (2018).\n\nBlanchett has performed in over 20 theatre productions. From 2008 to 2013, she and her husband, Andrew Upton, were the artistic directors of the Sydney Theatre Company. Some of her stage roles during that period were in revivals of A Streetcar Named Desire, Uncle Vanya and The Maids, garnering several theatre awards and nominations. She made her Broadway debut in 2017 in The Present, for which she received a Tony Award for Best Actress in a Play nomination. Blanchett has also received Emmy Award nominations for Outstanding Lead Actress in a Limited Series or Movie and Outstanding Limited Series as producer for the FX/Hulu historical drama miniseries Mrs. America (2020).	AUS	/vUuEHiAR0eD3XEJhg2DWIjymUAA.jpg
3051	nm0001057	Toni Collette	1	1972-11-01 00:00:00	\N	Toni Collette Galafassi (November 1, 1972) is an Australian actress, producer, singer, and songwriter. Known for her work in television and independent films, she has received various accolades throughout her career, including a Golden Globe Award and a Primetime Emmy Award, in addition to nominations for an Academy Award, a Tony Award, and two British Academy Film Awards.\n\nAfter making her film debut in Spotswood (1992) and being nominated for the AACTA Award for Best Actress in a Supporting Role, her breakthrough role came in the comedy-drama Muriel's Wedding (1994), which earned her a Golden Globe Award nomination and won her the AACTA Award for Best Actress in a Leading Role. Collette achieved greater international recognition for her role in the psychological thriller film The Sixth Sense (1999), and was nominated for the Academy Award for Best Supporting Actress. She received BAFTA Award nominations for her performances in the romantic comedy About a Boy (2002) and the comedy-drama Little Miss Sunshine (2006).\n\nCollette's films include diverse genres, such as the period comedy Emma (1996), the action thriller Shaft (2000), the period drama The Hours (2002), the romantic drama Japanese Story (2003), the comedies In Her Shoes (2005) and The Way, Way Back (2013), the horror films Krampus (2015) and Hereditary (2018), and the mystery film Knives Out (2019). Her Broadway performances include the lead role in The Wild Party (2000), which earned her a Tony Award nomination. In television, she starred in the Showtime comedy-drama series United States of Tara (2008–2011) and the Netflix drama miniseries Unbelievable (2019). For the former, she won a Primetime Emmy Award and a Golden Globe Award. She has won five AACTA Awards, from eight nominations.\n\nCollette married Dave Galafassi, drummer of the band Gelbison, in January 2003. The couple have two children together. As the lead singer of Toni Collette & the Finish, she wrote all 11 tracks of their sole album, Beautiful Awkward Pictures (2006). The band toured Australia, but have not performed nor released any new material after 2007. In 2017, Collette and Jen Turner co-founded the film production company Vocab Films.	AUS	/6QllXhefzi294BcqrV8RUR4xhsy.jpg
28633	nm0420955	Richard Jenkins	2	1947-05-04 00:00:00	\N	Richard Dale Jenkins (born May 4, 1947) is an American actor. Jenkins began his acting career in theater at the Trinity Repertory Company and later made his film debut in 1974. He has worked steadily in film and television since the 1980s, mostly in supporting roles. His first major role did not come until the early 2000s, when he portrayed the deceased patriarch Nathaniel Fisher on the HBO funeral drama series Six Feet Under (2001–2005). He is also known for his roles in the films Burn After Reading (2008), Step Brothers (2008), Let Me In (2010), Jack Reacher (2012), and The Cabin in the Woods (2012).\n\nJenkins was nominated for the Academy Award for Best Actor for the drama film The Visitor (2007). He won the Primetime Emmy Award for Outstanding Lead Actor in a Miniseries or a Movie for the limited drama series Olive Kitteridge (2014). For his performance in the fantasy drama film The Shape of Water (2017), Jenkins received Academy Award, Golden Globe and Screen Actors Guild Award nominations for Best Supporting Actor.\n\n​From Wikipedia, the free encyclopedia	USA	/muT3RZG9hiKaKojD751RcQ5tGEy.jpg
5293	nm0000353	Willem Dafoe	2	1955-07-22 00:00:00	\N	William James "Willem" Dafoe (born July 22, 1955) is an American actor. He is the recipient of various accolades, including the Volpi Cup for Best Actor, in addition to receiving nominations for four Academy Awards, four Screen Actors Guild Awards, three Golden Globe Awards, and a British Academy Film Award. He frequently collaborates with filmmakers Paul Schrader, Abel Ferrara, Lars von Trier, Julian Schnabel,  Wes Anderson, and Robert Eggers.\n\nDafoe was an early member of experimental theater company The Wooster Group. He made his film debut in Heaven's Gate (1980), but was fired during production. He had his first leading role in the outlaw biker film The Loveless (1982) and then played the main antagonist in Streets of Fire (1984) and To Live and Die in L.A. (1985). He received his first Academy Award nomination (as Best Supporting Actor) for his role as Sergeant Elias Grodin in Oliver Stone's war film Platoon (1986). In 1988, Dafoe played Jesus in Martin Scorsese's The Last Temptation of Christ and costarred in Mississippi Burning, both of which were controversial.\n\nAfter receiving his second Academy Award nomination (as Best Supporting Actor) for portraying Max Schreck in Shadow of the Vampire (2000), Dafoe portrayed the supervillain Norman Osborn / Green Goblin in the superhero film Spider-Man (2002), a role he reprised in its sequels Spider-Man 2 (2004) and Spider-Man 3 (2007), and the Marvel Cinematic Universe film Spider-Man: No Way Home (2021) earning him the Guinness World Record for the "longest career as a live-action Marvel character". He also portrayed the villains in Once Upon a Time in Mexico (2003) and XXX: State of the Union (2005), as well as Carson Clay in the film Mr. Bean's Holiday (2007). In 2009, he starred in the experimental film Antichrist, one of his three films with Lars von Trier. Dafoe then appeared in The Fault in Our Stars, John Wick, The Grand Budapest Hotel (all 2014), The Great Wall (2016), Murder on the Orient Express (2017), The Florida Project (2017) (for which he received his third Academy Award nomination in the Best Supporting Actor category), The Lighthouse (2019), The French Dispatch, and Nightmare Alley (both 2021). He portrayed Nuidis Vulko in the DC Extended Universe films Aquaman (2018), Zack Snyder's Justice League (2021) and Aquaman and the Lost Kingdom (2022).\n\nDafoe has portrayed several real-life figures, including T. S. Eliot in Tom & Viv (1994), Pier Paolo Pasolini in Pasolini (2014), Vincent van Gogh in At Eternity's Gate (2018) (for which he received an Academy Award for Best Actor nomination, his first in that category), and Leonhard Seppala in Togo (2019).	USA	/ui8e4sgZAwMPi3hzEO53jyBJF9B.jpg
11064	nm0000657	David Strathairn	2	1949-01-26 00:00:00	\N	An American film and television actor, best known for his portrayal of journalist Edward R. Murrow in the feature film "Good Night, and Good Luck", for which he was nominated for an Academy Award.	USA	/fhkvTcrCDPTAclTnE7sqQS1NZKq.jpg
2372	nm0000579	Ron Perlman	2	1950-04-13 00:00:00	\N	Ronald Perlman (born April 13, 1950) is an American actor and voice-over actor. His best known roles are as Clay Morrow on Sons of Anarchy (2008–2013), Hellboy in Hellboy (2004) and its sequel Hellboy II: The Golden Army (2008), Vincent on the series Beauty and the Beast (1987–1990) for which he won a Golden Globe Award, Salvatore in The Name of the Rose (1986), Johner in Alien Resurrection (1997), Nino in Drive (2011), and Benedict Drask in Don't Look Up (2021).\n\nPerlman is also known as a collaborator of Hellboy director Guillermo del Toro, having roles in the del Toro films Cronos (1993), Blade II (2002), Pacific Rim (2013) and Nightmare Alley (2021). His voice-over work includes the narrator of the post-apocalyptic game series Fallout (1997–present), Clayface in the DC Animated Universe, Slade in Teen Titans (2003–2006), Mr. Lancer in Danny Phantom (2004–2007), Lord Hood in the video games Halo 2 (2004) and Halo 3 (2007), the Stabbington brothers in Tangled (2010), The Lich in Adventure Time (2011–2017), Xibalba in The Book of Life (2014) and Optimus Prime in both the Transformers: Power of the Primes (2018) animated series, and the film Transformers: Rise of the Beasts (2023).	USA	/gXLnsvM0tD3Jt4JwTz6eWQkgac8.jpg
3910	nm0000531	Frances McDormand	1	1957-06-23 00:00:00	\N	An American film, stage and television actress. McDormand began her career on stage and made her screen debut in the 1984 film Blood Simple, having since appeared in several theatrical and television roles. McDormand has been recognized for her performances in 'Mississippi Burning' (1988), 'Short Cuts' (1993), 'Fargo' (1996), 'Wonder Boys' (2000), 'Almost Famous' (2000), 'North Country' (2005), 'Moonrise Kingdom' (2012), 'Hail, Caesar!' (2016), 'Three Billboards Outside Ebbing, Missouri' (2017), 'Nomadland' (2020) and 'The Tragedy of Macbeth' (2021).\n\nThroughout her career, she has been nominated for eight Golden Globes, five Academy Awards, four BAFTA Awards, and three Emmy Awards. She is one of the few performers to achieve the "Triple Crown of Acting", winning an Academy Award, a Primetime Emmy Award, and a Tony Award. She won her first Academy Award for Best Actress in 1997 for her role as Marge Gunderson in 'Fargo'.  She also won Best Supporting Actress from the Broadcast Film Critics Association, the Florida Film Critics Circle, and the Los Angeles Film Critics Association for her performance in 'Wonder Boys' (2000).  McDormand returned to the stage in the David Lindsay-Abaire play Good People on Broadway from February 8, 2011 to April 24, 2011. In 2017, McDormand starred in 'Three Billboards Outside Ebbing, Missouri' which earned her a second Academy Award for Best Actress.\n\nMcDormand has been married to filmmaker Joel Coen since 1984, they reside in New York City along with their adopted son Pedro.	USA	/r0A7hZsM1zuavTr0jN7bwmBcliR.jpg
1154054	nm3659660	Corey Hawkins	2	1988-10-22 00:00:00	\N	Corey Hawkins (born October 22, 1988) is an American actor. He is perhaps best known for playing Dr. Dre in the 2015 biopic film, Straight Outta Compton.\n\nHawkins was born in Washington, D.C. where he attended the Duke Ellington School of the Arts. He graduated from the Juilliard School in New York City, a member of the Drama Division's Group 40. While studying at Juilliard, Hawkins received the prestigious John Houseman Award for excellence in classical theatre. Upon graduation, he began a career starring Off-Broadway and guest starring on television. Hawkins garnered a brief role in Marvel Studios's Iron Man 3 and went on to star opposite Liam Neeson andJulianne Moore in Universal Pictures' action-thriller Non-Stop.\n\nIn 2013, Hawkins made his Broadway debut as Tybalt in the revival of Shakespeare's Romeo and Juliet. And in 2015, The Hollywood Reporter announced that Hawkins would join the cast of AMC's The Walking Dead as Heath, a key character from Robert Kirkman's comic series. Hawkins played Dr. Dre in the biopic Straight Outta Compton, from Universal Pictures, which was theatrically released on August 14, 2015. He has been cast in Kong: Skull Island, alongside Brie Larson, Samuel L. Jackson and Tom Hiddleston.\n\nDescription above from the Wikipedia article Corey Hawkins, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/habqxQgt2ouTrrrjpbTfL6YVH7C.jpg
178634	nm1307435	Alex Hassell	2	1980-09-17 00:00:00	\N	Alexander Stephen Hassell (born 7 September 1980) is an English actor. He is co-founder of The Factory Theatre Company. Hassell was born in Southend, England, the youngest of four, to a vicar. He trained at the Central School of Speech and Drama after completing GCSE and A-Level courses at Moulsham High School, in Chelmsford, Essex.\n\nHe has appeared in a number of stage roles, most recently as Hal in Henry IV Parts I and II, and Henry in Henry V, for the Royal Shakespeare Company. His first Hollywood role was in George Clooney's Suburbicon (2017), and later that year he appeared in his first major television role in the BBC adaptation of Jessie Burton's The Miniaturist, which first aired on Boxing Day. He also appeared as Translucent in the first season of The Boys (2019) on Amazon Prime Video, and played Vicious in Netflix's Cowboy Bebop in 2021.	GBR	/1VvnpDdLJ8WBBceDayjnAG9efNC.jpg
72309	nm0402898	Kathryn Hunter	1	1957-04-07 00:00:00	\N	Kathryn Hunter was born on April 9, 1957 in New York, USA as Kathryn Hadjipateras. She is known for her work on Harry Potter and the Order of the Phoenix (2007), Orlando (1992) and Rome (2005).	\N	/cVXR004q75laRSuayzpvw6iaQkU.jpg
216425	nm1584487	Bertie Carvel	2	1977-09-06 00:00:00	\N		GBR	/hahxQXeqj09AHcQRubde19XlBcy.jpg
2039	nm0322407	Brendan Gleeson	2	1955-03-29 00:00:00	\N	Brendan Gleeson (born 29 March 1955) is an Irish actor and film director. He is the recipient of three IFTA Awards, two BIFA's, and a Primetime Emmy Award and has been nominated twice for a BAFTA Award, five times for a Golden Globe Award and once for an Academy Award. In 2020, he was listed at number 18 on The Irish Times list of Ireland's greatest film actors. He is the father of actors Domhnall Gleeson and Brian Gleeson.\n\nHe is best known for his performance as Alastor Moody in the Harry Potter films (2005–2010). He is also known for his supporting roles in films such as Braveheart (1995), Michael Collins (1996), 28 Days Later (2002), Gangs of New York (2002), Cold Mountain (2003), Troy (2004), Suffragette (2015), Paddington 2 (2017), The Ballad of Buster Scruggs (2018), and The Tragedy of Macbeth (2021). He is also known for his leading roles in films such as The General (1998), In Bruges (2008), The Guard (2011), Calvary (2014), Frankie (2019), and The Banshees of Inisherin (2022). He received a nomination for the Academy Award for Best Supporting Actor for the lattermost film.\n\nHe won an Primetime Emmy Award in 2009 for his portrayal of Winston Churchill in the television film Into the Storm. He also received a Golden Globe Award nomination for his performance as Donald Trump in the Showtime series The Comey Rule (2020). From 2017 to 2019 he starred in the crime series Mr. Mercedes. He received an Emmy Award nomination for Stephen Frears' Sundance TV series State of the Union (2022).	IRL	/379TXtBPRrkBDrEBWPQ5v3up7kT.jpg
10982	nm0577982	Harry Melling	2	1989-03-13 00:00:00	\N	Harry Edward Melling (born 13 March 1989) is an English actor, best known for his role as Dudley Dursley in the Harry Potter film series.	GBR	/b0pHwi2MeqxEpeWnF4Llihu53aJ.jpg
65885	nm0027215	Miles Anderson	2	1947-10-23 00:00:00	\N	Miles Anderson is a Zimbabwean born British stage, film and television actor.	\N	/i4VFdmtrRrQoagTlHHlC1klwJAE.jpg
2684944	nm5090093	Matt Helm	2	\N	\N		\N	/aUTzIyqTRs0BSpsnIQF6f5OkoBD.jpg
2042908	nm9458718	Moses Ingram	1	1994-02-06 00:00:00	\N	Moses Ingram (born February 6, 1994) is an American actress and writer, known for The Tragedy of Macbeth (2021), The Queen's Gambit (2020), Day 74. (2020) and Obi-Wan Kenobi (2022).	USA	/u7I5f4Bgz7CI8G7fUOJDbFtd0qf.jpg
60062	nm0836954	Scott Subiono	2	\N	\N	Scott Subiono is an actor and producer.	\N	/r0xy019yATZzwPqm8tcKuFNInnh.jpg
2719	nm0859921	Brian Thompson	2	1959-08-28 00:00:00	\N	​From Wikipedia, the free encyclopedia.\n\nBrian Thompson (born August 28, 1959) is an American actor. His distinctive square-jaw profile, powerful voice, and imposing stature (193 cm, six-foot-four) has led him to star in many action films, and a large number of comedies: Joe Dirt, The Three Amigos, Weird Science, Key West, and Life Stinks.	USA	/qooSjBMA1P85JhBpHlwmmisGroO.jpg
1723411	nm5212070	Lucas Barker	2	\N	\N	Lucas Barker started acting at age 5.	\N	/7YEY1g5FgVvnm6tS7PUxBk2VJok.jpg
178629	nm0068430	Neil Bell	2	1970-02-04 00:00:00	\N	Neil Bell (born 4 February 1970) is an English actor, mainly on British television and occasionally in films.\n\nBell studied drama at Oldham College and has played character roles in such TV series as Buried, Shameless, Murphy's Law, Ideal, City Lights, The Bill and Casualty, and the films 24 Hour Party People (2002) and Dead Man's Shoes (2004). He also had a small role in the acclaimed TV series State of Play, playing the colleague of Polly Walker's character. He has recently had a main role in The Bill playing the role of a killer. In 2010, he had a role in the ITV comedy-drama Married Single Other. He has appeared in Coronation Street, and in 2012, he had a regular role in Downton Abbey as Durrant. In 2013, he appeared in the first series of BBC2's Peaky Blinders as Publican Harry Fenton. In February 2016, he appeared in the BBC drama series Moving On.	GBR	/9fiJx9gC1ZBOoDAEQmqguisZhKM.jpg
180683	nm0504683	Dan Lett	2	\N	\N	Dan Lett is an actor.	\N	/johOG5hLcJTIn47TzYYW9FN6TNp.jpg
1552843	nm2099563	Linden Porco	2	1996-08-29 00:00:00	\N		CAN	/qXZMxGUSpmmXU2XAdX48cAnQMAS.jpg
1184209	nm0307898	Armen Garo	2	\N	\N	Armen Garo is an American actor born Troy, New York. He holds a BS in Speech Communication from Emerson College. In 1985, he joined the East Providence Police Department in East Providence. While there he earned his BS Degree in Criminal Justice from Roger Williams College and MS Degree in the Administration of Justice from Salve Regina.	\N	/yRtRh0SwHxy7LtU82l1oqctiOAl.jpg
1466868	nm2824089	Tachia Newall	2	1990-01-10 00:00:00	\N		\N	/ywvojfXK3uzw0IgVEVg3j00GPuy.jpg
1182202	nm1526335	Karl Willetts	2	\N	\N		\N	/dkWglXQZAug9g8VVDtvonZO9nrO.jpg
8700	nm0818587	Sasha Spielberg	1	1990-05-14 00:00:00	\N	Sasha Spielberg (born May 14, 1990) is an American film actress and musician. She's the daughter of director Steven Spielberg and actress Kate Capshaw.	USA	/bb7FxLkfEcQf9VLobDiMxcxYdJU.jpg
1511947	nm5490797	Peter Janov	0	\N	\N		\N	/31TUPDwukz7uFWpQGGiD3UJTHdK.jpg
2949654	\N	Thomas John Rudolph	0	\N	\N		\N	/qVOQVmxQVwDpWQB4jfu852ozHFc.jpg
557599	nm1960171	Rebecca Gibel	1	\N	\N	Rebecca Gibel is an actress.	USA	/bfRKCKebQWp9eSpQv7k3UPgCGzy.jpg
88613	nm0118368	Jesse Buck	2	\N	\N		\N	/ij0Ax19wLlhS51OZOvDCVYiKO0w.jpg
1346089	nm3999973	Doug Simpson	2	\N	\N	Doug Simpson is an actor.	\N	/pG90BnHQCp8N8NGmQhivMIU1Rix.jpg
3275311	nm7360974	Richard Carter	2	\N	\N		\N	/vwMG8213y9UiCDXBPIUwzhVxUcX.jpg
129595	nm0106227	Jonathan Bray	2	1969-01-04 00:00:00	\N	Jonathan Bray was brought into the world on January 4, 1969 in Natick, Massachusetts, USA as Jonathan Richard Bray. He is an entertainer and maker, known for Castle (2009), Mad Men (2007) and The Young and the Restless (1973). He has been hitched to Kristin Bray since September 10, 2005.	USA	/xKcbHsF3w3i9ASDqkNQrHkHjAJo.jpg
113231	nm2322406	Gunner Wright	2	1973-08-26 00:00:00	\N	Gunner Wright is an American film actor known for his role in the film Love and for "portraying" the face and voice of Isaac Clarke in the videogame Dead Space 2. Wright raced motorcycles competitively until the age of 21 when he moved to Southern California. There he began working on Fox Television's Fastlane series and soon began a career in acting. He appeared in director Clint Eastwood's J. Edgar film.	\N	/b61iQAcvqxzEu866MZkn7C2buya.jpg
111195	nm0364807	Jamie Harris	2	1963-05-15 00:00:00	\N	Tudor St. John "Jamie" Harris (born 15 May 1963) is an English actor. He is the son of actor Richard Harris and socialite Elizabeth Rees-Williams. His two brothers are actor Jared Harris and director Damian Harris.	GBR	/w4RhAUrejInGkOYc0T4B6Wxpncd.jpg
1849970	nm5382258	Jose Guns Alves	2	\N	\N		DEU	/cLm8cFWaZESOsz4pIjuTV0MGSmq.jpg
2935410	nm10994414	Mathew Trent Hunnicutt	2	\N	\N		\N	/mcPIgNiKHWrokBKF8PX6PJuwof1.jpg
3185383	nm7064768	Benjamin Clémentine	2	1988-12-07 00:00:00	\N		GBR	/johpHbzqrue6XDG63vapfugGbnn.jpg
3314411	nm8834802	Joelle	1	\N	\N	Joelle Mia Renee Joelle, better known by her stage name Joelle, is an actress and singer who made her on-screen debut in Dune (2021), performs in Paul Feig's Netflix original film The School for Good and Evil playing the character of the same name, Joelle and is due to appear in Sky and MGM+'s second season of Domina playing the role of Vipsania.\n\nDescription above from the Wikipedia article Joelle (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	GBR	/rqmxqILAmCqIXCedRBtgh6NLaw2.jpg
195309	nm0352797	Mark Hadfield	2	\N	\N		\N	/um8w6IJxgmUdVUdnQj8BEWAR2lt.jpg
3314417	nm12946879	Milena Sidorova	1	\N	\N		\N	/9kLGHnnFqCDFBZ1M048zLp4KIGh.jpg
33527	nm0063440	Adam Beach	2	1972-11-11 00:00:00	\N	Adam Ruebin Beach (born November 11, 1972) is a Canadian Saulteaux actor. He is best known for his roles as Tommy on Walker, Texas Ranger, Kickin' Wing in Joe Dirt, Marine Private First Class Ira Hayes in Flags of Our Fathers, Private Ben Yahzee in Windtalkers, Dr. Charles Eastman (Ohiyesa) in Bury My Heart at Wounded Knee, Chester Lake in Law & Order: Special Victims Unit, and Officer Jim Chee in the film adaptions of Skinwalkers, Coyote Waits, and A Thief of Time.	CAN	/k2KLABeVAvL0szCOEgfarNKsESg.jpg
1622776	nm4348069	Myles Erlick	2	1998-07-27 00:00:00	\N		CAN	/tF5z54JpnMpLaRpTHfuEQuPfOy2.jpg
2200315	nm1234911	Ebboney Wilson	1	\N	\N		\N	/n9NgWyaWIMjrJ6gLSKdAx9klsRT.jpg
1497866	nm2502226	Andy Hoff	2	\N	\N		\N	/i9HJpnlNrZO20qjEVRn2VChVuCx.jpg
1862434	nm7058487	Jacob McCarthy	2	\N	\N	Jacob McCarthy is an actor, known for The Tragedy of Macbeth (2021), A.P. Bio (2018) and The Drummer and the Keeper (2017).	\N	/kU6N4Z2L7f3mFeSZnrnmFE0k4ZZ.jpg
3197731	\N	Samuel Menhinick	2	\N	\N		\N	/d7ujAuHeUo1liaQ8d3obt1uXKob.jpg
2839334	\N	Ethan Hutchison	0	\N	\N		\N	/z1FY9KVjnZuOFJhHSxvUfZwAjjg.jpg
185127	nm0432271	Martin Julien	2	\N	\N		\N	/vGbMM13q48eKOout1KtO2mOSzx2.jpg
162609	nm0453022	Karen Kilgariff	1	1970-05-11 00:00:00	\N	Karen Kilgariff is an American writer, comedian, singer, author, actress, television producer, and podcast host. She began her career as a stand-up comedian in the early 1990s and later became a television actress, most notably as a cast member on Mr. Show. She has written for many comedy television shows, including being the head writer on The Rosie Show, The Ellen Degeneres Show and The Pete Holmes Show. Since 2016 she has co-hosted the true crime comedy podcast My Favorite Murder along with Georgia Hardstark. In 2018, she and Hardstark co-founded the podcast network Exactly Right. Along with Hardstark, Kilgariff wrote the non-fiction book 'Stay Sexy and Don't Get Murdered', which was released on May 28, 2019.	USA	/4GBJJkzzNQFyAL9knurHFFP69RX.jpg
2923329	nm4289605	Eloise Kropp	1	1992-06-23 00:00:00	\N		USA	/6Q6nPMxO4OiB2I05GWr4sUod7WI.jpg
1669956	nm1456632	Mike Massimino	2	\N	\N	Mike Massimino is an American film and television actor.	USA	/954LJsI9Wic8lcS9H3A6llmznry.jpg
2411333	nm1351863	Seun Shote	2	\N	2021-03-15 00:00:00		GBR	/33szNjKtUsTxlwV039Gec2PKQS2.jpg
3570526	nm2079046	Jess LeProtto	2	\N	\N		\N	/adlxX3VA8HUuz4eNbPhpEWI6QOq.jpg
7009	nm0692874	Tim Post	2	1963-01-01 00:00:00	\N		CAN	/kk45jSIOmAw63x5mGpr7md4Itpb.jpg
1370985	nm2677789	Joe Lanza	0	\N	\N		\N	/hSAgzc6sKwGa6FeO5oCJtpbtVBr.jpg
1440638	nm0238444	Jacque Drew	1	\N	\N		\N	/9Vw1fwfEtmWBUFfhm8FjdMmyqkS.jpg
1452949	nm1328718	George Ketsios	2	\N	\N	George Ketsios is an American actor known for his work on Lethal Weapon (2016), Insecure (2016) and NCIS: Los Angeles (2009).	USA	/iU40VAycPnPiHEc2vIcpscraid6.jpg
2974	nm0950619	Roger Yuan	2	1961-01-25 00:00:00	\N	Roger Winston Yuan (born January 25, 1961) is an American martial arts fight trainer, stunt coordinator / performer, and actor who has trained many actors and actresses in many Hollywood films. As an actor himself, he also appeared in Shanghai Noon (2000) opposite Jackie Chan, Bulletproof Monk (2003) alongside Chow Yun-fat, the technician in Batman Begins (2005), and as Sévérine's bodyguard in Skyfall (2012). He is a well-recognized choreographer in Hollywood.	USA	/A1iQKcfFvo1OXBkyuHYAgXB5ctb.jpg
1287074	nm2490263	Gerard McCarthy	2	1981-03-31 00:00:00	\N	Is an actor from Belfast, Northern Ireland.	\N	/fDUif8fapYnKa7J2RGSoRmrVjWz.jpg
1094567	nm2334991	Kevin Csolak	2	\N	\N		\N	/qw1ZHpLfDV5DcLt2w0Uba3eUzVo.jpg
152491	nm0140952	Peter Carroll	2	\N	\N		AUS	/jVb7YfltTVdFZvF0ySsymZc0m9X.jpg
56267	nm0339159	Brad Greenquist	2	1959-10-08 00:00:00	\N		USA	/kbucYMeLCNUk03HuP9SxQajEBnI.jpg
1821649	nm2874801	Sid Sagar	2	\N	\N		\N	/gS3sPHu7zWexkynZYYWscRxQo3w.jpg
60376	nm0115410	Alison Bruce	1	1962-01-01 00:00:00	\N	Alison Bruce (born 1962) is a New Zealand television and film actress, who starred in the 1999 feature Magik and Rose. She also appeared in the teen series Being Eve, Xena: Warrior Princess and had a recurring role as Simula in Young Hercules.	TZA	/e4ZZDK9lObXflkOPDHTp84OKM3y.jpg
2231256	\N	Jake Jensen	0	\N	\N		\N	/dEdlwRIgmJddZH2dwrmWrD4dGh2.jpg
3029979	nm11216373	Nate Mann	2	\N	\N	Nate Mann is an American actor. Mann attended Germantown Academy, graduating in 2015. He would first study acting at Walnut Street Theatre, and then at Juilliard School, earning a Bachelor of Fine Arts degree in 2019. Mann made his stage debut in an Off-Broadway production of Little Women, directed by Kate Hamill.	\N	/r8b07eJP4KWWHth7WwKkqa5jrOw.jpg
1920010	nm7565671	Kayla Caulfield	1	1997-04-18 00:00:00	\N		USA	/3m61wlEQZi5JgBqC5tTOOVEFEUw.jpg
1590308	nm0074375	Susan James Berger	1	\N	\N	Susan James Berger is an American film and television actress under the name Susan Berger. She also writes romance and time travel fiction as Susan B James as well as children's books as Susan J Berger.	USA	/tJAsLDKJdcLAIOthD6J9kp4AYOY.jpg
3159120	nm10913047	Isabelle Kusman	1	\N	\N		\N	/unWHWnH5iNjdK5FXkJAOWdWeRFj.jpg
210007	nm2411962	Ryan Woodle	2	\N	\N		\N	/1WqsEXVQqsP00Ih68tjMtLDvNwT.jpg
1193052	nm0522262	Stephen Lovatt	2	1964-05-27 00:00:00	\N		NZL	/hN24wBIZ1BmuedLi69bKjFHUERD.jpg
3079266	nm4277617	Bryony Skillington	1	\N	\N		\N	/4uaSGhQUw9vCzl1WtDvQaYf4i6P.jpg
2059373	\N	János Timkó	2	\N	\N		\N	/qHKNILSJE41Mtj2NUO6mdT29BeG.jpg
1758334	nm7612604	Dominic Andersen	0	\N	\N		\N	/hvENsx1FcWqSH4hSb9iYrkakT84.jpg
3204235	nm9099862	Stone Martin	2	\N	\N		\N	/jdUhehefHzpIz6dZMz9o52QGsDu.jpg
1709197	nm1121459	Patrick Noonan	2	\N	\N		\N	/kJENW5zGcvbQiASqFs6rpyfjtlS.jpg
1838242	nm5430669	Caleb Ellsworth-Clark	2	\N	\N	Caleb Ellsworth-Clark is a Canadian stage and screen actor.	\N	/64V5bMLyVk3QdgNsRZS2J9q6swV.jpg
1483976	nm4675650	Maddie Ziegler	1	2002-09-30 00:00:00	\N	Madison Nicole Ziegler (born September 30, 2002) is an American actress and dancer. She was initially known for appearing in Lifetime's reality show Dance Moms from 2011 (at age 8) until 2016. From 2014, she gained wider recognition for starring in a series of music videos by Sia, beginning with "Chandelier" and "Elastic Heart", which have in total attracted more than 5 billion views on YouTube. Ziegler has appeared in films, television shows, concerts, advertisements and on magazine covers.\n\nZiegler was a judge on the 2016 season of So You Think You Can Dance: The Next Generation and toured with Sia in North America and Australia in 2016. Her 2017 memoir, The Maddie Diaries, was a New York Times Best Seller. Her film roles include Camille Le Haut in the animated film Ballerina (2016), Christina Sickleman in The Book of Henry (2017), the title role in Music (2021), Mia Reed in the high school drama The Fallout (2021) and Velma in Steven Spielberg's 2021 West Side Story.\n\nZiegler was included by Time magazine on its list of the "30 most influential teens" in each year from 2015 to 2017. She was included in the 2023 Forbes 30 Under 30 list in the Hollywood & Entertainment category. Her social media presence includes an Instagram account with more than 13 million followers.	USA	/hDzdA0IvoPpx5nmwL5Uu75rdfYh.jpg
1952980	nm6482829	Ella Hope-Higginson	1	\N	\N		\N	/hZRpGVczt2lVLdoyKMpJM5qJRsP.jpg
54494	nm0361994	Ian Harcourt	2	\N	\N		\N	/cusbc5RNGmY2bFeSeA3mUsjQIQs.jpg
183519	nm0823149	Craig Stark	2	\N	\N		\N	/5GDo19fwIWKW13oFTRoKOdKlyX8.jpg
2444530	\N	Vaughn W. Hebron	2	\N	\N		\N	/nGigNcqhQB3zJ6233jPJg6iQiXf.jpg
1502452	nm1380980	Yumi Mizui	1	\N	\N		\N	/s09Tk67xL8FfGBXWStLJZnflixo.jpg
2581752	nm7125386	Paige Locke	1	\N	\N		\N	/6IzyZwO0MmzrjY1GQpNJGYdmQH6.jpg
3251452	nm10289597	Serrana Su-Ling Bliss	1	2007-01-01 00:00:00	\N	Serrana Su-Ling Bliss is a multi-talented British film and television actress. She is known for Belfast (2021), Enola Holmes 2 (2022), and Matilda the Musical (2022).	GBR	/h3FCGvanMlV6FQjE3p3TQ5llcNU.jpg
1772814	nm4201439	Tony Viveiros	2	\N	\N		\N	/nhmBlJVY7szLR8tFTREXKNGWdPK.jpg
2004237	nm1384498	James Collins	2	\N	\N	James Collins is known for My Babysitter's a Vampire (2011), Undercover Grandpa (2017) and Private Eyes (2016).	\N	/ai7hzoOJyJIi5umEdU1tP4PowvK.jpg
2354448	\N	George DiCaprio	2	\N	\N		\N	/dHPxzNlHIpsleiMWjAuF91DEblP.jpg
115981	nm2049403	Ricky Garcia	2	\N	\N	Ricky Garcia is an actor and director.	\N	/hWAo9W7sxSYHm9VbnsTP3VMlnsC.jpg
1705236	nm2046521	Ryan Heffington	2	1973-06-07 00:00:00	\N	Ryan Heffington is a dancer and choreographer based in the desert two hours outside of Los Angeles. He was nominated for two Grammy Awards for choreographing the music videos for Arcade Fire's "We Exist" and Sia's "Chandelier", winning a VMA Award for the latter.	USA	/1B0018Nfd3gGceB9eaRKWWyUswG.jpg
220448	nm2167957	Paul Anderson	2	1978-02-12 00:00:00	\N	Paul Anderson is an English actor who started his acting career in the late 2000s. He was previously a ticket scalper who decided to attend Webber Douglas drama school, subsequently landing roles in theatre and in films such as The Firm, Sherlock Holmes: A Game of Shadows and Passion. Anderson is known for his breakout role as Arthur Shelby in British television series Peaky Blinders.	GBR	/nds5rTBZvJ4rEsP4N6OaoEgQDkW.jpg
1508651	nm3420091	Zoe McLane	0	\N	\N		\N	/wIqINqEM9GPmQMkzu6D8hsoEYel.jpg
202032	nm0408591	Ralph Ineson	2	1969-12-15 00:00:00	\N	Ralph Michael Ineson (born 15 December 1969) is an English actor and narrator. Known for his deep, rumbling voice, his most notable roles include William in The Witch, Dagmer Cleftjaw in Game of Thrones, Amycus Carrow in the last three Harry Potter films, Donald Bamford in the BBC drama series Goodnight Sweetheart, Chris Finch in the BBC sitcom The Office, and Nikolai Tarakanov in the HBO historical drama miniseries Chernobyl.	\N	/sn3ONJw2pJxMHiCqPwvkaiWr5mc.jpg
2792762	nm1536288	Jeni Jones	1	\N	\N	Jeni Jones is an award-winning actress & director of film & theatre. Her direction of the stage play "Women on the Verge" won the production an NAACP Theatre Award. She also recently directed the award-winning short film: Club Rat$, which premiered at the Oscar-qualifying L.A. Shorts & Chelsea Film Festivals & was used to raise money & awareness for RAINN (Rape, Abuse & Incest National Network). The film has gone on to play numerous festivals & to win multiple awards, including a Best Direction Award. Jeni earned her BA in Theatre Directing & English Literature from Fordham University in NYC & her MFA in Film Directing from CalArts.	\N	/2ayGEdebvjlFdPwd0wm4A29rtFP.jpg
111945	nm0063800	Noah Bean	2	1978-08-20 00:00:00	\N	Noah Bean (born 1978) is an American actor best known for his role as David Connor on the FX legal drama Damages and as Ryan Fletcher on the 2010 The CW series Nikita as David Connor on the FX legal drama Damages and his leading performance in the independent film The Pill.\n\nPersonal life\n\nBean was born in Boston, Massachusetts. As a child, Bean attended Pine Point School and The Williams School in Connecticut. An only child, he describes himself as being so quiet and shy that his school would phone his parents asking whether anything was wrong at home: "I was deathly shy and basically scared of people in general."  In high school his mother encouraged him to become involved in drama, which he says helped him open up, "I found when I had a script in my hand I could speak."[6] He later attended Boston University's College of Fine Arts before he was offered his first theatre role by director Michael Ritchie.\n\nBean hails from Mystic, Connecticut, although he has lived and worked in Los Angeles and is currently living in New York. He is friends with actor Seth Gabel and director Jack Bender and also says he has come to be good friends with Damages co-actor and on-screen fiancée Rose Byrne.\n\nDescription above from the Wikipedia article Noah Bean, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/tp5khe5mm2XddjDbRTSFhTzQMF.jpg
2905434	\N	Jeff Willy	2	\N	\N		\N	/31sgNM0IqpevV5SPGVM5faryy6e.jpg
1502556	nm1094652	Daniel Cleary	2	\N	\N		\N	/kvEB9Yq0gpxubYuruk5TQ9l6CPA.jpg
1856875	nm0742929	Golda Rosheuvel	1	1970-05-02 00:00:00	\N	Golda Rosheuvel is an actress, known for Lady Macbeth (2016), Luther (2010) and Silent Witness (1996).	\N	/fkGpUhweuMBzN6d4h0QvkM7plH7.jpg
1709422	\N	Lakin Valdez	2	\N	\N		\N	/2PYhkcb3yDrI686vVlEDJiKpkXz.jpg
2475409	nm7867621	Talia Ryder	1	2002-08-16 00:00:00	\N	Talia Ryder (born August 16, 2002) is an American stage and film actress. In 2015, she had her breakout role as Hortensia in the Broadway musical Matilda the Musical. She made her feature film debut in 2020 as Skylar, opposite Sidney Flanigan, in the critically-acclaimed indie film Never Rarely Sometimes Always, which premiered at the Sundance Film Festival. She also starred as Tessa in Steven Spielberg's film adaptation of West Side Story. (2021). In 2021, she also had a starring role in Olivia Rodrigo's music video for "Deja Vu". In 2022, she starred as Clare in the Netflix film Hello, Goodbye, and Everything In Between and as Gabbi Broussard in the Netflix film Do Revenge.	USA	/dq7nhIjhIFynugVdw3SmKaSY46B.jpg
968089	nm2730808	Emma Dumont	1	1994-11-15 00:00:00	\N	Emma Dumont (born Emma Noelle Roberts; November 15, 1994) is an American actress, model, and dancer. She is best known for her roles as Melanie Segal in the ABC Family series Bunheads, as Emma Karn on the NBC series Aquarius and as Polaris on the FOX series The Gifted.\n\nDescription above from the Wikipedia article Emma Dumont, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/yV7JHUXX4XGMfzhVIoj1iq0DMLB.jpg
1371551	nm3578998	Melissa McMeekin	1	1972-11-20 00:00:00	\N		USA	/wl0MMHtQYcrZLsII72J5SVNcTE3.jpg
1562074	nm6563873	Kyle Allen	2	1994-10-10 00:00:00	\N	Kyle Allen is an American actor who is best known for his role in the series "The Path." He did classical ballet for five years and acrobatics for six, was a dancer with the San Francisco Ballet, and attended the Washington, D.C. boarding school "The Kirov Academy of Ballet."	USA	/utHUARepKhbw4JyDVZLhcJyKYxj.jpg
2008558	nm5699472	James Udom	2	\N	\N		\N	/jsu1DOxQaRc10Hw6rcvgvpsRKKH.jpg
2614781	nm5686344	David T. Lim	2	\N	\N		\N	/avkdW9kdSMxMsCPAJOM87qkXeSA.jpg
183814	nm0563070	Jefferson Mays	2	1965-06-08 00:00:00	\N	Jefferson Mays (born Lewis Jefferson Mays; June 8, 1965) is an American film, stage and television actor.\n\nMays was raised in Clinton, Connecticut with his parents, a naval intelligence officer and a children's librarian, and his siblings. Mays graduated from Yale College, where he received a Bachelor of Arts degree, and the University of California, San Diego, where he earned a Master of Fine Arts.\n\nMays appeared on Broadway in I Am My Own Wife, a Pulitzer Prize-winning play by Doug Wright, from November 2003 (previews) to October 31, 2004. He had appeared in the play Off-Broadway at Playwrights Horizons in May 2003, and at the La Jolla Playhouse in July 2001. \n\nMays won the 2004 Tony Award for Best Performance by a Leading Actor in a Play, the 2004 Drama Desk Award for Outstanding One-Person Show, an Obie Award, and a 2004 Theatre World Award for his solo performance. He also won the 2007 Helpmann Award for Best Male Actor in a Play for seasons of I Am My Own Wife in Australia in 2006.\n\nIn 2007, he appeared as Henry Higgins in a revival of Pygmalion and starred as Private Mason in a revival of Journey's End. In August 2009, Mays appeared at the Williamstown Theatre Festival in Quartermaine's Terms by Simon Grey.  \n\nMays starred in the 2013 Broadway musical A Gentleman's Guide to Love and Murder, in which he played eight roles. He won the Outer Critics Circle Award for Outstanding Actor in a Musical. He also was nominated for the Tony Award for Best Performance by a Leading Actor in a Musical and tied for the Drama Desk Award for Outstanding Actor in a Musical (with Neil Patrick Harris).	USA	/5W9RapvctoJpGfjaQFQHsaLlGc9.jpg
1216011	nm1022918	Andy Powers	2	1975-10-12 00:00:00	\N		\N	/nUJlEbMB1CB3JwSGzMUXJSKbEla.jpg
19995	nm0265717	Marianne Faithfull	1	1946-12-29 00:00:00	\N	Daughter of Eva, the Baroness Erisso, and Major Glynn Faithfull, a WWII British spy. Recorded the first song written by Mick Jagger and Keith Richards, "As Tears Go By" (1964). Involved in a major drug scandal with Jagger, Richards and others, which ultimately turned public opinion favorably towards the 'Rolling Stones' and other rock groups. In the 70's she became addicted to heroin and was homeless in London's Soho district for a couple of years. Recorded numerous albums in the 80's, while struggling with cocaine and alcohol. Has remained sober and productive since.	GBR	/dUubdaEhMHx5UFZnRnuI75Zs3W4.jpg
60960	nm2200658	Ray Nicholson	2	1992-02-20 00:00:00	\N	Raymond Nicholson is an American actor and he is the son of actor Jack Nicholson and actress Rebecca Broussard. He starred opposite Diane Kruger in the Neil LaBute film Out of the Blue (2022). On television, he appeared in the 2021 Amazon Prime Video series Panic.	USA	/f0MRbGIyTEJLJgHedJS8pRFhGn4.jpg
2027042	nm0316884	Carrie Gibson	1	\N	\N	Carrie Gibson was born in Washington, DC. She has spent over twenty years creating and touring plays throughout the United States and Canada on diversity and discrimination to educational institutions, major corporations, colleges and government agencies including NASA, the FBI, and the Pentagon. She is the founding Artistic Director of two national touring theater companies. She is a professional actor, singer and voice over artist, and writes screenplays. She also sings in The Sound of Musical, an a cappella group she founded devoted to musical theater songs.	\N	/mAzEqxagUYim7m2Edl9jJcH8xH3.jpg
52792	nm0748973	Maya Rudolph	1	1972-07-27 00:00:00	\N	Maya Khabira Rudolph (born July 27, 1972) is an American actress, comedian, and singer. In 2000, she became a cast member on the NBC sketch comedy show Saturday Night Live (SNL), and later played supporting roles in the films 50 First Dates (2004), A Prairie Home Companion (2006), and Idiocracy (2006).\n\nSince leaving SNL in 2007, Rudolph has appeared in various films, including Grown Ups (2010) and its 2013 sequel, Bridesmaids (2011), Inherent Vice (2014), Sisters (2015), CHiPs (2017), Life of the Party (2018), Wine Country (2019), and Disenchanted (2022). She has also provided voice acting roles for the animated films Shrek the Third (2007), Big Hero 6 (2014), The Angry Birds Movie (2016), The Emoji Movie (2017), The Willoughbys (2020), The Mitchells vs. the Machines (2021), and Luca (2021).\n\nFrom 2011 to 2012, Rudolph starred as Ava Alexander in the NBC sitcom Up All Night. In 2016, she co-hosted the variety series Maya & Marty with Martin Short. Since 2017, she has voiced various characters in the Netflix animated sitcom Big Mouth, including Connie the Hormone Monstress, which won her Primetime Emmy Awards in 2020 and 2021. For her portrayal of United States senator and vice-presidential candidate Kamala Harris on Saturday Night Live, she won the Primetime Emmy Award for Outstanding Guest Actress in a Comedy Series\n\nRudolph appeared in the NBC fantasy comedy series The Good Place (2018–2020), for which she received three Primetime Emmy Award nominations. From 2019 to 2021, she starred in the Fox animated sitcom Bless the Harts. In 2022, she began starring in the comedy series Loot, also serving as an executive producer.	USA	/bpEVMFMyHEQ8wLdii9WKB279w8p.jpg
1488465	nm5620024	Paul Bullion	2	\N	\N		\N	/uR76mlAgEpmj0WNnzJ7jG337fZF.jpg
11868	nm0859503	Sean Patrick Thomas	2	1970-12-17 00:00:00	\N	Sean Patrick Thomas (born December 17, 1970) is an American actor. He is perhaps best known for his co-starring role in the 2001 film Save the Last Dance, as well as his television role as Detective Temple Page in The District.\n\nDescription above from the Wikipedia article Sean Patrick Thomas, licensed under CC-BY-SA, full list of contributors on Wikipedia.	USA	/59Mqg13DVutKEN4ZmkG8O814uKg.jpg
2299496	\N	Christopher Wallinger	2	\N	\N		\N	/5VCVoAK7ChI7TMNH4ZUC2MuMUfD.jpg
1984115	nm4213259	Ben Cook	2	1997-12-11 00:00:00	\N	Benjamin Cook is a New York-based actor who has appeared on television, film, Broadway and in two national tours.	USA	/siFE5F4ReT1krbu3kPseVx0OO6T.jpg
1330830	nm4286657	Will Conlon	2	\N	\N		\N	/9rlWewjpRc1QeWvZOJBNV4hS1tx.jpg
206483	nm2095375	Richard Short	2	1975-10-08 00:00:00	\N	Richard Short is a British stage, film and television actor as well as a writer about sports and travel.	GBR	/vLrenhZ9fUlwmzsxRqUeQKMAD3b.jpg
122518	nm0787307	Erica Shaffer	1	1970-03-06 00:00:00	\N		USA	/7L6yfu2SETLrd08WDS7vqGtGZbQ.jpg
1388183	nm3863881	Brandon Morales	2	\N	\N		\N	/ei98nkcYPPRSQz6hb55aR8nqroh.jpg
1363622	nm2426382	Andréa Burns	1	1971-02-21 00:00:00	\N	Andréa Burns She is an American actress, singer and songwriter, primarily featured in theatre, recordings and television. She is married to Director/Performer Peter Flynn, whom she met while touring in West Side Story. They have a son named Hudson who is featured on the cover art of her solo album, A Deeper Shade of Red.	USA	/1I8H50hOWMs5XpfaK92Mttr9m0y.jpg
59051	nm0319638	Jean Gilpin	1	\N	\N		GBR	/8NRvEevVGpG0y5gSb7SvBMiUfur.jpg
130735	nm0741045	José Ramón Rosario	2	\N	\N	José Ramón Rosario is an actor.	\N	/hR9hr1OPrxEMVpYoljkma954mQo.jpg
1351363	nm1728766	Mary Eileen O'Donnell	1	\N	\N		\N	/ikzIRoNVp61Cy6EUcr6B5tQ3kww.jpg
1218244	nm3183569	Tom Degnan	2	\N	\N	Tom Degnan is an actor.	\N	/2S2h0Kv5hCVT7wzdwZUerARuMCn.jpg
2864859	nm7258450	Kiara Pichardo	1	\N	\N		\N	/rVv1RyGV6ox6g5ME3sD1BItKigG.jpg
1941216	nm3711953	Robert Gilbert	2	1988-01-01 00:00:00	\N		GBR	/tJIcASVHyZvA5C9Hw0qxs1pz1UQ.jpg
2281194	nm8792057	Destry Allyn Spielberg	1	1996-12-01 00:00:00	\N		\N	/3kFgx6zOUzwfuETng7lWkn4in0J.jpg
2864883	nm10491301	Emilia Faucher	1	2013-06-06 00:00:00	\N		USA	/gownuhLhZyB9ggIyP471ydAwVZo.jpg
1691382	nm0750419	Shade Rupe	2	1968-08-23 00:00:00	\N		USA	/69dc66AU0CYKVS6OKJro704gZEE.jpg
1408766	nm0755120	Dan Sachoff	2	\N	\N		\N	/i0ogjEzllCYCo6W0JsxdIkQoYF2.jpg
5892	nm0382110	David Hewlett	2	1968-04-18 00:00:00	\N	David Ian Hewlett (born April 18, 1968) is an English-born Canadian actor best known for his role as Dr. Meredith Rodney McKay on the science fiction television shows Stargate SG1 and Stargate Atlantis.	GBR	/hUcYyssAPCqnZ4GjolhOWXHTWSa.jpg
3432200	nm11705174	Mairéad Tyers	1	1998-01-05 00:00:00	\N		IRL	/aEL6w9NPy2qf7VgqoOzt27Mx5ip.jpg
261927	nm0267256	Souad Faress	1	1948-03-25 00:00:00	\N		\N	/aEGdIch9eRzJcsAGbF7mAZPUiXt.jpg
1083177	nm4826554	Charlie Rawes	2	\N	\N	Charlie Rawes hails from England. He was a design student during 1997 at Colchester Institute. Represented by the Gregg Millard Management in London, England, Rawes began his acting career in 2011. His early credits often included playing brawny, nasty and tough characters. His film credits include Gangsters, Guns & Zombies (2012), Skiptrace (2016), King Arthur: Legend of the Sword (2017) and Jurassic World: Fallen Kingdom (2018). Charlie Rawes has experience as a presenter and voice actor.	GBR	/zsARROMEHNANOAI8wntYcn3BpOM.jpg
2946871	\N	Vanessa Ifediora	0	\N	\N		\N	/yle2qGIS220YVgaqzAGDoMXIY4.jpg
1466172	nm2407879	Reginald L. Barnes	2	\N	\N		\N	/rSP1ceuVk5g54jkOpxC9s1mX5PH.jpg
2531142	nm11024542	Patrick Higgins	2	\N	\N		\N	/3juPdAI6GpK0x6wLOHxZc7K6eVz.jpg
2531145	nm10772682	Ricardo Zayas	2	\N	\N		\N	/d7uMLeKQpmpKbkD5uazOEUqQuIP.jpg
1877835	nm6681689	Iyana Halley	1	1993-01-27 00:00:00	\N		USA	/4L27vsUPVNDbDWPYtndqLfkt5uA.jpg
1161044	nm0584290	Bert Michaels	2	\N	\N		\N	/2DWHmoXAw7naIH00Y4evQpiX8ac.jpg
2910038	\N	Brandon Koen	0	\N	\N		\N	/rYNtWyHyryUWwyOWiy0MIa4p5Oi.jpg
1277794	nm5330651	Hannah Barefoot	1	1984-01-01 00:00:00	\N	Hannah Barefoot is a theatrically trained actress, singer, and writer originally from Cody, Wyoming. She initially intended to become a professional dancer, but along with rigorous stage training and a steady diet of classic films, she found her true love in theatre. She pursued a BFA in Theatre, Dance, and Voice at the University of Wyoming.\n\nShe moved to Los Angeles after breaking into the film industry with her lead role in the indie-cult favorite, The Falls: Testament of Love (2014).	USA	/duMdWlldESIqFYDpaJNAcLFzTTq.jpg
1093502	nm4388560	Wil J. Jackson	2	\N	\N		\N	/nDXpRYtoJ6oBWdT1x3bUvGVHcKa.jpg
1929092	nm3443226	Stephen Collins	2	1947-10-01 00:00:00	\N		USA	/wKI02sI9KHaPMBHjY0SKpLI6yen.jpg
3417990	\N	Victor Alli	2	\N	\N		\N	/9CAGyiAnGiFjasD2V6fb7Q0Pega.jpg
1169291	nm4703393	Johnno Wilson	2	\N	\N		USA	/mc025GX2Ynsm6mS1tm6QmxzerGW.jpg
3405715	\N	Elbert Kim	0	\N	\N		\N	/f7ndemUYF9K1N1YfGBtxnMaZNNv.jpg
1722268	nm4685894	Nadia Quinn	0	\N	\N		\N	/ehUgDenC6dPe3wYmnum4REVur86.jpg
3340199	nm5080141	Ricky Ubeda	2	1995-12-04 00:00:00	\N		USA	/gFvnqLuvOESe74JZf0CalOtDmUR.jpg
1470381	nm1479104	Danny Waugh	2	\N	\N		\N	/iUaBx40fLwb2jADrTRDc7a7zTft.jpg
1269682	nm4578564	Benjamin Dilloway	2	\N	\N		\N	/reXJcitDu5hsCO7Hlra2ZFzr6Nn.jpg
133068	nm4024978	Owen Burke	2	1992-10-30 00:00:00	\N	Owen Burke is an actor, known for The Town (2010), Castle Rock (2018) and The Equalizer (2014).	USA	/kgU8OelLJImeisnTkZQ14Mjp9BP.jpg
3876864	nm6856172	Dominic Cannarella-Andersen	0	\N	\N		\N	\N
1849371	\N	Daniel Falk	0	\N	\N		\N	\N
100489	nm0842374	Rod Sweitzer	2	\N	\N		\N	\N
3235986	\N	Megumi Anjo	0	\N	\N		\N	\N
2394264	nm10008958	Harrison Coll	0	\N	\N	Harrison Coll is an actor, known for John Wick: Chapter 3 - Parabellum (2019), West Side Story (2021) and Following Enchantment's Line (2021).	USA	\N
1661084	\N	Brian Kehew	0	\N	\N		\N	\N
1542318	nm0488176	Richard B. Larimore	2	1960-08-17 00:00:00	\N		\N	\N
2595001	nm10372778	Piimio Mei	0	\N	\N		\N	\N
2988275	nm1421430	Brittany Pollack	1	\N	\N		\N	\N
3313929	\N	Kit Rakusen	0	\N	\N		\N	\N
2644245	nm7388959	Mike Iveson	2	\N	\N		\N	\N
2271510	nm2971084	Catherine McGregor	1	\N	\N		\N	\N
2468124	nm2303168	Natalie Toro	1	\N	\N		\N	\N
3244329	nm3430283	Matthew MacCallum	2	\N	\N		\N	\N
2568528	\N	Rachel Feeney	1	\N	\N		IRL	\N
1753430	\N	Chris Wolfe	0	\N	\N		\N	\N
3318127	nm7628284	Gaby Diaz	1	\N	\N		\N	\N
2441587	\N	Aryn Nelson	0	\N	\N		\N	\N
1128858	nm2165338	Chris Pentzell	2	\N	\N		\N	\N
1112483	nm2756158	Richard Falkner	2	\N	\N		\N	\N
3318188	nm10772685	Adriel Flete	2	\N	\N		\N	\N
2943430	nm0456812	Matt Kirkwood	2	\N	\N		\N	\N
2882010	\N	Gerren Hall	0	\N	\N		\N	\N
3334647	nm11583617	Dani Klupsch	1	\N	\N		\N	\N
1677824	\N	Valerie Davidson	0	\N	\N		\N	\N
559644	nm3109384	Fatimah Hassan	1	\N	\N		\N	\N
2845213	nm1692958	Walter Rinaldi	2	\N	\N		\N	\N
1395234	nm0893285	Connie Ventress	1	1957-06-26 00:00:00	\N		USA	\N
1688100	nm3463325	Olivia Washington	1	1991-04-10 00:00:00	\N		USA	\N
150062	nm0727640	Erika Ringor	1	1974-12-23 00:00:00	\N		USA	\N
3334741	\N	Donna Haim	0	\N	\N		\N	\N
3334744	\N	Griff Giacchino	0	\N	\N		\N	\N
3334746	\N	James Kelley	0	\N	\N		\N	\N
3334748	\N	Will Angarola	0	\N	\N		\N	\N
3334749	\N	Milo Herschlag	0	\N	\N		\N	\N
2779742	nm7820815	Tatum Warren-Ngata	1	\N	\N		\N	\N
3125863	\N	Sean Fabian Billings	0	\N	\N		\N	\N
3238506	nm1667734	Geoff Nathanson	2	\N	\N		\N	\N
3388019	nm7767046	Samantha Rodes	1	\N	\N		\N	\N
1210997	nm0152911	Dan Chariton	2	\N	\N		\N	\N
1790593	\N	John Dinan	0	\N	\N		\N	\N
1473232	nm4175452	Jamila Velazquez	1	\N	\N		\N	\N
1026774	nm2228444	Garrett McKechnie	0	\N	\N		\N	\N
1053402	nm2042175	Collin Sutton	2	\N	\N		\N	\N
3314410	nm12946877	Dora Kápolnai-Schvab	1	\N	\N		\N	\N
1182472	nm2188865	Yassmin Alers	1	\N	\N		\N	\N
2839336	\N	Tim Oakes	0	\N	\N		\N	\N
2839337	\N	Madison Randolph	0	\N	\N		\N	\N
2839339	\N	Phil DiGennaro	0	\N	\N		\N	\N
3318577	\N	Josiah Cross	0	\N	\N		\N	\N
3318590	\N	Robert Nuscher	0	\N	\N		\N	\N
3318591	\N	Chase Del Rey	0	\N	\N		\N	\N
3318599	\N	Alden Sherrill	0	\N	\N		\N	\N
3318600	\N	Jessica Wacnik	0	\N	\N		\N	\N
3318601	\N	Marcela Zacarias	0	\N	\N		\N	\N
3570525	nm2006385	Kelvin Delgado	2	\N	\N		\N	\N
3570527	nm10624793	John Michael Fiumara	2	\N	\N		\N	\N
3570528	nm3066784	Julian Elia	2	\N	\N		\N	\N
3570532	nm10772686	Carlos E. Gonzalez	2	\N	\N		\N	\N
3570533	nm10732912	Daniel Patrick Russell	2	\N	\N		\N	\N
3570534	nm10772690	Gabriela M. Soto	1	\N	\N		\N	\N
3570535	nm10772687	Juliette Feliciano Ortiz	1	\N	\N		\N	\N
3570536	nm7028333	Jeanette Delgado	1	\N	\N		\N	\N
3570537	nm10772689	Maria Alexis Rodriguez	1	\N	\N		\N	\N
3570538	nm10772688	Edriz E. Rosa Pérez	1	\N	\N		\N	\N
3570539	nm10703842	Jennifer Florentino	1	\N	\N		\N	\N
3570540	nm4067260	Melody Martí	1	\N	\N		\N	\N
3570541	nm8385004	Isabella Ward	1	\N	\N		\N	\N
3570542	nm10641630	Leigh-Ann Esty	1	\N	\N		\N	\N
3570545	nm5108204	Lauren Leach	1	\N	\N		\N	\N
3570551	nm5594257	Skye Mattox	1	\N	\N		\N	\N
3570552	nm10643495	Adriana Pierce	1	\N	\N		\N	\N
3570556	nm7071574	Brianna Abruzzo	1	\N	\N		\N	\N
3570558	nm10772693	Halli Toland	1	\N	\N		\N	\N
3570559	nm8567434	Sara Esty	1	\N	\N		\N	\N
3570563	nm9454203	Arianna Rosario	1	\N	\N		\N	\N
3570564	nm6010043	María Alejandra Castillo	1	\N	\N		\N	\N
3570570	nm13121462	Mannelly Gonzalez Abreu	0	\N	\N		\N	\N
3570571	nm13121463	Maya Haghighi Guliani	1	\N	\N		\N	\N
3570572	nm3945098	Tyler Myers	0	\N	\N		\N	\N
3570573	nm13121464	Jesseudi Marcelino	0	\N	\N		\N	\N
3570574	nm13121465	German M. Castillo	0	\N	\N		\N	\N
3570575	nm13121466	Ciara Calderon	1	\N	\N		\N	\N
3570576	nm10959000	Aubrey Mills	1	\N	\N		\N	\N
3570577	nm13121467	Leonardo Ro	2	\N	\N		\N	\N
3570578	nm13121468	Adrian Castillo	2	\N	\N		\N	\N
3570579	nm13121469	Luke Joseph Fuentes Duculan	2	\N	\N		\N	\N
3570580	nm13121470	Abigail R. Valdez	1	\N	\N		\N	\N
3570581	nm13121471	Navio Lopez	2	\N	\N		\N	\N
3570583	nm1054528	Erik Charlston	2	\N	\N		\N	\N
3570584	nm3092652	Clint de Ganon	2	\N	\N		\N	\N
3570585	nm8752073	Dave Phillips	0	\N	\N		\N	\N
3570586	nm13121472	Silvano Monasterios	0	\N	\N		\N	\N
3570587	nm3367604	Ric Molina	0	\N	\N		\N	\N
3570589	nm4067096	Dan Pearson	2	\N	\N		\N	\N
3570591	nm13121473	Hommy Ramos	0	\N	\N		\N	\N
3570595	nm3079174	Jose Ruiz	0	\N	\N		\N	\N
3570597	nm2243711	Jumaane Smith	2	\N	\N		\N	\N
2988968	\N	Mikayla LaShae Bartholomew	0	\N	\N		\N	\N
3570600	nm13123616	Dave Noland	2	\N	\N		\N	\N
3570602	nm13158118	Roland Morales	2	\N	\N		\N	\N
3570605	nm12008497	Javier Diaz	2	\N	\N		\N	\N
3570607	nm7448809	Ron Stroman	2	\N	\N		\N	\N
3570609	nm8702977	Savannah Renée Rodriguez	1	\N	\N		\N	\N
3570612	nm2519570	Lesley Bilingslea	2	\N	\N		\N	\N
3570615	nm2143836	Pablo Thomas	2	\N	\N		\N	\N
3570617	nm11622612	Ixchel Cuellar	1	\N	\N		\N	\N
3570619	nm11265232	Oscar Antonio Rodriguez	2	\N	\N		\N	\N
1244097	nm0635847	Lance Norris	0	\N	\N		\N	\N
2958277	nm7088160	Yurel Echezarreta	2	\N	\N		\N	\N
1473511	nm0645336	Rene Ojeda	2	\N	\N		\N	\N
2544618	\N	Daniele Lawson	0	\N	\N		\N	\N
2647018	nm6291173	Yesenia Ayala	1	\N	\N		\N	\N
2655218	\N	Christian Yeung	2	\N	\N		\N	\N
1532940	nm3238725	Sophia Bui	1	\N	\N		\N	\N
1674252	nm2432825	Mike Hill	2	\N	\N		\N	\N
3204233	\N	Anilee List	0	\N	\N		\N	\N
218254	nm0287054	Julie Forsyth	1	\N	\N		\N	\N
3204238	\N	Maeve Chapman	0	\N	\N		\N	\N
3204239	\N	Stephen Caliskan	0	\N	\N		\N	\N
3204240	\N	Amanda Bradshaw	0	\N	\N		\N	\N
3204241	\N	Bryan Sabbag	0	\N	\N		\N	\N
3204243	\N	Samidio DePina	0	\N	\N		\N	\N
3318930	\N	Sophia Sanders	0	\N	\N		\N	\N
3318931	\N	Mia Jovic	0	\N	\N		\N	\N
3318932	\N	Iva Jovic	0	\N	\N		\N	\N
3318933	\N	Tom Holmes	0	\N	\N		\N	\N
3318942	\N	Kamea Medora	0	\N	\N		\N	\N
3204256	\N	Jared Voss	0	\N	\N		\N	\N
3204270	\N	TJ Ciarametaro	0	\N	\N		\N	\N
3318958	\N	Jeff Cohn	0	\N	\N		\N	\N
3204272	\N	Nikki Kim	0	\N	\N		\N	\N
3204274	nm2103450	Mary Ann Schaub	1	\N	\N		USA	\N
3204275	\N	Cassandra Berta	0	\N	\N		\N	\N
3204277	\N	Sarah Clarke	0	\N	\N		\N	\N
11451	nm0132426	Eddie Campbell	2	\N	\N		\N	\N
3318986	\N	Teri Cohn	0	\N	\N		\N	\N
3318988	\N	Holly Haggerty	0	\N	\N		\N	\N
3318989	nm1248867	Mary Pascoe	1	\N	\N		\N	\N
3318990	\N	Albert Ton	0	\N	\N		\N	\N
3318992	nm9354463	Hailey Winslow	1	\N	\N		\N	\N
3319003	\N	Diana Dray	0	\N	\N		\N	\N
3319010	\N	Trent Longo	0	\N	\N		\N	\N
2407665	\N	Tess Rianne Sullivan	0	\N	\N		\N	\N
3319026	\N	Tristan Nokes	0	\N	\N		\N	\N
2174197	\N	Virginia Schneider	0	\N	\N		\N	\N
3472653	\N	Jimmy O'Dee	0	\N	\N		\N	\N
1185053	nm0176625	Tim Conway Jr.	0	\N	\N		\N	\N
3427615	\N	Joyce Branagh	0	\N	\N		\N	\N
2573644	nm8777646	Zachary Chicos	2	\N	\N		\N	\N
2524500	nm6668520	Jacob Guzman	2	\N	\N		\N	\N
2524501	nm3031755	David Guzman	2	\N	\N		\N	\N
2524507	nm5025652	Garett Hawe	2	\N	\N		\N	\N
3233125	nm8187625	Josh Owen	0	\N	\N		\N	\N
3233126	nm12858639	Aislinn Furlong	0	\N	\N		\N	\N
3233127	nm1146610	Stephen Bain	0	\N	\N		\N	\N
3233128	nm11772347	Maeson Stone Skuggedal	0	\N	\N		\N	\N
2317693	\N	Edward Headington	0	\N	\N		\N	\N
1738122	\N	Louis Delavenne	0	\N	\N		\N	\N
1578406	nm5405251	Charlotte Townsend	1	\N	\N		\N	\N
1983914	\N	Joshua Carl Allen	0	\N	\N		\N	\N
3118524	\N	Bottara Angele	0	\N	\N		\N	\N
3118530	\N	Natalia Becerril	0	\N	\N		\N	\N
3118531	\N	Nathan M. Hadden	0	\N	\N		\N	\N
3118535	nm4212337	Patrick Salway	2	\N	\N	Patrick Salway is an actor, musician, and writer currently based in Los Angeles. Since 2010, he has appeared in films, television, music videos, and commercials. As a musician, Salway has written and released 4 albums under the name VENEER and toured North America several times with various projects.	\N	\N
3118541	\N	Mark Kirksey	0	\N	\N		\N	\N
3448285	\N	Freya Yates	0	\N	\N		\N	\N
3448286	\N	Nessa Eriksson	0	\N	\N		\N	\N
3448288	\N	Charlie Barnard	0	\N	\N		\N	\N
3448289	\N	Frankie Hastings	0	\N	\N		\N	\N
3448291	\N	Caolan McCarthy	0	\N	\N		\N	\N
3370468	nm10772691	Kellie Drobnick	1	\N	\N		\N	\N
3448293	\N	Ian Dunnett Jnr	0	\N	\N		\N	\N
3448294	\N	Oliver Savell	0	\N	\N		\N	\N
1988069	\N	Vivienne Bersin	0	\N	\N		\N	\N
3448296	\N	Orla McDonagh	0	\N	\N		\N	\N
3448298	\N	Ross O'Donnellan	0	\N	\N		\N	\N
3448299	\N	Olivia Flanagan	0	\N	\N		\N	\N
3448300	\N	Estelle Cousins	0	\N	\N		\N	\N
3448308	\N	Scott Gutteridge	0	\N	\N		\N	\N
3448313	\N	Bill Branagh	0	\N	\N		\N	\N
2999839	\N	Kaitlyn Christian	1	\N	\N		\N	\N
2766415	nm10123313	Sean Berube	2	\N	\N		\N	\N
2098769	\N	Lili Connor	1	\N	\N		\N	\N
3497607	nm11159012	Andrew Locke	2	\N	\N		\N	\N
3497609	nm7206330	Derrick Moore	2	\N	\N		\N	\N
3497611	nm7476659	Grant Bradley	2	\N	\N		\N	\N
3497615	nm13208112	Vikki Ring	1	\N	\N		\N	\N
3497616	nm13208113	Vanessa Botbyl	1	\N	\N		\N	\N
3497617	nm13208114	Michael Bridgeman	2	\N	\N		\N	\N
3497620	nm13208115	Charles Langille	2	\N	\N		\N	\N
3497621	nm13208116	Paul Taylor	2	\N	\N		\N	\N
3002009	nm0553530	Feiga Martinez	1	\N	\N		\N	\N
1103516	nm4815306	Layla Crawford	1	2004-10-12 00:00:00	\N		USA	\N
2338498	\N	T.K. Weaver	0	\N	\N		\N	\N
1824462	nm0063774	David Bean	2	\N	\N		\N	\N
3432201	\N	Drew Dillon	0	\N	\N		\N	\N
3432204	\N	Leonard Buckley	2	\N	\N		\N	\N
2039574	\N	Gabi Stewart	0	\N	\N		\N	\N
3372842	nm7744115	Pearl Minnie Anderson	0	\N	\N		\N	\N
2531138	nm1353785	Sean Harrison Jones	2	1986-01-01 00:00:00	\N		\N	\N
2531146	nm7756613	Sebastian Serra	2	\N	\N		\N	\N
2531148	nm10772683	Carlos Sánchez Falú	2	\N	\N		\N	\N
1890153	nm0579727	Sarah Mennell	1	\N	\N	Sarah Mennell is a Canadian actress.	\N	\N
2621301	\N	Eloy Perez	0	\N	\N		\N	\N
120694	nm0102726	Denia Brache	1	\N	\N		\N	\N
3340200	nm10772684	Andrei Chagas	2	\N	\N		\N	\N
1808343	nm7745065	Adam Cropper	0	\N	\N		\N	\N
1992671	nm3677280	Mark Pettograsso	2	\N	\N		\N	\N
3274730	\N	Ledger Fuller	0	\N	\N		\N	\N
2285548	nm4592485	Alistair Sewell	2	\N	\N		\N	/bE5tjZAC3BBoP0Mh1WgT00e6zfT.jpg
\.


--
-- Data for Name: cast_races; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.cast_races (id, race_id, cast_member_id) FROM stdin;
1	1	71580
2	1	113505
3	1	205
4	1	88124
5	1	1356758
6	1	4432
7	1	147056
8	1	1254583
9	1	5309
10	1	8785
11	1	228866
12	1	1331023
13	1	19797
14	1	1571661
15	1	239574
16	4	239574
17	1	1539216
18	1	1514387
19	1	1190668
20	1	933238
21	1	25072
22	4	25072
23	1	16851
24	1	543530
25	5	543530
26	1	505710
27	3	505710
28	5	1622
29	1	44079
30	1	117642
31	7	117642
32	1	3810
33	1	83854
34	2	83854
35	3	2888
36	3	53923
37	3	1607523
38	1	19498
39	1	3417
40	1	32597
41	1	85824
42	1	1330888
43	1	14721
44	1	1741367
45	1	2764542
46	1	2228
47	1	2887
48	1	51329
49	1	227564
50	1	61263
51	1	8265
52	1	4003
53	1	33528
54	1	1741368
55	1	1741366
56	1	108916
57	1	112
58	1	3051
59	1	28633
60	1	5293
61	1	11064
62	5	11064
63	7	11064
64	1	2372
65	1	7497
66	1	2453
67	1	1462
68	1	5365
69	4	5365
70	3	5292
71	3	1154054
72	1	178634
73	1	72309
74	1	216425
75	1	2039
76	1	10982
77	3	2042908
78	1	17401
79	1	1159982
80	1	2217977
81	4	2217977
82	1	1437491
83	3	1437491
84	1	2225865
85	1	175829
86	1	74541
87	4	2225865
88	3	2225865
89	4	1437491
90	4	13299
91	1	38673
93	1	824
94	1	109708
95	1	69225
96	4	69225
97	1	1300637
98	5	1300637
99	1	98804
106	1	587823
107	1	565447
108	4	565447
109	3	979216
110	1	1253648
111	1	10581
112	1	8700
113	1	150062
114	3	150062
115	5	150062
116	1	4764
117	1	1774266
118	4	1473232
119	1	1483976
120	1	202032
121	1	111945
122	1	2475409
123	1	1562074
124	5	2614781
125	1	60960
126	1	52792
127	3	52792
128	3	11868
130	1	1277794
131	1	1929092
132	4	979216
133	1	33527
134	6	33527
177	1	73457
178	2	8691
179	3	8691
180	4	8691
181	1	543261
182	1	139820
183	5	139820
184	1	12835
185	3	12835
186	1	51663
187	3	105238
188	1	93491
189	1	2408703
190	1	1133349
191	1	16483
192	1	18273
193	1	1817
194	1	1363394
195	2	1363394
196	1	20750
197	1	15762
198	1	19975
199	1	96349
200	1	23680
201	1	51797
202	1	1784612
203	1	12132
204	1	15218
205	1	53266
206	1	13922
207	1	1427948
223	5	1620
224	5	690
225	5	1381186
226	1	8944
227	1	213001
228	5	232499
229	5	1375002
230	1	1317730
231	5	1383612
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.countries (id, name, demonym, region_id, subregion_id) FROM stdin;
ESP	Spain	Spanish	5	21
AFG	Afghanistan	Afghan	4	20
SDN	Sudan	Sudanese	1	13
BGR	Bulgaria	Bulgarian	5	18
DEU	Germany	German	5	25
LTU	Lithuania	Lithuanian	5	14
MYT	Mayotte	Mahoran	1	6
MHL	Marshall Islands	Marshallese	6	10
POL	Poland	Polish	5	5
TKL	Tokelau	Tokelauan	6	15
TZA	Tanzania	Tanzanian	1	6
MAC	Macau	Macanese	4	7
TLS	Timor-Leste	East Timorese	4	17
TGO	Togo	Togolese	1	23
CZE	Czechia	Czech	5	5
MCO	Monaco	Monegasque	5	25
UGA	Uganda	Ugandan	1	6
TTO	Trinidad and Tobago	Trinidadian	2	2
DZA	Algeria	Algerian	1	13
UKR	Ukraine	Ukrainian	5	8
EST	Estonia	Estonian	5	14
GRC	Greece	Greek	5	21
MRT	Mauritania	Mauritanian	1	23
GEO	Georgia	Georgian	4	24
SXM	Sint Maarten	St. Maartener	2	2
NAM	Namibia	Namibian	1	19
MKD	North Macedonia	Macedonian	5	18
MUS	Mauritius	Mauritian	1	6
KIR	Kiribati	I-Kiribati	6	10
COG	Republic of the Congo	Congolese	1	11
GNQ	Equatorial Guinea	Equatorial Guinean	1	11
NIU	Niue	Niuean	6	15
UNK	Kosovo	Kosovar	5	18
PLW	Palau	Palauan	6	10
QAT	Qatar	Qatari	4	24
USA	United States	American	2	12
CYM	Cayman Islands	Caymanian	2	2
BWA	Botswana	Motswana	1	19
PSE	Palestine	Palestinian	4	24
ZAF	South Africa	South African	1	19
VNM	Vietnam	Vietnamese	4	17
JEY	Jersey	Channel Islander	5	14
GUY	Guyana	Guyanese	2	16
TUV	Tuvalu	Tuvaluan	6	15
JOR	Jordan	Jordanian	4	24
PNG	Papua New Guinea	Papua New Guinean	6	9
BHS	Bahamas	Bahamian	2	2
CPV	Cape Verde	Cape Verdian	1	23
OMN	Oman	Omani	4	24
VEN	Venezuela	Venezuelan	2	16
BOL	Bolivia	Bolivian	2	16
EGY	Egypt	Egyptian	1	13
CAN	Canada	Canadian	2	12
NOR	Norway	Norwegian	5	14
KGZ	Kyrgyzstan	Kirghiz	4	4
ARM	Armenia	Armenian	4	24
COD	DR Congo	Congolese	1	11
PRI	Puerto Rico	Puerto Rican	2	2
LIE	Liechtenstein	Liechtensteiner	5	25
SWZ	Eswatini	Swazi	1	19
FRO	Faroe Islands	Faroese	5	14
NGA	Nigeria	Nigerian	1	23
MAF	Saint Martin	Saint Martin Islander	2	2
GUM	Guam	Guamanian	6	10
MWI	Malawi	Malawian	1	6
ALA	Åland Islands	Ålandish	5	14
STP	São Tomé and Príncipe	Sao Tomean	1	11
FLK	Falkland Islands	Falkland Islander	2	16
GTM	Guatemala	Guatemalan	2	3
BRB	Barbados	Barbadian	2	2
GHA	Ghana	Ghanaian	1	23
NIC	Nicaragua	Nicaraguan	2	3
IMN	Isle of Man	Manx	5	14
PRT	Portugal	Portuguese	5	21
AGO	Angola	Angolan	1	11
DOM	Dominican Republic	Dominican	2	2
ALB	Albania	Albanian	5	18
GNB	Guinea-Bissau	Guinea-Bissauan	1	23
LBY	Libya	Libyan	1	13
KWT	Kuwait	Kuwaiti	4	24
BHR	Bahrain	Bahraini	4	24
TKM	Turkmenistan	Turkmen	4	4
LBR	Liberia	Liberian	1	23
BFA	Burkina Faso	Burkinabe	1	23
LVA	Latvia	Latvian	5	14
RUS	Russia	Russian	5	8
PHL	Philippines	Filipino	4	17
NZL	New Zealand	New Zealander	6	1
CMR	Cameroon	Cameroonian	1	11
ECU	Ecuador	Ecuadorean	2	16
AIA	Anguilla	Anguillian	2	2
ROU	Romania	Romanian	5	18
IND	India	Indian	4	20
GAB	Gabon	Gabonese	1	11
MMR	Myanmar	Burmese	4	17
REU	Réunion	Réunionese	1	6
ASM	American Samoa	American Samoan	6	15
MNE	Montenegro	Montenegrin	5	18
BLZ	Belize	Belizean	2	3
MNG	Mongolia	Mongolian	4	7
AUT	Austria	Austrian	5	5
MSR	Montserrat	Montserratian	2	2
SAU	Saudi Arabia	Saudi Arabian	4	24
HUN	Hungary	Hungarian	5	5
NRU	Nauru	Nauruan	6	10
ARG	Argentina	Argentine	2	16
PCN	Pitcairn Islands	Pitcairn Islander	6	15
WLF	Wallis and Futuna	Wallis and Futuna Islander	6	15
YEM	Yemen	Yemeni	4	24
SVK	Slovakia	Slovak	5	5
TCA	Turks and Caicos Islands	Turks and Caicos Islander	2	2
SWE	Sweden	Swedish	5	14
SHN	Saint Helena, Ascension and Tristan da Cunha	Saint Helenian	1	23
ITA	Italy	Italian	5	21
BRA	Brazil	Brazilian	2	16
SSD	South Sudan	South Sudanese	1	11
CYP	Cyprus	Cypriot	5	21
THA	Thailand	Thai	4	17
TUR	Turkey	Turkish	4	24
BMU	Bermuda	Bermudian	2	12
AUS	Australia	Australian	6	1
BGD	Bangladesh	Bangladeshi	4	20
GRD	Grenada	Grenadian	2	2
SGP	Singapore	Singaporean	4	17
MDA	Moldova	Moldovan	5	8
MLI	Mali	Malian	1	23
KEN	Kenya	Kenyan	1	6
URY	Uruguay	Uruguayan	2	16
CHE	Switzerland	Swiss	5	25
SLV	El Salvador	Salvadoran	2	3
TCD	Chad	Chadian	1	11
GRL	Greenland	Greenlandic	2	12
BLR	Belarus	Belarusian	5	8
CIV	Ivory Coast	Ivorian	1	23
LBN	Lebanon	Lebanese	4	24
NLD	Netherlands	Dutch	5	25
SMR	San Marino	Sammarinese	5	21
BTN	Bhutan	Bhutanese	4	20
MYS	Malaysia	Malaysian	4	17
KAZ	Kazakhstan	Kazakhstani	4	4
FIN	Finland	Finnish	5	14
TUN	Tunisia	Tunisian	1	13
GMB	Gambia	Gambian	1	23
SYR	Syria	Syrian	4	24
ATF	French Southern and Antarctic Lands	French	3	22
NFK	Norfolk Island	Norfolk Islander	6	1
GIN	Guinea	Guinean	1	23
BES	Caribbean Netherlands	Dutch	2	2
MOZ	Mozambique	Mozambican	1	6
WSM	Samoa	Samoan	6	15
TWN	Taiwan	Taiwanese	4	7
SGS	South Georgia	South Georgian South Sandwich Islander	3	22
PRK	North Korea	North Korean	4	7
DJI	Djibouti	Djibouti	1	6
SUR	Suriname	Surinamer	2	16
FRA	France	French	5	25
RWA	Rwanda	Rwandan	1	6
KOR	South Korea	South Korean	4	7
ATA	Antarctica	Antarctican	3	22
CUW	Curaçao	Curaçaoan	2	2
JAM	Jamaica	Jamaican	2	2
MDV	Maldives	Maldivan	4	20
SVN	Slovenia	Slovene	5	5
CXR	Christmas Island	Christmas Islander	6	1
VIR	United States Virgin Islands	Virgin Islander	2	2
PRY	Paraguay	Paraguayan	2	16
IDN	Indonesia	Indonesian	4	17
MDG	Madagascar	Malagasy	1	6
IRQ	Iraq	Iraqi	4	24
HND	Honduras	Honduran	2	3
MAR	Morocco	Moroccan	1	13
HKG	Hong Kong	Hong Konger	4	7
ATG	Antigua and Barbuda	Antiguan, Barbudan	2	2
LKA	Sri Lanka	Sri Lankan	4	20
HTI	Haiti	Haitian	2	2
CUB	Cuba	Cuban	2	2
TJK	Tajikistan	Tadzhik	4	4
COK	Cook Islands	Cook Islander	6	15
COL	Colombia	Colombian	2	16
FSM	Micronesia	Micronesian	6	10
MNP	Northern Mariana Islands	American	6	10
KNA	Saint Kitts and Nevis	Kittitian or Nevisian	2	2
UZB	Uzbekistan	Uzbekistani	4	4
GIB	Gibraltar	Gibraltar	5	21
IRL	Ireland	Irish	5	14
PER	Peru	Peruvian	2	16
PAK	Pakistan	Pakistani	4	20
CHL	Chile	Chilean	2	16
ZMB	Zambia	Zambian	1	6
LCA	Saint Lucia	Saint Lucian	2	2
SYC	Seychelles	Seychellois	1	6
BEN	Benin	Beninese	1	23
GBR	United Kingdom	British	5	14
BVT	Bouvet Island	Unknown	3	22
CRI	Costa Rica	Costa Rican	2	3
COM	Comoros	Comoran	1	6
ISL	Iceland	Icelander	5	14
JPN	Japan	Japanese	4	7
VAT	Vatican City	Vatican	5	21
VGB	British Virgin Islands	Virgin Islander	2	2
NCL	New Caledonia	New Caledonian	6	9
FJI	Fiji	Fijian	6	9
BIH	Bosnia and Herzegovina	Bosnian, Herzegovinian	5	18
CCK	Cocos (Keeling) Islands	Cocos Islander	6	1
ESH	Western Sahara	Sahrawi	1	13
MEX	Mexico	Mexican	2	12
KHM	Cambodia	Cambodian	4	17
VCT	Saint Vincent and the Grenadines	Saint Vincentian	2	2
IRN	Iran	Iranian	4	24
MLT	Malta	Maltese	5	21
SRB	Serbia	Serbian	5	18
ARE	United Arab Emirates	Emirati	4	24
AZE	Azerbaijan	Azerbaijani	4	24
HMD	Heard Island and McDonald Islands	Heard and McDonald Islander	3	22
PYF	French Polynesia	French Polynesian	6	15
VUT	Vanuatu	Ni-Vanuatu	6	9
NER	Niger	Nigerien	1	23
ERI	Eritrea	Eritrean	1	6
CAF	Central African Republic	Central African	1	11
ISR	Israel	Israeli	4	24
NPL	Nepal	Nepalese	4	20
PAN	Panama	Panamanian	2	3
GGY	Guernsey	Channel Islander	5	14
SLB	Solomon Islands	Solomon Islander	6	9
ZWE	Zimbabwe	Zimbabwean	1	19
ABW	Aruba	Aruban	2	2
BRN	Brunei	Bruneian	4	17
DNK	Denmark	Danish	5	14
BEL	Belgium	Belgian	5	25
GUF	French Guiana	Guianan	2	16
LAO	Laos	Laotian	4	17
TON	Tonga	Tongan	6	15
AND	Andorra	Andorran	5	21
GLP	Guadeloupe	Guadeloupian	2	2
MTQ	Martinique	Martinican	2	2
LSO	Lesotho	Mosotho	1	19
DMA	Dominica	Dominican	2	2
SOM	Somalia	Somali	1	6
HRV	Croatia	Croatian	5	18
SLE	Sierra Leone	Sierra Leonean	1	23
BLM	Saint Barthélemy	Saint Barthélemy Islander	2	2
SJM	Svalbard and Jan Mayen	Norwegian	5	14
SPM	Saint Pierre and Miquelon	Saint-Pierrais, Miquelonnais	2	12
UMI	United States Minor Outlying Islands	American Islander	2	12
BDI	Burundi	Burundian	1	6
SEN	Senegal	Senegalese	1	23
ETH	Ethiopia	Ethiopian	1	6
LUX	Luxembourg	Luxembourger	5	25
CHN	China	Chinese	4	7
IOT	British Indian Ocean Territory	Military Personnel	1	6
\.


--
-- Data for Name: credits; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.credits (id, movie_id, "character", "order", cast_member_id) FROM stdin;
5cd0a6f1c3a36836c1e3227d	600583	Phil Burbank	0	71580
5e44a7a40102c9001757f3a6	600583	Peter Gordon	1	113505
5d9d1b09a5046e003682cb0b	600583	Rose Gordon	2	205
5dd6ff6428723c0012520229	600583	George Burbank	3	88124
5e44a79a41465c0016d26945	600583	Lola	4	1356758
613d9e4bf96a3900435fd064	600583	Mrs. Lewis	5	10760
5e44a7cc0102c9001757f3e1	600583	The Governor	6	30613
5e44a7b641465c0014d21c63	600583	Old Lady	7	4432
6315ee280c125500923af8f6	600583	Barkeep	8	3521003
6315ee339408ec007bed7003	600583	Sven	9	962109
6315ee7571083a009249f3a6	600583	Cricket	10	1399811
6315ee807fcab30091dd674e	600583	Theo	11	3233123
6315ee99ba131b0079b344d7	600583	Angelo	12	1404367
6315eeac326c190082251438	600583	Bobby	13	939388
6315eebdba131b0081d18fdc	600583	Juan	14	3233124
613ebfbf56b9f7008b973c07	777270	Buddy	0	3232669
5fdc21022efe4e003fd5e171	777270	Ma	1	147056
5fdc20f2cf48a10040475f99	777270	Pa	2	1254583
5fdc211b798e06003e335f5b	777270	Granny	3	5309
5fdc212a109dec0042f3c0cf	777270	Pop	4	8785
6135a9eecede690060f973f7	777270	Billy Clanton	5	228866
5fdc21412efe4e0040d628ed	777270	Moira	6	1726976
62371e568ac3d0001bba949e	777270	Will	7	3065081
5fdc216b798e0600403479e8	777270	Mackie	8	56101
62371e6ddf2945004607a891	777270	Auntie Violet	9	1709739
61470fcf511d09008a1b9958	777270	Catherine	10	2893134
62371f5d54a8ac007c533b50	777270	Frankie West	11	17483
5fdc2182cca7de003eeb04d5	777270	Minister	12	1474032
6237205c894ed60079513c10	777270	McLaury	13	82149
62371f788e8d30001d132153	777270	Mr Stewart	14	2163883
5fd92e5cecbde9003facf17f	776503	Ruby Rossi	0	1331023
5fd92eb1283ed9003e1cc82f	776503	Jackie Rossi	1	19797
601ce2019a3c490041adad69	776503	Frank Rossi	2	1571661
5fd92e69075288003e137400	776503	Bernardo Villalobos	3	239574
5fd92e9968188800429a9248	776503	Miles	4	1539216
5fd92ea6b0ba7e003f2fe88b	776503	Leo Rossi	5	1514387
5fdfc329eb0932003f52c044	776503	Gertie	6	1369336
5fdfc331f706de003e8119f6	776503	Brady	7	4728
5fdfc33cbbe1dd00411edbd8	776503	Tony Salgado	8	935624
5fdfc34de7c097003e17ce18	776503	Arthur	9	188049
611e898c9f0e1900440ef94b	776503	Ms. Simon	10	1974354
611e899b9f0e19005c3f2d3e	776503	Audra	11	3204229
611e89bcc14fee007dd68228	776503	Guidance Counselor	12	2559002
611e89d51bf876002f96cfd7	776503	Doctor	13	2357138
611e89e7595a56002a0d3a3f	776503	Riff Girl	14	3204232
5b4d01bac3a36823d803cd45	438631	Paul Atreides	0	1190668
5b90742fc3a368222e002f41	438631	Lady Jessica Atreides	1	933238
5c50bc070e0a2612cccedcb3	438631	Duke Leto Atreides	2	25072
5c64750d9251412fb4feec3e	438631	Gurney Halleck	3	16851
5c364b61c3a368273c1c5fee	438631	Baron Vladimir Harkonnen	4	1640
5c342d10c3a36851f8b52ac9	438631	Beast Rabban Harkonnen	5	543530
5e37991c4ca676001252ea99	438631	Dr. Liet Kynes	6	195666
61468a6985c0a20043d24c95	438631	Thufir Hawat	7	196179
5c5241fa0e0a2612ccd0fc9c	438631	Chani	8	505710
5c8e6e129251410ff4a1c158	438631	Dr. Wellington Yueh	9	1622
5c3e88ba9251415524ae5623	438631	Reverend Mother Gaius Helen Mohiam	10	44079
5c6610319251412fc6017577	438631	Duncan Idaho	11	117642
5c55434c0e0a26567ac66f76	438631	Stilgar	12	3810
5c6c967b0e0a261e069f48b6	438631	Piter de Vries	13	83854
5e3799110c27100013728d9c	438631	Jamis	14	205923
5d288a8fcaab6d00129b75a6	614917	Richard Williams	0	2888
5e191a04a0be280013ff9137	614917	Oracene "Brandy" Price	1	53923
5e19199c2ea6b90017ef1279	614917	Venus Williams	2	1607523
5e1919e33679a10011941aa8	614917	Serena Williams	3	2214765
5e20fc8d397df0001696a64b	614917	Rick Macci	4	19498
5f876b04a275020039cbb080	614917	Paul Cohen	5	3417
5e587e0e35811d001762a168	614917	Robin Finn	6	108696
5e619ed055c926001959fd55	614917	Will Hodges	7	32597
5ee0b9de90dde00022a6c9df	614917	Nancy Reagan	8	140198
5ee0ba0590dde00020a74321	614917	Anne Worchester	9	85824
5fe4a6665be00e003da05239	614917	Social Worker	10	113734
610189cf1684f7005f0e6256	614917	Laird Stabler	11	1330888
610189d9a217c0005d5f93ef	614917	Vic Braden	12	14721
610189e21b7294002f6cc0be	614917	Bells	13	1299192
61728f1bc8f8580094c68d97	614917	Braze	14	3280234
5f456cbbcee4810037aa2c82	718032	Alana Kane	0	1741367
5f508c67e894a6003749125b	718032	Gary Valentine	1	2764542
613a84ae6c1e040063dc1b7c	718032	Jack Holden	2	2228
613f359faaf897008c06f372	718032	Rex Blau	3	2887
5f284e8b435abd003877e7f2	718032	Jon Peters	4	51329
5f4b8d9deec4f30036d13d3c	718032	Joel Wachs	5	227564
60bf934d13a388002ba63fd6	718032	Lance	6	61263
61520fc3af95900026022966	718032	Momma Anita	7	139309
61a9d76cc5c1ef00450000e6	718032	Jerry Frick	8	8265
619000e163e6fb008dcd6bc5	718032	Lucille Doolittle	9	4003
61903b93bb260200430ec00b	718032	Mary Grady	10	538
601110e87f1d8300406e1b62	718032	Matthew	11	33528
6151ea2767203d00296cff98	718032	Danielle Kane	12	1741368
6151eb111c635b0044711aa0	718032	Este Kane	13	1741366
61aaed33001bbd001977f367	718032	Moti Kane	14	3334740
5d03e8e60e0a263f96d25f5c	597208	Stanton 'Stan' Carlisle	0	51329
5d44e8452d1e403b46bdd56f	597208	Mary Margaret 'Molly' Cahill	1	108916
5d44e81ea0be280016a136f6	597208	Dr. Lilith Ritter	2	112
5d44e83e0f2fbd7674ed1aeb	597208	Zeena 'Zeena the Seer' Krumbein	3	3051
5d44e8582d1e401ecbbdfc54	597208	Ezra Grindle	4	28633
5d44e8760f2fbd0b0decef04	597208	Clement 'Clem' Hoatley	5	5293
5d8ec74b109cd0002941a973	597208	Pete	6	11064
5d44e86ca0be280014a1447c	597208	Bruno	7	2372
5dd5ebb5af85de00157cccd5	597208	Anderson	8	7497
61aaeaece54d5d009270ce73	597208	Mrs. Kimball	9	2453
61eb168e3faba0001d3f8c5b	597208	Judge Kimball	10	229
5d44e8a52d1e403b44bdd511	597208	The Major	11	154785
5e8a093e9512e10014e6c1b7	597208	Sheriff Jedediah Judd	12	29862
6157e3e3d2147c0026750b0d	597208	Carny Boss	13	1462
61aaeabd0f2ae100421c52d5	597208	Funhouse Jack	14	5365
5c9d304492514124c53187d5	591538	Macbeth	0	5292
5c9d30490e0a2613f6ebeafa	591538	Lady Macbeth	1	3910
5dd7212bb5bc210013c249b1	591538	Macduff	2	1154054
5f167f943852020036db6dae	591538	Ross	3	178634
5f9ed4067614210036f191ce	591538	Witches / Old Man	4	72309
616ca0a9d43f010091e5aca0	591538	Banquo	5	216425
5dcb4373e263bb00136ef8e9	591538	Duncan	6	2039
5e34504176eecf00178dd2b7	591538	Malcolm	7	10982
5f9ed32a7e34830039a225e2	591538	Lennox	8	65885
5f9ed38b1511aa0038a6b6ac	591538	Donalbain	9	2684944
5e1fd730b3316b001102128d	591538	Lady Macduff	10	2042908
5f9ed3a9bd990c00384a3736	591538	Murderer	11	60062
5f9ed2ed63501300325a8e47	591538	Murderer	12	2719
5f9ed3ba7314a1003836349f	591538	Fleance	13	1723411
616ca113c8f858004345a582	591538	Porter	14	17401
5bb3265a0e0a263e0a007574	511809	Tony	0	1159982
5c3dae2d0e0a2615548d3082	511809	María	1	2217977
5c3de277c3a36805733e838e	511809	Anita	2	1437491
5c4aa4bac3a368477a8cd724	511809	Bernardo	3	2225865
5cb652da92514108d8f4b637	511809	Riff	4	1423520
5c9199789251410f939fab30	511809	Officer Krupke	5	175829
5c9199640e0a2663c752d203	511809	Lieutenant Schrank	6	74541
5c3de2529251417a60abcc8b	511809	Valentina	7	13299
5c91999fc3a368611f51d9c8	511809	Chino	8	2269067
5cb6e15fc3a3686af2834791	511809	Rosalía	9	1636954
62955d820f21c615372edce7	511809	Luz	10	2840908
61edf8f3cd204600e5782382	511809	Anybodys	11	2531140
5e3c6c6dac8e6b0018cbaff9	511809	Quique	12	2531143
62955e2f5cea18009fd0b0ab	511809	Charita	13	2721914
62955e52a44d0900a98b5a3c	511809	Aníbal	14	3441020
5e4234c141465c0016ce6f5f	626735	Jackson Briggs	0	38673
60f1c8dff0647c0046611cac	626735	Tamara	1	209
606a7997d48cee0078ada189	626735	Gus	2	135352
62115e623520e8001dc620cf	626735	Noah	3	824
62115e6b1f0275001b87dc5b	626735	Police Officer	4	109708
60f1c8faa9b9a40046e73162	626735	Niki	5	69225
606a79d3ebb99d002aded832	626735	Tiffany	6	1302221
606a799d699fb7006fc75c73	626735	Callan	7	1300637
606a79b0d48cee003f9ab446	626735	Keith	8	98804
606a798acdf2e60029693a3a	626735	Corporal Levitz	9	4741
606a79a67f2d4a006e3793af	626735	Zoe	10	227477
62115d79a24232006bffad08	626735	Bella	11	2026050
606a79e53429ff00290d0a75	626735	Natalie	12	1855491
606a79c6ce5d820058ecf955	626735	Al-Farid Friend	13	1564257
606a79f70d2f530040a22798	626735	Mercenary	14	2491917
606a79dd699fb7006fc75cbd	626735	Brad	15	1367516
606a79b7d3d3870059c83ae6	626735	Tara	16	1459439
606a79ef194186006f91fe3f	626735	Jones	17	1387665
618c836520e6a5002c4d4b62	626735	Range Boy	18	1067065
618c83cbcf62cd0061775eae	626735	Hotel Guest	19	2935410
618c83d86e0d7200291a9855	626735	Ranger Lucas	20	3255984
618c83eed55e4d0045b7defc	626735	Police Officer	21	3304751
618c83fb534661002ab45f86	626735	Dr. Gray	22	2189049
618c8418e74146006001d8ff	626735	Cellmate	23	2323106
618c8427e93e95008e9be94e	626735	Inmate #4	24	1444798
618c8444a313b80062504c71	626735	Room Service Attendant	25	2644960
618c8453d768fe004582ebd3	626735	Natasha	26	3304752
618c8464209f180043ded451	626735	Hipster Bartender	27	1517706
618c8473d55e4d0045b7e099	626735	Wealthy Woman	28	2180811
618c8481e74146006001daa5	626735	Hotel Guest #2	29	2923038
618c848f534661008f9cf2d9	626735	Dr. Junaid	30	1502670
618c849dd768fe002b812faf	626735	Inmate	31	1531618
618c84ae0f0da5006526d989	626735	Luke	32	3116820
618c84bab076e50066494804	626735	Sergeant Riley Rodriguez	33	3304753
618c84c67ac829002c9b77bb	626735		34	1679132
618c84cecca7de008f6aedb7	626735	Sonia	35	2045023
618c84d9534661004472e2d7	626735	Sergeant Turner	36	3116821
618c84e56e0d720063d7789b	626735	Battalion Ranger	37	3304754
61dc0d8000508a0043652015	626735	Additional Voices(voice)	38	1464399
61dc0fb56c8492008da7e5b1	626735	Corporal Dickerson	39	3376382
61dc102512197e006a41cc4e	626735	Soldier	40	2131693
61dc10c6924ce50042f55be9	626735	Deli Manager	41	3376396
61dc1119924ce5008cb76963	626735	Police Officer	42	1451079
61dc125100508a006879523c	626735	Funeral Attendee Family Member	43	1593376
61dc1309681888008fe5beba	626735		44	2625316
61dc136b681888001d55b068	626735	MP	45	1539711
62115de51f0275006a6ac18b	626735	Deli Teenager	46	2092052
5b7b78b30e0a267c710033be	447365	Peter Quill / Star-Lord	0	73457
5c8eaa880e0a26130256eb0a	447365	Gamora	1	8691
5b7b78f0c3a368197c0026eb	447365	Drax the Destroyer	2	543530
5c8eaa969251410ff4a250cd	447365	Nebula	3	543261
5b1fbd9a9251413f45003356	447365	Mantis	4	139820
5b7b79220e0a267c770030e2	447365	Groot (voice)	5	12835
5b7b79050e0a267c7d00377c	447365	Rocket (voice)	6	51329
5c8ea9abc3a36861194c8f42	447365	Kraglin / Young Rocket	7	51663
61895836595a560063724ff7	447365	The High Evolutionary	8	105238
6164bd5bcee481008d1b61be	447365	Adam Warlock	9	93491
629e21bef3e0df009d6fe1dd	447365	Cosmo (voice)	10	2408703
6148059e85da120062a93a74	447365	Ayesha	11	1133349
618ecf231c635b008f2c3660	447365	Stakar Ogord	12	16483
64507e9ad7107e00e3efae71	447365	On-Set Groot / Phlektik Guard	13	1696434
64482837b76cbb0492a3ba34	447365	Steemie Blueliver	14	85096
64507eba93bd690111f3dc6d	447365	Xlomo Smeth	15	1411625
64507f03af85de0104c08cef	447365	Ssssaralami	16	1591198
64507f1293bd690153923992	447365	Hoobtoe	17	4024360
64507f2093bd690111f3dcbe	447365	Orloni Peddler	18	3125907
62a8ae2fd5569718c75ba7ba	447365	Recorder Theel	19	1465297
64507f452a09bc0123708cc0	447365	Recorder Vim	20	18273
644827276e938a05283e8a5f	447365	Baby Rocket (voice)	21	4028624
644804a4b76cbb0492a3a8c9	447365	Lylla	22	1817
644804e0c51acd04b6a954fa	447365	Teefs	23	1502438
644804cb140bad04d3a77a2d	447365	Floor	24	1363394
644d2cd8cb802803247d581b	447365	War Pig (voice)	25	20750
64507f85e16e5a015db41519	447365	Behemoth (voice)	26	1937912
644d2ce3336e014401732abd	447365	Mainframe (voice)	27	15762
64507f9faf85de00e723af2d	447365	Krugarr	28	3192808
643eb6c4e0ca7f048b072f3b	447365	Martinex	29	19975
64507fbad7107e00e3efaf70	447365	Beardy Ravager	30	939406
64507fc6435011015e920aaa	447365	Molly Ravager	31	96349
64507fd0d7107e012d00a62b	447365	Fitz-Gibbonok	32	968692
643e71ccc6006d04ff80a267	447365	Blurp (voice)	33	23680
64507ff0e16e5a01401fbfdb	447365	Humanimal Turtle Experiment	34	4040040
644dc7776eecee056700f71a	447365	Administrator Kwol	35	87165
6436e1e11f748b00971668a6	447365	Master Karja	36	51797
645080116d1bb2010e586ee2	447365	The Boss's Nephew	37	1827845
6450801aaf85de013e640458	447365	Bletelsnort	38	1356013
64508022e942ee00e5e45fde	447365	Orgocorp Host Friniki	39	1404452
6450802be942ee00e5e45fec	447365	Security Assistant	40	3061301
6297852e09ed8f0cf038eb2a	447365	Ura	41	1784612
6450805512b10e01417858fb	447365	Gamora Shoots This Guy!	42	2422999
64508060e16e5a01401fc02a	447365	Carrot Head Guard	43	1290604
6450806943501100ea39aa2b	447365	Carrot Head's Friend	44	1635223
64508071e16e5a015db415d2	447365	Kitty Orgosentry	45	2486881
6450807ad7107e012d00a6a9	447365	Dancing Guard	46	1388183
64508083e16e5a01401fc043	447365	Violent Orgosentry	47	1768007
6450809b6d1bb200ed57dd15	447365	Humanimal Rabbit	48	4040048
645080a6e16e5a00e9f030a3	447365	Humanimal Kangaroo	49	2776852
645080ee2a09bc00e2da7243	447365	Humanimal Monkey	50	2510475
645080f6e942ee00e5e46091	447365	Warthog Mother	51	3359669
645080fed7107e010ade9f52	447365	Humanimal Panda Bear	52	1717376
6450810793bd6901746a6c77	447365	Neelie	53	967944
6450810e4350110124242e44	447365	Blue Jay Postal Worker	54	3245755
64508116af85de015be65bcb	447365	Rabbit Businessman	55	73620
6450812f2a09bc014020a816	447365	Humanimal Bush Baby Toddler	56	4040051
6450813ad7107e010ade9f85	447365	Humanimal Hyena	57	2532648
6450815343501100ea39aabe	447365	Humanimal Bat Child	58	4040052
64508169d7107e012d00a754	447365	Humanimal Bat Child	59	4040053
645081712a09bc0106f17c7d	447365	Till	60	1381393
644b3eaafba625052ed598d5	447365	Unsavory Octopus	61	3158773
645081ae6d1bb20150a51b3e	447365	Phyla	62	2651186
645081c26d1bb20171cc0000	447365	Latti	63	4040056
64508254af85de00e723b0f0	447365	Star Child	64	4040059
6450825eaf85de01213f4641	447365	Star Child	65	2437734
64508265af85de015be65c7b	447365	Star Child	66	4038968
6450826dd7107e00ebe028b8	447365	Star Child	67	3325844
64508274e942ee00e258f818	447365	Star Child	68	1907258
64508280e16e5a00e9f031cc	447365	Star Child	69	4040061
64508294d7107e014c6fc1b2	447365	Star Child	70	4040062
645082a693bd690153923bb7	447365	Star Child	71	4040063
645082b0d7107e016b7dc44c	447365	Gridlemop (voice)	72	78021
644dc72df90b19061613380a	447365	Broker	73	8399
645082cc12b10e0141785a7f	447365	Bzermikitokolok	74	1528191
645082d5d7107e010adea0c7	447365	Controller	75	20755
645082ee12b10e00ea4037ac	447365	Murf	76	4040064
644da3b2d4d5090a78f928b3	447365	Yondu Udonta	77	12132
6450830daf85de015be65d02	447365	Lambshank (voice)	78	15218
64508325af85de015be65d20	447365	Phlektik Guard	79	1543993
6450832e2a09bc014020a95a	447365	Grandma Quill	80	167132
644da449f90b1905f4131ed6	447365	Grandpa Quill	81	2518
6450834e12b10e00ea4037ef	447365	Crying Krylorian Citizen	82	1391876
645083566d1bb20150a51c49	447365	Crying Krylorian Citizen	83	1504236
6450835eaf85de00e23579f3	447365	Crying Krylorian Citizen	84	53266
64508369af85de00e723b1a6	447365	Crying Krylorian Citizen	85	4040065
64508374e16e5a0123a4512a	447365	Crying Krylorian Citizen	86	4040066
644dc7446beaea02fb2b7558	447365	Howard the Duck (voice)	87	13922
64555f375b370d00e3c655f1	447365	Phlektik	88	1427948
5b88a3dbc3a3682e5c0033be	545611	Evelyn Wang	0	1620
5e28fed81685da0017e21bae	545611	Waymond Wang	1	690
5e28fe934ca676001742aa3c	545611	Joy Wang / Jobu Tupaki	2	1381186
5e28feaf4ca676001241eedd	545611	Gong Gong	3	20904
5e28fee898f1f1000ff545cf	545611	Deirdre Beaubeirdre	4	8944
621a628dafa1b0001e298c86	545611	Becky Sregor	5	1071151
61c4940319ab590096991521	545611	Debbie the Dog Mom	6	213001
621a624389d97f0043962c89	545611	Chad	7	232499
621a625479a1c30043fed706	545611	Rick	8	1367122
621a62667b7b4d001bd3f8c7	545611	TV Musical - Queen	9	1375002
621a6274f1b5710042cc0399	545611	TV Musical - Soldier	10	964421
6212b5744813820043819d3a	545611	Alpha Jumper - Trophy	11	2410189
6212b5250e4fc800440a6af7	545611	Alpha Jumper - Bigger Trophy	12	1068877
621a6d893c4344004280dcde	545611	Security Guard	13	3444951
621a6d959c24fc0043df7ac5	545611	Security Guard	14	3341013
621a6da1a88587001bf41837	545611	Security Guard	15	1334321
5edc572ab42242002191b480	545611	Police - Confetti	16	202930
6421b6236a34480086261348	545611	Police - Salsa	17	1535095
621a62bd79a1c3006b95681a	545611	Police - Luchador	18	1310386
621a6d50dd926a001b3b4873	545611	Alpha Jumper - Jogger	19	2899647
62bebe58e640d6005b3d6e39	545611	Alpha Jumper - Edgelord	20	1099428
621a6d742a210c00438c6d7e	545611	Alpha Jumper - SWAT	21	1272901
5edc57361dcb770020036b09	545611	Alpha RV Officer	22	1561485
5edc57418d52c90022a4078e	545611	Alpha RV Officer	23	86170
627a2730a7e3630e229b21dd	545611	Kung Fu Master	24	3543715
621a62f190cf510018aac6b2	545611	Young Boy Waymond	25	2883298
621a6e64f1b571001b472f1d	545611	Maternity Doctor	26	1101375
621a6e454e4dff006348d69b	545611	Laundromat Police	27	1367516
621a621c7b7b4d006c87c76f	545611	District Manager	28	1317730
621a6ced79a1c30043ff024a	545611	Kung Fu Competitor / Co-Star	29	62426
621a6e334e4dff006348d663	545611	Opera Evelyn (voice)	30	3444959
621a6dd119ab59001c734b8e	545611	Raccacoonie Puppeteer	31	403314
621a6dde2a210c00438c6f60	545611	Raccacoonie Puppeteer	32	2019612
621a6e05dd926a0042254cee	545611	Raccacoonie Puppeteer	33	1394743
62542bda2f1be038ab7271a0	545611	Raccacoonie (voice) (uncredited)	34	7885
64017f569653f600db29801b	545611	Mugger (uncredited)	35	1383612
63a37d9a435011009f7486cf	545611	Lunch Lady (uncredited)	36	1253106
63a37da6325a5100a00c3b14	545611	Movie Theater Goer (uncredited)	37	3840579
63a37df893db9200870db1f0	545611	Chinese Choir / Movie Producer (uncredited)	38	1200895
63a37e1a4350110093c0a7b9	545611	Dominatrix (uncredited)	39	3446125
63a37e42435011009f7486ec	545611	Pedestrian (uncredited)	40	1593376
63a37e4c20ecaf00b3b7a301	545611	Chinese Choir (uncredited)	41	1466559
63a37e5520ecaf009fef6e9f	545611	Mei Li (uncredited)	42	3169828
\.


--
-- Data for Name: ethnicities; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.ethnicities (id, name, region_id, subregion_id) FROM stdin;
1	French	5	25
2	Persian	4	24
3	Abruzzi	\N	\N
4	Acadian	\N	\N
5	Aden	\N	\N
6	Afghan	\N	\N
7	African	\N	\N
8	African American	\N	\N
9	African Islands	\N	\N
10	Afrikaner	\N	\N
11	Afro	\N	\N
12	Afro-American	\N	\N
13	Agikuyu	\N	\N
14	Akan	\N	\N
15	Aland Islander	\N	\N
16	Alaska Athabascan	\N	\N
17	Alaska Native	\N	\N
18	Albanian	\N	\N
19	Aleut	\N	\N
20	Algerian	\N	\N
21	Alhucemas	\N	\N
22	Alsatian	\N	\N
23	Amalfi	\N	\N
24	Amara	\N	\N
25	Amazigh	\N	\N
26	Amerasian	\N	\N
27	American Indian	\N	\N
28	American Samoan	\N	\N
29	Amerindian	\N	\N
30	Andalusian	\N	\N
31	Andaman Islander	\N	\N
32	Andhra Pradesh	\N	\N
33	Andorran	\N	\N
34	Anglo	\N	\N
35	Angolan	\N	\N
36	Anguilla Islander	\N	\N
37	Antiguan	\N	\N
38	Apache	\N	\N
39	Appalachian	\N	\N
40	Apulian	\N	\N
41	Arab	\N	\N
42	Arapaho	\N	\N
43	Arawak	\N	\N
44	Argentinean	\N	\N
45	Armenian	\N	\N
46	Aruba Islander	\N	\N
47	Aryan	\N	\N
48	Asian	\N	\N
49	Assamese	\N	\N
50	Assiniboine Sioux	\N	\N
51	Assyrian	\N	\N
52	Asturian	\N	\N
53	Australian	\N	\N
54	Australian Aborigine	\N	\N
55	Austrian	\N	\N
56	Azerbaijani	\N	\N
57	Azeri	\N	\N
58	Azorean	\N	\N
59	Baggara	\N	\N
60	Bahamian	\N	\N
61	Bahraini	\N	\N
62	Bajan	\N	\N
63	Balearic Islander	\N	\N
64	Baluchi	\N	\N
65	Bamar	\N	\N
66	Bangladeshi	\N	\N
67	Bantu	\N	\N
68	Barbadian	\N	\N
69	Bashkir	\N	\N
70	Basilicata	\N	\N
71	Basque	\N	\N
72	Bavarian	\N	\N
73	Bedouin	\N	\N
74	Belarusian	\N	\N
75	Belgian	\N	\N
76	Belizean	\N	\N
77	Belorussian	\N	\N
78	Bengali	\N	\N
79	Benin	\N	\N
80	Berber	\N	\N
81	Berliner	\N	\N
82	Bermudan	\N	\N
83	Bessarabian	\N	\N
84	Bhutanese	\N	\N
85	Bioko	\N	\N
86	Black	\N	\N
87	Black Thai	\N	\N
88	Blackfeet	\N	\N
89	Bohemian	\N	\N
90	Bolivian	\N	\N
91	Borneo	\N	\N
92	Bosniak	\N	\N
93	Bosnian	\N	\N
94	Botswana	\N	\N
95	Brazilian	\N	\N
96	Breton	\N	\N
97	British	\N	\N
98	British Isles	\N	\N
99	British Virgin Islander	\N	\N
100	British West Indian	\N	\N
101	Briton	\N	\N
102	Bucovina	\N	\N
103	Bulgarian	\N	\N
104	Burman	\N	\N
105	Burmese	\N	\N
106	Burundian	\N	\N
107	Cabo Verdean	\N	\N
108	Cajun	\N	\N
109	Calabrian	\N	\N
110	Californio	\N	\N
111	Cambodian	\N	\N
112	Cameroonian	\N	\N
113	Campbell Islander	\N	\N
114	Canadian	\N	\N
115	Canadian American Indian	\N	\N
116	Canal Zone	\N	\N
117	Canary Islander	\N	\N
118	Cantonese	\N	\N
119	Cape Verdean	\N	\N
120	Caribbean	\N	\N
121	Caroline Islander	\N	\N
122	Carpathian	\N	\N
123	Carpatho Rusyn	\N	\N
124	Castillian	\N	\N
125	Catalonian	\N	\N
126	Cayenne	\N	\N
127	Cayman Islander	\N	\N
128	Celtic	\N	\N
129	Central African	\N	\N
130	Central American	\N	\N
131	Central European	\N	\N
132	Chadian	\N	\N
133	Chamolinian	\N	\N
134	Chamorro Islander	\N	\N
135	Channel Islander	\N	\N
136	Cherokee	\N	\N
137	Chevash	\N	\N
138	Cheyenne	\N	\N
139	Chicano	\N	\N
140	Chickasaw	\N	\N
141	Chilean	\N	\N
142	Chinese	\N	\N
143	Chippewa	\N	\N
144	Chippewa-Cree Indians of the Rocky Boy's Reservation	\N	\N
145	Choctaw	\N	\N
146	Christmas Islander	\N	\N
147	Chumash	\N	\N
148	Chuukese	\N	\N
149	Colombian	\N	\N
150	Colored	\N	\N
151	Colville	\N	\N
152	Comanche	\N	\N
153	Comanche Nation	\N	\N
154	Confederated Salish and Kootenai Tribes of the Flathead Nation	\N	\N
155	Confederated Tribes and Bands of the Yakama Nation	\N	\N
156	Confederated Tribes of the Colville Reservation	\N	\N
157	Congo-Brazzaville	\N	\N
158	Congolese	\N	\N
159	Cook Islander	\N	\N
160	Cornish	\N	\N
161	Corsican	\N	\N
162	Corsico Islander	\N	\N
163	Cossack	\N	\N
164	Costa Rican	\N	\N
165	Cree	\N	\N
166	Creek	\N	\N
167	Creole	\N	\N
168	Cretan	\N	\N
169	Crimean	\N	\N
170	Criollo	\N	\N
171	Croatian	\N	\N
172	Crow	\N	\N
173	Crow Tribe of Montana	\N	\N
174	Cuban	\N	\N
175	Cuban American	\N	\N
176	Cycladic Islander	\N	\N
177	Cypriot	\N	\N
178	Czech	\N	\N
179	Czechoslovakian	\N	\N
180	Danish	\N	\N
181	Dinka	\N	\N
182	District of Columbia	\N	\N
183	Djibouti	\N	\N
184	Dominica Islander	\N	\N
185	Dominican	\N	\N
186	Dutch	\N	\N
187	Dutch West Indian	\N	\N
188	East African	\N	\N
189	East German	\N	\N
190	East Indian	\N	\N
191	Eastern Archipelago	\N	\N
192	Eastern Cherokee	\N	\N
193	Eastern European	\N	\N
194	Eastern Tribes	\N	\N
195	Ecuadorian	\N	\N
196	Egyptian	\N	\N
197	Emilia Romagna	\N	\N
198	English	\N	\N
199	Equatorial Guinea	\N	\N
200	Eritrean	\N	\N
201	Eskimo	\N	\N
202	Estonian	\N	\N
203	Ethiopian	\N	\N
204	Eurasian	\N	\N
205	European	\N	\N
206	Faeroe Islander	\N	\N
207	Fijian	\N	\N
208	Filipino	\N	\N
209	Finnish	\N	\N
210	Finno Ugrian	\N	\N
211	Fleming	\N	\N
212	Florida	\N	\N
213	Formosan	\N	\N
214	French Basque	\N	\N
215	French Canadian	\N	\N
216	French Samoan	\N	\N
217	French West Indies	\N	\N
218	Frisian	\N	\N
219	Friulian	\N	\N
220	Fulani	\N	\N
221	Fur	\N	\N
222	Gabonese	\N	\N
223	Gagauz	\N	\N
224	Galician	\N	\N
225	Gallego	\N	\N
226	Gambian	\N	\N
227	Gazan	\N	\N
228	Georgian	\N	\N
229	German	\N	\N
230	Germanic	\N	\N
231	Ghanaian	\N	\N
232	Gibraltan	\N	\N
233	Goanese	\N	\N
234	Gosei	\N	\N
235	Greek	\N	\N
236	Greek Cypriote	\N	\N
237	Greenlander	\N	\N
238	Grenadian	\N	\N
239	Gruziia	\N	\N
240	Guadeloupe Islander	\N	\N
241	Guamanian	\N	\N
242	Guatemalan	\N	\N
243	Guinea Bissau	\N	\N
244	Guinean	\N	\N
245	Gujarati	\N	\N
246	Guyanese	\N	\N
247	Haitian	\N	\N
248	Hall Islander	\N	\N
249	Hamburger	\N	\N
250	Hanoverian	\N	\N
251	Hausa	\N	\N
252	Hawaiian	\N	\N
253	Hessian	\N	\N
254	Hispanic	\N	\N
255	Hmong	\N	\N
256	Honduran	\N	\N
257	Hong Kong	\N	\N
258	Hopi	\N	\N
259	Hungarian	\N	\N
260	Husel	\N	\N
261	Ibo	\N	\N
262	Icelander	\N	\N
263	Ifni	\N	\N
264	India	\N	\N
265	Indian	\N	\N
266	Indochinese	\N	\N
267	Indonesian	\N	\N
268	Inuit	\N	\N
269	Inupiat	\N	\N
270	Inupiat Eskimo	\N	\N
271	Iranian	\N	\N
272	Iraqi	\N	\N
273	Irish	\N	\N
274	Iroquois	\N	\N
275	Israeli	\N	\N
276	Issei	\N	\N
277	Italian	\N	\N
278	Ivoirian	\N	\N
279	Jamaican	\N	\N
280	Japanese	\N	\N
281	Javanese	\N	\N
282	Jebel Druse	\N	\N
283	Jewish	\N	\N
284	Jordanian	\N	\N
285	Kalmyk	\N	\N
286	Kapinagamarangan	\N	\N
287	Karelian	\N	\N
288	Karnatakan	\N	\N
289	Kashmiri	\N	\N
290	Kashubian	\N	\N
291	Katu	\N	\N
292	Kazakh	\N	\N
293	Kazakhstani	\N	\N
294	Kenyan	\N	\N
295	Keralan	\N	\N
296	Keres	\N	\N
297	Kermadec Islander	\N	\N
298	Khmer	\N	\N
299	Kinh	\N	\N
300	Kiowa	\N	\N
301	Kirghiz	\N	\N
302	Kiribatese	\N	\N
303	Kittitian	\N	\N
304	Kitts	\N	\N
305	Korean	\N	\N
306	Kosraean	\N	\N
307	Kurdish	\N	\N
308	Kuria Muria Islander	\N	\N
309	Kuwaiti	\N	\N
310	La Raza	\N	\N
311	Ladin	\N	\N
312	Lamotrekese	\N	\N
313	Lao Loum	\N	\N
314	Laotian	\N	\N
315	Lapp	\N	\N
316	Latakian	\N	\N
317	Latin	\N	\N
318	Latin American	\N	\N
319	Latin American Indian	\N	\N
320	Latino	\N	\N
321	Latvian	\N	\N
322	Lebanese	\N	\N
323	Lemko	\N	\N
324	Lesotho	\N	\N
325	Liberian	\N	\N
326	Libyan	\N	\N
327	Liechtensteiner	\N	\N
328	Ligurian	\N	\N
329	Lithuanian	\N	\N
330	Livonian	\N	\N
331	Lombardian	\N	\N
332	Lorrainian	\N	\N
333	Lubecker	\N	\N
334	Luiseno	\N	\N
335	Lumbee	\N	\N
336	Lumbee Indian	\N	\N
337	Luxemburger	\N	\N
338	Ma	\N	\N
339	Macao	\N	\N
340	Macedonian	\N	\N
341	Madagascan	\N	\N
342	Madeiran	\N	\N
343	Madhya Pradesh	\N	\N
344	Madrasi	\N	\N
345	Magyar	\N	\N
346	Maharashtran	\N	\N
347	Malawian	\N	\N
348	Malay	\N	\N
349	Malaysian	\N	\N
350	Maldivian	\N	\N
351	Malian	\N	\N
352	Maltese	\N	\N
353	Manchurian	\N	\N
354	Mandarin	\N	\N
355	Manx	\N	\N
356	Maori	\N	\N
357	Marches	\N	\N
358	Marshall Islander	\N	\N
359	Marshallese	\N	\N
360	Mauritanian	\N	\N
361	Mauritius	\N	\N
362	Melanesian	\N	\N
363	Melanesian Islander	\N	\N
364	Mende	\N	\N
365	Menominee Indian	\N	\N
366	Meo	\N	\N
367	Mesknetian	\N	\N
368	Mestizo	\N	\N
369	Mexican	\N	\N
370	Micmac	\N	\N
371	Micronesian	\N	\N
372	Middle Eastern	\N	\N
373	Midway Islander	\N	\N
374	Mnong	\N	\N
375	Mohawk	\N	\N
376	Mokilese	\N	\N
377	Moldovan	\N	\N
378	Molise	\N	\N
379	Monegasque	\N	\N
380	Mongolian	\N	\N
381	Montagnard	\N	\N
382	Montenegrin	\N	\N
383	Montserrat Islander	\N	\N
384	Moor	\N	\N
385	Moravian	\N	\N
386	Mordovian	\N	\N
387	Moroccan	\N	\N
388	Mortlockese	\N	\N
389	Mozambican	\N	\N
390	Mulatto	\N	\N
391	Muscat	\N	\N
392	Muscogee (Creek) Nation	\N	\N
393	Muscovite	\N	\N
394	Mysore	\N	\N
395	Naga	\N	\N
396	Namanouito	\N	\N
397	Namibian	\N	\N
398	Natalian	\N	\N
399	Native American	\N	\N
400	Native Hawaiian	\N	\N
401	Nauruan	\N	\N
402	Navajo	\N	\N
403	Navajo Nation	\N	\N
404	Neapolitan	\N	\N
405	Nepalese	\N	\N
406	New Caledonian Islander	\N	\N
407	New Guinean	\N	\N
408	New Zealander	\N	\N
409	Newfoundland	\N	\N
410	Ngatikese	\N	\N
411	Nicaraguan	\N	\N
412	Niger	\N	\N
413	Nigerian	\N	\N
414	Nisei	\N	\N
415	Niuean	\N	\N
416	Norfolk Islander	\N	\N
417	North African	\N	\N
418	North Borneo	\N	\N
419	North Caucasian	\N	\N
420	North Caucasian Turkic	\N	\N
421	Northern Marianas	\N	\N
422	Norwegian	\N	\N
423	Nova Scotian	\N	\N
424	Nuer	\N	\N
425	Nuevo Mexicano	\N	\N
426	Nukuoroan	\N	\N
427	Occitan	\N	\N
428	Oceania	\N	\N
429	Oglala Sioux	\N	\N
430	Okinawan	\N	\N
431	Oklahoma Choctaw	\N	\N
432	Omani	\N	\N
433	Oneida Nation of New York	\N	\N
434	Oneida Tribe of Indians of Wisconsin	\N	\N
435	Orissa	\N	\N
436	Oromo	\N	\N
437	Osage	\N	\N
438	Ossetian	\N	\N
439	Ottawa	\N	\N
440	Pacific Islander	\N	\N
441	Paiute	\N	\N
442	Pakistani	\N	\N
443	Palauan	\N	\N
444	Palestinian	\N	\N
445	Panamanian	\N	\N
446	Papuan	\N	\N
447	Paraguayan	\N	\N
448	Pashtun	\N	\N
449	Pennsylvania German	\N	\N
450	Peruvian	\N	\N
451	Phoenix Islander	\N	\N
452	Piedmontese	\N	\N
453	Pima	\N	\N
454	Pingelapese	\N	\N
455	Polish	\N	\N
456	Polynesian	\N	\N
457	Pomeranian	\N	\N
458	Pomo	\N	\N
459	Ponapean	\N	\N
460	Pondicherry	\N	\N
461	Portuguese	\N	\N
462	Potawatomi	\N	\N
463	Providencia	\N	\N
464	Prussian	\N	\N
465	Pueblo	\N	\N
466	Puerto Rican	\N	\N
467	Puget Sound Salish	\N	\N
468	Puglia	\N	\N
469	Pulawatese	\N	\N
470	Punjabi	\N	\N
471	Qatar	\N	\N
472	Quechua	\N	\N
473	Rajasthani	\N	\N
474	Rio de Oro	\N	\N
475	Rom	\N	\N
476	Romani	\N	\N
477	Romanian	\N	\N
478	Romansch	\N	\N
479	Romanscho	\N	\N
480	Rome	\N	\N
481	Rosebud Sioux	\N	\N
482	Rumanian	\N	\N
483	Russian	\N	\N
484	Rusyn	\N	\N
485	Ruthenian	\N	\N
486	Rwandan	\N	\N
487	Ryukyu Islander	\N	\N
488	Sac and Fox	\N	\N
489	Saint Lucian	\N	\N
490	Saipanese	\N	\N
491	Salvadoran	\N	\N
492	Samoan	\N	\N
493	San Andres	\N	\N
494	San Carlos Apache	\N	\N
495	San Marino	\N	\N
496	Sansei	\N	\N
497	Sardinian	\N	\N
498	Saudi Arabian	\N	\N
499	Sault Ste. Marie Chippewa	\N	\N
500	Saxon	\N	\N
501	Scandinavian	\N	\N
502	Scottish	\N	\N
503	Seminole	\N	\N
504	Seneca	\N	\N
505	Senegalese	\N	\N
506	Serbian	\N	\N
507	Shan	\N	\N
508	Shawnee	\N	\N
509	Shona	\N	\N
510	Shoshone	\N	\N
511	Sicilian	\N	\N
512	Sierra Leonean	\N	\N
513	Sikkim	\N	\N
514	Silesian	\N	\N
515	Singaporean	\N	\N
516	Singhalese	\N	\N
517	Sioux	\N	\N
518	Slavic	\N	\N
519	Slavonian	\N	\N
520	Slovak	\N	\N
521	Slovenian	\N	\N
522	Solomon Islander	\N	\N
523	Somalian	\N	\N
524	Sorb	\N	\N
525	South African	\N	\N
526	Soviet Turkic	\N	\N
527	Soviet	\N	\N
528	Spaniard	\N	\N
529	Spanish	\N	\N
530	Spanish American	\N	\N
531	Spanish Basque	\N	\N
532	Sri Lankan	\N	\N
533	St. Christopher	\N	\N
534	St. Croix Islander	\N	\N
535	St. John Islander	\N	\N
536	St. Lucia Islander	\N	\N
537	St. Maarten Islander	\N	\N
538	St. Thomas Islander	\N	\N
539	St. Vincent Islander	\N	\N
540	St. Vincent and Grenadine Islander	\N	\N
541	Subsaharan African	\N	\N
542	Sudanese	\N	\N
543	Sudetenlander	\N	\N
544	Suisse	\N	\N
545	Sumatran	\N	\N
546	Surinamese	\N	\N
547	Surinamese	\N	\N
548	Swaziland	\N	\N
549	Swedish	\N	\N
550	Swiss	\N	\N
551	Switzer	\N	\N
552	Syrian	\N	\N
553	Tadzhik	\N	\N
554	Tagalog	\N	\N
555	Tahitian	\N	\N
556	Taiwanese	\N	\N
557	Tamil	\N	\N
558	Tanganyikan	\N	\N
559	Tanzanian	\N	\N
560	Tarawa Islander	\N	\N
561	Tartar	\N	\N
562	Tasmanian	\N	\N
563	Tatar	\N	\N
564	Tejano	\N	\N
565	Temne	\N	\N
566	Teton Sioux	\N	\N
567	Thai	\N	\N
568	Three Affiliated Tribes of North Dakota	\N	\N
569	Tibetan	\N	\N
570	Ticino	\N	\N
571	Tigrinya	\N	\N
572	Tinian Islander	\N	\N
573	Tirolean	\N	\N
574	Tiv	\N	\N
575	Tlingit	\N	\N
576	Tlingit-Haida	\N	\N
577	Tobagonian	\N	\N
578	Togolese	\N	\N
579	Tohono O'Odham	\N	\N
580	Tokelauan	\N	\N
581	Tongan	\N	\N
582	Transjordan	\N	\N
583	Transylvanian	\N	\N
584	Trentino	\N	\N
585	Trieste	\N	\N
586	Trinidadian	\N	\N
587	Trucial Oman	\N	\N
588	Truk Islander	\N	\N
589	Trust Territory of the Pacific Islands	\N	\N
590	Tsimshian	\N	\N
591	Tunisian	\N	\N
592	Turcoman	\N	\N
593	Turkestani	\N	\N
594	Turkish Cypriote	\N	\N
595	Turkish	\N	\N
596	Turks and Caicos Islander	\N	\N
597	Turtle Mountain	\N	\N
598	Tuscan	\N	\N
599	Tuvinian	\N	\N
600	U.S. Virgin Islander	\N	\N
601	Udmurt	\N	\N
602	Ugandan	\N	\N
603	Ukrainian	\N	\N
604	Ulithian	\N	\N
605	Umbrian	\N	\N
606	Emirati	\N	\N
607	United Houma Nation	\N	\N
608	Upper Voltan	\N	\N
609	Uruguayan	\N	\N
610	Ute	\N	\N
611	Uttar Pradesh	\N	\N
612	Uzbek	\N	\N
613	Uzbekistani	\N	\N
614	Valencian	\N	\N
615	Valle d'Aosta	\N	\N
616	Vanuatuan	\N	\N
617	Veddah	\N	\N
618	Venetian	\N	\N
619	Venezuelan	\N	\N
620	Vietnamese	\N	\N
621	Volga	\N	\N
622	Volta	\N	\N
623	Voytak	\N	\N
624	Wake Islander	\N	\N
625	Wallachian	\N	\N
626	Walloon	\N	\N
627	Welsh	\N	\N
628	West African	\N	\N
629	West Bank	\N	\N
630	West German	\N	\N
631	West Indian	\N	\N
632	Western European	\N	\N
633	Western Lao	\N	\N
634	Westphalian	\N	\N
635	White Mountain Apache	\N	\N
636	Windish	\N	\N
637	Woleaian	\N	\N
638	Yakama	\N	\N
639	Yakut	\N	\N
640	Yap Islander	\N	\N
641	Yaqui	\N	\N
642	Yemeni	\N	\N
643	Yonsei	\N	\N
644	Yoruba	\N	\N
645	Yugoslavian	\N	\N
646	Yuman	\N	\N
647	Yupik	\N	\N
648	Zairian	\N	\N
649	Zambian	\N	\N
650	Zanzibar Islander	\N	\N
651	Zimbabwean	\N	\N
652	Zulu	\N	\N
653	Zuni	\N	\N
654	Ojibwe (Saulteaux)	2	12
655	Icelandic	5	14
\.


--
-- Data for Name: genders; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.genders (id, name) FROM stdin;
0	Unknown
1	Female
2	Male
3	Non-Binary
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.genres (id, name) FROM stdin;
28	Action
12	Adventure
16	Animation
35	Comedy
80	Crime
99	Documentary
18	Drama
10751	Family
14	Fantasy
36	History
27	Horror
10402	Music
9648	Mystery
10749	Romance
878	Science Fiction
10770	TV Movie
53	Thriller
10752	War
37	Western
\.


--
-- Data for Name: media_genres; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.media_genres (id, genre_id, movie_id) FROM stdin;
1	18	600583
2	36	600583
3	37	600583
4	18	777270
5	18	776503
6	10402	776503
7	10749	776503
8	878	438631
9	12	438631
10	18	614917
11	36	614917
12	18	718032
13	35	718032
14	53	597208
15	18	591538
16	10752	591538
17	18	511809
18	10749	511809
19	80	511809
62	18	626735
63	35	626735
64	27	30362
65	18	231218
66	18	1038113
67	16	812204
68	35	812204
69	10402	812204
70	10751	812204
71	16	123753
72	18	123753
73	16	1045937
74	16	1054370
75	18	890971
76	10751	585245
77	12	585245
78	35	585245
79	14	585245
80	16	483455
81	28	483455
82	35	483455
83	9648	483455
84	80	483455
85	14	483455
86	10751	583833
87	10749	583833
88	18	8588
89	36	8588
90	16	768726
91	35	768726
92	12	768726
93	10751	768726
94	35	21989
95	10749	21989
96	18	38810
97	35	40096
98	18	40096
99	14	40096
100	12	381289
101	35	381289
102	14	381289
103	10751	381289
104	18	381289
105	28	545611
106	12	545611
107	878	545611
108	27	391058
109	878	447365
110	12	447365
111	28	447365
112	28	118340
113	878	118340
114	12	118340
115	878	283995
116	12	283995
117	28	283995
118	35	283995
119	35	774752
120	878	774752
121	12	774752
122	16	509080
123	10751	509080
124	878	509080
125	16	411948
126	878	624860
127	28	624860
128	12	624860
129	28	603
130	878	603
131	12	604
132	28	604
133	53	604
134	878	604
135	16	33322
136	878	33322
137	53	33322
138	12	605
139	28	605
140	53	605
141	878	605
142	53	21769
143	28	21769
144	16	21769
145	878	21769
146	12	21769
147	99	14543
148	99	221495
149	878	221495
150	878	51767
151	99	647777
152	28	107392
153	12	107392
154	27	107392
155	14	107392
156	99	591955
157	99	696109
158	99	684428
159	28	684428
160	878	684428
161	99	684731
162	99	503880
\.


--
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.movies (id, imdb_id, title, overview, runtime, poster_path, release_date, budget, revenue) FROM stdin;
600583	tt10293406	The Power of the Dog	A domineering but charismatic rancher wages a war of intimidation on his brother's new wife and her teen son, until long-hidden secrets come to light.	128	/kEy48iCzGnp0ao1cZbNeWR6yIhC.jpg	2021-10-25 00:00:00	0	0
777270	tt12789558	Belfast	Buddy is a young boy on the cusp of adolescence, whose life is filled with familial love, childhood hijinks, and a blossoming romance. Yet, with his beloved hometown caught up in increasing turmoil, his family faces a momentous choice: hope the conflict will pass or leave everything they know behind for a new life.	98	/3mInLZyPOVLsZRsBwNHi3UJXXnm.jpg	2021-11-12 00:00:00	25000000	30000000
776503	tt10366460	CODA	As a CODA (Child of Deaf Adults), Ruby is the only hearing person in her deaf family. When the family's fishing business is threatened, Ruby finds herself torn between pursuing her love of music and her fear of abandoning her parents.	112	/BzVjmm8l23rPsijLiNLUzuQtyd.jpg	2021-08-11 00:00:00	10000000	1600000
438631	tt1160419	Dune	Paul Atreides, a brilliant and gifted young man born into a great destiny beyond his understanding, must travel to the most dangerous planet in the universe to ensure the future of his family and his people. As malevolent forces explode into conflict over the planet's exclusive supply of the most precious resource in existence-a commodity capable of unlocking humanity's greatest potential-only those who can conquer their fear will survive.	155	/d5NXSklXo0qyIYkgV94XAgMIckC.jpg	2021-09-15 00:00:00	165000000	402027830
614917	tt9620288	King Richard	The story of how Richard Williams served as a coach to his daughters Venus and Serena, who will soon become two of the most legendary tennis players in history.	145	/qQl0QS5P15vVzUcaP8rAqxbQ6Wp.jpg	2021-11-18 00:00:00	50000000	30000000
718032	tt11271038	Licorice Pizza	The story of Gary Valentine and Alana Kane growing up, running around and going through the treacherous navigation of first love in the San Fernando Valley, 1973.	133	/jD98aUKHQZNAmrk0wQQ9wmNQPnP.jpg	2021-11-26 00:00:00	40000000	27423319
597208	tt7740496	Nightmare Alley	An ambitious carnival man with a talent for manipulating people with a few well-chosen words hooks up with a female psychologist who is even more dangerous than he is.	150	/680klE0dIreQQOyWKFgNnCAJtws.jpg	2021-12-02 00:00:00	60000000	39629195
591538	tt10095582	The Tragedy of Macbeth	Macbeth, the Thane of Glamis, receives a prophecy from a trio of witches that one day he will become King of Scotland. Consumed by ambition and spurred to action by his wife, Macbeth murders his king and takes the throne for himself.	105	/wzQjzBq1ISZHoDKoAlxSWuiL3hO.jpg	2021-12-05 00:00:00	0	176248
511809	tt3581652	West Side Story	Two youngsters from rival New York City gangs fall in love, but tensions between their respective friends build toward tragedy.	157	/myAX5qoD6YVLNGiWpk2wcU66Vfq.jpg	2021-12-08 00:00:00	100000000	74530532
30362	\N	Dog		\N	\N	2009-04-24 00:00:00	\N	\N
231218	\N	Dog	A teenage girl gets ready to go out to meet her boyfriend, despite her mother's loud verbal disapproval of her clothes. She goes out to a deserted area with him and he begins to touch her up and have sex with her, however a dog reveals the true nature of her boyfriend.	\N	/8vvJwtpmqTwAkpDNHfGsphVNxYi.jpg	2001-08-16 00:00:00	\N	\N
1038113	\N	Dog	While driving and filming the landscapes around the road with his cellphone, the clergyman suddenly encounters a drug checkpoint. Officers want to inspect his car with a dog, but he does not allow it because he religiously believes that the dogs are unclean. He crashes on the way. A dog finds him on the road and tries to rescue him, but it does not succeed. Suddenly, his turban falls to the ground. The dog picks it up, puts it in the middle of the road, lies next to it, and waits for help.	\N	/k9r54dqYg5GZdBIO2KZ12G7Ob1v.jpg	2021-09-18 00:00:00	\N	\N
812204	\N	Rock Dog 2: Rock Around the Park	When Bodi and his band 'True Blue' leave Snow Mountain, to tour with pop sensation, Lil' Foxy, they learn that fame comes at a price.	\N	/kETYRGA15L0wkVPugSl8lKmSgFn.jpg	2021-08-05 00:00:00	\N	\N
123753	\N	Dog	A young boy and his father live in a dull, lonely house with the shadow of mourning hanging over them both. The boy misses his mother but gets no comfort from his father's assertions that she went peacefully. This tragedy is added to by the family dog which is looking increasingly unhealthy.	\N	/1V3HCyoEwQbD1vhxISlm7F3rUua.jpg	2001-08-01 00:00:00	\N	\N
1045937	\N	Dog	On how the dog was created	\N	\N	1987-12-31 00:00:00	\N	\N
1054370	\N	Dog	A young man comes to terms with his sexuality and confronts his bully in his home neighbourhood of Merton (London). Specially commissioned for the Southbank Festival of Neighbourhood 2013, adapted from the poem by Richard Scott.	\N	\N	2013-09-30 00:00:00	\N	\N
890971	\N	.dog	Young Dimitris, on the verge of manhood yet very much a child, has romanticized his imprisoned father to mythic proportions. When he gets released after ten years, Dimitris cannot wait to finally know him and make up for lost time. But when his father reveals his true nature, Dimitris must face a great dilemma: will his need of belonging prevail over his sense of justice?	\N	/3SCRCJvwtwZopxO2der0LExcOmu.jpg	2021-11-09 00:00:00	\N	\N
585245	\N	Clifford the Big Red Dog	As Emily struggles to fit in at home and at school, she discovers a small red puppy who is destined to become her best friend. When Clifford magically undergoes one heck of a growth spurt, becomes a gigantic dog and attracts the attention of a genetics company, Emily and her Uncle Casey have to fight the forces of greed as they go on the run across New York City. Along the way, Clifford affects the lives of everyone around him and teaches Emily and her uncle the true meaning of acceptance and unconditional love.	\N	/oifhfVhUcuDjE61V5bS5dfShQrm.jpg	2021-11-10 00:00:00	\N	\N
483455	\N	Bungo Stray Dogs: Dead Apple	A large scale catastrophe is occurring across the planet. Ability users are discovered after the appearance of a mysterious fog, apparently having committed suicide, so the Armed Detective Agency sets out to investigate these mysterious deaths. The case seems to involve an unknown ability user referred to as "Collector," a man who could be the mastermind behind the incident.\r Trust and courage are put to the test in order to save the city of Yokohama and ability users across the world from the grip of Collector where the Armed Detective Agency forms an unlikely partnership with the dangerous Port Mafia.	\N	/7ueB7Kxq2GObp5aDw6rsdzVefzP.jpg	2018-03-03 00:00:00	\N	\N
583833	\N	A Dog Named Palma	The film is inspired by an incredible story of a shepherd dog named Palm who was inadvertently left in the airport by her owner. She befriends nine-year old Nicholas whose mother dies leaving him with a father he barely knows - a pilot who finds the dog at the airport. It's a story of amazing adventures, true friendship and unconditional love.	\N	/3S3Mz9OD5SUwKy7kaqXcWAKUGXY.jpg	2021-03-18 00:00:00	\N	\N
8588	\N	Shooting Dogs	Two westerners, a priest and a teacher find themselves in the middle of the Rwandan genocide and face a moral dilemna. Do they place themselves in danger and protect the refugees, or escape the country with their lives? Based on a true story.	\N	/9xC2yUgqPVvoHykYuigrxLyunya.jpg	2006-03-08 00:00:00	\N	\N
768726	\N	Dogtanian and the Three Muskehounds	France, 17th century, under the reign of Louis XIII. Dogtanian is an impetuous and innocent peasant from Gascony, as well as a skilled swordsman, who travels to Paris with the purpose of making his dream come true: to join the Corps of Muskehounds of the Royal Guard.	\N	/tzc6gzLENIujnRIx7rUjN1FIhn5.jpg	2021-06-25 00:00:00	\N	\N
21989	\N	Hot Dog... The Movie	When a hopeful young American hot-dogger goes pole-to-pole with an arrogant Austrian pro, the snow really starts to fly! But as hot as it is on the mountain, it gets even hotter off when the pro's ex-girlfriend sets her eyes on the new blood. Who'll win the competition and the girl? Only a race to end all races can determine which skier can really cut the mustard!	\N	/qJ4tVNjjapCLigrVJi3ZXNX6xvB.jpg	1984-01-13 00:00:00	\N	\N
626735	tt11252248	Dog	An army ranger and his dog embark on a road trip along the Pacific Coast Highway to attend a friend's funeral.	102	/zHQy4h36WwuCetKS7C3wcT1hkgA.jpg	2022-02-17 00:00:00	20000000	77263354
38810	\N	Dogtooth	Three teenagers are confined to an isolated country estate that could very well be on another planet. The trio spend their days listening to endless homemade tapes that teach them a whole new vocabulary. Any word that comes from beyond their family abode is instantly assigned a new meaning. Hence 'the sea' refers to a large armchair and 'zombies' are little yellow flowers. Having invented a brother whom they claim to have ostracized for his disobedience, the uber-controlling parents terrorize their offspring into submission.	\N	/7nLuUGlH12cegPfR84QX4xIIH9k.jpg	2009-06-01 00:00:00	\N	\N
40096	\N	A Dog's Will	The lively João Grilo and the sly Chicó are poor guys living in the hinterland who cheat a bunch of people in a small in Northeastern Brazil. When they die, they have to be judged by Christ, the Devil and the Virgin Mary before they are admitted to paradise.	\N	/imcOp1kJsCsAFCoOtY5OnPrFbAf.jpg	2000-09-15 00:00:00	\N	\N
381289	\N	A Dog's Purpose	A dog goes on quest to discover his purpose in life over the course of several lifetimes with multiple owners.	\N	/3jcNvhtVQe5Neoffdic39fRactM.jpg	2017-01-19 00:00:00	\N	\N
494422	\N	Dog	United States / Mexico 1974, Super 8 transferred to digital, colour, silent, 3 min	\N	/30aotVEpqkoN5wdHr8J2ML47S76.jpg	1974-12-24 00:00:00	\N	\N
687558	\N	Female War: Doggie's Uprising	There is a visitor for local herb gatherer Doggie who has no particular need or greed for anything. His friend Chang-guk who is wanted to failure in his business and his captivating wife Seon-hwa come to see Doggie who has no choice but to give them a place to hide. The three of them end up living umcomfortably together. Will Doggie be able to suppress his desires for his friend's wife? And what is her secret that Doggie must never know?	\N	/pUnZK0uumzFD068kdcHMBTj9YQq.jpg	2016-03-24 00:00:00	\N	\N
391058	\N	Screams of Monday	A group of students of the environmental engineering career go to the neighborhood of the Monday River to do a job, during the night they hear a scream, Viviana (the protagonist) witnesses a moment that will unleash an overwhelming situation in her life that will guide her At the origin of that cry, Barbara and Jose will encounter an abnormal situation that will lead them to seek help in pseudo-science, Viviana's parents will seek explanations for the strange events that circulate Viviana's life.	\N	/51YrjxdcH9fVPg9oqA68DuD84qM.jpg	2016-04-01 00:00:00	\N	\N
603	\N	The Matrix	Set in the 22nd century, The Matrix tells the story of a computer hacker who joins a group of underground insurgents fighting the vast and powerful computers who now rule the earth.	\N	/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg	1999-03-30 00:00:00	\N	\N
604	\N	The Matrix Reloaded	Six months after the events depicted in The Matrix, Neo has proved to be a good omen for the free humans, as more and more humans are being freed from the matrix and brought to Zion, the one and only stronghold of the Resistance.  Neo himself has discovered his superpowers including super speed, ability to see the codes of the things inside the matrix and a certain degree of pre-cognition. But a nasty piece of news hits the human resistance: 250,000 machine sentinels are digging to Zion and would reach them in 72 hours. As Zion prepares for the ultimate war, Neo, Morpheus and Trinity are advised by the Oracle to find the Keymaker who would help them reach the Source.  Meanwhile Neo's recurrent dreams depicting Trinity's death have got him worried and as if it was not enough, Agent Smith has somehow escaped deletion, has become more powerful than before and has fixed Neo as his next target.	\N	/9TGHDvWrqKBzwDxDodHYXEmOE6J.jpg	2003-05-15 00:00:00	\N	\N
118340	\N	Guardians of the Galaxy	Light years from Earth, 26 years after being abducted, Peter Quill finds himself the prime target of a manhunt after discovering an orb wanted by Ronan the Accuser.	\N	/r7vmZjiyZw9rpJMQJdXpjgiCOk9.jpg	2014-07-30 00:00:00	\N	\N
283995	\N	Guardians of the Galaxy Vol. 2	The Guardians must fight to keep their newfound family together as they unravel the mysteries of Peter Quill's true parentage.	\N	/y4MBh0EjBlMuOzv9axM4qJlmhzz.jpg	2017-04-19 00:00:00	\N	\N
774752	\N	The Guardians of the Galaxy Holiday Special	On a mission to make Christmas unforgettable for Quill, the Guardians head to Earth in search of the perfect present.	\N	/8dqXyslZ2hv49Oiob9UjlGSHSTR.jpg	2022-11-25 00:00:00	\N	\N
509080	\N	LEGO Marvel Super Heroes: Guardians of the Galaxy - The Thanos Threat	The Guardians are on a mission to deliver the Build Stone to the Avengers before the Ravagers, Thanos and his underlings steal it from them.	\N	/e5h1RlnQzjgEAh4s96k50S8XkKa.jpg	2017-12-09 00:00:00	\N	\N
33322	\N	Armitage III: Poly Matrix	Ross Sylibus is assigned to a police unit on a Martian colony, to find that women are being murdered by a psychotic named D'anclaude. He is assigned a very unorthodox partner named Naomi Armitage, who seems to have links to the victims. To stir things up more, every victim is found to be an illegally made third-generation android.	\N	/7sUCRdjGe7VggDCGIHywfguYdAK.jpg	1996-06-25 00:00:00	\N	\N
605	\N	The Matrix Revolutions	The human city of Zion defends itself against the massive invasion of the machines as Neo fights to end the war at another front while also opposing the rogue Agent Smith.	\N	/qEWiBXJGXK28jGBAm8oFKKTB0WD.jpg	2003-11-05 00:00:00	\N	\N
21769	\N	Armitage: Dual Matrix	Naomi Armitage and Ross Sylibus have changed their names and live with their daughter Yoko as a happy and normal family on Mars — until an android riot breaks out at an anti-matter plant on Earth.	\N	/p5nd9VPKxpow5MFAQfZy2DEatPI.jpg	2002-03-22 00:00:00	\N	\N
14543	\N	The Matrix Revisited	The film goes behind the scenes of the 1999 sci-fi movie The Matrix.	\N	/8yxSztoc5sqZiGuKcFuVOh65B6Y.jpg	2001-11-19 00:00:00	\N	\N
221495	\N	The Matrix Recalibrated	The making of Matrix Revolutions, The (2003) is briefly touched on here in this documentary. Interviews with various cast and crew members inform us how they were affected by the deaths of Gloria Foster and Aaliyah, and also delve into the making of the visual effects that takes up a lot of screen time. Written by Rhyl Donnelly	\N	/gRni1Q651AZPnLqZczmahiIxG0s.jpg	2004-04-06 00:00:00	\N	\N
411948	\N	Matrix	A piece of abstract cinema by John Whitney. A series squares follow a 3-dimensional track, each one with a slight delay after the other.	\N	/wwGvUPEM6MRiXv3gRNaVUlUCHiT.jpg	1971-05-18 00:00:00	\N	\N
624860	\N	The Matrix Resurrections	Plagued by strange memories, Neo's life takes an unexpected turn when he finds himself back inside the Matrix.	\N	/8c4a8kE7PizaGQQnditMmI1xbRp.jpg	2021-12-16 00:00:00	\N	\N
51767	\N	Sexual Matrix	A professor designing a machine designed to meet the naughtiest fantasies. In order to perfect the discovery, he performed tests on various subjects, aided by his very appealing assistant.	\N	/vmhBIPKyYCWlp2PrIIc6EXZlP9Z.jpg	2000-04-01 00:00:00	\N	\N
545611	tt6710474	Everything Everywhere All at Once	An aging Chinese immigrant is swept up in an insane adventure, where she alone can save what's important to her by connecting with the lives she could have led in other universes.	140	/w3LxiVYdWWRvEVdn5RYq6jIqkb1.jpg	2022-03-24 00:00:00	25000000	139200000
647777	\N	Exit The Matrix	In the Absheron region of the Krasnodar Territory, among the majestic Caucasus Mountains and impenetrable forests, small villages were lost. They are connected to the rest of the world only by a thin thread of a narrow gauge railway winding through the gorges - and this is the only way from there and the only way there. A small old trolley - a motor-car, nicknamed by the locals "Matrix", delivers food, fuel and other benefits of civilization every day. People who, for one reason or another, prefer loneliness and unity with nature to noisy city life, make their journey on it.	\N	/6K8XMPENGGht4MGfbOaKy8fOHwj.jpg	2019-09-03 00:00:00	\N	\N
107392	\N	Chess Boxing Matrix	Action packed vampire kung fu movie produced by Joseph Kuo. Jack Long portrays a fighting Taoist priest, who helps with the aid of his disciples to reunite a baby vampire with his parents from the "King of Evil", who has captured the young hopper to enhance his own powers.	\N	/iq8zeotrIDwjViRgnISwEwHJQ87.jpg	1988-12-09 00:00:00	\N	\N
591955	\N	The Matrix Reloaded Revisited	The making of The Matrix Reloaded:  Go to the middle movie's furthest reaches via five documentary paths revealing 21 featurettes.	\N	/gb7C4oRzYWXWCuZMR1cwtHa53Pz.jpg	2004-12-07 00:00:00	\N	\N
696109	\N	A Glitch in the Matrix	Are we in fact living in a simulation? This is the question postulated, wrestled with, and ultimately argued for through archival footage, compelling interviews with real people shrouded in digital avatars, and a collection of cases from some of our most iconoclastic figures in contemporary culture.	\N	/bn0BLVadmvzq6MmJ0n97MLxGpNQ.jpg	2021-02-05 00:00:00	\N	\N
684428	\N	The Matrix: What Is Bullet-Time?	Special Effects wizard John Gaeta demonstrates how the "Bullet-Time" effects were created for the film Matrix, The (1999).	\N	/hSTervHaROcTd8Ir3DPfepN80dL.jpg	1999-09-21 00:00:00	\N	\N
684731	\N	The Matrix Reloaded: Pre-Load	This making-of piece offers the standard mix of movie snippets, behind the scenes materials, and interviews from cast and crew on the making of the film.	\N	\N	2003-10-14 00:00:00	\N	\N
503880	\N	The Matrix Revolutions Revisited	The making of The Matrix Revolutions:  The cataclysmic final confrontation chronicled through six documentary pods revealing 28 featurettes	\N	/61ASnmqvzpuz9VEfFElo3e2nIft.jpg	2004-12-07 00:00:00	\N	\N
555879	\N	Matrix	The film is composed of receding planes in a landscape: a back garden and the houses beyond. The wooden lattice fence, visible in the image, marks the border between enclosed and open, private and public space, and forms both a fulcrum for the work and a formal grid by which the shots are framed and organised.	\N	/AfFD10ZqEx2vkxM2yvRZkybsGB7.jpg	1998-12-31 00:00:00	\N	\N
373223	\N	Matrix	Abstract art film made for gallery exhibition.	\N	/wx2s9xYeC6uP2auuuVg99yl4RpU.jpg	1973-09-06 00:00:00	\N	\N
775293	\N	Matrix	"MATRIX is a flicker film which utilizes 81 still photographs of my wife's head. It is a film dependent upon variation of intense light changes by calculated combinations of black and white frame alternations with exposure changes. Throughout, the light intensity rises and falls as the head rotates in varying directions within a 360 degree frontal area." — James Cagle	\N	/frDqG8rmqKUg4HzQ604LZo8VLHB.jpg	1973-01-01 00:00:00	\N	\N
447365	tt6791350	Guardians of the Galaxy Vol. 3	Peter Quill, still reeling from the loss of Gamora, must rally his team around him to defend the universe along with protecting one of their own. A mission that, if not completed successfully, could quite possibly lead to the end of the Guardians as we know them.	150	/r2J02Z2OpNTctfOSN1Ydgii51I3.jpg	2023-05-03 00:00:00	250000000	528801000
\.


--
-- Data for Name: races; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.races (id, name, short, description) FROM stdin;
1	White	WHT	A person having origins in any of the original peoples of Europe.
2	Middle Eastern/North African	MENA	A person having origins in any of the original peoples of the Middle East and/or North Africa.
3	Black	BLK	A person having origins in any of the Black racial groups of Africa.
4	Hispanic/Latino	HSPN	A person of Mexican, Puerto Rican, Cuban, Central or South American, or other Spanish culture or origin, regardless of race.
5	Asian	ASN	A person having origins in any of the original peoples of the Far East, Southeast Asia, or the Indian subcontinent including, for example, Cambodia, China, India, Japan, Korea, Malaysia, Pakistan, the Philippine Islands, Thailand, and Vietnam.
6	American Indian/Alaska Native	AIAN	A person having origins in any of the original peoples of North and South America (including Central America) and who maintains tribal affiliation or community attachment.
7	Native Hawaiian/Pacific Islander	NHPI	A person having origins in any of the original peoples of Hawaii, Guam, Samoa, or other Pacific Islands.
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.regions (id, name) FROM stdin;
1	Africa
2	Americas
3	Antarctic
4	Asia
5	Europe
6	Oceania
\.


--
-- Data for Name: source_links; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.source_links (id, source_id, link) FROM stdin;
30	1	https://ethnicelebs.com/benedict-cumberbatch
31	1	https://ethnicelebs.com/kodi-smit-mcphee
32	1	https://ethnicelebs.com/kirsten-dunst
33	1	https://ethnicelebs.com/jesse-plemons
34	1	https://ethnicelebs.com/thomasin-mckenzie
35	1	https://ethnicelebs.com/frances-conroy
36	5	https://en.wikipedia.org/wiki/Caitr%C3%ADona_Balfe
37	1	https://ethnicelebs.com/jamie-dornan
38	1	https://ethnicelebs.com/judi-dench
39	1	https://ethnicelebs.com/ciaran-hinds
40	1	https://ethnicelebs.com/colin-morgan
41	1	https://ethnicelebs.com/emilia-jones
42	1	https://ethnicelebs.com/marlee-matlin
43	1	https://ethnicelebs.com/troy-kotsur
44	1	https://ethnicelebs.com/eugenio-derbez
45	1	https://ethnicelebs.com/ferdia-walsh-peelo
46	1	https://ethnicelebs.com/daniel-durant
47	1	https://ethnicelebs.com/timothee-chalamet
48	1	https://ethnicelebs.com/rebecca-ferguson
49	1	https://ethnicelebs.com/oscar-isaac
50	1	https://ethnicelebs.com/josh-brolin
51	1	https://ethnicelebs.com/batista
52	1	https://ethnicelebs.com/zendaya
53	1	https://ethnicelebs.com/chang-chen
54	1	https://ethnicelebs.com/charlotte-rampling
55	1	https://ethnicelebs.com/jason-momoa
56	1	https://ethnicelebs.com/javier-bardem
57	1	https://ethnicelebs.com/david-dastmalchian
58	1	https://ethnicelebs.com/will-smith
59	1	https://ethnicelebs.com/aunjanue-ellis
60	1	https://ethnicelebs.com/saniyya-sidney
61	1	https://ethnicelebs.com/jon-bernthal
62	1	https://ethnicelebs.com/tony-goldwyn
63	1	https://ethnicelebs.com/dylan-mcdermott
64	1	https://ethnicelebs.com/katrina-begin
65	1	https://ethnicelebs.com/andy-bean
66	1	https://ethnicelebs.com/kevin-dunn
67	1	https://ethnicelebs.com/alana-haim
68	1	https://ethnicelebs.com/cooper-hoffman
69	1	https://ethnicelebs.com/sean-penn
70	1	https://ethnicelebs.com/tom-waits
71	1	https://ethnicelebs.com/bradley-cooper
72	5	https://en.wikipedia.org/wiki/Benny_Safdie
73	1	https://ethnicelebs.com/skyler-gisondo
74	1	https://ethnicelebs.com/john-michael-higgins
75	1	https://ethnicelebs.com/christine-ebersole
76	1	https://ethnicelebs.com/joseph-cross
77	1	https://ethnicelebs.com/danielle-haim
78	1	https://ethnicelebs.com/este-haim
79	1	https://ethnicelebs.com/rooney-mara
80	1	https://ethnicelebs.com/cate-blanchett
81	1	https://ethnicelebs.com/toni-collette
82	1	https://ethnicelebs.com/richard-jenkins
83	1	https://ethnicelebs.com/willem-dafoe
84	1	https://ethnicelebs.com/david-strathairn
85	1	https://ethnicelebs.com/ron-perlman
86	1	https://ethnicelebs.com/holt-mccallany
87	1	https://ethnicelebs.com/mary-steenburgen
88	1	https://ethnicelebs.com/tim-blake-nelson
89	1	https://ethnicelebs.com/clifton-collins-jr
90	1	https://ethnicelebs.com/denzel-washington
91	1	https://ethnicelebs.com/corey-hawkins
92	1	https://ethnicelebs.com/alex-hassell
93	1	https://ethnicelebs.com/kathryn-hunter
94	1	https://ethnicelebs.com/bertie-carvel
95	1	https://ethnicelebs.com/brendan-gleeson
96	1	https://ethnicelebs.com/harry-melling
97	1	https://ethnicelebs.com/moses-ingram
98	1	https://ethnicelebs.com/stephen-root
99	1	https://ethnicelebs.com/ansel-elgort
100	1	https://ethnicelebs.com/rachel-zegler
101	1	https://ethnicelebs.com/ariana-debose
102	1	https://ethnicelebs.com/david-alvarez
103	1	https://ethnicelebs.com/brian-d'arcy-james
104	1	https://ethnicelebs.com/corey-stoll
105	1	https://ethnicelebs.com/rita-moreno
106	1	https://ethnicelebs.com/alice-englert
107	1	https://ethnicelebs.com/romina-power
108	1	https://ethnicelebs.com/victor-cruz
109	1	https://ethnicelebs.com/jeff-ward
110	1	https://ethnicelebs.com/rich-sommer
111	1	https://ethnicelebs.com/sasha-spielberg
112	1	https://ethnicelebs.com/erika-ringor
113	1	https://ethnicelebs.com/john-c-reilly
114	1	https://ethnicelebs.com/emily-althaus
115	1	https://ethnicelebs.com/jamila-velazquez
116	1	https://ethnicelebs.com/adam-beach
117	1	https://ethnicelebs.com/maddie-ziegler
118	1	https://ethnicelebs.com/ralph-ineson
119	1	https://ethnicelebs.com/noah-bean
120	1	https://ethnicelebs.com/talia-ryder
121	1	https://ethnicelebs.com/kyle-allen
122	1	https://ethnicelebs.com/david-lim
123	1	https://ethnicelebs.com/ray-nicholson
124	1	https://ethnicelebs.com/maya-rudolph
125	1	https://ethnicelebs.com/sean-patrick-thomas
126	1	https://ethnicelebs.com/hannah-barefoot
127	1	https://ethnicelebs.com/stephen-collins
\.


--
-- Data for Name: sources; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.sources (id, name, domain) FROM stdin;
1	Ethnicelebs	https://ethnicelebs.com
2	Wikipedia	https://wikipedia.org
5	Https://en	https://https://en.wikipedia.org
\.


--
-- Data for Name: subregions; Type: TABLE DATA; Schema: public; Owner: mithin
--

COPY public.subregions (id, name, region_id) FROM stdin;
1	Australia and New Zealand	6
2	Caribbean	2
3	Central America	2
4	Central Asia	4
5	Central Europe	5
6	Eastern Africa	1
7	Eastern Asia	4
8	Eastern Europe	5
9	Melanesia	6
10	Micronesia	6
11	Middle Africa	1
12	North America	2
13	Northern Africa	1
14	Northern Europe	5
15	Polynesia	6
16	South America	2
17	South-Eastern Asia	4
18	Southeast Europe	5
19	Southern Africa	1
20	Southern Asia	4
21	Southern Europe	5
22	Antarctica	3
23	Western Africa	1
24	Western Asia	4
25	Western Europe	5
\.


--
-- Name: also_known_as_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.also_known_as_id_seq', 4234, true);


--
-- Name: alt_countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.alt_countries_id_seq', 789, true);


--
-- Name: alt_ethnicities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.alt_ethnicities_id_seq', 76, true);


--
-- Name: cast_ethnicities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.cast_ethnicities_id_seq', 642, true);


--
-- Name: cast_ethnicity_source_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.cast_ethnicity_source_links_id_seq', 336, true);


--
-- Name: cast_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.cast_members_id_seq', 1, false);


--
-- Name: cast_races_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.cast_races_id_seq', 231, true);


--
-- Name: ethnicities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.ethnicities_id_seq', 655, true);


--
-- Name: genders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.genders_id_seq', 1, false);


--
-- Name: genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.genres_id_seq', 1, false);


--
-- Name: media_genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.media_genres_id_seq', 162, true);


--
-- Name: movies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.movies_id_seq', 1, false);


--
-- Name: races_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.races_id_seq', 7, true);


--
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.regions_id_seq', 6, true);


--
-- Name: source_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.source_links_id_seq', 127, true);


--
-- Name: sources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.sources_id_seq', 5, true);


--
-- Name: subregions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mithin
--

SELECT pg_catalog.setval('public.subregions_id_seq', 25, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: also_known_as also_known_as_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.also_known_as
    ADD CONSTRAINT also_known_as_pkey PRIMARY KEY (id);


--
-- Name: alt_countries alt_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.alt_countries
    ADD CONSTRAINT alt_countries_pkey PRIMARY KEY (id);


--
-- Name: alt_ethnicities alt_ethnicities_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.alt_ethnicities
    ADD CONSTRAINT alt_ethnicities_pkey PRIMARY KEY (id);


--
-- Name: cast_ethnicities cast_ethnicities_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_ethnicities
    ADD CONSTRAINT cast_ethnicities_pkey PRIMARY KEY (id);


--
-- Name: cast_ethnicity_source_links cast_ethnicity_source_links_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_ethnicity_source_links
    ADD CONSTRAINT cast_ethnicity_source_links_pkey PRIMARY KEY (id);


--
-- Name: cast_members cast_members_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_members
    ADD CONSTRAINT cast_members_pkey PRIMARY KEY (id);


--
-- Name: cast_races cast_races_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_races
    ADD CONSTRAINT cast_races_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: credits credits_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.credits
    ADD CONSTRAINT credits_pkey PRIMARY KEY (id);


--
-- Name: ethnicities ethnicities_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.ethnicities
    ADD CONSTRAINT ethnicities_pkey PRIMARY KEY (id);


--
-- Name: genders genders_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.genders
    ADD CONSTRAINT genders_pkey PRIMARY KEY (id);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: media_genres media_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.media_genres
    ADD CONSTRAINT media_genres_pkey PRIMARY KEY (id);


--
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: races races_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.races
    ADD CONSTRAINT races_pkey PRIMARY KEY (id);


--
-- Name: races races_short_key; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.races
    ADD CONSTRAINT races_short_key UNIQUE (short);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: source_links source_links_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.source_links
    ADD CONSTRAINT source_links_pkey PRIMARY KEY (id);


--
-- Name: sources sources_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);


--
-- Name: subregions subregions_pkey; Type: CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.subregions
    ADD CONSTRAINT subregions_pkey PRIMARY KEY (id);


--
-- Name: also_known_as also_known_as_cast_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.also_known_as
    ADD CONSTRAINT also_known_as_cast_member_id_fkey FOREIGN KEY (cast_member_id) REFERENCES public.cast_members(id);


--
-- Name: alt_countries alt_countries_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.alt_countries
    ADD CONSTRAINT alt_countries_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: alt_ethnicities alt_ethnicities_ethnicity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.alt_ethnicities
    ADD CONSTRAINT alt_ethnicities_ethnicity_id_fkey FOREIGN KEY (ethnicity_id) REFERENCES public.ethnicities(id);


--
-- Name: cast_ethnicities cast_ethnicities_cast_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_ethnicities
    ADD CONSTRAINT cast_ethnicities_cast_member_id_fkey FOREIGN KEY (cast_member_id) REFERENCES public.cast_members(id);


--
-- Name: cast_ethnicities cast_ethnicities_ethnicity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_ethnicities
    ADD CONSTRAINT cast_ethnicities_ethnicity_id_fkey FOREIGN KEY (ethnicity_id) REFERENCES public.ethnicities(id);


--
-- Name: cast_ethnicity_source_links cast_ethnicity_source_links_cast_ethnicity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_ethnicity_source_links
    ADD CONSTRAINT cast_ethnicity_source_links_cast_ethnicity_id_fkey FOREIGN KEY (cast_ethnicity_id) REFERENCES public.cast_ethnicities(id);


--
-- Name: cast_ethnicity_source_links cast_ethnicity_source_links_source_link_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_ethnicity_source_links
    ADD CONSTRAINT cast_ethnicity_source_links_source_link_id_fkey FOREIGN KEY (source_link_id) REFERENCES public.source_links(id);


--
-- Name: cast_members cast_members_country_of_birth_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_members
    ADD CONSTRAINT cast_members_country_of_birth_id_fkey FOREIGN KEY (country_of_birth_id) REFERENCES public.countries(id);


--
-- Name: cast_members cast_members_gender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_members
    ADD CONSTRAINT cast_members_gender_id_fkey FOREIGN KEY (gender_id) REFERENCES public.genders(id);


--
-- Name: cast_races cast_races_cast_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_races
    ADD CONSTRAINT cast_races_cast_member_id_fkey FOREIGN KEY (cast_member_id) REFERENCES public.cast_members(id);


--
-- Name: cast_races cast_races_race_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.cast_races
    ADD CONSTRAINT cast_races_race_id_fkey FOREIGN KEY (race_id) REFERENCES public.races(id);


--
-- Name: countries countries_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: countries countries_subregion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_subregion_id_fkey FOREIGN KEY (subregion_id) REFERENCES public.subregions(id);


--
-- Name: credits credits_cast_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.credits
    ADD CONSTRAINT credits_cast_member_id_fkey FOREIGN KEY (cast_member_id) REFERENCES public.cast_members(id);


--
-- Name: credits credits_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.credits
    ADD CONSTRAINT credits_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id);


--
-- Name: ethnicities ethnicities_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.ethnicities
    ADD CONSTRAINT ethnicities_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: ethnicities ethnicities_subregion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.ethnicities
    ADD CONSTRAINT ethnicities_subregion_id_fkey FOREIGN KEY (subregion_id) REFERENCES public.subregions(id);


--
-- Name: media_genres media_genres_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.media_genres
    ADD CONSTRAINT media_genres_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genres(id);


--
-- Name: media_genres media_genres_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.media_genres
    ADD CONSTRAINT media_genres_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id);


--
-- Name: source_links source_links_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.source_links
    ADD CONSTRAINT source_links_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.sources(id);


--
-- Name: subregions subregions_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mithin
--

ALTER TABLE ONLY public.subregions
    ADD CONSTRAINT subregions_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- PostgreSQL database dump complete
--

