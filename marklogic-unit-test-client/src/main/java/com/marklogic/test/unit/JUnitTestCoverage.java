package com.marklogic.test.unit;

import java.util.ArrayList;
import java.util.List;

public class JUnitTestCoverage {
  private final String module;

  private List<JUnitTestCoverageInfo> coverageInfo;

  public JUnitTestCoverage(String module) {
    this.module = module;
  }

  public String getModule() {
    return module;
  }

  public void addCoverageInfo(JUnitTestCoverageInfo coverageInfo) {
    if (this.coverageInfo == null) {
      this.coverageInfo = new ArrayList<>();
    }
    this.coverageInfo.add(coverageInfo);
  }

  public List<JUnitTestCoverageInfo> getCoverageInfo() {
    return coverageInfo;
  }

  @Override
  public String toString() {
    return String.format("[module: %s, coverageInfo: %s]", module, coverageInfo);
  }
}
