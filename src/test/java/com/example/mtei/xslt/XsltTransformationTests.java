package com.example.mtei.xslt;

import static org.junit.jupiter.api.DynamicTest.dynamicTest;

import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

import javax.xml.transform.TransformerException; // Keep this import

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll; // Import BeforeAll
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.TestFactory;
import org.junit.jupiter.api.TestInstance;

// Remove unused XMLUnit imports if XmlComparator handles them
// import org.xmlunit.builder.DiffBuilder;
// ... other XMLUnit imports ...

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class XsltTransformationTests {

    // Base directory for transforms relative to project root
    private static final Path TRANSFORMS_BASE_DIR = Paths.get("src", "main", "resources", "transforms_formato_intermedio");
    private static final String SOURCE_PREFIX = "source_"; // Needed for temp file naming
    private static final String TEMP_PREFIX = "temp_";     // Needed for temp file naming

    // Constantes para el formato de salida (pueden moverse a una clase de utilidades)
    private static final String ANSI_RESET = "\u001B[0m";
    private static final String ANSI_GREEN = "\u001B[32m";
    // private static final String ANSI_YELLOW = "\u001B[33m"; // Moved to XmlComparator
    private static final String ANSI_RED = "\u001B[31m";
    private static final String ANSI_BOLD = "\u001B[1m";

    // Test result tracking
    private final List<String> successfulTests = new ArrayList<>();
    private final List<String> failedTests = new ArrayList<>();

    // Helper classes instances
    private TestCaseFinder testCaseFinder;
    private XmlTransformer xmlTransformer;
    private XmlComparator xmlComparator;

    // Initialize helper classes once for all tests
    @BeforeAll
    void setup() {
        testCaseFinder = new TestCaseFinder(TRANSFORMS_BASE_DIR);
        xmlTransformer = new XmlTransformer();
        xmlComparator = new XmlComparator();
    }

    // Record definition can be moved to TestCaseFinder or a common place
    // private record TransformTestCase(Path sourceXmlPath, Path xsltPath, Path targetXmlPath) {}

    @TestFactory
    @DisplayName("XSLT Transformation Tests")
    Stream<DynamicTest> generateXsltTests() throws IOException {
        // Use TestCaseFinder
        List<TransformTestCase> testCases = testCaseFinder.findTestCases();

        if (testCases.isEmpty()) {
            System.err.println("WARNING: No XSLT test cases found in " + TRANSFORMS_BASE_DIR.toAbsolutePath());
            return Stream.of(dynamicTest("No test cases found", () -> Assertions.assertTrue(true, "No test cases detected.")));
        }

        // Create a DynamicTest for each found test case
        return testCases.stream()
                .map(testCase -> dynamicTest(
                        // Dynamic test name remains the same
                        "Transform " + testCase.sourceXmlPath().getFileName() + " using " +
                                TRANSFORMS_BASE_DIR.relativize(testCase.xsltPath()),
                        () -> executeAndCompareTransform(testCase) // The test execution logic
                ));
    }

    /**
     * Executes the XSLT transformation and compares the result using helper classes.
     */
    private void executeAndCompareTransform(TransformTestCase testCase) {
        String testName = testCase.sourceXmlPath().getFileName().toString();

        try {
            System.out.println("\n" + ANSI_BOLD + "Executing test for: " + testName + ANSI_RESET);

            // 1. Perform Transformation using XmlTransformer
            String actualXml = xmlTransformer.transform(testCase.sourceXmlPath(), testCase.xsltPath());

            // 2. Save temporary output file (optional, could be removed if not needed)
            saveTemporaryOutput(actualXml, testCase.sourceXmlPath());
            System.out.println("Temporary XML output saved."); // Update message if needed

            // 3. Read Expected Target XML
            String expectedXml = Files.readString(testCase.targetXmlPath(), StandardCharsets.UTF_8);

            // 4. Compare using XmlComparator
            try {
                xmlComparator.compareIgnoringAttributes(testName, actualXml, expectedXml);
                // If comparison passes without assertion error
                successfulTests.add(testName);
            } catch (AssertionError e) {
                // Comparison failed
                failedTests.add(testName);
                throw e; // Re-throw to mark the dynamic test as failed
            }

        } catch (IOException e) {
            failedTests.add(testName);
            Assertions.fail("IOException during test execution for " + testName + ": " + e.getMessage(), e);
        } catch (TransformerException e) {
            failedTests.add(testName);
            Assertions.fail("TransformerException during transformation for " + testName + ": " + e.getMessage(), e);
        } catch (Exception e) { // Catch broader exceptions if necessary
            failedTests.add(testName);
            Assertions.fail("Unexpected exception during test for " + testName + ": " + e.getMessage(), e);
        }
    }

    /**
     * Saves the generated XML to a temporary file.
     */
    private void saveTemporaryOutput(String xml, Path sourcePath) throws IOException {
         Path parentDir = sourcePath.getParent();
         if (parentDir == null) {
             // Handle case where source path might not have a parent (e.g., root directory)
             // Choose a default temp location or throw an error
             parentDir = Paths.get("."); // Or some other sensible default/error handling
             System.err.println("Warning: Could not determine parent directory for temp file. Using current directory.");
         }
         String sourceFileName = sourcePath.getFileName().toString();
         String tempFileName = sourceFileName.replaceFirst("^" + SOURCE_PREFIX, TEMP_PREFIX);
         Path tempFilePath = parentDir.resolve(tempFileName);

         try (FileWriter writer = new FileWriter(tempFilePath.toFile())) {
             writer.write(xml);
         }
         System.out.println("XML generado guardado en: " + tempFilePath.toAbsolutePath()); // Log absolute path
    }

    @AfterAll
    public void displayTestSummary() {
        // This method remains largely the same, reporting results
        System.out.println("\n" + ANSI_BOLD + "===== TEST SUMMARY =====" + ANSI_RESET);
        System.out.println(ANSI_GREEN + "✓ Successful tests: " + successfulTests.size() + ANSI_RESET);
        System.out.println(ANSI_RED + "✗ Failed tests: " + failedTests.size() + ANSI_RESET);

        if (!failedTests.isEmpty()) {
            System.out.println("\n" + ANSI_RED + ANSI_BOLD + "Failed tests (Source XML files):" + ANSI_RESET);
            for (String failedTest : failedTests) {
                System.out.println(ANSI_RED + " - " + failedTest + ANSI_RESET);
            }
        }

        System.out.println(ANSI_BOLD + "======================" + ANSI_RESET);
    }
}
