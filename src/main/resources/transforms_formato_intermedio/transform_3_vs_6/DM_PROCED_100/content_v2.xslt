<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xlink">


	<xsl:template match="content">
		<content>
		    <xsl:apply-templates select="refs"/>
			<procedure>
				<xsl:apply-templates select="proced/prelreqs"/>
				<xsl:apply-templates select="proced/mainfunc"/>
				<xsl:apply-templates select="proced/closereqs"/>
			</procedure>
		</content>
	</xsl:template>
	

  <!-- Mapea prelreqs a preliminaryRqmts -->
  <xsl:template match="prelreqs">
    <preliminaryRqmts>
      <xsl:apply-templates select="pmd"/>
      <xsl:apply-templates select="reqconds"/>
      <xsl:apply-templates select="reqpers"/>
      <!-- reqTechInfoGroup en XML2 no tiene fuente en XML1 -->
      <xsl:apply-templates select="supequip"/>
      <xsl:apply-templates select="supplies"/>
      <xsl:apply-templates select="spares"/>
      <xsl:apply-templates select="safety"/>
    </preliminaryRqmts>
  </xsl:template>

	<xsl:template match="refs">
        <refs>
            <xsl:apply-templates select="refdm"/>
        </refs>
    </xsl:template>
	
	<xsl:template match="refdm">
		<dmRef>
			<dmRefIdent>
				<xsl:if test="dmcextension">
					<identExtension extensionProducer="{dmcextension/dmeproducer}" extensionCode="{dmcextension/dmecode}"/>
				</xsl:if>
				
				<xsl:if test="avee">
					<dmCode modelIdentCode="{avee/modelic}" systemDiffCode="{avee/sdc}" systemCode="{avee/chapnum}" subSystemCode="{avee/section}" subSubSystemCode="{avee/subsect}" assyCode="{avee/subject}" disassyCode="{avee/discode}" 
					disassyCodeVariant="{avee/discodev}" infoCode="{avee/incode}" infoCodeVariant="{avee/incodev}" itemLocationCode="{avee/itemloc}"/>
				</xsl:if>
				
				<xsl:if test="age">
					<dmCode modelIdentCode="{age/modelic}" systemDiffCode="{age/supeqvc}" systemCode="{age/ecscs}" subSystemCode="{format-number(age/eidc, '0')}" subSubSystemCode="{format-number(age/cidc, '0')}" assyCode="{age/discode}" disassyCode="{age/discode}" 
					disassyCodeVariant="{age/discodev}" infoCode="{age/incode}" infoCodeVariant="{age/incodev}" itemLocationCode="{age/itemloc}"/>
				</xsl:if>
				

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
		</dmRef>
	</xsl:template>
	
  <!-- Mapea pmd a productionMaintData -->
  <xsl:template match="pmd">
    <productionMaintData>
      <!-- Mapea thi a thresholdInterval -->
      <thresholdInterval thresholdUnitOfMeasure="{thi/@uom}">
        <xsl:value-of select="thi"/>
      </thresholdInterval>
      <workAreaLocationGroup>
        <!-- Mapea zone a zoneRef -->
        <xsl:apply-templates select="zone"/>
        <!-- Mapea accpnl a accessPointRef -->
        <xsl:apply-templates select="accpnl"/>
        <!-- workLocation en XML2 template, no tiene fuente en XML1 -->
        <workLocation>
            <workArea>text</workArea>
            <internalRef>
                <subScript>String</subScript>
            </internalRef>
        </workLocation>
      </workAreaLocationGroup>
      <!-- Mapea opndurn a taskDuration -->
      <taskDuration startupDuration="{opndurn/@prelreqs}" procedureDuration="{opndurn/@proced}" closeupDuration="{opndurn/@closeup}">
           <!-- unitOfMeasure en XML2 template, no tiene fuente en XML1 -->
           <xsl:attribute name="unitOfMeasure">String</xsl:attribute>
      </taskDuration>
      <!-- avehcfg en XML1 no tiene mapeo en XML2 -->
    </productionMaintData>
  </xsl:template>

  <!-- Mapea zone a zoneRef -->
  <xsl:template match="zone">
    <zoneRef>
      <name><xsl:value-of select="nomen"/></name>
      <!-- shortName en XML2 template, no tiene fuente en XML1 -->
      <shortName>text</shortName>
      <refs>
        <!-- Mapea refdm dentro de zone a dmRef -->
        <xsl:apply-templates select="refs/refdm"/>
        <!-- reftp dentro de zone/refs en XML1 no tiene mapeo en XML2 -->
      </refs>
    </zoneRef>
  </xsl:template>

  <!-- Mapea accpnl a accessPointRef -->
  <xsl:template match="accpnl">
    <accessPointRef>
      <name><xsl:value-of select="nomen"/></name>
       <!-- shortName en XML2 template, no tiene fuente en XML1 -->
      <shortName>text</shortName>
      <refs>
        <!-- Mapea refdm dentro de accpnl a dmRef -->
        <xsl:apply-templates select="refs/refdm"/>
        <!-- reftp dentro de accpnl/refs en XML1 no tiene mapeo en XML2 -->
      </refs>
    </accessPointRef>
  </xsl:template>

  <!-- Mapea refdm (general) a dmRef -->
  <!-- Esta plantilla se aplica a cualquier refdm, ya sea en zone, accpnl o ein -->
