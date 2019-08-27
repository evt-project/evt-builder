<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="@*|node()|comment()" mode="viscoll6">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()|comment()" mode="#current"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="manuscript" mode="viscoll6">
        <manuscript idno="{@idno}" msname="{@msname}" msURL="{@msURL}">

            <xsl:for-each select="quire">
                <quire>
                    <xsl:attribute name="n">
                        <xsl:value-of select="@n"/>
                    </xsl:attribute>
                    <xsl:attribute name="positions">
                        <xsl:value-of select="@positions"/>
                    </xsl:attribute>
                    <units>
                        <xsl:apply-templates select="units" mode="viscoll6"/>
                    </units>
                </quire>
            </xsl:for-each>
            <!-- Con questo crea i quireCopy -->
            <xsl:for-each select="//quireCopy">
                <quireCopy>
                    <xsl:attribute name="n">
                        <xsl:value-of select="@n"/>
                    </xsl:attribute>
                    <xsl:variable name="positions" select="@positions"/>
                    <xsl:attribute name="positions">
                        <xsl:value-of select="$positions"/>
                    </xsl:attribute>

                    <xsl:for-each select=".//leaf">
                        <leaf>
                            <xsl:attribute name="n">
                                <xsl:value-of select="@n"/>
                            </xsl:attribute>
                            <xsl:attribute name="mode">
                                <xsl:value-of select="@mode"/>
                            </xsl:attribute>
                            <xsl:attribute name="single">
                                <xsl:value-of select="@single"/>
                            </xsl:attribute>
                            <xsl:attribute name="folio_number">
                                <xsl:value-of select="@folio_number"/>
                            </xsl:attribute>
                            <xsl:attribute name="conjoin">
                                <xsl:value-of select="@conjoin"/>
                            </xsl:attribute>
                            <xsl:attribute name="position">
                                <xsl:value-of select="@position"/>
                            </xsl:attribute>
                        </leaf>
                    </xsl:for-each>

                </quireCopy>
            </xsl:for-each>
        </manuscript>
    </xsl:template>

    <xsl:template match="units" mode="viscoll6">
        <xsl:for-each select="unit">
            <unit>
                <xsl:attribute name="n" select="@n"/>
                <inside>
                    <xsl:apply-templates select="inside" mode="viscoll6"/>
                </inside>
                <outside>
                    <xsl:apply-templates select="outside" mode="viscoll6"/>
                </outside>
            </unit>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="inside" mode="viscoll6">
        <xsl:apply-templates mode="viscoll6"/>
    </xsl:template>

    <xsl:template match="outside" mode="viscoll6">
        <xsl:apply-templates mode="viscoll6"/>
    </xsl:template>

    <xsl:template match="//left" mode="viscoll6">
        <left>
            <xsl:if test="@mode">
                <xsl:attribute name="mode">
                    <xsl:value-of select="@mode"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@folNo">
                <xsl:attribute name="folNo">
                    <xsl:value-of select="@folNo"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:variable name="the_folNo">
                <xsl:value-of select="@folNo"/>
                <!-- Prende il valore di folNo -->
            </xsl:variable>
            <!-- Prende image con attributo val uguale a the_folNo -->
            <xsl:variable name="viscoll_image_list_final_path">
                <xsl:choose>
                    <xsl:when test="contains($viscoll_image_list_path, 'http') or contains($viscoll_image_list_path, 'www.')">
                        <xsl:value-of select="$viscoll_image_list_path"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('../../../data/input_data/', $viscoll_image_list_path)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="document(concat($viscoll_image_list_final_path,/))//imageList/imageRV/image[@val = $the_folNo]">
                <xsl:attribute name="url">
                    <xsl:value-of select="document(concat($viscoll_image_list_final_path,/))//imageList/imageRV/image[@val = $the_folNo]/@url"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@mode='missing'">
                <xsl:attribute name="url">../../../input_data/images/images-viscoll/x.jpg</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="pos">
                <xsl:value-of select="@pos"/>
            </xsl:attribute>
        </left>
    </xsl:template>

    <xsl:template match="//right" mode="viscoll6">
        <right>
            <xsl:if test="@mode">
                <xsl:attribute name="mode">
                    <xsl:value-of select="@mode"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@folNo">
                <xsl:attribute name="folNo">
                    <xsl:value-of select="@folNo"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:variable name="the_folNo">
                <xsl:value-of select="@folNo"/>
            </xsl:variable>
            <xsl:variable name="viscoll_image_list_final_path">
                <xsl:choose>
                    <xsl:when test="contains($viscoll_image_list_path, 'http') or contains($viscoll_image_list_path, 'www.')">
                        <xsl:value-of select="$viscoll_image_list_path"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('../../../data/input_data/', $viscoll_image_list_path)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="document(concat($viscoll_image_list_final_path,/))//imageList/imageRV/image[@val=$the_folNo]">                <!-- Prende image con attributo val uguale a the_folNo -->
                <xsl:attribute name="url">
                    <xsl:value-of select="document(concat($viscoll_image_list_final_path,/))//imageList/imageRV/image[@val=$the_folNo]/@url"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:if test="@mode='missing'">
                <xsl:attribute name="url">../../../input_data/images/images-viscoll/x.jpg</xsl:attribute>
            </xsl:if>
            <xsl:attribute name="pos">
                <xsl:value-of select="@pos"/>
            </xsl:attribute>
        </right>
    </xsl:template>


</xsl:stylesheet>