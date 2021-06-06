
/**
 * Version     : 1.0
 * Copyright   : Copyright (c) March, 2001
 * Author      : Wihita Team
 * Company     : P.T Wihita Prakasa
 * Description : Wihita Project
 *
 *
 * int a = 1056;
 * int b = 1000;
 * int x;
 *
 * x = a % b;  -> mod = 56
 * x = a / b;  -> div = 1
 *
 * in this program :
 * a known as num
 * b known as denum
 *
 * max int can be convered is 2147483647
 */


package com.dimata.util;

import com.dimata.util.lang.I_Language;
import java.util.*;

public class NumberSpeller
{

    private StringBuffer strBuffSpell;

    public NumberSpeller() {
        strBuffSpell = new StringBuffer();
    }


    /**
     * List of english basic number
     */
    private void spellBasicNumToEng(int num) {
        String inaBasicStr = new String();
       
        switch(num) {
            case 1 : strBuffSpell.append(" One"); break;
            case 2 : strBuffSpell.append(" Two"); break;
            case 3 : strBuffSpell.append(" Three"); break;
            case 4 : strBuffSpell.append(" Four"); break;
            case 5 : strBuffSpell.append(" Five"); break;
            case 6 : strBuffSpell.append(" Six"); break;
            case 7 : strBuffSpell.append(" Seven"); break;
            case 8 : strBuffSpell.append(" Eight"); break;
            case 9 : strBuffSpell.append(" Nine"); break;
            case 10: strBuffSpell.append(" Ten"); break;
            case 11: strBuffSpell.append(" Eleven"); break;
            case 12: strBuffSpell.append(" Twelve"); break;
            case 13: strBuffSpell.append(" Thirteen"); break;
            case 14: strBuffSpell.append(" Fourteen"); break;
            case 15: strBuffSpell.append(" Fifteen"); break;
            case 16: strBuffSpell.append(" Sixteen"); break;
            case 17: strBuffSpell.append(" Seventeen"); break;
            case 18: strBuffSpell.append(" Eighteen"); break;
            case 19: strBuffSpell.append(" Nineteen"); break;
            case 20: strBuffSpell.append(" Twenty"); break;
            case 30: strBuffSpell.append(" Thirty"); break;
            case 40: strBuffSpell.append(" Forty"); break;
            case 50: strBuffSpell.append(" Fifty"); break;
            case 60: strBuffSpell.append(" Sixty"); break;
            case 70: strBuffSpell.append(" Seventy"); break;
            case 80: strBuffSpell.append(" Eighty"); break;
            case 90: strBuffSpell.append(" Ninety"); break;
        }
    }
    
    private void spellBasicNumToEng(long num) {
        String inaBasicStr = new String();

            if(num == 1)strBuffSpell.append(" One");
            else if(num == 2)strBuffSpell.append(" Two"); 
            else if(num == 3) strBuffSpell.append(" Three"); 
            else if(num == 4) strBuffSpell.append(" Four"); 
            else if(num == 5)strBuffSpell.append(" Five"); 
            else if(num == 6) strBuffSpell.append(" Six"); 
            else if(num == 7)strBuffSpell.append(" Seven"); 
            else if(num == 8) strBuffSpell.append(" Eight"); 
            else if(num == 9) strBuffSpell.append(" Nine"); 
            else if(num == 10)strBuffSpell.append(" Ten"); 
            else if(num == 11)strBuffSpell.append(" Eleven"); 
            else if(num == 12)strBuffSpell.append(" Twelve"); 
            else if(num == 13)strBuffSpell.append(" Thirteen"); 
            else if(num == 14)strBuffSpell.append(" Fourteen"); 
            else if(num == 15)strBuffSpell.append(" Fifteen"); 
            else if(num == 16)strBuffSpell.append(" Sixteen"); 
            else if(num == 17)strBuffSpell.append(" Seventeen"); 
            else if(num == 18)strBuffSpell.append(" Eighteen"); 
            else if(num == 19)strBuffSpell.append(" Nineteen"); 
            else if(num == 20)strBuffSpell.append(" Twenty"); 
            else if(num == 30)strBuffSpell.append(" Thirty");
            else if(num == 40)strBuffSpell.append(" Forty"); 
            else if(num == 50)strBuffSpell.append(" Fifty"); 
            else if(num == 60)strBuffSpell.append(" Sixty"); 
            else if(num == 70)strBuffSpell.append(" Seventy"); 
            else if(num == 80)strBuffSpell.append(" Eighty"); 
            else if(num == 90)strBuffSpell.append(" Ninety");
    }
    
    
    /**
     * List of Indonesian basic number
     */
    private void spellBasicNumToIna(int num) { 
        String inaBasicStr = new String();

        switch(num) {
            case 1 : strBuffSpell.append(" Satu"); break;
            case 2 : strBuffSpell.append(" Dua"); break;
            case 3 : strBuffSpell.append(" Tiga"); break;
            case 4 : strBuffSpell.append(" Empat"); break;
            case 5 : strBuffSpell.append(" Lima"); break;
            case 6 : strBuffSpell.append(" Enam"); break;
            case 7 : strBuffSpell.append(" Tujuh"); break;
            case 8 : strBuffSpell.append(" Delapan"); break;
            case 9 : strBuffSpell.append(" Sembilan"); break;
            case 10: strBuffSpell.append(" Sepuluh"); break;
            case 11: strBuffSpell.append(" Sebelas"); break;
            case 100: strBuffSpell.append(" Seratus"); break;
            case 1000: strBuffSpell.append(" Seribu"); break;
        }
    }



