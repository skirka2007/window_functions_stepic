WITH total_rev AS
	(SELECT year, month, SUM(revenue) AS revenue
	FROM sales 
	WHERE year=2020 AND plan="gold"
	GROUP BY year, month)
	
SELECT year, month, revenue,
	LAG(revenue, 1) OVER w AS prev,
	ROUND(revenue*100/LAG(revenue, 1) OVER w) AS perc
FROM total_rev
WINDOW w AS (ORDER BY month)
ORDER BY month;



SELECT plan, year, month, revenue,
	SUM(revenue) OVER w AS total
FROM sales 
WHERE year=2020 AND month < 4
WINDOW w AS (PARTITION BY plan
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
ORDER BY plan, month;



SELECT year, month, revenue,
	ROUND(AVG(revenue) OVER w) AS avg3m
FROM sales 
WHERE year=2020 AND plan='platinum' 
WINDOW w AS (ORDER BY `month`
			ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
ORDER BY month;



SELECT year, month, revenue, 
	LAST_VALUE (revenue) OVER w AS december,
	ROUND(revenue*100/LAST_VALUE (revenue) OVER w) AS perc
FROM sales 
WHERE plan='silver'
WINDOW w AS (PARTITION BY `year`
			ORDER BY month
			rows between unbounded preceding and unbounded following)
ORDER BY year, month;



WITH total_rev AS 
	(SELECT year, plan, SUM(revenue) AS revenue
	FROM sales s 
	GROUP BY year, plan)

SELECT year, plan, revenue,
	SUM(revenue) OVER w AS total,
	ROUND(revenue*100/SUM(revenue) OVER w) AS perc
FROM total_rev
WINDOW w AS (PARTITION BY year
			rows between unbounded preceding and unbounded following)
ORDER BY year, plan;



WITH total_rev AS
	(SELECT year, month, SUM(revenue) AS revenue
	FROM sales s 
	WHERE year=2020
	GROUP BY month)

SELECT year, month, revenue,
	NTILE (3) OVER w AS tile
FROM total_rev
WINDOW w AS (ORDER BY revenue DESC)
ORDER BY revenue DESC;



WITH total_rev AS 
	(SELECT year, quarter, SUM(revenue) AS revenue
	FROM sales  
	GROUP BY year, quarter)

SELECT *
FROM
	(SELECT year, quarter, revenue,
		LAG(revenue, 4) OVER w AS prev,
		ROUND(revenue*100/LAG(revenue, 4) OVER w) AS perc
	FROM total_rev
	WINDOW w AS (ORDER BY year, quarter)
	ORDER BY year, quarter) AS all_quart
WHERE year=2020;



WITH silver_q AS
	(SELECT year, month,
		RANK() OVER (ORDER BY quantity DESC) AS silver
	FROM sales
	WHERE plan='silver' AND year=2020),

gold_q AS
	(SELECT year, month,
		RANK() OVER (ORDER BY quantity DESC) AS gold
	FROM sales
	WHERE plan='gold' AND year=2020),

platinum_q AS
	(SELECT year, month,
		RANK() OVER (ORDER BY quantity DESC) AS platinum
	FROM sales
	WHERE plan='platinum' AND year=2020)

SELECT silver_q.*, gold_q.gold, platinum_q.platinum
FROM silver_q
JOIN gold_q 
	ON silver_q.year=gold_q.year AND silver_q.month=gold_q.month
JOIN platinum_q
	ON silver_q.year=platinum_q.year AND silver_q.month=platinum_q.month
ORDER BY month;