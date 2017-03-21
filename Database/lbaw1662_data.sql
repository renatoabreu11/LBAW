--
-- PostgreSQL database
--

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: lbaw1662
--

CREATE SCHEMA public;

--
-- Name: auction_type; Type: TYPE; Schema: public; Owner: lbaw1662
--

CREATE TYPE auction_type AS ENUM (
    'Default',
    'Dutch',
    'Sealed Bid'
);

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

--
-- Name: admin; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE admin (
    id serial integer NOT NULL,
    username character varying(32) NOT NULL,
    email character varying(64) NOT NULL,
    hashed_pass character varying(32) NOT NULL,
    CONSTRAINT admin_pkey PRIMARY KEY (id),
    CONSTRAINT admin_email_uindex UNIQUE (email),
    CONSTRAINT admin_username_uindex UNIQUE (username)
);

CREATE SEQUENCE admin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: answer; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE answer (
    id serial integer NOT NULL,
    creation_date timestamp without time zone NOT NULL,
    message text NOT NULL,
    question_id integer NOT NULL,
    user_id integer NOT NULL,
    auction_id integer NOT NULL,
    CONSTRAINT answer_pkey PRIMARY KEY (id),
    CONSTRAINT answer_auction_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE,
    CONSTRAINT answer_question_fk FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE,
    CONSTRAINT answer_user_fk FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE SET NULL
);

CREATE SEQUENCE answer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: answer_report; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE answer_report (
    id serial integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message character varying(128) NOT NULL,
    answer_id integer NOT NULL,
    CONSTRAINT answer_report_pkey PRIMARY KEY (id),
    CONSTRAINT answer_report_fk FOREIGN KEY (answer_id) REFERENCES answer(id) ON DELETE CASCADE
);

CREATE SEQUENCE answer_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: auction; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE auction (
    id serial integer NOT NULL,
    start_bid double precision NOT NULL,
    curr_bid double precision NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    type auction_type NOT NULL,
    user_id integer NOT NULL,
    CONSTRAINT auction_pkey PRIMARY KEY (id),
    CONSTRAINT auction_user_fk FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    CONSTRAINT auction_date_ck CHECK (start_date < end_date)
);

CREATE SEQUENCE auction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: auction_report; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE auction_report (
    id serial integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message character varying(128) NOT NULL,
    auction_id integer NOT NULL,
    CONSTRAINT auction_report_pkey PRIMARY KEY (id),
    CONSTRAINT auction_report_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE
);

CREATE SEQUENCE auction_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: bid; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE bid (
    id serial integer NOT NULL,
    amount double precision NOT NULL,
    date timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    auction_id integer NOT NULL,
    CONSTRAINT bid_pkey PRIMARY KEY (id),
    CONSTRAINT bid_auction_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE,
    CONSTRAINT bid_user_fk FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE SET NULL,
    CONSTRAINT bid_amount_ck CHECK (amount > (0)::double precision)
);

CREATE SEQUENCE bid_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: city; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE city (
    id serial integer NOT NULL,
    country_id integer NOT NULL,
    name character varying(32) NOT NULL,
    CONSTRAINT city_pkey PRIMARY KEY (id),
    CONSTRAINT city_fk FOREIGN KEY (country_id) REFERENCES country(id) ON DELETE CASCADE
);

CREATE SEQUENCE city_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: country; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE country (
    id serial integer NOT NULL,
    name character varying(64) NOT NULL,
    CONSTRAINT country_pkey PRIMARY KEY (id),
    CONSTRAINT country_name_uindex UNIQUE (name)
);

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: follow; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE follow (
    user_followed_id integer NOT NULL,
    user_following_id integer NOT NULL,
    CONSTRAINT follow_pk PRIMARY KEY (user_following_id, user_followed_id),
    CONSTRAINT follow_user_followed_fk FOREIGN KEY (user_followed_id) REFERENCES user(id) ON DELETE CASCADE,
    CONSTRAINT follow_user_following_fk FOREIGN KEY (user_following_id) REFERENCES user(id) ON DELETE CASCADE
);

