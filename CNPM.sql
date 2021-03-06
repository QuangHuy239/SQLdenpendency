USE [ChuyenDeCNPM]
GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 4/24/2021 18:10:16 ******/
DROP TABLE [dbo].[NhanVien]
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_TABLE]    Script Date: 4/24/2021 18:10:16 ******/
DROP PROCEDURE [dbo].[SP_UPDATE_TABLE]
GO
USE [master]
GO
/****** Object:  Database [ChuyenDeCNPM]    Script Date: 4/24/2021 18:10:16 ******/
DROP DATABASE [ChuyenDeCNPM]
GO
/****** Object:  Database [ChuyenDeCNPM]    Script Date: 4/24/2021 18:10:16 ******/
CREATE DATABASE [ChuyenDeCNPM]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ChuyenDeCNPM', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\ChuyenDeCNPM.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ChuyenDeCNPM_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\ChuyenDeCNPM_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ChuyenDeCNPM] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ChuyenDeCNPM].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ChuyenDeCNPM] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET ARITHABORT OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ChuyenDeCNPM] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ChuyenDeCNPM] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ChuyenDeCNPM] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ChuyenDeCNPM] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ChuyenDeCNPM] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET RECOVERY FULL 
GO
ALTER DATABASE [ChuyenDeCNPM] SET  MULTI_USER 
GO
ALTER DATABASE [ChuyenDeCNPM] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ChuyenDeCNPM] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ChuyenDeCNPM] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ChuyenDeCNPM] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'ChuyenDeCNPM', N'ON'
GO
USE [ChuyenDeCNPM]
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_TABLE]    Script Date: 4/24/2021 18:10:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UPDATE_TABLE] 
@manv int,@ho NVARCHAR(50), @ten NVARCHAR(10), @phai NVARCHAR(3), @diachi NVARCHAR(100), @ngaysinh date, @luong float, @type int
AS
SET XACT_ABORT ON;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET NOCOUNT ON;
BEGIN
	
	BEGIN TRAN
		BEGIN TRY
		MERGE NhanVien AS NV
		USING (VALUES (@manv,@ho,@ten,@phai,@diachi,@ngaysinh,@luong)) AS temp(manv,ho,ten,phai,diachi,ngaysinh,luong)
		 ON NV.manv = @manv
		WHEN MATCHED AND (@type > 0) THEN
				UPDATE SET NV.ho = temp.ho, NV.ten = temp.ten, NV.phai = temp.phai, NV.diachi = temp.diachi, 
					NV.ngaysinh = temp.ngaysinh, NV.luong = temp.luong
		WHEN MATCHED AND (@type = 0) THEN DELETE
		WHEN NOT MATCHED THEN 
			INSERT VALUES (temp.ho,temp.ten,temp.phai,temp.diachi,temp.ngaysinh,temp.luong);
		WAITFOR DELAY '00:00:10' 
		COMMIT
		END TRY
		BEGIN CATCH
			IF (@@TRANCOUNT > 0)
			BEGIN
				ROLLBACK TRAN;
			END;
		THROW;
		END CATCH
	
END
GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 4/24/2021 18:10:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhanVien](
	[manv] [int] IDENTITY(1,1) NOT NULL,
	[ho] [nvarchar](50) NOT NULL,
	[ten] [nvarchar](10) NOT NULL,
	[phai] [nvarchar](3) NOT NULL,
	[diachi] [nvarchar](100) NOT NULL,
	[ngaysinh] [date] NOT NULL,
	[luong] [float] NOT NULL,
 CONSTRAINT [PK_NhanVien] PRIMARY KEY CLUSTERED 
(
	[manv] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[NhanVien] ON 

INSERT [dbo].[NhanVien] ([manv], [ho], [ten], [phai], [diachi], [ngaysinh], [luong]) VALUES (1, N'Lương Quang', N'Huy', N'Nam', N'Long An', CAST(0xA3230B00 AS Date), 100000000)
INSERT [dbo].[NhanVien] ([manv], [ho], [ten], [phai], [diachi], [ngaysinh], [luong]) VALUES (2, N'Ngô Quang ', N'Hòa', N'Nam', N'Vũng Tàu', CAST(0x69230B00 AS Date), 100000000)
INSERT [dbo].[NhanVien] ([manv], [ho], [ten], [phai], [diachi], [ngaysinh], [luong]) VALUES (3, N'Nguyễn Thị ', N'Hồng', N'Nữ', N'Bình Định', CAST(0xD4240B00 AS Date), 100000000)
INSERT [dbo].[NhanVien] ([manv], [ho], [ten], [phai], [diachi], [ngaysinh], [luong]) VALUES (6, N'A', N'G', N'E', N'23', CAST(0x8E230B00 AS Date), 111)
INSERT [dbo].[NhanVien] ([manv], [ho], [ten], [phai], [diachi], [ngaysinh], [luong]) VALUES (8, N'EAEA', N'J', N'Nam', N'E', CAST(0xBA220B00 AS Date), 111)
INSERT [dbo].[NhanVien] ([manv], [ho], [ten], [phai], [diachi], [ngaysinh], [luong]) VALUES (11, N'ABE', N'A', N'NỮ', N'a', CAST(0xA3230B00 AS Date), 1)
SET IDENTITY_INSERT [dbo].[NhanVien] OFF
USE [master]
GO
ALTER DATABASE [ChuyenDeCNPM] SET  READ_WRITE 
GO
