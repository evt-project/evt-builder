<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:eg="http://www.tei-c.org/ns/Examples"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="#all">

	<xd:doc type="stylesheet">
		<xd:short>
			EN: Fundamental calls to generate the HTML structure.
			IT: Le chiamate principali per la generazione della struttura HTML.
		</xd:short>
	</xd:doc>

	<!-- ########### -->
	<!-- HEADER INFO -->
	<!-- ########### -->
	<xsl:template name="headerInfo_generation">
		<html lang="en-US">
			<body>
				<div id="headerInfo">
					<a href="javascript:void(0);" id="close_header_info_cont" title="Close Header Info"><i class="fa fa-close"></i></a>
					<div id="headerInfo_content">
						<xsl:apply-templates select="//tei:teiHeader"/>
						
						<xsl:if test="tei:TEI/tei:text/tei:front and not(tei:TEI/tei:text/tei:body)">
							<div id="generalFront_content">
								<xsl:apply-templates select="tei:TEI/tei:text/tei:front"/>
							</div>
						</xsl:if>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>

	<!-- ###################### -->
	<!-- MANUSCRIPT DESCRIPTION -->
	<!-- ###################### -->
	<xsl:template name="msDesc_generation">
		<html lang="en-US">
			<body>
				<div id="msDescription">
					<xsl:apply-templates select="//tei:msDesc"/>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<!-- ####### -->
	<!-- REGESTO -->
	<!-- ####### -->
	<xsl:template name="doc_regesto">
		<xsl:param name="doc_id" />
		<xsl:param name="front" />
		<html lang="en-US">
			<xsl:call-template name="html_head">
				<xsl:with-param name="html_path" select="$dataPrefix"/>
				<xsl:with-param name="html_tc" select="'datastructure'"/>
				<xsl:with-param name="output" select="regesto"/>
			</xsl:call-template>
			<body>
				<div id="regesto">
					<div class="front">
						<div class="info">
							<div class="align-center"><span class="intestazione inline">Numerazione nuova: </span><xsl:value-of select="$front/tei:titlePart[@type='numerazioneNuova']"/></div>
							<div class="align-center"><span class="intestazione inline">Numerazione originale: </span><xsl:value-of select="$front/tei:titlePart[@type='numerazioneOrig']"/></div>
							<div class="align-center">
								<span class="intestazione inline">
									<xsl:apply-templates mode="dipl" select="$front/tei:docDate"/>
								</span>
							</div>
						</div>
						<div class="reg_text">
							<!--<xsl:value-of select="$front/tei:div[@type='regesto']"/>-->
							<xsl:apply-templates select="$front/tei:div[@type='regesto']" mode="dipl"/>
						</div>
						<div class="reg_note">
							<hr/>
							<p class="bibliografia">
								<!--<xsl:value-of select="$front//tei:div[@type='orig_doc']"/>-->
								<xsl:apply-templates select="$front//tei:div[@type='orig_doc']" mode="dipl"></xsl:apply-templates>
							</p>
							<p class="bibliografia">
								<xsl:for-each select="$front//tei:div[@type='biblio']/tei:p">
									<xsl:apply-templates mode='dipl'/>
								</xsl:for-each>
							</p>
							<p class="crit_notes">
								<xsl:for-each select="tei:front//tei:div[@type='crit_notes']/tei:note">
									<xsl:apply-templates mode="dipl"/>
								</xsl:for-each>
							</p>
						</div>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	
	
	
	<!-- ########## -->
	<!-- FRONT INFO -->
	<!-- ########## -->
	<xsl:template name="front_generation">
		<xsl:param name="front" />
		<html lang="en-US">
			<body>
				<div id="frontInfo">
					<div id="front">
						<div class="front">
							<xsl:apply-templates select="$front"/>
						</div>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="tei:front/tei:titlePage">
		<div class="title"><xsl:value-of select="."/></div>
	</xsl:template>
	
	<xsl:template match="tei:front/tei:div">
		<xsl:element name="div">
			<xsl:attribute name="class">
				<xsl:if test="@type">
					<xsl:value-of select="@type"/>
				</xsl:if>
				<xsl:text> </xsl:text>
				<xsl:if test="@subtype">
					<xsl:value-of select="@subtype"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:if test="@subtype">
				<div class="section-title">
					<xsl:value-of select="@subtype"/>
				</div>
			</xsl:if>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tei:front/tei:listBibl">
		<span class="title">References</span>
		<xsl:apply-templates select="tei:front/tei:biblStruct">
			<xsl:sort order="ascending" select=".//date"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- ############## -->
	<!-- BIBLIO CHIGAGO -->
	<!-- ############## -->
	<xsl:template match="tei:listBibl">
		<body>
			<h2>References</h2>
			<xsl:apply-templates select="biblStruct[note='DOTR']">
				<xsl:sort order="ascending" select=".//date"/>
			</xsl:apply-templates>
		</body>
	</xsl:template>
	
	<xsl:template match="tei:listBibl/biblStruct">
		<p class="hangInd">
			
			<xsl:choose>
				<xsl:when test="analytic">
					
					<xsl:if test="monogr/title[@level='j']">
						<xsl:apply-templates select=".//author"/>
						<xsl:apply-templates select=".//title[@level='a']"/>
						<xsl:apply-templates select=".//editor"/>
						<xsl:apply-templates select=".//title[@level='j']"/>
						<xsl:apply-templates select=".//imprint"/>
					</xsl:if>
					
					<xsl:if test="monogr/title[@level='m']">
						<xsl:apply-templates select=".//author"/>
						<xsl:apply-templates select=".//title[@level='a']"/>
						In <xsl:apply-templates select=".//editor"/>
						<xsl:apply-templates select=".//title[@level='m']"/>
						<xsl:apply-templates select=".//imprint"/>
						<xsl:apply-templates select=".//series"/>
					</xsl:if>
					
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:apply-templates select=".//author"/>
					<xsl:apply-templates select=".//editor"/>
					<xsl:apply-templates select=".//title[@level]"/>
					<xsl:apply-templates select=".//note[@place='inline']" mode="inline"/>
					<xsl:apply-templates select=".//imprint"/>
					<xsl:apply-templates select=".//series"/>
				</xsl:otherwise>
				
			</xsl:choose>
			
		</p>
	</xsl:template>
	
	<xsl:template match="tei:listBibl/author">
		<xsl:choose>
			
			<xsl:when test="persName">
				<xsl:choose>
					<xsl:when test="position()=1 and position()=last()">
						<xsl:apply-templates select="persName"/>&#160;
					</xsl:when>
					<xsl:when test="position()!=last()">
						<xsl:apply-templates select="persName"/>,
					</xsl:when>
					<xsl:otherwise>
						and <xsl:apply-templates select="persName"/>&#160;
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="."/>&#160;
			</xsl:otherwise>
			
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:listBibl/editor">
		<xsl:choose>
			
			<xsl:when test="persName">
				<xsl:choose>
					<xsl:when test="position()=1 and position()=last()">
						<xsl:apply-templates select="persName"/>&#160;
					</xsl:when>
					<xsl:when test="position()!=last()">
						<xsl:apply-templates select="persName"/>,
					</xsl:when>
					<xsl:otherwise>
						and <xsl:apply-templates select="persName"/>&#160;eds.&#160;
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="."/>&#160;ed.&#160;
			</xsl:otherwise>
			
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:listBibl/persName">
		<xsl:value-of select="surname"/>,
		<xsl:value-of select="foreName[@type='init']"/>
	</xsl:template>
	
	<xsl:template match="tei:listBibl/title">
		<xsl:choose>
			<xsl:when test="@level='m' or @level='u'">
				<span class="title"><xsl:apply-templates/>. </span>
			</xsl:when>
			<xsl:when test="@level='s'">
				<span class="title"><xsl:apply-templates/>, </span>
			</xsl:when>
			<xsl:when test="@level='j'">
				<span class="title"><xsl:apply-templates/>&#160;</span>
			</xsl:when>
			<xsl:when test="@level='a'">&quot;<xsl:apply-templates/>.&quot; 
			</xsl:when>
			<xsl:otherwise>
				<span class="title"><xsl:apply-templates/></span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:listBibl/imprint">
		<xsl:choose>
			<xsl:when test="../title[@level='m']">
				<xsl:apply-templates select="pubPlace"/>
				<xsl:apply-templates select="publisher"/>
				<xsl:apply-templates select="date"/>
				<xsl:apply-templates select="biblScope[@type='pages']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="biblScope[@type='vol']"/>
				<xsl:apply-templates select="date"/>
				<xsl:apply-templates select="biblScope[@type='pages']"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:listBibl/date">
		<xsl:choose>
			<xsl:when test="../biblScope[@type='vol']">
				(<xsl:apply-templates/>):
			</xsl:when>
			<xsl:when test="../biblScope[@type='pages']">
				<xsl:apply-templates/>,
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>.
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:listBibl/pubPlace">
		<xsl:apply-templates/>:&#160;
	</xsl:template>
	
	<xsl:template match="tei:listBibl/publisher">
		<xsl:apply-templates/>,&#160;
	</xsl:template>
	
	<xsl:template match="tei:listBibl/biblScope">
		<xsl:choose>
			<xsl:when test="@type='vol'">
				<xsl:apply-templates/> 
			</xsl:when>
			<xsl:when test="@type='pages'">
				<xsl:apply-templates/>. 
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
