-- #lessons given per month, during a specific year.
-- Month		Total
SELECT EXTRACT(MONTH FROM start_time) as month, COUNT(id) as total
FROM lesson
WHERE EXTRACT(YEAR FROM start_time) = '2022'
GROUP BY month
ORDER BY month;

-- Month	    Individual		Group		Ensembles		Total       -> Month in integer
SELECT
  EXTRACT(MONTH FROM lesson.start_time) as month,
  count(i.id) as individual,
  count(g.id) as group,
  count(e.id) as ensembles, count(lesson.id) as total
FROM lesson
LEFT OUTER JOIN individual_lesson i ON (lesson.id = i.id)
LEFT OUTER JOIN group_lesson g ON (lesson.id = g.id)
LEFT OUTER JOIN ensembles e ON (lesson.id = e.id)
WHERE EXTRACT(YEAR FROM lesson.start_time) = '2022'
GROUP BY month
ORDER BY month;

-- Month	    Individual		Group		Ensembles		Total       -> Month in chars
SELECT
  to_char(date_trunc('month', lesson.start_time), 'Month') as month,
  count(i.id) as individual,
  count(g.id) as group,
  count(e.id) as ensembles,
  count(lesson.id) as total
FROM lesson
LEFT OUTER JOIN individual_lesson i ON (lesson.id = i.id)
LEFT OUTER JOIN group_lesson g ON (lesson.id = g.id)
LEFT OUTER JOIN ensembles e ON (lesson.id = e.id)
WHERE EXTRACT(YEAR FROM lesson.start_time) = '2022'
GROUP BY date_trunc('month', lesson.start_time)
ORDER BY date_trunc('month', lesson.start_time);

-------------------------------------------------------------------------------------------------------------
/* SELECT f.id, f.family_contact_name, f.family_email,
string_agg(DISTINCT s.first_name, ',') as children,
COUNT(s.family_id) AS qty
FROM family f, student s
WHERE f.id = s.family_id
GROUP BY f.id; */

-- #siblings
-- no_of_siblings  students
SELECT s.no_siblings as no_of_siblings, sum(s.no_students) as students
FROM (
  SELECT count(f.id)-1 as no_siblings, count(DISTINCT s.id) as no_students
  FROM family f, student s
  WHERE f.id = s.family_id
  GROUP BY f.id
  ORDER BY no_siblings
  ) as s
GROUP BY s.no_siblings;
-------------------------------------------------------------------------------------------------------------
--instructors who have given too much #lessons during CURRENT month, from high to low
		--first_name	last_name	no_lessons
SELECT
  to_char(date_trunc('month', current_date), 'Month') as current_month,
  i.first_name, i.last_name, count(l.id)
FROM instructor i
INNER JOIN lesson l ON (i.id = l.instructor_id)
WHERE EXTRACT(Month FROM start_time) = EXTRACT(Month FROM current_date)
GROUP BY i.first_name, i.last_name
HAVING count(l.id) > 1
ORDER BY count(l.id) DESC;
-------------------------------------------------------------------------------------------------------------
--List all ensembles held during the next week, sorted by music genre and weekday.
--For each ensemble tell whether it's full booked, has 1-2 seats left or has more seats left.
--Hint: you might want to use a CASE statement in your query to produce the desired output.
-- start_time	  genre		available_seats

SELECT ensembles.id, start_time, genre, level,
  CASE
    WHEN count(student_id) >= maximum_student THEN 'Fully booked'
    WHEN count(student_id) = maximum_student -1 THEN '1'
    WHEN count(student_id) = maximum_student -2 THEN '2'
    ELSE 'A lot'
  END available_seats
FROM ensembles
INNER JOIN student_ensembles ON student_ensembles.ensembles_id = ensembles.id
WHERE date_trunc('week', start_time) = date_trunc('week', now()) + interval '1 week'
GROUP BY ensembles.id
ORDER BY date_trunc('day', start_time), genre;


----------------------------------------------------------
CREATE VIEW lessons_per_month AS
SELECT
  to_char(date_trunc('month', lesson.start_time), 'Month') as month,
  count(i.id) as individual,
  count(g.id) as group,
  count(e.id) as ensembles,
  count(lesson.id) as total
FROM lesson
LEFT OUTER JOIN individual_lesson i ON (lesson.id = i.id)
LEFT OUTER JOIN group_lesson g ON (lesson.id = g.id)
LEFT OUTER JOIN ensembles e ON (lesson.id = e.id)
WHERE EXTRACT(YEAR FROM lesson.start_time) = '2022'
GROUP BY date_trunc('month', lesson.start_time)
ORDER BY date_trunc('month', lesson.start_time);
----------------------------------------------------------
CREATE VIEW no_of_siblings AS
SELECT s.no_siblings as no_of_siblings, sum(s.no_students) as students
FROM (
  SELECT count(f.id)-1 as no_siblings, count(DISTINCT s.id) as no_students
  FROM family f
  INNER JOIN student s on f.id = s.family_id
  GROUP BY f.id
  ORDER BY no_siblings
  ) as s
GROUP BY s.no_siblings;
----------------------------------------------------------
CREATE VIEW overworked_instructors AS
SELECT
  to_char(date_trunc('month', current_date), 'Month') as current_month,
  i.first_name, i.last_name, count(l.id)
FROM instructor i
INNER JOIN lesson l ON (i.id = l.instructor_id)
WHERE EXTRACT(Month FROM start_time) = EXTRACT(Month FROM current_date)
GROUP BY i.first_name, i.last_name
HAVING count(l.id) > 1
ORDER BY count(l.id) DESC;
----------------------------------------------------------
CREATE MATERIALIZED VIEW ensembles_next_week AS
SELECT ensembles.id, start_time, genre, level,
  CASE
    WHEN count(student_id) >= maximum_student THEN 'Fully booked'
    WHEN count(student_id) = maximum_student -1 THEN '1'
    WHEN count(student_id) = maximum_student -2 THEN '2'
    ELSE 'A lot'
  END available_seats
FROM ensembles
INNER JOIN student_ensembles ON student_ensembles.ensembles_id = ensembles.id
WHERE date_trunc('week', start_time) = date_trunc('week', now()) + interval '1 week'
GROUP BY ensembles.id
ORDER BY date_trunc('day', start_time), genre;