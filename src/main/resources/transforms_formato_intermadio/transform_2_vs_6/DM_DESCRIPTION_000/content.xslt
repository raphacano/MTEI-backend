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
		  
		  <xsl:when test="descript/para0[not(table)]">
			  <xsl:apply-templates select="descript"/>
		  </xsl:when>
		  
		  <xsl:otherwise>
			<description>
			  <xsl:choose>
				<xsl:when test="descript/para0/table">
				  <levelledPara>
					<title>
					  <xsl:value-of select="descript/para0/title"/>
					</title>
					<para>
					  <xsl:apply-templates select="descript/para0/para/node()"/>
					</para>
					<foldout>
					  <xsl:apply-templates select="descript/para0/figure"/>
					</foldout>
					<para>
					  <xsl:apply-templates select="descript/para0/para[2]/node()"/>
					</para>
					<table id="tab-0001">
					  <title>
						<xsl:value-of select="descript/para0/table/title"/>
					  </title>
					  <tgroup cols="3">
						<colspec colname="1"/>
						<colspec colname="2"/>
						<colspec colname="3"/>
						<thead>
						  <row>
							<entry>
							  <para>Item</para>
							</entry>
							<entry>
							  <para>Refer to</para>
							</entry>
							<entry>
							  <para>Definition</para>
							</entry>
						  </row>
						</thead>
						<tbody>
						  <xsl:apply-templates select="descript/para0/table/tgroup/tbody/row"/>
						</tbody>
					  </tgroup>
					</table>
				  </levelledPara>
				  <xsl:apply-templates select="descript//para[not(ancestor::para0)]"/>
				</xsl:when>
				
				<xsl:otherwise>
				  <xsl:apply-templates select="descript//para"/>
				</xsl:otherwise>
			  </xsl:choose>
			</description>
		  </xsl:otherwise>
		  
		</xsl:choose>
	
	  </content>
	</xsl:template>
	
	
	<xsl:template match="descript">
        <description>
            <xsl:apply-templates select="para0"/>
        </description>
    </xsl:template>


    <xsl:template match="para0">
        <levelledPara>
            <title><xsl:value-of select="title"/></title>
            <xsl:apply-templates select="* except title"/>
        </levelledPara>
    </xsl:template>

<!--    <xsl:template match="figure">
        <figure id="{@id}">
            <title><xsl:value-of select="title"/></title>
            <xsl:apply-templates select="graphic"/>
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
        </figure>
    </xsl:template>-->


    <xsl:template match="graphic">
        <graphic infoEntityIdent="{@boardno}">
            <xsl:apply-templates select="hotspot"/>
        </graphic>
    </xsl:template>


<!--    <xsl:template match="para">
        <para>
            <xsl:apply-templates select="node()"/>
        </para>
    </xsl:template>-->

    <xsl:template match="item">
        <listItem>
            <para><xsl:apply-templates/></para>
        </listItem>
    </xsl:template>

    <xsl:template match="xref">
        <internalRef internalRefId="{@xrefid}"><xsl:value-of select="."/></internalRef>
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
        <xsl:copy>
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
        <table id="tab-{count(preceding::table) + 1}">
            <title><xsl:value-of select="title"/></title>
            <tgroup cols="{tgroup/@cols}">
                <xsl:apply-templates select="tgroup/*"/>
                <tfoot>
                    <row>
                        <entry namest="1" nameend="{tgroup/@cols}">
                            <para>All parts can be procured from any certified part distributor</para>
                        </entry>
                    </row>
                </tfoot>
            </tgroup>
        </table>
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
            <xsl:apply-templates select="item"/>
        </randomList>
    </xsl:template>

    <xsl:template match="randlist/item">
        <listItem>
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
        </listItem>
    </xsl:template>
    
<!--     <xsl:template match="deflist">
        <definitionList>
            <xsl:apply-templates select="term|def"/>
        </definitionList>
    </xsl:template>-->
    
    <xsl:template match="deflist">
        <definitionList>
            <definitionListHeader>
                <termTitle>Component</termTitle>
                <definitionTitle>Functional description</definitionTitle>
            </definitionListHeader>
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
    
    <xsl:template match="def">
        <listItemDefinition>
            <para>
                <xsl:apply-templates select="node()"/>
            </para>
        </listItemDefinition>
    </xsl:template>

    <xsl:template match="term">
        <definitionListItem>
            <listItemTerm><xsl:value-of select="."/></listItemTerm>
        </definitionListItem>
    </xsl:template>


    
</xsl:stylesheet>