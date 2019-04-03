package com.marklogic.junit5;

import org.jdom2.Namespace;

import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of NamespaceProvider that registers a handful of commonly used MarkLogic namespaces and prefixes.
 */
public class MarkLogicNamespaceProvider implements NamespaceProvider {

	private List<Namespace> namespaces;

	/**
	 * @param additionalPrefixesAndUris
	 */
	public MarkLogicNamespaceProvider(String... additionalPrefixesAndUris) {
		this.namespaces = new ArrayList<>();
		addNamespace("admin", "http://marklogic.com/xdmp/admin");
		addNamespace("cts", "http://marklogic.com/cts");
		addNamespace("prop", "http://marklogic.com/xdmp/property");
		addNamespace("search", "http://marklogic.com/appservices/search");
		addNamespace("sec", "http://marklogic.com/xdmp/security");
		addNamespace("sem", "http://marklogic.com/semantics");

		if (additionalPrefixesAndUris != null) {
			for (int i = 0; i < additionalPrefixesAndUris.length; i += 2) {
				addNamespace(additionalPrefixesAndUris[i], additionalPrefixesAndUris[i + 1]);
			}
		}
	}

	@Override
	public Namespace[] getNamespaces() {
		return namespaces.toArray(new Namespace[]{});
	}

	protected void addNamespace(String prefix, String uri) {
		namespaces.add(Namespace.getNamespace(prefix, uri));
	}
}
