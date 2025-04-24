<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:dc="http://www.purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="dc rdf xlink"
    version="2.0">

	<!-- hoja de transformacion encargada de "Applicability cross-reference table " 
	131A
	-->
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:include href="../common/dmaddres.xslt"/>
    <xsl:include href="../common/status.xslt"/>
    <xsl:include href="content.xslt"/>

    <xsl:template match="/dmodule">
        <dmodule xmlns:dc="http://www.purl.org/dc/elements/1.1/"
                 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:xlink="http://www.w3.org/1999/xlink"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xsi:noNamespaceSchemaLocation="http://www.s1000d.org/S1000D_6/xml_schema_flat/appliccrossreftable.xsd">
            <identAndStatusSection>
                <xsl:apply-templates select="idstatus/dmaddres"/>
                <xsl:apply-templates select="idstatus/status"/>
            </identAndStatusSection>
			<xsl:apply-templates select="content"/>
		
        </dmodule>
    </xsl:template>

</xsl:stylesheet>