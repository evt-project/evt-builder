<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.pnp-software.com/XSLTdoc"
                xmlns:util="http://www.pnp-software.com/util"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="2.0">
  
  <xsl:include href="lib/util.xsl"/>
  
  <xd:doc type="stylesheet">
    <xd:short>
		Creates a HTML page for a stylesheet.
	</xd:short>
    <xd:detail>
      This stylesheet creates the xhtml output for one stylesheet. It calls sub-templates to
      build documentation parts for different parts of a stylesheet (templates, functions etc.).
      Note that the default namespace of this stylesheet is set to http://www.w3.org/1999/xhtml. 
      That means that any literal element is of this namespace if not specified specificely!
    </xd:detail>
    <xd:author>ibirrer</xd:author>
    <xd:cvsId>$Id: stylesheet.xsl 43 2009-11-07 13:02:24Z ibirrer $</xd:cvsId>
    <xd:copyright>2004, P&amp;P Software GmbH</xd:copyright>
  </xd:doc>
  
  <xd:doc>
    <xd:short>
		Controls the maximum access level displayed.
	</xd:short>
    <xd:detail>
      This parameter overrides the &lt;Access&gt; element inside an XSLTdocConfig file.
    </xd:detail>
  </xd:doc>
  <xsl:param name="access" select="if (/XSLTdocConfig/Access) then /XSLTdocConfig/Access else 'public'" as="xs:string" />

  <xd:doc>
    <xd:short>
		Calls sub-templates for each part of the stylesheet documentation.
	</xd:short>
  </xd:doc>
  
  <xsl:template match="/xsl:stylesheet | /xsl:transform" mode="stylesheet">
      <xsl:apply-templates select="." mode="stylesheetDetail"/>

      <xsl:apply-templates select="." mode="outputsSummary"/>
      <xsl:apply-templates select="." mode="elementSpaceSummary"/>
      <xsl:apply-templates select="." mode="namespaceAliasesSummary"/>
      <xsl:apply-templates select="." mode="characterMapsSummary"/>
      <xsl:apply-templates select="." mode="parametersSummary"/>
      <xsl:apply-templates select="." mode="variablesSummary"/>
      <xsl:apply-templates select="." mode="attSetsSummary"/>
      <xsl:apply-templates select="." mode="keysSummary"/>
      <xsl:apply-templates select="." mode="decimalFormatsSummary"/>
      <xsl:apply-templates select="." mode="templateModesSummary"/>
      <xsl:apply-templates select="." mode="matchTemplatesSummary"/>
      <xsl:apply-templates select="." mode="namedTemplatesSummary"/>
      <xsl:apply-templates select="." mode="functionsSummary"/>

      <xsl:apply-templates select="." mode="outputsDetail"/>
      <xsl:apply-templates select="." mode="elementSpaceDetail"/>
      <xsl:apply-templates select="." mode="namespaceAliasesDetail"/>
      <xsl:apply-templates select="." mode="characterMapsDetail"/>
      <xsl:apply-templates select="." mode="parametersDetail"/>
      <xsl:apply-templates select="." mode="variablesDetail"/>
      <xsl:apply-templates select="." mode="attSetsDetail"/>
      <xsl:apply-templates select="." mode="keysDetail"/>
      <xsl:apply-templates select="." mode="decimalFormatsDetail"/>
      <xsl:apply-templates select="." mode="templateModesDetail"/>
      <xsl:apply-templates select="." mode="matchTemplatesDetail"/>
      <xsl:apply-templates select="." mode="namedTemplatesDetail"/>
      <xsl:apply-templates select="." mode="functionsDetail"/>
  </xsl:template>

  <xd:doc>
    Extracts the short description from a xd:doc element. Everything before the
    first period is considered as short description. If the string doesn't
    contain a period, the whole string is returned. 
    <xd:param name="doc" type="string">
		xd:doc element
	</xd:param>
  </xd:doc>
  <xsl:template name="extractShortDescription">
    <xsl:param name="doc"/>
    <xsl:variable name="shortDesc" select="substring-before(string-join($doc/text(),''),'.')"/>
    <xsl:choose>
      <xsl:when test="string-length($shortDesc) &lt;= 0">
        <xsl:value-of select="$doc/text()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$shortDesc"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc> 
    Extracts the detail description from string. Everything after the
    first period is considered as detail description. If no detail description
    can be extracted, the empty string is returned.
    <xd:param name="doc" type="string">
      xd:doc element
    </xd:param>
  </xd:doc>
  <xsl:template name="extractDetailDescription">
    <xsl:param name="doc" as="element()"/>
    <xsl:variable name="detailDesc" select="substring-after(string-join($doc/text(),''),'.')"/>
    <xsl:choose>
      <xsl:when test="string-length($detailDesc) &lt;= 0">
         <xsl:text/>
      </xsl:when>
      <xsl:otherwise>
         <div class="detailDescr">
            <xsl:value-of select="$detailDesc"/>            
         </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc>
    <xd:short>Prints the detail description of a xd:doc element.</xd:short>
    <xd:detail> 
      If no detail description is found, the string &quot;No
      detail description available&quot; is printed
    </xd:detail>
  </xd:doc>
  <xsl:template match="xsl:function | xsl:template | xsl:stylesheet | xsl:transform | xsl:param | xsl:variable | xsl:attribute-set | xsl:key | xsl:output | xsl:preserve-space | xsl:strip-space | xsl:namespace-alias | xsl:character-map | xsl:decimal-format | xd:mode" mode="printDetailDescription">
    <xsl:param name="doc" select="xd:getDoc(.)" as="element(xd:doc)?"/>
    <xsl:choose>
  <xsl:when test="count($doc) != 0">
    <!-- xd documentation exists, find detail description -->
  <xsl:choose>
    <xsl:when test="$doc/xd:detail">
      <div class="detailDescr">
        <xsl:apply-templates select="$doc/xd:detail/child::node()" mode="XdocTags" />
      </div>
    </xsl:when>
    <xsl:otherwise>
      <!--
        No xd:detail element found, use text after first period as
        detail description.
      -->
      <xsl:call-template name="extractDetailDescription">
        <xsl:with-param name="doc" select="$doc" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text></xsl:text>
  </xsl:otherwise>
