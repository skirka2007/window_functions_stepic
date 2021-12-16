/*
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
