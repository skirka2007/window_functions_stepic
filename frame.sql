/* rows/group/range is based on the same value, asit was in order by.
ROWS BETWEEN frame_start AND frame_end
GROUPS BETWEEN frame_start AND frame_end - isn't supported by mysql
RANGE BETWEEN frame_start AND frame_end 

(frame_start) could be:
* current row 
* N preceding 
* N following 
* unbounded preceding 

(frame_end) could be:
* current row 
* N preceding 
* N following 
* unbounded following 

RANGE BETWEEN unbounded preceding AND current row - by default
*/

SELECT id, name, department, salary,
    FIRST_VALUE(salary) OVER (partition by department
                              order by department, salary
                              rows between 1 preceding and current row) AS prev_salary,
    MAX(salary) OVER (partition by department) AS max_salary
FROM employees
ORDER BY department, salary, id;


SELECT id, name, salary,
	COUNT(*) OVER w AS ge_cnt
FROM employees 
WINDOW w AS (ORDER BY salary
			groups between current row and unbounded following)
ORDER by salary, id;


SELECT id, name, salary,
	MAX(salary) OVER w AS next_salary
FROM employees 
WINDOW w AS (ORDER BY salary
			groups between 1 following and 1 following)
ORDER by salary, id;


SELECT id, name, salary,
    COUNT(*) OVER w AS p10_cnt
FROM employees
WINDOW w AS (ORDER BY salary
             RANGE BETWEEN CURRENT ROW AND 10 FOLLOWING)
ORDER BY salary, id


SELECT id, name, salary,
    MAX(salary) OVER w AS lower_sal
FROM employees
WINDOW w AS (ORDER BY salary
             RANGE BETWEEN 30 PRECEDING AND 10 PRECEDING)
ORDER BY salary, id