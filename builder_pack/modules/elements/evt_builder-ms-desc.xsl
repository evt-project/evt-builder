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
			EN: This file collects functions and templates to tranform information about manuscript description
			IT: Questo file è una collezione di funzioni e template per trasformare le informazioni descrittive relative al manoscritto
		</xd:short>
	</xd:doc>
	
	<!-- Si seleziona il nodo <msDesc> e si applica la regola ai nodi al suo interno. -->
	<xsl:template match="tei:msDesc">
		<div id="msDesc">
			<xsl:apply-templates select="tei:msIdentifier"/>
			<xsl:apply-templates select="tei:msContents"/>
			<xsl:apply-templates select="tei:physDesc"/>
			<xsl:apply-templates select="tei:history"/>
			<xsl:apply-templates select="tei:additional"/>
		</div>
	</xsl:template>
	
	<!-- Si seleziona il nodo <msIdentifier> e vengono visualizzati, in una tabella, i risultati
                dei nodi che riguardano la posiozne geografica del manoscritto e la sua collocazione in
                biblioteche, archivi, ecc ecc. -->
	<xsl:template match="tei:msIdentifier">
		<div id="msIdentifier">
			<div class="title_section">
				<span data-var-name="msd_msIdentifier_section_label">
					<xsl:value-of select="$msd_msIdentifier_section_label"/>
				</span>
			</div>
			<div class="table">
				<xsl:if test="tei:repository and tei:repository/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span data-var-name="msd_repository_section_label">
								<xsl:value-of select="$msd_repository_section_label"/>
							</span><xsl:text>:</xsl:text></div>
						<div class="right_col"><xsl:apply-templates select="tei:repository"/>
							<xsl:if test="tei:settlement or tei:country">
								<xsl:text> (</xsl:text>
								<xsl:if test="tei:settlement">
									<xsl:value-of select="tei:settlement"/>	
								</xsl:if>
								<xsl:if test="tei:country">
									<xsl:text> - </xsl:text>
									<xsl:value-of select="tei:country"/>
								</xsl:if>
								<xsl:text>) </xsl:text>
							</xsl:if></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:collection and tei:collection/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span data-var-text="msd_collection_section_label">
								<xsl:value-of select="$msd_collection_section_label"/>
							</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates select="tei:collection"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:idno and tei:idno/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span data-var-text="msd_idno_section_label">
								<xsl:value-of select="$msd_idno_section_label"/>
							</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates select="tei:idno"/></div>    
					</div>
				</xsl:if>
				<xsl:if test="tei:msName"> <!--and tei:msName/normalize-space()">-->
					<div class="row">
						<div class="left_col">
							<span data-var-text="msd_msName_section_label">
								<xsl:value-of select="$msd_msName_section_label"/>
							</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates select="tei:msName"/></div>    
					</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	
	<!-- Si seleziona il nodo <msContents> e vengono visualizzati, in una tabella, i risultati
                dei nodi che descrivono il contenuto intellettuale del manoscritto. -->
	<xsl:template match="tei:msContents">
		<div id="msContents">
			<div class="title_section">
				<span data-var-text="msd_msContents_section_label">
					<xsl:value-of select="$msd_msContents_section_label"/>
				</span>
			</div>
			<div class="table">
				<xsl:if test="tei:summary and tei:summary/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span data-var-text="msd_msContent_summary_section_label">
								<xsl:value-of select="$msd_msContent_summary_section_label"/>
							</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:value-of select="tei:summary"/></div>
					</div>
				</xsl:if>
				<xsl:if test="//tei:textLang and //tei:textLang/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span data-var-text="msd_textLang_section_label">
								<xsl:value-of select="$msd_textLang_section_label"/>
							</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:value-of select="//tei:textLang"/></div>
					</div>  
				</xsl:if>
				<xsl:if test="//tei:msItem"><!--and tei:msItem/normalize-space()">-->
					<div class="row">
						<div class="left_col">
							<span data-var-text="msd_msItems_section_label">
								<xsl:value-of select="$msd_msItems_section_label"/>
							</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col">
							<xsl:for-each select="tei:msItem">
								<div class="msItem">
									<xsl:if test="tei:locus and tei:title">
										<div class="block">
											<xsl:value-of select="tei:locus"/>
											<xsl:text>: </xsl:text>
											<xsl:value-of select="tei:title"/>	
										</div>
									</xsl:if>
									<xsl:if test="tei:incipit">
										<div class="block">
											<span data-var-text="msd_incipit_section_label">
												<xsl:value-of select="$msd_incipit_section_label"/>
											</span><xsl:text>: </xsl:text>
											<xsl:value-of select="tei:incipit"/>	
										</div>
									</xsl:if>
									<xsl:if test="tei:explicit">
										<div class="block">
											<span data-var-text="msd_explicit_section_label">
												<xsl:value-of select="$msd_explicit_section_label"/>
											</span><xsl:text>: </xsl:text>
											<xsl:value-of select="tei:explicit"/>
										</div>
									</xsl:if>
									<xsl:if test="tei:colophon">
										<div class="block">
											<xsl:value-of select="tei:colophon"/>
										</div>
									</xsl:if>
								</div>
							</xsl:for-each>
						</div>
					</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	
	<!-- Si seleziona il nodo <physDesc> e vengono visualizzati, in una tabella, i risultati
                dei nodi che descrivono la struttura fisica del manoscritto. -->
	<xsl:template match="tei:physDesc">
		<div id="physDesc">
			<div class="title_section">
				<span data-var-text="msd_physDesc_section_label">
					<xsl:value-of select="$msd_physDesc_section_label"/>
				</span>
			</div>
			<xsl:apply-templates select="tei:objectDesc"/>
			<xsl:apply-templates select="tei:handDesc"/>
			<xsl:apply-templates select="tei:decoDesc"/>
		</div>
	</xsl:template>
	
	<xsl:template match="tei:objectDesc">
		<div id="objectDesc">
			<xsl:apply-templates select="supportDesc"/>
			<xsl:apply-templates select="layoutDesc"/>
		</div>
	</xsl:template>
	
	<xsl:template match="supportDesc">
		<div id="supportDesc">
			<div class="table">
				<xsl:choose>
					<xsl:when test="tei:support or tei:extent or tei:collation or tei:condition or tei:foliation">
						<xsl:if test="tei:support and tei:support/normalize-space()">
							<div class="row">
								<div class="left_col">
									<span data-var-text="msd_support_section_label">
										<xsl:value-of select="$msd_support_section_label"/>
									</span><xsl:text>: </xsl:text>
								</div>
								<div class="right_col"><xsl:value-of select="tei:support"/></div>
							</div>
						</xsl:if>
						<xsl:if test="tei:extent and tei:extent/normalize-space()">
							<div class="row">
								<div class="left_col">
									<span data-var-text="msd_extent_section_label">
										<xsl:value-of select="$msd_extent_section_label"/>
									</span><xsl:text>: </xsl:text>
								</div>
								<div class="right_col"><xsl:value-of select="tei:extent"/></div>
							</div>
						</xsl:if>
						<xsl:if test="tei:collation and tei:collation/normalize-space()">
							<div class="row">
								<div class="left_col">
									<span data-var-text="msd_collation_section_label">
										<xsl:value-of select="$msd_collation_section_label"/>
									</span><xsl:text>: </xsl:text>
								</div>
								<div class="right_col"><xsl:value-of select="tei:collation"/></div>
							</div>
						</xsl:if>
						<xsl:if test="tei:condition and tei:condition/normalize-space()">
							<div class="row">
								<div class="left_col">
									<span data-var-text="msd_condition_section_label">
										<xsl:value-of select="$msd_condition_section_label"/>
									</span><xsl:text>: </xsl:text>
								</div>
								<div class="right_col"><xsl:value-of select="tei:condition"/></div>
							</div>
						</xsl:if>
						<xsl:if test="tei:foliation and tei:foliation/normalize-space()">
							<div class="row">
								<div class="left_col">
									<span data-var-text="msd_foliation_section_label">
										<xsl:value-of select="$msd_foliation_section_label"/>
									</span><xsl:text>: </xsl:text>
								</div>
								<div class="right_col"><xsl:value-of select="tei:foliation"/></div>
							</div>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<div class="row">
							<div class="left_col">
								<span data-var-text="msd_general_supportDesc_section_label">
									<xsl:value-of select="$msd_general_supportDesc_section_label"/>
								</span><xsl:text>: </xsl:text>
							</div>
							<div class="right_col"><xsl:apply-templates select="child::node()"/></div>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="tei:layoutDesc">
		<div id="layoutDesc">
			<div class="table">
				<xsl:if test="tei:layout and tei:layout/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span data-var-text="msd_layout_section_label">
								<xsl:value-of select="$msd_layout_section_label"/>
							</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:value-of select="tei:layout"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:summary and tei:summary/normalize-space()">
					<div class="row">
						<div class="left_col">
							<span data-var-text="msd_layoutDesc_summary_section_label">
								<xsl:value-of select="$msd_layoutDesc_summary_section_label"/>
							</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:value-of select="tei:summary"/></div>
					</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="tei:handDesc">
		<xsl:if test="normalize-space()">
			<div id="handDesc">
				<div class="table">
					<div class="row">
						<div class="left_col">
							<span data-var-text="msd_handDesc_section_label">
								<xsl:value-of select="$msd_handDesc_section_label"/>
							</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates/></div>
					</div>
				</div> 
			</div>
		</xsl:if>    
	</xsl:template>
	
	<xsl:template match="tei:decoDesc">
		<xsl:if test="normalize-space()">
			<div id="decoDesc">
				<div class="table">
					<div class="row">
						<div class="left_col">
							<span data-var-text="msd_decoDesc_section_label">
								<xsl:value-of select="$msd_decoDesc_section_label"/>
							</span><xsl:text>:</xsl:text>
						</div>
						<div class="right_col"><xsl:apply-templates/></div>
					</div>
				</div> 
			</div>
		</xsl:if>    
	</xsl:template>
	
	<!-- Si seleziona il nodo <history> e vengono visualizzati, in una tabella, i risultati
                dei nodi che descrivono la storia del manoscritto. -->
	<xsl:template match="tei:history">
		<div class="history">
			<div class="title_section"><span data-var-text="msd_history_section_label"><xsl:value-of select="$msd_history_section_label"/></span></div>
			<div class="table">
				<xsl:if test="tei:summary and tei:summary/normalize-space()">
					<div class="row">
						<div class="left_col"><span data-var-text="msd_history_summary_section_label"><xsl:value-of select="$msd_history_summary_section_label"/></span><xsl:text>:</xsl:text></div>
						<div class="right_col"><xsl:value-of select="tei:summary"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:origin and tei:origin/normalize-space()">
					<div class="row">
						<div class="left_col"><span data-var-text="msd_origin_section_label"><xsl:value-of select="$msd_origin_section_label"/></span><xsl:text>:</xsl:text></div>
						<div class="right_col"><xsl:value-of select="tei:origin"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:acquisition and tei:acquisition/normalize-space()">
					<div class="row">
						<div class="left_col"><span data-var-text="msd_acquisition_section_label"><xsl:value-of select="$msd_acquisition_section_label"/></span><xsl:text>:</xsl:text></div>
						<div class="right_col"><xsl:value-of select="tei:acquisition"/></div>    
					</div>
				</xsl:if>
				<xsl:if test="tei:provenance and tei:provenance/normalize-space()">
					<div class="row">
						<div class="left_col"><span data-var-text="msd_acquisition_section_label"><xsl:value-of select="$msd_acquisition_section_label"/></span><xsl:text>:</xsl:text></div>
						<div class="right_col"><xsl:value-of select="tei:provenance"/></div>
					</div>
				</xsl:if>    
			</div>
		</div>
	</xsl:template>
	
	<!-- Si seleziona il nodo <additional> e vengono visualizzati, in una tabella, i risultati
                dei nodi che comprendono informazioni generiche riguardo il manoscritto o una parte di esso. -->
	<xsl:template match="tei:additional">
		<div class="additional">
			<div class="table">
				<xsl:if test="tei:adminInfo and tei:adminInfo/normalize-space()">
					<div class="row">
						<div class="left_col"><span data-var-text="msd_adminInfo_section_label"><xsl:value-of select="$msd_adminInfo_section_label"/></span><xsl:text>:</xsl:text></div>
						<div class="right_col"><xsl:value-of select="tei:adminInfo"/></div>
					</div>
				</xsl:if>
				<xsl:if test="tei:surrogates and tei:surrogates/normalize-space()">
					<div class="row">
						<div class="left_col"><span data-var-text="msd_surrogates_section_label"><xsl:value-of select="$msd_surrogates_section_label"/></span><xsl:text>:</xsl:text></div>
						<div class="right_col"><xsl:value-of select="tei:surrogates"/></div>
					</div>
				</xsl:if>    
			</div>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
