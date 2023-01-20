--UPDATE BPP_Cliente
--SET [RagioneSociale] = 'N/A'
--WHERE [TipologiaCliente] = 'Privato';


select * from BPP_Cliente;


#ALTER TABLE BPP_Cliente
#ADD CONSTRAINT CK_NumeroTelefono
#CHECK (DATALENGTH(NumeroTelefono) = 10);


#INSERT INTO BPP_Cliente(CodiceCliente,TipologiaCliente,Nome,Cognome,NumeroTelefono,Indirizzo,RagioneSociale,NomeReferente,CognomeReferente)
#VALUES ( '001967865-8','Privato','Letizia','Palumbo','0922817865','Via Dante','','','')


--UPDATE BPP_Cliente
--SET NomeReferente = NULL, CognomeReferente = NULL 
--WHERE TipologiaCliente = 'Privato'


#ALTER TABLE BPP_Cliente
#ADD CONSTRAINT CK_Privato
#CHECK (TipologiaCliente='Privato' AND (RagioneSociale='N/A' OR RagioneSociale = NULL) AND NomeReferente = NULL AND CognomeReferente = NULL);