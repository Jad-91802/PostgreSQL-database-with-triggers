INSERT INTO Course(
  courseKey, courseCode, courseName, department, credits
)VALUES(
  nextval('courseSeq'), 'COS301', 'Software Engineering', 'Computer Science', 40
);

INSERT INTO Course(
  courseKey, courseCode, courseName, department, credits
)VALUES(
  nextval('courseSeq'), 'COS326', 'Database Systems', 'Computer Science', 20
);

INSERT INTO Course(
  courseKey, courseCode, courseName, department, credits
)VALUES(
  nextval('courseSeq'), 'MTH301', 'Discrete Mathematics', 'Mathematics', 15
);

INSERT INTO Course(
  courseKey, courseCode, courseName, department, credits
)VALUES(
  nextval('courseSeq'), 'PHL301', 'Logical Reasoning', 'Philosophy', 15
);

INSERT INTO DegreeProgram (
  degreeKey, degreeCode, degreeName, numberOfYears, faculty
)VALUES(
  nextval('degreeSeq'), 'BSc', 'Bachelor of Science', 3, 'EBIT'
 );

INSERT INTO DegreeProgram (
  degreeKey, degreeCode, degreeName, numberOfYears, faculty
)VALUES(
  nextval('degreeSeq'), 'BIT', 'Bachelor of IT', 4, 'EBIT'
 );

INSERT INTO DegreeProgram (
  degreeKey, degreeCode, degreeName, numberOfYears, faculty
)VALUES(
  nextval('degreeSeq'), 'PhD', 'Philosophiae Doctor', 5, 'EBIT'
 );

SET datestyle = DMY;
INSERT INTO Postgraduate(
  studentKey, studentNumber, fullName, dateOfBirth, degreeCode, yearOfStudy, category, supervisor
)VALUES
(nextval('studentSeq'), '101122',ROW('Mr', 'John', 'Warn'),'15-06-1987','PhD',2,'Full_time',ROW('Prof', 'Dan', 'Grande')),
(nextval('studentSeq'), '121101',ROW('Mrs', 'Andie', 'Ted'),'27-04-1985','PhD',3,'Part_time',ROW('Dr', 'Phil', 'Aster'));

SET datestyle = DMY;
INSERT INTO Undergraduate(
  studentKey, studentNumber, fullName, dateOfBirth, degreeCode, yearOfStudy, courseRegistration
)VALUES
(nextval('studentSeq'), '140010',ROW('Mr', 'A','Nuf'),'10-01-1996','BSc',3,('{COS301, COS326, MTH301}')),
(nextval('studentSeq'), '140015',ROW('Mrs', 'G','Mon'),'25-05-1995','BSc',3,('{COS301, PHL301, MTH301}')),
(nextval('studentSeq'), '131120',ROW('Miss', 'L','Tes'),'30-01-1995','BIT',3,('{COS301, COS326, PHL301}')),
(nextval('studentSeq'), '131140',ROW('Miss', 'W','Pou'),'20-02-1996','BIT',4,('{COS301, COS326,MTH301, PHL301}'));
