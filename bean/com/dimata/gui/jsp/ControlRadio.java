/* Generated by Together */


package com.dimata.gui.jsp;

import java.io.*;
import java.util.*;
import java.text.*;

import javax.servlet.http.*;

import com.dimata.util.*;

public class ControlRadio
{

    /**
       Table Dimention :
     		-> rows, cols

		Radio Button :
        	-> name, value, caption, checked
     */
    //public static String draw(String name, String initVal, int size, int maxChar)
	public static String draw()
    {
        /*
        if(name == null) name = new String("txt_input");
        String sz = "";
        String mc = "";
          */

        int cols = 3;
        int rows = 4;

        String strHtml = "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n";

/*
		  <tr>
		    <td><input type="radio" name="radiobutton" value="radiobutton" checked> sdfdsf </td>
		    <td><input type="radio" name="radiobutton" value="radiobutton">sdfdsf </td>
		    <td><input type="radio" name="radiobutton" value="radiobutton">sdfdsf </td>
		  </tr>
*/
		for(int i = 0; i < rows; i++) {
            strHtml = strHtml + "  <tr>\n";
			for(int j = 0; j < cols; j++) {
            	strHtml = strHtml + "    <td><input type=\"radio\" name=\"radiobutton\" value=\"radiobutton\" checked>" + j + "</td>\n";
	        } // end for cols
			strHtml = strHtml + "  </tr>\n";
        } //end for rows

        return strHtml;
    } // end draw



    public static String getStr(String name, HttpServletRequest req) {
        String value = "";
        try {
	        value = req.getParameter(name);
        }catch(Exception e) {
        }
        return value;
    }

} // end of WP_ControlDate()
