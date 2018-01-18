USE [dw]
GO

/****** Object:  Table [dbo].[ETL_Job_Log_Table]    Script Date: 01/17/2018 17:18:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ETL_Job_Log_Table](
	[StartTime] [datetime] NULL,
	[JobID] [int] NULL,
	[JobName] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

