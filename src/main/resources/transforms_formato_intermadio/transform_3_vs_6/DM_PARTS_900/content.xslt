<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink">
	

  <xsl:template match="content">
	  <content>
      <illustratedPartsCatalog>
        <xsl:apply-templates select="ipc/figure"/>
        <xsl:apply-templates select="ipc/ipp"/>
        <xsl:apply-templates select="ipc/csn"/>
      </illustratedPartsCatalog>
    </content>
  </xsl:template>
  
      <xsl:template match="figure">
        <figure id="{@id}">
            <title><xsl:value-of select="title"/></title>
            <xsl:apply-templates select="graphic"/>
            
            <xsl:if test="legend/deflist/term">
				<legend>
					<definitionList>
						<xsl:for-each select="legend/deflist/term">
							<definitionListItem>
								<listItemTerm><xsl:value-of select="."/></listItemTerm>
								<listItemDefinition>
									<para><xsl:value-of select="following-sibling::def[1]"/></para>
								</listItemDefinition>
							</definitionListItem>
						</xsl:for-each>
					</definitionList>
				</legend>
            </xsl:if>
         
        </figure>
    </xsl:template>

  <xsl:template match="ipp">
    <initialProvisioningProject
      initialProvisioningProjectNumber="{@ippn}"
      initialProvisioningProjectNumberSubject="{@ips}"
      fileIdent="{@fid}"/>
  </xsl:template>

  <xsl:template match="csn">
    <catalogSeqNumber
      indenture="{@ind}"
      systemCode="D00"
      subSystemCode="0"
      subSubSystemCode="0"
      assyCode="00"
      figureNumber="01"
      figureNumberVariant="A"
      item="{normalize-space(@item)}">
      <xsl:apply-templates select="isn"/>
    </catalogSeqNumber>
  </xsl:template>

  <xsl:template match="isn">
    <itemSeqNumber itemSeqNumberValue="{@isn}">
      <reasonForSelection reasonForSelectionValue="{rfs/@value}"/>
      <quantityPerNextHigherAssy><xsl:value-of select="qna"/></quantityPerNextHigherAssy>
      <partRef manufacturerCodeValue="{mfc}" partNumberValue="{pnr}"/>
      <partSegment>
        <itemIdentData>
          <descrForPart><xsl:value-of select="pas/dfp"/></descrForPart>
        </itemIdentData>
        <xsl:if test="pas/uoi | pas/str | pas/psc">
          <techData>
            <xsl:if test="pas/psc">
              <physicalSecurityPilferageCode><xsl:value-of select="pas/psc"/></physicalSecurityPilferageCode>
            </xsl:if>
            <xsl:if test="pas/uoi">
              <unitOfIssue><xsl:value-of select="pas/uoi"/></unitOfIssue>
            </xsl:if>
            <xsl:if test="pas/str">
              <specialStorage><xsl:value-of select="pas/str"/></specialStorage>
            </xsl:if>

          </techData>
        </xsl:if>
      </partSegment>
      <partLocationSegment/>
      <locationRcmdSegment>
        <locationRcmd>
          <service><xsl:value-of select="ces/srv"/></service>
          <sourceMaintRecoverability><xsl:value-of select="ces/smr"/></sourceMaintRecoverability>
          <modelVersion modelVersionValue="{ces/mov/@mov}"/>
        </locationRcmd>
      </locationRcmdSegment>
      <xsl:if test="n2d">
        <genericPartDataGroup>
          <xsl:for-each select="n2d/n2ddata">
            <genericPartData genericPartDataName="{@n2did}">
              <genericPartDataValue><xsl:value-of select="n2dvalue"/></genericPartDataValue>
            </genericPartData>
          </xsl:for-each>
        </genericPartDataGroup>
      </xsl:if>
    </itemSeqNumber>
  </xsl:template>
  
    <xsl:template match="graphic">
        <graphic infoEntityIdent="{@boardno}">
			<xsl:if test="@id">
				<xsl:attribute name="id">
					<xsl:value-of select="@id"/>
				</xsl:attribute>
			</xsl:if>
            <xsl:apply-templates select="hotspot"/>
        </graphic>
    </xsl:template>
    
    <xsl:template match="hotspot">
        <hotspot id="{@id}"
                 applicationStructureIdent="{@apsid}"
                 applicationStructureName="{@apsname}"
                 hotspotType="{@type}"
                 hotspotTitle="{@title}"
                 objectDescr="{@descript}"/>
    </xsl:template>


</xsl:stylesheet>