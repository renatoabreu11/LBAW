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

--
-- Name: answer_is_of_seller(); Type: FUNCTION; Schema: public; Owner: lbaw1662
--

CREATE FUNCTION answer_is_of_seller() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF EXISTS (SELECT auction.user_id FROM auction
            WHERE auction.id = NEW.auction_id AND auction.user_id != NEW.user_id)
    THEN
    RAISE EXCEPTION 'Only the seller can answer.';
  ELSE
    RETURN NEW;
  END IF;

END;
$$;


ALTER FUNCTION public.answer_is_of_seller() OWNER TO lbaw1662;

--
-- Name: answer_report_notification(); Type: FUNCTION; Schema: public; Owner: lbaw1662
--

CREATE FUNCTION answer_report_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO notification (user_id, message, type, date, is_new) VALUES(
            (SELECT "user".id
                FROM "user"
                    INNER JOIN answer ON answer.id = New.answer_id
                WHERE "user".id = answer.user_id),
            'Your answer ' ||
            (SELECT answer.message
             FROM answer
             WHERE answer.id = NEW.answer_id) || ' has been reported.',
            'Warning',
            now(),
            true
        );
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.answer_report_notification() OWNER TO lbaw1662;

--
-- Name: auction_report_notification(); Type: FUNCTION; Schema: public; Owner: lbaw1662
--

CREATE FUNCTION auction_report_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO notification (user_id, message, type, date, is_new) VALUES(
            (SELECT "user".id
                FROM "user"
                    INNER JOIN auction ON auction.id = New.auction_id
                WHERE "user".id = auction.user_id),
            'Your auction ' ||
            (SELECT product.name
             FROM product
                 INNER JOIN auction on auction.product_id = product.id
             WHERE auction.id = NEW.auction_id) || ' has been reported.',
            'Warning',
            now(),
            true
        );
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.auction_report_notification() OWNER TO lbaw1662;

--
-- Name: question_report_notification(); Type: FUNCTION; Schema: public; Owner: lbaw1662
--

CREATE FUNCTION question_report_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO notification (user_id, message, type, date, is_new) VALUES(
            (SELECT "user".id
                FROM "user"
                    INNER JOIN question ON question.id = New.question_id
                WHERE "user".id = question.user_id),
            'Your question ' ||
            (SELECT question.message
             FROM question
             WHERE question.id = NEW.question_id) || ' has been reported.',
            'Warning',
            now(),
            true
        );
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.question_report_notification() OWNER TO lbaw1662;

--
-- Name: review_report_notification(); Type: FUNCTION; Schema: public; Owner: lbaw1662
--

CREATE FUNCTION review_report_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO notification (user_id, message, type, date, is_new) VALUES(
            (SELECT "user"id
                FROM "user"
                    INNER JOIN review ON review.id = New.review_id
                    INNER JOIN bid ON review.bid_id = bid.id
                WHERE "user".id = bid.user_id),
            'Your review ' ||
            (SELECT review.message
             FROM review
             WHERE review.id = NEW.review_id) || ' has been reported.',
            'Warning',
            now(),
            true
        );
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.review_report_notification() OWNER TO lbaw1662;

--
-- Name: review_trigger(); Type: FUNCTION; Schema: public; Owner: lbaw1662
--

CREATE FUNCTION review_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  seller_id INTEGER;
BEGIN
  SELECT "user".id
   FROM "user"
     INNER JOIN bid ON bid.id = new.bid_id
     INNER JOIN auction ON bid.auction_id = auction.id
   WHERE "user".id = auction.user_id
   INTO seller_id;
  UPDATE "user"
  SET rating = (SELECT AVG(review.rating)
                FROM review, bid, auction
                WHERE review.bid_id = bid.id
                      AND bid.auction_id = auction.id
                      AND auction.user_id = seller_id)
  WHERE "user".id = seller_id;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.review_trigger() OWNER TO lbaw1662;

--
-- Name: seller_cannot_bid(); Type: FUNCTION; Schema: public; Owner: lbaw1662
--

CREATE FUNCTION seller_cannot_bid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF EXISTS (SELECT auction.user_id FROM auction
            WHERE auction.id = NEW.auction_id AND auction.user_id = NEW.user_id)
    THEN
    RAISE EXCEPTION '% cannot have bid in his own auction', NEW.user_id;
  ELSE
    RETURN NEW;
  END IF;

END;
$$;


ALTER FUNCTION public.seller_cannot_bid() OWNER TO lbaw1662;

--
-- Name: update_auction(); Type: FUNCTION; Schema: public; Owner: lbaw1662
--

CREATE FUNCTION update_auction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.date >
    (SELECT end_date
     FROM auction
     WHERE auction.id = NEW.auction_id)
  THEN RAISE EXCEPTION 'Error: Auction closed!';
  ELSEIF NEW.amount >
    (SELECT amount
     FROM bid
     WHERE bid.auction_id = NEW.auction_id
     ORDER BY amount DESC LIMIT 1)
  THEN
    INSERT INTO notification (user_id, message, type, date, is_new) VALUES(
      (SELECT bid.user_id
       FROM bid
       WHERE bid.auction_id = New.auction_id
       ORDER BY bid.amount DESC LIMIT 1),
      'Your bid on the auction ' ||
      (SELECT product.name
       FROM product
         INNER JOIN auction on auction.product_id = product.id
       WHERE auction.id = NEW.auction_id) || ' was surpassed.',
      'Auction',
      now(),
      'true'
    );
    INSERT INTO notification (user_id, message, type, date, is_new) VALUES(
      (SELECT auction.user_id
       FROM auction
       WHERE auction.id = NEW.auction_id),
      'The user ' ||
      (SELECT username
       FROM "user"
       WHERE id = NEW.user_id) ||
      ' has bid on the auction ' ||
      (SELECT product.name
       FROM product
         INNER JOIN auction on auction.product_id = product.id
       WHERE auction.id = NEW.auction_id) || '.',
      'Auction',
      now(),
      'true'
    );
    UPDATE auction
    SET curr_bid = NEW.amount
    WHERE id = NEW.auction_id;
  ELSE RAISE EXCEPTION 'Error: Bid amount must be higher than the current bid.';
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_auction() OWNER TO lbaw1662;

--
-- Name: user_report_notification(); Type: FUNCTION; Schema: public; Owner: lbaw1662
--

CREATE FUNCTION user_report_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO notification (user_id, message, type, date, is_new) VALUES(
            NEW.user_id,
            'You have been reported due to the following reasons: ' || NEW.message || '.',
            'Warning',
            now(),
            true
        );
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.user_report_notification() OWNER TO lbaw1662;

--
-- Name: warn_bidders(); Type: FUNCTION; Schema: public; Owner: lbaw1662
--

CREATE FUNCTION warn_bidders() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _bidder INTEGER;
  _auction VARCHAR(64);
BEGIN
  FOR _bidder IN (
    SELECT DISTINCT "user".id
    FROM "user", bid
    WHERE "user".id = bid.user_id AND bid.auction_id = OLD.id)

  LOOP
    SELECT product.name
    FROM product
    WHERE OLD.product_id = product.id
    INTO _auction;

    INSERT INTO notification (user_id, message, type, date, is_new) VALUES(
      _bidder,
      'The auction ' || _auction || ' and respectives bids/posts were removed.',
      'Auction',
      now(),
      true
    );
  END LOOP;
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.warn_bidders() OWNER TO lbaw1662;

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
    is_new boolean NOT NULL,
    date timestamp without time zone NOT NULL
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
    type category_type[] NOT NULL,
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
    profile_pic character varying(72),
    rating integer,
    CONSTRAINT user_rating_ck CHECK (((rating >= 0) AND (rating <= 10)))
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

