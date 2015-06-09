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
	
	<!-- Index title -->
	<!-- <xsl:param name="index_title" select="'The Digital Vercelli Book'"/> -->
	<!--<xsl:param name="index_title" select="'Codex Viewer'"/>-->
	<xsl:param name="index_title" select="'Codice Pelavicino'"/>
	
	<!-- Hide/Show scans -->
	<xsl:param name="image_frame" select="true()"/>
	
	<!-- Hide/Show badge -->
	<xsl:param name="badge" select="true()"/>
	<!-- alpha, beta, stable etc -->
	<xsl:param name="badge_text" select="'DIGITAL EDITION'"/>
	
	<!-- On/Off doubleview -->
	<xsl:param name="double_view" select="true()"/>
	
	<!-- On/Off regesto -->
	<xsl:param name="regesto" select="true()"/>
	
	<!-- Edition -->
	<!-- EN: To use it in your code:
		<xsl:value-of select="$edition_array[n]" />
	-->
	<!-- IT: Per l'utilizzo nel codice:
		<xsl:value-of select="$edition_array[n]" />
	-->
	<!-- EN: It is possible to skip production of pages for a specific edition simply removing the textual part of the corresponding item.
	-->
	<!-- IT: E' possibile rimuovere la produzione di pagine di una determinata edizione semplicemente rimuovendo la parte testuale dell'item corrispondente.
	-->
	<xsl:variable name="edition_array" as="element()*">
		<edition></edition> 	<!-- EN: For processing in the modules: $edition_array[1] -->
		<!-- IT: Per l'elaborazione nei moduli: $edition_array[1] -->
		<edition>Interpretative</edition>	<!-- EN: For processing in the modules: $edition_array[2] -->
		<!-- IT: Per l'elaborazione nei moduli: $edition_array[2] -->					
		<!-- EN: To add a new edition it is necessary to add a new line here and -forcedly- a declaration concerning output file in the modules/evt_builder-main.xsl file, under the <xsl:if test="$edition_array[2]!=''" condition>
				For instance: <edition>New_edition</edition>
		-->
		<!-- IT: Per aggiungere una nuova edizione, bisognerà inserire una nuova riga qui e -necessariamente- la dichiarazione per i file di output nel file modules/evt_builder-main.xsl, sotto la condizione <xsl:if test="$edition_array[2]!=''">
				Esempio: <edition>Nuova_edizione</edition>
		-->    
	</xsl:variable>
	
	<!-- IT: E' possibile personalizzare il prefisso usato nella creazione delle classi degli elementi html di un edizione.
	-->
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
	
	<!-- EN: It is possibile to personalize the elements in the filter select element that will select and highlight particular (groups of) words.
			 In order to change the label it is necessary to change the text inside the corresponding element.
			 In order to remove an elemento from the list in the application it is possibile both to remove the element itself or to delete the text inside it.
			 In order to add a new element to the list you simply need to know that the tag corresponds to the class name that has be given to the html element referring to the particular words to be selected.
	-->
	<!-- IT: E' possibile personalizzare gli elementi che compariranno nell'elenco dei filtri che selezionano particolari paroli o gruppi di parole. 
			 Per cambiare l'etichetta basta cambiare il testo dentro l'elemento corrispondente. 
			 Per rimuovere un elemento basta eliminare o tutto l'elemento di interesse o anche solo il testo al suo interno.
			 Per aggiungere un elemento alla lista basta sapere che il tag fa riferimento alla classe data all'elemento html con il quale sono state marcate le parole "particolari" da selezionare. 
	-->
	<xsl:variable name="lists" as="element()*">
		<persName>Persone</persName>
		<placeName>Luoghi</placeName>
		<roleName>Mestieri/Ruoli</roleName>
		<measure>Monete</measure>
		<date>Date</date>
	</xsl:variable>
	
	<!-- Nodo che contiene il testo da trasformare per ogni livello di edizione -->
	<!--<xsl:variable name="ed_content" select="//tei:body/name()"></xsl:variable>-->
	<xsl:variable name="ed_content" select="//tei:text/tei:group[@xml:id='group']/name()"/>
	<!-- Punto di partenza per la divisione degli elementi contententi pb/lb -->
	<!--<xsl:variable name="start_split" select="if(//tei:body/tei:div) then(//tei:body/tei:div/name()) else(//tei:body/name())"/>-->
	<xsl:variable name="start_split" select="if(//tei:text/tei:group[@xml:id='group']) then(//tei:text/tei:group[@xml:id='group']/name()) else(//tei:body/name())"/>
	
	<!-- Indica la profondità massima dei pb/lb rispetto all'elemento inserito della variabile $start_split-->
	<xsl:variable name="start_split_depth" select="//node()[name()=$start_split]/count(ancestor-or-self::node())"/>
	<xsl:variable name="max_depth" as="xs:integer" select="max(((max(//tei:pb/count(ancestor-or-self::node())) - //node()[name()=$start_split]/count(ancestor-or-self::node())), (max(//tei:lb/count(ancestor-or-self::node())) - //node()[name()=$start_split]/count(ancestor-or-self::node()))))"/>
	<!-- Profondità massima di un pb rispetto a body: max(//tei:pb/count(ancestor-or-self::node())) - //tei:body/count(ancestor-or-self::node()) 
		 Profondità massima di un lb rispetto a body: max(//tei:lb/count(ancestor-or-self::node())) - //tei:body/count(ancestor-or-self::node())
	-->
	
	<!-- EN: On/Off defaul Text Label generation from id 
		     If false() you need to put your own xslt transformations in modules/elements/evt_builder-generate-text_label.xsl -->
	<xsl:param name="defaulTextLabel" select="false()"/>
	
	
	<!-- INTERFACE CONTROL -->
	<!-- BUTTONS -->
	<!-- EN: Show/Hide Txt/Img Link Button in interface -->
	<!-- IT: Mostra/Nascondi pulsante Txt/Img Link nell'interfaccia web -->
	<xsl:param name="txtimg_link_button" select="false()"/>
	
	<!-- EN: Show/Hide Hotspot Button in interface -->
	<!-- IT: Mostra/Nascondi pulsante Hotspot nell'interfaccia web -->
	<xsl:param name="hs_button" select="false()"/>
	
	<!-- EN: Show/Hide Edition level selector in interface -->
	<!-- IT: Mostra/Nascondi selettore Livello/i Edizione nell'interfaccia web -->
	<xsl:param name="edition_level_selector" select="false()"/>
	
	<!-- IT: Choose page selector position -->
	<!-- IT: Scegli posizione Selettore pagina -->
	<!-- "left" or "right" | Default: "right" -->
	<xsl:param name="pp_selector_pos" select="'right'"/>
	
	<!-- On/Off Search -->
	<xsl:param name="search" select="false()"/>
	
	<!-- On/Off Document Navigation -->
	<xsl:param name="document_navigation" select="false()"/>
	
	<!-- LISTS -->
	<!-- On/Off persons list -->
	<xsl:param name="list_person" select="false()"/>
	<!-- Customize person list label -->
	<xsl:param name="list_person_label" select="'Lista Persone'"/>
	
	<!-- On/Off places list -->
	<xsl:param name="list_place" select="false()"/>
	<!-- Customize places list label -->
	<xsl:param name="list_place_label" select="'Lista Luoghi'"/>
	
</xsl:stylesheet>
