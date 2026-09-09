-- Hospital Appointment No Show Analysis

DROP TABLE IF EXISTS appointments;

CREATE TABLE appointments (
    appointment_id   INTEGER PRIMARY KEY,
    gender           CHAR(1) CHECK (gender IN ('M','F')),
    scheduled_day    DATE NOT NULL,
    appointment_day  DATE NOT NULL,
    age              SMALLINT NOT NULL CHECK (age >= 0),
    sms_received      SMALLINT CHECK (sms_received IN (0,1)),
    lead_time_days   SMALLINT GENERATED ALWAYS AS (appointment_day - scheduled_day) STORED,
    no_show          VARCHAR(3) CHECK (no_show IN ('Yes','No'))
);
 
CREATE INDEX idx_appt_noshow ON appointments(no_show);
CREATE INDEX idx_appt_sms ON appointments(sms_received);
 
SELECT * FROM appointments;
 
-- Analysis Questions
 
-- Q1. Overall no-show rate
SELECT
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN no_show='Yes' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(100.0 * SUM(CASE WHEN no_show='Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS no_show_rate_pct
FROM appointments;
 
-- Q2. No-show rate by SMS reminder
SELECT
    sms_received,
    COUNT(*) AS appointments,
    ROUND(100.0 * SUM(CASE WHEN no_show='Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS no_show_rate_pct
FROM appointments
GROUP BY sms_received;
 
-- Q3. No-show rate by waiting time bucket
SELECT
    CASE
        WHEN lead_time_days <= 3  THEN '0-3 days'
        WHEN lead_time_days <= 7  THEN '4-7 days'
        WHEN lead_time_days <= 14 THEN '8-14 days'
        ELSE '15+ days'
    END AS wait_bucket,
    CASE
        WHEN lead_time_days <= 3  THEN 1
        WHEN lead_time_days <= 7  THEN 2
        WHEN lead_time_days <= 14 THEN 3
        ELSE 4
    END AS bucket_order,
    COUNT(*) AS appointments,
    ROUND(100.0 * SUM(CASE WHEN no_show='Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS no_show_rate_pct
FROM appointments
WHERE lead_time_days IS NOT NULL
GROUP BY wait_bucket, bucket_order
ORDER BY bucket_order;
 
-- Q4. No-show rate by age group
SELECT
    CASE
        WHEN age <= 18 THEN 'Under 18'
        WHEN age <= 40 THEN '19-40'
        WHEN age <= 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    CASE
        WHEN age <= 18 THEN 1
        WHEN age <= 40 THEN 2
        WHEN age <= 60 THEN 3
        ELSE 4
    END AS age_group_order,
    COUNT(*) AS appointments,
    ROUND(100.0 * SUM(CASE WHEN no_show='Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS no_show_rate_pct
FROM appointments
GROUP BY age_group, age_group_order
ORDER BY age_group_order;
 
-- Q5. Rank patients' waiting time within their gender using a window function
SELECT
    appointment_id, gender, lead_time_days, no_show,
    RANK() OVER (PARTITION BY gender ORDER BY lead_time_days DESC, appointment_id) AS wait_rank
FROM appointments
ORDER BY gender, wait_rank
LIMIT 10;
 
-- End of Hospital Appointment No Show Analysis