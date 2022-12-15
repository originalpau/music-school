-- family
INSERT INTO
family(family_contact_name, family_email, family_phone_num)
VALUES
    ('Göran Svenson', 'svensson@email.se', '08123456'),
    ('Peter Johansson', 'johansson@email.se', '031123456'),
    ('Hanna Wang','wang@email.se', '08654321'),
    ('Leila Andersson', 'leila@gmail.com', '0762951263');

-- student
INSERT INTO
student(family_id, person_number, first_name, last_name, phone_no, email, street, zip, city)
VALUES
    ((SELECT id FROM family WHERE family_email='johansson@email.se'), '199001011222', 'Sofia', 'Johansson', '0705121212','sofia@email.se', 'Huvudgatan 1', '12345', 'Stockholm'),
    ((SELECT id FROM family WHERE family_email='svensson@email.se'), '199101012212', 'Johan', 'Svenson', '0706221212','johan@email.se', 'Andragatan 2', '12345', 'Stockholm'),
    ((SELECT id FROM family WHERE family_email='wang@email.se'), '199304061245', 'Nikita', 'Wang', '0705134264','nikita@email.se', 'Strandgatan 1', '12348', 'Stockholm'),
    ((SELECT id FROM family WHERE family_email='johansson@email.se'), '199906209876', 'Markus', 'Johansson', '0737291023', 'markus@email.com', 'Huvudgatan 1', '12345', 'Stockholm'),
    ((SELECT id FROM family WHERE family_email='johansson@email.se'), '200003021463', 'Leila', 'Johansson', '0739152847', 'leila@email.com', 'Huvudgatan 1', '12345', 'Stockholm'),
    ((SELECT id FROM family WHERE family_email='wang@email.se'), '200101015214', 'Ebony', 'Wang', '0701927693', 'ebony@email.com', 'Strandgatan 1', '12348', 'Stockholm'),
    ((SELECT id FROM family WHERE family_email='leila@gmail.com'), '199801055219', 'Sebastian', 'Andersson', '0739125212','sebastian@email.se', 'Penngatan 1', '16314', 'Stockholm');

-- rental_instrument
INSERT INTO
rental_instrument(kind, brand, price, isAvailable)
VALUES
    ('guitar', 'yamaha', 50, true),
    ('guitar', 'gibson', 50, true),
    ('violin', 'yamaha', 50, true),
    ('piano', 'casio', 60, true),
    ('piano', 'yamaha', 100, true),
    ('piano', 'roland', 80, true),
    ('piano', 'kawai', 120, true),
    ('drums', 'roland', 50, false);

-- student_rental_instrument
INSERT INTO
student_rental_instrument(rental_instrument_id, student_id, checkout_date)
VALUES
    (8, (SELECT id FROM student WHERE person_number='199001011222'), '2022-11-01');

-- instructor
INSERT INTO
instructor(person_number, first_name, last_name, phone_no, email, street, zip, city)
VALUES
    ('198308101239', 'James', 'Scott', '0765984823', 'james@gmail.com', 'Regeringsvägen 23', '13254', 'Stockholm'),
    ('199001230149', 'Jessica', 'Albertsson', '0724569128', 'jessica@gmail.com', 'Strandvägen 12', '13163', 'Stockholm'),
    ('197202051521', 'Peter', 'Frederick','07611072670','peter@icloud.edu','Huvudgatan 4','48525', 'Stockholm'),
    ('197012042632', 'Curran', 'Fernandez','07018349052','curran@icloud.edu','Drottningatan 1','16360', 'Stockholm'),
    ('198805031623', 'Felix', 'Robertson','07036978375','felix@icloud.edu','Kungavägen 5','77534', 'Stockholm');

-- instructor_availability
INSERT INTO
instructor_availability(start_time, end_time, instructor_id)
VALUES
    ('2022-11-19 23:06:35','2022-12-06 02:21:51', (SELECT id FROM instructor WHERE person_number='198308101239')),
    ('2022-11-20 16:01:36','2022-12-06 16:14:40', (SELECT id FROM instructor WHERE person_number='198308101239')),
    ('2022-11-20 13:03:29','2022-11-28 07:58:47', (SELECT id FROM instructor WHERE person_number='199001230149')),
    ('2022-11-22 10:40:24','2022-12-03 00:20:24', (SELECT id FROM instructor WHERE person_number='198805031623')),
    ('2022-11-20 04:30:08','2022-11-30 16:54:48', (SELECT id FROM instructor WHERE person_number='198805031623'));

