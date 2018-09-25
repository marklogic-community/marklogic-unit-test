---
layout: inner
title: How to Include ML Unit Test
lead_text: ''
permalink: /include/
---

# How to Include ML Unit Test in Your Project

ML Unit Test is built to make it easy to include in projects that use [ml-gradle](https://github.com/marklogic-community/ml-gradle). 

## Enabling marklogic-unit-test in an ml-gradle project

Using marklogic-unit-test requires two additions to the `build.gradle` file, as described below.

First, ml-gradle includes an "mlUnitTest" task, which depends on the marklogic-unit-test-client JAR file. ml-gradle 
does not include this by default (not every ml-gradle user will use marklogic-unit-test), so it must be added to the 
buildscript:

    buildscript {
      repositories {
        jcenter()
      }
      dependencies {
        classpath "com.marklogic:marklogic-unit-test-client:0.12.0"
      }
    }

Next, the marklogic-unit-test framework is depended on and installed as an "mlRestApi" dependency (the "mlRestApi" 
configuration is a feature of ml-gradle for depending on packages of MarkLogic modules):

    repositories {
      jcenter()
    }
      
    dependencies {
      mlRestApi "com.marklogic:marklogic-unit-test-modules:0.12.0"
    }

## Configuring which server mlUnitTest connects to 

Prior to ml-gradle 3.8.1, the `mlUnitTest` task will connect to `mlTestRestPort` if it's set, else `mlRestPort`. 

Starting in release 3.8.1, you can configure which REST API server `mlUnitTest` will connect to. The `mlUnitTest` task 
now exposes a property of type [`DatabaseClientConfig`]. You can configure the properties of this object, and mlUnitTest 
will use it for creating a connection to MarkLogic. 

Below is an example - note that you need to configure every property necessary for the type of connection you want, as 
none of the properties of the `DatabaseClientConfig` have any default value:

    mlUnitTest.databaseClientConfig.host = mlHost
    mlUnitTest.databaseClientConfig.port = 8880 // probably a port that differs from mlRestPort and mlTestRestPort
    mlUnitTest.databaseClientConfig.username = mlUsername
    mlUnitTest.databaseClientConfig.password = mlPassword
    // Other properties that can be set
    // mlUnitTest.databaseClientConfig.securityContextType
    // mlUnitTest.databaseClientConfig.database
    // mlUnitTest.databaseClientConfig.sslContext
    // mlUnitTest.databaseClientConfig.sslHostnameVerifier
    // mlUnitTest.databaseClientConfig.certFile
    // mlUnitTest.databaseClientConfig.certPassword 
    // mlUnitTest.databaseClientConfig.externalName
    // mlUnitTest.databaseClientConfig.trustManager

## Using a Test Content Database

Note that you should set up a separate content database for testing, using the same configuration as your regular 
content. Unit tests will likely insert, update, and delete data; you probably don't want that happening in your main 
database. 

[DatabaseClientConfig]: https://github.com/marklogic-community/ml-javaclient-util/blob/master/src/main/java/com/marklogic/client/ext/DatabaseClientConfig.java
