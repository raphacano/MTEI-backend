<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:template match="content">
        <content>
         <xsl:apply-templates select="act"/>
        </content>
    </xsl:template>
    
  
   <xsl:template match="act">
        <applicCrossRefTable>

            <xsl:apply-templates select="productattributes"/>


            <xsl:apply-templates select="cctref"/>


            <xsl:apply-templates select="pctref"/>
        </applicCrossRefTable>
    </xsl:template>


    <xsl:template match="productattributes">
        <productAttributeList>

            <xsl:apply-templates select="prodattr"/>
        </productAttributeList>
    </xsl:template>


    <xsl:template match="prodattr">
        <productAttribute>

            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="@id = 'serialno'">SerialNo</xsl:when>
                    <xsl:otherwise><xsl:value-of select="@id"/></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>


            <xsl:if test="position() = 1">
                <xsl:attribute name="productIdentifier">primary</xsl:attribute>
            </xsl:if>


            <xsl:if test="@pattern">
                <xsl:attribute name="valuePattern"><xsl:value-of select="@pattern"/></xsl:attribute>
            </xsl:if>

     
            <xsl:if test="@id = 'versrank'">
                 <xsl:attribute name="valueDataType">integer</xsl:attribute>
             </xsl:if>


            <name><xsl:value-of select="name"/></name>
            <displayName><xsl:value-of select="displayname"/></displayName>
            <descr><xsl:value-of select="description"/></descr>


            <xsl:apply-templates select="enum"/>


        </productAttribute>
    </xsl:template>


    <xsl:template match="enum">
        <enumeration>

            <xsl:if test="@actvalues">
                <xsl:attribute name="applicPropertyValues"><xsl:value-of select="@actvalues"/></xsl:attribute>
            </xsl:if>
        </enumeration>
    </xsl:template>


    <xsl:template match="cctref">
        <condCrossRefTableRef>

            <xsl:apply-templates select="refdm"/>
        </condCrossRefTableRef>
    </xsl:template>

  
    <xsl:template match="pctref">
        <productCrossRefTableRef>

            <xsl:apply-templates select="refdm"/>
        </productCrossRefTableRef>
    </xsl:template>


    <xsl:template match="refdm">
        <dmRef>

            <xsl:apply-templates select="avee"/>
        </dmRef>
    </xsl:template>


    <xsl:template match="avee">
        <dmRefIdent>
            <dmCode>
      
                <xsl:attribute name="modelIdentCode"><xsl:value-of select="modelic"/></xsl:attribute>
                <xsl:attribute name="systemDiffCode"><xsl:value-of select="sdc"/></xsl:attribute>
                <xsl:attribute name="systemCode"><xsl:value-of select="chapnum"/></xsl:attribute>
                <xsl:attribute name="subSystemCode"><xsl:value-of select="section"/></xsl:attribute>
                <xsl:attribute name="subSubSystemCode"><xsl:value-of select="subsect"/></xsl:attribute>
                <xsl:attribute name="assyCode"><xsl:value-of select="subject"/></xsl:attribute>
                <xsl:attribute name="disassyCode"><xsl:value-of select="discode"/></xsl:attribute>
                <xsl:attribute name="disassyCodeVariant"><xsl:value-of select="discodev"/></xsl:attribute>
                <xsl:attribute name="infoCode"><xsl:value-of select="incode"/></xsl:attribute>
                <xsl:attribute name="infoCodeVariant"><xsl:value-of select="incodev"/></xsl:attribute>
                <xsl:attribute name="itemLocationCode"><xsl:value-of select="itemloc"/></xsl:attribute>
            </dmCode>
        </dmRefIdent>
    </xsl:template>

</xsl:stylesheet>