/****** Object:  StoredProcedure [dbo].[BPP_L2_2_popolamento]    Script Date: 06/02/2023 11:30:11 ******/
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

	truncate table dbo.BPP_L2_fact_bolletta
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
      
      -- Se questi codici cliente corrispondono ma le CheckSum sono diversi, allora il record ? cambiato;
      -- quindi, aggiornare il record esistente nel target, e set FLAG ATTUALE a NO
      
      WHEN MATCHED and target.DimensionCheckSum <> source.DimensionCheckSum and target.FlagAttuale='SI'
      THEN 
      UPDATE SET  
        FlagAttuale='NO'
  
      -- Se invece questi codici cliente NON corrispondono, vuol dire il record ? nuovo, e
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

-- TABELLA DEI FATTI 
   insert into BPP_L2_fact_bolletta( ChiaveTempo,ChiaveCliente,ChiaveContratto,ChiaveContatore,ChiaveOperatore, DataEmissione,PeriodoRiferimento,
   DataScadenzaPagamento,CodiceLettura,ConsumoFascia1,ConsumoFascia2,ConsumoFascia3,PrezzoKWhFascia1,PrezzoKWhFascia2,PrezzoKWhFascia3,
   TotaleDaPagare,ProfessioneClienteAttuale)
	select 
	ChiaveTempo, ChiaveCliente, ChiaveContratto, ChiaveContatore, ChiaveOperatore, DataEmissione, BPP_Bolletta.PeriodoRiferimento, DataScadenzaPagamento, 
	CodiceLettura, C1.Consumo as ConsumoFascia1, C2.Consumo As ConsumoFascia2, C3.Consumo As ConsumoFascia3, 
	F1.PrezzoKWh as PrezzoKWhFascia1, F2.PrezzoKWh as PrezzoKWhFascia2, F3.PrezzoKWh as PrezzoKWhFascia3, 
	C1.Consumo * F1.PrezzoKWh + C2.Consumo * F2.PrezzoKWh + C3.Consumo * F3.PrezzoKWh as SommaPagare,BPP_Cliente.Professione 

	from BPP_Bolletta
	left join BPP_L2_dim_contratto
	on BPP_L2_dim_contratto.CodiceContratto = BPP_Bolletta.CodiceContratto
	

		left join BPP_Contatore 
		on BPP_L2_dim_contratto.CodiceContratto = BPP_Contatore.CodiceContratto
	
		left join BPP_L2_dim_contatore
		on BPP_Contatore.CodiceContatore = BPP_L2_dim_contatore.CodiceContatore

			left join BPP_Contratto
			on BPP_Contratto.CodiceContratto = BPP_Bolletta.CodiceContratto

			left join BPP_Cliente
			on BPP_Cliente.CodiceCliente = BPP_Contratto.CodiceCliente

			left join BPP_L2_dim_cliente
			on BPP_L2_dim_cliente.CodiceCliente = BPP_Cliente.CodiceCliente

				left join BPP_Lettura
				on BPP_Lettura.CodiceContatore = BPP_Contatore.CodiceContatore

					--per chiave operatore
					left join BPP_L2_dim_operatore
					on BPP_L2_dim_operatore.MatricolaOperatore = BPP_Lettura.MatricolaOperatore

						--per i 3 consumi
						left join BPP_Contiene as C1
						on C1.NumeroBolletta = BPP_Bolletta.NumeroBolletta and C1.CodiceContratto = BPP_Bolletta.CodiceContratto
						and C1.CodiceFasciaOraria = 1

						left join BPP_Contiene as C2
						on C2.NumeroBolletta = BPP_Bolletta.NumeroBolletta and C2.CodiceContratto = BPP_Bolletta.CodiceContratto
						and C2.CodiceFasciaOraria = 2
						
						left join BPP_Contiene as C3
						on C3.NumeroBolletta = BPP_Bolletta.NumeroBolletta and C3.CodiceContratto = BPP_Bolletta.CodiceContratto
						and C3.CodiceFasciaOraria = 3

							--per PrezzoKWH per 3 fascie orarie
							left join BPP_FasciaOraria as F1
							on F1.CodiceFasciaOraria = C1.CodiceFasciaOraria

							left join BPP_FasciaOraria as F2
							on F2.CodiceFasciaOraria = C2.CodiceFasciaOraria

							left join BPP_FasciaOraria as F3
							on F3.CodiceFasciaOraria = C3.CodiceFasciaOraria

							--chiaveTempo
								left join BPP_L2_dim_tempo
								on BPP_L2_dim_tempo.Data = BPP_Bolletta.DataEmissione

END
GO


