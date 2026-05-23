-- ============================================================
-- STEP 2A — MySQL Workbench: Create Schema
-- File: step2a_create_schema.sql
-- How to run: Open MySQL Workbench -> File -> Open SQL Script
--             -> select this file -> click the lightning bolt Run All
-- ============================================================
 
CREATE DATABASE IF NOT EXISTS netflix_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
 
USE netflix_db;
 
-- Drop existing tables (safe to re-run)
DROP TABLE IF EXISTS netflix_countries;
DROP TABLE IF EXISTS netflix_genres;
DROP TABLE IF EXISTS netflix_titles;
 
-- ── TABLE 1: netflix_titles (main table) ─────────────────────
CREATE TABLE netflix_titles (
    show_id              VARCHAR(20)   PRIMARY KEY,
    type                 VARCHAR(10)   NOT NULL,
    title                VARCHAR(300)  NOT NULL,
    director             VARCHAR(500)  DEFAULT 'Unknown',
    cast                 TEXT,
    country              VARCHAR(300)  DEFAULT 'Unknown',
    date_added           DATE,
    year_added           INT,
    month_added          INT,
    month_name           VARCHAR(20),
    release_year         INT,
    rating               VARCHAR(15),
    audience_group       VARCHAR(20),
    duration             INT,
    duration_minutes     FLOAT,
    duration_seasons     FLOAT,
    genres               VARCHAR(500),
    description          TEXT,
    content_age_at_add   INT,
    INDEX idx_type         (type),
    INDEX idx_year_added   (year_added),
    INDEX idx_release_year (release_year),
    INDEX idx_rating       (rating),
    INDEX idx_audience     (audience_group)
);
 
-- ── TABLE 2: netflix_genres (one row per genre per title) ─────
CREATE TABLE netflix_genres (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    show_id        VARCHAR(20)  NOT NULL,
    type           VARCHAR(10),
    title          VARCHAR(300),
    release_year   INT,
    year_added     INT,
    rating         VARCHAR(15),
    audience_group VARCHAR(20),
    genre          VARCHAR(100) NOT NULL,
    INDEX idx_genre      (genre),
    INDEX idx_show_id    (show_id),
    INDEX idx_genre_year (genre, year_added),
    FOREIGN KEY (show_id) REFERENCES netflix_titles(show_id) ON DELETE CASCADE
);
 
-- ── TABLE 3: netflix_countries (one row per country per title) ─
CREATE TABLE netflix_countries (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    show_id        VARCHAR(20)  NOT NULL,
    type           VARCHAR(10),
    title          VARCHAR(300),
    release_year   INT,
    year_added     INT,
    rating         VARCHAR(15),
    country_single VARCHAR(100) NOT NULL,
    INDEX idx_country (country_single),
    INDEX idx_show_id (show_id),
    FOREIGN KEY (show_id) REFERENCES netflix_titles(show_id) ON DELETE CASCADE
);
 
SELECT 'Schema created successfully! Now run step2b_load_mysql.py' AS status;