INSERT INTO admin VALUES (1, 'renato', 'Donec@rutrumloremac.ca', 'YDF54RBV9VG');
INSERT INTO admin VALUES (2, 'evenilink', 'sem.eget@odio.co.uk', 'TRD70YRH4HI');
INSERT INTO admin VALUES (3, 'hant', 'semper.auctor.Mauris@in.com', 'DIK92SGU6NZ');
INSERT INTO admin VALUES (4, 'dcepa95', 'asfasf.auctor.Mauris@in.com', 'DIK65GGU6NZ');


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('admin_id_seq', 1, false);


--
-- Data for Name: answer; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO answer VALUES (3, '2017-03-18 17:03:59', 'libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet luctus', 10, 1, 11);
INSERT INTO answer VALUES (6, '2017-03-15 18:07:39', 'urna suscipit nonummy. Fusce fermentum fermentum arcu.', 2, 19, 6);
INSERT INTO answer VALUES (7, '2017-03-20 01:25:35', 'neque. Morbi quis urna. Nunc quis', 4, 7, 16);
INSERT INTO answer VALUES (5, '2017-03-12 23:58:34', 'vitae dolor. Donec fringilla. Donec feugiat', 7, 15, 15);
INSERT INTO answer VALUES (1, '2017-03-21 18:10:01', 'Curabitur vel lectus. Cum sociis natoque penatibus et magnis', 8, 10, 14);
INSERT INTO answer VALUES (4, '2017-03-11 10:42:58', 'eget lacus. Mauris non dui', 12, 1, 10);
INSERT INTO answer VALUES (2, '2017-03-21 14:06:37', 'scelerisque sed, sapien. Nunc pulvinar arcu et pede. Nunc sed orci lobortis augue scelerisque', 14, 4, 17);
INSERT INTO answer VALUES (8, '2017-03-18 18:56:22', 'vestibulum lorem, sit amet ultricies sem magna nec quam. Curabitur vel lectus. Cum', 15, 17, 19);


--
-- Name: answer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('answer_id_seq', 1, false);


--
-- Data for Name: answer_report; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO answer_report VALUES (1, '2017-03-12 22:14:35', 'malesuada malesuada. Integer id magna et ipsum cursus vestibulum. Mauris', 2);
INSERT INTO answer_report VALUES (2, '2017-03-11 04:57:40', 'adipiscing elit. Aliquam auctor, velit eget laoreet posuere, enim nisl', 5);
INSERT INTO answer_report VALUES (6, '2017-03-22 03:21:14', 'odio. Etiam ligula tortor, dictum eu, placerat eget, venenatis a, magna. Lorem ipsum', 3);
INSERT INTO answer_report VALUES (3, '2017-03-23 15:33:08', 'Fusce feugiat. Lorem ipsum dolor sit amet, consectetuer adipiscing', 5);
INSERT INTO answer_report VALUES (4, '2017-03-16 16:21:45', 'nec ante blandit viverra. Donec tempus, lorem fringilla ornare placerat, orci lacus', 8);


--
-- Name: answer_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('answer_report_id_seq', 1, false);


--
-- Data for Name: auction; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO auction VALUES (1, 28.5899999999999999, 53.6000000000000014, '2017-03-09 07:06:36', '2017-03-09 13:44:55', 'Sealed Bid', 6, 1, '2017-03-04 09:26:31');
INSERT INTO auction VALUES (2, 75.3700000000000045, 192.539999999999992, '2017-03-06 04:57:27', '2017-03-12 22:39:07', 'Dutch', 21, 2, '2017-03-04 10:25:56');
INSERT INTO auction VALUES (15, 96.7099999999999937, 174, '2017-03-11 09:51:51', '2017-03-14 08:18:22', 'Dutch', 15, 15, '2017-03-05 04:40:38');
INSERT INTO auction VALUES (8, 41.1700000000000017, 41.1700000000000017, '2017-03-04 10:01:44', '2017-03-14 13:57:20', 'Dutch', 16, 8, '2017-03-03 08:03:13');
INSERT INTO auction VALUES (12, 79.9699999999999989, 79.9699999999999989, '2017-03-11 13:13:28', '2017-03-15 22:34:09', 'Sealed Bid', 22, 12, '2017-03-05 20:07:21');
INSERT INTO auction VALUES (11, 16.379999999999999, 79.4099999999999966, '2017-03-11 00:58:46', '2017-03-16 21:15:26', 'Sealed Bid', 1, 11, '2017-03-05 06:45:27');
INSERT INTO auction VALUES (19, 62.0799999999999983, 112.560000000000002, '2017-03-12 08:28:26', '2017-03-17 19:12:41', 'Sealed Bid', 17, 19, '2017-03-02 13:23:12');
INSERT INTO auction VALUES (18, 11.4700000000000006, 77.6400000000000006, '2017-03-14 11:22:00', '2017-03-19 13:18:47', 'Sealed Bid', 17, 18, '2017-03-07 09:20:35');
INSERT INTO auction VALUES (13, 13.5199999999999996, 150.710000000000008, '2017-03-12 15:30:06', '2017-03-19 18:24:04', 'Sealed Bid', 19, 13, '2017-03-02 12:52:11');
INSERT INTO auction VALUES (4, 29.7199999999999989, 112.560000000000002, '2017-03-05 08:29:15', '2017-03-20 16:58:02', 'Dutch', 10, 4, '2017-03-04 18:37:46');
INSERT INTO auction VALUES (6, 43.240000000000002, 76.0499999999999972, '2017-03-05 21:18:09', '2017-03-22 04:30:09', 'Dutch', 19, 6, '2017-03-03 10:17:54');
INSERT INTO auction VALUES (16, 15.5399999999999991, 15.5399999999999991, '2017-03-11 14:54:28', '2017-03-23 01:47:28', 'Dutch', 7, 16, '2017-03-05 21:24:40');
INSERT INTO auction VALUES (20, 92.2000000000000028, 180.650000000000006, '2017-03-06 07:29:37', '2017-03-23 15:05:22', 'Sealed Bid', 14, 20, '2017-03-02 06:17:09');
INSERT INTO auction VALUES (14, 55.6099999999999994, 55.6099999999999994, '2017-03-09 02:43:40', '2017-03-24 04:10:25', 'Dutch', 10, 14, '2017-03-06 22:22:49');
INSERT INTO auction VALUES (5, 66.7900000000000063, 78.3400000000000034, '2017-03-12 00:11:42', '2017-03-25 07:16:33', 'Default', 16, 5, '2017-03-08 15:14:38');
INSERT INTO auction VALUES (10, 50.0499999999999972, 98, '2017-03-08 21:08:10', '2017-03-26 09:33:15', 'Default', 1, 10, '2017-03-06 00:47:22');
INSERT INTO auction VALUES (3, 64.7600000000000051, 138.879999999999995, '2017-03-10 05:11:33', '2017-03-27 20:30:53', 'Default', 11, 3, '2017-03-05 19:10:22');
INSERT INTO auction VALUES (17, 38.990000000000002, 139.349999999999994, '2017-03-12 15:17:36', '2017-03-27 21:11:43', 'Sealed Bid', 4, 17, '2017-03-04 22:09:04');
INSERT INTO auction VALUES (9, 83.2999999999999972, 144.780000000000001, '2017-03-11 13:29:25', '2017-03-28 05:38:04', 'Dutch', 5, 9, '2017-03-02 08:34:12');
INSERT INTO auction VALUES (7, 63.9299999999999997, 63.9299999999999997, '2017-03-05 02:22:24', '2017-03-29 07:54:38', 'Dutch', 10, 7, '2017-03-04 20:18:16');


