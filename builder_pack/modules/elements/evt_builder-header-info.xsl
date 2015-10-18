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
			EN: This file collects functions and templates to tranform information encoded in teiHeader element
			IT: Questo file è una collezione di funzioni e template per trasformare le informazioni codificate nel teiHeader
		</xd:short>
	</xd:doc>
	
	<!-- Si seleziona il nodo <fileDesc> e si applica la regola ai nodi al suo interno -->
	<xsl:template match="tei:fileDesc">
		<div id="fileDesc">
			<xsl:apply-templates select="tei:titleStmt"/>
			<xsl:apply-templates select="tei:publicationStmt"/>
			<xsl:apply-templates select="tei:editionStmt"/>
		</div>
	</xsl:template>
	
	<!-- Si seleziona il nodo <titleStmt> e vengono visualizzati, in una tabella, i risultati
        dei nodi che riguardano le informazioni sul titolo dell'opera e i suoi responsabili. -->
	<xsl:template match="tei:titleStmt">
		<div id="titleStmt">
			<xsl:if test="tei:title">
				<xsl:element name="div">
					<xsl:attribute name="class">title main</xsl:attribute>
					<xsl:value-of select="tei:title"/>
				</xsl:element>
			</xsl:if>
			<div class="table">
				<xsl:if test="tei:author and tei:author/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">TEXT_AUTHOR</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates select="tei:author"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:principal and tei:principal/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">PRINCIPAL_INVESTIGATOR</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates select="tei:principal"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:respStmt"> <!--and tei:respStmt/normalize-space()">-->
					<xsl:for-each select="tei:respStmt">
						<div class="row">
							<div class="left_col"><xsl:value-of select="tei:resp"/></div>
							<div class="right_col"><xsl:for-each select="tei:name">
								<xsl:value-of select="."/>
								<xsl:if test="position() != last()">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
							</div>
						</div>
					</xsl:for-each>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	
	<!-- Si seleziona il  nodo <publicationStmt> e vengono visualizzati, in una tabella, i risultati
        dei nodi che riguardano le informazioni relative la pubblicazione e la distribuzione del 
        documento elettronico. -->
	<xsl:template match="tei:publicationStmt">
		<div id="publicationStmt">
			<div class="section-title">
				<span lang="def">PUBLICATION_INFORMATION</span>
			</div>
			<div class="table">
				<xsl:if test=" tei:authority and tei:authority/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">PUBLISHER</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates select="tei:authority"/></div>
					</div>
				</xsl:if>
				<xsl:if test=" tei:publisher and tei:publisher/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">PUBLISHER</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates select="tei:publisher"/></div>
					</div>
				</xsl:if>
				<xsl:if test=" tei:pubPlace and tei:pubPlace/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">PUBLICATION_PLACE</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates select="tei:pubPlace"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:date and tei:date/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">DATE</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates select="tei:date"/></div>
					</div>
				</xsl:if>    
				<xsl:if test="tei:availability and tei:availability/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">AVAILABILITY</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:value-of select="tei:availability"/></div>
					</div>
				</xsl:if>    
			</div>
		</div>
	</xsl:template>
	
	<!-- Si seleziona il nodo <editionStmt> e vengono visualizzati, in una tabella, i risultati
        dei nodi che riguardano le informazioni relative all'edizione del testo. -->
	<xsl:template match="tei:editionStmt">
		<div id="editionStmt">
			<div class="section-title">
				<span lang="def">TEXT_EDITION</span>
			</div>
			<div class="table">
				<xsl:if test="tei:edition and tei:edition/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">EDITION</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates select="tei:edition"/></div>
					</div>
				</xsl:if>  
				<xsl:if test="tei:respStmt">
					<xsl:for-each select="tei:respStmt">
						<div class="row">
							<div class="left_col"><xsl:value-of select="tei:resp"/></div>
							<div class="right_col"><xsl:for-each select="tei:name">
								<xsl:value-of select="."/>
								<xsl:if test="position() != last()">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each></div>
						</div>
					</xsl:for-each>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	
	<!-- Si seleziona il nodo <encodingDesc> e si applica la regola ai nodi al suo interno. -->
	<xsl:template match="tei:encodingDesc">
		<div class="encodingDesc">
			<div class="section-title">
				<span lang="def">ENCODING_DESCRIPTION</span>
			</div>
			<xsl:apply-templates select="tei:projectDesc"/>
			<xsl:apply-templates select="tei:editorialDecl"/>
			<xsl:apply-templates select="tei:samplingDecl"/>
			<xsl:apply-templates select="tei:charDecl"/>
		</div>
	</xsl:template>
	
	<!-- Si seleziona il nodo <projectDesc> e vengono visualizzati, in una tabella, i risultati
            dei nodi che comprendono tutte le informazioni riguardanti la procedura di conversione. -->
	<xsl:template match="tei:projectDesc">
		<xsl:if test="normalize-space()">
			<div class="projectDesc">
				<div class="table">
					<div class="row">
						<div class="left_col">
							<span lang="def">PROJECT_DESCRIPTION</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates/></div>
					</div>
				</div>    
			</div>
		</xsl:if>    
	</xsl:template>
	
	<!-- Si seleziona il nodo <editorialDecl> e vengono visualizzati, in una tabella, i risultati
            dei nodi che comprendono i dettagli sui principi e criteri utilizzati nella conversione del manoscritto. -->
	<xsl:template match="tei:editorialDecl">
		<div class="editorialDecl">
			<div class="table">
				<xsl:if test="tei:correction and tei:correction/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">CORRECTIONS</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:value-of select="tei:correction"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:normalization and tei:normalization/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">NORMALIZATION</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:value-of select="tei:normalization"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:segmentation and tei:segmentation/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">SEGMENTATION</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:value-of select="tei:segmentation"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:hyphenation and tei:hyphenation/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">HYPHENATION</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:value-of select="tei:hyphenation"/></div>
					</div>
				</xsl:if>    
			</div> 
		</div> 
	</xsl:template>
	
	<!-- Si selziona il  nodo <samplingDecl> e vengono visualizzati, in una tabella, i risultati
        dei nodi che descrivono i metodi e i principi usati durante la campionatura del testo durante la creazione. -->
	<xsl:template match="tei:samplingDecl">
		<xsl:if test="normalize-space()">
			<div class="samplingDecl">
				<div class="table">
					<div class="row">
						<div class="left_col">
							<span lang="def">SAMPLING_METHODS</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates/></div>
					</div>
				</div>
			</div>
		</xsl:if>    
	</xsl:template>
	
	<!-- Si seleziona il nodo <charDecl> ma il template viene lasciato vuoto. -->
	<xsl:template match="tei:charDecl"></xsl:template>
	
	<!-- Si seleziona il nodo <profileDesc> e vengono visualizzati, in una tabella, i risultati
        dei nodi che comprendono la descrizione degli aspetti non bibliografici del manoscritto,
        in particolare il tipo di linguaggio utilizzato. -->
	<xsl:template match="tei:profileDesc">
		<div class="profileDesc">
			<div class="section-title">
				<span lang="def">PROFILE_DESCRIPTION</span>
			</div>
			<div class="table">
				<xsl:if test="tei:langUsage and tei:langUsage/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">LANGUAGE</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:value-of select="tei:langUsage"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:textClass and tei:textClass/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span lang="def">TEXT_CLASSIFICATION</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:value-of select="tei:textClass"/></div>
					</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	
	<!-- Si seleziona il nodo <revisionDesc> e vengono visualizzati in una tabella i risultati dei nodi
        che contengono tutte le modifiche apportate alla pubblicazione -->
	<xsl:template match="tei:revisionDesc">
		<xsl:if test="normalize-space()">
			<div class="change">
				<div class="section-title">
					<span lang="def">REVISIONS</span><xsl:text>:</xsl:text>
				</div>
				<div class="table">
					<xsl:for-each select="tei:change">
						<div class="row">
							<div class="left_col"><xsl:value-of select="@when , @who"/></div>
							<div class="right_col"><xsl:for-each select="node()">
								<xsl:value-of select="."/>
								<xsl:if test="position() = last()">
									<xsl:text>.</xsl:text>
								</xsl:if>
							</xsl:for-each>
							</div>
						</div>
					</xsl:for-each>    
				</div>
			</div>
		</xsl:if>    
	</xsl:template>
	
	<xsl:template match="tei:title">
		<xsl:element name="span">
			<xsl:attribute name="class">title <xsl:value-of select="@type"/></xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
