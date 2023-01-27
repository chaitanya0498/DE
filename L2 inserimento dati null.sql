insert into BPP_L2_Contratto (
      [CodiceContratto]
      ,[TipologiaContratto]
      ,[IndirizzoLocale]
      ,[DataInizioFornitura]
      ,[DataStipulaContratto]
      ,[KWMassimi]
      ,[TempoMassimoIntervento]
)
values ('0', null, null, null, null, null, null)

select * from BPP_L2_Contratto


insert into BPP_L2_Cliente ([CodiceCliente]
      ,[TipologiaCliente]
      ,[NomeCliente]
      ,[CognomeCliente]
      ,[NumeroTelefono]
      ,[Indirizzo]
      ,[RagioneSociale]
      ,[NomePersonaRiferimento]
      ,[CognomePersonaRiferimento])
values ('0', null, null, null, null, null, null, null, null)

select * from BPP_L2_Cliente


insert into BPP_L2_Contatore([CodiceContatore]
      ,[Modello]
      ,[KWMassimiErogabili]
      ,[DataInstallazione]
      ,[CodiceLettura]
      ,[KWLetti]
      ,[DataLettura]
      ,[MatricolaOperatore]
      ,[NomeOperatore]
      ,[CognomeOperatore]
      ,[NumeroTelefonoOperatore])

values ('0', null, null,null,'0',null,null,'0',null,null,null)

select * from BPP_L2_Contatore


insert into BPP_L2_Tempo([Data]
      ,[Anno]
      ,[Mese]
      ,[Giorno]
      ,[DescrizioneData]
      ,[GiornoSettimana]
      ,[DescrizioneMeseAnno]
      ,[Weekday/Weekend])
values('1900-01-01','1900','01','01',null,null,'gennaio 1900',null)

select * from BPP_L2_Tempo
