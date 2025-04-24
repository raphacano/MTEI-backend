<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink">
	

  <xsl:variable name="firstApplic" select="(//applic)[1]"/>

  <xsl:template match="content">
    <content>
		<xsl:if test="schedule/timelim">
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
		  </xsl:if>
		  
		<xsl:if test="schedule/definspec">
			 <maintPlanning>
				<xsl:apply-templates select="schedule/definspec"/>
			 </maintPlanning>
		</xsl:if>
      
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

			<tolerance>
				<xsl:attribute name="toleranceValue">
					<xsl:choose>
						<xsl:when test="tolerance/@value">
							<xsl:value-of select="tolerance/@value"/>
						</xsl:when>
						<xsl:otherwise>0.0</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</tolerance>
        </threshold>
      </limitType>
    </timeLimit>
  </xsl:template>
  
  
	 <xsl:template match="definspec">
        <inspectionDefinition>
            <xsl:apply-templates select="inspection"/>
            <xsl:apply-templates select="tasklist"/>
            <rqmtSource sourceOfRqmt="{inspection/limit/refinspec/@insptype}">
                <xsl:apply-templates select="inspection/limit/refinspec" mode="rqmtSource"/>
            </rqmtSource>
        </inspectionDefinition>
    </xsl:template>

    <!-- Inspection section -->
    <xsl:template match="inspection">
        <inspection>
            <xsl:apply-templates select="limit"/>
            <xsl:apply-templates select="remarks"/>issueDate
        </inspection>
    </xsl:template>

    <!-- Limit section -->
    <xsl:template match="limit">
        <limit>
            <sampling><xsl:value-of select="sampling"/></sampling>
            <xsl:apply-templates select="threshold"/>
            <inspectionType inspectionTypeCategory="{refinspec/@insptype}"/>
            <xsl:apply-templates select="trigger"/>
            <xsl:apply-templates select="limrange"/>
            <xsl:apply-templates select="remarks"/>
        </limit>
    </xsl:template>

    <!-- Threshold template -->
    <xsl:template match="threshold">
        <threshold thresholdUnitOfMeasure="{@uom}">
            <thresholdValue><xsl:value-of select="value"/></thresholdValue>
            <tolerance toleranceValue="{tolerance/@value}"/>
        </threshold>
    </xsl:template>

    <!-- Trigger section -->
    <xsl:template match="trigger">
        <trigger>
            <refs>
                <xsl:apply-templates select="refs/refdm"/>
            </refs>
            <xsl:apply-templates select="threshold"/>
        </trigger>
    </xsl:template>

    <!-- DM Reference template -->
    <xsl:template match="refdm">
        <dmRef>
            <dmRefIdent>
                <identExtension 
                    extensionProducer="{dmcextension/dmeproducer}" 
                    extensionCode="{dmcextension/dmecode}"/>
                <dmCode 
                    systemDiffCode="{age/supeqvc}" 
                    subSubSystemCode="{age/subsubsyscode}" 
                    infoCodeVariant="{age/incodev}" 
                    subSystemCode="{age/subsyscode}" 
                    itemLocationCode="{
                        if (ancestor::trigger) then 'A'
                        else if (ancestor::taskitem) then 'B'
                        else 'C'
                    }" 
                    disassyCodeVariant="{age/discodev}" 
                    modelIdentCode="{age/modelic}" 
                    assyCode="{age/eidc}" 
                    disassyCode="{age/cidc}" 
                    systemCode="{age/ecscs}" 
                    infoCode="{age/incode}"/>
                <issueInfo 
                    inWork="{age/inwork}" 
                    issueNumber="{issno/@issno}"/>
                <language 
                    countryIsoCode="{language/@country}" 
                    languageIsoCode="{language/@language}"/>
            </dmRefIdent>
            <dmRefAddressItems>
                <dmTitle>
                    <techName><xsl:value-of select="dmtitle/techname"/></techName>
                    <infoName><xsl:value-of select="dmtitle/infoname"/></infoName>
                    <infoNameVariant><xsl:value-of select="dmtitle/infonamevariant"/></infoNameVariant>
                </dmTitle>
                <issueDate>
                    <xsl:attribute name="year">
                        <xsl:value-of select="substring(issuedate,1,4)"/>
                    </xsl:attribute>
                    <xsl:attribute name="month">
                        <xsl:value-of select="substring(issuedate,6,2)"/>
                    </xsl:attribute>
                    <xsl:attribute name="day">
                        <xsl:value-of select="substring(issuedate,9,2)"/>
                    </xsl:attribute>
                </issueDate>
            </dmRefAddressItems>
            <behavior/>
        </dmRef>
    </xsl:template>

    <!-- Limit Range -->
    <xsl:template match="limrange">
        <limitRange>
            <limitRangeFrom>
                <xsl:apply-templates select="from/threshold"/>
            </limitRangeFrom>
            <limitRangeTo>
                <xsl:apply-templates select="to/threshold"/>
            </limitRangeTo>
        </limitRange>
    </xsl:template>

    <!-- Remarks -->
    <xsl:template match="remarks">
        <remarks>
            <simplePara>
                <subScript><xsl:value-of select=".//subscrpt"/></subScript>
            </simplePara>
        </remarks>
    </xsl:template>

    <!-- Task List -->
    <xsl:template match="tasklist">
        <taskGroup>
            <xsl:apply-templates select="taskitem"/>
        </taskGroup>
    </xsl:template>

    <!-- Task Item -->
    <xsl:template match="taskitem">
        <taskItem taskSeqNumber="{@seqnum}" taskName="{@taskname}">
            <refs>
                <xsl:apply-templates select="refs/refdm"/>
            </refs>
            <task>
                <taskTitle><xsl:value-of select="task"/></taskTitle>
                <taskDescr>
                    <simplePara>
                        <subScript><xsl:value-of select="applic/displaytext/p/subscrpt"/></subScript>
                    </simplePara>
                </taskDescr>
                <taskMarker markerType="{@taskname}"/>
            </task>
        </taskItem>
    </xsl:template>

    <!-- RqmtSource template -->
    <xsl:template match="refinspec" mode="rqmtSource">
        <dmRef>
            <dmRefIdent>
                <identExtension 
                    extensionProducer="{ancestor::limit/refdm/dmcextension/dmeproducer}" 
                    extensionCode="{ancestor::limit/refdm/dmcextension/dmecode}"/>
                <dmCode 
                    systemDiffCode="{ancestor::limit/refdm/age/supeqvc}" 
                    subSubSystemCode="{ancestor::limit/refdm/age/subsubsyscode}" 
                    infoCodeVariant="{ancestor::limit/refdm/age/incodev}" 
                    subSystemCode="{ancestor::limit/refdm/age/subsyscode}" 
                    itemLocationCode="C" 
                    disassyCodeVariant="{ancestor::limit/refdm/age/discodev}" 
                    modelIdentCode="{ancestor::limit/refdm/age/modelic}" 
                    assyCode="{ancestor::limit/refdm/age/eidc}" 
                    disassyCode="{ancestor::limit/refdm/age/cidc}" 
                    systemCode="{ancestor::limit/refdm/age/ecscs}" 
                    infoCode="{ancestor::limit/refdm/age/incode}"/>
                <issueInfo 
                    inWork="{ancestor::limit/refdm/age/inwork}" 
                    issueNumber="{ancestor::limit/refdm/issno/@issno}"/>
                <language 
                    countryIsoCode="{ancestor::limit/refdm/language/@country}" 
                    languageIsoCode="{ancestor::limit/refdm/language/@language}"/>
            </dmRefIdent>
            <dmRefAddressItems>
                <dmTitle>
                    <techName><xsl:value-of select="ancestor::limit/refdm/dmtitle/techname"/></techName>
                    <infoName><xsl:value-of select="ancestor::limit/refdm/dmtitle/infoname"/></infoName>
                    <infoNameVariant><xsl:value-of select="ancestor::limit/refdm/dmtitle/infonamevariant"/></infoNameVariant>
                </dmTitle>
                <issueDate>
                    <xsl:attribute name="year">
                        <xsl:value-of select="substring(ancestor::limit/refdm/issuedate,1,4)"/>
                    </xsl:attribute>
                    <xsl:attribute name="month">
                        <xsl:value-of select="substring(ancestor::limit/refdm/issuedate,6,2)"/>
                    </xsl:attribute>
                    <xsl:attribute name="day">
                        <xsl:value-of select="substring(ancestor::limit/refdm/issuedate,9,2)"/>
                    </xsl:attribute>
                </issueDate>
            </dmRefAddressItems>
            <behavior/>
        </dmRef>
        <sourceType/>
    </xsl:template>

      
</xsl:stylesheet>