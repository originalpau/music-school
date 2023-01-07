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
rental_instrument(kind, brand, price)
VALUES 
    ('guitar', 'yamaha', 50),
    ('guitar', 'gibson', 50),
    ('violin', 'yamaha', 50),
    ('piano', 'casio', 60),
    ('piano', 'yamaha', 100),
    ('piano', 'roland', 80),
    ('piano', 'kawai', 120),
    ('drums', 'roland', 50);

-- student_rental_instrument
INSERT INTO
student_rental_instrument(rental_instrument_id, student_id, checkout_date)
VALUES
    (1, (SELECT id FROM student WHERE person_number='199001011222'), '2022-11-01');

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
pricing_scheme(type, level, student_price, instructor_price)
VALUES
    ('individual', 'beginner', 150, 100),
    ('individual', 'intermediate', 160, 110),
    ('individual', 'advanced', 170, 120),
    ('group', 'beginner', 120, 70),
    ('group', 'intermediate', 130, 80),
    ('group', 'advanced', 140, 90),
    ('ensembles', 'beginner', 120, 70),
    ('ensembles', 'intermediate', 130, 80),
    ('ensembles', 'advanced', 140, 90);
