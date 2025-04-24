<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:template match="content">
	  <content>
		<xsl:choose>
		
		  <xsl:when test="acrw/descacrw">
			<refs>
			  <xsl:apply-templates select="refs/refdm"/>
			</refs>
            <crew>
                <descrCrew>
                    <xsl:apply-templates select="acrw/descacrw/*"/>
                </descrCrew>
            </crew>
		  </xsl:when>	
		  	
		  <xsl:when test="refs/refdm">
			<refs>
			  <xsl:apply-templates select="refs/refdm"/>
			</refs>
			<description>
			  <levelledPara>
				<title>
				  <xsl:value-of select="descript/para0/title"/>
				</title>
				<para>
				  <xsl:apply-templates select="descript/para0/para/node()"/>
				</para>
			  </levelledPara>
			</description>
		  </xsl:when>
		  
		  <xsl:when test="descript/para0">
					<xsl:apply-templates select="descript"/>
		   </xsl:when>
		  
		</xsl:choose>
	
	  </content>
	</xsl:template>
	
	
    
    <xsl:template match="descript">
        <description>
            <xsl:apply-templates/>
        </description>
    </xsl:template>
    
     <xsl:template match="para0">
        <levelledPara>
            <xsl:apply-templates/>
        </levelledPara>
    </xsl:template>


    <xsl:template match="figure">
        <figure id="{@id}">
            <title><xsl:value-of select="title"/></title>
            <xsl:apply-templates select="graphic"/>
            
            <xsl:if test="legend/deflist/term">
				<legend>
					<definitionList>
						<xsl:for-each select="legend/deflist/term">
							<definitionListItem>
								<listItemTerm><xsl:value-of select="."/></listItemTerm>
								<listItemDefinition>
									<para><xsl:value-of select="following-sibling::def[1]"/></para>
								</listItemDefinition>
							</definitionListItem>
						</xsl:for-each>
					</definitionList>
				</legend>
            </xsl:if>
            
        </figure>
    </xsl:template>


    <xsl:template match="graphic">
        <graphic infoEntityIdent="{@boardno}" >
            <xsl:apply-templates select="hotspot"/>
        </graphic>
    </xsl:template>


	<xsl:template match="para">
		<para>
			<xsl:apply-templates select="@* | node()"/>
		</para>
	</xsl:template>

	<xsl:template match="entry[not(para)]">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*"/>
			<para>
				<xsl:apply-templates select="node()"/>
			</para>
		</xsl:copy>
	</xsl:template>

    <xsl:template match="xref">
		<internalRef internalRefId="{@xrefid}">
		  <xsl:attribute name="internalRefTargetType">
			<xsl:choose>
			  <xsl:when test="@xidtype = 'supply'">irtt04</xsl:when>
			  <xsl:when test="@xidtype = 'supequip'">irtt05</xsl:when>
			   <xsl:when test="@xidtype = 'figure'">irtt06</xsl:when>
			   <xsl:when test="@xidtype = 'hotspot'">irtt07</xsl:when>
			   <xsl:when test="@xidtype = 'table'">irtt03</xsl:when>
			   <xsl:when test="@xidtype = 'para'">irtt02</xsl:when>
			</xsl:choose>
		  </xsl:attribute>
		</internalRef>
   </xsl:template>

	 <xsl:template match="item">
        <listItem>
            <xsl:apply-templates/>
        </listItem>
    </xsl:template>

	<xsl:template match="subpara1|subpara2|subpara3|subpara4|subpara5|subpara6|subpara7">
		<levelledPara>
		  <xsl:if test="title">
			<title><xsl:value-of select="title"/></title>
		  </xsl:if>
		  <xsl:apply-templates select="*[not(self::title)]"/>
		</levelledPara>
	</xsl:template>


	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
   

	 <xsl:template match="entry">
        <entry>
            <xsl:choose>
                <xsl:when test="para">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <para>
                        <xsl:apply-templates/>
                    </para>
                </xsl:otherwise>
            </xsl:choose>
        </entry>
    </xsl:template>
    
    <xsl:template match="applic">
        <applic>
            <displayText><simplePara><xsl:value-of select="displaytext"/></simplePara></displayText>
            <xsl:apply-templates select="evaluate"/>
        </applic>
    </xsl:template>
  

	<xsl:template match="refdm">
        <dmRef>
            <dmRefIdent>
            
                <dmCode modelIdentCode="{avee/modelic}"
                    systemDiffCode="{avee/sdc}"
                    systemCode="{avee/chapnum}"
                    subSystemCode="{avee/section}"
                    subSubSystemCode="{avee/subsect}"
                    assyCode="{avee/subject}"
                    disassyCode="{avee/discode}"
                    disassyCodeVariant="{avee/discodev}"
                    infoCode="{avee/incode}"
                    infoCodeVariant="{avee/incodev}"
                    itemLocationCode="{avee/itemloc}"/>
                  
            </dmRefIdent>
            <dmRefAddressItems>
                <dmTitle>
                    <techName><xsl:value-of select="dmtitle/techname"/></techName>
                    <infoName><xsl:value-of select="dmtitle/infoname"/></infoName>
                </dmTitle>
            </dmRefAddressItems>
        </dmRef>
    </xsl:template>

    <xsl:template match="hotspot">
        <hotspot id="{@id}"
                 applicationStructureIdent="{@apsid}"
                 applicationStructureName="{@apsname}"
                 hotspotType="{@type}"
                 hotspotTitle="{@title}"
                 objectDescr="{@descript}"/>
    </xsl:template>

   
    
    <xsl:template match="table">
        <table>
            <xsl:apply-templates select="@*|node()"/>
        </table>
    </xsl:template>


	<xsl:template match="title">
		<title>
			<xsl:apply-templates select="@* | node()"/>
		</title>
	</xsl:template>
	
	<xsl:template match="tgroup">
		<tgroup>
			<xsl:apply-templates select="@* | node()"/>
		</tgroup>
	</xsl:template>

    <xsl:template match="colspec">
        <colspec colname="{@colname}">
            <xsl:if test="@colname = '2'">
                <xsl:attribute name="colwidth">35mm</xsl:attribute>
            </xsl:if>
            <xsl:if test="@colname = '3'">
                <xsl:attribute name="colwidth">75mm</xsl:attribute>
            </xsl:if>
        </colspec>
    </xsl:template>

    
      <xsl:template match="randlist">
        <randomList listItemPrefix="{@prefix}">
            <xsl:for-each select="item">
                <listItem>
                    <para><xsl:value-of select="."/></para>
                </listItem>
            </xsl:for-each>
        </randomList>
    </xsl:template>

    <xsl:template match="randlist/item">
        <listItem>
            <xsl:apply-templates/>
        </listItem>
    </xsl:template>
    
    <xsl:template match="acronym">
		<acronym reasonForUpdateRefIds="{@id}" 
				  derivativeClassificationRefId="{@id}" id="{@id}" controlAuthorityRefs="{@id}">
		  <xsl:apply-templates select="node()"/>
		</acronym>
  </xsl:template>

  <xsl:template match="acroterm">
		<acronymTerm>
		  <xsl:apply-templates select="node()"/>
		</acronymTerm>
  </xsl:template>

  <xsl:template match="acrodef">
    <acronymDefinition reasonForUpdateRefIds="{ancestor::acronym/@id}" 
                       derivativeClassificationRefId="{ancestor::acronym/@id}"
                       controlAuthorityRefs="{ancestor::acronym/@id}">
      <xsl:apply-templates select="node()"/>
    </acronymDefinition>
  </xsl:template>

	<xsl:template match="subscrpt">
		<subScript>
		  <xsl:apply-templates select="node()"/>
		</subScript>
	</xsl:template>
  
	
	<xsl:template match="deflist">
        <definitionList>
<!--            <definitionListHeader>
                <termTitle>Component</termTitle>
                <definitionTitle>Functional description</definitionTitle>
            </definitionListHeader>-->
            <xsl:for-each select="term">
                <definitionListItem>
                    <listItemTerm>
                        <xsl:value-of select="."/>
                    </listItemTerm>
                    <xsl:apply-templates select="following-sibling::def[1]"/>
                </definitionListItem>
            </xsl:for-each>
        </definitionList>
    </xsl:template>
	
	  <xsl:template match="term">
        <definitionListItem>
            <listItemTerm><xsl:value-of select="."/></listItemTerm>
        </definitionListItem>
    </xsl:template>

    <xsl:template match="def">
        <listItemDefinition>
            <para><xsl:apply-templates select="node()"/></para>
        </listItemDefinition>
    </xsl:template>
    
    <xsl:template match="item">
        <listItem>
            <para><xsl:apply-templates/></para>
        </listItem>
    </xsl:template>

    
</xsl:stylesheet>