</xsl:choose>
  </xsl:template>
  
  <!-- 
  ***************************************
  * Templates with mode 'printProperties'
  ***************************************
  -->
  <xd:doc>
    <xd:short>
		Prints the properties of a xd:doc element.
	</xd:short>
  </xd:doc>
  <xsl:template match="xsl:function | xsl:template | xsl:stylesheet | xsl:transform | xsl:param | xsl:variable | xsl:attribute-set | xsl:key | xsl:output | xsl:preserve-space | xsl:strip-space | xsl:namespace-alias | xsl:character-map | xsl:decimal-format | xd:mode" mode="printProperties">
    <xsl:param name="doc" select="xd:getDoc(.)" as="element(xd:doc)?"/>
    <xsl:param name="root" select="(ancestor-or-self::xsl:stylesheet | ancestor-or-self::xsl:transform)[last()]" as="element(*)?"/>
    <xsl:param name="modeDoc" select="if (self::xsl:template) then xd:getModeDoc($root, @mode) else ()" />
    <xsl:variable name="htmlResult">
      <xsl:variable name="cur" select="." />

      <!-- Simple properties -->
      <xsl:apply-templates select="$doc/*" mode="printProperty"/>
			
      <!-- XSLT version (GAB, 09/2009) -->
      <xsl:if test="@version or @xsl:version">
        <div class="property">
          <div class="propertyCaption">XSLT Version:</div>
          <div class="propertyContent"><xsl:value-of select="@version | @xsl:version"/></div>
        </div>
      </xsl:if>

      <!-- Parameters -->
      <xsl:if test="(xsl:param or $doc/xd:param) and not(self::xsl:stylesheet | self::xsl:transform)">
        <div class="property">
          <div class="propertyCaption">Parameters:</div>
          <div class="propertyContent">
              <xsl:for-each select="xsl:param">
              <xsl:variable name="useDoc" select="($doc, $modeDoc)[xd:param[@name=current()/@name]][1]" />
                <!-- List parameters -->
                <div class="parameterDetail">
                  <xsl:copy-of select="xd:printParamDeclaration(., $useDoc)"/>
                  <span class="paramDescr"> - <xsl:apply-templates select="$useDoc/xd:param[@name=current()/@name]/child::node()" mode="XdocTags"/></span>
                </div>
              </xsl:for-each>
              <xsl:for-each select="$doc/xd:param">
                <xsl:if test="not($cur/xsl:param[@name = current()/@name])">
                <xsl:variable name="useDoc" select="($doc, $modeDoc)[xd:param[@name=current()/@name]][1]" />
                <!-- List parameters -->
                <div class="parameterDetail">
                  <xsl:copy-of select="xd:printParamDeclaration(., $useDoc)"/>
                  <span class="paramDescr"> - <xsl:apply-templates select="$useDoc/xd:param[@name=current()/@name]/child::node()" mode="XdocTags"/></span>
                </div>
                </xsl:if>
              </xsl:for-each>
          </div>
        </div>
      </xsl:if>
	  
      <!-- Returns (GAB, 09/2009) -->
      <xsl:variable name="useReturnDoc" select="($doc, $modeDoc)[xd:return][1]" />
      <xsl:if test="$useReturnDoc/xd:return/child::node()">
        <!--
          By testing against child::node(), we can explicitly suppress the
          documentation from the mode by doing <xd:return/> without causing
          an empty Returns: section.
        -->
        <div class="property">
          <div class="propertyCaption">Returns:</div>
          <div class="propertyContent"><xsl:apply-templates select="$useReturnDoc/xd:return/child::node()" mode="XdocTags"/></div>
        </div>
      </xsl:if>

       <!-- Attribute Sets (JK, 11/2007) -->
       <xsl:if test="@use-attribute-sets">
          <div class="property">
             <div class="propertyCaption">Attribute Sets:</div>
             <div class="propertyContent">
                <div class="attSetDetail">
                   <xsl:copy-of select="xd:printUseAttributeSets(.)"/>
                </div>
             </div>
          </div>
       </xsl:if>
       
       <xsl:if test="xsl:attribute">
          <div class="property">
             <div class="propertyCaption">Attributes:</div>
             <div class="propertyContent">
                <xsl:for-each select="xsl:attribute">
                   <!-- List attributes -->
                   <div class="attSetDetail">
                      <xsl:copy-of select="xd:printAttribute(.)"/>
                   </div>
                </xsl:for-each>
             </div>
          </div>
       </xsl:if>
       
       <!-- Template mode usage (GAB, 09/2009) -->
       <xsl:if test="self::xd:mode">
          <xsl:variable name="templates" select="xd:getTemplatesByMode($root, @name)" />
          <xsl:if test="exists($templates)">
            <div class="property">
               <div class="propertyCaption">Templates Using This Mode:</div>
               <div class="propertyContent">
                  <xsl:for-each select="$templates">
                    <xsl:sort select="@match" />

                     <!-- List templates -->
                     <div class="matchTemplatesDetail">
                        <xsl:copy-of select="xd:printMatchTemplate(.)"/>
                     </div>
                  </xsl:for-each>
               </div>
            </div>
          </xsl:if>
       </xsl:if>
       
       <!-- Namespaces (GAB, 09/2009) -->
       <xsl:variable name="namespacePrefixes" as="xs:string*">
         <xsl:choose>
           <xsl:when test="self::xsl:stylesheet or self::xsl:transform">
             <xsl:variable name="prefixes" select="in-scope-prefixes(.)"/>
             <xsl:for-each select="in-scope-prefixes(.)">
               <xsl:sort />
               <xsl:choose>
                 <xsl:when test=". = 'xml'" />
                 <xsl:when test=". = ''">#default</xsl:when>
                 <xsl:otherwise><xsl:sequence select="." /></xsl:otherwise>
               </xsl:choose>
             </xsl:for-each>
           </xsl:when>
           <xsl:when test="self::xsl:namespace-alias">
             <xsl:if test="@stylesheet-prefix"><xsl:sequence select="@stylesheet-prefix"/></xsl:if>
             <xsl:if test="@result-prefix"><xsl:sequence select="@result-prefix"/></xsl:if>
           </xsl:when>
           <xsl:when test="self::xsl:preserve-space or self::xsl:strip-space">
             <xsl:variable name="namespaceListDup" as="xs:string*">
               <xsl:for-each select="xd:splitWhitespaceString(@elements)">
                 <xsl:sequence select="if (contains(., ':')) then substring-before(., ':') else '#default'" />
               </xsl:for-each>
             </xsl:variable>
             <xsl:sequence select="distinct-values($namespaceListDup)" />
           </xsl:when>
           <xsl:when test="not(self::xd:mode)">
            <!-- Warn about anything that differs from the root -->
            <xsl:for-each select="distinct-values((in-scope-prefixes($cur), in-scope-prefixes($root)))">
              <xsl:sort />
              <xsl:if test="string(namespace-uri-for-prefix(., $cur)) != string(namespace-uri-for-prefix(., $root))">
                <xsl:choose>
                  <xsl:when test=". = ''">#default</xsl:when>
                  <xsl:otherwise><xsl:sequence select="." /></xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
           </xsl:when>
         </xsl:choose>
       </xsl:variable>
       <xsl:if test="exists($namespacePrefixes)">
          <div class="property">
            <div class="propertyCaption">Namespace Prefix Summary:</div>
            <div class="propertyContent">
              <xsl:for-each select="$namespacePrefixes">
                <div class="namespacePrefixDetail">
                  <span class="namespacePrefix"><xsl:value-of select="."/></span>
                  <xsl:text>&#160;-&#160;</xsl:text>
                  <span class="namespace"><xsl:value-of select="namespace-uri-for-prefix(if (. != '#default') then . else '', $cur)"/></span>
                </div>
              </xsl:for-each>
            </div>
          </div>
       </xsl:if>
       
       <xsl:if test="(self::xsl:stylesheet | self::xsl:transform)/(@xpath-default-namespace | @xsl:xpath-default-namespace)">
          <!--
            XPath default namespace is already taken care of by everything else,
            so we only display it for the root here.
          -->
          <div class="property">
            <div class="propertyCaption">XPath Default Namespace:</div>
            <div class="propertyContent"><xsl:value-of select="@xpath-default-namespace | @xsl:xpath-default-namespace" /></div>
          </div>
       </xsl:if>
       
    </xsl:variable>
    <xsl:if test="count($htmlResult/*) != 0">   
      <div class="properties">
        <xsl:copy-of select="$htmlResult"/>
      </div>
    </xsl:if>
  </xsl:template>
  
  <!-- 
  ***************************************
  * Templates with mode 'printProperty'
  ***************************************
  -->
  <xd:doc>
    <xd:short>Overwrites XSLT default rules.</xd:short>
    <xd:detail>This ensures that tags not handled
    in the mode <i>printProperty</i> are not printed.</xd:detail>
  </xd:doc>
  <xsl:template match="*" mode="printProperty"/>

  <!-- **** -->
  <xd:doc>
    <xd:short>Prints the short description of a documented xsl function or template.</xd:short>
    <xd:detail> 
      If there's nn xd:doc element dedined or he xd:doc element does not contain a short description, the string 
      &quot;No short description available&quot; is printed.
    </xd:detail>
  </xd:doc>
  <xsl:template match="*" mode="printShortDescription">
    <xsl:param name="doc" select="xd:getDoc(.)" as="element(xd:doc)?"/>
    <div class="shortDescr">
      <xsl:choose>
        <xsl:when test="count($doc) != 0">
          <!-- xd documentation exists, find short description -->
          <xsl:choose>
            <xsl:when test="$doc/xd:short">
              <xsl:apply-templates select="$doc/xd:short/child::node()" mode="XdocTags"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="extractShortDescription">
                <xsl:with-param name="doc" select="$doc"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>No short description available</xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
  
  <xd:doc>
    <xd:short>Returns the xd:doc node of an element.</xd:short>
    <xd:detail></xd:detail>
    <xd:param name="element">
      The element can be one of the following:
      <ul>
        <li>xsl:stylesheet</li>
        <li>xsl:transform</li>
        <li>xsl:template</li>
        <li>xsl:function</li>
      </ul>
      Returns the empty sequence if no xd:doc element was found for the given element.
    </xd:param>
  </xd:doc>
  <xsl:function name="xd:getDoc" as="element(xd:doc)?">
    <xsl:param name="element" as="element(*)"/>
    <xsl:choose>
      <xsl:when test="$element[self::xsl:stylesheet | self::xsl:transform]">
        <xsl:sequence select="$element/xd:doc[@type='stylesheet']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$element/preceding-sibling::*[1][self::xd:doc and (@type != 'stylesheet' or not(@type)) and not(@mode)]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xd:doc>
    <xd:short>Returns the xd:doc nodes for the mode(s) of a template.</xd:short>
    <xd:detail></xd:detail>
    <xd:param name="element">
      The xsl:stylesheet or xsl:transform element.
    </xd:param>
    <xd:param name="modeAttr">
      The mode attribute.
    </xd:param>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:function name="xd:getModeDoc" as="element(xd:doc)*">
    <xsl:param name="element" as="element(*)"/>
    <xsl:param name="mode" />
    <xsl:choose>
      <xsl:when test="$mode = '#all'">
        <xsl:sequence select="$element/xd:doc[@mode][xd:accessMatch(.)]"/>
      </xsl:when>
      <xsl:when test="$mode">
        <xsl:for-each select="xd:splitWhitespaceString($mode)">
          <xsl:sequence select="$element/xd:doc[@mode = $mode][xd:accessMatch(.)]"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$element/xd:doc[@mode = '#default'][xd:accessMatch(.)]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xd:doc>
    <xd:short>Indexes all xsl:character-map elements in each stylesheet by name.</xd:short>
  </xd:doc>
  <xsl:key
    name="xd:character-map"
    match="/xsl:stylesheet/xsl:character-map | /xsl:transform/xsl:character-map"
    use="@name"
  />
  
  <xd:doc>
    Prints the declaration of a function or template.
    <xd:param name="link">If this parameter equals to true() it adds the declaration as a link to the detailied declaration</xd:param>
  </xd:doc>
  <xsl:template match="xsl:function | xsl:template | xsl:param | xsl:variable | xsl:attribute-set | xsl:key | xsl:output | xsl:preserve-space | xsl:strip-space | xsl:namespace-alias | xsl:character-map | xsl:decimal-format | xd:mode" mode="printDeclaration">
    <xsl:param name="link" select="false()"/>
    <xsl:param name="doc" select="xd:getDoc(.)" as="element(xd:doc)?"/>
    <xsl:param name="sourceLinkNode" select="if ($doc) then $doc else ."/>
    <xsl:param name="verbatimUriRel" select="concat(util:getFile(base-uri($sourceLinkNode)), '.src.html')"/>
    <xsl:param name="root" select="(ancestor-or-self::xsl:stylesheet | ancestor-or-self::xsl:transform)[last()]" as="element(*)?"/>
    <xsl:param name="showModes" select="false()"/>
    <xsl:variable name="verbatimLink" select="concat( $verbatimUriRel,'#', generate-id($sourceLinkNode))"/>
    
    <xsl:variable name="name" as="xs:string">
      <xsl:choose>
        <xsl:when test="self::xsl:template/@match"><xsl:value-of select="@match"/></xsl:when>
        <xsl:when test="self::xsl:namespace-alias"><xsl:value-of select="concat(@stylesheet-prefix, ' &#x2192; ', @result-prefix)"/></xsl:when>
        <xsl:when test="self::xsl:preserve-space or self::xsl:strip-space"><xsl:value-of select="@elements"/></xsl:when>
        <xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
        <xsl:otherwise>#default</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="declaration">
      <!-- Declaration access -->
      <xsl:if test="@xd:access">
        <span class="accessType"><xsl:value-of select="@xd:access"/>&#160;</span>
      </xsl:if>

      <!-- Declaration type -->
      <xsl:choose>
        <xsl:when test="self::xsl:preserve-space">
          <span class="paramType">preserve&#160;</span>
        </xsl:when>
        <xsl:when test="self::xsl:strip-space">
          <span class="paramType">strip&#160;</span>
        </xsl:when>
        <xsl:when test="$doc/@type">
          <span class="paramType"><xsl:value-of select="$doc/@type"/>&#160;</span>
        </xsl:when>
        <xsl:when test="@as and not($doc/@type)">
          <span class="paramType"><xsl:value-of select="@as"/>&#160;</span>
        </xsl:when>
      </xsl:choose>
      <!-- Declaration Name -->
      <span class="declName">
        <xsl:choose>
          <xsl:when test="$link">
            <a class="declLink" href="{$link}"><xsl:value-of select="$name"/></a>
          </xsl:when>
          <xsl:when test="self::xd:mode[@name = '#default']">
            <a name="modesDetail_defaultMode"><xsl:value-of select="$name"/></a>
          </xsl:when>
          <xsl:when test="self::xd:mode">
            <a name="modesDetail_mode_{@name}"><xsl:value-of select="$name"/></a>
          </xsl:when>
          <xsl:otherwise>
            <a name="{generate-id(.)}"><xsl:value-of select="$name"/></a>
          </xsl:otherwise>
        </xsl:choose>
      </span>
      <!-- Mode and Params and (key: match and use)  -->
      <xsl:variable name="propertyInfo" as="element(*)*"> 
				<xsl:if test="@use-when or @xsl:use-when">
          <div>
            <span class="declCaption">use-when: </span>
            <xsl:value-of select="@use-when | @xsl:use-when"/>
          </div>
				</xsl:if>

        <xsl:if test="xsl:param">
          <div>
            <span class="declCaption">param: </span>
            <xsl:for-each select="xsl:param">
              <xsl:copy-of select="xd:printParamDeclaration(., $doc)"/>
              <xsl:if test="position() != last()">,&#160;</xsl:if>
            </xsl:for-each>
          </div>
        </xsl:if>
        <!-- Mode -->
        <xsl:if test="$showModes">
          <div>
            <span class="declCaption">mode: </span>
            <xsl:choose>
              <xsl:when test="@mode">
                <xsl:for-each select="xd:splitWhitespaceString(@mode)">
                  <xsl:copy-of select="xd:printMode($root, .)"/>
                  <xsl:if test="position() != last()">&#160;</xsl:if>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise><xsl:copy-of select="xd:printMode($root, '#default')" /></xsl:otherwise>
            </xsl:choose>
          </div>
        </xsl:if>
        <!-- Character maps -->
        <xsl:variable name="characterMaps" as="element(xsl:character-map)*">
          <xsl:for-each select="xd:splitWhitespaceString(@use-character-maps)">
            <xsl:sequence select="$root/xsl:character-map[@name = current()][xd:accessMatch(.)][1]" />
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="exists($characterMaps)">
          <div>
            <span class="declCaption">use-character-maps: </span>
            <xsl:for-each select="$characterMaps">
              <a href="#{generate-id(.)}"><xsl:value-of select="@name"/></a>
              <xsl:if test="position() != last()">&#160;</xsl:if>
            </xsl:for-each>
          </div>
        </xsl:if>
        <xsl:for-each select="(
          self::xsl:template/@priority,
          self::xsl:function/@override,
          self::xsl:key/@match,
          self::xsl:key/@use,
          @xpath-default-namespace,
          @xsl:xpath-default-namespace
        )">
          <div>
            <span class="declCaption"><xsl:value-of select="concat(local-name(.), ': ')" /></span>
            <span class="paramValue"><xsl:value-of select="."/></span>
          </div>
        </xsl:for-each>
      </xsl:variable>
      <xsl:if test="exists($propertyInfo)">
        <xsl:text> (</xsl:text>
        <xsl:for-each select="$propertyInfo">
          <xsl:copy-of select="child::node()" />
          <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
      </xsl:if>
      <!-- Link to source -->
      <xsl:if test="not(self::xd:mode) or $doc">
        <xsl:text> - </xsl:text>
        <a class="sourceLink" href="{$verbatimLink}">source</a>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xd:doc>
    
  </xd:doc>
  <xsl:function name="xd:printParamDeclaration">
    <xsl:param name="param"/>
    <xsl:param name="doc"/>
    <!-- Param type -->
    <xsl:choose>
      <xsl:when test="$doc/xd:param[@name=$param/@name]/@type">
        <span class="paramType"><xsl:value-of select="$doc/xd:param[@name=$param/@name]/@type"/>&#160;</span>
      </xsl:when>
      <xsl:when test="$param/@as">
        <span class="paramType"><xsl:value-of select="$param/@as"/>&#160;</span>
      </xsl:when>
    </xsl:choose>
    <!-- Param name -->          
    <span class="paramName">
      <xsl:value-of select="$param/@name"/>
    </span>
    
    <xsl:variable name="paramProps" as="element(*)*">
      <xsl:for-each select="($param/@required, $param/@tunnel)"> 
        <div>
          <span class="paramPropertyName"><xsl:value-of select="local-name()" /></span>
          <xsl:text>=</xsl:text>
          <span class="paramPropertyValue"><xsl:value-of select="." /></span>
        </div>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:if test="exists($paramProps)">
      <span class="paramPropertyList">
        <xsl:text>&#160;[</xsl:text>
        <xsl:for-each select="$paramProps">
          <xsl:copy-of select="child::node()" />
          <xsl:if test="position() != last()">,&#160;</xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
      </span>
    </xsl:if>
  </xsl:function>

   <!-- JK, 11/2007 -->
   <xsl:function name="xd:printAttribute">
      <xsl:param name="att"/>
      <!-- Param name -->          
      <span class="attName">
         <xsl:value-of select="concat($att/@name,': ', if ($att/@select) then $att/@select else $att)"/>
      </span>
   </xsl:function>

  <xd:doc>
    <xd:short>Indexes all xsl:attribute-set elements in each stylesheet by name.</xd:short>
  </xd:doc>
  <xsl:key
    name="xd:attribute-set"
    match="/xsl:stylesheet/xsl:attribute-set | /xsl:transform/xsl:attribute-set"
    use="@name"
  />

  <!-- JK, 11/2007 -->
  <xsl:function name="xd:printUseAttributeSets">
      <xsl:param name="set"/>
      <!-- Param name -->
      <xsl:for-each select="xd:splitWhitespaceString($set/@use-attribute-sets)">
        <xsl:variable name="attSetNode" select="$set/key('xd:attribute-set', current())[xd:accessMatch(.)]" />
        <xsl:choose>
          <xsl:when test="$attSetNode">
            <a href="#{generate-id($attSetNode)}" class="attName">
              <xsl:value-of select="current()"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <span class="attName">
              <xsl:value-of select="current()"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() != last()" xml:space="preserve"><![CDATA[ ]]></xsl:if>
      </xsl:for-each>
   </xsl:function>
   
  <xsl:function name="xd:printMode">
    <xsl:param name="root" as="element(*)"/>
    <xsl:param name="mode"/>
    <!-- Template match -->          
    <span class="modeName">
      <xsl:choose>
        <xsl:when test="$mode = '#all' or not(xd:accessMatch($root/xd:doc[@mode = $mode]))"><xsl:value-of select="$mode"/></xsl:when>
        <xsl:otherwise>
          <a href="#modesDetail_{if ($mode = '#default') then 'defaultMode' else concat('mode_', $mode)}"><xsl:value-of select="$mode"/></a>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:function>
   
  <xsl:function name="xd:printMatchTemplate">
    <xsl:param name="template"/>
    <!-- Template match -->          
    <span class="templateName">
      <a href="#{generate-id($template)}"><xsl:value-of select="$template/@match"/></a>
    </span>
  </xsl:function>
   
  <xd:doc> 
    Prints the short form of the declaration of a template. This
    includes the parameters and the mode. 
    <xd:param name="doc" type="node-set">The xd:doc node-set</xd:param>
    <xd:param name="template" type="node-set">
      The xsl:template node-set for which the <b>declaration</b> should be printed
    </xd:param>
  </xd:doc>
  <xsl:template name="printTemplateDeclaration">
    <xsl:param name="doc"/>
    <xsl:param name="template"/>
    <xsl:if test="$template/xsl:param or $template/@mode">
      <xsl:text> (</xsl:text>
      <xsl:if test="$template/xsl:param">
        <span class="form">param: </span>
        <xsl:for-each select="$template/xsl:param">
          <xsl:if test="$doc/xd:param[@name=current()/@name]">
            <span class="parameterType">
              <xsl:value-of select="$doc/xd:param[@name=current()/@name]/@type"/>&#160;</span>
          </xsl:if>
          <span class="parameterName">
            <xsl:value-of select="@name"/>
          <xsl:if test="position() != last()">,&#160;</xsl:if>
          </span>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test="@mode">
        <span class="form">mode: </span>
        <span class="parameterValue"><xsl:value-of select="$template/@mode"/></span>
      </xsl:if>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    <xd:short>Outputs title for output details and creates detailed documentation for each output.</xd:short>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="outputsDetail">
    <xsl:if test="xsl:output[xd:accessMatch(.)]">
      <div id="outputsDetail" class="detailSection">
      <h2>Outputs Detail</h2>
      
      <xsl:for-each select="xsl:output[xd:accessMatch(.)]">
        <xsl:sort select="@name"/>
        <div class="listItem">
          <xsl:apply-templates select="." mode="printDeclaration"/>
          <div class="detailDoc">
            <xsl:apply-templates select="." mode="printShortDescription"/>
            <xsl:apply-templates select="." mode="printDetailDescription"/>
            
            <div class="outputAttributes">
              <div class="outputAttributesHeader">Attributes</div>
              <xsl:apply-templates select="(@*[not(contains(name(), ':'))] | @xsl:*)[local-name() != 'name']"
                mode="outputsDetailAttributes">
                <xsl:sort select="local-name()" />
              </xsl:apply-templates>
            </div>
            <xsl:apply-templates select="." mode="printProperties"/>
          </div>
        </div>
      </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    <xd:short>Outputs title for element space details and creates detailed documentation for each element.</xd:short>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="elementSpaceDetail">
    <xsl:if test="(xsl:preserve-space | xsl:strip-space)[xd:accessMatch(.)]">
      <div id="elementSpaceDetail" class="detailSection">
      <h2>Element Space Detail</h2>
      
      <xsl:for-each select="(xsl:preserve-space | xsl:strip-space)[xd:accessMatch(.)]">
        <!-- strip-space goes last -->
        <xsl:sort select="boolean(self::xsl:strip-space)"/>
        <xsl:sort select="@elements"/>
        <div class="listItem">
          <xsl:apply-templates select="." mode="printDeclaration"/>
          <div class="detailDoc">
            <xsl:apply-templates select="." mode="printShortDescription"/>
            <xsl:apply-templates select="." mode="printDetailDescription"/>
            <xsl:apply-templates select="." mode="printProperties"/>
          </div>
        </div>
      </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    <xd:short>Outputs title for namespace alias details and creates detailed documentation for each namespace alias.</xd:short>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="namespaceAliasesDetail">
    <xsl:if test="xsl:namespace-alias[xd:accessMatch(.)]">
      <div id="namespaceAliasesDetail" class="detailSection">
      <h2>Namespace Aliases Detail</h2>
      
      <xsl:for-each select="xsl:namespace-alias[xd:accessMatch(.)]">
        <xsl:sort select="@stylesheet-prefix"/>
        <xsl:sort select="@result-prefix"/>
        <div class="listItem">
          <xsl:apply-templates select="." mode="printDeclaration"/>
          <div class="detailDoc">
            <xsl:apply-templates select="." mode="printShortDescription"/>
            <xsl:apply-templates select="." mode="printDetailDescription"/>
            <xsl:apply-templates select="." mode="printProperties"/>
          </div>
        </div>
      </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*" mode="outputsDetailAttributes">
    <div class="outputAttributeItem">
      <div class="outputAttributeName"><xsl:value-of select="name()"/></div>
      <div class="outputAttributeValue"><xsl:value-of select="."/></div>
    </div>
  </xsl:template>
  
  <xsl:template match="@use-character-maps" mode="outputsDetailAttributes">
    <xsl:variable name="context" select="." /> 
    <div class="outputAttributeItem">
      <div class="outputAttributeName"><xsl:value-of select="name()"/></div>
      <div class="outputAttributeValue">
        <xsl:for-each select="xd:splitWhitespaceString(.)">
          <!--
            Here we show the private character map names, but we don't link
            them. This is different from the declaration display, in which they
            are hidden. This is because we are only trying to spice up the
            otherwise verbatim attribute values with links.
          -->
          <xsl:variable name="characterMap" select="$context/key('xd:character-map', current())[xd:accessMatch(.)]" />
          <xsl:choose>
            <xsl:when test="$characterMap">
              <a href="#{generate-id($characterMap)}" class="characterMap"><xsl:value-of select="."/></a>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
          </xsl:choose>
          <xsl:if test="not(position() = last())" xml:space="preserve"><![CDATA[ ]]></xsl:if>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>
  
  <xd:doc>The upper-case hexadecimal digits.</xd:doc>
  <xsl:variable name="hexDigitsUpper" select="('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F')" />
  
  <xd:doc>
    <xd:short>Outputs title for character map details and creates detailed documentation for each character map.</xd:short>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="characterMapsDetail">
    <xsl:if test="xsl:character-map[xd:accessMatch(.)]">
      <div id="characterMapsDetail" class="detailSection">
      <h2>Character Maps Detail</h2>
      
      <xsl:for-each select="xsl:character-map[xd:accessMatch(.)]">
        <xsl:sort select="@name"/>
        <div class="listItem">
          <xsl:apply-templates select="." mode="printDeclaration"/>
          <div class="detailDoc">
            <xsl:apply-templates select="." mode="printShortDescription"/>
            <xsl:apply-templates select="." mode="printDetailDescription"/>
            
            <!-- Displays the output character table -->
            <table class="characterMapTable">
              <thead>
                <tr><th colspan="4">Mappings</th></tr>
                <tr><th>Char.</th><th>Dec.</th><th>Hex.</th><th>String</th></tr>
              </thead>
              <tbody>
                <xsl:for-each select="xsl:output-character">
                  <tr>
                    <td class="characterMapChar"><xsl:value-of select="@character"/></td>
                    <td class="characterMapDec">#<xsl:value-of select="string-to-codepoints(@character)"/></td>
                    <td class="characterMapHex">#x<xsl:value-of select="xd:decToBase(string-to-codepoints(@character), $hexDigitsUpper)"/></td>
                    <td class="characterMapString"><xsl:value-of select="@string"/></td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
            <xsl:apply-templates select="." mode="printProperties"/>
          </div>
        </div>
      </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    <xd:short>Outputs title for decimal format details and creates detailed documentation for each decimal format.</xd:short>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="decimalFormatsDetail">
    <xsl:if test="xsl:decimal-format[xd:accessMatch(.)]">
      <div id="decimalFormatsDetail" class="detailSection">
      <h2>Decimal Formats Detail</h2>
      
      <xsl:for-each select="xsl:decimal-format[xd:accessMatch(.)]">
        <xsl:sort select="@name"/>
        <div class="listItem">
          <xsl:apply-templates select="." mode="printDeclaration"/>
          <div class="detailDoc">
            <xsl:apply-templates select="." mode="printShortDescription"/>
            <xsl:apply-templates select="." mode="printDetailDescription"/>
            
            <div class="decimalFormatAttributes">
              <div class="decimalFormatAttributesHeader">Attributes</div>
              <xsl:apply-templates select="(@*[not(contains(name(), ':'))] | @xsl:*)[local-name() != 'name']"
                mode="decimalFormatsDetailAttributes">
                <xsl:sort select="local-name()" />
              </xsl:apply-templates>
            </div>
            <xsl:apply-templates select="." mode="printProperties"/>
          </div>
        </div>
      </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="@*" mode="decimalFormatsDetailAttributes">
    <div class="decimalFormatAttributeItem">
      <div class="decimalFormatAttributeName"><xsl:value-of select="name()"/></div>
      <div class="decimalFormatAttributeValue"><xsl:value-of select="."/></div>
    </div>
  </xsl:template>

  <xd:doc>Outputs title for function details and creates detailed documentation for each function</xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="functionsDetail">
    <xsl:if test="xsl:function[xd:accessMatch(.)]">
      <div id="functionsDetail" class="detailSection">
      <h2>Functions Detail</h2>
      <xsl:for-each select="xsl:function[xd:accessMatch(.)]">
        <xsl:sort select="@name"/>
        <div class="listItem"> 
          <xsl:apply-templates select="." mode="printDeclaration"/>
          <div class="detailDoc">
            <xsl:apply-templates select="." mode="printShortDescription"/>
            <xsl:apply-templates select="." mode="printDetailDescription"/>
            <xsl:apply-templates select="." mode="printProperties"/>
          </div>
        </div>
      </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    <xd:short>Outputs title for template mode details and creates detailed documentation for each template mode.</xd:short>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="templateModesDetail">
    <xsl:variable name="root" select="." />
    
    <xsl:if test="(xd:doc | xsl:template)[xd:accessMatch(.)]/@mode">
      <xsl:variable name="modeList" select="xd:getModes(.)" as="xs:string*" />
      <div id="templateModesDetail" class="detailSection">
        <h2>Template Modes Detail</h2>
        <xsl:for-each select="$modeList">
          <xsl:sort />
          <div class="listItem">
            <xsl:variable name="doc" select="$root/xd:doc[@mode = current()]" />
            <xsl:variable name="modeData">
              <xd:mode name="{current()}" />
            </xsl:variable>
            <xsl:apply-templates select="$modeData" mode="printDeclaration">
              <xsl:with-param name="doc" select="$doc" />
            </xsl:apply-templates>
            <div class="detailDoc">
              <xsl:apply-templates select="$modeData" mode="printShortDescription">
                <xsl:with-param name="doc" select="$doc" />
              </xsl:apply-templates>
              <xsl:apply-templates select="$modeData" mode="printDetailDescription">
                <xsl:with-param name="doc" select="$doc" />
              </xsl:apply-templates>
              <xsl:apply-templates select="$modeData" mode="printProperties">
                <xsl:with-param name="root" select="$root" />
                <xsl:with-param name="doc" select="$doc" />
              </xsl:apply-templates>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>Outputs title for named template details and creates detailed documentation for each named template</xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="namedTemplatesDetail">
    <xsl:if test="xsl:template[@name and xd:accessMatch(.)]">
      <div id="namedTemplatesDetail" class="detailSection">
      <h2>Named Templates Detail</h2>
      <xsl:for-each select="xsl:template[@name and xd:accessMatch(.)]">
        <xsl:sort select="@name"/>
        <div class="listItem"> 
          <xsl:apply-templates select="." mode="printDeclaration"/>
          <div class="detailDoc">
            <xsl:apply-templates select="." mode="printShortDescription"/>
            <xsl:apply-templates select="." mode="printDetailDescription"/>
            <xsl:apply-templates select="." mode="printProperties"/>
          </div>
        </div>
      </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>Outputs title for match template details and creates detailed documentation for each match template</xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="matchTemplatesDetail">
    <xsl:variable name="root" select="."/>
    <xsl:if test="xsl:template[@match and xd:accessMatch(.)]">
      <div id="matchTemplatesDetail" class="detailSection">
      <h2>Match Templates Detail</h2>
      <xsl:for-each select="xsl:template[@match and xd:accessMatch(.)]">
        <xsl:sort select="@mode"/>
        <xsl:sort select="@match"/>
        <div class="listItem"> 
          <xsl:apply-templates select="." mode="printDeclaration">
            <xsl:with-param name="showModes" select="boolean($root/(xd:doc | xsl:template)[xd:accessMatch(.)]/@mode)" />
          </xsl:apply-templates>
          <div class="detailDoc">
            <xsl:apply-templates select="." mode="printShortDescription"/>
            <xsl:apply-templates select="." mode="printDetailDescription"/>
            <xsl:apply-templates select="." mode="printProperties"/>
          </div>
        </div>
      </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>Outputs title for parameter details and creates detailed documentation for each parameter</xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="parametersDetail">
    <xsl:if test="xsl:param[xd:accessMatch(.)]">
      <div id="parametersDetail" class="detailSection">
      <h2>Parameters Detail</h2>
      <xsl:for-each select="xsl:param[xd:accessMatch(.)]">
        <xsl:sort select="@name"/>
        <div class="listItem"> 
          <xsl:apply-templates select="." mode="printDeclaration"/>
          <div class="detailDoc">
            <xsl:apply-templates select="." mode="printShortDescription"/>
            <xsl:apply-templates select="." mode="printDetailDescription"/>
            <xsl:apply-templates select="." mode="printProperties"/>
          </div>
        </div>
      </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

   <xd:doc>JK, 11/2007 - Outputs title for variables details and creates detailed documentation for each variable</xd:doc>
   <xsl:template match="xsl:stylesheet | xsl:transform" mode="variablesDetail">
      <xsl:if test="xsl:variable[xd:accessMatch(.)]">
         <div id="variablesDetail" class="detailSection">
            <h2>Variables Detail</h2>
            <xsl:for-each select="xsl:variable[xd:accessMatch(.)]">
               <xsl:sort select="@name"/>
               <div class="listItem"> 
                  <xsl:apply-templates select="." mode="printDeclaration"/>
                  <div class="detailDoc">
                     <xsl:apply-templates select="." mode="printShortDescription"/>
                     <xsl:apply-templates select="." mode="printDetailDescription"/>
                     <xsl:apply-templates select="." mode="printProperties"/>
                  </div>
               </div>
            </xsl:for-each>
         </div>
      </xsl:if>
   </xsl:template>

  <xd:doc>SM, 05/12/2007 - Outputs title for keys and creates detailed documentation for each key</xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="keysDetail">
		<xsl:if test="xsl:key[xd:accessMatch(.)]">
			<div id="keysDetail" class="detailSection">
				<h2>Keys Detail</h2>
				<xsl:for-each select="xsl:key[xd:accessMatch(.)]">
					<xsl:sort select="@name"/>
					<div class="listItem"> 
						<xsl:apply-templates select="." mode="printDeclaration"/>
						<div class="detailDoc">
							<xsl:apply-templates select="." mode="printShortDescription"/>
							<xsl:apply-templates select="." mode="printDetailDescription"/>
							<xsl:apply-templates select="." mode="printProperties"/>
						</div>
					</div>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xd:doc>JK, 11/2007 - Outputs title for attribute sets details and creates detailed documentation for each attribute set</xd:doc>
   <xsl:template match="xsl:stylesheet | xsl:transform" mode="attSetsDetail">
      <xsl:if test="xsl:attribute-set[xd:accessMatch(.)]">
         <div id="attSetsDetail" class="detailSection">
            <h2>Attibute Sets Detail</h2>
            <xsl:for-each select="xsl:attribute-set[xd:accessMatch(.)]">
               <xsl:sort select="@name"/>
               <div class="listItem"> 
                  <xsl:apply-templates select="." mode="printDeclaration"/>
                  <div class="detailDoc">
                     <xsl:apply-templates select="." mode="printShortDescription"/>
                     <xsl:apply-templates select="." mode="printDetailDescription"/>
                     <xsl:apply-templates select="." mode="printProperties"/>
                  </div>
               </div>
            </xsl:for-each>
         </div>
      </xsl:if>
   </xsl:template>
   
   <xd:doc>Prints details of the stylesheet.</xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="stylesheetDetail" xmlns="http://www.w3.org/1999/xhtml">
    <div xmlns="http://www.w3.org/1999/xhtml" id="stylesheetDetail">
      <!-- ************* Title ********************** -->
      <h1><xsl:value-of select="util:getFile(base-uri(.))"/></h1>
      <div class="detailDoc">
        <!-- ************* Includes ******************* -->
        <xsl:if test="xsl:include">
          <div id="includes">
            <h2>Includes</h2>
            <ul>
              <xsl:for-each select="xsl:include">
                <li>
                  <a href="{@href}.xd.html" class="filelink"><xsl:value-of select="@href"/></a>
                </li>
              </xsl:for-each>
            </ul>
          </div>
        </xsl:if>
        <!-- ************* Imorts ********************* -->
        <xsl:if test="xsl:import">
          <div id="imports">
            <h2>Imports</h2>
            <ul>
              <xsl:for-each select="xsl:import">
                <li>
                  <a href="{@href}.xd.html" class="filelink"><xsl:value-of select="@href"/></a>
                </li>
              </xsl:for-each>
            </ul>
          </div>
        </xsl:if>
        
        <!-- Imported schemas (GAB, 09/2009) -->
        <xsl:if test="xsl:import-schema">
          <div id="importedSchemas">
            <h2>Imported Schemas</h2>
            <ul>
              <xsl:for-each select="xsl:import-schema">
                <li>
                  <xsl:variable name="schemaNamespace" as="xs:string?">
                    <xsl:choose>
                      <xsl:when test="xs:schema"><xsl:value-of select="xs:schema/@targetNamespace"/></xsl:when>
                      <xsl:when test="@namespace"><xsl:value-of select="@namespace"/></xsl:when>
                      <xsl:when test="@schema-location"><xsl:value-of select="document(@schema-location, .)/xs:schema/@targetNamespace"/></xsl:when>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="$schemaNamespace != ''">
                      <span class="namespace"><xsl:value-of select="concat('{', $schemaNamespace, '}')"/></span>
                      <xsl:variable name="prefixes" select="in-scope-prefixes(.)[namespace-uri-for-prefix(., current()) = $schemaNamespace]"/>
                      <xsl:if test="exists($prefixes)">
                        <xsl:text>&#160;(</xsl:text>
                        <xsl:value-of select="$prefixes" separator=", "/>
                        <xsl:text>)</xsl:text>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <span class="namespace">#default</span>
                    </xsl:otherwise>
                  </xsl:choose>

                  <xsl:text> - </xsl:text>
                  
                  <xsl:choose>
                    <xsl:when test="xs:schema">
                      <a href="{concat(util:getFile(base-uri(.)),'.src.html#',generate-id(xs:schema))}" class="filelink">[inline]</a>
                    </xsl:when>
                    <xsl:otherwise>
                      <!--
                        TODO: this can be replaced if there is ever an
                        XSD-documentation functionality implemented
                      -->
                      <a href="{resolve-uri(@schema-location, base-uri(.))}" class="filelink"><xsl:value-of select="@schema-location"/></a>
                    </xsl:otherwise>
                  </xsl:choose>
                </li>
              </xsl:for-each>
            </ul>
          </div>
        </xsl:if>
             
        <xsl:apply-templates select="." mode="printShortDescription"/>
        <xsl:apply-templates select="." mode="printDetailDescription"/>
        <xsl:apply-templates select="." mode="printProperties"/>
      </div> <!-- detailDoc -->
    </div> <!-- stylesheetDetail -->
  </xsl:template>
  
  <xd:doc>
    Generates function summary section.
    Prints title of the section and then iterates through
    all functions and prints its declaration and short description
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="functionsSummary">
    <xsl:if test="xsl:function[xd:accessMatch(.)]">
      <div id="functionsSummary" class="summarySection">
        <h2>Functions Summary</h2>
        <xsl:for-each select="xsl:function[xd:accessMatch(.)]">
          <xsl:sort select="@name"/>
          <div class="listItem">
            <xsl:apply-templates select="." mode="printDeclaration">
              <xsl:with-param name="link" select="concat('#', generate-id(.))"/>
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="." mode="printShortDescription"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    <xd:short>Returns a sequence of names of modes in a stylesheet.</xd:short>
    <xd:detail>This function returns both modes that are explicitly documented and modes that are
    implicitly used.</xd:detail>
    <xd:param name="element">
      The xsl:stylesheet or xsl:transform element.
    </xd:param>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:function name="xd:getModes" as="xs:string*">
    <xsl:param name="element" as="element(*)"/>
	
    <xsl:variable name="modeList" as="xs:string*">
      <xsl:if test="$element/xd:doc[@mode = '#default'] or $element/xsl:template[@match and not(@mode)]">
        <xsl:sequence select="('#default')" />
      </xsl:if>

      <xsl:sequence select="$element/xd:doc/@mode" />

      <xsl:for-each select="$element/xsl:template[xd:accessMatch(.)]/@mode">
        <xsl:for-each select="xd:splitWhitespaceString(.)">
          <xsl:if test=". != '#all'">
            <xsl:sequence select="." />
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:sequence select="distinct-values($modeList)" />
  </xsl:function>
  
  <xd:doc>
    <xd:short>Splits a whitespace-separated string into a sequence.</xd:short>
    <xd:param name="string">
      The string to split.
    </xd:param>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:function name="xd:splitWhitespaceString" as="xs:string*">
    <xsl:param name="string" as="xs:string?"/>
    <xsl:sequence select="tokenize(normalize-space($string), ' ')" />
  </xsl:function>
  
  <xd:doc>
    <xd:short>Converts a decimal number to a string with another numeric base, given the set of digits.</xd:short>
    <xd:param name="dec">The decimal number.</xd:param>
    <xd:param name="digits">The sequence of digits.</xd:param>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:function name="xd:decToBase" as="xs:string">
    <xsl:param name="dec" as="xs:integer" />
    <xsl:param name="digits" as="xs:string*"/>
    <xsl:variable name="base" select="count($digits)" />
    <xsl:choose>
      <xsl:when test="$dec &lt; 0">
        <xsl:text>-</xsl:text>
        <xsl:value-of select="xd:decToBase(-$dec, $digits)"/>
      </xsl:when>
      <xsl:when test="$dec = 0">0</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat((if ($dec idiv $base != 0) then xd:decToBase($dec idiv $base, $digits) else ''), $digits[($dec mod $base) + 1])"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xd:doc>
    <xd:short>Returns a sequence of templates using a given mode in a stylesheet.</xd:short>
    <xd:param name="element">
      The xsl:stylesheet or xsl:transform element.
    </xd:param>
    <xd:param name="name">
      The mode name for which to search.
    </xd:param>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:function name="xd:getTemplatesByMode" as="element(xsl:template)*">
    <xsl:param name="element" as="element(*)"/>
    <xsl:param name="mode" as="xs:string" />
	
    <xsl:for-each select="$element/xsl:template[@match]">
      <xsl:if test="
        @mode = '#all'
        or (not(@mode) and $mode = '#default')
        or exists(index-of(xd:splitWhitespaceString(@mode), $mode))
      ">
        <xsl:sequence select="(.)" />
      </xsl:if>
    </xsl:for-each>
  </xsl:function>
  
  <xd:doc>
    <xd:short>Determines if an element satisfies the access level specified for the documentation generation.</xd:short>
    <xd:param name="element">
      The element to check.
    </xd:param>
    <xd:param name="access">
      The access level. Defaults to the global xd:access parameter.
    </xd:param>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:function name="xd:accessMatch" as="xs:boolean">
    <xsl:param name="element" as="element(*)?"/>   
    <xsl:variable name="testAccess" select="if ($element/@xd:access) then $element/@xd:access else 'public'" />
    
    <xsl:choose>
      <xsl:when test="$testAccess = 'private'"><xsl:value-of select="$access = 'private'"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="true()" /></xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xd:doc>
    <xd:short>Generates template mode summary section.</xd:short>
    <xd:detail>Prints title of the section and then iterates through
    all template modes and prints their declarations and short descriptions.</xd:detail>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="templateModesSummary">
    <xsl:variable name="root" select="." />
    
    <xsl:if test="(xd:doc | xsl:template)[xd:accessMatch(.)]/@mode">
      <xsl:variable name="modeList" select="xd:getModes(.)" as="xs:string*" />
      <div id="templateModesSummary" class="summarySection">
        <h2>Template Modes Summary</h2>
        <xsl:for-each select="$modeList">
          <xsl:sort />
          <div class="listItem">
            <xsl:variable name="doc" select="$root/xd:doc[@mode = current()]" />
            <xsl:variable name="modeData">
              <xd:mode name="{current()}" />
            </xsl:variable>
            <xsl:apply-templates select="$modeData" mode="printDeclaration">
              <xsl:with-param name="doc" select="$doc"/>
              <xsl:with-param name="link">
                <xsl:call-template name="getGeneratedId">
                  <xsl:with-param name="type" select="'mode'" />
                  <xsl:with-param name="name" select="current()" />
                </xsl:call-template>
              </xsl:with-param>
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="$modeData" mode="printShortDescription">
                <xsl:with-param name="doc" select="$doc"/>
              </xsl:apply-templates>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    Generates match template summary section.
    Prints title of the section and then iterates through
    all templates and prints its declaration and short description
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="matchTemplatesSummary">
    <xsl:variable name="root" select="."/>
    <xsl:if test="xsl:template[@match and xd:accessMatch(.)]">
      <div id="matchTemplatesSummary" class="summarySection">
        <h2>Match Templates Summary</h2>
        <xsl:for-each select="xsl:template[@match and xd:accessMatch(.)]">
          <xsl:sort select="@mode"/>
          <xsl:sort select="@match"/>
          <div class="listItem">      
            <xsl:apply-templates select="." mode="printDeclaration">
              <xsl:with-param name="link" select="concat('#', generate-id(.))"/>
              <xsl:with-param name="showModes" select="boolean($root/(xd:doc | xsl:template)[xd:accessMatch(.)]/@mode)" />
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="." mode="printShortDescription"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    <xd:short>Generates output summary section.</xd:short>
    <xd:detail>Prints title of the section and then iterates through
    all outputs and prints their declarations and short descriptions.</xd:detail>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="outputsSummary">
    <xsl:if test="xsl:output[xd:accessMatch(.)]">
      <div id="outputsSummary" class="summarySection">
        <h2>Outputs Summary</h2>
        <xsl:for-each select="xsl:output[xd:accessMatch(.)]">
          <xsl:sort select="@name"/>
          <div class="listItem">      
            <xsl:apply-templates select="." mode="printDeclaration">
              <xsl:with-param name="link" select="concat('#', generate-id(.))"/>
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="." mode="printShortDescription"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xd:doc>
    <xd:short>Generates element space summary section.</xd:short>
    <xd:detail>Prints title of the section and then iterates through
    all strip-space and preserve-space elements and prints their declarations and short descriptions.</xd:detail>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="elementSpaceSummary">
    <xsl:if test="(xsl:preserve-space | xsl:strip-space)[xd:accessMatch(.)]">
      <div id="elementSpaceSummary" class="summarySection">
        <h2>Element Space Summary</h2>
        <xsl:for-each select="(xsl:preserve-space | xsl:strip-space)[xd:accessMatch(.)]">
          <!-- strip-space goes last -->
          <xsl:sort select="boolean(self::xsl:strip-space)"/>
          <xsl:sort select="@elements"/>
          <div class="listItem">      
            <xsl:apply-templates select="." mode="printDeclaration">
              <xsl:with-param name="link" select="concat('#', generate-id(.))"/>
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="." mode="printShortDescription"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xd:doc>
    <xd:short>Generates namespace alias summary section.</xd:short>
    <xd:detail>Prints title of the section and then iterates through
    all namespace aliases and prints their declarations and short descriptions.</xd:detail>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="namespaceAliasesSummary">
    <xsl:if test="xsl:namespace-alias[xd:accessMatch(.)]">
      <div id="namespaceAliasesSummary" class="summarySection">
        <h2>Namespace Aliases Summary</h2>
        <xsl:for-each select="xsl:namespace-alias[xd:accessMatch(.)]">
          <xsl:sort select="@name"/>
          <div class="listItem">      
            <xsl:apply-templates select="." mode="printDeclaration">
              <xsl:with-param name="link" select="concat('#', generate-id(.))"/>
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="." mode="printShortDescription"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xd:doc>
    <xd:short>Generates character map summary section.</xd:short>
    <xd:detail>Prints title of the section and then iterates through
    all character maps and prints their declarations and short descriptions.</xd:detail>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="characterMapsSummary">
    <xsl:if test="xsl:character-map[xd:accessMatch(.)]">
      <div id="characterMapsSummary" class="summarySection">
        <h2>Character Maps Summary</h2>
        <xsl:for-each select="xsl:character-map[xd:accessMatch(.)]">
          <xsl:sort select="@name"/>
          <div class="listItem">      
            <xsl:apply-templates select="." mode="printDeclaration">
              <xsl:with-param name="link" select="concat('#', generate-id(.))"/>
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="." mode="printShortDescription"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xd:doc>
    <xd:short>Generates decimal formats summary section.</xd:short>
    <xd:detail>Prints title of the section and then iterates through
    all decimal formats and prints their declarations and short descriptions.</xd:detail>
    <xd:author>Greg Beauchesne</xd:author>
    <xd:since>09/2009</xd:since>
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="decimalFormatsSummary">
    <xsl:if test="xsl:decimal-format[xd:accessMatch(.)]">
      <div id="decimalFormatsSummary" class="summarySection">
        <h2>Decimal Formats Summary</h2>
        <xsl:for-each select="xsl:decimal-format[xd:accessMatch(.)]">
          <xsl:sort select="@name"/>
          <div class="listItem">      
            <xsl:apply-templates select="." mode="printDeclaration">
              <xsl:with-param name="link" select="concat('#', generate-id(.))"/>
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="." mode="printShortDescription"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xd:doc>
    Generates parameter summary section.
    Prints title of the section and then iterates through
    all parameters and prints its declaration and short description
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="parametersSummary">
    <xsl:if test="xsl:param[xd:accessMatch(.)]">
      <div id="parametersSummary" class="summarySection">
        <h2>Parameters Summary</h2>
        <xsl:for-each select="xsl:param[xd:accessMatch(.)]">
          <xsl:sort select="@name"/>
          <div class="listItem">      
            <xsl:apply-templates select="." mode="printDeclaration">
              <xsl:with-param name="link" select="concat('#', generate-id(.))"/>
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="." mode="printShortDescription"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    JK, 11/2007
    Generates variable summary section.
    Prints title of the section and then iterates through
    all top level variables and prints its declaration and short description
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="variablesSummary">
    <xsl:if test="xsl:variable[xd:accessMatch(.)]">
      <div id="variablesSummary" class="summarySection">
        <h2>Variables Summary</h2>
        <xsl:for-each select="xsl:variable[xd:accessMatch(.)]">
          <xsl:sort select="@name"/>
          <div class="listItem">      
            <xsl:apply-templates select="." mode="printDeclaration">
              <xsl:with-param name="link" select="concat('#', generate-id(.))"/>
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="." mode="printShortDescription"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
	<xd:doc>
		SM, 05/12/2007
		Generates key summary section.
		Prints title of the section and then iterates through
		all keys and prints its declaration and short description
	</xd:doc>
	<xsl:template match="xsl:stylesheet | xsl:transform" mode="keysSummary">
		<xsl:if test="xsl:key[xd:accessMatch(.)]">
			<div id="keysSummary" class="summarySection">
				<h2>Keys Summary</h2>
				<xsl:for-each select="xsl:key[xd:accessMatch(.)]">
					<xsl:sort select="@name"/>
					<div class="listItem">      
						<xsl:apply-templates select="." mode="printDeclaration">
							<xsl:with-param name="link" select="concat('#', generate-id(.))"/>
						</xsl:apply-templates>
						<div class="shortDoc">
							<xsl:apply-templates select="." mode="printShortDescription"/>
						</div>
					</div>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xd:doc>
    JK, 11/2007
    Generates attribute set summary section.
    Prints title of the section and then iterates through
    all top level variables and prints its declaration and short description
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="attSetsSummary">
    <xsl:if test="xsl:attribute-set[xd:accessMatch(.)]">
      <div id="attSetsSummary" class="summarySection">
        <h2>Attribute Sets Summary</h2>
        <xsl:for-each select="xsl:attribute-set[xd:accessMatch(.)]">
          <xsl:sort select="@name"/>
          <div class="listItem">      
            <xsl:apply-templates select="." mode="printDeclaration">
              <xsl:with-param name="link" select="concat('#', generate-id(.))"/>
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="." mode="printShortDescription"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    Generates template summary section.
    Prints title of the section and then iterates through
    all templates and prints its declaration and short description
  </xd:doc>
  <xsl:template match="xsl:stylesheet | xsl:transform" mode="namedTemplatesSummary">
    <xsl:if test="xsl:template[@name and xd:accessMatch(.)]">
      <div id="namedTemplatesSummary" class="summarySection">
        <h2>Named Templates Summary</h2>
        <xsl:for-each select="xsl:template[@name and xd:accessMatch(.)]">
          <xsl:sort select="@name"/>
          <div class="listItem">      
            <xsl:apply-templates select="." mode="printDeclaration">
              <xsl:with-param name="link" select="concat('#', generate-id(.))"/>
            </xsl:apply-templates>
            <div class="shortDoc">
              <xsl:apply-templates select="." mode="printShortDescription"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xd:doc mode="XdocTags">
    Translates specialized xd: elements into XHTML. This allows for extension
    elements that can do things such as link to other parts of the
    documentation or easily include formatted XML.
  </xd:doc>
  
  <xd:doc>
    Default template in XdocTags mode. This ensures that elements that
    need no conversion(html tags) are copied to the result tree.
    The namespace of an element is translated to xhtml!
  </xd:doc>
  <xsl:template match="*" mode="XdocTags">
    <xsl:element name="{node-name(.)}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="XdocTags"/>
    </xsl:element>
  </xsl:template>
  
  <xd:doc>
    Default template in XdocTags mode for elements in xd namespace.
  </xd:doc>
  <xsl:template match="xd:*" mode="XdocTags">
    <xsl:apply-templates mode="XdocTags"/>
  </xsl:template>
  
  <xd:doc> Converts a xd:link element to a html link. (JK, 11/2007)</xd:doc>
  <xsl:template match="xd:link" mode="XdocTags">
    <a>
      <xsl:variable name="name" select="if (@name) then @name else ."/>
      <xsl:attribute name="href">
        <xsl:call-template name="getGeneratedId">
         <xsl:with-param name="name" select="$name"/>
         <xsl:with-param name="type" select="@type"/>
         <xsl:with-param name="mode" select="@mode"/>
         <xsl:with-param name="stylesheet-prefix" select="@stylesheet-prefix"/>
         <xsl:with-param name="result-prefix" select="@result-prefix"/>
        </xsl:call-template>
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test=". != '' and @name">
          <!-- Verbatim -->
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test=". != '' and not(@name)">
          <!-- Simple automatic -->
          <xsl:if test="@type = 'variable'">
            <xsl:value-of select="'$'"/>
          </xsl:if>
          <xsl:value-of select="."/>
          <xsl:if test="@mode">
            <xsl:value-of select="concat(', mode=&quot;',@mode,'&quot;')"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <!-- Fully automatic -->
          <xsl:apply-templates select="." mode="xdLinkText"/>
          
        </xsl:otherwise>
       </xsl:choose>
     </a>
   </xsl:template>
   
   <xd:doc mode="xdLinkText">
     <xd:short>Selects the automatic text for an xd:link element.</xd:short>
   </xd:doc>
   
   <xsl:template match="xd:link" mode="xdLinkText">
      <xsl:value-of select="@type" />
      <xsl:text>:&#160;</xsl:text>
      <xsl:value-of select="@name" />
   </xsl:template>
   
   <xsl:template match="xd:link[@type = 'match-template']" mode="xdLinkText">
      <xsl:value-of select="@type" />
      <xsl:text>:&#160;</xsl:text>
      <xsl:value-of select="@name" />
      <xsl:if test="@mode">
        <xsl:value-of select="concat(', mode=&quot;',@mode,'&quot;')"/>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="xd:link[@type = 'variable' or @type = 'parameter']" mode="xdLinkText">
      <xsl:value-of select="@type" />
      <xsl:text>:&#160;</xsl:text>
      <xsl:value-of select="concat('$', @name)" />
   </xsl:template>

   <xsl:template match="xd:link[@type = 'namespace-alias']" mode="xdLinkText">
      <xsl:value-of select="@type" />
      <xsl:text>:&#160;</xsl:text>
      <xsl:value-of select="@stylesheet-prefix" />
      <xsl:text>&#160;&#x2192;&#160;</xsl:text>
      <xsl:value-of select="@result-prefix" />
   </xsl:template>
   
   <xsl:template name="getGeneratedId">
     <xsl:param name="name"/>
     <xsl:param name="type"/>
     <xsl:param name="mode"/>
     <xsl:param name="stylesheet-prefix"/>
     <xsl:param name="result-prefix"/>
     <xsl:choose>
       <xsl:when test="$type = 'named-template'">
         <xsl:text>#</xsl:text>
         <xsl:if test="/(xsl:stylesheet | xsl:transform)/xsl:template[@name = $name]">
           <xsl:value-of select="generate-id(/(xsl:stylesheet | xsl:transform)/xsl:template[@name = $name])"></xsl:value-of>
         </xsl:if>         
       </xsl:when>
       <xsl:when test="$type = 'match-template'">
         <xsl:text>#</xsl:text>
         <xsl:choose>
           <xsl:when test="$mode">
             <xsl:if test="/(xsl:stylesheet | xsl:transform)/xsl:template[@match = $name and @mode = $mode]">
               <xsl:value-of select="generate-id(/(xsl:stylesheet | xsl:transform)/xsl:template[@match = $name and @mode = $mode])"></xsl:value-of>
             </xsl:if>               
           </xsl:when>
           <xsl:otherwise>
             <xsl:if test="/(xsl:stylesheet | xsl:transform)/xsl:template[@match = $name]">
               <xsl:value-of select="generate-id(/(xsl:stylesheet | xsl:transform)/xsl:template[@match = $name])"></xsl:value-of>
             </xsl:if>                        
           </xsl:otherwise>
         </xsl:choose>         
       </xsl:when>
       <xsl:when test="
             $type = 'variable'
          or $type = 'key'
          or $type = 'attribute-set'
          or $type = 'output'
          or $type = 'character-map'
          or $type = 'decimal-format'
       ">
         <xsl:variable name="element" select="/(xsl:stylesheet | xsl:transform)/xsl:*[local-name() = $type and (@name = $name or ($name = '#default' and not(@name)))]" />
         <xsl:text>#</xsl:text>
         <xsl:if test="$element">
           <xsl:value-of select="generate-id($element)"/>
         </xsl:if>                  
       </xsl:when>
       <xsl:when test="$type = 'import'">
         <xsl:value-of select="concat($name,'.xd.html')"/>
       </xsl:when>
       <xsl:when test="$type = 'namespace-alias'">
         <xsl:variable name="element" select="/(xsl:stylesheet | xsl:transform)/xsl:namespace-alias[@stylesheet-prefix = $stylesheet-prefix and @result-prefix = $result-prefix]" />
         <xsl:text>#</xsl:text>
         <xsl:if test="$element">
           <xsl:value-of select="generate-id($element)"/>
         </xsl:if>                  
       </xsl:when>
       <xsl:when test="$type = 'preserve-space'">
         <xsl:variable name="element" select="/(xsl:stylesheet | xsl:transform)/xsl:preserve-space[@elements = $name]" />
         <xsl:text>#</xsl:text>
         <xsl:if test="$element">
           <xsl:value-of select="generate-id($element)"/>
         </xsl:if>                  
       </xsl:when>
       <xsl:when test="$type = 'strip-space'">
         <xsl:variable name="element" select="/(xsl:stylesheet | xsl:transform)/xsl:strip-space[@elements = $name]" />
         <xsl:text>#</xsl:text>
         <xsl:if test="$element">
           <xsl:value-of select="generate-id($element)"/>
         </xsl:if>                  
       </xsl:when>
	   <xsl:when test="$type = 'mode'">
        <xsl:value-of select="if ($name = '#default') then '#modesDetail_defaultMode' else concat('#modesDetail_mode_', $name)"/>
	   </xsl:when>
     </xsl:choose>
   </xsl:template>
   
</xsl:stylesheet>
