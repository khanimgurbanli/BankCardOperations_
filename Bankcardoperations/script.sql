USE [master]
GO
/****** Object:  Database [BankCardOperations]    Script Date: 11/11/2021 9:42:23 PM ******/
CREATE DATABASE [BankCardOperations]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BankCardOperations', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BankCardOperations.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BankCardOperations_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BankCardOperations_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [BankCardOperations] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BankCardOperations].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BankCardOperations] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BankCardOperations] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BankCardOperations] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BankCardOperations] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BankCardOperations] SET ARITHABORT OFF 
GO
ALTER DATABASE [BankCardOperations] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BankCardOperations] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BankCardOperations] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BankCardOperations] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BankCardOperations] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BankCardOperations] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BankCardOperations] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BankCardOperations] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BankCardOperations] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BankCardOperations] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BankCardOperations] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BankCardOperations] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BankCardOperations] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BankCardOperations] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BankCardOperations] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BankCardOperations] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BankCardOperations] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BankCardOperations] SET RECOVERY FULL 
GO
ALTER DATABASE [BankCardOperations] SET  MULTI_USER 
GO
ALTER DATABASE [BankCardOperations] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BankCardOperations] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BankCardOperations] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BankCardOperations] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BankCardOperations] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BankCardOperations] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BankCardOperations', N'ON'
GO
ALTER DATABASE [BankCardOperations] SET QUERY_STORE = OFF
GO
USE [BankCardOperations]
GO
/****** Object:  UserDefinedFunction [dbo].[Balance]    Script Date: 11/11/2021 9:42:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Balance](@card_number float,@pin nvarchar(50)) returns float
as
begin
declare @result float
set @result= (select [Balance] from Cards where CardNumber=@card_number and Pin=@pin);
 
return @result
end

GO
/****** Object:  UserDefinedFunction [dbo].[GenerateCode]    Script Date: 11/11/2021 9:42:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 create function [dbo].[GenerateCode](@ID float) returns float
as
begin
declare @result float
set   @result =RIGHT((@ID*RIGHT(@ID,6)),16);
return @result
END
GO
/****** Object:  Table [dbo].[Cards]    Script Date: 11/11/2021 9:42:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cards](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Surname] [nvarchar](50) NULL,
	[Birthdate] [nvarchar](30) NULL,
	[Email] [nvarchar](200) NULL,
	[Status] [int] NULL,
	[Pin] [int] NULL,
	[CardNumber] [decimal](18, 0) NULL,
	[Time] [datetime] NULL,
 CONSTRAINT [PK_Cards] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Operations]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Operations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CardNumber] [decimal](18, 0) NULL,
	[Amount] [decimal](19, 2) NULL,
	[Balance] [decimal](19, 2) NULL,
	[Status] [nchar](50) NULL,
	[Time] [datetime] NULL,
 CONSTRAINT [PK_Operations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Operator]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Operator](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OperatorCode] [int] NULL,
	[Status] [int] NULL,
	[Name] [nchar](50) NULL,
	[Surname] [nchar](50) NULL,
 CONSTRAINT [PK_Operator] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[AcceptCardRequest]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[AcceptCardRequest](@status int,@cardnumber decimal )
as
begin
declare @NewId int
     update Cards set Status=@status  where  CardNumber=@cardnumber

	select *  from Cards where CardNumber=@cardnumber 
end
GO
/****** Object:  StoredProcedure [dbo].[AddAmount]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[AddAmount](@addamount decimal(19,2),@card_number decimal, @add_date datetime,@tableStatus nvarchar(50))
as
begin
begin try
declare @status int
declare @balance decimal(19,2)

declare @sumaddamount decimal(19,2) 
declare @sumwithdrawamount decimal(19,2) 

select  @sumaddamount=SUM(Amount) from Operations where CardNumber=@card_number and status='The amount entered'
select  @sumwithdrawamount=SUM(Amount) from Operations where CardNumber=@card_number and status='The amount withdrawn'
set @balance=(coalesce(@sumaddamount,0)-coalesce(@sumwithdrawamount,0))+@addamount

    insert into Operations(CardNumber,Amount,Balance,Status,Time) values(@card_number,@addamount,@balance,@tableStatus,@add_date)
	set @status=1 
end try
begin catch
    set @status=0
end catch
select @status[Status]
end

GO
/****** Object:  StoredProcedure [dbo].[ChangeCardInfo]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ChangeCardInfo] (@CardNumber decimal,@Name nvarchar(50)=null,@Surname nvarchar(50)=null,@Birthdate date=null,@Email nvarchar(50)=null,@Pin int=null)
as
begin
Declare @Status int
Update Cards Set Name=@Name,Surname=@Surname,Birthdate=@Birthdate,Email=@Email,Pin=@Pin WHERE CardNumber=@CardNumber
Select * from Cards where CardNumber=@CardNumber
Set @Status =1
end
GO
/****** Object:  StoredProcedure [dbo].[ChangePin]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ChangePin](@Oldpin int,@Newpin int,@card_number decimal)
as
begin
 begin try
 declare @staus int
update Cards set Pin=@Newpin  where  CardNumber=@card_number and Pin=@Oldpin
select pin from cards where pin=@Newpin and CardNumber=@card_number
end try
 begin catch
 select pin from cards where pin=@Oldpin and CardNumber=@card_number
 end  catch
end
GO
/****** Object:  StoredProcedure [dbo].[CreateNewCard]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[CreateNewCard] (@Name nvarchar(50),@Surname nvarchar(50),@Birthdate nvarchar(30),@Email nvarchar(200),@Status int,@Time datetime )
as
begin
	begin try
	    declare @NewId int
		insert into Cards(Name,Surname,Birthdate,Email,Status,Time) values (@Name,@Surname,@Birthdate,@Email,@Status,@Time)
		set @NewId = SCOPE_IDENTITY()
	end try
	begin catch
		set @NewId = 0
	end catch
	select @NewId [NewId]
	exec [GenerateCodePin] @NewId
end

GO
/****** Object:  StoredProcedure [dbo].[CreateNewCardOperator]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[CreateNewCardOperator] (@Name nvarchar(50),@Surname nvarchar(50),@Birthdate nvarchar(30),@Email nvarchar(200),@Status int,@Time datetime)
as
begin
declare @NewId int
		insert into Cards(Name,Surname,Email,Birthdate,Status,Time) values (@Name,@Surname,@Email,@Birthdate,@Status,@Time)
		set @NewId = SCOPE_IDENTITY()
	
	select * from cards
	exec [GenerateCodePin] @NewId
end

GO
/****** Object:  StoredProcedure [dbo].[CustomerLogin]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[CustomerLogin](@CardNumber decimal,@Pin int) 
as
begin 
DECLARE @Status as int 
     if exists(select *  from Cards where CardNumber=@CardNumber and Pin=@pin)
   
	  set @Status= 1
	
	else
	
     set @Status= 0

	 select @Status [Status]
end


GO
/****** Object:  StoredProcedure [dbo].[DeleteCard]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[DeleteCard](@status int,@cardnumber decimal)
as
begin
update Cards set Status=@status where CardNumber=@cardnumber
select cards.status,Operations.balance from Cards inner join Operations on Cards.cardnumber=Operations.cardnumber and Operations.balance>=0
end
GO
/****** Object:  StoredProcedure [dbo].[Filter]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Filter] (@start_date date=null,@end_date date=null,@card_number decimal)
AS 
begin

select  distinct o.Amount,o.Status,o.Time  from Operations o
where  o.CardNumber=@card_number and cast(time as date) between  @start_date and  @end_date order by Time desc

end
GO
/****** Object:  StoredProcedure [dbo].[GenerateCodePin]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GenerateCodePin](@Id int)
as
begin
declare @pin int
declare @code decimal
select @pin=floor(1000+rand()*8999)
select @code= convert(decimal(16,0),(RAND()*8999999999999999)+1000000000000000 )

update cards set pin=@pin, cardnumber=@code where Id=@Id
end

GO
/****** Object:  StoredProcedure [dbo].[GetAllCards]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetAllCards] 
as
begin
    select * from Cards order by Time desc 
end
GO
/****** Object:  StoredProcedure [dbo].[GetBalanceByCustomer]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetBalanceByCustomer] ( @card_number decimal)
AS
  BEGIN
 DECLARE @Balance as decimal(19,2)

     if exists(select top 1  Balance from Operations where CardNumber=@card_number and Balance is not null   order by ID desc  )
   
	   set @Balance= (select top 1  Balance from Operations where CardNumber=@card_number   order by ID desc)

	else
	
        set @Balance = 0

	 select @Balance [Balance]
 END
GO
/****** Object:  StoredProcedure [dbo].[GetOperationByCustomer]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetOperationByCustomer] (@card_number decimal)
AS 
begin
begin try 
declare @status int
select  distinct Amount,Status,Time  from Operations 
where  CardNumber=@card_number order by Time desc 
      set @status=1
end try
begin catch
      set @status=0
end catch
select @status [Status]
end
GO
/****** Object:  StoredProcedure [dbo].[OperatorLogin]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[OperatorLogin] (@pin int)
as
DECLARE @Status as int 
     if exists(select *  from Operator where OperatorCode=@pin)
   
	  set @Status= 1
	
	else
	
     set @Status= 0

	 select @Status [Status]
	


GO
/****** Object:  StoredProcedure [dbo].[RejectCardRequest]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[RejectCardRequest](@status int,@card_number decimal)
as
begin
declare @applycard int
set @applycard=0
  update Cards set Status=@status where CardNumber=@card_number
 select Status from Cards
end
GO
/****** Object:  StoredProcedure [dbo].[WithdrawAmount]    Script Date: 11/11/2021 9:42:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[WithdrawAmount](@withdrawamount decimal(19,2),@cardnumber decimal, @date datetime, @tableStatus nvarchar(50))
as
begin
begin try
declare @status int
declare @balance decimal(19,2)

declare @sumaddamount decimal(19,2) 
declare @sumwithdrawamount decimal(19,2) 

select  @sumaddamount=SUM(Amount) from Operations where CardNumber=@cardnumber and status='The amount entered'
select  @sumwithdrawamount=SUM(Amount) from Operations where CardNumber=@cardnumber and status='The amount withdrawn'
set @balance=(coalesce(@sumaddamount,0)-coalesce(@sumwithdrawamount,0))-@withdrawamount

    insert into Operations(CardNumber,Amount,Balance,Status,Time) values(@cardnumber,@withdrawamount,@balance,@tableStatus,@date)
    set @status=1
end try
begin catch 
   set @status=0
end catch
Select @status[Status]
end
GO
USE [master]
GO
ALTER DATABASE [BankCardOperations] SET  READ_WRITE 
GO
