## Easy JUnit 5 testing with MarkLogic

Want to write JUnit 5 tests that verify the behavior of endpoints in [MarkLogic](https://www.marklogic.com/), 
including applications using the [Data Hub Framework](https://marklogic.github.io/marklogic-data-hub/)? 
This library makes that as simple as possible by providing the following support:

1. Connect to MarkLogic with the [MarkLogic Java Client](https://developer.marklogic.com/products/java) by reusing
configuration you've already defined in your project
1. Clear your test database before a test run so it always runs in a known state
1. Easily read and make assertions on JSON and XML documents, including support for XPath-based assertions
1. Easily integrate [marklogic-unit-test](https://github.com/marklogic-community/marklogic-unit-test) tests into a JUnit test suite

Below is a simple example of a JUnit test that writes a couple documents, runs a search on them, and then reads them 
back and verifies the contents of each document:

```
public class SearchTest extends AbstractSpringMarkLogicTest {

	@Test
	public void twoDocuments() {
		getDatabaseClient().newXMLDocumentManager().write("/test/1.xml", new StringHandle("<message>Hello world</message>"));
		getDatabaseClient().newJSONDocumentManager().write("/test/2.json", new StringHandle("{\"message\":\"Hello world\"}"));

		QueryManager queryManager = getDatabaseClient().newQueryManager();
		SearchHandle searchHandle = queryManager.search(queryManager.newStringDefinition(), new SearchHandle());
		assertEquals(2, searchHandle.getTotalResults());

		XmlNode xml = readXmlDocument("/test/1.xml");
		xml.assertElementValue("/message", "Hello world");

		JsonNode json = readJsonDocument("/test/2.json");
		assertEquals("Hello world", json.get("message").asText());
	}
}
```

## Getting started on an ml-gradle project

If you'd like to use marklogic-junit5 on a regular ml-gradle project (not a DHF project), then 
start with the ml-gradle example project to see a working example with instructions on how to get started. 

## Getting started on a Data Hub Framework project 

As of DHF 5.5, support exists within DHF 5 for writing tests and should be used instead of this project. 
See [this example project](https://github.com/marklogic/marklogic-data-hub/tree/master/examples/reference-entity-model#testing-support) 
for more information.

If you're using DHF 4, see [the DHF 4 example project](https://github.com/marklogic-community/marklogic-unit-test/tree/1.0.0/marklogic-junit5/examples/simple-dhf4)
from the 1.0.0 tag of this repository. 

## Running the tests within this project

If you'd like to run the tests within this project, you'll first need to create a gradle-local.properties file in this 
project that defines your admin user's password - e.g. 

    mlPassword=admin

The tests will make use of MarkLogic's out-of-the-box Documents database. Be sure you do not have anything of importance 
in this database, as it will be cleared before each test is run.

You can then run the tests via Gradle:

    ../gradlew clean test
