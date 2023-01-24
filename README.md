# DE

(a) 
ER DIAGRAM
Open this repository's github link on draw.io

(b)
SCHEMA LOGICO RELAZIONALE

1. CLIENTE
(CODICE_CLIENTE, TipologiaCliente, Nome, Cognome, NumeroTelefono, Indirizzo, RagioneSociale, NomePersonaRif., CognomePersonaRif.)

2. CONTRATTO
(CODICE_CONTRATTO, Tipologia Contratto, IndirizzoLocale, DataStipulaContratto, DataInizioFornitura, CodiceCliente(FK), KWMassimi, TempoMassimoIntervento)

3. CONTATORE
(CODICE_ALFANUMERICO, Modello, KWMassimiErogabili, CodiceContratto(FK), DataInstallazione)

4. LETTURA
(CODICE_ALFANUMERICO(FK), MATRICOLA OPERATORE(FK), KwLettiSulContatore, Data, Ora)

5. FASCIA ORARIA
(CODICE_ALFANUMERICO, OraInizioValidità, OraFineValidità, Prezzo KWh, Consumo)

6. BOLLETTA
(NUMERO_PROGRESSIVO, CODICE_CONTRATTO, DataEmissione, PeriodoRiferimento, QuantitàCorrenteErogata, DataScadenzaPagamento, SommaDaPagare, **CorrenteConsumata, CodiceFasciaOraria(FK))     
**
7. OPERATORE
(MATRICOLA, Nome, Cognome, NumeroCellulare)

LAVORA IN 
(MATRICOLA_OPERATORE, CODICE_ALFANUMERICO_AreaGeografica, DataInizio, DataFine)

8. AREA GEOGRAFICA(CodiceAreaGeografica, NomeAreaGeografica)

9. CITTA (NomeCittà, CodiceCitta, CodiceAreaGeografica)





Si vuole realizzare una base di dati per la gestione di alcune attivit`a di un ditta che fornisce
energia elettrica.
• I clienti della ditta sono univocamente identificati da un codice cliente. I clienti privati
sono caratterizzati da nome, cognome, indirizzo e da un numero di telefono. I clienti di
tipo business sono caratterizzati da ragione sociale, indirizzo, numero di telefono, nome e
cognome della persona di riferimento.


• I contratti sono univocamente identificati da un codice contratto e sono caratterizzati
dall’indirizzo del locale per cui si stipula il contratto, dalla data di stipula del contratto,
dalla data d’inizio di fornitura del servizio (se gi`a nota), dai clienti intestatari del contratto
e dai kW massimi erogabili. Per i contratti di tipo business `e noto il tempo massimo di
intervento in seguito ad un guasto.

• Gli operatori della ditta sono caratterizzati da una matricola univoca e da nome, cognome
e numero di cellulare.

• I contatori sono univocamente identificati da un codice alfanumerico e sono caratterizzati
da modello, kW massimi erogabili, data di installazione e contratto a cui si riferiscono. Si
memorizzano le letture dei contatori. Ogni lettura `e caratterizzata dal contatore a cui si
riferisce, dall’operatore che ha effettuato la lettura, dal valore in kWh letto sul contatore,
dalla data e dall’ora in cui `e stata effettuata. Si tenga presente che nel corso della stessa
data per ogni contatore si effettua al massimo una lettura.

• Ogni bolletta `e univocamente identificata da un numero progressivo all’interno dell’anno e
del contratto per cui `e emessa, ed `e caratterizzata dal periodo temporale a cui si riferisce,
dalla data di emissione, dalla data di scandenza del pagamento, dalla somma da pagare e
dalla quantit`a totale di corrente consumata espressa in kWh.


• Il prezzo al kWh della corrente dipende dalla fascia oraria in cui la corrente `e erogata. Le
fasce orarie sono univocamente identificate da un codice alfanumerico e sono caratterizzate
da un’ora d’inizio validit`a, da un’ora di fine validit`a e dal prezzo al kWh. Memorizzare per
ogni bolletta la quantit`a di corrente totale erogata, espessa in kWh, relativamente a ogni
fascia oraria.


• Le aree geografiche presso cui la ditta fornisce la corrente sono univocamente identificate
da un codice alfanumerico e sono caratterizzate da un elenco di citt`a. Ogni citt`a appartiene
al massimo ad un’area geografica. Si memorizzano i periodi di tempo (data d’inizio, data
di fine) nei quali un operatore lavora presso un’area. 
#########
In particolare, ogni operatore pu`o lavorare in tempi diversi presso le stesse aree geografiche, ma anche presso aree geografiche
diverse nello stesso periodo temporale.
#########




(a) (8 punti) Descrivere con un diagramma E-R lo schema concettuale di una base di dati per
tale applicazione.
(b) (4 punti) Costruire uno schema logico relazionale normalizzato per la stessa base di dati.




VINCOLI D'INTEGRITA' REFERENZIALE























