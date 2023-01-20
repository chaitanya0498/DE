--VINCOLI CLIENTE 
--[
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

--]



--VINCOLI OPERATORE
--[--select LEN(MatricolaOperatore) from BPP_Operatore

--delete from BPP_Operatore
--select * from BPP_Operatore

--ALTER TABLE BPP_Operatore
--add constraint CK_MatricolaOperatore
--check (LEN(MatricolaOperatore) = 10);




--VINCOLI CONTRATTO
--ALTER TABLE BPP_Contratto
--add constraint CK_CodiceContratto
--check (LEN(CodiceContratto) = 10);


















