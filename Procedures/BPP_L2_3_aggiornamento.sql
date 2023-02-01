-- =======================================================
-- Create Stored Procedure Template for Azure SQL Database
-- =======================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Letizia, Federico, Chaitanya>
-- Create Date: <01-02-2023>
-- Description: <Procedura per aggiornamento L2 cliente>
-- =============================================
ALTER PROCEDURE BPP_L2_3_aggiornamento
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
-- PREREQUISITI:
-- 1. Le tabelle in L1 sono state popolate
-- 2. La procedura di popolamento ha popolato le tabelle in L2
-- TO DO
-- 1. Vogliamo aggiornare la tabella BPP_L2_dim_cliente per gestire in modo corretto la storicizzazione di 'Professione'

-- Questo codice aggiunge una nuova riga alla nostra dimensione cliente solo se la professione è cambiata
INSERT INTO dbo.BPP_L2_dim_cliente(CodiceCliente,TipologiaCliente,Nome,Cognome,
    Indirizzo,RagioneSociale,Professione,DataInizioProfessione)
select CodiceCliente, TipologiaCliente, Nome, Cognome, Indirizzo, RagioneSociale, Professione, DataAggiornamento
from BPP_Cliente as a
WHERE EXISTS  
(SELECT b.CodiceCliente, b.TipologiaCliente,b.Nome, b.Cognome,b.RagioneSociale,b.Professione,b.DataInizioProfessione
FROM BPP_L2_dim_cliente AS b  
WHERE b.CodiceCliente = a.CodiceCliente and b.Professione <> a.Professione)
  
-- Questo codice crea una tabella temporanea che ci servirà al posso successivo
create table BPP_L2_cliente_flag_professione (
CodiceCliente varchar(20),
Professione varchar(50),
FlagAttuale char(2)
)

-- Svuotiamo la tabella
truncate table BPP_L2_cliente_flag_professione

-- Inseriamo i dati nella tabella temporana mettendo 'SI' e 'NO' in base all'ordinamento della data
insert into BPP_L2_cliente_flag_professione (CodiceCliente, Professione, FlagAttuale)
 select CodiceCliente, Professione, CASE
    Row_number() 
                OVER( 
                  partition BY C2.CodiceCliente 
                  ORDER BY C2.DataInizioProfessione DESC)
    WHEN 1 THEN 'SI'
    ELSE 'NO'
  END from BPP_L2_dim_cliente as C2

--select * from BPP_L2_cliente_flag_professione

-- Aggiorniamo la dimensione cliente modificando il FlagAttule dove necessario
update BPP_L2_dim_cliente
set BPP_L2_dim_cliente.FlagAttuale = BPP_L2_cliente_flag_professione.FlagAttuale
from BPP_L2_dim_cliente, BPP_L2_cliente_flag_professione
where BPP_L2_dim_cliente.CodiceCliente = BPP_L2_cliente_flag_professione.CodiceCliente and BPP_L2_dim_cliente.Professione = BPP_L2_cliente_flag_professione.Professione

END