--
-- Name: image; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE image (
    id serial integer NOT NULL,
    filename text NOT NULL,
    product_id integer NOT NULL,
    CONSTRAINT image_pkey PRIMARY KEY (id),
    CONSTRAINT image_filename_uindex UNIQUE (filename),
    CONSTRAINT image_fk FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

CREATE SEQUENCE image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: location; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE location (
    id serial integer NOT NULL,
    city_id integer NOT NULL,
    address character varying(64) NOT NULL,
    CONSTRAINT location_pkey PRIMARY KEY (id),
    CONSTRAINT location_fk FOREIGN KEY (city_id) REFERENCES city(id)
);

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: notification; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE notification (
    id serial integer NOT NULL,
    message character varying(128) NOT NULL,
    type notification_type NOT NULL,
    user_id integer NOT NULL,
    CONSTRAINT notification_pkey PRIMARY KEY (id),
    CONSTRAINT notification_fk FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);

CREATE SEQUENCE notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: product; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE product (
    id serial integer NOT NULL,
    type category_type[],
    name character varying(64) NOT NULL,
    description text NOT NULL,
    CONSTRAINT product_pkey PRIMARY KEY (id)
);

CREATE SEQUENCE product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: question; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE question (
    id serial integer NOT NULL,
    creation_date timestamp without time zone NOT NULL,
    message text NOT NULL,
    title character varying(64) NOT NULL,
    user_id integer NOT NULL,
    auction_id integer NOT NULL,
    CONSTRAINT question_pkey PRIMARY KEY (id),
    CONSTRAINT question_auction_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE,
    CONSTRAINT question_user_fk FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE SET NULL
);

CREATE SEQUENCE question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: question_report; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE question_report (
    id serial integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message character varying(128) NOT NULL,
    question_id integer NOT NULL,
    CONSTRAINT question_report_pkey PRIMARY KEY (id),
    CONSTRAINT question_report_fk FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE
);

CREATE SEQUENCE question_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: review; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE review (
    id serial integer NOT NULL,
    rating integer NOT NULL,
    message text NOT NULL,
    date timestamp without time zone NOT NULL,
    bid_id integer NOT NULL,
    CONSTRAINT review_pkey PRIMARY KEY (id),
    CONSTRAINT review_fk FOREIGN KEY (bid_id) REFERENCES bid(id),
    CONSTRAINT review_rating_ck CHECK ((rating >= 0) AND (rating <= 10))
);

CREATE SEQUENCE review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: user; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE user (
    id serial integer NOT NULL,
    username character varying(64) NOT NULL,
    email character varying(64) NOT NULL,
    name character varying(64) NOT NULL,
    short_bio character varying(255) NOT NULL,
    full_bio text,
    hashed_pass character varying(64) NOT NULL,
    phone character varying(15),
    register_date timestamp without time zone NOT NULL,
    location_id integer,
    CONSTRAINT user_pkey PRIMARY KEY (id),
    CONSTRAINT user_email_uindex UNIQUE (email),
    CONSTRAINT user_username_uindex UNIQUE (username),
    CONSTRAINT user_fk FOREIGN KEY (location_id) REFERENCES location(id) ON DELETE SET NULL
);

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: user_report; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE user_report (
    id serial integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message character varying(128) NOT NULL,
    user_id integer NOT NULL,
    CONSTRAINT user_report_pkey PRIMARY KEY (id),
    CONSTRAINT user_report_fk FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);

CREATE SEQUENCE user_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: watchlist; Type: TABLE; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE watchlist (
    auction_id integer NOT NULL,
    user_id integer NOT NULL,
    notifications boolean NOT NULL,
    CONSTRAINT watchlist_pk PRIMARY KEY (auction_id, user_id),
    CONSTRAINT watchlist_auction_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE,
    CONSTRAINT watchlist_user_fk FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);