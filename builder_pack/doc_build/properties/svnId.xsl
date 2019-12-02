<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">
  <xd:doc type="stylesheet">
    Stylesheet for xd:svnId property.
    <xd:author>ibirrer</xd:author>
    <xd:cvsId>$Id: svnId.xsl 22 2005-01-03 10:07:35Z ibirrer $</xd:cvsId>
    <xd:copyright>2004, P&amp;P Software GmbH</xd:copyright>
  </xd:doc>
               
  <xd:doc>Prints the xd:svnId property.</xd:doc>
  <xsl:template match="xd:svnId" mode="printProperty">
    <div class="property">
      <div class="propertyCaption">SVN Id:</div>
      <div class="propertyContent"><xsl:value-of select="."/></div>
    </div>
  </xsl:template>
</xsl:stylesheet>