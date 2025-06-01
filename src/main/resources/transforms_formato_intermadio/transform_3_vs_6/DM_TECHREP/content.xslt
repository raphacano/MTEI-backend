<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">


	<xsl:template match="content">
		<content>
			<xsl:apply-templates select="techrep"/>
		</content>
	</xsl:template>
    

    <xsl:template match="techrep">
        <techRepository>
            <xsl:apply-templates select="einlist/eininfo" mode="functional"/>
            <xsl:apply-templates select="cblist" mode="cb"/>
            <xsl:apply-templates select="partlist/partinfo" mode="part"/>
             <xsl:apply-templates select="zonelist"/>
             <xsl:apply-templates select="accpnllist"/>
             <xsl:apply-templates select="toollist"/>
             <xsl:apply-templates select="organizationlist"/>
              <xsl:apply-templates select="consupplylist"/>
        </techRepository>
    </xsl:template>
    

    <xsl:template match="eininfo" mode="functional">
        <functionalItemRepository>
            <functionalItemSpec>
                <functionalItemIdent functionalItemType="{einid/@eintype}" functionalItemNumber="{einid/@einnbr}"/>
                <name><xsl:value-of select="nomen"/></name>
                <xsl:apply-templates select="refs/refdm" mode="fparea"/>
                <xsl:apply-templates select="einref | einalt"/>
                <refs>
                    <xsl:apply-templates select="refs/refdm"/>
                </refs>
            </functionalItemSpec>
        </functionalItemRepository>
    </xsl:template>
    
