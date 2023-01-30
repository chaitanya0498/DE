/****** Object:  StoredProcedure [dbo].[LP_Esempio_DimensioneTempo]    Script Date: 30/01/2023 17:26:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[LP_Esempio_DimensioneTempo]
	@dt_start date = '2020-01-01', 
	@dt_end date = '2024-12-31'
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @giorni_tot int, @i int = 0

	SET @giorni_tot = DATEDIFF(d,@dt_start,@dt_end)
	CREATE TABLE LP_L2_dim_Data(
		ChiaveTempo INT IDENTITY(0,1) PRIMARY KEY NOT NULL,
		Data DATE, 
		Giorno char(2), 
		Mese char(2),
		Anno char(4), 
		DescrizioneData varchar(30),
		GiornoSettimana varchar(20),
		DescrizioneMeseAnno varchar(20),
		[Weekday-Weekend] char(7)

	);
-- Inserimento record nullo con ChiaveTempo = 0
INSERT INTO dbo.LP_L2_dim_Data(data,giorno,mese,anno,DescrizioneData,GiornoSettimana,DescrizioneMeseAnno,[Weekday-Weekend])
values ('1900-01-01','01','01','1900','01 Gennaio 1900','Lunedì','Gennaio 1900','Weekday')


	WHILE @i < @giorni_tot 
		BEGIN
			INSERT INTO dbo.LP_L2_dim_Data(data,giorno,mese,anno,DescrizioneData,GiornoSettimana,DescrizioneMeseAnno,[Weekday-Weekend])
			SELECT 
-- DATEADD aggiunge @i(integer) a @dt_start in giorni(d). Esempio: 01-01-2020 al primo ciclo diventa 02-01-2020 e così via..			
			CAST(DATEADD(d,@i,@dt_start) AS DATE),
-- Estrazione di giorno (DAY), MESE(month), Anno(Year)			
			DAY(CAST(DATEADD(d,@i,@dt_start) AS DATE)),
			MONTH(CAST(DATEADD(d,@i,@dt_start) AS DATE)),
			YEAR(CAST(DATEADD(d,@i,@dt_start) AS DATE)),
-- Per la DescrizioneData -- CONCAT concatena le stringhe e DATANAME(datapart, data) restituisce una stringa
			CONCAT(DATENAME(day,CAST(DATEADD(d,@i,@dt_start) AS DATE)), DATENAME(month,CAST(DATEADD(d,@i,@dt_start) AS DATE)),DATENAME(year,CAST(DATEADD(d,@i,@dt_start) AS DATE))),
-- GiornoSettimana
			DATENAME(weekday,CAST(DATEADD(d,@i,@dt_start) AS DATE)), 
-- DescrizioneMeseAnno
            CONCAT(DATENAME(month,CAST(DATEADD(d,@i,@dt_start) AS DATE)),DATENAME(year,CAST(DATEADD(d,@i,@dt_start) AS DATE))),
--Weekday-Weekend
			CASE 
			WHEN (DATENAME(weekday,CAST(DATEADD(d,@i,@dt_start) AS DATE)) = 'Sunday' or DATENAME(weekday,CAST(DATEADD(d,@i,@dt_start) AS DATE)) = 'Saturday')
			THEN 'Weekend' 
			WHEN (DATENAME(weekday,CAST(DATEADD(d,@i,@dt_start) AS DATE)) <> 'Sunday' or DATENAME(weekday,CAST(DATEADD(d,@i,@dt_start) AS DATE)) <> 'Saturday')
			THEN 'Weekday' 
			END
			WHERE CAST(DATEADD(d,@i,@dt_start) AS DATE) NOT IN (SELECT data FROM LP_L2_dim_Data)
			SET @i = @i + 1
		END
END
GO


