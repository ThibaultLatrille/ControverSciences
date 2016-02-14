--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: best_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE best_comments (
    id integer NOT NULL,
    reference_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    f_0_comment_id integer,
    f_1_comment_id integer,
    f_2_comment_id integer,
    f_3_comment_id integer,
    f_4_comment_id integer,
    f_5_comment_id integer,
    f_6_comment_id integer,
    f_7_comment_id integer,
    f_0_user_id integer,
    f_1_user_id integer,
    f_2_user_id integer,
    f_3_user_id integer,
    f_4_user_id integer,
    f_5_user_id integer,
    f_6_user_id integer,
    f_7_user_id integer
);


--
-- Name: best_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE best_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: best_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE best_comments_id_seq OWNED BY best_comments.id;


--
-- Name: binaries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE binaries (
    id integer NOT NULL,
    timeline_id integer,
    reference_id integer,
    user_id integer,
    value integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    frame_id integer
);


--
-- Name: binaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE binaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: binaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE binaries_id_seq OWNED BY binaries.id;


--
-- Name: comment_joins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comment_joins (
    id integer NOT NULL,
    reference_id integer,
    comment_id integer,
    field integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: comment_joins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comment_joins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comment_joins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comment_joins_id_seq OWNED BY comment_joins.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    user_id integer,
    timeline_id integer,
    reference_id integer,
    f_0_content text DEFAULT ''::text,
    f_1_content text DEFAULT ''::text,
    f_2_content text DEFAULT ''::text,
    f_3_content text DEFAULT ''::text,
    f_4_content text DEFAULT ''::text,
    f_5_content text DEFAULT ''::text,
    markdown_0 text DEFAULT ''::text,
    markdown_1 text DEFAULT ''::text,
    markdown_2 text DEFAULT ''::text,
    markdown_3 text DEFAULT ''::text,
    markdown_4 text DEFAULT ''::text,
    markdown_5 text DEFAULT ''::text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    public boolean DEFAULT true,
    caption text DEFAULT ''::text,
    caption_markdown text DEFAULT ''::text,
    title text DEFAULT ''::text,
    title_markdown text DEFAULT ''::text,
    f_0_balance integer DEFAULT 0,
    f_1_balance integer DEFAULT 0,
    f_2_balance integer DEFAULT 0,
    f_3_balance integer DEFAULT 0,
    f_4_balance integer DEFAULT 0,
    f_5_balance integer DEFAULT 0,
    f_6_balance integer DEFAULT 0,
    f_7_balance integer DEFAULT 0,
    f_0_score double precision DEFAULT 0.0,
    f_1_score double precision DEFAULT 0.0,
    f_2_score double precision DEFAULT 0.0,
    f_3_score double precision DEFAULT 0.0,
    f_4_score double precision DEFAULT 0.0,
    f_5_score double precision DEFAULT 0.0,
    f_6_score double precision DEFAULT 0.0,
    f_7_score double precision DEFAULT 0.0,
    figure_id integer,
    notif_generated boolean DEFAULT false
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
-- Name: credits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE credits (
    id integer NOT NULL,
    user_id integer,
    timeline_id integer,
    summary_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: credits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE credits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE credits_id_seq OWNED BY credits.id;


--
-- Name: dead_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dead_links (
    id integer NOT NULL,
    reference_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: dead_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dead_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dead_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dead_links_id_seq OWNED BY dead_links.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: domains; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE domains (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: domains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE domains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE domains_id_seq OWNED BY domains.id;


--
-- Name: edge_votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE edge_votes (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    edge_id integer,
    value boolean
);


--
-- Name: edge_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE edge_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edge_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE edge_votes_id_seq OWNED BY edge_votes.id;


--
-- Name: edges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE edges (
    id integer NOT NULL,
    timeline_id integer,
    target integer,
    weight integer DEFAULT 1,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    plus integer DEFAULT 0,
    minus integer DEFAULT 0,
    balance integer DEFAULT 0
);


--
-- Name: edges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE edges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE edges_id_seq OWNED BY edges.id;


--
-- Name: figures; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE figures (
    id integer NOT NULL,
    reference_id integer,
    timeline_id integer,
    user_id integer,
    profil boolean,
    picture character varying(255),
    file_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    img_timeline_id integer,
    source text DEFAULT ''::text,
    partner_id integer
);


--
-- Name: figures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE figures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: figures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE figures_id_seq OWNED BY figures.id;


--
-- Name: frame_credits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE frame_credits (
    id integer NOT NULL,
    timeline_id integer,
    user_id integer,
    frame_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: frame_credits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE frame_credits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: frame_credits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE frame_credits_id_seq OWNED BY frame_credits.id;


--
-- Name: frames; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE frames (
    id integer NOT NULL,
    timeline_id integer,
    user_id integer,
    name text,
    content text,
    name_markdown text,
    content_markdown text,
    score double precision DEFAULT 0.0,
    balance integer DEFAULT 0,
    best boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "binary" text DEFAULT ''::text
);


--
-- Name: frames_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE frames_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: frames_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE frames_id_seq OWNED BY frames.id;


--
-- Name: go_patches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE go_patches (
    id integer NOT NULL,
    comment_id integer,
    user_id integer,
    summary_id integer,
    field integer,
    target_user_id integer,
    frame_id integer,
    content text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    counter integer DEFAULT 0
);


--
-- Name: go_patches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE go_patches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: go_patches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE go_patches_id_seq OWNED BY go_patches.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invitations (
    id integer NOT NULL,
    user_id integer,
    message text,
    timeline_id integer,
    reference_id integer,
    target_email text,
    target_name text,
    user_name text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invitations_id_seq OWNED BY invitations.id;


--
-- Name: issues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issues (
    id integer NOT NULL,
    title character varying(255),
    body text,
    labels text[] DEFAULT '{}'::text[],
    author character varying(255),
    importance integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    url character varying(255)
);


--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issues_id_seq OWNED BY issues.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE likes (
    id integer NOT NULL,
    timeline_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer
);


--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE likes_id_seq OWNED BY likes.id;


--
-- Name: links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE links (
    id integer NOT NULL,
    user_id integer,
    comment_id integer,
    reference_id integer,
    timeline_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    count integer
);


--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE links_id_seq OWNED BY links.id;


--
-- Name: newsletters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE newsletters (
    id integer NOT NULL,
    email text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: newsletters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE newsletters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: newsletters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE newsletters_id_seq OWNED BY newsletters.id;


--
-- Name: notification_selections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notification_selections (
    id integer NOT NULL,
    timeline_id integer,
    reference_id integer,
    frame_id integer,
    comment_id integer,
    summary_id integer,
    user_id integer,
    win boolean,
    field integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: notification_selections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notification_selections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_selections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notification_selections_id_seq OWNED BY notification_selections.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifications (
    id integer NOT NULL,
    user_id integer,
    timeline_id integer,
    reference_id integer,
    summary_id integer,
    comment_id integer,
    like_id integer,
    category integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    field integer,
    suggestion_id integer,
    frame_id integer
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: partner_loves; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE partner_loves (
    id integer NOT NULL,
    partner_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: partner_loves_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE partner_loves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: partner_loves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE partner_loves_id_seq OWNED BY partner_loves.id;


--
-- Name: partners; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE partners (
    id integer NOT NULL,
    user_id integer,
    name text,
    url text,
    description text,
    why text,
    name_markdown text,
    description_markdown text,
    why_markdown text,
    figure_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    loves integer DEFAULT 0
);


--
-- Name: partners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE partners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE partners_id_seq OWNED BY partners.id;


--
-- Name: pending_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pending_users (
    id integer NOT NULL,
    user_id integer,
    why text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    refused boolean DEFAULT false
);


--
-- Name: pending_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pending_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pending_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pending_users_id_seq OWNED BY pending_users.id;


--
-- Name: private_timelines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE private_timelines (
    id integer NOT NULL,
    user_id integer,
    timeline_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: private_timelines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE private_timelines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: private_timelines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE private_timelines_id_seq OWNED BY private_timelines.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    user_id integer,
    title text,
    title_markdown text,
    content text,
    content_markdown text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ratings (
    id integer NOT NULL,
    reference_id integer,
    timeline_id integer,
    user_id integer,
    value integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ratings_id_seq OWNED BY ratings.id;


--
-- Name: reference_contributors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reference_contributors (
    id integer NOT NULL,
    user_id integer,
    reference_id integer,
    bool boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reference_contributors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reference_contributors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reference_contributors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reference_contributors_id_seq OWNED BY reference_contributors.id;


--
-- Name: reference_edge_votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reference_edge_votes (
    id integer NOT NULL,
    timeline_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    reference_edge_id integer,
    value boolean,
    category integer
);


--
-- Name: reference_edge_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reference_edge_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reference_edge_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reference_edge_votes_id_seq OWNED BY reference_edge_votes.id;


--
-- Name: reference_edges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reference_edges (
    id integer NOT NULL,
    timeline_id integer,
    reference_id integer,
    target integer,
    weight integer DEFAULT 1,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    category integer,
    plus integer DEFAULT 0,
    minus integer DEFAULT 0,
    balance integer DEFAULT 0
);


--
-- Name: reference_edges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reference_edges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reference_edges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reference_edges_id_seq OWNED BY reference_edges.id;


--
-- Name: reference_taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reference_taggings (
    id integer NOT NULL,
    tag_id integer,
    reference_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reference_taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reference_taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reference_taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reference_taggings_id_seq OWNED BY reference_taggings.id;


--
-- Name: reference_user_taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reference_user_taggings (
    id integer NOT NULL,
    tag_id integer,
    reference_user_tag_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reference_user_taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reference_user_taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reference_user_taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reference_user_taggings_id_seq OWNED BY reference_user_taggings.id;


--
-- Name: reference_user_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reference_user_tags (
    id integer NOT NULL,
    reference_id integer,
    timeline_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reference_user_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reference_user_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reference_user_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reference_user_tags_id_seq OWNED BY reference_user_tags.id;


--
-- Name: references; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "references" (
    id integer NOT NULL,
    user_id integer,
    timeline_id integer,
    doi text,
    url text,
    year integer,
    title text,
    title_fr text,
    author text,
    journal text,
    publisher text,
    open_access boolean DEFAULT true,
    abstract text DEFAULT ''::text,
    nb_contributors integer DEFAULT 0,
    nb_edits integer DEFAULT 0,
    nb_votes integer DEFAULT 0,
    star_1 integer DEFAULT 0,
    star_2 integer DEFAULT 0,
    star_3 integer DEFAULT 0,
    star_4 integer DEFAULT 0,
    star_5 integer DEFAULT 0,
    star_most integer DEFAULT 0,
    binary_1 integer DEFAULT 0,
    binary_2 integer DEFAULT 0,
    binary_3 integer DEFAULT 0,
    binary_4 integer DEFAULT 0,
    binary_5 integer DEFAULT 0,
    binary_most integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "binary" character varying(255) DEFAULT ''::character varying,
    article boolean DEFAULT true,
    abstract_markdown text DEFAULT ''::text,
    category integer,
    slug character varying(255),
    views integer DEFAULT 0
);


--
-- Name: references_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE references_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: references_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE references_id_seq OWNED BY "references".id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: suggestion_child_votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE suggestion_child_votes (
    id integer NOT NULL,
    suggestion_child_id integer,
    value boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer
);


--
-- Name: suggestion_child_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE suggestion_child_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suggestion_child_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE suggestion_child_votes_id_seq OWNED BY suggestion_child_votes.id;


--
-- Name: suggestion_children; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE suggestion_children (
    id integer NOT NULL,
    user_id integer,
    suggestion_id integer,
    comment text,
    balance integer DEFAULT 0,
    plus integer DEFAULT 0,
    minus integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    content_markdown text DEFAULT ''::text
);


--
-- Name: suggestion_children_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE suggestion_children_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suggestion_children_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE suggestion_children_id_seq OWNED BY suggestion_children.id;


--
-- Name: suggestion_votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE suggestion_votes (
    id integer NOT NULL,
    suggestion_id integer,
    value boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer
);


--
-- Name: suggestion_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE suggestion_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suggestion_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE suggestion_votes_id_seq OWNED BY suggestion_votes.id;


--
-- Name: suggestions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE suggestions (
    id integer NOT NULL,
    user_id integer,
    comment text,
    timeline_id integer,
    balance integer DEFAULT 0,
    plus integer DEFAULT 0,
    minus integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    children integer DEFAULT 0,
    content_markdown text DEFAULT ''::text
);


--
-- Name: suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE suggestions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE suggestions_id_seq OWNED BY suggestions.id;


--
-- Name: summaries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE summaries (
    id integer NOT NULL,
    user_id integer,
    timeline_id integer,
    balance integer DEFAULT 0,
    score double precision,
    best boolean DEFAULT false,
    content text DEFAULT ''::text,
    markdown text DEFAULT ''::text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    public boolean DEFAULT true,
    caption text DEFAULT ''::text,
    caption_markdown text DEFAULT ''::text,
    figure_id integer,
    notif_generated boolean DEFAULT false
);


--
-- Name: summaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE summaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: summaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE summaries_id_seq OWNED BY summaries.id;


--
-- Name: summary_bests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE summary_bests (
    id integer NOT NULL,
    user_id integer,
    timeline_id integer,
    summary_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: summary_bests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE summary_bests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: summary_bests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE summary_bests_id_seq OWNED BY summary_bests.id;


--
-- Name: summary_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE summary_links (
    id integer NOT NULL,
    user_id integer,
    timeline_id integer,
    reference_id integer,
    summary_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    count integer
);


--
-- Name: summary_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE summary_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: summary_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE summary_links_id_seq OWNED BY summary_links.id;


--
-- Name: tag_pairs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tag_pairs (
    id integer NOT NULL,
    tag_theme_source integer,
    tag_theme_target integer,
    "references" boolean,
    occurencies integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tag_pairs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tag_pairs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_pairs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tag_pairs_id_seq OWNED BY tag_pairs.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    timeline_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: timeline_contributors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE timeline_contributors (
    id integer NOT NULL,
    user_id integer,
    timeline_id integer,
    bool boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: timeline_contributors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timeline_contributors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timeline_contributors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE timeline_contributors_id_seq OWNED BY timeline_contributors.id;


--
-- Name: timelines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE timelines (
    id integer NOT NULL,
    name text,
    user_id integer,
    nb_references integer DEFAULT 0,
    nb_contributors integer DEFAULT 0,
    nb_likes integer DEFAULT 0,
    nb_comments integer DEFAULT 0,
    nb_summaries integer DEFAULT 0,
    score double precision DEFAULT 1.0,
    score_recent double precision DEFAULT 1.0,
    debate boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "binary" character varying(255) DEFAULT ''::character varying,
    nb_frames integer DEFAULT 0,
    frame text DEFAULT ''::text,
    figure_id integer,
    slug character varying(255),
    private boolean DEFAULT false,
    staging boolean DEFAULT false,
    views integer DEFAULT 0,
    favorite boolean DEFAULT false
);


--
-- Name: timelines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE timelines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timelines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE timelines_id_seq OWNED BY timelines.id;


--
-- Name: user_details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_details (
    id integer NOT NULL,
    user_id integer,
    institution character varying(255),
    job character varying(255),
    website character varying(255),
    biography text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    figure_id integer,
    content_markdown text DEFAULT ''::text,
    send_email boolean DEFAULT true,
    profil hstore
);


--
-- Name: user_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_details_id_seq OWNED BY user_details.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    score double precision DEFAULT 1.0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    password_digest character varying(255),
    remember_digest character varying(255),
    admin boolean DEFAULT false,
    activation_digest character varying(255),
    activated boolean DEFAULT false,
    activated_at timestamp without time zone,
    reset_digest character varying(255),
    reset_sent_at timestamp without time zone,
    important integer,
    nb_notifs integer DEFAULT 0,
    can_switch_admin boolean DEFAULT false,
    slug character varying(255),
    private_timeline boolean DEFAULT false,
    nb_private integer DEFAULT 0,
    my_patches integer DEFAULT 0,
    target_patches integer DEFAULT 0,
    first_name text DEFAULT ''::text,
    last_name text DEFAULT ''::text
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
-- Name: visite_references; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visite_references (
    id integer NOT NULL,
    user_id integer,
    reference_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    counter integer DEFAULT 0
);


--
-- Name: visite_references_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visite_references_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visite_references_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visite_references_id_seq OWNED BY visite_references.id;


--
-- Name: visite_timelines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visite_timelines (
    id integer NOT NULL,
    user_id integer,
    timeline_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    counter integer DEFAULT 0
);


--
-- Name: visite_timelines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visite_timelines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visite_timelines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visite_timelines_id_seq OWNED BY visite_timelines.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer NOT NULL,
    user_id integer,
    timeline_id integer,
    reference_id integer,
    comment_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    field integer
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY best_comments ALTER COLUMN id SET DEFAULT nextval('best_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY binaries ALTER COLUMN id SET DEFAULT nextval('binaries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comment_joins ALTER COLUMN id SET DEFAULT nextval('comment_joins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY credits ALTER COLUMN id SET DEFAULT nextval('credits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY dead_links ALTER COLUMN id SET DEFAULT nextval('dead_links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY domains ALTER COLUMN id SET DEFAULT nextval('domains_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY edge_votes ALTER COLUMN id SET DEFAULT nextval('edge_votes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY edges ALTER COLUMN id SET DEFAULT nextval('edges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY figures ALTER COLUMN id SET DEFAULT nextval('figures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY frame_credits ALTER COLUMN id SET DEFAULT nextval('frame_credits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY frames ALTER COLUMN id SET DEFAULT nextval('frames_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY go_patches ALTER COLUMN id SET DEFAULT nextval('go_patches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations ALTER COLUMN id SET DEFAULT nextval('invitations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issues ALTER COLUMN id SET DEFAULT nextval('issues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY likes ALTER COLUMN id SET DEFAULT nextval('likes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY newsletters ALTER COLUMN id SET DEFAULT nextval('newsletters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notification_selections ALTER COLUMN id SET DEFAULT nextval('notification_selections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY partner_loves ALTER COLUMN id SET DEFAULT nextval('partner_loves_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY partners ALTER COLUMN id SET DEFAULT nextval('partners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pending_users ALTER COLUMN id SET DEFAULT nextval('pending_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY private_timelines ALTER COLUMN id SET DEFAULT nextval('private_timelines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ratings ALTER COLUMN id SET DEFAULT nextval('ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reference_contributors ALTER COLUMN id SET DEFAULT nextval('reference_contributors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reference_edge_votes ALTER COLUMN id SET DEFAULT nextval('reference_edge_votes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reference_edges ALTER COLUMN id SET DEFAULT nextval('reference_edges_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reference_taggings ALTER COLUMN id SET DEFAULT nextval('reference_taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reference_user_taggings ALTER COLUMN id SET DEFAULT nextval('reference_user_taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reference_user_tags ALTER COLUMN id SET DEFAULT nextval('reference_user_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "references" ALTER COLUMN id SET DEFAULT nextval('references_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY suggestion_child_votes ALTER COLUMN id SET DEFAULT nextval('suggestion_child_votes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY suggestion_children ALTER COLUMN id SET DEFAULT nextval('suggestion_children_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY suggestion_votes ALTER COLUMN id SET DEFAULT nextval('suggestion_votes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY suggestions ALTER COLUMN id SET DEFAULT nextval('suggestions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY summaries ALTER COLUMN id SET DEFAULT nextval('summaries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY summary_bests ALTER COLUMN id SET DEFAULT nextval('summary_bests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY summary_links ALTER COLUMN id SET DEFAULT nextval('summary_links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_pairs ALTER COLUMN id SET DEFAULT nextval('tag_pairs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY timeline_contributors ALTER COLUMN id SET DEFAULT nextval('timeline_contributors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY timelines ALTER COLUMN id SET DEFAULT nextval('timelines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_details ALTER COLUMN id SET DEFAULT nextval('user_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visite_references ALTER COLUMN id SET DEFAULT nextval('visite_references_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visite_timelines ALTER COLUMN id SET DEFAULT nextval('visite_timelines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: best_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY best_comments
    ADD CONSTRAINT best_comments_pkey PRIMARY KEY (id);


--
-- Name: binaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY binaries
    ADD CONSTRAINT binaries_pkey PRIMARY KEY (id);


--
-- Name: comment_joins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comment_joins
    ADD CONSTRAINT comment_joins_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: credits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY credits
    ADD CONSTRAINT credits_pkey PRIMARY KEY (id);


--
-- Name: dead_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dead_links
    ADD CONSTRAINT dead_links_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: domains_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (id);


--
-- Name: edge_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY edge_votes
    ADD CONSTRAINT edge_votes_pkey PRIMARY KEY (id);


--
-- Name: edges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY edges
    ADD CONSTRAINT edges_pkey PRIMARY KEY (id);


--
-- Name: figures_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY figures
    ADD CONSTRAINT figures_pkey PRIMARY KEY (id);


--
-- Name: frame_credits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY frame_credits
    ADD CONSTRAINT frame_credits_pkey PRIMARY KEY (id);


--
-- Name: frames_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY frames
    ADD CONSTRAINT frames_pkey PRIMARY KEY (id);


--
-- Name: invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: newsletters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY newsletters
    ADD CONSTRAINT newsletters_pkey PRIMARY KEY (id);


--
-- Name: notification_selections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification_selections
    ADD CONSTRAINT notification_selections_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: partner_loves_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY partner_loves
    ADD CONSTRAINT partner_loves_pkey PRIMARY KEY (id);


--
-- Name: partners_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY partners
    ADD CONSTRAINT partners_pkey PRIMARY KEY (id);


--
-- Name: patches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY go_patches
    ADD CONSTRAINT patches_pkey PRIMARY KEY (id);


--
-- Name: pending_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pending_users
    ADD CONSTRAINT pending_users_pkey PRIMARY KEY (id);


--
-- Name: private_timelines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY private_timelines
    ADD CONSTRAINT private_timelines_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: reference_contributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reference_contributors
    ADD CONSTRAINT reference_contributors_pkey PRIMARY KEY (id);


--
-- Name: reference_edge_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reference_edge_votes
    ADD CONSTRAINT reference_edge_votes_pkey PRIMARY KEY (id);


--
-- Name: reference_edges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reference_edges
    ADD CONSTRAINT reference_edges_pkey PRIMARY KEY (id);


--
-- Name: reference_taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reference_taggings
    ADD CONSTRAINT reference_taggings_pkey PRIMARY KEY (id);


--
-- Name: reference_user_taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reference_user_taggings
    ADD CONSTRAINT reference_user_taggings_pkey PRIMARY KEY (id);


--
-- Name: reference_user_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reference_user_tags
    ADD CONSTRAINT reference_user_tags_pkey PRIMARY KEY (id);


--
-- Name: references_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "references"
    ADD CONSTRAINT references_pkey PRIMARY KEY (id);


--
-- Name: suggestion_child_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY suggestion_child_votes
    ADD CONSTRAINT suggestion_child_votes_pkey PRIMARY KEY (id);


--
-- Name: suggestion_children_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY suggestion_children
    ADD CONSTRAINT suggestion_children_pkey PRIMARY KEY (id);


--
-- Name: suggestion_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY suggestion_votes
    ADD CONSTRAINT suggestion_votes_pkey PRIMARY KEY (id);


--
-- Name: suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY suggestions
    ADD CONSTRAINT suggestions_pkey PRIMARY KEY (id);


--
-- Name: summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY summaries
    ADD CONSTRAINT summaries_pkey PRIMARY KEY (id);


--
-- Name: summary_bests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY summary_bests
    ADD CONSTRAINT summary_bests_pkey PRIMARY KEY (id);


--
-- Name: summary_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY summary_links
    ADD CONSTRAINT summary_links_pkey PRIMARY KEY (id);


--
-- Name: tag_pairs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tag_pairs
    ADD CONSTRAINT tag_pairs_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: timeline_contributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timeline_contributors
    ADD CONSTRAINT timeline_contributors_pkey PRIMARY KEY (id);


--
-- Name: timelines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY timelines
    ADD CONSTRAINT timelines_pkey PRIMARY KEY (id);


--
-- Name: user_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_details
    ADD CONSTRAINT user_details_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visite_references_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visite_references
    ADD CONSTRAINT visite_references_pkey PRIMARY KEY (id);


--
-- Name: visite_timelines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visite_timelines
    ADD CONSTRAINT visite_timelines_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: index_best_comments_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_best_comments_on_reference_id ON best_comments USING btree (reference_id);


--
-- Name: index_binaries_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_binaries_on_reference_id ON binaries USING btree (reference_id);


--
-- Name: index_binaries_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_binaries_on_timeline_id ON binaries USING btree (timeline_id);


--
-- Name: index_binaries_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_binaries_on_user_id ON binaries USING btree (user_id);


--
-- Name: index_comment_joins_on_comment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comment_joins_on_comment_id ON comment_joins USING btree (comment_id);


--
-- Name: index_comment_joins_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comment_joins_on_reference_id ON comment_joins USING btree (reference_id);


--
-- Name: index_comments_on_figure_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_figure_id ON comments USING btree (figure_id);


--
-- Name: index_comments_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_reference_id ON comments USING btree (reference_id);


--
-- Name: index_comments_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_timeline_id ON comments USING btree (timeline_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_credits_on_summary_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_credits_on_summary_id ON credits USING btree (summary_id);


--
-- Name: index_credits_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_credits_on_timeline_id ON credits USING btree (timeline_id);


--
-- Name: index_credits_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_credits_on_user_id ON credits USING btree (user_id);


--
-- Name: index_dead_links_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_dead_links_on_reference_id ON dead_links USING btree (reference_id);


--
-- Name: index_dead_links_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_dead_links_on_user_id ON dead_links USING btree (user_id);


--
-- Name: index_edge_votes_on_edge_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_edge_votes_on_edge_id ON edge_votes USING btree (edge_id);


--
-- Name: index_edge_votes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_edge_votes_on_user_id ON edge_votes USING btree (user_id);


--
-- Name: index_edges_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_edges_on_timeline_id ON edges USING btree (timeline_id);


--
-- Name: index_figures_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_figures_on_reference_id ON figures USING btree (reference_id);


--
-- Name: index_figures_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_figures_on_timeline_id ON figures USING btree (timeline_id);


--
-- Name: index_figures_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_figures_on_user_id ON figures USING btree (user_id);


--
-- Name: index_frame_credits_on_frame_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_frame_credits_on_frame_id ON frame_credits USING btree (frame_id);


--
-- Name: index_frame_credits_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_frame_credits_on_timeline_id ON frame_credits USING btree (timeline_id);


--
-- Name: index_frame_credits_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_frame_credits_on_user_id ON frame_credits USING btree (user_id);


--
-- Name: index_frames_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_frames_on_timeline_id ON frames USING btree (timeline_id);


--
-- Name: index_frames_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_frames_on_user_id ON frames USING btree (user_id);


--
-- Name: index_go_patches_on_comment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_go_patches_on_comment_id ON go_patches USING btree (comment_id);


--
-- Name: index_go_patches_on_frame_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_go_patches_on_frame_id ON go_patches USING btree (frame_id);


--
-- Name: index_go_patches_on_summary_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_go_patches_on_summary_id ON go_patches USING btree (summary_id);


--
-- Name: index_go_patches_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_go_patches_on_user_id ON go_patches USING btree (user_id);


--
-- Name: index_invitations_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invitations_on_reference_id ON invitations USING btree (reference_id);


--
-- Name: index_invitations_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invitations_on_timeline_id ON invitations USING btree (timeline_id);


--
-- Name: index_invitations_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invitations_on_user_id ON invitations USING btree (user_id);


--
-- Name: index_likes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_likes_on_user_id ON likes USING btree (user_id);


--
-- Name: index_links_on_comment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_links_on_comment_id ON links USING btree (comment_id);


--
-- Name: index_links_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_links_on_reference_id ON links USING btree (reference_id);


--
-- Name: index_links_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_links_on_timeline_id ON links USING btree (timeline_id);


--
-- Name: index_links_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_links_on_user_id ON links USING btree (user_id);


--
-- Name: index_notification_selections_on_comment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notification_selections_on_comment_id ON notification_selections USING btree (comment_id);


--
-- Name: index_notification_selections_on_frame_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notification_selections_on_frame_id ON notification_selections USING btree (frame_id);


--
-- Name: index_notification_selections_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notification_selections_on_reference_id ON notification_selections USING btree (reference_id);


--
-- Name: index_notification_selections_on_summary_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notification_selections_on_summary_id ON notification_selections USING btree (summary_id);


--
-- Name: index_notification_selections_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notification_selections_on_timeline_id ON notification_selections USING btree (timeline_id);


--
-- Name: index_notification_selections_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notification_selections_on_user_id ON notification_selections USING btree (user_id);


--
-- Name: index_notifications_on_comment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_comment_id ON notifications USING btree (comment_id);


--
-- Name: index_notifications_on_frame_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_frame_id ON notifications USING btree (frame_id);


--
-- Name: index_notifications_on_like_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_like_id ON notifications USING btree (like_id);


--
-- Name: index_notifications_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_reference_id ON notifications USING btree (reference_id);


--
-- Name: index_notifications_on_suggestion_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_suggestion_id ON notifications USING btree (suggestion_id);


--
-- Name: index_notifications_on_summary_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_summary_id ON notifications USING btree (summary_id);


--
-- Name: index_notifications_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_timeline_id ON notifications USING btree (timeline_id);


--
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_user_id ON notifications USING btree (user_id);


--
-- Name: index_partner_loves_on_partner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_partner_loves_on_partner_id ON partner_loves USING btree (partner_id);


--
-- Name: index_partner_loves_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_partner_loves_on_user_id ON partner_loves USING btree (user_id);


--
-- Name: index_partners_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_partners_on_user_id ON partners USING btree (user_id);


--
-- Name: index_pending_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pending_users_on_user_id ON pending_users USING btree (user_id);


--
-- Name: index_private_timelines_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_private_timelines_on_timeline_id ON private_timelines USING btree (timeline_id);


--
-- Name: index_private_timelines_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_private_timelines_on_user_id ON private_timelines USING btree (user_id);


--
-- Name: index_questions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_user_id ON questions USING btree (user_id);


--
-- Name: index_ratings_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_reference_id ON ratings USING btree (reference_id);


--
-- Name: index_ratings_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_timeline_id ON ratings USING btree (timeline_id);


--
-- Name: index_ratings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_user_id ON ratings USING btree (user_id);


--
-- Name: index_reference_contributors_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_contributors_on_reference_id ON reference_contributors USING btree (reference_id);


--
-- Name: index_reference_contributors_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_contributors_on_user_id ON reference_contributors USING btree (user_id);


--
-- Name: index_reference_edge_votes_on_reference_edge_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_edge_votes_on_reference_edge_id ON reference_edge_votes USING btree (reference_edge_id);


--
-- Name: index_reference_edge_votes_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_edge_votes_on_timeline_id ON reference_edge_votes USING btree (timeline_id);


--
-- Name: index_reference_edge_votes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_edge_votes_on_user_id ON reference_edge_votes USING btree (user_id);


--
-- Name: index_reference_edges_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_edges_on_reference_id ON reference_edges USING btree (reference_id);


--
-- Name: index_reference_edges_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_edges_on_timeline_id ON reference_edges USING btree (timeline_id);


--
-- Name: index_reference_edges_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_edges_on_user_id ON reference_edges USING btree (user_id);


--
-- Name: index_reference_taggings_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_taggings_on_reference_id ON reference_taggings USING btree (reference_id);


--
-- Name: index_reference_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_taggings_on_tag_id ON reference_taggings USING btree (tag_id);


--
-- Name: index_reference_user_taggings_on_reference_user_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_user_taggings_on_reference_user_tag_id ON reference_user_taggings USING btree (reference_user_tag_id);


--
-- Name: index_reference_user_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_user_taggings_on_tag_id ON reference_user_taggings USING btree (tag_id);


--
-- Name: index_reference_user_tags_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_user_tags_on_reference_id ON reference_user_tags USING btree (reference_id);


--
-- Name: index_reference_user_tags_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_user_tags_on_timeline_id ON reference_user_tags USING btree (timeline_id);


--
-- Name: index_reference_user_tags_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_reference_user_tags_on_user_id ON reference_user_tags USING btree (user_id);


--
-- Name: index_references_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_references_on_slug ON "references" USING btree (slug);


--
-- Name: index_references_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_references_on_timeline_id ON "references" USING btree (timeline_id);


--
-- Name: index_references_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_references_on_user_id ON "references" USING btree (user_id);


--
-- Name: index_suggestion_child_votes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_suggestion_child_votes_on_user_id ON suggestion_child_votes USING btree (user_id);


--
-- Name: index_suggestion_children_on_suggestion_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_suggestion_children_on_suggestion_id ON suggestion_children USING btree (suggestion_id);


--
-- Name: index_suggestion_children_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_suggestion_children_on_user_id ON suggestion_children USING btree (user_id);


--
-- Name: index_suggestion_votes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_suggestion_votes_on_user_id ON suggestion_votes USING btree (user_id);


--
-- Name: index_suggestions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_suggestions_on_user_id ON suggestions USING btree (user_id);


--
-- Name: index_summaries_on_figure_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_summaries_on_figure_id ON summaries USING btree (figure_id);


--
-- Name: index_summaries_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_summaries_on_timeline_id ON summaries USING btree (timeline_id);


--
-- Name: index_summaries_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_summaries_on_user_id ON summaries USING btree (user_id);


--
-- Name: index_summary_bests_on_summary_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_summary_bests_on_summary_id ON summary_bests USING btree (summary_id);


--
-- Name: index_summary_bests_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_summary_bests_on_timeline_id ON summary_bests USING btree (timeline_id);


--
-- Name: index_summary_bests_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_summary_bests_on_user_id ON summary_bests USING btree (user_id);


--
-- Name: index_summary_links_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_summary_links_on_reference_id ON summary_links USING btree (reference_id);


--
-- Name: index_summary_links_on_summary_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_summary_links_on_summary_id ON summary_links USING btree (summary_id);


--
-- Name: index_summary_links_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_summary_links_on_timeline_id ON summary_links USING btree (timeline_id);


--
-- Name: index_summary_links_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_summary_links_on_user_id ON summary_links USING btree (user_id);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_timeline_id ON taggings USING btree (timeline_id);


--
-- Name: index_timeline_contributors_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_timeline_contributors_on_timeline_id ON timeline_contributors USING btree (timeline_id);


--
-- Name: index_timeline_contributors_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_timeline_contributors_on_user_id ON timeline_contributors USING btree (user_id);


--
-- Name: index_timelines_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_timelines_on_created_at ON timelines USING btree (created_at);


--
-- Name: index_timelines_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_timelines_on_slug ON timelines USING btree (slug);


--
-- Name: index_timelines_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_timelines_on_user_id ON timelines USING btree (user_id);


--
-- Name: index_user_details_on_figure_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_details_on_figure_id ON user_details USING btree (figure_id);


--
-- Name: index_user_details_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_details_on_user_id ON user_details USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_slug ON users USING btree (slug);


--
-- Name: index_visite_references_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visite_references_on_reference_id ON visite_references USING btree (reference_id);


--
-- Name: index_visite_references_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visite_references_on_user_id ON visite_references USING btree (user_id);


--
-- Name: index_visite_references_on_user_id_and_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_visite_references_on_user_id_and_reference_id ON visite_references USING btree (user_id, reference_id);


--
-- Name: index_visite_timelines_on_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visite_timelines_on_timeline_id ON visite_timelines USING btree (timeline_id);


--
-- Name: index_visite_timelines_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visite_timelines_on_user_id ON visite_timelines USING btree (user_id);


--
-- Name: index_visite_timelines_on_user_id_and_timeline_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_visite_timelines_on_user_id_and_timeline_id ON visite_timelines USING btree (user_id, timeline_id);


--
-- Name: index_votes_on_comment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_comment_id ON votes USING btree (comment_id);


--
-- Name: index_votes_on_reference_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_reference_id ON votes USING btree (reference_id);


--
-- Name: index_votes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_user_id ON votes USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140921155518');

INSERT INTO schema_migrations (version) VALUES ('20140921181143');

INSERT INTO schema_migrations (version) VALUES ('20140921183612');

INSERT INTO schema_migrations (version) VALUES ('20140923130942');

INSERT INTO schema_migrations (version) VALUES ('20140925145911');

INSERT INTO schema_migrations (version) VALUES ('20140925182213');

INSERT INTO schema_migrations (version) VALUES ('20140926084205');

INSERT INTO schema_migrations (version) VALUES ('20141004211629');

INSERT INTO schema_migrations (version) VALUES ('20141009010500');

INSERT INTO schema_migrations (version) VALUES ('20141012084903');

INSERT INTO schema_migrations (version) VALUES ('20141014133717');

INSERT INTO schema_migrations (version) VALUES ('20141014135502');

INSERT INTO schema_migrations (version) VALUES ('20141016062355');

INSERT INTO schema_migrations (version) VALUES ('20141103124421');

INSERT INTO schema_migrations (version) VALUES ('20141113113628');

INSERT INTO schema_migrations (version) VALUES ('20141114104539');

INSERT INTO schema_migrations (version) VALUES ('20141114104556');

INSERT INTO schema_migrations (version) VALUES ('20141118115026');

INSERT INTO schema_migrations (version) VALUES ('20141119101238');

INSERT INTO schema_migrations (version) VALUES ('20141119101317');

INSERT INTO schema_migrations (version) VALUES ('20141119101342');

INSERT INTO schema_migrations (version) VALUES ('20141119170822');

INSERT INTO schema_migrations (version) VALUES ('20141119170848');

INSERT INTO schema_migrations (version) VALUES ('20141119171005');

INSERT INTO schema_migrations (version) VALUES ('20141120151206');

INSERT INTO schema_migrations (version) VALUES ('20141120151226');

INSERT INTO schema_migrations (version) VALUES ('20141120151427');

INSERT INTO schema_migrations (version) VALUES ('20141121094019');

INSERT INTO schema_migrations (version) VALUES ('20141203214004');

INSERT INTO schema_migrations (version) VALUES ('20141203214114');

INSERT INTO schema_migrations (version) VALUES ('20141216090451');

INSERT INTO schema_migrations (version) VALUES ('20141216105604');

INSERT INTO schema_migrations (version) VALUES ('20141217095244');

INSERT INTO schema_migrations (version) VALUES ('20141218003217');

INSERT INTO schema_migrations (version) VALUES ('20141220142612');

INSERT INTO schema_migrations (version) VALUES ('20141220174041');

INSERT INTO schema_migrations (version) VALUES ('20141220174228');

INSERT INTO schema_migrations (version) VALUES ('20141220174336');

INSERT INTO schema_migrations (version) VALUES ('20141220174859');

INSERT INTO schema_migrations (version) VALUES ('20141220175004');

INSERT INTO schema_migrations (version) VALUES ('20141220182220');

INSERT INTO schema_migrations (version) VALUES ('20141220182852');

INSERT INTO schema_migrations (version) VALUES ('20141221160028');

INSERT INTO schema_migrations (version) VALUES ('20141222223714');

INSERT INTO schema_migrations (version) VALUES ('20141223111756');

INSERT INTO schema_migrations (version) VALUES ('20141223111915');

INSERT INTO schema_migrations (version) VALUES ('20141223111945');

INSERT INTO schema_migrations (version) VALUES ('20141223112223');

INSERT INTO schema_migrations (version) VALUES ('20141230122232');

INSERT INTO schema_migrations (version) VALUES ('20141230122406');

INSERT INTO schema_migrations (version) VALUES ('20141230150724');

INSERT INTO schema_migrations (version) VALUES ('20141231012129');

INSERT INTO schema_migrations (version) VALUES ('20150111203636');

INSERT INTO schema_migrations (version) VALUES ('20150111210149');

INSERT INTO schema_migrations (version) VALUES ('20150125191049');

INSERT INTO schema_migrations (version) VALUES ('20150125191109');

INSERT INTO schema_migrations (version) VALUES ('20150125191128');

INSERT INTO schema_migrations (version) VALUES ('20150125191144');

INSERT INTO schema_migrations (version) VALUES ('20150125191212');

INSERT INTO schema_migrations (version) VALUES ('20150125191246');

INSERT INTO schema_migrations (version) VALUES ('20150129223433');

INSERT INTO schema_migrations (version) VALUES ('20150129224218');

INSERT INTO schema_migrations (version) VALUES ('20150129232507');

INSERT INTO schema_migrations (version) VALUES ('20150214234916');

INSERT INTO schema_migrations (version) VALUES ('20150215004812');

INSERT INTO schema_migrations (version) VALUES ('20150215014341');

INSERT INTO schema_migrations (version) VALUES ('20150215023109');

INSERT INTO schema_migrations (version) VALUES ('20150217110149');

INSERT INTO schema_migrations (version) VALUES ('20150217134740');

INSERT INTO schema_migrations (version) VALUES ('20150224154940');

INSERT INTO schema_migrations (version) VALUES ('20150224161134');

INSERT INTO schema_migrations (version) VALUES ('20150226103100');

INSERT INTO schema_migrations (version) VALUES ('20150226222928');

INSERT INTO schema_migrations (version) VALUES ('20150308135736');

INSERT INTO schema_migrations (version) VALUES ('20150327181220');

INSERT INTO schema_migrations (version) VALUES ('20150328131720');

INSERT INTO schema_migrations (version) VALUES ('20150401140623');

INSERT INTO schema_migrations (version) VALUES ('20150401204856');

INSERT INTO schema_migrations (version) VALUES ('20150403134742');

INSERT INTO schema_migrations (version) VALUES ('20150420193904');

INSERT INTO schema_migrations (version) VALUES ('20150422123340');

INSERT INTO schema_migrations (version) VALUES ('20150510191309');

INSERT INTO schema_migrations (version) VALUES ('20150510225613');

INSERT INTO schema_migrations (version) VALUES ('20150601084858');

INSERT INTO schema_migrations (version) VALUES ('20150601112341');

INSERT INTO schema_migrations (version) VALUES ('20150601115552');

INSERT INTO schema_migrations (version) VALUES ('20150601124951');

INSERT INTO schema_migrations (version) VALUES ('20150604084837');

INSERT INTO schema_migrations (version) VALUES ('20150604091125');

INSERT INTO schema_migrations (version) VALUES ('20150608193406');

INSERT INTO schema_migrations (version) VALUES ('20150609204637');

INSERT INTO schema_migrations (version) VALUES ('20150610225144');

INSERT INTO schema_migrations (version) VALUES ('20150612101856');

INSERT INTO schema_migrations (version) VALUES ('20150614083605');

INSERT INTO schema_migrations (version) VALUES ('20150614161710');

INSERT INTO schema_migrations (version) VALUES ('20150614222520');

INSERT INTO schema_migrations (version) VALUES ('20150617154449');

INSERT INTO schema_migrations (version) VALUES ('20150617155527');

INSERT INTO schema_migrations (version) VALUES ('20150617160715');

INSERT INTO schema_migrations (version) VALUES ('20150619073049');

INSERT INTO schema_migrations (version) VALUES ('20150619082224');

INSERT INTO schema_migrations (version) VALUES ('20150619095507');

INSERT INTO schema_migrations (version) VALUES ('20150620132010');

INSERT INTO schema_migrations (version) VALUES ('20150622102420');

INSERT INTO schema_migrations (version) VALUES ('20150622152322');

INSERT INTO schema_migrations (version) VALUES ('20150624131916');

INSERT INTO schema_migrations (version) VALUES ('20150624151720');

INSERT INTO schema_migrations (version) VALUES ('20150625122417');

INSERT INTO schema_migrations (version) VALUES ('20150704105413');

INSERT INTO schema_migrations (version) VALUES ('20150704121413');

INSERT INTO schema_migrations (version) VALUES ('20150705080238');

INSERT INTO schema_migrations (version) VALUES ('20150705081655');

INSERT INTO schema_migrations (version) VALUES ('20150705082548');

INSERT INTO schema_migrations (version) VALUES ('20150705090122');

INSERT INTO schema_migrations (version) VALUES ('20150705100446');

INSERT INTO schema_migrations (version) VALUES ('20150705131138');

INSERT INTO schema_migrations (version) VALUES ('20150705151802');

INSERT INTO schema_migrations (version) VALUES ('20150706141209');

INSERT INTO schema_migrations (version) VALUES ('20150706180239');

INSERT INTO schema_migrations (version) VALUES ('20150707120734');

INSERT INTO schema_migrations (version) VALUES ('20150707133146');

INSERT INTO schema_migrations (version) VALUES ('20150707150018');

INSERT INTO schema_migrations (version) VALUES ('20150707151424');

INSERT INTO schema_migrations (version) VALUES ('20150718112555');

INSERT INTO schema_migrations (version) VALUES ('20150718114231');

INSERT INTO schema_migrations (version) VALUES ('20150718185029');

INSERT INTO schema_migrations (version) VALUES ('20150718185429');

INSERT INTO schema_migrations (version) VALUES ('20150718185458');

INSERT INTO schema_migrations (version) VALUES ('20150722090257');

INSERT INTO schema_migrations (version) VALUES ('20150722100625');

INSERT INTO schema_migrations (version) VALUES ('20150722115335');

INSERT INTO schema_migrations (version) VALUES ('20150723144812');

INSERT INTO schema_migrations (version) VALUES ('20150811164658');

INSERT INTO schema_migrations (version) VALUES ('20150812120123');

INSERT INTO schema_migrations (version) VALUES ('20150819210212');

INSERT INTO schema_migrations (version) VALUES ('20150820180251');

INSERT INTO schema_migrations (version) VALUES ('20150823224903');

INSERT INTO schema_migrations (version) VALUES ('20150908105548');

INSERT INTO schema_migrations (version) VALUES ('20150918150534');

INSERT INTO schema_migrations (version) VALUES ('20150930151648');

INSERT INTO schema_migrations (version) VALUES ('20151008103748');

INSERT INTO schema_migrations (version) VALUES ('20151008180419');

INSERT INTO schema_migrations (version) VALUES ('20151019091723');

INSERT INTO schema_migrations (version) VALUES ('20151020202426');

INSERT INTO schema_migrations (version) VALUES ('20151111233529');

INSERT INTO schema_migrations (version) VALUES ('20151113131542');

INSERT INTO schema_migrations (version) VALUES ('20151113142155');

INSERT INTO schema_migrations (version) VALUES ('20151113142446');

INSERT INTO schema_migrations (version) VALUES ('20151113170318');

INSERT INTO schema_migrations (version) VALUES ('20151127122655');

INSERT INTO schema_migrations (version) VALUES ('20151129132418');

INSERT INTO schema_migrations (version) VALUES ('20151204183223');

INSERT INTO schema_migrations (version) VALUES ('20160106144822');

INSERT INTO schema_migrations (version) VALUES ('20160128224715');

INSERT INTO schema_migrations (version) VALUES ('20160214143452');

