/*
Подсчитать, насколько средняя продолжительность звонков абонентов отличается от средней по тарифу, 
на который этот абонент подключен, и общей средней продолжительности звонка. 
Сделать два варианта – с использованием аналитической функции и без использования.
*/

CREATE OR REPLACE FUNCTION average_duration_of_all_calls() 
RETURNS numeric AS 
$$
	SELECT AVG(dur)
	FROM public.f
$$ LANGUAGE SQL;

----- FIRST ANSWER ↓
SELECT ks,
	   average_call_duration_by_ks.avg_dur - average_call_duration_by_tariff.avg_dur AS diff_between_tariff,
	   average_call_duration_by_ks.avg_dur - average_duration_of_all_calls() AS diff_between_all_duration
FROM 
(
	SELECT s.kt, AVG(dur) AS avg_dur
	FROM public.f
	LEFT JOIN public.s
	ON (f.ks = s.ks)
	GROUP BY s.kt
) AS average_call_duration_by_tariff
LEFT JOIN 
(
	SELECT s.kt, s.ks, AVG(dur) AS avg_dur
	FROM public.f
	LEFT JOIN public.s
	ON (f.ks = s.ks)
	LEFT JOIN public.t
	ON (s.kt = t.kt)
	GROUP BY s.ks, s.kt
) AS average_call_duration_by_ks -- average duration by user calls
ON (average_call_duration_by_tariff.kt = average_call_duration_by_ks.kt);
----- FIRST ANSWER ↑

----- SECOND ANSWER ↓
SELECT DISTINCT s.ks, AVG(dur) OVER (PARTITION BY s.ks) - AVG(dur) OVER (PARTITION BY t.kt) AS diff_between_tariff,
				AVG(dur) OVER (PARTITION BY s.ks) - average_duration_of_all_calls()  AS diff_between_all_duration
FROM public.f
LEFT JOIN public.s
ON (f.ks = s.ks)
LEFT JOIN public.t
ON (s.kt = t.kt);
----- SECOND ANSWER ↑

-- average call duration by user
SELECT s.ks, AVG(dur)
FROM public.f
LEFT JOIN public.s
ON (f.ks = s.ks)
LEFT JOIN public.t
ON (s.kt = t.kt)
GROUP BY s.ks;
-- ks 1001: 12.2
-- ks 1002: 112.0
-- ks 1003: 12.0
-- ks 1004 20.0
-- ks 1005: 30.75
-- ks 1006: 10.0
-- ks 1007: 21.0

-- average call duration by tariff
SELECT AVG(dur)
FROM public.f
LEFT JOIN public.s
ON (f.ks = s.ks)
LEFT JOIN public.t
ON (s.kt = t.kt)
GROUP BY t.kt;
-- TARIFF 1: 61/5 = 12,2 
-- TARIFF 2: 616/9=68,4
-- TARIFF 3: 164/7=23,42

-- average call duration of all ks
SELECT AVG(dur)
FROM public.f