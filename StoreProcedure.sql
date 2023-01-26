CONTATORE
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

CLIENTE

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

