package com.example.mtei.xslt;

import java.util.List;
import java.util.stream.StreamSupport;

import org.junit.jupiter.api.Assertions;
import org.xmlunit.builder.DiffBuilder;
import org.xmlunit.builder.Input;
import org.xmlunit.diff.ComparisonResult;
import org.xmlunit.diff.ComparisonType;
import org.xmlunit.diff.DefaultComparisonFormatter;
import org.xmlunit.diff.Diff;
import org.xmlunit.diff.Difference;
import org.xmlunit.diff.DifferenceEvaluator;

public class XmlComparator {

    // Constantes para el formato de salida (pueden moverse a una clase de utilidades)
    private static final String ANSI_RESET = "\u001B[0m";
    private static final String ANSI_GREEN = "\u001B[32m";
    private static final String ANSI_YELLOW = "\u001B[33m";
    private static final String ANSI_RED = "\u001B[31m";
    private static final String ANSI_BOLD = "\u001B[1m";

    /**
     * Compares XML documents ignoring attributes, whitespace, and comments.
     * Prints detailed feedback and fails the assertion if differences are found.
     *
     * @param fileName    Name of the source file for reporting.
     * @param actualXml   The actual XML generated from transformation.
     * @param expectedXml The expected XML from the target file.
     */
    public void compareIgnoringAttributes(String fileName, String actualXml, String expectedXml) {
        DifferenceEvaluator ignoreAttributesDifferenceEvaluator = (comparison, outcome) -> {
            if (comparison.getType() == ComparisonType.ELEMENT_NUM_ATTRIBUTES ||
                comparison.getType() == ComparisonType.ATTR_NAME_LOOKUP ||
                comparison.getType() == ComparisonType.ATTR_VALUE ||
                comparison.getType().name().startsWith("ATTR_")) {
                return ComparisonResult.EQUAL;
            }
            return outcome;
        };

        Diff diff = DiffBuilder.compare(Input.fromString(expectedXml))
                .withTest(Input.fromString(actualXml))
                .ignoreWhitespace()
                .ignoreComments()
                .withDifferenceEvaluator(ignoreAttributesDifferenceEvaluator)
                .build();

        List<Difference> differenceList = StreamSupport
                .stream(diff.getDifferences().spliterator(), false)
                .toList();

        int totalDifferences = differenceList.size();
        int totalNodes = countNodes(expectedXml); // Use the helper method

        double matchPercentage = 100.0;
        if (totalNodes > 0 && totalDifferences > 0) {
            matchPercentage = Math.max(0, 100.0 - ((double)totalDifferences / totalNodes * 100.0));
            matchPercentage = Math.min(100.0, Math.max(0.0, matchPercentage));
        }

        String formattedPercentage = String.format("%.2f", matchPercentage);
        String colorCode = getColorCode(matchPercentage);

        if (totalDifferences == 0) {
            System.out.println(ANSI_GREEN + ANSI_BOLD + "MATCH 100%" + ANSI_RESET +
                    " - Transformación exitosa para " + fileName + " (ignorando atributos)");
        } else {
            System.out.println(colorCode + ANSI_BOLD + "MATCH " + formattedPercentage + "%" + ANSI_RESET +
                    " - Encontradas " + totalDifferences + " diferencias en " + fileName + " (ignorando atributos)");

            printDifferences(differenceList, colorCode);

            Assertions.fail("XML comparison failed for " + fileName + ": " + totalDifferences +
                    " differences found (ignoring attributes)");
        }
    }

    private String getColorCode(double matchPercentage) {
        if (matchPercentage >= 95.0) return ANSI_GREEN;
        if (matchPercentage >= 80.0) return ANSI_YELLOW;
        return ANSI_RED;
    }

    private void printDifferences(List<Difference> differenceList, String colorCode) {
        DefaultComparisonFormatter formatter = new DefaultComparisonFormatter();
        System.out.println("\nDiferencias encontradas (ignorando atributos):");
        int count = 0;
        int maxDifferencesToShow = 10;

        for (Difference difference : differenceList) {
            count++;
            System.out.println(colorCode + "Diferencia " + count + ":" + ANSI_RESET);
            System.out.println(formatter.getDescription(difference.getComparison()));
            System.out.println("  Esperado: " + difference.getComparison().getControlDetails().getValue());
            System.out.println("  Actual:   " + difference.getComparison().getTestDetails().getValue());
            System.out.println();

            if (count >= maxDifferencesToShow && differenceList.size() > maxDifferencesToShow) {
                System.out.println("... y " + (differenceList.size() - maxDifferencesToShow) + " diferencias más.");
                break;
            }
        }
    }

     /**
     * Counts approximately the number of element nodes in an XML document string.
     * @param xml The XML document as a string.
     * @return An approximate count of element nodes.
     */
    private int countNodes(String xml) {
        int count = 0;
        int index = 0;
        while ((index = xml.indexOf('<', index)) != -1) {
            if (index + 1 < xml.length() && xml.charAt(index + 1) != '/' && xml.charAt(index + 1) != '?' && xml.charAt(index + 1) != '!') {
                count++;
            }
            index++;
        }
        return Math.max(1, count); // Ensure at least 1 to avoid division by zero
    }
}
