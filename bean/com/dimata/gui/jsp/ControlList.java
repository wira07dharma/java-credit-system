package com.dimata.gui.jsp;

import com.dimata.util.Command;
import javax.servlet.jsp.JspWriter;

import java.util.Vector;

/**
 * This will gerate list of data based on vectors : Header and content are customizedable. Url lingk may also be setup for a column.
 */
public class ControlList {
    public ControlList() {
        areaWidth = new String("100%");
        areaStyle = new String("listarea");

        listWidth = new String("100%");
        listStyle = new String("listtable");

        title = new String("");
        titleStyle = new String("listtitle");
        cellStyle = new String("cellStyle");
        cellStyleOdd = new String("cellStyleOdd");
        cellSpacing = new String("1");

        header = new Vector(1, 1);
        headerAlign = new Vector(1, 1);
        colsAlign = new Vector(1, 1);
        headerWidth = new Vector(1, 1);
        headerRowspan = new Vector(1, 1);
        headerColspan = new Vector(1, 1);
        headerStyle = new String("listheader");
        footerStyle = new String("listFooter");

        data = new Vector(1, 1);
        footer = new Vector(1,1);

        linkRow = -1;
        linkData = new Vector(1, 1);
        linkPrefix = new String("");
        linkSufix = new String("");

        rowSelectedStyle = new String("tabtitlehidden");
    }

    public void initDefault() {
    }

    private String areaWidth;
    private String areaStyle;

    private String listWidth;
    private String listStyle;

    private String title;
    private Vector header;
    private Vector headerAlign;
    private Vector colsAlign;
    private Vector headerWidth;
    private Vector headerRowspan;
    private Vector headerColspan;
    private String headerStyle;
    private String footerStyle;

    private Vector data;
    private Vector footer;

    private int linkRow;
    private Vector linkData;
    private String linkPrefix;
    private String linkSufix;
    private String titleStyle;
    private Vector headerToDataMap;
    private String cellStyle;
    private String cellStyleOdd;
    private String cellSpacing;
    private Vector align = new Vector(1, 1);
    private Vector colsFormat = new Vector(1, 1);
    private int rowStep = 10;
    private int rowStart = -1;
    private String rowSelectedStyle;
    private int border;
    

    private Vector headerSize = new Vector(1, 1);
    private Vector headerWidthSize = new Vector(1, 1);

    public static String SELF_DRAW = "SELF";

    public void reset() {
        data.removeAllElements();
        footer.removeAllElements();
        linkData.removeAllElements();
    }


    /**
     * standard draw the list : from "data" and "linkData"
     */
    public String draw() {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\" cellspacing=\"0\">";
        if (title != null && title.length() > 0)
            str = str + "<tr><td><div class=\"" + titleStyle + "\">" + title +
                    "</div></td></tr>";

        str = str + "<tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\" border=\"" + border + "\"><tr>";
        // create header
        for (int h = 0; h < header.size(); h++) {

            str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" + (String) header.get(h) + "</td>";
        }
        str = str + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                str = str + "<tr valign=\"top\">";

                for (int k = 0; k < tmpRow.size(); k++) {
                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + ">" + (String) tmpRow.get(k) + "</td>";
                    } else {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                (String) tmpRow.get(k) + "</a></td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";
        //System.out.println(str);
        return str;
    }

    public String draw(int selectedIndex) {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\" border=\"" + border + "\"><tr>";
        // create header
        for (int h = 0; h < header.size(); h++) {

            str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" + (String) header.get(h) + "</td>";
        }
        str = str + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                str = str + "<tr valign=\"top\">";

                for (int k = 0; k < tmpRow.size(); k++) {
                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + ((j%2)==0? cellStyle:cellStyleOdd);
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + ">" +
                                (String) tmpRow.get(k) + "</td>";
                    } else {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + ((j%2)==0? cellStyle:cellStyleOdd);
                        }
                        str = str + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                (String) tmpRow.get(k) + "</a></td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }
    
     public String drawBoostrap(int selectedIndex) {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table class=\"table table-striped table-bordered\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table class=\"table table-striped table-bordered\"><tr>";
        // create header
        for (int h = 0; h < header.size(); h++) {

            str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" + (String) header.get(h) + "</td>";
        }
        str = str + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                str = str + "<tr valign=\"top\">";

                for (int k = 0; k < tmpRow.size(); k++) {
                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + ((j%2)==0? cellStyle:cellStyleOdd);
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + ">" +
                                (String) tmpRow.get(k) + "</td>";
                    } else {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + ((j%2)==0? cellStyle:cellStyleOdd);
                        }
                        str = str + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                (String) tmpRow.get(k) + "</a></td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }
    
    public String drawBootstrapStripted() {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table  id=\"example1\" class=\"table table-bordered table-striped\" >";
        str = str +"<tr>";
        // create header
        for (int h = 0; h < header.size(); h++) {
            
            str = str + "<th>" + (String)header.get(h) + "</th>";
        }
        str = str + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        int prevColNumber=0;
        String colSpan="";
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector)data.get(j);
            if (tmpRow != null) {
                str = str + "<tr>";
                for (int k = 0; k < tmpRow.size(); k++) {
                    if ((linkRow != k) || (linkData==null) || (linkData.size()<=j)) {
                        str = str + "<td "+(k < (tmpRow.size()-1)? "":colSpan)+"" + (String) colsFormat.get(k) + ">" + (String)tmpRow.get(k) + "</td>";
                    }
                    else {
                        str = str + "<td "+(k < (tmpRow.size()-1)? "":colSpan)+"" + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String)linkData.get(j) + linkSufix + "\">" +
                        (String)tmpRow.get(k) + "</a></td>";
                    }
                }
                prevColNumber = tmpRow.size();
                str = str + "</tr>";
            }
        }
        //str = str + "</table></td></tr></table></div>";
        str = str + "</table>";
        //System.out.println(str);
        return str;
    }
    /**
     * standard draw the list : from "data" and "linkData"
     * table with border
     * field Name with align
     * celldata with align
     */
    public String drawMe() {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\"  class=\"" + areaStyle + "\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table width=\"" + listWidth + "\" border=\"" + border + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        for (int h = 0; h < header.size(); h++) {

            str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" +
                    "<div align=\"" + (String) headerAlign.get(h) + "\">" + (String) header.get(h) + "</div></td>";
        }
        str = str + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                str = str + "<tr>";

                for (int k = 0; k < tmpRow.size(); k++) {
                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + ">" +
                                "<div align=\"" + (String) colsAlign.get(k) + "\" >" + (String) tmpRow.get(k) + "</div></td>";
                    } else {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                "<div align=\"" + (String) colsAlign.get(k) + "\" >" + (String) tmpRow.get(k) + "</div></a></td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }

    /**
     * standard draw the list : from "data" and "linkData"
     * table with border
     * field Name with align
     * celldata with align
     */
    public String drawMe(int selectedIndex) {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\"  class=\"" + areaStyle + "\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table width=\"" + listWidth + "\" border=\"" + border + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        for (int h = 0; h < header.size(); h++) {

            str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" +
                    "<div align=\"" + (String) headerAlign.get(h) + "\">" + (String) header.get(h) + "</div></td>";
        }
        str = str + "</tr>";
        System.out.println("sjfmhsdhfdsf");
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                str = str + "<tr>";

                for (int k = 0; k < tmpRow.size(); k++) {
                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td nowrap class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + ((j%2)==0? cellStyle:cellStyleOdd);
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + ">" +
                                "<div align=\"" + (String) colsAlign.get(k) + "\" >" + (String) tmpRow.get(k) + "</div></td>";
                    } else {
                        str = str + "<td nowrap class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + ((j%2)==0? cellStyle:cellStyleOdd);
                        }
                        str = str + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                "<div align=\"" + (String) colsAlign.get(k) + "\" >" + (String) tmpRow.get(k) + "</div></a></td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }
    
    
       /**
     * standard draw the list : from "data" and "linkData"
     * table with border
     * field Name with align
     * celldata with align
     */
    public void drawMe(JspWriter out,  int selectedIndex) {
        String tmpStr = new String("");
        //String str = new String("");
        try{
        out.print("<table width=\"" + areaWidth + "\"  class=\"" + areaStyle + "\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table width=\"" + listWidth + "\" border=\"" + border + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\"><tr>");
        // create header
        for (int h = 0; h < header.size(); h++) {

            out.print("<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" +
                    "<div align=\"" + (String) headerAlign.get(h) + "\">" + (String) header.get(h) + "</div></td>");
        }
        out.print("</tr>");
        //System.out.println("sjfmhsdhfdsf");
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                out.print("<tr>");

                for (int k = 0; k < tmpRow.size(); k++) {
                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        out.print("<td nowrap class=\"");
                        if (j == selectedIndex) {
                            out.print(rowSelectedStyle);
                        } else {
                            out.print(((j%2)==0? cellStyle:cellStyleOdd));
                        }

                        out.print("\" " + (String) colsFormat.get(k) + ">" +
                                "<div align=\"" + (String) colsAlign.get(k) + "\" >" + (String) tmpRow.get(k) + "</div></td>");
                    } else {
                        out.print("<td nowrap class=\"");
                        if (j == selectedIndex) {
                            out.print(rowSelectedStyle);
                        } else {
                            out.print(((j%2)==0? cellStyle:cellStyleOdd));
                        }
                        out.print("\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                "<div align=\"" + (String) colsAlign.get(k) + "\" >" + (String) tmpRow.get(k) + "</div></a></td>");
                    }
                }
                out.print("</tr>");
            }
        }
        out.print("</table></td></tr></table>");
        } catch(Exception exc){
            System.out.println(" Draw List : "+exc);
        }
        //return str;
    }
    
