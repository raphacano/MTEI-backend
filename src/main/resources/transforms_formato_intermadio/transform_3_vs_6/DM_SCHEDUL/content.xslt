<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink">
	

  <xsl:variable name="firstApplic" select="(//applic)[1]"/>

  <xsl:template match="content">
    <content>

      <referencedApplicGroup>
        <applic id="MK1MK9">
          <displayText>
            <simplePara>
              <xsl:value-of select="$firstApplic/displaytext"/>
            </simplePara>
          </displayText>

          <xsl:apply-templates select="$firstApplic/evaluate"/>
        </applic>
      </referencedApplicGroup>

      <maintPlanning>
        <xsl:apply-templates select="schedule/timelim"/>
      </maintPlanning>
    </content>
  </xsl:template>


  <xsl:template match="evaluate">
    <evaluate andOr="{@operator}">
      <xsl:apply-templates select="*"/>
    </evaluate>
  </xsl:template>


  <xsl:template match="assert">
    <assert applicPropertyIdent="{@actidref}"
            applicPropertyType="{@actreftype}"
            applicPropertyValues="{@actvalues}"/>
  </xsl:template>


  <xsl:template match="timelim">
    <timeLimitInfo timeLimitIdent="{@identifier}" applicRefId="MK1MK9">
      <equipGroup>
        <equip>
          <name><xsl:value-of select="equip/nomen"/></name>
          <identNumber>
            <manufacturerCode><xsl:value-of select="equip/identno/mfc"/></manufacturerCode>
            <partAndSerialNumber>
              <partNumber><xsl:value-of select="equip/identno/pnr"/></partNumber>
            </partAndSerialNumber>
          </identNumber>
        </equip>
      </equipGroup>
      <xsl:if test="qty">
        <reqQuantity unitOfMeasure="{qty/@uom}">
          <xsl:value-of select="qty"/>
        </reqQuantity>
      </xsl:if>

      <xsl:if test="cat and count(timelimit) = 1">
        <timeLimitCategory timeLimitCategoryValue="1"/>
      </xsl:if>
      <xsl:apply-templates select="timelimit"/>
    </timeLimitInfo>
  </xsl:template>


  <xsl:template match="timelimit">
    <timeLimit>
      <limitType limitUnitType="{limittype/@type}">
        <threshold thresholdUnitOfMeasure="{limittype/threshold/@uom}">
          <thresholdValue><xsl:value-of select="limittype/threshold/value"/></thresholdValue>

          <xsl:if test="limittype/threshold/tolerance">
            <tolerance toleranceType="plusorminus" toleranceValue="{limittype/threshold/tolerance/@minus}"/>
          </xsl:if>
        </threshold>
      </limitType>
    </timeLimit>
  </xsl:template>
  
  
</xsl:stylesheet>