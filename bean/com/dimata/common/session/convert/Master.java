/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.session.convert;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Regen
 */
public class Master {

  public static String implode(String separator, Vector<Long> data) {
    StringBuilder sb = new StringBuilder();
    String s= "";
    int i=0;
    for(Long d: data) {
      //data.length - 1 => to not add separator at the end
      if (i!=0) {s+=separator;}
      s+=d.toString();
      i++;
    }
    return s;
  }
  
  public static boolean inArray(String[] s, String i) {
    boolean x = false;
    if(s != null) {
      for(String n: s) {
        if (n.equals(i)) {
          return true;
        }
      }
    }
    return x;
  }
  
  public static Date string2DateTime(String dateString) {
    return string2Date(dateString, "yyyy-MM-dd HH:mm:ss");
  }
  
  public static Date string2Date(String dateString) {
      if (dateString.equals("")) {
          return null;
      }
    dateString+=" 00:00:00";
    return string2Date(dateString, "yyyy-MM-dd HH:mm:ss");
  }
  public static Date string2Date(String dateString, String format) {
    Date date = null;
    SimpleDateFormat formatter = new SimpleDateFormat(format);

    try {
      if(dateString != null && !dateString.equals("")) {
        date = formatter.parse(dateString);
      }
      System.out.println(date);
      System.out.println(formatter.format(date));

    } catch (ParseException e) {
      e.printStackTrace();
    }

    return date;
  }
  public static String date2String(Date date) {
    if(date != null && !date.equals("")) { 
      return date2String(date, "yyyy-MM-dd HH:mm:ss");
    }
    
    return "";
  }

  public static String date2String(Date date, String outFormat) {
    if (date == null) {
      return ("");
    }
    String strRet = new String();
    SimpleDateFormat outDF = null;

    try {
      outDF = (SimpleDateFormat) DateFormat.getDateInstance();
      outDF.applyPattern(outFormat);
      strRet = outDF.format(date).toString();
    } catch (Exception e) {
      strRet = "ERROR::" + e.toString();
    }
    if (strRet != null) {
      strRet = strRet.replaceAll("24:00:00", "00:00:00");
    }
    return strRet;
  }
  
  public static String codeGenerator(String prefix, String digit, String counter) {
    return prefix+digit.substring(0, digit.length()-counter.length())+counter;
  }

}
