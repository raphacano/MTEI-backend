<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:template match="content">
        <content>
        
            <xsl:if test="//inlineapplics/applic">
				<referencedApplicGroup>
					<xsl:for-each select="//inlineapplics/applic">
						<applic id="{@id}">
							<displayText><simplePara><xsl:value-of select="displaytext"/></simplePara></displayText>
							<xsl:apply-templates select="evaluate"/>
						</applic>
					</xsl:for-each>
				</referencedApplicGroup>
            </xsl:if>
            
            <xsl:apply-templates select="refs"/>
<!--            <xsl:apply-templates select="proced"/>-->
            
            <xsl:if test="acrw/frc/*">
				<crew>
					<crewRefCard>
						<xsl:apply-templates select="acrw/frc/*"/>
					</crewRefCard>
				</crew>
            </xsl:if>
            
			<xsl:if test="acrw/descacrw">
				<crew>
					<descrCrew>
						<xsl:apply-templates select="acrw/descacrw/*"/>
					</descrCrew>
				</crew>
		  </xsl:if>
		  
        </content>
    </xsl:template>
    
  
    <xsl:template match="refs">
        <refs>
            <dmRef>
                <dmRefIdent>
                    <dmCode modelIdentCode="{refdm/avee/modelic}"
                            systemDiffCode="{refdm/avee/sdc}"
                            systemCode="{refdm/avee/chapnum}"
                            subSystemCode="{refdm/avee/section}"
                            subSubSystemCode="{refdm/avee/subsect}"
                            assyCode="{refdm/avee/subject}"
                            disassyCode="{refdm/avee/discode}"
                            disassyCodeVariant="{refdm/avee/discodev}"
                            infoCode="{refdm/avee/incode}"
                            infoCodeVariant="{refdm/avee/incodev}"
                            itemLocationCode="{refdm/avee/itemloc}"/>
                </dmRefIdent>
            </dmRef>
        </refs>
    </xsl:template>
    
    <xsl:template match="refdm">
        <dmRef>
            <dmRefIdent>
                <dmCode modelIdentCode="{avee/modelic}"
                    systemDiffCode="{avee/sdc}"
                    systemCode="{avee/chapnum}"
                    subSystemCode="{avee/section}"
                    subSubSystemCode="{avee/subsect}"
                    assyCode="{avee/subject}"
                    disassyCode="{avee/discode}"
                    disassyCodeVariant="{avee/discodev}"
                    infoCode="{avee/incode}"
                    infoCodeVariant="{avee/incodev}"
                    itemLocationCode="{avee/itemloc}"/>
            </dmRefIdent>
        </dmRef>
    </xsl:template>

    <xsl:template match="proced">
        <procedure>
            <preliminaryRqmts>
                <reqCondGroup><noConds/></reqCondGroup>
                <reqPersons>
                    <person man="{prelreqs/reqpers/person/@man}">
                        <personCategory personCategoryCode="{prelreqs/reqpers/perscat/@category}"/>
                        <trade><xsl:value-of select="prelreqs/reqpers/trade"/></trade>
                        <estimatedTime unitOfMeasure="h"><xsl:value-of select="prelreqs/reqpers/esttime"/></estimatedTime>
                    </person>
                </reqPersons>
                <xsl:apply-templates select="prelreqs/supequip"/>
                <xsl:apply-templates select="prelreqs/supplies"/>
                <reqSpares><noSpares/></reqSpares>
                <reqSafety><noSafety/></reqSafety>
            </preliminaryRqmts>
            <mainProcedure>
                <xsl:apply-templates select="mainfunc/step1"/>
            </mainProcedure>
            <closeRqmts>
                <reqCondGroup><noConds/></reqCondGroup>
            </closeRqmts>
        </procedure>
    </xsl:template>


    <xsl:template match="supequip">
        <reqSupportEquips>
            <supportEquipDescrGroup>
                <xsl:apply-templates select="supeqli/supequi"/>
            </supportEquipDescrGroup>
        </reqSupportEquips>
    </xsl:template>

    <xsl:template match="supequi">
        <supportEquipDescr id="{@id}">
            <name><xsl:value-of select="nomen"/></name>
            <identNumber>
            
                <xsl:if test="nsn/@nsn">
                     <xsl:attribute name="nsn">
                        <xsl:value-of select="nsn/@nsn"/>
                    </xsl:attribute>
                </xsl:if>
                
                <manufacturerCode><xsl:value-of select="identno/mfc"/></manufacturerCode>
                <partAndSerialNumber>
                    <partNumber><xsl:value-of select="identno/pnr"/></partNumber>
                </partAndSerialNumber>
            </identNumber>
            <reqQuantity unitOfMeasure="{qty/@uom}"><xsl:value-of select="qty"/></reqQuantity>
        </supportEquipDescr>
    </xsl:template>

    <xsl:template match="supplies">
        <reqSupplies>
            <supplyDescrGroup>
                <xsl:apply-templates select="supplyli/supply"/>
            </supplyDescrGroup>
        </reqSupplies>
    </xsl:template>

    <xsl:template match="supply">
        <supplyDescr id="{@id}">
            <name><xsl:value-of select="nomen"/></name>
            <identNumber>
                <manufacturerCode><xsl:value-of select="identno/mfc"/></manufacturerCode>
                <partAndSerialNumber>
                    <partNumber><xsl:value-of select="identno/pnr"/></partNumber>
                </partAndSerialNumber>
            </identNumber>
            <reqQuantity><xsl:value-of select="qty"/></reqQuantity>
        </supplyDescr>
    </xsl:template>


    <xsl:template match="step1">
        <proceduralStep>
            <xsl:apply-templates select="para|step2"/>
        </proceduralStep>
    </xsl:template>

    <xsl:template match="step2">
        <proceduralStep>
            <xsl:apply-templates select="node()"/>
        </proceduralStep>
    </xsl:template>

    <xsl:template match="step3 | step4">
        <proceduralStep>
            <para><xsl:value-of select="para"/></para>
            <xsl:apply-templates select="*[not(self::para)]"/>
        </proceduralStep>
    </xsl:template>

    <xsl:template match="para0|subpara1">
        <levelledPara>
            <xsl:if test="@id">
                <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </levelledPara>
    </xsl:template>

    
 	<xsl:template match="xref">
	  <internalRef internalRefId="{@xrefid}">
		<xsl:attribute name="internalRefTargetType">
		  <xsl:choose>
			<xsl:when test="@xidtype = 'figure'">irtt01</xsl:when>
			<xsl:when test="@xidtype = 'table'">irtt02</xsl:when>
			<xsl:when test="@xidtype = 'multimedia'">irtt03</xsl:when>
			<xsl:when test="@xidtype = 'supply'">irtt04</xsl:when>
			<xsl:when test="@xidtype = 'supequip'">irtt05</xsl:when>
			<xsl:when test="@xidtype = 'spare'">irtt06</xsl:when>
			<xsl:when test="@xidtype = 'para'">irtt07</xsl:when>
			<xsl:when test="@xidtype = 'step'">irtt08</xsl:when>
			<xsl:when test="@xidtype = 'graphic'">irtt09</xsl:when>
			<xsl:when test="@xidtype = 'multimediaobject'">irtt10</xsl:when>
			<xsl:when test="@xidtype = 'hotspot'">irtt11</xsl:when>
			<xsl:when test="@xidtype = 'param'">irtt12</xsl:when>
			<xsl:when test="@xidtype = 'zone'">irtt13</xsl:when>
			<xsl:when test="@xidtype = 'worklocation'">irtt14</xsl:when>
			<xsl:when test="@xidtype = 'servicebulletinmaterialset'">irtt15</xsl:when>
			<xsl:when test="@xidtype = 'accesspoint'">irtt16</xsl:when>
		  </xsl:choose>
		</xsl:attribute>
		<!-- Añadir atributo 'titulo' solo para xidtype='hotspot' -->
		<xsl:if test="@xidtype = 'hotspot'">
		  <xsl:attribute name="titulo">
			<xsl:variable name="figPart" select="substring-after(@xrefid, 'fig-')"/>
			<xsl:variable name="figNumber" select="number(substring-before($figPart, '-'))"/>
			<xsl:variable name="hotNumber" select="number(substring-after(@xrefid, 'hot-'))"/>
			<xsl:value-of select="concat($figNumber, '/', $hotNumber)"/>
		  </xsl:attribute>
		</xsl:if>
	  </internalRef>
	</xsl:template>


    <xsl:template match="multimedia">
        <multimedia>
            <title><xsl:value-of select="title"/></title>
            <multimediaObject autoPlay="{multimediaobject/@autoplay}"
                              fullScreen="{multimediaobject/@fullscrn}"
                              infoEntityIdent="{multimediaobject/@boardno}"
                              multimediaType="other"/>
        </multimedia>
    </xsl:template>

    <xsl:template match="figure">
        <figure id="{@id}">
            <title><xsl:value-of select="title"/></title>
            <graphic infoEntityIdent="{graphic/@xlink:href}"/>
        </figure>
    </xsl:template>

    <xsl:template match="caution">
        <caution>
            <warningAndCautionPara><xsl:apply-templates select="para/node()"/></warningAndCautionPara>
        </caution>
    </xsl:template>

    <xsl:template match="randlist">
        <randomList listItemPrefix="{@prefix}">
            <xsl:for-each select="item">
                <listItem>
              <!--      <para><xsl:value-of select="."/></para>-->
              <para><xsl:apply-templates/></para>
                </listItem>
            </xsl:for-each>
        </randomList>
    </xsl:template>

    <xsl:template match="noconds|nosafety|nospares">
        <xsl:element name="no{translate(local-name(),'s','S')}"/>
    </xsl:template>

    <xsl:template match="drill">
        <crewDrill>
            <xsl:apply-templates select="title|subdrill|step|if|elseif|warning"/>
        </crewDrill>
    </xsl:template>

    <xsl:template match="subdrill">
        <subCrewDrill>
            <xsl:apply-templates select="*"/>
        </subCrewDrill>
    </xsl:template>

    <xsl:template match="step">
        <crewDrillStep>
            <xsl:apply-templates select="*"/>
        </crewDrillStep>
    </xsl:template>

    <xsl:template match="challrsp">
        <challengeAndResponse>
            <challenge><para><xsl:value-of select="challeng/para"/></para></challenge>
            <response><xsl:apply-templates select="response/*"/></response>
        </challengeAndResponse>
    </xsl:template>

    <xsl:template match="if">
        <if>
            <caseCond><xsl:value-of select="condit"/></caseCond>
            <xsl:apply-templates select="*[not(self::condit)]"/>
        </if>
    </xsl:template>

    <xsl:template match="elseif">
        <elseIf>
            <caseCond><xsl:value-of select="condit"/></caseCond>
            <xsl:apply-templates select="*[not(self::condit)]"/>
        </elseIf>
    </xsl:template>

    
    <xsl:template match="table">
        <table>
            <xsl:apply-templates select="@*|node()"/>
        </table>
    </xsl:template>


    <xsl:template match="colspec/@colwidth">
        <xsl:attribute name="colwidth">
            <xsl:choose>
                <xsl:when test=". = '*'">1*</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="capgrp">
        <captionGroup cols="{@cols}" applicRefId="{@refapplic}">
            <xsl:apply-templates select="*"/>
        </captionGroup>
    </xsl:template>

    <xsl:template match="capbody">
        <captionBody>
            <xsl:apply-templates select="*"/>
        </captionBody>
    </xsl:template>

    <xsl:template match="caprow">
        <captionRow>
            <xsl:apply-templates select="*"/>
        </captionRow>
    </xsl:template>

	<xsl:template match="entry">
		<xsl:copy copy-namespaces="no">
		  <para>
			<xsl:apply-templates select="node()"/>
		  </para>
		</xsl:copy>
	</xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
	<xsl:template match="warning">
		<warning>
		  <xsl:apply-templates select="symbol"/>
		  <warningAndCautionPara>
			<xsl:value-of select="para"/>
		  </warningAndCautionPara>
		</warning>
	</xsl:template>
	
	<xsl:template match="caption">
		<caption>
		  <xsl:apply-templates select="@colour|@width"/>
		  <xsl:apply-templates select="node()"/>
		</caption>
    </xsl:template>
	
  <xsl:template match="@colour">
    <xsl:attribute name="color">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@width">
    <xsl:attribute name="captionWidth">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="capline">
    <captionLine>
      <xsl:apply-templates select="@*|node()"/>
    </captionLine>
  </xsl:template>
	
	<xsl:template match="procd">
		<crewProcedureName>
		  <xsl:apply-templates select="@*|node()"/>
		</crewProcedureName>
  </xsl:template>
  
  	<xsl:template match="capentry">
		<captionEntry>
		  <xsl:apply-templates select="@*|node()"/>
		</captionEntry>
  </xsl:template>

    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>

</xsl:stylesheet>