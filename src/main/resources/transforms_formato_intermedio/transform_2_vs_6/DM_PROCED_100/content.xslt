<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">

	
	<xsl:template match="content">
		<content>
		    <xsl:apply-templates select="refs"/>
			<procedure>
				<xsl:apply-templates select="proced/prelreqs"/>
				<xsl:apply-templates select="proced/mainfunc"/>
				<xsl:apply-templates select="proced/closereqs"/>
			</procedure>
		</content>
	</xsl:template>
	
	<xsl:template match="prelreqs">
		<preliminaryRqmts>
			<productionMaintData>
				<taskDuration unitOfMeasure="HOUR" startupDuration="{pmd/opndurn/@prelreqs}" procedureDuration="{pmd/opndurn/@proced}" closeupDuration="{pmd/opndurn/@closeup}"/>
			</productionMaintData>
			<reqCondGroup>
				<xsl:choose>
					<xsl:when test=" reqconds ">
						<xsl:apply-templates select="reqconds"/>
					</xsl:when>
					<xsl:otherwise>
						<noConds/>
					</xsl:otherwise>
				</xsl:choose>
			</reqCondGroup>
			<xsl:apply-templates select="reqpers"/>
			<xsl:apply-templates select="supequip"/>
			<xsl:apply-templates select="supplies"/>
			<xsl:apply-templates select="spares"/>
			<xsl:apply-templates select="safety"/>
		</preliminaryRqmts>
	</xsl:template>
	
	<xsl:template match="refs">
        <refs>
            <xsl:apply-templates select="refdm"/>
        </refs>
    </xsl:template>
	
	<xsl:template match="refdm">
		<dmRef>
			<dmRefIdent>
	
				<xsl:if test="dmcextension">
					<identExtension extensionProducer="{dmcextension/dmeproducer}" extensionCode="{dmcextension/dmecode}"/>
				</xsl:if>
				<dmCode modelIdentCode="{avee/modelic}" systemDiffCode="{avee/sdc}" systemCode="{avee/chapnum}" subSystemCode="{avee/section}" subSubSystemCode="{avee/subsect}" assyCode="{avee/subject}" disassyCode="{avee/discode}" disassyCodeVariant="{avee/discodev}" infoCode="{avee/incode}" infoCodeVariant="{avee/incodev}" itemLocationCode="{avee/itemloc}"/>
				<xsl:if test="issno/@issno">
					<issueInfo issueNumber="{issno/@issno}" inWork=""/>
				</xsl:if>
				<xsl:if test="@language">
					<language languageIsoCode="{@language}" countryIsoCode=""/>
				</xsl:if>
			</dmRefIdent>
			<dmRefAddressItems>
				<dmTitle>
					<techName>
						<xsl:value-of select="dmtitle/techname"/>
					</techName>
					<infoName>
						<xsl:value-of select="dmtitle/infoname"/>
					</infoName>
				</dmTitle>
				<xsl:if test="issdate/@year or issdate/@month or issdate/@day">
					<issueDate>
						<xsl:if test="issdate/@year">
							<xsl:attribute name="year"><xsl:value-of select="issdate/@year"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="issdate/@month">
							<xsl:attribute name="month"><xsl:value-of select="issdate/@month"/></xsl:attribute>
						</xsl:if>
						<xsl:if test="issdate/@day">
							<xsl:attribute name="day"><xsl:value-of select="issdate/@day"/></xsl:attribute>
						</xsl:if>
					</issueDate>
				</xsl:if>
			</dmRefAddressItems>
		</dmRef>
	</xsl:template>	

	<xsl:template match="reqconds">
		<xsl:choose>
			<xsl:when test="noconds">
				<noConds/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	<xsl:template match="reqcond">
		<reqCondNoRef>
			<reqCond>
				<xsl:value-of select="normalize-space()"/>
			</reqCond>
		</reqCondNoRef>
	</xsl:template>
	
	
  <xsl:template match="reqpers">
    <reqPersons>
      <person man="{person/@man}">
        <xsl:apply-templates select="perscat"/>
        <xsl:apply-templates select="perskill"/>
        <xsl:apply-templates select="trade"/>
        <xsl:apply-templates select="esttime"/>
      </person>
    </reqPersons>
  </xsl:template>

  <xsl:template match="perscat">
    <personCategory personCategoryCode="{@category}"/>
  </xsl:template>

  <xsl:template match="perskill">
    <personSkill skillLevelCode="{@skill}"/>
  </xsl:template>

  <xsl:template match="trade">
    <trade><xsl:value-of select="."/></trade>
  </xsl:template>

  <xsl:template match="esttime">
    <estimatedTime unitOfMeasure="h">
      <xsl:value-of select="translate(., ',', '.')"/>
    </estimatedTime>
  </xsl:template>
	
	<xsl:template match="supplies">
    	<reqSupplies>
			<xsl:choose>
			  <xsl:when test="supplyli">
					<xsl:apply-templates select="supplyli"/>
				</xsl:when>
				<xsl:otherwise>
					<noSupplies/>
				</xsl:otherwise>
			</xsl:choose>
		</reqSupplies>
	</xsl:template>
	
	<xsl:template match="supplyli">
		<supplyDescrGroup>
			<xsl:apply-templates select="supply"/>
		</supplyDescrGroup>
	</xsl:template>
	
	<xsl:template match="supply">
		<supplyDescr id="{@id}">
			<xsl:apply-templates select="nomen | identno | qty"/>
		</supplyDescr>
	</xsl:template>
	
	<xsl:template match="nomen">
		<name>
			<xsl:apply-templates/>
		</name>
	</xsl:template>
	<xsl:template match="identno">
		<identNumber>
			<xsl:apply-templates select="mfc | pnr"/>
		</identNumber>
	</xsl:template>
	<xsl:template match="mfc">
		<manufacturerCode>
			<xsl:value-of select="."/>
		</manufacturerCode>
	</xsl:template>
	<xsl:template match="pnr">
		<partAndSerialNumber>
			<partNumber>
				<xsl:value-of select="."/>
			</partNumber>
		</partAndSerialNumber>
	</xsl:template>
	<xsl:template match="qty">
		<reqQuantity>
			<xsl:if test="@uom">
				<xsl:attribute name="unitOfMeasure"><xsl:value-of select="@uom"/></xsl:attribute>
			</xsl:if>
			<xsl:value-of select="."/>
		</reqQuantity>
	</xsl:template>
	
	
    <xsl:template match="spares">
    	<reqSpares>
			<xsl:choose>
			  <xsl:when test="//spare">
					<spareDescrGroup>
						<xsl:apply-templates select="//spare"/>
					</spareDescrGroup>
				</xsl:when>
				<xsl:otherwise>
					<noSpares/>
				</xsl:otherwise>
			</xsl:choose>
		</reqSpares>
    </xsl:template>

