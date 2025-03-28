<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


    <xsl:template match="status">
        <dmStatus issueType="{/dmodule/idstatus/dmaddres/issno/@type}">
            <security securityClassification="{security/@class}" commercialClassification="{security/@commcls}"/>
            <dataRestrictions>
                <restrictionInstructions>
                    <dataDistribution><xsl:value-of select="datarest/instruct/distrib"/></dataDistribution>
                    <exportControl>
                        <exportRegistrationStmt>
                            <simplePara><xsl:value-of select="datarest/instruct/expcont/expstatement/p"/></simplePara>
                        </exportRegistrationStmt>
                    </exportControl>
                    <dataHandling><xsl:value-of select="datarest/instruct/handling"/></dataHandling>
                    <dataDestruction><xsl:value-of select="datarest/instruct/destruct"/></dataDestruction>
                    <dataDisclosure><xsl:value-of select="datarest/instruct/disclose"/></dataDisclosure>
                </restrictionInstructions>
                <restrictionInfo>
                    <copyright>
                        <xsl:for-each select="datarest/inform/copyright/para">
                            <copyrightPara><xsl:value-of select="."/></copyrightPara>
                        </xsl:for-each>
                    </copyright>
                    <policyStatement><xsl:value-of select="datarest/inform/polref"/></policyStatement>
                    <dataConds><xsl:value-of select="datarest/inform/datacond"/></dataConds>
                </restrictionInfo>
            </dataRestrictions>
            <responsiblePartnerCompany enterpriseCode="{rpc}">
                <enterpriseName><xsl:value-of select="rpc/@rpcname"/></enterpriseName>
            </responsiblePartnerCompany>
            <originator enterpriseCode="{orig}">
                <enterpriseName><xsl:value-of select="orig/@origname"/></enterpriseName>
            </originator>
<!--            <applicCrossRefTableRef>
                <dmRef>
                    <dmRefIdent>
                        <dmCode modelIdentCode="{actref/refdm/avee/modelic}"
                                systemDiffCode="{actref/refdm/avee/sdc}"
                                systemCode="{actref/refdm/avee/chapnum}"
                                subSystemCode="{actref/refdm/avee/section}"
                                subSubSystemCode="{actref/refdm/avee/subsect}"
                                assyCode="{actref/refdm/avee/subject}"
                                disassyCode="{actref/refdm/avee/discode}"
                                disassyCodeVariant="{actref/refdm/avee/discodev}"
                                infoCode="{actref/refdm/avee/incode}"
                                infoCodeVariant="{actref/refdm/avee/incodev}"
                                itemLocationCode="{actref/refdm/avee/itemloc}"/>
                    </dmRefIdent>
                </dmRef>
            </applicCrossRefTableRef>-->
            <applic>
                <displayText>
                    <simplePara><xsl:value-of select="applic/type"/></simplePara>
                </displayText>
   <!--             <xsl:apply-templates select="applic/evaluate"/>-->
            </applic>
            <techStandard>
                <authorityInfoAndTp>
                    <authorityInfo><xsl:value-of select="techstd/autandtp/authblk"/></authorityInfo>
                    <techPubBase><xsl:value-of select="techstd/autandtp/tpbase"/></techPubBase>
                </authorityInfoAndTp>
                <authorityExceptions/>
                <authorityNotes/>
            </techStandard>
            <brexDmRef>
                <dmRef>
                    <dmRefIdent>
                        <dmCode modelIdentCode="{brexref/refdm/avee/modelic}"
                                systemDiffCode="{brexref/refdm/avee/sdc}"
                                systemCode="{brexref/refdm/avee/chapnum}"
                                subSystemCode="{brexref/refdm/avee/section}"
                                subSubSystemCode="{brexref/refdm/avee/subsect}"
                                assyCode="{brexref/refdm/avee/subject}"
                                disassyCode="{brexref/refdm/avee/discode}"
                                disassyCodeVariant="{brexref/refdm/avee/discodev}"
                                infoCode="{brexref/refdm/avee/incode}"
                                infoCodeVariant="{brexref/refdm/avee/incodev}"
                                itemLocationCode="{brexref/refdm/avee/itemloc}"/>
                    </dmRefIdent>
                </dmRef>
            </brexDmRef>
            <qualityAssurance>
                <firstVerification verificationType="tabtop"/>
            </qualityAssurance>
            <systemBreakdownCode><xsl:value-of select="sbc"/></systemBreakdownCode>
            <skillLevel skillLevelCode="{skill/@skill}"/>
            <xsl:for-each select="rfu/p">
                <reasonForUpdate id="RFU-{translate(substring-before(.,':'), ' ', '-')}" updateReasonType="urt01">
                    <simplePara><xsl:value-of select="normalize-space(.)"/></simplePara>
                </reasonForUpdate>
            </xsl:for-each>
        </dmStatus>
    </xsl:template>
    
    <xsl:template match="distrib"><dataDistribution><xsl:apply-templates/></dataDistribution></xsl:template>
    <xsl:template match="expcont"><exportControl><xsl:apply-templates/></exportControl></xsl:template>
    <xsl:template match="expstatement"><exportRegistrationStmt><simplePara><xsl:apply-templates/></simplePara></exportRegistrationStmt></xsl:template>
    <xsl:template match="handling"><dataHandling><xsl:apply-templates/></dataHandling></xsl:template>
    <xsl:template match="destruct"><dataDestruction><xsl:apply-templates/></dataDestruction></xsl:template>
    <xsl:template match="disclose"><dataDisclosure><xsl:apply-templates/></dataDisclosure></xsl:template>
</xsl:stylesheet>