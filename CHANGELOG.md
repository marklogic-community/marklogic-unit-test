# Change Log

## [1.0.0](https://github.com/marklogic-community/marklogic-unit-test/tree/1.0.0) (2019-09-13)
[Full Changelog](https://github.com/marklogic-community/marklogic-unit-test/compare/1.0.beta...1.0.0)

**Implemented enhancements:**

- assert-equal-json no longer reports the location of comparison differences [\#37](https://github.com/marklogic-community/marklogic-unit-test/issues/37)
- Add documentation for developing and testing ml-unit-test locally [\#29](https://github.com/marklogic-community/marklogic-unit-test/issues/29)
- Support Testing of the MarkLogic Data Hub Framework \(DHF\) [\#26](https://github.com/marklogic-community/marklogic-unit-test/issues/26)
- Support testing of REST services [\#25](https://github.com/marklogic-community/marklogic-unit-test/issues/25)
- Setup real JUnit tests for marklogic-unit-test-modules [\#11](https://github.com/marklogic-community/marklogic-unit-test/issues/11)

**Fixed bugs:**

- Unable to use suite name in test name [\#79](https://github.com/marklogic-community/marklogic-unit-test/issues/79)
- JSON equals is inconsistent in comparisons [\#44](https://github.com/marklogic-community/marklogic-unit-test/issues/44)

**Closed issues:**

- ML10 gradle project has error with unit test [\#86](https://github.com/marklogic-community/marklogic-unit-test/issues/86)
- Updating docs to reflect renamed dependency [\#80](https://github.com/marklogic-community/marklogic-unit-test/issues/80)
- How to test DHF project that uses multiple databases [\#74](https://github.com/marklogic-community/marklogic-unit-test/issues/74)
- Document how to include marklogic-unit-test and set up for a Data Hub [\#36](https://github.com/marklogic-community/marklogic-unit-test/issues/36)

**Merged pull requests:**

- Removing Roxy reference [\#103](https://github.com/marklogic-community/marklogic-unit-test/pull/103) ([jamesagardner](https://github.com/jamesagardner))
- Updating MarkLogic Copyrights to 2019 [\#102](https://github.com/marklogic-community/marklogic-unit-test/pull/102) ([jamesagardner](https://github.com/jamesagardner))
- Updating 1.0.beta references to 1.0.0 [\#101](https://github.com/marklogic-community/marklogic-unit-test/pull/101) ([jamesagardner](https://github.com/jamesagardner))
- Abstract mark logic test logger [\#99](https://github.com/marklogic-community/marklogic-unit-test/pull/99) ([hansenmc](https://github.com/hansenmc))
- JaxpServiceResponseUnmarshaller.parse\(\) relies upon default character encoding [\#98](https://github.com/marklogic-community/marklogic-unit-test/pull/98) ([hansenmc](https://github.com/hansenmc))
- Update XmlNode.java to use the diamond operator \<\> [\#97](https://github.com/marklogic-community/marklogic-unit-test/pull/97) ([hansenmc](https://github.com/hansenmc))
- change hard-coded namespace-prefix test from name\(\) to use self axis [\#96](https://github.com/marklogic-community/marklogic-unit-test/pull/96) ([hansenmc](https://github.com/hansenmc))
- apply $params in xdmp:xslt-invoke\(\) for coverage report format transform [\#95](https://github.com/marklogic-community/marklogic-unit-test/pull/95) ([hansenmc](https://github.com/hansenmc))
- Update CONTRIBUTING.md [\#94](https://github.com/marklogic-community/marklogic-unit-test/pull/94) ([hansenmc](https://github.com/hansenmc))
- fix AbstractMarkLogicTest.java javadocs [\#93](https://github.com/marklogic-community/marklogic-unit-test/pull/93) ([hansenmc](https://github.com/hansenmc))
- Fixing Travis CI error [\#90](https://github.com/marklogic-community/marklogic-unit-test/pull/90) ([jamesagardner](https://github.com/jamesagardner))
- Fixing Issue \#44: assert-equal-json inconsistent in comparisons [\#85](https://github.com/marklogic-community/marklogic-unit-test/pull/85) ([cskeefer](https://github.com/cskeefer))
- \#79 Updating assertion to be more specific [\#84](https://github.com/marklogic-community/marklogic-unit-test/pull/84) ([jamesagardner](https://github.com/jamesagardner))
- \#79 Fixing module not found error when test module contains the test suite name [\#83](https://github.com/marklogic-community/marklogic-unit-test/pull/83) ([jamesagardner](https://github.com/jamesagardner))
- Renaming marklogic-junit to marklogic-junit5 [\#78](https://github.com/marklogic-community/marklogic-unit-test/pull/78) ([rjrudin](https://github.com/rjrudin))
- Improving the project landing page [\#73](https://github.com/marklogic-community/marklogic-unit-test/pull/73) ([jamesagardner](https://github.com/jamesagardner))
- bintray config fixes [\#70](https://github.com/marklogic-community/marklogic-unit-test/pull/70) ([rjrudin](https://github.com/rjrudin))
- \#46 Change test failure stack output from encoded XML to a nested text format [\#61](https://github.com/marklogic-community/marklogic-unit-test/pull/61) ([jonesyface](https://github.com/jonesyface))

## [1.0.beta](https://github.com/marklogic-community/marklogic-unit-test/tree/1.0.beta) (2019-04-26)
[Full Changelog](https://github.com/marklogic-community/marklogic-unit-test/compare/v0.12.0...1.0.beta)

**Implemented enhancements:**

- Document Unit Testing Data Hub Framework \(DHF\) Flow [\#65](https://github.com/marklogic-community/marklogic-unit-test/issues/65)
- Eliminate xdmp:eval\(\) [\#55](https://github.com/marklogic-community/marklogic-unit-test/issues/55)
- Remove Roxy from Namespaces [\#52](https://github.com/marklogic-community/marklogic-unit-test/issues/52)
- Add Failure Message to Assert Functions [\#51](https://github.com/marklogic-community/marklogic-unit-test/issues/51)
- Support Nested Test Suites [\#45](https://github.com/marklogic-community/marklogic-unit-test/issues/45)
- Allow substitutions during deployment [\#32](https://github.com/marklogic-community/marklogic-unit-test/issues/32)
- Was not able to use the ml-unit-test framework [\#21](https://github.com/marklogic-community/marklogic-unit-test/issues/21)
- \#45 Nested test suite support [\#54](https://github.com/marklogic-community/marklogic-unit-test/pull/54) ([jamesagardner](https://github.com/jamesagardner))

**Closed issues:**

- Difficult to run a unit test in qconsole [\#62](https://github.com/marklogic-community/marklogic-unit-test/issues/62)
- Create Node client for REST endpoint [\#17](https://github.com/marklogic-community/marklogic-unit-test/issues/17)
- Rename ml-unit-test-client? [\#16](https://github.com/marklogic-community/marklogic-unit-test/issues/16)

**Merged pull requests:**

- 1.0.0 Release [\#69](https://github.com/marklogic-community/marklogic-unit-test/pull/69) ([jamesagardner](https://github.com/jamesagardner))
- Updating Namespace \#52 [\#68](https://github.com/marklogic-community/marklogic-unit-test/pull/68) ([jamesagardner](https://github.com/jamesagardner))
- Merged marklogic-junit library into marklogic-unit-test [\#66](https://github.com/marklogic-community/marklogic-unit-test/pull/66) ([rjrudin](https://github.com/rjrudin))
- Issue \#55: Converted xdmp:eval to xdmp:invoke-function [\#60](https://github.com/marklogic-community/marklogic-unit-test/pull/60) ([cskeefer](https://github.com/cskeefer))
- Specify permissions and collections in test:load-test-file [\#59](https://github.com/marklogic-community/marklogic-unit-test/pull/59) ([cskeefer](https://github.com/cskeefer))
- \#52 Removing Roxy from Namespaces [\#56](https://github.com/marklogic-community/marklogic-unit-test/pull/56) ([jamesagardner](https://github.com/jamesagardner))
- Adding contributor information [\#50](https://github.com/marklogic-community/marklogic-unit-test/pull/50) ([jamesagardner](https://github.com/jamesagardner))
- Updating formatting [\#49](https://github.com/marklogic-community/marklogic-unit-test/pull/49) ([jamesagardner](https://github.com/jamesagardner))
- Docs name change [\#43](https://github.com/marklogic-community/marklogic-unit-test/pull/43) ([dmcassel](https://github.com/dmcassel))

## [v0.12.0](https://github.com/marklogic-community/marklogic-unit-test/tree/v0.12.0) (2018-09-20)
[Full Changelog](https://github.com/marklogic-community/marklogic-unit-test/compare/0.11.2...v0.12.0)

**Merged pull requests:**

- Release v0.12.0 [\#42](https://github.com/marklogic-community/marklogic-unit-test/pull/42) ([dmcassel](https://github.com/dmcassel))
- Release [\#41](https://github.com/marklogic-community/marklogic-unit-test/pull/41) ([dmcassel](https://github.com/dmcassel))
- Change to marklogic [\#40](https://github.com/marklogic-community/marklogic-unit-test/pull/40) ([dmcassel](https://github.com/dmcassel))

## [0.11.2](https://github.com/marklogic-community/marklogic-unit-test/tree/0.11.2) (2018-09-20)
[Full Changelog](https://github.com/marklogic-community/marklogic-unit-test/compare/0.11.1...0.11.2)

**Implemented enhancements:**

- assert-equal-json doesn't accept arrays [\#28](https://github.com/marklogic-community/marklogic-unit-test/issues/28)

**Fixed bugs:**

- failures in suite-setup.xqy are not reported [\#13](https://github.com/marklogic-community/marklogic-unit-test/issues/13)

**Closed issues:**

- Unit testing with ml-data-hub:2.0.4 [\#34](https://github.com/marklogic-community/marklogic-unit-test/issues/34)
- Set up github pages for docs [\#24](https://github.com/marklogic-community/marklogic-unit-test/issues/24)
- assertEqual cannot compare JS/JSON arrays [\#23](https://github.com/marklogic-community/marklogic-unit-test/issues/23)
- Add CONTRIBUTING.md [\#12](https://github.com/marklogic-community/marklogic-unit-test/issues/12)
- Add .editorconfig to help with consistent formatting [\#5](https://github.com/marklogic-community/marklogic-unit-test/issues/5)

**Merged pull requests:**

- Expand support for http helpers for REST tests [\#39](https://github.com/marklogic-community/marklogic-unit-test/pull/39) ([ryanjdew](https://github.com/ryanjdew))
- better error reporting; added helpers [\#35](https://github.com/marklogic-community/marklogic-unit-test/pull/35) ([dmcassel](https://github.com/dmcassel))
- Issue 13: Report suite-setup.xqy failures [\#33](https://github.com/marklogic-community/marklogic-unit-test/pull/33) ([jonesyface](https://github.com/jonesyface))
- Issue 28 [\#31](https://github.com/marklogic-community/marklogic-unit-test/pull/31) ([dmcassel](https://github.com/dmcassel))
- adding new files [\#30](https://github.com/marklogic-community/marklogic-unit-test/pull/30) ([dmcassel](https://github.com/dmcassel))
- Adding travis support [\#27](https://github.com/marklogic-community/marklogic-unit-test/pull/27) ([paxtonhare](https://github.com/paxtonhare))

## [0.11.1](https://github.com/marklogic-community/marklogic-unit-test/tree/0.11.1) (2018-06-05)
[Full Changelog](https://github.com/marklogic-community/marklogic-unit-test/compare/0.11...0.11.1)

**Fixed bugs:**

- assert-equal-json should ignore key order [\#19](https://github.com/marklogic-community/marklogic-unit-test/issues/19)

**Closed issues:**

- Configure code coverage via REST endpoint [\#15](https://github.com/marklogic-community/marklogic-unit-test/issues/15)

**Merged pull requests:**

- fixing \#19 [\#22](https://github.com/marklogic-community/marklogic-unit-test/pull/22) ([paxtonhare](https://github.com/paxtonhare))
- adding param to enable codeCoverage via ml-unit-test.xqy endpoint and… [\#20](https://github.com/marklogic-community/marklogic-unit-test/pull/20) ([hansenmc](https://github.com/hansenmc))
- run setup/teardown with coverage and ensure all executed lines included in wanted lines [\#18](https://github.com/marklogic-community/marklogic-unit-test/pull/18) ([hansenmc](https://github.com/hansenmc))

## [0.11](https://github.com/marklogic-community/marklogic-unit-test/tree/0.11) (2018-05-22)
[Full Changelog](https://github.com/marklogic-community/marklogic-unit-test/compare/0.10.0...0.11)

**Closed issues:**

- Use ml-unit-test without depending on rjrudin bintray repository [\#9](https://github.com/marklogic-community/marklogic-unit-test/issues/9)

**Merged pull requests:**

- updating notice per legal [\#8](https://github.com/marklogic-community/marklogic-unit-test/pull/8) ([dmcassel](https://github.com/dmcassel))
- code coverage [\#4](https://github.com/marklogic-community/marklogic-unit-test/pull/4) ([hansenmc](https://github.com/hansenmc))
- Added functionality to output alternative report formats via user-defined XSLT [\#1](https://github.com/marklogic-community/marklogic-unit-test/pull/1) ([jonesyface](https://github.com/jonesyface))

## [0.10.0](https://github.com/marklogic-community/marklogic-unit-test/tree/0.10.0) (2018-05-02)
[Full Changelog](https://github.com/marklogic-community/marklogic-unit-test/compare/0.9.1...0.10.0)

**Closed issues:**

- TestManager does not run teardown or suiteTeardown [\#2](https://github.com/marklogic-community/marklogic-unit-test/issues/2)

**Merged pull requests:**

- run teardown by default [\#3](https://github.com/marklogic-community/marklogic-unit-test/pull/3) ([dmcassel](https://github.com/dmcassel))
- Teardown scripts are now invoked by default as part of a single test [\#7](https://github.com/marklogic-community/marklogic-unit-test/pull/7) ([rjrudin](https://github.com/rjrudin))
- Develop [\#6](https://github.com/marklogic-community/marklogic-unit-test/pull/6) ([dmcassel](https://github.com/dmcassel))

## [0.9.1](https://github.com/marklogic-community/marklogic-unit-test/tree/0.9.1) (2018-02-22)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*