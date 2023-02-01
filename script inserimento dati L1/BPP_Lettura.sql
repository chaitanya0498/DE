create table BPP_Lettura(
	CodiceLettura uniqueidentifier not null primary key,
	CodiceContatore uniqueidentifier FOREIGN KEY REFERENCES BPP_Contatore(CodiceContatore),
	MatricolaOperatore varchar FOREIGN KEY REFERENCES BPP_Operatore(MatricolaOperatore),
	KWLetti decimal(5,3),
	DataOraLettura datetime,
	)
	