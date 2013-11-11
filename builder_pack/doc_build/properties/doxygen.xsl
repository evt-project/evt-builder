<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">
  <xd:doc type="stylesheet">
    <xd:short>Stylesheet for xd: properties equivalent to some of those available in Doxygen.</xd:short>
    <xd:author>Greg Beauchesne</xd:author>
  </xd:doc>
               
  <xd:doc>Prints the xd:version property.</xd:doc>
  <xsl:template match="xd:version" mode="printProperty">
    <div class="property">
      <div class="propertyCaption">Version:</div>
      <div class="propertyContent"><xsl:apply-templates mode="XdocTags"/></div>
    </div>
  </xsl:template>

  <xd:doc>Prints the xd:see | xd:sa property.</xd:doc>
  <xsl:template match="xd:see | xd:sa" mode="printProperty">
    <div class="property">
      <div class="propertyCaption">See Also:</div>
      <div class="propertyContent"><xsl:apply-templates mode="XdocTags"/></div>
    </div>
  </xsl:template>

  <xd:doc>Prints the xd:since property.</xd:doc>
  <xsl:template match="xd:since" mode="printProperty">
    <div class="property">
      <div class="propertyCaption">Since:</div>
      <div class="propertyContent"><xsl:apply-templates mode="XdocTags"/></div>
    </div>
  </xsl:template>
  
  <xd:doc>Prints the xd:deprecated property.</xd:doc>
  <xsl:template match="xd:deprecated" mode="printProperty">
    <div class="property">
      <div class="propertyCaption">Deprecated:</div>
      <div class="propertyContent"><xsl:apply-templates mode="XdocTags"/></div>
    </div>
  </xsl:template>
  
  <xd:doc>Prints the xd:remarks property.</xd:doc>
  <xsl:template match="xd:remarks" mode="printProperty">
    <div class="property">
      <div class="propertyCaption">Remarks:</div>
      <div class="propertyContent"><xsl:apply-templates mode="XdocTags"/></div>
    </div>
  </xsl:template>
  
  <xd:doc>Prints the xd:note property.</xd:doc>
  <xsl:template match="xd:note" mode="printProperty">
    <div class="property">
      <div class="propertyCaption">Notes:</div>
      <div class="propertyContent"><xsl:apply-templates mode="XdocTags"/></div>
    </div>
  </xsl:template>
</xsl:stylesheet>