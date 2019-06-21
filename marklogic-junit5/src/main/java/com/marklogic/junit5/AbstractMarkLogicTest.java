package com.marklogic.junit5;

import com.fasterxml.jackson.databind.JsonNode;
import com.marklogic.client.DatabaseClient;
import com.marklogic.client.ext.helper.ClientHelper;
import com.marklogic.client.ext.helper.LoggingObject;
import com.marklogic.client.io.BytesHandle;
import com.marklogic.client.io.DocumentMetadataHandle;
import com.marklogic.client.io.JacksonHandle;
import com.marklogic.client.io.StringHandle;
import com.marklogic.test.unit.TestManager;
import com.marklogic.test.unit.TestModule;
import com.marklogic.test.unit.TestResult;
import com.marklogic.test.unit.TestSuiteResult;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * Abstract base class for writing JUnit tests that depend on a connection to MarkLogic via a DatabaseClient. Provides
 * support for the following:
 * <ol>
 * <li>Delete all or a subset of documents in the test database before each test method runs</li>
 * <li>Methods for reading XML or a document at a URI into an XmlNode object</li>
 * <li>Methods for making common assertions on collections, permissions, and document properties</li>
 * </ol>
 * <p>
 * This class depends on a DatabaseClient, and how that is provided must be defined by the subclass.
 * </p>
 */
public abstract class AbstractMarkLogicTest extends LoggingObject {

	/**
	 * A Logger is declared, as the SLF4J Logger API is brought in via the ml-javaclient-util dependency.
	 */
	protected final Logger logger = LoggerFactory.getLogger(getClass());

	/**
	 * Subclass must define how a connection is made to (presumably) the test database.
	 *
	 * @return
	 */
	protected abstract DatabaseClient getDatabaseClient();

	/**
	 * Before a test method runs, delete all of the documents in the database that match the query defined by
	 * getJavascriptForDeletingDocumentsBeforeTestRuns.
	 */
	@BeforeEach
	public void deleteDocumentsBeforeTestRuns() {
		getDatabaseClient().newServerEval().javascript(getJavascriptForDeletingDocumentsBeforeTestRuns()).evalAs(String.class);
	}

	/**
	 * Protected so a subclass can modify this to, e.g., not delete every document.
	 */
	protected String getJavascriptForDeletingDocumentsBeforeTestRuns() {
		return "declareUpdate(); cts.uris('', [], cts.trueQuery()).toArray().forEach(item => xdmp.documentDelete(item))";
	}

	/**
	 * Used to construct an XmlNode with the returned NamespaceProvider associated with it,
	 * thereby making the namespaces available for XPath expressions.
	 *
	 * @return
	 */
	protected NamespaceProvider getNamespaceProvider() {
		return new MarkLogicNamespaceProvider();
	}

	/**
	 * Parse the given XML and return an XmlNode for marking assertions on the contents of the XML.
	 *
	 * @param xml
	 * @return
	 */
	protected XmlNode parseXml(String xml) {
		return new XmlNode(xml, getNamespaceProvider().getNamespaces());
	}

	/**
	 * Read the XML document at the given URI and return an XmlNode for making assertions on the contents of the XML.
	 *
	 * @param uri
	 * @param expectedCollections If any are specified, the document is verified to be in each of the given collections
	 * @return
	 */
	protected XmlNode readXmlDocument(String uri, String... expectedCollections) {
		String xml = getDatabaseClient().newXMLDocumentManager().read(uri, new StringHandle()).get();
		if (expectedCollections != null) {
			assertInCollections(uri, expectedCollections);
		}
		return new XmlNode(uri, xml, getNamespaceProvider().getNamespaces());
	}

	/**
	 * Read the JSON document at the given URI and return a JsonNode.
	 *
	 * @param uri
	 * @param expectedCollections If any are specified, the document is verified to be in each of the given collections
	 * @return
	 */
	protected JsonNode readJsonDocument(String uri, String... expectedCollections) {
		JsonNode json = getDatabaseClient().newJSONDocumentManager().read(uri, new JacksonHandle()).get();
		if (expectedCollections != null) {
			assertInCollections(uri, expectedCollections);
		}
		return json;
	}

	/**
	 * Verify that the document at the given URI is in the given collections.
	 *
	 * @param uri
	 * @param collections
	 */
	protected void assertInCollections(String uri, String... collections) {
		List<String> colls = new ClientHelper(getDatabaseClient()).getCollections(uri);
		for (String c : collections) {
			Assertions.assertTrue(colls.contains(c), String.format("Expected URI %s to be in collection %s", uri, c));
		}
	}

	/**
	 * Verify that the document at the given URI is not in any of the given collections.
	 *
	 * @param message
	 * @param uri
	 * @param collections
	 */
	protected void assertNotInCollections(String uri, String... collections) {
		List<String> colls = new ClientHelper(getDatabaseClient()).getCollections(uri);
		for (String c : collections) {
			Assertions.assertFalse(colls.contains(c), String.format("Expected URI %s to not be in collection %s", uri, c));
		}
	}

	protected void assertCollectionSize(String collection, int size) {
		assertCollectionSize(null, collection, size);
	}

	/**
	 * Verify the size of the given collection.
	 *
	 * @param message
	 * @param collection
	 * @param size
	 */
	protected void assertCollectionSize(String message, String collection, int size) {
		Assertions.assertEquals(size, new ClientHelper(getDatabaseClient()).getCollectionSize(collection), message);
	}

	/**
	 * Get all URIs in the given collection, verifying the count at the same time.
	 *
	 * @param collectionName
	 * @param expectedCount
	 * @return
	 */
	protected List<String> getUrisInCollection(String collectionName, int expectedCount) {
		List<String> uris = new ClientHelper(getDatabaseClient()).getUrisInCollection(collectionName, expectedCount + 1);
		Assertions.assertEquals(expectedCount, uris.size(), String.format("Expected %d uris in collection %s", expectedCount, collectionName));
		return uris;
	}

	/**
	 * Returns a PermissionsTester object based on the permissions on the document at the given URI, which provides
	 * convenience methods for asserting on the permissions on a document.
	 *
	 * @param uri
	 * @param t
	 * @return
	 */
	protected PermissionsTester readDocumentPermissions(String uri) {
		DocumentMetadataHandle metadata = new DocumentMetadataHandle();
		getDatabaseClient().newDocumentManager().read(uri, metadata, new BytesHandle());
		return new PermissionsTester(metadata.getPermissions());
	}

	/**
	 * Convenience method for getting the properties for a document as a fragment.
	 *
	 * @param uri
	 * @param client
	 * @return
	 */
	protected XmlNode readDocumentProperties(String uri) {
		return new XmlNode(getDatabaseClient().newServerEval().xquery(String.format("xdmp:document-properties('%s')", uri)).evalAs(String.class));
	}

	/**
	 * Convenience method for executing marklogic-unit-test tests.
	 *
	 * @param testModule
	 */
	protected void runMarkLogicUnitTests(TestModule testModule) {
		TestSuiteResult result = new TestManager(getDatabaseClient()).run(testModule);
		for (TestResult testResult : result.getTestResults()) {
			String failureXml = testResult.getFailureXml();
			if (failureXml != null) {
				Assertions.fail(String.format("Test %s in suite %s failed, cause: %s", testResult.getName(), testModule.getSuite(), failureXml));
			}
		}
	}
}
