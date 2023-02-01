--                                                     VINCOLI CLIENTE 

--UPDATE BPP_Cliente
--SET [RagioneSociale] = 'N/A'
--WHERE [TipologiaCliente] = 'Privato';

--select * from BPP_Cliente;
--select LEN(NumeroTelefono) from BPP_Cliente

--ALTER TABLE BPP_Cliente
--ADD CONSTRAINT CK_CodiceCliente
--CHECK (LEN(CodiceCliente) = 10);

--INSERT INTO BPP_Cliente(CodiceCliente,TipologiaCliente,Nome,Cognome,NumeroTelefono,Indirizzo,RagioneSociale,NomeReferente,CognomeReferente)
--VALUES ( '001967865-8','Privato','Letizia','Palumbo','0922817865','Via Dante','','','')

--UPDATE BPP_Cliente
--SET NomeReferente = NULL, CognomeReferente = NULL 
--WHERE TipologiaCliente = 'Privato'

--ALTER TABLE BPP_Cliente
--ADD CONSTRAINT CK_Privato
--CHECK (TipologiaCliente='Privato' AND (RagioneSociale='N/A' OR RagioneSociale = NULL) AND NomeReferente = NULL AND CognomeReferente = NULL);

--ALTER TABLE BPP_Cliente
--ADD CONSTRAINT CK_TipologiaCliente1
--CHECK(
--        TipologiaCliente='Privato' AND 
--                                 (RagioneSociale='N/A' OR RagioneSociale = NULL) AND
--                                  (NomeReferente = NULL AND CognomeReferente = NULL) 
--     OR TipologiaCliente='Business' AND  
--                                  (RagioneSociale !='N/A' OR RagioneSociale != NULL) AND
--                                  (NomeReferente != NULL AND CognomeReferente != NULL)
--);

--                                                       VINCOLI OPERATORE

--select LEN(MatricolaOperatore) from BPP_Operatore

--delete from BPP_Operatore
--select * from BPP_Operatore

--ALTER TABLE BPP_Operatore
--add constraint CK_MatricolaOperatore
--check (LEN(MatricolaOperatore) = 10);




--                                                             VINCOLI CONTRATTO

--ALTER TABLE BPP_Contratto
--add constraint CK_CodiceContratto
--check (LEN(CodiceContratto) = 10);


                                                            
--                                                             VINCOLI BOLLETTA

--ALTER TABLE BPP_Bolletta
--add constraint CK_DataEmissioneScadenza
--check (DataEmissione < DataScadenzaPagamento);




--                                                            VINCOLI CONTATORE

--ALTER TABLE [dbo].[BPP_Contatore]  WITH CHECK ADD  CONSTRAINT [FK__BPP_Contatore__Codic__6BFAA9D8] FOREIGN KEY([CodiceContratto])
--REFERENCES [dbo].[BPP_Contratto] ([CodiceContratto])
--GO







--                                                            TABELLA LETTURA

-- Auto Increment PK
--Alter table table_name modify column_name datatype(length) AUTO_INCREMENT PRIMARY KEY 


--                                                            TABELLA CITTA                                                            
--alter table BPP_Citta
--ADD FOREIGN KEY (CodiceAreaGeografica) REFERENCES BPP_AreaGeografica(CodiceAreaGeografica);


--                                                            TABELLA LAVORA_IN
--CREATE TABLE BPP_LAVORA_IN (
  --  MatricolaOperatore char(10) NOT NULL,
  --  CodiceAreaGeografica char(5) NOT NULL, 
  --  DataInizio date, 
  --  DataFine date, 
  --  PRIMARY KEY (MatricolaOperatore,CodiceAreaGeografica),
  --  FOREIGN KEY (MatricolaOperatore) REFERENCES BPP_Operatore(MatricolaOperatore),
  --  FOREIGN KEY (CodiceAreaGeografica) REFERENCES BPP_AreaGeografica(CodiceAreaGeografica) 
);



--														   TABELLA BOLLETTA
/*CREATE TABLE [dbo].[BPP_Contiene](
    [NumeroBolletta] [int] IDENTITY(1,1) NOT NULL,
    [CodiceContratto] [char](10) NOT NULL,
    [PeriodoRiferimento] [varchar](20) NOT NULL,
    [CodiceFasciaOraria] [char](1) NOT NULL,
    [Consumo] [decimal](6,2) NULL,
    PRIMARY KEY(NumeroBolletta, CodiceContratto,PeriodoRiferimento,CodiceFasciaOraria) ,
    FOREIGN KEY(NumeroBolletta, CodiceContratto,PeriodoRiferimento) REFERENCES BPP_Bolletta(NumeroBolletta, CodiceContratto,PeriodoRiferimento),
    FOREIGN KEY(CodiceFasciaOraria) REFERENCES BPP_FasciaOraria(CodiceFasciaOraria)
);   
*/


/*                                                   TABELLA BOLLETTA

SELECT Co.CodiceContratto, L.DataOraLettura, Co.CodiceContatore
from BPP_Contratto as C, BPP_Lettura AS L, BPP_Contatore as Co
where L.CodiceContatore = Co.CodiceContatore 
and Co.CodiceContratto = C.CodiceContratto

*/


