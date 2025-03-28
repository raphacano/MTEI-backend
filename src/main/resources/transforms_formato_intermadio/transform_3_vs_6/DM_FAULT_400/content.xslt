<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="content">
	  <content>
		 <xsl:if test="not(//afr/ifault)">
			 <xsl:apply-templates select="refs"/>
		 </xsl:if>
		 <xsl:apply-templates select="afi"/>
		 <xsl:apply-templates select="afr"/>
	  </content>
	</xsl:template>


    <xsl:template match="refs">
        <refs>
            <xsl:apply-templates select="refdm"/>
        </refs>
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


    <xsl:template match="afi">
        <faultIsolation>
            <xsl:apply-templates select="afi-proc"/>
        </faultIsolation>
    </xsl:template>


    <xsl:template match="afi-proc">
        <faultIsolationProcedure>
            <xsl:apply-templates select="fault"/>
            <faultDescr>
                <descr><xsl:value-of select="describe/fdesc"/></descr>
            </faultDescr>
            <xsl:apply-templates select="isoproc"/>
        </faultIsolationProcedure>
    </xsl:template>


    <xsl:template match="fault">
        <fault faultCode="{@fcode}"/>
    </xsl:template>


    <xsl:template match="isoproc">
        <isolationProcedure>
            <xsl:apply-templates select="prelreqs"/>
            <xsl:apply-templates select="isolatep"/>
        </isolationProcedure>
    </xsl:template>

 
    <xsl:template match="prelreqs">
        <preliminaryRqmts>
            <reqCondGroup>
                <xsl:apply-templates select="reqconds/*"/>
            </reqCondGroup>
            
            <xsl:apply-templates select="supequip"/>
            
            <reqSupplies>
                <xsl:apply-templates select="supplies/*"/>
            </reqSupplies>
            <reqSpares>
                <xsl:apply-templates select="spares/*"/>
            </reqSpares>
            <reqSafety>
                <xsl:apply-templates select="safety/*"/>
            </reqSafety>
        </preliminaryRqmts>
    </xsl:template>


	<xsl:template match="reqconds">
	
    	<reqCondGroup>
			<xsl:choose>
			  <xsl:when test="//reqcond">
					<reqCondDm>
						<xsl:apply-templates select="reqcond"/>
					</reqCondDm>
				</xsl:when>
			</xsl:choose>
		</reqCondGroup>
		
	</xsl:template>
	
	<!-- Corrected reqconds template to process children -->
