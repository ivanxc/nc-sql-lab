INSERT INTO f(idcall, ks, dt, dur) VALUES
(130000, 1001, '2022-01-01 10:00:00+03', 30),
(130001, 1001, '2022-01-01 11:00:00+03', 2),
(130002, 1001, '2022-01-01 11:10:00+03', 40), -- prev dur < 5 AND current dur > 30
(130003, 1001, '2022-01-01 11:55:00+03', 40),
(130004, 1001, '2022-01-01 13:00:00+03', 5),
(130005, 1001, '2022-01-01 13:00:00+03', 50),
(130006, 1001, '2022-01-01 14:00:00+03', 1),
(130007, 1001, '2022-01-01 14:05:00+03', 2),
(130008, 1001, '2022-01-01 14:10:00+03', 3),
(130009, 1001, '2022-01-01 14:15:00+03', 4),
(130010, 1001, '2022-01-01 14:20:00+03', 60), -- prev dur < 5 AND current dur > 30
(130011, 1001, '2022-01-01 16:00:00+03', 2),
(130012, 1002, '2022-01-01 10:00:00+03', 1),
(130013, 1002, '2022-01-01 12:00:00+03', 25),
(130014, 1002, '2022-01-01 13:00:00+03', 2),
(130015, 1002, '2022-01-01 14:00:00+03', 31), -- prev dur < 5 AND current dur > 30
(130016, 1002, '2022-01-01 16:00:00+03', 1),
(130017, 1003, '2022-01-01 10:00:00+03', 40),
(130018, 1003, '2022-01-01 11:00:00+03', 2),
(130019, 1004, '2022-01-01 10:00:00+03', 40),
(130020, 1004, '2022-01-01 11:00:00+03', 2),
(130021, 1005, '2022-01-01 10:00:00+03', 40),
(130022, 1005, '2022-01-01 11:00:00+03', 2),
(130023, 1005, '2022-01-01 12:00:00+03', 40), -- prev dur < 5 AND current dur > 30
(130024, 1005, '2022-01-01 13:00:00+03', 40),
(130025, 1005, '2022-01-01 14:00:00+03', 30),
(130026, 1005, '2022-01-01 15:00:00+03', 40),
(130027, 1006, '2022-01-01 10:00:00+03', 35),
(130028, 1007, '2022-01-01 10:00:00+03', 35),
(130029, 1100, '2022-01-01 10:00:00+03', 35),
(130030, 1100, '2022-01-01 11:00:00+03', 4);

-- Show calls, where prev call duration < 5 and current duration > 30
SELECT idcall, ks, dt, dur 
FROM 
(
	SELECT *, LAG(dur, 1) OVER ( PARTITION BY ks ORDER BY dt) as prev_call_dur
	FROM f
) as calls
WHERE dur > 30 AND prev_call_dur < 5;

/* Output
 idcall |  ks  |           dt           | dur
--------+------+------------------------+-----
 130002 | 1001 | 2022-01-01 11:10:00+03 |  40
 130010 | 1001 | 2022-01-01 14:20:00+03 |  60
 130015 | 1002 | 2022-01-01 14:00:00+03 |  31
 130023 | 1005 | 2022-01-01 12:00:00+03 |  40
*/