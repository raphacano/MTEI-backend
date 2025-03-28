<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:template match="content">
       <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="//dmStatus/referencedApplicGroup"/>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*|node()">
		 <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="dmRef">
        <dmRef>
            <xsl:apply-templates select="node()"/>
        </dmRef>
    </xsl:template>
   
    
    <xsl:template match="internalRef">
		<internalRef internalRefId="{@internalRefId}">
		  <xsl:attribute name="internalRefTargetType">
			<xsl:choose>
			 <xsl:when test="@internalRefTargetType = 'para'">irtt02</xsl:when>
			  <xsl:when test="@internalRefTargetType = 'table'">irtt04</xsl:when>
			  <xsl:when test="@internalRefTargetType = 'supequip'">irtt05</xsl:when>
			   <xsl:when test="@internalRefTargetType = 'figure'">irtt06</xsl:when>
			   <xsl:when test="@internalRefTargetType = 'supply'">irtt07</xsl:when>
			   <xsl:when test="@internalRefTargetType = 'hotspot'">irtt11</xsl:when>
			</xsl:choose>
		  </xsl:attribute>
		  <xsl:apply-templates select="node()"/>
		</internalRef>
  </xsl:template>

    <xsl:template match="table">
        <table>
            <xsl:apply-templates select="@*|node()"/>
        </table>
    </xsl:template>

    <xsl:template match="thead/row">
        <row>
            <xsl:apply-templates select="@*|node()"/>
        </row>
    </xsl:template>

    <xsl:template match="colspec">
        <xsl:choose>
            <xsl:when test="@colname='1'">
                <colspec colname="1" colwidth="40mm"/>
            </xsl:when>
            <xsl:when test="@colname='2'">
                <colspec colname="2" colwidth="35mm"/>
            </xsl:when>
            <xsl:when test="@colname='3'">
                <colspec colname="3" colwidth="75mm"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="colspec/@colwidth[. = '*']">
        <xsl:attribute name="colwidth">
            <xsl:text>1.0*</xsl:text>
        </xsl:attribute>
    </xsl:template>
    
</xsl:stylesheet>