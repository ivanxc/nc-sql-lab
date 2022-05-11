SELECT * FROM public.s;

-- duplicates of initial data
INSERT INTO public.s(ks, sfn, sln, kt, gender, h, salary) VALUES
(10020, 'Ian', 'Holm', 2, 'm', 169, 1200.00),
(10030, 'Milla', 'Jovovich', 2, 'f', 176, 2100.00),
(10040, 'Chris', 'Tucker', 2, 'm', 190, 900.00),
(10050, 'Luke', 'Perry', 3, 'm', 167, 950.00),
(10060, 'Brion', 'James', 3, 'm', 200, 1100.00),
(10070, 'Lee', 'Evans', 3, 'm', 178, 500.00),
(10010, 'Gary', 'Oldman', 1, 'm', 167, 2500.00),
(12340, 'Ivan', 'Ivanov', 3, 'm', 199, 501.00),
(33330, 'Petr', 'Petrov', 3, 'm', 170, 1200.00),
(22220, 'Steven', 'King', 3, 'm', 193, 4999.00),
(22221, 'Steven', 'King', 3, 'm', 193, 4999.00),
(11000, 'Grette', 'Tundberg', 1, 'f', 149, 3899.00),
(11001, 'Grette', 'Tundberg', 1, 'f', 149, 3899.00),
(11002, 'Grette', 'Tundberg', 1, 'f', 149, 3899.00);

-- new data, no duplicates
INSERT INTO public.s(ks, sfn, sln, kt, gender, h, salary) VALUES
(4000, 'Ivan', 'Ivanov', 3, 'm', 170, 600.00),
(4001, 'Ivan', 'Ivanov', 3, 'm', 170, 700.00),
(4002, 'Alyona', 'Svetikova', 2, 'f', 160, 650.00),
(4003, 'Alyona', 'Sergeeva', 1, 'f', 166, 1200.00),
(4004, 'Oleg', 'Tinkov', 3, 'm', 190, 20000.00),
(4005, 'Oleg', 'Valeev', 1, 'm', 184, 500.00),
(4006, 'Semen', 'Moiseev', 1, 'm', 175, 1000.00),
(4007, 'Ilya', 'Moiseev', 1, 'm', 175, 1000.00),
(4008, 'Elena', 'Moiseeva', 1, 'f', 175, 1000.00),
(4009, 'Elena', 'Evans', 2, 'f', 167, 800.00),
(4010, 'Elena', 'Evans', 2, 'f', 163, 800.00),
(4011, 'Elena', 'Evans', 3, 'f', 163, 800.00),
(4012, 'Timur', 'Nurmagomedov', 2, 'm', 161, 1200.00),
(4013, 'Hasbulla', 'Nurmagomedov', 2, 'm', 161, 1200.00),
(4014, 'Nikita', 'Memaev', 2, 'm', 170, 2100.00);

-- duplicates of new data
INSERT INTO public.s(ks, sfn, sln, kt, gender, h, salary) VALUES
(40000, 'Ivan', 'Ivanov', 3, 'm', 170, 600.00),
(40020, 'Alyona', 'Svetikova', 2, 'f', 160, 650.00),
(40070, 'Ilya', 'Moiseev', 1, 'm', 175, 1000.00),
(40100, 'Elena', 'Evans', 2, 'f', 163, 800.00),
(40130, 'Hasbulla', 'Nurmagomedov', 2, 'm', 161, 1200.00);

-- There is 26 original rows and  in customers (s) table and 19 duplicates

-- Show duplicates
SELECT ks, origin.sfn, origin.sln, origin.kt, 
	   origin.gender, origin.h, origin.salary
FROM public.s AS origin
INNER JOIN
	(
	SELECT sfn, sln, kt, gender, h, salary, COUNT(*)
	FROM public.s
	GROUP BY sfn, sln, kt, gender, h, salary
	HAVING COUNT(*) > 1
	) AS duplicates
ON
	(
	origin.sfn = duplicates.sfn AND
	origin.sln = duplicates.sln AND
	origin.kt = duplicates.kt AND
	origin.gender = duplicates.gender AND
	origin.h = duplicates.h AND
	origin.salary = duplicates.salary
	)
ORDER BY sfn, sln, kt, gender, h, salary;
-- There are 35 rows in result:
-- 14 duplicates of origin +
-- 11 rows, which was duplicated +
-- 5 duplicates of new data +
-- 5 rows, which was duplicated 

/* Output:
  ks   |   sfn    |     sln      | kt | gender |  h  | salary
-------+----------+--------------+----+--------+-----+---------
 40020 | Alyona   | Svetikova    |  2 | f      | 160 |  650.00
  4002 | Alyona   | Svetikova    |  2 | f      | 160 |  650.00
 10060 | Brion    | James        |  3 | m      | 200 | 1100.00
  1006 | Brion    | James        |  3 | m      | 200 | 1100.00
 10040 | Chris    | Tucker       |  2 | m      | 190 |  900.00
  1004 | Chris    | Tucker       |  2 | m      | 190 |  900.00
  4010 | Elena    | Evans        |  2 | f      | 163 |  800.00
 40100 | Elena    | Evans        |  2 | f      | 163 |  800.00
  1001 | Gary     | Oldman       |  1 | m      | 167 | 2500.00
 10010 | Gary     | Oldman       |  1 | m      | 167 | 2500.00
  1100 | Grette   | Tundberg     |  1 | f      | 149 | 3899.00
 11000 | Grette   | Tundberg     |  1 | f      | 149 | 3899.00
 11002 | Grette   | Tundberg     |  1 | f      | 149 | 3899.00
 11001 | Grette   | Tundberg     |  1 | f      | 149 | 3899.00
 40130 | Hasbulla | Nurmagomedov |  2 | m      | 161 | 1200.00
  4013 | Hasbulla | Nurmagomedov |  2 | m      | 161 | 1200.00
  1002 | Ian      | Holm         |  2 | m      | 169 | 1200.00
 10020 | Ian      | Holm         |  2 | m      | 169 | 1200.00
  4007 | Ilya     | Moiseev      |  1 | m      | 175 | 1000.00
 40070 | Ilya     | Moiseev      |  1 | m      | 175 | 1000.00
  4000 | Ivan     | Ivanov       |  3 | m      | 170 |  600.00
 40000 | Ivan     | Ivanov       |  3 | m      | 170 |  600.00
 12340 | Ivan     | Ivanov       |  3 | m      | 199 |  501.00
  1234 | Ivan     | Ivanov       |  3 | m      | 199 |  501.00
 10070 | Lee      | Evans        |  3 | m      | 178 |  500.00
  1007 | Lee      | Evans        |  3 | m      | 178 |  500.00
  1005 | Luke     | Perry        |  3 | m      | 167 |  950.00
 10050 | Luke     | Perry        |  3 | m      | 167 |  950.00
  1003 | Milla    | Jovovich     |  2 | f      | 176 | 2100.00
 10030 | Milla    | Jovovich     |  2 | f      | 176 | 2100.00
  3333 | Petr     | Petrov       |  3 | m      | 170 | 1200.00
 33330 | Petr     | Petrov       |  3 | m      | 170 | 1200.00
 22220 | Steven   | King         |  3 | m      | 193 | 4999.00
 22221 | Steven   | King         |  3 | m      | 193 | 4999.00
  2222 | Steven   | King         |  3 | m      | 193 | 4999.00
*/