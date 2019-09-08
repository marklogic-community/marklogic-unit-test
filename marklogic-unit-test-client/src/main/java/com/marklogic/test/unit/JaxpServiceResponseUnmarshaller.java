package com.marklogic.test.unit;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;
import org.xml.sax.InputSource;

/**
 * JAXP-based implementation. Not the prettiest code, but doesn't have any 3rd-party dependencies,
 * only relies on what Java provides by itself.
 */
public class JaxpServiceResponseUnmarshaller implements ServiceResponseUnmarshaller {

	private DocumentBuilder documentBuilder;

	@Override
	public List<TestModule> parseTestList(String xml) {
		NodeList kids = parse(xml).getDocumentElement().getChildNodes();
		List<TestModule> testModules = new ArrayList<>();
		for (int i = 0; i < kids.getLength(); i++) {
			Node suiteNode = kids.item(i);
			if ("suite".equals(suiteNode.getLocalName())
				&& "http://marklogic.com/test".equals(suiteNode.getNamespaceURI())) {
				String suite = suiteNode.getAttributes().getNamedItem("path").getTextContent();
				NodeList testsNodes = suiteNode.getChildNodes();
				for (int j = 0; j < testsNodes.getLength(); j++) {
					NodeList testNodes = testsNodes.item(j).getChildNodes();
					for (int k = 0; k < testNodes.getLength(); k++) {
						Node testNode = testNodes.item(k);
						String test = testNode.getAttributes().getNamedItem("path").getTextContent();
						testModules.add(new TestModule(test, suite));
					}
				}
			}
		}
		return testModules;
	}

	@Override
	public TestSuiteResult parseTestSuiteResult(String xml) {
		Element root = parse(xml).getDocumentElement();
		String name = root.getAttribute("name");
		int total = Integer.parseInt(root.getAttribute("total"));
		int passed = Integer.parseInt(root.getAttribute("passed"));
		int failed = Integer.parseInt(root.getAttribute("failed"));
		double time = Double.parseDouble(root.getAttribute("time"));
		TestSuiteResult testSuiteResult = new TestSuiteResult(xml, name, total, passed, failed, time);

		NodeList tests = root.getChildNodes();
		for (int i = 0; i < tests.getLength(); i++) {
			Element testNode = (Element) tests.item(i);
			String testName = testNode.getAttribute("name");
			double testTime = Double.parseDouble(testNode.getAttribute("time"));
			NodeList resultNodes = testNode.getChildNodes();
			String failureXml = null;
			for (int j = 0; j < resultNodes.getLength(); j++) {
				Element resultNode = (Element) resultNodes.item(j);
				if ("fail".equals(resultNode.getAttribute("type"))) {
					failureXml = toXml(resultNode);
					break;
				}
			}
			testSuiteResult.addTestResult(new TestResult(testName, testTime, failureXml));
		}

		return testSuiteResult;
	}

	@Override
	public JUnitTestSuite parseJUnitTestSuiteResult(String xml) {
		Element root = parse(xml).getDocumentElement();
		int errors = Integer.parseInt(root.getAttribute("errors"));
		int failures = Integer.parseInt(root.getAttribute("failures"));
		String hostname = root.getAttribute("hostname");
		String name = root.getAttribute("name");
		int tests = Integer.parseInt(root.getAttribute("tests"));
		double time = Double.parseDouble(root.getAttribute("time"));
		JUnitTestSuite suite = new JUnitTestSuite(xml, errors, failures, hostname, name, tests, time);

		NodeList testCases = root.getChildNodes();
		for (int i = 0; i < testCases.getLength(); i++) {
			Element node = (Element) testCases.item(i);
			String testName = node.getAttribute("name");
			String classname = node.getAttribute("classname");
			double testTime = Double.parseDouble(root.getAttribute("time"));
			JUnitTestCase testCase = new JUnitTestCase(testName, classname, testTime);
			suite.addTestCase(testCase);

			NodeList failureNodes = node.getChildNodes();
			for (int j = 0; j < failureNodes.getLength(); j++) {
				Element failureNode = (Element) failureNodes.item(j);
				String type = failureNode.getAttribute("type");
				String message = failureNode.getAttribute("message");
				String failureXml = toXml(failureNode);
				testCase.addTestFailure(new JUnitTestFailure(type, message, failureXml));
			}
		}

		return suite;
	}

	protected String toXml(Node node) {
		try {
			TransformerFactory transFactory = TransformerFactory.newInstance();
			Transformer transformer = transFactory.newTransformer();
			StringWriter buffer = new StringWriter();
			transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
			transformer.transform(new DOMSource(node), new StreamResult(buffer));
			return buffer.toString();
		} catch (Exception ex) {
			throw new RuntimeException(ex);
		}
	}

	protected void initializeDocumentBuilder() {
		if (documentBuilder == null) {
			try {
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
				factory.setNamespaceAware(true);
				documentBuilder = factory.newDocumentBuilder();
			} catch (Exception ex) {
				throw new RuntimeException("Unable to construct JAXP DocumentBuilder, cause: " + ex.getMessage(), ex);
			}
		}
	}

	protected Document parse(String xml) {
		initializeDocumentBuilder();
		try {
			return documentBuilder.parse(new InputSource(new StringReader(xml)));
		} catch (Exception ex) {
			throw new RuntimeException("Unable to parse test list XML, cause: " + ex.getMessage(), ex);
		}
	}

}
