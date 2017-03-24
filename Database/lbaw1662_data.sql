--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: auction_type; Type: TYPE; Schema: public; Owner: lbaw1662
--

CREATE TYPE auction_type AS ENUM (
    'Default',
    'Dutch',
    'Sealed Bid'
);


ALTER TYPE auction_type OWNER TO lbaw1662;

--
-- Name: category_type; Type: TYPE; Schema: public; Owner: lbaw1662
--

CREATE TYPE category_type AS ENUM (
    'Art',
    'Tickets and Trips',
    'Dolls and Bears',
    'Toys and Hobbies',
    'Cars and Vehicles',
    'Sports Souvenirs',
    'Home and Garden',
    'Collectibles',
    'Electronics and Computers',
    'Movies and DVDs',
    'Musical Instruments',
    'Jewelry',
    'Books',
    'Cloths and Accessories',
    'Health and Beauty',
    'Video Games',
    'Sexual Toys'
);


ALTER TYPE category_type OWNER TO lbaw1662;

--
-- Name: notification_type; Type: TYPE; Schema: public; Owner: lbaw1662
--

CREATE TYPE notification_type AS ENUM (
    'Auction',
    'Question',
    'Answer',
    'Win',
    'Warning'
);


ALTER TYPE notification_type OWNER TO lbaw1662;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE admin (
    id integer NOT NULL,
    username character varying(32) NOT NULL,
    email character varying(64) NOT NULL,
    hashed_pass character varying(32) NOT NULL
);


ALTER TABLE admin OWNER TO lbaw1662;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE admin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin_id_seq OWNER TO lbaw1662;

--
-- Name: admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE admin_id_seq OWNED BY admin.id;


--
-- Name: answer; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE answer (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    question_id integer NOT NULL,
    user_id integer NOT NULL,
    auction_id integer NOT NULL
);


ALTER TABLE answer OWNER TO lbaw1662;

--
-- Name: answer_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE answer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE answer_id_seq OWNER TO lbaw1662;

--
-- Name: answer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE answer_id_seq OWNED BY answer.id;


--
-- Name: answer_report; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE answer_report (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    answer_id integer NOT NULL
);


ALTER TABLE answer_report OWNER TO lbaw1662;

--
-- Name: answer_report_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE answer_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE answer_report_id_seq OWNER TO lbaw1662;

--
-- Name: answer_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE answer_report_id_seq OWNED BY answer_report.id;


--
-- Name: auction; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE auction (
    id integer NOT NULL,
    start_bid double precision NOT NULL,
    curr_bid double precision NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    type auction_type NOT NULL,
    user_id integer NOT NULL,
    product_id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    CONSTRAINT auction_date_ck CHECK (((date < start_date) AND (start_date < end_date)))
);


ALTER TABLE auction OWNER TO lbaw1662;

--
-- Name: auction_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE auction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auction_id_seq OWNER TO lbaw1662;

--
-- Name: auction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE auction_id_seq OWNED BY auction.id;


--
-- Name: auction_report; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE auction_report (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    auction_id integer NOT NULL
);


ALTER TABLE auction_report OWNER TO lbaw1662;

--
-- Name: auction_report_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE auction_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auction_report_id_seq OWNER TO lbaw1662;

--
-- Name: auction_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE auction_report_id_seq OWNED BY auction_report.id;


--
-- Name: bid; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE bid (
    id integer NOT NULL,
    amount double precision NOT NULL,
    date timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    auction_id integer NOT NULL,
    CONSTRAINT bid_amount_ck CHECK ((amount > (0)::double precision))
);


ALTER TABLE bid OWNER TO lbaw1662;

--
-- Name: bid_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE bid_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bid_id_seq OWNER TO lbaw1662;

--
-- Name: bid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE bid_id_seq OWNED BY bid.id;