    /**
     * Clear the spell buffer, to get to actual spalled string
     */
    private void reset() {
        strBuffSpell.delete(0, strBuffSpell.length());
    }



    private void spellNumToEng(int num) {
        int denum = 0;
        String str = new String();
        Integer numObj = new Integer(num);

        if(num > numObj.MAX_VALUE || num < 0) {
            strBuffSpell.append("ERROR::Invalid integer value to be spelled, value range: 0 - " + numObj.MAX_VALUE);
            return;
        }

        if(num < 20) {
            spellBasicNumToEng(num);
        } else {
            if(num < 100 && (num / 10 < 10)) {
                spellBasicNumToEng((num / 10) * 10);
                spellNumToEng(num % 10);
            } else {
                if(num <= 99) denum = 10;
                else if(num <= 999) denum = 100;
                else if(num <= 999999) denum = 1000;
                else if(num <= 999999999) denum = 1000000;                 
                else denum = 1000000000;

                    spellNumToEng(num / denum);
	                switch(denum)
                    {
	                    case 100 : strBuffSpell.append(" Hundred"); break;
	                    case 1000 : strBuffSpell.append(" Thousand"); break;
	                    case 1000000 : strBuffSpell.append(" Million"); break;
	                    case 1000000000 : strBuffSpell.append(" Billion"); break;
	                }
	                spellNumToEng(num % denum);
            }
        }

        strBuffSpell.toString().trim();
    }
    
     private void spellNumToEng(long num) {
        long denum = 0;
        String str = new String();
        Double numObj = new Double(num);

        if(num > numObj.MAX_VALUE || num < 0) {
            strBuffSpell.append("ERROR::Invalid integer value to be spelled, value range: 0 - " + numObj.MAX_VALUE);
            return;
        }

        if(num < 20) {
            spellBasicNumToEng(num);
        } else {
            if(num < 100 && (num / 10 < 10)) {
                spellBasicNumToEng((num / 10) * 10);
                spellNumToEng(num % 10);
            } else {
                if(num <= 99) denum = 10;
                else if(num <= 999) denum = 100;
                else if(num <= 999999) denum = 1000;
                else if(num <= 999999999) denum = 1000000; 
                else if(num <= 999999999999L) denum = 1000000000L;
                else denum = 1000000000000L;

                    spellNumToEng(num / denum);
	               
	                if(denum == 100)strBuffSpell.append(" Hundred"); 
	                else if(denum == 1000) strBuffSpell.append(" Thousand"); 
	                else if(denum == 1000000) strBuffSpell.append(" Million");
                        else if(denum == 1000000000) strBuffSpell.append(" Billion");
                        else strBuffSpell.append(" Trillion"); 
	                
	                spellNumToEng(num % denum);
            }
        }

        strBuffSpell.toString().trim();
    }
    

