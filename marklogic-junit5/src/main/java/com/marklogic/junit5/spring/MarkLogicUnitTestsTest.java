package com.marklogic.junit5.spring;

import com.marklogic.junit5.MarkLogicUnitTestArgumentsProvider;
import com.marklogic.test.unit.TestModule;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ArgumentsSource;

/**
 * This is a JUnit 5 parameterized test that invokes every test module defined by the REST endpoint provided by the
 * marklogic-unit-test framework - https://github.com/marklogic-community/marklogic-unit-test . This class is abstract
 * so that it is not run when executing tests for the marklogic-junit5 project - it is instead expected to be extended
 * in a project that depends on marklogic-junit5.
 * <p>
 * To make use of this in your own project, simply create a class that extends this in your src/test/java directory (
 * or whatever you store the source of test classes) so that it'll be executed by your IDE / Maven / Gradle / etc.
 * Nothing further needs to be added to the class, it just needs to extend this class.
 */
public abstract class MarkLogicUnitTestsTest extends AbstractSpringMarkLogicTest {

	@ParameterizedTest
	@ArgumentsSource(MarkLogicUnitTestArgumentsProvider.class)
	public void test(TestModule testModule) {
		runMarkLogicUnitTests(testModule);
	}

}
