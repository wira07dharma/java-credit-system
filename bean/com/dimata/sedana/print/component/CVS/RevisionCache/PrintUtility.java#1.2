/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.print.component;

import com.dimata.common.entity.location.Location;
import com.lowagie.text.*;
import java.awt.Color;

/**
 *
 * @author arise
 */
public class PrintUtility {
	
	public static String namaHari[][] = {
		{"Minggu", "Senin","Selasa","Rabu","Kamis","Jum'at","Sabtu"},
		{"Sunday", "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
	};
	
	public static Color border = new Color(0x00, 0x00, 0x00);
	public static Color bgColor = new Color(220, 220, 220);
	
	public static Font fontTitle = new Font(Font.STRIKETHRU, 22, Font.BOLD, border);
	public static Font fontTitleUnderline = new Font(Font.STRIKETHRU, 22, Font.BOLD + Font.UNDERLINE, border);
	public static Font fontUnderSubTitle = new Font(Font.STRIKETHRU, 12);
	public static Font fontPublic = new Font(Font.STRIKETHRU, 8);
	public static Font fontMainHeader = new Font(Font.STRIKETHRU, 14, Font.BOLD + Font.UNDERLINE, border);
	public static Font fontHeader = new Font(Font.STRIKETHRU, 10, Font.ITALIC, border);
	public static Font fontHeaderUnderline = new Font(Font.STRIKETHRU, 10, Font.ITALIC + Font.UNDERLINE, border);
	public static Font fontListHeader = new Font(Font.STRIKETHRU, 10, Font.BOLD, border);
	public static Font fontLsContent = new Font(Font.STRIKETHRU, 8);
	public static Font fontLsContentUnderline = new Font(Font.STRIKETHRU, 8, Font.UNDERLINE, border);
	public static Font fontNormal = new Font(Font.STRIKETHRU, 10);
	public static Font fontNormalBold = new Font(Font.STRIKETHRU, 10, Font.BOLD, border);
	public static Font fontNormalHeader = new Font(Font.STRIKETHRU, 10);
	public static Font fontSection = new Font(Font.STRIKETHRU, 12, Font.BOLD, border);
	public static Font fontSubSection = new Font(Font.STRIKETHRU, 10, Font.BOLD, border);
	public static Font fontSectionContent = new Font(Font.STRIKETHRU, 8);
	public static Font fontSectionContentBold = new Font(Font.STRIKETHRU, 8, Font.BOLD, border);
	
	public static Table getHeaderImage(int SESS_LANGUAGE, Image gambar, Location loc) throws BadElementException, DocumentException {
		Table table = new Table(2);

		try {
			int ctnInt[] = {25, 75};
			table.setBorderColor(new Color(255, 255, 255));
			table.setWidth(100);
			table.setWidths(ctnInt);
			table.setSpacing(1);
			table.setPadding(0);
			table.setDefaultCellBorder(Table.NO_BORDER);

			gambar.scaleAbsolute(100, 100);
			Cell cellImage = new Cell(new Phrase(new Chunk(gambar, 0, 0)));
			cellImage.setRowspan(6);
			table.setDefaultHorizontalAlignment(Table.ALIGN_CENTER);
			table.setDefaultVerticalAlignment(Table.ALIGN_BOTTOM);
			table.addCell(cellImage);

			table.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
			table.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
			table.addCell(new Phrase("", fontPublic));
			table.addCell(new Phrase("", fontPublic));
			table.addCell(new Phrase(loc.getName().toUpperCase(), fontTitle));
			table.addCell(new Phrase(loc.getAddress(), fontUnderSubTitle));
			table.addCell(new Phrase("Telp: " + loc.getTelephone() + ", Fax: " + loc.getFax(), fontUnderSubTitle));
			table.addCell(new Phrase("", fontPublic));

			Cell cell = new Cell(new Phrase("", fontPublic));
			cell.setColspan(ctnInt.length);
			table.setDefaultCellBorder(Table.TOP);
			table.addCell(cell);
			table.setDefaultCellBorder(Table.NO_BORDER);

		} catch (Exception e) {
			printErrorMessage(e.getMessage());
		}
		return table;
	}
	
	//=============================== UTILITY =======================
	public static void printErrorMessage(String errorMessage) {
		System.out.println("");
		System.out.println("========================================>>> WARNING <<<========================================");
		System.out.println("");
		System.out.println("MESSAGE : " + errorMessage);
		System.out.println("");
		System.out.println("========================================<<< * * * * >>>========================================");
		System.out.println("");
	}
	public static Table createTable(int col, int[] widths) throws BadElementException, DocumentException {
		Table tempTable = new Table(col);

		int ctnInt[] = widths;
		tempTable.setDefaultHorizontalAlignment(Table.ALIGN_LEFT);
		tempTable.setDefaultVerticalAlignment(Table.ALIGN_CENTER);
		tempTable.setDefaultCellBackgroundColor(bgColor);
		tempTable.setCellsFitPage(true);
		tempTable.setDefaultCellBackgroundColor(Color.WHITE);
		tempTable.setBorderColor(new Color(255, 255, 255));
		tempTable.setWidth(100);
		tempTable.setWidths(ctnInt);
		tempTable.setSpacing(1f); 
		tempTable.setPadding(1);

		return tempTable;
	}

	public static void createEmptySpace(Table table, int col, int row) throws BadElementException, DocumentException {
		for (int i = 0; i < row; i++) {
			Cell cell = new Cell(new Phrase("", fontLsContent));
			cell.setColspan(col);
			table.addCell(cell);
		}

	}

	public static String capitalizeWord(String str) {
		String words[] = str.split("\\s");
		String capitalizeWord = "";
		for (String w : words) {
			String first = w.substring(0, 1);
			String afterfirst = w.substring(1);
			capitalizeWord += first.toUpperCase() + afterfirst + " ";
		}
		return capitalizeWord.trim();
	}

}
