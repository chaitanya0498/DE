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



--                                                           VINCOLI FASCIA ORARIA

--ALTER TABLE BPP_FasciaOraria
--add constraint CK_OraInizioFineValidita
--check (OraInizioValidità < OraFineValidità);




--                                                            VINCOLI CONTATORE

--ALTER TABLE [dbo].[BPP_Contatore]  WITH CHECK ADD  CONSTRAINT [FK__BPP_Contatore__Codic__6BFAA9D8] FOREIGN KEY([CodiceContratto])
--REFERENCES [dbo].[BPP_Contratto] ([CodiceContratto])
--GO














