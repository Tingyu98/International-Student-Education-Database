# 1. Help display school information for students interested in a specific program, such as a student interested 
# in the computer science program.

SELECT School_Name, Department_Name, Program_Name, School_State, Number_of_seats
FROM Department D
JOIN Program P ON D.DepartmentID = P.DepartmentID
JOIN School S ON D.SchoolID = S.SchoolID
WHERE P.Program_Name LIKE '%computer science%';

# 2. Help students set clear preparation goals about SAT for applying to specific programs.

SELECT DISTINCT P.Program_Name, R.SAT
FROM Requirement R
JOIN Program P ON R.ProgramID = P.ProgramID
WHERE R.SAT > 1400
ORDER BY R.SAT DESC
LIMIT 10;

# 3. Retrieves a list of all students who have been accepted into their chosen school, useful for enrollment processing.

SELECT S.School_Name, ST.First_Name, ST.Last_Name, D.Student_Decision, D.School_Decision
FROM Student ST
JOIN Decision D ON ST.StudentID = D.StudentID
JOIN Department DE ON D.DepartmentID = DE.DepartmentID
JOIN School S ON DE.SchoolID = S.SchoolID
WHERE D.Student_Decision = 'Enroll' AND D.School_Decision = 'Admit'
ORDER BY S.School_Name;

# 4. Rejection Rates by School for the international students using this database
SELECT School.School_Name,
Concat ( 
ROUND((CAST(COUNT(CASE WHEN Decision.School_Decision = 'Deny' THEN 1 END) AS DECIMAL) / COUNT(Decision.School_Decision)) * 100, 2), 
'%' ) AS Rejection_Percentage
From School
LEFT JOIN Department ON Department.SchoolID = School.SchoolID
LEFT JOIN Decision ON Decision.DepartmentID = Department.DepartmentID
GROUP BY School_Name;

# 5. Acceptance Rates by school for the international students using this database
SELECT School.School_Name,
Concat ( 
ROUND((CAST(COUNT(CASE WHEN Decision.School_Decision = 'Deny' THEN 1 END) AS DECIMAL) / COUNT(Decision.School_Decision)) * 100, 2), 
'%' ) AS Rejection_Percentage
From School
LEFT JOIN Department ON Department.SchoolID = School.SchoolID
LEFT JOIN Decision ON Decision.DepartmentID = Department.DepartmentID
GROUP BY School_Name;

# 6. For each department at Mount Mary College, this query provides a clear and well-structured list of courses, term offerings, 
# and instructor names, making it simple for students to access academic data.

SELECT Department.Department_Name, Courses.Course_Name, Courses.Term_Offered, Courses.Instructor_Name
FROM School
JOIN Department ON School.SchoolID = Department.SchoolID
JOIN Courses ON Department.DepartmentID = Courses.DepartmentID
WHERE School.School_Name = 'Mount Mary College'
ORDER BY Department.Department_Name, Courses.Course_Name;

# 7. This query offers query is a thorough count of applications for each academic program. 
# This makes application strategy planning easier.

SELECT Program.ProgramID, Program.Program_Name, COUNT(Application.StudentID) AS Number_of_Applicants
FROM Program
LEFT JOIN Application_to_Program ON Program.ProgramID = Application_to_Program.ProgramID
LEFT JOIN Application ON Application_to_Program.ApplicationID = Application.ApplicationID
GROUP BY Program.ProgramID, Program.Program_Name
ORDER BY Number_of_Applicants DESC; 

# 8. This search provides information about the number of applications received by each university. This helps international students
# get an idea of what their chances are to get admitted

SELECT School.SchoolID, School.School_Name, COUNT(Application.ApplicationID) AS Number_of_Applications
FROM School
LEFT JOIN Department ON School.SchoolID = Department.SchoolID
LEFT JOIN Program ON Department.DepartmentID = Program.DepartmentID
LEFT JOIN Application_to_Program ON Program.ProgramID = Application_to_Program.ProgramID
LEFT JOIN Application ON Application_to_Program.ApplicationID = Application.ApplicationID
GROUP BY School.SchoolID, School.School_Name
ORDER BY Number_of_Applications DESC;

# 9. This query searches the courses listed taught by the Public Health department at University of Tennessee

SELECT Department.DepartmentID, Department.Department_Name, Courses.CourseID, Courses.Course_Name, School.School_Name
From School
LEFT JOIN Department ON School.SchoolID = Department.SchoolID
LEFT JOIN Program ON Department.DepartmentID =  Program.DepartmentID
LEFT JOIN Courses ON Program.ProgramID = Courses.ProgramID
WHERE School.School_Name = 'University of Tennessee - Knoxville' AND Department.Department_Name = 'Public Health' ;


# 10. Search of schools that has a health and a required IETLS score of 5 or less and contact information
SELECT School.School_Name, School.School_State, Program.Program_Name, Department.Department_Email 
From School
LEFT JOIN Department ON Department.SchoolID = School.SchoolID
LEFT JOIN Program ON Program.DepartmentID = Department.DepartmentID
LEFT JOIN Requirement ON Requirement.ProgramID = Program.ProgramID
WHERE Requirement.IETLS <=5 AND Program.Program_Name LIKE '%health%';

