package com.marklogic.junit5;

import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.Namespace;
import org.jdom2.filter.Filters;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;
import org.jdom2.xpath.XPathExpression;
import org.jdom2.xpath.XPathFactory;
import org.junit.jupiter.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Encapsulates an XML node with a variety of methods for assisting with XPath-based assertions in a JUnit test.
 * Depends on JDOM2 and Jaxen for constructing and evaluating XPath expressions.
 */
public class XmlNode {

	protected final Logger logger = LoggerFactory.getLogger(getClass());

	private Document internalDoc;
	private Namespace[] namespaces;
	private String uri;

	public XmlNode(Document doc) {
		this.internalDoc = doc;
	}

	public XmlNode(String xml, Namespace... namespaces) {
		try {
			internalDoc = new SAXBuilder().build(new StringReader(xml));
			this.namespaces = namespaces;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	public XmlNode(String uri, String xml, Namespace... namespaces) {
		this(xml, namespaces);
		this.uri = uri;
	}

	public XmlNode(XmlNode other) {
		this.internalDoc = other.internalDoc;
		this.namespaces = other.namespaces;
		this.uri = other.uri;
	}

	public XmlNode(Element el, Namespace... namespaces) {
		this.internalDoc = new Document(el.detach());
		this.namespaces = namespaces;
	}

	protected String format(String format, Object... args) {
		return String.format(format, args);
	}

	public XmlNode getXmlNode(String xpath) {
		List<Element> list = evaluateForElements(xpath);
		try {
			assertElementListHasOneElement("Expected to find a single element with xpath: " + xpath, list, xpath);
			return new XmlNode(list.get(0), this.namespaces);
		} catch (AssertionError ae) {
			prettyPrint();
			throw ae;
		}
	}

	public List<XmlNode> getXmlNodes(String xpath) {
		List<Element> elements = evaluateForElements(xpath);
		List<XmlNode> fragments = new ArrayList<XmlNode>();
		for (Element el : elements) {
			fragments.add(new XmlNode(el, this.namespaces));
		}
		return fragments;
	}

	public void assertElementValue(String xpath, String value) {
		assertElementValue(null, xpath, value);
	}

	public String getElementValue(String xpath) {
		List<Element> list = evaluateForElements(xpath);
		try {
			assertElementListHasOneElement("", list, xpath);
			return list.get(0).getText();
		} catch (AssertionError ae) {
			prettyPrint();
			throw ae;
		}
	}

	/**
	 * Seemingly can't use XPath in JDOM2 to get an attribute value directly.
	 */
	public String getAttributeValue(String elementXpath, String attributeName) {
		List<Element> list = evaluateForElements(elementXpath);
		try {
			assertElementListHasOneElement("", list, elementXpath);
			return list.get(0).getAttributeValue(attributeName);
		} catch (AssertionError ae) {
			prettyPrint();
			throw ae;
		}
	}

	public void assertElementValue(String message, String xpath, String value) {
		List<Element> list = evaluateForElements(xpath);
		try {
			Assertions.assertTrue(list.size() > 0, message += ";\nCould not find at least one element, xpath: " + xpath);
			boolean found = false;
			for (Element el : list) {
				if (value.equals(el.getText())) {
					found = true;
					break;
				}
			}
			Assertions.assertTrue(found, message + "\n:Elements: " + list);
		} catch (AssertionError ae) {
			prettyPrint();
			throw ae;
		}
	}

	public void assertElementCount(String xpath, int count) {
		assertElementCount(null, xpath, count);
	}

	public void assertElementCount(String message, String xpath, int count) {
		String xpathToTest = xpath + "[%d]";
		assertElementExists(message, format(xpathToTest, count));
		assertElementMissing(message, format(xpathToTest, count + 1));
	}

	private void assertElementListHasOneElement(String message, List<Element> list, String xpath) {
		int size = list.size();
		Assertions.assertTrue(size == 1, message + ";\nExpected 1 element, but found " + size + "; xpath: " + xpath);
	}

	public void assertElementExists(String xpath) {
		assertElementExists(null, xpath);
	}

	public void assertElementExists(String message, String xpath) {
		List<Element> list = evaluateForElements(xpath);
		try {
			assertElementListHasOneElement(message, list, xpath);
		} catch (AssertionError ae) {
			prettyPrint();
			throw ae;
		}
	}

	public void assertElementMissing(String message, String xpath) {
		List<Element> list = evaluateForElements(xpath);
		Assertions.assertEquals(0, list.size(), message + ";\nexpected no elements matching xpath " + xpath);
	}

	protected List<Element> evaluateForElements(String xpath) {
		XPathFactory f = XPathFactory.instance();
		XPathExpression<Element> expr = f.compile(xpath, Filters.element(), new HashMap<>(), namespaces);
		return expr.evaluate(internalDoc);
	}

	public void prettyPrint() {
		logger.info(getPrettyXml());
	}

	public String getPrettyXml() {
		return new XMLOutputter(Format.getPrettyFormat()).outputString(internalDoc);
	}

	public String getUri() {
		return uri;
	}

	public Document getInternalDoc() {
		return internalDoc;
	}

	public Namespace[] getNamespaces() {
		return namespaces;
	}

	public void setNamespaces(Namespace[] namespaces) {
		this.namespaces = namespaces;
	}
}
