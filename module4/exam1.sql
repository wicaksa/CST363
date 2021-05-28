-- Student: Wicaksa Munajat
-- Date: 05/25/2021
-- Class: CSUMB CS ONLINE CST 363 Summer '21 M
-- Module 4 Midterm 1 

-- 1. What are the last and first names of students majoring in Biology and 
--    have a GPA between 3.0 and 3.5. The list should be in order by lastname.

--    DEBUG SELECT * FROM student WHERE major = 'biology' ORDER BY GPA DESC; 
--    SHOULD BE 7 STUDENTS 

SELECT  lastname, firstname
FROM student
WHERE major = 'Biology' AND 
      GPA >= 3.0 AND GPA <= 3.5
ORDER BY lastname;

-- 2. Summarize the student data by major.  For each major show the number of students 
--    with that major and the average GPA of students.  The column headings should be 
--    “major”, “numberOfStudents”, and “averageGPA”.
--    Return rows in order by major.
--    Use the SQL round function to round the averageGPA to 2 decimal points.

-- SELECT * FROM student ORDER BY major;
-- BIOLOGY = 15
-- CS = 10
-- MATH = 10

SELECT  major, COUNT(*) as numberOfStudents, ROUND(AVG(GPA), 2) as averageGPA
FROM student 
GROUP BY major
ORDER BY major;

-- 3. What are the last and first names of students and their letter grade who took “Discrete Math” 
--    with a grade of “B” or “A”?
--    Return rows in order by last name.

-- check the student id in student with student id in enrollment, courseid in enrollment and courseid in course where name of course is 'discrete math'
-- check enrollment the grades are either B or A or above 3.0 

SELECT s.lastname, s.firstname, e.grade
FROM student s, enrollment e, course c, grade g
WHERE s.studentid = e.studentid AND 
	  e.courseid = c.courseid AND 
      e.grade = g.grade AND
      c.name = 'Discrete Math' AND
      g.points >= 3.0
ORDER BY lastname;

-- DEBUG
-- select * from student;
-- select * from semester;
-- select * from course order by courseid;  
-- select * from grade;
-- select * from enrollment order by courseid;

-- SELECT s.lastname, s.firstname, c.name
-- FROM student s, enrollment e, course c
-- WHERE s.studentid = e.studentid AND 
	  -- e.courseid = c.courseid AND 
      -- c.name = 'Discrete Math'
-- ORDER BY lastname;

-- students who took discrete math
-- result: 20 students are taking discrete math 
-- 15 have either b or a 

-- 4. For each course, return courseid, course name and the count of enrolled students. 
--    If a course has no enrollments, a count of 0 should appear.  
--    Return rows sorted by courseid.

-- 	  DEBUG MUST SHOW 21 courses including 0 w/ 0
--    Need to use left join to join 2 tables 

SELECT c.courseid, c.name as coursename, IFNULL(COUNT(e.studentid), 0) as enrolledstudents
FROM course c
LEFT JOIN enrollment e ON c.courseid = e.courseid
GROUP BY c.courseid, c.name
ORDER BY c.courseid;

-- 5. Who are the students (list their lastname and firstname) enrolled in ’Calculus 2’ 
--    who did not take and pass (with a grade of C or better) 
--    the required prerequisite course ’Calculus 1’?   
--    List the students in order by lastname.

--    DEBUG
--    Should just show 1 result (Foggle)
--    1. find out of those students, who took calculus 1 and received D or F
--    2. find students enrolled in calculus 2

SELECT s.lastname, s.firstname 
FROM student s 
JOIN (SELECT e.studentid
	  FROM enrollment e
	  WHERE e.grade IN ('D', 'F') AND 
            courseid IN (SELECT courseid
					     FROM course c
					     WHERE name = 'Calculus 1')) t
	  ON t.studentid = s.studentid
      AND s.studentid IN (SELECT studentid
					     FROM enrollment e
                         WHERE courseid IN (SELECT courseid
										    FROM course c
                                            WHERE c.name = 'Calculus 2'))
ORDER BY lastname;
						
