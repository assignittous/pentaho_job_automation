USE [dw]
GO

/****** Object:  Table [dbo].[ETL_Schedule_Log]    Script Date: 01/17/2018 17:18:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ETL_Schedule_Log](
	[JobID] [int] NULL,
	[JobName] [varchar](50) NULL,
	[Frequency] [varchar](50) NULL,
	[DAY] [int] NULL,
	[Runtime] [varchar](8) NULL,
	[RuntimeMinutes] [int] NULL,
	[Tolerance] [float] NULL,
	[ScheduleRunDateTime] [datetime] NULL,
	[LastRunTime] [datetime] NULL,
	[CurrentDate] [datetime] NULL,
	[TimeDiff] [int] NULL,
	[Status] [varchar](100) NULL,
	[Email] [bit] NULL,
	[Recipient] [varchar](100) NULL,
	[Sender] [varchar](100) NULL,
	[SenderName] [varchar](100) NULL,
	[Server] [varchar](100) NULL,
	[ServerPort] [varchar](100) NULL,
	[EmailMessage] [varchar](100) NULL,
	[RunDiff] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