<!---->
    <xsl:template match="cblist" mode="cb">
        <circuitBreakerRepository>
            <xsl:apply-templates select="cbinfo"/>
        </circuitBreakerRepository>
    </xsl:template>
    
    <xsl:template match="partinfo" mode="part">
        <partRepository>
            <xsl:apply-templates select="."/>
        </partRepository>
    </xsl:template>
    

    <xsl:template match="refdm">
        <dmRef>
            <dmRefIdent>
                <identExtension 
                    extensionProducer="{dmcextension/dmeproducer}" 
                    extensionCode="{dmcextension/dmecode}"/>
                <dmCode 
                    systemDiffCode="0"
                    subSubSystemCode="0" 
                    infoCodeVariant="{age/incodev}" 
                    subSystemCode="{age/supeqvc}" 
                    itemLocationCode="{age/itemloc}" 
                    disassyCodeVariant="{age/discodev}" 
                    modelIdentCode="{age/modelic}" 
                    assyCode="{age/eidc}" 
                    disassyCode="{age/discode}" 
                    systemCode="{age/ecscs}"
                    infoCode="{age/incode}"/>
                    
                <xsl:if test="issno/@issno">
                    <issueInfo issueNumber="{format-number(issno/@issno, '000')}" inWork="00"/>
                </xsl:if>
                <xsl:if test="@language">
                    <language languageIsoCode="{@language}" countryIsoCode=""/>
                </xsl:if>
            </dmRefIdent>
            <dmRefAddressItems>
                <dmTitle>
                    <techName><xsl:value-of select="dmtitle/techname"/></techName>
                    <infoName><xsl:value-of select="dmtitle/infoname"/></infoName>
                </dmTitle>
                <xsl:call-template name="issueDate"/>
            </dmRefAddressItems>
            <behavior/>
        </dmRef>
    </xsl:template>
    

    <xsl:template name="issueDate">
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
    </xsl:template>
    
   
  

    <xsl:template match="einref">
        <functionalItemRefGroup functionalItemRefType="{@type}">
            <functionalItemRef functionalItemNumber="{ein/@einnbr}">
                <name><xsl:value-of select="ein/nomen"/></name>
                <xsl:if test="ein/refs/refdm">
                    <refs>
                        <xsl:apply-templates select="ein/refs/refdm"/>
                    </refs>
                </xsl:if>
            </functionalItemRef>
        </functionalItemRefGroup>
    </xsl:template>
   
   
    <xsl:template match="einalt">
        <functionalItemAlt>
            <name><xsl:value-of select="nomen"/></name>
            <location>
                <zoneRef>
                    <name><xsl:value-of select="location/zone/nomen"/></name>
                    <xsl:if test="location/zone/refs/refdm">
                        <refs>
                            <xsl:apply-templates select="location/zone/refs/refdm"/>
                        </refs>
                    </xsl:if>
                </zoneRef>
            </location>
            <accessFrom>
                <zoneRef>
                    <name><xsl:value-of select="accessfrom/zone/nomen"/></name>
                    <xsl:if test="accessfrom/zone/refs/refdm">
                        <refs>
                            <xsl:apply-templates select="accessfrom/zone/refs/refdm"/>
                        </refs>
                    </xsl:if>
                </zoneRef>
            </accessFrom>
            <reqQuantity><xsl:value-of select="qty"/></reqQuantity>
            <xsl:apply-templates select="einref"/>
        </functionalItemAlt>
    </xsl:template>
    

    <xsl:template match="cbinfo">
        <circuitBreakerSpec>
            <circuitBreakerIdent circuitBreakerNumber="{cbid/@cbnbr}"/>
            <name><xsl:value-of select="nomen"/></name>
            <xsl:apply-templates select="refs/refdm" mode="fparea"/>
            <xsl:apply-templates select="cbalt"/>
            <refs>
                <xsl:apply-templates select="refs/refdm"/>
            </refs>
        </circuitBreakerSpec>
    </xsl:template>
    
  
    <xsl:template match="cbalt">
        <circuitBreakerAlt>
            <name><xsl:value-of select="nomen"/></name>
            <circuitBreakerClass circuitBreakerType="elmec"/>
            <location>
                <zoneRef>
                    <name><xsl:value-of select="location/zone/nomen"/></name>
                    <xsl:if test="location/zone/refs/refdm">
                        <refs>
                            <xsl:apply-templates select="location/zone/refs/refdm"/>
                        </refs>
                    </xsl:if>
                </zoneRef>
            </location>
            <xsl:apply-templates select="einref"/>
        </circuitBreakerAlt>
    </xsl:template>
    
      <xsl:template match="refdm" mode="fparea">
        <functionalPhysicalAreaRef 
            subSubSystemCode="{age/incodev}" 
            subSystemCode="{age/discodev}" 
            assyCode="{age/eidc}" 
            systemCode="{age/ecscs}">
            <dmRef>
                <dmRefIdent>
                    <identExtension 
                        extensionCode="{dmcextension/dmecode}" 
                        extensionProducer="{dmcextension/dmeproducer}"/>
                    <dmCode 
                        systemDiffCode="{age/supeqvc}"
                        subSubSystemCode="{age/incodev}"
                        infoCodeVariant="{age/incodev}"
                        subSystemCode="{age/discodev}"
                        itemLocationCode="{age/itemloc}"
                        disassyCodeVariant="{age/discodev}"
                        modelIdentCode="{age/modelic}"
                        assyCode="{age/eidc}"
                        disassyCode="{age/discode}"
                        systemCode="{age/ecscs}"
                        infoCode="{age/incode}"/>
                        
						<xsl:if test="issno/@issno">
							<issueInfo issueNumber="{format-number(issno/@issno, '000')}" inWork="00"/>
						</xsl:if>
						<xsl:if test="@language">
							<language languageIsoCode="{@language}" countryIsoCode=""/>
						</xsl:if>
  
                </dmRefIdent>
                <dmRefAddressItems>
                    <dmTitle>
                        <techName><xsl:value-of select="dmtitle/techname"/></techName>
                        <infoName><xsl:value-of select="dmtitle/infoname"/></infoName>
                    </dmTitle>
                    
					<xsl:call-template name="issueDate"/>
					
                </dmRefAddressItems>
                <behavior/>
            </dmRef>
        </functionalPhysicalAreaRef>
    </xsl:template>
    

    <xsl:template match="partinfo">
        <partSpec>
            <partIdent partNumberValue="{partid/@pnr}" manufacturerCodeValue="{partid/@mfc}"/>
            <itemIdentData>
                <name><xsl:value-of select="nomdata/nomen"/></name>
                <partKeyword><xsl:value-of select="nomdata/kwd"/></partKeyword>
                <shortName><xsl:value-of select="nomdata/opn"/></shortName>
                <overLengthPartNumber><xsl:value-of select="nomdata/stocknbr/@pnr"/></overLengthPartNumber>
                <stockNumber><xsl:value-of select="nomdata/stocknbr/@pnr"/></stockNumber>
                <natoStockNumber>
                    <fullNatoStockNumber><xsl:value-of select="nomdata/nsn"/></fullNatoStockNumber>
                    <xsl:if test="nomdata/nsn/refs/refdm">
                        <refs>
                            <xsl:apply-templates select="nomdata/nsn/refs/refdm"/>
                        </refs>
                    </xsl:if>
                </natoStockNumber>
            </itemIdentData>
            <procurementData>
                <supplierCode><xsl:value-of select="procdata/spl"/></supplierCode>
                <optionalSupplierCode><xsl:value-of select="procdata/osc"/></optionalSupplierCode>
                <xsl:if test="procdata/bfe">
                    <buyerFurnishedEquipFlag/>
                </xsl:if>
            </procurementData>
            <techData>
                <sparePartClass sparePartClassCode="{techdata/spc/@spcnbr}"/>
                <usageCategory usageCategoryCode="{techdata/usgcat/@usgnbr}"/>
                <specDocument/>
                <quantity>
                    <quantityGroup>
                        <quantityValue><xsl:value-of select="techdata/quantity/qtygrp/qtyvalue"/></quantityValue>
                        <quantityTolerance><xsl:value-of select="techdata/quantity/qtygrp/qtytolerance"/></quantityTolerance>
                    </quantityGroup>
                </quantity>
                <physicalSecurityPilferageCode><xsl:value-of select="techdata/psc"/></physicalSecurityPilferageCode>
                <fitmentCode fitmentCodeValue="{techdata/ftc/@value}"/>
                <unitOfIssue><xsl:value-of select="techdata/uoi"/></unitOfIssue>
                <specialStorage><xsl:value-of select="techdata/str"/></specialStorage>
                <calibrationMarker><xsl:value-of select="techdata/cmk"/></calibrationMarker>
            </techData>
            <partRefGroup>
                <xsl:apply-templates select="partref/rplby"/>
            </partRefGroup>
            <xsl:if test="refs/refdm">
                <refs>
                    <xsl:apply-templates select="refs/refdm"/>
                </refs>
            </xsl:if>
        </partSpec>
    </xsl:template>
    

    <xsl:template match="rplby">
        <replacedBy replacementCode="{@inc}">
            <partRef partNumberValue="{part/@pnr}" manufacturerCodeValue="{part/@mfc}">
                <xsl:if test="part/refs/refdm">
                    <refs>
                        <xsl:apply-templates select="part/refs/refdm"/>
                    </refs>
                </xsl:if>
            </partRef>
            <functionalItemRef functionalItemNumber="{ein/@einnbr}">
                <name><xsl:value-of select="ein/nomen"/></name>
                <xsl:if test="ein/refs/refdm">
                    <refs>
                        <xsl:apply-templates select="ein/refs/refdm"/>
                    </refs>
                </xsl:if>
            </functionalItemRef>
            <replacementCond><xsl:value-of select="ict"/></replacementCond>
        </replacedBy>
    </xsl:template>
    
