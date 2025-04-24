package com.example.mtei.xslt;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.fail;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.FileSystem;
import java.nio.file.FileSystemNotFoundException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Stream;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import org.xmlunit.builder.DiffBuilder;
import org.xmlunit.builder.Input;
import org.xmlunit.diff.Diff;
// import org.xmlunit.diff.DefaultNodeMatcher; // Descomentar si se usa NodeMatcher
// import org.xmlunit.diff.ElementSelectors; // Descomentar si se usa NodeMatcher

class IntermediateFormatTransformationTest {

    private static final String BASE_RESOURCE_PATH = "transforms_formato_intermadio";
    private static final String TRANSFORM_PREFIX = "transform_";
    private static final String DM_PREFIX = "DM_";
    private static final String SOURCE_PREFIX = "source_";
    private static final String TARGET_PREFIX = "target_";
    private static final String MAIN_XSLT = "main.xslt";
    private static final String XML_SUFFIX = ".xml";

    // --- TestCase Class (sin cambios) ---
    static class TestCase {
        final String sourceXmlPath;
        final String targetXmlPath;
        final String xsltPath;
        
        final String displayName;

        TestCase(String sourceXmlPath, String targetXmlPath, String xsltPath, String displayName) {
            this.sourceXmlPath = sourceXmlPath;
            this.targetXmlPath = targetXmlPath;
            this.xsltPath = xsltPath;
            this.displayName = displayName;
        }

        @Override
        public String toString() {
            return displayName;
        }
    }

    // --- Fuente de datos (MethodSource) (sin cambios respecto a la versión anterior) ---
    static Stream<TestCase> transformationTestProvider() throws IOException, URISyntaxException {
        List<TestCase> testCases = new ArrayList<>();
        ClassLoader classLoader = IntermediateFormatTransformationTest.class.getClassLoader();
        URL baseUrl = classLoader.getResource(BASE_RESOURCE_PATH);

        if (baseUrl == null) {
            System.err.println("ERROR: Base resource path not found: " + BASE_RESOURCE_PATH);
            return Stream.empty();
        }
        System.out.println("Base URL found: " + baseUrl);

        Path basePath;
        URI baseUri = baseUrl.toURI();
        FileSystem fileSystem = null; // Para manejar el cierre del FileSystem del JAR

        try {
             if ("jar".equals(baseUri.getScheme())) {
                 try {
                     fileSystem = FileSystems.getFileSystem(baseUri);
                     System.out.println("Using existing JAR file system: " + baseUri);
                 } catch (FileSystemNotFoundException e) {
                     System.out.println("Creating new JAR file system: " + baseUri);
                     fileSystem = FileSystems.newFileSystem(baseUri, Collections.emptyMap());
                 }
                 basePath = fileSystem.getPath(BASE_RESOURCE_PATH);

             } else {
                System.out.println("Using file system path: " + baseUri);
                basePath = Paths.get(baseUri);
             }

             System.out.println("Starting scan from Path: " + basePath);
             if (!Files.exists(basePath)) {
                  System.err.println("ERROR: Calculated basePath does not exist: " + basePath);
                  return Stream.empty();
             }
             if (!Files.isDirectory(basePath)) {
                 System.err.println("ERROR: Calculated basePath is not a directory: " + basePath);
                 return Stream.empty();
             }

             scanDirectory(basePath, classLoader, testCases);

        } catch (Exception e) {
            System.err.println("Error accessing or scanning resource path: " + BASE_RESOURCE_PATH);
            e.printStackTrace();
             return Stream.empty();
        }

        if (testCases.isEmpty()) {
             System.err.println("WARNING: No test cases found under: " + BASE_RESOURCE_PATH);
        } else {
            System.out.println("Total test cases found: " + testCases.size());
        }

        return testCases.stream();
    }