-- instructor_instrument
INSERT INTO
instructor_instrument(instrument, level, instructor_id)
VALUES
    ('guitar','beginner', (SELECT id FROM instructor WHERE person_number='198308101239')),
    ('piano','intermediate', (SELECT id FROM instructor WHERE person_number='198308101239')),
    ('drums','advanced', (SELECT id FROM instructor WHERE person_number='199001230149')),
    ('violin', 'advanced', (SELECT id FROM instructor WHERE person_number='198805031623')),
    ('guitar','intermediate', (SELECT id FROM instructor WHERE person_number='198805031623'));

-- pricing_scheme
INSERT INTO
pricing_scheme(lesson_type, level, student_discount_perc, student_price, instructor_price)
VALUES
    ('individual', 'beginner', 0, 150, 100),
    ('individual', 'beginner', 5, 143, 100),
    ('individual', 'intermediate', 0, 160, 110),
    ('individual', 'intermediate', 5, 152, 110),
    ('individual', 'advanced', 0, 170, 120),
    ('individual', 'advanced', 5, 162, 120),
    ('group', 'beginner', 0, 120, 70),
    ('group', 'beginner', 5, 114, 70),
    ('group', 'intermediate', 0, 130, 80),
    ('group', 'intermediate', 5, 124, 80),
    ('group', 'advanced', 0, 140, 90),
    ('group', 'advanced', 5, 133, 90),
    ('ensembles', 'beginner', 0, 120, 70),
    ('ensembles', 'beginner', 5, 114, 70),
    ('ensembles', 'intermediate', 0, 130, 80),
    ('ensembles', 'intermediate', 5, 124, 80),
    ('ensembles', 'advanced', 0, 140, 90),
    ('ensembles', 'advanced', 5, 133, 90);

-- ensembles
INSERT INTO
ensembles(instructor_id, classroom, level, start_time, maximum_student, minimum_student, genre)
VALUES
    ((SELECT id FROM instructor WHERE person_number='198308101239'), 'TBD', 'beginner', '2022-11-11 13:30', 10, 3, 'gospel'),
    ((SELECT id FROM instructor WHERE person_number='198308101239'), 'TBD', 'intermediate', '2022-11-7 13:30', 10, 3, 'gospel'),
    ((SELECT id FROM instructor WHERE person_number='199001230149'), 'TBD', 'advanced', '2022-11-11 14:30', 10, 3, 'rock'),
    ((SELECT id FROM instructor WHERE person_number='198805031623'), 'TBD', 'beginner', '2022-11-8 15:00', 10, 3, 'rock'),
    ((SELECT id FROM instructor WHERE person_number='198805031623'), 'TBD', 'intermediate', '2022-11-10 13:30', 10, 3, 'rock'),
    ((SELECT id FROM instructor WHERE person_number='197012042632'), 'TBD', 'advanced', '2022-11-12 13:30', 10, 3, 'jazz');

INSERT INTO ensembles (instructor_id,classroom,level,start_time,maximum_student,minimum_student,genre)
VALUES
  (3,'TBD','intermediate','2023-01-13 20:17',15,4,'gospel'),
  (2,'TBD','intermediate','2023-01-22 07:44',10,4,'rock'),
  (1,'TBD','intermediate','2022-12-14 08:47',11,4,'gospel'),
  (3,'TBD','beginner','2023-01-25 18:08',14,4,'jazz'),
  (4,'TBD','beginner','2023-01-16 23:11',11,3,'gospel'),
  (2,'TBD','intermediate','2023-01-05 22:26',12,4,'jazz'),
  (2,'TBD','intermediate','2022-12-06 11:06',11,3,'gospel'),
  (4,'TBD','intermediate','2022-12-23 20:41',12,4,'rock'),
  (0,'TBD','intermediate','2022-12-30 06:26',13,4,'jazz'),
  (2,'TBD','beginner','2022-12-12 05:49',11,3,'pop'),
  (2,'TBD','intermediate','2022-12-09 05:52',11,3,'jazz'),
  (2,'TBD','intermediate','2023-01-31 04:31',15,3,'jazz'),
  (1,'TBD','intermediate','2023-01-10 19:15',14,3,'pop'),
  (3,'TBD','beginner','2023-01-17 02:18',11,4,'rock'),
  (2,'TBD','beginner','2022-12-13 16:59',15,4,'rock'),
  (4,'TBD','beginner','2022-12-05 21:22',14,3,'rock'),
  (2,'TBD','intermediate','2023-01-29 02:38',13,3,'jazz'),
  (5,'TBD','beginner','2022-12-03 11:25',14,3,'jazz'),
  (4,'TBD','beginner','2023-01-11 02:30',15,3,'gospel'),
  (2,'TBD','intermediate','2022-12-26 09:31',11,4,'rock');

