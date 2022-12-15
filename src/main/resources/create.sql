CREATE TYPE lesson_type AS ENUM ('individual', 'group', 'ensembles');
CREATE TYPE level AS ENUM ('beginner', 'intermediate', 'advanced');

--pricing_scheme
CREATE TABLE pricing_scheme (
id SERIAL PRIMARY KEY,
lesson_type lesson_type NOT NULL,
level level NOT NULL,
student_discount_perc SMALLINT NOT NULL,
student_price SMALLINT NOT NULL,
instructor_price SMALLINT NOT NULL
);

-- instructor
CREATE TABLE instructor (
    id SERIAL PRIMARY KEY,
    person_number VARCHAR(12) UNIQUE NOT NULL,
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR(500) NOT NULL,
    phone_no VARCHAR(50) NOT NULL,
    email VARCHAR(500) NOT NULL,
    street VARCHAR(50) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    city VARCHAR(50) NOT NULL
);

-- instructor_availability
CREATE TABLE instructor_availability (
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    instructor_id INT NOT NULL,
    PRIMARY KEY (start_time, end_time, instructor_id),
    FOREIGN KEY (instructor_id) REFERENCES instructor(id) ON DELETE CASCADE
);

-- instructor_instrument
CREATE TABLE instructor_instrument (
    instrument VARCHAR(50) NOT NULL,
    level level NOT NULL,
    instructor_id INT NOT NULL,
    PRIMARY KEY (instrument, level, instructor_id),
    FOREIGN KEY (instructor_id) REFERENCES instructor(id) ON DELETE CASCADE
);

--family
CREATE TABLE family (
id SERIAL PRIMARY KEY,
family_contact_name VARCHAR(50) NOT NULL,
family_email VARCHAR(500),
family_phone_num VARCHAR(50) NOT NULL
);

--student
CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    person_number VARCHAR(12) UNIQUE NOT NULL,
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR(500) NOT NULL,
    phone_no VARCHAR(50) NOT NULL,
    email VARCHAR(500) NOT NULL,
    street VARCHAR(50) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    city VARCHAR(50) NOT NULL,
    family_id INT NOT NULL,

    FOREIGN KEY (family_id) REFERENCES family(id)
);

-- rental_instrument
CREATE TABLE rental_instrument (
    id SERIAL PRIMARY KEY,
    kind VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    price SMALLINT NOT NULL,
    isAvailable BOOLEAN NOT NULL
);

-- student_rental_instrument
CREATE TABLE student_rental_instrument (
    rental_instrument_id INT NOT NULL,
    student_id INT NOT NULL,
    checkout_date TIMESTAMP NOT NULL,
    return_date TIMESTAMP,
    PRIMARY KEY (rental_instrument_id, student_id),
    FOREIGN KEY (rental_instrument_id) REFERENCES rental_instrument(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
);

--INHERITANCE: lesson
CREATE TABLE lesson (
    id SERIAL PRIMARY KEY,
    instructor_id INT NOT NULL,
    classroom VARCHAR(50) NOT NULL,
    level level NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES instructor(id)
);

-- individual_lesson
CREATE TABLE individual_lesson (
    instrument VARCHAR(500) NOT NULL,
    student_id INT,

    FOREIGN KEY (student_id) REFERENCES student(id),
    CONSTRAINT individual_lesson_pkey PRIMARY KEY (id)
) INHERITS(lesson);

-- group_lesson
CREATE TABLE group_lesson (
    instrument VARCHAR(500) NOT NULL,
    maximum_student SMALLINT NOT NULL,
    minimum_student SMALLINT NOT NULL CHECK(minimum_student > 2),

    CONSTRAINT group_lesson_pkey PRIMARY KEY (id)
) INHERITS(lesson);

CREATE TABLE student_group_lesson (
    student_id INT NOT NULL,
    group_lesson_id INT NOT NULL,

    PRIMARY KEY (student_id, group_lesson_id),
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (group_lesson_id) REFERENCES group_lesson(id) ON DELETE CASCADE
);

-- ensembles
CREATE TABLE ensembles (
    genre VARCHAR(50) NOT NULL,
    maximum_student SMALLINT NOT NULL,
    minimum_student SMALLINT NOT NULL CHECK(minimum_student > 2),

    CONSTRAINT ensembles_pkey PRIMARY KEY (id)
) INHERITS(lesson);

CREATE TABLE student_ensembles (
    student_id INT NOT NULL,
    ensembles_id INT NOT NULL,
    ensemble_instrument VARCHAR(500) NOT NULL,

    PRIMARY KEY (student_id, ensembles_id),
    FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    FOREIGN KEY (ensembles_id) REFERENCES ensembles(id) ON DELETE CASCADE
);