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
RRoot, 10/5/2017, Added new code to match the website at the end of this file.
RRoot, 23/5/2018, Added additional code to cover for all sprocs and views.
RRoot, 29/5/2018, Added code to create a CSharp login and user if it does not exist 
***************************************************/
Set NoCount On -- turns of the (1 row affected) messages

/****** -- Create Database -- *****/
USE [master]
IF  EXISTS (Select name From sys.databases Where name = N'AdvWebDevProject')
  BEGIN
    EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'AdvWebDevProject'
    ALTER DATABASE [AdvWebDevProject] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE [AdvWebDevProject]
  END
Go
 
CREATE DATABASE AdvWebDevProject
Go

USE AdvWebDevProject
Go

/****** -- Create Tables -- *****/
-- dbo.Classes -- Required for Project
CREATE TABLE [dbo].[Classes](
	[ClassId] [int] NOT NULL,
	[ClassName] [nvarchar](100) NOT NULL,
	[ClassDate] [datetime] NOT NULL,
	[ClassDescription] [nvarchar](2000) NOT NULL,
 CONSTRAINT [PK_Classes] PRIMARY KEY CLUSTERED 
  (	[ClassId] ASC )
 )
Go

-- dbo.Students -- Required for Project
CREATE TABLE [dbo].[Students](
	[StudentId] [int] NOT NULL,
	[StudentName] [nvarchar](100) NOT NULL,
	[StudentEmail] [nvarchar](100) NOT NULL,
	[StudentLogin] [nvarchar](50) NULL,
	[StudentPassword] [nvarchar](50) NULL,
 CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED 
  (	[StudentId] ASC )
)
Go

-- dbo.ClassStudents -- Required for Project
CREATE TABLE [dbo].[ClassStudents](
	[ClassId] [int] NOT NULL,
	[StudentId] [int] NOT NULL,
 CONSTRAINT [PK_ClassStudents] PRIMARY KEY CLUSTERED 
  (	[ClassId] ASC, [StudentId] ASC )
) 
  -- Adds  FOREIGN KEY:
  ALTER TABLE [dbo].[ClassStudents] WITH CHECK ADD CONSTRAINT [FK_ClassStudents_Classes] FOREIGN KEY([ClassId])
  REFERENCES [dbo].[Classes] ([ClassId])
  Go
  ALTER TABLE [dbo].[ClassStudents] WITH CHECK ADD CONSTRAINT [FK_ClassStudents_Students] FOREIGN KEY([StudentId])
  REFERENCES [dbo].[Students] ([StudentId])
Go

