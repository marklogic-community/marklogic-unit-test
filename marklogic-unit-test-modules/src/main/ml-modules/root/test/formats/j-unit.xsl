<!--
    Convert default marklogic-unit-test report XML output to valid JUnit report XML
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:test="http://marklogic.com/test"
                xmlns:error="http://marklogic.com/xdmp/error"
                exclude-result-prefixes="#all">
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>

	<!-- Required inputs -->
	<xsl:param name="hostname"/>
	<xsl:param name="timestamp"/>

	<!-- Output all text nodes, elements and attributes -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<!-- Output test suites -->
	<xsl:template match="test:suite">
		<testsuite errors="0" failures="{@failed}" hostname="{$hostname}" name="{@name}" tests="{@total}" time="{@time}" timestamp="{$timestamp}">
			<xsl:apply-templates/>
		</testsuite>
	</xsl:template>

	<!-- Output test cases within test suites -->
	<xsl:template match="test:test">
		<testcase classname="{@name}" name="{@name}" time="{@time}">
			<xsl:apply-templates/>
		</testcase>
	</xsl:template>

	<!-- Output test case failures -->
	<xsl:template match="test:result[@type = 'fail']">
		<failure type="{error:error/error:name/string()}" message="{error:error/error:message/string()}">
			<xsl:apply-templates mode="serialize"/>
		</failure>
	</xsl:template>

	<!-- Prevent output test case successes -->
	<xsl:template match="test:result[@type = 'success']"/>

	<!-- Serialize error stack output so document is valid JUnit XML -->
	<xsl:template match="*" mode="serialize">
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="name()"/>
		<xsl:apply-templates select="@*" mode="serialize" />
		<xsl:if test="self::error:error">
			<xsl:for-each select="namespace::*">
				<xsl:text> </xsl:text>
				<xsl:value-of select="name()"/>
				<xsl:text>="</xsl:text>
				<xsl:value-of select="."/>
				<xsl:text>"</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="node()">
				<xsl:text>&gt;</xsl:text>
				<xsl:apply-templates mode="serialize" />
				<xsl:text>&lt;/</xsl:text>
				<xsl:value-of select="name()"/>
				<xsl:text>&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> /&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*" mode="serialize">
		<xsl:text> </xsl:text>
		<xsl:value-of select="name()"/>
		<xsl:text>="</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>"</xsl:text>
	</xsl:template>

	<xsl:template match="text()" mode="serialize">
		<xsl:value-of select="."/>
	</xsl:template>

</xsl:stylesheet>
