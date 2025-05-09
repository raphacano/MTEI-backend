<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="  xlink ">

	
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
<!--		<reqCondNoRef>-->
			<reqCond>
				<xsl:value-of select="normalize-space()"/>
			</reqCond>
<!--		</reqCondNoRef>-->
	</xsl:template>
	
	<xsl:template match="reqcondm">
		<reqCondDm>
				<xsl:apply-templates select="reqcond"/>
				<xsl:if test="refdm">
					<xsl:apply-templates select="refdm"/>
				</xsl:if>
		</reqCondDm>
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
			<xsl:apply-templates select="supplyli"/>
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

    <xsl:template match="spare">
        <spareDescr>
            <catalogSeqNumberRef 
                figureNumber="{substring(identno/mfc, 1, 2)}" 
                item="{substring(identno/pnr, 1, 3)}"/> 
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
			 <xsl:apply-templates select="para/node()"/>
				<!--<xsl:apply-templates select="refdm"/>-->
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
  
	<xsl:template match="note/para">
		<notePara>
			<xsl:apply-templates/>
		</notePara>
	</xsl:template>
	
	<xsl:template match="caution/para">
		<warningAndCautionPara>
			<xsl:apply-templates/>
		</warningAndCautionPara>
	</xsl:template>
	
	<xsl:template match="figure">
		<figure id="{@id}">
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
    
<!--    <xsl:template match="legend">
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
    </xsl:template>-->
    
    <xsl:template match="legend">
		<legend>
			<definitionList>
				<!-- Process each term/def pair -->
				<xsl:for-each select="deflist/term">
					<definitionListItem>
						<listItemTerm>
							<xsl:value-of select="."/>
						</listItemTerm>
						<listItemDefinition>
							<para>
								<xsl:value-of select="following-sibling::def[1]"/>
							</para>
						</listItemDefinition>
					</definitionListItem>
				</xsl:for-each>
			</definitionList>
		</legend>
	</xsl:template>
  
	<xsl:template match="closereqs">
		<closeRqmts>
			<reqCondGroup>
				<xsl:choose>
					<!-- Handle reqconds with reqcond children -->
					<xsl:when test="reqconds/reqcond">
						<xsl:for-each select="reqconds/reqcond">
							<reqCondNoRef>  <!-- ADDED WRAPPER ELEMENT -->
								<reqCond>
									<xsl:value-of select="normalize-space(.)"/>
								</reqCond>
							</reqCondNoRef>
						</xsl:for-each>
					</xsl:when>
					<!-- Handle other valid cases -->
					<xsl:when test="reqconds/reqcondm">
						<xsl:apply-templates select="reqconds/*"/>
					</xsl:when>
					<xsl:otherwise>
						<noConds/>
					</xsl:otherwise>
				</xsl:choose>
			</reqCondGroup>
		</closeRqmts>
	</xsl:template>
	

    
	<xsl:template match="randlist">
		<xsl:choose>
			<xsl:when test="ancestor::warning">
				<attentionRandomList listItemPrefix="{@prefix}">
					<xsl:for-each select="item">
						<attentionRandomListItem>
							<attentionListItemPara><xsl:value-of select="."/></attentionListItemPara>
						</attentionRandomListItem>
					</xsl:for-each>
				</attentionRandomList>
			</xsl:when>
			<xsl:otherwise>
				<randomList listItemPrefix="{@prefix}">
					<xsl:for-each select="item">
						<listItem>
							<para><xsl:value-of select="."/></para>
						</listItem>
					</xsl:for-each>
				</randomList>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
    
   <xsl:template match="acronym">
		<acronym reasonForUpdateRefIds="{@id}" 
				  derivativeClassificationRefId="{@id}" id="{@id}" controlAuthorityRefs="{@id}">
		  <xsl:apply-templates select="node()"/>
		</acronym>
  </xsl:template>

  <xsl:template match="acroterm">
		<acronymTerm>
		  <xsl:apply-templates select="node()"/>
		</acronymTerm>
  </xsl:template>

  <xsl:template match="acrodef">
    <acronymDefinition reasonForUpdateRefIds="{ancestor::acronym/@id}" 
                       derivativeClassificationRefId="{ancestor::acronym/@id}"
                       controlAuthorityRefs="{ancestor::acronym/@id}">
      <xsl:apply-templates select="node()"/>
    </acronymDefinition>
  </xsl:template>

  	<xsl:template match="emphasis">
		<emphasis>
			<xsl:value-of select="."/>
		</emphasis>
	</xsl:template>
	
	  <xsl:template match="entry">
        <entry>
            <para><xsl:apply-templates/></para>
        </entry>
    </xsl:template>
    
<!--    <xsl:template match="entry">
		<xsl:copy copy-namespaces="no">
		  <para>
			<xsl:apply-templates select="node()"/>
		  </para>
		</xsl:copy>
	</xsl:template>-->
	
	<xsl:template match="*">
		<xsl:element name="{local-name()}">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
</xsl:stylesheet>
