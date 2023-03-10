/****** Object:  StoredProcedure [dbo].[BPP_L2_1_createschema_societa_elettrica]    Script Date: 03/02/2023 10:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      <Letizia, Federico, Chaitanya>
-- Create Date: <30/01/2023>
-- Description: <Base di dati per la gestione di alcune attività di una ditta che fornisce energia elettrica>
-- =============================================

ALTER PROCEDURE [dbo].[BPP_L2_1_createschema_societa_elettrica]
    @dt_start date = '2020-01-01', 
	@dt_end date = '2024-12-31'

AS
BEGIN
 
	drop table dbo.BPP_L2_fact_bolletta
	drop table dbo.BPP_L2_dim_cliente
	drop table dbo.BPP_L2_cliente_SCD
	drop table dbo.BPP_L2_cliente_staging
	drop table dbo.BPP_L2_dim_contatore 
	drop table dbo.BPP_L2_dim_contratto 
	drop table dbo.BPP_L2_dim_operatore
	drop table dbo.BPP_L2_dim_tempo
	
	
    -- SET NOCOUNT ON added to prevent extra result sets from[dbo].[FP_L2_cliente_SCD]
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	DECLARE @giorni_tot int, @i int = 0

    -- Insert statements for procedure here

-- Time table
SET @giorni_tot = DATEDIFF(d,@dt_start,@dt_end)
	CREATE TABLE BPP_L2_dim_tempo(
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
INSERT INTO dbo.BPP_L2_dim_tempo(data,giorno,mese,anno,DescrizioneData,GiornoSettimana,DescrizioneMeseAnno,[Weekday-Weekend])
values ('1900-01-01','01','01','1900','01 Gennaio 1900','Lunedì','Gennaio 1900','Weekday')


	WHILE @i < @giorni_tot 
		BEGIN
			INSERT INTO dbo.BPP_L2_dim_tempo(data,giorno,mese,anno,DescrizioneData,GiornoSettimana,DescrizioneMeseAnno,[Weekday-Weekend])
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
			WHERE CAST(DATEADD(d,@i,@dt_start) AS DATE) NOT IN (SELECT data FROM BPP_L2_dim_tempo)
			SET @i = @i + 1
		END


-- Client Table
	create table dbo.BPP_L2_dim_cliente(
    ChiaveCliente int IDENTITY(0,1) PRIMARY KEY NOT NULL,
    CodiceCliente varchar(20) NOT NULL,
    TipologiaCliente varchar(20),
    Nome varchar(50),
    Cognome varchar(50), 
    Indirizzo varchar(50),
    RagioneSociale varchar(50),
    Professione varchar(50),
	DataInizioProfessione date,
	DataFineProfessione date,
	FlagAttuale char(2)
	)

		-- Creare la tabella di staging
		create table FP_L2_cliente_staging(
		ChiaveCliente int identity(0,1) primary key not null,
		CodiceCliente varchar(20),
		TipologiaCliente varchar(20),
		Nome varchar(50),
		Cognome varchar(50),
		Indirizzo varchar(50),
		RagioneSociale varchar(50),
		Professione varchar(50),
		DataInizioProfessione date,
		DimensionCheckSum int constraint DF_tblStaging_DimensionCheckSum default -1
		)

		-- Creare la tabella Cliente SCD Tipo 2 
		create table FP_L2_cliente_SCD(
		ChiaveCliente int identity(0,1) primary key not null,
		CodiceCliente varchar(20),
		TipologiaCliente varchar(20),
		Nome varchar(50),
		Cognome varchar(50),
		Indirizzo varchar(50),
		RagioneSociale varchar(50),
		Professione varchar(50),
		DataInizioProfessione date,
		DimensionCheckSum int constraint DF_tblSCD_DimensionCheckSum default -1,
		FlagAttuale char(2) default 'SI'
		)



	
-- Meter table
create table dbo.BPP_L2_dim_contatore(
ChiaveContatore int identity(0,1) primary key not null,
CodiceContatore char(10) not null,
UltimiKWLetti decimal(6,2),
UltimaDataLettura date,
NomeAreaGeografica varchar(50)
)
-- KW Letti e Data Lettura contengono sempre la misura più recente

-- Contract table
	create table dbo.BPP_L2_dim_contratto(
	ChiaveContratto int identity(0,1) primary key not null,
	CodiceContratto char(10) not null,
	TipologiaContratto varchar(30),
	DataInizioFornitura date,
	KWMassimi decimal(4,1),
	TempoMassimoIntervento int
	)

-- Operator table
	create table dbo.BPP_L2_dim_operatore(
	ChiaveOperatore int identity(0,1) primary key not null,
	MatricolaOperatore char(10) not null, 
	NomeOperatore varchar(50),
	CognomeOperatore varchar(50),
	NumeroTelefonoOperatore char(10)
	)

-- Bill table
	create table dbo.BPP_L2_fact_bolletta(
	ChiaveTempo int foreign key references dbo.BPP_L2_dim_tempo(ChiaveTempo),
	ChiaveCliente int foreign key references dbo.BPP_L2_dim_cliente(ChiaveCliente),
	ChiaveContratto int foreign key references dbo.BPP_L2_dim_contratto(ChiaveContratto),
	ChiaveContatore int foreign key references dbo.BPP_L2_dim_contatore(ChiaveContatore),
	ChiaveOperatore int foreign key references dbo.BPP_L2_dim_operatore(ChiaveOperatore),
	DataEmissione date,
	PeriodoRiferimento varchar(20),
	DataScadenzaPagamento date,
	CodiceLettura int not null,
	ConsumoFascia1 decimal(6,2),
	ConsumoFascia2 decimal(6,2),
	ConsumoFascia3 decimal(6,2),
	PrezzoKWhFascia1 decimal(4,3),
	PrezzoKWhFascia2 decimal(4,3),
	PrezzoKWhFascia3 decimal(4,3),
	TotaleDaPagare decimal(8,2),
	ProfessioneClienteAttuale varchar(50),
	primary key (ChiaveTempo,ChiaveCliente,ChiaveContratto,ChiaveContatore,ChiaveOperatore)
	)


END
