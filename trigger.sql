-- 5. Создать триггер журнализации изменения тарифов.

-- Table for tracking changes
CREATE TABLE t_changes
(
	operation char(1) NOT NULL,
	user_changed text NOT NULL,
	time_stamp timestamp NOT NULL,
	
	kt integer,
	nt varchar(20),
	monthfee numeric (12,2),
	monthmins integer,
	minfee numeric (12,2)
);

-- TASK 5 SOLUTION ↓
-- Trigger function
CREATE OR REPLACE FUNCTION track_changes_on_t() RETURNS TRIGGER
AS $$
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			INSERT INTO t_changes
			SELECT 'I', session_user, now(), nt.* 
			FROM new_table nt;
		ELSEIF (TG_OP = 'UPDATE') THEN
			INSERT INTO t_changes
			SELECT 'U', session_user, now(), nt.* 
			FROM new_table nt;
		ELSEIF (TG_OP = 'DELETE') THEN
			INSERT INTO t_changes
			SELECT 'D', session_user, now(), ot.* 
			FROM old_table ot;
		END IF;
		RETURN NULL;
	END
$$ LANGUAGE plpgsql;

-- Trigger on insert
CREATE TRIGGER change_t_insert
AFTER INSERT ON public.t
REFERENCING NEW TABLE as new_table
FOR EACH STATEMENT EXECUTE PROCEDURE track_changes_on_t();

-- Trigger on update
CREATE TRIGGER change_t_update
AFTER UPDATE ON public.t
REFERENCING NEW TABLE as new_table
FOR EACH STATEMENT EXECUTE PROCEDURE track_changes_on_t();

-- Trigger on delete
CREATE TRIGGER change_t_delete
AFTER DELETE ON public.t
REFERENCING OLD TABLE as old_table
FOR EACH STATEMENT EXECUTE PROCEDURE track_changes_on_t();
-- TASK 5 SOLUTION ↑

/* SELECT * FROM public.t; ↓
 kt |   nt    | monthfee | monthmins | minfee
----+---------+----------+-----------+--------
  3 | Maxi    |     0.00 |         0 |   5.00
  1 | Mini    |   400.00 |       300 |   1.00
  2 | Average |   200.00 |       150 |   3.00
*/

INSERT INTO public.t VALUES
(4, 'Pro', 100.0, 100.0, 3.5);

UPDATE public.t
SET minfee = 4
WHERE kt = 4;

DELETE FROM public.t
WHERE kt = 4;

SELECT * FROM public.t_changes;
/* Output:
 operation | user_changed |         time_stamp         | kt | nt  | monthfee | monthmins | minfee
-----------+--------------+----------------------------+----+-----+----------+-----------+--------
 I         | postgres     | 2022-05-16 16:32:25.038801 |  4 | Pro |   100.00 |       100 |   3.50
 U         | postgres     | 2022-05-16 16:32:59.445299 |  4 | Pro |   100.00 |       100 |   4.00
 D         | postgres     | 2022-05-16 16:33:19.733413 |  4 | Pro |   100.00 |       100 |   4.00
*/