<!--  <xsl:template match="refdm">
    <dmRef>
      <dmRefIdent>
        <identExtension extensionProducer="{dmcextension/dmeproducer}" extensionCode="{dmcextension/dmecode}"/>
        <dmCode modelIdentCode="{age/modelic}" systemCode="{age/ecscs}" infoCode="{age/eidc}" assyCode="{age/cidc}" disassyCode="{age/discode}" disassyCodeVariant="{age/discodev}" subSystemCode="{age/incode}" subSubSystemCode="{age/incodev}" itemLocationCode="{age/itemloc}">
            --><!-- Atributos con valores '0' o '00' en XML2 template sin fuente en XML1 --><!--
            <xsl:attribute name="systemDiffCode">0</xsl:attribute>
            <xsl:attribute name="infoCodeVariant">0</xsl:attribute>
        </dmCode>
        <issueInfo issueNumber="{issno/@issno}">
            --><!-- inWork en XML2 template sin fuente en XML1 --><!--
            <xsl:attribute name="inWork">00</xsl:attribute>
        </issueInfo>
        <language languageIsoCode="{language/@language}">
             --><!-- countryIsoCode en XML2 template sin fuente en XML1 --><!--
            <xsl:attribute name="countryIsoCode">AA</xsl:attribute>
        </language>
      </dmRefIdent>
      <dmRefAddressItems>
        <dmTitle>
          <techName><xsl:value-of select="dmtitle/techname"/></techName>
          <infoName><xsl:value-of select="dmtitle/infoname"/></infoName>
          --><!-- infoNameVariant en XML2 template, no tiene fuente en XML1 --><!--
          <infoNameVariant>text</infoNameVariant>
        </dmTitle>
        --><!-- issueDate en XML2 template, no tiene fuente en XML1 --><!--
        <issueDate year="0000" day="30" month="10"/>
      </dmRefAddressItems>
      --><!-- behavior en XML2 template, no tiene fuente en XML1 --><!--
      <behavior/>
    </dmRef>
  </xsl:template>-->

  <!-- Mapea reqconds a reqCondGroup -->
  <xsl:template match="reqconds">
    <reqCondGroup>
      <xsl:apply-templates select="noconds"/>
    </reqCondGroup>
  </xsl:template>

   <!-- Mapea noconds a noConds -->
  <xsl:template match="noconds">
    <noConds/>
  </xsl:template>

  <!-- Mapea reqpers a reqPersons -->
  <xsl:template match="reqpers">
    <reqPersons>
      <personnel>
        <!-- Mapea perscat/@category a personCategory/@personCategoryCode -->
        <personCategory personCategoryCode="{perscat/@category}"/>
        <!-- Mapea perskill/@skill a personSkill/@skillLevelCode -->
        <personSkill skillLevelCode="{perskill/@skill}"/>
        <!-- Mapea trade a trade -->
        <trade><xsl:value-of select="trade"/></trade>
        <!-- Mapea esttime a estimatedTime -->
        <estimatedTime>
            <xsl:attribute name="unitOfMeasure">String</xsl:attribute> <!-- unitOfMeasure en XML2 template, no tiene fuente en XML1 -->
            <xsl:value-of select="esttime"/>
        </estimatedTime>
        <!-- applic y asrequir en XML1 no tienen mapeo en XML2 template -->
      </personnel>
    </reqPersons>
  </xsl:template>

  <!-- Mapea supequip a reqSupportEquips -->
  <xsl:template match="supequip">
    <reqSupportEquips>
      <xsl:apply-templates select="nosupeq"/>
    </reqSupportEquips>
  </xsl:template>

  <!-- Mapea nosupeq a noSupportEquips -->
   <xsl:template match="nosupeq">
    <noSupportEquips/>
  </xsl:template>

  <!-- Mapea supplies a reqSupplies -->
  <xsl:template match="supplies">
    <reqSupplies>
      <xsl:apply-templates select="nosupply"/>
    </reqSupplies>
  </xsl:template>

  <!-- Mapea nosupply a noSupplies -->
   <xsl:template match="nosupply">
    <noSupplies/>
  </xsl:template>

  <!-- Mapea spares a reqSpares -->
  <xsl:template match="spares">
    <reqSpares>
      <xsl:apply-templates select="nospares"/>
    </reqSpares>
  </xsl:template>

   <!-- Mapea nospares a noSpares -->
  <xsl:template match="nospares">
    <noSpares/>
  </xsl:template>


  <!-- Mapea safety a reqSafety -->
  <xsl:template match="safety">
    <reqSafety>
      <xsl:apply-templates select="nosafety"/>
    </reqSafety>
  </xsl:template>

   <!-- Mapea nosafety a noSafety -->
  <xsl:template match="nosafety">
    <noSafety/>
  </xsl:template>


  <!-- Mapea mainfunc a mainProcedure -->
  <xsl:template match="mainfunc">
    <mainProcedure>
      <!-- Aplica plantillas a todos los elementos step* hijos para manejar la recursión -->
      <xsl:apply-templates select="*[starts-with(local-name(), 'step')]"/>
    </mainProcedure>
  </xsl:template>

  <!-- Mapea cualquier step* a proceduralStep (plantilla recursiva) -->
  <xsl:template match="*[starts-with(local-name(), 'step')]">
    <proceduralStep>
      <!-- Mapea title a title -->
      <xsl:apply-templates select="title"/>
      <!-- Mapea warning a warning -->
      <xsl:apply-templates select="warning"/>
      <!-- Mapea caution a caution -->
      <xsl:apply-templates select="caution"/>
      <!-- Mapea note a note -->
      <xsl:apply-templates select="note"/>

      <!-- applic dentro de step* en XML1 no tiene mapeo en XML2 template -->

      <!-- Aplica plantillas a elementos step* anidados -->
      <xsl:apply-templates select="*[starts-with(local-name(), 'step')]"/>
    </proceduralStep>
  </xsl:template>

  <!-- Mapea title (dentro de step*) -->
  <xsl:template match="title">
    <title>
      <functionalItemRef functionalItemNumber="{ein/@einnbr}">
         <!-- Mapea ein/nomen a name -->
        <name><xsl:value-of select="ein/nomen"/></name>
         <!-- shortName en XML2 template, no tiene fuente en XML1 -->
        <shortName>text</shortName>
        <refs>
          <!-- Mapea refdm dentro de ein a dmRef -->
          <xsl:apply-templates select="ein/refs/refdm"/>
          <!-- reftp dentro de ein/refs en XML1 no tiene mapeo en XML2 -->
        </refs>
      </functionalItemRef>
    </title>
  </xsl:template>

  <!-- Mapea warning (dentro de step*) -->
  <xsl:template match="warning">
    <warning>
      <!-- Mapea symbol/@boardno a symbol/@infoEntityIdent -->
      <xsl:if test="symbol/@boardno">
        <symbol infoEntityIdent="{symbol/@boardno}"/>
      </xsl:if>
      <!-- Generamos warningAndCautionPara solo si hay texto de aplicabilidad -->
      <xsl:if test="applic/displaytext/p/subscrpt">
          <warningAndCautionPara>
            <!-- AÑADIMOS el atributo required functionalItemNumber -->
            <functionalItemRef functionalItemNumber="N/A">
               <!-- Mapea applic/displaytext/p/subscrpt text a name -->
              <name><xsl:value-of select="applic/displaytext/p/subscrpt"/></name>
              <!-- shortName en XML2 template, no tiene fuente en XML1 -->
              <shortName>text</shortName>
              <!-- refs/dmRef en XML2 template no tiene fuente en XML1 -->
            </functionalItemRef>
             <!-- applic y assert en XML1 no tienen mapeo directo en XML2 template -->
          </warningAndCautionPara>
      </xsl:if>
       <!-- symbol/applic en XML1 no tiene mapeo en XML2 template -->
    </warning>
  </xsl:template>

  <!-- Mapea caution (dentro de step*) -->
 <xsl:template match="caution">
    <caution>
      <!-- Mapea symbol/@boardno a symbol/@infoEntityIdent -->
       <xsl:if test="symbol/@boardno">
        <symbol infoEntityIdent="{symbol/@boardno}"/>
      </xsl:if>
       <!-- Generamos warningAndCautionPara solo si hay texto de aplicabilidad -->
      <xsl:if test="applic/displaytext/p/subscrpt">
          <warningAndCautionPara>
             <!-- AÑADIMOS el atributo required functionalItemNumber -->
             <functionalItemRef functionalItemNumber="N/A">
              <!-- Mapea applic/displaytext/p/subscrpt text a name -->
              <name><xsl:value-of select="applic/displaytext/p/subscrpt"/></name>
              <!-- shortName en XML2 template, no tiene fuente en XML1 -->
              <shortName>text</shortName>
              <!-- refs/dmRef en XML2 template no tiene fuente en XML1 -->
            </functionalItemRef>
             <!-- applic y assert en XML1 no tienen mapeo directo en XML2 template -->
          </warningAndCautionPara>
      </xsl:if>
      <!-- symbol/applic en XML1 no tiene mapeo en XML2 template -->
    </caution>
  </xsl:template>

  <!-- Mapea note (dentro de step*) -->
 <xsl:template match="note">
    <note>
       <!-- Mapea symbol/@boardno a symbol/@infoEntityIdent -->
       <xsl:if test="symbol/@boardno">
        <symbol infoEntityIdent="{symbol/@boardno}"/>
      </xsl:if>
      <!-- Generamos notePara solo si hay texto de aplicabilidad -->
      <xsl:if test="applic/displaytext/p/subscrpt">
          <notePara>
             <!-- AÑADIMOS el atributo required functionalItemNumber -->
             <functionalItemRef functionalItemNumber="N/A">
              <!-- Mapea applic/displaytext/p/subscrpt text a name -->
              <name><xsl:value-of select="applic/displaytext/p/subscrpt"/></name>
              <!-- shortName en XML2 template, no tiene fuente en XML1 -->
              <shortName>text</shortName>
              <!-- refs/dmRef en XML2 template no tiene fuente en XML1 -->
            </functionalItemRef>
             <!-- applic y assert en XML1 no tienen mapeo directo en XML2 template -->
          </notePara>
      </xsl:if>
      <!-- symbol/applic en XML1 no tiene mapeo en XML2 template -->
    </note>
  </xsl:template>

  <!-- Mapea closereqs a closeRqmts -->
  <xsl:template match="closereqs">
    <closeRqmts>
      <xsl:apply-templates select="reqconds"/>
    </closeRqmts>
  </xsl:template>

  <!-- Ignora los elementos applic ya que se manejan casos específicos -->
<!--  <xsl:template match="applic"/>-->
  <!-- Ignora assert -->
<!--  <xsl:template match="assert"/>
  --><!-- Ignora reftp --><!--
  <xsl:template match="reftp"/>
  --><!-- Ignora avehcfg --><!--
  <xsl:template match="avehcfg"/>
   --><!-- Ignora asrequir --><!--
  <xsl:template match="asrequir"/>
   --><!-- Ignora symbol/applic --><!--
  <xsl:template match="symbol/applic"/>-->


</xsl:stylesheet>