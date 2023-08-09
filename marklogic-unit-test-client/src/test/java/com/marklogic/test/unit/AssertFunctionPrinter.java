package com.marklogic.test.unit;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Not a test, just a simple tool for printing all the non-deprecated assertion functions found in test-helper.xqy.
 * The printed output is intended to be inserted into the ./docs/assertions/index.html file on the gh-pages branch.
 */
public class AssertFunctionPrinter {

    public static void main(String[] args) throws IOException {
        File file = new File("marklogic-unit-test-modules/src/main/ml-modules/root/test/test-helper.xqy");
        List<String> signatures = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line = reader.readLine();
            while (line != null) {
                if (line.contains("declare function test:assert-") && !line.contains("assert-meets")) {
                    signatures.add(line.replaceAll("declare function test:", "").replaceAll(" \\{", "").trim());
                }
                line = reader.readLine();
            }
        }

        Collections.sort(signatures);
        signatures.forEach(signature -> System.out.println("<li>" + signature + "</li>"));
    }
}
