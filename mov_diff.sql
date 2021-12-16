#lag(x,y) - previous value of x column with lag y
#lead(x,y) - next value of x column with lag y

#NB! It works within the frame (from the first value till the last item in block with the same meaning)
# It can be fixed using "rows between unbounded preceding and unbounded following"
#first_value(x) - the first value of x in the block
#last_value(x) - the last value of x in the block
#nth_value(x, n) - the n value of x in the block


SELECT name, department, salary,
	ROUND((salary - LAG(salary, 1) OVER w)/salary * 100, 0) AS diff
FROM employees 
WINDOW w AS (order by salary);


SELECT name, department, salary,
	FIRST_VALUE(salary) OVER w AS low,
	LAST_VALUE(salary) OVER w AS high
FROM employees 
WINDOW w AS (PARTITION BY department
			ORDER BY salary 
			rows between unbounded preceding and unbounded following);