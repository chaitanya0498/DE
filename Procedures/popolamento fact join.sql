select * from BPP_L2_fact_bolletta
select 
--*
ChiaveTempo, ChiaveCliente, ChiaveContratto, ChiaveContatore, ChiaveOperatore, DataEmissione, BPP_Bolletta.PeriodoRiferimento, DataScadenzaPagamento, 
CodiceLettura, C1.Consumo as ConsumoFascia1, C2.Consumo As ConsumoFascia2, C3.Consumo As ConsumoFascia3, 
F1.PrezzoKWh as PrezzoKWhFascia1, F2.PrezzoKWh as PrezzoKWhFascia2, F3.PrezzoKWh as PrezzoKWhFascia3, 
C1.Consumo * F1.PrezzoKWh + C2.Consumo * F2.PrezzoKWh + C3.Consumo * F3.PrezzoKWh as SommaPagare 

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
								

select * from BPP_Bolletta
select * from BPP_FasciaOraria
select * from BPP_Contiene
select * from BPP_L2_dim_operatore				
select * from BPP_L2_fact_bolletta
select * from BPP_Cliente
select * from BPP_Contratto
select * from BPP_Contatore
select * from BPP_L2_dim_contatore

select * from BPP_L2_dim_cliente
--select * from BPP_L2_dim_contratto
