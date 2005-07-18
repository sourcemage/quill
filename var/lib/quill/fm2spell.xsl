<?xml version='1.0'?>
<!--
-*- sgml -*-
Take Freshmeat.net's XML project description and produce SourceMage GNU/Linux spell file(s).
XML project description can supplied directly or downloaded from Freshmeat.net itself.
Parameters:
  project - Freshmeat.net's project name (in case download is required) TODO;
  persist - generate persistent operations;
  debug - provide debug data;
  gzip-suffix - specify either `tar.gz' or `tgz' as default for `url_tgz' tag.
-->

<!DOCTYPE PUBLIC [
  <!ENTITY LF "&#xA;">
]>

<t:stylesheet version='1.0' xmlns:t='http://www.w3.org/1999/XSL/Transform'>

<t:output method='text' omit-xml-declaration='yes' standalone='yes' indent='no' />

<!--Set this parameter to Freshmeat's project name and XML descriptor will be downloaded-->
<t:param name='project' />

<!--Set this parameter to `true' to generate persistent operations, e.g. file creation-->
<t:param name='persist' select="'true'" />

<!--Set this parameter to `true' to produce debug output-->
<t:param name='debug' select="'true'" />

<!--
Set this parameter to `tgz' if the target package uses that suffix instead of `tar.gz'.
This is necessary because Freshmeat.net's XML descriptor doesn't have direct URLs.
-->
<t:param name='gzip-suffix' select="'tar.gz'" />

<t:variable name='freshmeat-url' select='"http://freshmeat.net/projects-xml/"' />

<!--This is invoked when the XML descriptor is supplied on input-->
<t:template match='/project-listing'>
  <t:if test='$debug'>
    <t:message>XML supplied as input.</t:message>
  </t:if>
  <t:apply-templates select='project' />
</t:template>

<!--This is supposedly invoked when XML descriptor has to be downloaded-->
<t:template match="/*[local-name() != 'project-listing']">
  <t:variable name='project-url' select="concat($freshmeat-url, '/', $project)" />
  <t:if test='$debug'>
    <t:message>XML doanloaded from <t:value-of select='$project-url' /></t:message>
  </t:if>
  <t:apply-templates select='document($project-url)/project-listing/project' />
</t:template>

