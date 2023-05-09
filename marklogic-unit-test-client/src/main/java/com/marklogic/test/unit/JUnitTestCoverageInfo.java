package com.marklogic.test.unit;

public class JUnitTestCoverageInfo {
  private final String type;
  private final int count;
  private final String infoXml;

  public JUnitTestCoverageInfo(String type, int count, String infoXml) {
    this.type = type;
    this.count = count;
    this.infoXml = infoXml;
  }

  public String getType() {
    return type;
  }

  public int getCount() {
    return count;
  }

  public String getInfoXml() {
    return infoXml;
  }

  @Override
  public String toString() {
    return String.format("[%s: %d]", type, count);
  }
}