-- 6. There are 3 professors who teach Calculus 1: Smith, Lupin and Fenwick.
--    Find the number of students who took Calculus 1 with each of the professors.
--    Calculate the average grade in Calculus 1 for each professor rounded to 2 digits.
--    Use a join with the "grade" table to convert letter grade into a number that can be averaged.
--    You may assume that a student does not take Calculus 1 more than 1 time.
--    The result table should be: Calc1Instructor CountStudents AvgGradeCalc1
SELECT c.instructor as Calc1Instructor, COUNT(DISTINCT e.studentid) as CountStudents, ROUND(AVG(g.points),2) as AvgGradeCalc1
FROM course c, enrollment e, grade g
WHERE c.courseid = e.courseid AND 
      e.grade = g.grade AND
      c.name = 'Calculus 1'
GROUP BY c.instructor;

-- 7. A continuation of problem 6.
--    Find for each professor, how many of their Calculus 1 students went on to take Calculus 2.
--    You may assume that a student does not take Calculus 2 more than 1 time.
--    The result table should be 
--    Calc1Instructor CountStudentsCalc2  
SELECT c.instructor as Calc1Instructor, COUNT(DISTINCT e.studentid) as CountStudentsCalc2
FROM enrollment e
JOIN course c ON e.courseid = c.courseid 
AND e.courseid IN (SELECT courseid 
                   FROM course 
                   WHERE name = 'Calculus 1')
JOIN enrollment e2 ON e.studentid = e2.studentid
AND e2.courseid IN(SELECT courseid
                   FROM course 
                   WHERE name = 'Calculus 2')
GROUP BY c.instructor;

-- 8. Write an SQL select that would return a transcript data for a student with
--    studentid 3729.  That is all courses taken by student 3729.
--    The result have the column names
--          Semester   'Fall' or 'Spring' 
--          Year       2016 or 2017 
--          courseid  
--          name       course name 
--          grade      letter  grade  A , B etc. 
--          units     
--    The list of courses should be chronological order:  
--    that is 2017 Spring comes before 2017 Fall. 
--    hint: use the semester table to get the correct sort sequence
--    Use the SQL substring function to get Semester, Year as separate columns.
SELECT LEFT(e.semester,char_length(e.semester) - 4) as Semester, RIGHT(e.semester, 4) as Year, e.CourseId, c.Name, e.Grade, e.Units
FROM course c, enrollment e, semester s
WHERE e.courseid = c.courseid AND 
      s.semester = e.semester AND
      e.studentid = '3729'
ORDER BY s.sequence; 

-- 9. To enroll in Discrete Math, a student cannot have already taken and passed the course
--    with a grade of 'C' or better,  AND the student cannot take the course more than 2 times. 
--    Code an SQL statement that returns a list of studentids who CANNOT enroll in 
--    Discrete Math.  The list should contain only studentId in order by studentId.
--    [ hint: use group by studentId ]

-- WHO CAN'T ENROLL ARE:
-- STUDENTS WHO PASSED THE COURSE WITH A B or C 
-- STUDENT WHO HAVE FAILED WITH D OR F AND have taken the class 2 or more times

-- Students who have passed Discrete Math with a C or higher
SELECT e.studentid
FROM enrollment e, course c
WHERE c.courseid = e.courseid and
      c.name = 'discrete math' and 
      e.grade in ('A', 'B', 'C') 
GROUP BY e.studentid
UNION
-- Students who have failed Discrete Math with a D or F
-- can't be enrolled more than twice
SELECT e.studentid
FROM enrollment e, course c
WHERE c.courseid = e.courseid and
      c.name = 'discrete math' and 
      e.grade in ('D', 'F') 
GROUP BY e.studentid
HAVING COUNT(e.studentid) > 1
ORDER BY studentid;

-- DEBUG
-- 305 rows
-- SELECT * 
-- FROM enrollment;

-- students who have taken discrete math (40132)
-- 20 students
-- select distinct e.studentid, e.courseid, e.semester, c.name, e.grade
-- from enrollment e, course c
-- where e.courseid = c.courseid and c.name = 'discrete math' 
-- order by e.studentid;

-- students who have taken discrete math AND have grades of a, b, or c
-- 16 students

--    10. Write a SQL update statement that changes the grade for studentid 4456 who
--    enrolled in Discrete Math in semester ‘Spring2017’.  Change the grade to B 
--    only if the current grade is C.    
--    Your answer should be a single SQL update statement
--    that use a subselect to find the courseid for 'Discrete Math'.
update enrollment e
SET e.grade = 'B'
WHERE e.studentid = '4456'
AND e.courseid IN (SELECT c.courseid
				   FROM course c
                   WHERE c.name = 'Discrete Math')
AND e.semester = 'Spring2017'
AND e.grade = 'C';