<!---->
   <xsl:template match="zonelist">
        <zoneRepository>
            <xsl:apply-templates select="figure"/>
            <xsl:apply-templates select="zoneinfo"/>
        </zoneRepository>
    </xsl:template>

  <xsl:template match="figure">
        <figure>
            <title>
                <xsl:apply-templates select="title/ein"/>
            </title>
            <xsl:apply-templates select="graphic"/>
            <xsl:apply-templates select="legend"/>
        </figure>
    </xsl:template>

 
    <xsl:template match="graphic">
        <graphic infoEntityIdent="{@boardno}">
            <hotspot>
                <internalRef>
                    <subScript><xsl:value-of select="hotspot/xref/subscrpt"/></subScript>
                </internalRef>
            </hotspot>
            <reasonForAmendment>
                <xsl:apply-templates select="rfa/ein"/>
            </reasonForAmendment>
        </graphic>
    </xsl:template>


    <xsl:template match="legend">
        <legend>
            <xsl:apply-templates select="deflist"/>
        </legend>
    </xsl:template>

<!---->
    <xsl:template match="deflist">
        <definitionList>
            <title>
                <xsl:apply-templates select="title/ein"/>
            </title>
            <definitionListHeader>
                <termTitle>
                    <xsl:apply-templates select="term/ein"/>
                </termTitle>
                <definitionTitle>
                    <xsl:apply-templates select="def/para/ein"/>
                </definitionTitle>
            </definitionListHeader>
            <definitionListItem>
                <listItemTerm>
                    <xsl:apply-templates select="term/ein"/>
                </listItemTerm>
                <listItemDefinition>
                    <para>
                        <xsl:apply-templates select="def/para/ein"/>
                    </para>
                </listItemDefinition>
            </definitionListItem>
        </definitionList>
    </xsl:template>


    <xsl:template match="zoneinfo">
        <zoneSpec>
            <zoneIdent zoneNumber="{zoneid/@zonenbr}"/>
            <xsl:apply-templates select="zoneref"/>
            <xsl:apply-templates select="zonealt"/>
            <refs>
                <xsl:apply-templates select="refs/refdm"/>
            </refs>
        </zoneSpec>
    </xsl:template>


    <xsl:template match="zoneref">
        <zoneRefGroup zoneRefType="{@type}">
            <zoneRef>
                <name><xsl:value-of select="zone/nomen"/></name>
                <refs>
                    <xsl:apply-templates select="zone/refs/refdm"/>
                </refs>
            </zoneRef>
        </zoneRefGroup>
    </xsl:template>


    <xsl:template match="zonealt">
        <zoneAlt>
            <itemDescr><xsl:value-of select="desc"/></itemDescr>
            <zoneSide zoneSideValue="{side/@hand}"/>
            <boundaryFrom>
                <xsl:apply-templates select="bndfrom/boundary"/>
            </boundaryFrom>
            <boundaryTo>
                <xsl:apply-templates select="bndto/boundary"/>
            </boundaryTo>
            <xsl:apply-templates select="zoneref"/>
            <internalRef>
                <subScript><xsl:value-of select="xref/subscrpt"/></subScript>
            </internalRef>
        </zoneAlt>
    </xsl:template>


    <xsl:template match="boundary">
        <boundary>
            <quantity>
                <quantityGroup>
                    <quantityValue>
                        <xsl:value-of select=".//qtyvalue"/>
                    </quantityValue>
                    <quantityTolerance>
                        <xsl:value-of select=".//qtytolerance"/>
                    </quantityTolerance>
                </quantityGroup>
            </quantity>
        </boundary>
    </xsl:template>


    <xsl:template match="ein">
        <functionalItemRef functionalItemNumber="{@einnbr}">
            <name><xsl:value-of select="nomen"/></name>
            <refs>
                <xsl:apply-templates select="refs/refdm"/>
            </refs>
        </functionalItemRef>
    </xsl:template>
    

