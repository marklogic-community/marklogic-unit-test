package com.marklogic.test.unit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;

/**
 * JAXP-based implementation. Not the prettiest code, but doesn't have any 3rd-party dependencies,
 * only relies on what Java provides by itself.
 */
public class JaxpServiceResponseUnmarshaller implements ServiceResponseUnmarshaller {

  protected final Logger logger = LoggerFactory.getLogger(getClass());
  private DocumentBuilder documentBuilder;
  private static final int ELEMENT_TYPE = 1;

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
    NodeList testCases = root.getChildNodes();
    int cases = testCases.getLength();

    TestSuiteResult testSuiteResult = new TestSuiteResult(prettyPrintXml(xml), name, cases, total, passed, failed, time);

    for (int i = 0; i < testCases.getLength(); i++) {
      Element testNode = (Element) testCases.item(i);
      String testName = testNode.getAttribute("name");
      double testTime = Double.parseDouble(testNode.getAttribute("time"));
      NodeList resultNodes = testNode.getChildNodes();
      String failureXml = null;
      for (int j = 0; j < resultNodes.getLength(); j++) {
        // An XQuery test module may return additional nodes, such as text nodes, which should be
        // ignored unless they are element nodes.
        if (resultNodes.item(j).getNodeType() == ELEMENT_TYPE) {
          Element resultNode = (Element) resultNodes.item(j);
          if ("fail".equals(resultNode.getAttribute("type"))) {
            failureXml = toXml(resultNode);
            break;
          }
        } else {
          logger.debug("Ignoring Node Type [" + resultNodes.item(j).getNodeType() + "]");
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
    NodeList testCases = root.getChildNodes();
    int cases = testCases.getLength();
    JUnitTestSuite suite = new JUnitTestSuite(prettyPrintXml(xml), errors, failures, hostname, name, cases, tests, time);
    for (int i = 0; i < testCases.getLength(); i++) {
      Element node = (Element) testCases.item(i);
      String testName = node.getAttribute("name");
      String classname = node.getAttribute("classname");
      double testTime = Double.parseDouble(root.getAttribute("time"));
      int testCaseTests = Integer.parseInt(node.getAttribute("tests"));
      int testsSuccess = Integer.parseInt(node.getAttribute("success"));
      int testsFail = Integer.parseInt(node.getAttribute("fail"));

      JUnitTestCase testCase = new JUnitTestCase(testName, classname, testTime, testCaseTests, testsSuccess, testsFail);
      suite.addTestCase(testCase);

      NodeList failureNodes = node.getElementsByTagName("failure");
      for (int j = 0; j < failureNodes.getLength(); j++) {
        Element failureNode = (Element) failureNodes.item(j);
        String type = failureNode.getAttribute("type");
        String message = failureNode.getAttribute("message");
        String failureXml = toXml(failureNode);
        testCase.addTestFailure(new JUnitTestFailure(type, message, failureXml));
      }
      NodeList coverageNodes = node.getElementsByTagName("coverage");
      for (int j = 0; j < coverageNodes.getLength(); j++) {
        Element coverageNode = (Element) coverageNodes.item(j);
        String module = coverageNode.getAttribute("module");
        NodeList coverageInfo = coverageNode.getChildNodes();
        JUnitTestCoverage testCoverage = new JUnitTestCoverage(module);
        testCase.addTestCoverage(testCoverage);
        for (int k = 0; k < coverageInfo.getLength(); k++) {
          Element coverageInfoNode = (Element) coverageInfo.item(k);
          String type = coverageInfoNode.getTagName();
          int count = Integer.parseInt(coverageInfoNode.getAttribute("count"));
          String infoXml = toXml(coverageInfoNode);
          testCoverage.addCoverageInfo(new JUnitTestCoverageInfo(type, count, infoXml));
        }
      }
    }

    return suite;
  }

  protected String toXml(Node node) {
    try {
      TransformerFactory transFactory = TransformerFactory.newInstance();
      Transformer transformer = transFactory.newTransformer();
      StringWriter buffer = new StringWriter();
      transformer.transform(new DOMSource(node), new StreamResult(buffer));
      return buffer.toString();
    } catch (Exception ex) {
      throw new RuntimeException(ex);
    }
  }

  protected String prettyPrintXml(String xmlString) {
    return prettyPrintXml(xmlString, 2, false);
  }

  protected String prettyPrintXml(String xmlString, int indent, boolean ignoreDeclaration) {
    try {
      InputSource src = new InputSource(new StringReader(xmlString));
      Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(src);

      TransformerFactory transformerFactory = TransformerFactory.newInstance();
      transformerFactory.setAttribute("indent-number", indent);
      Transformer transformer = transformerFactory.newTransformer();
      transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
      transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, ignoreDeclaration ? "yes" : "no");
      transformer.setOutputProperty(OutputKeys.INDENT, "yes");

      StringWriter buffer = new StringWriter();
      transformer.transform(new DOMSource(document), new StreamResult(buffer));
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
