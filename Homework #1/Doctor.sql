USE [ConsultingRoom]
GO

/****** Object:  Table [dbo].[Doctor]    Script Date: 4.7.2022 г. 21:50:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Doctor](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Cabinet] [int] NOT NULL,
	[PatientID] [int] NOT NULL,
	[Prescription] [varchar](150) NOT NULL
) ON [PRIMARY]
GO

