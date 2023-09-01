package com.marklogic.test.unit;

import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.ArgumentsProvider;
import org.junit.jupiter.params.provider.ArgumentsSource;

import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.fail;

/**
 * Example of running each test module as a separate JUnit test. Not a lot of code to reuse here, because the
 * important stuff is in static blocks.
 */
public class SampleParameterizedTest implements ArgumentsProvider {

    private static TestManager testManager;

    @ParameterizedTest
    @ArgumentsSource(SampleParameterizedTest.class)
    public void test(TestModule testModule) {
        TestSuiteResult result = testManager.run(testModule);
        for (TestResult testResult : result.getTestResults()) {
            String failureXml = testResult.getFailureXml();
            if (failureXml != null) {
                fail(String.format("Test %s in suite %s failed, cause: %s", testResult.getName(), testModule.getSuite(), failureXml));
            }
        }
    }

    /**
     * This sets up the parameters for our test by getting a list of the test modules.
     * <p>
     * Also creates a DatabaseClient based on the values in gradle.properties. Typically, properties will be retrieved via
     * a more robust mechanism, like Spring's test framework support.
     *
     * @return
     * @throws Exception
     */
    @Override
    public Stream<? extends Arguments> provideArguments(ExtensionContext context) throws Exception {
        testManager = new TestManager(ClientUtil.getClient());
        return Stream.of(testManager.list().toArray(new TestModule[]{})).map(Arguments::of);
    }
}