<!--    <xsl:template match="spare">
        <spareDescr>
            <catalogSeqNumberRef 
                figureNumber="{substring(identno/mfc, 1, 2)}" 
                item="{substring(identno/pnr, 1, 3)}"/> 
            <reqQuantity>
                <xsl:value-of select="qty"/>
            </reqQuantity>
        </spareDescr>
    </xsl:template>-->
	
	<xsl:template match="spare">
		<spareDescr>
			<catalogSeqNumberRef 
				figureNumber="{concat(
					substring(identno/mfc, 1, 1), 
					substring(
						translate(identno/mfc, translate(identno/mfc, '0123456789', ''), ''), 
						1, 1
					)
				)}" 
				item="{substring(
					translate(identno/pnr, translate(identno/pnr, '0123456789', ''), ''), 
					1, 3
				)}"/>
			<reqQuantity>
				<xsl:value-of select="qty"/>
			</reqQuantity>
		</spareDescr>
	</xsl:template>

	
	<xsl:template match="safety">
	<reqSafety>
		<xsl:choose>
		  <xsl:when test="safecond/warning">
			  <safetyRqmts>
				<xsl:apply-templates select="safecond/warning"/>
			  </safetyRqmts>
			</xsl:when>
			<xsl:otherwise>
				<noSafety/>
			</xsl:otherwise>
		</xsl:choose>	  
	</reqSafety>
	</xsl:template>
	
	  <xsl:template match="warning">
		<warning>
		  <xsl:apply-templates select="symbol"/>
		  <warningAndCautionPara>
			<xsl:value-of select="para"/>
		  </warningAndCautionPara>
		</warning>
	  </xsl:template>
	  
	  	<xsl:template match="procd">
		<warning>
		  <xsl:apply-templates select="symbol"/>
		  <warningAndCautionPara>
			<xsl:value-of select="para"/>
		  </warningAndCautionPara>
		</warning>
	  </xsl:template>
	
	  <xsl:template match="symbol">
		<symbol infoEntityIdent="{@boardno}"/>
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
                <manufacturerCode><xsl:value-of select="identno/mfc"/></manufacturerCode>
                <partAndSerialNumber>
                    <partNumber><xsl:value-of select="identno/pnr"/></partNumber>
                </partAndSerialNumber>
            </identNumber>
            
            <reqQuantity>
                <xsl:if test="qty/@uom">
                    <xsl:attribute name="unitOfMeasure">
                        <xsl:value-of select="qty/@uom"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="qty"/>
            </reqQuantity>
        </supportEquipDescr>
    </xsl:template>
	
	<xsl:template match="mainfunc">
		<mainProcedure>
			<xsl:apply-templates select=".//step1"/>
		</mainProcedure>
	</xsl:template>

	
	<xsl:template match="step1 | step2 | step3 | step4">
		<proceduralStep>
