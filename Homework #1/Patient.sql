USE [ConsultingRoom]
GO

/****** Object:  Table [dbo].[Patient]    Script Date: 4.7.2022 г. 21:51:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Patient](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Date] [date] NOT NULL,
	[Diagnosis] [varchar](150) NOT NULL,
	[Cabinet] [int] NOT NULL,
	[MedicalDirection] [bit] NOT NULL
) ON [PRIMARY]
GO

