<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">

	<xsl:template match="content">
		<content>
			<xsl:apply-templates select="techrep"/>
		</content>
	</xsl:template>
	
	<xsl:template match="techrep">
		<techRepository>
				<xsl:if test="einlist/eininfo">
					<functionalItemRepository>
						<xsl:apply-templates select="einlist/eininfo"/>
					</functionalItemRepository>
				</xsl:if>		
				<xsl:if test="cblist">
					<xsl:apply-templates select="cblist"/>
				</xsl:if>	
		</techRepository>
	</xsl:template>
	
	<xsl:template match="eininfo">
		<functionalItemSpec>
			<functionalItemIdent functionalItemType="{einid/@eintype}" functionalItemNumber="{einid/@einnbr}"/>
			<name>
				<xsl:value-of select="nomen"/>
			</name>


			<xsl:apply-templates select="refs/refdm" mode="fparea"/>
			<xsl:apply-templates select="einref"/>
			<xsl:apply-templates select="einalt"/>
			<refs>
				<xsl:apply-templates select="refs/refdm"/>
			</refs>
		</functionalItemSpec>
	</xsl:template>
	
	<xsl:template match="refdm" mode="fpArea">
		<dmRef>
			<dmRefIdent>
				<identExtension extensionProducer="{dmcextension/dmeproducer}" extensionCode="{dmcextension/dmecode}"/>
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
			<behavior/>
		</dmRef>
	</xsl:template>
	
	<xsl:template match="einref">
		<functionalItemRefGroup functionalItemRefType="{@type}">
			<functionalItemRef functionalItemNumber="{ein/@einnbr}">
				<name>
					<xsl:value-of select="ein/nomen"/>
				</name>
				<refs>
					<xsl:apply-templates select="ein/refs/refdm"/>
				</refs>
			</functionalItemRef>
		</functionalItemRefGroup>
	</xsl:template>
	
	<xsl:template match="refdm">
		<dmRef>
			<dmRefIdent>
				<identExtension extensionProducer="{dmcextension/dmeproducer}" extensionCode="{dmcextension/dmecode}"/>
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
					<techName>
						<xsl:value-of select="dmtitle/techname"/>
					</techName>
					<infoName>
						<xsl:value-of select="dmtitle/infoname"/>
					</infoName>
				</dmTitle>
				<issueDate year="0000" day="30" month="10"/>
			</dmRefAddressItems>
			<behavior/>
		</dmRef>
	</xsl:template>
	
	
	<xsl:template match="einalt">
		<functionalItemAlt>
			<name>
				<xsl:value-of select="nomen"/>
			</name>
			<location>
				<zoneRef>
					<name>
						<xsl:value-of select="location/zone/nomen"/>
					</name>
					<refs>
						<xsl:apply-templates select="location/zone/refs/refdm"/>
					</refs>
				</zoneRef>
			</location>
			<accessFrom>
				<zoneRef>
					<name>
						<xsl:value-of select="accessfrom/zone/nomen"/>
					</name>
					<refs>
						<xsl:apply-templates select="accessfrom/zone/refs/refdm"/>
					</refs>
				</zoneRef>
			</accessFrom>
			<reqQuantity>
				<xsl:value-of select="qty"/>
			</reqQuantity>
			<xsl:apply-templates select="einref"/>
		</functionalItemAlt>
	</xsl:template>

	 <xsl:template match="cblist">
        <circuitBreakerRepository>
            <xsl:apply-templates select="cbinfo"/>
        </circuitBreakerRepository>
    </xsl:template>

    <xsl:template match="cbinfo">
        <circuitBreakerSpec>
            <circuitBreakerIdent circuitBreakerNumber="{cbid/@cbnbr}"/>
       		<name>
				<xsl:value-of select="nomen"/>
			</name>

           <xsl:apply-templates select="refs/refdm" mode="fparea"/>
            <xsl:apply-templates select="cbalt"/>
      
            <refs>
                <xsl:apply-templates select="refs/refdm"/>
            </refs>
        </circuitBreakerSpec>
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
                <behavior/>
            </dmRef>
        </functionalPhysicalAreaRef>
    </xsl:template>



    <xsl:template match="cbalt">
        <circuitBreakerAlt>
            <name><xsl:value-of select="nomen"/></name>
            <circuitBreakerClass circuitBreakerType="elmec"/>
            
            <location>
                <zoneRef>
                    <name><xsl:value-of select="location/zone/nomen"/></name>
                    <refs>
                        <xsl:apply-templates select="location/zone/refs/refdm"/>
                    </refs>
                </zoneRef>
            </location>

            <xsl:apply-templates select="einref"/>
        </circuitBreakerAlt>
    </xsl:template>


	
</xsl:stylesheet>