    private void spellNumToIna(int num) {
        int denum = 0;
        Integer numObj = new Integer(num);

        if(num > numObj.MAX_VALUE || num < 0) {
            strBuffSpell.append("ERROR::Invalid integer value to be spelled, value range: 0 - " + numObj.MAX_VALUE);
            return;
        }

        if(num < 12 || num == 100 || num == 1000) {
            spellBasicNumToIna(num);
        } else {
            if(num < 20) {
                spellBasicNumToIna(num % 10);
                strBuffSpell.append(" Belas");
            } else {
                if(num <= 99) denum = 10;
                else if(num <= 999) denum = 100;
                else if(num <= 999999) denum = 1000;
                else if(num <= 999999999) denum = 1000000;
                else denum = 1000000000;

                if((num / denum == 1) && (denum == 100)) {
                    strBuffSpell.append(" Seratus");
                    spellNumToIna(num % denum);
                } else {
                    if((num / denum == 1) && (denum == 1000)) {
                        strBuffSpell.append(" Seribu");
                        spellNumToIna(num % denum);
                    } else {
                        spellNumToIna(num / denum);
                        switch(denum) {
                            case 10 : strBuffSpell.append(" Puluh"); break;
                            case 100 : strBuffSpell.append(" Ratus"); break;
                            case 1000 : strBuffSpell.append(" Ribu"); break;
                            case 1000000 : strBuffSpell.append(" Juta"); break;
                            case 1000000000 : strBuffSpell.append(" Milyar"); break;
                        }
                        spellNumToIna(num % denum);
                    }
                }
            }
        }

        strBuffSpell.toString().trim();
    }

    public String spellNumberToIna(int num) {
        this.reset();
        this.spellNumToIna(num);
        return this.strBuffSpell.toString();
    }

    public String spellNumberToEng(int num) {
        this.reset();
        this.spellNumToEng(num);
        return this.strBuffSpell.toString();
    }
    
    
    public static String specialSpeller(double dNumberToSpell, int iLanguage){
	String sResult = "";
	try{
	    if(iLanguage == I_Language.LANGUAGE_DEFAULT){
		if(dNumberToSpell >= 1000 && dNumberToSpell < 1000000){
		    sResult = "Ribuan";
		}else if(dNumberToSpell >= 1000000 && dNumberToSpell < 1000000000){
		    sResult = "Jutaan";
		}else if(dNumberToSpell >= 1000000000 && dNumberToSpell < 1000000000000L){
		    sResult = "Milyaran";
		}else if(dNumberToSpell >= 1000000000000L){
		    sResult = "Triliun";
		}
	    }else{
		if(dNumberToSpell >= 1000 && dNumberToSpell < 1000000){
		    sResult = "Thousand";
		}else if(dNumberToSpell >= 1000000 && dNumberToSpell < 1000000000){
		    sResult = "Million";
		}else if(dNumberToSpell >= 1000000000 && dNumberToSpell < 1000000000000L){
		    sResult = "Billion";
		}else if(dNumberToSpell >= 1000000000000L){
		    sResult = "Trilion";
		}
	    }
	}catch(Exception e){}
	return sResult;
    }
    
     public String spellNumberToEngLong(long num) {
        this.reset();
        this.spellNumToEng(num);
        return this.strBuffSpell.toString();
    }

    public String spellNumberToIna(double num) {

        String numStr = String.valueOf(num);
        System.out.println(numStr);
        StringTokenizer strToken = new StringTokenizer(numStr, ".");

		String firstStr = strToken.nextToken();
        System.out.println(firstStr);
        String lastStr = strToken.nextToken();
        System.out.println(lastStr);

        int firstInt = Integer.parseInt(firstStr);
        int lastInt = Integer.parseInt(lastStr);

        if(firstInt==0 && lastInt>0){
        	return "Nol Koma "+spellNumberToIna(lastInt);
        }

        if(firstInt==0 && lastInt==0){
            return "Nol";
        }

        if(firstInt>0 && lastInt==0){
            return spellNumberToIna(firstInt);
        }

        if(firstInt>0 && lastInt>0){
            return spellNumberToIna(firstInt)+" Koma "+spellNumberToIna(lastInt);
        }
        else{
            return "";
        }

    }

