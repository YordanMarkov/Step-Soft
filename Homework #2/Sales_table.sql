USE [Sales]
GO

/****** Object:  Table [dbo].[Sales]    Script Date: 5.7.2022 г. 15:14:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sales](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Number] [int] NOT NULL,
	[Stock] [varchar](50) NOT NULL,
	[Amount] [int] NOT NULL,
	[Price] [float] NOT NULL,
	[Total] [float] NOT NULL
) ON [PRIMARY]
GO

