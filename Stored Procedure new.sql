-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Letizia, Federico, Chaitanya>
-- Create Date: <30/01/2023>
-- Description: <Base di dati per la gestione di alcune attivit� di una ditta che fornisce energia elettrica>
-- =============================================
CREATE PROCEDURE dbo.BPP_L2_createschema_societa_elettrica

AS
BEGIN
 
	drop table dbo.BPP_L2_dim_cliente 
	drop table dbo.BPP_L2_dim_contatore 
	drop table dbo.BPP_L2_dim_contratto 
	drop table dbo.BPP_L2_dim_operatore
	drop table dbo.BPP_L2_dim_data
	drop table dbo.BPP_L2_fact_bolletta
	
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here


	create table dbo.BPP_L2_dim_cliente(
��� ChiaveCliente int IDENTITY(0,1) PRIMARY KEY NOT NULL,
��� CodiceCliente varchar(20) NOT NULL,
��� TipologiaCliente varchar(20),
��� Nome varchar(50),
��� Cognome varchar(50),�
��� Indirizzo varchar(50),
��� RagioneSociale varchar(50),
��� Professione varchar(50),
	DataInizioValidita date,
	DataFineValidita date,
	FlagAttuale char(2)
	)

	create table dbo.BPP_L2_dim_contatore(
	ChiaveContatore int identity(0,1) primary key not null,
	CodiceContatore char(10) not null,
	UltimiKWLetti decimal(6,2),
	UltimaDataLettura date,
	NomeAreaGeografica varchar(50)
	)

	-- KW Letti e Data Lettura contengono sempre la misura pi� recente


	create table dbo.BPP_L2_dim_contratto(
	ChiaveContratto int identity(0,1) primary key not null,
	CodiceContratto char(10),
	TipologiaContratto varchar(30),
	DataInizioFornitura date,
	KWMassimi decimal(4,1),
	TempoMassimoIntervento int
	)

	create table dbo.BPP_L2_dim_operatore(
	ChiaveOperatore int identity(0,1) primary key not null,
	MatricolaOperatore char(10) not null,�
	NomeOperatore varchar(50),
	CognomeOperatore varchar(50),
	NumeroTelefonoOperatore char(10)
	)

	create table dbo.BPP_L2_dim_tempo(
	ChiaveTempo int IDENTITY(0,1) primary key NOT NULL,
	[Data] date,
	Anno char(4),
	Mese char(2),
	Giorno char(2),
	DescrizioneData varchar(30),
	GiornoSettimana varchar(20),
	DescrizioneMeseAnno varchar(20),
	[Weekday/Weekend] char(7)
	)
	

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
GO