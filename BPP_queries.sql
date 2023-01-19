#UPDATE BPP_Cliente
#SET [RagioneSociale] = 'N/A'
#WHERE [TipologiaCliente] = 'Privato';


select * from BPP_Cliente;


#ALTER TABLE BPP_Cliente
#ADD CONSTRAINT CK_NumeroTelefono
#CHECK (DATALENGTH(NumeroTelefono) = 10);
