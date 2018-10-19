package com.marklogic.test.unit;

import com.marklogic.client.DatabaseClient;
import com.marklogic.client.extensions.ResourceManager;
import com.marklogic.client.io.StringHandle;
import com.marklogic.client.io.marker.AbstractWriteHandle;
import com.marklogic.client.util.RequestParameters;

import java.util.ArrayList;
import java.util.List;

/**
 * Provides methods for talking to the marklogic-unit-test REST extension.
 */
public class TestManager extends ResourceManager {

	public final static String FORMAT_JUNIT = "junit";

	/**
	 * The "none" format means that the XML will be returned from the marklogic-unit-test endpoint without any additional
	 * formatting applied to it.
	 */
	public final static String FORMAT_NONE = "";

	private ServiceResponseUnmarshaller unitTestXmlParser;

	public TestManager(DatabaseClient client) {
		this(client, new JaxpServiceResponseUnmarshaller());
	}

	public TestManager(DatabaseClient client, ServiceResponseUnmarshaller unitTestXmlParser) {
		super();
		this.unitTestXmlParser = unitTestXmlParser;
		client.init("marklogic-unit-test", this);
	}

	/**
	 * @return one TestModule for each test module found in the modules database
	 */
	public List<TestModule> list() {
		RequestParameters params = new RequestParameters();
		params.add("func", "list");
		String xml = getServices().get(params, new StringHandle()).get();
		return unitTestXmlParser.parseTestList(xml);
	}

	/**
	 * @return the distinct set of suite names in all of the test modules
	 */
	public List<String> listSuites() {
		List<TestModule> testModules = list();
		List<String> suites = new ArrayList<>();
		for (TestModule testModule : testModules) {
			String suite = testModule.getSuite();
			if (!suites.contains(suite)) {
				suites.add(suite);
			}
		}
		return suites;
	}

	/**
	 * Run a single test module. This is intended to be used in a parameterized JUnit test, where each test
	 * module is intended to correspond to a separate JUnit test.
	 *
	 * @param testModule
	 * @return
	 */
	public TestSuiteResult run(TestModule testModule) {
		return run(testModule, true, true, false);
	}

	/**
	 *
	 * Run a single test module. This is intended to be used in a parameterized JUnit test, where each test
	 * module is intended to correspond to a separate JUnit test.
	 *
	 * @param testModule
	 * @param runTeardown
	 * @param runSuiteTeardown
	 * @param calculateCoverage
	 * @return
	 */
	public TestSuiteResult run(TestModule testModule, boolean runTeardown, boolean runSuiteTeardown, boolean calculateCoverage) {
		RequestParameters params = buildRequestParameters(testModule.getSuite(), null, FORMAT_NONE, runTeardown, runSuiteTeardown, calculateCoverage);

		String test = testModule.getTest();
		if (test != null) {
			params.add("tests", testModule.getTest());
		}

		String xml = getServices().post(params, (AbstractWriteHandle) null, new StringHandle()).get();
		return unitTestXmlParser.parseTestSuiteResult(xml);
	}

	/**
	 * @return a JUnitTestSuite for every suite found in the modules database
	 */
	public List<JUnitTestSuite> runAllSuites() {
		return runAllSuites(true, true, false);
	}

	/**
	 *
	 * @param runTeardown
	 * @param runSuiteTeardown
	 * @param calculateCoverage
	 * @return a JUnitTestSuite for every suite found in the modules database
	 */
	public List<JUnitTestSuite> runAllSuites(boolean runTeardown, boolean runSuiteTeardown, boolean calculateCoverage) {
	  return runAllSuites(null, runTeardown, runSuiteTeardown, calculateCoverage);
	}

  /**
   * @param tests
   * @param runTeardown
   * @param runSuiteTeardown
   * @param calculateCoverage
   * @return
   */
  public List<JUnitTestSuite> runAllSuites(String tests, boolean runTeardown, boolean runSuiteTeardown, boolean calculateCoverage) {
    List<String> suiteNames = listSuites();
    List<JUnitTestSuite> suites = new ArrayList<>();
    for (String suiteName : suiteNames) {
      JUnitTestSuite suite = runSuite(suiteName, tests, FORMAT_JUNIT, runTeardown, runSuiteTeardown, calculateCoverage);
      suites.add(suite);
    }
    return suites;
  }

    /**
	   * @param suite
	   * @return a JUnitTestSuite capturing the results of running the given suite name
	   */
	public JUnitTestSuite runSuite(String suite) {
		return runSuite(suite, true, true, false);
	}

	/**
	 *
	 * @param suite
	 * @param runTeardown
	 * @param runSuiteTeardown
	 * @param calculateCoverage
	 * @return
	 */
	public JUnitTestSuite runSuite(String suite, boolean runTeardown, boolean runSuiteTeardown, boolean calculateCoverage) {
	  return runSuite(suite, null, FORMAT_JUNIT, runTeardown, runSuiteTeardown, calculateCoverage);
	}

  /**
   *
   * @param suite
   * @param tests
   * @param format
   * @param runTeardown
   * @param runSuiteTeardown
   * @param calculateCoverage
   * @return
   */
  public JUnitTestSuite runSuite(String suite, String tests, String format, boolean runTeardown, boolean runSuiteTeardown, boolean calculateCoverage) {
    RequestParameters params = buildRequestParameters(suite, tests, format, runTeardown, runSuiteTeardown, calculateCoverage);
    String xml = getServices().post(params, (AbstractWriteHandle) null, new StringHandle()).get();
    return unitTestXmlParser.parseJUnitTestSuiteResult(xml);
  }

  /**
   *
   * @param suite
   * @param tests
   * @param format
   * @param runTeardown
   * @param runSuiteTeardown
   * @param calculateCoverage
   * @return
   */
	protected RequestParameters buildRequestParameters(String suite, String tests, String format, boolean runTeardown, boolean runSuiteTeardown, boolean calculateCoverage) {
		RequestParameters params = new RequestParameters();
		params.add("func", "run");
		params.add("suite", suite);
		params.add("tests", tests);
		params.add("format", format);
		params.add("runsuiteteardown", String.valueOf(runSuiteTeardown));
		params.add("runteardown", String.valueOf(runTeardown));
		params.add("calculatecoverage", String.valueOf(calculateCoverage));
		return params;
	}

	public void setUnitTestXmlParser(ServiceResponseUnmarshaller unitTestXmlParser) {
		this.unitTestXmlParser = unitTestXmlParser;
	}
}
