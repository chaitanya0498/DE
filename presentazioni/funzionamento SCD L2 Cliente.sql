-- PANORAMA DELLA DB
select * from BPP_L2_dim_tempo
select * from BPP_L2_dim_contatore
select * from BPP_L2_dim_contratto
select * from BPP_L2_dim_operatore


--CLIENTE L2: PROVA DELLA FUNZIONALITà SCD L2
--Tipi di prove: Cambio Professione (SCD-2) e/o Cambio Indirizzo in L1

select * from BPP_Cliente
select * from BPP_L2_dim_cliente order by CodiceCliente



-- 1. modifica della professione in L1 di Fabio
		update BPP_Cliente
		set Professione = 'Primario', DataAggiornamento = GETDATE()
		where CodiceCliente = '02467877-8'
		select * from BPP_Cliente

		-- eseguire la procedura di popolamento/aggiornamento del L2 
		DECLARE	@return_value int
		EXEC	@return_value = [dbo].[BPP_L2_2_popolamento]
		SELECT	'Return Value' = @return_value
		GO

		--visualizzare i resultati
		select * from BPP_L2_dim_cliente order by CodiceCliente
		select * from BPP_Cliente


-- 2. modifica dell'indirizzo del Giacomo (il suo record non è stata aggiornata prima)
	
		update BPP_Cliente
		set Indirizzo = 'Via del Borghetto 12, Milano (MI)' 
		where CodiceCliente = '02167877-8'
		select * from BPP_Cliente

		-- eseguire la procedura di popolamento/aggiornamento del L2 
		DECLARE	@return_value int
		EXEC	@return_value = [dbo].[BPP_L2_2_popolamento]
		SELECT	'Return Value' = @return_value
		GO

		--visualizzare i resultati
		select * from BPP_L2_dim_cliente order by CodiceCliente
		select * from BPP_Cliente


-- 4. inserimento di un nuovo record in L1 (per controllare se le chiave siano consistenti)

		insert into BPP_Cliente
		values ('09967879-0', 'Privato', 'Adolfo', 'Fogacci', '3454335120', 'Via della Indipendenza 7, Prato (PO)', null, 'Sviluppatore', GETDATE(), null, null)
		select * from BPP_Cliente


		-- eseguire la procedura di popolamento/aggiornamento del L2 
		DECLARE	@return_value int
		EXEC	@return_value = [dbo].[BPP_L2_2_popolamento]
		SELECT	'Return Value' = @return_value
		GO

		--visualizzare i resultati
		select * from BPP_L2_dim_cliente










-- Dubbio - modifica dell'indirizzo del Mario Rossi, PER CUI ABBIAMO CAMBIATO UNA PROFESSIONE PRECEDENTEMENTE -> perdiamo la storicizzazione

		update BPP_Cliente
		set Indirizzo = 'Via Nuova 16, Novara (NO)'
		where CodiceCliente = '02067877-8'

		select * from BPP_Cliente

		-- eseguire la procedura di popolamento/aggiornamento del L2 
		DECLARE	@return_value int
		EXEC	@return_value = [dbo].[BPP_L2_2_popolamento]
		SELECT	'Return Value' = @return_value
		GO

		select * from BPP_L2_dim_cliente order by CodiceCliente


		-- Diremo al utente di fare questo tipo del aggiornamento nel modo seguente:
		-- Proviamo ad aggiornare sia Indirizzo , ma anche la professione (se non ha cambiato professione, cmq rimettiamolo uguale come vecchio)
		update BPP_Cliente
		set Indirizzo = 'Via Nuova 16, Novara (NO)' , Professione = ' Tirocinante'
		where CodiceCliente = '02067877-8'

		select * from BPP_Cliente

		-- eseguire la procedura di popolamento/aggiornamento del L2 
		DECLARE	@return_value int
		EXEC	@return_value = [dbo].[BPP_L2_2_popolamento]
		SELECT	'Return Value' = @return_value
		GO

		select * from BPP_L2_dim_cliente order by CodiceCliente
