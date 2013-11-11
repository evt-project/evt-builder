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
	
	
	<!-- MULTI PHASE TRASFORMATION -->
	
	<!-- EN: Close and open back elements when you find a pb or an lb -->
	<!-- IT: Chiudi e riapri i tag quando trovi un pb o un lb -->
	<xsl:template match="node()[name()=$start_split]/node()" mode="splitZero">
		<xsl:choose>
			<xsl:when test="lb|pb">
				<xsl:for-each-group select="node()" group-starting-with="lb|pb">
					<!-- EN: copy lb/pb if present in this group -->
					<!-- IT: copia lb/pb se presente nel gruppo -->
					<xsl:if test="current-group()/(descendant-or-self::lb|descendant-or-self::pb)">
						<xsl:sequence select="current-group()/(descendant-or-self::lb|descendant-or-self::pb)"/>
					</xsl:if>
					<!-- Copies the elements in the group except lb/pb -->
					<xsl:element name="{parent::node()/name()}" xmlns="http://www.tei-c.org/ns/1.0">
						<xsl:for-each select="parent::node()/@*[not(name()='part')]">
							<xsl:attribute name="{name()}" select="."/>
						</xsl:for-each>
						<xsl:attribute name="part" select="position()"></xsl:attribute>
						<xsl:sequence select="current-group()[not(self::lb|self::pb)]"/>
					</xsl:element>
				</xsl:for-each-group>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- EN: Close and open back elements when you find a pb or an lb -->
	<!-- IT: Chiudi e riapri i tag quando trovi un pb o un lb -->
	<xsl:template match="node()[name()=$start_split]/node()/node()" mode="split-1">
		<xsl:choose>
			<xsl:when test="lb|pb">
				<xsl:for-each-group select="node()" group-starting-with="lb|pb">
					<!-- IT: copia lb/pb se presente nel gruppo -->
					<xsl:if test="current-group()/(descendant-or-self::lb|descendant-or-self::pb)">
						<xsl:sequence select="current-group()/(descendant-or-self::lb|descendant-or-self::pb)"/>
					</xsl:if>
					<!-- Copies all elements in the group except lb/pb -->
					<xsl:element name="{parent::node()/name()}" xmlns="http://www.tei-c.org/ns/1.0">
						<xsl:for-each select="parent::node()/@*">
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."></xsl:value-of>
							</xsl:attribute>
						</xsl:for-each>
						<xsl:sequence select="current-group()[not(self::lb|self::pb)]"/>
					</xsl:element>
				</xsl:for-each-group>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- EN: Close and open back elements when you find a pb or an lb -->
	<!-- IT: Chiudi e riapri i tag quando trovi un pb o un lb -->
	<xsl:template match="node()[name()=$start_split]/node()/node()/node()" mode="split-2">
		<xsl:choose>
			<xsl:when test="lb|pb">
				<xsl:for-each-group select="node()" group-starting-with="lb|pb">
					<!-- IT: copia lb/pb se presente nel gruppo -->
					<xsl:if test="current-group()/(descendant-or-self::lb|descendant-or-self::pb)">
						<xsl:sequence select="current-group()/(descendant-or-self::lb|descendant-or-self::pb)"/>
					</xsl:if>
					<!-- Copies all elements in the group except lb/pb -->
					<xsl:element name="{parent::node()/name()}" xmlns="http://www.tei-c.org/ns/1.0">
						<xsl:for-each select="parent::node()/@*">
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."></xsl:value-of>
							</xsl:attribute>
						</xsl:for-each>
						<xsl:sequence select="current-group()[not(self::lb|self::pb)]"/>
					</xsl:element>
				</xsl:for-each-group>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- EN: Close and open back elements when you find a pb or an lb -->
	<!-- IT: Chiudi e riapri i tag quando trovi un pb o un lb -->
	<xsl:template match="node()[name()=$start_split]/node()/node()/node()/node()" mode="split-3">
		<xsl:choose>
			<xsl:when test="lb|pb">
				<xsl:for-each-group select="node()" group-starting-with="lb|pb">
					<!-- IT: copia lb/pb se presente nel gruppo -->
					<xsl:if test="current-group()/(descendant-or-self::lb|descendant-or-self::pb)">
						<xsl:sequence select="current-group()/(descendant-or-self::lb|descendant-or-self::pb)"/>
					</xsl:if>
					<!-- Copies all elements in the group except lb/pb -->
					<xsl:element name="{parent::node()/name()}" xmlns="http://www.tei-c.org/ns/1.0">
						<xsl:for-each select="parent::node()/@*">
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."></xsl:value-of>
							</xsl:attribute>
						</xsl:for-each>
						<xsl:sequence select="current-group()[not(self::lb|self::pb)]"/>
					</xsl:element>
				</xsl:for-each-group>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- EN: Close and open back elements when you find a pb or an lb -->
	<!-- IT: Chiudi e riapri i tag quando trovi un pb o un lb -->
	<xsl:template match="node()[name()=$start_split]/node()/node()/node()/node()/node()" mode="split-4">
		<xsl:choose>
			<xsl:when test="lb|pb">
				<xsl:for-each-group select="node()" group-starting-with="lb|pb">
					<!-- IT: copia lb/pb se presente nel gruppo -->
					<xsl:if test="current-group()/(descendant-or-self::lb|descendant-or-self::pb)">
						<xsl:sequence select="current-group()/(descendant-or-self::lb|descendant-or-self::pb)"/>
					</xsl:if>
					<!-- Copies all elements in the group except lb/pb -->
					<xsl:element name="{parent::node()/name()}" xmlns="http://www.tei-c.org/ns/1.0">
						<xsl:for-each select="parent::node()/@*">
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."></xsl:value-of>
							</xsl:attribute>
						</xsl:for-each>
						<xsl:sequence select="current-group()[not(self::lb|self::pb)]"/>
					</xsl:element>
				</xsl:for-each-group>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- EN: Close and open back elements when you find a pb or an lb -->
	<!-- IT: Chiudi e riapri i tag quando trovi un pb o un lb -->
	<xsl:template match="node()[name()=$start_split]/node()/node()/node()/node()/node()/node()" mode="split-5">
		<xsl:choose>
			<xsl:when test="lb|pb">
				<xsl:for-each-group select="node()" group-starting-with="lb|pb">
					<!-- IT: copia lb/pb se presente nel gruppo -->
					<xsl:if test="current-group()/(descendant-or-self::lb|descendant-or-self::pb)">
						<xsl:sequence select="current-group()/(descendant-or-self::lb|descendant-or-self::pb)"/>
					</xsl:if>
					<!-- Copies all elements in the group except lb/pb -->
					<xsl:element name="{parent::node()/name()}" xmlns="http://www.tei-c.org/ns/1.0">
						<xsl:for-each select="parent::node()/@*">
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."></xsl:value-of>
							</xsl:attribute>
						</xsl:for-each>
						<xsl:sequence select="current-group()[not(self::lb|self::pb)]"/>
					</xsl:element>
				</xsl:for-each-group>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ADD NEW STEP PART 1 -->
	<!-- EN: to add a new level copy the previous template and add a "node()" to the match pattern, f.i.: match="tei:body/node()/node()/node()/node()/node()/node()/node()"
	and decrease the mode value by 1, f.i.: mode="split-6"-->
	<!-- IT: per aggiungere un nuovo livello, copiare il template precedente e aggiungere un "node()" al pattern del match es: match="tei:body/node()/node()/node()/node()/node()/node()/node()"
	e decrementare di 1 il valore del mode es: mode="split-6"-->
	

	<!-- EN: Copy all -->
	<!-- IT: Copia tutto -->
	<xsl:template match="@*|node()" mode="splitZero split-1 split-2 split-3 split-4 split-5">
		<!-- ADD NEW STEP PART 2 -->
		<!-- EN: To add a new level add here the mode increased by one, f.i.: mode="split-6" -->
		<!-- IT: Per aggiungere un nuovo livello aggiungere qui il mode incrementato di 1 es: mode="split-6" -->
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
		<xsl:apply-templates select="//tei:TEI" mode="split-5"/>
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
	
	<!-- END OF MULTI PHASE TRASFORMATION -->
	
	<xsl:template match="/" priority="1">
		<xsl:apply-templates select="$step0" mode="splitPages"></xsl:apply-templates>
	</xsl:template>
	
	<!--EN: Calls the page template for every page -->
	<!--IT: Per ogni pagina chiama il template page -->
	<xsl:template match="*" mode="splitPages">
		<!--<xsl:copy-of select="*"></xsl:copy-of>-->
		<xsl:for-each-group select="//tei:text//node()[name()=$start_split]/node()" group-starting-with="//tei:pb">
			<xsl:if test="self::tei:pb">
				<xsl:call-template name="page"> <!-- See: evt_builder-main -->
					<xsl:with-param name="pb_n" select="@n"/>	
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each-group>
		<!--EN: Calls the template that generates the index -->
		<!--IT: Chiama il template per la generazione della index -->
		<xsl:call-template name="index"></xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>