<!--	<xsl:template match="reqconds">
		<reqCondGroup>
			<xsl:apply-templates select="*"/>
		</reqCondGroup>
	</xsl:template>
	
	<xsl:template match="reqcond">
		<reqCond>
			<xsl:value-of select="normalize-space()"/>
		</reqCond>
	</xsl:template>
	-->
	
	<xsl:template match="noconds">
		<noConds/>
    </xsl:template>
    
    <xsl:template match="nosupply">
		<noSupplies/>
    </xsl:template>
    
    <xsl:template match="nospares">
		<noSpares/>
    </xsl:template>
    
    <xsl:template match="nosafety">
		<noSafety/>
    </xsl:template>
	
    <xsl:template match="supplies">
    	<reqSupplies>
			<xsl:choose>
			  <xsl:when test="//supply">
					<suppliesDescrGroup>
						<xsl:apply-templates select="supply"/>
					</suppliesDescrGroup>
				</xsl:when>
			</xsl:choose>
		</reqSupplies>
    </xsl:template>

    <xsl:template match="spares">
    	<reqSpares>
			<xsl:choose>
			  <xsl:when test="//spare">
					<spareDescrGroup>
						<xsl:apply-templates select="spare"/>
					</spareDescrGroup>
				</xsl:when>
			</xsl:choose>
		</reqSpares>
    </xsl:template>
    
    <xsl:template match="safety">
		<reqSafety>
			<xsl:choose>
			  <xsl:when test="safecond/warning">
				  <safetyRqmts>
					<xsl:apply-templates select="safecond/warning"/>
				  </safetyRqmts>
				</xsl:when>
			</xsl:choose>	  
		</reqSafety>
	</xsl:template>
    
    <xsl:template match="supequip">
        <reqSupportEquips>
            <supportEquipDescrGroup>
                <xsl:apply-templates select="supeqli/supequi"/>
            </supportEquipDescrGroup>
        </reqSupportEquips>
    </xsl:template>

 
    <xsl:template match="supequi">
        <supportEquipDescr>
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <name><xsl:value-of select="nomen"/></name>
            <identNumber>
                <manufacturerCode><xsl:value-of select="identno/mfc"/></manufacturerCode>
                <partAndSerialNumber>
                    <partNumber><xsl:value-of select="identno/pnr"/></partNumber>
                </partAndSerialNumber>
            </identNumber>
            <reqQuantity unitOfMeasure="{qty/@uom}">
                <xsl:value-of select="qty"/>
            </reqQuantity>
        </supportEquipDescr>
    </xsl:template>


    <xsl:template match="isolatep">
        <isolationMainProcedure>
            <xsl:apply-templates select="*"/>
        </isolationMainProcedure>
        <closeRqmts>
                <reqCondGroup>
                    <noConds/>
                </reqCondGroup>
        </closeRqmts>
    </xsl:template>


    <xsl:template match="isostep">
        <isolationStep id="stp-{substring-after(@id, 'istp-')}">
            <action>
                <xsl:apply-templates select="action/node()"/>
            </action>
            <isolationStepQuestion>
                <xsl:value-of select="question"/>
            </isolationStepQuestion>
            <isolationStepAnswer>
                <xsl:apply-templates select="answer/*"/>
            </isolationStepAnswer>
        </isolationStep>
    </xsl:template>

    <xsl:template match="isoend">
        <isolationProcedureEnd id="stp-{substring-after(@id, 'istp-')}">
            <action>
                <xsl:apply-templates select="action/node()"/>
            </action>
        </isolationProcedureEnd>
    </xsl:template>


    <xsl:template match="xref">
        <internalRef internalRefId="{@xrefid}" internalRefTargetType="irtt05"/>
    </xsl:template>

    <xsl:template match="action//refdm">
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


    <xsl:template match="sel-list">
        <listOfChoices>
            <xsl:apply-templates select="choice"/>
        </listOfChoices>
    </xsl:template>

    <xsl:template match="choice">
        <choice nextActionRefId="stp-{substring-after(@refid, 'istp-')}">
            <xsl:value-of select="."/>
        </choice>
    </xsl:template>

 
    <xsl:template match="yesno">
        <yesNoAnswer>
            <yesAnswer nextActionRefId="stp-{substring-after(yes/@refid, 'istp-')}"/>
            <noAnswer nextActionRefId="stp-{substring-after(no/@refid, 'istp-')}"/>
        </yesNoAnswer>
    </xsl:template>


   <!--
		afr -> faultReporting
    -->
    

    <xsl:template match="afr">
        <faultReporting>
            <xsl:apply-templates select="dfault"/>
            <xsl:apply-templates select="ifault"/>
            <xsl:apply-templates select="cfault"/>
        </faultReporting>
    </xsl:template>


    <xsl:template match="dfault">
        <detectedFault id="{@id}" faultCode="{@fcode}">
            <xsl:apply-templates select="describe"/>
            <xsl:apply-templates select="detect"/>
            <xsl:apply-templates select="disolate"/>
            <xsl:apply-templates select="remarks"/>
        </detectedFault>
    </xsl:template>


    <xsl:template match="describe">
        <faultDescr>
            <descr><xsl:value-of select="fdesc"/></descr>
        </faultDescr>
    </xsl:template>


    <xsl:template match="detect">
        <detectionInfo detectionType="{@type}">
            <xsl:apply-templates select="delruitem"/>
        </detectionInfo>
    </xsl:template>

   
    <xsl:template match="delruitem">
        <detectedLruItem>
            <xsl:apply-templates select="lru"/>
        </detectedLruItem>
    </xsl:template>

   
    <xsl:template match="disolate">
        <isolateDetectedFault>
            <xsl:apply-templates select="lruitem"/>
        </isolateDetectedFault>
    </xsl:template>

    
    <xsl:template match="lruitem">
        <lruItem>
            <xsl:apply-templates select="lru"/>
        </lruItem>
    </xsl:template>

   
    <xsl:template match="lru">
        <lru>
            <name><xsl:value-of select="nomen"/></name>
            <identNumber>
                <manufacturerCode><xsl:value-of select="identno/mfc"/></manufacturerCode>
                <partAndSerialNumber>
                    <partNumber><xsl:value-of select="identno/pnr"/></partNumber>
                </partAndSerialNumber>
            </identNumber>
        </lru>
    </xsl:template>

 
    <xsl:template match="remarks">
        <remarks>
            <simplePara><xsl:apply-templates/></simplePara>
        </remarks>
    </xsl:template>
    

    <xsl:template match="ifault">
        <isolatedFault id="{@id}" faultCode="{@fcode}">
            <faultDescr>
                <descr><xsl:value-of select="describe/fdesc"/></descr>
            </faultDescr>
            <xsl:apply-templates select="locandrep"/>
        </isolatedFault>
    </xsl:template>

   
    <xsl:template match="locandrep">
        <locateAndRepair>
            <xsl:apply-templates select="lrlruitem"/>
        </locateAndRepair>
    </xsl:template>

   
    <xsl:template match="lrlruitem">
        <locateAndRepairLruItem>
            <xsl:apply-templates select="lru"/>
            <xsl:apply-templates select="repair"/>
        </locateAndRepairLruItem>
    </xsl:template>


    <xsl:template match="lru">
        <lru>
            <name><xsl:value-of select="nomen"/></name>
            <identNumber>
                <manufacturerCode><xsl:value-of select="identno/mfc"/></manufacturerCode>
                <partAndSerialNumber>
                    <partNumber><xsl:value-of select="identno/pnr"/></partNumber>
                </partAndSerialNumber>
            </identNumber>
        </lru>
    </xsl:template>


    <xsl:template match="repair">
        <repair>
            <refs>
                <xsl:apply-templates select="refs/refdm"/>
            </refs>
        </repair>
    </xsl:template>
    
    <xsl:template match="cfault">
        <correlatedFault id="{@id}">
            <basicCorrelatedFaults>
                <xsl:apply-templates select="msg-wmlf-desc/msgdesc"/>
            </basicCorrelatedFaults>
            <xsl:apply-templates select="disolate"/>
            <xsl:apply-templates select="remarks"/>
        </correlatedFault>
    </xsl:template>

    <xsl:template match="msgdesc">
        <bitMessage>
            <fault faultCode="{fault/@fcode}"/>
            <faultDescr>
                <descr><xsl:value-of select="describe/fdesc"/></descr>
            </faultDescr>
        </bitMessage>
    </xsl:template>


</xsl:stylesheet>