--
-- Name: auction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('auction_id_seq', 1, false);


--
-- Data for Name: auction_report; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO auction_report VALUES (2, '2017-03-06 13:22:01', 'facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec luctus aliquet odio. Etiam ligula tortor, dictum eu, placerat eget,', 8);
INSERT INTO auction_report VALUES (3, '2017-03-22 04:40:20', 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Phasellus ornare. Fusce mollis. Duis sit amet', 10);
INSERT INTO auction_report VALUES (4, '2017-03-16 15:37:14', 'enim, sit amet ornare lectus', 17);
INSERT INTO auction_report VALUES (5, '2017-03-07 16:49:21', 'ligula. Aenean gravida nunc sed pede. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur', 17);
INSERT INTO auction_report VALUES (6, '2017-03-16 21:49:32', 'felis, adipiscing fringilla, porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non', 8);
INSERT INTO auction_report VALUES (8, '2017-03-09 01:29:16', 'Integer vulputate, risus a ultricies adipiscing, enim mi tempor lorem, eget mollis lectus', 18);
INSERT INTO auction_report VALUES (9, '2017-03-04 05:56:49', 'Sed pharetra, felis eget varius ultrices, mauris', 6);
INSERT INTO auction_report VALUES (10, '2017-03-18 18:30:51', 'vel, faucibus id, libero. Donec consectetuer mauris id sapien. Cras dolor dolor, tempus non, lacinia at, iaculis quis,', 7);
INSERT INTO auction_report VALUES (1, '2017-03-21 09:23:19', 'magna tellus faucibus leo, in lobortis tellus justo sit amet nulla. Donec non justo.', 5);
INSERT INTO auction_report VALUES (7, '2017-03-22 01:00:25', 'ante bibendum ullamcorper. Duis cursus, diam at pretium aliquet, metus urna convallis erat, eget tincidunt dui augue eu tellus. Phasellus', 6);


--
-- Name: auction_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('auction_report_id_seq', 1, false);


--
-- Data for Name: bid; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO bid VALUES (1, 150.710000000000008, '2017-03-15 21:10:40', 15, 13);
INSERT INTO bid VALUES (8, 77.6400000000000006, '2017-03-18 08:01:39', 15, 18);
INSERT INTO bid VALUES (12, 114.099999999999994, '2017-03-18 06:53:20', 20, 9);
INSERT INTO bid VALUES (14, 76.75, '2017-03-15 04:27:22', 9, 10);
INSERT INTO bid VALUES (21, 49.1799999999999997, '2017-03-12 07:00:52', 25, 10);
INSERT INTO bid VALUES (22, 78.3400000000000034, '2017-03-12 21:22:12', 19, 5);
INSERT INTO bid VALUES (23, 144.780000000000001, '2017-03-26 17:49:50', 13, 9);
INSERT INTO bid VALUES (15, 53.6000000000000014, '2017-03-09 08:02:47', 2, 1);
INSERT INTO bid VALUES (13, 89, '2017-03-08 03:35:38', 8, 2);
INSERT INTO bid VALUES (19, 192.539999999999992, '2017-03-11 17:59:42', 23, 2);
INSERT INTO bid VALUES (2, 138.879999999999995, '2017-03-13 12:21:20', 9, 3);
INSERT INTO bid VALUES (25, 112.560000000000002, '2017-03-16 06:01:14', 12, 4);
INSERT INTO bid VALUES (17, 85.6899999999999977, '2017-03-07 23:08:40', 11, 4);
INSERT INTO bid VALUES (6, 76.0499999999999972, '2017-03-14 11:13:00', 7, 6);
INSERT INTO bid VALUES (9, 98, '2017-03-18 15:57:31', 23, 10);
INSERT INTO bid VALUES (10, 39.5399999999999991, '2017-03-15 21:01:12', 3, 11);
INSERT INTO bid VALUES (24, 79.4099999999999966, '2017-03-16 10:13:29', 8, 11);
INSERT INTO bid VALUES (16, 18.5599999999999987, '2017-03-12 00:39:55', 10, 11);
INSERT INTO bid VALUES (3, 56.9799999999999969, '2017-03-13 07:16:48', 25, 13);
INSERT INTO bid VALUES (4, 174, '2017-03-13 19:12:40', 19, 15);
INSERT INTO bid VALUES (11, 139.349999999999994, '2017-03-16 04:37:49', 18, 17);
INSERT INTO bid VALUES (5, 73.6800000000000068, '2017-03-13 10:04:53', 19, 19);
INSERT INTO bid VALUES (20, 112.560000000000002, '2017-03-16 02:01:01', 22, 19);
INSERT INTO bid VALUES (7, 180.650000000000006, '2017-03-13 17:07:59', 8, 20);
INSERT INTO bid VALUES (18, 153.52000000000001, '2017-03-08 15:54:48', 12, 20);


--
-- Name: bid_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('bid_id_seq', 1, false);


--
-- Data for Name: city; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO city VALUES (1, 1, 'Monaco');
INSERT INTO city VALUES (2, 2, 'Dublin');
INSERT INTO city VALUES (3, 3, 'Paris');
INSERT INTO city VALUES (4, 4, 'Zagreb');
INSERT INTO city VALUES (5, 5, 'Helsinki');
INSERT INTO city VALUES (6, 6, 'Budapest');
INSERT INTO city VALUES (7, 7, 'Athens');
INSERT INTO city VALUES (8, 8, 'Warsaw');
INSERT INTO city VALUES (9, 9, 'Tokyo');
INSERT INTO city VALUES (10, 10, 'Moscow');
INSERT INTO city VALUES (11, 11, 'Brasilia');
INSERT INTO city VALUES (12, 12, 'Stockholm');
INSERT INTO city VALUES (13, 13, 'Brussels');
INSERT INTO city VALUES (14, 14, 'Antananarivo');
INSERT INTO city VALUES (15, 15, 'Rome');
INSERT INTO city VALUES (16, 16, 'Singapore');
INSERT INTO city VALUES (17, 17, 'London');
INSERT INTO city VALUES (18, 18, 'Berlin');
INSERT INTO city VALUES (19, 19, 'Adis Abeba');
INSERT INTO city VALUES (20, 20, 'Tunes');
INSERT INTO city VALUES (21, 21, 'Buenos Aires');
INSERT INTO city VALUES (22, 22, 'Reykvavik');
INSERT INTO city VALUES (23, 23, 'Bandar Seri');
INSERT INTO city VALUES (24, 24, 'Lisbon');
INSERT INTO city VALUES (25, 25, 'Bangcock');


--
-- Name: city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('city_id_seq', 1, false);


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO country VALUES (1, 'Monaco');
INSERT INTO country VALUES (2, 'Ireland');
INSERT INTO country VALUES (3, 'France');
INSERT INTO country VALUES (4, 'Croatia');
INSERT INTO country VALUES (5, 'Finland');
INSERT INTO country VALUES (6, 'Hungary');
INSERT INTO country VALUES (7, 'Greece');
INSERT INTO country VALUES (8, 'Poland');
INSERT INTO country VALUES (9, 'Japan');
INSERT INTO country VALUES (10, 'Russia');
INSERT INTO country VALUES (11, 'Brazil');
INSERT INTO country VALUES (12, 'Sweden');
INSERT INTO country VALUES (13, 'Belgium');
INSERT INTO country VALUES (14, 'Madagascar');
INSERT INTO country VALUES (15, 'Italy');
INSERT INTO country VALUES (16, 'Singapore');
INSERT INTO country VALUES (17, 'United Kingdom');
INSERT INTO country VALUES (18, 'Germany');
INSERT INTO country VALUES (19, 'Ethiopia');
INSERT INTO country VALUES (20, 'Tunisia');
INSERT INTO country VALUES (21, 'Argentina');
INSERT INTO country VALUES (22, 'Iceland');
INSERT INTO country VALUES (23, 'Brunei');
INSERT INTO country VALUES (24, 'Portugal');
INSERT INTO country VALUES (25, 'Thailand');


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('country_id_seq', 1, true);


--
-- Data for Name: follow; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO follow VALUES (9, 16, '2017-03-07 03:43:22');
INSERT INTO follow VALUES (20, 19, '2017-03-09 12:32:37');
INSERT INTO follow VALUES (15, 1, '2017-03-19 05:07:31');
INSERT INTO follow VALUES (8, 19, '2017-03-16 12:53:44');
INSERT INTO follow VALUES (3, 20, '2017-03-05 22:59:39');
INSERT INTO follow VALUES (9, 13, '2017-03-22 11:29:06');
INSERT INTO follow VALUES (18, 14, '2017-03-04 23:07:22');
INSERT INTO follow VALUES (14, 8, '2017-03-29 22:24:44');
INSERT INTO follow VALUES (10, 1, '2017-03-19 07:58:24');
INSERT INTO follow VALUES (11, 12, '2017-03-13 23:59:42');
INSERT INTO follow VALUES (9, 7, '2017-03-06 13:57:16');
INSERT INTO follow VALUES (18, 11, '2017-03-11 00:48:13');
INSERT INTO follow VALUES (6, 13, '2017-03-25 06:38:47');
INSERT INTO follow VALUES (19, 5, '2017-03-02 14:48:43');
INSERT INTO follow VALUES (2, 19, '2017-03-18 11:46:05');
INSERT INTO follow VALUES (13, 6, '2017-03-16 16:42:33');
INSERT INTO follow VALUES (2, 4, '2017-03-24 19:06:27');
INSERT INTO follow VALUES (2, 11, '2017-03-07 06:09:44');
INSERT INTO follow VALUES (14, 15, '2017-03-10 03:44:55');
INSERT INTO follow VALUES (7, 15, '2017-03-12 18:35:35');


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO image VALUES (1, '1.bmp', 6);
INSERT INTO image VALUES (2, '2.png', 12);
INSERT INTO image VALUES (3, '3.png', 17);
INSERT INTO image VALUES (4, '4.png', 3);
INSERT INTO image VALUES (5, '5.png', 18);
INSERT INTO image VALUES (6, '6.png', 5);
INSERT INTO image VALUES (7, '7.bmp', 1);
INSERT INTO image VALUES (8, '8.png', 16);
INSERT INTO image VALUES (9, '9.bmp', 7);
INSERT INTO image VALUES (10, '10.png', 13);
INSERT INTO image VALUES (11, '11.jpg', 17);
INSERT INTO image VALUES (12, '12.png', 19);
INSERT INTO image VALUES (13, '13.jpg', 17);
INSERT INTO image VALUES (14, '14.bmp', 9);
INSERT INTO image VALUES (15, '15.bmp', 12);
INSERT INTO image VALUES (16, '16.png', 2);
INSERT INTO image VALUES (17, '17.bmp', 16);
INSERT INTO image VALUES (18, '18.jpg', 1);
INSERT INTO image VALUES (19, '19.jpg', 16);
INSERT INTO image VALUES (20, '20.jpg', 15);
INSERT INTO image VALUES (21, '21.png', 17);
INSERT INTO image VALUES (22, '22.bmp', 11);
INSERT INTO image VALUES (23, '23.png', 1);
INSERT INTO image VALUES (24, '24.png', 20);
INSERT INTO image VALUES (25, '25.png', 3);
INSERT INTO image VALUES (26, '26.bmp', 7);
INSERT INTO image VALUES (27, '27.png', 11);
INSERT INTO image VALUES (28, '28.jpg', 6);
INSERT INTO image VALUES (29, '29.png', 9);
INSERT INTO image VALUES (30, '30.jpg', 4);
INSERT INTO image VALUES (31, '31.jpg', 13);
INSERT INTO image VALUES (32, '32.png', 14);
INSERT INTO image VALUES (33, '33.png', 6);
INSERT INTO image VALUES (34, '34.bmp', 10);
INSERT INTO image VALUES (35, '35.png', 9);
INSERT INTO image VALUES (36, '36.bmp', 15);
INSERT INTO image VALUES (37, '37.bmp', 14);
INSERT INTO image VALUES (38, '38.bmp', 12);
INSERT INTO image VALUES (39, '39.png', 9);
INSERT INTO image VALUES (40, '40.bmp', 17);


--
-- Name: image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('image_id_seq', 1, false);


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO location VALUES (1, 1, 'P.O. Box 198, 5812 Pellentesque Road');
INSERT INTO location VALUES (2, 2, '200-7740 Cursus. St.');
INSERT INTO location VALUES (3, 3, '8243 Adipiscing, Ave');
INSERT INTO location VALUES (4, 4, '755-1989 Urna Ave');
INSERT INTO location VALUES (5, 5, '4418 Id Rd.');
INSERT INTO location VALUES (6, 6, 'P.O. Box 622, 4585 Enim Road');
INSERT INTO location VALUES (7, 7, 'P.O. Box 271, 4313 Vulputate, Ave');
INSERT INTO location VALUES (8, 8, '986-3772 Orci. St.');
INSERT INTO location VALUES (9, 9, 'P.O. Box 435, 1224 Rhoncus. St.');
INSERT INTO location VALUES (10, 10, '5821 Eleifend St.');
INSERT INTO location VALUES (11, 11, 'Ap #985-4146 Torquent Street');
INSERT INTO location VALUES (12, 12, '4914 Ac Av.');
INSERT INTO location VALUES (13, 13, '7161 Natoque Rd.');
INSERT INTO location VALUES (14, 14, '279-3600 Sociis Avenue');
INSERT INTO location VALUES (15, 15, '737 Ut Avenue');
INSERT INTO location VALUES (16, 16, '882-5682 Hendrerit St.');
INSERT INTO location VALUES (17, 17, '8079 Nec, Avenue');
INSERT INTO location VALUES (18, 18, '757-4827 Vulputate, Rd.');
INSERT INTO location VALUES (19, 19, '795-4148 Arcu. Rd.');
INSERT INTO location VALUES (20, 20, '7158 Sodales Avenue');
INSERT INTO location VALUES (21, 21, '9173 Non Rd.');
INSERT INTO location VALUES (22, 22, '2935 Imperdiet Street');
INSERT INTO location VALUES (23, 23, 'Ap #325-3349 Gravida St.');
INSERT INTO location VALUES (24, 24, '821-9437 A Ave');
INSERT INTO location VALUES (25, 25, 'Ap #367-7802 Pede. St.');


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('location_id_seq', 1, false);


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO notification VALUES (1, 'Lorem ipsum dolor sit amet, consectetuer', 'Answer', 8, false, '2017-03-15 04:49:18');
INSERT INTO notification VALUES (2, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed', 'Answer', 18, true, '2017-03-03 00:42:08');
INSERT INTO notification VALUES (3, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus.', 'Auction', 14, true, '2017-03-11 18:00:57');
INSERT INTO notification VALUES (4, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor.', 'Question', 12, false, '2017-03-18 10:36:06');
INSERT INTO notification VALUES (5, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor.', 'Auction', 15, false, '2017-03-09 12:45:11');
INSERT INTO notification VALUES (6, 'Lorem ipsum dolor sit amet, consectetuer', 'Auction', 12, true, '2017-03-09 04:19:15');
INSERT INTO notification VALUES (7, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing', 'Win', 20, true, '2017-03-11 16:33:33');
INSERT INTO notification VALUES (8, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed', 'Question', 2, true, '2017-03-18 17:41:37');
INSERT INTO notification VALUES (9, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur', 'Answer', 18, true, '2017-03-21 22:17:21');
INSERT INTO notification VALUES (10, 'Lorem ipsum dolor sit', 'Warning', 11, false, '2017-03-14 13:22:11');
INSERT INTO notification VALUES (11, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor.', 'Auction', 5, false, '2017-03-07 07:34:22');
INSERT INTO notification VALUES (12, 'Lorem ipsum dolor sit amet,', 'Answer', 9, false, '2017-03-07 19:03:41');
INSERT INTO notification VALUES (13, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur', 'Auction', 13, false, '2017-03-15 08:02:42');
INSERT INTO notification VALUES (14, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Warning', 18, false, '2017-03-21 17:08:04');
INSERT INTO notification VALUES (15, 'Lorem', 'Win', 16, true, '2017-03-13 20:15:47');
INSERT INTO notification VALUES (16, 'Lorem', 'Win', 6, true, '2017-03-11 02:26:16');
INSERT INTO notification VALUES (17, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus.', 'Auction', 10, false, '2017-03-14 20:28:27');
INSERT INTO notification VALUES (18, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed', 'Auction', 7, true, '2017-03-20 13:54:19');
INSERT INTO notification VALUES (19, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer', 'Answer', 20, true, '2017-03-15 00:26:42');
INSERT INTO notification VALUES (20, 'Lorem ipsum dolor', 'Question', 8, false, '2017-03-18 08:26:55');
INSERT INTO notification VALUES (21, 'Lorem', 'Warning', 9, true, '2017-03-09 21:50:19');
INSERT INTO notification VALUES (22, 'Lorem ipsum dolor sit amet, consectetuer', 'Auction', 11, false, '2017-03-12 09:16:14');
INSERT INTO notification VALUES (23, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing', 'Auction', 17, false, '2017-03-06 18:27:25');
INSERT INTO notification VALUES (24, 'Lorem ipsum', 'Win', 6, false, '2017-03-08 17:20:20');
INSERT INTO notification VALUES (25, 'Lorem ipsum dolor sit', 'Question', 2, false, '2017-03-14 07:39:03');


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('notification_id_seq', 1, false);


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO product VALUES (1, '{"Sports Souvenirs",Collectibles}', 'mauris ipsum porta elit, a', 'Fusce aliquam, enim nec tempus scelerisque, lorem ipsum sodales purus, in molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus. Aenean egestas hendrerit neque. In ornare sagittis felis. Donec tempor,');
INSERT INTO product VALUES (2, '{"Health and Beauty","Toys and Hobbies"}', 'ipsum cursus vestibulum. Mauris magna.', 'id, erat. Etiam vestibulum massa rutrum magna.');
INSERT INTO product VALUES (3, '{Books,"Toys and Hobbies"}', 'orci. Donec nibh. Quisque nonummy', 'felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus. Donec nibh enim, gravida sit amet, dapibus id, blandit at, nisi. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla');
INSERT INTO product VALUES (4, '{Books}', 'condimentum eget, volutpat ornare, facilisis', 'mauris. Suspendisse aliquet molestie tellus. Aenean egestas');
INSERT INTO product VALUES (5, '{"Cars and Vehicles"}', 'sed, sapien. Nunc pulvinar arcu', 'ut, molestie in, tempus eu, ligula. Aenean euismod mauris eu elit. Nulla facilisi. Sed neque. Sed eget lacus. Mauris non dui nec urna suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Phasellus ornare. Fusce mollis. Duis sit amet diam');
INSERT INTO product VALUES (6, '{"Health and Beauty","Cars and Vehicles"}', 'Donec est mauris, rhoncus id,', 'lorem,');
INSERT INTO product VALUES (7, '{Books}', 'ridiculus mus. Proin vel arcu', 'lectus ante dictum mi, ac mattis velit justo nec ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat');
INSERT INTO product VALUES (8, '{Books}', 'scelerisque mollis. Phasellus libero mauris,', 'commodo at, libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet luctus vulputate, nisi sem');
INSERT INTO product VALUES (9, '{"Sexual Toys"}', 'Vestibulum ante ipsum primis in', 'nec ligula');
INSERT INTO product VALUES (10, '{"Home and Garden"}', 'amet lorem semper auctor. Mauris', 'ligula tortor, dictum eu, placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam laoreet, libero et');
INSERT INTO product VALUES (11, '{"Sexual Toys",Collectibles}', 'eu, eleifend nec, malesuada ut,', 'eget, ipsum. Donec sollicitudin adipiscing ligula. Aenean gravida nunc sed pede. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin vel arcu eu odio tristique pharetra.');
INSERT INTO product VALUES (12, '{"Electronics and Computers","Dolls and Bears"}', 'metus. In nec orci. Donec', 'lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor,');
INSERT INTO product VALUES (13, '{"Movies and DVDs",Jewelry}', 'at augue id ante dictum', 'Cum sociis natoque penatibus et magnis dis');
INSERT INTO product VALUES (14, '{Books}', 'dis parturient montes, nascetur ridiculus', 'Nunc mauris elit, dictum eu, eleifend nec, malesuada ut, sem. Nulla interdum. Curabitur dictum. Phasellus in felis. Nulla tempor augue ac ipsum. Phasellus vitae mauris sit amet lorem semper auctor. Mauris vel turpis. Aliquam adipiscing lobortis risus. In mi pede, nonummy ut, molestie in, tempus eu, ligula. Aenean euismod');
INSERT INTO product VALUES (15, '{"Video Games"}', 'nec ligula consectetuer rhoncus. Nullam', 'convallis erat, eget tincidunt dui augue eu tellus. Phasellus elit pede, malesuada vel, venenatis vel, faucibus id, libero. Donec consectetuer mauris id sapien. Cras dolor');
INSERT INTO product VALUES (16, '{Books}', 'luctus sit amet, faucibus ut,', 'eu erat semper rutrum. Fusce dolor quam, elementum at, egestas a, scelerisque sed, sapien. Nunc pulvinar arcu et pede. Nunc sed orci lobortis augue scelerisque mollis. Phasellus libero mauris, aliquam eu,');
INSERT INTO product VALUES (17, '{"Sports Souvenirs",Books}', 'Suspendisse ac metus vitae velit', 'purus. Duis elementum, dui quis accumsan convallis, ante lectus convallis est, vitae sodales nisi magna sed dui. Fusce aliquam, enim nec tempus scelerisque, lorem ipsum sodales purus, in molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus. Aenean egestas');
INSERT INTO product VALUES (18, '{"Dolls and Bears"}', 'nisl. Nulla eu neque pellentesque', 'interdum ligula eu enim. Etiam imperdiet dictum magna. Ut');
INSERT INTO product VALUES (19, '{"Home and Garden"}', 'ornare sagittis felis. Donec tempor,', 'tellus sem mollis dui, in sodales elit erat vitae risus. Duis a mi fringilla mi lacinia mattis. Integer eu lacus. Quisque imperdiet, erat nonummy ultricies ornare, elit elit fermentum risus, at fringilla purus mauris a');
INSERT INTO product VALUES (20, '{Books}', 'feugiat nec, diam. Duis mi', 'Integer vulputate, risus a ultricies adipiscing, enim mi tempor lorem, eget mollis lectus pede et risus. Quisque libero lacus, varius et, euismod et, commodo at, libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet luctus vulputate, nisi sem semper');


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('product_id_seq', 1, false);


--
-- Data for Name: question; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO question VALUES (8, '2017-03-20 01:10:50', 'imperdiet non, vestibulum nec, euismod in, dolor. Fusce feugiat. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aliquam', 'et, commodo at, libero. Morbi accumsan', 4, 14);
INSERT INTO question VALUES (13, '2017-03-04 21:43:18', 'at, velit. Cras lorem lorem,', 'varius et, euismod et, commodo at,', 16, 2);
INSERT INTO question VALUES (1, '2017-03-15 07:45:48', 'eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in aliquet lobortis, nisi nibh lacinia', 'nulla at sem molestie sodales. Mauris', 12, 19);
INSERT INTO question VALUES (2, '2017-03-14 08:08:55', 'cubilia Curae; Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse', 'mauris blandit mattis. Cras eget nisi', 6, 6);
INSERT INTO question VALUES (3, '2017-03-07 06:53:48', 'amet lorem semper auctor. Mauris vel turpis. Aliquam adipiscing lobortis risus. In mi pede, nonummy', 'sed tortor. Integer aliquam adipiscing lacus.', 5, 17);
INSERT INTO question VALUES (4, '2017-03-19 02:15:46', 'mauris, rhoncus id, mollis nec, cursus', 'augue malesuada malesuada. Integer id magna', 24, 16);
INSERT INTO question VALUES (12, '2017-03-10 22:31:23', 'lacus vestibulum lorem, sit amet ultricies sem magna nec quam. Curabitur vel lectus. Cum sociis natoque penatibus', 'semper cursus. Integer mollis. Integer tincidunt', 3, 10);
INSERT INTO question VALUES (14, '2017-03-20 18:57:33', 'egestas. Fusce aliquet magna a neque. Nullam ut nisi a odio semper', 'dui. Fusce aliquam, enim nec tempus', 8, 17);
INSERT INTO question VALUES (11, '2017-03-12 05:30:37', 'Phasellus at augue id ante dictum', 'tincidunt adipiscing. Mauris molestie pharetra nibh.', 4, 8);
INSERT INTO question VALUES (10, '2017-03-15 05:52:16', 'facilisis non, bibendum sed, est. Nunc laoreet lectus quis massa. Mauris vestibulum, neque sed', 'Fusce mi lorem, vehicula et, rutrum', 17, 11);
INSERT INTO question VALUES (9, '2017-03-07 04:36:18', 'luctus vulputate, nisi sem semper erat, in consectetuer ipsum nunc id enim.', 'risus. Duis a mi fringilla mi', 9, 12);
INSERT INTO question VALUES (5, '2017-03-21 14:20:21', 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec tincidunt.', 'quis massa. Mauris vestibulum, neque sed', 12, 14);
INSERT INTO question VALUES (7, '2017-03-10 15:00:31', 'libero. Proin mi. Aliquam gravida mauris', 'Ut tincidunt vehicula risus. Nulla eget', 10, 15);
INSERT INTO question VALUES (15, '2017-03-16 12:51:05', 'Aenean massa. Integer vitae nibh. Donec est mauris, rhoncus id, mollis nec, cursus a, enim. Suspendisse aliquet,', 'enim nec tempus scelerisque, lorem ipsum', 14, 19);
INSERT INTO question VALUES (6, '2017-03-19 14:55:34', 'ac libero nec ligula consectetuer rhoncus. Nullam', 'pede nec ante blandit viverra. Donec', 11, 20);


--
-- Name: question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('question_id_seq', 1, false);


--
-- Data for Name: question_report; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO question_report VALUES (1, '2017-03-11 01:42:50', 'rhoncus. Proin nisl sem, consequat', 3);
INSERT INTO question_report VALUES (2, '2017-03-08 21:39:54', 'aliquet, metus urna convallis erat, eget tincidunt dui augue eu tellus. Phasellus elit', 6);
INSERT INTO question_report VALUES (3, '2017-03-07 20:46:40', 'egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae, posuere at,', 6);
INSERT INTO question_report VALUES (4, '2017-03-21 00:10:24', 'a, malesuada id, erat. Etiam vestibulum', 1);
INSERT INTO question_report VALUES (5, '2017-03-14 20:18:04', 'ante, iaculis nec, eleifend non, dapibus', 4);
INSERT INTO question_report VALUES (6, '2017-03-03 21:38:13', 'risus odio, auctor vitae, aliquet nec, imperdiet nec, leo. Morbi neque tellus, imperdiet', 2);
INSERT INTO question_report VALUES (7, '2017-03-30 19:12:24', 'Sed eu eros. Nam consequat dolor vitae dolor. Donec fringilla. Donec feugiat metus', 15);
INSERT INTO question_report VALUES (8, '2017-03-10 16:31:56', 'vestibulum, neque sed dictum eleifend, nunc risus varius orci, in consequat enim diam', 3);
INSERT INTO question_report VALUES (9, '2017-03-22 04:59:42', 'ligula. Nullam enim. Sed nulla ante, iaculis nec,', 11);
INSERT INTO question_report VALUES (10, '2017-03-07 11:24:56', 'lacinia vitae, sodales at, velit.', 12);


--
-- Name: question_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('question_report_id_seq', 1, false);


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO review VALUES (3, 3, 'parturient montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu. Sed', '2017-03-14 05:41:07', 19);
INSERT INTO review VALUES (4, 7, 'Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus. Aenean egestas hendrerit neque. In ornare sagittis felis. Donec', '2017-03-24 10:44:42', 7);
INSERT INTO review VALUES (1, 8, 'Praesent eu nulla at sem molestie sodales. Mauris blandit enim consequat purus.', '2017-03-21 16:46:09', 25);
INSERT INTO review VALUES (2, 1, 'ac turpis egestas. Aliquam fringilla cursus purus. Nullam scelerisque neque sed sem egestas blandit. Nam', '2017-03-20 13:29:19', 24);
INSERT INTO review VALUES (5, 6, 'sed, facilisis vitae, orci. Phasellus dapibus quam quis diam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames', '2017-03-20 05:21:45', 20);


--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('review_id_seq', 1, false);


--
-- Data for Name: review_report; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO review_report VALUES (1, '2017-03-29 08:25:01', 'pede. Praesent eu dui. Cum sociis natoque penatibus et magnis dis', 3);


--
-- Name: review_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('review_report_id_seq', 1, false);


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO "user" VALUES (4, 'Romero', 'malesuada.ut@enimnonnisi.org', 'Brent', 'adipiscing elit. Aliquam auctor, velit eget laoreet posuere, enim nisl elementum purus, accumsan interdum libero', NULL, 'HZZ83KYX0VR', '(09) 929 462 326', '2017-04-03 11:49:24', 4, NULL, NULL);
INSERT INTO "user" VALUES (5, 'Becker', 'nulla@enimdiamvel.co.uk', 'Teagan', 'lectus rutrum urna, nec luctus felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem,', NULL, 'KFD08MQZ8YE', '(06) 301 746 284', '2017-05-21 04:29:35', 12, NULL, NULL);
INSERT INTO "user" VALUES (10, 'Bowers', 'auctor.velit.eget@risus.ca', 'Laith', 'ultrices posuere cubilia Curae; Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque', NULL, 'JTU77JSO0XU', '(03) 874 515 612', '2017-04-02 20:09:50', 16, NULL, NULL);
INSERT INTO "user" VALUES (11, 'Townsend', 'at.libero@est.org', 'Brenda', 'Donec tempus, lorem fringilla ornare placerat, orci lacus vestibulum lorem, sit amet ultricies sem magna', NULL, 'NRM81OWS2OV', '(08) 147 274 376', '2017-04-04 17:28:39', 13, NULL, NULL);
INSERT INTO "user" VALUES (12, 'Tyler', 'Cras@ametrisus.net', 'Adrian', 'purus. Nullam scelerisque neque sed sem egestas blandit. Nam nulla magna, malesuada vel, convallis in,', NULL, 'DJI32DGL7PN', '(08) 066 946 130', '2017-05-15 18:48:25', 12, NULL, NULL);
INSERT INTO "user" VALUES (13, 'Willis', 'enim.condimentum@Nullamutnisi.net', 'Daniel', 'vitae semper egestas, urna justo faucibus lectus, a sollicitudin orci sem eget massa. Suspendisse eleifend.', NULL, 'UDL44PJX3YG', '(03) 365 593 569', '2017-07-23 04:30:34', 18, NULL, NULL);
INSERT INTO "user" VALUES (14, 'Palmer', 'consectetuer.adipiscing.elit@utsem.com', 'Lenore', 'mi pede, nonummy ut, molestie in, tempus eu, ligula. Aenean euismod mauris eu elit. Nulla', NULL, 'QBC46HME1QM', '(07) 041 222 487', '2017-02-15 14:58:55', 4, NULL, NULL);
INSERT INTO "user" VALUES (15, 'Meyer', 'egestas@primisinfaucibus.net', 'Adena', 'at, nisi. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin', NULL, 'TGJ32CBB3WW', '(01) 606 570 428', '2017-03-05 15:14:38', 6, NULL, NULL);
INSERT INTO "user" VALUES (16, 'Christian', 'mauris.a.nunc@sitametmetus.net', 'Angela', 'felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum eu, ultrices', NULL, 'GLW57ESV1SO', '(02) 875 964 716', '2017-04-05 22:21:47', 22, NULL, NULL);
INSERT INTO "user" VALUES (20, 'Hardy', 'molestie.pharetra@inaliquet.edu', 'Brian', 'ut quam vel sapien imperdiet ornare. In faucibus. Morbi vehicula. Pellentesque tincidunt tempus risus. Donec', NULL, 'IMG27BBA1IR', '(07) 121 967 929', '2017-06-07 20:47:04', 22, NULL, NULL);
INSERT INTO "user" VALUES (22, 'Gilliam', 'aliquam.iaculis@sitamet.net', 'Danielle', 'libero. Proin mi. Aliquam gravida mauris ut mi. Duis risus odio, auctor vitae, aliquet nec,', NULL, 'BKR31SCG6QZ', '(08) 653 083 528', '2017-02-11 01:11:30', 23, NULL, NULL);
INSERT INTO "user" VALUES (25, 'Wise', 'ipsum.porta@utnullaCras.co.uk', 'Eleanor', 'odio tristique pharetra. Quisque ac libero nec ligula consectetuer rhoncus. Nullam velit dui, semper et,', NULL, 'EGV61HMX2RW', '(01) 075 231 883', '2017-05-29 07:23:03', 2, NULL, NULL);
INSERT INTO "user" VALUES (1, 'Burton', 'orci@mauris.edu', 'Kylan', 'turpis non enim. Mauris quis turpis vitae purus gravida sagittis. Duis gravida. Praesent eu nulla', NULL, 'RXZ31ALQ6DT', '177 871 612', '2017-04-13 14:28:44', 13, NULL, NULL);
INSERT INTO "user" VALUES (2, 'Dyer', 'enim.commodo@penatibusetmagnis.ca', 'Hamish', 'congue turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus', NULL, 'UYE06KUX3NU', '(07) 365 867 245', '2017-07-02 06:16:54', 16, 'Dyer.jpg', NULL);
INSERT INTO "user" VALUES (3, 'Jennings', 'vestibulum.nec.euismod@idenimCurabitur.co.uk', 'Joy', 'diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos', NULL, 'IDS86KLR5ZH', '298 864 407', '2017-07-27 20:08:29', 8, NULL, NULL);
INSERT INTO "user" VALUES (6, 'Ramos', 'Phasellus.nulla.Integer@loremac.org', 'Valentine', 'amet metus. Aliquam erat volutpat. Nulla facilisis. Suspendisse commodo tincidunt nibh. Phasellus nulla. Integer vulputate,', NULL, 'YTU61DVX1GM', '(04) 930 300 923', '2017-04-12 20:44:14', 22, NULL, NULL);
INSERT INTO "user" VALUES (7, 'Davis', 'Duis.dignissim.tempor@nislelementum.ca', 'Ruby', 'massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor non, feugiat nec,', NULL, 'WAF42UBV8ZO', '260 636 980', '2017-04-26 02:54:49', 11, NULL, NULL);
INSERT INTO "user" VALUES (8, 'Kinney', 'Mauris@etrutrumeu.net', 'Austin', 'mollis vitae, posuere at, velit. Cras lorem lorem, luctus ut, pellentesque eget, dictum placerat, augue.', NULL, 'DBV77CYZ5KU', '120 624 980', '2017-05-31 10:25:24', 1, 'Kinney.jpg', NULL);
INSERT INTO "user" VALUES (9, 'Booker', 'id.mollis.nec@ligulaeu.net', 'Emma', 'magnis dis parturient montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla euismod enim. Etiam', NULL, 'TVI84PMT0ER', '190 636 950', '2017-05-24 06:20:03', 9, NULL, NULL);
INSERT INTO "user" VALUES (17, 'Walter', 'eu.tellus@dui.net', 'Troy', 'massa. Mauris vestibulum, neque sed dictum eleifend, nunc risus varius orci, in consequat enim diam', NULL, 'KER37IWE0EZ', '357 734 185', '2017-06-07 03:15:15', 24, NULL, NULL);
INSERT INTO "user" VALUES (18, 'Cleveland', 'lorem.fringilla@sollicitudin.co.uk', 'September', 'lobortis risus. In mi pede, nonummy ut, molestie in, tempus eu, ligula. Aenean euismod mauris', NULL, 'SMA91SZQ5XG', '291 046 712', '2017-03-19 03:16:00', 3, NULL, NULL);
INSERT INTO "user" VALUES (19, 'Hobbs', 'a.magna.Lorem@loremtristiquealiquet.net', 'Francis', 'Vivamus non lorem vitae odio sagittis semper. Nam tempor diam dictum sapien. Aenean massa. Integer', NULL, 'WMK09CMM7AC', '(01) 935 777 211', '2017-05-25 17:25:40', 1, 'Hobbs.png', NULL);
INSERT INTO "user" VALUES (21, 'Elliott', 'sem.ut@libero.org', 'Craig', 'rutrum eu, ultrices sit amet, risus. Donec nibh enim, gravida sit amet, dapibus id, blandit', NULL, 'MLC88ATX6OB', '494 073 167', '2017-02-23 04:44:33', 2, NULL, NULL);
INSERT INTO "user" VALUES (23, 'Fox', 'litora.torquent.per@nislNullaeu.net', 'Dale', 'aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam', NULL, 'WVT56BDS6TL', '(01) 171 574 614', '2017-03-15 23:22:40', 7, 'Fox.jpg', NULL);
INSERT INTO "user" VALUES (24, 'Gardner', 'risus@mus.edu', 'Rogan', 'felis. Donec tempor, est ac mattis semper, dui lectus rutrum urna, nec luctus felis purus', NULL, 'NIG86PVG9XF', '430 826 295', '2017-04-30 00:31:32', 25, NULL, NULL);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('user_id_seq', 1, false);


--
-- Data for Name: user_report; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO user_report VALUES (1, '2017-03-29 08:25:01', 'pede. Praesent eu dui. Cum sociis natoque penatibus et magnis dis', 3);
INSERT INTO user_report VALUES (2, '2017-03-14 01:06:27', 'auctor quis, tristique ac, eleifend vitae, erat. Vivamus', 14);
INSERT INTO user_report VALUES (3, '2017-03-14 20:22:15', 'placerat, augue. Sed molestie. Sed id risus quis diam luctus lobortis. Class aptent taciti sociosqu', 6);
INSERT INTO user_report VALUES (4, '2017-03-22 20:11:23', 'Proin dolor. Nulla semper tellus id nunc interdum feugiat.', 8);
INSERT INTO user_report VALUES (5, '2017-03-24 02:33:35', 'ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit', 18);
INSERT INTO user_report VALUES (6, '2017-03-02 12:33:50', 'Nunc sollicitudin commodo ipsum.', 25);
INSERT INTO user_report VALUES (7, '2017-03-10 19:51:29', 'accumsan convallis, ante lectus convallis est, vitae sodales nisi magna sed dui. Fusce aliquam, enim nec tempus scelerisque, lorem ipsum', 7);
INSERT INTO user_report VALUES (8, '2017-03-16 09:16:30', 'ornare. Fusce mollis. Duis sit', 16);
INSERT INTO user_report VALUES (9, '2017-03-03 03:46:04', 'et nunc. Quisque ornare tortor at risus. Nunc ac sem', 21);
INSERT INTO user_report VALUES (10, '2017-03-10 20:55:15', 'risus. In Lorem ipsun', 20);


--
-- Name: user_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lbaw1662
--

SELECT pg_catalog.setval('user_report_id_seq', 1, false);


--
-- Data for Name: watchlist; Type: TABLE DATA; Schema: public; Owner: lbaw1662
--

INSERT INTO watchlist VALUES (14, 14, false, '2017-03-09 10:15:48');
INSERT INTO watchlist VALUES (7, 6, false, '2017-03-11 07:14:12');
INSERT INTO watchlist VALUES (11, 4, false, '2017-03-11 04:35:48');
INSERT INTO watchlist VALUES (13, 21, true, '2017-03-16 17:09:45');
INSERT INTO watchlist VALUES (20, 6, true, '2017-03-07 14:19:16');
INSERT INTO watchlist VALUES (20, 3, false, '2017-03-21 03:08:34');
INSERT INTO watchlist VALUES (14, 12, false, '2017-03-11 14:46:57');
INSERT INTO watchlist VALUES (3, 2, true, '2017-03-22 18:31:24');
INSERT INTO watchlist VALUES (20, 19, true, '2017-03-12 07:29:37');
INSERT INTO watchlist VALUES (16, 12, false, '2017-03-22 01:42:51');
INSERT INTO watchlist VALUES (13, 8, false, '2017-03-09 03:26:00');
INSERT INTO watchlist VALUES (13, 6, false, '2017-03-16 11:13:00');
INSERT INTO watchlist VALUES (6, 4, true, '2017-03-10 12:52:03');
INSERT INTO watchlist VALUES (1, 5, false, '2017-03-08 16:00:45');
INSERT INTO watchlist VALUES (2, 2, true, '2017-03-05 04:54:35');
INSERT INTO watchlist VALUES (2, 7, false, '2017-03-11 16:47:59');
INSERT INTO watchlist VALUES (7, 19, true, '2017-03-14 08:27:03');
INSERT INTO watchlist VALUES (7, 24, false, '2017-03-23 05:59:55');
INSERT INTO watchlist VALUES (7, 25, false, '2017-03-18 05:57:52');
INSERT INTO watchlist VALUES (11, 20, false, '2017-03-14 05:46:51');


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
-- Name: answer_question_id_user_id_index; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX answer_question_id_user_id_index ON answer USING btree (question_id, user_id);


--
-- Name: auction_end_date_index; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX auction_end_date_index ON auction USING btree (end_date);

ALTER TABLE auction CLUSTER ON auction_end_date_index;


--
-- Name: auction_user_id_index; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX auction_user_id_index ON auction USING hash (user_id);


--
-- Name: bid_auction_id_index; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX bid_auction_id_index ON bid USING hash (auction_id);


--
-- Name: bid_user_id_index; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX bid_user_id_index ON bid USING hash (user_id);


--
-- Name: country_name_uindex; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX country_name_uindex ON country USING btree (name);


--
-- Name: image_filename_uindex; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX image_filename_uindex ON image USING btree (filename);


--
-- Name: question_auction_id_index; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX question_auction_id_index ON question USING hash (auction_id);


--
-- Name: review_bid_id_index; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX review_bid_id_index ON review USING hash (bid_id);


--
-- Name: user_email_uindex; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX user_email_uindex ON "user" USING btree (email);


--
-- Name: user_username_uindex; Type: INDEX; Schema: public; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX user_username_uindex ON "user" USING btree (username);


--
-- Name: answer_is_of_seller; Type: TRIGGER; Schema: public; Owner: lbaw1662
--

CREATE TRIGGER answer_is_of_seller BEFORE INSERT OR UPDATE ON answer FOR EACH ROW EXECUTE PROCEDURE answer_is_of_seller();


--
-- Name: auction_deleted; Type: TRIGGER; Schema: public; Owner: lbaw1662
--

CREATE TRIGGER auction_deleted BEFORE DELETE ON auction FOR EACH ROW EXECUTE PROCEDURE warn_bidders();


--
-- Name: new_answer_report; Type: TRIGGER; Schema: public; Owner: lbaw1662
--

CREATE TRIGGER new_answer_report AFTER INSERT ON answer_report FOR EACH ROW EXECUTE PROCEDURE answer_report_notification();


--
-- Name: new_auction_report; Type: TRIGGER; Schema: public; Owner: lbaw1662
--

CREATE TRIGGER new_auction_report AFTER INSERT ON auction_report FOR EACH ROW EXECUTE PROCEDURE auction_report_notification();


--
-- Name: new_bid; Type: TRIGGER; Schema: public; Owner: lbaw1662
--

CREATE TRIGGER new_bid BEFORE INSERT ON bid FOR EACH ROW EXECUTE PROCEDURE update_auction();


--
-- Name: new_question_report; Type: TRIGGER; Schema: public; Owner: lbaw1662
--

CREATE TRIGGER new_question_report AFTER INSERT ON question_report FOR EACH ROW EXECUTE PROCEDURE question_report_notification();


--
-- Name: new_review_report; Type: TRIGGER; Schema: public; Owner: lbaw1662
--

CREATE TRIGGER new_review_report AFTER INSERT ON review_report FOR EACH ROW EXECUTE PROCEDURE review_report_notification();


--
-- Name: new_user_report; Type: TRIGGER; Schema: public; Owner: lbaw1662
--

CREATE TRIGGER new_user_report AFTER INSERT ON user_report FOR EACH ROW EXECUTE PROCEDURE user_report_notification();


--
-- Name: review_trigger; Type: TRIGGER; Schema: public; Owner: lbaw1662
--

CREATE TRIGGER review_trigger AFTER INSERT OR UPDATE ON review FOR EACH ROW EXECUTE PROCEDURE review_trigger();


--
-- Name: seller_cannot_bid; Type: TRIGGER; Schema: public; Owner: lbaw1662
--

CREATE TRIGGER seller_cannot_bid BEFORE INSERT OR UPDATE ON bid FOR EACH ROW EXECUTE PROCEDURE seller_cannot_bid();


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

