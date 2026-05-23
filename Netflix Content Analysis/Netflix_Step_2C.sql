-- ============================================================
-- STEP 2C — MySQL Workbench: Create Views for Power BI
-- File: step2c_create_views.sql
-- How to run: Open MySQL Workbench -> File -> Open SQL Script
--             -> select this file -> click lightning bolt Run All
-- Run AFTER: step2b_load_mysql.py has finished loading data
-- ============================================================
 
USE netflix_db;
 
-- ── VIEW 1: Yearly Content Additions ─────────────────────────
-- Power BI page: Content Growth (line/bar chart)
CREATE OR REPLACE VIEW v_yearly_additions AS
SELECT
    year_added,
    type,
    COUNT(*) AS title_count
FROM netflix_titles
WHERE year_added IS NOT NULL
GROUP BY year_added, type
ORDER BY year_added, type;
 
-- ── VIEW 2: Monthly Additions (for heatmap) ──────────────────
-- Power BI page: Content Growth (matrix visual / heatmap)
CREATE OR REPLACE VIEW v_monthly_additions AS
SELECT
    year_added,
    month_added,
    month_name,
    COUNT(*) AS title_count
FROM netflix_titles
WHERE year_added IS NOT NULL AND month_added IS NOT NULL
GROUP BY year_added, month_added, month_name
ORDER BY year_added, month_added;
 
-- ── VIEW 3: Genre Counts ─────────────────────────────────────
-- Power BI page: Genre Analysis (bar chart, treemap)
CREATE OR REPLACE VIEW v_genre_counts AS
SELECT
    genre,
    type,
    COUNT(*) AS title_count
FROM netflix_genres
GROUP BY genre, type
ORDER BY title_count DESC;
 
-- ── VIEW 4: Genre Trend by Year ───────────────────────────────
-- Power BI page: Genre Analysis (line chart over years)
CREATE OR REPLACE VIEW v_genre_yearly AS
SELECT
    genre,
    year_added,
    type,
    COUNT(*) AS title_count
FROM netflix_genres
WHERE year_added IS NOT NULL
GROUP BY genre, year_added, type
ORDER BY genre, year_added;
 
-- ── VIEW 5: Country Counts ────────────────────────────────────
-- Power BI page: Country Analysis (filled map + bar chart)
CREATE OR REPLACE VIEW v_country_counts AS
SELECT
    country_single AS country,
    type,
    COUNT(*) AS title_count
FROM netflix_countries
WHERE country_single <> 'Unknown'
GROUP BY country_single, type
ORDER BY title_count DESC;
 
-- ── VIEW 6: Rating Distribution ───────────────────────────────
-- Power BI page: Ratings (donut chart)
CREATE OR REPLACE VIEW v_rating_dist AS
SELECT
    rating,
    audience_group,
    type,
    COUNT(*) AS title_count
FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY rating, audience_group, type
ORDER BY title_count DESC;
 
-- ── VIEW 7: Top Directors ─────────────────────────────────────
-- Power BI page: Directors table
CREATE OR REPLACE VIEW v_top_directors AS
SELECT
    director,
    type,
    COUNT(*)         AS title_count,
    MIN(release_year) AS first_year,
    MAX(release_year) AS latest_year
FROM netflix_titles
WHERE director <> 'Unknown'
GROUP BY director, type
HAVING title_count >= 2
ORDER BY title_count DESC
LIMIT 100;
 
-- ── VIEW 8: Movie Duration by Genre ──────────────────────────
-- Power BI page: Ratings & Duration (bar chart)
CREATE OR REPLACE VIEW v_movie_duration AS
SELECT
    g.genre,
    ROUND(AVG(t.duration_minutes), 1) AS avg_duration_mins,
    MIN(t.duration_minutes)           AS min_mins,
    MAX(t.duration_minutes)           AS max_mins,
    COUNT(*)                          AS movie_count
FROM netflix_titles t
JOIN netflix_genres g ON t.show_id = g.show_id
WHERE t.type = 'Movie' AND t.duration_minutes IS NOT NULL
GROUP BY g.genre
HAVING movie_count >= 5
ORDER BY avg_duration_mins DESC;
 
-- ── VIEW 9: KPI Summary ───────────────────────────────────────
-- Power BI page: Overview (KPI cards)
CREATE OR REPLACE VIEW v_kpi_summary AS
SELECT
    COUNT(*)                                          AS total_titles,
    SUM(type = 'Movie')                               AS total_movies,
    SUM(type = 'TV Show')                             AS total_tv_shows,
    ROUND(SUM(type='Movie')*100.0/COUNT(*), 1)        AS movie_pct,
    ROUND(SUM(type='TV Show')*100.0/COUNT(*), 1)      AS tv_show_pct,
    MIN(year_added)                                   AS earliest_year,
    MAX(year_added)                                   AS latest_year,
    ROUND(AVG(CASE WHEN type='Movie' THEN duration_minutes END), 0)
                                                      AS avg_movie_mins
FROM netflix_titles;
 
-- ── VERIFY ───────────────────────────────────────────────────
SELECT 'All 9 views created!' AS view_name, 0  UNION ALL
SELECT 'v_yearly_additions', COUNT(*) FROM v_yearly_additions UNION ALL
SELECT 'v_monthly_additions', COUNT(*) FROM v_monthly_additions UNION ALL
SELECT 'v_genre_counts', COUNT(*) FROM v_genre_counts UNION ALL
SELECT 'v_genre_yearly', COUNT(*) FROM v_genre_yearly UNION ALL
SELECT 'v_country_counts', COUNT(*) FROM v_country_counts UNION ALL
SELECT 'v_rating_dist', COUNT(*) FROM v_rating_dist UNION ALL
SELECT 'v_top_directors', COUNT(*) FROM v_top_directors UNION ALL
SELECT 'v_movie_duration', COUNT(*) FROM v_movie_duration UNION ALL
SELECT 'v_kpi_summary', COUNT(*) FROM v_kpi_summary;