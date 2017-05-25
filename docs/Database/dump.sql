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



--
-- Name: answer_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('answer_id_seq', 1, false);


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

INSERT INTO auction VALUES (5, 100, 100, '2017-05-25 09:28:00', '2017-05-25 09:30:00', 'Default', 4, 5, '2017-05-25 09:26:37.832878', 1, true, 0, 'Created');
INSERT INTO auction VALUES (6, 12, 12, '2017-05-25 10:06:00', '2017-05-25 10:07:00', 'Default', 4, 6, '2017-05-25 10:03:45.802588', 1, true, 0, 'Closed');
INSERT INTO auction VALUES (7, 12, 12, '2017-05-25 22:42:00', '2017-05-27 10:42:00', 'Default', 4, 7, '2017-05-25 10:43:18.213526', 1, true, 0, 'Created');


--
-- Name: auction_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('auction_id_seq', 7, true);


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



--
-- Name: bid_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('bid_id_seq', 1, false);


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

SELECT pg_catalog.setval('category_id_seq', 18, true);


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

INSERT INTO feedback VALUES (1, 1, 'Hello, this site is really good. Keep up the good work!', '2017-05-22 15:44:09.291428');


--
-- Name: feedback_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('feedback_id_seq', 1, true);


--
-- Data for Name: follow; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--



--
-- Data for Name: image; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO image VALUES (8, '8.png', 5, 'gridGraph.png', 'gridGraph.png');
INSERT INTO image VALUES (9, '9.png', 6, 'gridGraph.png', 'gridGraph.png');
INSERT INTO image VALUES (10, '10.png', 7, 'horario.PNG', 'horario.PNG');


--
-- Name: image_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('image_id_seq', 10, true);


--
-- Data for Name: notification; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO notification VALUES (1, 'Boas, @hant? Está tudo bem? Abraço à família. Estuda muito para COMP', 'Warning', 4, false, '2017-05-22 16:52:24.173989');
INSERT INTO notification VALUES (2, 'Your auction A Game of Thrones (A Song of Ice and Fire, Book 1) was deleted.', 'Auction', 4, false, '2017-05-25 08:32:39.159452');
INSERT INTO notification VALUES (4, 'Your auction bike was deleted.', 'Auction', 4, true, '2017-05-25 09:09:27.100951');
INSERT INTO notification VALUES (5, 'Your auction biker was deleted.', 'Auction', 4, true, '2017-05-25 09:25:37.525926');
INSERT INTO notification VALUES (6, 'Your auction bhjef is now open!<br>', 'Auction', 4, true, '2017-05-25 10:06:02.312908');
INSERT INTO notification VALUES (7, 'The auction bhjef is now open!<br>May the odds be ever in your favor! Good luck!', 'Auction', 4, true, '2017-05-25 10:06:02.318631');
INSERT INTO notification VALUES (8, 'Your auction bhjef is now closed.<br>No one placed a bid in your auction :(. Better luck next time!', 'Auction', 4, true, '2017-05-25 10:07:01.870681');


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('notification_id_seq', 8, true);


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

INSERT INTO product VALUES (3, 'bike', 'good bike.', 'good.', '{good.}');
INSERT INTO product VALUES (4, 'biker', 'dsf', 'dsf', '{sdf}');
INSERT INTO product VALUES (5, 'fsdf', 'dsf', 'sdfsd', '{dsf}');
INSERT INTO product VALUES (6, 'bhjef', 'dsfs', 'fdssdf', '{fdsf}');
INSERT INTO product VALUES (7, 'bfcxvcv', 'xcv', 'xcvxc', '{vcxvx,bvbvb}');


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO product_category VALUES (3, 5);
INSERT INTO product_category VALUES (4, 2);
INSERT INTO product_category VALUES (5, 12);
INSERT INTO product_category VALUES (6, 5);
INSERT INTO product_category VALUES (7, 3);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('product_id_seq', 7, true);


--
-- Data for Name: question; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--



--
-- Name: question_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('question_id_seq', 1, false);


--
-- Data for Name: question_report; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--



--
-- Name: question_report_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('question_report_id_seq', 1, false);


--
-- Data for Name: review; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--



--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('review_id_seq', 1, false);


--
-- Data for Name: user; Type: TABLE DATA; Schema: final; Owner: lbaw1662
--

INSERT INTO "user" VALUES (1, 'renatoabreu', 'renatoabreu1196@gmail.com', 'Renato Abreu', 'Hello. I sell a lot of stuff. Come and see. I have the best things and everything costs 25 Schmeckles.', NULL, '$2y$12$FDpZPDSCltFqIKMi8ATxjeHAgacr1VuX91vWfJiZ1JCX.4N9z7sAO', NULL, '2017-05-09 00:56:32.755805', 'default.png', NULL, 0, NULL, NULL);
INSERT INTO "user" VALUES (2, 'jlopes', 'jlopes@fe.up.pt', 'John Doe', 'Bio really short.', NULL, '$2y$12$gQCytOCmMLPQF93MYTk/ye/Z83gosOcO8sgcblBOnUOTiEpIgAkW.', NULL, '2017-05-22 09:48:06.239041', 'default.png', NULL, 0, NULL, NULL);
INSERT INTO "user" VALUES (4, 'hant', 'up201406163@fe.up.pt', 'Helder Antunes', 'Hello! I sell things I no longer need. Maybe you need it!', 'I just know that I AM.', '$2y$12$Yx9P.HKAZ6l/R/f55x8QQenEhv7ecblfXEN/uVwyaE0KxVFLSyejy', '921212122', '2017-05-22 15:24:39.421975', 'default.png', NULL, 1000, 61, NULL);
INSERT INTO "user" VALUES (6, 'dcepa95', 'dcepa95@gmail.com', 'Diogo Cepa', 'Talk a little about me?', NULL, '$2y$12$ejcRc5zXM2xmog6DW0XMBOtfZ1ep6wEl4DfXmJ/TjPOjPkOKVvFmu', NULL, '2017-05-25 08:29:51.082072', 'default.png', NULL, 0, NULL, NULL);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1662
--

SELECT pg_catalog.setval('user_id_seq', 7, true);


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

INSERT INTO watchlist VALUES (5, 4, true, '2017-05-25 09:26:37.832878');
INSERT INTO watchlist VALUES (6, 4, true, '2017-05-25 10:03:45.802588');
INSERT INTO watchlist VALUES (7, 4, true, '2017-05-25 10:43:18.213526');


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

