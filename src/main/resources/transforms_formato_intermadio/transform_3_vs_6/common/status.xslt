<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

	<xsl:template match="status">
		<dmStatus issueType="{/dmodule/idstatus/dmaddres/issno/@type}">
			<security securityClassification="{security/@class}">
				<xsl:if test="security/@commcls">
					<xsl:attribute name="commercialClassification"><xsl:value-of select="security/@commcls"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="security/@caveat">
					<xsl:attribute name="caveat"><xsl:value-of select="security/@caveat"/></xsl:attribute>
				</xsl:if>
			</security>
			<dataRestrictions>
				<restrictionInstructions>
					<dataDistribution>
						<xsl:value-of select="datarest/instruct/distrib"/>
					</dataDistribution>
					<exportControl>
						<exportRegistrationStmt>
							<simplePara>
								<xsl:value-of select="datarest/instruct/expcont/expstatement/p"/>
							</simplePara>
						</exportRegistrationStmt>
					</exportControl>
					<dataHandling>
						<xsl:value-of select="datarest/instruct/handling"/>
					</dataHandling>
					<dataDestruction>
						<xsl:value-of select="datarest/instruct/destruct"/>
					</dataDestruction>
					<dataDisclosure>
						<xsl:value-of select="datarest/instruct/disclose"/>
					</dataDisclosure>
				</restrictionInstructions>
				<restrictionInfo>
					<xsl:if test="datarest/inform/copyright/para">
						<copyright>
							<xsl:for-each select="datarest/inform/copyright/para">
								<copyrightPara>
									<emphasis>
										<xsl:value-of select="."/>
									</emphasis>
								</copyrightPara>
							</xsl:for-each>
						</copyright>
					</xsl:if>
					<policyStatement>
						<xsl:value-of select="datarest/inform/polref"/>
					</policyStatement>
					<dataConds>
						<xsl:value-of select="datarest/inform/datacond"/>
					</dataConds>
				</restrictionInfo>
			</dataRestrictions>
			<responsiblePartnerCompany enterpriseCode="{rpc}">
				<enterpriseName>
					<xsl:value-of select="rpc/@rpcname"/>
				</enterpriseName>
			</responsiblePartnerCompany>
			<originator enterpriseCode="{orig}">
				<enterpriseName>
					<xsl:value-of select="orig/@origname"/>
				</enterpriseName>
			</originator>
			<applicCrossRefTableRef>
				<dmRef>
					<dmRefIdent>
						<dmCode modelIdentCode="{actref/refdm/avee/modelic}" systemDiffCode="{actref/refdm/avee/sdc}" systemCode="{actref/refdm/avee/chapnum}" subSystemCode="{actref/refdm/avee/section}" subSubSystemCode="{actref/refdm/avee/subsect}" assyCode="{actref/refdm/avee/subject}" disassyCode="{actref/refdm/avee/discode}" disassyCodeVariant="{actref/refdm/avee/discodev}" infoCode="{actref/refdm/avee/incode}" infoCodeVariant="{actref/refdm/avee/incodev}" itemLocationCode="{actref/refdm/avee/itemloc}"/>
					</dmRefIdent>
				</dmRef>
			</applicCrossRefTableRef>
			 <applic>
                <displayText><simplePara><xsl:value-of select="applic/displaytext"/></simplePara></displayText>
                <xsl:apply-templates select="applic/evaluate"/>
            </applic>			
			<techStandard>
				<authorityInfoAndTp>
					<authorityInfo>
						<xsl:value-of select="techstd/autandtp/authblk"/>
					</authorityInfo>
					<techPubBase>
						<xsl:value-of select="techstd/autandtp/tpbase"/>
					</techPubBase>
				</authorityInfoAndTp>
				<authorityExceptions/>
				<authorityNotes/>
			</techStandard>
			<brexDmRef>
				<dmRef>
					<dmRefIdent>
						<dmCode modelIdentCode="{brexref/refdm/avee/modelic}" systemDiffCode="{brexref/refdm/avee/sdc}" systemCode="{brexref/refdm/avee/chapnum}" subSystemCode="{brexref/refdm/avee/section}" subSubSystemCode="{brexref/refdm/avee/subsect}" assyCode="{brexref/refdm/avee/subject}" disassyCode="{brexref/refdm/avee/discode}" disassyCodeVariant="{brexref/refdm/avee/discodev}" infoCode="{brexref/refdm/avee/incode}" infoCodeVariant="{brexref/refdm/avee/incodev}" itemLocationCode="{brexref/refdm/avee/itemloc}"/>
					</dmRefIdent>
				</dmRef>
			</brexDmRef>
			<qualityAssurance>
				<firstVerification verificationType="{qa/firstver/@type}"/>
			</qualityAssurance>
			<systemBreakdownCode>
				<xsl:value-of select="sbc"/>
			</systemBreakdownCode>

			<xsl:if test="//skill/@skill">			
				<skillLevel skillLevelCode="{//skill/@skill}"/>
			</xsl:if>
			
			<reasonForUpdate id="rfu_general" updateReasonType="urt03">
				<xsl:for-each select="rfu/p">
					<simplePara>
						<xsl:value-of select="."/>
					</simplePara>
				</xsl:for-each>
			</reasonForUpdate>
		</dmStatus>
	</xsl:template>
	
	<xsl:template match="evaluate">
		<evaluate andOr="{@operator}">
			<xsl:apply-templates select="*"/>
		</evaluate>
	</xsl:template>
	
	<xsl:template match="assert">
		<assert applicPropertyIdent="{@actidref}" applicPropertyType="{@actreftype}" applicPropertyValues="{@actvalues}"/>
	</xsl:template>


</xsl:stylesheet>