<t:template match='project'>
  <t:variable name='spell' select='normalize-space(projectname_short)' />

  <!--May need lower the case here, XSLT 2.0 and XPath 2.0 have "lower-case()"-->
  <t:variable name='release' select='latest_release' />

  <t:variable name='version' select='normalize-space($release/latest_release_version)' />

  <t:variable name='sed-expression'>
    <t:text>'s/</t:text><t:value-of select='$spell' /><t:text>/\$SPELL/g&LF;</t:text>
    <t:text>s/</t:text><t:value-of select='$version' /><t:text>/\$VERSION/g'</t:text>
  </t:variable>

  <!--Pick one of the source tarball formats and work it-->
  <t:variable name='source-suffix'>
    <t:choose>
      <t:when test='string-length(url_bz2) > 0'>
        <t:text>tar.bz2</t:text>
      </t:when>
      <t:when test='string-length(url_tgz) > 0'>
        <t:value-of select='$gzip-suffix' />
      </t:when>
      <t:when test='string-length(url_zip) > 0'>
        <t:text>zip</t:text>
      </t:when>
    </t:choose>
  </t:variable>

  <t:text>#!/bin/sh&LF;</t:text>
  <t:text># This script is going to create grimoire files for new spell&LF;</t:text>
  <t:if test='$debug'>
    <t:text>set -x &amp;&amp;&LF;</t:text>
  </t:if>
  <t:text>&LF;</t:text>

  <t:text>SPELL=</t:text><t:value-of select='$spell' />
  <t:text> &amp;&amp;&LF;</t:text>
  <t:text>VERSION=</t:text><t:value-of select='$version' />
  <t:text> &amp;&amp;&LF;</t:text>
  <t:text>WEB_SITE=</t:text><t:apply-templates select='url_homepage' />
  <t:text> &amp;&amp;&LF;</t:text>
  <t:text>WEB_SITE_CONVERTED="${WEB_SITE//$SPELL/\$SPELL}" &amp;&amp;&LF;</t:text>
  <t:text>FRESHMEAT_URL='</t:text><t:value-of select='normalize-space(url_project_page)' />
  <t:text>' &amp;&amp;&LF;</t:text>
  <!--
  This replacement doesn't have to be done with bash because we have the actual URL,
  but XPath 1.0 doesn't have a `replace' function. XPath 2.0 does have it.
  -->
  <t:text>FRESHMEAT_URL_CONVERTED="${FRESHMEAT_URL//$SPELL/\$SPELL}" &amp;&amp;&LF;</t:text>
  <t:text>UPDATED=</t:text><t:value-of select="translate(substring-before(normalize-space($release/latest_release_date), ' '), '-', '')" />
  <t:text> &amp;&amp;&LF;</t:text>
  <t:text>SOURCE_SUFFIX=</t:text><t:value-of select='$source-suffix' />
  <t:text> &amp;&amp;&LF;</t:text>
  <t:text>&LF;</t:text>

  <t:if test='$source-suffix'>
    <!--
    The following condition is a rude hack on multiple levels, something better is necessary.
    Firstly, `translate' is not a replacement operation, so it uses the fact that
    the three suffixes `bz2', `gz', and `zip' don't have any of characters `t', 'a', and 'r'.
    If parameter `gzip-suffix' is set to `tgz', this code still works because `tgz' becomes
    `gz' after `translate' is applied.
    Secondly, it uses the fact that source URLs in Freshmeat XML descriptor end with either
    `bz2' (url_bz2), `gz' (url_tgz), or `zip' (url_zip). Oh well...
    -->
    <t:text>URL=</t:text><t:apply-templates select="*[starts-with(local-name(), 'url_') and contains(local-name(), translate($source-suffix, 'tar.', ''))]" />
    <t:text> &amp;&amp;&LF;</t:text>
    <t:text>if ! [[ "$URL" =~ "^.*$SOURCE_SUFFIX\$" ]]; then URL="${URL%/*}/$SPELL-$VERSION.$SOURCE_SUFFIX"; fi &amp;&amp;&LF;</t:text>
    <t:text>SOURCE=$(basename "$URL") &amp;&amp;&LF;</t:text>
    <t:text>SOURCE_CONVERTED=$(echo "$SOURCE" | sed </t:text><t:value-of select='$sed-expression' />
    <t:text>) &amp;&amp;&LF;</t:text>
    <t:text>URL_CONVERTED="${URL//$SOURCE/\$SOURCE}" &amp;&amp;&LF;</t:text>
    <t:text>&LF;</t:text>
  </t:if>

  <t:if test="$persist = 'true'">
    <t:text>mkdir -p "$SPELL" &amp;&amp;&LF;</t:text>
    <t:text>cd "$SPELL" &amp;&amp;&LF;</t:text>
    <t:if test='$source-suffix'>
      <t:text>if wget "$URL" &amp;&amp; [[ -f "$SOURCE" ]]; then&LF;</t:text>
      <t:text>  CHECKSUM=$(md5unpack "$SOURCE" 2&gt;&amp;1 | head -1 | cut -d ' ' -f 1)&LF;</t:text>
      <t:text>fi &amp;&amp;&LF;</t:text>
      <t:text>&LF;</t:text>
    </t:if>

    <t:text>cat &gt;DETAILS &lt;&lt;__END_DETAILS &amp;&amp;&LF;</t:text>
    <t:text>           SPELL=$SPELL&LF;</t:text>
    <t:text>         VERSION=$VERSION&LF;</t:text>
    <t:text>          MD5[0]='$CHECKSUM'&LF;</t:text>
    <t:text>          SOURCE="$SOURCE_CONVERTED"&LF;</t:text>
    <t:text>   SOURCE_URL[0]="$URL_CONVERTED"&LF;</t:text>
    <t:text>SOURCE_DIRECTORY=\$BUILD_DIRECTORY/\$SPELL-\$VERSION&LF;</t:text>
    <t:text>        WEB_SITE="$WEB_SITE_CONVERTED"&LF;</t:text>
    <t:text>   FRESHMEAT_URL="$FRESHMEAT_URL_CONVERTED"&LF;</t:text>
    <t:apply-templates select='license' />
    <t:text>         UPDATED=$UPDATED&LF;</t:text>
    <t:text>       BUILD_API=2&LF;</t:text>
    <t:text>           SHORT='</t:text><t:value-of select="normalize-space(translate(desc_short, '.', ''))"/>
    <t:text>'&LF;</t:text>
    <t:text>cat &lt;&lt; EOF&LF;</t:text>
    <t:value-of select='normalize-space(desc_full)'/>
    <t:text>&LF;</t:text>
    <t:text>EOF&LF;</t:text>
    <t:text># Auto-generated from Freshmeat.net's project descriptor&LF;</t:text>
    <t:text>__END_DETAILS&LF;</t:text>
  <!--End of persistent operations-->
  </t:if>

  <t:text>echo Enjoy!&LF;</t:text>
</t:template>

<!--
Creates a bash script that will follow a given URL and resolve it.
Takes any Freshmeat.net XML descriptor's node that starts with `url_'.
-->
<t:template match="*[starts-with(local-name(), 'url_')]">
  <t:text>$(curl -sILS '</t:text><t:value-of select="." /><t:text>' | grep -i 'location:' | tail -1 | cut -d ' ' -f 2 | tr -d '\r')</t:text>
</t:template>

<!--Process a license record-->
<t:template match='license'>
  <t:text>      LICENSE[</t:text><t:value-of select='position() - 1' />
  <t:text>]='</t:text>
  <t:choose>
    <t:when test="contains(., '(')">
      <t:value-of select="normalize-space(substring-before(substring-after(., '('), ')'))" />
    </t:when>
    <t:otherwise>
      <t:value-of select='normalize-space(.)' />
    </t:otherwise>
  </t:choose>
  <t:text>'&LF;</t:text>
</t:template>

</t:stylesheet>