# 11. For Schools, dentifies students whose scores in at least two tests (SAT, ACT, GRE, TOEFL, IETLS) exceed 
# the average scores for their respective tests. This information can be valuable for pinpointing high-performing 
# students in specific areas, aiding in targeted academic support or recognition programs

SELECT StudentID, First_Name, Last_Name, SAT, ACT, GRE, TOEFL, IETLS,
CASE WHEN SAT > IFNULL((SELECT AVG(SAT) FROM Student WHERE SAT IS NOT NULL), 0) THEN 'Above Avg' ELSE 'Below Avg' END AS SAT_Avg_Status,
CASE WHEN ACT > IFNULL((SELECT AVG(ACT) FROM Student WHERE ACT IS NOT NULL), 0) THEN 'Above Avg' ELSE 'Below Avg' END AS ACT_Avg_Status,
CASE WHEN GRE > IFNULL((SELECT AVG(GRE) FROM Student WHERE GRE IS NOT NULL), 0) THEN 'Above Avg' ELSE 'Below Avg' END AS GRE_Avg_Status,
CASE WHEN TOEFL > IFNULL((SELECT AVG(TOEFL) FROM Student WHERE TOEFL IS NOT NULL), 0) THEN 'Above Avg' ELSE 'Below Avg' END AS TOEFL_Avg_Status,
CASE WHEN IETLS > IFNULL((SELECT AVG(IETLS) FROM Student WHERE IETLS IS NOT NULL), 0) THEN 'Above Avg' ELSE 'Below Avg' END AS IETLS_Avg_Status
FROM Student
WHERE 
    (SAT > IFNULL((SELECT AVG(SAT) FROM Student WHERE SAT IS NOT NULL), 0) AND
    ACT > IFNULL((SELECT AVG(ACT) FROM Student WHERE ACT IS NOT NULL), 0)) OR
    
    (SAT > IFNULL((SELECT AVG(SAT) FROM Student WHERE SAT IS NOT NULL), 0) AND
    GRE > IFNULL((SELECT AVG(GRE) FROM Student WHERE GRE IS NOT NULL), 0)) OR
    
    (SAT > IFNULL((SELECT AVG(SAT) FROM Student WHERE SAT IS NOT NULL), 0) AND
    TOEFL > IFNULL((SELECT AVG(TOEFL) FROM Student WHERE TOEFL IS NOT NULL), 0)) OR
    
    (SAT > IFNULL((SELECT AVG(SAT) FROM Student WHERE SAT IS NOT NULL), 0) AND
    IETLS > IFNULL((SELECT AVG(IETLS) FROM Student WHERE IETLS IS NOT NULL), 0)) OR
    
    (ACT > IFNULL((SELECT AVG(ACT) FROM Student WHERE ACT IS NOT NULL), 0) AND
    GRE > IFNULL((SELECT AVG(GRE) FROM Student WHERE GRE IS NOT NULL), 0)) OR
    
    (ACT > IFNULL((SELECT AVG(ACT) FROM Student WHERE ACT IS NOT NULL), 0) AND
    TOEFL > IFNULL((SELECT AVG(TOEFL) FROM Student WHERE TOEFL IS NOT NULL), 0)) OR
    
    (ACT > IFNULL((SELECT AVG(ACT) FROM Student WHERE ACT IS NOT NULL), 0) AND
    IETLS > IFNULL((SELECT AVG(IETLS) FROM Student WHERE IETLS IS NOT NULL), 0)) OR
    
    (GRE > IFNULL((SELECT AVG(GRE) FROM Student WHERE GRE IS NOT NULL), 0) AND
    TOEFL > IFNULL((SELECT AVG(TOEFL) FROM Student WHERE TOEFL IS NOT NULL), 0)) OR
    
    (GRE > IFNULL((SELECT AVG(GRE) FROM Student WHERE GRE IS NOT NULL), 0) AND
    IETLS > IFNULL((SELECT AVG(IETLS) FROM Student WHERE IETLS IS NOT NULL), 0)) OR
    
    (TOEFL > IFNULL((SELECT AVG(TOEFL) FROM Student WHERE TOEFL IS NOT NULL), 0) AND
    IETLS > IFNULL((SELECT AVG(IETLS) FROM Student WHERE IETLS IS NOT NULL), 0));
    
# 12. Acceptance Rates by School in the Law Department
SELECT School.School_Name,
Concat ( 
ROUND((CAST(COUNT(CASE WHEN Decision.School_Decision = 'Deny' THEN 1 END) AS DECIMAL) / COUNT(Decision.School_Decision)) * 100, 2), 
'%' ) AS Rejection_Percentage
From School
LEFT JOIN Department ON Department.SchoolID = School.SchoolID
LEFT JOIN Decision ON Decision.DepartmentID = Department.DepartmentID
WHERE Department.Department_Name = 'Law'
GROUP BY School_Name
Having Rejection_Percentage IS NOT NULL
;

# Procedural Call
CALL GetStudentDetailsAndDecision(36571338);

