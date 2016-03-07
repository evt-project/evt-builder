Introduzione
============ 

<br/>

###Che cos'è EVT

EVT (abbreviazione di Edition Visualization Technology) è un software per la creazione e la navigazione di edizioni digitali di manoscritti sulla base di testo codificato secondo lo standard TEI XML (http://www.tei-c.org/). Questo software è nato nell’ambito del progetto Vercelli Book Digitale (Archivio e Biblioteca Capitolare di Vercelli CXVII; sito del progetto: http://vbd.humnet.unipi.it/) per permettere la navigazione di tale manoscritto, di grande importanza per le ricerche sulla lingua e la letteratura anglosassone.
EVT si basa su tecnologie web standard e aperte, come HTML, CSS e Javascript, per essere sicuri che funzioni su tutti i navigatori web più recenti e sul Web quanto più a lungo possibile. Caratteristiche specifiche, come la lente d’ingrandimento, sono affidate a plugin jQuery, di nuovo scelti fra quelli open source e meglio supportati, in modo da ridurre il rischio di future incompatibilità con i navigatori. L’architettura generale del software, in ogni caso, è modulare, pertanto ogni componente che potrebbe causare problemi o rivelarsi non del tutto adatta allo scopo può essere sostituita con facilità.

###Come funziona
L’idea di base di EVT è molto simile al modus operandi che comunemente viene adottato per convertire documenti TEI XML in HTML: si applica un foglio di stile al documento, e viene avviato un processo di elaborazione che si conclude con un sito web contenente l’edizione. L’obiettivo ideale è infatti quello di avere uno strumento molto semplice e user friendly al quale affidare i propri dati, tale da richiedere pochissimo sforzo e nessuna conoscenza al di là della codifica XML da parte dello studioso. Per raggiungere questo obiettivo EVT si basa su una struttura modulare dove un singolo foglio di stile (evt_builder.xsl) avvia una serie di trasformazioni XSLT chiamando a turno tutti gli altri moduli. Questi ultimi appartengono a due categorie: moduli che hanno come compito la costruzione del sito HTML, e moduli di elaborazione dei file XML che estraggono il testo dell’edizione che si trova fra i marcatori di pagina (elementi `<pb/>`) e lo formattano in base al livello di edizione. Tutti i moduli XSLT risiedono nella cartella builder_pack, in modo da avere una gerarchia delle directory semplice e ben ordinata.

###Funzionalità
Al momento EVT può essere usato per creare edizioni basate su immagini con due possibili livelli del testo: edizione diplomatica e diplomatica-interpretativa. Questo significa che una trascrizione che faccia uso degli elementi messi a disposizione dal modulo TEI per la trascrizione di fonti primarie dovrebbe essere già pienamente compatibile con EVT, o richiedere solo piccole modifiche per divenire compatibile. Recentemente è stata aggiunta la possibilità di fare ricerche nei testi con qualunque livello di edizione, inoltre EVT permette di gestire le named entities e le liste collegate a queste ultime. La trascrizione del Vercelli Book segue gli schemi TEI standard senza fare uso di elementi o attributi personalizzati: i nostri test con file di altri progetti mostrano infatti un alto livello di compatibilità.
Per quanto riguarda il supporto alle immagini, caratteristiche come una lente d’ingrandimento, lo zoom, il collegamento testo-immagine e altre ancora sono già disponibili. Il collegamento testo-immagine è ispirato dal software Image Markup Tool sviluppato da Martin Holmes ed è stato implementato facendo uso di XSLT e CSS da uno dei collaboratori del progetto; tutte le altre caratteristiche sono basate su plugin jQuery.


***
<br/>

Guida rapida
============

<br/>
###Installazione
EVT non necessita di procedure di installazione particolari, una volta decompresso l'archivio in una cartella di vostra scelta il software è pronto per l'uso.
	
###Configurazione
Ci sono diversi modi di personalizzare EVT, il più importante consiste nel modificare il file builder_pack/modules/evt_builder-conf.xsl per configurare i parametri disponibili in modo che l'interfaccia utente corrisponda ai dati dell'edizione. Fare riferimento al manuale di EVT (cartella doc) per ulteriori informazioni su questo file e su altri metodi di personalizzazione dell'output di EVT.

###Manuale di EVT
Nella cartella "doc" è disponibile una versione preliminare del manuale di EVT, questo è il principale punto di riferimento riguardo l'uso e la personalizzazione del software.

###Feedback
Per favore inviare ogni commento, suggerimento, bug report etc. a roberto.rossellidelturco@gmail.com oppure a evt.developers@gmail.com.
