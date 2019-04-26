# Change Log

## [v1.0.0](https://github.com/marklogic-community/marklogic-unit-test/tree/v1.0.0) (2019-04-26)
[Full Changelog](https://github.com/marklogic-community/marklogic-unit-test/compare/v0.12.0...v1.0.0)

**Implemented enhancements:**

- Support Nested Test Suites [\#45](https://github.com/marklogic-community/marklogic-unit-test/issues/45)
- Add Failure Message to Assert Functions [\#51](https://github.com/marklogic-community/marklogic-unit-test/issues/51)
- Remove Roxy from Namespaces [\#52](https://github.com/marklogic-community/marklogic-unit-test/issues/52)
- Eliminate xdmp:eval\(\) [\#55](https://github.com/marklogic-community/marklogic-unit-test/issues/55)
- Allow substitutions during deployment [\#32](https://github.com/marklogic-community/marklogic-unit-test/issues/32)

**Merged pull requests:**

- Merged marklogic-junit library into marklogic-unit-test [\#66](https://github.com/marklogic-community/marklogic-unit-test/pull/66) ([rjrudin](https://github.com/rjrudin))
- Specify permissions and collections in test:load-test-file [\#59](https://github.com/marklogic-community/marklogic-unit-test/pull/59) ([cskeefer](https://github.com/cskeefer))
- Adding contributor information [\#50](https://github.com/marklogic-community/marklogic-unit-test/pull/50) ([jamesagardner](https://github.com/jamesagardner))
- Name change from ml-unit-test to marklogic-unit-test [\#43](https://github.com/marklogic-community/marklogic-unit-test/pull/43) ([dmcassel](https://github.com/dmcassel))

**Breaking Changes:**
- The namespaces were updated due to [\#52](https://github.com/marklogic-community/marklogic-unit-test/issues/52) follow these [instructions for upgrading](https://github.com/marklogic-community/marklogic-unit-test/issues/52#issuecomment-487184896).

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
