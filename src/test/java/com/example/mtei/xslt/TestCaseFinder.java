package com.example.mtei.xslt;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

// Helper class or record to hold test case data (puede moverse aquí o a un paquete común)
record TransformTestCase(Path sourceXmlPath, Path xsltPath, Path targetXmlPath) {}

public class TestCaseFinder {

    private final Path transformsBaseDir;
    private static final String SOURCE_PREFIX = "source_";
    private static final String TARGET_PREFIX = "target_";
    private static final String XSLT_FILENAME = "main.xslt";
    private static final String TRANSFORM_PREFIX = "transform_";
    private static final String DM_PREFIX = "DM_";


    public TestCaseFinder(Path transformsBaseDir) {
        this.transformsBaseDir = transformsBaseDir;
    }

    /**
     * Finds all valid transformation test cases based on the specified structure.
     */
    public List<TransformTestCase> findTestCases() throws IOException {
        List<TransformTestCase> cases = new ArrayList<>();
        if (!Files.isDirectory(transformsBaseDir)) {
            System.err.println("ERROR: Transforms base directory not found: " + transformsBaseDir.toAbsolutePath());
            return cases; // Return empty list
        }

        // 1. Find all transform_ directories (first level)
        try (Stream<Path> transformDirs = Files.list(transformsBaseDir)
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
                                                " with XSLT: " + transformsBaseDir.relativize(xsltPath));
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
}
