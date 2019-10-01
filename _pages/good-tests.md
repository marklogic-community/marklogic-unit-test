---
layout: inner
title: Writing Good Tests
lead_text: ''
permalink: /good-tests/
---

# Writing Good Tests

## Purpose of Tests
- To demostrate that a feature works
- To prevent regression failures
- To detect software failures
- To help in refactoring, upgrades and maintenace releases

## Scope of a Test Suite
- Focused on a single library module, or more narrow
- Focused on a single entity
- Focused on a particular package

## Scope of a Test Case
- Focused on a particular function in a library module; you may have multiple cases for the same function
- Focused on a particular function for a given entity; you may have multiple cases for the same function
- Focused on a particular function with in a package; you may have multiple cases for the same function

## Comments in a Test Case
- Start with a top-level comment for each test case that explains why it's there
- Use descriptive arguments that are self documenting
- Assert expected result with descriptive messages

## Using Application Code to Verify Application Code
*TODO*
(test calls an app function; should you use another app function as part of verifying that it worked?)
