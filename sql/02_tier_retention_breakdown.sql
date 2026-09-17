USE saas_analytics;

WITH cohort_setup AS (
    SELECT 
        user_id,
        tier,
        mrr,
        DATE_FORMAT(signup_date, '%Y-%m-01') AS cohort_month,
        DATE_FORMAT(activity_date, '%Y-%m-01') AS activity_month
    FROM saas_churn_data
),
cohort_index AS (
    SELECT 
        user_id,
        tier,
        mrr,
        cohort_month,
        activity_month,
        TIMESTAMPDIFF(MONTH, STR_TO_DATE(cohort_month, '%Y-%m-%d'), STR_TO_DATE(activity_month, '%Y-%m-%d')) AS month_number
    FROM cohort_setup
),
tier_sizes AS (
    SELECT 
        tier,
        COUNT(DISTINCT user_id) AS total_tier_users
    FROM cohort_index
    WHERE month_number = 0
    GROUP BY tier
)
SELECT 
    ci.tier,
    ci.month_number,
    COUNT(DISTINCT ci.user_id) AS active_users,
    ts.total_tier_users,
    ROUND((COUNT(DISTINCT ci.user_id) / ts.total_tier_users) * 100, 2) AS tier_retention_rate,
    SUM(ci.mrr) AS tier_mrr
FROM cohort_index ci
JOIN tier_sizes ts ON ci.tier = ts.tier
GROUP BY ci.tier, ci.month_number, ts.total_tier_users
ORDER BY ci.tier, ci.month_number;
