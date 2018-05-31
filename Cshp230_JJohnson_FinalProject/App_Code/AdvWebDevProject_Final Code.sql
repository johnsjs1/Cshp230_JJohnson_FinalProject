/***************************************************
Title: AdvWebDevProject.sql
Dev:
Date:
Desc: This script creates of 
  the AdvWebDevProject database, and all
  of the objects within it, requiered for 
  the project. If you wish to do more the 
  the minimum you will have to add more code.

ChangeLog: (Who, When, What)
RRoot, End of Project, 
Added new code to match the website at the end of 
this file.
***************************************************/


/****** -- Create Database -- *****/
USE [master]
IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'AdvWebDevProject')
  BEGIN
    EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'AdvWebDevProject'
    ALTER DATABASE [AdvWebDevProject] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE [AdvWebDevProject]
  END
GO
 
CREATE DATABASE AdvWebDevProject
GO

USE AdvWebDevProject
GO

/****** -- Create Tables -- *****/
-- dbo.Classes -- Needed for Project
CREATE TABLE [dbo].[Classes](
	[ClassId] [int] NOT NULL,
	[ClassName] [nvarchar](100) NOT NULL,
	[ClassDate] [datetime] NOT NULL,
	[ClassDescription] [nvarchar](2000) NOT NULL,
 CONSTRAINT [PK_Classes] PRIMARY KEY CLUSTERED 
  (	[ClassId] ASC )
 )
GO

-- dbo.Students -- Needed for Project
CREATE TABLE [dbo].[Students](
	[StudentId] [int] NOT NULL,
	[StudentName] [nvarchar](100) NOT NULL,
	[StudentEmail] [nvarchar](100) NOT NULL,
	[StudentLogin] [nvarchar](50) NULL,
	[StudentPassword] [nvarchar](50) NULL,
 CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED 
  (	[StudentId] ASC )
)
GO

-- dbo.ClassStudents -- Needed for Project
CREATE TABLE [dbo].[ClassStudents](
	[ClassId] [int] NOT NULL,
	[StudentId] [int] NOT NULL,
 CONSTRAINT [PK_ClassStudents] PRIMARY KEY CLUSTERED 
  (	[ClassId] ASC, [StudentId] ASC )
) 
  -- Adds  FOREIGN KEY:
  ALTER TABLE [dbo].[ClassStudents]  WITH CHECK ADD  CONSTRAINT [FK_ClassStudents_Classes] FOREIGN KEY([ClassId])
  REFERENCES [dbo].[Classes] ([ClassId])
  GO
  ALTER TABLE [dbo].[ClassStudents]  WITH CHECK ADD  CONSTRAINT [FK_ClassStudents_Students] FOREIGN KEY([StudentId])
  REFERENCES [dbo].[Students] ([StudentId])
GO

