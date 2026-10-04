USE [master]
GO
IF DB_ID(N'StudentFeedbackSystem') IS NULL
    CREATE DATABASE [StudentFeedbackSystem];
GO
USE [StudentFeedbackSystem]
GO
/****** Object:  Table [dbo].[Admins]    Script Date: 10/4/2026 8:31:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Admins](
	[AdminId] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[PasswordHash] [nvarchar](255) NOT NULL,
	[FullName] [nvarchar](150) NOT NULL,
	[Role] [nvarchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[FailedLoginCount] [int] NOT NULL,
	[LockoutUntil] [datetime2](7) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AdminId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditLog]    Script Date: 10/4/2026 8:31:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLog](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[AdminId] [int] NULL,
	[Action] [nvarchar](100) NOT NULL,
	[TargetType] [nvarchar](50) NOT NULL,
	[TargetId] [int] NOT NULL,
	[Details] [nvarchar](500) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseOfferings]    Script Date: 10/4/2026 8:31:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseOfferings](
	[OfferingId] [int] IDENTITY(1,1) NOT NULL,
	[CourseId] [int] NOT NULL,
	[ProfessorId] [int] NOT NULL,
	[SectionId] [int] NOT NULL,
	[SchoolYear] [nvarchar](9) NOT NULL,
	[Term] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OfferingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Offering] UNIQUE NONCLUSTERED 
(
	[CourseId] ASC,
	[ProfessorId] ASC,
	[SectionId] ASC,
	[SchoolYear] ASC,
	[Term] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 10/4/2026 8:31:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Courses](
	[CourseId] [int] IDENTITY(1,1) NOT NULL,
	[CourseCode] [nvarchar](20) NOT NULL,
	[CourseTitle] [nvarchar](200) NOT NULL,
	[Units] [tinyint] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CourseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CourseCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Criteria]    Script Date: 10/4/2026 8:31:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Criteria](
	[CriterionId] [int] IDENTITY(1,1) NOT NULL,
	[CriterionName] [nvarchar](150) NOT NULL,
	[Weight] [decimal](4, 2) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CriterionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Enrollments]    Script Date: 10/4/2026 8:31:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Enrollments](
	[EnrollmentId] [int] IDENTITY(1,1) NOT NULL,
	[StudentId] [int] NOT NULL,
	[OfferingId] [int] NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[HasRated] [bit] NOT NULL,
	[EnrolledAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EnrollmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Enrollment] UNIQUE NONCLUSTERED 
(
	[StudentId] ASC,
	[OfferingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feedback]    Script Date: 10/4/2026 8:31:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedback](
	[FeedbackId] [int] IDENTITY(1,1) NOT NULL,
	[EnrollmentId] [int] NOT NULL,
	[StudentId] [int] NOT NULL,
	[ProfessorId] [int] NOT NULL,
	[CourseId] [int] NOT NULL,
	[SchoolYear] [nvarchar](9) NOT NULL,
	[Term] [nvarchar](20) NOT NULL,
	[AverageScore] [decimal](4, 2) NOT NULL,
	[Comments] [nvarchar](1000) NULL,
	[IsAnonymous] [bit] NOT NULL,
	[SubmittedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FeedbackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Feedback_Student_Enrollment] UNIQUE NONCLUSTERED 
(
	[StudentId] ASC,
	[EnrollmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FeedbackDetails]    Script Date: 10/4/2026 8:31:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FeedbackDetails](
	[FeedbackDetailId] [int] IDENTITY(1,1) NOT NULL,
	[FeedbackId] [int] NOT NULL,
	[CriterionId] [int] NOT NULL,
	[Score] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FeedbackDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_FeedbackDetail] UNIQUE NONCLUSTERED 
(
	[FeedbackId] ASC,
	[CriterionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Professors]    Script Date: 10/4/2026 8:31:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Professors](
	[ProfessorId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[Department] [nvarchar](100) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProfessorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sections]    Script Date: 10/4/2026 8:31:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sections](
	[SectionId] [int] IDENTITY(1,1) NOT NULL,
	[SectionName] [nvarchar](50) NOT NULL,
	[Program] [nvarchar](50) NOT NULL,
	[YearLevel] [tinyint] NOT NULL,
	[SchoolYear] [nvarchar](9) NOT NULL,
	[Term] [nvarchar](20) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SectionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Sections_Name_Term] UNIQUE NONCLUSTERED 
(
	[SectionName] ASC,
	[SchoolYear] ASC,
	[Term] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Students]    Script Date: 10/4/2026 8:31:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[StudentId] [int] IDENTITY(1,1) NOT NULL,
	[StudentNumber] [nvarchar](20) NOT NULL,
	[SchoolEmail] [nvarchar](150) NOT NULL,
	[PasswordHash] [nvarchar](255) NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[Program] [nvarchar](50) NOT NULL,
	[YearLevel] [tinyint] NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[RejectionReason] [nvarchar](300) NULL,
	[SectionId] [int] NULL,
	[DateRegistered] [datetime2](7) NOT NULL,
	[DateVerified] [datetime2](7) NULL,
	[VerifiedBy] [int] NULL,
	[FailedLoginCount] [int] NOT NULL,
	[LockoutUntil] [datetime2](7) NULL,
	[MiddleName] [nvarchar](100) NULL,
	[BirthDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[StudentNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SchoolEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AuditLog_TargetType_TargetId]    Script Date: 10/4/2026 8:31:21 PM ******/