    // --- Lógica de Descubrimiento (scanDirectory sin cambios) ---
    private static void scanDirectory(Path currentPath, ClassLoader classLoader, List<TestCase> testCases) {
        System.out.println("Scanning directory: " + currentPath);
        try (Stream<Path> stream = Files.list(currentPath)) {
            stream.forEach(path -> {
                if (Files.isDirectory(path)) {
                    String dirName = path.getFileName().toString();

                    if (dirName.startsWith(TRANSFORM_PREFIX)) {
                        System.out.println("  Entering transform directory: " + dirName);
                        scanDirectory(path, classLoader, testCases);
                    }
                    else if (dirName.startsWith(DM_PREFIX)) {
                         if (path.getParent() != null && path.getParent().getFileName().toString().startsWith(TRANSFORM_PREFIX)) {
                            System.out.println("    Entering DM directory: " + dirName);
                            Path xsltFile = path.resolve(MAIN_XSLT);
                            if (Files.exists(xsltFile)) {
                                try {
                                    String xsltResourcePath = getResourcePath(xsltFile);
                                    // *** LLAMADA A findSourcesInDMStructure con los DEBUG logs ***
                                    findSourcesInDMStructure(path, xsltResourcePath, classLoader, testCases);
                                } catch (Exception e) {
                                     System.err.println("    ERROR processing DM directory " + path + ": Failed to get resource path or find sources.");
                                     e.printStackTrace();
                                }
                            } else {
                                System.err.println("    WARNING: Missing " + MAIN_XSLT + " in DM directory: " + path);
                            }
                         } else {
                              System.out.println("    Skipping DM directory not directly under a transform_* directory: " + path);
                         }
                    }
                }
            });
        } catch (IOException e) {
            System.err.println("ERROR: Failed to list files in directory: " + currentPath + " - " + e.getMessage());
             e.printStackTrace();
        }
    }

    // --- Lógica de Descubrimiento (findSourcesInDMStructure CON DEBUG LOGS) ---
    /**
     * Busca recursivamente archivos 'source_*.xml' dentro de una carpeta base DM_* y sus subdirectorios.
     * Todos los sources encontrados usarán el mismo xsltResourcePath.
     */
    private static void findSourcesInDMStructure(Path dmBaseDir, String xsltResourcePath, ClassLoader classLoader, List<TestCase> testCases) {
        System.out.println("      Searching for source/target pairs recursively in: " + dmBaseDir.getFileName() + " using XSLT: " + xsltResourcePath);
        try (Stream<Path> walk = Files.walk(dmBaseDir)) {
            walk.filter(Files::isRegularFile)
                .filter(p -> {
                    String fileName = p.getFileName().toString();
                    return fileName.startsWith(SOURCE_PREFIX) && fileName.endsWith(XML_SUFFIX);
                })
                // *** INICIO: Procesamiento de cada sourceFile encontrado ***
                .forEach(sourceFile -> {
                    // --- LOG DE DEBUG ---
                    System.out.println("        [DEBUG] Processing source candidate: " + sourceFile.toString());
                    // --- FIN LOG DE DEBUG ---

                    String sourceFileName = sourceFile.getFileName().toString();
                    String targetFileName = TARGET_PREFIX + sourceFileName.substring(SOURCE_PREFIX.length());
                    Path targetFile = sourceFile.resolveSibling(targetFileName); // Target en la misma carpeta que Source

                    // --- LOG DE DEBUG ---
                    System.out.println("        [DEBUG] Expecting target: " + targetFile.toString());
                    // --- FIN LOG DE DEBUG ---

                    // *** Comprueba si existe el target ***
                    if (Files.exists(targetFile)) {
                        // --- LOG DE DEBUG ---
                        System.out.println("        [DEBUG] Target exists. Creating TestCase.");
                         // --- FIN LOG DE DEBUG ---
                        try {
                            String sourceResourcePath = getResourcePath(sourceFile);
                            String targetResourcePath = getResourcePath(targetFile);
                            String displayName = getRelativeDisplayName(sourceFile, BASE_RESOURCE_PATH); // Nombre más limpio

                            testCases.add(new TestCase(sourceResourcePath, targetResourcePath, xsltResourcePath, displayName));
                            System.out.println("        -> Found test case: " + displayName);

                        } catch (Exception e) {
                            System.err.println("        ERROR creating test case for source " + sourceFile + ": " + e.getMessage());
                            e.printStackTrace();
                        }
                    } else {
                        // *** El target NO existe -> Imprime Warning ***
                        System.err.println("        WARNING: Target file NOT FOUND for " + sourceFile.getFileName() + " in " + sourceFile.getParent().getFileName() + " (Expected path: " + targetFile + ")");
                    }
                });
                // *** FIN: Procesamiento de cada sourceFile encontrado ***
        } catch (IOException e) {
             System.err.println("      ERROR walking file tree for DM structure: " + dmBaseDir + " - " + e.getMessage());
             e.printStackTrace();
        }
    }


