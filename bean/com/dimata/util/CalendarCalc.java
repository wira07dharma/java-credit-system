/*
 * CalendarCalc.java
 *
 * Created on April 23, 2005, 8:12 AM
 */

package com.dimata.util;

import java.util.*;

/*
 * There are 2 types of calendar in <code>CalendarCalc</code> i.e.:
 * INDONESIAN : the first day of the week is MONDAY
 * ENGLISH    : the first day of the week is SUNDAY
 *
 * @version     1.0, 04/23/05
 * @author      Edhy Putra 
 */
public class CalendarCalc {
    
    public static final int ENGLISH = 0;
    public static final int INDONESIAN = 1;
    
    private int iCalendarType = 0;
    private Date dCalendarCurrTime = new Date();
    GregorianCalendar cal = new GregorianCalendar();                

    /** 
     * Creates a new instance of CalendarCalc 
     */
    public CalendarCalc() 
    {        
    }

    /**
     * Creates a new instance of CalendarCalc
     * @param <CODE>iCalendarType</CODE>type of calendar
     */
    public CalendarCalc(int iCalendarType) 
    {
        this.iCalendarType = iCalendarType;
    }
    
    /**
     * @param dCalendarCurrTime
     * @param iSelectedWeek
     * @return First <CODE>Date</CODE> of selected week or <CODE>NULL</CODE> if any error occur
     */    
    public Date getStartDateOfTheWeek(Date dCalendarCurrTime, int iSelectedWeek)
    {
        Date dResult = null;        
        
        cal.setTime(new Date(dCalendarCurrTime.getYear(), dCalendarCurrTime.getMonth(), 1));
        int iWeekOfMonth = cal.get(cal.WEEK_OF_MONTH);
        int iDayOfWeek = cal.get(cal.DAY_OF_WEEK);        
        
        // if selected week equal to the week of calendar's current time
        if(iWeekOfMonth == iSelectedWeek)
        {
            dResult = new Date(dCalendarCurrTime.getYear(), dCalendarCurrTime.getMonth(), 1);            
        }
        
        // if selected week not equal to the week of calendar's current time
        else
        {
            int iSubstractor = iDayOfWeek - 1;
            int iFirstDateOfTheWeek = (iCalendarType == ENGLISH) ? cal.SUNDAY : cal.MONDAY;
            int iStartDate = ((iSelectedWeek-1) * cal.DAY_OF_WEEK) - iSubstractor + iFirstDateOfTheWeek;                                               
            dResult = new Date(dCalendarCurrTime.getYear(), dCalendarCurrTime.getMonth(), iStartDate);            
        }
        
        return dResult;
    }
    

    /**
     * @param dCalendarCurrTime
     * @param iSelectedWeek
     * @return Last <CODE>Date</CODE> of selected week or <CODE>NULL</CODE> if any error occur
     */    
    public Date getEndDateOfTheWeek(Date dCalendarCurrTime, int iSelectedWeek)
    {
        Date dResult = null;          
        
        cal.setTime(new Date(dCalendarCurrTime.getYear(), dCalendarCurrTime.getMonth(), 1));        
        int iDayOfMonth = cal.getActualMaximum(cal.DAY_OF_MONTH); 
        int iWeekOfMonth = cal.get(cal.WEEK_OF_MONTH);
        int iDayOfWeek = cal.get(cal.DAY_OF_WEEK);    
        int iFirstDateOfTheWeek = (iCalendarType == ENGLISH) ? cal.SUNDAY : cal.MONDAY;
        
        // if selected week equal to the week of calendar's current time
        if(iWeekOfMonth == iSelectedWeek)
        {             
            int iDayAmountOfFirstWeek = cal.DAY_OF_WEEK - iDayOfWeek + iFirstDateOfTheWeek;
            dResult = new Date(dCalendarCurrTime.getYear(), dCalendarCurrTime.getMonth(), iDayAmountOfFirstWeek);            
        }
        
        // if selected week not equal to the week of calendar's current time
        else
        {
            int iSubstractor = iDayOfWeek - 1;            
            int iEndDate = ((iSelectedWeek-1) * cal.DAY_OF_WEEK) - iSubstractor + (cal.DAY_OF_WEEK - 1) + iFirstDateOfTheWeek;                                               
            iEndDate = (iEndDate > iDayOfMonth) ? iDayOfMonth : iEndDate;
            dResult = new Date(dCalendarCurrTime.getYear(), dCalendarCurrTime.getMonth(), iEndDate);            
        }
        
        return dResult;
    }
    
}