INSERT INTO
student_ensembles(student_id, ensembles_id, ensemble_instrument)
VALUES
    ((SELECT id FROM student WHERE person_number='199001011222'), (SELECT id FROM ensembles WHERE start_time='2022-11-11 13:30'), 'piano'),
    ((SELECT id FROM student WHERE person_number='199101012212'), (SELECT id FROM ensembles WHERE start_time='2022-11-7 13:30'), 'piano'),
    ((SELECT id FROM student WHERE person_number='199304061245'), (SELECT id FROM ensembles WHERE start_time='2022-11-11 14:30'), 'drums'),
    ((SELECT id FROM student WHERE person_number='199906209876'), (SELECT id FROM ensembles WHERE start_time='2022-11-8 15:00'), 'guitar'),
    ((SELECT id FROM student WHERE person_number='200003021463'), (SELECT id FROM ensembles WHERE start_time='2022-11-10 13:30'), 'guitar'),
    ((SELECT id FROM student WHERE person_number='200101015214'), (SELECT id FROM ensembles WHERE start_time='2022-11-12 13:30'), 'piano');

INSERT INTO
student_ensembles(student_id, ensembles_id, ensemble_instrument)
VALUES
(1, 9, 'piano'),
(1, 16, 'guitar'),
(1, 21, 'drums'),
(2, 9, 'guitar'),
(2, 16, 'guitar'),
(2, 21, 'guitar'),
(3, 9, 'piano'),
(3, 16, 'piano'),
(4, 9, 'drums'),
(4, 16, 'drums'),
(4, 21, 'drums'),
(5, 9, 'violin'),
(5,16, 'violin'),
(6, 9, 'piano');

-- group_lesson
INSERT INTO
group_lesson(instructor_id, classroom, level, start_time, maximum_student, minimum_student, instrument)
VALUES
    ((SELECT id FROM instructor WHERE person_number='198308101239'), 'TBD', 'beginner', '2022-11-11 10:30', 10, 3, 'guitar'),
    ((SELECT id FROM instructor WHERE person_number='198308101239'), 'TBD', 'intermediate', '2022-11-7 17:30', 10, 3, 'guitar'),
    ((SELECT id FROM instructor WHERE person_number='197012042632'), 'TBD', 'advanced', '2022-11-12 19:30', 10, 3, 'piano'),
    ((SELECT id FROM instructor WHERE person_number='197012042632'), 'TBD', 'advanced', '2022-12-15 19:30', 10, 3, 'piano'),
    ((SELECT id FROM instructor WHERE person_number='198308101239'), 'TBD', 'beginner', '2022-9-10 10:30', 10, 3, 'guitar');

INSERT INTO
student_group_lesson(student_id, group_lesson_id)
VALUES
    ((SELECT id FROM student WHERE person_number='199001011222'), (SELECT id FROM group_lesson WHERE start_time='2022-11-11 10:30')),
    ((SELECT id FROM student WHERE person_number='199101012212'), (SELECT id FROM group_lesson WHERE start_time='2022-11-7 17:30')),
    ((SELECT id FROM student WHERE person_number='200101015214'), (SELECT id FROM group_lesson WHERE start_time='2022-11-12 19:30'));

-- individual_lesson
INSERT INTO
individual_lesson(instructor_id, student_id, start_time, instrument, classroom, level)
VALUES
    ((SELECT id FROM instructor WHERE person_number='197012042632'), (SELECT id FROM student WHERE person_number='200003021463'), '2022-11-9 17:00', 'piano', 'TBD', 'beginner'),
    ((SELECT id FROM instructor WHERE person_number='197202051521'), (SELECT id FROM student WHERE person_number='200101015214'), '2022-10-1 15:00', 'violin', 'TBD', 'beginner'),
    ((SELECT id FROM instructor WHERE person_number='197202051521'), (SELECT id FROM student WHERE person_number='200101015214'), '2022-8-1 15:00', 'violin', 'TBD', 'beginner'),
    ((SELECT id FROM instructor WHERE person_number='197202051521'), (SELECT id FROM student WHERE person_number='200101015214'), '2022-8-7 15:00', 'violin', 'TBD', 'beginner'),
    ((SELECT id FROM instructor WHERE person_number='197202051521'), (SELECT id FROM student WHERE person_number='200101015214'), '2022-7-15 15:00', 'violin', 'TBD', 'beginner');

update ensembles
set maximum_student = 6, minimum_student = 3
where date_trunc('week', start_time) = date_trunc('week', now()) + interval '1 week';