CREATE NONCLUSTERED INDEX [IX_AuditLog_TargetType_TargetId] ON [dbo].[AuditLog]
(
	[TargetType] ASC,
	[TargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Enrollments_OfferingId]    Script Date: 10/4/2026 8:31:21 PM ******/
CREATE NONCLUSTERED INDEX [IX_Enrollments_OfferingId] ON [dbo].[Enrollments]
(
	[OfferingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Enrollments_StudentId]    Script Date: 10/4/2026 8:31:21 PM ******/
CREATE NONCLUSTERED INDEX [IX_Enrollments_StudentId] ON [dbo].[Enrollments]
(
	[StudentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Feedback_CourseId]    Script Date: 10/4/2026 8:31:21 PM ******/
CREATE NONCLUSTERED INDEX [IX_Feedback_CourseId] ON [dbo].[Feedback]
(
	[CourseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Feedback_ProfessorId_Term]    Script Date: 10/4/2026 8:31:21 PM ******/
CREATE NONCLUSTERED INDEX [IX_Feedback_ProfessorId_Term] ON [dbo].[Feedback]
(
	[ProfessorId] ASC,
	[SchoolYear] ASC,
	[Term] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Students_SectionId]    Script Date: 10/4/2026 8:31:21 PM ******/
CREATE NONCLUSTERED INDEX [IX_Students_SectionId] ON [dbo].[Students]
(
	[SectionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Students_Status]    Script Date: 10/4/2026 8:31:21 PM ******/
CREATE NONCLUSTERED INDEX [IX_Students_Status] ON [dbo].[Students]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Admins] ADD  DEFAULT ('Admin') FOR [Role]
GO
ALTER TABLE [dbo].[Admins] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Admins] ADD  DEFAULT ((0)) FOR [FailedLoginCount]
GO
ALTER TABLE [dbo].[Admins] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AuditLog] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Courses] ADD  DEFAULT ((3)) FOR [Units]
GO
ALTER TABLE [dbo].[Courses] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Criteria] ADD  DEFAULT ((1.00)) FOR [Weight]
GO
ALTER TABLE [dbo].[Criteria] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [dbo].[Criteria] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Enrollments] ADD  DEFAULT ('Ongoing') FOR [Status]
GO
ALTER TABLE [dbo].[Enrollments] ADD  DEFAULT ((0)) FOR [HasRated]
GO
ALTER TABLE [dbo].[Enrollments] ADD  DEFAULT (sysutcdatetime()) FOR [EnrolledAt]
GO
ALTER TABLE [dbo].[Feedback] ADD  DEFAULT ((1)) FOR [IsAnonymous]
GO
ALTER TABLE [dbo].[Feedback] ADD  DEFAULT (sysutcdatetime()) FOR [SubmittedAt]
GO
ALTER TABLE [dbo].[Professors] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Professors] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Sections] ADD  DEFAULT (sysutcdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Students] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[Students] ADD  DEFAULT (sysutcdatetime()) FOR [DateRegistered]
GO
ALTER TABLE [dbo].[Students] ADD  DEFAULT ((0)) FOR [FailedLoginCount]
GO
ALTER TABLE [dbo].[AuditLog]  WITH CHECK ADD FOREIGN KEY([AdminId])
REFERENCES [dbo].[Admins] ([AdminId])
GO
ALTER TABLE [dbo].[CourseOfferings]  WITH CHECK ADD FOREIGN KEY([CourseId])
REFERENCES [dbo].[Courses] ([CourseId])
GO
ALTER TABLE [dbo].[CourseOfferings]  WITH CHECK ADD FOREIGN KEY([ProfessorId])
REFERENCES [dbo].[Professors] ([ProfessorId])
GO
ALTER TABLE [dbo].[CourseOfferings]  WITH CHECK ADD FOREIGN KEY([SectionId])
REFERENCES [dbo].[Sections] ([SectionId])
GO
ALTER TABLE [dbo].[Enrollments]  WITH CHECK ADD FOREIGN KEY([OfferingId])
REFERENCES [dbo].[CourseOfferings] ([OfferingId])
GO
ALTER TABLE [dbo].[Enrollments]  WITH CHECK ADD FOREIGN KEY([StudentId])
REFERENCES [dbo].[Students] ([StudentId])
GO
ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD FOREIGN KEY([CourseId])
REFERENCES [dbo].[Courses] ([CourseId])
GO
ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD FOREIGN KEY([EnrollmentId])
REFERENCES [dbo].[Enrollments] ([EnrollmentId])
GO
ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD FOREIGN KEY([ProfessorId])
REFERENCES [dbo].[Professors] ([ProfessorId])
GO
ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD FOREIGN KEY([StudentId])
REFERENCES [dbo].[Students] ([StudentId])
GO
ALTER TABLE [dbo].[FeedbackDetails]  WITH CHECK ADD FOREIGN KEY([CriterionId])
REFERENCES [dbo].[Criteria] ([CriterionId])
GO
ALTER TABLE [dbo].[FeedbackDetails]  WITH CHECK ADD FOREIGN KEY([FeedbackId])
REFERENCES [dbo].[Feedback] ([FeedbackId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Students]  WITH CHECK ADD FOREIGN KEY([SectionId])
REFERENCES [dbo].[Sections] ([SectionId])
GO
ALTER TABLE [dbo].[Students]  WITH CHECK ADD FOREIGN KEY([VerifiedBy])
REFERENCES [dbo].[Admins] ([AdminId])
GO
ALTER TABLE [dbo].[Admins]  WITH CHECK ADD  CONSTRAINT [CK_Admins_Role] CHECK  (([Role]='SuperAdmin' OR [Role]='Admin'))
GO
ALTER TABLE [dbo].[Admins] CHECK CONSTRAINT [CK_Admins_Role]
GO
ALTER TABLE [dbo].[Enrollments]  WITH CHECK ADD  CONSTRAINT [CK_Enrollments_Status] CHECK  (([Status]='Dropped' OR [Status]='Completed' OR [Status]='Ongoing'))
GO
ALTER TABLE [dbo].[Enrollments] CHECK CONSTRAINT [CK_Enrollments_Status]
GO
ALTER TABLE [dbo].[FeedbackDetails]  WITH CHECK ADD  CONSTRAINT [CK_FeedbackDetails_Score] CHECK  (([Score]>=(1) AND [Score]<=(5)))
GO
ALTER TABLE [dbo].[FeedbackDetails] CHECK CONSTRAINT [CK_FeedbackDetails_Score]
GO
ALTER TABLE [dbo].[Students]  WITH CHECK ADD  CONSTRAINT [CK_Students_Status] CHECK  (([Status]='Suspended' OR [Status]='Rejected' OR [Status]='Verified' OR [Status]='Pending'))
GO
ALTER TABLE [dbo].[Students] CHECK CONSTRAINT [CK_Students_Status]
GO

INSERT INTO [dbo].[Admins] (Username, PasswordHash, FullName, Role, IsActive, FailedLoginCount)
VALUES (
    N'superadmin',
    N'$2b$11$xERszKW9wryKpQE/m.cBFeahYGEQunsxd8JEyhXYMZca0.zfwwOg2',
    N'Super Administrator',
    N'SuperAdmin',
    1,
    0
);