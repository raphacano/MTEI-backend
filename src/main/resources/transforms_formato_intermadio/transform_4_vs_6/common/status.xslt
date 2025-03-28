<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="dmStatus">
        <xsl:copy>
            <!-- Copy all child elements except referencedApplicGroup -->
            <xsl:apply-templates select="node()[not(self::referencedApplicGroup)]"/>
        </xsl:copy>
    </xsl:template>
   
</xsl:stylesheet>