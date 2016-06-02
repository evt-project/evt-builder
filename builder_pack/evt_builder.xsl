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
  	
	<!--<xsl:import href="modules/xml-to-string.xsl"/>-->
	
	<xd:doc type="stylesheet">
		<xd:author>RafMas</xd:author>
		<xd:short>
			EN: Transformation from TEI P5 to HTML5
			IT: Strumento di trasformazione da TEI P5 ad HTML5
		</xd:short>
		  <xd:detail>
			EN: This is the main file to perform the transformation, it is used to include all other evt_builder-*.xsl modules		
			IT: Questo è il file principale per effettuare la trasformazione, serve per includere tutti gli altri moduli evt_builder-*.xsl		
		  </xd:detail>
	</xd:doc>

	<!-- Basic -->
	<xsl:include href="modules/evt_builder-main.xsl"/>
	<xsl:include href="../config/evt_builder-config.xsl"/>

	<xsl:include href="modules/fundamental_units/evt_builder-copy_and_call_main.xsl"/>
	<xsl:include href="modules/fundamental_units/evt_builder-structure.xsl"/>
	
	<!-- Image-Text link & HotSpot-->
	<xsl:include href="modules/fundamental_units/evt-builder_imagetext-link_hotspot.xsl"/>

	<!-- Biblio -->
	<xsl:include href="modules/elements/evt_builder-biblio.xsl"/>
	
	<!-- HTML structure -->
	<xsl:include href="modules/html_build/evt_builder-callhtml.xsl"/>
	<xsl:include href="modules/html_build/evt_builder-callhtml-prefatory_matter.xsl"/>
	<xsl:include href="modules/html_build/evt_builder-function.xsl"/>
		
	<!-- Elements -->
	<xsl:include href="modules/elements/evt_builder-divLine.xsl"/>
	<xsl:include href="modules/elements/evt_builder-header-info.xsl"/>
	<xsl:include href="modules/elements/evt_builder-ms-desc.xsl"/>
	
	<!-- Elements for diplomatic version-->
	<xsl:include href="modules/elements/evt_builder-dipl-core.xsl"/>
	<xsl:include href="modules/elements/evt_builder-dipl-multi_module.xsl"/>
	<!--<xsl:include href="modules/elements/evt_builder-dipl-textstructure.xsl"/>--> <!-- Added By JK-->

	<!-- Elements for interpretative version-->
	<xsl:include href="modules/elements/evt_builder-interp-core.xsl"/>
	<xsl:include href="modules/elements/evt_builder-interp-multi_module.xsl"/>
	<!--<xsl:include href="modules/elements/evt_builder-interp-textstructure.xsl"/>-->
	
	<!-- Extra -->
	<xsl:include href="modules/extra/functx-1.0.xsl"/>
	
	<!-- Generation of text label from id. -->
	<xsl:include href="modules/elements/evt_builder-generate-text_label.xsl"/>
	
	<!-- Custom templates -->
	<xsl:include href="../config/evt_builder-custom-templates.xsl"/>
	
</xsl:stylesheet>
