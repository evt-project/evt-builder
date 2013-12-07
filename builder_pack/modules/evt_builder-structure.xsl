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
                IT: Template per la generazione del file structure.xml
            </xd:short>
        </xd:doc>
        
    <!-- All -->
    <xd:doc>
        <xd:short>
            IT: 
        </xd:short>
        <xd:detail>
            IT: 
        </xd:detail>
    </xd:doc>
    <xsl:template match="*" mode="structure_generation">
        <xsl:result-document method="xml" href="{$filePrefix}/data/output_data/structure.xml" indent="yes">
            <xml>
                <editions>
                    <xsl:for-each select="$edition_array">
                        <edition><xsl:value-of select="."/></edition>
                    </xsl:for-each>
                </editions>
                <textpage>
                    <xsl:for-each select="$root//tei:div[@subtype='edition_text']">
                        <text>
                            <xsl:attribute name="n" select="@n"></xsl:attribute>
                            <xsl:for-each select=".//tei:pb">
                                <pb><xsl:value-of select="@n"></xsl:value-of></pb>
                            </xsl:for-each>
                        </text>
                    </xsl:for-each>
                </textpage>
                <pages>
                    <!--<xsl:variable name="all_pb" select="//tei:pb"/>-->
                    <xsl:for-each-group select="//tei:pb" group-starting-with="node()[ends-with(@n, 'v') or (ends-with(@n, 'r') and not(preceding-sibling::node()[ends-with(@n, 'v')]) )]" >
                        <pair>
                            <xsl:for-each select="current-group()/self::tei:pb">
                                <pb><xsl:value-of select="@n"></xsl:value-of></pb>
                            </xsl:for-each>
                        </pair>
                    </xsl:for-each-group>
                    <!--<pair>
                        <pb>104v</pb>
                        <pb>105r</pb>
                    </pair>
                    <pair>
                        <pb>105v</pb>
                        <pb>106r</pb>
                    </pair>
                    <pair>
                        <pb>111v</pb>
                        <pb>112r</pb>
                    </pair>
                    <pair>
                        <pb>112v</pb>
                        <pb>113r</pb>
                    </pair>
                    <pair>
                        <pb>117v</pb> risultato html 117v-.jpg, interno alla cartella double
                    </pair>-->
                </pages>
            </xml>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>