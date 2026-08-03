<?xml version="1.0" encoding="utf-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">
 <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="removeplus">+</xsl:variable>
	<xsl:variable name="replaceplus"> </xsl:variable>
	<xsl:variable name="removepercent">%</xsl:variable>
	<xsl:variable name="replacepercent"/>
	<xsl:variable name="removeft">ft.</xsl:variable>
	<xsl:variable name="replaceft"/>
	<xsl:variable name="removebab">+/</xsl:variable>
	<xsl:variable name="replacebab"/>
	
	<xsl:variable name="removeNewline">#10;</xsl:variable>
	<xsl:variable name="replaceNewline"><br/></xsl:variable>
	<xsl:template name="format-literal-content-helper">
		<xsl:param name="text"/>
		<xsl:variable name="linebreak" select="'&#xA;'"/>
		<xsl:choose>
		<xsl:when test="contains($text,$linebreak)">
			<xsl:value-of disable-output-escaping="yes" select="substring-before($text,$linebreak)"/>
			<br/>
			<xsl:call-template name="format-literal-content-helper">
			<xsl:with-param name="text" select="substring-after($text,$linebreak)"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise><xsl:value-of disable-output-escaping="yes" select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
 
  <xsl:output encoding="utf-8" method="html"/>

  <xsl:template match="/">

    <!-- Add a proper DOCTYPE declaration here, to make sure the page is rendered
        properly. Firefox doesn't need this, so we make sure it doesn't get
        output when we're using "Transformiix", the Firefox XSLT processor.
        NOTE: This weird behaviour is only an issue if you have this stylesheet
            directly linked from an XML document, i.e. if you're trying to test
            it without having to tell HL to regenerate the XML file every time.
    -->
    <xsl:if test="system-property('xsl:vendor') != 'Transformiix'">
      <xsl:text disable-output-escaping="yes">
        &lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
          "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"&gt;
        </xsl:text>
      </xsl:if>
    <html>
      <head>

      <!-- XHTML requires that you specify a meta-tag to dictate the content type.
      -->
      <xsl:text disable-output-escaping="yes">
      &lt;meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1"/&gt;
      </xsl:text>
      <style type="text/css">
                    @media print  { .noprint  { display: none; }}
                    @page :left {
                        margin-left: 0.25in;
                        margin-right: 0.5in;
                        margin-top: 0.4in;
                        margin-bottom: 0.5in;
                    }
                    @page :right {
                        margin-left: 0.5in;
                        margin-right: 0.25in;
                        margin-top: 0.4in;
                        margin-bottom: 0.5in;
                    }
					font {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10px;
						font-weight: normal;
					}
					.headline {
						background-color: #000000;
						color: #FFFFFF;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 14px;
						font-weight: bold;
						text-transform: uppercase;
					}
					.tinytext {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 6px;
						font-weight: normal;
						text-transform: uppercase;
						line-height: 6px;
						display: block;
					}
					.smalltext {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 8px;
						font-weight: normal;
						text-transform: uppercase;
						display: block;
					}
					.mediumtext {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 9px;
						font-weight: normal;
						text-transform: uppercase;
					}
					.headtext {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 9px;
						font-weight: normal;
					}
					.normaltext {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 9px;
						font-weight: normal;
						display: block;
					}
					.largetextnormal {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 12px;
						font-weight: normal;
						text-transform: uppercase;
					}
					.largetext {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 12px;
						font-weight: bold;
						text-transform: uppercase;
					}
					.largetextwhite {
						color: #ffffff;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 12px;
						font-weight: bold;
						text-transform: uppercase;
					}
					.smallwritein {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 9px;
						font-weight: normal;
						text-transform: uppercase;
					}
					.largewritein {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 12px;
						font-weight: normal;
						text-transform: uppercase;
					}
					.box {
						border-right: #000000 1px solid;
						border-top: #000000 1px solid;
						border-left: #000000 1px solid;
						border-bottom: #000000 1px solid;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10px;
						background-color: #FFFFFF;
					}
					.boxgrey {
						border-right: #000000 1px solid;
						border-top: #000000 1px solid;
						border-left: #000000 1px solid;
						border-bottom: #000000 1px solid;
						font-family: bookman old style,times new roman,book antiqua,arial;
						background-color: #DDDDDD;
					}
					.boxwhite {
						border-right: #FFFFFF 1px solid;
						border-top: #FFFFFF 1px solid;
						border-left: #FFFFFF 1px solid;
						border-bottom: #FFFFFF 1px solid;
						background-color: #FFFFFF;
					}
					.writeinline {
						border-bottom: #000000 1px solid;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10px;
						display: block;
					}
					.writein {
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10px;
					}
					.largewritten {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 14px;
						font-weight: normal;
					}
                    .tlcorner {
                        height:11px;
                        width:18px; 
                        -moz-border-radius-bottomright:18px 11px; 
                        border-bottom-right-radius:18px 11px; 
                        background-color:white;
                    }
                    .trcorner {
                        height:11px;
                        width:18px; 
                        -moz-border-radius-bottomleft:18px 11px; 
                        border-bottom-left-radius:18px 11px; 
                        background-color:white;
                    }
                    .blcorner {
                        height:11px;
                        width:18px; 
                        -moz-border-radius-topright:18px 11px; 
                        border-top-right-radius:18px 11px; 
                        background-color:white;
                    }
                    .brcorner {
                        height:11px;
                        width:18px; 
                        -moz-border-radius-topleft:18px 11px; 
                        border-top-left-radius:18px 11px; 
                        background-color:white;
                    }
					.turningHeader {
						color: #FFFFFF;
						background-color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10px;
						font-weight: bold;
					}
					.turningLine {
						color: #000000;
						background-color: #FFFFFF;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10px;
						font-weight: normal;
					}
					.containerHeader {
						color: #FFFFFF;
						background-color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10px;
						font-weight: bold;
					}
					.inventoryHeader {
						color: #000000;
						background-color: #DDDDDD;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10px;
						font-weight: bold;
					}
					.spellListHeader {
						color: #000000;
						background-color: #DDDDDD;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10px;
						font-weight: bold;
					}
					.spellListHeader2 {
						color: #FFFFFF;
						background-color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10px;
						font-weight: bold;
					}
					.spellListHeaderPerDay {
						color: #000000;
						background-color: #FFFFFF;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10px;
						font-weight: bold;
					}
					.spelltext {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 5pt;
						font-weight: normal;
					}
					.skillx {
						color: #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 9px;
						line-height: 9px;
						margin-top: 0px;
						margin-bottom: 0px;
						font-weight: normal;
					}
					A {
						color: #000000;
						text-decoration: none;
					}
					.boxes {
						color: #000000;
						font-family: wingdings;
						font-size: 14px;
						font-weight: normal;
					}
					.v1 {
					FONT-SIZE: 1pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v2 {
					FONT-SIZE: 2pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v3 {
					FONT-SIZE: 3pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v4 {
					FONT-SIZE: 4pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v4_5 {
					FONT-SIZE: 4.5pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v5 {
					FONT-SIZE: 5pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v5_5 {
					FONT-SIZE: 5.5pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v6 {
					FONT-SIZE: 6pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v7 {
					FONT-SIZE: 7pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v8 {
					FONT-SIZE: 8pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v9 {
					FONT-SIZE: 9pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v10 {
					FONT-SIZE: 10pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v5sc {
					FONT-SIZE: 5pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial; font-variant: small-caps;
					}
					.v6sc {
					FONT-SIZE: 6pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial; font-variant: small-caps;
					}
					.v7sc {
					FONT-SIZE: 7pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial; font-variant: small-caps;
					}
					.v8sc {
					FONT-SIZE: 8pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial; font-variant: small-caps;
					}
					.v9sc {
					FONT-SIZE: 9pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial; font-variant: small-caps;
					}
					.v10sc {
					FONT-SIZE: 10pt; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial; font-variant: small-caps;
					}
					.v4_5w {
					background-color: black;
					FONT-SIZE: 4.5pt; COLOR: white; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v5w {
					background-color: black;
					FONT-SIZE: 5pt; COLOR: white; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v6w {
					background-color: black;
					FONT-SIZE: 6pt; COLOR: white; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v7w {
					background-color: black;
					FONT-SIZE: 7pt; COLOR: white; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v8w {
					background-color: black;
					FONT-SIZE: 8pt; COLOR: white; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v9w {
					background-color: black;
					FONT-SIZE: 9pt; COLOR: white; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v10w {
					background-color: black;
					FONT-SIZE: 10pt; COLOR: white; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial
					}
					.v10wsc {
					background-color: gray;
					FONT-SIZE: 10pt; COLOR: white; FONT-FAMILY: bookman old style,times new roman,book antiqua,arial; font-variant: small-caps;
					}
					/* Armidale Codex v3.18: print-safe portrait watermark and
					   restrained field colors within the official black framework. */
					.codex-page { position: relative; }
					.codex-page-one { overflow: hidden; }
					.codex-page-content { position: relative; z-index: 2; }
					.codex-watermark {
						position: absolute; top: 3.25in; left: 18%; width: 64%; height: 7.0in;
						z-index: 0; text-align: center; overflow: hidden; pointer-events: none;
					}
					.codex-watermark img {
						max-width: 100%; max-height: 100%; opacity: 0.30;
						filter: grayscale(100%);
						-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=30)";
					}
					.codex-page-one .writeinline {
						background-color: #f2f6fa;
						background-color: rgba(226, 235, 245, 0.46);
					}
					.codex-page-one .box {
						background-color: #ffffff;
						background-color: rgba(255, 255, 255, 0.78);
					}
					.codex-race-field { width: 25%; max-width: 25%; overflow: hidden; }
					.codex-race-value {
						display: block; width: 100%; overflow: hidden;
						white-space: nowrap; text-overflow: ellipsis;
					}
					/* Compact, color-keyed page-one treatment based on the
					   Armidale 3.17 Aristea output. */
					.codex-page-one .codex-accent-initiative { background-color: rgba(91, 218, 207, 0.90) !important; }
					.codex-page-one .codex-accent-defense { background-color: rgba(132, 238, 116, 0.90) !important; }
					.codex-page-one .codex-accent-save { background-color: rgba(244, 224, 101, 0.90) !important; }
					.codex-page-one .codex-accent-combat { background-color: rgba(255, 132, 145, 0.88) !important; }
					.codex-page-one .codex-skill-row { height: 9px !important; line-height: 8px !important; }
					.codex-page-one .codex-skill-row td {
						font-size: 6.3pt !important; line-height: 7.2pt !important;
						padding: 0 !important; border-bottom: 1px dotted #888888;
					}
					.codex-page-one .codex-skill-row td.writeinline {
						display: table-cell; background: transparent;
					}
					.codex-page-one .codex-skill-check table { width: 8px !important; }
					.codex-page-one .codex-skill-check td { border: 0; font-size: 6pt !important; }
					.codex-page-one .codex-skill-class { background-color: rgba(72, 143, 157, 0.92) !important; color: #ffffff; }
					.codex-page-one .codex-trained-marker { color: #b77c00; font-weight: bold; }
					.codex-page-one .codex-skill-total { background-color: rgba(221, 226, 230, 0.90) !important; font-weight: bold; }
					.codex-page-one .codex-skill-component { background-color: rgba(245, 247, 249, 0.68) !important; }
					.codex-page-one .codex-conditional-row { display: none; }
					.codex-page-one .codex-languages-header {
						background: #000000; color: #ffffff; text-align: center;
						font-weight: bold; text-transform: uppercase; padding: 2px 0;
					}
					.codex-page-one .codex-weapon-entry .v10 { font-size: 7pt !important; line-height: 8pt !important; }
					.codex-page-one .codex-weapon-entry .v10w { font-size: 8pt !important; line-height: 8pt !important; }
					.codex-section { width: 100%; border-collapse: collapse; margin: 0 0 10px 0; }
					.codex-section th {
						background-color: #000000; color: #ffffff;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 10pt; text-transform: uppercase; padding: 4px 8px;
					}
					.codex-section td {
						border: 1px solid #000000;
						font-family: bookman old style,times new roman,book antiqua,arial;
						font-size: 8pt; padding: 4px 6px; vertical-align: top;
					}
					.codex-label {
						background-color: #dddddd; font-size: 6pt !important;
						font-weight: bold; text-transform: uppercase;
					}
					.codex-value-blue { background-color: #e7eff8; font-size: 10pt !important; text-align: center; }
					.codex-value-gold { background-color: #f4ead3; font-size: 10pt !important; text-align: center; }
					.codex-value-violet { background-color: #eee4f3; font-size: 10pt !important; text-align: center; }
					.codex-value-green { background-color: #e6efe7; font-size: 10pt !important; text-align: center; }
					.codex-note { color: #444444; font-size: 7pt; }
      </style>

<script type="text/javascript">
<xsl:text disable-output-escaping="yes">
&lt;!--
function toggleLayer(whichLayer)
{
    var elem, vis, onval;
    var arr = document.getElementsByName(whichLayer);
    for (var i = 0; i &lt; arr.length; i++) {
        elem = arr.item(i);
        onval = (elem.localName=='tr') ? 'table-row' : 'block';
        vis = elem.style;  // if the style.display value is blank we try to figure it out here
        if (vis.display=='' &amp;&amp; elem.offsetWidth!=undefined &amp;&amp; elem.offsetHeight!=undefined)
            vis.display = (elem.offsetWidth!=0 &amp;&amp; elem.offsetHeight!=0) ? onval : 'none';
        vis.display = (vis.display=='' || vis.display==onval) ? 'none' : onval;
    }
}
function toggleLayers(a,b)
{
    toggleLayer(a);
    toggleLayer(b);
}
//--&gt;
</xsl:text>
</script>

      <!-- Page title - just find the first hero and use its name  -->
      <title>
       <xsl:choose>
        <xsl:when test="count(/document/public/character) = 1">
         <xsl:value-of select="/document/public/character/@name"/>
        </xsl:when> 
        <xsl:otherwise>Portfolio</xsl:otherwise>
       </xsl:choose>
      </title>
      </head>

    <body>

      <!-- Output all our hero nodes in turn
        NOTE: We use //hero to ensure that we pick up minions as well, since
            they're children of heroes
        -->
      <xsl:apply-templates select="/document/public/character"/>

      </body>
    </html>
  </xsl:template>

  <!-- How to output each hero in the document -->
  <xsl:template match="character">
   <xsl:variable name="pfs" select="count(factions/faction) &gt; 0" />

 <!-- Display "Output Options" screen-only header. -->
 <div class="noprint" style="background-color: #c0c0c0; border: 2px solid black;">
  <b>Output Options</b><br/>

  <input type="checkbox">
   <xsl:attribute name="onclick">javascript:toggleLayers('weapondetails<xsl:value-of select="position()"/>','noweapondetails<xsl:value-of select="position()"/>');</xsl:attribute>
   <xsl:if test="contains(settings/@summary, 'Always Print 2-Weapon Attacks')">
    <xsl:attribute name="checked">checked</xsl:attribute>
   </xsl:if>
  </input>
    Always Print 2-Weapon Attacks<br/>

  <xsl:if test="personal/description != ''">
   <input type="checkbox">
    <xsl:attribute name="onclick">javascript:toggleLayer('backgrounddetails<xsl:value-of select="position()"/>');</xsl:attribute>
    <xsl:if test="contains(settings/@summary, 'Hide Background Details')">
     <xsl:attribute name="checked">checked</xsl:attribute>
    </xsl:if>
   </input>
     Hide Background Details<br/>
  </xsl:if>

  <input type="checkbox">
   <xsl:attribute name="onclick">javascript:toggleLayers('inlinemaneuvers<xsl:value-of select="position()"/>','noinlinemaneuvers<xsl:value-of select="position()"/>');</xsl:attribute>
   <xsl:if test="count(journals/journal[@name='Hide Maneuvers In Weapon Block']) != 0">
    <xsl:attribute name="checked">checked</xsl:attribute>
   </xsl:if>
  </input>
    Hide Maneuvers In Weapon Block<br/>

  <input type="checkbox">
   <xsl:attribute name="onclick">javascript:toggleLayer('trackingboxes<xsl:value-of select="position()"/>');</xsl:attribute>
   <xsl:if test="count(journals/journal[@name='Hide Tracking Boxes']) != 0">
    <xsl:attribute name="checked">checked</xsl:attribute>
   </xsl:if>
  </input>
    Hide Tracking Boxes<br/>

  <input type="checkbox">
   <xsl:attribute name="onclick">javascript:toggleLayer('unusableskill<xsl:value-of select="position()"/>');</xsl:attribute>
   <xsl:if test="contains(settings/@summary, 'Hide Unusable Skills')">
    <xsl:attribute name="checked">checked</xsl:attribute>
   </xsl:if>
  </input>
    Hide Unusable Skills<br/>

  <input type="checkbox">
   <xsl:attribute name="onclick">javascript:toggleLayer('abilitydesc<xsl:value-of select="position()"/>');</xsl:attribute>
   <xsl:if test="contains(settings/@summary, 'Show Feat / Ability Descriptions')">
    <xsl:attribute name="checked">checked</xsl:attribute>
   </xsl:if>
  </input>
    Show Feat / Ability Descriptions<br/>

  <div>
   <xsl:attribute name="id">abilitydesc<xsl:value-of select="position()"/></xsl:attribute>
   <xsl:attribute name="name">abilitydesc<xsl:value-of select="position()"/></xsl:attribute>
   <xsl:choose>
    <xsl:when test="contains(settings/@summary, 'Show Feat / Ability Descriptions')">
     <xsl:attribute name="style">display:block;</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
     <xsl:attribute name="style">display:none;</xsl:attribute>
    </xsl:otherwise>
   </xsl:choose>
   <xsl:text>&#160;&#160;&#160;&#160;&#160;</xsl:text>
   <input type="checkbox">
    <xsl:attribute name="onclick">javascript:toggleLayer('commonproficiency<xsl:value-of select="position()"/>');</xsl:attribute>
    <xsl:if test="count(journals/journal[@name='Hide Common Proficiencies']) != 0">
     <xsl:attribute name="checked">checked</xsl:attribute>
    </xsl:if>
   </input>
     Hide Common Proficiencies<br/>
  </div>

  <input type="checkbox">
   <xsl:attribute name="onclick">javascript:toggleLayer('portrait<xsl:value-of select="position()"/>');</xsl:attribute>
   <xsl:if test="contains(settings/@summary, 'Show Hero Portrait')">
    <xsl:attribute name="checked">checked</xsl:attribute>
   </xsl:if>
  </input>
    Show Hero Portrait<br/>

  <input type="checkbox">
   <xsl:attribute name="onclick">javascript:toggleLayer('maneuvers<xsl:value-of select="position()"/>');</xsl:attribute>
   <xsl:if test="count(journals/journal[@name='Show Maneuvers Table']) != 0">
    <xsl:attribute name="checked">checked</xsl:attribute>
   </xsl:if>
  </input>
     Show Maneuvers Table<br/>

  <xsl:if test="count(*/spell) != 0">
   <input type="checkbox">
    <xsl:attribute name="onclick">javascript:toggleLayer('spelldesc<xsl:value-of select="position()"/>');</xsl:attribute>
    <xsl:if test="count(journals/journal[@name='Show Spell Descriptions']) != 0">
     <xsl:attribute name="checked">checked</xsl:attribute>
    </xsl:if>
   </input>
     Show Spell Descriptions<br/>
  </xsl:if>
 </div>

 <!-- Page1 -->
 <div class="codex-page codex-page-one" style="page-break-after: always">
  <!-- An image layer prints even when browser background graphics are off. -->
  <xsl:if test="count(images/image) != 0">
   <div class="codex-watermark">
    <img alt="Character portrait watermark">
     <xsl:attribute name="src"><xsl:value-of select="images/image/@filename"/></xsl:attribute>
    </img>
   </div>
  </xsl:if>
  <div class="codex-page-content">

      <!-- Start directly with the hero and player identity fields. Product
           logo artwork is intentionally omitted in the Codex edition. -->

 <table cellpadding="0" cellspacing="0" width="100%">
  <tr>
   <td style="width:100%" valign="bottom">
   <table cellpadding="0" cellspacing="0" width="100%">
    <tr>
     <td>
      <table cellpadding="0" cellspacing="0" width="100%">
       <tbody>
        <tr>
         <td>
          <table cellpadding="0" cellspacing="0" width="100%">
           <tbody>
            <tr>

             <td width="42%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10"><xsl:value-of select="@name"/></span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Character Name</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

             <td width="1%"></td>

             <td width="14%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10">
                   <xsl:variable name="align" select="alignment/@name"/>
                   <xsl:choose>
                    <xsl:when test="$align = 'Lawful Good'">LG</xsl:when>
                    <xsl:when test="$align = 'Neutral Good'">NG</xsl:when>
                    <xsl:when test="$align = 'Chaotic Good'">CG</xsl:when>
                    <xsl:when test="$align = 'Lawful Neutral'">LN</xsl:when>
                    <xsl:when test="$align = 'Chaotic Neutral'">CN</xsl:when>
                    <xsl:when test="$align = 'Lawful Evil'">LE</xsl:when>
                    <xsl:when test="$align = 'Neutral Evil'">NE</xsl:when>
                    <xsl:when test="$align = 'Chaotic Evil'">CE</xsl:when>
                    <xsl:otherwise>TN</xsl:otherwise>
                   </xsl:choose>
                  </span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Alignment</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

             <td width="1%"></td>

             <td width="42%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10">
                   <xsl:choose>
                    <xsl:when test="$pfs">
                     <xsl:value-of select="pathfindersociety/@playernum"/>
                     -
                     <xsl:value-of select="pathfindersociety/@characternum"/>
                    </xsl:when>
                    <xsl:otherwise>
                     <xsl:value-of select="@playername"/>
                    </xsl:otherwise>
                   </xsl:choose>
                   &#160;
                  </span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">
                   <xsl:choose>
                    <xsl:when test="$pfs">Character Number</xsl:when>
                    <xsl:otherwise>Player</xsl:otherwise>
                   </xsl:choose>
                  </span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

            </tr>
           </tbody>
          </table>
         </td>
        </tr>
        <tr style="height:3px"><td></td></tr>
        <tr>
         <td>
          <table cellpadding="0" cellspacing="0" width="100%">
           <tbody>
            <tr>

             <td width="57%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10">
                   <xsl:value-of select="classes/@summary"/>
                  </span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Character Level</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

             <td width="1%"></td>

             <td width="23%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr>
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10"><xsl:value-of select="deity/@name"/>&#160;</span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Deity</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

             <td width="1%"></td>

             <td width="18%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr>
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10">
                   <xsl:if test="$pfs">
                    <xsl:value-of select="factions/faction/@name"/>
                   </xsl:if>
                   &#160;
                  </span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">
                   <xsl:choose>
                    <xsl:when test="$pfs">Faction</xsl:when>
                    <xsl:otherwise>Homeland</xsl:otherwise>
                   </xsl:choose>
                  </span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

            </tr>
           </tbody>
          </table>
         </td>
        </tr>
        <tr style="height:3px"><td></td></tr>
        <tr>
         <td>
          <table cellpadding="0" cellspacing="0" width="100%">
           <tbody>
            <tr>

             <xsl:variable name="raceFullText">
              <xsl:value-of select="race/@racetext"/>
              <xsl:if test="templates/@summary!=''"> (<xsl:value-of select="templates/@summary"/>)</xsl:if>
             </xsl:variable>
             <xsl:variable name="raceMaxChars" select="28"/>
             <td class="codex-race-field" width="25%" title="{normalize-space(string($raceFullText))}">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10 codex-race-value">
                   <xsl:choose>
                    <xsl:when test="string-length(normalize-space(string($raceFullText))) &gt; $raceMaxChars">
                     <xsl:value-of select="substring(normalize-space(string($raceFullText)), 1, $raceMaxChars - 3)"/><xsl:text>...</xsl:text>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="normalize-space(string($raceFullText))"/></xsl:otherwise>
                   </xsl:choose>
                  </span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Race</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

             <td width="1%"></td>

             <td width="9%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10"><xsl:value-of select="size/@name"/></span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Size</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

             <td width="1%"></td>

             <td width="9%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10"><xsl:value-of select="personal/@gender"/></span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Gender</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

             <td width="1%"></td>

             <td width="9%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10"><xsl:value-of select="personal/@age"/></span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Age</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

             <td width="1%"></td>

             <td width="9%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10"><xsl:value-of select="personal/charheight/@text"/></span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Height</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

             <td width="1%"></td>

             <td width="11%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10"><xsl:value-of select="personal/charweight/@value"/> lbs.</span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Weight</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

             <td width="1%"></td>

             <td width="9%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                   <span class="v10"><xsl:value-of select="personal/@hair"/>&#160;</span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Hair</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

             <td width="1%"></td>

             <td width="9%">
              <table cellpadding="0" cellspacing="0" width="100%">
               <tbody>
                <tr style="height:14px">
                 <td class="writeinline" valign="bottom" width="100%">
                  <span class="v10"><xsl:value-of select="personal/@eyes"/>&#160;</span>
                 </td>
                </tr>
                <tr>
                 <td>
                  <span class="v6sc">Eyes</span>
                 </td>
                </tr>
               </tbody>
              </table>
             </td>

            </tr>
           </tbody>
          </table>
         </td>
        </tr>
       </tbody>
      </table>
     </td>
    </tr>
    <tr style="height:5px">
     <td/>
    </tr>
   </table>
   </td>
  </tr>
 </table>

<table cellpadding="0" cellspacing="0" width="100%">
 <tbody>
  <tr>
   <td valign="top" width="49%">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
     <tbody>
      <tr>
       <td valign="top" width="54%">
        <table width="100%">
         <tbody>
          <tr>
           <td align="center" class="v4_5" style="width:24%">
            ABILITY NAME
           </td>
           <td align="center" class="v4_5" style="width:19%">
	    ABILITY<br/>SCORE
	   </td>
           <td align="center" class="v4_5" style="width:19%">
	    ABILITY<br/>MODIFIER
	   </td>
           <td align="center" class="v5sc" style="width:19%">
	    Temp<br/>Adjustment
	   </td>
           <td align="center" class="v5sc" valign="bottom" style="width:19%">
	    Temp<br/>Modifier
	   </td>
          </tr>
          <xsl:apply-templates select="attributes/attribute"/>
         </tbody>
        </table>
       </td>
       <td style="width:1%">
        
       </td>
       <td valign="top" style="width:45%">
        <table width="100%">
         <tbody>
          <tr>
           <td align="center" class="v4_5w" style="width:14%">
            <span class="v10w"><b>HP</b></span>
            <br/>
            HIT POINTS
           </td>
           <td align="center" style="width:19%; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
            <table width="100%">
             <tbody>
              <tr>
               <td class="v6sc" valign="top" align="left">Total</td>
               <td class="v10" align="left"><b><xsl:value-of select="health/@hitpoints"/></b></td>
              </tr>
             </tbody>
            </table>
           </td>
           <td align="center" valign="top" style="width:19%; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
            <table width="100%">
             <tbody>
              <tr>
               <td class="v5" align="left" valign="top">DR</td>
               <td class="v7" align="center" valign="middle" style="text-transform: uppercase">
                <b>
                 <xsl:for-each select="damagereduction/special">
                  <xsl:value-of select="@shortname" disable-output-escaping="yes" /><br/>
                 </xsl:for-each>
                 <xsl:apply-templates select="resistances/special" mode="dr"/>
                </b>
               </td>
              </tr>
             </tbody>
            </table>
           </td>
          </tr>
         </tbody>
        </table>
        <table width="100%">
         <tbody>
          <tr>
           <td align="left" class="v4_5" style="width:100%">
            WOUNDS / CURRENT HP
           </td>
          </tr>
          <tr>
           <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
            <br/><br/><br/>
           </td>
          </tr>
          <tr>
           <td align="left" class="v4_5" style="width:100%">
            NONLETHAL DAMAGE
           </td>
          </tr>
          <tr>
           <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
            <br/><br/>
           </td>
          </tr>
         </tbody>
        </table>
        <table width="100%">
         <tbody>
          <tr>
           <td align="center" class="v4_5w">
            <span class="v10w"><b>INITIATIVE</b></span>
            <br/>MODIFIER
           </td>
           <td align="center" class="v9 codex-accent-initiative" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
            <b><xsl:value-of select="initiative/@total"/></b>
           </td>
           <td align="center" class="v7">
            <b>=</b>
           </td>
           <td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
            <b><xsl:value-of select="initiative/@attrtext"/></b>
           </td>
           <td align="center" class="v7">
            <b>+</b>
           </td>
           <td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
            <!-- initiative/@misctext seems to be wrong/insufficient, since
                 it doesn't include things like Improved Initiative feat bonus.
                 Hence we cannot use it directly.
              -->
            <b>
             <xsl:variable name="total">
              <xsl:call-template name="modtonumber">
               <xsl:with-param name="mod">
                <xsl:value-of select="initiative/@total"/>
               </xsl:with-param>
              </xsl:call-template>
             </xsl:variable>
             <xsl:variable name="attrtext">
              <xsl:call-template name="modtonumber">
               <xsl:with-param name="mod">
                <xsl:value-of select="initiative/@attrtext"/>
               </xsl:with-param>
              </xsl:call-template>
             </xsl:variable>
             <xsl:call-template name="numbertomod">
              <xsl:with-param name="n">
               <xsl:value-of select="number($total)-number($attrtext)"/>
              </xsl:with-param>
             </xsl:call-template>
            </b>
           </td>
          </tr>
          <tr>
           <td>
            
           </td>
           <td align="center" class="v6" valign="top">
            TOTAL
           </td>
           <td>
            
           </td>
           <td align="center" class="v4_5" valign="top">
            DEX<br/>MODIFIER
           </td>
           <td>
            
           </td>
           <td align="center" class="v4_5">
            MISC<br/>MODIFIER
           </td>
          </tr>
         </tbody>
        </table>
       </td>
      </tr>
     </tbody>
    </table>
    <table border="0" width="100%">
     <tbody>
      <tr>
       <td align="center" class="v4_5w" style="width:0.5in">
        <span class="v9w"><b>AC</b></span>
        <br/>
        ARMOR CLASS
       </td>
       <td align="center" class="v9 codex-accent-defense" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="armorclass/@ac"/></b>
       </td>
       <td align="center" class="v7">
        <b>=</b>
       </td>
       <td align="center" class="v9">
        <b>10</b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="armorclass/@fromarmor"/></b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="armorclass/@fromshield"/></b>
       </td>
       <td align="center" class="v7"><b>+</b></td><td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
       <b><xsl:value-of select="armorclass/@fromdexterity"/></b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="armorclass/@fromsize"/></b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="armorclass/@fromnatural"/></b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v9" style="width:0.25in; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="armorclass/@fromdeflect"/></b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <xsl:variable name="frommisc">
         <xsl:call-template name="modtonumber">
          <xsl:with-param name="mod">
           <xsl:value-of select="armorclass/@frommisc"/>
          </xsl:with-param>
         </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="fromdodge">
         <xsl:call-template name="modtonumber">
          <xsl:with-param name="mod">
           <xsl:value-of select="armorclass/@fromdodge"/>
          </xsl:with-param>
         </xsl:call-template>
        </xsl:variable>
        <b>
         <xsl:call-template name="numbertomod">
          <xsl:with-param name="n">
           <xsl:value-of select="number($frommisc)+number($fromdodge)"/>
          </xsl:with-param>
         </xsl:call-template>
        </b>
       </td>
      </tr>
      <tr>
       <td/>
       <td align="center" class="v6" valign="top">
        TOTAL
       </td>
       <td/>
       <td align="center" class="v4_5" valign="top"/>
       <td/>
       <td align="center" class="v4_5">
        ARMOR<br/>BONUS
       </td>
       <td/>
       <td align="center" class="v4_5">
        SHIELD<br/>BONUS
       </td>
       <td/>
       <td align="center" class="v4_5">
        DEX<br/>MODIFIER
       </td>
       <td/>
       <td align="center" class="v4_5">
        SIZE<br/>MODIFIER
       </td>
       <td/>
       <td align="center" class="v4_5">
        NATURAL<br/>ARMOR
       </td>
       <td colspan="3" align="center" class="v4_5">
        DEFLECTION<br/>MODIFIER
       </td>
       <td align="center" class="v4_5">
        MISC<br/>MODIFIER
       </td>
      </tr>
     </tbody>
    </table>
    <table border="0" width="100%">
     <tbody>
      <tr>
       <td align="center" class="v4_5w">
        <span class="v10w"><b>TOUCH</b></span>
        <br/>
        ARMOR CLASS
       </td>
       <td align="center" class="v9 codex-accent-defense" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="armorclass/@touch"/></b>
       </td>
       <td align="center" class="v4_5w">
        <span class="v9w"><b>FLAT-FOOTED</b></span>
        <br/>
        ARMOR CLASS
       </td>
       <td align="center" class="v9 codex-accent-defense" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="armorclass/@flatfooted"/></b>
       </td>
       <td align="right" class="v4_5" style="width:45%; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid" valign="top">
        MODIFIERS
       </td>
      </tr>
     </tbody>
    </table>
    <table border="0" cellpadding="0" width="100%">
     <tbody>
      <tr valign="bottom">
       <td align="center" class="v6" style="width:20%" valign="middle">
        SAVING THROWS
       </td>
       <td align="center" class="v6" valign="middle" style="width:10%">
        TOTAL
       </td>
       <td/>
       <td align="center" class="v4_5" style="width:9%">
        BASE<br/>SAVE
       </td>
       <td/>
       <td align="center" class="v4_5" style="width:9%">
        ABILITY<br/>MODIFIER
       </td>
       <td/>
       <td align="center" class="v4_5" style="width:9%">
        MAGIC<br/>MODIFIER
       </td>
       <td/>
       <td align="center" class="v4_5" style="width:9%">
        MISC<br/>MODIFIER
       </td>
       <td/>
       <td align="center" class="v4_5" style="width:9%">
        TEMPORARY<br/>MODIFIER
       </td>
       <td/>
       <td rowspan="4" align="right" class="v4_5" style="width:25%; border-right: black 1px solid; border-top: black 1px solid; border-left: black 1px solid; border-bottom: black 1px solid" valign="top">
        MODIFIERS
       </td>
      </tr>
      <xsl:apply-templates select="saves/save"/>
     </tbody>
    </table>
    <table cellpadding="0" cellspacing="0" border="0" width="100%">
     <tbody>
      <tr height="2px;">
       <td/>
      </tr>
      <tr>
       <xsl:call-template name="leftcorners"/>
       <td align="center" class="v10w">
        <b>BASE ATTACK BONUS</b>
        <br/>
       </td>
       <xsl:call-template name="rightcorners"/>
       <td width="2px;"/>
       <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="attack/@baseattack"/></b>
       </td>
       <td width="8px;"/>
       <td align="center" class="v10w">
        <b>SPELL RESISTANCE</b>
        <br/>
       </td>
       <td width="2px;"/>
       <td align="center" class="v10" style="width:25px; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="substring(resistances/special[substring(@shortname,1,7)='spells ']/@shortname,8)"/></b>
       </td>
      </tr>
      <tr height="4px;">
       <td/>
      </tr>
     </tbody>
    </table>
    <table cellpadding="0" cellspacing="0" width="100%">
     <tbody>
      <xsl:variable name="strmod" select="attributes/attribute[@name='Strength']/attrbonus/@modified"/>
      <xsl:variable name="dexmod" select="attributes/attribute[@name='Dexterity']/attrbonus/@modified"/>
      <xsl:variable name="acfromsize">
       <xsl:call-template name="modtonumber">
        <xsl:with-param name="mod">
         <xsl:value-of select="armorclass/@fromsize"/>
        </xsl:with-param>
       </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="cmbfromsize">
       <xsl:call-template name="numbertomod">
        <xsl:with-param name="n">
         <xsl:value-of select="-$acfromsize"/>
        </xsl:with-param>
       </xsl:call-template>
      </xsl:variable>
      <tr>
       <xsl:call-template name="leftcorners"/>
       <td align="center" class="v10w" style="width:25%">
        <b>CMB</b>
       </td>
       <xsl:call-template name="rightcorners"/>
       <td width="2px;"/>
       <td align="center" class="v10 codex-accent-combat" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="maneuvers/@cmb"/></b>
       </td>
       <td align="center" class="v7">
        <b>=</b>
       </td>
       <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="attack/@baseattack"/></b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="$strmod"/></b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="$cmbfromsize"/></b>
       </td>
       <td/>
       <td rowspan="2" colspan="6" align="center" class="v9" style="width:25%; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid" valign="top">
        <table cellpadding="0" cellspacing="0" width="100%">
         <tbody>
          <tr>
           <td style="text-align:right" class="v4_5">MODIFIERS</td>
          </tr>
          <tr>
           <td align="center">
            <xsl:variable name="cmbmod">
             <xsl:value-of select="maneuvers/@cmb"/>
            </xsl:variable>
            <xsl:variable name="cmb">
             <xsl:call-template name="modtonumber">
              <xsl:with-param name="mod" select="$cmbmod"/>
             </xsl:call-template>
            </xsl:variable>
            <xsl:for-each select="maneuvers/maneuvertype[@cmb != $cmbmod]">
             <xsl:variable name="maneuvertypecmb">
              <xsl:call-template name="modtonumber">
               <xsl:with-param name="mod">
                <xsl:value-of select="@cmb"/>
               </xsl:with-param>
              </xsl:call-template>
             </xsl:variable>
             <xsl:call-template name="numbertomod">
              <xsl:with-param name="n">
               <xsl:value-of select="$maneuvertypecmb - $cmb"/>
              </xsl:with-param>
             </xsl:call-template>
             &#160;<xsl:value-of select="@name"/><br/>
            </xsl:for-each>
           </td>
          </tr>
         </tbody>
        </table>
       </td>
      </tr>
      <tr>
       <td><br/></td>
       <td/>
       <td/>
       <td/>
       <td align="center" class="v5_5">
        TOTAL
       </td>
       <td/>
       <td align="center" class="v4">
        BASE ATTACK<br/>BONUS
       </td>
       <td/>
       <td align="center" class="v4">
        STRENGTH<br/>MODIFIER
       </td>
       <td/>
       <td align="center" class="v4">
        SIZE<br/>MODIFIER
       </td>
      </tr>
      <tr style="height:5px">
       <td/>
      </tr>
      <tr>
       <xsl:call-template name="leftcorners"/>
       <td align="center" class="v10w">
        <b>CMD</b>
       </td>
       <xsl:call-template name="rightcorners"/>
       <td width="2px;"/>
       <td align="center" class="v10 codex-accent-combat" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="maneuvers/@cmd"/></b>
       </td>
       <td align="center" class="v7">
        <b>=</b>
       </td>
       <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="attack/@baseattack"/></b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="$strmod"/></b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="$dexmod"/></b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b><xsl:value-of select="$cmbfromsize"/></b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <b>
         <xsl:variable name="babnum">
          <xsl:call-template name="modtonumber">
           <xsl:with-param name="mod">
            <xsl:value-of select="attack/@baseattack"/>
           </xsl:with-param>
          </xsl:call-template>
         </xsl:variable>
         <xsl:variable name="strmodnum">
          <xsl:call-template name="modtonumber">
           <xsl:with-param name="mod">
            <xsl:value-of select="$strmod"/>
           </xsl:with-param>
          </xsl:call-template>
         </xsl:variable>
         <xsl:variable name="dexmodnum">
          <xsl:call-template name="modtonumber">
           <xsl:with-param name="mod">
            <xsl:value-of select="$dexmod"/>
           </xsl:with-param>
          </xsl:call-template>
         </xsl:variable>
         <xsl:variable name="sizemodnum">
          <xsl:call-template name="modtonumber">
           <xsl:with-param name="mod">
            <xsl:value-of select="$cmbfromsize"/>
           </xsl:with-param>
          </xsl:call-template>
         </xsl:variable>
         <xsl:call-template name="numbertomod">
          <xsl:with-param name="n">
           <xsl:value-of select="maneuvers/@cmd - $babnum - $strmodnum - $dexmodnum - $sizemodnum - 10"/>
          </xsl:with-param>
         </xsl:call-template>
        </b>
       </td>
       <td align="center" class="v7">
        <b>+</b>
       </td>
       <td align="left" class="v10">
        <b>10</b>
       </td>
      </tr>
      <tr>
       <td/>
       <td/>
       <td/>
       <td/>
       <td align="center" class="v5_5">
        TOTAL
       </td>
       <td/>
       <td align="center" class="v4">
        BASE ATTACK<br/>BONUS
       </td>
       <td/>
       <td align="center" class="v4">
        STRENGTH<br/>MODIFIER
       </td>
       <td/>
       <td align="center" class="v4">
        DEXTERITY<br/>MODIFIER
       </td>
       <td/>
       <td align="center" class="v4">
        SIZE<br/>MODIFIER
       </td>
       <td/>
       <td align="center" class="v4">
        MISC<br/>MODIFIER
       </td>
       <td/>
      </tr>
      <tr style="height:3px">
       <td/>
      </tr>
     </tbody>
    </table>
    <xsl:apply-templates select="melee/weapon"/>
    <xsl:apply-templates select="ranged/weapon"/>
   </td>
<td style="width:1%">&#160;</td>
<td valign="top" style="width:50%">
<table cellpadding="0" cellspacing="0" width="100%">
 <tbody>
  <tr>
   <td valign="middle" style="width:81%">
    <table width="100%">
     <tbody>
      <tr>
       <td align="center" class="v4_5w">
        <span class="v10w"><b>SPEED</b></span>
        <br/>
        LAND
       </td>
       <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
         <tbody>
          <tr style="height:20px">
           <td class="v10" align="center"><b><xsl:value-of select="movement/basespeed/@value"/></b></td>
           <td class="v5" valign="bottom">FT.</td>
           <td class="v10" align="center"><b><xsl:value-of select="movement/basespeed/@value div 5"/></b></td>
           <td class="v5" valign="bottom">SQ.</td>
          </tr>
         </tbody>
        </table>
       </td>
       <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
         <tbody>
          <tr style="height:20px">
           <td class="v10" align="center"><b><xsl:value-of select="movement/speed/@value"/></b></td>
           <td class="v5" valign="bottom">FT.</td>
           <td class="v10" align="center"><b><xsl:value-of select="movement/speed/@value div 5"/></b></td>
           <td class="v5" valign="bottom">SQ.</td>
          </tr>
         </tbody>
        </table>
       </td>
      </tr>
      <tr>
       <td class="v4_5"/>
       <td align="center" class="v4_5" valign="top">
        BASE SPEED
       </td>
       <td align="center" class="v4_5" valign="top">
        WITH ARMOR
       </td>
      </tr>
     </tbody>
    </table>
    <table width="100%">
     <tbody>
      <tr>
       <td align="center" class="v10" style="width:30%; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
         <tbody>
          <tr style="height:20px">
           <td class="v10" align="right"><b>&#160;<xsl:value-of select="substring-before(substring-after(movement/special[starts-with(@name,'Flight ')]/@shortname,'('),' feet')"/></b></td>
           <td class="v4_5" valign="bottom">FT.</td>
           <td class="v10" align="center"><b>&#160;<xsl:value-of select="substring-before(substring-after(movement/special[starts-with(@name,'Flight ')]/@shortname,'feet, '),')')"/></b></td>
           <td class="v10" align="center"><b>&#160;</b></td>
          </tr>
         </tbody>
        </table>
       </td>
       <td align="center" class="v10" style="width:23%; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <table width="100%">
         <tbody>
          <tr style="height:20px">
           <td class="v10" align="right">
            <b>
             <xsl:variable name="swimspeed" select="substring-before(substring-after(movement/special[starts-with(@name,'Swimming ')]/@shortname,'('),' feet')"/>
             <xsl:choose>
              <xsl:when test="$swimspeed">
               <xsl:value-of select="$swimspeed"/>
              </xsl:when>
              <xsl:otherwise>
               <xsl:value-of select="movement/speed/@value div 4"/>
              </xsl:otherwise>
             </xsl:choose>
            </b>
           </td>
           <td class="v4_5" align="right" valign="bottom">FT.</td>
          </tr>
         </tbody>
        </table>
       </td>
       <td align="center" class="v10" style="width=23%; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <table width="100%">
         <tbody>
          <tr style="height:20px">
           <td class="v10" align="right">
            <b>
             <xsl:variable name="climbspeed" select="substring-before(substring-after(movement/special[starts-with(@name,'Climbing ')]/@shortname,'('),' feet')"/>
             <xsl:choose>
              <xsl:when test="$climbspeed">
               <xsl:value-of select="$climbspeed"/>
              </xsl:when>
              <xsl:otherwise>
               <xsl:value-of select="movement/speed/@value div 4"/>
              </xsl:otherwise>
             </xsl:choose>
            </b>
           </td>
           <td class="v5" align="right" valign="bottom">FT.</td>
          </tr>
         </tbody>
        </table>
       </td>
       <td align="center" class="v10" style="width:23%; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
        <table width="100%">
         <tbody>
          <tr style="height:20px">
           <td class="v10" align="right"><b><xsl:value-of select="substring-before(substring-after(movement/special[starts-with(@name,'Burrowing ')]/@shortname,'('),' feet')"/></b></td>
           <td class="v4_5" align="right" valign="bottom">FT.</td>
          </tr>
         </tbody>
        </table>
       </td>
      </tr>
      <tr>
       <td align="center" class="v4" valign="top">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
         <tbody>
          <tr>
           <td class="v4_5" align="center" valign="top" style="width:50%">FLY</td>
           <td class="v4_5"/>
           <td class="v4_5" align="center" valign="top" style="width:50%">MANEUVERABILITY</td>
          </tr>
         </tbody>
        </table>
       </td>
       <td align="center" class="v4_5" valign="top">
        SWIM
       </td>
       <td align="center" class="v4_5" valign="top">
        CLIMB
       </td>
       <td align="center" class="v4_5" valign="top">
        BURROW
       </td>
      </tr>
     </tbody>
    </table>
   </td>
   <td style="width:1%"/>
   <td align="center" style="width:18%" valign="top">
    <table width="100%">
     <tbody>
      <tr>
       <td align="center" class="v4_5" style="width:18%; border:black 1px solid;" valign="top">
        TEMP MODIFIERS<br/>
        <br/><br/><br/><br/><br/><br/><br/><br/>
       </td>
      </tr>
     </tbody>
    </table>
   </td>
  </tr>
 </tbody>
</table>
<p class="v4"/>
<table cellpadding="0" cellspacing="0" width="100%">
 <tbody>
  <tr>
   <td>
    <table cellpadding="0" cellspacing="0" width="100%">
     <tbody>
      <tr class="headline">
       <xsl:call-template name="leftcorners"/>
       <td align="center" style="height:22px">Skills</td>
       <xsl:call-template name="rightcorners"/>
      </tr>
      <tr style="height:5px">
       <td/>
      </tr>
     </tbody>
    </table>
   </td>
  </tr>
  <tr>
   <td>
    <table cellpadding="0" cellspacing="0" width="100%">
     <tbody>
      <tr>
       <td align="center"><span class="smalltext">
       <br/></span>
       </td>
       <td align="left"><span class="v8sc">
       Skill Names</span>
       </td>
       <td align="center" class="v6sc">
       Total<br/>Bonus
       </td>
       <td align="center"/>
       <td align="center">
        <span class="smalltext"/>
       </td>
       <td align="center" class="v6sc">
         Ability<br/>Mod.
       </td>
       <td/>
       <td align="center" class="v6sc">
         Ranks
       </td>
       <td align="center"/>
       <td align="center" class="v6sc">
         Misc.<br/>Mod.
       </td>
      </tr>
      <tr>
       <td align="center">
       </td>
      </tr>
      <xsl:apply-templates select="skills/skill"/>
      <tr style="height:15px">
       <td align="center">
        <table border="0" cellpadding="0" cellspacing="0" class="box" width="10">
         <tbody>
          <tr style="height:9px">
           <td align="center" class="skillx" valign="bottom">
            <xsl:text disable-output-escaping="yes">&amp;#x2713;</xsl:text>
           </td>
          </tr>
         </tbody>
        </table>
       </td>
       <td align="left" colspan="9"><span class="v7sc">
        Class Skill&#160;&#160;&#160;*&#160;Trained Only
        </span>
       </td>
      </tr>
      <tr style="height:5px"><td></td>
      </tr>

      <tr class="codex-conditional-row">
       <td class="v9sc" colspan="10">
        Conditional Modifiers:
       </td>
      </tr>
      <tr class="codex-conditional-row" style="height:15px"><td colspan="10"><span class="writeinline">&#160;</span></td></tr>
      <tr class="codex-conditional-row" style="height:15px"><td colspan="10"><span class="writeinline">&#160;</span></td></tr>
      <tr class="v5 codex-conditional-row"><td>&#160;</td></tr>
     
      <tr>
       <td class="v9sc codex-languages-header" colspan="10">
        Languages:
       </td>
      </tr>
      <tr style="height:15px">
       <td class="v10" colspan="10"><span class="writeinline">
        <xsl:apply-templates select="languages/language"/>
        </span>
       </td>
      </tr>
      <xsl:if test="count(languages/language) &lt; 6">
       <tr style="height:15px"><td colspan="10"><span class="writeinline">&#160;</span></td></tr>
      </xsl:if>
     </tbody>
    </table>
   </td>
  </tr>
 </tbody>
</table>
</td>
</tr>
</tbody>
</table>
</div>
</div>

<!-- Page2 -->
<div style="page-break-after: always">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
<td style="height:100%; width:74%" valign="top">

 <!-- AC ITEMS table -->
 <table border="0" cellpadding="0" cellspacing="0" width="100%">
   <tbody>
    <tr>
     <td rowspan="2" align="center" class="v10w" style="width:40%">
      <table border="0" cellpadding="0" cellspacing="0" width="100%">
       <tbody>
        <tr>
         <xsl:call-template name="leftcorners">
          <xsl:with-param name="type">box</xsl:with-param>
         </xsl:call-template>
         <td align="center">
          <b>AC ITEMS</b>
         </td>
         <xsl:call-template name="rightcornerfill"/>
        </tr>
       </tbody>
      </table>
     </td>
     <td class="v3"><br/></td>
    </tr>
    <tr>
     <td align="center" class="v6w">
      <b>BONUS</b>
     </td>
     <td align="center" class="v6w">
      <b>TYPE</b>
     </td>
     <td align="center" class="v6w">
      <b>CHECK PENALTY</b>
     </td>
     <td align="center" class="v6w">
      <b>SPELL FAILURE</b>
     </td>
     <td align="center" class="v6w">
      <b>WEIGHT</b>
     </td>
     <td align="center" class="v6w">
      <b>PROPERTIES</b>
     </td>
    </tr>
    <xsl:apply-templates select="defenses/armor[@ac != '+0' or weight/@text != '']"/>
    <!-- Include an extra blank row, to allow in-play fill-in on paper. -->
    <tr style="height:13px">
     <td class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">&#160;</td>
     <td class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black"></td>
     <td class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black"></td>
     <td class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black"></td>
     <td class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black"></td>
     <td class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black"></td>
     <td class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black"></td>
    </tr>
    <tr style="height:10px">
     <td align="right" class="v10w">
      <b>TOTALS&#160;</b>
     </td>
     <td align="center" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
      <xsl:call-template name="numbertomod">
       <xsl:with-param name="n">
        <xsl:call-template name="gettotalacitemsbonus"/>
       </xsl:with-param>
      </xsl:call-template>
     </td>
     <td align="left" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
      <!-- type -->
     </td>
     <td align="center" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
      <!-- armor check penalty -->
      <xsl:call-template name="numbertomod">
       <xsl:with-param name="n">
        <xsl:value-of select="penalties/penalty[@name='Armor Check Penalty']/@value"/>
       </xsl:with-param>
      </xsl:call-template>
     </td>
     <td align="left" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
      <!-- spell failure -->
     </td>
     <td align="center" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
      <!-- weight -->
      <xsl:variable name="weight" select="sum(defenses/armor/weight/@value)"/>
      <xsl:if test="$weight &gt; 0">
       <xsl:value-of select="sum(defenses/armor/weight/@value)"/> lbs.
      </xsl:if>
     </td>
     <td align="left" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
      <!-- properties -->
     </td>
    </tr>
   </tbody>
 </table>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
 <tbody>
  <tr>
   <td style="height:100%; width:43%" valign="top">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
     <tbody>
      <tr>
       <td class="v5">&#160;</td>
      </tr>
      <tr>
       <td>
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
         <tbody>
          <tr>
           <td align="center" class="v10w" colspan="2">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
             <tbody>
              <tr>
               <xsl:call-template name="leftcorners">
                <xsl:with-param name="type">box</xsl:with-param>
               </xsl:call-template>
               <td align="center">
                <b>GEAR</b>
               </td>
               <xsl:call-template name="rightcorners">
                <xsl:with-param name="type">box</xsl:with-param>
               </xsl:call-template>
              </tr>
             </tbody>
            </table>
           </td>
          </tr>
          <tr>
           <td align="center" class="v7" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black; width:80%">
            ITEM
           </td>
           <td align="center" class="v7" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black; width:19%">
            WT.
           </td>
          </tr>
          <xsl:apply-templates select="gear/item"/>
          <xsl:apply-templates select="magicitems/item">
           <xsl:with-param name="magic">yes</xsl:with-param>
          </xsl:apply-templates>
          <xsl:variable name="gearrows">
           <xsl:apply-templates select="gear" mode="countgearrows"/>
          </xsl:variable>
          <xsl:variable name="magicitemrows">
           <xsl:apply-templates select="magicitems" mode="countgearrows"/>
          </xsl:variable>
          <xsl:variable name="totalrows">
           <xsl:value-of select="ceiling($gearrows + $magicitemrows)"/>
          </xsl:variable>
          <xsl:if test="$totalrows &lt; 25">
           <xsl:call-template name="blankitem">
            <xsl:with-param name="count" select="25 - $totalrows"/>
           </xsl:call-template>
          </xsl:if>
          <!-- Always have at least 1 blank row to write in during play. -->
          <xsl:call-template name="blankitem"/>
          <tr>
           <td align="right" class="v10w">
            <b>TOTAL WEIGHT&#160;</b>
           </td>
           <td align="center" class="v10" style="border: 1px solid black; width:83%">
            <xsl:value-of select="round(10 * encumbrance/@carried) div 10"/>
           </td>
          </tr>
         </tbody>
        </table>
       </td>
      </tr>
      <tr>
       <td>
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
         <tbody>
          <tr>
           <td colspan="7" style="height:5px">
            
           </td>
          </tr>
          <tr>
           <td align="center" class="v6" style="width:24%">
            LIGHT<br/>LOAD
           </td>
           <td style="width:1%">
            
           </td>
           <td align="center" class="v10" style="BORDER: black 1px solid; width:24%">
           <xsl:value-of select="encumbrance/@light"/>
           </td>
           <td style="width:1%">
            
           </td>
           <td align="center" class="v6" style="width:24%">
            LIFT OVER<br/>HEAD
           </td>
           <td style="width:1%">
            
           </td>
           <td align="center" class="v10" style="BORDER: black 1px solid; width:24%">
            <xsl:value-of select="encumbrance/@heavy"/>
           </td>
          </tr>
          <tr>
           <td colspan="7" style="height:5px">
            
           </td>
          </tr>
          <tr>
           <td align="center" class="v6" style="width:24%">
            MEDIUM<br/>LOAD
           </td>
           <td style="width:1%">
            
           </td>
           <td align="center" class="v10" style="BORDER: black 1px solid; width:24%">
           <xsl:value-of select="encumbrance/@medium"/>

           </td>
           <td style="width:1%">
            
           </td>
           <td align="center" class="v6" style="width:24%">
            LIFT OFF<br/>GROUND
           </td>
           <td style="width:1%">
            
           </td>
           <td align="center" class="v10" style="BORDER: black 1px solid; width:24%">
            <xsl:value-of select="2 * encumbrance/@heavy"/>
           </td>
          </tr>
          <tr>
           <td colspan="7" style="height:5px">
            
           </td>
          </tr>
          <tr>
           <td align="center" class="v6" style="width:24%">
            HEAVY<br/>LOAD
           </td>
           <td style="width:1%">
            
           </td>
           <td align="center" class="v10" style="BORDER: black 1px solid; width:24%">
           <xsl:value-of select="encumbrance/@heavy"/>
           </td>
           <td style="width:1%">
            
           </td>
           <td align="center" class="v6" style="width:24%">
            DRAG OR<br/>PUSH
           </td>
           <td style="width:1%">
            
           </td>
           <td align="center" class="v10" style="BORDER: black 1px solid; width:24%">
            <xsl:value-of select="5 * encumbrance/@heavy"/>
           </td>
          </tr>
          <tr>
           <td colspan="7" style="height:5px">
            
           </td>
          </tr>
         </tbody>
        </table>
       </td>
      </tr>
      <tr>
       <td style="height:100%">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
         <tbody>
          <tr>
           <xsl:call-template name="leftcorners">
            <xsl:with-param name="type">box</xsl:with-param>
           </xsl:call-template>
           <td align="center" class="v10w">
            <b>MONEY</b>
           </td>
           <xsl:call-template name="rightcorners">
            <xsl:with-param name="type">box</xsl:with-param>
           </xsl:call-template>
          </tr>
          <tr>
           <td align="left" class="v4" style="height:100%; border-left:1px solid black; border-right:1px solid black; border-bottom:1px solid black;" valign="top" colspan="3">
            <br/>
            <span class="v8">&#160; CP <b><xsl:value-of select="money/@cp"/></b></span>
            <br/><br/>
            <span class="v8">&#160; SP <b><xsl:value-of select="money/@sp"/></b></span>
            <br/><br/>
            <span class="v8">&#160; GP <b><xsl:value-of select="money/@gp"/></b></span>
            <br/><br/>
            <span class="v8">&#160; PP <b><xsl:value-of select="money/@pp"/></b></span>
            <br/><br/>
           </td>
          </tr>
         </tbody>
        </table>
       </td>
      </tr>
     </tbody>
    </table>
   </td>
   <td style="width:1%">
    
   </td>
   <td style="height:100%; width=55%" valign="top">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
     <tbody>
      <tr>
       <td>
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
         <tbody>
          <tr>
           <td class="v5">&#160;</td>
          </tr>
          <tr>
           <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
             <tbody>
              <tr>
               <td align="center" class="v10w" colspan="2">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                 <tbody>
                  <tr>
                   <xsl:call-template name="leftcorners"/>
                   <td align="center">
                    <b>FEATS</b>
                   </td>
                   <xsl:call-template name="rightcorners"/>
                  </tr>
                 </tbody>
                </table>
               </td>
              </tr>
              <xsl:apply-templates select="traits/trait" mode="list"/>
              <xsl:apply-templates select="feats/feat" mode="list"/>
              <xsl:variable name="rowcount" select="count(traits/trait) + count(feats/feat)"/>
              <xsl:if test="$rowcount &lt; 12">
               <xsl:call-template name="blankrow">
                <xsl:with-param name="count" select="12 - $rowcount"/>
               </xsl:call-template>
              </xsl:if>
              <tr>
               <td>
                <br/>
               </td>
              </tr>
              <tr>
               <td align="center" class="v10w" colspan="2">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                 <tbody>
                  <tr>
                   <xsl:call-template name="leftcorners"/>
                   <td align="center">
                    <b>SPECIAL ABILITIES</b>
                   </td>
                   <xsl:call-template name="rightcorners"/>
                  </tr>
                 </tbody>
                </table>
               </td>
              </tr>
              <xsl:apply-templates select="*/special[not(starts-with(@name, 'Godling Output|')) and not(starts-with(@name, 'Godling Power|')) and not(starts-with(@name, 'Godling Fatal Flaw|'))]" mode="list"/>
              <xsl:apply-templates select="trackedresources/trackedresource" mode="list"/>
              <xsl:call-template name="blankrow">
               <xsl:with-param name="count" select="5"/>
              </xsl:call-template>
              <tr>
               <td style="height:5px"/>
              </tr>
              <tr>
               <td style="height:100%">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                 <tbody>
                  <!-- The XP block format varies between the core sheet
                       and the Pathfinder Society sheet.
                    --> 
                  <xsl:choose>
                   <xsl:when test="$pfs">
                    <tr>
                     <td align="center" class="v9w">
                      <table border="0" cellpadding="0" cellspacing="0" width="100%">
                       <tbody>
                        <tr>
                         <xsl:call-template name="leftcorners">
                          <xsl:with-param name="type">box</xsl:with-param>
                         </xsl:call-template>
                         <td align="center">
                          EXPERIENCE POINTS
                         </td>
                        </tr>
                       </tbody>
                      </table>
                     </td>
                     <td align="center" class="v9w" colspan="3">
                      <table border="0" cellpadding="0" cellspacing="0" width="100%">
                       <tbody>
                        <tr>
                         <td align="center">
                          FAME
                         </td>
                         <xsl:call-template name="rightcorners">
                          <xsl:with-param name="type">box</xsl:with-param>
                         </xsl:call-template>
                        </tr>
                       </tbody>
                      </table>
                     </td>
                    </tr>
                    <tr>
                     <td align="center" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black; width:50%; height:100%" valign="top">
                      <xsl:value-of select="xp/@total"/>
                     </td>
                     <td align="center" class="v10" style="height:100%; width:20%; border-bottom: 1px solid black" valign="top">
                      <xsl:value-of select="factions/faction/@tpa"/>
                     </td>
                     <td align="center" class="v10" style="height:100%; width:10%; border-bottom: 1px solid black" valign="top">
                      /
                     </td>
                     <td align="center" class="v10" style="height:100%; width:20%; border-bottom: 1px solid black; border-right: 1px solid black" valign="top">
                      <xsl:value-of select="factions/faction/@cpa"/>
                     </td>
                    </tr>
                    <tr>
                     <td/>
                     <td align="center" class="v4">TOTAL FAME</td>
                     <td/>
                     <td align="center" class="v4">CURRENT PRESTIGE</td>
                    </tr>
                   </xsl:when>
                   <xsl:otherwise>
                    <tr>
                     <td rowspan="2" align="center" class="v10w">
                      <table cellpadding="0" cellspacing="0" border="0" width="100%">
                       <tbody>
                        <tr>
                         <xsl:call-template name="leftcorners">
                          <xsl:with-param name="type">box</xsl:with-param>
                         </xsl:call-template>
                         <td align="center">
                          <b>EXPERIENCE POINTS</b><br/>
                         </td>
                         <xsl:call-template name="rightcornerfill"/>
                        </tr>
                       </tbody>
                      </table>
                     </td>
                     <td class="v3"><br/></td>
                    </tr>
                    <tr>
                     <td align="center" class="v7w">
                       NEXT LEVEL
                     </td>
                    </tr>
                    <tr>
                     <td align="center" class="v10" style="height:100%; border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;" valign="top">
                      <xsl:value-of select="xp/@total"/>
                     </td>
                     <td align="center" class="v10" style="height:100%; border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;" valign="top">
                      <!-- Calculate XP needed for next level. -->
                      <xsl:choose>
                       <xsl:when test="contains(settings/@summary, 'Advancement Speed: Pathfinder Society Advancement')">
                        <xsl:value-of select="classes/@level * 3"/>
                       </xsl:when>
                       <xsl:when test="contains(settings/@summary, 'Advancement Speed: Slow Advancement')">
                        <xsl:choose>
                         <xsl:when test="classes/@level = 1">3000</xsl:when>
                         <xsl:when test="classes/@level = 2">7500</xsl:when>
                         <xsl:when test="classes/@level = 3">14000</xsl:when>
                         <xsl:when test="classes/@level = 4">23000</xsl:when>
                         <xsl:when test="classes/@level = 5">35000</xsl:when>
                         <xsl:when test="classes/@level = 6">53000</xsl:when>
                         <xsl:when test="classes/@level = 7">77000</xsl:when>
                         <xsl:when test="classes/@level = 8">115000</xsl:when>
                         <xsl:when test="classes/@level = 9">160000</xsl:when>
                         <xsl:when test="classes/@level = 10">235000</xsl:when>
                         <xsl:when test="classes/@level = 11">330000</xsl:when>
                         <xsl:when test="classes/@level = 12">475000</xsl:when>
                         <xsl:when test="classes/@level = 13">665000</xsl:when>
                         <xsl:when test="classes/@level = 14">955000</xsl:when>
                         <xsl:when test="classes/@level = 15">1350000</xsl:when>
                         <xsl:when test="classes/@level = 16">1900000</xsl:when>
                         <xsl:when test="classes/@level = 17">2700000</xsl:when>
                         <xsl:when test="classes/@level = 18">3850000</xsl:when>
                         <xsl:when test="classes/@level = 19">5350000</xsl:when>
                        </xsl:choose>
                       </xsl:when>
                       <xsl:when test="contains(settings/@summary, 'Advancement Speed: Medium Advancement')">
                        <xsl:choose>
                         <xsl:when test="classes/@level = 1">2000</xsl:when>
                         <xsl:when test="classes/@level = 2">5000</xsl:when>
                         <xsl:when test="classes/@level = 3">9000</xsl:when>
                         <xsl:when test="classes/@level = 4">15000</xsl:when>
                         <xsl:when test="classes/@level = 5">23000</xsl:when>
                         <xsl:when test="classes/@level = 6">35000</xsl:when>
                         <xsl:when test="classes/@level = 7">51000</xsl:when>
                         <xsl:when test="classes/@level = 8">75000</xsl:when>
                         <xsl:when test="classes/@level = 9">105000</xsl:when>
                         <xsl:when test="classes/@level = 10">155000</xsl:when>
                         <xsl:when test="classes/@level = 11">220000</xsl:when>
                         <xsl:when test="classes/@level = 12">315000</xsl:when>
                         <xsl:when test="classes/@level = 13">445000</xsl:when>
                         <xsl:when test="classes/@level = 14">635000</xsl:when>
                         <xsl:when test="classes/@level = 15">890000</xsl:when>
                         <xsl:when test="classes/@level = 16">1300000</xsl:when>
                         <xsl:when test="classes/@level = 17">1800000</xsl:when>
                         <xsl:when test="classes/@level = 18">2550000</xsl:when>
                         <xsl:when test="classes/@level = 19">3600000</xsl:when>
                        </xsl:choose>
                       </xsl:when>
                       <xsl:when test="contains(settings/@summary, 'Advancement Speed: Fast Advancement')">
                        <xsl:choose>
                         <xsl:when test="classes/@level = 1">1300</xsl:when>
                         <xsl:when test="classes/@level = 2">3300</xsl:when>
                         <xsl:when test="classes/@level = 3">6000</xsl:when>
                         <xsl:when test="classes/@level = 4">10000</xsl:when>
                         <xsl:when test="classes/@level = 5">15000</xsl:when>
                         <xsl:when test="classes/@level = 6">23000</xsl:when>
                         <xsl:when test="classes/@level = 7">34000</xsl:when>
                         <xsl:when test="classes/@level = 8">50000</xsl:when>
                         <xsl:when test="classes/@level = 9">71000</xsl:when>
                         <xsl:when test="classes/@level = 10">105000</xsl:when>
                         <xsl:when test="classes/@level = 11">145000</xsl:when>
                         <xsl:when test="classes/@level = 12">210000</xsl:when>
                         <xsl:when test="classes/@level = 13">295000</xsl:when>
                         <xsl:when test="classes/@level = 14">425000</xsl:when>
                         <xsl:when test="classes/@level = 15">600000</xsl:when>
                         <xsl:when test="classes/@level = 16">850000</xsl:when>
                         <xsl:when test="classes/@level = 17">1200000</xsl:when>
                         <xsl:when test="classes/@level = 18">1700000</xsl:when>
                         <xsl:when test="classes/@level = 19">2400000</xsl:when>
                        </xsl:choose>
                       </xsl:when>
                      </xsl:choose>
                     </td>
                    </tr>
                   </xsl:otherwise>
                  </xsl:choose>
                 </tbody>
                </table>
               </td>
              </tr>
             <tr>
               <td>
                <br/>
               </td>
              </tr>
             </tbody>
            </table>
           </td>
          </tr>
         </tbody>
        </table>
       </td>
      </tr>
     </tbody>
    </table>
   </td>
  </tr>
 </tbody>
</table>

</td>
 <xsl:if test="count(spellclasses/spellclass) &gt; 0">
  <td style="width:1%"></td>
  <td style="height:100%; width:25%" valign="top">
   <table border="0" cellpadding="0" cellspacing="0" width="100%">
     <tbody>
      <xsl:apply-templates select="spellclasses/spellclass[spelllevel]"/>
     </tbody>
   </table>
  </td>
 </xsl:if>
</tr>
</tbody>
</table>
</div>

<!-- Godling / Mythic page. The bridge records come from the Codex Godly
     Powers data files and do not change any character calculations. -->
<xsl:if test="contains(templates/@summary, 'Godling Bloodline:') or count(*/special[starts-with(@name, 'Godling Output|')]) != 0">
 <xsl:variable name="godlingOutput" select="*/special[starts-with(@name, 'Godling Output|')][1]"/>
 <xsl:variable name="godlingName" select="$godlingOutput/@name"/>
 <xsl:variable name="bloodlineValue" select="substring-before(concat(substring-after($godlingName, '|Bloodline='), '|'), '|')"/>
 <xsl:variable name="ancestorValue" select="substring-before(concat(substring-after($godlingName, '|Ancestor='), '|'), '|')"/>
 <xsl:variable name="tierValue" select="substring-before(concat(substring-after($godlingName, '|Tier='), '|'), '|')"/>
 <xsl:variable name="fatalEarnedValue" select="substring-before(concat(substring-after($godlingName, '|FatalEarned='), '|'), '|')"/>
 <xsl:variable name="fatalAdjValue" select="substring-before(concat(substring-after($godlingName, '|FatalAdj='), '|'), '|')"/>
 <xsl:variable name="fatalDcValue" select="substring-before(concat(substring-after($godlingName, '|FatalDC='), '|'), '|')"/>
 <xsl:variable name="godlyValue" select="substring-before(concat(substring-after($godlingName, '|Godly='), '|'), '|')"/>
 <xsl:variable name="mythicPowerValue" select="substring-before(concat(substring-after($godlingName, '|MythicPower='), '|'), '|')"/>
 <div class="codex-page" style="page-break-after: always">
  <table class="codex-section">
   <tbody>
    <tr><th colspan="8">Godling / Mythic</th></tr>
    <tr>
     <td class="codex-label">Bloodline Strength</td>
     <td class="codex-label">Ancestor</td>
     <td class="codex-label">Mythic Tier</td>
     <td class="codex-label">Fatal Flaws Earned</td>
     <td class="codex-label">Fatal DC Adjustment</td>
     <td class="codex-label">Fatal Flaw DC</td>
     <td class="codex-label">Godly Powers</td>
     <td class="codex-label">Mythic Power</td>
    </tr>
    <tr>
     <td class="codex-value-gold">
      <xsl:choose><xsl:when test="$bloodlineValue != ''"><xsl:value-of select="$bloodlineValue"/></xsl:when><xsl:otherwise><xsl:value-of select="substring-before(substring-after(templates/@summary, 'Godling Bloodline: '), ' +')"/></xsl:otherwise></xsl:choose>
     </td>
     <td class="codex-value-green"><xsl:choose><xsl:when test="$ancestorValue != ''"><xsl:value-of select="$ancestorValue"/></xsl:when><xsl:otherwise>&#8212;</xsl:otherwise></xsl:choose></td>
     <td class="codex-value-violet"><xsl:choose><xsl:when test="$tierValue != ''"><xsl:value-of select="$tierValue"/></xsl:when><xsl:otherwise>&#8212;</xsl:otherwise></xsl:choose></td>
     <td class="codex-value-gold"><xsl:choose><xsl:when test="$fatalEarnedValue != ''"><xsl:value-of select="$fatalEarnedValue"/></xsl:when><xsl:otherwise>&#8212;</xsl:otherwise></xsl:choose></td>
     <td class="codex-value-gold"><xsl:choose><xsl:when test="$fatalAdjValue != ''"><xsl:value-of select="$fatalAdjValue"/></xsl:when><xsl:otherwise>&#8212;</xsl:otherwise></xsl:choose></td>
     <td class="codex-value-gold"><xsl:choose><xsl:when test="$fatalDcValue != ''"><xsl:value-of select="$fatalDcValue"/></xsl:when><xsl:otherwise>&#8212;</xsl:otherwise></xsl:choose></td>
     <td class="codex-value-blue"><xsl:choose><xsl:when test="$godlyValue != ''"><xsl:value-of select="$godlyValue"/></xsl:when><xsl:otherwise>&#8212;</xsl:otherwise></xsl:choose></td>
     <td class="codex-value-blue">
      <xsl:choose>
       <xsl:when test="$mythicPowerValue != ''"><xsl:value-of select="$mythicPowerValue"/></xsl:when>
       <xsl:when test="count(trackedresources/trackedresource[starts-with(@name, 'Mythic Power')]) != 0"><xsl:value-of select="trackedresources/trackedresource[starts-with(@name, 'Mythic Power')][1]/@left"/>/<xsl:value-of select="trackedresources/trackedresource[starts-with(@name, 'Mythic Power')][1]/@max"/></xsl:when>
       <xsl:otherwise>&#8212;</xsl:otherwise>
      </xsl:choose>
     </td>
    </tr>
   </tbody>
  </table>

  <table class="codex-section">
   <tbody>
    <tr><th colspan="3">Godly Powers <xsl:if test="$godlyValue != ''">(<xsl:value-of select="$godlyValue"/> selected)</xsl:if></th></tr>
    <tr><td class="codex-label" style="width:31%">Power</td><td class="codex-label">Summary / Rules</td><td class="codex-label" style="width:13%">Source</td></tr>
    <xsl:choose>
     <xsl:when test="count(*/special[starts-with(@name, 'Godling Power|Name=')]) != 0">
      <xsl:for-each select="*/special[starts-with(@name, 'Godling Power|Name=')]">
       <tr><td class="codex-value-blue" style="text-align:left"><xsl:value-of select="substring-after(@name, 'Godling Power|Name=')"/></td><td><xsl:value-of select="description"/></td><td><xsl:value-of select="@sourcetext"/></td></tr>
      </xsl:for-each>
     </xsl:when>
     <xsl:otherwise><tr><td colspan="3" class="codex-note">No selected Godly Powers were exported.</td></tr></xsl:otherwise>
    </xsl:choose>
   </tbody>
  </table>

  <table class="codex-section">
   <tbody>
    <tr><th colspan="3">Fatal Flaws</th></tr>
    <tr><td class="codex-label" style="width:9%">Slot</td><td class="codex-label">Fatal Flaw</td><td class="codex-label" style="width:14%">Save DC</td></tr>
    <xsl:choose>
     <xsl:when test="count(*/special[starts-with(@name, 'Godling Fatal Flaw|')]) != 0">
      <xsl:for-each select="*/special[starts-with(@name, 'Godling Fatal Flaw|')]">
       <xsl:variable name="flawName" select="@name"/>
       <tr>
        <td class="codex-value-gold"><xsl:value-of select="substring-before(substring-after($flawName, '|Slot='), '|')"/></td>
        <td><xsl:value-of select="substring-before(substring-after($flawName, '|Name='), '|DC=')"/></td>
        <td class="codex-value-gold"><xsl:value-of select="substring-after($flawName, '|DC=')"/></td>
       </tr>
      </xsl:for-each>
     </xsl:when>
     <xsl:otherwise><tr><td colspan="3" class="codex-note">No selected Fatal Flaws were exported.</td></tr></xsl:otherwise>
    </xsl:choose>
   </tbody>
  </table>

  <table class="codex-section">
   <tbody>
    <tr><th colspan="2">Mythic Abilities (Path and Optional Other)</th></tr>
    <tr><td class="codex-label">Ability</td><td class="codex-label" style="width:24%">Path / Source</td></tr>
    <xsl:for-each select="*/special[contains(@sourcetext, 'Universal') or contains(@sourcetext, 'Archmage') or contains(@sourcetext, 'Champion') or contains(@sourcetext, 'Guardian') or contains(@sourcetext, 'Hierophant') or contains(@sourcetext, 'Marshal') or contains(@sourcetext, 'Trickster')]">
     <tr><td><xsl:value-of select="@name"/></td><td class="codex-value-violet" style="text-align:left"><xsl:value-of select="@sourcetext"/></td></tr>
    </xsl:for-each>
   </tbody>
  </table>

  <table class="codex-section">
   <tbody>
    <tr><th colspan="2">Mythic Feats</th></tr>
    <tr><td class="codex-label">Feat</td><td class="codex-label" style="width:24%">Category</td></tr>
    <xsl:for-each select="feats/feat[contains(@categorytext, 'Mythic')]">
     <tr><td><xsl:value-of select="@name"/></td><td class="codex-value-violet" style="text-align:left"><xsl:value-of select="@categorytext"/></td></tr>
    </xsl:for-each>
   </tbody>
  </table>
  <p class="codex-note">Values are read from Hero Lab's Godly Powers tab and native Mythic selections. Mythic Power is shown as current / maximum.</p>
 </div>
</xsl:if>

<!-- Page3 -->
<div>
 <!-- Display character portrait. -->
 <xsl:if test="count(images/image) != 0">
  <div>
   <xsl:attribute name="id">portrait<xsl:value-of select="position()"/></xsl:attribute>
   <xsl:attribute name="name">portrait<xsl:value-of select="position()"/></xsl:attribute>
   <xsl:choose>
    <xsl:when test="contains(settings/@summary, 'Show Hero Portrait')">
     <xsl:attribute name="style">display:block;</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
     <xsl:attribute name="style">display:none;</xsl:attribute>
    </xsl:otherwise>
   </xsl:choose>
   <img style="float:right" class="portrait">
    <xsl:attribute name="src"><xsl:value-of select="images/image/@filename"/></xsl:attribute>
   </img>
  </div>
 </xsl:if>

 <!-- Display background details. -->
 <xsl:if test="personal/description != ''">
  <div>
   <xsl:attribute name="id">backgrounddetails<xsl:value-of select="position()"/></xsl:attribute>
   <xsl:attribute name="name">backgrounddetails<xsl:value-of select="position()"/></xsl:attribute>
   <xsl:choose>
    <xsl:when test="contains(settings/@summary, 'Hide Background Details')">
     <xsl:attribute name="style">display:none;</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
     <xsl:attribute name="style">display:block;</xsl:attribute>
    </xsl:otherwise>
   </xsl:choose>
   <p align="center" class="v10w">
    <b>Background Details</b><br/>
   </p>
   <p class="v10" style="white-space: pre-wrap">
    <xsl:value-of select="personal/description"/>
    <br/>
   </p>
  </div>
 </xsl:if>

 <!-- Display feat/ability full descriptions. -->
 <div>
  <xsl:attribute name="id">abilitydesc<xsl:value-of select="position()"/></xsl:attribute>
  <xsl:attribute name="name">abilitydesc<xsl:value-of select="position()"/></xsl:attribute>
  <xsl:choose>
   <xsl:when test="contains(settings/@summary, 'Show Feat / Ability Descriptions')">
    <xsl:attribute name="style">display:block;</xsl:attribute>
   </xsl:when>
   <xsl:otherwise>
    <xsl:attribute name="style">display:none;</xsl:attribute>
   </xsl:otherwise>
  </xsl:choose>
  <p align="center" class="v10w">
   <b>Feats</b><br/>
  </p>
  <xsl:apply-templates select="traits/trait" mode="full"/>
  <xsl:apply-templates select="feats/feat" mode="full"/>
  <p/>
  <p align="center" class="v10w">
   <b>Special Abilities</b><br/>
  </p>
  <xsl:apply-templates select="*/special[not(starts-with(@name, 'Godling Output|')) and not(starts-with(@name, 'Godling Power|')) and not(starts-with(@name, 'Godling Fatal Flaw|'))]" mode="full"/>
 </div>

 <!-- Display combat maneuvers table. -->
 <div>
  <xsl:attribute name="id">maneuvers<xsl:value-of select="position()"/></xsl:attribute>
  <xsl:attribute name="name">maneuvers<xsl:value-of select="position()"/></xsl:attribute>
  <xsl:choose>
   <xsl:when test="count(journals/journal[@name='Show Maneuvers Table']) != 0">
    <xsl:attribute name="style">display:block; page-break-inside:avoid;</xsl:attribute>
   </xsl:when>
   <xsl:otherwise>
    <xsl:attribute name="style">display:none; page-break-inside:avoid;</xsl:attribute>
   </xsl:otherwise>
  </xsl:choose>
  <p align="center" class="v10w">
   <b>Combat Maneuvers Table</b><br/>
  </p>
  <p class="v10">
   <table border="1" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
     <tr>
      <td rowspan="2" valign="bottom"><strong>Maneuver</strong></td>
      <td rowspan="2" valign="bottom" align="center"><strong>CMD</strong></td>
      <td rowspan="2" valign="bottom" align="center"><strong>Base CMB</strong></td>
      <td align="center">
       <xsl:attribute name="colspan">
        <xsl:value-of select="count(melee/weapon)"/>
       </xsl:attribute>
       <strong>CMB With Weapon</strong>
      </td>
     </tr>

     <tr>
      <xsl:for-each select="melee/weapon">
       <td>
        <strong>
         <xsl:choose>
          <xsl:when test="contains(@name,'&#xA;')">
           <xsl:value-of select="substring-before(@name,'&#xA;')"/>
          </xsl:when>
          <xsl:otherwise>
           <xsl:value-of select="@name"/>
          </xsl:otherwise>
         </xsl:choose>
        </strong>
       </td>
      </xsl:for-each>
     </tr>

     <tr>
      <td>Bull Rush</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Bull Rush']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Bull Rush']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <xsl:variable name="bullrushbonus">
        <xsl:call-template name="getbullrushbonus"/>
       </xsl:variable>
       <td>
        <xsl:choose>
         <xsl:when test="$bullrushbonus!=''">
          <xsl:value-of select="$bullrushbonus"/>
         </xsl:when>
         <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
       </td>
      </xsl:for-each>
     </tr>

     <tr>
      <td>Dirty Trick</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Dirty Trick']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Dirty Trick']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <td>-</td>
      </xsl:for-each>
     </tr>
 
     <tr>
      <td>Disarm</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Disarm']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Disarm']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <xsl:variable name="disarmbonus">
        <xsl:call-template name="getdisarmbonus">
         <xsl:with-param name="force">true</xsl:with-param>
        </xsl:call-template>
       </xsl:variable>
       <td>
        <xsl:choose>
         <xsl:when test="$disarmbonus!=''">
          <xsl:value-of select="$disarmbonus"/>
         </xsl:when>
         <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
       </td>
      </xsl:for-each>
     </tr>
 
     <tr>
      <td>Drag</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Drag']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Drag']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <xsl:variable name="dragbonus">
        <xsl:call-template name="getdragbonus"/>
       </xsl:variable>
       <td>
        <xsl:choose>
         <xsl:when test="$dragbonus!=''">
          <xsl:value-of select="$dragbonus"/>
         </xsl:when>
         <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
       </td>
      </xsl:for-each>
     </tr>
 
     <tr>
      <td>Feint</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Feint']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Feint']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <td>-</td>
      </xsl:for-each>
     </tr>
 
     <tr>
      <td>Grapple</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Grapple']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Grapple']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <xsl:variable name="grapplebonus">
        <xsl:call-template name="getgrapplebonus"/>
       </xsl:variable>
       <td>
        <xsl:choose>
         <xsl:when test="$grapplebonus!=''">
          <xsl:value-of select="$grapplebonus"/>
         </xsl:when>
         <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
       </td>
      </xsl:for-each>
     </tr>
 
     <tr>
      <td>Overrun</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Overrun']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Overrun']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <td>-</td>
      </xsl:for-each>
     </tr>
 
     <tr>
      <td>Pull</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Pull']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Pull']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <td>-</td>
      </xsl:for-each>
     </tr>
 
     <tr>
      <td>Push</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Push']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Push']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <td>-</td>
      </xsl:for-each>
     </tr>
 
     <tr>
      <td>Reposition</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Reposition']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Reposition']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <xsl:variable name="repositionbonus">
        <xsl:call-template name="getrepositionbonus"/>
       </xsl:variable>
       <td>
        <xsl:choose>
         <xsl:when test="$repositionbonus!=''">
          <xsl:value-of select="$repositionbonus"/>
         </xsl:when>
         <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
       </td>
      </xsl:for-each>
     </tr>
 
     <tr>
      <td>Steal</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Steal']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Steal']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <xsl:variable name="stealbonus">
        <xsl:call-template name="getstealbonus"/>
       </xsl:variable>
       <td>
        <xsl:choose>
         <xsl:when test="$stealbonus!=''">
          <xsl:value-of select="$stealbonus"/>
         </xsl:when>
         <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
       </td>
      </xsl:for-each>
     </tr>
 
     <tr>
      <td>Sunder</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Sunder']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Sunder']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <xsl:variable name="sunderbonus">
        <xsl:call-template name="getsunderbonus">
         <xsl:with-param name="force">true</xsl:with-param>
        </xsl:call-template>
       </xsl:variable>
       <td>
        <xsl:choose>
         <xsl:when test="$sunderbonus!=''">
          <xsl:value-of select="$sunderbonus"/>
         </xsl:when>
         <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
       </td>
      </xsl:for-each>
     </tr>
 
     <tr>
      <td>Trip</td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Trip']/@cmd"/></td>
      <td align="center"><xsl:value-of select="maneuvers/maneuvertype[@name='Trip']/@cmb"/></td>
      <xsl:for-each select="melee/weapon">
       <xsl:variable name="tripbonus">
        <xsl:call-template name="gettripbonus">
         <xsl:with-param name="force">true</xsl:with-param>
        </xsl:call-template>
       </xsl:variable>
       <td>
        <xsl:choose>
         <xsl:when test="$tripbonus!=''">
          <xsl:value-of select="$tripbonus"/>
         </xsl:when>
         <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
       </td>
      </xsl:for-each>
     </tr>

    </tbody>
   </table>
  </p>
 </div>

 <!-- Display spell full descriptions. -->
 <xsl:if test="count(*/spell) != 0">
  <div style="display:none;">
   <xsl:attribute name="id">spelldesc<xsl:value-of select="position()"/></xsl:attribute>
   <xsl:attribute name="name">spelldesc<xsl:value-of select="position()"/></xsl:attribute>
   <p align="center" class="v10w">
    <b>Spell Descriptions</b><br/>
   </p>
   <xsl:apply-templates select="*/spell" mode="full"/>
  </div>
 </xsl:if>

</div>

<div id="footer" style="page-break-after: always">
 <p style="text-align:center" class="v6">
  Hero Lab&#174; and the Hero Lab logo are Registered Trademarks of 
  LWD Technology, Inc.  Free download at http://www.wolflair.com
  <br/>
  Pathfinder&#174; and associated marks and logos are trademarks of 
  Paizo Publishing, LLC, and are used under license.
 </p>
</div>

</xsl:template>

 <!--=======================================================================-->
 <!-- These simple rules match attributes, skills etc, and display them     -->
 <!-- appropriately                                                         -->
 <!--=======================================================================-->
 <xsl:template match="attribute">
  <tr>
   <td align="center" class="v4_5w" style="width:0.5in">
    <span class="v10w" style="text-transform: uppercase"><b><xsl:value-of select="substring(@name,1,3)"/></b>
    </span>
    <br/>
    <span style="text-transform: uppercase"><xsl:value-of select="@name"/></span>
   </td>
   <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
    <b>
     <xsl:value-of select="attrvalue/@text"/></b><br/>
   </td>
   <td align="center" class="v10" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
    <b><xsl:value-of select="attrbonus/@text"/></b><br/>
   </td>
   <td align="center" style="BORDER-RIGHT: #dddddd 3px solid; BORDER-TOP: #dddddd 3px solid; BORDER-LEFT: #dddddd 3px solid; BORDER-BOTTOM: #dddddd 3px solid"><br/>
   </td>
   <td align="center" style="BORDER-RIGHT: #dddddd 3px solid; BORDER-TOP: #dddddd 3px solid; BORDER-LEFT: #dddddd 3px solid; BORDER-BOTTOM: #dddddd 3px solid"><br/>
   </td>
  </tr>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template match="save">
  <tr>
   <td align="center" class="v4_5w">
    <span class="largetextwhite">
     <xsl:value-of select="substring-before(@name,' Save')"/>
    </span>
    <br/>
    <xsl:choose>
     <xsl:when test="@abbr = 'Fort'">(CONSTITUTION)</xsl:when>
     <xsl:when test="@abbr = 'Ref'">(DEXTERITY)</xsl:when>
     <xsl:when test="@abbr = 'Will'">(WISDOM)</xsl:when>
    </xsl:choose>
   </td>
   <td align="center" class="v9 codex-accent-save" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
    <b><xsl:value-of select="@save"/></b>
   </td>
   <td align="center" class="v7">
    <b>=</b>
   </td>
   <td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
    <b><xsl:value-of select="@base"/></b>
   </td>
   <td align="center" class="v7">
    <b>+</b>
   </td>
   <td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
    <b><xsl:value-of select="@fromattr"/></b>
   </td>
   <td align="center" class="v7">
    <b>+</b>
   </td>
   <td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
    <b><xsl:value-of select="@fromresist"/></b>
   </td>
   <td align="center" class="v7">
    <b>+</b>
   </td>
   <td align="center" class="v9" style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid">
    <b><xsl:value-of select="@frommisc"/></b>
   </td>
   <td align="center" class="v7">
    <b>+</b>
   </td>
   <td align="center" style="BORDER-RIGHT: #dddddd 3px solid; BORDER-TOP: #dddddd 3px solid; BORDER-LEFT: #dddddd 3px solid; BORDER-BOTTOM: #dddddd 3px solid">
   </td>
  </tr>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display a row in the Skills table.                                    -->
 <!--=======================================================================-->
 <xsl:template match="skill">
  <tr class="codex-skill-row">
   <xsl:if test="@usable='no'">
    <!-- IE uses id, Firefox uses name -->
    <xsl:attribute name="id">unusableskill<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
    <xsl:attribute name="name">unusableskill<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
    <xsl:choose>
     <xsl:when test="contains(../../settings/@summary, 'Hide Unusable Skills')">
      <xsl:attribute name="style">height:9px; display:none;</xsl:attribute>
     </xsl:when>
     <xsl:otherwise>
      <xsl:attribute name="style">height:9px; display:table-row;</xsl:attribute>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:if>
   <td align="center" class="codex-skill-check">
    <table border="0" cellpadding="0" cellspacing="0" class="box" width="10">
     <tbody>
      <tr style="height:9px">
       <td align="center" valign="bottom">
        <xsl:attribute name="class">skillx<xsl:if test="@classskill"> codex-skill-class</xsl:if></xsl:attribute>
        <xsl:choose>
         <xsl:when test="@classskill">
          <xsl:text disable-output-escaping="yes">&amp;#x2713;</xsl:text>
         </xsl:when>
         <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
       </td>
      </tr>
     </tbody>
    </table>
   </td>
   <td align="left" class="v9sc">
    <xsl:value-of select="@name"/>
    <xsl:if test="@trainedonly">
     <span class="codex-trained-marker">*</span>
    </xsl:if>
   </td>
   <td align="center" class="writeinline codex-skill-total">
    <xsl:value-of select="@value"/>
   </td>
   <td align="center">
    <span class="v9">=</span>
   </td>
   <td align="left" class="v9sc">
    <xsl:value-of select="substring(@attrname,1,3)"/>
   </td>
   <td align="center" class="writeinline codex-skill-component">
    <xsl:value-of select="@attrbonus"/>
   </td>
   <td align="center">
    <span class="v9">+</span>
   </td>
   <td align="center" class="writeinline codex-skill-component">
    <xsl:value-of select="@ranks"/>
   </td>
   <td align="center">
    <span class="v9">+</span>
   </td>
   <td align="center" class="writeinline codex-skill-component">
    <xsl:value-of select="number(@value)-number(@attrbonus)-number(@ranks)"/>
   </td>
  </tr>
 </xsl:template>
 
 <!--=======================================================================-->
 <xsl:template match="feat | trait">
  <xsl:if test="position() != 1">
   <xsl:text>, </xsl:text>
  </xsl:if><xsl:value-of select="@name"/>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template name="abilitylistentry">
  <tr>
   <td class="v10" style="border-bottom: 1px solid black" valign="top">
    <table cellpadding="0" cellspacing="0" width="100%">
     <tbody>
      <tr>
       <td>
        <xsl:attribute name="id">trackingboxes<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
        <xsl:attribute name="name">trackingboxes<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
        <xsl:choose>
         <xsl:when test="count(../../journals/journal[@name='Hide Tracking Boxes']) = 0">
          <xsl:attribute name="style">display:block;</xsl:attribute>
         </xsl:when>
         <xsl:otherwise>
          <xsl:attribute name="style">display:none;</xsl:attribute>
         </xsl:otherwise>
        </xsl:choose>
        <table cellpadding="0" cellspacing="0">
         <tbody>
          <tr>
           <xsl:variable name="abilityname" select="@name"/>
           <xsl:for-each select="../../trackedresources/trackedresource[@name=$abilityname]">
            <xsl:call-template name="spellx">
             <xsl:with-param name="count" select="@max"/>
            </xsl:call-template>
           </xsl:for-each>
           <td/>
          </tr>
         </tbody>
        </table>
       </td>
       <td width="100%">
        <xsl:value-of select="@name"/>
        <xsl:call-template name="abilitysource"/>
       </td>
      </tr>
     </tbody>
    </table>
   </td>
  </tr>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display a set of 1 or more blank rows.                                -->
 <!--=======================================================================-->
 <xsl:template name="blankrow">
  <xsl:param name="count" select="1"/>
  <xsl:if test="$count &gt; 0">
   <tr>
    <td class="v10" style="border-bottom: 1px solid black" valign="top">
     <br/>
    </td>
   </tr>
   <xsl:call-template name="blankrow">
    <xsl:with-param name="count" select="$count - 1"/>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>
  
 <!--=======================================================================-->
 <xsl:template match="feat | trait" mode="list">
  <xsl:call-template name="abilitylistentry"/>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template match="special" mode="list">
  <!-- Don't duplicate feats, traits, or items. -->
  <xsl:variable name="specialname" select="@name"/>
  <xsl:if test="count(../../feats/feat[@name=$specialname]) = 0 and count(../../traits/trait[@name=$specialname]) = 0 and count(../../*/item[@name=$specialname]) = 0">
   <!-- Show spelllike attacks (e.g. death domain's Bleeding Touch) once. -->
   <xsl:if test="(local-name(..) = 'attack') or count(../../attack/special[@name=$specialname])=0">
    <xsl:call-template name="abilitylistentry"/>
   </xsl:if>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template match="trackedresource" mode="list">
  <!-- Don't duplicate feats, traits, specials, or items. -->
  <xsl:variable name="specialname" select="@name"/>
  <xsl:if test="count(../../feats/feat[@name=$specialname]) = 0 and count(../../traits/trait[@name=$specialname]) = 0 and count(../../*/special[@name=$specialname]) = 0 and count(../../*/item[@name=$specialname]) = 0">
   <xsl:call-template name="abilitylistentry"/>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display the source of an ability.                                     -->
 <!--=======================================================================-->
 <xsl:template name="abilitysource">
   <xsl:if test="traitcategory">
    (<xsl:value-of select="traitcategory"/> Trait)
   </xsl:if>
   <xsl:if test="specsource">
    <xsl:text> (</xsl:text>

    <!-- Get specsource matching a class or race. -->
    <xsl:for-each select="specsource">
     <xsl:variable name="spec" select="text()"/>
     <xsl:choose>
      <xsl:when test="(position()=1) and (position()=last())">
       <xsl:value-of select="$spec"/>
      </xsl:when>
      <xsl:when test="$spec='Master'">
       <xsl:value-of select="$spec"/>
      </xsl:when>
      <xsl:when test="../../../race/@name=$spec">
       <xsl:value-of select="$spec"/>
      </xsl:when>
      <xsl:when test="../../../subtypes/subtype/@name=$spec">
       <xsl:value-of select="$spec"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:for-each select="../../../classes/class">
        <xsl:variable name="classname">
         <xsl:call-template name="getbasename">
          <xsl:with-param name="name" select="@name"/>
         </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$classname=$spec">
         <xsl:value-of select="$spec"/>
        </xsl:if>
       </xsl:for-each>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:for-each>

    <xsl:choose>
     <xsl:when test="contains(description,'2 slots')"> Opposition School)</xsl:when>
     <xsl:otherwise> Ability)</xsl:otherwise>
    </xsl:choose>
   </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display full description of a feat or trait.                          -->
 <!--=======================================================================-->
 <xsl:template name="abilityfullentry">
  <p class="v10" style="page-break-inside:avoid;">
   <xsl:variable name="iscommonproficiency">
    <xsl:call-template name="iscommonproficiency"/>
   </xsl:variable>
   <xsl:if test="$iscommonproficiency='true'">
    <xsl:attribute name="id">commonproficiency<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
    <xsl:attribute name="name">commonproficiency<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
   </xsl:if>
   <strong><xsl:value-of select="@name"/>&#160;</strong>
   <xsl:call-template name="abilitysource"/>
   <br/>&#160;&#160;&#160;
   <span style="white-space: pre-wrap"><xsl:value-of select="description"/></span>
  </p>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template match="feats/feat | traits/trait" mode="full">
  <xsl:call-template name="abilityfullentry"/>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template match="special" mode="full">
  <!-- Don't duplicate feats or traits. -->
  <xsl:variable name="specialname" select="@name"/>
  <xsl:if test="count(../../feats/feat[@name=$specialname]) = 0 and count(../../traits/trait[@name=$specialname]) = 0">
   <!-- Show spelllike attacks (e.g. death domain's Bleeding Touch) once. -->
   <xsl:if test="(local-name(..) = 'attack') or count(../../attack/special[@name=$specialname])=0">
    <xsl:call-template name="abilityfullentry"/>
   </xsl:if>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display the full description for a spell.                             -->
 <!--=======================================================================-->
 <xsl:template match="spell" mode="full">
  <xsl:variable name="name" select="@name"/>
  <xsl:variable name="class" select="@class"/>
  <!-- Skip duplicates. -->
  <xsl:if test="(count(preceding-sibling::spell[@name=$name and @class=$class and @class!='']) = 0)">
   <div style="page-break-inside:avoid;">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
     <tbody>
      <tr>
       <td align="left" class="v10wsc">
        <xsl:value-of select="@name"/>
       </td>
      </tr>
     </tbody>
    </table>
    <b>School </b> <xsl:value-of select="@schooltext"/>
    <xsl:if test="@subschooltext!=''"> (<xsl:value-of select="@subschooltext"/>)</xsl:if>
    <xsl:if test="@descriptortext!=''"> [<xsl:value-of select="@descriptortext"/>]</xsl:if>;
    <b>Level </b>
     <xsl:value-of select="@class"/>
     <xsl:text> </xsl:text>
     <xsl:value-of select="@level"/><br/>
    <b>Casting Time </b> <xsl:value-of select="@casttime"/><br/>
    <b>Components </b> <xsl:value-of select="@componenttext"/><br/>
    <b>Range </b> <xsl:value-of select="@range"/><br/>
    <xsl:if test="@target!=''">
     <b>Target </b> <xsl:value-of select="@target"/><br/>
    </xsl:if>
    <xsl:if test="@area!=''">
     <b>Area </b> <xsl:value-of select="@area"/><br/>
    </xsl:if>
    <b>Duration </b> <xsl:value-of select="@duration"/><br/>
    <b>Saving Throw </b> <xsl:value-of select="@save"/>
    <xsl:if test="@resist!=''">
     <xsl:text>; </xsl:text>
     <b>Spell Resistance </b> <xsl:value-of select="@resist"/>
    </xsl:if>
    <br/>
    <span style="white-space: pre-wrap"><xsl:value-of select="description"/></span><br/>
    <br/>
   </div>
  </xsl:if>
 </xsl:template>
  
 <!--=======================================================================-->
 <xsl:template match="language">
  <xsl:if test="(position() &gt; 5) and ((position() mod 5) = 1)">
   <xsl:text disable-output-escaping="yes">
        &lt;/span&gt;
       &lt;/td&gt;
      &lt;/tr&gt;
      &lt;tr style="height:15px"&gt;
       &lt;td class="v10" colspan="10"&gt;&lt;span class="writeinline"&gt;
   </xsl:text>
  </xsl:if>
  <xsl:choose>
   <!-- Since we display languages comma-separated, don't show an individual
        language in a comma-containing form.
     -->
   <xsl:when test="contains(@name,',')">
    <xsl:value-of select="concat(substring-after(@name, ', '),' ')"/>
    <xsl:value-of select="substring-before(@name, ',')"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="@name"/>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="count(following-sibling::language) != 0">
   <xsl:text>, </xsl:text>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get a name without the parenthetical addition, if any.                -->
 <!--=======================================================================-->
 <xsl:template name="getbasename">
  <xsl:param name="name"/>
  <xsl:choose>
   <xsl:when test="contains($name,'(')">
    <xsl:value-of select="substring-before($name,' (')"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$name"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
  <xsl:template match="spellclass">
    <!-- To display the DC correctly in this section, we need to compute the
         ability modifier.  Unfortunately, HeroLab doesn't give us this in
         the XML today, so we have to use a heuristic to try to calculate it.
      -->
    <xsl:variable name="classname">
     <xsl:call-template name="getbasename">
      <xsl:with-param name="name" select="@name"/>
     </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="dcattrmod">
     <xsl:call-template name="getdcattrmod">
      <xsl:with-param name="classname" select="$classname"/>
     </xsl:call-template>
    </xsl:variable>

    <tr>
     <td align="center" class="v10w" style="width:100%; text-transform: uppercase">
      <table cellpadding="0" cellspacing="0" border="0" width="100%">
       <tbody>
        <tr>
         <xsl:call-template name="leftcorners"/>
         <td align="center">
          <b>
           <xsl:if test="count(../../spellclasses/spellclass) != 1">
            <xsl:value-of select="@name"/>&#160;
           </xsl:if>
           SPELLS
          </b>
         </td>
         <xsl:call-template name="rightcorners"/>
        </tr>
       </tbody>
      </table>
     </td>
    </tr>
    <tr>
     <td style="height:5px"/>
    </tr>
    <tr>
     <td valign="top" style="width:100%">
      <table width="100%">
       <tbody>
        <tr>
         <td align="center" class="v5" style="width:20%">
          SPELLS<br/>KNOWN
         </td>
         <td align="center" class="v5" style="width:20%">
          SPELL<br/>SAVE DC
         </td>
         <td align="center" class="v5" style="width:20%">
          LEVEL
         </td>
         <td align="center" class="v5" style="width:20%">
          SPELLS<br/>PER DAY
         </td>
         <td align="center" class="v5" style="width:20%">
          BONUS<br/>SPELLS
         </td>
        </tr>
        <xsl:apply-templates select="spelllevel">
         <xsl:with-param name="dcattrmod" select="$dcattrmod"/>
        </xsl:apply-templates>
       </tbody>
      </table>
     </td>
    </tr>
    <tr style="height:40px">
     <td style="width:100%; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid" valign="top">
      <span class="v5sc">Conditional Modifiers</span>
     </td>
    </tr>
    <tr>
     <td style="height:5px"/>
    </tr>
    <tr>
     <td style="width:100%" align="center" class="v8">
      DOMAINS/SPECIALTY SCHOOL
     </td>
    </tr>
    <tr style="height:30px">
     <td>
      <span class="writeinline">
       <!-- Display domains. -->
       <xsl:variable name="domainspec" select="concat(@name,' Domain:')"/>
       <xsl:for-each select="../../otherspecials/special[contains(@name,$domainspec)]">
        <xsl:value-of select="substring-after(@name,': ')"/>
        <xsl:if test="count(following-sibling::special[contains(@name,$domainspec)]) != 0">, </xsl:if>
       </xsl:for-each>

       <!-- Display specialties. Non-school specialties all have an
            Associated School in the description.
         -->
       <xsl:for-each select="../../otherspecials/special[(@sourcetext = $classname)]">
        <xsl:choose>
         <xsl:when test="contains(description,'2 slots')"/>
         <xsl:when test="contains(description,'Associated School:')">
          <xsl:value-of select="@name"/>
         </xsl:when>
         <xsl:when test="contains(@name,'Supremacy')">
          <xsl:value-of select="substring-before(@name,' Supremacy')"/>
         </xsl:when>
         <xsl:when test="@name='Abjuration'">Abjuration</xsl:when>
         <xsl:when test="@name='Conjuration'">Conjuration</xsl:when>
         <xsl:when test="@name='Divination'">Divination</xsl:when>
         <xsl:when test="@name='Enchantment'">Enchantment</xsl:when>
         <xsl:when test="@name='Evocation'">Evocation</xsl:when>
         <xsl:when test="@name='Illusion'">Illusion</xsl:when>
         <xsl:when test="@name='Necromancy'">Necromancy</xsl:when>
         <xsl:when test="@name='Transmutation'">Transmutation</xsl:when>
         <xsl:when test="@name='Metal Magic'">Metal</xsl:when>
         <xsl:when test="starts-with(@name,'Flexible Enhancement')">Wood</xsl:when>
        </xsl:choose>
       </xsl:for-each>

       <!-- Display oppositions. -->
       <xsl:if test="count(../../otherspecials/special[(@sourcetext = $classname) and contains(description,'2 slots')]) != 0">
        <xsl:text> (Opp: </xsl:text>
        <xsl:for-each select="../../otherspecials/special[(@sourcetext = $classname) and contains(description,'2 slots')]">
         <xsl:value-of select="@shortname"/>
         <xsl:if test="count(following-sibling::special[(@sourcetext = $classname) and contains(description,'2 slots')]) != 0">, </xsl:if>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
       </xsl:if>
       &#160;
      </span>
     </td>
    </tr>
    <xsl:call-template name="spellsknownlevels"/>
    <xsl:if test="count(../../spellsmemorized/spell[@class=$classname]) != 0">
     <tr>
      <td style="width:100%">
       <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tbody>
         <xsl:call-template name="spellsmemorizedlevels"/>
        </tbody>
       </table>
      </td>
     </tr>
    </xsl:if>
  </xsl:template>
 
 <!--=======================================================================-->
  <xsl:template match="spelllevel">
   <xsl:param name="dcattrmod" select="0"/>
   <xsl:variable name="classname">
    <xsl:call-template name="getbasename">
     <xsl:with-param name="name" select="../@name"/>
    </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="level" select="@level"/>
   <xsl:variable name="bonusspells">
    <xsl:choose>
     <xsl:when test="@level != 0">
      <xsl:value-of select="floor(($dcattrmod - @level + 4) div 4)"/>
     </xsl:when>
     <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
   </xsl:variable>
   <tr>
    <td class="box" align="center" style="v10">
     <xsl:if test="../@spells='Spontaneous'">
      <xsl:value-of select="count(../../spellsknown/spell[@level=$level and @class=$classname])"/>
     </xsl:if>
    </td>
    <td class="box" align="center" style="v10">
     <xsl:value-of select="10 + @level + $dcattrmod"/>
    </td>
    <td align="center" class="v6">
     <xsl:call-template name="nth">
      <xsl:with-param name="n" select="@level"/>
     </xsl:call-template>
    </td>
    <td class="box" align="center" style="v10">
     <xsl:choose>
      <xsl:when test="@unlimited = 'yes'">Any</xsl:when>
      <xsl:otherwise><xsl:value-of select="@maxcasts - $bonusspells"/></xsl:otherwise>
     </xsl:choose>
    </td>
    <td class="box" align="center" style="v10">
     <xsl:if test="$bonusspells != 0">
      <xsl:value-of select="$bonusspells"/>
     </xsl:if>
    </td>
   </tr>
  </xsl:template>

 <!--=======================================================================-->
 <!-- Convert a modifier (like "+3" or "") to a number ("3" or "0").        -->
 <!--=======================================================================-->
 <xsl:template name="modtonumber">
  <xsl:param name="mod">0</xsl:param>
  <xsl:variable name="premod">
   <xsl:choose>
    <xsl:when test="substring-before($mod,'/')">
     <xsl:value-of select="substring-before($mod,'/')"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="$mod"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:choose>
   <xsl:when test="substring($premod,1,1) = '+'">
    <xsl:value-of select="number(substring($premod,2))"/>
   </xsl:when>
   <xsl:when test="string(number($premod)) != 'NaN'">
    <xsl:value-of select="number($premod)"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="0"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Convert a number (like "3" or "0") to a modifier ("+3" or "").        -->
 <!--=======================================================================-->
 <xsl:template name="numbertomod">
  <xsl:param name="n">0</xsl:param>
  <xsl:param name="showzero">no</xsl:param>
  <xsl:if test="$n &gt; 0">+</xsl:if>
  <xsl:if test="$n != 0">
    <xsl:value-of select="$n"/>
  </xsl:if>
  <xsl:if test="($n = 0) and ($showzero != 'no')">+0</xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Given a number N, return a 'Nth' string.                              -->
 <!-- Note that 0 is still '0', not '0th' on the standard sheet.            -->
 <!--=======================================================================-->
 <xsl:template name="nth">
  <xsl:param name="n">0</xsl:param>
  <xsl:value-of select="$n"/>
  <xsl:choose>
   <xsl:when test="$n = 0"></xsl:when>
   <xsl:when test="$n = 1">ST</xsl:when>
   <xsl:when test="$n = 2">ND</xsl:when>
   <xsl:when test="$n = 3">RD</xsl:when>
   <xsl:otherwise>TH</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display a memorized spell list for each spell level.                  -->
 <!--=======================================================================-->
 <xsl:template name="spellsmemorizedlevels">
  <xsl:param name="level" select="0"/>
  <xsl:if test="$level &lt;= @maxspelllevel"> 
   <xsl:call-template name="spellsmemorized">
    <xsl:with-param name="level"><xsl:value-of select="$level"/></xsl:with-param>
   </xsl:call-template>
   <xsl:call-template name="spellsmemorizedlevels">
    <xsl:with-param name="level" select="$level + 1"/>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display a known spell list for each spell level.                      -->
 <!--=======================================================================-->
 <xsl:template name="spellsknownlevels">
  <xsl:param name="level" select="0"/>
  <xsl:if test="$level &lt;= @maxspelllevel">
   <xsl:call-template name="spellsknown">
    <xsl:with-param name="classname">
     <xsl:value-of select="@name"/>
    </xsl:with-param>
    <xsl:with-param name="level"><xsl:value-of select="$level"/></xsl:with-param>
   </xsl:call-template>
   <xsl:call-template name="spellsknownlevels">
    <xsl:with-param name="level" select="$level + 1"/>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
  <xsl:template name="spellsknown">
   <xsl:param name="classname">0</xsl:param>
   <xsl:param name="level">0</xsl:param>
   <xsl:variable name="baseclassname">
    <xsl:call-template name="getbasename">
     <xsl:with-param name="name" select="@name"/>
    </xsl:call-template>
   </xsl:variable>
   <xsl:if test="count(../../spellsknown/spell[@level=$level and @class=$baseclassname]) != 0">
    <tr>
     <td>
      <table>
       <tbody>
        <tr>
         <td class="v6" style="width:30px">
          <xsl:call-template name="nth">
           <xsl:with-param name="n">
            <xsl:value-of select="$level"/>
           </xsl:with-param>
          </xsl:call-template>
         </td>
         <xsl:for-each select="../../spellclasses/spellclass[@name=$classname]/spelllevel[@level=$level]">
          <xsl:call-template name="spellx">
           <xsl:with-param name="count">
            <xsl:value-of select="@maxcasts"/>
           </xsl:with-param>
          </xsl:call-template>
         </xsl:for-each>
        </tr>
       </tbody>
      </table>
     </td>
    </tr>
    <tr>
     <td style="width:100%">
      <table border="0" cellpadding="0" cellspacing="0" width="100%">
       <tbody>
        <xsl:apply-templates select="../../spellsknown/spell[@level=$level and @class=$baseclassname]"/>
       </tbody>
      </table>
     </td>
    </tr>
   </xsl:if>
  </xsl:template>

 <!--=======================================================================-->
  <xsl:template name="spellsmemorized">
   <xsl:param name="level">0</xsl:param>
   <xsl:variable name="classfullname" select="@name"/>
   <xsl:variable name="classname">
    <xsl:call-template name="getbasename">
     <xsl:with-param name="name" select="@name"/>
    </xsl:call-template>
   </xsl:variable>
   <xsl:if test="count(../../spellsmemorized/spell[@level=$level and @class=$classname]) != 0">
    <tr>
     <td class="v6" colspan="2">
      <xsl:call-template name="nth">
       <xsl:with-param name="n">
        <xsl:value-of select="$level"/>
       </xsl:with-param>
      </xsl:call-template>
     </td>
    </tr>
    <xsl:apply-templates select="../../spellsmemorized/spell[@level=$level and @class='']">
     <xsl:with-param name="castersource" select="../../classes/class[@name=$classfullname]/@castersource"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="../../spellsmemorized/spell[@level=$level and @class=$classname]">
     <xsl:with-param name="castersource" select="../../classes/class[@name=$classfullname]/@castersource"/>
    </xsl:apply-templates>
   </xsl:if>
  </xsl:template>

 <!--=======================================================================-->
 <xsl:template match="spellsknown/spell">
  <tr style="height:8px">
   <td class="v8" style="border-bottom: 1px solid black" valign="top">
    <xsl:value-of select="@name"/>
   </td>
  </tr>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template match="spellsmemorized/spell">
  <xsl:param name="castersource"/>
  <tr style="height:8px">
   <xsl:call-template name="spellx"/>
   <td class="v8" style="border-bottom: 1px solid black" valign="top">
    <xsl:value-of select="@name"/>
    <xsl:if test="@class=''">
     <xsl:if test="$castersource='Divine'"> (D)</xsl:if>
     <xsl:if test="$castersource='Arcane'"> (S)</xsl:if>
    </xsl:if>
   </td>
  </tr>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display a set of 1 or more checkboxes.                                -->
 <!--=======================================================================-->
 <xsl:template name="spellx">
  <xsl:param name="count" select="1"/>
  <xsl:param name="n" select="1"/>
  <xsl:if test="$n &lt;= $count">
   <xsl:if test="($n &gt; 1) and (($n mod 10) = 1)">
    <xsl:text disable-output-escaping="yes">
     &lt;/tr&gt;&lt;tr&gt;
    </xsl:text>
   </xsl:if>
   <td style="width:12px">
    <table border="0" cellpadding="0" cellspacing="0" class="box" width="10">
     <tbody>
      <tr style="height:9px">
       <td align="center" class="skillx" valign="bottom">&#160;</td>
      </tr>
     </tbody>
    </table>
   </td>
   <xsl:call-template name="spellx">
    <xsl:with-param name="count" select="$count"/>
    <xsl:with-param name="n" select="$n + 1"/>
   </xsl:call-template>
  </xsl:if> 
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the penalty applied to a given equipped weapon due to fighting    -->
 <!-- with two weapons.  Note this is not used for double weapons.          -->
 <!--                                                                       -->
 <!-- Two-Weapon  Offhand   Mainhand   Offhand                              -->
 <!--  Fighting    Class    Penalty    Penalty                              -->
 <!-- ==========  =======   ========   =======                              -->
 <!--     Yes      light      -2          -2                                -->
 <!--     Yes      1-hand     -4          -4                                -->
 <!--     No       light      -4          -8                                -->
 <!--     No       1-hand     -6         -10                                -->
 <!--=======================================================================-->
 <xsl:template name="twoweaponpenalty">
  <xsl:param name="offhandclass">
   <xsl:call-template name="guessoffhandweaponclass"/>
  </xsl:param>
  <xsl:param name="equipped" select="@equipped"/>
  <xsl:choose>
   <xsl:when test="$offhandclass='none'">0</xsl:when>
   <xsl:when test="not($equipped)">0</xsl:when>
   <xsl:when test="$equipped='bothhands'">0</xsl:when>
   <xsl:when test="$equipped='offhandonly'">0</xsl:when>
   <xsl:when test="count(../../feats/feat[@name='Two-weapon Fighting']) != 0 or (@name='Unarmed Strike' and count(../../attack/special[@name='Brawler, Greater']) != 0)">
    <xsl:choose>
     <xsl:when test="$offhandclass='light'">-2</xsl:when>
     <xsl:otherwise>-4</xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <xsl:otherwise>
    <xsl:choose>
     <xsl:when test="$offhandclass='light' and $equipped='mainhand'">-4</xsl:when>
     <xsl:when test="$offhandclass='light' and $equipped='offhand'">-8</xsl:when>
     <xsl:when test="$offhandclass='1-hand' and $equipped='mainhand'">-6</xsl:when>
     <xsl:otherwise>-10</xsl:otherwise>
    </xsl:choose>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the weapon attack bonus text.                                     -->
 <!-- The 'action' parameter should be one of:                              -->
 <!--     attack: a normal attack with multiple allowed (e.g., trip)        -->
 <!--     quick: a normal attack but must be the one with the highest bonus -->
 <!--            (e.g., reposition with the Quick Reposition feat)          -->
 <!--     standard: a standard action (e.g., bull rush)                     -->
 <!--=======================================================================-->
 <xsl:template name="weaponattackbonustext">
  <xsl:param name="attack"/>

  <!-- Display bonuses for multiple attacks by default.  If the action is
       a standard action, rather than in place of an attack, the caller
       should pass 'standard' instead.
    -->
  <xsl:param name="action">attack</xsl:param>

  <!-- Display the primary attack bonus text, unless the action is standard
       and this isn't the highest attack bonus.  That is, if the action is
       standard, skip if the attack bonus was calculated for a double attack
       or with an offhand penalty.
     -->
  <xsl:if test="($action!='standard') or ((@equipped!='double') and not((@equipped='mainhand') and (count(../../melee/weapon[@equipped='offhand'])!=0)))">
   <xsl:choose>
    <xsl:when test="($action!='attack') and contains($attack,'/')">
     <xsl:value-of select="substring-before($attack,'/')"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="$attack"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:if>

  <xsl:if test="contains(@categorytext,'Double Weapon')">
   <!-- Compute penalties for fighting with a double weapon. -->
   <xsl:variable name="penalty">
    <xsl:call-template name="twoweaponpenalty">
     <xsl:with-param name="offhandclass">light</xsl:with-param>
     <xsl:with-param name="equipped">mainhand</xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="offhandpenalty">
    <xsl:call-template name="twoweaponpenalty">
     <xsl:with-param name="offhandclass">light</xsl:with-param>
     <xsl:with-param name="equipped">offhand</xsl:with-param>
    </xsl:call-template>
   </xsl:variable>

   <xsl:choose>
    <xsl:when test="@equipped='double'">
     <xsl:if test="$action='attack'">
      <xsl:text>/</xsl:text>
      <xsl:call-template name="modifiedattack">
       <xsl:with-param name="mod" select="$offhandpenalty - $penalty"/>
       <xsl:with-param name="baseattack">
        <xsl:choose>
         <xsl:when test="contains($attack,'/')">
          <xsl:value-of select="substring-before($attack,'/')"/>
         </xsl:when>
         <xsl:otherwise>
          <xsl:value-of select="$attack"/>
         </xsl:otherwise>
        </xsl:choose>
       </xsl:with-param>
      </xsl:call-template>
     </xsl:if>
     <xsl:if test="$action!='standard'">
      (double) or
     </xsl:if>
     <xsl:call-template name="modifiedattack">
      <xsl:with-param name="mod" select="- $penalty"/>
      <xsl:with-param name="baseattack" select="$attack"/>
      <xsl:with-param name="action" select="$action"/>
     </xsl:call-template>
     <xsl:if test="$action!='standard'">
      <xsl:text> (single)</xsl:text>
     </xsl:if>
    </xsl:when>
    <xsl:otherwise>
     <xsl:if test="$action!='standard'">
      (single) or
      <xsl:call-template name="modifiedattack">
       <xsl:with-param name="mod" select="$penalty"/>
       <xsl:with-param name="baseattack" select="$attack"/>
      </xsl:call-template>
     </xsl:if>
     <xsl:if test="$action='attack'">
      <xsl:text>/</xsl:text>
      <xsl:call-template name="modifiedattack">
       <xsl:with-param name="mod" select="$offhandpenalty"/>
       <xsl:with-param name="baseattack">
        <xsl:choose>
         <xsl:when test="contains($attack,'/')">
          <xsl:value-of select="substring-before($attack,'/')"/>
         </xsl:when>
         <xsl:otherwise>
          <xsl:value-of select="$attack"/>
         </xsl:otherwise>
        </xsl:choose>
       </xsl:with-param>
      </xsl:call-template>
     </xsl:if>
     <xsl:if test="$action!='standard'">
      <xsl:text> (double)</xsl:text>
     </xsl:if>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:if>

  <xsl:if test="(@equipped='mainhand') and (count(../../melee/weapon[@equipped='offhand'])!=0)">
   <xsl:if test="$action!='standard'">
    (2 weapons) or
   </xsl:if>

   <!-- Show the attack bonus if using this weapon alone (no two-weapon
        penalties).  If the action is a standard action, this is the 
        highest attack bonus for the weapon, so always show it.
     -->
   <xsl:variable name="penalty">
    <xsl:call-template name="twoweaponpenalty"/>
   </xsl:variable>
   <xsl:call-template name="modifiedattack">
    <xsl:with-param name="mod" select="- $penalty"/>
    <xsl:with-param name="baseattack" select="$attack"/>
    <xsl:with-param name="action" select="$action"/>
   </xsl:call-template>

   <xsl:if test="$action!='standard'">
    <xsl:text> (alone)</xsl:text>
   </xsl:if>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the basic weapon bonus text for a given weapon.                   -->
 <!--=======================================================================-->
 <xsl:template name="getbasicweaponbonus">
  <xsl:call-template name="weaponattackbonustext">
   <xsl:with-param name="attack" select="@attack"/>
  </xsl:call-template>
  <xsl:if test="rangedattack/@attack != '' and rangedattack/@attack != @attack">
   <xsl:text>,</xsl:text><br/> ranged
   <xsl:call-template name="weaponattackbonustext">
    <xsl:with-param name="attack" select="rangedattack/@attack"/>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the effective bonus for using a combat maneuver instead of a      -->
 <!-- melee attack with a given weapon.                                     -->
 <!--=======================================================================-->
 <xsl:template name="getmaneuverbonus">
  <xsl:param name="type"/>
  <xsl:variable name="cmb">
   <xsl:call-template name="modtonumber">
    <xsl:with-param name="mod">
     <xsl:value-of select="../../maneuvers/maneuvertype[@name=$type]/@cmb"/>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="meleeattack">
   <xsl:call-template name="modtonumber">
    <xsl:with-param name="mod">
     <xsl:value-of select="../../attack/@meleeattack"/>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$cmb - $meleeattack"/>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the effective bonus for using a bull rush combat maneuver with a  -->
 <!-- given weapon.                                                         -->
 <!--=======================================================================-->
 <xsl:template name="getbullrushbonus">
  <xsl:variable name="isbullrush">
   <xsl:call-template name="isbullrushweapon"/>
  </xsl:variable>
  <xsl:if test="$isbullrush='true'">
   <xsl:variable name="bullrushbonus">
    <xsl:call-template name="getmaneuverbonus">
     <xsl:with-param name="type">Bull Rush</xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   <xsl:call-template name="weaponattackbonustext">
    <xsl:with-param name="attack">
     <xsl:call-template name="modifiedattack">
      <xsl:with-param name="mod" select="$bullrushbonus - 4"/>
      <xsl:with-param name="baseattack" select="@attack"/>
     </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="action">standard</xsl:with-param>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the effective bonus for using a disarm combat maneuver with a     -->
 <!-- given weapon.                                                         -->
 <!--=======================================================================-->
 <xsl:template name="getdisarmbonus">
  <xsl:param name="force">false</xsl:param>
  <xsl:variable name="isdisarm">
   <xsl:call-template name="isdisarmweapon"/>
  </xsl:variable>
  <xsl:if test="($isdisarm='true') or ($force='true') or (count(../../feats/feat[contains(@name,'Disarm')]) != 0)">
   <xsl:variable name="disarmbonus">
    <xsl:call-template name="getmaneuverbonus">
     <xsl:with-param name="type">Disarm</xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   <xsl:call-template name="weaponattackbonustext">
    <xsl:with-param name="attack">
     <xsl:call-template name="modifiedattack">
      <xsl:with-param name="mod"> 
       <xsl:choose>
        <xsl:when test="$isdisarm='true'">
         <xsl:value-of select="$disarmbonus + 2"/>
        </xsl:when>
        <xsl:when test="@name='Unarmed Strike'">
         <xsl:value-of select="$disarmbonus - 4"/>
        </xsl:when>
        <xsl:otherwise>
         <xsl:value-of select="$disarmbonus"/>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="baseattack" select="@attack"/>
     </xsl:call-template>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the effective bonus for using a drag combat maneuver with a       -->
 <!-- given weapon.                                                         -->
 <!--=======================================================================-->
 <xsl:template name="getdragbonus">
  <xsl:variable name="istrip">
   <xsl:call-template name="istripweapon"/>
  </xsl:variable>
  <xsl:if test="($istrip='true') or (contains(@name,'Net') and count(../../feats/feat[@name='Net Maneuvering']) != 0)">
   <xsl:variable name="dragbonus">
    <xsl:call-template name="getmaneuverbonus">
     <xsl:with-param name="type">Drag</xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   <xsl:call-template name="weaponattackbonustext">
    <xsl:with-param name="attack">
     <xsl:call-template name="modifiedattack">
      <xsl:with-param name="mod" select="$dragbonus"/>
      <xsl:with-param name="baseattack" select="@attack"/>
     </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="action">standard</xsl:with-param>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the effective bonus for using a grapple combat maneuver with a    -->
 <!-- given weapon.                                                         -->
 <!--=======================================================================-->
 <xsl:template name="getgrapplebonus">
  <xsl:variable name="isgrapple">
   <xsl:call-template name="isgrappleweapon"/>
  </xsl:variable>
  <xsl:if test="$isgrapple='true'">
   <xsl:variable name="grapplebonus">
    <xsl:call-template name="getmaneuverbonus">
     <xsl:with-param name="type">Grapple</xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   <xsl:call-template name="weaponattackbonustext">
    <xsl:with-param name="attack">
     <xsl:call-template name="modifiedattack">
      <xsl:with-param name="mod" select="$grapplebonus"/>
      <xsl:with-param name="baseattack" select="@attack"/>
     </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="action">standard</xsl:with-param>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the effective bonus for using a reposition combat maneuver with a -->
 <!-- given weapon.                                                         -->
 <!--=======================================================================-->
 <xsl:template name="getrepositionbonus">
  <xsl:variable name="istrip">
   <xsl:call-template name="istripweapon"/>
  </xsl:variable>
  <xsl:if test="($istrip='true') or (contains(@name,'Net') and count(../../feats/feat[@name='Net Maneuvering']) != 0)">
   <xsl:variable name="repositionbonus">
    <xsl:call-template name="getmaneuverbonus">
     <xsl:with-param name="type">Reposition</xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   <xsl:call-template name="weaponattackbonustext">
    <xsl:with-param name="attack">
     <xsl:call-template name="modifiedattack">
      <xsl:with-param name="mod" select="$repositionbonus"/>
      <xsl:with-param name="baseattack" select="@attack"/>
     </xsl:call-template>
    </xsl:with-param>
    <!-- The Quick Reposition feat turns this into an attack action,
         but it still can only be done once at the highest attack bonus.
      -->
    <xsl:with-param name="action">
     <xsl:choose>
      <xsl:when test="count(../../feats/feat[@name='Quick Reposition']) != 0">quick</xsl:when>
      <xsl:otherwise>standard</xsl:otherwise>
     </xsl:choose>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the effective bonus for using a steal combat maneuver with a      -->
 <!-- given weapon.                                                         -->
 <!--=======================================================================-->
 <xsl:template name="getstealbonus">
  <xsl:variable name="issteal">
   <xsl:call-template name="isstealweapon"/>
  </xsl:variable>
  <xsl:if test="$issteal='true'">
   <xsl:variable name="stealbonus">
    <xsl:call-template name="getmaneuverbonus">
     <xsl:with-param name="type">Steal</xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   <xsl:call-template name="weaponattackbonustext">
    <xsl:with-param name="attack">
     <xsl:call-template name="modifiedattack">
      <xsl:with-param name="mod" select="$stealbonus - 4"/>
      <xsl:with-param name="baseattack" select="@attack"/>
     </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="action">standard</xsl:with-param>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the effective bonus for using a sunder combat maneuver with a     -->
 <!-- given weapon.                                                         -->
 <!--=======================================================================-->
 <xsl:template name="getsunderbonus">
  <xsl:param name="force">false</xsl:param>
  <xsl:if test="($force='true') or (count(../../feats/feat[contains(@name,'Sunder')]) != 0)">
   <xsl:variable name="sunderbonus">
    <xsl:call-template name="getmaneuverbonus">
     <xsl:with-param name="type">Sunder</xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   <xsl:call-template name="weaponattackbonustext">
    <xsl:with-param name="attack">
     <xsl:call-template name="modifiedattack">
      <xsl:with-param name="mod" select="$sunderbonus"/>
      <xsl:with-param name="baseattack" select="@attack"/>
     </xsl:call-template>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the effective bonus for using a trip combat maneuver with a       -->
 <!-- given weapon.                                                         -->
 <!--=======================================================================-->
 <xsl:template name="gettripbonus">
  <xsl:param name="force">false</xsl:param>
  <xsl:variable name="istrip">
   <xsl:call-template name="istripweapon"/>
  </xsl:variable>
  <xsl:if test="($istrip='true') or ($force='true') or (count(../../feats/feat[contains(@name,'Trip')]) != 0 and local-name(..)!='ranged')">
   <xsl:variable name="tripbonus">
    <xsl:call-template name="getmaneuverbonus">
     <xsl:with-param name="type">Trip</xsl:with-param>
    </xsl:call-template>
   </xsl:variable>
   <xsl:call-template name="weaponattackbonustext">
    <xsl:with-param name="attack">
     <xsl:call-template name="modifiedattack">
      <xsl:with-param name="mod" select="$tripbonus"/>
      <xsl:with-param name="baseattack" select="@attack"/>
     </xsl:call-template>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess whether weapon is a nonlethal weapon.                           -->
 <!--=======================================================================-->
 <xsl:template name="isnonlethalweapon">
  <xsl:choose>
   <xsl:when test="contains(@name,'Bolas')">yes</xsl:when>
   <xsl:when test="contains(@name,'nine-tails')">true</xsl:when>
   <xsl:when test="contains(@name,'Sling bullets, little starstone')">yes</xsl:when>
   <xsl:when test="contains(@name,'Sling bullets, softstone')">yes</xsl:when>
   <xsl:when test="contains(@name,'Sap')">yes</xsl:when>
   <xsl:when test="contains(@name,'Unarmed Strike') and count(../../feats/feat[@name='Improved Unarmed Strike']) = 0">yes</xsl:when>
   <xsl:when test="contains(@name,'Whip') and not(contains(@name,'Frostkiss')) and not(contains(@name,'Nine-section')) and not(contains(@name,'Scorpion')) and count(../../feats/feat[@name='Whip Mastery']) = 0">yes</xsl:when>
   <xsl:otherwise>no</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess whether weapon is a trip weapon.                                -->
 <!--=======================================================================-->
 <xsl:template name="istripweapon">
  <xsl:choose>
   <xsl:when test="contains(@name,'Aklys')">true</xsl:when>
   <xsl:when test="contains(@name,'Bola')">true</xsl:when>
   <xsl:when test="contains(@name,'Chain spear')">true</xsl:when>
   <xsl:when test="contains(@name,'Fauchard')">true</xsl:when>
   <xsl:when test="contains(@name,'Flail')">true</xsl:when>
   <xsl:when test="contains(@name,'Flickmace')">true</xsl:when>
   <xsl:when test="contains(@name,'Flindbar')">true</xsl:when>
   <xsl:when test="contains(@name,'Gaff')">true</xsl:when>
   <xsl:when test="contains(@name,'Gnome hooked hammer')">true</xsl:when>
   <xsl:when test="contains(@name,'Guisarme') and not(contains(@name,'Glaive'))">true</xsl:when>
   <xsl:when test="contains(@name,'Halberd')">true</xsl:when>
   <xsl:when test="contains(@name,'Hooked axe')">true</xsl:when>
   <xsl:when test="contains(@name,'Hooked lance')">true</xsl:when>
   <xsl:when test="contains(@name,'Horsechopper')">true</xsl:when>
   <xsl:when test="contains(@name,'Kama')">true</xsl:when>
   <xsl:when test="contains(@name,'Khopesh')">true</xsl:when>
   <xsl:when test="contains(@name,'Kusarigama')">true</xsl:when>
   <xsl:when test="contains(@name,'Meteor hammer')">true</xsl:when>
   <xsl:when test="contains(@name,'Ogre hook')">true</xsl:when>
   <xsl:when test="contains(@name,'Quarterstaff') and count(../../feats/feat[@name='Tripping Staff']) != 0">true</xsl:when>
   <xsl:when test="contains(@name,'Scarf, bladed')">true</xsl:when>
   <xsl:when test="contains(@name,'Scythe')">true</xsl:when>
   <xsl:when test="contains(@name,'Shang gou')">true</xsl:when>
   <xsl:when test="contains(@name,'Sickle')">true</xsl:when>
   <xsl:when test="contains(@name,'Spiked chain')">true</xsl:when>
   <xsl:when test="contains(@name,'Stitched sling, halfling')">true</xsl:when>
   <xsl:when test="contains(@name,'Temple sword')">true</xsl:when>
   <xsl:when test="contains(@name,'Throwing Shield')">true</xsl:when>
   <xsl:when test="contains(@name,'Whip')">true</xsl:when>
   <xsl:when test="contains(@name,'Rod of the python') and count(../../feats/feat[@name='Tripping Staff']) != 0">true</xsl:when>
   <xsl:when test="contains(@name,'Staff of power') and count(../../feats/feat[@name='Tripping Staff']) != 0">true</xsl:when>
   <xsl:when test="contains(@name,'Staff of the woodlands') and count(../../feats/feat[@name='Tripping Staff']) != 0">true</xsl:when>
   <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess whether weapon is a blocking weapon.                            -->
 <!--=======================================================================-->
 <xsl:template name="isblockingweapon">
  <xsl:choose>
   <xsl:when test="contains(@name,'Bo staff')">true</xsl:when>
   <xsl:when test="contains(@name,'Dan bong')">true</xsl:when>
   <xsl:when test="contains(@name,'Rope dart')">true</xsl:when>
   <xsl:when test="contains(@name,'Sansetsukon')">true</xsl:when>
   <xsl:when test="contains(@name,'Tonfa')">true</xsl:when>
   <xsl:when test="contains(@name,'Nine-section whip')">true</xsl:when>
   <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess whether weapon is a brace weapon. -->
 <!--=======================================================================-->
 <xsl:template name="isbraceweapon">
  <xsl:choose>
   <xsl:when test="contains(@name,'Bardiche')">true</xsl:when>
   <xsl:when test="contains(@name,'Bec de corbin')">true</xsl:when>
   <xsl:when test="contains(@name,'Bill')">true</xsl:when>
   <xsl:when test="contains(@name,'Boar spear')">true</xsl:when>
   <xsl:when test="contains(@name,'Dwarven urgosh')">true</xsl:when>
   <xsl:when test="contains(@name,'Glaive-guisarme')">true</xsl:when>
   <xsl:when test="contains(@name,'Halberd')">true</xsl:when>
   <xsl:when test="contains(@name,'Horsechopper')">true</xsl:when>
   <xsl:when test="contains(@name,'Longspear')">true</xsl:when>
   <xsl:when test="contains(@name,'Lucerne hammer')">true</xsl:when>
   <xsl:when test="contains(@name,'Nodachi')">true</xsl:when>
   <xsl:when test="contains(@name,'Rhomphaia')">true</xsl:when>
   <xsl:when test="contains(@name,'Spear')">true</xsl:when>
   <xsl:when test="contains(@name,'Tiger fork')">true</xsl:when>
   <xsl:when test="contains(@name,'Trident')">true</xsl:when>
   <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess whether weapon is a deadly weapon.                              -->
 <!--=======================================================================-->
 <xsl:template name="isdeadlyweapon">
  <xsl:choose>
   <xsl:when test="contains(@name,'Katana') and not(contains(@name,'double'))">true</xsl:when>
   <xsl:when test="contains(@name,'Wakizashi')">true</xsl:when>
   <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess whether weapon is a disarm weapon. -->
 <!--=======================================================================-->
 <xsl:template name="isdisarmweapon">
  <xsl:choose>
   <xsl:when test="contains(@name,'Bill')">true</xsl:when>
   <xsl:when test="contains(@name,'Double chicken saber')">true</xsl:when>
   <xsl:when test="contains(@name,'Flail')">true</xsl:when>
   <xsl:when test="contains(@name,'Flindbar')">true</xsl:when>
   <xsl:when test="contains(@name,'Hooked axe')">true</xsl:when>
   <xsl:when test="contains(@name,'Gaff')">true</xsl:when>
   <xsl:when test="contains(@name,'Jutte')">true</xsl:when>
   <xsl:when test="contains(@name,'Kyoketsu shoge')">true</xsl:when>
   <xsl:when test="contains(@name,'Nunchaku')">true</xsl:when>
   <xsl:when test="contains(@name,'Net') and count(../../feats/feat[@name='Net Maneuvering']) != 0">true</xsl:when>
   <xsl:when test="contains(@name,'nine-tails')">true</xsl:when>
   <xsl:when test="contains(@name,'Ranseur')">true</xsl:when>
   <xsl:when test="contains(@name,'Sai')">true</xsl:when>
   <xsl:when test="contains(@name,'Sansetsukon')">true</xsl:when>
   <xsl:when test="contains(@name,'Scarf, bladed')">true</xsl:when>
   <xsl:when test="contains(@name,'Shang gou')">true</xsl:when>
   <xsl:when test="contains(@name,'Spiked chain')">true</xsl:when>
   <xsl:when test="contains(@name,'Stitched sling, halfling')">true</xsl:when>
   <xsl:when test="contains(@name,'Seven-branched sword')">true</xsl:when>
   <xsl:when test="contains(@name,'Swordbreaker dagger')">true</xsl:when>
   <xsl:when test="contains(@name,'Tekko-kagi')">true</xsl:when>
   <xsl:when test="contains(@name,'Wahaika')">true</xsl:when>
   <xsl:when test="(contains(@name,'Whip') or contains(@name,'whip')) and not(contains(@name,'Nine-section'))">true</xsl:when>
   <xsl:when test="contains(@name,'Fork of the Forgotten One')">true</xsl:when>
   <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess whether weapon is a distracting weapon.                         -->
 <!--=======================================================================-->
 <xsl:template name="isdistractingweapon">
  <xsl:choose>
   <xsl:when test="contains(@name,'Fighting fan')">true</xsl:when>
   <xsl:when test="contains(@name,'Nine-section whip')">true</xsl:when>
   <xsl:when test="contains(@name,'Rope dart')">true</xsl:when>
   <xsl:when test="contains(@name,'Urumi')">true</xsl:when>
   <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess whether weapon is a grapple weapon.  Note that Ultimate Combat  -->
 <!-- is inconsistent between 'grapple' vs. 'grappling'.                    -->
 <!--=======================================================================-->
 <xsl:template name="isgrappleweapon">
  <xsl:choose>
   <xsl:when test="contains(@name,'Garrote')">true</xsl:when>
   <xsl:when test="contains(@name,'Harpoon')">true</xsl:when>
   <xsl:when test="contains(@name,'Kusarigama')">true</xsl:when>
   <xsl:when test="contains(@name,'Kyoketsu shoge')">true</xsl:when>
   <xsl:when test="contains(@name,'Mancatcher')">true</xsl:when>
   <xsl:when test="contains(@name,'Sibat')">true</xsl:when>
   <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess whether weapon is a monk weapon.                                -->
 <!--=======================================================================-->
 <xsl:template name="ismonkweapon">
  <xsl:choose>
   <xsl:when test="count(../../classes/class[contains(@name,'Monk')]) = 0">false</xsl:when>
   <xsl:when test="contains(@name,'Bo staff')">true</xsl:when>
   <xsl:when test="contains(@name,'Brass knuckles')">true</xsl:when>
   <xsl:when test="contains(@name,'Broadsword, nine ring')">true</xsl:when>
   <xsl:when test="contains(@name,'Butterfly sword')">true</xsl:when>
   <xsl:when test="contains(@name,'Cestus')">true</xsl:when>
   <xsl:when test="contains(@name,'Dan bong')">true</xsl:when>
   <xsl:when test="contains(@name,'Double chicken saber')">true</xsl:when>
   <xsl:when test="contains(@name,'Emei piercer')">true</xsl:when>
   <xsl:when test="contains(@name,'Fighting fan')">true</xsl:when>
   <xsl:when test="contains(@name,'Jutte')">true</xsl:when>
   <xsl:when test="contains(@name,'Kama')">true</xsl:when>
   <xsl:when test="contains(@name,'Knuckle axe')">true</xsl:when>
   <xsl:when test="contains(@name,'Kyoketsu shoge')">true</xsl:when>
   <xsl:when test="contains(@name,'Lungchuan tamo')">true</xsl:when>
   <xsl:when test="contains(@name,'Monk')">true</xsl:when>
   <xsl:when test="contains(@name,'Nunchaku')">true</xsl:when>
   <xsl:when test="contains(@name,'Nine-section whip')">true</xsl:when>
   <xsl:when test="contains(@name,'Quarterstaff')">true</xsl:when>
   <xsl:when test="contains(@name,'Rope dart')">true</xsl:when>
   <xsl:when test="contains(@name,'Sai')">true</xsl:when>
   <xsl:when test="contains(@name,'Sansetsukon')">true</xsl:when>
   <xsl:when test="contains(@name,'Seven-branched sword')">true</xsl:when>
   <xsl:when test="contains(@name,'Shang gou')">true</xsl:when>
   <xsl:when test="contains(@name,'Shuriken')">true</xsl:when>
   <xsl:when test="contains(@name,'Siangham')">true</xsl:when>
   <xsl:when test="contains(@name,'Temple sword')">true</xsl:when>
   <xsl:when test="contains(@name,'Tiger fork')">true</xsl:when>
   <xsl:when test="contains(@name,'Tonfa')">true</xsl:when>
   <xsl:when test="contains(@name,'Wushu dart')">true</xsl:when>
   <xsl:when test="contains(@name,'Rod of the python')">true</xsl:when>
   <xsl:when test="contains(@name,'Staff of power')">true</xsl:when>
   <xsl:when test="contains(@name,'Staff of the woodlands')">true</xsl:when>
   <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess whether weapon is a steal weapon.  That is, whether the weapon  -->
 <!-- can be used to perform a steal maneuver.                              -->
 <!--=======================================================================-->
 <xsl:template name="isstealweapon">
  <xsl:choose>
   <xsl:when test="(contains(@name,'Whip') or contains(@name,'whip')) and not(contains(@name,'Nine-section'))">true</xsl:when>
   <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess whether weapon is a bull rush weapon.  That is, whether the     -->
 <!-- weapon can be used to perform a bull rush maneuver with the           -->
 <!-- "Sweeping Fend" ability.                                              -->
 <!--=======================================================================-->
 <xsl:template name="isbullrushweapon">
  <xsl:variable name="sweepingfend">
   <xsl:choose>
    <xsl:when test="count(../../otherspecials/special[@shortname='Sweeping Fend']) = 0">false</xsl:when>
    <xsl:otherwise>true</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:variable name="trickshot">
   <xsl:choose>
    <xsl:when test="count(../../otherspecials/special[@shortname='Trick Shot: Bull Rush']) = 0">false</xsl:when>
    <xsl:otherwise>true</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:choose>
   <!-- Weapons in the 'Polearms' list: -->
   <xsl:when test="contains(@name,'Bardiche')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Bec de corbin')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Bill')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Fauchard')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Flailpole')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Glaive')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Guisarme')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Halberd')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Lucerne hammer')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Mancatcher')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Naginata')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Nodachi')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Ranseur')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Rhomphaia')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'spade')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Tepoztopilli')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Tiger fork')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Fork of the Forgotten One')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <!-- Weapons in the 'Spears' list: -->
   <xsl:when test="contains(@name,'Amentum')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Harpoon')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Javelin')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Lance')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Pilum')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Sibat')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'spear')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Spear')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <xsl:when test="contains(@name,'Trident')"><xsl:value-of select="$sweepingfend"/></xsl:when>
   <!-- Weapons in the 'Bows' list: -->
   <xsl:when test="contains(@name,'Bow')"><xsl:value-of select="$trickshot"/></xsl:when>
   <xsl:when test="contains(@name,'Shortbow')"><xsl:value-of select="$trickshot"/></xsl:when>
   <xsl:when test="contains(@name,'Longbow')"><xsl:value-of select="$trickshot"/></xsl:when>
   <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Determine whether a feat is a common proficiency.                     -->
 <!--=======================================================================-->
 <xsl:template name="iscommonproficiency">
  <xsl:choose>
   <xsl:when test="@name='Armor Proficiency (Light)'">true</xsl:when>
   <xsl:when test="@name='Armor Proficiency (Medium)'">true</xsl:when>
   <xsl:when test="@name='Armor Proficiency (Heavy)'">true</xsl:when>
   <xsl:when test="@name='Martial Weapon Proficiency - All'">true</xsl:when>
   <xsl:when test="@name='Shield Proficiency'">true</xsl:when>
   <xsl:when test="@name='Simple Weapon Proficiency - All'">true</xsl:when>
   <xsl:when test="@name='Tower Shield Proficiency'">true</xsl:when>
   <xsl:when test="contains(@name,'Weapon Proficiencies')">true</xsl:when>
   <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Convert a size letter (F,D,T,S,M,L,H,G,C) to a number.                -->
 <!--=======================================================================-->
 <xsl:template name="sizelettertonumber">
  <xsl:param name="size"/>
  <xsl:value-of select="string-length(substring-before(' FDTSMLHGC',$size))"/>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the current character's size number.                              -->
 <!-- This assumes the current context is two levels below 'character'.     -->
 <!--=======================================================================-->
 <xsl:template name="getwieldersize">
  <xsl:call-template name="sizelettertonumber">
   <xsl:with-param name="size" select="substring(../../size/@name,1,1)"/>
  </xsl:call-template>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get the current weapon's size number.                                 -->
 <!-- This assumes the current context is two levels below 'character'.     -->
 <!--=======================================================================-->
 <xsl:template name="getweaponsizemod">
  <xsl:choose>
   <xsl:when test="@size">
    <xsl:call-template name="sizelettertonumber">
     <xsl:with-param name="size" select="substring(@size,2,1)"/>
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="getwieldersize"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess weapon class (light vs. one-handed) of the named weapon.        -->
 <!-- This is not 100% reliable since there may be custom weapons, and      -->
 <!-- named magic items that don't contain a standard weapon name.          -->
 <!-- However, it's the best we can do given that HeroLab doesn't currently -->
 <!-- provide the info in the XML.                                          -->
 <!-- TODO: handle size difference                                          -->
 <!--=======================================================================-->
 <xsl:template name="guessweaponclass">
  <xsl:param name="weaponname" select="@name"/>
  <xsl:param name="useradded" select="@useradded"/>
  <!-- Set 'base' to 0 (light), 1 (1-hand), 2 (2-hand), or double. -->
  <xsl:variable name="base">
   <xsl:choose>
    <!-- Guess that all non-useradded weapons are Light. -->
    <xsl:when test="$useradded='no'">0</xsl:when>
    <!-- Light weapons -->
    <xsl:when test="contains($weaponname,'Aklys')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Barbazu beard')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Battle aspergillum')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Battle poi')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Bich')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Blade boot')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Blowgun')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Bola')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Brass knuckles')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Cestus')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Hand')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Crystal chakram')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Cutlass')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Dagger')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Dan bong')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Dart')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Dogslicer')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Emei piercer')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Fangfile')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Fighting fan')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Firearm Bayonet, Pistol')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Firearm, Pistol')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Flask thrower')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Gauntlet')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Gladius')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Iron brush')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Javelin') and not(contains($weaponname,'Shrillshaft'))">0</xsl:when>
    <xsl:when test="contains($weaponname,'Jutte')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Kama')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Katar')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Kerambit')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Klar')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Switchblade knife')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Knuckle axe')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Kukri')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Light hammer')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Light mace')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Light pick')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Lungchuan tamo')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Madu')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Maulaxe')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Net')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Nunchaku')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Pata')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Quadrens')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Sai')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Sap')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Scorpion whip')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Shang gou')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Shortsword')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Shuriken')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Siangham')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Sica')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Sickle')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Sling glove')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Halfling')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Starknife')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Butterfly sword')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Tekko-kagi')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Throwing axe')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Tonfa')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Touch Attack')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Wakizashi')">0</xsl:when>
    <xsl:when test="contains($weaponname,'War razor')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Wooden stake')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Wushu dart')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Blade of the willing martyr')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Buffoon')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Guarding blade')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Luck blade')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Machete of clearing')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Ricochet hammer')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Rod of alertness')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Rod of the uraeus')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Rod of thunder and lightning')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Rod of withering')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Spirit blade')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Stinging stiletto')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Sun blade')">0</xsl:when>
    <xsl:when test="contains($weaponname,'Sword of subtlety')">0</xsl:when>
    <!-- Double weapons -->
    <xsl:when test="contains($weaponname,'Orc double axe')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Battle ladder')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Chain spear')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Dire flail')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Dwarven urgosh')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Double sling')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Gnome hooked hammer')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Meteor hammer')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Quarterstaff')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Two-bladed sword')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Rod of flailing')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Rod of the python')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Shifter')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Staff of power')">double</xsl:when>
    <xsl:when test="contains($weaponname,'Staff of the woodlands')">double</xsl:when>
    <!-- 2-hand weapons -->
    <xsl:when test="contains($weaponname,'Bardiche')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Bayonet')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Bec de corbin')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Bill')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Blackaxe')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Boar spear')">2</xsl:when>
    <xsl:when test="contains($weaponname,'bow') or contains($weaponname,'Bow')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Curve blade')">2</xsl:when>
    <xsl:when test="contains($weaponname,'dorn-dergar')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Earth breaker')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Falchion')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Fauchard')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Flailpole')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Flambard')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Garrote')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Glaive')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Great')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Guisarme')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Halberd')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Heavy flail')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Horsechopper')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Lance')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Longspear')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Lucerne hammer')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Mancatcher')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Musket')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Ogre hook')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Piston maul')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Ranseur')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Scarf, bladed')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Scythe')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Spear')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Spiked chain')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Switchscythe')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Trident')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Berserking sword')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Blade of binding')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Crowcaller')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Executioner')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Fork of the Forgotten One')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Frost brand')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Hellcaller')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Jorngarl')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Life-drinker')">2</xsl:when>
    <xsl:when test="contains($weaponname,'Maul')">2</xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:choose>
   <!-- We don't currently handle odd-sized double weapons any differently. -->
   <xsl:when test="$base='double'">double</xsl:when>
   <xsl:otherwise>
    <xsl:variable name="weaponsizemod">
     <xsl:call-template name="getweaponsizemod"/>
    </xsl:variable>
    <xsl:variable name="wieldersize">
     <xsl:call-template name="getwieldersize"/>
    </xsl:variable>
    <xsl:variable name="delta" select="$base + $weaponsizemod - $wieldersize"/>
    <xsl:choose>
     <xsl:when test="$delta=2">2-hand</xsl:when>
     <xsl:when test="$delta=1">1-hand</xsl:when>
     <xsl:when test="$delta=0">light</xsl:when>
     <xsl:otherwise>unusable</xsl:otherwise>
    </xsl:choose>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Guess weapon class (light vs. one-handed) of the offhand weapon.      -->
 <!--=======================================================================-->
 <xsl:template name="guessoffhandweaponclass">
  <xsl:choose>
   <xsl:when test="count(../../*/weapon[@equipped='offhand'])=0">none</xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="guessweaponclass">
     <xsl:with-param name="weaponname" select="../../*/weapon[@equipped='offhand']/@name"/>
     <xsl:with-param name="useradded" select="../../*/weapon[@equipped='offhand']/@useradded"/>
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get a modified attack modifier.                                       -->
 <!--=======================================================================-->
 <xsl:template name="modifiedattack">
  <xsl:param name="mod">0</xsl:param>
  <xsl:param name="baseattack"/>
  <xsl:param name="action">attack</xsl:param>
  <xsl:variable name="baseattacknumber">
   <xsl:call-template name="modtonumber">
    <xsl:with-param name="mod">
     <xsl:value-of select="$baseattack"/>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="modifiedattacknumber" select="$baseattacknumber + $mod"/>
  <xsl:variable name="modifiedattackmod">
   <xsl:call-template name="numbertomod">
    <xsl:with-param name="n">
     <xsl:value-of select="$modifiedattacknumber"/>
    </xsl:with-param>
    <xsl:with-param name="showzero">yes</xsl:with-param>
   </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$modifiedattackmod"/>
  <xsl:if test="($action='attack') and contains($baseattack,'/')">
   <xsl:text>/</xsl:text>
   <xsl:call-template name="modifiedattack">
    <xsl:with-param name="mod" select="$mod"/>
    <xsl:with-param name="baseattack" select="substring-after($baseattack,'/')"/>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get weapon name text. -->
 <!--=======================================================================-->
 <xsl:template name="getweaponnametext">
  <xsl:param name="type">standard</xsl:param>
  <xsl:variable name="weaponclass">
   <xsl:call-template name="guessweaponclass"/>
  </xsl:variable>
  <xsl:variable name="isoffhand" select="($type='standard') and (@equipped = 'offhand')"/>
  <xsl:variable name="isblocking">
   <xsl:call-template name="isblockingweapon"/>
  </xsl:variable>
  <xsl:variable name="isbrace">
   <xsl:call-template name="isbraceweapon"/>
  </xsl:variable>
  <xsl:variable name="isbullrush">
   <xsl:call-template name="isbullrushweapon"/>
  </xsl:variable>
  <xsl:variable name="isdeadly">
   <xsl:call-template name="isdeadlyweapon"/>
  </xsl:variable>
  <xsl:variable name="isdisarm">
   <xsl:call-template name="isdisarmweapon"/>
  </xsl:variable>
  <xsl:variable name="isdistracting">
   <xsl:call-template name="isdistractingweapon"/>
  </xsl:variable>
  <xsl:variable name="isgrapple">
   <xsl:call-template name="isgrappleweapon"/>
  </xsl:variable>
  <xsl:variable name="ismonk">
   <xsl:call-template name="ismonkweapon"/>
  </xsl:variable>
  <xsl:variable name="issteal">
   <xsl:call-template name="isstealweapon"/>
  </xsl:variable>
  <xsl:variable name="istrip">
   <xsl:call-template name="istripweapon"/>
  </xsl:variable>

  <xsl:choose>
   <xsl:when test="contains(@name,'&#xA;')">
    <xsl:value-of select="substring-before(@name,'&#xA;')"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="@name"/>
   </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="$type='standard' or $isoffhand='true' or $isblocking='true' or $isbrace='true' or $isdeadly='true' or $isdisarm='true' or $isdistracting='true' or $isgrapple='true' or $ismonk='true' or $istrip='true'"> (</xsl:if>

   <xsl:if test="$type='standard'">
    <xsl:value-of select="$weaponclass"/>
   </xsl:if>

   <xsl:if test="$isoffhand='true'">
    <xsl:if test="$type='standard'">, </xsl:if>
    <xsl:text>offhand</xsl:text>
   </xsl:if>

   <xsl:if test="$isblocking='true'">
    <xsl:if test="$type='standard' or $isoffhand='true'">, </xsl:if>
    <xsl:text>blocking</xsl:text>
   </xsl:if>

   <xsl:if test="$isbrace='true'">
    <xsl:if test="$type='standard' or $isoffhand='true' or $isblocking='true'">, </xsl:if>
    <xsl:text>brace</xsl:text>
   </xsl:if>

   <xsl:if test="$isdeadly='true'">
    <xsl:if test="$type='standard' or $isoffhand='true' or $isblocking='true' or $isbrace='true'">, </xsl:if>
    <xsl:text>deadly</xsl:text>
   </xsl:if>

   <xsl:if test="$isdisarm='true'">
    <xsl:if test="$type='standard' or $isoffhand='true' or $isblocking='true' or $isbrace='true' or $isdeadly='true'">, </xsl:if>
    <xsl:text>disarm</xsl:text>
   </xsl:if>

   <xsl:if test="$isdistracting='true'">
    <xsl:if test="$type='standard' or $isoffhand='true' or $isblocking='true' or $isbrace='true' or $isdeadly='true' or $isdisarm='true'">, </xsl:if>
    <xsl:text>distracting</xsl:text>
   </xsl:if>

   <xsl:if test="$isgrapple='true'">
    <xsl:if test="$type='standard' or $isoffhand='true' or $isblocking='true' or $isbrace='true' or $isdeadly='true' or $isdisarm='true' or $isdistracting='true'">, </xsl:if>
    <xsl:text>grapple</xsl:text>
   </xsl:if>

   <xsl:if test="$ismonk='true'">
    <xsl:if test="$type='standard' or $isoffhand='true' or $isblocking='true' or $isbrace='true' or $isdeadly='true' or $isdisarm='true' or $isdistracting='true' or $isgrapple='true'">, </xsl:if>
    <xsl:text>monk</xsl:text>
   </xsl:if>

   <xsl:if test="$istrip='true'">
    <xsl:if test="$type='standard' or $isoffhand='true' or $isblocking='true' or $isbrace='true' or $isdeadly='true' or $isdisarm='true' or $isdistracting='true' or $isgrapple='true' or $ismonk='true'">, </xsl:if>
    <xsl:text>trip</xsl:text>
   </xsl:if>

  <xsl:if test="$type='standard' or $isoffhand='true' or $isblocking='true' or $isbrace='true' or $isdeadly='true' or $isdisarm='true' or $isdistracting='true' or $isgrapple='true' or $ismonk='true' or $istrip='true'">)</xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get weapon range text.                                                -->
 <!-- The best discussion of reach seems to be at                           -->
 <!-- http://paizo.com/paizo/messageboards/paizoPublishing/pathfinder/      -->
 <!--     pathfinderRPG/rules/whatIsTheReachOfAColossalSizedLongSpearOrWhip -->
 <!--=======================================================================-->
 <xsl:template name="getweaponrangetext">
  <xsl:if test="contains(@categorytext,'Reach Weapon')">
   <xsl:choose>
    <xsl:when test="../../size/@name='Tiny'">5</xsl:when>
    <xsl:when test="(contains(@name, 'Whip') or (contains(@name, 'whip'))) and not(contains(@name, 'Nine-section'))">
     <xsl:value-of select="../../size/reach/@value * 3"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="../../size/reach/@value * 2"/>
    </xsl:otherwise>
   </xsl:choose>
   <xsl:text>' reach</xsl:text>
  </xsl:if>
  <xsl:value-of select="rangedattack/@rangeinctext"/>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get weapon attack text for 2-weapon table.                            -->
 <!--=======================================================================-->
 <xsl:template name="getweaponattacktext">
  <!-- Display bonuses for multiple attacks by default.  If the action is
       a standard action, rather than in place of an attack, the caller
       should pass 'standard' instead.
    -->
  <xsl:param name="action">attack</xsl:param>
  <xsl:param name="offhandclass">
   <xsl:call-template name="guessoffhandweaponclass"/>
  </xsl:param>
  <xsl:param name="equipped" select="@equipped"/>

  <xsl:variable name="penalty">
   <xsl:call-template name="twoweaponpenalty">
    <xsl:with-param name="offhandclass" select="$offhandclass"/>
    <xsl:with-param name="equipped" select="$equipped"/>
   </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="equippedpenalty">
   <xsl:call-template name="twoweaponpenalty"/>
  </xsl:variable>

  <xsl:variable name="attackmod">
   <xsl:call-template name="modtonumber">
    <xsl:with-param name="mod">
     <xsl:value-of select="../../attack/@attackbonus"/>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="weaponattackmod">
   <xsl:call-template name="modtonumber">
    <xsl:with-param name="mod">
     <xsl:value-of select="@attack"/>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:variable>

  <!-- DEBUG OUTPUT
  [equipped=<xsl:value-of select="@equipped"/>
  ,equippedpenalty=<xsl:value-of select="$equippedpenalty"/>
  ,penalty=<xsl:value-of select="$penalty"/>
  ,attackmod=<xsl:value-of select="$attackmod"/>
  ,weaponattackmod=<xsl:value-of select="$weaponattackmod"/>]
  -->

  <xsl:call-template name="modifiedattack">
   <xsl:with-param name="mod" select="$penalty - $equippedpenalty - $attackmod + $weaponattackmod"/>
   <xsl:with-param name="baseattack" select="../../attack/@attackbonus"/>
   <xsl:with-param name="action">
    <xsl:choose>
     <xsl:when test="$equipped='offhand'">standard</xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="$action"/>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get weapon damage mod for being equipped in a given way.              -->
 <!--=======================================================================-->
 <xsl:template name="getweapondamageequippedmod">
  <xsl:param name="equipped" select="@equipped"/>
  <xsl:variable name="weaponclass">
   <xsl:call-template name="guessweaponclass"/>
  </xsl:variable>
  <xsl:variable name="strmodnum">
   <xsl:call-template name="modtonumber">
    <xsl:with-param name="mod">
     <xsl:value-of select="../../attributes/attribute[@name='Strength']/attrbonus/@modified"/>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
   <!-- Penalties never change. -->
   <xsl:when test="$strmodnum &lt; 1">0</xsl:when>
   <xsl:when test="$equipped='offhand' and count(../../feats/feat[@name='Double Slice']) = 0">
    <!-- Only 1/2 of STR bonus applies unless the hero has the Double Slice
         feat, so subtract off the rest. -->
    <xsl:value-of select="-ceiling($strmodnum div 2)"/>
   </xsl:when>
   <xsl:when test="$equipped='bothhands' and $weaponclass='1-hand'">
    <!-- An extra 1/2 of STR bonus applies. Note per the
         twoWeaponFightingArmorSpikes thread in the Paizo forums,
         James Jacobs ruled this does NOT apply to double weapons.
         In the treantmonksGuideToRangersOptimization thread, James
         says "while you wield a double weapon two-handed... the rules 
         treat it as if you were wielding two weapons one-handed". -->
    <xsl:value-of select="floor($strmodnum div 2)"/>
   </xsl:when>
   <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Get damage dice sections.  Damage consists of one or more sections    -->
 <!-- separated by + and -.  We consider any section with a 'd' in it part  -->
 <!-- of the damage dice.                                                   -->
 <!--=======================================================================-->
 <xsl:template name="getdamagedice">
  <xsl:param name="prefix"/>
  <xsl:param name="damage"/>

  <!-- Set $piece to be the substring at least one character long (which
       might be a + or -) and ending before the next + or -.
    -->
  <xsl:variable name="afterfirst">
   <xsl:value-of select="substring($damage,2)"/>
  </xsl:variable>
  <xsl:variable name="piecebeforeplus">
   <xsl:choose>
    <xsl:when test="contains($afterfirst,'+')">
     <xsl:value-of select="substring-before($afterfirst,'+')"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="$afterfirst"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:variable name="piecebeforeminus">
   <xsl:choose>
    <xsl:when test="contains($piecebeforeplus,'-')">
     <xsl:value-of select="substring-before($piecebeforeplus,'-')"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="$piecebeforeplus"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:variable name="piece">
   <xsl:value-of select="concat(substring($damage,1,1),$piecebeforeminus)"/>
  </xsl:variable>

  <!-- If the piece has a 'd' in it, then it's part of the damage dice. -->
  <xsl:variable name="okpiece">
   <xsl:if test="contains($piece,'d')">
    <xsl:value-of select="$piece"/>
   </xsl:if>
  </xsl:variable> 

  <!-- Compose full damage dice so far. -->
  <xsl:variable name="ok">
   <xsl:value-of select="concat($prefix,$okpiece)"/>
  </xsl:variable>

  <!-- Set 'rest' to the unparsed remainder. -->
  <xsl:variable name="rest">
   <xsl:value-of select="substring-after($damage,$piece)"/>
  </xsl:variable>

  <xsl:choose>
   <xsl:when test="$rest = ''">
    <xsl:value-of select="$ok"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="getdamagedice">
     <xsl:with-param name="prefix">
      <xsl:value-of select="$ok"/>
     </xsl:with-param>
     <xsl:with-param name="damage">
      <xsl:value-of select="$rest"/>
     </xsl:with-param>
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>

 </xsl:template>

 <!--=======================================================================-->
 <!-- Get damage bonus.                                                     -->
 <!--=======================================================================-->
 <xsl:template name="getdamagebonus">
  <xsl:param name="damage"/>

  <!-- Set $piece to be the substring at least one character long (which
       might be a + or -) and ending before the next + or -.
    -->
  <xsl:variable name="afterfirst">
   <xsl:value-of select="substring($damage,2)"/>
  </xsl:variable>
  <xsl:variable name="piecebeforeplus">
   <xsl:choose>
    <xsl:when test="contains($afterfirst,'+')">
     <xsl:value-of select="substring-before($afterfirst,'+')"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="$afterfirst"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:variable name="piecebeforeminus">
   <xsl:choose>
    <xsl:when test="contains($piecebeforeplus,'-')">
     <xsl:value-of select="substring-before($piecebeforeplus,'-')"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="$piecebeforeplus"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:variable name="piece">
   <xsl:value-of select="concat(substring($damage,1,1),$piecebeforeminus)"/>
  </xsl:variable>

  <!-- Set 'rest' to the unparsed remainder. -->
  <xsl:variable name="rest">
   <xsl:value-of select="substring-after($damage,$piece)"/>
  </xsl:variable>

  <!-- If the piece has a 'd' in it, then it's part of the damage dice. -->
  <xsl:choose>
   <xsl:when test="contains($piece,'d')">
    <xsl:choose>
     <xsl:when test="$rest = ''">0</xsl:when>
     <xsl:otherwise>
      <xsl:call-template name="getdamagebonus">
       <xsl:with-param name="damage">
        <xsl:value-of select="$rest"/>
       </xsl:with-param>
      </xsl:call-template>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="modtonumber">
     <xsl:with-param name="mod">
      <xsl:value-of select="$piece"/>
     </xsl:with-param>
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>

 </xsl:template>

 <!--=======================================================================-->
 <!-- Get weapon damage text.                                               -->
 <!--=======================================================================-->
 <xsl:template name="getweapondamagetext">
  <xsl:param name="equipped" select="@equipped"/>

  <xsl:variable name="equippedmod">
   <xsl:call-template name="getweapondamageequippedmod"/>
  </xsl:variable>

  <xsl:variable name="penalty">
   <xsl:call-template name="getweapondamageequippedmod">
    <xsl:with-param name="equipped" select="$equipped"/>
   </xsl:call-template>
  </xsl:variable>

  <!-- Double weapons have two damage sections, and we only want the first. -->
  <xsl:variable name="maindamage">
   <xsl:choose>
    <xsl:when test="substring-before(@damage,'/')">
     <xsl:value-of select="substring-before(@damage,'/')"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="@damage"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="basedamage">
   <xsl:call-template name="getdamagedice">
    <xsl:with-param name="damage">
     <xsl:value-of select="$maindamage"/>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$basedamage"/>

  <xsl:variable name="bonus">
   <xsl:call-template name="getdamagebonus">
    <xsl:with-param name="damage">
     <xsl:value-of select="$maindamage"/>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:variable>

  <!-- Combine all the bonuses and penalties together into one number. -->
  <xsl:call-template name="numbertomod">
   <xsl:with-param name="n">
    <xsl:value-of select="number($bonus)+number($penalty)-number($equippedmod)"/>
   </xsl:with-param>
  </xsl:call-template>  

  <!-- Output damage type(s). -->
  <xsl:variable name="nonlethal">
   <xsl:call-template name="isnonlethalweapon"/>
  </xsl:variable>
  <xsl:if test="$nonlethal = 'yes'"> nonlethal</xsl:if>
<!--XXX
  <xsl:if test="$damagetype != ''">
   <xsl:text> </xsl:text>
   <xsl:value-of select="$damagetype"/>
  </xsl:if>
-->

  <!-- DEBUG OUTPUT
  [equippedmod=<xsl:value-of select="$equippedmod"/>
  ,penalty=<xsl:value-of select="$penalty"/>
  ,basedamage=<xsl:value-of select="$basedamage"/>
  ,maindamage=<xsl:value-of select="$maindamage"/>
  ,bonus=<xsl:value-of select="$bonus"/>
  ,nonlethal=<xsl:value-of select="$nonlethal"/>]
  -->
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display standard format weapon block. -->
 <!--=======================================================================-->
 <xsl:template name="standardweaponblock">
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
   <tbody>
    <tr>
     <td rowspan="2" align="center" class="v10w" style="width:50%">
      <table border="0" cellpadding="0" cellspacing="0" width="100%">
       <tbody>
        <tr>
         <xsl:call-template name="leftcorners">
          <xsl:with-param name="type">box</xsl:with-param>
         </xsl:call-template>
         <td align="center">
          <b>WEAPON</b><br/>
         </td>
         <xsl:call-template name="rightcornerfill"/>
        </tr>
       </tbody>
      </table>
     </td>
     <td class="v3"><br/></td>
    </tr>
    <tr>
     <td align="center" class="v6w" style="width:38%">
      <b>ATTACK BONUS</b>
      <br/>
     </td>
     <td align="center" class="v6w" style="width:12%">
      <b>CRITICAL</b>
      <br/>
     </td>
    </tr>
    <tr>
     <td class="v10" style="border-left: black 1px solid; border-right: black 1px solid" valign="top">
      <xsl:call-template name="getweaponnametext"/>
     </td>
     <td align="center" class="v10 codex-accent-combat" style="border-left: black 1px solid; border-right: black 1px solid" valign="top">
      <div>
       <xsl:attribute name="id">noinlinemaneuvers<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
       <xsl:attribute name="name">noinlinemaneuvers<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
       <xsl:choose>
        <xsl:when test="count(../../journals/journal[@name='Hide Maneuvers In Weapon Block']) != 0">
         <xsl:attribute name="style">display:block;</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
         <xsl:attribute name="style">display:none;</xsl:attribute>
        </xsl:otherwise>
       </xsl:choose>

       <xsl:call-template name="getbasicweaponbonus"/>
      </div>

      <div>
       <xsl:attribute name="id">inlinemaneuvers<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
       <xsl:attribute name="name">inlinemaneuvers<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
       <xsl:choose>
        <xsl:when test="count(../../journals/journal[@name='Hide Maneuvers In Weapon Block']) = 0">
         <xsl:attribute name="style">display:block;</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
         <xsl:attribute name="style">display:none;</xsl:attribute>
        </xsl:otherwise>
       </xsl:choose>

       <xsl:call-template name="getbasicweaponbonus"/>

       <xsl:variable name="bullrushbonus">
        <xsl:call-template name="getbullrushbonus"/>
       </xsl:variable>
       <xsl:if test="$bullrushbonus!=''">
        <xsl:text>,</xsl:text><br/>bull rush
        <xsl:value-of select="$bullrushbonus"/>
       </xsl:if>

       <xsl:variable name="disarmbonus">
        <xsl:call-template name="getdisarmbonus"/>
       </xsl:variable>
       <xsl:if test="$disarmbonus!=''">
        <xsl:text>,</xsl:text><br/>disarm
        <xsl:value-of select="$disarmbonus"/>
       </xsl:if>

       <xsl:variable name="dragbonus">
        <xsl:call-template name="getdragbonus"/>
       </xsl:variable>
       <xsl:if test="$dragbonus!=''">
        <xsl:text>,</xsl:text><br/>drag
        <xsl:value-of select="$dragbonus"/>
       </xsl:if>
 
       <xsl:variable name="grapplebonus">
        <xsl:call-template name="getgrapplebonus"/>
       </xsl:variable>
       <xsl:if test="$grapplebonus!=''">
        <xsl:text>,</xsl:text><br/>grapple
        <xsl:value-of select="$grapplebonus"/>
       </xsl:if>

       <xsl:variable name="repositionbonus">
        <xsl:call-template name="getrepositionbonus"/>
       </xsl:variable>
       <xsl:if test="$repositionbonus!=''">
        <xsl:text>,</xsl:text><br/>reposition
        <xsl:value-of select="$repositionbonus"/>
       </xsl:if>

       <xsl:variable name="stealbonus">
        <xsl:call-template name="getstealbonus"/>
       </xsl:variable>
       <xsl:if test="$stealbonus!=''">
        <xsl:text>,</xsl:text><br/>steal
        <xsl:value-of select="$stealbonus"/>
       </xsl:if>

       <xsl:variable name="sunderbonus">
        <xsl:call-template name="getsunderbonus"/>
       </xsl:variable>
       <xsl:if test="$sunderbonus!=''">
        <xsl:text>,</xsl:text><br/>sunder
        <xsl:value-of select="$sunderbonus"/>
       </xsl:if>

       <xsl:variable name="tripbonus">
        <xsl:call-template name="gettripbonus"/>
       </xsl:variable>
       <xsl:if test="$tripbonus!=''">
        <xsl:text>,</xsl:text><br/>trip
        <xsl:value-of select="$tripbonus"/>
       </xsl:if>

      </div>
     </td>
     <td align="center" class="v10 codex-accent-combat" style="border-left: black 1px solid; border-right: black 1px solid" valign="top">
      <xsl:value-of select="@crit"/>
     </td>
    </tr>
   </tbody>
  </table>
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
   <tbody>
    <tr>
     <td align="center" class="v6w" style="width:5%">
      <b>TYPE</b>
     </td>
     <td align="center" class="v6w" style="width:15%">
      <b>RANGE</b>
     </td>
     <td align="center" class="v6w" style="width:30%">
      <b>AMMUNITION</b>
     </td>
     <td align="center" class="v6w" style="width:50%">
      <b>DAMAGE</b>
     </td>
    </tr>
    <tr>
     <td align="center" class="v10" style="BORDER: black 1px solid" valign="top">
      <xsl:value-of select="@typetext"/>
     </td>
     <td align="center" class="v10" style="BORDER: black 1px solid" valign="top">
      <xsl:call-template name="getweaponrangetext"/>
     </td>
     <td align="center" class="v10" style="BORDER: black 1px solid" valign="top">
     </td>
     <td align="center" class="v10 codex-accent-combat" style="BORDER: black 1px solid" valign="top">
      <xsl:value-of select="@damage"/>
      <xsl:variable name="nonlethal">
       <xsl:call-template name="isnonlethalweapon"/>
      </xsl:variable>
      <xsl:if test="$nonlethal = 'yes'"> nonlethal</xsl:if>
     </td>
    </tr>
   </tbody>
  </table>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display a detailed weapon block. -->
 <!--=======================================================================-->
 <xsl:template name="detailedweaponblock">
  <xsl:variable name="weaponclass">
   <xsl:call-template name="guessweaponclass"/>
  </xsl:variable>
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
   <tbody>
    <tr>
     <td rowspan="2" align="center" class="v10w" style="width:50%">
      <table border="0" cellpadding="0" cellspacing="0" width="100%">
       <tbody>
        <tr>
         <xsl:call-template name="leftcorners">
          <xsl:with-param name="type">box</xsl:with-param>
         </xsl:call-template>
         <td align="center">
          <b>WEAPON</b><br/>
         </td>
         <xsl:call-template name="rightcornerfill"/>
        </tr>
       </tbody>
      </table>
     </td>
     <td class="v3"><br/></td>
    </tr>
    <tr>
     <td align="center" class="v6w" style="width:18%">
      <b>CLASS</b>
      <br/>
     </td>
     <td align="center" class="v6w" style="width:5%">
      <b>TYPE</b>
      <br/>
     </td>
     <td align="center" class="v6w" style="width:15%">
      <b>RANGE</b>
      <br/>
     </td>
     <td align="center" class="v6w" style="width:12%">
      <b>CRITICAL</b>
      <br/>
     </td>
    </tr>
    <tr>
     <td class="v10" style="border-left: black 1px solid; border-right: black 1px solid" valign="top">
      <xsl:call-template name="getweaponnametext">
       <xsl:with-param name="type">detailed</xsl:with-param>
      </xsl:call-template>
     </td>
     <td align="center" class="v10" style="border-left: black 1px solid; border-right: black 1px solid" valign="top">
      <xsl:value-of select="$weaponclass"/>
     </td>
     <td align="center" class="v10" style="border-left: black 1px solid; border-right: black 1px solid" valign="top">
      <xsl:value-of select="@typetext"/>
     </td>
     <td align="center" class="v10" style="border-left: black 1px solid; border-right: black 1px solid" valign="top">
      <xsl:call-template name="getweaponrangetext"/>
     </td>
     <td align="center" class="v10" style="border-left: black 1px solid; border-right: black 1px solid" valign="top">
      <xsl:value-of select="@crit"/>
     </td>
    </tr>
   </tbody>
  </table>
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
   <tbody>
    <tr>
     <td align="center" class="v8w" style="width:20%">
      <b>ONLY WEAPON</b>
     </td>
     <td align="center" class="v6w" style="width:15%">
      <b>ATTACK BONUS</b>
      <br/>
     </td>
     <td align="center" class="v6w" style="width:15%">
      <b>DAMAGE</b>
      <br/>
     </td>
     <td align="center" class="v8w" style="width:20%">
      <b>TWO WEAPONS</b>
     </td>
     <td align="center" class="v6w" style="width:15%">
      <b>ATTACK BONUS</b>
      <br/>
     </td>
     <td align="center" class="v6w" style="width:15%">
      <b>DAMAGE</b>
      <br/>
     </td>
    </tr>
    <tr>
     <td align="center" class="v6w">
      <b>BOTH HANDS</b>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweaponattacktext">
       <xsl:with-param name="equipped">bothhands</xsl:with-param>
       <xsl:with-param name="offhandclass">none</xsl:with-param>
      </xsl:call-template>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweapondamagetext">
       <xsl:with-param name="equipped">bothhands</xsl:with-param>
      </xsl:call-template>
     </td>
     <td align="center" class="v6w">
      <b>MAIN HAND<br/>(LIGHT OFFHAND)</b>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweaponattacktext">
       <xsl:with-param name="equipped">mainhand</xsl:with-param>
       <xsl:with-param name="offhandclass">light</xsl:with-param>
      </xsl:call-template>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweapondamagetext">
       <xsl:with-param name="equipped">mainhand</xsl:with-param>
      </xsl:call-template>
     </td>
    </tr>
    <tr>
     <td align="center" class="v6w">
      <b>MAIN HAND</b>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweaponattacktext">
       <xsl:with-param name="equipped">mainhand</xsl:with-param>
       <xsl:with-param name="offhandclass">none</xsl:with-param>
      </xsl:call-template>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweapondamagetext">
       <xsl:with-param name="equipped">mainhand</xsl:with-param>
      </xsl:call-template>
     </td>
     <td align="center" class="v6w">
      <b>MAIN HAND<br/>(1-HAND OFFHAND)</b>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweaponattacktext">
       <xsl:with-param name="equipped">mainhand</xsl:with-param>
       <xsl:with-param name="offhandclass">1-hand</xsl:with-param>
      </xsl:call-template>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweapondamagetext">
       <xsl:with-param name="equipped">mainhand</xsl:with-param>
      </xsl:call-template>
     </td>
    </tr>
    <tr>
     <td align="center" class="v6w">
      <b>OFFHAND</b>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweaponattacktext">
       <xsl:with-param name="equipped">offhandonly</xsl:with-param>
       <xsl:with-param name="offhandclass">none</xsl:with-param>
      </xsl:call-template>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweapondamagetext">
       <xsl:with-param name="equipped">offhand</xsl:with-param>
      </xsl:call-template>
     </td>
     <td align="center" class="v6w">
      <b>OFFHAND</b>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweaponattacktext">
       <xsl:with-param name="equipped">offhand</xsl:with-param>
       <xsl:with-param name="offhandclass" select="$weaponclass"/>
      </xsl:call-template>
     </td>
     <td align="center" class="v10" style="border: black 1px solid">
      <xsl:call-template name="getweapondamagetext">
       <xsl:with-param name="equipped">offhand</xsl:with-param>
      </xsl:call-template>
     </td>
    </tr>
   </tbody>
  </table>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display a weapon block. -->
 <!--=======================================================================-->
 <xsl:template match="weapon">
  <xsl:variable name="wepname" select="@name"/>
  <xsl:variable name="weaponclass">
   <xsl:call-template name="guessweaponclass"/>
  </xsl:variable>

  <!-- Don't display duplicates.  Only display if equipped, or if no preceding
       weapon has the same name.
    -->
  <xsl:if test="(@equipped) or (count(preceding-sibling::weapon[@name=$wepname]) = 0)">
   <div class="codex-weapon-entry">
    <xsl:attribute name="id">noweapondetails<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
    <xsl:attribute name="name">noweapondetails<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
    <xsl:choose>
     <xsl:when test="not(contains(../../settings/@summary, 'Always Print 2-Weapon Attacks'))">
      <xsl:attribute name="style">display:block; page-break-inside:avoid;</xsl:attribute>
     </xsl:when>
     <xsl:otherwise>
      <xsl:attribute name="style">display:none; page-break-inside:avoid;</xsl:attribute>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="standardweaponblock"/>
   </div>

   <div class="codex-weapon-entry">
    <xsl:attribute name="id">weapondetails<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
    <xsl:attribute name="name">weapondetails<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
    <xsl:choose>
     <xsl:when test="contains(../../settings/@summary, 'Always Print 2-Weapon Attacks')">
      <xsl:attribute name="style">display:block; page-break-inside:avoid;</xsl:attribute>
     </xsl:when>
     <xsl:otherwise>
      <xsl:attribute name="style">display:none; page-break-inside:avoid;</xsl:attribute>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
     <xsl:when test="$weaponclass!='2-hand' and $weaponclass!='double' and $weaponclass!='unusable' and not(contains(@attack,'x'))">
      <xsl:call-template name="detailedweaponblock"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:call-template name="standardweaponblock"/>
     </xsl:otherwise>
    </xsl:choose>
   </div>

   <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
     <tr>
      <td style="height:4px"/>
     </tr>
    </tbody>
   </table>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template name="itemrow">
  <xsl:param name="name">&#160;</xsl:param>
  <xsl:param name="weight"/>
  <xsl:param name="boxes"/>
  <tr>
   <td align="left" class="v10" style="border: 1px solid black; width:80%">
    <xsl:choose>
     <xsl:when test="$boxes &gt; 1">
      <table border="0" cellpadding="0" cellspacing="0">
       <tbody>
        <tr>
         <td>
          <xsl:attribute name="id">trackingboxes<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
          <xsl:attribute name="name">trackingboxes<xsl:value-of select="1+count(../../preceding-sibling::character)"/></xsl:attribute>
          <xsl:choose>
           <xsl:when test="count(../../journals/journal[@name='Hide Tracking Boxes']) = 0">
            <xsl:attribute name="style">display:block;</xsl:attribute>
           </xsl:when>
           <xsl:otherwise>
            <xsl:attribute name="style">display:none;</xsl:attribute>
           </xsl:otherwise>
          </xsl:choose>
          <table border="0" cellpadding="0" cellspacing="0">
           <tbody>
            <tr>
             <xsl:call-template name="spellx">
              <xsl:with-param name="count">
               <xsl:value-of select="$boxes"/>
              </xsl:with-param>
             </xsl:call-template>
            </tr>
           </tbody>
          </table>
         </td>
         <td>
          <xsl:value-of select="$name"/>
         </td>
        </tr>
       </tbody>
      </table>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="$name"/>
     </xsl:otherwise>
    </xsl:choose>
   </td>
   <td align="center" class="v10" style="border: 1px solid black; width:19%">
    <xsl:value-of select="$weight"/>
   </td>
  </tr>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template name="getquantity">
  <xsl:variable name="itemname" select="@name"/>
  <xsl:variable name="itemidx" select="count(preceding::item[@name=$itemname])"/>
  <xsl:variable name="trcount" select="count(../../trackedresources/trackedresource[@name=$itemname])"/>
  <xsl:variable name="left" select="../../trackedresources/trackedresource[@name=$itemname and count(preceding::trackedresource[@name=$itemname])=$itemidx]/@left"/>
  <xsl:variable name="max" select="../../trackedresources/trackedresource[@name=$itemname and count(preceding::trackedresource[@name=$itemname])=$itemidx]/@max"/>
  <xsl:choose>
   <xsl:when test="$trcount = 0">
    <xsl:value-of select="@quantity"/>
   </xsl:when>
   <xsl:when test="$max = @quantity">
    <xsl:value-of select="$left"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="@quantity"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template name="getcharges">
  <xsl:variable name="itemname" select="@name"/>
  <xsl:variable name="itemidx" select="count(preceding::item[@name=$itemname])"/>
  <xsl:variable name="trcount" select="count(../../trackedresources/trackedresource[@name=$itemname])"/>
  <xsl:variable name="left" select="../../trackedresources/trackedresource[@name=$itemname and count(preceding::trackedresource[@name=$itemname])=$itemidx]/@left"/>
  <xsl:variable name="max" select="../../trackedresources/trackedresource[@name=$itemname and count(preceding::trackedresource[@name=$itemname])=$itemidx]/@max"/>
  <xsl:choose>
   <xsl:when test="$trcount = 0">0</xsl:when>
   <xsl:when test="$max = @quantity">0</xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$left"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template match="item">
  <xsl:param name="magic"/>
  <xsl:variable name="itemname" select="@name"/>
  <xsl:variable name="itemidx" select="count(preceding::item[@name=$itemname])"/>
  <xsl:variable name="left" select="../../trackedresources/trackedresource[@name=$itemname and count(preceding::trackedresource[@name=$itemname])=$itemidx]/@left"/>
  <xsl:call-template name="itemrow">
   <xsl:with-param name="boxes" select="$left"/>
   <xsl:with-param name="name">
    <xsl:variable name="quantity">
     <xsl:call-template name="getquantity"/>
    </xsl:variable>
    <xsl:variable name="charges">
     <xsl:call-template name="getcharges"/>
    </xsl:variable>

    <!-- DEBUG OUTPUT
     <xsl:variable name="trcount" select="count(../../trackedresources/trackedresource[@name=$itemname])"/>
     <xsl:variable name="max" select="../../trackedresources/trackedresource[@name=$itemname]/@max"/>
     [idx=<xsl:value-of select="$itemidx"/>,
     trcount=<xsl:value-of select="$trcount"/>,
     left=<xsl:value-of select="$left"/>,
     max=<xsl:value-of select="$max"/>,
     @qty=<xsl:value-of select="@quantity"/>,
     $qty=<xsl:value-of select="$quantity"/>,
     $ch=<xsl:value-of select="$charges"/>]
    -->

    <xsl:choose>
     <xsl:when test="contains(@name,'&#xA;')">
      <xsl:value-of select="substring-before(@name,'&#xA;')"/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="@name"/>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$quantity != 1">
     (x<xsl:value-of select="$quantity"/>)
    </xsl:if>
    <xsl:if test="$magic='yes'">
     <xsl:if test="$charges != 0">
      (<xsl:value-of select="$charges"/> charges)
     </xsl:if>
    </xsl:if>
   </xsl:with-param>
   <xsl:with-param name="weight">
    <xsl:if test="weight/@text != ''">
     <xsl:value-of select="round(10 * weight/@value * @quantity) div 10"/>
    </xsl:if>
   </xsl:with-param>
  </xsl:call-template>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Count the number of rows consumed by the current item.                -->
 <!--=======================================================================-->
 <xsl:template name="countitemrows">
  <xsl:variable name="itemname" select="@name"/>
  <xsl:variable name="itemidx" select="count(preceding::item[@name=$itemname])"/>
  <xsl:variable name="boxes" select="../../trackedresources/trackedresource[@name=$itemname and count(preceding::trackedresource[@name=$itemname])=$itemidx]/@left"/>
   <xsl:choose>
    <xsl:when test="$boxes &gt; 10">
     <xsl:variable name="boxrows">
      <xsl:value-of select="floor(($boxes + 9) div 10)"/>
     </xsl:variable>
     <!-- Convert box rows into effective item rows. -->
     <xsl:value-of select="$boxrows * 0.65"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
   </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Count the number of rows consumed by a set of items.                  -->
 <!--=======================================================================-->
 <xsl:template match="gear | magicitems" mode="countgearrows">
  <xsl:choose>
   <xsl:when test="count(item) = 0">0</xsl:when>
   <xsl:otherwise>
    <xsl:for-each select="item[1]">
     <xsl:call-template name="countitemsetrows"/>
    </xsl:for-each>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template name="countitemsetrows">
  <xsl:variable name="itemrows">
   <xsl:call-template name="countitemrows"/>
  </xsl:variable>
  <xsl:variable name="aftersum">
   <xsl:choose>
    <xsl:when test="count(following-sibling::item) = 0">0</xsl:when>
    <xsl:otherwise>
     <xsl:for-each select="following-sibling::item[1]">
      <xsl:call-template name="countitemsetrows"/>
     </xsl:for-each>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$itemrows + $aftersum"/>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display a set of 1 or blank item lines.                               -->
 <!--=======================================================================-->
 <xsl:template name="blankitem">
  <xsl:param name="count" select="1"/>
  <xsl:if test="$count &gt; 0">
   <xsl:call-template name="itemrow"/>
   <xsl:call-template name="blankitem">
    <xsl:with-param name="count" select="$count - 1"/>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Display an AC ITEMS block entry.                                      -->
 <!--=======================================================================-->
 <xsl:template match="defenses/armor">
  <xsl:choose>
   <xsl:when test="@equipped">
   <tr style="height:10px">
    <td align="left" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
     <xsl:choose>
      <xsl:when test="contains(@name,'&#xA;')">
       <xsl:value-of select="substring-before(@name,'&#xA;')"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="@name"/>
      </xsl:otherwise>
     </xsl:choose>
    </td>
    <td align="center" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
     <xsl:value-of select="@ac"/>
    </td>
    <td align="left" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
    </td>
    <td align="left" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
    </td>
    <td align="left" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
    </td>
    <td align="center" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
     <xsl:if test="weight/@text != ''">
      <xsl:value-of select="weight/@value"/> lbs.
     </xsl:if>
    </td>
    <td align="left" class="v10" style="border-left: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">
    </td>
   </tr>
  </xsl:when>
  <xsl:otherwise/></xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template name="gettotalacitemsbonus">
  <xsl:param name="n" select="1"/>
  <xsl:variable name="count" select="count(defenses/armor)"/>
  <xsl:choose>
   <xsl:when test="$n &gt; $count">0</xsl:when>
   <xsl:otherwise>
    <xsl:variable name="thisvalue">
     <xsl:call-template name="modtonumber">
      <xsl:with-param name="mod">
       <xsl:value-of select="defenses/armor[$n]/@ac"/>
      </xsl:with-param>
     </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="restvalue">
     <xsl:call-template name="gettotalacitemsbonus">
      <xsl:with-param name="n" select="$n + 1"/>
     </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$thisvalue + $restvalue"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <xsl:template match="special" mode="dr">
  <xsl:choose>
   <!-- Skip resistances that don't end in a number, such as 'Undead Resistance'. -->
   <xsl:when test="not(contains('0123456789',substring(@shortname,string-length(@shortname),1)))"/>

   <!-- Skip spell resistance, which is shown in its own box. -->
   <xsl:when test="starts-with(@shortname,'spells ')"/>

   <xsl:otherwise>
    <xsl:value-of select="@shortname"/><br/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Attempt to compute the attribute modifier for a given caster class,
      since HeroLab doesn't currently give this in the XML.
   -->
 <!--=======================================================================-->
 <xsl:template name="getdcattrmod">
  <xsl:param name="classname"/>
  <xsl:param name="mod" select="0"/>
  <xsl:choose>
   <xsl:when test="count(../../*/spell[@class=$classname])=0">
    <!-- No spells chosen, so we can't tell. -->
    0
   </xsl:when>
   <xsl:when test="count(../../*/spell[@class=$classname and @dc=10+@level+$mod]) != 0">
    <!-- This seems to be it.  Return this modifier value. -->
    <xsl:value-of select="$mod"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="getdcattrmod">
     <!-- This doesn't seem to be it.  Try the next higher value. -->
     <xsl:with-param name="classname" select="$classname"/>
     <xsl:with-param name="mod" select="$mod + 1"/>
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!--=======================================================================-->
 <!-- Generate inverse rounded corners.                                     -->
 <!--=======================================================================-->
 <xsl:template name="leftcorners">
  <xsl:param name="type"/>
  <td class="headline" style="width:18px;">
   <table cellpadding="0" cellspacing="0" width="100%">
    <tbody>
     <tr>
      <td class="tlcorner"/>
     </tr>
     <tr height="1px;"><td/></tr>
     <tr>
      <td class="blcorner">
       <xsl:if test="$type='box'">
        <xsl:attribute name="style">border-left: 1px solid black;</xsl:attribute>
       </xsl:if>
      </td>
     </tr>
    </tbody>
   </table>
  </td>
 </xsl:template>

 <xsl:template name="rightcornerfill">
  <td class="headline" style="width:9px;">
   <table cellpadding="0" cellspacing="0" width="100%">
    <tbody>
     <tr>
      <td style="height:7px; width:9px; -moz-border-radius-bottomleft:9px 7px;  border-bottom-left-radius:9px 7px; background-color:white;"/>
     </tr>
     <tr height="5px;"><td/></tr>
     <tr>
      <td style="font-size:7pt">&#160;</td>
     </tr>
    </tbody>
   </table>
  </td>
 </xsl:template>

 <xsl:template name="rightcorners">
  <xsl:param name="type"/>
  <td class="headline" style="width:18px;">
   <table cellpadding="0" cellspacing="0" width="100%">
    <tbody>
     <tr>
      <td class="trcorner"/>
     </tr>
     <tr height="1px;"><td/></tr>
     <tr>
      <td class="brcorner">
       <xsl:if test="$type='box'">
        <xsl:attribute name="style">border-right: 1px solid black;</xsl:attribute>
       </xsl:if>
      </td>
     </tr>
    </tbody>
   </table>
  </td>
 </xsl:template>

</xsl:stylesheet>
