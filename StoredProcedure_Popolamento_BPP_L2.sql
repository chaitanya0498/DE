/****** Object:  StoredProcedure [dbo].[BPP_L2_popolamento]    Script Date: 01/02/2023 11:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Letizia, Federico, Chaitanya>
-- Create Date: 31-01-2023
-- Description: Popolamento delle tabelle L2 da L1 (1.troncare, 2.inserire valori null, 3.popola le tabelle L2)
-- =============================================
ALTER PROCEDURE [dbo].[BPP_L2_popolamento]

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here

-- 1.svuotare le tabelle L2

--	truncate table dbo.BPP_L2_fact_bolletta
	delete dbo.BPP_L2_dim_cliente 
	delete dbo.BPP_L2_dim_contatore 
	delete dbo.BPP_L2_dim_contratto 
	delete dbo.BPP_L2_dim_operatore

	DBCC checkident(BPP_L2_dim_cliente, reseed, -1);
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
insert into dbo.BPP_L2_dim_cliente(CodiceCliente,TipologiaCliente,Nome,Cognome,
    Indirizzo,RagioneSociale,Professione,DataInizioProfessione)
select CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataAggiornamento
from BPP_Cliente

UPDATE BPP_L2_dim_cliente
SET FlagAttuale =
 (select CASE
    Row_number() 
                OVER( 
                  partition BY CodiceCliente 
                  ORDER BY DataInizioProfessione DESC)
    WHEN 1 THEN 'SI'
    ELSE 'NO'
  END)

--TABELLA L2 CONTATORE



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
