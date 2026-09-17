SELECT COUNT(*) FROM saas_analytics.saas_churn_data;

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
    cohort_sizes AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT user_id) AS total_users
    FROM cohort_index
    WHERE month_number = 0
    GROUP BY cohort_month
),
retention_matrix AS (
    SELECT 
        ci.cohort_month,
        ci.month_number,
        COUNT(DISTINCT ci.user_id) AS active_users,
        SUM(ci.mrr) AS recurring_revenue
    FROM cohort_index ci
    GROUP BY ci.cohort_month, ci.month_number
)
SELECT 
    rm.cohort_month,
    cs.total_users,
    rm.month_number,
    rm.active_users,
    ROUND((rm.active_users / cs.total_users) * 100, 2) AS retention_rate,
    rm.recurring_revenue
FROM retention_matrix rm
JOIN cohort_sizes cs ON rm.cohort_month = cs.cohort_month
ORDER BY rm.cohort_month, rm.month_number;
