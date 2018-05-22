<!--
 Copyright 2012-2018 MarkLogic Corporation

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 The use of the Apache License does not indicate that this project is
 affiliated with the Apache Software Foundation.

 Code adapted from xray
 https://github.com/robwhitby/xray/tree/v2.1

 Modifications copyright (c) 2018 MarkLogic Corporation
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:error="http://marklogic.com/xdmp/error"
                xmlns:prof="http://marklogic.com/xdmp/profile"
                xmlns:test="http://marklogic.com/roxy/test"
                xmlns:xdmp="http://marklogic.com/xdmp"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="error prof test xdmp xs">

  <xsl:output method="html" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes" />

  <xsl:include href="../common.xsl"/>

  <xsl:template match="test:tests">
    <html>
      <xsl:call-template name="html-head"/>
      <body>
        <xsl:apply-templates select="test:coverage-summary"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="test:coverage-summary">
    <xsl:variable name="total-coverage" select="test:coverage-percent(xs:int(@covered-count), xs:int(@wanted-count))"/>
    <section class="coverage">
      <details open="true">
        <summary>
          <xsl:text>Code Coverage: </xsl:text>
          <xsl:value-of select="$total-coverage"/>
          <xsl:text>%</xsl:text>
        </summary>
        <table cellspacing="0" cellpadding="0">
          <thead>
            <tr>
              <th>Module</th>
              <th>Missed Lines</th>
              <th>Coverage</th>
              <th>Missed</th>
              <th>Covered</th>
              <th>Lines</th>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates>
              <xsl:sort select="test:missing/@count" data-type="number" order="descending"/>
              <xsl:sort select="test:covered/@count" data-type="number" order="descending"/>
              <xsl:sort select="test:wanted/@count" data-type="number" order="descending"/>
            </xsl:apply-templates>
          </tbody>
          <tfoot>
            <tr>
              <th>Total</th>
              <th><xsl:value-of select="concat(@missing-count, ' of ', @wanted-count)"/></th>
              <th><span class="pct"><xsl:value-of select="$total-coverage"/>%</span></th>
              <th><xsl:value-of select="@missing-count"/></th>
              <th><xsl:value-of select="@covered-count"/></th>
              <th><xsl:value-of select="@wanted-count"/></th>
            </tr>
          </tfoot>
        </table>
      </details>
    </section>
  </xsl:template>

  <xsl:template match="test:module-coverage">
    <xsl:variable name="link"
                  select="concat('default.xqy?func=coverage-module',
                                   '&amp;format=html',
                                   '&amp;module=', encode-for-uri(@uri),
                                   '&amp;wanted=', encode-for-uri(test:wanted/string()),
                                   '&amp;covered=', encode-for-uri(test:covered/string()))"/>
    <xsl:variable name="pct" select="test:coverage-percent(xs:int(test:covered/@count), xs:int(test:wanted/@count))"/>
    <xsl:variable name="status">
      <xsl:choose>
        <xsl:when test="$pct eq 100">passed</xsl:when>
        <xsl:when test="$pct le 0">ignored</xsl:when>
        <xsl:otherwise>failed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr class="{$status} {if (position() mod 2) then () else 'even'}">
      <td><a href="{$link}" target="_blank"><xsl:value-of select="@uri"/></a></td>
      <td>
        <div style="width:{ max(( 2, round(100 * ( max((test:wanted/@count, 1)) div max(../*/test:wanted/@count) ) ) ))}%">
        <div class="bar-chart">
          <span style="width:{100 - $pct}%" class="bar missed" title="{test:missing/@count}" alt="{test:missing/@count}"/>
          <span style="width:{$pct}%" class="bar covered" title="{test:covered/@count}" alt="{test:covered/@count}"/>
        </div>
        </div>
      </td>
      <td><span class="pct"><xsl:value-of select="$pct"/>%</span></td>
      <td><xsl:value-of select="test:missing/@count"/></td>
      <td><xsl:value-of select="test:covered/@count"/></td>
      <td><xsl:value-of select="test:wanted/@count"/></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
