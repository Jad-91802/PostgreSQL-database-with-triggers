SET datestyle = DMY;
INSERT INTO Undergraduate(
  studentKey, studentNumber, fullName, dateOfBirth, degreeCode, yearOfStudy, courseRegistration
)VALUES
(nextval('studentSeq'), '123456', ROW('Mr', 'Jared','Gratz'),'24-04-1997','ABC',1,('{COS301, COS326}'));

SET datestyle = DMY;
INSERT INTO Undergraduate(
  studentKey, studentNumber, fullName, dateOfBirth, degreeCode, yearOfStudy, courseRegistration
)VALUES
(nextval('studentSeq'), '123456', ROW('Mr', 'Jared', 'Gratz'),'24-04-1997','BSc',1,('{COS301, COS123}'));

SET datestyle = DMY;
INSERT INTO Postgraduate(
  studentKey, studentNumber, fullName, dateOfBirth, degreeCode, yearOfStudy, category, supervisor
)VALUES
(nextval('studentSeq'), '123456', ROW('Mr', 'Jared', 'Gratz'),'27-04-1985','ABC',1,'Part_time',ROW('Dr', 'Phil', 'Phil'));

UPDATE Undergraduate
SET degreeCode = 'ABC'
WHERE studentNumber = '140010';

UPDATE Undergraduate
SET courseRegistration = ('{COS301, COS123}')
WHERE studentNumber = '140010';

UPDATE Postgraduate
SET degreeCode = 'ABC'
WHERE studentNumber = '101122';

SELECT * FROM Undergraduate;

DELETE FROM Undergraduate WHERE studentNumber = '140010';

SELECT * FROM DeletedUndergrad;

SELECT * FROM Postgraduate;

DELETE FROM Postgraduate WHERE studentNumber = '101122';

SELECT * FROM DeletedPostgrad;
