<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://www.purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="dc rdf xlink xsi xs">

    <xsl:output method="xml" indent="yes"/>

    <xsl:include href="../common/dmaddres.xslt"/>
    <xsl:include href="../common/status.xslt"/>
    <xsl:include href="content.xslt"/>

    <xsl:template match="/dmodule">
        <dmodule xmlns:dc="http://www.purl.org/dc/elements/1.1/"
                 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xsi:noNamespaceSchemaLocation="http://www.s1000d.org/S1000D_4-0/xml_schema_flat/techrep.xsd">
            <identAndStatusSection>
                <xsl:apply-templates select="idstatus/dmaddres"/>
                <xsl:apply-templates select="idstatus/status"/>
            </identAndStatusSection>
            <xsl:apply-templates select="content"/>
        </dmodule>
    </xsl:template>
</xsl:stylesheet>