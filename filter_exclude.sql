#EXCLUDE and FILTER aren't supported by mysql, but there is CASE alternative.
#EXCLUDE NO OTHERS by default
#EXCLUDE CURRENT ROW
#EXCLUDE GROUP (current row + all with the same value,mentioned in order by)
#EXCLUDE TIES (leave the current row, but exclude other with the same value)

SELECT id, name, salary,
    ROUND(AVG(salary) OVER w) AS p20_sal
FROM employees
WINDOW w AS (ORDER BY salary
            RANGE BETWEEN CURRENT ROW AND 20 FOLLOWING
            EXCLUDE CURRENT ROW)
ORDER BY salary, id


