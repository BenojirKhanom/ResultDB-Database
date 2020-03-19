use master
GO
USE ResultDB;
Go
---------- table---------
    select * from StudentCopy;
	select * from Faculty;
	select * from Course;
	select * from StudentCourse;

-----------index-----------------
GO
EXEC  sp_helpindex StudentCopy;
GO

-----------view--------------
SELECT * FROM VW_Result;
GO

 --------------------------JOIN QUERY-----------------------------------------

 SELECT StudentCopy.StudentID, StudentFName+' '+StudentLName as studentFullName,
        Course.CourseID,CourseName as Course,Gread,FacultyName as Faculty,FacultyPhone
from StudentCopy  join StudentCourse on StudentCopy.StudentID = StudentCourse.StudentID 
				  join Course  on Course.CourseID = StudentCourse.CourseID 
				  join Faculty on Faculty.FacultyID = Course.FacultyID;
GO
   --------------------------SubQUERY-----------------------------------------
SELECT StudentCopy.StudentID, StudentFName+' '+StudentLName as studentFullName,
       Course.CourseID,CourseName as Course,Gread,FacultyName as Faculty,FacultyPhone
from StudentCopy  join StudentCourse on StudentCopy.StudentID = StudentCourse.StudentID 
				  join Course  on Course.CourseID = StudentCourse.CourseID 
				  join Faculty on Faculty.FacultyID = Course.FacultyID
where Course.CourseID in (SELECT CourseID FROM Course WHERE CourseName = 'SQL');

GO 


-------------------------------Scaler Function------------------------------------
INSERT INTO StudentCopy
Values
	('Sharmin','Rumpa');
GO
SELECT * FROM StudentCopy;
GO

-------------------------------TRIGGER---------------------------------------------

INSERT INTO Faculty         
Values 
('Lenin Chowdhory','01710434370');
GO 
-------------------------------StoredProcedure--------------------------------------------


------------- INSERT
 EXEC sp_Get_New_StudentCopy 'Benojir','Khanom'
 GO
 SELECT * FROM StudentCopy
 GO


----------------Updae
  GO
  EXEC sp_Update_New_StudentCopy 3, 'Rokaya', 'Akter'
  GO
  SELECT * FROM StudentCopy

  GO
    --Create a complete copy of the 'StudentCopy' Table.
SELECT * FROM Old_StudentCopy;

GO
--A Union that combines 'StudentCopy' from two different tables.
	Select 'Old Student' AS Source, StudentID, StudentFName, StudentLName 
	From Old_StudentCopy
UNION
	Select 'StudentCopy' AS Source, StudentID, StudentFName, StudentLName
	From StudentCopy
Order by StudentFName asc;

GO
--Create Common Table Expressions ----------------------------
With CTE1 AS
(
	Select SC.StudentID, Concat(StudentFName, ' ', StudentLName) AS StudentName,  CourseName
	From StudentCopy SC JOIN StudentCourse SCR ON SC.StudentID = SCR.StudentID
						JOIN Course ON SCR.CourseID = Course.CourseID
),
CTE2 AS
(
	Select SC.StudentID, FacultyName, FacultyPhone, Gread 
	From StudentCopy SC JOIN StudentCourse SCR ON SC.StudentID = SCR.StudentID
						JOIN Course ON SCR.CourseID = Course.CourseID
						JOIN Faculty ON Faculty.FacultyID = Course.FacultyID
)
Select CTE1.StudentID, StudentName, CourseName, FacultyName, FacultyPhone, Gread 
From CTE1 JOIN CTE2 ON CTE1.StudentID = CTE2.StudentID;		
--------------------------END---------------------------------------------