<!---->
    <xsl:template match="accpnllist">
        <accessPointRepository>
            <xsl:apply-templates select="figure | accpnlinfo"/>
        </accessPointRepository>
    </xsl:template>
    
    
    <xsl:template match="title">
        <title>
            <xsl:apply-templates select="ein"/>
        </title>
    </xsl:template>
    

   
    <xsl:template match="hotspot">
        <hotspot>
            <internalRef>
                <subScript>
                    <xsl:value-of select="xref/subscrpt"/>
                </subScript>
            </internalRef>
        </hotspot>
    </xsl:template>
    

    <xsl:template match="rfa">
        <reasonForAmendment>
            <xsl:apply-templates select="ein"/>
        </reasonForAmendment>
    </xsl:template>
    

    <xsl:template match="legend">
        <legend>
            <definitionList>
                <xsl:apply-templates select="deflist/title"/>
                <definitionListHeader>
                    <termTitle>
                        <xsl:apply-templates select="deflist/term/ein"/>
                    </termTitle>
                    <definitionTitle>
                        <xsl:apply-templates select="deflist/def/para/ein"/>
                    </definitionTitle>
                </definitionListHeader>
                <definitionListItem>
                    <listItemTerm>
                        <xsl:apply-templates select="deflist/term/ein"/>
                    </listItemTerm>
                    <listItemDefinition>
                        <para>
                            <xsl:apply-templates select="deflist/def/para/ein"/>
                        </para>
                    </listItemDefinition>
                </definitionListItem>
            </definitionList>
        </legend>
    </xsl:template>
    

    <xsl:template match="accpnlinfo">
        <accessPointSpec>
            <accessPointIdent accessPointNumber="{accpnlid/@accpnlnbr}"/>
            <xsl:apply-templates select="accpnlref"/>
            <xsl:apply-templates select="accpnlalt"/>
            <xsl:apply-templates select="refs"/>
        </accessPointSpec>
    </xsl:template>
    

    <xsl:template match="accpnlref">
        <accessPointRefGroup accessPointRefType="{@type}">
            <accessPointRef>
                <name><xsl:value-of select="accpnl/nomen"/></name>
                <refs>
                    <xsl:apply-templates select="accpnl/refs/refdm"/>
                </refs>
            </accessPointRef>
        </accessPointRefGroup>
    </xsl:template>
    

    <xsl:template match="accpnlalt">
        <accessPointAlt>
            <accessPointType accessPointTypeValue="{acctype/@accpnltype}"/>
            <zoneRef>
                <name><xsl:value-of select="zone/nomen"/></name>
                <refs>
                    <xsl:apply-templates select="zone/refs/refdm"/>
                </refs>
            </zoneRef>
            <accessTo>
                <xsl:apply-templates select="accessto/ein"/>
                <otherItems><xsl:value-of select="accessto/others"/></otherItems>
            </accessTo>
            <xsl:apply-templates select="accpnlref"/>
            <fastener>
                <fastenerType><xsl:value-of select="fastener/fsttype"/></fastenerType>
                <fastenerQuantity><xsl:value-of select="fastener/fstqty"/></fastenerQuantity>
            </fastener>
            <quantity>
                <quantityGroup>
                    <quantityValue><xsl:value-of select="quantity/qtygrp/qtyvalue"/></quantityValue>
                    <quantityTolerance><xsl:value-of select="quantity/qtygrp/qtytolerance"/></quantityTolerance>
                </quantityGroup>
            </quantity>
            <hoursToOpen><xsl:value-of select="openhour"/></hoursToOpen>
            <internalRef>
                <subScript><xsl:value-of select="xref/subscrpt"/></subScript>
            </internalRef>
        </accessPointAlt>
    </xsl:template>
    
