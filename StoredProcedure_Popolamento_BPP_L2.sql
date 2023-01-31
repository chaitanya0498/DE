-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Letizia, Federico, Chaitanya>
-- Create Date: 31-01-2023
-- Description: Popolamento delle tabelle L2 da L1 (1.troncare, 2.inserire valori null, 3.popola le tabelle L2)
-- =============================================
CREATE PROCEDURE BPP_L2_popolamento

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here

-- 1.svuotare le tabelle L2

--truncate table BPP_L2_dim_cliente ??????????????
--truncate table BPP_L2_dim_contratto
--truncate table BPP_L2_dim_contatore
truncate table BPP_L2_dim_operatore


-- TABELLA L2 OPERATORE

-- inserimento valori null
	insert into dbo.BPP_L2_dim_operatore(MatricolaOperatore,NomeOperatore,CognomeOperatore,NumeroTelefonoOperatore)
	values('0000000000',null,null,null)

-- popolamento dati
	insert into BPP_L2_dim_operatore(MatricolaOperatore,NomeOperatore, CognomeOperatore, NumeroTelefonoOperatore)
	select MatricolaOperatore, NomeOperatore, CognomeOperatore, NumeroTelefonoOperatore
	from BPP_Operatore

-- visualizzare la tabella
	select * from BPP_L2_dim_operatore


END
GO
