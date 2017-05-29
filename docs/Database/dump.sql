--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = final, pg_catalog;

ALTER TABLE ONLY final.watchlist DROP CONSTRAINT watchlist_user_fk;
ALTER TABLE ONLY final.watchlist DROP CONSTRAINT watchlist_auction_fk;
ALTER TABLE ONLY final.user_report DROP CONSTRAINT user_report_fk;
ALTER TABLE ONLY final."user" DROP CONSTRAINT user_fk;
ALTER TABLE ONLY final.review DROP CONSTRAINT review_fk;
ALTER TABLE ONLY final.question DROP CONSTRAINT question_user_fk;
ALTER TABLE ONLY final.question_report DROP CONSTRAINT question_report_fk;
ALTER TABLE ONLY final.question DROP CONSTRAINT question_auction_fk;
ALTER TABLE ONLY final.product_category DROP CONSTRAINT product_category_product_fk;
ALTER TABLE ONLY final.product_category DROP CONSTRAINT product_category_category_fk;
ALTER TABLE ONLY final.notification DROP CONSTRAINT notification_fk;
ALTER TABLE ONLY final.image DROP CONSTRAINT image_fk;
ALTER TABLE ONLY final.follow DROP CONSTRAINT follow_user_following_fk;
ALTER TABLE ONLY final.follow DROP CONSTRAINT follow_user_followed_fk;
ALTER TABLE ONLY final.feedback DROP CONSTRAINT feedback_user_id_fk;
ALTER TABLE ONLY final.city DROP CONSTRAINT city_fk;
ALTER TABLE ONLY final.bid DROP CONSTRAINT bid_user_fk;
ALTER TABLE ONLY final.bid DROP CONSTRAINT bid_auction_fk;
ALTER TABLE ONLY final.auction DROP CONSTRAINT auction_user_fk;
ALTER TABLE ONLY final.auction_report DROP CONSTRAINT auction_report_fk;
ALTER TABLE ONLY final.auction DROP CONSTRAINT auction_product_fk;
ALTER TABLE ONLY final.answer DROP CONSTRAINT answer_user_fk;
ALTER TABLE ONLY final.answer_report DROP CONSTRAINT answer_report_fk;
ALTER TABLE ONLY final.answer DROP CONSTRAINT answer_question_fk;
DROP TRIGGER seller_cannot_bid ON final.bid;
DROP TRIGGER review_trigger ON final.review;
DROP TRIGGER remove_review ON final.review;
DROP TRIGGER new_user_report ON final.user_report;
DROP TRIGGER new_question_report ON final.question_report;
DROP TRIGGER new_bid ON final.bid;
DROP TRIGGER new_auction_report ON final.auction_report;
DROP TRIGGER new_answer_report ON final.answer_report;
DROP TRIGGER auction_deleted ON final.auction;
DROP INDEX final.user_username_uindex;
DROP INDEX final.user_username_bio_idx;
DROP INDEX final.user_email_uindex;
DROP INDEX final.review_bid_id_index;
DROP INDEX final.question_auction_id_index;
DROP INDEX final.notification_user_id_index;
DROP INDEX final.image_filename_uindex;
DROP INDEX final.fts_product_idx;
DROP INDEX final.country_name_uindex;
DROP INDEX final.bid_user_id_index;
DROP INDEX final.bid_auction_id_index;
DROP INDEX final.auction_user_id_index;
DROP INDEX final.auction_end_date_index;
DROP INDEX final.answer_question_id_user_id_index;
DROP INDEX final.admin_username_uindex;
DROP INDEX final.admin_email_uindex;
ALTER TABLE ONLY final.watchlist DROP CONSTRAINT watchlist_pk;
ALTER TABLE ONLY final.user_report DROP CONSTRAINT user_report_pkey;
ALTER TABLE ONLY final."user" DROP CONSTRAINT user_pkey;
ALTER TABLE ONLY final.review DROP CONSTRAINT review_pkey;
ALTER TABLE ONLY final.question_report DROP CONSTRAINT question_report_pkey;
ALTER TABLE ONLY final.question DROP CONSTRAINT question_pkey;
ALTER TABLE ONLY final.product DROP CONSTRAINT product_pkey;
ALTER TABLE ONLY final.product_category DROP CONSTRAINT product_category_pkey;
ALTER TABLE ONLY final.password_request DROP CONSTRAINT password_request_token_uindex;
ALTER TABLE ONLY final.password_request DROP CONSTRAINT password_request_pkey;
ALTER TABLE ONLY final.notification DROP CONSTRAINT notification_pkey;
ALTER TABLE ONLY final.image DROP CONSTRAINT image_pkey;
ALTER TABLE ONLY final.follow DROP CONSTRAINT follow_pk;
ALTER TABLE ONLY final.feedback DROP CONSTRAINT feedback_pkey;
ALTER TABLE ONLY final.country DROP CONSTRAINT country_pkey;
ALTER TABLE ONLY final.city DROP CONSTRAINT city_pkey;
ALTER TABLE ONLY final.category DROP CONSTRAINT category_pkey;
ALTER TABLE ONLY final.category DROP CONSTRAINT category_name_key;
ALTER TABLE ONLY final.bid DROP CONSTRAINT bid_pkey;
ALTER TABLE ONLY final.auction_report DROP CONSTRAINT auction_report_pkey;
ALTER TABLE ONLY final.auction DROP CONSTRAINT auction_pkey;
ALTER TABLE ONLY final.answer_report DROP CONSTRAINT answer_report_pkey;
ALTER TABLE ONLY final.answer DROP CONSTRAINT answer_pkey;
ALTER TABLE ONLY final.admin DROP CONSTRAINT admin_pkey;
ALTER TABLE final.user_report ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final."user" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.review ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.question_report ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.question ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.product ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.password_request ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.notification ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.image ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.feedback ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.country ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.city ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.category ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.bid ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.auction_report ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.auction ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.answer_report ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.answer ALTER COLUMN id DROP DEFAULT;
ALTER TABLE final.admin ALTER COLUMN id DROP DEFAULT;
DROP TABLE final.watchlist;
DROP SEQUENCE final.user_report_id_seq;
DROP TABLE final.user_report;
DROP SEQUENCE final.user_id_seq;
DROP TABLE final."user";
DROP SEQUENCE final.review_id_seq;
DROP TABLE final.review;
DROP SEQUENCE final.question_report_id_seq;
DROP TABLE final.question_report;
DROP SEQUENCE final.question_id_seq;
DROP TABLE final.question;
DROP SEQUENCE final.product_id_seq;
DROP TABLE final.product_category;
DROP TABLE final.product;
DROP SEQUENCE final.password_request_id_seq;
DROP TABLE final.password_request;
DROP SEQUENCE final.notification_id_seq;
DROP TABLE final.notification;
DROP SEQUENCE final.image_id_seq;
DROP TABLE final.image;
DROP TABLE final.follow;
DROP SEQUENCE final.feedback_id_seq;
DROP TABLE final.feedback;
DROP SEQUENCE final.country_id_seq;
DROP TABLE final.country;
DROP SEQUENCE final.city_id_seq;
DROP TABLE final.city;
DROP SEQUENCE final.category_id_seq;
DROP TABLE final.category;
DROP SEQUENCE final.bid_id_seq;
DROP TABLE final.bid;
DROP SEQUENCE final.auction_report_id_seq;
DROP TABLE final.auction_report;
DROP SEQUENCE final.auction_id_seq;
DROP TABLE final.auction;
DROP SEQUENCE final.answer_report_id_seq;
DROP TABLE final.answer_report;
DROP SEQUENCE final.answer_id_seq;
DROP TABLE final.answer;
DROP SEQUENCE final.admin_id_seq;
DROP TABLE final.admin;
DROP FUNCTION final.warn_bidders();
DROP FUNCTION final.user_report_notification();
DROP FUNCTION final.update_auction();
DROP FUNCTION final.seller_cannot_bid();
DROP FUNCTION final.review_trigger();
DROP FUNCTION final.remove_review();
DROP FUNCTION final.question_report_notification();
DROP FUNCTION final.auction_report_notification();
DROP FUNCTION final.answer_report_notification();
DROP TYPE final.notification_type;
DROP TYPE final.auction_type;
DROP TYPE final.auction_state;
DROP SCHEMA final;
--
-- Name: final; Type: SCHEMA; Schema: -; Owner: lbaw1662
--

CREATE SCHEMA final;


ALTER SCHEMA final OWNER TO lbaw1662;

SET search_path = final, pg_catalog;

--
-- Name: auction_state; Type: TYPE; Schema: final; Owner: lbaw1662
--

CREATE TYPE auction_state AS ENUM (
    'Created',
    'Open',
    'Closed'
);


ALTER TYPE auction_state OWNER TO lbaw1662;

--
-- Name: auction_type; Type: TYPE; Schema: final; Owner: lbaw1662
--

CREATE TYPE auction_type AS ENUM (
    'Default',
    'Dutch',
    'Sealed Bid'
);


ALTER TYPE auction_type OWNER TO lbaw1662;

--
-- Name: notification_type; Type: TYPE; Schema: final; Owner: lbaw1662
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
-- Name: answer_report_notification(); Type: FUNCTION; Schema: final; Owner: lbaw1662
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


ALTER FUNCTION final.answer_report_notification() OWNER TO lbaw1662;

--
-- Name: auction_report_notification(); Type: FUNCTION; Schema: final; Owner: lbaw1662
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


ALTER FUNCTION final.auction_report_notification() OWNER TO lbaw1662;

--
-- Name: question_report_notification(); Type: FUNCTION; Schema: final; Owner: lbaw1662
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


ALTER FUNCTION final.question_report_notification() OWNER TO lbaw1662;

--
-- Name: remove_review(); Type: FUNCTION; Schema: final; Owner: lbaw1662
--

CREATE FUNCTION remove_review() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  seller_id INTEGER;
BEGIN
  SELECT "user".id
   FROM "user"
     INNER JOIN bid ON bid.id = old.bid_id
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
END;$$;


ALTER FUNCTION final.remove_review() OWNER TO lbaw1662;

--
-- Name: review_trigger(); Type: FUNCTION; Schema: final; Owner: lbaw1662
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


ALTER FUNCTION final.review_trigger() OWNER TO lbaw1662;

--
-- Name: seller_cannot_bid(); Type: FUNCTION; Schema: final; Owner: lbaw1662
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


ALTER FUNCTION final.seller_cannot_bid() OWNER TO lbaw1662;

--
-- Name: update_auction(); Type: FUNCTION; Schema: final; Owner: lbaw1662
--

