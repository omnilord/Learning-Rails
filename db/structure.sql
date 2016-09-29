--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.1
-- Dumped by pg_dump version 9.5.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: update_tags(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_tags() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  rtags text[];
  atags text[];
  ntag text;
BEGIN
  IF (TG_OP = 'INSERT') THEN
    rtags := ARRAY[]::text[];
    atags := COALESCE(NEW.tags, ARRAY[]::text[]);
  ELSIF (TG_OP = 'DELETE') THEN
    rtags := COALESCE(OLD.tags, ARRAY[]::text[]);
    atags := ARRAY[]::text[];
  ELSIF (TG_OP = 'UPDATE') THEN
    rtags := ARRAY(
                    SELECT unnest(COALESCE(OLD.tags, ARRAY[]::text[]))
                    EXCEPT
                    SELECT unnest(COALESCE(NEW.tags, ARRAY[]::text[]))
                  );
    atags := ARRAY(
                    SELECT unnest(COALESCE(NEW.tags, ARRAY[]::text[]))
                    EXCEPT
                    SELECT unnest(COALESCE(OLD.tags, ARRAY[]::text[]))
                  );
  ELSE
    RAISE EXCEPTION 'Unknown, unexpected TG_OP value in update_tags.';
  END IF;

  -- First subtract where tags were removed
  IF array_length(rtags, 1) > 0 THEN
    FOREACH ntag IN ARRAY rtags LOOP
      UPDATE tags SET volume=CASE volume WHEN 0 THEN 0 ELSE volume - 1 END
        WHERE tags.tag=ntag;
    END LOOP;
  END IF;

  -- Then add where tags were added
  IF array_length(atags, 1) > 0 THEN
    FOREACH ntag IN ARRAY atags LOOP
      UPDATE tags SET volume=volume+1 WHERE tags.tag=ntag;
      IF NOT FOUND THEN
        INSERT INTO tags VALUES(ntag, 1);
      END IF;
    END LOOP;
  END IF;

  RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE articles (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying,
    body text,
    tags character varying[] DEFAULT '{}'::character varying[],
    user_id integer
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE articles_id_seq OWNED BY articles.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comments (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    article_id integer,
    body text
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    tag text NOT NULL,
    volume integer DEFAULT 0
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    username text,
    email text,
    password_digest text,
    avatar text,
    privilege integer DEFAULT 1
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles ALTER COLUMN id SET DEFAULT nextval('articles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_comments_on_article_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_article_id ON comments USING btree (article_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: maintain_tag_counts_on_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER maintain_tag_counts_on_delete AFTER DELETE ON articles FOR EACH ROW WHEN (((old.tags IS NOT NULL) AND (old.tags <> '{}'::character varying[]))) EXECUTE PROCEDURE update_tags();


--
-- Name: maintain_tag_counts_on_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER maintain_tag_counts_on_insert AFTER INSERT ON articles FOR EACH ROW WHEN (((new.tags IS NOT NULL) AND (new.tags <> '{}'::character varying[]))) EXECUTE PROCEDURE update_tags();


--
-- Name: maintain_tag_counts_on_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER maintain_tag_counts_on_update AFTER UPDATE OF tags ON articles FOR EACH ROW WHEN ((old.tags IS DISTINCT FROM new.tags)) EXECUTE PROCEDURE update_tags();


--
-- Name: fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_3bf61a60d3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT fk_rails_3bf61a60d3 FOREIGN KEY (article_id) REFERENCES articles(id);


--
-- Name: fk_rails_3d31dad1cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT fk_rails_3d31dad1cc FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160510145027');

INSERT INTO schema_migrations (version) VALUES ('20160510215203');

INSERT INTO schema_migrations (version) VALUES ('20160811150728');

INSERT INTO schema_migrations (version) VALUES ('20160811173821');

INSERT INTO schema_migrations (version) VALUES ('20160815095245');

INSERT INTO schema_migrations (version) VALUES ('20160824061854');

INSERT INTO schema_migrations (version) VALUES ('20160919145900');

INSERT INTO schema_migrations (version) VALUES ('20160927153130');