    // --- getResourcePath (sin cambios respecto a la versión anterior) ---
    private static String getResourcePath(Path absolutePath) {
        ClassLoader classLoader = IntermediateFormatTransformationTest.class.getClassLoader();
        String resourceName = BASE_RESOURCE_PATH;
        URL resourceUrl = classLoader.getResource(resourceName);
        if (resourceUrl == null) {
             resourceUrl = classLoader.getResource("");
             if (resourceUrl == null) {
                throw new RuntimeException("Cannot determine resources root directory!");
             }
        }

        try {
            Path resourcesRootPath;
            URI resourceUri = resourceUrl.toURI();

            if ("jar".equals(resourceUri.getScheme())) {
                 FileSystem jarFileSystem;
                 try {
                     jarFileSystem = FileSystems.getFileSystem(resourceUri);
                 } catch (FileSystemNotFoundException e) {
                      throw new IllegalStateException("JAR FileSystem not found for a path presumably within it: " + resourceUri, e);
                 }
                 Path jarRoot = jarFileSystem.getPath("/");
                 String relative = jarRoot.relativize(absolutePath).toString();
                 relative = relative.replace(jarFileSystem.getSeparator(), "/");
                 return relative.startsWith("/") ? relative.substring(1) : relative;

            } else {
                resourcesRootPath = Paths.get(resourceUrl.toURI());
                Path classPathRoot = resourcesRootPath.getParent();
                if (classPathRoot == null) {
                    throw new RuntimeException("Cannot determine classpath root from: " + resourcesRootPath);
                }
                String relative = classPathRoot.relativize(absolutePath).toString();
                return relative.replace(FileSystems.getDefault().getSeparator(), "/");
            }

        } catch (Exception e) {
            throw new RuntimeException("Failed to convert path to resource path: " + absolutePath, e);
        }
    }

     // --- getRelativeDisplayName (sin cambios) ---
     private static String getRelativeDisplayName(Path absolutePath, String basePathName) {
         try {
             String resourcePath = getResourcePath(absolutePath);
             if (resourcePath.startsWith(basePathName + "/")) {
                 return resourcePath.substring(basePathName.length() + 1);
             }
             return resourcePath;
         } catch (Exception e) {
             return absolutePath.getFileName().toString();
         }
     }