-- dbo.LoginRequests -- Needed for Project
CREATE TABLE [dbo].[LoginRequests](
	[LoginId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[EmailAddress] [nvarchar](50) NOT NULL,
	[LoginName] [nvarchar](50) NOT NULL,
	[NewOrReactivate] [nvarchar](50) NOT NULL,
	[ReasonForAccess] [nvarchar](50) NOT NULL,
	[DateNeededBy] [datetime] NULL,
 CONSTRAINT [PK_LoginRequests] PRIMARY KEY CLUSTERED 
  (	[LoginId] ASC )
) 
GO

/****** -- Create Views -- *****/
-- Abstraction Views --
-- dbo.vClasses
Go
Create View vClasses
AS
SELECT [ClassId], [ClassName], [ClassDate], [ClassDescription] FROM [Classes]
Go
-- dbo.vStudents
-- dbo.vClassStudents
-- dbo.vLoginRequests
-- dbo.vClassesByStudents -- Needed for Project


/****** -- Create Stored Procedures -- *****/
-- Transaction Sprocs --

-- Create Insert Sprocs:
-- dbo.pInsClasses
-- dbo.pInsStudents

-- dbo.pInsClassStudents -- Needed for Project
GO
CREATE --DROP
PROCEDURE dbo.pInsClassStudents ( 
  @ClassId int
, @StudentId int
)
AS
/***************************************************
Dev: RRoot
Date: Nov, 10, 2011
Desc: This stored procedure adds data to the 
ClassStudents table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
       INSERT INTO [AdvWebDevProject].[dbo].[ClassStudents]
               ([ClassId]
               ,[StudentId]
               )
         VALUES
              (@ClassId
              ,@StudentId
              );
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @Message nVarchar(1000);
    SELECT @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
GO

--dbo.pInsLoginRequests
--dbo.pInsStudents

-- Create Updates Sprocs:
-- dbo.pUpdClasses
-- dbo.pUpdStudents
-- dbo.pUpdClassStudents -- Needed for Project
GO
CREATE -- DROP
PROCEDURE dbo.pUpdClassStudents ( 
  @OriginalClassId int
, @OriginalStudentId int
, @NewClassId int
, @NewStudentId int
)
AS
/***************************************************
Dev: RRoot
Date: Nov, 10, 2011
Desc: This stored procedure changes data in the 
ClassStudents table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
    UPDATE [AdvWebDevProject].[dbo].[ClassStudents]
     SET [ClassId] = @NewClassId
          , [StudentId] = @NewStudentId
     WHERE  [ClassId] = @OriginalClassId
     AND [StudentId] = @OriginalStudentId;
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @Message nVarchar(1000);
    SELECT @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
GO

--dbo.pUpdLoginRequests

-- Create Deletes Sprocs:
-- dbo.pDelClasses
-- dbo.pDelStudents
-- dbo.pDelClassStudents -- Needed for Project
GO
CREATE -- DROP
PROCEDURE dbo.pDelClassStudents ( 
  @ClassId int
, @StudentId int
)
AS
/***************************************************
Dev: RRoot
Date: Nov, 10, 2011
Desc: This stored procedure removes data in the 
ClassStudents table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
    DELETE FROM [AdvWebDevProject].[dbo].[ClassStudents]
     WHERE  [ClassId] = @ClassId
     AND [StudentId] = @StudentId;
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @Message nVarchar(1000);
    SELECT @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
GO

-- dbo.pDelLoginRequests

-- Reporting Sprocs --
GO
CREATE --DROP
PROCEDURE dbo.pSelClassesByStudents 
AS
SELECT 
      [Students].[StudentId]
    , [Students].[StudentName]
    , [Students].[StudentEmail]
    , [Classes].[ClassId]
    , [Classes].[ClassName]
    , [Classes].[ClassDate]
    , [Classes].[ClassDescription]
  FROM  Classes 
  INNER JOIN ClassStudents 
    ON Classes.ClassId = ClassStudents.ClassId 
  INNER JOIN Students 
    ON ClassStudents.StudentId = Students.StudentId
GO



--dbo.pSelLoginIdByLoginAndPassword -- Needed for Project
Go
CREATE -- DROP
PROCEDURE dbo.pSelLoginIdByLoginAndPassword( 
  @StudentLogin nVarchar(50)
, @StudentPassword nVarchar(50)  
, @StudentId int Out
)
AS
/***************************************************
Dev: RRoot
Date: Nov, 10, 2011
Desc: This stored procedure outputs a student Id 
  based on a given login and password
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    --BEGIN TRANSACTION;
    ------------------- Transaction Statement:
    SELECT @StudentId = [StudentId]
      FROM [AdvWebDevProject].[dbo].[Students]
      WHERE [StudentLogin] = @StudentLogin
      AND [StudentPassword] = @StudentPassword;
    ------------------- Transaction Statement;
    --COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    --ROLLBACK TRANSACTION;
    DECLARE @Message nVarchar(1000);
    SELECT @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
GO


/****** -- Testing Code -- *****/
-- Add Test Data to tables:
Insert into dbo.Classes ( ClassId,	ClassName,	ClassDate,	ClassDescription )
  Values (1,	'HTML',	'2011-01-01',	'Simple HTML class' )
Insert into dbo.Classes ( ClassId,	ClassName,	ClassDate,	ClassDescription )
  Values (2,	'CSS',	'2011-01-01',	'Basic CSS class' )
GO  
Insert into dbo.Students ( StudentId,	StudentName,	StudentEmail,	StudentLogin,	StudentPassword)
  Values ( 1,'Bob Smith','BSmith@Hotmail.com','BSmith01','Pa$$word' )
Insert into dbo.Students ( StudentId,	StudentName,	StudentEmail,	StudentLogin,	StudentPassword)
  Values ( 2	,'Sue Jones',	'SJones@Gmail.com','SJones01','Te$ting' )
GO
--Insert into dbo.ClassStudents ( )
--  Values ( )


--Insert into dbo.LoginRequests ( )
--  Values ( )

-- Select on Views:
-- Abstraction Views --
-- Select * From dbo.vClasses
-- Select * From dbo.vStudents
-- Select * From dbo.vClassStudents
-- Select * From dbo.vLoginRequests



-- Execute Insert Sprocs:
-- Execute dbo.pInsClasses
-- Execute dbo.pInsStudents

--Execute dbo.pInsClassStudents -- Needed for Project
Select * from dbo.ClassStudents; -- Before
DECLARE	@return_value int;
EXEC	@return_value = [dbo].[pInsClassStudents]
		@ClassId = 2,
		@StudentId = 1;
SELECT	'Return Value' = @return_value;
Select * from dbo.ClassStudents; -- After
GO
--Execute dbo.pInsLoginRequests


-- Execute Update Sprocs:
-- Execute dbo.pUpdClasses
-- Execute dbo.pUpdStudents

--Execute dbo.pUpdClassStudents -- Needed for Project
Select * from dbo.ClassStudents; -- Before
DECLARE	@return_value int
EXEC	@return_value = [dbo].[pUpdClassStudents]
		@OriginalClassId = 2,
		@OriginalStudentId = 1,
		@NewClassId = 2,
		@NewStudentId = 2
SELECT	'Return Value' = @return_value
Select * from dbo.ClassStudents; -- After
GO
--Execute dbo.pUpdLoginRequests


-- Execute Delete Sprocs:
-- Execute dbo.pDelClasses
-- Execute dbo.pDelStudents

--Execute dbo.pDelClassStudents -- Needed for Project
Select * from dbo.ClassStudents; -- Before
DECLARE	@return_value int
EXEC	@return_value = [dbo].[pDelClassStudents]
		@ClassId = 2,
		@StudentId = 1
SELECT	'Return Value' = @return_value
Select * from dbo.ClassStudents; -- After
GO
-- Execute dbo.pDelLoginRequests


-- Execute Reporting Sprocs:
EXEC dbo.pSelClassesByStudents  -- Needed for Project

-- Execute dbo.pSelClassesByStudentID
-- Execute dbo.pSelLoginIdByLoginAndPassword -- Needed for Project
DECLARE	@return_value int;
DECLARE	@Id int;
EXEC	@return_value = [dbo].[pSelLoginIdByLoginAndPassword]
		@StudentLogin = N'BSmith01',
		@StudentPassword = N'Pa$$word',
		@StudentId = @Id OUTPUT;
SELECT	@Id as N'@StudentId';
SELECT	'Return Value' = @return_value;



/************* NEW CODE ****************/
-----------------------------------------

-- dbo.pSelClassesByStudentID
Go
CREATE --DROP
PROCEDURE [dbo].[pSelClassesByStudentID]
(@StudentId int) 
AS
SELECT 
      [Students].[StudentId]
    , [Students].[StudentName]
    , [Students].[StudentEmail]
    , [Classes].[ClassId]
    , [Classes].[ClassName]
    , [Classes].[ClassDate]
    , [Classes].[ClassDescription]
  FROM  Classes 
  INNER JOIN ClassStudents 
    ON Classes.ClassId = ClassStudents.ClassId 
  INNER JOIN Students 
    ON ClassStudents.StudentId = Students.StudentId
WHERE [Students].[StudentId] = @StudentId;
GO

GO 
CREATE PROC pInsLoginRequest
(
	@Name [nvarchar](50) ,
	@EmailAddress [nvarchar](50) ,
	@LoginName [nvarchar](50),
	@NewOrReactivate [nvarchar](50),
	@ReasonForAccess [nvarchar](50) ,
	@DateNeededBy datetime
)
/**************************************************
Dev: RRoot
OriginalDate: Sept 4 2009 
ChangeLog: (Who, When, What)
	RRoot,Oct 10 2010,Added Try-Catch code.
**************************************************/
AS
Begin
DECLARE @RC int;
	Begin Try
		Begin Tran
			INSERT INTO [dbo].[LoginRequests]
                ([Name]
				,[EmailAddress]
				,[LoginName]
				,[NewOrReactivate]
				,[ReasonForAccess]
				,[DateNeededBy])
			VALUES
				(
					@Name ,
					@EmailAddress,
					@LoginName,
					@NewOrReactivate,
					@ReasonForAccess,
					@DateNeededBy
				)
		Commit Tran		
		Set @RC = 100
	End Try
	Begin Catch
		Rollback Tran
		Set @RC = -100	
	End Catch
	RETURN @RC
End
GO
		