/****** Object:  StoredProcedure [dbo].[BPP_L2_2_popolamento]    Script Date: 03/02/2023 11:13:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Letizia, Federico, Chaitanya>
-- Create Date: 31-01-2023
-- Description: Popolamento delle tabelle L2 da L1 (1.troncare, 2.inserire valori null, 3.popola le tabelle L2)
-- =============================================
ALTER PROCEDURE [dbo].[BPP_L2_2_popolamento]

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here

-- 1.svuotare le tabelle L2

--	truncate table dbo.BPP_L2_fact_bolletta
	delete dbo.BPP_L2_dim_cliente 
	delete dbo.BPP_L2_cliente_staging	
	delete dbo.BPP_L2_dim_contatore 
	delete dbo.BPP_L2_dim_contratto 
	delete dbo.BPP_L2_dim_operatore

	DBCC checkident(BPP_L2_dim_cliente, reseed, -1);
	DBCC checkident(BPP_L2_cliente_staging, reseed, -1);
	DBCC checkident(BPP_L2_dim_contatore, reseed, -1);
	DBCC checkident(BPP_L2_dim_contratto, reseed, -1);
	DBCC checkident(BPP_L2_dim_operatore, reseed, -1);







-- 2.inserire valori null

--TABELLA L2 CLIENTE
	insert into dbo.BPP_L2_dim_cliente(CodiceCliente,TipologiaCliente,Nome,Cognome,
	Indirizzo,RagioneSociale,Professione,DataInizioProfessione,DataFineProfessione,FlagAttuale)
	values('0000000000',null,null,null,null,null,null,null,null,null)

--TABELLA L2 CONTATORE
	insert into dbo.BPP_L2_dim_contatore(CodiceContatore,UltimiKWLetti,UltimaDataLettura,NomeAreaGeografica)
	values('0000000000',null,null,null)

--TABELLA L2 CONTRATTO
	insert into dbo.BPP_L2_dim_contratto(CodiceContratto,TipologiaContratto,DataInizioFornitura,KWMassimi,TempoMassimoIntervento)
	values('0000000000',null,null,null,null)

-- TABELLA L2 OPERATORE
	insert into dbo.BPP_L2_dim_operatore(MatricolaOperatore,NomeOperatore,CognomeOperatore,NumeroTelefonoOperatore)
	values('0000000000',null,null,null)





-- 3.popola le tabelle L2

--TABELLA L2 CLIENTE
--Inseriamo tutte le righe della tabella cliente L1 nella tabella L2 staging 
insert into dbo.BPP_L2_cliente_staging (CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione)
select CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataAggiornamento
from BPP_Cliente

-- Assegniamo uno score ad ogni riga della tabella cliente L2 staging tramite la funzione binary_checksum (due righe popolate esattamente nello stesso modo avranno lo stesso CHECKSUM)
update dbo.BPP_L2_cliente_staging set DimensionCheckSum=
BINARY_CHECKSUM(CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione)

-- Inzia l'insert nella tabella L2 cliente SCD (che sara' la nostra tabella finale) tramite MERGE
insert into dbo.BPP_L2_cliente_SCD (CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, DimensionCheckSum)
--inserisci solo le righe che sono state cambiate
  select CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, DimensionCheckSum   
  from
    (
     MERGE into dbo.BPP_L2_cliente_SCD AS target
      USING 
      ( -- il sorgente: colonne dei attributi dalla staging table.
        SELECT CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, 
        DimensionCheckSum

        from dbo.BPP_L2_cliente_staging
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


-- Cancelliamo le righe di cui non ci serve mantenere la storicizzazione
DELETE FROM BPP_L2_cliente_SCD
WHERE CodiceCliente IN (
                        SELECT A.CodiceCliente
                        from BPP_L2_cliente_SCD as B, BPP_L2_cliente_SCD as A
                        where B.CodiceCliente = A.CodiceCliente and B.Professione = A.Professione AND A.FlagAttuale = 'NO' and (A.Nome <>B.Nome or
                        A.Cognome <>B.Cognome or A.Indirizzo <>B.Indirizzo or A.RagioneSociale <>B.RagioneSociale)
                        )
      and FlagAttuale = 'NO'

-- Stessa cosa ma per i clienti di tipo Business 
delete BPP_L2_cliente_SCD
where TipologiaCliente = 'Business' and FlagAttuale = 'NO'
 

 -- A questo punto popoliamo la nostra BPP_L2_dim_cliente con i dati della cliente L2 SCD. 
insert into BPP_L2_dim_cliente(CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, FlagAttuale)
  select CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataInizioProfessione, FlagAttuale 
  from BPP_L2_cliente_SCD







--TABELLA L2 CONTRATTO
    insert into dbo.BPP_L2_dim_contratto(CodiceContratto,TipologiaContratto,DataInizioFornitura,KWMassimi,TempoMassimoIntervento)
	select CodiceContratto,TipologiaContratto,DataInizioFornitura,KWMassimi,TempoMassimoIntervento
	from BPP_Contratto

-- TABELLA L2 OPERATORE
	insert into BPP_L2_dim_operatore(MatricolaOperatore,NomeOperatore, CognomeOperatore, NumeroTelefonoOperatore)
	select MatricolaOperatore, NomeOperatore, CognomeOperatore, NumeroTelefonoOperatore
	from BPP_Operatore

-- TABELLA CONTATORE
	insert into BPP_L2_dim_contatore(CodiceContatore, UltimiKWLetti, UltimaDataLettura, NomeAreaGeografica)
	select C.CodiceContatore, L.UltimiKWLetti, L.UltimaDataLettura,P.NomeAreaGeografica
    from  BPP_Contatore as C
    INNER JOIN BPP_Lettura as L ON L.CodiceContatore = C.CodiceContatore
    INNER JOIN (
    select LI.MatricolaOperatore, LI.CodiceAreaGeografica, A.NomeAreaGeografica
    from BPP_LAVORA_IN as LI
    INNER JOIN  BPP_AreaGeografica as A
    on LI.CodiceAreaGeografica = A.CodiceAreaGeografica ) AS P
    ON L.MatricolaOperatore = P.MatricolaOperatore




END
