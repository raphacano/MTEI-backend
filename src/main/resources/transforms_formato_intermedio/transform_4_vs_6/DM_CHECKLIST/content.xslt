<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
<!--    <xsl:template match="content">
       <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="//dmStatus/referencedApplicGroup"/>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>-->
    
    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="functionalItemRef">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="dmCode/@itemLocationCode">
        <xsl:attribute name="itemLocationCode">
            <xsl:choose>
                <xsl:when test="ancestor::title">A</xsl:when>
                <xsl:when test="ancestor::termTitle">D</xsl:when>
                <xsl:when test="ancestor::definitionTitle">A</xsl:when>
                <xsl:when test="ancestor::listItemTerm">C</xsl:when>
                <xsl:when test="ancestor::checkListInfo/title">B</xsl:when>
                <xsl:otherwise>C</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    
    <xsl:template match="dmTitle">
        <dmTitle>
            <techName><xsl:value-of select="techName"/></techName>
            <infoName><xsl:value-of select="infoName"/></infoName>
            <infoNameVariant><xsl:value-of select="infoName"/></infoNameVariant>
        </dmTitle>
    </xsl:template>
    
    <xsl:template match="productionMaintData">
        <productionMaintData>
            <thresholdInterval thresholdUnitOfMeasure="th12">
                <xsl:value-of select="thresholdInterval"/>
            </thresholdInterval>
            <workAreaLocationGroup>
                <xsl:apply-templates select="zoneRef"/>
                <xsl:apply-templates select="accessPointRef"/>
                <workLocation>
                    <workArea><xsl:value-of select="workArea"/></workArea>
                    <internalRef>
                        <subScript><xsl:value-of select="graphic/hotspot/internalRef/subScript"/></subScript>
                    </internalRef>
                </workLocation>
            </workAreaLocationGroup>
            <xsl:apply-templates select="taskDuration"/>
        </productionMaintData>
    </xsl:template>
    
    <xsl:template match="thresholdInterval/@thresholdUnitOfMeasure">
        <xsl:attribute name="thresholdUnitOfMeasure">th12</xsl:attribute>
    </xsl:template>
    
    <!-- Update personSkill attribute -->
    <xsl:template match="personSkill/@skillLevelCode">
        <xsl:attribute name="skillLevelCode">sk48</xsl:attribute>
    </xsl:template>
    
    <xsl:template match="threshold/@thresholdUnitOfMeasure">
        <xsl:attribute name="thresholdUnitOfMeasure">th20</xsl:attribute>
    </xsl:template>
    
    <xsl:template match="threshold">
        <threshold thresholdUnitOfMeasure="th20">
            <thresholdValue><xsl:value-of select="thresholdValue"/></thresholdValue>
            <tolerance toleranceValue="0.0"/>
        </threshold>
    </xsl:template>
    
    <xsl:template match="zoneRef|accessPointRef">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
            <name><xsl:value-of select="name"/></name>
            <xsl:apply-templates select="refs"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="attentionSequentialList|attentionRandomList|commonInfoDescrPara/warning|commonInfoDescrPara/caution"/>    
</xsl:stylesheet>