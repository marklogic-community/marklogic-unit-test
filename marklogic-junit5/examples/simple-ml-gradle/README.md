This project shows a basic setup for writing JUnit tests with marklogic-junit5 against an application deployed 
with [ml-gradle](https://github.com/marklogic-community/ml-gradle). In addition, it includes an example of executing
tests written using [marklogic-unit-test](https://github.com/marklogic-community/marklogic-unit-test) via JUnit.

## Trying the project out locally

To try this project out locally, assuming you've cloned this repository, just run the following steps:

First, deploy the application:

    ./gradlew mlDeploy

And then run the tests:

    ./gradlew test

This task should complete with an output of "BUILD SUCCESSFUL", with the JUnit test being written to 
./build/reports/tests/test/index.html . In this report, you'll also see how the 2 marklogic-unit-test modules - located under
src/test/ml-modules - were both executed as separate tests. 

## Using marklogic-junit5 in your own ml-gradle project

Read through each of the following steps to use marklogic-junit5 in your own project.

### Configure build.gradle

First, make sure you're applied the Gradle "java" plugin:

    plugins {
        id "java"
        // other plugins, such as ml-gradle
    } 

Next, add the following dependencies:

    dependencies {
      // existing dependencies
      
      testImplementation "com.marklogic:marklogic-junit5:1.2.0"
            
      testImplementation "org.junit.jupiter:junit-jupiter:5.7.2"
    
      // Forcing Spring to use logback instead of commons-logging
      testImplementation "ch.qos.logback:logback-classic:1.2.4"
      testImplementation "org.slf4j:jcl-over-slf4j:1.7.31"
      testImplementation "org.slf4j:slf4j-api:1.7.31"
    }
    
### Configure gradle.properties

If you haven't already, set the value of mlTestRestPort in gradle.properties to an available port:

    mlTestRestPort=8019

If you haven't done this and run mlDeploy before, then run mlDeploy now to deploy a test app server and database that
mirror your regular REST server and database (marklogic-junit5 depends on a REST server):

    ./gradlew mlDeploy

### Add a Logback configuration file for logging

If you aren't already configuring Logback for logging purposes, then consider copying the src/test/resources/logback.xml 
file in this project into the same location in your own project. This step isn't required, but it's typically useful to 
log some information in certain tests.

### Create a test class and run it

You're now ready to start writing JUnit 5 tests using marklogic-junit5. See the src/test/java/org/example directory in 
this project for several examples of tests that write and read documents, search them, and make assertions (including 
XPath expressions with custom namespace prefixes) on different aspects of documents.

The key point here is that the tests in this project extend AbstractSpringMarkLogicTest. This class uses 
[Spring's test support](https://docs.spring.io/spring/docs/current/spring-framework-reference/testing.html) to 
execute JUnit 5 tests with all of Spring's support for dependency and configuration management. This class depends on 
another class from marklogic-junit5 named SimpleTestConfig to create a DatabaseClient that connects to your test REST 
server. SimpleTestConfig assumes the following properties can be found in gradle.properties and gradle-local.properties:

- mlUsername
- mlPassword
- mlHost
- mlTestRestPort

If you're using a different way of authenticating with your test REST server, you can make your own Spring configuration 
class (it's worth using SimpleTestConfig as a starting point) and then use that via the following annotation on your 
own test class:

    @ContextConfiguration(classes = {MyCustomTestConfig.class})
    public abstract AbstractApplicationTest extends AbstractSpringMarkLogicTest
    
Alternatively, because AbstractSpringMarkLogicTest is so simple, you can make your own variation of it that extends 
AbstractMarkLogicTest:

    @ExtendWith(SpringExtension.class)
    @ContextConfiguration(classes = {MyCustomTestConfig.class})
    public abstract AbstractApplicationTest extends AbstractMarkLogicTest {
    
        @Autowired
        protected DatabaseClientProvider databaseClientProvider;
      
        @Override
        protected DatabaseClient getDatabaseClient() {
          return databaseClientProvider.getDatabaseClient();
        }
    }
    
You'll still be able to leverage all of the testing support in AbstractMarkLogicTest.

### Optional - configuring marklogic-unit-test

If you'd like to write and execute marklogic-unit-test test modules, add the following to your build.gradle file as well (grab
the latest version for both dependencies):

    mlBundle "com.marklogic:marklogic-unit-test-modules:1.2.0"
    testImplementation "com.marklogic:marklogic-unit-test-client:1.2.0"

In addition, add the following to gradle.properties so that you can store test modules in a directory separate from 
your application modules:

    mlModulePaths=src/main/ml-modules,src/test/ml-modules

Finally, you'll need to stub out a very simple class in your src/test/java directory. You can use any class name and 
package - the class simply needs to extend MarkLogicUnitTestsTest. For example, this is the class found in this sample project:

    package org.example;    
    import com.marklogic.junit5.spring.MarkLogicUnitTestsTest;
    public class UnitTestsTest extends MarkLogicUnitTestsTest {}

When this class is run, a test method in the parent class will be executed that handles finding all of the 
marklogic-unit-test test modules and executing each one as a separate JUnit test. 
