#min(value)	
#max(value)	
#count(value) != null
#avg(value)	
#sum(value)	
#group_concat(value, separator)	concate values with the separator

SELECT name, city, salary,
    SUM(salary) OVER w AS fund,
    ROUND(salary*100/SUM(salary) OVER w) AS perc
FROM employees
WINDOW w AS (PARTITION BY city)
ORDER BY city, salary, id;


SELECT name, department, salary,
    COUNT(id) OVER w AS emp_cnt,
    ROUND(AVG(salary) OVER w) AS sal_avg,
    ROUND((salary - AVG(salary) OVER w)*100/AVG(salary) OVER w) AS diff
FROM employees
WINDOW w AS (PARTITION BY department)
ORDER BY department, salary, id;

select
  city,
  department,
  sum(salary) as dep_salary,
  sum(sum(salary)) over (partition by city) as x, #returns sum of all salaries in the city
  sum(sum(salary)) over () as y #returns sum of all salaries in the table
from employees
group by city, department
order by city, department;