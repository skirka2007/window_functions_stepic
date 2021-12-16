#rows between X preceding and Y following, unbounded (instead of X/Y) - boundary of the SECTION, 
#current row (instead of X preceding/ Y...) is also possible
#frame never goes outside the SECTION 
# default frame is rows between unbounded preceding and current row (and is applicable if we use order by in the window function)

SELECT year, month, income,
    ROUND(AVG(income) OVER w) AS roll_avg
FROM expenses
WINDOW w AS (ORDER BY year, month
             rows between 1 preceding and current row)
ORDER BY year, month;

SELECT id, name, department, salary,
    SUM(salary) OVER w AS total
FROM employees
WINDOW w AS (PARTITION BY department
             rows between unbounded preceding and current row)
ORDER BY department, salary, id;




