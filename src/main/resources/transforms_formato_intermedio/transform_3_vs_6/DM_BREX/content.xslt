<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:template match="content">
        <content>
         <xsl:apply-templates select="brex"/>
        </content>
    </xsl:template>
    
  
   <xsl:template match="brex">
    <brex defaultBrSeverityLevel="brsl01">
      <xsl:apply-templates select="contextrules/structrules"/>
    </brex>
  </xsl:template>


  <xsl:template match="structrules">

    <contextRules>
      <structureObjectRuleGroup>

        <xsl:apply-templates select="objrule"/>
      </structureObjectRuleGroup>

    </contextRules>
  </xsl:template>

  <xsl:template match="objrule">

    <structureObjectRule>



      <objectPath>
        <xsl:attribute name="allowedObjectFlag">
          <xsl:choose>

            <xsl:when test="@objappl = '0'">0</xsl:when>

            <xsl:when test="@objappl = '1'">2</xsl:when>

            <xsl:otherwise>2</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>

        <xsl:value-of select="@objpath"/>
      </objectPath>


      <objectUse>
        <xsl:value-of select="objuse"/>
      </objectUse>


      <xsl:apply-templates select="objval"/>
    </structureObjectRule>
  </xsl:template>


  <xsl:template match="objval">

    <objectValue>

      <xsl:attribute name="valueForm">
        <xsl:value-of select="@valtype"/>
      </xsl:attribute>

    
      <xsl:attribute name="valueAllowed">
        <xsl:choose>

          <xsl:when test="@valtype = 'single'">
            <xsl:value-of select="@val1"/>
          </xsl:when>

          <xsl:when test="@valtype = 'range'">
            <xsl:value-of select="concat(@val1, '~', @val2)"/>
          </xsl:when>

        </xsl:choose>
      </xsl:attribute>


      <xsl:value-of select="text()"/>
    </objectValue>
  </xsl:template>


</xsl:stylesheet>