    // --- testTransformation (CON DiffBuilder para detalles de error) ---
    @DisplayName("Test XSLT Transformation")
    @ParameterizedTest(name = "{index} => {0}")
    @MethodSource("transformationTestProvider")
    void testTransformation(TestCase testCase) {
        System.out.println("-----------------------------------------------------");
        System.out.println("Running test for: " + testCase.displayName);

        InputStream sourceXmlStream = null;
        InputStream xsltStream = null;
        InputStream targetXmlStream = null; // Stream para cargar el target inicialmente
        InputStream targetXmlStreamForDiff = null; // Stream separado para la comparación
        String actualXmlOutput = null; // Para imprimir en caso de error

        try {
            // 1. Cargar recursos
            sourceXmlStream = getResourceAsStreamOrFail(testCase.sourceXmlPath);
            xsltStream = getResourceAsStreamOrFail(testCase.xsltPath);
            targetXmlStream = getResourceAsStreamOrFail(testCase.targetXmlPath); // Cargamos una vez para asegurar que existe

            // 2. Configurar transformador (con fallback y posible Saxon)
            System.out.println("  Using XSLT: " + testCase.xsltPath);
            TransformerFactory factory;
            try {
                factory = TransformerFactory.newInstance("net.sf.saxon.TransformerFactoryImpl", null);
                System.out.println("  Using Saxon-HE Transformer Factory");
            } catch (javax.xml.transform.TransformerFactoryConfigurationError e) {
                System.err.println("  WARN: Saxon-HE TransformerFactory not found or failed to load. Falling back to default JAXP transformer. Error: " + e.getMessage());
                factory = TransformerFactory.newInstance();
                System.out.println("  Using default JAXP Transformer Factory");
            }
            Transformer transformer = factory.newTransformer(new StreamSource(xsltStream));

            // 3. Ejecutar transformación
            StringWriter resultWriter = new StringWriter();
            transformer.transform(new StreamSource(sourceXmlStream), new StreamResult(resultWriter));
            actualXmlOutput = resultWriter.toString(); // Guardamos el resultado

            // 4. Comparar resultado con XMLUnit + DiffBuilder for detailed errors
            System.out.println("  Comparing with target: " + testCase.targetXmlPath);
            // Volvemos a cargar el target stream para la comparación, ya que el anterior puede haberse cerrado
            targetXmlStreamForDiff = getResourceAsStreamOrFail(testCase.targetXmlPath);

            Diff xmlDiff = DiffBuilder.compare(Input.fromStream(targetXmlStreamForDiff))
                    .withTest(Input.fromString(actualXmlOutput))
                    .ignoreWhitespace()
                    .ignoreComments()
                    // .normalizeWhitespace() // Considera descomentar si los espacios siguen siendo un problema
                    // .withNodeMatcher(new DefaultNodeMatcher(ElementSelectors.byNameAndText)) // Considera si el orden de elementos hermanos similares es un problema
                    .checkForIdentical() // O checkForSimilar()
                    .build();

            // Assert y reportar diferencias
            if (xmlDiff.hasDifferences()) {
                 System.err.println("  DIFFERENCES FOUND for: " + testCase.displayName);
                 int count = 0;
                 for (org.xmlunit.diff.Difference difference : xmlDiff.getDifferences()) {
                     System.err.println("   - Difference " + (++count) + ": " + difference.toString());
                     // System.err.println("     Control XPath: " + difference.getComparison().getControlDetails().getXPath()); // XPath puede ser útil
                     // System.err.println("     Test XPath:    " + difference.getComparison().getTestDetails().getXPath());
                 }
                  // Opcional: Imprimir XMLs para comparación manual fácil (cuidado con logs muy largos)
                  // System.err.println("----- EXPECTED (Target) -----\n" + new String(targetXmlStreamForDiff.readAllBytes())); // Necesitaría volver a leer el stream
                  // System.err.println("----- ACTUAL (Generated) -----\n" + actualXmlOutput);
                  // System.err.println("----- END XML -----");

                 fail("XML Transformation result differs from target for " + testCase.displayName + ". See console error log for difference details.");
            } else {
                 System.out.println("  XML Comparison OK.");
                 System.out.println("  Test PASSED for: " + testCase.displayName);
            }

        } catch (Exception e) { // Captura excepciones de carga, transformación o comparación
            System.err.println("  Test FAILED for: " + testCase.displayName + " with Exception.");
             if (actualXmlOutput != null) {
                 // Imprime una parte del XML generado si la transformación llegó a completarse
                 System.err.println("  Actual XML Output (at time of exception, first 1000 chars):\n" + actualXmlOutput.substring(0, Math.min(actualXmlOutput.length(), 1000)) + "...");
             } else {
                  System.err.println("  Actual XML Output: null (Exception likely occurred before or during transformation)");
             }
             e.printStackTrace(System.err); // Imprime stack trace a stderr
            fail("Exception during test execution for " + testCase.displayName + ": " + e.getMessage(), e);
        } finally {
            // Asegurar el cierre de todos los streams
             safeClose(sourceXmlStream);
             safeClose(xsltStream);
             safeClose(targetXmlStream);
             safeClose(targetXmlStreamForDiff); // Asegurarse de cerrar el stream de comparación
             System.out.println("-----------------------------------------------------");
        }
    }

    // --- getResourceAsStreamOrFail (sin cambios) ---
    private InputStream getResourceAsStreamOrFail(String resourcePath) {
        String cleanResourcePath = resourcePath.startsWith("/") ? resourcePath.substring(1) : resourcePath;
        InputStream is = getClass().getClassLoader().getResourceAsStream(cleanResourcePath);
        assertNotNull(is, "Resource not found in classpath: [" + cleanResourcePath + "] (Original: [" + resourcePath+"])");
        try {
            byte[] content = is.readAllBytes();
            is.close();
            return new ByteArrayInputStream(content);
        } catch (IOException e) {
            fail("Failed to read resource content: " + cleanResourcePath, e);
            return null;
        }
    }

    // --- safeClose (sin cambios) ---
    private void safeClose(InputStream is) {
        if (is != null) {
            try {
                is.close();
            } catch (IOException e) {
                System.err.println("Warn: Failed to close input stream: " + e.getMessage());
            }
        }
    }
}