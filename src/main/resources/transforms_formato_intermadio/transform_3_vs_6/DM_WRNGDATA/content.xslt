<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink">


  <xsl:template match="applic">
    <applicRef applicIdentValue="" id="{@id}"/>
  </xsl:template>

  <xsl:template match="content">
    <content>

      <referencedApplicGroupRef>
        <xsl:apply-templates select="../idstatus/status/inlineapplics/applic"/>
      </referencedApplicGroupRef>

      <xsl:apply-templates select="wrngdata"/>
    </content>
  </xsl:template>


  <xsl:template match="wrngdata">
    <wiringData>
      <electricalEquipGroup>
        <xsl:apply-templates select="elecequips/elecequip"/>
      </electricalEquipGroup>
    </wiringData>
  </xsl:template>

  <xsl:template match="elecequip">
    <electricalEquip applicRefId="{@refapplic}">
      <functionalItemRef functionalItemNumber="{rfd}">
        <xsl:if test="rfd/@contextid">
          <xsl:attribute name="contextIdent">
            <xsl:value-of select="rfd/@contextid"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="rfd/@mfc">
          <xsl:attribute name="manufacturerCodeValue">
            <xsl:value-of select="rfd/@mfc"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="rfd/@originator">
          <xsl:attribute name="itemOriginator">
            <xsl:value-of select="rfd/@originator"/>
          </xsl:attribute>
        </xsl:if>
      </functionalItemRef>
      <partNumber><xsl:value-of select="pnr"/></partNumber>
      <xsl:if test="maxposition"><maxMountingPositions><xsl:value-of select="maxposition"/></maxMountingPositions></xsl:if>
      <xsl:apply-templates select="trl"/>
      <connectionListClass><xsl:value-of select="clc"/></connectionListClass>
      <responsiblePartnerCompany enterpriseCode="{rpc}">
        <enterpriseName><xsl:value-of select="rpc/@rpcname"/></enterpriseName>
      </responsiblePartnerCompany>
      <xsl:if test="qty"><reqQuantity><xsl:value-of select="qty"/></reqQuantity></xsl:if>
      <xsl:apply-templates select="instinfo"/>
    </electricalEquip>
  </xsl:template>

  <xsl:template match="sibplugid">
    <siblingPlugIdent>
      <functionalItemRef>
        <xsl:attribute name="functionalItemNumber">
          <xsl:value-of select="rfd"/>
        </xsl:attribute>
        <xsl:if test="rfd/@contextid">
          <xsl:attribute name="contextIdent">
            <xsl:value-of select="rfd/@contextid"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="rfd/@mfc">
          <xsl:attribute name="manufacturerCodeValue">
            <xsl:value-of select="rfd/@mfc"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="rfd/@originator">
          <xsl:attribute name="itemOriginator">
            <xsl:value-of select="rfd/@originator"/>
          </xsl:attribute>
        </xsl:if>
      </functionalItemRef>
    </siblingPlugIdent>
  </xsl:template>

  <xsl:template match="instinfo">
    <installationInfo>
      <xsl:if test="@instid">
        <xsl:attribute name="installationIdent">
          <xsl:value-of select="@instid"/>
        </xsl:attribute>
      </xsl:if>
      <installationLocation><xsl:value-of select="instloc"/></installationLocation>
      <xsl:apply-templates select="sibplugid|nhassy|posnhassy"/>
    </installationInfo>
  </xsl:template>

  <xsl:template match="nhassy">
    <nextHigherAssy>
      <functionalItemRef functionalItemNumber="{rfd}"/>
    </nextHigherAssy>
  </xsl:template>

  <xsl:template match="posnhassy">
    <positionOnNextHigherAssy mountPosition="{@pos}"/>
  </xsl:template>

  <xsl:template match="trl">
    <transverseLink>
      <xsl:apply-templates select="eeconnection"/>
    </transverseLink>
  </xsl:template>

  <xsl:template match="eeconnection">
    <electricalEquipConnection>
      <xsl:apply-templates select="contact"/>
    </electricalEquipConnection>
  </xsl:template>

  <xsl:template match="contact">
    <contact contactIdent="{@ident}"/>
  </xsl:template>
  
</xsl:stylesheet>