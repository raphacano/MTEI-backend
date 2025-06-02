<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink">
	

  <xsl:template match="@*|node()">
    <xsl:copy >
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

   <xsl:template match="graphic">
        <graphic infoEntityIdent="{@infoEntityIdent}"/>
    </xsl:template>
    
    <xsl:template match="catalogSeqNumber">
        <catalogSeqNumber>
            <xsl:variable name="cleanVal" select="normalize-space(@catalogSeqNumberValue)"/>
            <xsl:attribute name="indenture">
                <xsl:value-of select="@indenture"/>
            </xsl:attribute>
            <xsl:attribute name="systemCode">
                <xsl:value-of select="substring($cleanVal, 1, 3)"/>
            </xsl:attribute>
            <xsl:attribute name="subSystemCode">
                <xsl:value-of select="substring($cleanVal, 4, 1)"/>
            </xsl:attribute>
            <xsl:attribute name="subSubSystemCode">
                <xsl:value-of select="substring($cleanVal, 5, 1)"/>
            </xsl:attribute>
            <xsl:attribute name="assyCode">
                <xsl:value-of select="substring($cleanVal, 6, 2)"/>
            </xsl:attribute>
            <xsl:attribute name="figureNumber">01</xsl:attribute>

            <xsl:attribute name="figureNumberVariant">
                <xsl:value-of select="substring($cleanVal, 10, 1)"/>
            </xsl:attribute>
            
            <xsl:attribute name="item">
                <xsl:value-of select="substring($cleanVal, 11, 3)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </catalogSeqNumber>
    </xsl:template>

    <xsl:template match="itemSequenceNumber">
        <itemSeqNumber>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="reasonForSelection | quantityPerNextHigherAssy"/>
            <partRef manufacturerCodeValue="{manufacturerCode}" partNumberValue="{partNumber}"/>
            <xsl:apply-templates select="partIdentSegment"/>
            <xsl:apply-templates select="* except (
                reasonForSelection | 
                quantityPerNextHigherAssy | 
                manufacturerCode | 
                partNumber | 
                partIdentSegment
            )"/>
        </itemSeqNumber>
    </xsl:template>

    <xsl:template match="manufacturerCode | partNumber"/>


    <xsl:template match="partIdentSegment">
        <partSegment>
            <itemIdentData>
                <xsl:apply-templates select="descrForPart"/>
            </itemIdentData>
        </partSegment>
    </xsl:template>


    <xsl:template match="unitOfIssue | specialStorage"/>


</xsl:stylesheet>