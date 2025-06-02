<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://www.purl.org/dc/elements/1.1/" exclude-result-prefixes="dc">
	<xsl:variable name="lang" select="normalize-space(substring-before(concat(//dc:language, '-'), '-'))"/>
	<xsl:variable name="country" select="normalize-space(substring-after(//dc:language, '-'))"/>
	<xsl:template match="dmaddres">
		<dmAddress>
			<dmIdent>
				<dmCode modelIdentCode="{dmc/avee/modelic}" 
				systemDiffCode="{dmc/avee/sdc}" systemCode="{dmc/avee/chapnum}" 
				subSystemCode="{dmc/avee/section}" subSubSystemCode="{dmc/avee/subsect}" 
				assyCode="{dmc/avee/subject}" disassyCode="{dmc/avee/discode}" 
				disassyCodeVariant="{dmc/avee/discodev}" infoCode="{dmc/avee/incode}" 
				infoCodeVariant="{dmc/avee/incodev}" itemLocationCode="{dmc/avee/itemloc}"/>
				
				<language languageIsoCode="{$lang}">
					<xsl:attribute name="countryIsoCode">
						<xsl:choose>
							<xsl:when test="$country">
								<xsl:value-of select="$country"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="upper-case($lang)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</language>

				<issueInfo issueNumber="{format-number(issno/@issno, '000')}" inWork="{format-number(issno/@inwork, '00')}"/>
			</dmIdent>
			<dmAddressItems>
				<issueDate year="{issdate/@year}" month="{format-number(issdate/@month, '00')}" day="{format-number(issdate/@day, '00')}"/>
				<dmTitle>
					<techName>
						<xsl:value-of select="dmtitle/techname"/>
					</techName>
					<infoName>
						<xsl:value-of select="dmtitle/infoname"/>
					</infoName>
				</dmTitle>
			</dmAddressItems>
		</dmAddress>
	</xsl:template>
</xsl:stylesheet>
