#row_number() - nuber of row according to the order in the window	
#dense_rank() - rank without missing places (if 2 items hold the 1'st place, the next item will hold the 2'nd place)
#rank() - rank with missing places (if 2 items hold the 1'st place, the next item will hold the 3'd place)
#ntile(n) - create n groups according to the order in the window	

SELECT 
	DENSE_RANK () OVER w AS rank_place,
	name,
	department,
	salary
FROM employees 
WINDOW w AS (ORDER BY salary DESC)
ORDER BY rank_place, id;


SELECT DENSE_RANK () OVER w AS rank_dep,
	name, department, salary
FROM employees 
WINDOW w AS (PARTITION BY department
			ORDER BY salary DESC)
ORDER BY department, salary DESC;


SELECT NTILE (3) OVER w AS salary_group,
	name, department, salary
FROM employees 
WINDOW w AS (ORDER BY salary DESC)
ORDER BY salary DESC;


SELECT NTILE(2) OVER w AS tile,
    name, city, salary
FROM employees
WINDOW w AS (PARTITION BY city
             ORDER BY salary)
ORDER BY city, tile;


WITH cte AS (
SELECT DENSE_RANK() OVER w AS rating,
	id, name, department, salary
FROM employees 
WINDOW w AS (PARTITION BY department
			ORDER BY salary DESC))
SELECT id, name, department, salary
FROM cte
WHERE rating=1;


WITH cte AS (
SELECT ROW_NUMBER () OVER w AS rating,
	id, name, department, salary
FROM employees 
WINDOW w AS (PARTITION BY department
			ORDER BY salary DESC, name))
SELECT *
FROM cte
WHERE rating=2;