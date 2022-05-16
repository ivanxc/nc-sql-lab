-- 3. Подсчитать, насколько средняя продолжительность звонков абонентов отличается от средней по тарифу, 
--    на который этот абонент подключен, и общей средней продолжительности звонка. 
--    Сделать два варианта – с использованием аналитической функции и без использования.

CREATE OR REPLACE FUNCTION average_duration_of_all_calls() 
RETURNS numeric AS 
$$
	SELECT AVG(dur)
	FROM public.f
$$ LANGUAGE SQL;

/* SELECT f.ks, f.dur, s.kt
   FROM f
   INNER JOIN s
   USING (ks); ↓
  ks  | dur | kt
------+-----+----
 1001 |  20 |  1
 1001 |  30 |  1
 1001 |   2 |  1
 1001 |   5 |  1
 1003 |  10 |  2
 1003 |  11 |  2
 1003 |  15 |  2
 1004 |  20 |  2
 1005 |   3 |  3
 1006 |  10 |  3
 1006 |  10 |  3
 1007 |  21 |  3
 1001 |   4 |  1
 1002 | 160 |  2
 1002 | 100 |  2
 1002 | 100 |  2
 1002 | 100 |  2
 1002 | 100 |  2
 1005 |  20 |  3
 1005 |  50 |  3
 1005 |  50 |  3
*/

-- TASK 3 FIRST SOLUTION ↓
SELECT ks,
	   average_call_duration_by_ks.avg_dur - average_call_duration_by_tariff.avg_dur AS diff_between_tariff,
	   average_call_duration_by_ks.avg_dur - average_duration_of_all_calls() AS diff_between_all_duration
FROM 
(
	SELECT s.kt, AVG(dur) AS avg_dur
	FROM public.f
	INNER JOIN public.s
	ON (f.ks = s.ks)
	GROUP BY s.kt
) AS average_call_duration_by_tariff -- average call duration by tariff
INNER JOIN 
(
	SELECT s.kt, s.ks, AVG(dur) AS avg_dur
	FROM public.f
	LEFT JOIN public.s
	ON (f.ks = s.ks)
	GROUP BY s.ks, s.kt
) AS average_call_duration_by_ks -- average call duration by user
ON (average_call_duration_by_tariff.kt = average_call_duration_by_ks.kt);
-- TASK 3 FIRST SOLUTION ↑

-- TASK 3 SECOND SOLUTION (WITH ANALYTICAL FUNCTION) ↓
SELECT DISTINCT s.ks, 
				AVG(dur) OVER(PARTITION BY s.ks) - AVG(dur) OVER(PARTITION BY s.kt) AS diff_between_tariff,
				AVG(dur) OVER(PARTITION BY s.ks) - average_duration_of_all_calls()  AS diff_between_all_duration
FROM public.f
INNER JOIN public.s
ON (f.ks = s.ks)
-- TASK 3 SECOND SOLUTION ↑

/* Output:
  ks  | diff_between_tariff  | diff_between_all_duration
------+----------------------+---------------------------
 1001 |   0.0000000000000000 |      -27.8476190476190476
 1002 |  43.5555555555555556 |       71.9523809523809524
 1003 | -56.4444444444444444 |      -28.0476190476190476
 1004 | -48.4444444444444444 |      -20.0476190476190476
 1005 |   7.3214285714285714 |       -9.2976190476190476
 1006 | -13.4285714285714286 |      -30.0476190476190476
 1007 |  -2.4285714285714286 |      -19.0476190476190476
*/
