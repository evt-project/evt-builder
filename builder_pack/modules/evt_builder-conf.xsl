<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:eg="http://www.tei-c.org/ns/Examples"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="#all">
	
	<xd:doc type="stylesheet">
		<xd:short>
			EN: This file collects parameters and configurable variables used in the other modules.
			IT: Questo file è una collezione di parametri e variabili configurabili, usati negli altri moduli.
		</xd:short>
	</xd:doc>
	
	<!-- GLOBAL -->
	<!-- EN: The global variable $root is in the file evt_builder-copy_and_call_main.xsl-->
	<!-- IT: La variabile globale $root si trova nel file evt_builder-copy_and_call_main.xsl-->
	
	<!-- Parameters -->
	<!-- EN: It is possible to modify these prefixes so that they point to a custom web site, for instance:
		<xsl:param name="filePrefix" select="'http://tuosito.it/evtb'"/>
	-->	
	<!-- IT: E' possibile modificare i prefissi per puntare ad un server personalizzato, ad esempio:
		<xsl:param name="filePrefix" select="'http://tuosito.it/evtb'"/>
	-->	
	<xsl:param name="mainPrefix" select="'.'"/> <!-- index -->
	<xsl:param name="filePrefix" select="'../../..'"/> <!-- file path -->
	<xsl:param name="dataPrefix" select="'../..'"/> <!-- page -->
	
	<xsl:param name="webSite" select="'http://pelavicino.labcd.unipi.it'"/> <!-- index -->
	<!-- EN: Index title -->
	<!-- IT: Titolo edizione -->
	<!-- default: 'Codex Viewer' -->
	<!--<xsl:param name="index_title" select="'Codex Viewer'"/>-->
	<!--<xsl:param name="index_title" select="'The Digital Vercelli Book'"/>-->
	<xsl:param name="index_title" select="'Codice Pelavicino'"/>
	
	<!-- EN: Hide/Show scans -->
	<!-- IT: Nascondi/Mostra scansioni -->
	<!-- default: true() -->
	<xsl:param name="image_frame" select="true()"/>
	
	<!-- EN: Hide/Show badge -->
	<!-- IT: Nascondi/Mostra badge -->
	<!-- default: true() -->
	<xsl:param name="badge" select="true()"/>
	<!-- EN: Set text in badge -->
	<!-- IT: Imposta testo del badge -->
	<!-- ex: alpha, beta, stable etc -->	
	<xsl:param name="badge_text" select="'DIGITAL'"/>
	
	<!-- EN: On/Off doubleview -->
	<!-- IT: Attiva/Disattiva vista doppia pagina -->
	<!-- default: true() -->
	<xsl:param name="double_view" select="true()"/>
	
	<!-- ################ -->
	<!-- PREFATORY MATTER -->
	<!-- ################ -->
	
	<!-- EN: On/Off regesto -->
	<!-- IT: Attiva/Disattiva regesto -->
	<!-- default: false() -->
	<xsl:param name="regesto" select="true()"/>
	
	<!-- EN: On/Off Front Information -->
	<!-- IT: Attiva/Disattiva Front Information -->
	<!-- default: true() -->
	<xsl:param name="frontInfo" select="false()"/>
	
	<!-- EN: On/Off Manuscript Description -->
	<!-- IT: Attiva/Disattiva Descrizione del manoscritto-->
	<!-- default: true() -->
	<xsl:param name="msDesc" select="true()"/>
	
	<!-- EN: On/Off Header information -->
	<!-- IT: Attiva/Disattiva Informazioni generali -->
	<!-- default: true() -->
	<xsl:param name="headerInfo" select="true()"/>
	
	<!-- ############## -->
	<!-- EDITION LEVELS -->
	<!-- ############## -->
	<!-- EN: To use it in your code:
		<xsl:value-of select="$edition_array[n]" />	-->
	<!-- IT: Per l'utilizzo nel codice:
		<xsl:value-of select="$edition_array[n]" />	-->
	
	<!-- EN: It is possible to skip production of pages for a specific edition simply removing the textual part of the corresponding item. -->
	<!-- IT: E' possibile rimuovere la produzione di pagine di una determinata edizione semplicemente rimuovendo la parte testuale dell'item corrispondente. -->
	<xsl:variable name="edition_array" as="element()*">
		<edition></edition> 
		<!-- EN: If you have diplomatic edition put <edition>Diplomatic</edition>.  
			 	 If you DON'T have diplomatic edition put <edition></edition> -->
		<!-- IT: Se si ha l'edizione diplomatica scrivere <edition>Diplomatic</edition>.  
			 	 Se NON si ha l'edizione diplomatica mettere <edition></edition> -->
		
		<!-- EN: For processing in the modules: $edition_array[1] --> <!-- IT: Per l'elaborazione nei moduli: $edition_array[1] -->
		
		<edition>Interpretative</edition>	
		<!-- EN: If you have diplomatic edition put <edition>Interpretative</edition>.  
			 	 If you don't have diplomatic edition put <edition></edition> -->
		<!-- IT: Se si ha l'edizione interpretativa scrivere <edition>Interpretative</edition>.  
			 	 Se NON si ha l'edizione interpretativa mettere <edition></edition> -->
		
		<!-- EN: For processing in the modules: $edition_array[2] --> <!-- IT: Per l'elaborazione nei moduli: $edition_array[2] -->					
		
		<!-- EN: To add a new edition it is necessary to add a new line here and -forcedly- a declaration concerning output file in the modules/evt_builder-main.xsl file, under the <xsl:if test="$edition_array[2]!=''" condition>
				For instance: <edition>New_edition</edition> -->
		<!-- IT: Per aggiungere una nuova edizione, bisognerà inserire una nuova riga qui e -necessariamente- la dichiarazione per i file di output nel file modules/evt_builder-main.xsl, sotto la condizione <xsl:if test="$edition_array[2]!=''">
				Esempio: <edition>Nuova_edizione</edition> -->    
	</xsl:variable>
	
	<!-- EN: It is possibile to customize the prefix used in the creation of the classes of the html elements of the edition -->
	<!-- IT: E' possibile personalizzare il prefisso usato nella creazione delle classi degli elementi html di un edizione. -->
	<xsl:variable name="ed_name1">facs</xsl:variable>
	<xsl:variable name="ed_name2">dipl</xsl:variable>
	
	<!-- Variable -->
	
	<!-- Thumb image -->
	<xsl:variable name="fb_thumb">thumb_fb.jpg</xsl:variable>
	
	<!--
	<xsl:variable name="title" select="teiHeader/fileDesc/titleStmt/title" />
    <xsl:variable name="author" select="teiHeader/fileDesc/titleStmt/author" />
    <xsl:variable name="publisher" select="teiHeader/fileDesc/publicationStmt/publisher" />
    <xsl:variable name="pubdate" select="teiHeader/fileDesc/publicationStmt/date" />
	-->
	
	
	<!-- EN: Indicate the xml node that contains all the text to be transformed for each edition level -->
    <!-- IT: Indicare il nodo xml che contiene il testo da trasformare per ogni livello di edizione -->
    <xsl:variable name="ed_content" select="if(//tei:text/tei:group[@xml:id='group']) then(//tei:text/tei:group[@xml:id='group']/name()) else ( //tei:body/name() )"/> 
    
    
    <!-- EN: Starting point for the split of elements containing pb and lb -->
    <!-- IT: Punto di partenza per la divisione degli elementi contententi pb/lb -->
	<xsl:variable name="start_split" select="if(//tei:text/tei:group[@xml:id='group']) then(//tei:text/tei:group[@xml:id='group']/name()) else( if(//tei:body/tei:div[@subtype='edition_text']) then(//tei:body/tei:div[@subtype='edition_text']/name()) else(//tei:body/name()) )"/>
	
	
	<!-- EN: Indicate the maximum depth of pb/lb with relatively to the element stated in the variable $start_split-->
	<!-- IT: Indica la profondità massima dei pb/lb rispetto all'elemento inserito della variabile $start_split-->
	<xsl:variable name="start_split_depth" select="//node()[name()=$start_split]/count(ancestor-or-self::node())"/>
	<xsl:variable name="max_depth" as="xs:integer" select="max(((max(//tei:pb/count(ancestor-or-self::node())) - //node()[name()=$start_split]/count(ancestor-or-self::node())), (max(//tei:lb/count(ancestor-or-self::node())) - //node()[name()=$start_split]/count(ancestor-or-self::node()))))"/>
	<!-- EN: Highest depth of a pb relatively to the body: max(//tei:pb/count(ancestor-or-self::node())) - //tei:body/count(ancestor-or-self::node()) 
		     Highest depth of a lb relatively to the body: max(//tei:lb/count(ancestor-or-self::node())) - //tei:body/count(ancestor-or-self::node())
	-->
	<!-- 
		IT: Profondità massima di un pb rispetto a body: max(//tei:pb/count(ancestor-or-self::node())) - //tei:body/count(ancestor-or-self::node()) 
		    Profondità massima di un lb rispetto a body: max(//tei:lb/count(ancestor-or-self::node())) - //tei:body/count(ancestor-or-self::node())
	-->
	
	<!-- EN: On/Off default Text Label generation from id 
		     If false() you need to put your own xslt transformations in modules/elements/evt_builder-generate-text_label.xsl -->
	<!-- IT: Attiva/Disattiva generazione standard dell'etichetta del selettore testuale in base all'id. 
		     Se false() e' necessario aggiungere le proprie trasformazioni xslt nel file modules/elements/evt_builder-generate-text_label.xsl -->
	<xsl:param name="defaulTextLabel" select="true()"/>
	
	<!-- ################# -->
	<!-- INTERFACE CONTROL -->
	<!-- ################# -->
	
	<!-- -->
	<!-- DEFAULT CONTENT SEEN -->
	<!-- EN: Set default content on first load for left frame choosing between image or manuscript info 
			Possible values are: 
			- 'image' if you want to see the image on first load
			- 'info'  if you want to see the manuscript info on first load
			Any other value will work as 'image'.
	-->
	<!-- IT: Indicare cosa visualizzare di default al primo caricamento nel frame sinistro: immagine o informazioni sul manoscritto 
			I valori possibili sono: 
			- 'image' se si vuole visualizzare l'immagine al primo caricamento
			- 'info'  se si vogliono visualizzare le informazioni sul manoscritto al primo caricamento
			Qualsiasi altro valore varrà come 'image'
	-->
	<xsl:variable name="left_frame_default_content" select="'image'" />
	
	<!-- EN: Set default content on first load for right frame choosing between text or text front info 
			Possible values are: 
			- 'text' if you want to see the text on first load
			- 'info'  if you want to see the text front info on first load
			Any other value will work as 'text'.
	-->
	<!-- IT: Indicare cosa visualizzare di default al primo caricamento nel frame destro: testo o informazioni sul testo 
			I valori possibili sono: 
			- 'text' se si vuole visualizzare il testo al primo caricamento
			- 'info'  se si vogliono visualizzare le informazioni sul testo al primo caricamento
			Qualsiasi altro valore varrà come 'text'
	-->
	<xsl:variable name="right_frame_default_content" select="'info'" />
	
	<!-- BUTTONS PRESENCE AND POSITION -->
	
	<!-- EN: Show/Hide Txt/Img Link Button in interface -->
	<!-- IT: Mostra/Nascondi pulsante Txt/Img Link nell'interfaccia web -->
	<!-- default: true() -->
	<xsl:param name="txtimg_link_button" select="true()"/>
	
	<!-- EN: Show/Hide Hotspot Button in interface -->
	<!-- IT: Mostra/Nascondi pulsante Hotspot nell'interfaccia web -->
	<!-- default: true() -->
	<xsl:param name="hs_button" select="false()"/>
	
	<!-- EN: Show/Hide Magnifier Button in interface -->
	<!-- IT: Mostra/Nascondi pulsante Lente di ingrandimento nell'interfaccia web -->
	<!-- default: true() -->
	<xsl:param name="mag_button" select="true()"/>
	
	<!-- EN: Show/Hide Thumbnails Button in interface -->
	<!-- IT: Mostra/Nascondi pulsante Thumbnails nell'interfaccia web -->
	<!-- default: true() -->
	<xsl:param name="thumbs_button" select="true()"/>
	
	<!-- EN: Show/Hide Edition level selector in interface -->
	<!-- IT: Mostra/Nascondi selettore Livello/i Edizione nell'interfaccia web -->
	<!-- default: true() -->
	<xsl:param name="edition_level_selector" select="false()"/>
	
	<!-- IT: Choose page selector position -->
	<!-- IT: Scegli posizione Selettore pagina -->
	<!-- "left" or "right" | Default: "right" -->
	<!-- default: right -->
	<xsl:param name="pp_selector_pos" select="'right'"/>
	
	<!-- EN: Choose whether or not to group pages by document in the selector -->
    <!-- IT: Scegli se raggruppare o meno le pagine per documento nel selettore apposito -->
    <!-- default: true() -->
    <xsl:param name="pp_selector_doc_grouping" select="false()"/>
    
    <!-- EN: Choose whether or not having a tooltip on pages option showing the belonging document  -->
    <!-- IT: Scegli se avere un tooltip sulle opzioni delle pagine che mostra il/i documento/i di appartenenza -->
    <!-- default: false() -->
    <xsl:param name="pp_selector_doc_tooltip" select="true()"/>

	<!-- EN: On/Off Search -->
	<!-- IT: Attiva/Disattiva Ricerca -->
	<!-- default: true() -->
	<xsl:param name="search" select="true()"/>
	
	<!-- EN: On/Off Virtual Keyboard for search -->
	<!-- IT: Attiva/Disattiva Tastiera virtuale per ricerca -->
	<!-- default: true() -->
	<xsl:param name="virtual_keyboard_search" select="false()"/>
	
	<!-- EN: On/Off Document Navigation -->
	<!-- IT: Attiva/Disattiva navigazione per documento -->
	<!-- default: false() -->
	<xsl:param name="document_navigation" select="true()"/>
	
	<!-- LISTS -->
	
	<!-- EN: On/Off persons list -->
	<!-- IT: Attiva/disattiva lista persone -->
	<!-- default: true() -->
	<xsl:param name="list_person" select="true()"/>
	
	<!-- EN: On/Off places list -->
	<!-- IT: Attiva/disattiva lista luoghi -->
	<!-- default: true() -->
	<xsl:param name="list_place" select="true()"/>
	
	<!-- EN: It is possibile to personalize the elements in the filter select element that will select and highlight particular (groups of) words.
			 In order to change the label it is necessary to change the text inside the corresponding element.
			 In order to remove an elemento from the list in the application it is possibile both to remove the element itself or to delete the text inside it.
			 In order to add a new element to the list you simply need to know that the tag corresponds to the class name that has be given to the html element referring to the particular words to be selected. -->
	<!-- IT: E' possibile personalizzare gli elementi che compariranno nell'elenco dei filtri che selezionano particolari paroli o gruppi di parole. 
			 Per cambiare l'etichetta basta cambiare il testo dentro l'elemento corrispondente. 
			 Per rimuovere un elemento basta eliminare o tutto l'elemento di interesse o anche solo il testo al suo interno.
			 Per aggiungere un elemento alla lista basta sapere che il tag fa riferimento alla classe data all'elemento html con il quale sono state marcate le parole "particolari" da selezionare. -->
	<xsl:variable name="lists" as="element()*">
		<persName/>
		<placeName/>
		<roleName/>
		<measure/>
		<date/>
		<abbr/>
	</xsl:variable>
</xsl:stylesheet>