<!---->
    <xsl:template match="toollist">
        <toolRepository>
            <xsl:apply-templates select="figure"/>
            <xsl:apply-templates select="toolinfo"/>
        </toolRepository>
    </xsl:template>
    

    <xsl:template match="figure">
        <figure>
            <xsl:apply-templates select="title"/>
            <xsl:apply-templates select="graphic"/>
            <xsl:apply-templates select="legend"/>
        </figure>
    </xsl:template>
    

    <xsl:template match="title">
        <title>
            <functionalItemRef functionalItemNumber="{ein/@einnbr}">
                <name><xsl:value-of select="ein/nomen"/></name>
                <refs>
                    <xsl:apply-templates select="ein/refs/refdm"/>
                </refs>
            </functionalItemRef>
        </title>
    </xsl:template>
    

    <xsl:template match="graphic">
        <graphic infoEntityIdent="{@boardno}">
            <xsl:apply-templates select="hotspot"/>
            <reasonForAmendment>
                <functionalItemRef functionalItemNumber="{rfa/ein/@einnbr}">
                    <name><xsl:value-of select="rfa/ein/nomen"/></name>
                    <refs>
                        <xsl:apply-templates select="rfa/ein/refs/refdm"/>
                    </refs>
                </functionalItemRef>
            </reasonForAmendment>
        </graphic>
    </xsl:template>
    

    <xsl:template match="hotspot">
        <hotspot>
            <internalRef>
                <subScript><xsl:value-of select="xref/subscrpt"/></subScript>
            </internalRef>
        </hotspot>
    </xsl:template>
    

    <xsl:template match="legend">
        <legend>
            <definitionList>
                <xsl:apply-templates select="deflist/title"/>
                <definitionListHeader>
                    <termTitle>
                        <xsl:apply-templates select="deflist/term"/>
                    </termTitle>
                    <definitionTitle>
                        <xsl:apply-templates select="deflist/def" mode="title"/>
                    </definitionTitle>
                </definitionListHeader>
                <definitionListItem>
                    <listItemTerm>
                        <xsl:apply-templates select="deflist/term"/>
                    </listItemTerm>
                    <listItemDefinition>
                        <xsl:apply-templates select="deflist/def"/>
                    </listItemDefinition>
                </definitionListItem>
            </definitionList>
        </legend>
    </xsl:template>
    

    <xsl:template match="deflist/title">
        <title>
            <functionalItemRef functionalItemNumber="{ein/@einnbr}">
                <name><xsl:value-of select="ein/nomen"/></name>
                <refs>
                    <xsl:apply-templates select="ein/refs/refdm"/>
                </refs>
            </functionalItemRef>
        </title>
    </xsl:template>
    
    <xsl:template match="deflist/term">
        <functionalItemRef functionalItemNumber="{ein/@einnbr}">
            <name><xsl:value-of select="ein/nomen"/></name>
            <refs>
                <xsl:apply-templates select="ein/refs/refdm"/>
            </refs>
        </functionalItemRef>
    </xsl:template>
    
    <xsl:template match="deflist/def" mode="title">
        <functionalItemRef functionalItemNumber="{para/ein/@einnbr}">
            <name><xsl:value-of select="para/ein/nomen"/></name>
            <refs>
                <xsl:apply-templates select="para/ein/refs/refdm"/>
            </refs>
        </functionalItemRef>
    </xsl:template>
    
    <xsl:template match="deflist/def">
        <para>
            <functionalItemRef functionalItemNumber="{para/ein/@einnbr}">
                <name><xsl:value-of select="para/ein/nomen"/></name>
                <refs>
                    <xsl:apply-templates select="para/ein/refs/refdm"/>
                </refs>
            </functionalItemRef>
        </para>
    </xsl:template>
    

   <xsl:template match="toolinfo">
        <toolSpec>
            <toolIdent manufacturerCodeValue="{toolid/@mfc}" toolNumber="{toolid/@toolnbr}"/>
            <itemIdentData>
                <name><xsl:value-of select="nomdata/nomen"/></name>
                <partKeyword><xsl:value-of select="nomdata/kwd"/></partKeyword>
                <shortName><xsl:value-of select="nomdata/opn"/></shortName>
                <overLengthPartNumber><xsl:value-of select="nomdata/stocknbr/@pnr"/></overLengthPartNumber>
                <stockNumber><xsl:value-of select="nomdata/stocknbr/@pnr"/></stockNumber>
                <natoStockNumber>
                    <fullNatoStockNumber><xsl:value-of select="nomdata/nsn"/></fullNatoStockNumber>

                    <xsl:if test="nomdata/nsn/refdm">
                        <refs>
                            <xsl:apply-templates select="nomdata/nsn/refdm"/>
                        </refs>
                    </xsl:if>
                </natoStockNumber>
            </itemIdentData>
            <procurementData>
                <supplierCode><xsl:value-of select="procdata/spl"/></supplierCode>
                <optionalSupplierCode><xsl:value-of select="procdata/osc"/></optionalSupplierCode>
                <buyerFurnishedEquipFlag/>
            </procurementData>
            <techData>
                <sparePartClass sparePartClassCode="{techdata/spc/@spcnbr}"/>
                <usageCategory usageCategoryCode="{techdata/usgcat/@usgnbr}"/>
                <specDocument/>
                <quantity>
                    <quantityGroup>
                        <quantityValue><xsl:value-of select="techdata/quantity/qtygrp/qtyvalue"/></quantityValue>
                        <quantityTolerance><xsl:value-of select="techdata/quantity/qtygrp/qtytolerance"/></quantityTolerance>
                    </quantityGroup>
                </quantity>
                <physicalSecurityPilferageCode><xsl:value-of select="techdata/psc"/></physicalSecurityPilferageCode>
                <fitmentCode fitmentCodeValue="{techdata/ftc/@value}"/>
                <unitOfIssue><xsl:value-of select="techdata/uoi"/></unitOfIssue>
                <specialStorage><xsl:value-of select="techdata/str"/></specialStorage>
                <calibrationMarker><xsl:value-of select="techdata/cmk"/></calibrationMarker>
            </techData>
            <xsl:apply-templates select="toolref"/>
            <xsl:apply-templates select="toolalt"/>
            <refs>
                <xsl:apply-templates select="refs/refdm"/>
            </refs>
        </toolSpec>
    </xsl:template>
    

    <xsl:template match="toolref">
        <toolRefGroup toolRefType="{@type}">
            <toolRef toolNumber="{tool/@toolnbr}">
                <refs>
                    <xsl:apply-templates select="tool/refs/refdm"/>
                </refs>
            </toolRef>
        </toolRefGroup>
    </xsl:template>
    

    <xsl:template match="toolalt">
        <toolAlt>
            <itemDescr><xsl:value-of select="desc"/></itemDescr>
		   <functionalPhysicalAreaRef
				subSubSystemCode="{xs:integer(refs/refdm/age/cidc)}"
				subSystemCode="{xs:integer(refs/refdm/age/eidc)}"
				assyCode="{refs/refdm/age/modelic}"
				systemCode="{refs/refdm/age/ecscs}">
                <dmRef>
                    <dmRefIdent>
                        <identExtension
                            extensionCode="{refs/refdm/dmcextension/dmecode}"
                            extensionProducer="{refs/refdm/dmcextension/dmeproducer}"/>
                        <dmCode
                            modelIdentCode="{refs/refdm/age/modelic}"
                            systemDiffCode="{refs/refdm/age/supeqvc}"
                            systemCode="{refs/refdm/age/ecscs}"
							assyCode="{refs/refdm/age/discode}"
                            subSystemCode="{xs:integer(refs/refdm/age/eidc)}"
                            subSubSystemCode="{xs:integer(refs/refdm/age/cidc)}"
                            disassyCode="{refs/refdm/age/discode}"
                            disassyCodeVariant="{refs/refdm/age/discodev}"
                            infoCode="{refs/refdm/age/incode}"
                            infoCodeVariant="{refs/refdm/age/incodev}"
                            itemLocationCode="{refs/refdm/age/itemloc}"/>
                            
						<xsl:if test="issno/@issno">
							<issueInfo issueNumber="{format-number(issno/@issno, '000')}" inWork="00"/>
						</xsl:if>
						<xsl:if test="@language">
							<language languageIsoCode="{@language}" countryIsoCode=""/>
						</xsl:if>
							
                    </dmRefIdent>
                    <dmRefAddressItems>
                        <dmTitle>
                            <techName><xsl:value-of select="refs/refdm/dmtitle/techname"/></techName>
                            <infoName><xsl:value-of select="refs/refdm/dmtitle/infoname"/></infoName>
                        </dmTitle>
					  <xsl:call-template name="issueDate"/>
                    </dmRefAddressItems>
                    <behavior/>
                </dmRef>
            </functionalPhysicalAreaRef>
            <rcmdQuantity><xsl:value-of select="rcmdqty"/></rcmdQuantity>
            <packaging><xsl:value-of select="packaging"/></packaging>
            <taskCategory taskCategoryCode="{taskcode/@code}"/>
            <simpleRemark><xsl:value-of select="remark"/></simpleRemark>
            <internalRef>
                <subScript><xsl:value-of select="xref/subscrpt"/></subScript>
            </internalRef>
            <refs>
                <xsl:apply-templates select="refs/refdm"/>
            </refs>
        </toolAlt>
    </xsl:template>