    /**
     * standard draw the list : from "data" and "linkData"
     * table with border
     * field Name with align
     * celldata with align
     */
    public String drawMeContent(int selectedIndex) {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\"  class=\"" + areaStyle + "\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table width=\"" + listWidth + "\" border=\"" + border + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        for (int h = 0; h < header.size(); h++) {
            str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" +
                    "<div align=\"" + (String) headerAlign.get(h) + "\">" + (String) header.get(h) + "</div></td>";
        }
        str = str + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                str = str + "<tr>";

                for (int k = 0; k < tmpRow.size(); k++) {
                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + cellStyle;
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + ">" +
                                "<div align=\"" + (String) colsAlign.get(k) + "\" >" + (String) tmpRow.get(k) + "</div></td>";
                    } else {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + cellStyle;
                        }
                        str = str + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                "<div align=\"" + (String) colsAlign.get(k) + "\" >" + (String) tmpRow.get(k) + "</div></a></td>";
                    }
                }
                str = str + "</tr>";
                if (j == selectedIndex) {
                    int colspan = tmpRow.size();
                    tmpRow = (Vector) data.get(j + 1);
                    str = str + "<tr>\n<td class=\"" + cellStyle + "\" colspan=\"" + colspan + "\">" + tmpRow.get(0) + "</td>\n</tr>";
                    j++;
                }
            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }

    public String drawMeListContent(int selectedIndex) {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" border=\"" + border + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        boolean ifnewrow = false;
        String newrow = "";
        for (int h = 0; h < header.size(); h++) {
            String colspan = String.valueOf(headerColspan.get(h));
            String rowspan = String.valueOf(headerRowspan.get(h));
            if ((!colspan.equals("0")) || (!rowspan.equals("0"))) {
                str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\"" +
                        " rowspan=\"" + rowspan + "\" colspan=\"" + colspan + "\" " +
                        "align=\"" + headerAlign.get(h) + "\">" + (String) header.get(h) + "</td>";

            } else {
                if (ifnewrow == false) {
                    newrow = newrow + "</tr>";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + (String) headerWidth.get(h) + "\" class=\"" + headerStyle + "\" align=\"" + (String) headerAlign.get(h) + "\"> " +
                        (String) header.get(h) + "</td>";
            }

        }
        //System.out.println(newrow);
        str = str + newrow + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {

                str = str + "<tr>";
                boolean rowsAlign = false;
                for (int k = 0; k < tmpRow.size(); k++) {
                    int alg = 0;
                    if (((String) headerRowspan.get(k)).equals("0") || (rowsAlign == true)) {
                        alg = k + 1;
                        rowsAlign = true;
                    } else
                        alg = k;

                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + cellStyle;
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + ">" +
                                "<div align=\"" + (String) colsAlign.get(alg) + "\">" +
                                (String) tmpRow.get(k) + "</div></td>";
                    } else {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + cellStyle;
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                "<div align=\"" + (String) colsAlign.get(alg) + "\">" + (String) tmpRow.get(k) + "</div></a></td>";
                    }
                }
                str = str + "</tr>";
                if (j == selectedIndex) {
                    int colspan = tmpRow.size();
                    tmpRow = (Vector) data.get(j + 1);
                    str = str + "<tr>\n<td class=\"" + cellStyle + "\" colspan=\"" + colspan + "\">" + tmpRow.get(0) + "</td>\n</tr>";
                    j++;
                }
            }
        }
        str = str + "</table></td></tr></table>";

        return str;
    }


    /**
     *  draw  the list : from "data" and "linkData"
     *  fieldName with colspan or rowspan
     */
    public String drawList() {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\">";
        if (title != null && title.length() > 0) {
            str = str + "<tr><td><div class=\"" + titleStyle + "\">" + title +
                    "</div></td></tr>";
        }
        str = str + "<tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        boolean ifnewrow = false;
        String newrow = "";
        for (int h = 0; h < header.size(); h++) {
            String colspan = String.valueOf(headerColspan.get(h));
            String rowspan = String.valueOf(headerRowspan.get(h));
            if ((!colspan.equals("0")) || (!rowspan.equals("0"))) {
           //if (!rowspan.equals("0")) {
                str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\"" +
                        " rowspan=\"" + rowspan + "\" colspan=\"" + colspan + "\" ";
                if (!colspan.equals("0"))
                    str = str + "align=\"center\"";
                str = str + ">" + (String) header.get(h) + "</td> \n";
                
                /*if (ifnewrow == false || rowspan.equals("0")) {
                    newrow = newrow + "</tr> \n";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\" > " +
                        (String) header.get(h) + "</td>";*/

            } else {                 
                if (ifnewrow == false) {
                    newrow = newrow + "</tr> \n";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\" > " +
                        (String) header.get(h) + "</td>";
            }

        }
        //System.out.println(newrow);
        str = str + newrow + "</tr> \n";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                str = str + "<tr valign=\"top\">";

                for (int k = 0; k < tmpRow.size(); k++) {
                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + ">" + (String) tmpRow.get(k) + "</td> \n";
                    } else {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                (String) tmpRow.get(k) + "</a></td> \n";
                    }
                }
                str = str + "</tr> \n";
            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }


    public String drawMeList() {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" border=\"" + border + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        boolean ifnewrow = false;
        String newrow = "";
        for (int h = 0; h < header.size(); h++) {
            String colspan = String.valueOf(headerColspan.get(h));
            String rowspan = String.valueOf(headerRowspan.get(h));
            if ((!colspan.equals("0")) || (!rowspan.equals("0"))) {
                str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\"" +
                        " rowspan=\"" + rowspan + "\" colspan=\"" + colspan + "\" " +
                        "align=\"" + headerAlign.get(h) + "\">" + (String) header.get(h) + "</td>";


            } else {
                if (ifnewrow == false) {
                    newrow = newrow + "</tr>";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + (String) headerWidth.get(h) + "\" class=\"" + headerStyle + "\" align=\"" + (String) headerAlign.get(h) + "\"> " +
                        (String) header.get(h) + "</td>";
            }

        }
        //System.out.println(newrow);
        str = str + newrow + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                str = str + "<tr valign=\"top\">";
                boolean rowsAlign = false;
                for (int k = 0; k < tmpRow.size(); k++) {

                    int alg = 0;
                    if (((String) headerRowspan.get(k)).equals("0") || (rowsAlign == true)) {
                        alg = k + 1;
                        rowsAlign = true;
                    } else
                        alg = k;

                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"" + cellStyle + "\" " + (String) colsFormat.get(k) + ">" +
                                "<div align=\"" + (String) colsAlign.get(alg) + "\">" + (String) tmpRow.get(k) + "</div></td>";
                    } else {
                        str = str + "<td class=\"" + cellStyle + "\" " + (String) colsFormat.get(k) + ">" +
                                "<div align=\"" + (String) colsAlign.get(alg) + "\"><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                (String) tmpRow.get(k) + "</a></div></td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";

        return str;
    }

    /**
     * drawMeWithId ---> to field <table>, <tr> and <td> with ID
     * created by gedhy
     */
    public String drawMeWithId() {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\"  class=\"" + areaStyle + "\"> " +
                "<tr><td>" +
                "<table width=\"" + listWidth + "\" border=\"" + border + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\">" +
                "<tr>";

        boolean ifnewrow = false;
        String newrow = "";
        for (int h = 0; h < header.size(); h++) {
            String colspan = String.valueOf(headerColspan.get(h));
            String rowspan = String.valueOf(headerRowspan.get(h));
            if ((!colspan.equals("0")) || (!rowspan.equals("0"))) {
                str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\"" +
                        " rowspan=\"" + rowspan + "\" colspan=\"" + colspan + "\" " +
                        "align=\"" + headerAlign.get(h) + "\">" + (String) header.get(h) + "</td>";

            } else {
                if (ifnewrow == false) {
                    newrow = newrow + "</tr>";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + (String) headerWidth.get(h) + "\" class=\"" + headerStyle + "\" align=\"" + (String) headerAlign.get(h) + "\"> " +
                        (String) header.get(h) + "</td>";
            }

        }
        //System.out.println(newrow);
        str = str + newrow + "</tr>";

        //create list
        Vector tmpRow = new Vector(1, 1);
        int spanIndex = 0;

        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {

                if (tmpRow.size() != 1) { // not colspan
                    str = str + "<tr>";
                    boolean rowsAlign = false;
                    for (int k = 0; k < tmpRow.size(); k++) {

                        int alg = 0;
                        if (((String) headerRowspan.get(k)).equals("0") || (rowsAlign == true)) {
                            alg = k + 1;
                            rowsAlign = true;
                        } else {
                            alg = k;
                        }

                        if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                            str = str + "<td class=\"" + cellStyle + "\" " + (String) colsFormat.get(k) + ">" +
                                    "<div align=\"" + (String) colsAlign.get(alg) + "\">" + (String) tmpRow.get(k) + "</div></td>";
                        } else {
                            str = str + "<td class=\"" + cellStyle + "\" " + (String) colsFormat.get(k) + ">" +
                                    "<div align=\"" + (String) colsAlign.get(alg) + "\">" +
                                    "<img alt=\"expand or collapse related purchase request list\" class=\"expandable\" onclick=\"javascript:changepic()\" src=\"/hanoman/image/signplus.gif\" width=\"9\" child=\"childlist" + spanIndex + "\">&nbsp;" +
                                    //"<a style=\"text-decoration:none\" href=\"" + linkPrefix + (String)linkData.get(j) + linkSufix + "\">"+(String)tmpRow.get(k) + "</a></div></td>";
                                    (String) tmpRow.get(k) + "</div></td>";
                        }
                    }
                    str = str + "</tr>";
                }

                if (tmpRow.size() == 1) { // colspan
                    str = str + "<tr class=\"collapsed\" id=\"childlist" + spanIndex + "\">" +
                            "<td colspan=\"" + header.size() + "\">" + (String) tmpRow.get(0) + "</td></tr>";
                    spanIndex++;
                }

            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }


    /**
     * drawListWithId ---> to field <table>, <tr> and <td> with ID
     * created by lkarunia
     */
    public String drawListWithId() {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\"  class=\"" + areaStyle + "\"> " +
                "<tr><td>" +
                "<table width=\"" + listWidth + "\" border=\"" + border + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\">" +
                "<tr>";

        boolean ifnewrow = false;
        String newrow = "";
        System.out.println(">>>>>>>>>>>>>>>>>>" + header.size());
        for (int h = 0; h < header.size(); h++) {
            String colspan = String.valueOf(headerColspan.get(h));
            String rowspan = String.valueOf(headerRowspan.get(h));
            if ((!colspan.equals("0")) || (!rowspan.equals("0"))) {
                str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" + (String) header.get(h) + "</td>";
            } else {
                if (ifnewrow == false) {
                    newrow = newrow + "</tr>";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + (String) headerWidth.get(h) + "\" class=\"" + headerStyle + "\"> " +
                        (String) header.get(h) + "</td>";
            }

        }
        str = str + newrow + "</tr>";

        //create list
        Vector tmpRow = new Vector(1, 1);
        int spanIndex = 0;
        System.out.println(">>>>>>>>>>>>>>>>>>data" + data.size());
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            System.out.println(">>>>>>>>>>>>>>>>>>tmpRow" + tmpRow.size());
            if (tmpRow != null) {
                if (tmpRow.size() != 1) { // not colspan
                    str = str + "<tr>";
                    boolean rowsAlign = false;
                    for (int k = 0; k < tmpRow.size(); k++) {
                        if ((linkRow != k) || (linkData == null) || (linkData.size() <= spanIndex)) {
                            str = str + "<td class=\"" + cellStyle + "\" " + (String) colsFormat.get(k) + ">" +
                                    (String) tmpRow.get(k) + "</td>";
                        } else {
                            str = str + "<td class=\"" + cellStyle + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(spanIndex) + linkSufix + "\">" +
                                    (String) tmpRow.get(k) + "</a></td>";
                        }
                    }
                    spanIndex++;
                    str = str + "</tr>";
                }

                if (tmpRow.size() == 1) { // colspan
                    System.out.println("spanIndex >>" + (spanIndex));
                    str = str + "<tr class=\"collapsed\" id=\"childlist" + (spanIndex - 1) + "\">" +
                            "<td colspan=\"" + header.size() + "\">" + (String) tmpRow.get(0) + "</td></tr>";
                }

            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }

    public String drawListandChild() {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\"  class=\"" + areaStyle + "\"> " +
                "<tr><td>" +
                "<table width=\"" + listWidth + "\" border=\"" + border + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\">" +
                "<tr>";

        boolean ifnewrow = false;
        String newrow = "";
        for (int h = 0; h < header.size(); h++) {
            String colspan = String.valueOf(headerColspan.get(h));
            String rowspan = String.valueOf(headerRowspan.get(h));
            if ((!colspan.equals("0")) || (!rowspan.equals("0"))) {
                str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" + (String) header.get(h) + "</td>";
            } else {
                if (ifnewrow == false) {
                    newrow = newrow + "</tr>";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + (String) headerWidth.get(h) + "\" class=\"" + headerStyle + "\"> " +
                        (String) header.get(h) + "</td>";
            }

        }
        str = str + newrow + "</tr>";

        //create list
        Vector tmpRow = new Vector(1, 1);
        int spanIndex = 0;
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                if (tmpRow.size() != 1) { // not colspan
                    str = str + "<tr>";
                    boolean rowsAlign = false;
                    for (int k = 0; k < tmpRow.size(); k++) {
                        if ((linkRow != k) || (linkData == null) || (linkData.size() <= spanIndex)) {
                            str = str + "<td class=\"" + cellStyle + "\" " + (String) colsFormat.get(k) + ">" +
                                    (String) tmpRow.get(k) + "</td>";
                        } else {
                            str = str + "<td class=\"" + cellStyle + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(spanIndex) + linkSufix + "\">" +
                                    (String) tmpRow.get(k) + "</a></td>";
                        }
                    }
                    spanIndex++;
                    str = str + "</tr>";
                }

                if (tmpRow.size() == 1) { // colspan
                    System.out.println("spanIndex >>" + (spanIndex));
                    str = str + "<tr>" +
                            "<td colspan=\"" + header.size() + "\">" + (String) tmpRow.get(0) + "</td></tr>";
                }

            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }


    public String drawList(int selectedIndex) {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\">";
        if (title != null && title.length() > 0) {
            str = str + "<tr><td><div class=\"" + titleStyle + "\">" + title +
                    "</div></td></tr>";
        }
        str = str + "<tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        boolean ifnewrow = false;
        String newrow = "";
        for (int h = 0; h < header.size(); h++) {
            String colspan = String.valueOf(headerColspan.get(h));
            String rowspan = String.valueOf(headerRowspan.get(h));
            if ((!colspan.equals("0")) || (!rowspan.equals("0"))) {
                str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\"" +
                        " rowspan=\"" + rowspan + "\" colspan=\"" + colspan + "\" ";
                if (!colspan.equals("0"))
                    str = str + "align=\"center\"";
                str = str + ">" + (String) header.get(h) + "</td>";

            } else {
                if (ifnewrow == false) {
                    newrow = newrow + "</tr>";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\" > " +
                        (String) header.get(h) + "</td>";
            }

        }
        //System.out.println(newrow);
        str = str + newrow + "</tr>";

        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {

                str = str + "<tr valign=\"top\">"; 

                for (int k = 0; k < tmpRow.size(); k++) {
                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + cellStyle;
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + ">" + (String) tmpRow.get(k) + "</td>";
                    } else {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + cellStyle;
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                (String) tmpRow.get(k) + "</a></td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }


    public String drawList_LinkSize(int selectedIndex) {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        boolean ifnewrow = false;
        String newrow = "";
        for (int h = 0; h < header.size(); h++) {
            String colspan = String.valueOf(headerColspan.get(h));
            String rowspan = String.valueOf(headerRowspan.get(h));
            if ((!colspan.equals("0")) || (!rowspan.equals("0"))) {
                str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\"" +
                        " rowspan=\"" + rowspan + "\" colspan=\"" + colspan + "\" ";
                if (!colspan.equals("0"))
                    str = str + "align=\"center\"";
                str = str + ">" + (String) header.get(h) + "</td>";

            } else {
                if (ifnewrow == false) {
                    newrow = newrow + "</tr>";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\" > " +
                        (String) header.get(h) + "</td>";
            }

        }
        str = str + newrow + "</tr>";

        //System.out.println("str : "+str);

        String strSize = "";
        //System.out.println("headerSize : "+headerSize);
        for (int c = 0; c < headerSize.size(); c++) {
            Vector vectHeader = (Vector) headerSize.get(c);
            Vector vectWidth = (Vector) headerWidthSize.get(c);
            strSize = strSize + "<tr>";
            for (int s = 0; s < vectHeader.size(); s++) {
                strSize = strSize + "<td width=\"" + vectWidth.get(s) + "\" class=\"" + headerStyle + "\">" +
                        "<div align=\"center\">" + (String) vectHeader.get(s) + "</div></td>";
            }
            strSize = strSize + "</tr>";
        }

        str = str + strSize;


        System.out.println("str : " + str);
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {

                str = str + "<tr>";

                for (int k = 0; k < tmpRow.size(); k++) {
                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + cellStyle;
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + ">" + (String) tmpRow.get(k) + "</td>";
                    } else {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + cellStyle;
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                (String) tmpRow.get(k) + "</a></td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }

    /**
     *  draw  the list : from "data" and "linkData"
     *  fieldName with colspan or rowspan
     *  fieldName with align
     *  listCell with align
     */

    public String drawMeList(int selectedIndex) {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" border=\"" + border + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        boolean ifnewrow = false;
        String newrow = "";
        for (int h = 0; h < header.size(); h++) {
            String colspan = String.valueOf(headerColspan.get(h));
            String rowspan = String.valueOf(headerRowspan.get(h));
            if ((!colspan.equals("0")) || (!rowspan.equals("0"))) {
                str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\"" +
                        " rowspan=\"" + rowspan + "\" colspan=\"" + colspan + "\" " +
                        "align=\"" + headerAlign.get(h) + "\">" + (String) header.get(h) + "</td>";

            } else {
                if (ifnewrow == false) {
                    newrow = newrow + "</tr>";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + (String) headerWidth.get(h) + "\" class=\"" + headerStyle + "\" align=\"" + (String) headerAlign.get(h) + "\"> " +
                        (String) header.get(h) + "</td>";
            }

        }
        //System.out.println(newrow);
        str = str + newrow + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {

                str = str + "<tr>";
                boolean rowsAlign = false;
                for (int k = 0; k < tmpRow.size(); k++) {
                    int alg = 0;
                    if (((String) headerRowspan.get(k)).equals("0") || (rowsAlign == true)) {
                        alg = k + 1;
                        rowsAlign = true;
                    } else
                        alg = k;

                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + cellStyle;
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + ">" +
                                "<div align=\"" + (String) colsAlign.get(alg) + "\"><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                (String) tmpRow.get(k) + "</a></div></td>";
                    } else {
                        str = str + "<td class=\"";
                        if (j == selectedIndex) {
                            str = str + rowSelectedStyle;
                        } else {
                            str = str + cellStyle;
                        }

                        str = str + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                "<div align=\"" + (String) colsAlign.get(alg) + "\">" + (String) tmpRow.get(k) + "</div></a></td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";

        return str;
    }


    public String draw_LinkJoinData() {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        int numOfCols = header.size();
        for (int h = 0; h < header.size(); h++) {

            str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" + (String) header.get(h) + "</td>";
        }
        str = str + "</tr>";
        //create list
        String strCell = "";
        String strLink = "";
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            strCell = "";
            strLink = "";
            if (tmpRow != null) {
                str = str + "<tr>";
                int dataCols = tmpRow.size();
                Object obj = ((Object) tmpRow.get(0));
                strLink = obj == null ? "" : obj.toString();

                for (int k = 1; k < numOfCols + 1; k++) { // + 1 , cause of link join data
                    if (k < dataCols) {
                        obj = ((Object) tmpRow.get(k));
                        strCell = obj == null ? "" : obj.toString();
                    } else
                        strCell = "";

                    if (linkRow != (k - 1)) {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k - 1) + ">" + strCell + "</td>";
                    } else {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k - 1) + "><a href=\"" + linkPrefix + strLink + linkSufix + "\">" +
                                strCell + "</a></td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }

    /**
     * this will show the linkRow column of data with the type of input/html or others , specified by the linkPrefix and LinkSufix
     * the data on the linkRow column will be randered between the linkPrefix and LinkSufix.
     * so you can build e.g. :   <input name="" type="radio" value="data[linkRow]" >
     *
     */
    public String draw_JoinDataLinkSpec() {
        return draw_JoinDataLinkSpec(0, data.size());
    }

    public String draw_JoinDataLinkSpec(int startRow, int endRow) {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\"> <tr><td><div class=\"" + titleStyle + "\">" + title +
                "</div></td></tr><tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        int numOfCols = header.size();
        for (int h = 0; h < header.size(); h++) {

            str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" + (String) header.get(h) + "</td>";
        }
        str = str + "</tr>";
        //create list
        String strCell = "";
        //String strLink ="";
        Vector tmpRow = new Vector(1, 1);
        for (int j = startRow; (j < data.size()) && (j <= endRow); j++) {
            tmpRow = (Vector) data.get(j);
            strCell = "";
            if (tmpRow != null) {
                str = str + "<tr>";
                int dataCols = tmpRow.size();
                //strLink = ( (Object)tmpRow.get(0)).toString();

                for (int k = 0; k < numOfCols; k++) {
                    if (k < dataCols) {
                        Object obj = ((Object) tmpRow.get(k));
                        strCell = obj == null ? "" : obj.toString();
                    } else
                        strCell = "";

                    if (linkRow != (k)) {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + ">" + strCell + "</td>";
                    } else {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + " >" + linkPrefix + strCell + linkSufix +
                                "</td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";

        return str;
    }


    public String drawMeWithId(String imagePath) {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\"  class=\"" + areaStyle + "\"> " +
                "<tr><td>" +
                "<table width=\"" + listWidth + "\" border=\"" + border + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\">" +
                "<tr>";

        boolean ifnewrow = false;
        String newrow = "";
        for (int h = 0; h < header.size(); h++) {
            String colspan = String.valueOf(headerColspan.get(h));
            String rowspan = String.valueOf(headerRowspan.get(h));
            if ((!colspan.equals("0")) || (!rowspan.equals("0"))) {
                str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\"" +
                        " rowspan=\"" + rowspan + "\" colspan=\"" + colspan + "\" " +
                        "align=\"" + headerAlign.get(h) + "\">" + (String) header.get(h) + "</td>";

            } else {
                if (ifnewrow == false) {
                    newrow = newrow + "</tr>";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + (String) headerWidth.get(h) + "\" class=\"" + headerStyle + "\" align=\"" + (String) headerAlign.get(h) + "\"> " +
                        (String) header.get(h) + "</td>";
            }

        }
        //System.out.println(newrow);
        str = str + newrow + "</tr>";

        //create list
        Vector tmpRow = new Vector(1, 1);
        int spanIndex = 0;

        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {

                if (tmpRow.size() != 1) { // not colspan
                    str = str + "<tr>";
                    boolean rowsAlign = false;
                    for (int k = 0; k < tmpRow.size(); k++) {

                        int alg = 0;
                        if (((String) headerRowspan.get(k)).equals("0") || (rowsAlign == true)) {
                            alg = k + 1;
                            rowsAlign = true;
                        } else {
                            alg = k;
                        }

                        if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                            str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + ">" +
                                    "<div align=\"" + (String) colsAlign.get(alg) + "\">" + (String) tmpRow.get(k) + "</div></td>";
                        } else {
                            str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + ">" +
                                    "<div align=\"" + (String) colsAlign.get(alg) + "\">" +
                                    "<img alt=\"expand or collapse related purchase request list\" class=\"expandable\" onclick=\"javascript:changepic()\" src=\"" + imagePath + "\" width=\"9\" child=\"childlist" + spanIndex + "\">&nbsp;" +
                                    //"<a style=\"text-decoration:none\" href=\"" + linkPrefix + (String)linkData.get(j) + linkSufix + "\">"+(String)tmpRow.get(k) + "</a></div></td>";
                                    (String) tmpRow.get(k) + "</div></td>";
                        }
                    }
                    str = str + "</tr>";
                }

                if (tmpRow.size() == 1) { // colspan
                    str = str + "<tr class=\"collapsed\" id=\"childlist" + spanIndex + "\">" +
                            "<td colspan=\"" + header.size() + "\">" + (String) tmpRow.get(0) + "</td></tr>";
                    spanIndex++;
                }

            }
        }
        str = str + "</table></td></tr></table>";
        return str;
    }

    /**
     * Added by wardana may 24, 2004
     * Method ini berfungsi utk draw list, dimana listnya ada rowspan atau colspannya.
     * Row berupa vector :
     * index 0 : data list
     * index 1 : rowspan
     * index 2 : colspan
     * @return
     *
     */
    public String drawWithRowColSpans() {
        String tmpStr = new String("");
        String str = new String("");
        Vector vTempRow = new Vector();
        int iRowspan = 0;
        int iColspan = 0;
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\" cellspacing=\"0\">";
        if (title != null && title.length() > 0)
            str = str + "<tr><td><div class=\"" + titleStyle + "\">" + title +
                    "</div></td></tr>";

        str = str + "<tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\" border=\"" + border + "\"><tr>";
        // create header
        for (int h = 0; h < header.size(); h++) {

            str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" + (String) header.get(h) + "</td>";
        }
        str = str + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                str = str + "<tr valign=\"top\">";
                for (int k = 0; k < tmpRow.size(); k++) {
                    vTempRow = (Vector)tmpRow.get(k);
                    iRowspan = Integer.parseInt((String)vTempRow.get(1));
                    iColspan = Integer.parseInt((String)vTempRow.get(2));
                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" "+ (iRowspan > 1 ? " rowspan=\"" + iRowspan + "\" ":"") + (iColspan > 1 ? " colspan=\"" + iColspan + "\" ":"") + (String) colsFormat.get(k) + ">" + (String) vTempRow.get(0) + "</td>";
                    } else {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" "+ (iRowspan > 1 ? " rowspan=\"" + iRowspan + "\" ":"") + (iColspan > 1 ? " colspan=\"" + iColspan + "\" ":"") + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                (String) vTempRow.get(0) + "</a></td>";
                    }
                }
                str = str + "</tr>";
            }
        }
        str = str + "</table></td></tr></table>";
        //System.out.println(str);
        return str;
    }

    public String drawListWithRowColSpans() {
        String tmpStr = new String("");
        String str = new String("");
        Vector vTempRow = new Vector();
        int iRowspan = 0;
        int iColspan = 0;
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\">";
        if (title != null && title.length() > 0) {
            str = str + "<tr><td><div class=\"" + titleStyle + "\">" + title +
                    "</div></td></tr>";
        }
        str = str + "<tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\"><tr>";
        // create header
        boolean ifnewrow = false;
        String newrow = "";
        for (int h = 0; h < header.size(); h++) {
            String colspan = String.valueOf(headerColspan.get(h));
            String rowspan = String.valueOf(headerRowspan.get(h));
            if ((!colspan.equals("0")) || (!rowspan.equals("0"))) {
                str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\"" +
                        " rowspan=\"" + rowspan + "\" colspan=\"" + colspan + "\" ";
                if (!colspan.equals("0"))
                    str = str + "align=\"center\"";
                str = str + ">" + (String) header.get(h) + "</td>";

            } else {
                if (ifnewrow == false) {
                    newrow = newrow + "</tr>";
                    ifnewrow = true;
                }
                String tagHtml = "";
                if (newrow.length() > 5)
                    tagHtml = newrow.substring(newrow.length() - 5, newrow.length());
                if (!tagHtml.equals("</td>"))
                    newrow = newrow + "<tr>";
                newrow = newrow + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\" > " +
                        (String) header.get(h) + "</td>";
            }

        }
        //System.out.println(newrow);
        str = str + newrow + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                str = str + "<tr valign=\"top\">";

                for (int k = 0; k < tmpRow.size(); k++) {
                    vTempRow = (Vector)tmpRow.get(k);
                    iRowspan = Integer.parseInt((String)vTempRow.get(1));
                    iColspan = Integer.parseInt((String)vTempRow.get(2));

                    if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" "+ (iRowspan > 1 ? " rowspan=\"" + iRowspan + "\" ":"") + (iColspan > 1 ? " colspan=\"" + iColspan + "\" ":"") + (String) colsFormat.get(k) + ">" + (String) vTempRow.get(0) + "</td>";
                    } else {
                        str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" "+ (iRowspan > 1 ? " rowspan=\"" + iRowspan + "\" ":"") + (iColspan > 1 ? " colspan=\"" + iColspan + "\" ":"") + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                (String) vTempRow.get(0) + "</a></td>";
                    }
                }
                str = str + "</tr>";
            }
        }

         for (int j = 0; j < footer.size(); j++) {
            tmpRow = (Vector) footer.get(j);
            if (tmpRow != null) {
                str = str + "<tr valign=\"top\">";

                for (int k = 0; k < tmpRow.size(); k++) {
                    vTempRow = (Vector)tmpRow.get(k);
                    iRowspan = Integer.parseInt((String)vTempRow.get(1));
                    iColspan = Integer.parseInt((String)vTempRow.get(2));
                    str = str + "<td class=\"" + footerStyle + "\" "+ (iRowspan > 1 ? " rowspan=\"" + iRowspan + "\" ":"") + (iColspan > 1 ? " colspan=\"" + iColspan + "\" ":"") + (String) colsFormat.get(k) + ">" + (String) vTempRow.get(0) + "</td>";
                }
                str = str + "</tr>";
            }
        }

        str = str + "</table></td></tr></table>";
        return str;
    }

    public String drawWithSelf() {
        String tmpStr = new String("");
        String str = new String("");
        str = "<table width=\"" + areaWidth + "\" class=\"" + areaStyle + "\" cellspacing=\"0\">";
        if (title != null && title.length() > 0)
            str = str + "<tr><td><div class=\"" + titleStyle + "\">" + title +
                    "</div></td></tr>";

        str = str + "<tr><td><table width=\"" + listWidth + "\" class=\"" + listStyle + "\" cellspacing=\"" + cellSpacing + "\" border=\"" + border + "\"><tr>";
        // create header
        for (int h = 0; h < header.size(); h++) {

            str = str + "<td width=\"" + headerWidth.get(h) + "\" class=\"" + headerStyle + "\">" + (String) header.get(h) + "</td>";
        }
        str = str + "</tr>";
        //create list
        Vector tmpRow = new Vector(1, 1);
        for (int j = 0; j < data.size(); j++) {
            tmpRow = (Vector) data.get(j);
            if (tmpRow != null) {
                if(tmpRow.size() > 1 && tmpRow.get(0).toString().trim().equals(SELF_DRAW)){
                   str += tmpRow.get(1);
                }else{
                    str = str + "<tr valign=\"top\">";

                    for (int k = 0; k < tmpRow.size(); k++) {
                        if ((linkRow != k) || (linkData == null) || (linkData.size() <= j)) {
                            str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + ">" + (String) tmpRow.get(k) + "</td>";
                        } else {
                            str = str + "<td class=\"" + ((j%2)==0? cellStyle:cellStyleOdd) + "\" " + (String) colsFormat.get(k) + "><a href=\"" + linkPrefix + (String) linkData.get(j) + linkSufix + "\">" +
                                    (String) tmpRow.get(k) + "</a></td>";
                        }
                    }
                    str = str + "</tr>";
                }
            }
        }
        str = str + "</table></td></tr></table>";
        //System.out.println(str);
        return str;
    }

    public String getFooterStyle() {
        return footerStyle;
    }

    public void setFooterStyle(String footerStyle) {
        this.footerStyle = footerStyle;
    }

    public Vector getFooter() {
        return footer;
    }

    public void setFooter(Vector footer) {
        this.footer = footer;
    }

    public String getAreaWidth() {
        return areaWidth;
    }

    public void setAreaWidth(java.lang.String areaWidth) {
        this.areaWidth = areaWidth;
    }

    public String getAreaStyle() {
        return areaStyle;
    }

    public void setAreaStyle(String areaStyle) {
        this.areaStyle = areaStyle;
    }

    public String getListWidth() {
        return listWidth;
    }

    public void setListWidth(java.lang.String listWidth) {
        this.listWidth = listWidth;
    }

    public String getListStyle() {
        return listStyle;
    }

    public void setListStyle(String listStyle) {
        this.listStyle = listStyle;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Vector getHeader() {
        return header;
    }

    //public void setHeader(Vector header) { this.header = header; }
    public Vector getHeaderWidth() {
        return headerWidth;
    }

    public Vector getHeaderAlign() {
        return headerAlign;
    }

    public Vector getColsAlign() {
        return colsAlign;
    }

    public Vector getHeaderRowspan() {
        return headerRowspan;
    }

    public Vector getHeaderColspan() {
        return headerColspan;
    }

    //public void setHeaderWidth(Vector headerWidth) { this.headerWidth = headerWidth; }
    public void addHeader(String header, String width) {
        this.header.add(header);
        this.headerWidth.add(width);
        this.colsFormat.add("");
    }


    public void addHeader(String header, String width, String rowspan, String colspan) {
        this.header.add(header);
        this.headerWidth.add(width);
        this.headerRowspan.add(rowspan);
        this.headerColspan.add(colspan);
        this.colsFormat.add("");
    }

    public void addHeader(String header) {
        this.header.add(header);
        this.headerWidth.add("");
        this.headerRowspan.add("");
        this.headerColspan.add("");
        this.colsFormat.add("");
    }


    /* public void addHeader(String header)
     {
        this.header.add(header); this.headerWidth.add("");
        this.colsFormat.add("");
     }*/

    public void addHeader(String header, String width, String rowspan, String colspan,
                          String colFormat) {
        this.header.add(header);
        this.headerWidth.add(width);
        this.headerRowspan.add(rowspan);
        this.headerColspan.add(colspan);
        this.colsFormat.add(colFormat);
    }

    public void addHeader(String header, String width, String colFormat) {
        this.header.add(header);
        this.headerWidth.add(width);
        this.colsFormat.add(colFormat);
    }

    public void dataFormat(String header, String width, String headerAlign, String colsAlign) {
        this.header.add(header);
        this.headerWidth.add(width);
        this.headerAlign.add(headerAlign);
        this.colsAlign.add(colsAlign);
        this.colsFormat.add("");
    }

    public void dataFormat(String header, String width, String rowspan, String colspan,
                           String headerAlign, String colsAlign) {
        this.header.add(header);
        this.headerWidth.add(width);
        this.headerRowspan.add(rowspan);
        this.headerColspan.add(colspan);
        this.headerAlign.add(headerAlign);
        this.colsAlign.add(colsAlign);
        this.colsFormat.add("");
    }


    public void setHeaderCaption(int idx, String caption) {
        if (idx < this.header.size())
            this.header.set(idx, caption);
    }

    public String getHeaderStyle() {
        return headerStyle;
    }

    public void setHeaderStyle(String headerStyle) {
        this.headerStyle = headerStyle;
    }


    public Vector getData() {
        return data;
    }

    public void setData(Vector data) {
        this.data = data;
    }

    public int getLinkRow() {
        return linkRow;
    }

    public void setLinkRow(int linkRow) {
        this.linkRow = linkRow;
    }

    public Vector getLinkData() {
        return linkData;
    }

    public void setLinkData(Vector linkData) {
        this.linkData = linkData;
    }

    public String getLinkPrefix() {
        return linkPrefix;
    }

    public void setLinkPrefix(String linkPrefix) {
        this.linkPrefix = linkPrefix;
    }

    public String getLinkSufix() {
        return linkSufix;
    }

    public void setLinkSufix(String linkSufix) {
        this.linkSufix = linkSufix;
    }

    public String getTitleStyle() {
        return titleStyle;
    }

    public void setTitleStyle(String titleStyle) {
        this.titleStyle = titleStyle;
    }

    public Vector getHeaderToDataMap() {
        return headerToDataMap;
    }

    /**
     *  mapping from header index to data index ,
     *      standard  : default header 0-> data 0 ...
     *      link join data : default link -> data 0 ,  header 0-> data 1 ...
     */
    public void setHeaderToDataMap(Vector headerToDataMap) {
        this.headerToDataMap = headerToDataMap;
    }

    public String getCellStyle() {
        return cellStyle;
    }

    public void setCellStyle(String cellStyle) {
        this.cellStyle = cellStyle;
    }

    public String getCellStyleOdd() {
        return cellStyleOdd;
    }

    public void setCellStyleOdd(String cellStyleOdd) {
        this.cellStyleOdd = cellStyleOdd;
    }

    public String getCellSpacing() {
        return cellSpacing;
    }

    public void setCellSpacing(String cellSpacing) {
        this.cellSpacing = cellSpacing;
    }

    public Vector getColsFormat() {
        return colsFormat;
    }

    public void setColsFormat(Vector colsFormat) {
        this.colsFormat = colsFormat;
    }

    public int getRowStart() {
        return 0;
    }


    public int getRowStep() {
        return rowStep;
    }

    public void setRowStep(int rowStep) {
        this.rowStep = rowStep;
    }

    public String drawFirst_LJoin() {
        rowStart = 0;
        String html = draw_JoinDataLinkSpec(rowStart, rowStart + rowStep - 1);
        /* if(rowStep<data.size()){
                 rowStart = rowStep;
         }*/
        return html;
    }

    public String drawLast_LJoin() {
        int rowNum = data.size();
        if ((rowNum % rowStep) > 0) {
            rowStart = rowNum - (rowNum % rowStep);
        } else {
            rowStart = rowNum - rowStep;
        }
        return draw_JoinDataLinkSpec(rowStart, rowStart + rowStep - 1);
    }

    public String drawNext_LJoin() {

        //System.out.println("00000000   row start : "+rowStart);

        if (rowStart < 0) {
// System.out.println("000000000000 in < 0");
            rowStart = 0;
            return draw_JoinDataLinkSpec(rowStart, rowStart + rowStep - 1);
        } else {
            //System.out.println("---)))) > 0 ");
            if ((rowStart + rowStep) < data.size()) {
// System.out.println("000000000  rowStart : "+ (rowStart + rowStep));
                rowStart = rowStart + rowStep;
                return draw_JoinDataLinkSpec(rowStart, rowStart + rowStep - 1);
            } else {
                return draw_JoinDataLinkSpec(rowStart, data.size());
            }
        }
        //return "";
    }

    public String drawPrev_LJoin() {
        if (rowStart <= 0) {
            rowStart = 0;
            return draw_JoinDataLinkSpec(rowStart, rowStart + rowStep - 1);
        } else {
            if (rowStart - rowStep >= 0) {
                rowStart = rowStart - rowStep;
                return draw_JoinDataLinkSpec(rowStart, rowStart + rowStep - 1);
            }
        }
        return "";
    }


    public static int getNewOffset(int iCommand, int totalItem, int maxOnList, int currentOffset) {
        switch (iCommand) {
            case Command.FIRST:
                return 0;

            case Command.PREV:
                if (currentOffset < 0) {
                    return 0;
                } else {
                    if (currentOffset - maxOnList >= 0) {
                        return currentOffset - maxOnList;
                    } else
                        return 0;
                }

            case Command.NEXT:
                if (currentOffset < 0) {
                    return 0;
                } else {
                    if ((currentOffset + maxOnList) < totalItem) {
                        return currentOffset + maxOnList;
                    } else {
                        return currentOffset;
                    }
                }

            case Command.LAST:
                if ((totalItem % maxOnList) > 0) {
                    return totalItem - (totalItem % maxOnList);
                } else {
                    return totalItem - maxOnList;
                }

            default :
                return currentOffset;
        }

    }

    public String getRowSelectedStyle() {
        return rowSelectedStyle;
    }

    public void setRowSelectedStyle(String rowSelectedStyle) {
        this.rowSelectedStyle = rowSelectedStyle;
    }

    public int getBorder() {
        return border;
    }

    public void setBorder(int border) {
        this.border = border;
    }

    public void setHeaderSize(Vector vect, Vector vt) {
        this.headerSize.add(vect);
        this.headerWidthSize.add(vt);
    }

    public static void main(String[] arg){
        ControlList ctrlist = new ControlList(); 
        
        int language = 0;
        
        String strHeader[][] = {
	{"PERKIRAAN","ANGGARANG","REALISASI","PENCAPAIAN BULAN INI","PENCAPAIAN TAHUN INI","S.D BULAN INI","BULAN INI","RP","%"},
	{"ACCOUNT","BUDGET","ACTUAL","MTD TO BUDGET VAR","YTD TO BUDGET VAR","MONTH-TO-DATE","YEAR-TO-DATE","IDR","%"}
        };
        ctrlist.addHeader("ACCOUNT","10%","3","0");
        ctrlist.addHeader("MTD","10%","0","4");
        ctrlist.addHeader("BUDGET","10%","2","0");
        ctrlist.addHeader("ACTUAL","10%","2","0");
        ctrlist.addHeader("VARIANCE","10%","0","2");
        ctrlist.addHeader("VALUE","10%","0","0");
         ctrlist.addHeader("%","10%","0","0");
        
        String list = ctrlist.drawList();
        
        System.out.println(list);
    }
}
