-- TABELLA DIMENSIONE CONTATORE

create table BPP_L2_Contatore (
ChiaveContatore int identity(1,1) primary key not null,
CodiceContatore char(10) not null,
Modello varchar(20),
KWMassimiErogabili decimal(4,1),
DataInstallazione date,
CodiceLettura int not null,
KWLetti decimal(6,2),
DataLettura date,
MatricolaOperatore char(10) not null, 
NomeOperatore varchar(50),
CognomeOperatore varchar(50),
NumeroTelefonoOperatore char(10)
)


-- TABELLA DIMENSIONE CLIENTE

create table [BPP_L2_Cliente](
    [ChiaveCliente] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
    [CodiceCliente] [varchar](20) NOT NULL,
    [TipologiaCliente] [varchar](20),
    [NomeCliente] [varchar](50),
    [CognomeCliente] [varchar](50), 
    [NumeroTelefono] [char](10), 
    [Indirizzo] [varchar](50),
    [RagioneSociale] [varchar](50),
    [NomePersonaRiferimento] [varchar](50),
    [CognomePersonaRiferimento] [varchar](50)
);

-- TABELLA DIMENSIONE CONTRATTO

create table BPP_L2_Contratto ( 
	ChiaveContratto int identity(1,1) primary key not null,
	CodiceContratto char(10),
	TipologiaContratto varchar(30),
	IndirizzoLocale varchar(50),
	DataInizioFornitura date,
	DataStipulaContratto date,
	KWMassimi decimal(4,1),
	TempoMassimoIntervento decimal(5,2)
	)


-- TABELLA DIMENSIONE TEMPO

create table BPP_L2_Tempo (
ChiaveTempo int identity(1,1) primary key not null, 
[Data] date,
Anno char(4),
Mese char(2),
Giorno char(2),
[DescrizioneData] varchar(30),
GiornoSettimana varchar(20),
DescrizioneMeseAnno varchar(20),
[Weekday/Weekend] char(7)
)


-- TABELLA DEI FATTI BOLLETTA
create table BPP_L2_Bolletta (
ChiaveTempo int foreign key references BPP_L2_Tempo(ChiaveTempo),
ChiaveCliente int foreign key references BPP_L2_Cliente(ChiaveCliente),
ChiaveContratto int foreign key references BPP_L2_Contratto(ChiaveContratto),
ChiaveContatore int foreign key references BPP_L2_Contatore(ChiaveContatore),
DataEmissione date,
PeriodoRiferimento varchar(20),
DataScadenzaPagamento date, 
ConsumoFascia1 decimal(6,2),
ConsumoFascia2 decimal(6,2),
ConsumoFascia3 decimal(6,2),
PrezzoKWhFascia1 decimal(4,3),
PrezzoKWhFascia2 decimal(4,3),
PrezzoKWhFascia3 decimal(4,3),
SommaPagare1 decimal(6,2),
SommaPagare2 decimal(6,2),
SommaPagare3 decimal(6,2),
TotalePagare decimal(8,2)
)

