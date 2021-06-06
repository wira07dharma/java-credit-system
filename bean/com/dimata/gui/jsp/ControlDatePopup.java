/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.gui.jsp;

import com.dimata.qdep.form.FRMHandler;
import com.dimata.util.Formater;
import java.util.Date;

/**
 *
 * @author artha
 */
public class ControlDatePopup {
    
    /**
     * @desc membuat pengeset date untuk getTh()
     * @param formName
     * @param elementName
     * @return string javascipts isi getTh()
     */
    public static String writeDateCaller(String formName, String elementName){
        String strCall = "";
        strCall = "if(document."+formName+"."+elementName+") { var "+elementName+"_date = document."+formName+"."+elementName+".value;"
            +"if("+elementName+"_date) {"    
            +"var thn = "+elementName+"_date.substring(0,4);" 
            +"var bln = "+elementName+"_date.substring(5,7);"
            +"if(bln.charAt(0)==\"0\"){"
            +"bln = \"\"+bln.charAt(1);"
            +"}"
            +"var hri = "+elementName+"_date.substring(8,10);"
            +"if(hri.charAt(0)==\"0\"){"
            +"hri = \"\"+hri.charAt(1);"
            +"}"
            +"document."+formName+"."+elementName+"_mn.value=bln;"
            +"document."+formName+"."+elementName+"_dy.value=hri;"
            +"document."+formName+"."+elementName+"_yr.value=thn; }}";
    
        return strCall;
    }

    
    /**
     * untuk hideObjectForDate dari object ini
     * @param formName
     * @param elementName
     * @return string untuk hideObjectForDate
     * document.frmstandartrate.FRM_TRANS_TYPE.style.display="none";
     */
    public static String writeDateHideObj(String formName, String elementName){
        String strHideObj = "";
        strHideObj = "document."+formName+"."+elementName+".style.display=\"none\";";
        return strHideObj;
    }
    
    /**
     * untuk showObjectForDate dari object ini
     * @param formName
     * @param elementName
     * @return string untuk showObjectForDate
     * document.frmstandartrate.FRM_TRANS_TYPE.style.display="";
     */
    public static String writeDateShowObj(String formName, String elementName){
        String strHideObj = "";
        strHideObj = "document."+formName+"."+elementName+".style.display=\"\";";
        return strHideObj;
    }
    
    /**
     * @desc membuat interface untuk tanggal dan tempat mengeset tanggal yang dipilih
     * @param elementName
     * @param date
     * @return string dari element tanggal
     */
    public static String writeDate(String elementName, Date date){
        String strDate = "";
      if( date== null){
            date= new Date();
        }
        strDate = "<input type=\"text\" onClick=\"ds_sh(this);\" id=\""+elementName+"\" name=\""+elementName+"\" readonly=\"readonly\" style=\"cursor: text\" value=\""+Formater.formatDate((date == null? new Date() : date), "yyyy-MM-dd")+"\"/>"
                  +"<input type=\"hidden\" name=\""+elementName+ FRMHandler.MN +"\" value=\""+(date.getMonth()+1) +"\">"
                   +"<input type=\"hidden\" name=\""+elementName+ FRMHandler.DY+"\" value=\""+date.getDate() +"\">"
                   +"<input type=\"hidden\" name=\""+elementName+FRMHandler.YR+ "\" value=\""+(date.getYear()+1900) +"\">"   
                   +"<script language=\"JavaScript\" type=\"text/JavaScript\">getThn();</script>";
        return strDate;
    }
    /**
     * @desc membuat interface untuk tanggal dan tempat mengeset tanggal yang dipilih
     * @param elementName
     * @param date
     * @return string dari element tanggal
     */
    public static String writeDate(String elementName, Date date, int index){
        String strDate = "";
        strDate = "<input onClick=\"ds_sh(this,"+index+");\" name=\""+elementName+"\" readonly=\"readonly\" style=\"cursor: text\" value=\""+Formater.formatDate((date == null? new Date() : date), "yyyy-MM-dd")+"\"/>"
                   +"<input type=\"hidden\" name=\""+elementName+"_mn\">"
                   +"<input type=\"hidden\" name=\""+elementName+"_dy\">"
                   +"<input type=\"hidden\" name=\""+elementName+"_yr\">"
                   +"<script language=\"JavaScript\" type=\"text/JavaScript\">getThn();</script>";
        return strDate;
    }
    
    public static String writeDate(String elementName, Date date, int index, String function){
        String strDate = "";
        strDate = "<input onClick=\"ds_sh(this,"+index+");\" name=\""+elementName+"\" readonly=\"readonly\" style=\"cursor: text\" value=\""+Formater.formatDate((date == null? new Date() : date), "yyyy-MM-dd")+"\"/>"
                   +"<input type=\"hidden\" name=\""+elementName+"_mn\">"
                   +"<input type=\"hidden\" name=\""+elementName+"_dy\">"
                   +"<input type=\"hidden\" name=\""+elementName+"_yr\">"
                   +"<script language=\"JavaScript\" type=\"text/JavaScript\">"+function+";</script>";
        return strDate;
    }
    
    public static String writeDate(String elementName, Date date, String function){
        String strDate = "";
        strDate = "<input onClick=\"ds_sh(this);\" onChange=\""+function+";\" name=\""+elementName+"\" readonly=\"readonly\" style=\"cursor: text\" value=\""+Formater.formatDate((date == null? new Date() : date), "yyyy-MM-dd")+"\"/>"
                   +"<input type=\"hidden\" name=\""+elementName+"_mn\">"
                   +"<input type=\"hidden\" name=\""+elementName+"_dy\">"
                   +"<input type=\"hidden\" name=\""+elementName+"_yr\">"
                   +"<script language=\"JavaScript\" type=\"text/JavaScript\">"+function+";</script>";
        return strDate;
    }
    
    public static String writeDateHide(String elementName, Date date, String function){
        String strDate = "";
        if( date== null){
            date= new Date();
        }
        strDate = "<input name=\""+elementName+"\" type=\"hidden\" style=\"cursor: text\" value=\""+Formater.formatDate((date == null? new Date() : date), "yyyy-MM-dd")+"\"/>"
                   +"<input type=\"hidden\" name=\""+elementName+"_mn\" value=\""+(date.getMonth()+1) +"\">"
                   +"<input type=\"hidden\" name=\""+elementName+"_dy\" value=\""+date.getDate() +"\">"
                   +"<input type=\"hidden\" name=\""+elementName+"_yr\" value=\""+(date.getYear()+1900) +"\">"
                   +"<script language=\"JavaScript\" type=\"text/JavaScript\">"+function+";</script>";
        return strDate;
    }
    
    
    /**
     * @desc membuat table calendar
     * @param approot
     * @return table calendar
     */
    public static String writeTable(String approot){
        String strTable = "";
        strTable = "<table class=\"ds_box\" cellpadding=\"0\" cellspacing=\"0\" id=\"ds_conclass\" style=\"display: none;\">"
            +"<tr><td id=\"ds_calclass\">"
            +"</td></tr>"
            +"</table>"
            +"<script language=JavaScript src=\""+approot+"/main/calendar.js\"></script>";
        return strTable;
    }
    
}