<!--			<xsl:apply-templates select="@*|node()"/>-->
			<xsl:apply-templates select="node()"/>
		</proceduralStep>
	</xsl:template>
	
	 <xsl:template match="multimediaobject">
        <multimediaObject  autoPlay="{@autoplay}"
                 fullScreen="{@fullscrn}"
                 infoEntityIdent="{@boardno}"
                 multimediaType="{@multimediaclass}"/>
    </xsl:template>
	
  <xsl:template match="xref">
    <internalRef internalRefId="{@xrefid}">
      <xsl:attribute name="internalRefTargetType">
        <xsl:choose>
          <xsl:when test="@xidtype = 'supply'">irtt04</xsl:when>
          <xsl:when test="@xidtype = 'supequip'">irtt05</xsl:when>
           <xsl:when test="@xidtype = 'figure'">irtt06</xsl:when>
           <xsl:when test="@xidtype = 'hotspot'">irtt07</xsl:when>
        </xsl:choose>
      </xsl:attribute>
    </internalRef>
  </xsl:template>
  
  	<xsl:template match="note/para">
		<notePara>
			<xsl:value-of select="."/>
		</notePara>
	</xsl:template>
	
  	<xsl:template match="caution/para">
		<warningAndCautionPara>
			<xsl:value-of select="."/>
		</warningAndCautionPara>
	</xsl:template>
	
	<xsl:template match="figure">
		<figure>
			  <xsl:if test="@id">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
             </xsl:if>
			<title><xsl:value-of select="title"/></title>
			<graphic infoEntityIdent="{graphic/@boardno}">
				<xsl:if test="graphic/@id">
					<xsl:attribute name="id">
						<xsl:value-of select="graphic/@id"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="graphic/hotspot"/>
			</graphic>
			<xsl:apply-templates select="legend"/>
		</figure>
	</xsl:template>
    
    <xsl:template match="hotspot">
        <hotspot applicationStructureIdent="{@apsid}"
                 applicationStructureName="{@apsname}"
                 id="{@id}"
                 hotspotTitle="{@title}"/>
    </xsl:template>
    
    <xsl:template match="legend">
        <legend>
            <definitionList>
                <definitionListItem>
                    <listItemTerm>
                        <xsl:value-of select="deflist/term"/>
                    </listItemTerm>
                    <listItemDefinition>
                        <para><xsl:value-of select="deflist/def"/></para>
                    </listItemDefinition>
                </definitionListItem>
            </definitionList>
        </legend>
    </xsl:template>
  
	<xsl:template match="closereqs">
		<closeRqmts>
			<reqCondGroup>
				<xsl:choose>
					<xsl:when test="reqconds/reqcond">
						<xsl:for-each select="reqconds/reqcond">
							<reqCondNoRef>
								<reqCond>
									<xsl:value-of select="."/>
								</reqCond>
							</reqCondNoRef>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<noConds/>
					</xsl:otherwise>
				</xsl:choose>
			</reqCondGroup>
		</closeRqmts>
	</xsl:template>
	
	<xsl:template match="randlist">
        <randomList listItemPrefix="{@prefix}">
            <xsl:for-each select="item">
                <listItem>
                    <para><xsl:value-of select="."/></para>
                </listItem>
            </xsl:for-each>
        </randomList>
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