	public String spellNumberToEng(double num) {

        //String numStr = String.valueOf(num);
        String numStr = Formater.formatNumber(num,"###.00");
        System.out.println(numStr);
        StringTokenizer strToken = new StringTokenizer(numStr, ".");

		String firstStr = strToken.nextToken();
        System.out.println(firstStr);
        String lastStr = strToken.nextToken();
        System.out.println(lastStr);

        int firstInt = Integer.parseInt(firstStr);
        int lastInt = Integer.parseInt(lastStr);

        if(firstInt==0 && lastInt>0){
        	return "Zero Point "+spellNumberToEng(lastInt);
        }

        if(firstInt==0 && lastInt==0){
            return "Zero";
        }

        if(firstInt>0 && lastInt==0){
            return spellNumberToEng(firstInt);
        }

        if(firstInt>0 && lastInt>0){
            return spellNumberToEng(firstInt)+" Point "+spellNumberToEng(lastInt);
        }
        else{
            return "";
        }

    }
        
        public String spellNumberToEngLong1(double num) {

        //String numStr = String.valueOf(num);
        String numStr = Formater.formatNumber(num,"###.00");
        System.out.println(numStr);
        StringTokenizer strToken = new StringTokenizer(numStr, ".");

        String firstStr = strToken.nextToken();
        System.out.println(firstStr);
        String lastStr = strToken.nextToken();
        System.out.println(lastStr);

        int firstLong = Integer.parseInt(firstStr);
        int lastLong = Integer.parseInt(lastStr);

        if(firstLong==0 && lastLong>0){
        	return "Zero Point "+spellNumberToEngLong(lastLong);
        }

        if(firstLong==0 && lastLong==0){
            return "Zero";
        }

        if(firstLong>0 && lastLong==0){
            return spellNumberToEngLong(firstLong);
        }

        if(firstLong>0 && lastLong>0){
            return spellNumberToEngLong(firstLong)+" Point "+spellNumberToEngLong(lastLong);
        }
        else{
            return "";
        }

    }
        
       

    public String spellNumberToIna(float num) {

        String numStr = String.valueOf(num);
        System.out.println(numStr);
        StringTokenizer strToken = new StringTokenizer(numStr, ".");

		String firstStr = strToken.nextToken();
        System.out.println(firstStr);
        String lastStr = strToken.nextToken();
        System.out.println(lastStr);

        int firstInt = Integer.parseInt(firstStr);
        int lastInt = Integer.parseInt(lastStr);

        if(firstInt==0 && lastInt>0){
        	return "Nol Koma "+spellNumberToIna(lastInt);
        }

        if(firstInt==0 && lastInt==0){
            return "Nol";
        }

        if(firstInt>0 && lastInt==0){
            return spellNumberToIna(firstInt);
        }

        if(firstInt>0 && lastInt>0){
            return spellNumberToIna(firstInt)+" Koma "+spellNumberToIna(lastInt);
        }
        else{
            return "";
        }

    }

	public String spellNumberToEng(float num) {

        String numStr = String.valueOf(num);
        System.out.println(numStr);
        StringTokenizer strToken = new StringTokenizer(numStr, ".");

		String firstStr = strToken.nextToken();
        System.out.println(firstStr);
        String lastStr = strToken.nextToken();
        System.out.println(lastStr);

        int firstInt = Integer.parseInt(firstStr);
        int lastInt = Integer.parseInt(lastStr);

        if(firstInt==0 && lastInt>0){
        	return "Zero Point "+spellNumberToEng(lastInt);
        }

        if(firstInt==0 && lastInt==0){
            return "Zero";
        }

        if(firstInt>0 && lastInt==0){
            return spellNumberToEng(firstInt);
        }

        if(firstInt>0 && lastInt>0){
            return spellNumberToEng(firstInt)+" Point "+spellNumberToEng(lastInt);
        }
        else{
            return "";
        }

    }

        public static void main(String[] args){
            NumberSpeller numberSpeller = new NumberSpeller();                 
            String longNumber = numberSpeller.spellNumberToEngLong(991321987654321L);
            System.out.println(longNumber);
        }
} // end of NumberSpeller