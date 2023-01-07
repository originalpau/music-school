--"which lessons each student has taken, and at which cost, since they first joined - marketing"
--Did not store: classroom, instructor_id, instructor_price, student_discount_perc, max/min students, end_time

CREATE TABLE historical_lesson (
    id SERIAL PRIMARY KEY,
    lesson_id INT NOT NULL,
    type type NOT NULL,
    level level NOT NULL, 
    start_time TIMESTAMP NOT NULL,
    student_id INT NOT NULL,
    instrument VARCHAR(500), 
    genre VARCHAR(50),
    student_price SMALLINT NOT NULL
);

--Select Data to Transfer to From OLTP Database and
--Insert Data into historical_lesson

--group
insert into historical_lesson(lesson_id, type, level, start_time, student_id, instrument, student_price)
select g.id as lesson_id, type, g.level, start_time, student_id, instrument, student_price from group_lesson g
inner join student_group_lesson on group_lesson_id = g.id
inner join pricing_scheme p on p.id = pricing_scheme_id;

--ensembles
insert into historical_lesson(lesson_id, type, level, start_time, student_id, instrument, genre, student_price)
select e.id as lesson_id, type, e.level, start_time, student_id, ensemble_instrument as instrument, genre, student_price from ensembles e
inner join student_ensembles on ensembles_id = e.id
inner join pricing_scheme p on p.id = pricing_scheme_id;

--individual
insert into historical_lesson(lesson_id, type, level, start_time, student_id, instrument, student_price)
select i.id as lesson_id, type, i.level, start_time, student_id, instrument, student_price from individual_lesson i
inner join pricing_scheme p on p.id = pricing_scheme_id;