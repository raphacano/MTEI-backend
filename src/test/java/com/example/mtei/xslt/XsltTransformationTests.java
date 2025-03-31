package com.example.mtei.xslt;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.TestFactory;
import org.junit.jupiter.api.Assertions;
import org.springframework.boot.test.context.SpringBootTest; // Optional, but ensures Spring context if needed later
import org.xmlunit.matchers.CompareMatcher;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.junit.jupiter.api.DynamicTest.dynamicTest;

//@SpringBootTest // Keep if you need Spring context features, otherwise optional for this specific test
public class XsltTransformationTests {

    // Base directory for transforms relative to project root
    private static final Path TRANSFORMS_BASE_DIR = Paths.get("src", "main", "resources", "transforms_formato_intermadio");
    private static final String SOURCE_PREFIX = "source_";
    private static final String TARGET_PREFIX = "target_";
    private static final String XSLT_FILENAME = "main.xslt";

    // Helper class or record to hold test case data
    private record TransformTestCase(Path sourceXmlPath, Path xsltPath, Path targetXmlPath) {}

    @TestFactory
    @DisplayName("XSLT Transformation Tests")
    Stream<DynamicTest> generateXsltTests() throws IOException {
        List<TransformTestCase> testCases = findTestCases();

        if (testCases.isEmpty()) {
            System.err.println("WARNING: No XSLT test cases found in " + TRANSFORMS_BASE_DIR.toAbsolutePath());
            // Return a single dummy test to avoid JUnit errors with empty streams
             return Stream.of(dynamicTest("No test cases found", () -> Assertions.assertTrue(true, "No test cases detected.")));
        }

        // Create a DynamicTest for each found test case
        return testCases.stream()
                .map(testCase -> dynamicTest(
                        // Dynamic test name: e.g., "Transform source_example.xml using transforms/scenario1/main.xslt"
                        "Transform " + testCase.sourceXmlPath().getFileName() + " using " +
                                TRANSFORMS_BASE_DIR.relativize(testCase.xsltPath()),
                        () -> executeAndCompareTransform(testCase) // The test execution logic
                ));
    }

    /**
     * Finds all valid transformation test cases (source_*.xml, parent/main.xslt, target_*.xml).
     */
    private List<TransformTestCase> findTestCases() throws IOException {
        List<TransformTestCase> cases = new ArrayList<>();
        if (!Files.isDirectory(TRANSFORMS_BASE_DIR)) {
            System.err.println("ERROR: Transforms base directory not found: " + TRANSFORMS_BASE_DIR.toAbsolutePath());
            return cases; // Return empty list
        }

        try (Stream<Path> paths = Files.walk(TRANSFORMS_BASE_DIR)) {
            paths
                .filter(Files::isRegularFile)
                .filter(path -> path.getFileName().toString().startsWith(SOURCE_PREFIX) && path.getFileName().toString().endsWith(".xml"))
                .forEach(sourcePath -> {
                    Path parentDir = sourcePath.getParent();
                    if (parentDir == null) return; // Should not happen in walk

                    Path xsltPath = parentDir.resolve(XSLT_FILENAME);

                    String sourceFileName = sourcePath.getFileName().toString();
                    String targetFileName = sourceFileName.replaceFirst("^" + SOURCE_PREFIX, TARGET_PREFIX);
                    Path targetPath = parentDir.resolve(targetFileName);

                    // Check if all required files exist for this source file
                    if (Files.exists(xsltPath) && Files.exists(targetPath)) {
                        cases.add(new TransformTestCase(sourcePath, xsltPath, targetPath));
                        System.out.println("Found test case: " + sourcePath.getFileName());
                    } else {
                        if (!Files.exists(xsltPath)) {
                             System.err.println("WARNING: Missing " + XSLT_FILENAME + " for source " + sourcePath.toAbsolutePath());
                        }
                         if (!Files.exists(targetPath)) {
                             System.err.println("WARNING: Missing target file " + targetFileName + " for source " + sourcePath.toAbsolutePath());
                         }
                    }
                });
        }
        return cases;
    }

    /**
     * Executes the XSLT transformation and compares the result with the target XML.
     */
    private void executeAndCompareTransform(TransformTestCase testCase) {
        try {
            System.out.println("Executing test for: " + testCase.sourceXmlPath().getFileName());

            // 1. Perform Transformation
            String actualXml = transformXml(testCase.sourceXmlPath(), testCase.xsltPath());

            // 2. Read Expected Target XML
            String expectedXml = Files.readString(testCase.targetXmlPath(), StandardCharsets.UTF_8);

            // 3. Compare using XMLUnit
            // isSimilarTo ignores whitespace, comments, and attribute order by default
            assertThat("XML comparison failed for " + testCase.sourceXmlPath().getFileName(),
                    actualXml,
                    CompareMatcher.isSimilarTo(expectedXml)
                                  .ignoreWhitespace() // Be explicit about ignoring whitespace
                                  .ignoreComments()); // Be explicit about ignoring comments

            System.out.println("SUCCESS: " + testCase.sourceXmlPath().getFileName());

        } catch (IOException e) {
            Assertions.fail("IOException during test execution for " + testCase.sourceXmlPath().getFileName() + ": " + e.getMessage(), e);
        } catch (TransformerException e) {
            Assertions.fail("TransformerException during transformation for " + testCase.sourceXmlPath().getFileName() + ": " + e.getMessage(), e);
        } catch (Exception e) {
            Assertions.fail("Unexpected exception during test for " + testCase.sourceXmlPath().getFileName() + ": " + e.getMessage(), e);
        }
    }

    /**
     * Helper method to perform XSLT transformation.
     * @param sourceXmlPath Path to the source XML file.
     * @param xsltPath Path to the XSLT file.
     * @return The transformed XML as a String.
     * @throws IOException If file reading fails.
     * @throws TransformerException If XSLT transformation fails.
     */
    private String transformXml(Path sourceXmlPath, Path xsltPath) throws IOException, TransformerException {
        TransformerFactory factory = TransformerFactory.newInstance();
         // Mitigate potential XML External Entity (XXE) attacks
         try {
              factory.setFeature(javax.xml.XMLConstants.FEATURE_SECURE_PROCESSING, true);
              factory.setAttribute(javax.xml.XMLConstants.ACCESS_EXTERNAL_DTD, "");
              factory.setAttribute(javax.xml.XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
         } catch (TransformerConfigurationException e) {
              System.err.println("Warning: Could not set secure processing features on TransformerFactory: " + e.getMessage());
              // Decide if you want to fail here or just log the warning
         }


        try (InputStream xmlInputStream = Files.newInputStream(sourceXmlPath);
             InputStream xsltInputStream = Files.newInputStream(xsltPath)) {

            Source xsltSource = new StreamSource(xsltInputStream);
            Transformer transformer = factory.newTransformer(xsltSource);

            Source xmlSource = new StreamSource(xmlInputStream);
            StringWriter writer = new StringWriter();
            Result result = new StreamResult(writer);

            transformer.transform(xmlSource, result);

            return writer.toString();
        }
    }
}