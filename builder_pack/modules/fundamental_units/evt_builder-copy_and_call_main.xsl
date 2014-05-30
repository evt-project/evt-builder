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
			EN: This stylesheet creates a copy of the document where the l element is closed (and later re-opened) whenever it is interrupted by a pb or lb element. 
			For each page present in this copy the page template is applied (which is in evt_builder-main)
			IT: Crea una copia del documento nella quale il tag l viene chiuso (e poi ri-aperto) tutte le volte che è interrotto da un pb o un lb. 
			Per ogni pagina presente in questa copia viene chiamato il template page (questo template si trova in evt_builder-main)
		</xd:short>
	</xd:doc>


	<!-- MULTI PHASE TRANSFORMATION -->
	
	<!-- EN: Close and open back elements when you find a pb or an lb -->
	<!-- IT: Chiudi e riapri i tag quando trovi un pb o un lb -->
	<xsl:template match="node()[name()=$start_split]//node()[lb|pb][not(descendant::node()[lb|pb])]" mode="splitZero split-1 split-2 split-3 split-4 split-5">
		<!-- ADD NEW STEP PART 1 -->
		<!-- EN: To add a new level add here a new mode increased by one, f.i.: mode="split-6" -->
		<!-- IT: Per aggiungere un nuovo livello aggiungere qui un nuovo mode incrementando di 1 il precedente es: mode="split-6" -->
		<xsl:for-each-group select="node()" group-starting-with="lb|pb">
			<xsl:call-template name="group"/>
		</xsl:for-each-group>	
	</xsl:template>



	<!-- EN: Copy all -->
	<!-- IT: Copia tutto -->
	<xsl:template match="@*|node()" mode="splitZero split-1 split-2 split-3 split-4 split-5">
		<!-- ADD NEW STEP PART 2 -->
		<!-- EN: To add a new level add here the mode increased by one, f.i.: mode="split-6" -->
		<!-- IT: Per aggiungere un nuovo livello aggiungere qui un nuovo mode incrementando di 1 il precedente es: mode="split-6" -->
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>


	
	<!-- EN: Recursive calls on variables to close and open all elements broken by lb/pb -->
	<!-- IT: Chiamate ricorsive sulla variabili per chiudere e aprire tutti i tag spezzati da lb/pb -->
	<xsl:variable name="step0">
		<xsl:apply-templates select="$step-1" mode="splitZero"></xsl:apply-templates>
	</xsl:variable>
	
	<xsl:variable name="step-1">
		<xsl:apply-templates select="$step-2" mode="split-1"/>
	</xsl:variable>
	
	<xsl:variable name="step-2">
		<xsl:apply-templates select="$step-3" mode="split-2"/>
	</xsl:variable>
	
	<xsl:variable name="step-3">
		<xsl:apply-templates select="$step-4" mode="split-3"/>
	</xsl:variable>
	
	<xsl:variable name="step-4">
		<xsl:apply-templates select="$step-5" mode="split-4"/>
	</xsl:variable>
	
	<xsl:variable name="step-5">
		<xsl:apply-templates select="//node()[name()=$ed_content]" mode="split-5"/>
	</xsl:variable>
	
	<!-- ADD NEW STEP PART 3 -->
	<!--
		EN: to add a new level modify the previous variable as follows (increase the select value by one and add the corresponding variable):
		IT: per aggiungere un nuovo livello modificare la precedente variabile nel seguente modo (incrementare di 1 il valore del select e aggiungere la corrispondente variabile):
		<xsl:variable name="step-5">
			<xsl:apply-templates select="step-6" mode="split-5"/>
		</xsl:variable>
		
		<xsl:variable name="step-6">
			<xsl:apply-templates select="//tei:TEI" mode="split-6"/>
		</xsl:variable>
	-->
	
	<xsl:template name="group">
		<!-- EN: copy lb/pb if present in this group -->
		<!-- IT: copia lb/pb se presente nel gruppo -->
		<xsl:if test="current-group()/(descendant-or-self::lb|descendant-or-self::pb)">
			<xsl:sequence select="current-group()/(descendant-or-self::lb|descendant-or-self::pb)"/>
		</xsl:if>
		<!-- Copies the elements in the group except lb/pb -->
		<xsl:element name="{parent::node()/name()}" xmlns="http://www.tei-c.org/ns/1.0">
			<xsl:copy-of select="parent::node()/@* except (parent::node()/@part)"/>
			<xsl:attribute name="part" select="position()"></xsl:attribute>
			<xsl:attribute name="id" select="generate-id(parent::node())"></xsl:attribute>
			<xsl:sequence select="current-group()[not(self::lb|self::pb)]"/>
		</xsl:element>
	</xsl:template>
	
	
	<!-- END OF MULTI PHASE TRANSFORMATION -->
	
	<xsl:template match="*" mode="file4search">
		<!-- IT: Per ogni pagina, genera le corrispettive edizioni. Il template data_structure si trova in html_build/evt_builder-callhtml.xsl -->
		<xsl:call-template name="search_file"></xsl:call-template>
	</xsl:template>
	
	<!--EN: Calls the page template for every page -->
	<!--IT: Per ogni pagina chiama il template page -->
	<xsl:template match="*" mode="splitPages">
		<!--<xsl:copy-of select="*"></xsl:copy-of>-->
		<xsl:for-each-group select="//node()[name()=$ed_content]/descendant-or-self::node()[name()=$start_split]/node()" group-starting-with="//tei:pb">
			<xsl:if test="self::tei:pb"> <!--IT: test per non creare una pagina per un gruppo che non inizia con pb (puo succedere al primo gruppo)  -->
				<xsl:call-template name="page"/> <!-- See: evt_builder-main -->
			</xsl:if>
		</xsl:for-each-group>
		<!--EN: Calls the template that generates the index -->
		<!--IT: Chiama il template per la generazione della index -->
		<!--<xsl:call-template name="index"></xsl:call-template>-->
	</xsl:template>
	
	<!--CDP:embedded -->
	<!--EN: Calls the page template for every page -->
	<!--IT: Per ogni pagina chiama il template page -->
	<xsl:template match="*" mode="splitPages4embedded">
		<!--<xsl:copy-of select="*"></xsl:copy-of>-->
		<xsl:for-each-group select="$root//tei:sourceDoc" group-by="@xml:id">
			<xsl:for-each-group select="current-group()/tei:surface" group-by="@xml:id">
				<xsl:call-template name="page"/> <!-- See: evt_builder-main -->
			</xsl:for-each-group>
			<xsl:for-each-group select="current-group()/tei:surfaceGrp" group-by="@xml:id">
				<xsl:for-each-group select="current-group()/child::tei:surfaceGrp" group-by="@xml:id"><!-- primo livello di annidamento <surfaceGrp> -->
					<xsl:call-template name="surfaceGrp" />
				</xsl:for-each-group>
				<xsl:call-template name="surfaceGrp"/>			
			</xsl:for-each-group>
		</xsl:for-each-group>
		<!--EN: Calls the template that generates the index -->
		<!--IT: Chiama il template per la generazione della index -->
		<!--<xsl:call-template name="index"></xsl:call-template>-->
	</xsl:template>
	
	<xsl:template name="surfaceGrp">
		<xsl:for-each-group select="current-group()/tei:surface" group-by="@xml:id">
			<xsl:call-template name="page" /> <!-- See: evt_builder-main -->
		</xsl:for-each-group>
	</xsl:template>
</xsl:stylesheet>
