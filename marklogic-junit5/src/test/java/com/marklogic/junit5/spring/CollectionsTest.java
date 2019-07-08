package com.marklogic.junit5.spring;

import com.marklogic.client.io.DocumentMetadataHandle;
import com.marklogic.client.io.StringHandle;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class CollectionsTest extends AbstractSpringMarkLogicTest {

	@Test
	public void test() {
		DocumentMetadataHandle metadata = new DocumentMetadataHandle();
		metadata.getCollections().addAll("blue", "red");
		getDatabaseClient().newXMLDocumentManager().write("/test1.xml", metadata, new StringHandle("<hello>world</hello>"));

		metadata = new DocumentMetadataHandle();
		metadata.getCollections().addAll("blue", "green");
		getDatabaseClient().newXMLDocumentManager().write("/test2.xml", metadata, new StringHandle("<hello>again</hello>"));

		assertInCollections("/test1.xml", "blue", "red");
		assertNotInCollections("/test1.xml", "green");
		assertCollectionSize("blue", 2);
		assertCollectionSize("red", 1);
		assertCollectionSize("green", 1);

		assertEquals(2, getUrisInCollection("blue", 2).size());
	}
}
