Use master
GO
IF DB_ID ('ResultDB') IS NOT NULL
DROP DATABASE ResultDB;
GO 
CREATE DATABASE ResultDB  
ON   ( 
		Name= 'ResultDB_data',
		FileName= 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ResultDB.mdf',
		Size= 20MB,
		MaxSize=1GB,
		FileGrowth= 10%
	 ) 
LOG ON 
	 (
		Name= 'ResultDB_log',
		FileName= 'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\ResultDB.ldf',
		Size= 20MB,
		MaxSize=1GB,
		FileGrowth= 10% 
	 );
GO
	 USE ResultDB;

	 GO

   CREATE TABLE StudentCopy 
(  StudentID INT identity Primary Key NOT NULL,
   StudentFName varchar (30) NOT NULL,
   StudentLName varchar (30) NOT NULL,
);
	
	CREATE TABLE Faculty
(	FacultyID INT identity Primary Key NONCLUSTERED NOT NULL,
	FacultyName Varchar(30) NOT NULL,
	FacultyPhone Varchar(30) NOT NULL
);

	CREATE TABLE Course 
(   CourseID INT Primary Key NOT NULL,
	FacultyID INT NOT NULL REFERENCES Faculty(FacultyID),
	CourseName Varchar (30) NOT NULL
);
	CREATE TABLE StudentCourse 
(	StudentID INT NOT NULL REFERENCES StudentCopy(StudentID),
	CourseID INT NOT NULL REFERENCES Course(CourseID),
	Gread Char (1) NOT NULL,
	Primary Key (StudentID,CourseID)
	);
	GO
	
	INSERT INTO StudentCopy(StudentFName,StudentLName)
	Values 
	('Imran','Hossain'),('Robiul','Hossain'),('Julhas', 'Hossain'),('Ala','Uddin'),('Alauddin','Jafor'),
	('Arif','Hossain'),('Sarower', 'Hossain'),('Mohiulla','Uddin'),('Anisul','Hasan'),('Masud','Ahamed'),
	('Akram', 'Ahamed'),('Torikul','Islam'),('Rofikul','Hossain'),('Saiful','islam'),('Jubaier', 'Hossain'),
	('Mohasin','Ali'),('Forhal','Ulla'),('Mafujur','Rohoman'),('Rakin', 'Hossain'),('Nazim','Uddin'),
	('Rubel','Islam'),('Iasin','Arafat'),('Iasin', 'Hossain'),('Munna','khan');
	

	INSERT INTO Faculty(FacultyName,FacultyPhone)
	Values 
	('Moinul Hasan'		,	'01710134371'),
	('Bari hossain'		,	'01710424372'),
	('Jahidul Hasan'	,	'01910433373'),
	('Ahasan Habib'		,	'01910435374'),
	('Mosaedur Rhoman'	,	'01610444375'),
	('Soriful Hossain'	,	'01610434366'),
	('Jillur Rhoman'	,	'01510434377'),
	('Mostafijur Islam'	,	'01510434378');

	INSERT INTO Course(CourseID,FacultyID,CourseName)
	Values
	('101','1','SQL'),
	('102','2','Java'),
	('103','3','PHP'),
	('104','4','C#'),
	('105','5','HTML'),
	('106','6','GAVE'),
	('107','7','Web Degain'),
	('108','8','NT');
	
	INSERT INTO StudentCourse(StudentID,CourseID,Gread)
	Values
	('1','101','A'),('2','101','C'),('3','102','A'),('4','102','B'),
	('5','103','A'),('6','103','B'),('7','104','C'),('8','104','B'),
	('9','105','B'),('10','105','A'),('11','106','A'),('12','106','B'),
	('13','107','C'),('14','107','A'),('15','108','A'),('16','108','B'),
	('17','101','A'),('18','102','C'),('19','103','B'),('20','104','B'),
	('21','105','A'),('22','106','C'),('23','107','A'),('24','108','B');
	-------------------------------------------------
	
	
	----------------- INDEX------------------------

CREATE CLUSTERED INDEX IX_Faculty_FacultyName ON Faculty(FacultyName);


 --------------------------CreateView-----------------------------------------
 Go
CREATE VIEW VW_Result As 
SELECT StudentCopy.StudentID, StudentFName+' '+StudentLName as studentFullName,
       Course.CourseID,CourseName as Course,Gread,FacultyName as Faculty,FacultyPhone
from StudentCopy  join StudentCourse on StudentCopy.StudentID = StudentCourse.StudentID 
				  join Course  on Course.CourseID = StudentCourse.CourseID 
				  join Faculty on Faculty.FacultyID = Course.FacultyID
where Course.CourseID = 104;
GO 


-------------------------------Scaler Function------------------------------------
CREATE FUNCTION dbo.GetNewStudentID (@StudentID int) 
RETURNS Varchar(30)
AS
BEGIN
RETURN(SELECT StudentFName+' '+StudentLName as studentFullName FROM StudentCopy WHERE StudentID = @StudentID)
END
GO


-------------------------------TRIGGER---------------------------------------------
CREATE TRIGGER tr_new_Faculty
ON Faculty
AFTER INSERT
AS
BEGIN 
SELECT * FROM inserted
END
GO 

-------------------------------StoredProcedure--------------------------------------------


------------- INSERT

CREATE PROC sp_Get_New_StudentCopy
(
 @StudentFName Varchar (30),
 @StudentLName Varchar (30)
 )
 AS
 INSERT INTO StudentCopy
 (StudentFName,StudentLName)
 Values
 (@StudentFName,@StudentLName);
 GO


 ----------------- UPDATE
create PROCEDURE sp_Update_New_StudentCopy
 @StudentID int,
  @StudentFName Varchar (30),
  @StudentLName Varchar (30)
  
  AS
  Update StudentCopy SET
  StudentFName = @StudentFName,
  StudentLName = @StudentLName
  WHERE
  StudentID=@StudentID;
  GO


  --Create a complete copy of the 'StudentCopy' Table.
Select * 
INTO Old_StudentCopy
FROM StudentCopy;
-----------------------end-------------------------

















