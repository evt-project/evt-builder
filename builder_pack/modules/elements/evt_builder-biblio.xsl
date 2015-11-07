<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all">

    <xd:doc type="stylesheet">
        <xd:short>
            EN: Fundamental calls to formatting the bibliographical info.
            IT: Le chiamate principali per la formattazione della bibliografia.
        </xd:short>
    </xd:doc>
    
    <!-- ############## -->
    <!-- BIBLIO CHIGAGO -->
    <!-- ############## -->
    <xsl:template match="tei:listBibl">
        <body>
            <xsl:choose>
                <xsl:when test="biblStruct[note='DOTR']">
                    <xsl:apply-templates select="biblStruct[note='DOTR']">
                        <xsl:sort order="ascending" select=".//date"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="tei:bibl">
                        <xsl:sort order="ascending" select=".//@xml:id"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
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
       
    <!-- add by CDP -->
    <xsl:template match="tei:bibl">
        <xsl:element name="span">
            <xsl:attribute name="class">bibl</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
            
        
    </xsl:template>
</xsl:stylesheet>
