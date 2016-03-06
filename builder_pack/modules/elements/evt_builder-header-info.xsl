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
	<xsl:template match="tei:teiHeader">
		<div id="headerInfo_nav_tabs">
			
			<li>
				<a href="#tab1">
					<span lang="def">EVT_INFORMATION</span>
				</a>
			</li>
			<li>
				<a href="#tab2">
					<span lang="def">GENERAL_INFORMATION</span>
				</a>
			</li>
			
			<xsl:if test="tei:fileDesc/publicationStmt">
				<li> 
					<a href="#tab3">
						<span lang="def">PUBLICATION_INFORMATION</span>							
					</a>
				</li>
			</xsl:if>
			<xsl:if test="tei:encodingDesc">
				<li>
					<a href="#tab4">				
						<span lang="def">PROJECT_DESCRIPTION</span>															
					</a>
				</li>
			</xsl:if>
			<xsl:if test="tei:profileDesc">
				<li>
					<a href="#tab5">				
						<span lang="def">PROFILE_DESCRIPTION</span>															
					</a>
				</li>
			</xsl:if>
			<xsl:if test="tei:revisionDesc">
				<li>
					<a href="#tab6">				
						<span lang="def">REVISIONS</span>															
					</a>
				</li>
			</xsl:if>
		</div>
		
		<div id="headerInfo_box_tabs">
			<div id="tab1" class="box_tab">
				<xsl:copy-of select="$evtTxt"/>	
			</div>
			
			<div id="tab2" class="box_tab">
				<xsl:if test="tei:fileDesc//title">
					<div>
						<p class="title"><span lang="def">TITLE</span></p>
						<p class="information"><xsl:value-of select="tei:fileDesc//title"/></p>
					</div>
				</xsl:if>
				<xsl:if test="tei:fileDesc//author and tei:fileDesc//author/normalize-space()">
					<div>
						<p class="title"><span lang="def">TEXT_AUTHOR</span></p>
						<p class="information"><xsl:apply-templates select="tei:fileDesc//author"/></p>		
					</div>
				</xsl:if>
				<xsl:if test="tei:fileDesc//principal and tei:fileDesc//principal/normalize-space()">
					<div>
						<p class="title"><span lang="def">PRINCIPAL_INVESTIGATOR</span></p>
						<p class="information"><xsl:apply-templates select="tei:fileDesc//principal"/></p>	
					</div>
				</xsl:if>
				<xsl:if test="tei:fileDesc//respStmt">
					<xsl:for-each select="tei:fileDesc//respStmt">
						<div>
							<p class="title">
								<xsl:variable name="resp" select="tei:resp"/>
								<xsl:value-of select="translate(normalize-space(translate($resp,':','  ')),':','  ')"/>
							</p>
							<p class="information">
								<xsl:for-each select="tei:name">
									<xsl:value-of select="."/>
									<xsl:if test="position() != last()">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</p>
						</div>
					</xsl:for-each>
				</xsl:if>				
			</div>
			
			<div id="tab3" class="box_tab">
				<xsl:if test="tei:fileDesc//authority and tei:fileDesc//authority/normalize-space()">
					<div>
						<p class="title"><span lang="def">AUTORITY</span></p>
						<p class="information"><xsl:apply-templates select="tei:fileDesc//authority"/></p>						
					</div>
				</xsl:if>
				<xsl:if test="tei:fileDesc//publisher and tei:fileDesc//publisher/normalize-space()">
					<div>
						<p class="title"><span lang="def">PUBLISHER</span></p>
						<p class="information"><xsl:apply-templates select="tei:fileDesc//publisher"/></p>						
					</div>
				</xsl:if>
				<xsl:if test=" tei:fileDesc//pubPlace and tei:fileDesc//pubPlace/normalize-space()">
					<div>
						<p class="title"><span lang="def">PUBLICATION_PLACE</span></p>
						<p class="information"><xsl:apply-templates select="tei:fileDesc//pubPlace"/></p>
					</div>
				</xsl:if>
				<xsl:if test="tei:fileDesc//date">
					<div>
						<p class="title"><span lang="def">DATE</span></p>
						<p class="information"><xsl:apply-templates select="tei:fileDesc//date"/></p>
					</div>
				</xsl:if>    
				<xsl:if test="tei:fileDesc//availability and tei:fileDesc//availability/normalize-space()">
					<div>
						<p class="title"><span lang="def">AVAILABILITY</span></p>
						<p class="information"><xsl:value-of select="tei:fileDesc//availability"/></p>
					</div>
				</xsl:if>				
			</div>
			
			<div id="tab4" class="box_tab">
				<xsl:if test="tei:encodingDesc/projectDesc and tei:encodingDesc/projectDesc/normalize-space()">
					<p class="title"><span lang="def">PROFILE_DESCRIPTION</span></p>
					<p class="information"><xsl:apply-templates select="tei:encodingDesc/projectDesc"/></p>	
				</xsl:if>
				<xsl:if test="tei:encodingDesc/editorialDecl and tei:encodingDesc/editorialDecl/normalize-space()">
					<p class="title"><span lang="def">EDITORIAL_DECLARATION</span></p>
					
					<xsl:if test="tei:encodingDesc/editorialDecl/correction and tei:encodingDesc/editorialDecl/correction/normalize-space()">
						<p class="information">
							<span lang="def">CORRECTIONS</span><xsl:text>:</xsl:text>
							<xsl:value-of select="tei:encodingDesc/editorialDecl/correction"/>
						</p>
					</xsl:if>
					<xsl:if test="tei:encodingDesc/editorialDecl/normalization and tei:encodingDesc/editorialDecl/normalization/normalize-space()">
						<p class="information">	
							<span lang="def">NORMALIZATION</span><xsl:text>:</xsl:text>							
							<xsl:value-of select="tei:encodingDesc/editorialDecl/normalization"/>
						</p>
					</xsl:if>
					<xsl:if test="tei:encodingDesc/editorialDecl/segmentation and tei:encodingDesc/editorialDecl/segmentation/normalize-space()">
						<p class="information">
							<span lang="def">SEGMENTATION</span><xsl:text>:</xsl:text>	
							<xsl:value-of select="tei:encodingDesc/editorialDecl/segmentation"/>
						</p>
					</xsl:if>
					<xsl:if test="tei:encodingDesc/editorialDecl/hyphenation and tei:encodingDesc/editorialDecl/hyphenation/normalize-space()">							
						<p class="information">
							<span lang="def">HYPHENATION</span><xsl:text>:</xsl:text>
							<xsl:value-of select="tei:encodingDesc/editorialDecl/hyphenation"/>
						</p>
					</xsl:if>
					
				</xsl:if>
			</div>
			
			<div id="tab5" class="box_tab">
				<xsl:if test="tei:profileDesc/langUsage and tei:profileDesc/langUsage/normalize-space()">
					<p class="title"><span lang="def">LANGUAGE</span></p>
					<p class="information"><xsl:apply-templates select="tei:profileDesc/langUsage"/></p>	
				</xsl:if>
				<xsl:if test="tei:profileDesc/textDesc and tei:profileDesc/textDesc/normalize-space()">
					<p class="title"><span lang="def">TEXT_DESCRIPTION</span></p>
					<p class="information"><xsl:apply-templates select="tei:profileDesc/textDesc"/></p>	
				</xsl:if>
				<xsl:if test="tei:profileDesc/textDesc and tei:profileDesc/settingDesc/normalize-space()">
					<p class="title"><span lang="def">SETTING_DESCRIPTION</span></p>
					<p class="information"><xsl:apply-templates select="tei:profileDesc/settingDesc"/></p>	
				</xsl:if>				
			</div>
			
			<div id="tab6" class="box_tab">
				<xsl:if test="tei:revisionDesc and tei:revisionDesc/normalize-space()">
					<p class="title"><span lang="def">REVISIONS</span></p>
					<ul class="information">
						<xsl:for-each select="tei:revisionDesc/change">							
							<li>
								<xsl:value-of select="@when , @who"/><xsl:text>: </xsl:text>
								<xsl:for-each select="node()">
									<xsl:value-of select="."/>
									<xsl:if test="position() = last()">
										<xsl:text>.</xsl:text>
									</xsl:if>
								</xsl:for-each>
							</li>
						</xsl:for-each>    
					</ul>	
				</xsl:if>				
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