<!---->
    <xsl:template match="organizationlist">
        <enterpriseRepository>
            <xsl:apply-templates select="organizationinfo"/>
        </enterpriseRepository>
    </xsl:template>

	<xsl:template match="organizationinfo">
        <enterpriseSpec>

            <enterpriseIdent manufacturerCodeValue="{organizationid/@mfc}"/>
            
            <enterpriseName>
                <xsl:value-of select="contactaddr/enterprise/ent-name"/>
            </enterpriseName>
            <businessUnit>
                <businessUnitName>
                    <xsl:value-of select="contactaddr/enterprise/division"/>
                </businessUnitName>
                

                <businessUnitAddress>
                    <xsl:apply-templates select="contactaddr/address"/>
                    <SITA/> 
                </businessUnitAddress>
                
                <contactPerson>
                    <lastName/>
                    <middleName/>
                    <firstName/>
                    <jobTitle/>
                    <contactPersonAddress>
                        <department/>
                        <street/>
                        <postOfficeBox/>
                        <postalZipCode/>
                        <city/>
                        <country/>
                        <state/>
                        <province/>
                        <building/>
                        <room/>
                        <phoneNumber/>
                        <faxNumber/>
                        <email/>
                        <internet/>
                        <SITA/>
                    </contactPersonAddress>
                </contactPerson>
            </businessUnit>
            
            <xsl:apply-templates select="organizationref" mode="enterpriseRef"/>

            <refs>
                <xsl:apply-templates select="refs/refdm"/>
            </refs>
        </enterpriseSpec>
    </xsl:template>
    

    <xsl:template match="address">
        <department><xsl:value-of select="dept"/></department>
        <street><xsl:value-of select="street"/></street>
        <postOfficeBox><xsl:value-of select="pobox"/></postOfficeBox>
        <postalZipCode>
            <xsl:choose>
                <xsl:when test="zip != ''"><xsl:value-of select="zip"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="postcode"/></xsl:otherwise>
            </xsl:choose>
        </postalZipCode>
        <city><xsl:value-of select="city"/></city>
        <country><xsl:value-of select="country"/></country>
        <state><xsl:value-of select="state"/></state>
        <province><xsl:value-of select="province"/></province>
        <building><xsl:value-of select="building"/></building>
        <room><xsl:value-of select="room"/></room>
        <phoneNumber><xsl:value-of select="phone"/></phoneNumber>
        <faxNumber><xsl:value-of select="fax"/></faxNumber>
        <email><xsl:value-of select="email"/></email>
        <internet><xsl:value-of select="internet"/></internet>
    </xsl:template>
    

    <xsl:template match="organizationref" mode="enterpriseRef">
        <enterpriseRef manufacturerCodeValue="{@mfc}">
            <xsl:apply-templates select="refdm"/>
        </enterpriseRef>
    </xsl:template>
    
    
