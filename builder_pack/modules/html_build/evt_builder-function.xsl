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
			EN: This file collects functions and template serving several purposes.
			IT: Questo file è una collezione di funzioni e template, finalizzati a diversi scopi.
		</xd:short>
	</xd:doc>
	
	<!--Use...
		<xsl:call-template name="rm-loops">
			<xsl:with-param name="rm_for"><xsl:value-of select="count($array)"/></xsl:with-param>
			<xsl:with-param name="rm_object" select="$array"></xsl:with-param>
		</xsl:call-template>
	-->
	<xsl:template name="rm-loops">
        <xsl:param name="rm_for" />
        <xsl:param name="rm_object" />
        <xsl:param name="rm_counter">1</xsl:param>

        <div>
			<xsl:value-of select="$rm_object[$rm_counter+0]" />
		</div>

        <xsl:if test="$rm_counter != $rm_for">
            <xsl:call-template name="rm-loops">
                <xsl:with-param name="rm_for" select="$rm_for" />
                <xsl:with-param name="rm_object" select="$rm_object" />
                <xsl:with-param name="rm_counter" select="$rm_counter + 1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>		

	<!-- EN: Used in modules/html_build/evt_builder-callhtml.xsl -->
	<!-- IT: Utilizzato in modules/html_build/evt_builder-callhtml.xsl -->
	<xsl:template name="rm-loops_radio">
        <xsl:param name="rm_for" />
        <xsl:param name="rm_object" />
        <xsl:param name="rm_counter">1</xsl:param>
        
		<xsl:param name="rm_counter_test" />
	
		<xsl:variable name="radio_value" select="$rm_object[$rm_counter+0]" />
		<xsl:variable name="rm_counter_test_inc">
			<xsl:choose>
				<xsl:when test="$radio_value!=''">0</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$radio_value!=''">
			<xsl:choose>
				<xsl:when test="$rm_counter = $rm_counter_test">				
					<input type="radio" name="edition_r" class="regular-radio" checked="checked" value="{$radio_value}" /> <xsl:value-of select="$radio_value" /> |
				</xsl:when>
				<xsl:otherwise>
					<input type="radio" name="edition_r" class="regular-radio" value="{$radio_value}" /> <xsl:value-of select="$radio_value" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	
        <xsl:if test="$rm_counter != $rm_for">		
            <xsl:call-template name="rm-loops_radio">
                <xsl:with-param name="rm_for" select="$rm_for" />
				<xsl:with-param name="rm_counter_test" select="$rm_counter_test + $rm_counter_test_inc" />
                <xsl:with-param name="rm_object" select="$rm_object" />
                <xsl:with-param name="rm_counter" select="$rm_counter + 1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="ee_select_build">
		<select class="main_ee_select">
			<xsl:for-each select="$edition_array">
				<xsl:variable name="edition_name" select="name(.)" />
				<xsl:if test="$edition_name = 'edition'">
					<option>
						<xsl:value-of select="."/>
					</option>										
				</xsl:if>
			</xsl:for-each>
		</select>
	</xsl:template>
			
	<xsl:template name="pp_select_build">
		<xsl:param name="html_select_main"/>
		<select class="main_pp_select">
			 <xsl:if test="$html_select_main='html_select_main'">
				<xsl:attribute name="id">
					<xsl:value-of select="'control_pp_select'" />
				</xsl:attribute>
			 </xsl:if>
			<xsl:for-each select="//tei:pb">
				<option>
					<xsl:attribute name="value">
						<xsl:value-of select="@n" />
					 </xsl:attribute>
					<xsl:value-of select="@n"/>										
				</option>										
			</xsl:for-each>
		</select>
	</xsl:template>

	<xsl:template name="div_select_build">
		<xsl:param name="html_div_class"/>

		<div class="{$html_div_class}">
	     	<span class="label_selected"></span>
			<div class="open_select" ><i class="fa fa-sort-desc"></i></div>
	        <div class="option_container down"></div>  
	    </div>
	</xsl:template>
	
</xsl:stylesheet>
