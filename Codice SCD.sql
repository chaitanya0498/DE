--Terzo giorno: L1 e L2 sono popolate. L'utente aggiorna L1. L'aggiornamento pu� essere di pi� tipi: o si aggiorna la professione (SCD typw 2) 
-- oppure si aggiornano altri attribuiti, di cui per� non ci interessano i record passati (SCD type 1). 

-- Passo 1: Si aggiorna la tabella L1 (manualmente, prima di far partire la procedura)
-- Passo 2: La tabella staging � gi� popolata. La tronchiamo e la ripopoliamo con tutte le righe in L1. 
-- Passo 3: Popoliamo la tabella SCD con il merge tra tabella di staging in tempo t e tabella di SCD in t-1.
-- Passo 4: la nostra dim_cliente coincider� con l'ultima versione della tabella SCD 

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

--select * from FP_L2_cliente_staging
--select * from FP_L2_cliente_SCD
--delete FP_L2_cliente_SCD (per simulare una tabella vuota come fosse il primo giorno)



--=============================================================================
-- Blocco di codice 2
--=============================================================================

-- Inizio del giorno 1 - Facciamo il delete di tutte le righe nella tabella di staging 
delete FP_L2_cliente_staging

-- Inseriamo tutte le righe della tabella cliente L1 nella tabella L2 staging 
insert into dbo.FP_L2_cliente_staging (CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione)
select CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataAggiornamento
from BPP_Cliente

-- Assegniamo uno score ad ogni riga della tabella cliente L2 staging tramite la funzione binary_checksum (due righe popolate esattamente nello stesso modo avranno lo stesso CHECKSUM)
update dbo.FP_L2_cliente_staging set DimensionCheckSum=
BINARY_CHECKSUM(CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione)
 


--=============================================================================
-- Blocco di codice 3
--=============================================================================
-- Inzia l'insert nella tabella L2 cliente SCD (che sara' la nostra tabella finale) tramite MERGE
insert into dbo.FP_L2_cliente_SCD (CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, DimensionCheckSum)
--inserisci solo le righe che sono state cambiate
  select CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, DimensionCheckSum   
  from
    (
     MERGE into dbo.FP_L2_cliente_SCD AS target
      USING 
      ( -- il sorgente: colonne dei attributi dalla staging table.
        SELECT CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, 
        DimensionCheckSum

        from dbo.FP_L2_cliente_staging
      ) 
      
      AS source 
      ( CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, 
        DimensionCheckSum  
      ) 
      
      ON 
      (
        target.CodiceCliente = source.CodiceCliente --Paragonando CodiceCliente nelle tabelle target(destinazione) e source(sorgente)  
      )
      
      -- Se questi codici cliente corrispondono ma le CheckSum sono diversi, allora il record è cambiato;
      -- quindi, aggiornare il record esistente nel target, e set FLAG ATTUALE a NO
      
      WHEN MATCHED and target.DimensionCheckSum <> source.DimensionCheckSum and target.FlagAttuale='SI'
      THEN 
      UPDATE SET  
        FlagAttuale='NO'
  
      -- Se invece questi codici cliente NON corrispondono, vuol dire il record è nuovo, e
      -- quindi, inseriamo i record nuovi nella target utilizzando i valore dalla sorgente.
      WHEN NOT MATCHED THEN  
        INSERT 
        (
         CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, 
         DimensionCheckSum
        )
        VALUES 
        (
          source.CodiceCliente, 
          source.TipologiaCliente,
          source.Nome,
          source.Cognome,
          source.Indirizzo,
          source.RagioneSociale,
          source.Professione,
          source.DataInizioProfessione,
          source.DimensionCheckSum
        )


  OUTPUT $action, 
   source.CodiceCliente, 
    source.TipologiaCliente,
    source.Nome,
    source.Cognome,
	  source.Indirizzo,
	  source.RagioneSociale,
	  source.Professione,
	  source.DataInizioProfessione,
    source.DimensionCheckSum
    
) -- fine del MERGE

-- MERGE (codice di sopra) come:

--I campi seguenti aggiornati saranno inseriti all'interno della slowly changing dimension.
as changes 
(
  action, 
  CodiceCliente, 
  TipologiaCliente,
  Nome,
  Cognome,
	Indirizzo,
	RagioneSociale,
	Professione,
	DataInizioProfessione,
  DimensionCheckSum
)
where action='UPDATE';



--Visualizziamo entrambe le tabelle (Blocco codice 4)
--select * from dbo.FP_L2_cliente_staging order by CodiceCliente
--select * from dbo.FP_L2_cliente_SCD order by CodiceCliente, ChiaveCliente



--=============================================================================
--Blocco codice 5 
--=============================================================================

--Start of Day 2 - truncate the staging table
--truncate table dbo.FP_L2_cliente_staging
-- insert a new record into the staging table
/*insert into dbo.FP_L2_cliente_staging
(CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione)
values ('01967877-8', 'Privato', 'Maria', 'Bianchi', 'Via Mameli 2, Pisa (PI)', null, 'Consulente', getdate())
-- insert a new record into the staging table
insert into dbo.FP_L2_cliente_staging
(CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione)
values ('02461843-8', 'Privato', 'Fabio', 'Bernardi', 'Via Corsica 23, Torino (TO)', null, 'Pescatore', getdate())
-- insert a changed record into the staging table
insert into dbo.FP_L2_cliente_staging
(CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione)
values ('02167877-8', 'Privato', 'Giacomo', 'Paleari', 'Via Roma 67, Milano (MI)', null, 'Medico', '2023-02-01') */

-- Update the checksum value in the staging table
--update dbo.FP_L2_cliente_staging set DimensionCheckSum=
--BINARY_CHECKSUM(CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione)


--select * from dbo.FP_L2_cliente_SCD order by CodiceCliente, ChiaveCliente



--=============================================================================
-- BLOCCO CODICE 4
--=============================================================================

-- Cancelliamo le righe di cui non ci serve mantenere la storicizzazione
DELETE FROM FP_L2_cliente_SCD
WHERE CodiceCliente IN (
                        SELECT A.CodiceCliente
                        from FP_L2_cliente_SCD as B, FP_L2_cliente_SCD as A
                        where B.CodiceCliente = A.CodiceCliente and B.Professione = A.Professione AND A.FlagAttuale = 'NO' and (A.Nome <>B.Nome or�
                        A.Cognome <>B.Cognome� or A.Indirizzo <>B.Indirizzo or�� A.RagioneSociale <>B.RagioneSociale)
                        )
      and FlagAttuale = 'NO'

-- Stessa cosa ma per i clienti di tipo Business 
delete FP_L2_cliente_SCD
where TipologiaCliente = 'Business' and FlagAttuale = 'NO'

-- Visualizziamo il risultato finale 
--select * from dbo.FP_L2_cliente_SCD order by CodiceCliente, ChiaveCliente


delete from BPP_L2_dim_cliente
DBCC checkident(BPP_L2_dim_cliente, reseed, -1);

-- A questo punto popoliamo la nostra BPP_L2_dim_cliente con i dati della cliente L2 SCD. 
insert into BPP_L2_dim_cliente(CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, FlagAttuale)
  select CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, FlagAttuale 
  from FP_L2_cliente_SCD

