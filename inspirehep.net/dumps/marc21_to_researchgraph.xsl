<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    exclude-result-prefixes="xs xsl fn"
    version="1.0">
    
    <!-- =========================================== -->
    <!-- Configuration                                                                             -->
    <!-- =========================================== -->
    <xsl:param name="source" select="'inspirehep.net'"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
    
    <!-- =========================================== -->
    <!-- RegistryObjects (root) Template             -->
    <!-- =========================================== -->
    <xsl:template match="/">
        <registryObjects xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://researchgraph.org/schema/v2.0/xml/nodes
            https://raw.githubusercontent.com/researchgraph/Schema/master/xsd/registryObjects.xsd">
            <!--<publications>
                <xsl:apply-templates select="//record" mode="publication"/>
            </publications>-->
            <researchers>
                <xsl:apply-templates select="//record" mode="researcher"/>
            </researchers>
            <relations>
                <xsl:apply-templates select="//record" mode="relation"/>
            </relations>
        </registryObjects>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Publication Template                                                               -->
    <!-- =========================================== -->
    <xsl:template match="record" mode="publication">
        <xsl:variable name="local_id" select=".//datafield[@tag='035'][subfield='Inspire']/subfield[@code='a']"/>
        <xsl:if test=".//datafield[@tag='035'][subfield='INSPIRE']">
            <publication>
                <key>
                    <xsl:value-of select="concat('researchgraph.org/inspirehep/',$local_id)"/>
                </key>
                <source>
                    <xsl:value-of select="$source"/>
                </source>
                <local_id>
                    <xsl:value-of select="$local_id"/>
                </local_id>
                <last_updated>
                    <xsl:value-of select="ancestor::record/header/datestamp"/>
                </last_updated>
                <url>
                    <xsl:value-of select="concat('https://inspirehep.net/record/',$local_id)"/>
                </url>
                <title>
                    <xsl:value-of select=".//datafield[@tag='245']/subfield[@code='a']"/>
                </title>
                <authors_list>
                    <xsl:value-of select="translate(.//datafield[@tag='100']/subfield[@code='a'],',','.')"/>
                    <xsl:value-of select=" ' , '"/>
                    
                    <xsl:for-each select=".//datafield[@tag='700']">
                        <xsl:value-of select="translate(.//subfield[@code='a'],',','.')"/>
                        <xsl:if test="position() != last()">
                            <xsl:value-of select="' , '"/>
                        </xsl:if>
                    </xsl:for-each>
                </authors_list>
                <xsl:if test=".//datafield[@tag='024'][@ind1='7']">
                    <doi>
                        <xsl:value-of select=".//datafield[@tag='024'][@ind1='7']/subfield[@code='a']"/>
                    </doi>
                </xsl:if>
                <xsl:if test=".//datafield[@tag='260']/subfield[@code='c']">
                    <publication_year>
                        <xsl:value-of select=".//datafield[@tag='260']/subfield[@code='c']"/>
                    </publication_year>
                </xsl:if>
            </publication>
        </xsl:if>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Researcher Template -->
    <!-- =========================================== -->
    <xsl:template match="record" mode="researcher">
        <xsl:for-each select="./datafield[@tag='700'][subfield[@code='x']]
                                     | ./datafield[@tag='100'][subfield[@code='x']]">
            <researcher>
                <key>
                    <xsl:value-of select="concat('researchgraph.org/inspirehep/researcher/', ./subfield[@code='x'])"/>
                </key>
                <!--<source>
                    <xsl:value-of select="$source"/>
                </source>
                <local_id>
                    <xsl:value-of select=".//subfield[@code='i']"/>
                </local_id>
                <last_updated>
                    <xsl:value-of select="ancestor::record/header/datestamp"/>
                </last_updated>
                <full_name>
                    <xsl:value-of select=".//subfield[@code='a']"/>
                </full_name>
                <first_name>
                    <xsl:value-of select="substring-before(.//subfield[@code='a'],',')"/>
                </first_name>
                <last_name>
                    <xsl:value-of select="substring-after(.//subfield[@code='a'],', ')"/>
                </last_name>
                <xsl:if test=".//subfield[@code='j']">
                    <orcid>
                        <xsl:value-of select="subfield[@code='j']"/>
                    </orcid>
                </xsl:if>-->
            </researcher>
        </xsl:for-each>
    </xsl:template>
    
    <!-- =========================================== -->
    <!-- Relation Template                                                                    -->
    <!-- =========================================== -->
    <!--<xsl:template match="record" mode="relation">
        <relation>
            <from_key>
                <xsl:value-of select="'fromkey'"/>
            </from_key>
            <to_uri>
                <xsl:value-of select="'to_uri'"/>
            </to_uri>
        </relation>
    </xsl:template>-->
</xsl:stylesheet>