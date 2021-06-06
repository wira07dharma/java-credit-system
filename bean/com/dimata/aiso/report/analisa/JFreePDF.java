/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.posbo.report.grafik;

import com.lowagie.text.Document;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.DefaultFontMapper;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfTemplate;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.io.FileOutputStream;
import java.util.Vector;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;

/**
 *
 * @author gadnyana
 */
public class JFreePDF {

    /* chapter12/FoobarCharts.java */
    public static void convertToPdf(JFreeChart chart,
	    int width, int height, String filename) {
	Document document = new Document(new Rectangle(width, height));
	try {
	    PdfWriter writer;
	    writer = PdfWriter.getInstance(document, new FileOutputStream(filename));
	    document.open();
	    
	    PdfContentByte cb = writer.getDirectContent();
	    
	    PdfTemplate tp = cb.createTemplate(width, height);
	    Graphics2D g2d = tp.createGraphics(width, height, new DefaultFontMapper());
	    Rectangle2D r2d = new Rectangle2D.Double(0, 0, width, height);
	    
	    chart.draw(g2d, r2d);
	    g2d.dispose();
	    cb.addTemplate(tp, 0, 0);
	} catch (Exception e) {
	    e.printStackTrace();
	}
	document.close();
    }

    public static void main(String[] as) {

	DefaultPieDataset pd = new DefaultPieDataset();
	Vector alValues = new Vector();
	alValues.add("200");
	alValues.add("100");
	alValues.add("200");

	alValues.add("50");
	alValues.add("80");
	alValues.add("90");

	for (int cnt = 0; cnt < alValues.size(); cnt++) {
	    int val = Integer.parseInt((alValues.get(cnt).toString().trim()));
	    pd.setValue("nama " + cnt, val);
	}

	JFreeChart chart = ChartFactory.createPieChart("", pd, false, false, false);
	convertToPdf(chart, 400, 300, "/media/disk/contoh.pdf");
    }
}
