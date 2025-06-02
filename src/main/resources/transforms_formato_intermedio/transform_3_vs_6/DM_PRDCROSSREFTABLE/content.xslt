<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
     exclude-result-prefixes="xlink">
    
    <xsl:template match="content">
        <content>
         <xsl:apply-templates select="pct"/>
        </content>
    </xsl:template>
    
  
  <xsl:template match="pct">
    <productCrossRefTable>
      <xsl:apply-templates select="node()"/>
    </productCrossRefTable>
  </xsl:template>


  <xsl:template match="assign">
   <product>
    <xsl:copy copy-namespaces="no">
  
      <xsl:attribute name="applicPropertyIdent">
        <xsl:choose>
 
          <xsl:when test="@actidref = 'serialno'">SerialNo</xsl:when>
     
          <xsl:otherwise>
            <xsl:value-of select="@actidref"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
  
      <xsl:attribute name="applicPropertyType">
        <xsl:value-of select="@actreftype"/>
      </xsl:attribute>
  
      <xsl:attribute name="applicPropertyValue">
        <xsl:value-of select="@actvalue"/>
      </xsl:attribute>
  
    </xsl:copy>
    </product>
  </xsl:template>

</xsl:stylesheet>