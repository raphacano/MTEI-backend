package com.example.mtei.xslt;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.TestFactory;
import org.junit.jupiter.api.Assertions;
import org.springframework.boot.test.context.SpringBootTest; // Optional, but ensures Spring context if needed later
import org.xmlunit.matchers.CompareMatcher;

// Importaciones específicas para transformación XML
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.XMLConstants;

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
    private static final String TRANSFORM_PREFIX = "transform_";
    private static final String DM_PREFIX = "DM_";
    
    // Nombre de la implementación de Saxon para XSLT 2.0
    private static final String SAXON_TRANSFORMER_FACTORY = "net.sf.saxon.TransformerFactoryImpl";

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
     * Finds all valid transformation test cases based on the specified structure:
     * 1. First level folders starting with "transform_"
     * 2. Second level folders starting with "DM_" containing main.xslt
     * 3. Source XML files in deeper levels starting with "source_"
     * 4. Target XML files in the same directory as source files starting with "target_"
     */
    private List<TransformTestCase> findTestCases() throws IOException {
        List<TransformTestCase> cases = new ArrayList<>();
        if (!Files.isDirectory(TRANSFORMS_BASE_DIR)) {
            System.err.println("ERROR: Transforms base directory not found: " + TRANSFORMS_BASE_DIR.toAbsolutePath());
            return cases; // Return empty list
        }

        // 1. Find all transform_ directories (first level)
        try (Stream<Path> transformDirs = Files.list(TRANSFORMS_BASE_DIR)
                .filter(Files::isDirectory)
                .filter(path -> path.getFileName().toString().startsWith(TRANSFORM_PREFIX))) {
            
            transformDirs.forEach(transformDir -> {
                // 2. Find all DM_ directories (second level) that contain main.xslt
                try (Stream<Path> dmDirs = Files.list(transformDir)
                        .filter(Files::isDirectory)
                        .filter(path -> path.getFileName().toString().startsWith(DM_PREFIX))) {
                    
                    dmDirs.forEach(dmDir -> {
                        Path xsltPath = dmDir.resolve(XSLT_FILENAME);
                        
                        // Only process directories that have a main.xslt file
                        if (Files.exists(xsltPath)) {
                            // 3. Find all source XML files in this DM directory and its subdirectories
                            try (Stream<Path> sourceFiles = Files.walk(dmDir)
                                    .filter(Files::isRegularFile)
                                    .filter(path -> path.getFileName().toString().startsWith(SOURCE_PREFIX) 
                                            && path.getFileName().toString().toUpperCase().endsWith(".XML"))) {
                                
                                sourceFiles.forEach(sourcePath -> {
                                    Path parentDir = sourcePath.getParent();
                                    if (parentDir == null) return; // Should not happen in walk
                                    
                                    String sourceFileName = sourcePath.getFileName().toString();
                                    String targetFileName = sourceFileName.replaceFirst("^" + SOURCE_PREFIX, TARGET_PREFIX);
                                    Path targetPath = parentDir.resolve(targetFileName);
                                    
                                    // Check if target file exists for this source file
                                    if (Files.exists(targetPath)) {
                                        cases.add(new TransformTestCase(sourcePath, xsltPath, targetPath));
                                        System.out.println("Found test case: " + sourcePath.getFileName() + 
                                                " with XSLT: " + TRANSFORMS_BASE_DIR.relativize(xsltPath));
                                    } else {
                                        System.err.println("WARNING: Missing target file " + targetFileName + 
                                                " for source " + sourcePath.toAbsolutePath());
                                    }
                                });
                            } catch (IOException e) {
                                System.err.println("ERROR: Failed to process directory " + dmDir + ": " + e.getMessage());
                            }
                        } else {
                            System.err.println("WARNING: No " + XSLT_FILENAME + " found in " + dmDir);
                        }
                    });
                } catch (IOException e) {
                    System.err.println("ERROR: Failed to process transform directory " + transformDir + ": " + e.getMessage());
                }
            });
        } catch (IOException e) {
            System.err.println("ERROR: Failed to list transform directories: " + e.getMessage());
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
        // Intentar usar Saxon como procesador XSLT 2.0
        TransformerFactory factory;
        try {
            // Intentar cargar la implementación de Saxon
            factory = TransformerFactory.newInstance(SAXON_TRANSFORMER_FACTORY, null);
            System.out.println("Usando Saxon como procesador XSLT 2.0");
        } catch (TransformerFactoryConfigurationError e) {
            // Si Saxon no está disponible, usar el procesador predeterminado
            System.out.println("Saxon no está disponible. Usando el procesador XSLT predeterminado.");
            factory = TransformerFactory.newInstance();
            
            // Intentar configurar el procesador predeterminado para XSLT 2.0
            try {
                factory.setAttribute("http://saxon.sf.net/feature/version-warning", Boolean.FALSE);
                factory.setAttribute("http://saxon.sf.net/feature/allow-external-functions", Boolean.TRUE);
            } catch (IllegalArgumentException ex) {
                System.out.println("El procesador predeterminado no soporta configuraciones de Saxon: " + ex.getMessage());
            }
        }
        
        // Configuración de seguridad para permitir acceso a hojas de estilo externas
        try {
            // Mantener el procesamiento seguro pero permitir acceso a archivos locales
            factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
            
            // Permitir acceso a archivos locales para hojas de estilo externas
            factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "file");
            
            // Restringir acceso a DTD externas por seguridad
            factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
            
            System.out.println("Configuración de seguridad XSLT aplicada correctamente");
        } catch (TransformerConfigurationException e) {
            System.err.println("Advertencia: No se pudieron establecer las características de procesamiento seguro en TransformerFactory: " + e.getMessage());
        }

        // Establecer el directorio base para resolver referencias relativas
        Path xsltDir = xsltPath.getParent();
        String xsltSystemId = xsltPath.toUri().toString();
        
        try (InputStream xmlInputStream = Files.newInputStream(sourceXmlPath);
             InputStream xsltInputStream = Files.newInputStream(xsltPath)) {

            Source xsltSource = new StreamSource(xsltInputStream, xsltSystemId);
            Transformer transformer = factory.newTransformer(xsltSource);
            
            // Configurar el directorio base para resolver referencias relativas en el XSLT
            transformer.setParameter("base-uri", xsltDir.toUri().toString());

            Source xmlSource = new StreamSource(xmlInputStream, sourceXmlPath.toUri().toString());
            StringWriter writer = new StringWriter();
            Result result = new StreamResult(writer);

            transformer.transform(xmlSource, result);

            return writer.toString();
        }
    }
}
