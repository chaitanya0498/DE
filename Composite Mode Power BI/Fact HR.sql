/****** Object:  Table [dbo].[L2_Alten_F_HR]    Script Date: 17/02/2023 15:59:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[L2_Alten_F_HR](
	[SK_Project] [int] NOT NULL,
	[SK_Gerarchia] [int] NOT NULL,
	[SK_Data] [int] NOT NULL,
	[SK_TD] [int] NOT NULL,
	[ProjectManagerId] [nvarchar](max) NULL,
	[ProjectManager] [nvarchar](max) NULL,
	[costAmount] [float] NULL,
	[revenueAmount] [float] NULL,
	[SK_HR] [int] IDENTITY(1,1) NOT NULL,
	[SK_Risorsa] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SK_Data] ASC,
	[SK_Project] ASC,
	[SK_TD] ASC,
	[SK_Gerarchia] ASC,
	[SK_Risorsa] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[L2_Alten_F_HR]  WITH CHECK ADD FOREIGN KEY([SK_Data])
REFERENCES [dbo].[L2_Alten_D_Tempo] ([SK_Data])
GO

ALTER TABLE [dbo].[L2_Alten_F_HR]  WITH CHECK ADD FOREIGN KEY([SK_Gerarchia])
REFERENCES [dbo].[L2_Alten_D_Gerarchia_BM] ([SK_Gerarchia])
GO

ALTER TABLE [dbo].[L2_Alten_F_HR]  WITH CHECK ADD FOREIGN KEY([SK_Project])
REFERENCES [dbo].[L2_Alten_D_Projects] ([SK_project])
GO

ALTER TABLE [dbo].[L2_Alten_F_HR]  WITH CHECK ADD FOREIGN KEY([SK_Risorsa])
REFERENCES [dbo].[L2_alten_d_Risorsa] ([SK_Risorsa])
GO

ALTER TABLE [dbo].[L2_Alten_F_HR]  WITH CHECK ADD FOREIGN KEY([SK_TD])
REFERENCES [dbo].[L2_Alten_D_Gerarchia_TD] ([SK_TD])
GO

