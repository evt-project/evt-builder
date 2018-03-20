<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all">
    
    <xsl:template match="@*|node()|comment()" mode="create_imageList">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:TEI//tei:facsimile" mode="create_imageList">
        <imageList>
            <xsl:for-each select="//tei:surface">
                <imageRV>
                    <xsl:choose>
                        <xsl:when test=".[ends-with(@corresp, 'r') and following-sibling::tei:surface[ends-with(@corresp, 'v')] 
                            and not( number(replace(@corresp,'[^0-9]','')) = number(replace(following-sibling::tei:surface[1]/@corresp,'[^0-9]',''))+1)]"> <!-- Se il nodo ha attributo corresp che termina con r e il nodo seguente ha attributo corresp che termina con v e se hanno numero uguale -->
                            <xsl:variable name="n">
                                <xsl:value-of select="translate(@corresp, '#', '')"/>
                            </xsl:variable>
                            <xsl:variable name="n_following">
                                <xsl:value-of select="following-sibling::*[1]/translate(@corresp, '#', '')"/>
                            </xsl:variable>
                            <xsl:variable name="path_image">
                                <xsl:value-of select="concat('../../../input_data/',translate(./tei:graphic/@url, '\', '/'))"/>
                            </xsl:variable>
                            <xsl:variable name="path_image_following">
                                <xsl:value-of select="following-sibling::*[1]/concat('../../../input_data/',translate(./tei:graphic/@url, '\', '/'))"/>
                            </xsl:variable>
                            <image val="{$n}" url="{$path_image}"></image>
                            <image val="{$n_following}" url="{$path_image_following}"></image>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="n">
                                <xsl:value-of select="translate(@corresp, '#', '')"/>
                            </xsl:variable>
                            <xsl:variable name="path_image">
                                <xsl:value-of select="concat('../../../input_data/',translate(./tei:graphic/@url, '\', '/'))"/>
                            </xsl:variable>
                            <image val="{$n}" url="{$path_image}"></image>
                        </xsl:otherwise>
                    </xsl:choose>
                </imageRV>
            </xsl:for-each>
        </imageList>
        
    </xsl:template>
        
        
            <!--<imageList> 
                <xsl:for-each select="//tei:surface"> 
                    <imageRV>
                        <image>
                            <xsl:attribute name="val">
                                <xsl:value-of select="translate(@corresp, '#', '')"/>
                            </xsl:attribute>
                            <xsl:attribute name="url">
                                <xsl:value-of select="concat('../../../input_data/',translate(./tei:graphic/@url, '\', '/'))"/>
                            </xsl:attribute>
                        </image>
                    </imageRV>
                </xsl:for-each>
            </imageList> -->

    
</xsl:stylesheet>
    
    