CREATE FUNCTION update_auction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  latest_bidder INTEGER;
BEGIN
  SELECT bid.user_id
       FROM bid
       WHERE bid.auction_id = NEW.auction_id
       ORDER BY bid.amount DESC LIMIT 1
  INTO latest_bidder;
  IF NEW.date >
    (SELECT end_date
     FROM auction
     WHERE auction.id = NEW.auction_id)
  THEN RAISE EXCEPTION 'Auction closed!';
  ELSEIF NEW.amount >
    (SELECT amount
     FROM bid
     WHERE bid.auction_id = NEW.auction_id
     ORDER BY amount DESC LIMIT 1)
    OR NEW.amount > (SELECT curr_bid FROM auction WHERE auction.id = NEW.auction_id)
  THEN
    IF latest_bidder IS NOT NULL
    THEN 
    INSERT INTO notification (user_id, message, TYPE, DATE, is_new) VALUES(
      (SELECT bid.user_id
       FROM bid
       WHERE bid.auction_id = NEW.auction_id
       ORDER BY bid.amount DESC LIMIT 1),
      'Your bid on the auction ' ||
      (SELECT product.name
       FROM product
         INNER JOIN auction ON auction.product_id = product.id
       WHERE auction.id = NEW.auction_id) || ' was surpassed.',
      'Auction',
      now(),
      'true'
    );
    END IF;
    INSERT INTO notification (user_id, message, TYPE, DATE, is_new) VALUES(
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
         INNER JOIN auction ON auction.product_id = product.id
       WHERE auction.id = NEW.auction_id) || '.',
      'Auction',
      now(),
      'true'
    );
    UPDATE auction
    SET curr_bid = NEW.amount, num_bids = num_bids + 1
    WHERE id = NEW.auction_id;
  ELSE RAISE EXCEPTION 'Bid amount must be higher than the current bid.';
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION final.update_auction() OWNER TO lbaw1662;

--
-- Name: user_report_notification(); Type: FUNCTION; Schema: final; Owner: lbaw1662
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


ALTER FUNCTION final.user_report_notification() OWNER TO lbaw1662;

--
-- Name: warn_bidders(); Type: FUNCTION; Schema: final; Owner: lbaw1662
--

CREATE FUNCTION warn_bidders() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
  _bidder INTEGER;
  _auction VARCHAR(64);
  latest_bidder INTEGER;
BEGIN
  SELECT bid.user_id
       FROM bid
       WHERE bid.auction_id = OLD.id
       ORDER BY bid.amount DESC LIMIT 1
  INTO latest_bidder;
  SELECT product.name
    FROM product
    WHERE OLD.product_id = product.id
    INTO _auction;
  IF latest_bidder IS NOT NULL
    THEN 
    UPDATE "user" set amount = amount + OLD.curr_bid WHERE id = latest_bidder;
  END IF;
  FOR _bidder IN (
    SELECT DISTINCT "user".id
    FROM "user", bid
    WHERE "user".id = bid.user_id AND bid.auction_id = OLD.id)

  LOOP
    INSERT INTO notification (user_id, message, type, date, is_new) VALUES(
      _bidder,
      'The auction ' || _auction || ' and respectives bids/posts were removed.',
      'Auction',
      now(),
      true
    );
  END LOOP;
  INSERT INTO notification (user_id, message, TYPE, DATE, is_new) VALUES(
      OLD.user_id,
      'Your auction ' || _auction || ' was deleted.',
      'Auction',
      now(),
      'true'
    );
  RETURN OLD;
END;
$$;


ALTER FUNCTION final.warn_bidders() OWNER TO lbaw1662;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE admin (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    email character varying(64) NOT NULL,
    hashed_pass character varying(64) NOT NULL
);


ALTER TABLE admin OWNER TO lbaw1662;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE admin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin_id_seq OWNER TO lbaw1662;

--
-- Name: admin_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE admin_id_seq OWNED BY admin.id;


--
-- Name: answer; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE answer (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    question_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE answer OWNER TO lbaw1662;

--
-- Name: answer_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE answer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE answer_id_seq OWNER TO lbaw1662;

--
-- Name: answer_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE answer_id_seq OWNED BY answer.id;


--
-- Name: answer_report; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE answer_report (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    answer_id integer NOT NULL
);


ALTER TABLE answer_report OWNER TO lbaw1662;

--
-- Name: answer_report_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE answer_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE answer_report_id_seq OWNER TO lbaw1662;

--
-- Name: answer_report_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE answer_report_id_seq OWNED BY answer_report.id;


--
-- Name: auction; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
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
    quantity integer DEFAULT 1 NOT NULL,
    questions_section boolean DEFAULT true NOT NULL,
    num_bids integer DEFAULT 0 NOT NULL,
    state auction_state DEFAULT 'Created'::auction_state NOT NULL,
    CONSTRAINT auction_date_ck CHECK (((date < start_date) AND (start_date < end_date)))
);


ALTER TABLE auction OWNER TO lbaw1662;

--
-- Name: auction_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE auction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auction_id_seq OWNER TO lbaw1662;

--
-- Name: auction_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE auction_id_seq OWNED BY auction.id;


--
-- Name: auction_report; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE auction_report (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    auction_id integer NOT NULL
);


ALTER TABLE auction_report OWNER TO lbaw1662;

--
-- Name: auction_report_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE auction_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auction_report_id_seq OWNER TO lbaw1662;

--
-- Name: auction_report_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE auction_report_id_seq OWNED BY auction_report.id;


--
-- Name: bid; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
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
-- Name: bid_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE bid_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bid_id_seq OWNER TO lbaw1662;

--
-- Name: bid_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE bid_id_seq OWNED BY bid.id;


