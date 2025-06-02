<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink">
	

  <xsl:template match="content">
	  <content>
        <xsl:apply-templates select="wrngflds"/>
    </content>
  </xsl:template>
  
    <xsl:template match="wrngflds">
        <wiringFields>
            <xsl:apply-templates select="@*|node()"/>
        </wiringFields>
    </xsl:template>
    

    <xsl:template match="dsc.wires">
        <descrWire>
            <xsl:apply-templates select="@*|node()"/>
        </descrWire>
    </xsl:template>
    
    <xsl:template match="dsc.harness">
        <descrHarness>
            <xsl:apply-templates select="@*|node()"/>
        </descrHarness>
    </xsl:template>
    
    <xsl:template match="dsc.elecequip">
        <descrElectricalEquip>
            <xsl:apply-templates select="@*|node()"/>
        </descrElectricalEquip>
    </xsl:template>
    

    <xsl:template match="dsc.wireno">
        <descrWireNumber>
            <xsl:apply-templates/>
        </descrWireNumber>
    </xsl:template>
    
    <xsl:template match="dsc.wiretype">
        <descrWireType>
            <xsl:apply-templates/>
        </descrWireType>
    </xsl:template>
    
    <xsl:template match="dsc.wiregauge">
        <descrWireGauge>
            <xsl:apply-templates/>
        </descrWireGauge>
    </xsl:template>
    
    <xsl:template match="dsc.pnr[parent::dsc.wires]">
        <descrPartNumber>
            <xsl:apply-templates/>
        </descrPartNumber>
    </xsl:template>
    
    <xsl:template match="dsc.harnid[parent::dsc.wires]">
        <descrHarnessIdent>
            <xsl:apply-templates/>
        </descrHarnessIdent>
    </xsl:template>
    
    <xsl:template match="dsc.wireseqno">
        <descrWireSeqNumber>
            <xsl:apply-templates/>
        </descrWireSeqNumber>
    </xsl:template>
    
    <xsl:template match="dsc.wicircode">
        <descrWireInfoCircuitIdent>
            <xsl:apply-templates/>
        </descrWireInfoCircuitIdent>
    </xsl:template>
    
    <xsl:template match="dsc.wisecid">
        <descrWireInfoSectionIdent>
            <xsl:apply-templates/>
        </descrWireInfoSectionIdent>
    </xsl:template>
    
    <xsl:template match="dsc.length">
        <descrLength>
            <xsl:apply-templates/>
        </descrLength>
    </xsl:template>
    
    <xsl:template match="dsc.colour">
        <descrWireColor>
            <xsl:apply-templates/>
        </descrWireColor>
    </xsl:template>
    
    <xsl:template match="dsc.twist">
        <descrTwist>
            <xsl:apply-templates/>
        </descrTwist>
    </xsl:template>
    
    <xsl:template match="dsc.rfd[parent::dsc.wires]">
        <descrFunctionalItemRef>
            <xsl:apply-templates/>
        </descrFunctionalItemRef>
    </xsl:template>
    
    <xsl:template match="dsc.groupcode">
        <descrGroupCode>
            <xsl:apply-templates/>
        </descrGroupCode>
    </xsl:template>
    
    <xsl:template match="dsc.screen">
        <descrScreen>
            <xsl:apply-templates/>
        </descrScreen>
    </xsl:template>
    
    <xsl:template match="dsc.rpc[parent::dsc.wires]">
        <descrResponsiblePartnerCompany>
            <xsl:apply-templates/>
        </descrResponsiblePartnerCompany>
    </xsl:template>
    
    <xsl:template match="dsc.feedthru">
        <descrFeedThru>
            <xsl:apply-templates/>
        </descrFeedThru>
    </xsl:template>
    
    <xsl:template match="dsc.nhassy[parent::dsc.wires]">
        <descrNextHigherAssy>
            <xsl:apply-templates/>
        </descrNextHigherAssy>
    </xsl:template>
    

    <xsl:template match="dsc.harnid[parent::dsc.harness]">
        <descrHarnessIdent>
            <xsl:apply-templates/>
        </descrHarnessIdent>
    </xsl:template>
    
    <xsl:template match="dsc.pnr[parent::dsc.harness]">
        <descrPartNumber>
            <xsl:apply-templates/>
        </descrPartNumber>
    </xsl:template>
    
    <xsl:template match="dsc.harnvar">
        <descrHarnessVariantIdent>
            <xsl:apply-templates/>
        </descrHarnessVariantIdent>
    </xsl:template>
    
    <xsl:template match="dsc.harnissue">
        <descrHarnessVariantIssue>
            <xsl:apply-templates/>
        </descrHarnessVariantIssue>
    </xsl:template>
    
    <xsl:template match="dsc.nomenc">
        <descrHarnessName>
            <xsl:apply-templates/>
        </descrHarnessName>
    </xsl:template>
    
    <xsl:template match="dsc.emc-code">
        <descrEmcCode>
            <xsl:apply-templates/>
        </descrEmcCode>
    </xsl:template>
    
    <xsl:template match="dsc.mint">
        <descrMinTemperature>
            <xsl:apply-templates/>
        </descrMinTemperature>
    </xsl:template>
    
    <xsl:template match="dsc.maxt">
        <descrMaxTemperature>
            <xsl:apply-templates/>
        </descrMaxTemperature>
    </xsl:template>
    
    <xsl:template match="dsc.harnenv">
        <descrHarnessEnvironment>
            <xsl:apply-templates/>
        </descrHarnessEnvironment>
    </xsl:template>
    
    <xsl:template match="dsc.sleeve">
        <descrSleeve>
            <xsl:apply-templates/>
        </descrSleeve>
    </xsl:template>
    
    <xsl:template match="dsc.rpc[parent::dsc.harness]">
        <descrResponsiblePartnerCompany>
            <xsl:apply-templates/>
        </descrResponsiblePartnerCompany>
    </xsl:template>
    
    <xsl:template match="dsc.rfd[parent::dsc.elecequip]">
        <descrFunctionalItemRef>
            <xsl:apply-templates/>
        </descrFunctionalItemRef>
    </xsl:template>
    
    <xsl:template match="dsc.pnr[parent::dsc.elecequip]">
        <descrPartNumber>
            <xsl:apply-templates/>
        </descrPartNumber>
    </xsl:template>
    
    <xsl:template match="dsc.instloc">
        <descrInstallationLocation>
            <xsl:apply-templates/>
        </descrInstallationLocation>
    </xsl:template>
    
    <xsl:template match="dsc.nhassy[parent::dsc.elecequip]">
        <descrNextHigherAssy>
            <xsl:apply-templates/>
        </descrNextHigherAssy>
    </xsl:template>
    
    <xsl:template match="dsc.posnhassy">
        <descrPositionOnNextHigherAssy>
            <xsl:apply-templates/>
        </descrPositionOnNextHigherAssy>
    </xsl:template>
    
    <xsl:template match="dsc.maxposition">
        <descrMaxMountingPositions>
            <xsl:apply-templates/>
        </descrMaxMountingPositions>
    </xsl:template>
    
    <xsl:template match="dsc.sibplugid">
        <descrSiblingPlugIdent>
            <xsl:apply-templates/>
        </descrSiblingPlugIdent>
    </xsl:template>
    
    <xsl:template match="dsc.trl">
        <descrTransverseLink>
            <xsl:apply-templates/>
        </descrTransverseLink>
    </xsl:template>
    
    <xsl:template match="dsc.rpc[parent::dsc.elecequip]">
        <descrResponsiblePartnerCompany>
            <xsl:apply-templates/>
        </descrResponsiblePartnerCompany>
    </xsl:template>
    
    <xsl:template match="dsc.qty">
        <descrReqQuantity>
            <xsl:apply-templates/>
        </descrReqQuantity>
    </xsl:template>
    

    <xsl:template match="fldname">
        <fieldName>
            <xsl:apply-templates/>
        </fieldName>
    </xsl:template>
    
    <xsl:template match="dscr">
        <descr>
            <xsl:apply-templates/>
        </descr>
    </xsl:template>
    
    <xsl:template match="dsc.contact">
		<descrContact>
			<xsl:apply-templates/>
		</descrContact>
	</xsl:template>


</xsl:stylesheet>