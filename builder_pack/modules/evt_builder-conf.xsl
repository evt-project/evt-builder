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
	<xsl:param name="index_title" select="'Codex Viewer'"/> 	
	
	<!-- Hide/Show scans -->
	<xsl:param name="image_frame" select="true()"/> 

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
		<Item>Facsimile</Item> 	<!-- EN: For processing in the modules: $edition_array[1] -->
								<!-- IT: Per l'elaborazione nei moduli: $edition_array[1] -->
		<Item>Diplomatic</Item>	<!-- EN: For processing in the modules: $edition_array[2] -->
								<!-- IT: Per l'elaborazione nei moduli: $edition_array[2] -->
		
	<!-- EN: To add a new edition it is necessary to add a new line here and -forcedly- a declaration concerning output file in the modules/evt_builder-main.xsl file, under the <xsl:if test="$edition_array[2]!=''" condition>
				For instance: <Item>New_edition</Item>
		-->
	<!-- IT: Per aggiungere una nuova edizione, bisognerà inserire una nuova riga qui e -necessariamente- la dichiarazione per i file di output nel file modules/evt_builder-main.xsl, sotto la condizione <xsl:if test="$edition_array[2]!=''">
				Esempio: <Item>Nuova_edizione</Item>
		-->    
	</xsl:variable>
	
	<!-- Variable -->
	<!--
	<xsl:variable name="title" select="teiHeader/fileDesc/titleStmt/title" />
    <xsl:variable name="author" select="teiHeader/fileDesc/titleStmt/author" />
    <xsl:variable name="publisher" select="teiHeader/fileDesc/publicationStmt/publisher" />
    <xsl:variable name="pubdate" select="teiHeader/fileDesc/publicationStmt/date" />
	-->
	
	<!-- Punto di partenza per la divisione degli elementi contententi pb/lb -->
	<xsl:variable name="start_split" select="if(//tei:body/tei:div) then(//tei:body/tei:div/name()) else(//tei:body/name())"/>
	<!-- Indica la profondità massima dei pb/lb rispetto all'elemento inserito della variabile $start_split-->
	<xsl:variable name="start_split_depth" select="//node()[name()=$start_split]/count(ancestor-or-self::node())"/>
	<xsl:variable name="max_depth" as="xs:integer" select="max(((max(//tei:pb/count(ancestor-or-self::node())) - //node()[name()=$start_split]/count(ancestor-or-self::node())), (max(//tei:lb/count(ancestor-or-self::node())) - //node()[name()=$start_split]/count(ancestor-or-self::node()))))"/>
	<!-- Profondità massima di un pb rispetto a body: max(//tei:pb/count(ancestor-or-self::node())) - //tei:body/count(ancestor-or-self::node()) 
		 Profondità massima di un lb rispetto a body: max(//tei:lb/count(ancestor-or-self::node())) - //tei:body/count(ancestor-or-self::node())
	-->
	
</xsl:stylesheet>
