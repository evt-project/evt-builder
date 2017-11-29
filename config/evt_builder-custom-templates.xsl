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
                EN: This file has been prepared for you to add your personal XSLT templates
                IT: Questo file è stato predisposto per accogliere template personalizzati
            </xd:short>
        </xd:doc>
    <!-- In order to make it work properly you need to add mode="interp dipl #default" to each template -->
   
    <xsl:template name="listDoc">
        <xsl:element name="ul">
            <xsl:attribute name="id" select="'ul_listDocument'"/>
            <xsl:attribute name="class" select="'ul_list'"/>
            <xsl:for-each select="$root//tei:text/tei:group/tei:text">
                <xsl:element name="li">
                    <xsl:attribute name="id" select="@xml:id" />
                    <xsl:attribute name="class" select="'list_element'"/> 
                    <xsl:attribute name="data-sort-date">
                       <xsl:choose>
                           <xsl:when test="current()//tei:docDate//tei:date[@when]">
                            <xsl:call-template name="dateValue">
                                <xsl:with-param name="date"><xsl:value-of select="tei:front//tei:docDate//(tei:date[@when])[1]/@when"/></xsl:with-param>
                            </xsl:call-template>  
                           </xsl:when>
                           <xsl:when test="current()//tei:docDate//tei:date[@notBefore]">
                               <xsl:call-template name="dateValue">
                                   <xsl:with-param name="date"><xsl:value-of select="tei:front//tei:docDate//tei:date/@notBefore"/></xsl:with-param>
                               </xsl:call-template>  
                           </xsl:when>
                           <xsl:when test="current()//tei:docDate//tei:date[@from]">
                               <xsl:call-template name="dateValue">
                               <xsl:with-param name="date"><xsl:value-of select="tei:front//tei:docDate//tei:date/@from"/></xsl:with-param>
                               </xsl:call-template>  
                           </xsl:when>  
                           
                         <!-- per <date> sono ammessi altri attributi non usati nel CP. Si devono prendere in considerazione?-->
                        <!--   <xsl:otherwise>
                               <xsl:call-template name="dateValue">
                               <xsl:with-param name="date"><xsl:value-of select="tei:front//tei:docDate//tei:date/@"/></xsl:with-param>
                               </xsl:call-template>  
                           </xsl:otherwise>-->
                      </xsl:choose>        
                    </xsl:attribute>
                    <xsl:attribute name="data-sort-num">
                           <xsl:value-of select="current()//tei:front//tei:titlePart[@type='numerazioneNuova']"/>
                    </xsl:attribute>
                    <xsl:call-template name="document" />
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    
    
    <xsl:template name="dateValue">
        <xsl:param name="date"/>
        <xsl:choose>
            <!--funziona correttamente solo usando questo ordine per i match-->
            <xsl:when test="matches($date, '\d{4}-\d{2}-\d{2}')">
               <xsl:value-of select="$date"/> 
            </xsl:when>
            <xsl:when test="matches($date, '\d{4}-\d{2}')">
                <xsl:value-of select="concat($date, '-01')"/>
            </xsl:when>
            <xsl:when test="matches($date, '\d{4}')">
                <xsl:value-of select="concat($date, '-01', '-01')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$date"/>
            </xsl:otherwise>
        </xsl:choose>      
    </xsl:template>

    <xsl:template name="document">
        <xsl:choose>
            <xsl:when test="current()//tei:front">
                
                <!--creo uno span per le date-->
                <xsl:element name="span">
                    <xsl:attribute name="class">document_list_info</xsl:attribute>                   
                    <xsl:if test="current()//tei:docDate">             
                        <xsl:if test="current()//tei:docDate//tei:date">
                            
                            <xsl:choose>
                                <xsl:when test="current()//tei:docDate//tei:date[@when]">
                                    <!--voglio solo la prima data nell'ordine cronologico. Il caso dell'attributo when è l'unico in cui posso avere più date-->
                                    
                                    <xsl:value-of select="tei:front//tei:docDate//(tei:date[@when])[1]"/>
                                    <xsl:text>&#xA0;</xsl:text>   
                                </xsl:when> 
                                
                                <!--Se l'elemento date ha gli attributi @notBefore e @notAfter-->
                                <xsl:when test="current()//tei:docDate//tei:date[@notBefore] and current()//tei:docDate//tei:date[@notAfter]">
                                    <xsl:attribute name="data-value"><xsl:value-of select="tei:front//tei:docDate//tei:date/@notBefore"/></xsl:attribute>
                                    <xsl:value-of select="tei:front//tei:docDate//tei:date/@notBefore"/>
                                    <xsl:text>&#xA0;-&#xA0;</xsl:text>
                                    <xsl:value-of select="tei:front//tei:docDate//tei:date/@notAfter"/>
                                </xsl:when>
                                
                                <!--se l'elemento date ha gli attributi @from e @to-->
                                <xsl:when test="current()//tei:docDate//tei:date[@from] and current()//tei:docDate//tei:date[@to]">
                                    <xsl:attribute name="data-value"><xsl:value-of select="tei:front//tei:docDate//tei:date/@from"/></xsl:attribute>
                                    <xsl:value-of select="tei:front//tei:docDate//tei:date/@from"/>
                                    <xsl:text>&#xA0;-&#xA0;</xsl:text>
                                    <xsl:value-of select="tei:front//tei:docDate//tei:date/@to"/>
                                </xsl:when>
                                
                                <!-- se non si verifica nessuno dei casi precedenti. Questo però può dare problemi per l'ordinamento-->
                                <xsl:otherwise>
                                    <xsl:value-of select="tei:front//tei:docDate//tei:date/@*"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            <xsl:text>&#xA0;</xsl:text>
                            <!--chiudo l'if per il date-->
                        </xsl:if>
                        <!--chiudo l'if per il docDate-->
                    </xsl:if>
                </xsl:element>
                
               <!-- Non nella lista, nel link al documento
                   
                per la numerazione originale
                <xsl:element name="span"> 
                    <xsl:attribute name="class">document_list_info <xsl:if test="$list_doc=true()"> link_active</xsl:if></xsl:attribute>
                    <xsl:attribute name="data-ref">
                        <xsl:value-of select="@xml:id" />
                    </xsl:attribute>
                    <xsl:if test="current()//tei:titlePart[@type='numerazioneOrig']">
                        <xsl:value-of select="tei:front//tei:titlePart[@type='numerazioneOrig']"/>
                        <xsl:text>&#xA0;</xsl:text>
                    </xsl:if>
                </xsl:element> 
                
                <xsl:text>-</xsl:text>
                per la numerazione nuova
                <xsl:element name="span"> 
                    <xsl:attribute name="class">document_list_info <xsl:if test="$list_doc=true()"> link_active</xsl:if></xsl:attribute>
                    <xsl:attribute name="data-ref">
                        <xsl:value-of select="@xml:id" />
                    </xsl:attribute>
                    <xsl:if test="current()//tei:titlePart[@type='numerazioneNuova']">
                        <xsl:value-of select="tei:front//tei:titlePart[@type='numerazioneNuova']"/>
                        <xsl:text>&#xA0;</xsl:text>
                    </xsl:if>
                </xsl:element> -->
                
                <!--creo uno span per i luoghi-->
                <xsl:element name="span">
                    <xsl:attribute name="class">document_list_info</xsl:attribute>
                    <xsl:if test="current()//tei:docDate">             
                        <xsl:if test="current()//tei:docDate//tei:placeName">
                            <xsl:for-each select="current()//tei:docDate//tei:placeName">
                                <xsl:value-of select="."/>
                                <xsl:text>&#xA0;</xsl:text>
                            </xsl:for-each>
                            <!--chiudo l'if per il placeName-->
                        </xsl:if>
                        <!--chiudo l'if per il docDate-->
                    </xsl:if>
                </xsl:element>
                
                <!--creo uno span per il regesto-->
                
                <xsl:element name="span">
                    <xsl:attribute name="class">document_list_info</xsl:attribute>
                    <xsl:if test="current()//tei:div[@type='regesto']">             
                        <xsl:value-of select="tei:front//tei:div[@type='regesto']"/>
                        <xsl:text></xsl:text>
                        <!--chiudo l'if per il div-->
                    </xsl:if>
                </xsl:element>
                
             <span class="toggle_list_element"><i class="fa fa-angle-right"></i></span>
            </xsl:when>
            
            <xsl:otherwise>    
                <xsl:element name="span">
                    <xsl:attribute name="class">display-block</xsl:attribute>
                    <span lang="def">NO_INFO</span>
                    <xsl:text>.</xsl:text>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>       
</xsl:stylesheet>