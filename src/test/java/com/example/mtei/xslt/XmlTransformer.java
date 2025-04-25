package com.example.mtei.xslt;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.nio.file.Files;
import java.nio.file.Path;

import javax.xml.XMLConstants;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class XmlTransformer {

    private static final String SAXON_TRANSFORMER_FACTORY = "net.sf.saxon.TransformerFactoryImpl";
    private final TransformerFactory factory;

    public XmlTransformer() {
        this.factory = createTransformerFactory();
    }

    private TransformerFactory createTransformerFactory() {
        TransformerFactory tf;
        try {
            tf = TransformerFactory.newInstance(SAXON_TRANSFORMER_FACTORY, null);
            System.out.println("Usando Saxon como procesador XSLT 2.0");
        } catch (TransformerFactoryConfigurationError e) {
            System.out.println("Saxon no está disponible. Usando el procesador XSLT predeterminado.");
            tf = TransformerFactory.newInstance();
            // Intentar configurar el procesador predeterminado para XSLT 2.0 (opcional)
            try {
                tf.setAttribute("http://saxon.sf.net/feature/version-warning", Boolean.FALSE);
                tf.setAttribute("http://saxon.sf.net/feature/allow-external-functions", Boolean.TRUE);
            } catch (IllegalArgumentException ex) {
                System.out.println("El procesador predeterminado no soporta configuraciones de Saxon: " + ex.getMessage());
            }
        }

        // Configuración de seguridad
        try {
            tf.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
            tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "file");
            tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
            System.out.println("Configuración de seguridad XSLT aplicada correctamente");
        } catch (TransformerConfigurationException e) {
            System.err.println("Advertencia: No se pudieron establecer las características de procesamiento seguro en TransformerFactory: " + e.getMessage());
        }
        return tf;
    }

    /**
     * Performs XSLT transformation.
     * @param sourceXmlPath Path to the source XML file.
     * @param xsltPath Path to the XSLT file.
     * @return The transformed XML as a String.
     * @throws IOException If file reading fails.
     * @throws TransformerException If XSLT transformation fails.
     */
    public String transform(Path sourceXmlPath, Path xsltPath) throws IOException, TransformerException {
        Path xsltDir = xsltPath.getParent();
        String xsltSystemId = xsltPath.toUri().toString();

        try (InputStream xmlInputStream = Files.newInputStream(sourceXmlPath);
             InputStream xsltInputStream = Files.newInputStream(xsltPath)) {

            Source xsltSource = new StreamSource(xsltInputStream, xsltSystemId);
            Transformer transformer = factory.newTransformer(xsltSource);

            // Configurar el directorio base para resolver referencias relativas en el XSLT
            if (xsltDir != null) {
                 transformer.setParameter("base-uri", xsltDir.toUri().toString());
            }

            Source xmlSource = new StreamSource(xmlInputStream, sourceXmlPath.toUri().toString());
            StringWriter writer = new StringWriter();
            Result result = new StreamResult(writer);

            transformer.transform(xmlSource, result);

            return writer.toString();
        }
    }
}