--
-- Name: city; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE city (
    id integer NOT NULL,
    country_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE city OWNER TO lbaw1662;

--
-- Name: city_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE city_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE city_id_seq OWNER TO lbaw1662;

--
-- Name: city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE city_id_seq OWNED BY city.id;


--
-- Name: country; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE country (
    id integer NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE country OWNER TO lbaw1662;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE country_id_seq OWNER TO lbaw1662;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: follow; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE follow (
    user_followed_id integer NOT NULL,
    user_following_id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    CONSTRAINT dif_users_ck CHECK ((user_followed_id <> user_following_id))
);


ALTER TABLE follow OWNER TO lbaw1662;

--
-- Name: image; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE image (
    id integer NOT NULL,
    filename text NOT NULL,
    product_id integer NOT NULL
);


ALTER TABLE image OWNER TO lbaw1662;

--
-- Name: image_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE image_id_seq OWNER TO lbaw1662;

--
-- Name: image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE image_id_seq OWNED BY image.id;


--
-- Name: location; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE location (
    id integer NOT NULL,
    city_id integer NOT NULL,
    address character varying(64) NOT NULL
);


ALTER TABLE location OWNER TO lbaw1662;

--
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE location_id_seq OWNER TO lbaw1662;

--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE location_id_seq OWNED BY location.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE notification (
    id integer NOT NULL,
    message character varying(128) NOT NULL,
    type notification_type NOT NULL,
    user_id integer NOT NULL,
    "isNew" boolean NOT NULL
);


ALTER TABLE notification OWNER TO lbaw1662;

--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE notification_id_seq OWNER TO lbaw1662;

--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE notification_id_seq OWNED BY notification.id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE product (
    id integer NOT NULL,
    type category_type[],
    name character varying(64) NOT NULL,
    description text NOT NULL
);


ALTER TABLE product OWNER TO lbaw1662;

--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_id_seq OWNER TO lbaw1662;

--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- Name: question; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE question (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    title character varying(64) NOT NULL,
    user_id integer NOT NULL,
    auction_id integer NOT NULL
);


ALTER TABLE question OWNER TO lbaw1662;

--
-- Name: question_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE question_id_seq OWNER TO lbaw1662;

--
-- Name: question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE question_id_seq OWNED BY question.id;


--
-- Name: question_report; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE question_report (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    question_id integer NOT NULL
);


ALTER TABLE question_report OWNER TO lbaw1662;

--
-- Name: question_report_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE question_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE question_report_id_seq OWNER TO lbaw1662;

--
-- Name: question_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE question_report_id_seq OWNED BY question_report.id;


--
-- Name: review; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE review (
    id integer NOT NULL,
    rating integer NOT NULL,
    message text NOT NULL,
    date timestamp without time zone NOT NULL,
    bid_id integer NOT NULL,
    CONSTRAINT review_rating_ck CHECK (((rating >= 0) AND (rating <= 10)))
);


ALTER TABLE review OWNER TO lbaw1662;

--
-- Name: review_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE review_id_seq OWNER TO lbaw1662;

--
-- Name: review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE review_id_seq OWNED BY review.id;


--
-- Name: review_report; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE review_report (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    review_id integer NOT NULL
);


ALTER TABLE review_report OWNER TO lbaw1662;

--
-- Name: review_report_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE review_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE review_report_id_seq OWNER TO lbaw1662;

--
-- Name: review_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE review_report_id_seq OWNED BY review_report.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    email character varying(64) NOT NULL,
    name character varying(64) NOT NULL,
    short_bio character varying(255) NOT NULL,
    full_bio text,
    hashed_pass character varying(64) NOT NULL,
    phone character varying(20),
    register_date timestamp without time zone NOT NULL,
    location_id integer,
    profile_pic character varying(72)
);


ALTER TABLE "user" OWNER TO lbaw1662;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_id_seq OWNER TO lbaw1662;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- Name: user_report; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE user_report (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE user_report OWNER TO lbaw1662;

--
-- Name: user_report_id_seq; Type: SEQUENCE; Schema: public; Owner: lbaw1662
--

CREATE SEQUENCE user_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_report_id_seq OWNER TO lbaw1662;

--
-- Name: user_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lbaw1662
--

ALTER SEQUENCE user_report_id_seq OWNED BY user_report.id;


--
-- Name: watchlist; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE watchlist (
    auction_id integer NOT NULL,
    user_id integer NOT NULL,
    notifications boolean NOT NULL,
    date timestamp without time zone NOT NULL
);


ALTER TABLE watchlist OWNER TO lbaw1662;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY admin ALTER COLUMN id SET DEFAULT nextval('admin_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY answer ALTER COLUMN id SET DEFAULT nextval('answer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY answer_report ALTER COLUMN id SET DEFAULT nextval('answer_report_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY auction ALTER COLUMN id SET DEFAULT nextval('auction_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY auction_report ALTER COLUMN id SET DEFAULT nextval('auction_report_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY bid ALTER COLUMN id SET DEFAULT nextval('bid_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY city ALTER COLUMN id SET DEFAULT nextval('city_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY image ALTER COLUMN id SET DEFAULT nextval('image_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY location ALTER COLUMN id SET DEFAULT nextval('location_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY notification ALTER COLUMN id SET DEFAULT nextval('notification_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY question ALTER COLUMN id SET DEFAULT nextval('question_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY question_report ALTER COLUMN id SET DEFAULT nextval('question_report_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY review ALTER COLUMN id SET DEFAULT nextval('review_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY review_report ALTER COLUMN id SET DEFAULT nextval('review_report_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY user_report ALTER COLUMN id SET DEFAULT nextval('user_report_id_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('admin_id_seq', 1, false);


--
-- Data for Name: answer; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: answer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('answer_id_seq', 1, false);


--
-- Data for Name: answer_report; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: answer_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('answer_report_id_seq', 1, false);


--
-- Data for Name: auction; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: auction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('auction_id_seq', 1, false);


--
-- Data for Name: auction_report; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: auction_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('auction_report_id_seq', 1, false);


--
-- Data for Name: bid; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: bid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('bid_id_seq', 1, false);


--
-- Data for Name: city; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('city_id_seq', 1, false);


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('country_id_seq', 1, true);


--
-- Data for Name: follow; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('image_id_seq', 1, false);


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('location_id_seq', 1, false);


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('notification_id_seq', 1, false);


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('product_id_seq', 1, false);


--
-- Data for Name: question; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('question_id_seq', 1, false);


--
-- Data for Name: question_report; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: question_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('question_report_id_seq', 1, false);


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('review_id_seq', 1, false);


--
-- Data for Name: review_report; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: review_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('review_report_id_seq', 1, false);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('user_id_seq', 1, false);


--
-- Data for Name: user_report; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: user_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('user_report_id_seq', 1, false);


--
-- Data for Name: watchlist; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--



--
-- Name: admin_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: answer_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT answer_pkey PRIMARY KEY (id);


--
-- Name: answer_report_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY answer_report
    ADD CONSTRAINT answer_report_pkey PRIMARY KEY (id);


--
-- Name: auction_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY auction
    ADD CONSTRAINT auction_pkey PRIMARY KEY (id);


--
-- Name: auction_report_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY auction_report
    ADD CONSTRAINT auction_report_pkey PRIMARY KEY (id);


--
-- Name: bid_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY bid
    ADD CONSTRAINT bid_pkey PRIMARY KEY (id);


--
-- Name: city_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY city
    ADD CONSTRAINT city_pkey PRIMARY KEY (id);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: follow_pk; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT follow_pk PRIMARY KEY (user_following_id, user_followed_id);


--
-- Name: image_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: product_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: question_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY question
    ADD CONSTRAINT question_pkey PRIMARY KEY (id);


--
-- Name: question_report_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY question_report
    ADD CONSTRAINT question_report_pkey PRIMARY KEY (id);


--
-- Name: review_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);


--
-- Name: review_report_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY review_report
    ADD CONSTRAINT review_report_pkey PRIMARY KEY (id);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_report_pkey; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY user_report
    ADD CONSTRAINT user_report_pkey PRIMARY KEY (id);


--
-- Name: watchlist_pk; Type: CONSTRAINT; Schema: public; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY watchlist
    ADD CONSTRAINT watchlist_pk PRIMARY KEY (auction_id, user_id);


--
-- Name: admin_email_uindex; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX admin_email_uindex ON admin USING btree (email);


--
-- Name: admin_username_uindex; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX admin_username_uindex ON admin USING btree (username);


--
-- Name: country_name_uindex; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX country_name_uindex ON country USING btree (name);


--
-- Name: image_filename_uindex; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX image_filename_uindex ON image USING btree (filename);


--
-- Name: user_email_uindex; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX user_email_uindex ON "user" USING btree (email);


--
-- Name: user_username_uindex; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX user_username_uindex ON "user" USING btree (username);


--
-- Name: answer_auction_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT answer_auction_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE;


--
-- Name: answer_question_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT answer_question_fk FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE;


--
-- Name: answer_report_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY answer_report
    ADD CONSTRAINT answer_report_fk FOREIGN KEY (answer_id) REFERENCES answer(id) ON DELETE CASCADE;


--
-- Name: answer_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT answer_user_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: auction_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY auction
    ADD CONSTRAINT auction_product_fk FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE;


--
-- Name: auction_report_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY auction_report
    ADD CONSTRAINT auction_report_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE;


--
-- Name: auction_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY auction
    ADD CONSTRAINT auction_user_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: bid_auction_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY bid
    ADD CONSTRAINT bid_auction_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE;


--
-- Name: bid_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY bid
    ADD CONSTRAINT bid_user_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: city_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY city
    ADD CONSTRAINT city_fk FOREIGN KEY (country_id) REFERENCES country(id) ON DELETE CASCADE;


--
-- Name: follow_user_followed_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT follow_user_followed_fk FOREIGN KEY (user_followed_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: follow_user_following_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT follow_user_following_fk FOREIGN KEY (user_following_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: image_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY image
    ADD CONSTRAINT image_fk FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE;


--
-- Name: location_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_fk FOREIGN KEY (city_id) REFERENCES city(id);


--
-- Name: notification_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: question_auction_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY question
    ADD CONSTRAINT question_auction_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE;


--
-- Name: question_report_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY question_report
    ADD CONSTRAINT question_report_fk FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE;


--
-- Name: question_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY question
    ADD CONSTRAINT question_user_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE SET NULL;


--
-- Name: review_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_fk FOREIGN KEY (bid_id) REFERENCES bid(id);


--
-- Name: review_report_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY review_report
    ADD CONSTRAINT review_report_fk FOREIGN KEY (review_id) REFERENCES review(id) ON DELETE CASCADE;


--
-- Name: user_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_fk FOREIGN KEY (location_id) REFERENCES location(id) ON DELETE SET NULL;


--
-- Name: user_report_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY user_report
    ADD CONSTRAINT user_report_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: watchlist_auction_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY watchlist
    ADD CONSTRAINT watchlist_auction_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE;


--
-- Name: watchlist_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: lbaw1662
--

ALTER TABLE ONLY watchlist
    ADD CONSTRAINT watchlist_user_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: lbaw1662
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM lbaw1662;
GRANT ALL ON SCHEMA public TO lbaw1662;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

