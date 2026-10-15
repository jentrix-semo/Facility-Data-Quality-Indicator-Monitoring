-- Drop first so the script can be re-run safely
DROP VIEW IF EXISTS vw_subcounty_summary;
DROP VIEW IF EXISTS vw_facility_latest_visit;

-- Sub-county summary (feeds the Page 1 sub-county comparison)
CREATE VIEW vw_subcounty_summary AS
SELECT
    sub_county,
    ROUND(AVG(quality_score)::numeric, 2) AS avg_quality_score,
    SUM(discrepancy_count) AS total_discrepancies,
    SUM(CASE WHEN reporting_status != 'On time' THEN 1 ELSE 0 END) AS late_submissions,
    COUNT(*) AS n_visits
FROM facility_visits
GROUP BY sub_county
ORDER BY avg_quality_score;

-- Most recent visit per facility (feeds the Page 1 map)
CREATE VIEW vw_facility_latest_visit AS
SELECT DISTINCT ON (facility_name) *
FROM facility_visits
ORDER BY facility_name, visit_date DESC;

---Confirming the views are created
SELECT * FROM vw_subcounty_summary;
SELECT COUNT(*) FROM vw_facility_latest_visit;