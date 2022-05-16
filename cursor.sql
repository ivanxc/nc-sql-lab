-- 4. Таблица абонентов содержит их зарплату. При помощи процедуры, содержащей курсор,
--    откорректировать зарплату: если меньше 50 – установить 50.

/* SELECT * FROM s; ↓
  ks  |  sfn   |   sln    | kt | gender |  h  | salary
------+--------+----------+----+--------+-----+---------
 1002 | Ian    | Holm     |  2 | m      | 169 | 1200.00
 1003 | Milla  | Jovovich |  2 | f      | 176 | 2100.00
 1004 | Chris  | Tucker   |  2 | m      | 190 |  900.00
 1005 | Luke   | Perry    |  3 | m      | 167 |  950.00
 1006 | Brion  | James    |  3 | m      | 200 | 1100.00
 1007 | Lee    | Evans    |  3 | m      | 178 |  500.00
 1001 | Gary   | Oldman   |  1 | m      | 167 | 2500.00
 1234 | Ivan   | Ivanov   |  3 | m      | 199 |  501.00
 3333 | Petr   | Petrov   |  3 | m      | 170 | 1200.00
 2222 | Steven | King     |  3 | m      | 193 | 4999.00
 1100 | Grette | Tundberg |  1 | f      | 149 | 3899.00
*/

UPDATE s
SET salary = 30
WHERE ks % 2 = 1;

/* SELECT * FROM s; ↓
  ks  |  sfn   |   sln    | kt | gender |  h  | salary
------+--------+----------+----+--------+-----+---------
 1002 | Ian    | Holm     |  2 | m      | 169 | 1200.00
 1004 | Chris  | Tucker   |  2 | m      | 190 |  900.00
 1006 | Brion  | James    |  3 | m      | 200 | 1100.00
 1234 | Ivan   | Ivanov   |  3 | m      | 199 |  501.00
 2222 | Steven | King     |  3 | m      | 193 | 4999.00
 1100 | Grette | Tundberg |  1 | f      | 149 | 3899.00
 1003 | Milla  | Jovovich |  2 | f      | 176 |   30.00
 1005 | Luke   | Perry    |  3 | m      | 167 |   30.00
 1007 | Lee    | Evans    |  3 | m      | 178 |   30.00
 1001 | Gary   | Oldman   |  1 | m      | 167 |   30.00
 3333 | Petr   | Petrov   |  3 | m      | 170 |   30.00
*/

-- TASK 4 SOLUTION ↓
CREATE OR REPLACE PROCEDURE increase_salary_to_minimum(IN minimum int) AS 
$$
DECLARE 
	r record;
	low_salary_curs CURSOR FOR SELECT * FROM s WHERE salary < minimum;
BEGIN
	OPEN low_salary_curs;
	LOOP
		FETCH low_salary_curs INTO r;
		EXIT WHEN NOT FOUND;
		UPDATE s
		SET salary = minimum
		WHERE CURRENT OF low_salary_curs;
	END LOOP;
	CLOSE low_salary_curs;
	END;
$$ LANGUAGE plpgsql;

CALL increase_salary_to_minimum(50);
-- TASK 4 SOLUTION ↑

/* Output:
  ks  |  sfn   |   sln    | kt | gender |  h  | salary
------+--------+----------+----+--------+-----+---------
 1002 | Ian    | Holm     |  2 | m      | 169 | 1200.00
 1004 | Chris  | Tucker   |  2 | m      | 190 |  900.00
 1006 | Brion  | James    |  3 | m      | 200 | 1100.00
 1234 | Ivan   | Ivanov   |  3 | m      | 199 |  501.00
 2222 | Steven | King     |  3 | m      | 193 | 4999.00
 1100 | Grette | Tundberg |  1 | f      | 149 | 3899.00
 1003 | Milla  | Jovovich |  2 | f      | 176 |   50.00
 1005 | Luke   | Perry    |  3 | m      | 167 |   50.00
 1007 | Lee    | Evans    |  3 | m      | 178 |   50.00
 1001 | Gary   | Oldman   |  1 | m      | 167 |   50.00
 3333 | Petr   | Petrov   |  3 | m      | 170 |   50.00
*/