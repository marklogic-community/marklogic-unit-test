package com.marklogic.test.unit;

import com.marklogic.client.DatabaseClient;
import com.marklogic.client.extensions.ResourceManager;
import com.marklogic.client.io.StringHandle;
import com.marklogic.client.io.marker.AbstractWriteHandle;
import com.marklogic.client.util.RequestParameters;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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
        RequestParameters params = new RunParameters()
            .withTestNames(testModule.getTest())
            .withFormat(FORMAT_NONE)
            .withRunSuiteTeardown(runSuiteTeardown)
            .withRunTeardown(runTeardown)
            .withCalculateCoverage(calculateCoverage)
            .toRequestParameters(testModule.getSuite());

        String xml = getServices().post(params, (AbstractWriteHandle) null, new StringHandle()).get();
        return unitTestXmlParser.parseTestSuiteResult(xml);
    }

    /**
     * @return a JUnitTestSuite for every suite found in the modules database
     */
    public List<JUnitTestSuite> runAllSuites() {
        return runAllSuites(new RunParameters());
    }

    /**
     * @param runTeardown
     * @param runSuiteTeardown
     * @param calculateCoverage
     * @return a JUnitTestSuite for every suite found in the modules database
     * @deprecated since 1.4.0; prefer using {@code RunParameters}
     */
    @Deprecated
    public List<JUnitTestSuite> runAllSuites(boolean runTeardown, boolean runSuiteTeardown, boolean calculateCoverage) {
        List<String> suiteNames = listSuites();
        List<JUnitTestSuite> suites = new ArrayList<>();
        for (String suiteName : suiteNames) {
            suites.add(runSuite(suiteName, runTeardown, runSuiteTeardown, calculateCoverage));
        }
        return suites;
    }

    /**
     * @param suite
     * @return a JUnitTestSuite capturing the results of running the given suite name
     */
    public JUnitTestSuite runSuite(String suite) {
        return runSuite(suite, new RunParameters());
    }

    /**
     * @param suite
     * @param runTeardown
     * @param runSuiteTeardown
     * @param calculateCoverage
     * @return
     * @deprecated since 1.4.0; prefer using {@code RunParameters}
     */
    @Deprecated
    public JUnitTestSuite runSuite(String suite, boolean runTeardown, boolean runSuiteTeardown, boolean calculateCoverage) {
        RequestParameters params = new RunParameters()
            .withFormat(FORMAT_JUNIT)
            .withRunSuiteTeardown(runSuiteTeardown)
            .withRunTeardown(runTeardown)
            .withCalculateCoverage(calculateCoverage)
            .toRequestParameters(suite);

        String xml = getServices().post(params, (AbstractWriteHandle) null, new StringHandle()).get();
        return unitTestXmlParser.parseJUnitTestSuiteResult(xml);
    }

    /**
     * Run a single suite with the given parameters.
     *
     * @param params
     * @return
     * @since 1.4.0
     */
    public JUnitTestSuite runSuite(String suiteName, RunParameters params) {
        String xml = getServices().post(params.toRequestParameters(suiteName), (AbstractWriteHandle) null, new StringHandle()).get();
        return unitTestXmlParser.parseJUnitTestSuiteResult(xml);
    }

    /**
     * Run all suites using the given parameters.
     *
     * @since 1.4.0
     */
    public List<JUnitTestSuite> runAllSuites(RunParameters params) {
        return this.listSuites().stream().map(suite -> runSuite(suite, params)).collect(Collectors.toList());
    }

    /**
     * Runs each suite identified by {@code suiteNames}, using the parameters in the given {@code RunParameters}
     * instance.
     *
     * @since 1.4.0
     */
    public List<JUnitTestSuite> runSuites(List<String> suiteNames, RunParameters params) {
        return suiteNames.stream().map(suiteName -> runSuite(suiteName, params)).collect(Collectors.toList());
    }

    public void setUnitTestXmlParser(ServiceResponseUnmarshaller unitTestXmlParser) {
        this.unitTestXmlParser = unitTestXmlParser;
    }

    /**
     * Simplifies constructing a set of request parameters to pass to the marklogic-unit-test REST extension.
     *
     * @since 1.4.0
     */
    public static class RunParameters {

        private String[] testNames;
        private boolean runSuiteTeardown = true;
        private boolean runTeardown = true;
        private boolean calculateCoverage = false;
        private String format = "junit";

        public RunParameters() {
        }

        public RunParameters(String... testNames) {
            this();
            withTestNames(testNames);
        }

        public RunParameters withTestNames(String... testNames) {
            this.testNames = testNames;
            return this;
        }

        public RunParameters withFormat(String format) {
            this.format = format;
            return this;
        }

        public RunParameters withRunSuiteTeardown(boolean runSuiteTeardown) {
            this.runSuiteTeardown = runSuiteTeardown;
            return this;
        }

        public RunParameters withRunTeardown(boolean runTeardown) {
            this.runTeardown = runTeardown;
            return this;
        }

        public RunParameters withCalculateCoverage(boolean calculateCoverage) {
            this.calculateCoverage = calculateCoverage;
            return this;
        }

        public RequestParameters toRequestParameters(String suiteName) {
            RequestParameters params = new RequestParameters();
            params.add("run", "func");
            if (suiteName != null) {
                params.add("suite", suiteName);
            }
            if (format != null) {
                params.add("format", format);
            }
            if (testNames != null) {
                params.add("tests", Stream.of(testNames).collect(Collectors.joining(",")));
            }
            params.add("runsuiteteardown", String.valueOf(runSuiteTeardown));
            params.add("runteardown", String.valueOf(runTeardown));
            params.add("calculatecoverage", String.valueOf(calculateCoverage));
            return params;
        }
    }
}