--
-- Name: category; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE category (
    id integer NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE category OWNER TO lbaw1662;

--
-- Name: category_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_id_seq OWNER TO lbaw1662;

--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE category_id_seq OWNED BY category.id;


--
-- Name: city; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE city (
    id integer NOT NULL,
    country_id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE city OWNER TO lbaw1662;

--
-- Name: city_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE city_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE city_id_seq OWNER TO lbaw1662;

--
-- Name: city_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE city_id_seq OWNED BY city.id;


--
-- Name: country; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE country (
    id integer NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE country OWNER TO lbaw1662;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE country_id_seq OWNER TO lbaw1662;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE country_id_seq OWNED BY country.id;


--
-- Name: feedback; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE feedback (
    id integer NOT NULL,
    user_id integer NOT NULL,
    message text NOT NULL,
    date timestamp without time zone NOT NULL
);


ALTER TABLE feedback OWNER TO lbaw1662;

--
-- Name: feedback_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE feedback_id_seq OWNER TO lbaw1662;

--
-- Name: feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE feedback_id_seq OWNED BY feedback.id;


--
-- Name: follow; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE follow (
    user_followed_id integer NOT NULL,
    user_following_id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    CONSTRAINT dif_users_ck CHECK ((user_followed_id <> user_following_id))
);


ALTER TABLE follow OWNER TO lbaw1662;

--
-- Name: image; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE image (
    id integer NOT NULL,
    filename character varying(32) NOT NULL,
    product_id integer NOT NULL,
    description character varying(128) NOT NULL,
    original_name character varying(64) NOT NULL
);


ALTER TABLE image OWNER TO lbaw1662;

--
-- Name: image_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE image_id_seq OWNER TO lbaw1662;

--
-- Name: image_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE image_id_seq OWNED BY image.id;


--
-- Name: notification; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE notification (
    id integer NOT NULL,
    message character varying(256) NOT NULL,
    type notification_type NOT NULL,
    user_id integer NOT NULL,
    is_new boolean NOT NULL,
    date timestamp without time zone NOT NULL
);


ALTER TABLE notification OWNER TO lbaw1662;

--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE notification_id_seq OWNER TO lbaw1662;

--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE notification_id_seq OWNED BY notification.id;


--
-- Name: password_request; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE password_request (
    id integer NOT NULL,
    email character varying(128) NOT NULL,
    token character varying(128) NOT NULL
);


ALTER TABLE password_request OWNER TO lbaw1662;

--
-- Name: password_request_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE password_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE password_request_id_seq OWNER TO lbaw1662;

--
-- Name: password_request_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE password_request_id_seq OWNED BY password_request.id;


--
-- Name: product; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE product (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    description text NOT NULL,
    condition text NOT NULL,
    characteristics character varying(128)[]
);


ALTER TABLE product OWNER TO lbaw1662;

--
-- Name: product_category; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE product_category (
    product_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE product_category OWNER TO lbaw1662;

--
-- Name: product_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_id_seq OWNER TO lbaw1662;

--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- Name: question; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE question (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    user_id integer NOT NULL,
    auction_id integer NOT NULL
);


ALTER TABLE question OWNER TO lbaw1662;

--
-- Name: question_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE question_id_seq OWNER TO lbaw1662;

--
-- Name: question_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE question_id_seq OWNED BY question.id;


--
-- Name: question_report; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE question_report (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    question_id integer NOT NULL
);


ALTER TABLE question_report OWNER TO lbaw1662;

--
-- Name: question_report_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE question_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE question_report_id_seq OWNER TO lbaw1662;

--
-- Name: question_report_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE question_report_id_seq OWNED BY question_report.id;


--
-- Name: review; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
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
-- Name: review_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE review_id_seq OWNER TO lbaw1662;

--
-- Name: review_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE review_id_seq OWNED BY review.id;


--
-- Name: user; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
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
    profile_pic character varying(72) DEFAULT 'default.png'::character varying NOT NULL,
    rating integer,
    amount double precision DEFAULT 0 NOT NULL,
    city_id integer,
    oauth_id character varying(64),
    CONSTRAINT user_rating_ck CHECK (((rating >= 0) AND (rating <= 10)))
);


ALTER TABLE "user" OWNER TO lbaw1662;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_id_seq OWNER TO lbaw1662;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- Name: user_report; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE user_report (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    message text NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE user_report OWNER TO lbaw1662;

--
-- Name: user_report_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1662
--

CREATE SEQUENCE user_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_report_id_seq OWNER TO lbaw1662;

--
-- Name: user_report_id_seq; Type: SEQUENCE OWNED BY; Schema: final; Owner: lbaw1662
--

ALTER SEQUENCE user_report_id_seq OWNED BY user_report.id;


--
-- Name: watchlist; Type: TABLE; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE TABLE watchlist (
    auction_id integer NOT NULL,
    user_id integer NOT NULL,
    notifications boolean NOT NULL,
    date timestamp without time zone NOT NULL
);


ALTER TABLE watchlist OWNER TO lbaw1662;

--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY admin ALTER COLUMN id SET DEFAULT nextval('admin_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY answer ALTER COLUMN id SET DEFAULT nextval('answer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY answer_report ALTER COLUMN id SET DEFAULT nextval('answer_report_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY auction ALTER COLUMN id SET DEFAULT nextval('auction_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY auction_report ALTER COLUMN id SET DEFAULT nextval('auction_report_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY bid ALTER COLUMN id SET DEFAULT nextval('bid_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY category ALTER COLUMN id SET DEFAULT nextval('category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY city ALTER COLUMN id SET DEFAULT nextval('city_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY feedback ALTER COLUMN id SET DEFAULT nextval('feedback_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY image ALTER COLUMN id SET DEFAULT nextval('image_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY notification ALTER COLUMN id SET DEFAULT nextval('notification_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY password_request ALTER COLUMN id SET DEFAULT nextval('password_request_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY question ALTER COLUMN id SET DEFAULT nextval('question_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY question_report ALTER COLUMN id SET DEFAULT nextval('question_report_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY review ALTER COLUMN id SET DEFAULT nextval('review_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY user_report ALTER COLUMN id SET DEFAULT nextval('user_report_id_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO admin VALUES (1, 'seekbid', 'seekbid1617@gmail.com', '$2y$12$EHywLEfwWSBO.uCZ5ogLF.aLIlGI5L3vsHYOaqt.wLThDI22EGMoa');
INSERT INTO admin VALUES (2, 'lbaw1662', 'lbaw1662@fe.up.pt', '$2y$12$o6h7m8iuYa0w0hia5TjYpOO87fQvUSD.Wg7fALgSaEv41uBVdKa/q');


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('admin_id_seq', 3, true);


--
-- Data for Name: answer; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO answer VALUES (1, '2017-05-29 14:21:28.199662', 'Yeah, that''s not enough. Sorry, my friend.', 1, 7);


--
-- Name: answer_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('answer_id_seq', 1, true);


--
-- Data for Name: answer_report; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--



--
-- Name: answer_report_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('answer_report_id_seq', 1, false);


--
-- Data for Name: auction; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO auction VALUES (23, 30, 30, '2017-05-29 18:45:00', '2017-06-02 19:46:00', 'Default', 11, 23, '2017-05-29 15:48:45.51018', 1, true, 0, 'Open');
INSERT INTO auction VALUES (2, 10, 10, '2017-05-29 13:05:00', '2017-06-03 13:11:00', 'Default', 6, 2, '2017-05-29 12:58:19.209684', 1, true, 0, 'Open');
INSERT INTO auction VALUES (3, 120, 120, '2017-05-29 13:08:00', '2017-06-03 13:17:00', 'Default', 4, 3, '2017-05-29 13:04:07.661988', 1, true, 0, 'Open');
INSERT INTO auction VALUES (4, 14, 14, '2017-05-29 13:13:00', '2017-06-03 13:22:00', 'Default', 4, 4, '2017-05-29 13:09:01.68881', 1, true, 0, 'Open');
INSERT INTO auction VALUES (5, 20, 20, '2017-05-29 13:17:00', '2017-05-29 13:20:00', 'Default', 4, 5, '2017-05-29 13:16:05.237026', 1, true, 0, 'Closed');
INSERT INTO auction VALUES (6, 15, 15, '2017-05-29 13:30:00', '2017-06-04 13:38:00', 'Default', 4, 6, '2017-05-29 13:25:31.747', 1, true, 0, 'Open');
INSERT INTO auction VALUES (7, 80, 80, '2017-05-29 13:38:00', '2017-06-03 13:43:00', 'Default', 4, 7, '2017-05-29 13:30:37.012986', 1, true, 0, 'Open');
INSERT INTO auction VALUES (8, 50, 50, '2017-05-29 13:38:00', '2017-05-29 22:49:00', 'Default', 6, 8, '2017-05-29 13:36:34.059664', 1, true, 0, 'Open');
INSERT INTO auction VALUES (9, 60, 60, '2017-05-29 13:44:00', '2017-06-29 21:58:00', 'Default', 1, 9, '2017-05-29 13:41:05.424465', 1, false, 0, 'Open');
INSERT INTO auction VALUES (12, 22, 22, '2017-05-29 14:04:00', '2017-05-29 19:11:00', 'Default', 1, 12, '2017-05-29 13:58:29.790396', 1, true, 0, 'Open');
INSERT INTO auction VALUES (13, 34, 34, '2017-05-29 14:05:00', '2017-06-07 14:14:00', 'Default', 1, 13, '2017-05-29 14:01:07.565063', 1, true, 0, 'Open');
INSERT INTO auction VALUES (16, 900, 900, '2017-05-31 10:05:00', '2017-06-03 14:05:00', 'Default', 7, 16, '2017-05-29 14:09:41.758057', 1, true, 0, 'Created');
INSERT INTO auction VALUES (17, 99, 99, '2017-05-29 14:12:00', '2017-06-03 14:23:00', 'Default', 4, 17, '2017-05-29 14:09:56.938925', 1, true, 0, 'Open');
INSERT INTO auction VALUES (15, 67, 67, '2017-05-29 14:14:00', '2017-06-08 14:21:00', 'Default', 4, 15, '2017-05-29 14:07:19.406098', 4, true, 0, 'Open');
INSERT INTO auction VALUES (18, 160, 160, '2017-05-31 02:13:00', '2017-06-02 17:13:00', 'Default', 7, 18, '2017-05-29 14:17:16.398221', 1, false, 0, 'Created');
INSERT INTO auction VALUES (1, 550, 556, '2017-05-29 13:00:00', '2017-06-03 13:06:00', 'Default', 6, 1, '2017-05-29 12:54:37.018899', 1, true, 1, 'Open');
INSERT INTO auction VALUES (19, 30, 30, '2017-05-29 14:26:00', '2017-06-04 18:35:00', 'Default', 10, 19, '2017-05-29 14:19:37.593389', 1, true, 0, 'Open');
INSERT INTO auction VALUES (20, 18, 18, '2017-05-29 14:29:00', '2017-06-03 20:35:00', 'Default', 10, 20, '2017-05-29 14:23:27.08597', 1, true, 0, 'Open');
INSERT INTO auction VALUES (21, 250, 250, '2017-05-29 14:36:00', '2017-06-03 14:42:00', 'Default', 9, 21, '2017-05-29 14:32:47.411668', 1, true, 0, 'Open');
INSERT INTO auction VALUES (22, 98, 98, '2017-05-29 14:41:00', '2017-06-02 14:48:00', 'Default', 9, 22, '2017-05-29 14:35:03.35022', 1, true, 0, 'Open');
INSERT INTO auction VALUES (14, 21, 23, '2017-05-29 14:10:00', '2017-05-29 17:17:00', 'Default', 1, 14, '2017-05-29 14:03:52.174944', 1, true, 2, 'Closed');
INSERT INTO auction VALUES (11, 69, 94, '2017-05-29 13:53:00', '2017-05-29 17:50:00', 'Default', 1, 11, '2017-05-29 13:51:38.192161', 1, true, 2, 'Closed');
INSERT INTO auction VALUES (10, 46, 123, '2017-05-29 13:46:00', '2017-05-29 18:00:00', 'Default', 1, 10, '2017-05-29 13:45:08.34157', 1, true, 3, 'Closed');


--
-- Name: auction_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('auction_id_seq', 24, true);


--
-- Data for Name: auction_report; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--



--
-- Name: auction_report_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('auction_report_id_seq', 1, false);


--
-- Data for Name: bid; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO bid VALUES (1, 556, '2017-05-29 14:25:28.294128', 9, 1);
INSERT INTO bid VALUES (2, 22, '2017-05-29 16:32:37.578969', 11, 14);
INSERT INTO bid VALUES (3, 23, '2017-05-29 16:44:54.450479', 9, 14);
INSERT INTO bid VALUES (4, 89, '2017-05-29 17:45:45.034337', 8, 11);
INSERT INTO bid VALUES (5, 76, '2017-05-29 17:46:08.281369', 8, 10);
INSERT INTO bid VALUES (6, 94, '2017-05-29 17:47:41.693977', 7, 11);
INSERT INTO bid VALUES (7, 85, '2017-05-29 17:48:48.408943', 7, 10);
INSERT INTO bid VALUES (8, 123, '2017-05-29 17:50:41.357205', 10, 10);


--
-- Name: bid_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('bid_id_seq', 8, true);


--
-- Data for Name: category; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO category VALUES (1, 'Art');
INSERT INTO category VALUES (2, 'Tickets and Trips');
INSERT INTO category VALUES (3, 'Dolls and Bears');
INSERT INTO category VALUES (4, 'Toys and Hobbies');
INSERT INTO category VALUES (5, 'Cars and Vehicles');
INSERT INTO category VALUES (6, 'Sports Souvenirs');
INSERT INTO category VALUES (7, 'Home and Garden');
INSERT INTO category VALUES (8, 'Collectibles');
INSERT INTO category VALUES (9, 'Electronics and Computers');
INSERT INTO category VALUES (10, 'Movies and DVDs');
INSERT INTO category VALUES (11, 'Musical Instruments');
INSERT INTO category VALUES (12, 'Jewelry');
INSERT INTO category VALUES (13, 'Books');
INSERT INTO category VALUES (14, 'Cloths and Accessories');
INSERT INTO category VALUES (15, 'Health and Beauty');
INSERT INTO category VALUES (16, 'Video Games');
INSERT INTO category VALUES (17, 'Sexual Toys');


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('category_id_seq', 26, true);


--
-- Data for Name: city; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO city VALUES (1, 1, 'Buenos Aires');
INSERT INTO city VALUES (2, 1, 'Córdoba');
INSERT INTO city VALUES (3, 1, 'Rosario');
INSERT INTO city VALUES (4, 2, 'Brussels');
INSERT INTO city VALUES (5, 2, 'Antwerp');
INSERT INTO city VALUES (6, 2, 'Ghent');
INSERT INTO city VALUES (9, 3, 'São Paulo');
INSERT INTO city VALUES (10, 3, 'Rio de Janeiro');
INSERT INTO city VALUES (11, 3, 'Salvador');
INSERT INTO city VALUES (12, 4, 'Toronto');
INSERT INTO city VALUES (13, 4, 'Montreal');
INSERT INTO city VALUES (14, 4, 'Calgary');
INSERT INTO city VALUES (15, 5, 'Copenhagen');
INSERT INTO city VALUES (16, 5, 'Aarhus');
INSERT INTO city VALUES (17, 5, 'Odense');
INSERT INTO city VALUES (18, 6, 'Helsinki');
INSERT INTO city VALUES (19, 6, 'Espoo');
INSERT INTO city VALUES (20, 6, 'Tampere');
INSERT INTO city VALUES (21, 7, 'Paris');
INSERT INTO city VALUES (22, 7, 'Marseille');
INSERT INTO city VALUES (23, 7, 'Lyon');
INSERT INTO city VALUES (24, 8, 'Berlin');
INSERT INTO city VALUES (25, 8, 'Hamburg');
INSERT INTO city VALUES (26, 8, 'Munich');
INSERT INTO city VALUES (27, 9, 'Dublin');
INSERT INTO city VALUES (28, 9, 'Cork');
INSERT INTO city VALUES (29, 9, 'Dún Laoghaire');
INSERT INTO city VALUES (30, 10, 'Rome');
INSERT INTO city VALUES (31, 10, 'Milan');
INSERT INTO city VALUES (32, 10, 'Naples');
INSERT INTO city VALUES (33, 11, 'Amsterdam');
INSERT INTO city VALUES (34, 11, 'Rotterdam');
INSERT INTO city VALUES (35, 11, 'The Hague');
INSERT INTO city VALUES (36, 12, 'Oslo');
INSERT INTO city VALUES (37, 12, 'Bergen');
INSERT INTO city VALUES (38, 12, 'Trondheim');
INSERT INTO city VALUES (39, 13, 'Warsaw');
INSERT INTO city VALUES (40, 13, 'Kraków');
INSERT INTO city VALUES (41, 13, 'Łódź');
INSERT INTO city VALUES (42, 15, 'Madrid');
INSERT INTO city VALUES (43, 15, 'Barcelona');
INSERT INTO city VALUES (44, 15, 'Valencia');
INSERT INTO city VALUES (45, 16, 'Stockholm');
INSERT INTO city VALUES (46, 16, 'Gothenburg');
INSERT INTO city VALUES (47, 16, 'Malmo');
INSERT INTO city VALUES (48, 17, 'Zürich');
INSERT INTO city VALUES (49, 17, 'Geneva');
INSERT INTO city VALUES (50, 17, 'Basel');
INSERT INTO city VALUES (51, 18, 'London');
INSERT INTO city VALUES (52, 18, 'Birmingham');
INSERT INTO city VALUES (53, 18, 'Glasgow');
INSERT INTO city VALUES (54, 19, 'New York');
INSERT INTO city VALUES (55, 19, 'Los Angeles');
INSERT INTO city VALUES (56, 19, 'Chicago');
INSERT INTO city VALUES (57, 20, 'Moscow');
INSERT INTO city VALUES (58, 20, 'Saint Petersburg');
INSERT INTO city VALUES (59, 20, 'Novosibirsk');
INSERT INTO city VALUES (60, 14, 'Lisbon');
INSERT INTO city VALUES (61, 14, 'Porto');
INSERT INTO city VALUES (62, 14, 'Amadora');
INSERT INTO city VALUES (63, 14, 'Braga');
INSERT INTO city VALUES (64, 14, 'Setúbal');
INSERT INTO city VALUES (65, 14, 'Coimbra');
INSERT INTO city VALUES (66, 14, 'Évora');
INSERT INTO city VALUES (67, 14, 'Aveiro');
INSERT INTO city VALUES (68, 14, 'Viana do Castelo');


--
-- Name: city_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('city_id_seq', 69, true);


--
-- Data for Name: country; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO country VALUES (1, 'Argentina');
INSERT INTO country VALUES (2, 'Belgium');
INSERT INTO country VALUES (3, 'Brazil');
INSERT INTO country VALUES (4, 'Canada');
INSERT INTO country VALUES (5, 'Denmark');
INSERT INTO country VALUES (6, 'Finland');
INSERT INTO country VALUES (7, 'France');
INSERT INTO country VALUES (8, 'Germany');
INSERT INTO country VALUES (9, 'Ireland');
INSERT INTO country VALUES (10, 'Italy');
INSERT INTO country VALUES (11, 'Netherlands');
INSERT INTO country VALUES (12, 'Norway');
INSERT INTO country VALUES (13, 'Poland');
INSERT INTO country VALUES (14, 'Portugal');
INSERT INTO country VALUES (15, 'Spain');
INSERT INTO country VALUES (16, 'Sweden');
INSERT INTO country VALUES (17, 'Switzerland');
INSERT INTO country VALUES (18, 'United Kingdom');
INSERT INTO country VALUES (19, 'United States');
INSERT INTO country VALUES (20, 'Russia');


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('country_id_seq', 21, true);


--
-- Data for Name: feedback; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--



--
-- Name: feedback_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('feedback_id_seq', 1, false);


--
-- Data for Name: follow; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO follow VALUES (1, 10, '2017-05-29 19:05:20.636478');


--
-- Data for Name: image; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO image VALUES (36, '36.jpg', 17, 'Amazon pic', '51sxlX6icFL.jpg');
INSERT INTO image VALUES (37, '37.jpg', 17, 'Amazon pic', '51U26fgp7qL.jpg');
INSERT INTO image VALUES (38, '38.jpg', 17, 'Amazon pic', '51L76NdI7AL.jpg');
INSERT INTO image VALUES (39, '39.jpg', 17, 'Amazon pic', '51nhjIjwjTL.jpg');
INSERT INTO image VALUES (40, '40.jpg', 17, 'Amazon pic', '51pO-APzj-L.jpg');
INSERT INTO image VALUES (41, '41.jpg', 17, 'Amazon pic', '41wwgcooOrL.jpg');
INSERT INTO image VALUES (42, '42.jpg', 17, 'Amazon pic', '41R-LMNkA5L.jpg');
INSERT INTO image VALUES (43, '43.jpg', 17, 'Amazon pic', '41O38ZycVvL.jpg');
INSERT INTO image VALUES (44, '44.jpg', 19, 'Amazon pic', '418-zrDnh2L.jpg');
INSERT INTO image VALUES (45, '45.jpg', 19, 'Amazon pic', '61Fe6Imf4fL.jpg');
INSERT INTO image VALUES (1, '1.jpeg', 1, 'Rockrider 9.1.jpg', 'Rockrider 9.1.jpg');
INSERT INTO image VALUES (46, '46.jpg', 19, 'Amazon pic', '614cZS8AYXL.jpg');
INSERT INTO image VALUES (2, '2.jpeg', 2, 'god of war 3.jpg', 'god of war 3.jpg');
INSERT INTO image VALUES (3, '3.jpeg', 2, 'god of war 3.1.jpg', 'god of war 3.1.jpg');
INSERT INTO image VALUES (47, '47.jpg', 19, 'Amazon pic', '61ap02GyvpL.jpg');
INSERT INTO image VALUES (4, '4.jpeg', 3, 'consola.jpg', 'consola.jpg');
INSERT INTO image VALUES (5, '5.jpeg', 3, 'gta5.jpg', 'gta5.jpg');
INSERT INTO image VALUES (48, '48.jpg', 19, 'Amazon pic', '61thz-yQg2L.jpg');
INSERT INTO image VALUES (6, '6.jpeg', 4, 'essential excel.jpg', 'essential excel.jpg');
INSERT INTO image VALUES (7, '7.png', 5, 'Amazon pic', 'E1xxFbiCYlS.png');
INSERT INTO image VALUES (49, '49.jpg', 19, 'Amazon pic', '71WFYaAGoPL.jpg');
INSERT INTO image VALUES (50, '50.jpg', 19, 'Amazon pic', '41CTeTrsJOL.jpg');
INSERT INTO image VALUES (9, '9.jpg', 6, 'Amazon pic', '41t4-USdbUL.jpg');
INSERT INTO image VALUES (10, '10.jpg', 6, 'Amazon pic', '41QcMSpHRRL.jpg');
INSERT INTO image VALUES (51, '51.jpg', 20, 'Amazon pic', '41S6QJcFiYL.jpg');
INSERT INTO image VALUES (11, '11.jpg', 6, 'Amazon pic', '519ehywatHL.jpg');
INSERT INTO image VALUES (12, '12.jpg', 6, 'Amazon pic', '61y0-igfDSL.jpg');
INSERT INTO image VALUES (52, '52.jpeg', 18, 'Swiss watch', '41Yz3Y9JiTL.jpg');
INSERT INTO image VALUES (13, '13.jpg', 6, 'Amazon pic', '61QgmR6OYEL.jpg');
INSERT INTO image VALUES (14, '14.jpg', 6, 'Amazon pic', '41t4-USdbUL.jpg');
INSERT INTO image VALUES (53, '53.jpg', 21, 'Amazon pic', '410XpEnPZML.jpg');
INSERT INTO image VALUES (15, '15.jpg', 7, 'Amazon pic', '61OyazrD4cL.jpg');
INSERT INTO image VALUES (54, '54.jpg', 21, 'Amazon pic', '41tJkeJMwUL.jpg');
INSERT INTO image VALUES (17, '17.jpeg', 8, 'got1.jpg', 'got1.jpg');
INSERT INTO image VALUES (55, '55.jpg', 21, 'Amazon pic', '41O9l732WpL.jpg');
INSERT INTO image VALUES (18, '18.jpeg', 8, 'got2.jpg', 'got2.jpg');
INSERT INTO image VALUES (19, '19.jpeg', 9, 'oil.jpg', 'oil.jpg');
INSERT INTO image VALUES (56, '56.jpg', 21, 'Amazon pic', '316UZy5BGDL.jpg');
INSERT INTO image VALUES (20, '20.jpeg', 10, 'top.jpg', 'top.jpg');
INSERT INTO image VALUES (21, '21.jpeg', 12, 'hobbit.jpg', 'hobbit.jpg');
INSERT INTO image VALUES (57, '57.jpg', 21, 'Amazon pic', '41Fk17yWFqL.jpg');
INSERT INTO image VALUES (22, '22.jpg', 13, 'Amazon pic', '515W-N7Rl7L.jpg');
INSERT INTO image VALUES (23, '23.jpg', 13, 'Amazon pic', '414b%2Bd%2BOF4L.jpg');
INSERT INTO image VALUES (58, '58.jpg', 21, 'Amazon pic', '41Ic1meTeQL.jpg');
INSERT INTO image VALUES (24, '24.jpg', 13, 'Amazon pic', '51BfYSYSfxL.jpg');
INSERT INTO image VALUES (25, '25.jpg', 14, 'Amazon pic', '41-W%2B88iTZL.jpg');
INSERT INTO image VALUES (59, '59.jpg', 21, 'Amazon pic', '41Xb-%2BbVVAL.jpg');
INSERT INTO image VALUES (26, '26.jpg', 15, 'Amazon pic', '41kK7SYo48L.jpg');
INSERT INTO image VALUES (27, '27.jpg', 15, 'Amazon pic', '51jjbnjfygL.jpg');
INSERT INTO image VALUES (60, '60.jpg', 22, 'Amazon pic', '41T508I4xrL.jpg');
INSERT INTO image VALUES (28, '28.jpg', 15, 'Amazon pic', '51z4stxR4YL.jpg');
INSERT INTO image VALUES (29, '29.jpg', 16, 'Amazon pic', '41TQSYa9bML.jpg');
INSERT INTO image VALUES (61, '61.jpg', 22, 'Amazon pic', '31qsrSAe4SL.jpg');
INSERT INTO image VALUES (30, '30.jpg', 16, 'Amazon pic', '51uIekFQyrL.jpg');
INSERT INTO image VALUES (31, '31.jpg', 16, 'Amazon pic', '51kSxvyQVlL.jpg');
INSERT INTO image VALUES (62, '62.jpg', 22, 'Amazon pic', '31XeX15NbcL.jpg');
INSERT INTO image VALUES (32, '32.jpg', 16, 'Amazon pic', '51vGvFqBQmL.jpg');
INSERT INTO image VALUES (33, '33.jpg', 16, 'Amazon pic', '31I%2Bl0NatCL.jpg');
INSERT INTO image VALUES (63, '63.jpg', 22, 'Amazon pic', '51QpmIKFy9L.jpg');
INSERT INTO image VALUES (34, '34.jpg', 16, 'Amazon pic', '51IkthL143L.jpg');
INSERT INTO image VALUES (35, '35.jpg', 16, 'Amazon pic', '41iT7VNkcsL.jpg');
INSERT INTO image VALUES (64, '64.jpg', 22, 'Amazon pic', '31FEyNr89oL.jpg');
INSERT INTO image VALUES (65, '65.jpg', 22, 'Amazon pic', '51hCragyzXL.jpg');
INSERT INTO image VALUES (80, '80.jpg', 23, 'Amazon pic', '41l7TKGQ8OL.jpg');
INSERT INTO image VALUES (81, '81.jpg', 23, 'Amazon pic', '41vRw5nnQ5L.jpg');
INSERT INTO image VALUES (82, '82.jpg', 23, 'Amazon pic', '41scGyraoeL.jpg');


--
-- Name: image_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('image_id_seq', 107, true);


--
-- Data for Name: notification; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO notification VALUES (50, 'Your bid on the auction [The Book Thief] (By: Markus Zusak) [published: October, 2013] was surpassed.', 'Auction', 11, true, '2017-05-29 16:44:54.450479');
INSERT INTO notification VALUES (24, 'Your auction The Hobbit is now open!<br>', 'Auction', 1, false, '2017-05-29 14:04:01.84133');
INSERT INTO notification VALUES (51, 'The user Rick has bid on the auction [The Book Thief] (By: Markus Zusak) [published: October, 2013].', 'Auction', 1, true, '2017-05-29 16:44:54.450479');
INSERT INTO notification VALUES (10, 'Your auction Harry Potter (8 Book Series) is now open!<br>', 'Auction', 4, false, '2017-05-29 13:17:02.518046');
INSERT INTO notification VALUES (52, 'Someone posted a question in the auction [The Book Thief] (By: Markus Zusak) [published: October, 2013].', 'Question', 1, true, '2017-05-29 16:49:14.327577');
INSERT INTO notification VALUES (8, 'Your auction Essential Excel 2016: A Step-by-Step Guide 1st ed. Edition, Kind is now open!<br>', 'Auction', 4, false, '2017-05-29 13:13:02.015487');
INSERT INTO notification VALUES (53, 'You''ve won the auction [The Book Thief] (By: Markus Zusak) [published: October, 2013] with a bid of 23€. Congratulations!', 'Win', 9, true, '2017-05-29 17:17:01.72588');
INSERT INTO notification VALUES (54, 'Your auction [The Book Thief] (By: Markus Zusak) [published: October, 2013] is now closed.<br>The user Rick had the highest bid (23€) and won the auction.<br>The money will be shortly transferred to your account.', 'Auction', 1, true, '2017-05-29 17:17:01.738085');
INSERT INTO notification VALUES (6, 'Your auction PS3 console with commands and games is now open!<br>', 'Auction', 4, false, '2017-05-29 13:08:01.923107');
INSERT INTO notification VALUES (4, 'Your auction God Of War 3 is now open!<br>', 'Auction', 6, false, '2017-05-29 13:05:01.844396');
INSERT INTO notification VALUES (55, 'The user Heisenberg has bid on the auction Skechers USA Men''s Pelem Emiro Flip Flop.', 'Auction', 1, true, '2017-05-29 17:45:45.034337');
INSERT INTO notification VALUES (2, 'Your auction Rockrider 9.1 is now open!<br>', 'Auction', 6, false, '2017-05-29 13:00:01.814824');
INSERT INTO notification VALUES (56, 'The user Heisenberg has bid on the auction Billabong Women''s Bella Beach Crossback Bikini Top.', 'Auction', 1, true, '2017-05-29 17:46:08.281369');
INSERT INTO notification VALUES (17, 'Your auction Game of Thrones: Season 5 [Blu-ray + Digital HD] is now open!<br>', 'Auction', 6, true, '2017-05-29 13:38:02.557186');
INSERT INTO notification VALUES (19, 'Your auction Best Peppermint Oil (Large 4 Ounce) 100% Pure is now open!<br>', 'Auction', 1, true, '2017-05-29 13:44:02.341524');
INSERT INTO notification VALUES (20, 'Your auction Billabong Women''s Bella Beach Crossback Bikini Top is now open!<br>', 'Auction', 1, true, '2017-05-29 13:46:02.384051');
INSERT INTO notification VALUES (57, 'Your bid on the auction Skechers USA Men''s Pelem Emiro Flip Flop was surpassed.', 'Auction', 8, true, '2017-05-29 17:47:41.693977');
INSERT INTO notification VALUES (22, 'Your auction Skechers USA Men''s Pelem Emiro Flip Flop is now open!<br>', 'Auction', 1, false, '2017-05-29 13:53:01.541897');
INSERT INTO notification VALUES (58, 'The user thedonald has bid on the auction Skechers USA Men''s Pelem Emiro Flip Flop.', 'Auction', 1, true, '2017-05-29 17:47:41.693977');
INSERT INTO notification VALUES (26, 'Your auction The Lightning Thief (Percy Jackson and the Olympians, Book 1) is now open!<br>', 'Auction', 1, true, '2017-05-29 14:05:02.418065');
INSERT INTO notification VALUES (28, 'Your auction [The Book Thief] (By: Markus Zusak) [published: October, 2013] is now open!<br>', 'Auction', 1, true, '2017-05-29 14:10:02.47008');
INSERT INTO notification VALUES (34, 'Someone posted a question in your auction.', 'Question', 7, true, '2017-05-29 14:15:02.889379');
INSERT INTO notification VALUES (59, 'Your bid on the auction Billabong Women''s Bella Beach Crossback Bikini Top was surpassed.', 'Auction', 8, true, '2017-05-29 17:48:48.408943');
INSERT INTO notification VALUES (60, 'The user thedonald has bid on the auction Billabong Women''s Bella Beach Crossback Bikini Top.', 'Auction', 1, true, '2017-05-29 17:48:48.408943');
INSERT INTO notification VALUES (61, 'You''ve won the auction Skechers USA Men''s Pelem Emiro Flip Flop with a bid of 94€. Congratulations!', 'Win', 7, true, '2017-05-29 17:50:01.859278');
INSERT INTO notification VALUES (62, 'Your auction Skechers USA Men''s Pelem Emiro Flip Flop is now closed.<br>The user thedonald had the highest bid (94€) and won the auction.<br>The money will be shortly transferred to your account.', 'Auction', 1, true, '2017-05-29 17:50:01.871947');
INSERT INTO notification VALUES (63, 'Someone posted a question in the auction Billabong Women''s Bella Beach Crossback Bikini Top.', 'Question', 1, true, '2017-05-29 17:50:32.376088');
INSERT INTO notification VALUES (36, 'The user Rick has bid on the auction Rockrider 9.1.', 'Auction', 6, true, '2017-05-29 14:25:28.294128');
INSERT INTO notification VALUES (37, 'Your auction Little Tikes Gas ''n Go Mower is now open!<br>', 'Auction', 10, true, '2017-05-29 14:26:02.341065');
INSERT INTO notification VALUES (39, 'Your auction Daniel Tiger''s Neighborhood Daniel Tiger Mini Plush is now open!<br>', 'Auction', 10, true, '2017-05-29 14:29:01.792455');
INSERT INTO notification VALUES (41, 'Your auction Cordoba Mini SM-CE Travel Acoustic-Electric is now open!<br>', 'Auction', 9, false, '2017-05-29 14:36:02.263145');
INSERT INTO notification VALUES (64, 'Your bid on the auction Billabong Women''s Bella Beach Crossback Bikini Top was surpassed.', 'Auction', 7, true, '2017-05-29 17:50:41.357205');
INSERT INTO notification VALUES (43, 'Your auction Pioneer DJ DDJ-SB2 Portable 2-channel controller for Serato DJ is now open!<br>', 'Auction', 9, true, '2017-05-29 14:41:02.280885');
INSERT INTO notification VALUES (47, 'Someone posted a question in your auction.', 'Question', 6, true, '2017-05-29 15:05:15.757555');
INSERT INTO notification VALUES (48, 'Your auction Mass Effect Andromeda - PlayStation 4 was deleted.', 'Auction', 11, true, '2017-05-29 15:53:47.861484');
INSERT INTO notification VALUES (49, 'The user harry_potter has bid on the auction [The Book Thief] (By: Markus Zusak) [published: October, 2013].', 'Auction', 1, true, '2017-05-29 16:32:37.578969');
INSERT INTO notification VALUES (65, 'The user gandalf has bid on the auction Billabong Women''s Bella Beach Crossback Bikini Top.', 'Auction', 1, true, '2017-05-29 17:50:41.357205');
INSERT INTO notification VALUES (67, 'Your auction Billabong Women''s Bella Beach Crossback Bikini Top is now closed.<br>The user gandalf had the highest bid (123€) and won the auction.<br>The money will be shortly transferred to your account.', 'Auction', 1, false, '2017-05-29 18:00:02.497226');
INSERT INTO notification VALUES (69, 'Your auction Mass Effect Andromeda - PlayStation 4 is now open!<br>', 'Auction', 11, true, '2017-05-29 18:45:02.660761');
INSERT INTO notification VALUES (66, 'You''ve won the auction Billabong Women''s Bella Beach Crossback Bikini Top with a bid of 123€. Congratulations!', 'Win', 10, false, '2017-05-29 18:00:02.48989');


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('notification_id_seq', 69, true);


--
-- Data for Name: password_request; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--



--
-- Name: password_request_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('password_request_id_seq', 1, true);


--
-- Data for Name: product; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO product VALUES (10, 'Billabong Women''s Bella Beach Crossback Bikini Top', 'Cross back printed bikini top with removable cups and strappy criss cross detail at back.', 'New.', '{"Product Dimensions: 1 x 1 x 1 inches","Shipping Weight: 1 pounds"}');
INSERT INTO product VALUES (11, 'Skechers USA Men''s Pelem Emiro Flip Flop', 'Flip flop.', 'NEW.', '{Synthetic,Imported,Synthetic,sole,Relax}');
INSERT INTO product VALUES (12, 'The Hobbit', 'A great modern classic and the prelude to The Lord of the Rings.
 
Bilbo Baggins is a hobbit who enjoys a comfortable, unambitious life, rarely traveling any farther than his pantry or cellar. But his contentment is disturbed when the wizard Gandalf and a company of dwarves arrive on his doorstep one day to whisk him away on an adventure. They have launched a plot to raid the treasure hoard guarded by Smaug the Magnificent, a large and very dangerous dragon. Bilbo reluctantly joins their quest, unaware that on his journey to the Lonely Mountain he will encounter both a magic ring and a frightening creature known as Gollum.', 'Like new.', '{"Age Range: 12 and up","Grade Level: 7 and up","Paperback: 300 pages","Publisher: Houghton Mifflin Harcourt (September 18, 2012)"}');
INSERT INTO product VALUES (13, 'The Lightning Thief (Percy Jackson and the Olympians, Book 1)', 'Percy Jackson and the Olympians, Book One: Lightning Thief, The', 'Used, but new.', NULL);
INSERT INTO product VALUES (1, 'Rockrider 9.1', 'Year 2014 Size S
Weight 13.5 kg
Everything running at 100%
Rockshox Recon 120mm Suspension with Lock
Shock absorber X-Fusio E1 aided by the anti-smoking system Neuf
Derailleur behind SLX
Front Derailleur SRAM-X7
Brakes hydraulic Tektro Auriga Comp
Tire behind Maxxis Larsen TT walked 3x
Tire front Continental X-King walked 2x
Carbon changeover', 'Everything running at 100%.', NULL);
INSERT INTO product VALUES (2, 'God Of War 3', 'Game in excellent condition. I hand in the Oeiras area and in some areas of Lisbon. Do not mail.', 'Game in excellent condition.', NULL);
INSERT INTO product VALUES (3, 'PS3 console with commands and games', 'I have for sale a PS3 Slim 500GB with 2 commands. Taking the offer of GTA 5.', 'In perfect condition.', '{500GB}');
INSERT INTO product VALUES (4, 'Essential Excel 2016: A Step-by-Step Guide 1st ed. Edition, Kind', 'This book shows you how easy it is to create, edit, sort, analyze, summarize and format data as well as graph it. Loaded with screen shots, step-by-step instructions, and reader exercises, Essential Excel 2016 makes it easy for you to get to grips with this powerful software and what it can do.', 'Good condition.', '{"Highlight, take notes, and search in the book","Length: 673 pages","Due to its large file size, this book may take longer to download"}');
INSERT INTO product VALUES (5, 'Harry Potter (8 Book Series)', '"The Eighth Story. Nineteen Years Later.

Based on an original new story by J.K. Rowling, Jack Thorne and John Tiffany, a new play by Jack Thorne, Harry Potter and the Cursed Child is the eighth story in the Harry Potter series and the first official Harry Potter story to be presented on stage. The play will receive its world premiere in London’s West End on July 30, 2016.

It was always difficult being Harry Potter and it isn’t much easier now that he is an overworked employee of the Ministry of Magic, a husband and father of three school-age children.

While Harry grapples with a past that refuses to stay where it belongs, his youngest son Albus must struggle with the weight of a family legacy he never wanted. As past and present fuse ominously, both father and son learn the uncomfortable truth: sometimes, darkness comes from unexpected places."', 'Perfect condition.', NULL);
INSERT INTO product VALUES (6, 'Fiskars Traditional Bypass Pruning Shears', 'This reliable pruner is ideal for a variety of general pruning tasks. A fully hardened, precision-ground steel blade stays sharp longer, and a rust-resistant, low-friction coating makes cutting easier. A self-cleaning sap groove keeps the blades from sticking, and the handle includes non-slip grips. All-steel construction provides long-lasting durability.', 'Perfect!!!', NULL);
INSERT INTO product VALUES (7, 'NEW Banzai Geyser Blast Sprinkler Kids Water', 'The Geyser Blast Sprinkler helps you to create a fun atmosphere in your yard. Just hook it up to the end of any standard garden hose and you''re good to go. This geyser sprinkler has several wiggling arms that spray water in random directions. It''s made from sturdy plastic to be immune to rust and to hold up to lots of regular use. The water also sprays up vertically from the base so kids can run through it.', 'Good state.', NULL);
INSERT INTO product VALUES (8, 'Game of Thrones: Season 5 [Blu-ray + Digital HD]', 'Game of Thrones: Season 5 [Blu-ray + Digital HD]', 'Fresh.', NULL);
INSERT INTO product VALUES (9, 'Best Peppermint Oil (Large 4 Ounce) 100% Pure', 'About the product
GET BETTER RESULTS WITH SUN ESSENTIAL OILS - With what we believe to be superior sourced and harvested ingredients, we think you will agree that our oils are by far the most effective on the market - a wonderful smell that can''t be beat!
SUN PROVIDES THE BEST ESSENTIAL OILS - Yes, it''s a matter of opinion, but we believe our oils to be the best and will provide anyone who doesn''t feel the same way with an 100% pure, unconditional manufacturer refund, anytime. We think you will feel that you have never smelled an oil this wonderful...and that after you have smelled this oil other brands may have a distinct alcohol or chemical smell with a ''dry'' scent and noticeable lack of depth.
LOVE THE SMELL AND FEEL GREAT - Fatigue and irritability are often a result of many factors that are difficult to pinpoint. Clear your mind and relax with the wonderful smell of Peppermint (Mentha Piperita)
SUN makes the BEST quality PREMIUM Aromatherapy oils and has OVER 100 SCENTS', 'Peppermint in a 4oz glass essential oil bottle. Comes with pipette for your convenience.', '{"Product Dimensions: 1.8 x 1.8 x 4.5 inches","Shipping Weight: 7.2 ounces"}');
INSERT INTO product VALUES (14, '[The Book Thief] (By: Markus Zusak) [published: October, 2013]', 'Will be shipped from US. Used books may not include companion materials, may have some shelf wear, may contain highlighting/notes, may not include CDs or access codes. 100% money back guarantee.', 'Good condition.', NULL);
INSERT INTO product VALUES (15, 'Cooper Starfire RS-C 2.0 All-Season Radial Tire', 'The RS-C 2.0 has an aggressive design that performs great in all four seasons. This tire is designed for the budget conscious consumer that is looking for upscale performance. The RS-C 2.0 is offered in sizes to accommodate today''s most popular vehicles.', 'Perfect.', NULL);
INSERT INTO product VALUES (16, 'SkyTech ArchAngel GTX 1050 Ti Gaming Computer Desktop PC', 'Now you can turn your PC into a powerful gaming rig! With the newest technology from Nvidia GTX 1050 Ti, SkyTech PC provides you the newest and improved version of the Pascal architecture at a budget. Redeem your confidence while you raise your gaming experience and praise our SkyTech PC. The Skytech ArchAngel 1050 Ti offers a fast and powerful performance that all gamers will love. <br><br>SkyTech ArchAngel Gamers 1050 Ti uses AMD FX-6300 Processor that is fast and reliable. You won&rsquo;t know what&rsquo;s fast until you get your hands on one of these! SkyTech believes in FAST, RELIABILITY, QUALITY, and AFFORDABILITY! Unlike other gaming PC out in the market that sacrifice quality for price, Skytech does not compromise and only use quality & branded components such as higher grade power supply, gaming memory with heat spreader, and more! <br><br>** SkyTech PC uses only the best and branded components to ensure that your computer is reliable and durable. <br><br>**SkyTech PC power supplies have a 5 year warranty. <br><br>** SkyTech PC ONLY uses High Performance GAMING Memory for your PC. <br><br>System <br><br>Processor: AMD FX-6300 Vishera 6-Core 3.5 GHz / 4.1 GHz Turbo Unlocked <br>Motherboard:AM3+ 970 Chipset Gaming Motherboard (Not generic motherboard where other gaming companies will cut corners on)<br>Graphics: Nvidia Geforce GTX 1050 TI 4GB Pascal Engine <br>Memory: High Performance 8GB DDR3 1866 MHz Gaming Memory with Heat Spreader (We do not use generic memory that other companies will cut corners on)<br>Hard Disk: 1TB 7200 RPM Hard Drive <br>Power Supply: 430 Watts High Performance Power Supply<br>Operating System Windows 10 Professional 64-bit', 'Brand new. Perfect condition.', '{"Aspect Ratio: 16:9","Hardware Platform: PC","Manufacturer: Skytech Gaming","Operating System: Windows 10","Part Number: ST-ARCH-GTX1050TI-V1","Publisher: Skytech Gaming"}');
INSERT INTO product VALUES (17, 'AUDEW Car Covers Waterproof /Windproof/Dustproof/Scratch', '<br> Applications:<br> Suitable for most SUV cars, but depending on the size of the product, please carefully comparing your car.<br> <br> <b>Specifications:</b><br> Material: 190T polyester fabric, with insulation effect a few digits.<br> Silver color<br> Size: 5.2 (W) x2 (W) x1.8m (H)<br> <br> <b>Characteristics:</b><br> This product has sun, heat, etc., with silver hardware, as long as you install the glass block after the latter block in front of the parking time you can make your car to keep in a cool state , Make you driving life more comfortable, safer and healthier.<br> 1. Car Cover Protection, capable of preventing harmful dust in wagons and machine parts, their resistance to aging and machine use and the inner tear of the wagon.<br> 2. Car Cover Protection, can effectively prevent snow from urban pollution in the acid conditions of the car surface brutally tortured.<br> 3. Car Cover Protection, can effectively withstand heavy ultraviolet radiation damage to paint the inside of the tire.<br> 4. Suitable for dust, rain, warm seasons of summer, or long-term use in the car.<br> <br> <b>The package includes:</b><br> 1 x Car Cover SUV<br> 1 x storage bag', 'New.', NULL);
INSERT INTO product VALUES (18, 'Wenger Swiss Military Elite Two-Tone Stainless Date Watch', 'Wenger 79093 Military Elite women''s watch features a 30mm wide and 10mm thick two tone yellow gold plated solid stainless steel case with a fixed bezel and textured push-pull crown. Wenger 79093 is powered by a reliable Swiss Made quartz movement. This beautiful watch also features a sharp looking silver tone dial with white accents gold tone luminous hands and hour markers along with the date display function, scratch resistant mineral crystal and water resistant to 100 meters. Wenger 79093 is equipped with a 15mm wide two tone yellow gold plated solid stainless steel bracelet with a fold over safety lock clasp. Wenger 79093 women''s Military Elite silver dial two tone steel watch is brand new and comes in an original Wenger gift box and is backed by a 3 years limited warranty. Bracelet 7 1/4"', 'Brand new. Bought it a few days ago to my wife but she didn''t like it :(', NULL);
INSERT INTO product VALUES (19, 'Little Tikes Gas ''n Go Mower', 'This toy lawn mower lets children mimic the activity they see every day in the world around them. The sounds and hands-on features of this kid’s lawn mower encourage pretend play and get kids moving – and mowing! It looks like the real thing!   Features:<br> - Sounds are mechanical, so no batteries are needed <br> - Push the toy mower and the beads pop <br> - Pull cord to hear engine sounds <br> - Clicking key and moveable throttle <br> - Removable gas can <br> - Kids can open the tethered gas cap and pretend to fill up the lawn mower <br> - 18+ months<br>', 'NEW.', NULL);
INSERT INTO product VALUES (20, 'Daniel Tiger''s Neighborhood Daniel Tiger Mini Plush', 'How do you teach life''s little lessons with big fun? By giving your little one a Daniel Tiger mini plush, an adorable seven Inch of fuzzy, snuggly tiger-riffic cuddles. This sweet little stuffed tiger is based on the PBS show Daniel Tiger''s Neighborhood, inspired by the classic Mister Rogers neighborhood.', 'New and magic.', '{"Binding: Toy","Is Adult Product: 0","Item Part Number: WS-1026","Manufacturer: Tolly Tots - Domestic","Manufacturer Maximum Age: 72","Manufacturer Minimum Age: 36","Package Quantity: 1","Part Number: WS-1026","Product Group: Toy","Product Type Name: TOYS_AND_GAMES"}');
INSERT INTO product VALUES (21, 'Cordoba Mini SM-CE Travel Acoustic-Electric', 'Cordoba is proud to introduce the latest addition to the Cordoba Mini Series: the Mini SM-CE. At first glance, the Mini SM-CE clearly stands out from other travel sized guitars, with its solid cedar top and striking spalted maple back and sides accentuated by a padauk rosette and binding. The solid cedar top provides a warm tone that’s nicely complemented by the brightness of the spalted maple, resulting in an instrument that really projects its voice. For those who want to plug and play, the Cordoba Mini SM-CE features a soft cutaway and Cordoba 2Band pickup. The hallmark of Cordoba''s Mini guitars is the comfortable feel and string spacing of a full size guitar. The Mini SM-CE also includes a thin U-shaped neck outlined with padauk binding, 50mm (1.96”) nut width, and 510mm (20”) scale length. The Mini SM-CE comes with custom Aquila strings tuned to A, and a standard E tuning string set is also available. It includes a Cordoba gig bag, making it the ideal companion for road trips, vacations, and hanging out at home.', 'Perfect.', '{"Binding: Electronics","Is Autographed: 0","Is Memorabilia: 0","Manufacturer: Cordoba Music Group","Number Of Items: 1","Package Quantity: 1","Part Number: Mini SE-CE","Product Group: Musical Instruments","Product Type Name: GUITARS","Studio: Cordoba Music Group"}');
INSERT INTO product VALUES (22, 'Pioneer DJ DDJ-SB2 Portable 2-channel controller for Serato DJ', 'Portable 2-channel controller for Serato DJ. DDJ-SB2 boasts all popular features from DDJ-SB, and adds some amazing new functions. This controller has been upgraded with 4-deck control and dedicated buttons to switch between channels effortlessly, plus a trim knob and level meters to master the input volume, and Pad Trans beat effects will uplift your DJ skills.', 'Use, but New!', '{"Binding: Electronics","Is Autographed: 0","Is Memorabilia: 0","Manufacturer: Pioneer Pro DJ","Package Quantity: 1","Part Number: DDJ-SB2","Product Group: Musical Instruments","Product Type Name: SOUND_AND_RECORDING_EQUIPMENT","Publisher: Pioneer Pro DJ","Studio: Pioneer Pro DJ"}');
INSERT INTO product VALUES (23, 'Mass Effect Andromeda - PlayStation 4', 'Mass Effect: Andromeda takes players to the Andromeda galaxy, far beyond the Milky Way. There, players will lead our fight for a new home in hostile territory as the Pathfinder-a leader of military-trained explorers. This is the story of humanity''s next chapter, and player choices throughout the game will ultimately determine our survival.', 'Excelent, still in the plastic.', NULL);
INSERT INTO product VALUES (24, 'Mass Effect Andromeda - PlayStation 4', 'Mass Effect: Andromeda takes players to the Andromeda galaxy, far beyond the Milky Way. There, players will lead our fight for a new home in hostile territory as the Pathfinder-a leader of military-trained explorers. This is the story of humanity''s next chapter, and player choices throughout the game will ultimately determine our survival.', 'Excelent, still in the plastic.', NULL);


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO product_category VALUES (1, 5);
INSERT INTO product_category VALUES (2, 16);
INSERT INTO product_category VALUES (3, 9);
INSERT INTO product_category VALUES (3, 16);
INSERT INTO product_category VALUES (4, 13);
INSERT INTO product_category VALUES (5, 13);
INSERT INTO product_category VALUES (6, 7);
INSERT INTO product_category VALUES (7, 7);
INSERT INTO product_category VALUES (8, 10);
INSERT INTO product_category VALUES (9, 15);
INSERT INTO product_category VALUES (10, 14);
INSERT INTO product_category VALUES (11, 14);
INSERT INTO product_category VALUES (11, 15);
INSERT INTO product_category VALUES (12, 13);
INSERT INTO product_category VALUES (13, 13);
INSERT INTO product_category VALUES (14, 13);
INSERT INTO product_category VALUES (15, 5);
INSERT INTO product_category VALUES (16, 9);
INSERT INTO product_category VALUES (17, 5);
INSERT INTO product_category VALUES (18, 14);
INSERT INTO product_category VALUES (19, 4);
INSERT INTO product_category VALUES (20, 3);
INSERT INTO product_category VALUES (21, 11);
INSERT INTO product_category VALUES (22, 11);
INSERT INTO product_category VALUES (23, 16);
INSERT INTO product_category VALUES (24, 16);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('product_id_seq', 24, true);


--
-- Data for Name: question; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO question VALUES (1, '2017-05-29 14:15:02.884633', 'I only give 500€.', 4, 16);
INSERT INTO question VALUES (3, '2017-05-29 14:43:25.391867', 'What is the range of the water jets? I might buy it.', 11, 7);
INSERT INTO question VALUES (4, '2017-05-29 15:05:15.747521', 'If I use a Wingardium Leviosa, does it ride for me?', 11, 1);
INSERT INTO question VALUES (5, '2017-05-29 16:49:14.317064', 'Did you enjoyed the book? I really don''t know if it''s good. Help me please. And that''s why I always say, ''Shumshumschilpiddydah!''', 9, 14);
INSERT INTO question VALUES (6, '2017-05-29 17:50:32.362348', 'I really want this. Awesome product. Do you think it will suit me?', 10, 10);


--
-- Name: question_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('question_id_seq', 6, true);


--
-- Data for Name: question_report; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--



--
-- Name: question_report_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('question_report_id_seq', 1, true);


--
-- Data for Name: review; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO review VALUES (1, 10, 'Great deal I made with this buddy.', '2017-05-29 19:04:29.11129', 8);


--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('review_id_seq', 1, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO "user" VALUES (8, 'Heisenberg', 'heisenberg@hotmail.com', 'Walter White', 'No, you clearly don''t know who you''re talking to, so let me clue you in. I am not in danger. I am the danger! A guy opens his door and gets shot and you think that of me? No. I am the one who knocks!', '', '$2y$12$pN6x0Jg4..02TThfn7EblOy.DWPCICHQbSx0l4sDtSSHIJbW6gihW', '987654321', '2017-05-29 10:52:49.414417', '8.jpg', NULL, 489, 56, NULL);
INSERT INTO "user" VALUES (2, 'jlopes', 'jlopes@fe.up.pt', 'João Lopes', 'Bio really short.', NULL, '$2y$12$gQCytOCmMLPQF93MYTk/ye/Z83gosOcO8sgcblBOnUOTiEpIgAkW.', NULL, '2017-05-22 09:48:06.239041', 'default.png', NULL, 0, NULL, NULL);
INSERT INTO "user" VALUES (3, 'dcepa95', 'dcepa95@gmail.com', 'Diogo Cepa', 'Talk a little about me?', NULL, '$2y$12$ejcRc5zXM2xmog6DW0XMBOtfZ1ep6wEl4DfXmJ/TjPOjPkOKVvFmu', NULL, '2017-05-25 08:29:51.082072', 'default.png', NULL, 0, NULL, NULL);
INSERT INTO "user" VALUES (4, 'hant', 'up201406163@fe.up.pt', 'Hélder Antunes', 'Hello! I sell things I no longer need. Maybe you need it!', 'I just know that I AM.', '$2y$12$Yx9P.HKAZ6l/R/f55x8QQenEhv7ecblfXEN/uVwyaE0KxVFLSyejy', '921212122', '2017-05-22 15:24:39.421975', 'default.png', NULL, 1000, 61, NULL);
INSERT INTO "user" VALUES (7, 'thedonald', 'donaldtrump@gmail.com', 'Donald Trump', 'I am the most successful person ever to run for president. Nobody’s ever been more successful than me. I have the best words. I am the best builder. Nobody builds walls better than me.', '', '$2y$12$hkZuQEac5i1FokdlwkVsqufqIblcuMWSE8GH2bMSXeI5ThHTv9yNO', '912121222', '2017-05-26 20:45:07.817477', '7.jpg', NULL, 106, 54, NULL);
INSERT INTO "user" VALUES (10, 'gandalf', 'gandalf@hotmail.com', 'Gandalf the White', 'All we have to decide is what to do with the time that is given us. My advice is to buy the things that i sell.', '', '$2y$12$JkkekkZ6rAoz6q5UrTL/YOrm3T7rMoByygIMPwcCTxmYq8Szf/90a', '', '2017-05-29 11:11:51.673123', '10.jpg', NULL, 3, 53, NULL);
INSERT INTO "user" VALUES (6, 'dakingindanorf', 'jonsnow@hotmail.com', 'Jon Snow', 'I''m the son of Lady Lyanna Stark and Rhaegar Targaryen, the Prince of Dragonstone. And i do know some things.', '', '$2y$12$vcwf0pkM5dIqwfoftNUOkuwsEKjj2sECAIO0Opd8ADkmDTztThUqy', '917592123', '2017-05-26 20:34:28.12354', '6.jpg', NULL, 0, 12, NULL);
INSERT INTO "user" VALUES (11, 'harry_potter', 'hp17@gmail.com', 'James', 'Avedra Kadabra to my prices!', 'I''m a wizard who deals in the best stuff!', '$2y$12$1Eb4IqWXqPQbnpALLMXX3.7bBEcShPGZh//b655NvG23k2Mfdy7bC', '', '2017-05-29 13:04:18.044892', '11.jpg', NULL, 500, 51, NULL);
INSERT INTO "user" VALUES (9, 'Rick', 'ricksanchez@gmail.com', 'Rick Sanchez', 'Wubba-lubba-dub-dub!', 'I''m a grumpy old men who likes to sell stuff.', '$2y$12$BquGZeFoQObgyoYG9.evA.LpvRp22u6Pn1pSs5WqJTt1b2EOI1UcC', '', '2017-05-29 10:59:48.819301', '9.png', NULL, 421, 54, NULL);
INSERT INTO "user" VALUES (1, 'renatoabreu', 'renatoabreu1196@gmail.com', 'Renato Abreu', 'Hello. I sell a lot of stuff. Come and see. I have the best things and everything costs 25 Schmeckles.', NULL, '$2y$12$FDpZPDSCltFqIKMi8ATxjeHAgacr1VuX91vWfJiZ1JCX.4N9z7sAO', NULL, '2017-05-09 00:56:32.755805', 'default.png', 10, 327, NULL, NULL);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('user_id_seq', 11, true);


--
-- Data for Name: user_report; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--



--
-- Name: user_report_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('user_report_id_seq', 1, false);


--
-- Data for Name: watchlist; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO watchlist VALUES (1, 6, true, '2017-05-29 12:54:37.018899');
INSERT INTO watchlist VALUES (2, 6, true, '2017-05-29 12:58:19.209684');
INSERT INTO watchlist VALUES (3, 4, true, '2017-05-29 13:04:07.661988');
INSERT INTO watchlist VALUES (4, 4, true, '2017-05-29 13:09:01.68881');
INSERT INTO watchlist VALUES (5, 4, true, '2017-05-29 13:16:05.237026');
INSERT INTO watchlist VALUES (6, 4, true, '2017-05-29 13:25:31.747');
INSERT INTO watchlist VALUES (7, 4, true, '2017-05-29 13:30:37.012986');
INSERT INTO watchlist VALUES (8, 6, true, '2017-05-29 13:36:34.059664');
INSERT INTO watchlist VALUES (9, 1, false, '2017-05-29 13:41:05.424465');
INSERT INTO watchlist VALUES (10, 1, true, '2017-05-29 13:45:08.34157');
INSERT INTO watchlist VALUES (6, 11, true, '2017-05-29 13:49:35.927508');
INSERT INTO watchlist VALUES (11, 1, true, '2017-05-29 13:51:38.192161');
INSERT INTO watchlist VALUES (12, 1, true, '2017-05-29 13:58:29.790396');
INSERT INTO watchlist VALUES (13, 1, true, '2017-05-29 14:01:07.565063');
INSERT INTO watchlist VALUES (14, 1, true, '2017-05-29 14:03:52.174944');
INSERT INTO watchlist VALUES (15, 4, true, '2017-05-29 14:07:19.406098');
INSERT INTO watchlist VALUES (16, 7, true, '2017-05-29 14:09:41.758057');
INSERT INTO watchlist VALUES (17, 4, true, '2017-05-29 14:09:56.938925');
INSERT INTO watchlist VALUES (16, 4, true, '2017-05-29 14:13:04.726586');
INSERT INTO watchlist VALUES (18, 7, true, '2017-05-29 14:17:16.398221');
INSERT INTO watchlist VALUES (19, 10, true, '2017-05-29 14:19:37.593389');
INSERT INTO watchlist VALUES (20, 10, true, '2017-05-29 14:23:27.08597');
INSERT INTO watchlist VALUES (21, 9, true, '2017-05-29 14:32:47.411668');
INSERT INTO watchlist VALUES (22, 9, true, '2017-05-29 14:35:03.35022');
INSERT INTO watchlist VALUES (1, 9, true, '2017-05-29 14:39:26.721465');
INSERT INTO watchlist VALUES (23, 11, true, '2017-05-29 15:48:45.51018');
INSERT INTO watchlist VALUES (23, 1, false, '2017-05-29 16:38:53.108272');
INSERT INTO watchlist VALUES (14, 9, true, '2017-05-29 16:45:34.317702');
INSERT INTO watchlist VALUES (1, 4, true, '2017-05-29 17:54:05.843875');


--
-- Name: admin_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: answer_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT answer_pkey PRIMARY KEY (id);


--
-- Name: answer_report_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY answer_report
    ADD CONSTRAINT answer_report_pkey PRIMARY KEY (id);


--
-- Name: auction_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY auction
    ADD CONSTRAINT auction_pkey PRIMARY KEY (id);


--
-- Name: auction_report_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY auction_report
    ADD CONSTRAINT auction_report_pkey PRIMARY KEY (id);


--
-- Name: bid_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY bid
    ADD CONSTRAINT bid_pkey PRIMARY KEY (id);


--
-- Name: category_name_key; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_name_key UNIQUE (name);


--
-- Name: category_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: city_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY city
    ADD CONSTRAINT city_pkey PRIMARY KEY (id);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: feedback_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (id);


--
-- Name: follow_pk; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT follow_pk PRIMARY KEY (user_following_id, user_followed_id);


--
-- Name: image_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: password_request_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY password_request
    ADD CONSTRAINT password_request_pkey PRIMARY KEY (id);


--
-- Name: password_request_token_uindex; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY password_request
    ADD CONSTRAINT password_request_token_uindex UNIQUE (token);


--
-- Name: product_category_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (product_id, category_id);


--
-- Name: product_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: question_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY question
    ADD CONSTRAINT question_pkey PRIMARY KEY (id);


--
-- Name: question_report_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY question_report
    ADD CONSTRAINT question_report_pkey PRIMARY KEY (id);


--
-- Name: review_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_report_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY user_report
    ADD CONSTRAINT user_report_pkey PRIMARY KEY (id);


--
-- Name: watchlist_pk; Type: CONSTRAINT; Schema: final; Owner: lbaw1662; Tablespace: 
--

ALTER TABLE ONLY watchlist
    ADD CONSTRAINT watchlist_pk PRIMARY KEY (auction_id, user_id);


--
-- Name: admin_email_uindex; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX admin_email_uindex ON admin USING btree (email);


--
-- Name: admin_username_uindex; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX admin_username_uindex ON admin USING btree (username);


--
-- Name: answer_question_id_user_id_index; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX answer_question_id_user_id_index ON answer USING btree (question_id, user_id);


--
-- Name: auction_end_date_index; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX auction_end_date_index ON auction USING btree (end_date);

ALTER TABLE auction CLUSTER ON auction_end_date_index;


--
-- Name: auction_user_id_index; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX auction_user_id_index ON auction USING hash (user_id);


--
-- Name: bid_auction_id_index; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX bid_auction_id_index ON bid USING hash (auction_id);


--
-- Name: bid_user_id_index; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX bid_user_id_index ON bid USING hash (user_id);


--
-- Name: country_name_uindex; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX country_name_uindex ON country USING btree (name);


--
-- Name: fts_product_idx; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX fts_product_idx ON product USING gin (to_tsvector('english'::regconfig, (((name)::text || ' '::text) || description)));


--
-- Name: image_filename_uindex; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX image_filename_uindex ON image USING btree (filename);


--
-- Name: notification_user_id_index; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX notification_user_id_index ON notification USING hash (user_id);


--
-- Name: question_auction_id_index; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX question_auction_id_index ON question USING hash (auction_id);


--
-- Name: review_bid_id_index; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX review_bid_id_index ON review USING hash (bid_id);


--
-- Name: user_email_uindex; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX user_email_uindex ON "user" USING btree (email);


--
-- Name: user_username_bio_idx; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE INDEX user_username_bio_idx ON "user" USING gin (to_tsvector('english'::regconfig, (((username)::text || ' '::text) || (short_bio)::text)));


--
-- Name: user_username_uindex; Type: INDEX; Schema: final; Owner: lbaw1662; Tablespace: 
--

CREATE UNIQUE INDEX user_username_uindex ON "user" USING btree (username);


--
-- Name: auction_deleted; Type: TRIGGER; Schema: final; Owner: lbaw1662
--

CREATE TRIGGER auction_deleted BEFORE DELETE ON auction FOR EACH ROW EXECUTE PROCEDURE warn_bidders();


--
-- Name: new_answer_report; Type: TRIGGER; Schema: final; Owner: lbaw1662
--

CREATE TRIGGER new_answer_report AFTER INSERT ON answer_report FOR EACH ROW EXECUTE PROCEDURE answer_report_notification();


--
-- Name: new_auction_report; Type: TRIGGER; Schema: final; Owner: lbaw1662
--

CREATE TRIGGER new_auction_report AFTER INSERT ON auction_report FOR EACH ROW EXECUTE PROCEDURE auction_report_notification();


--
-- Name: new_bid; Type: TRIGGER; Schema: final; Owner: lbaw1662
--

CREATE TRIGGER new_bid BEFORE INSERT ON bid FOR EACH ROW EXECUTE PROCEDURE update_auction();


--
-- Name: new_question_report; Type: TRIGGER; Schema: final; Owner: lbaw1662
--

CREATE TRIGGER new_question_report AFTER INSERT ON question_report FOR EACH ROW EXECUTE PROCEDURE question_report_notification();


--
-- Name: new_user_report; Type: TRIGGER; Schema: final; Owner: lbaw1662
--

CREATE TRIGGER new_user_report AFTER INSERT ON user_report FOR EACH ROW EXECUTE PROCEDURE user_report_notification();


--
-- Name: remove_review; Type: TRIGGER; Schema: final; Owner: lbaw1662
--

CREATE TRIGGER remove_review AFTER DELETE ON review FOR EACH ROW EXECUTE PROCEDURE remove_review();


--
-- Name: review_trigger; Type: TRIGGER; Schema: final; Owner: lbaw1662
--

CREATE TRIGGER review_trigger AFTER INSERT OR UPDATE ON review FOR EACH ROW EXECUTE PROCEDURE review_trigger();


--
-- Name: seller_cannot_bid; Type: TRIGGER; Schema: final; Owner: lbaw1662
--

CREATE TRIGGER seller_cannot_bid BEFORE INSERT OR UPDATE ON bid FOR EACH ROW EXECUTE PROCEDURE seller_cannot_bid();


--
-- Name: answer_question_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT answer_question_fk FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE;


--
-- Name: answer_report_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY answer_report
    ADD CONSTRAINT answer_report_fk FOREIGN KEY (answer_id) REFERENCES answer(id) ON DELETE CASCADE;


--
-- Name: answer_user_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY answer
    ADD CONSTRAINT answer_user_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: auction_product_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY auction
    ADD CONSTRAINT auction_product_fk FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE;


--
-- Name: auction_report_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY auction_report
    ADD CONSTRAINT auction_report_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE;


--
-- Name: auction_user_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY auction
    ADD CONSTRAINT auction_user_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: bid_auction_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY bid
    ADD CONSTRAINT bid_auction_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE;


--
-- Name: bid_user_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY bid
    ADD CONSTRAINT bid_user_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: city_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY city
    ADD CONSTRAINT city_fk FOREIGN KEY (country_id) REFERENCES country(id) ON DELETE CASCADE;


--
-- Name: feedback_user_id_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY feedback
    ADD CONSTRAINT feedback_user_id_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: follow_user_followed_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT follow_user_followed_fk FOREIGN KEY (user_followed_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: follow_user_following_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY follow
    ADD CONSTRAINT follow_user_following_fk FOREIGN KEY (user_following_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: image_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY image
    ADD CONSTRAINT image_fk FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE;


--
-- Name: notification_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: product_category_category_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY product_category
    ADD CONSTRAINT product_category_category_fk FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE;


--
-- Name: product_category_product_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY product_category
    ADD CONSTRAINT product_category_product_fk FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE;


--
-- Name: question_auction_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY question
    ADD CONSTRAINT question_auction_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE;


--
-- Name: question_report_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY question_report
    ADD CONSTRAINT question_report_fk FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE;


--
-- Name: question_user_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY question
    ADD CONSTRAINT question_user_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: review_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_fk FOREIGN KEY (bid_id) REFERENCES bid(id) ON DELETE CASCADE;


--
-- Name: user_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_fk FOREIGN KEY (city_id) REFERENCES city(id) ON DELETE SET NULL;


--
-- Name: user_report_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY user_report
    ADD CONSTRAINT user_report_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: watchlist_auction_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY watchlist
    ADD CONSTRAINT watchlist_auction_fk FOREIGN KEY (auction_id) REFERENCES auction(id) ON DELETE CASCADE;


--
-- Name: watchlist_user_fk; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1662
--

ALTER TABLE ONLY watchlist
    ADD CONSTRAINT watchlist_user_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