<!---->    
     <xsl:template match="consupplylist">
        <supplyRepository>
            <xsl:apply-templates select="consupplyinfo"/>
        </supplyRepository>
    </xsl:template>
    
  <xsl:template match="consupplyinfo">
        <supplySpec>
 
            <supplyIdent 
                supplyNumberType="{consupplyid/@consupplyreftype}" 
                supplyNumber="{consupplyid/@consupplyref}"/>
           
            <name><xsl:value-of select="speclist/spec"/></name>

            <shortName>String</shortName>

            <specificationGroup>
                <specDocument/>
            </specificationGroup>
            

            <supplierGroup>
                <suppliedBy locallySuppliedFlag="{suplist/sup/@local}">
                    <shippingInfo>
                        <packaging><xsl:value-of select="suplist/sup/shippinginfo/packaging"/></packaging>
                    </shippingInfo>
                </suppliedBy>
            </supplierGroup>
            
 
            <natoStockNumber>
                <fullNatoStockNumber>String</fullNatoStockNumber>
                <refs>
                    <xsl:apply-templates select="refs/refdm"/>
                </refs>
            </natoStockNumber>

            <quantity>
                <quantityGroup>
                    <quantityValue><xsl:value-of select="quantity/qtygrp/qtyvalue"/></quantityValue>
                    <quantityTolerance><xsl:value-of select="quantity/qtygrp/qtytolerance"/></quantityTolerance>
                </quantityGroup>
            </quantity>
            

            <refs>
                <xsl:apply-templates select="refs/refdm"/>
            </refs>
            

            <lowestAuthorizedLevelGroup>
                <lowestAuthorizedLevel lowestLevel="la37"/>
            </lowestAuthorizedLevelGroup>
        </supplySpec>
    </xsl:template>

    
    
    <xsl:template match="*"/>
</xsl:stylesheet>