-- dbo.LoginRequests -- Required for Project
CREATE TABLE [dbo].[LoginRequests](
	[LoginId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[EmailAddress] [nvarchar](50) NOT NULL,
	[LoginName] [nvarchar](50) NOT NULL,
	[NewOrReactivate] [nvarchar](50) NOT NULL,
	[ReasonForAccess] [nvarchar](50) NOT NULL,
	[DateRequiredBy] [datetime] NULL,
 CONSTRAINT [PK_LoginRequests] PRIMARY KEY CLUSTERED 
  (	[LoginId] ASC )
) 
Go

/****** -- Load Test Data -- *****/
-- [dbo].[Classes]
Insert into dbo.Classes ( ClassId,	ClassName,	ClassDate,	ClassDescription )
  Values (1,	'HTML',	'2011-01-01',	'Simple HTML class' )
Insert into dbo.Classes ( ClassId,	ClassName,	ClassDate,	ClassDescription )
  Values (2,	'CSS',	'2011-01-01',	'Basic CSS class' )
Go  
-- [dbo].[Students]
Insert into dbo.Students ( StudentId,	StudentName,	StudentEmail,	StudentLogin,	StudentPassword)
  Values ( 1,'Bob Smith','BSmith@Testmail.com','BSmith01','Pa$$word' )
Insert into dbo.Students ( StudentId,	StudentName,	StudentEmail,	StudentLogin,	StudentPassword)
  Values ( 2,'Sue Jones',	'SJones@Testmail.com','SJones01','Te$ting' )
Go
-- [dbo].[ClassStudents]
Insert Into dbo.ClassStudents ([ClassId], [StudentId])
  Values (1, 1 ), (2, 1), (2,2)
Go

-- [dbo].[LoginRequests]
INSERT INTO [dbo].[LoginRequests]([Name],[EmailAddress],[LoginName],[NewOrReactivate],[ReasonForAccess],[DateRequiredBy])
     VALUES('Joe James', 'JJames@Testmail.com','JJames', 'New', 'New Student', '20200101')
Go

/****** -- Create Views -- *****/
-- Abstraction Views --
-- dbo.vClasses
Go
Create View vClasses -- Required for Project
AS
Select [ClassId], [ClassName], [ClassDate], [ClassDescription] From [Classes]
Go

-- dbo.vStudents
Create View vStudents
AS
Select [StudentId], [StudentName], [StudentEmail], [StudentLogin], [StudentPassword] From [Students]
Go

-- dbo.vClassStudents
Create View vClassStudents
AS
Select [ClassId], [StudentId] From [ClassStudents]
Go

-- dbo.vLoginRequests
Create View vLoginRequests
AS
Select [LoginId], [Name], [EmailAddress], [LoginName], [NewOrReactivate], [ReasonForAccess], [DateRequiredBy] From [LoginRequests]
Go

-- dbo.vClassesByStudents -- Required for Project
Create View vClassesByStudents
AS
Select 
 C.[ClassId]
,C.[ClassName]
,C.[ClassDate]
,C.[ClassDescription]
,S.[StudentId]
,S.[StudentName]
,S.[StudentEmail]
From [Classes] as C
Join [ClassStudents] as CS
 On C.ClassId = CS.ClassId
Join [Students] as S
 On CS.StudentId = S.StudentId
Go

/****** -- Create Stored Procedures -- *****/
-- Transaction Sprocs --

-- Create Insert Sprocs:
-- dbo.pInsClasses
Go
CREATE --DROP
PROCEDURE dbo.pInsClasses ( 
  @ClassId int
, @ClassName nvarchar(100)
, @ClassDate datetime
, @ClassDescription nvarchar(2000)
)
AS
/***************************************************
Dev: RRoot
Date: May, 23, 2018
Desc: This stored procedure adds data to the Classes table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
       INSERT INTO [Classes]
               ([ClassId], [ClassName], [ClassDate], [ClassDescription])
         VALUES(@ClassId, @ClassName, @ClassDate, @ClassDescription);
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go

-- dbo.pInsStudents
Go
CREATE --DROP
PROCEDURE dbo.pInsStudents ( 
  @StudentId int
, @StudentName nvarchar(100)
, @StudentEmail nvarchar(100)
, @StudentLogin nvarchar(50)
, @StudentPassword nvarchar(50)
)
AS
/***************************************************
Dev: RRoot
Date: May, 23, 2018
Desc: This stored procedure adds data to the Students table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
       INSERT INTO [dbo].[Students]
               ([StudentId], [StudentName], [StudentEmail], [StudentLogin], [StudentPassword])
         VALUES(@StudentId, @StudentName, @StudentEmail, @StudentLogin, @StudentPassword);
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go


-- dbo.pInsClassStudents -- Required for Project
Go
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
               ([ClassId], [StudentId])
         VALUES(@ClassId, @StudentId);
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go

--dbo.pInsLoginRequests -- Required For Project
Go
CREATE --DROP
PROCEDURE [dbo].[pInsLoginRequests]( 
  @LoginID int OUTPUT -- Used to capture the Automated ID number
, @Name nvarchar (50)
, @EmailAddress nvarchar(50)
, @LoginName nvarchar(50)
, @NewOrReactivate nvarchar(50)
, @ReasonForAccess nvarchar(50)
, @DateRequiredBy datetime
)
AS
/***************************************************
Dev: RRoot
Date: May, 23, 2018
Desc: This stored procedure adds data to the LoginRequests table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
       INSERT INTO [dbo].[LoginRequests]
               ([Name], [EmailAddress], [LoginName], [NewOrReactivate], [ReasonForAccess], [DateRequiredBy])
         VALUES(@Name, @EmailAddress, @LoginName, @NewOrReactivate, @ReasonForAccess, @DateRequiredBy);
       Set @LoginID = @@IDENTITY; -- This will give back the new ID as output
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;


-- Create Updates Sprocs:
-- dbo.pUpdClasses
Go
CREATE --DROP
PROCEDURE dbo.pUpdClasses ( 
  @ClassId int
, @ClassName nvarchar(100)
, @ClassDate datetime
, @ClassDescription nvarchar(2000)
)
AS
/***************************************************
Dev: RRoot
Date: May, 23, 2018
Desc: This stored procedure change data in the Classes table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
       Update [Classes]
         Set [ClassId] = @ClassId
           , [ClassName] = @ClassName
           , [ClassDate] = @ClassDate
           , [ClassDescription] = @ClassDescription
         Where ClassId = @ClassId;
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go

-- dbo.pUpdStudents
Go
CREATE --DROP
PROCEDURE dbo.pUpdStudents ( 
  @StudentId int
, @StudentName nvarchar(100)
, @StudentEmail nvarchar(100)
, @StudentLogin nvarchar(50)
, @StudentPassword nvarchar(50)
)
AS
/***************************************************
Dev: RRoot
Date: May, 23, 2018
Desc: This stored procedure change data in the Students table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
       Update [dbo].[Students]
        Set [StudentId] = @StudentId
          , [StudentName] = @StudentName
          , [StudentEmail] = @StudentEmail
          , [StudentLogin] = @StudentLogin
          , [StudentPassword] = @StudentPassword
        Where [StudentId] = @StudentId ;
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go

-- dbo.pUpdClassStudents
Go
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
     Where  [ClassId] = @OriginalClassId
     AND [StudentId] = @OriginalStudentId;
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go

--dbo.pUpdLoginRequests
Go
CREATE --DROP
PROCEDURE dbo.pUpdLoginRequests( 
  @LoginId int
, @Name nvarchar
, @EmailAddress nvarchar(50)
, @LoginName nvarchar(50)
, @NewOrReactivate nvarchar(50)
, @ReasonForAccess nvarchar(50)
, @DateRequiredBy datetime
)
AS
/***************************************************
Dev: RRoot
Date: May, 23, 2018
Desc: This stored procedure Change data in the LoginRequests table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
       Update [dbo].[LoginRequests]
        Set [Name] = @Name
          , [EmailAddress] = @EmailAddress
          , [LoginName] = @LoginName
          , [NewOrReactivate] = @NewOrReactivate
          , [ReasonForAccess] = @ReasonForAccess
          , [DateRequiredBy] = @DateRequiredBy
        Where  [LoginId] = @LoginId;
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go

-- Create Deletes Sprocs:
-- dbo.pDelClasses
Go
CREATE --DROP
PROCEDURE dbo.pDelClasses ( 
  @ClassId int
)
AS
/***************************************************
Dev: RRoot
Date: May, 23, 2018
Desc: This stored procedure Delete data in the Classes table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
       Delete From [Classes] Where ClassId = @ClassId;
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go

-- dbo.pDelStudents
Go
CREATE --DROP
PROCEDURE dbo.pDelStudents ( 
  @StudentId int
)
AS
/***************************************************
Dev: RRoot
Date: May, 23, 2018
Desc: This stored procedure Delete data in the Students table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
       Delete From [dbo].[Students] Where [StudentId] = @StudentId;
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go

-- dbo.pDelClassStudents 
Go
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
    DELETE From [AdvWebDevProject].[dbo].[ClassStudents]
     Where  [ClassId] = @ClassId
     AND [StudentId] = @StudentId;
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go

-- dbo.pDelLoginRequests
Go
CREATE --DROP
PROCEDURE dbo.pDelLoginRequests( 
  @LoginId int
)
AS
/***************************************************
Dev: RRoot
Date: May, 23, 2018
Desc: This stored procedure Delete data in the LoginRequests table 
ChangeLog: (Who, When, What)
***************************************************/
BEGIN -- Body of stored procedure:
  BEGIN TRY
    BEGIN TRANSACTION;
    ------------------- Transaction Statement:
       Delete From [dbo].[LoginRequests] Where [LoginId] = @LoginId;
    ------------------- Transaction Statement;
    COMMIT TRANSACTION;
    RETURN +100
  END TRY   
  BEGIN CATCH
    ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go

-- Reporting Sprocs --
Go
CREATE --DROP
PROCEDURE dbo.pSelClassesByStudents 
AS
Select 
      [Students].[StudentId]
    , [Students].[StudentName]
    , [Students].[StudentEmail]
    , [Classes].[ClassId]
    , [Classes].[ClassName]
    , [Classes].[ClassDate]
    , [Classes].[ClassDescription]
  From  Classes 
  INNER JOIN ClassStudents 
    ON Classes.ClassId = ClassStudents.ClassId 
  INNER JOIN Students 
    ON ClassStudents.StudentId = Students.StudentId
Go

-- dbo.pSelClassesByStudentId
Go
CREATE --DROP 
PROCEDURE [dbo].[pSelClassesByStudentId] -- Required for the project
(@StudentId int) 
/**************************************************
Dev: RRoot
OriginalDate: Sept 4 2009 
ChangeLog: (Who, When, What)
**************************************************/
AS
BEGIN -- Body of stored procedure:
  BEGIN TRY
    ------------------- Reporting Statement:
    Select 
          [Students].[StudentId]
        , [Students].[StudentName]
        , [Students].[StudentEmail]
        , [Classes].[ClassId]
        , [Classes].[ClassName]
        , [Classes].[ClassDate]
        , [Classes].[ClassDescription]
      From  Classes 
      INNER JOIN ClassStudents 
        ON Classes.ClassId = ClassStudents.ClassId 
      INNER JOIN Students 
        ON ClassStudents.StudentId = Students.StudentId
      Where [Students].[StudentId] = @StudentId;
     If(@@ROWCOUNT = 0) RaisError('No Login Found', 15, 1);
    ------------------- Reporting Statement;
    RETURN +100
  END TRY   
  BEGIN CATCH
    --ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go


--dbo.pSelLoginIdByLoginAndPassword -- Required for Project
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
    ------------------- Reporting Statement:
    Select @StudentId = [StudentId]
      From [AdvWebDevProject].[dbo].[Students]
      Where [StudentLogin] = @StudentLogin
      AND [StudentPassword] = @StudentPassword;
    If(@@ROWCOUNT = 0) RaisError('No Login Found', 15, 1);
    ------------------- Reporting Statement;
    RETURN +100
  END TRY   
  BEGIN CATCH
    --ROLLBACK TRANSACTION;
    Declare @Message nVarchar(1000);
    Select @Message = ERROR_MESSAGE();
    RAISERROR(@Message, 15, 1);     
    RETURN -100     
  END CATCH
END; -- Body of stored procedure;
Go

    
/****** -- Testing Code -- *****/
-- Test Inserts Sprocs
Declare @RC int = 0;
Exec @RC = [dbo].[pInsClasses]
             @ClassId = 3
           , @ClassName = 'C#'
           , @ClassDate = '2020-01-01'
           , @ClassDescription = 'Simple C# class'
Print '[dbo].[pInsClasses]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vClasses;
Go
Declare @RC int = 0;
Exec @RC = [dbo].[pInsStudents]
             @StudentId = 3
           , @StudentName = 'Jim James'
           , @StudentEmail = 'JJames@Testmail.com'
           , @StudentLogin = 'JJames'
           , @StudentPassword = '111aaa'
Print '[dbo].[pInsStudents]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vStudents;
Go

Declare @RC int = 0;
Exec @RC = [dbo].[pInsClassStudents]
             @ClassId = 2 -- CSS
           , @StudentId = 3 -- Jim James
Print '[dbo].[pInsClassStudents]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vClassStudents;
Select * From vClassesByStudents;
Go

Declare @RC int = 0;
Declare @NewLoginId int;
Exec @RC = [dbo].[pInsLoginRequests]
             @LoginId = @NewLoginId output
           , @Name = 'Nu Student'
           , @EmailAddress = 'NStudent@Testmail.com'
           , @LoginName =  'NStudent'
           , @NewOrReactivate = 'New'
           , @ReasonForAccess = 'New Student'
           , @DateRequiredBy = '20200101'
Print '[dbo].[pInsLoginRequests]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select @NewLoginId;
Select * From vLoginRequests;
Go


-- Test Update Sprocs
Declare @RC int = 0;
Exec @RC = [dbo].[pUpdClasses]
             @ClassId = 3
           , @ClassName = 'C#z'
           , @ClassDate = '2020-01-01'
           , @ClassDescription = 'Simple C# classz'
Print '[dbo].[pUpdClasses]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vClasses;
Go

Declare @RC int = 0;
Exec @RC = [dbo].[pUpdStudents]
             @StudentId = 3
           , @StudentName = 'Jim Jamesz'
           , @StudentEmail = 'JJames@Testmail.comz'
           , @StudentLogin = 'JJamesz'
           , @StudentPassword = '111aaaz'
Print '[dbo].[pUpdStudents]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vStudents;
Go

Declare @RC int = 0;
Exec @RC = [dbo].[pUpdClassStudents]
             @OriginalClassId = 2 -- CSS
           , @OriginalStudentId = 3 -- Joe James
           , @NewClassId = 1 -- HMTL
           , @NewStudentId = 3 -- Joe James
Print '[dbo].[pUpdClassStudents]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vClassStudents;
Select * From vClassesByStudents;
Go

Declare @RC int = 0;
Declare @LastID int;
Select @LastID = Max(LoginID) From vLoginRequests;
Exec @RC = [dbo].[pUpdLoginRequests]
             @LoginId = @LastID
           , @Name = 'Nu Studentz'
           , @EmailAddress = 'NStudent@Testmail.comz'
           , @LoginName =  'NStudentz'
           , @NewOrReactivate = 'Newz'
           , @ReasonForAccess = 'New Studentz'
           , @DateRequiredBy = '20100101'
Print '[dbo].[pUpdLoginRequests]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vLoginRequests;
Go

---- Test Delete Sprocs 
Declare @RC int = 0;
Declare @LastID int;
Select @LastID = Max(LoginID) From vLoginRequests;
Exec @RC = [dbo].[pDelLoginRequests]
             @LoginId = @LastID
Print '[dbo].[pDelLoginRequests]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vLoginRequests;
Go

Declare @RC int = 0;
Exec @RC = [dbo].[pDelClassStudents]
             @ClassId = 1
            ,@StudentId = 3
Print '[dbo].[pDelClassStudents]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vClassStudents;
Select * From vClassesByStudents;
Go

Declare @RC int = 0;
Exec @RC = [dbo].[pDelClasses]
             @ClassId = 3
Print '[dbo].[pDelClasses]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vClasses;
Go

Declare @RC int = 0;
Exec @RC = [dbo].[pDelStudents]
             @StudentId = 3
Print '[dbo].[pDelStudents]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vStudents;
Go

---- Execute Reporting Sprocs:
--EXEC dbo.pSelClassesByStudents -- Required for Project
Declare @RC int = 0;
Declare	@Id int = 1;
Execute @RC = dbo.pSelClassesByStudentId 
            @StudentID = @ID;
Select @RC
Print '[dbo].[pSelClassesByStudentId]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status

-- Execute dbo.pSelLoginIdByLoginAndPassword -- Required for Project
Go
Declare @RC int = 0;
Declare	@Id int = 0;
EXEC @RC = [dbo].[pSelLoginIdByLoginAndPassword]
		           @StudentLogin = N'BSmith01'
		         , @StudentPassword = N'Pa$$word'
		         , @StudentId = @Id OUTPUT;
Select @Id as N'@StudentId'; -- Show Output data
Select	'Return Value' = @RC; -- Show Return Code data
Print '[dbo].[pSelLoginIdByLoginAndPassword]: ' + IIF(@RC > 0, 'Passed', 'Failed') -- Check status
Select * From vStudents;

-- Set Permissions -- 
If Not Exists (Select Name From Master..Syslogins Where Name = 'CSharp')
 Begin 
   Exec sp_addlogin @loginame =  'CSharp' , @passwd = 'sql' 
 End
If Not Exists (Select Name From AdvWebDevProject..SysUsers Where Name = 'CSharp')
 Begin
   Exec sp_adduser @LogiName = 'CSharp', @Name_in_db = 'CSharp';
 End
go

-- Views --
Grant Select On [dbo].[vClasses] To Public; 
Grant Select On [dbo].[vClassesByStudents] To Public;
Grant Select On [dbo].[vLoginRequests] To Public; 
Grant Select On [dbo].[vStudents] To Public;
go

-- Stored Procedures --
Grant Exec On [dbo].[pDelClasses] To Public;
Grant Exec On [dbo].[pDelClassStudents] To Public;
Grant Exec On [dbo].[pDelLoginRequests] To Public;
Grant Exec On [dbo].[pDelStudents] To Public;
go

Grant Exec On [dbo].[pInsClasses] To Public;
Grant Exec On [dbo].[pInsClassStudents] To Public;
Grant Exec On [dbo].[pInsLoginRequests] To Public;
Grant Exec On [dbo].[pInsStudents] To Public;
go

Grant Exec On [dbo].[pSelClassesByStudentId] To Public;
Grant Exec On [dbo].[pSelClassesByStudents] To Public;
Grant Exec On [dbo].[pSelLoginIdByLoginAndPassword] To Public;
go
 
Grant Exec On [dbo].[pUpdClasses] To Public;
Grant Exec On [dbo].[pUpdClassStudents] To Public;
Grant Exec On [dbo].[pUpdLoginRequests] To Public;
Grant Exec On [dbo].[pUpdStudents] To Public; 