-- PROVE PER CREARE LA TABELLA DEI FATTI


select L2_Cl.ChiaveCliente, L2_Co.ChiaveContratto, L2_Ct.ChiaveContatore, L2_Op.ChiaveOperatore, L1_Bo.DataEmissione, L1_Bo.PeriodoRiferimento,
L1_Bo.DataScadenzaPagamento, L1_L.CodiceLettura, ProfessioneClienteAttuale

from BPP_Contratto as L1_Co, BPP_L2_dim_contratto as L2_Co,
     BPP_Contatore as L1_Ct,BPP_L2_dim_contatore as L2_Ct,
	 BPP_Cliente as L1_Cl,BPP_L2_dim_cliente as L2_Cl, 
	 BPP_Bolletta as L1_Bo, BPP_L2_fact_bolletta as L2_Bo, 
	 BPP_Operatore as L1_Op, BPP_L2_dim_operatore as L2_Op,
	 BPP_Lettura as L1_L


where L1_Cl.CodiceCliente = L1_Co.CodiceCliente and L1_Cl.CodiceCliente = L2_Cl.CodiceCliente
and  L1_Co.CodiceContratto = L2_Co.CodiceContratto and L1_Co.CodiceContratto = L1_Bo.CodiceContratto 
and L1_Co.CodiceContratto = L1_Ct.CodiceContratto and L1_Ct.CodiceContatore = L2_Ct.CodiceContatore
and L1_L.CodiceContatore = L1_Ct.CodiceContatore and L1_L.MatricolaOperatore = L1_Op.MatricolaOperatore 




select * from BPP_L2_dim_cliente where Nome = 'Mario'
select * from BPP_Contratto 
select * from BPP_L2_dim_contratto
select * from BPP_contatore
select * from BPP_L2_dim_contatore



--insert into BPP_L2_fact_bolletta(ChiaveTempo,ChiaveCliente,ChiaveContratto,ChiaveContatore,ChiaveOperatore,DataEmissione,
--PeriodoRiferimento,DataScadenzaPagamento,CodiceLettura,ConsumoFascia1,ConsumoFascia2,ConsumoFascia3,PrezzoKWhFascia1,PrezzoKWhFascia2,
--PrezzoKWhFascia3,TotaleDaPagare,ProfessioneClienteAttuale)
/*
SELECT L1_Cn.Consumo as ConsumoFascia1
	FROM BPP_Contiene as L1_Cn
	WHERE L1_Cn.CodiceFasciaOraria = 1,

	SELECT L1_Cn.Consumo as ConsumoFascia2
	FROM BPP_Contiene as L1_Cn
	WHERE L1_Cn.CodiceFasciaOraria = 2, 
	SELECT L1_Cn.Consumo as ConsumoFascia3
	FROM BPP_Contiene as L1_Cn
	WHERE L1_Cn.CodiceFasciaOraria = 3,

	SELECT L1_Fo.PrezzoKWh as PrezzoKWhFascia1 FROM BPP_FasciaOraria as L1_Fo WHERE L1_Fo.CodiceFasciaOraria = 1,
	SELECT L1_Fo.PrezzoKWh as PrezzoKWhFascia2 FROM BPP_FasciaOraria as L1_Fo WHERE L1_Fo.CodiceFasciaOraria = 2,
	SELECT L1_Fo.PrezzoKWh as PrezzoKWhFascia3 FROM BPP_FasciaOraria as L1_Fo WHERE L1_Fo.CodiceFasciaOraria = 3,


	SELECT (L1_Cn.ConsumoFascia1* L1_Fo.PrezzoKWhFascia1) + (L1_Cn.ConsumoFascia2 * L1_Fo.PrezzoKWhFascia1) + (L1_Cn.ConsumoFascia3 * L1_Fo.PrezzoKWhFascia1) AS TotaleDaPagare
	from BPP_Contiene as L1_Cn, BPP_FasciaOraria as L1_Fo
	where L1_Fo.CodiceFasciaOraria = L1_Cn.CodiceFasciaOraria ,
	*/

	/*
	select T.ChiaveTempo, L2_C.ChiaveCliente, L2_Ct.ChiaveContratto, L2_Co.ChiaveContatore, L2_Op.ChiaveOperatore, L1_Bo.DataEmissione, L1_Bo.PeriodoRiferimento,
L1_Bo.DataScadenzaPagamento, L1_Le.CodiceLettura, ProfessioneClienteAttuale
from BPP_L2_dim_tempo as T
left join BPP_L2_fact_bolletta as L2_B on L2_B.ChiaveTempo = T.ChiaveTempo
left join BPP_L2_dim_cliente as L2_C on L2_B.ChiaveCliente = L2_C.ChiaveCliente
left join BPP_L2_dim_contratto as L2_Ct on L2_B.ChiaveContratto = L2_Ct.ChiaveContratto
left join BPP_L2_dim_contatore as L2_Co on L2_B.ChiaveContatore = L2_Co.ChiaveContatore
left join BPP_L2_dim_operatore as L2_Op on L2_B.ChiaveOperatore = L2_Op.ChiaveOperatore
left join BPP_Bolletta as L1_Bo on L1_Bo.CodiceContratto = L2_Ct.CodiceContratto
left join BPP_Lettura as L1_Le on L1_Le.MatricolaOperatore = L2_Op.MatricolaOperatore
left join BPP_Contratto as L1_Co on L1_Co.CodiceContratto= L1_Bo.CodiceContratto
left join BPP_Cliente as L1_Cl on L1_Cl.CodiceCliente= L1_Co.CodiceCliente
*/