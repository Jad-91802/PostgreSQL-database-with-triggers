CREATE SEQUENCE degreeSeq START WITH 1000 INCREMENT BY 12;

CREATE SEQUENCE courseSeq START WITH 2000;

CREATE SEQUENCE studentSeq START WITH 3000;

CREATE DOMAIN studentNumber AS TEXT
CHECK(
   VALUE ~ '^[0-9]{6}$'
);

CREATE TYPE CategoryType AS ENUM ('Part_time', 'Full_time');

CREATE TYPE TitleType AS ENUM ('Ms', 'Mev', 'Miss', 'Mrs', 'Mr', 'Mnr', 'Dr', 'Prof');

CREATE TYPE NameType AS (title TitleType, firstName text, surname text);

CREATE TABLE DegreeProgram (
	degreeKey  serial PRIMARY KEY,
    degreeCode text UNIQUE,
    degreeName text,
    numberOfYears integer,
    faculty text
);

CREATE TABLE Course (
	courseKey serial PRIMARY KEY,
    courseCode text,
    courseName text,
    department text,
    credits integer
);

CREATE TABLE student (
	studentKey serial PRIMARY KEY,
    studentNumber integer,
    fullName   NameType,
    dateOfBirth date,
    degreeCode  text REFERENCES DegreeProgram (degreeCode),
    yearOfStudy integer
);

CREATE TABLE Undergraduate (
    courseRegistration text[]
) INHERITS(student);

CREATE TABLE Postgraduate (
    category CategoryType,
    supervisor NameType
) INHERITS(student);

CREATE TABLE DeletedUndergrad (
	studentKey serial,
    studentNumber integer,
    fullName NameType,
    dateOfBirth date,
    degreeCode text REFERENCES DegreeProgram (degreeCode),
    yearOfStudy integer,
	courseRegistration text[],
	dateAndTime timestamp,
	userId text
);

CREATE TABLE DeletedPostgrad (
	studentKey serial,
    studentNumber integer,
    fullName NameType,
    dateOfBirth date,
    degreeCode text REFERENCES DegreeProgram (degreeCode),
    yearOfStudy integer,
	category CategoryType,
    supervisor NameType,
	dateAndTime timestamp,
	userId text
);

CREATE OR REPLACE FUNCTION personFullNames(name NameType) RETURNS text AS
$$
DECLARE outName text;
BEGIN	
	outName := CAST(name.title AS text) || ' ' || name.firstName || ' ' || name.surname;
	RETURN outName;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ageInYears(date) RETURNS text AS 
$$
BEGIN 
	RETURN age(current_date, $1);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isRegisteredFor(text, text[]) RETURNS boolean AS
$$
DECLARE flag boolean; val text;	
BEGIN
	flag := false;
	FOREACH val IN ARRAY $2
	LOOP
		IF $1 = val THEN 
			flag := true;
		END IF;
	END LOOP;
	RETURN flag;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isValidCourseCode(text)RETURNS boolean AS $$
DECLARE	val text;
BEGIN
	SELECT courseCode FROM Course WHERE courseCode = $1 INTO val;
	IF FOUND THEN
		RETURN true;
	ELSE RETURN false;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION hasValidCourseCodes(text [])RETURNS boolean AS $$
DECLARE	boolVal boolean; val text;
BEGIN
	FOREACH val IN ARRAY $1
	LOOP
		IF isValidCourseCode(val) THEN
			boolVal := true;
		ELSE RETURN false;
		END IF;
	END LOOP;
	RETURN boolVal;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION courseCodeFrequency(text, text [])RETURNS int AS $$
DECLARE countCode int; val text;
BEGIN	
	countCode := 0;
	FOREACH val IN ARRAY $2
	LOOP
		IF $1 = val THEN
			countCode := countCode + 1;
		END IF;
	END LOOP;
	RETURN countCode;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION hasDuplicateCourseCode(text [])RETURNS boolean AS $$
DECLARE countCode int; val text; arr text; 
BEGIN	
	countCode := 0;
	FOREACH val IN ARRAY $1
	LOOP
		FOREACH arr IN ARRAY $1
		LOOP
			IF arr = val THEN
				countCode := countCode + 1;
			END IF;
		END LOOP;
		IF countCode > 1 THEN
			RETURN true;
		END IF;
		countCode := 0;	
	END LOOP;
	RETURN false;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isValidDegreeCode(text)RETURNS boolean AS $$
DECLARE val text;
BEGIN	
	SELECT degreeCode FROM DegreeProgram WHERE degreeCode = $1 INTO val;
	IF FOUND THEN
		RETURN true;
	ELSE RETURN false;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_valid_degree_code() RETURNS TRIGGER AS
$$
BEGIN
	IF NOT(isValidDegreeCode(New.degreeCode))  THEN
		RAISE EXCEPTION 'Invalid degree Code';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_valid_course_codes() RETURNS TRIGGER AS
$$
BEGIN
	IF NOT(hasValidCourseCodes(NEW.courseRegistration))  THEN
		RAISE EXCEPTION 'Invalid course Code';
	ELSIF (hasDuplicateCourseCode(NEW.courseRegistration))  THEN
		RAISE EXCEPTION 'Duplicate course Code found';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION record_delete_undergrad() RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO DeletedUndergrad
		SELECT OLD.*, now(), user;
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION record_delete_postgrad() RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO DeletedPostgrad
		SELECT OLD.*, now(), user;
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_valid_degree
	BEFORE INSERT OR UPDATE ON Student
		FOR EACH ROW
			EXECUTE PROCEDURE check_valid_degree_code();

CREATE TRIGGER check_valid_degree
	BEFORE INSERT OR UPDATE ON Undergraduate
		FOR EACH ROW
			EXECUTE PROCEDURE check_valid_degree_code();

CREATE TRIGGER check_valid_degree
	BEFORE INSERT OR UPDATE ON Postgraduate
		FOR EACH ROW
			EXECUTE PROCEDURE check_valid_degree_code();
			
CREATE TRIGGER check_valid_course_registration
	BEFORE INSERT OR UPDATE ON Undergraduate
		FOR EACH ROW
			EXECUTE PROCEDURE check_valid_course_codes();

CREATE TRIGGER audit_delete_undergrad
	AFTER DELETE ON Undergraduate
		FOR EACH ROW
			EXECUTE PROCEDURE record_delete_undergrad();

CREATE TRIGGER audit_delete_postgrad
	AFTER DELETE ON Postgraduate
		FOR EACH ROW
			EXECUTE PROCEDURE record_delete_postgrad();