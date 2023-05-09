package com.marklogic.test.unit;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Default implementation that is fairly similar to how the Gradle "test" task reports errors.
 */
public class DefaultJUnitTestReporter implements JUnitTestReporter {

	@Override
	public String reportOnJUnitTestSuites(List<JUnitTestSuite> suites) {
		StringBuilder sb = new StringBuilder();

		int testsCompleted = 0;
		int testFailed = 0;
    sb.append("\n\nTest Results:");
		for (JUnitTestSuite suite : suites) {
			if (suite.getTestCases() == null) {
				continue;
			}
			for (JUnitTestCase testCase : suite.getTestCases()) {
				testsCompleted++;
				if (testCase.hasTestFailures()) {
					testFailed++;
					sb.append("\n\n").append(testCase.getClassname()).
            append(" > ").append(testCase.getName()).
            append(" FAILED");
					for (JUnitTestFailure failure : testCase.getTestFailures()) {
						sb.append("\n    ").append(failure.getMessage());
					}
				}
			}
		}
		sb.append("\n\n").append(testsCompleted).
      append(" tests completed, ").append(testFailed).
      append(" failed");
		return sb.toString();
	}

  public String reportOnJUnitTestSuitesCoverage(List<JUnitTestSuite> suites) {
    StringBuilder sb = new StringBuilder();

    int testsCovered = 0;
    Map<String, Map<String, Integer>> modulesAnalyzed = new HashMap<>();
    sb.append("\n\nCoverage Results:");
    sb.append("\n\nCoverage Per Test");
    for (JUnitTestSuite suite : suites) {
      if (suite.getTestCases() == null) {
        continue;
      }
      for (JUnitTestCase testCase : suite.getTestCases()) {
        testsCovered++;
        if (testCase.hasTestCoverages()) {
          sb.append("\n\n").append(testCase.getClassname()).
            append(" > ").append(testCase.getName()).
            append(" COVERED");
          for (JUnitTestCoverage coverage : testCase.getTestCoverages()) {
            String module = coverage.getModule();
            List<JUnitTestCoverageInfo> coverInfo = coverage.getCoverageInfo();
            if (modulesAnalyzed.containsKey(module)) {
              Map<String,Integer> analyzed = modulesAnalyzed.get(module);
              Integer wantedCount = coverInfo.get(0).getCount();
              Integer coveredCount = coverInfo.get(1).getCount();
              if (analyzed.get("wanted") < wantedCount) {
                analyzed.put("wanted", wantedCount);
              }
              if (analyzed.get("covered") < coveredCount) {
                analyzed.put("covered", coveredCount);
              }
              analyzed.put("missing", analyzed.get("wanted") - analyzed.get("covered"));
            } else {
              Map<String,Integer> analyzed = new HashMap<>();
              for (JUnitTestCoverageInfo jUnitTestCoverageInfo : coverInfo) {
                analyzed.put(jUnitTestCoverageInfo.getType(), jUnitTestCoverageInfo.getCount());
              }
              modulesAnalyzed.put(module, analyzed);
            }
            sb.append("\n    ").append(coverage);
          }
        }
      }
    }
    sb.append("\n\n").append(testsCovered).
      append(" tests covered").append("\n\nCoverage Across All Tests:\n");
    modulesAnalyzed.forEach(
      (key,value) -> sb.append("\t[module: ").
        append(key).append(", coverageInfo: ").
        append(value).append("]\n")
    );
    return sb.toString();
  }
}
