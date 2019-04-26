package com.marklogic.junit5;

import org.jdom2.Namespace;

/**
 * Provides an array of Namespace objects that can be registered with JDOM for use in XPath expressions.
 */
public interface NamespaceProvider {

	Namespace[] getNamespaces();
}
