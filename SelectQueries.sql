SELECT studentNumber, personFullNames(fullName), ageInYears(dateOfBirth), (SELECT degreeCode FROM DegreeProgram WHERE DegreeProgram.degreeCode = Undergraduate.degreeCode) AS Degree_Program FROM Undergraduate WHERE isRegisteredFor('COS326', courseRegistration);

SELECT hasValidCourseCodes('{COS301, COS123}');

SELECT hasValidCourseCodes('{COS301, COS326}');

SELECT hasDuplicateCourseCode('{COS301, COS326}');

SELECT hasDuplicateCourseCode('{COS301, COS326, COS326}');


