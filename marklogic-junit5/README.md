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

If you're working on a Data Hub Framework (DHF) project and you're like to start writing JUnit tests to verify your application 
features, then check out the DHF example project to see a working example with instructions on how to get started.

