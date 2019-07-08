package org.example;

import com.marklogic.junit5.dhf.DataHubUnitTestsTest;

/**
 * This class is needed so that when running tests in an IDE / Maven / Gradle / etc, the test runner is able to find
 * a class that knows how to execute marklogic-unit-test tests. That knowledge is contained in the parent class
 * such that this subclass does not need to do anything beyond extending it. But this subclass must exist so that the
 * test runner can find it.
 */
public class RunDataHubUnitTestsTest extends DataHubUnitTestsTest {

}
