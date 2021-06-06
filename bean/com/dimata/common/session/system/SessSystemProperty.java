/*
 * SessSystemProperty.java
 *
 * Created on April 30, 2002, 10:11 AM
 */

package com.dimata.common.session.system;

import com.dimata.common.entity.system.*;

public class SessSystemProperty {

    
    public static boolean loaded      = false;
    public static String[] groups = {"APPLICATION SETUP"};    
    public static String[][] subGroups = {     
        {"Application"}        
    };

    public static String[] systemPropsAISO = {"BOOK_TYPE","BOOK_TYPE_SYMBOL","GENERAL_CONTACT_ID","AISO_GENERAL_CONTACT_ID","GEN_CONTACT_ID_CLIENT",  
                          "SPECIAL_JOURNAL_DEPT","CASH_PAYMENT_SYSTEM_ID","LOCAL_DAILY_CURR_ID","TRAVEL_AGENT","CORPORATE","DOT_COM",
                          "GOVERMENT","WALK_IN", "IJ_DEFAULT_DEPARTMENT_OID","SELF_SUPPLIER_ID","AUTO_REC_FA",
                          "COMPANY_NAME","COMPANY_ADDRESS","COMPANY_PHONE","COMPANY_CITY","PERIOD_INTERVAL",
                          "LOC_CODE",
                            "ACC_BANK_NAME",
                            "ACC_BANK_NO",
                            "ACC_FOR_PETTY_CASH",
                            "ACTIVE_DURATION",
                            "BANK_NAME",
                            "BOOK_TYPE_IDR",
                            "BOOK_TYPE_USD",
                            "CHECK_BOX_CONTACT",
                            "COMMAND_BACK",
                            "FIXED_ASSETS_ONLY",
                            "ICON_SEARCH_CONTACT",
                            "INFORMATION",
                            "JOURNAL_BASE_ON",
                            "LAST_ENTRY_DURATION",
                            "PERIOD_ACTIVITY_INTERVAL",
                            "REPORT_ON",
                            "UPDATE_JOURNAL",
                            "USE_DATE_PICKER",
                            "USE_JOURNAL_DISTRIBUTION", "IJ_ROOM_DEPARTMENT_ID","IJ_TELEPHONE_DEPARTMENT_ID",
                            "IJ_ROOM_CLASSES_DEPARTMENT_ID_MAP", /* map untuk room class id ke department contoh :   Oid Room Class Manggis Villa => oid Department dari Puri Bagus Manggis*/
                            "IJ_DFLT_INCL_BREAKFST_DEPARTMENT_ID",
                            "IJ_ROOM_DEP_TO_INCL_BREAKFST_DEP_ID_MAP",
                            "LOGBOOK_COMPANY_ID",
                            "LOGBOOK_COMPANY_PWD",
                            "CLOSING_ANNUAL_MONTH",
                            "NOMINAL_UNBALANCE", "CLOSING_MODE_EARNING", "LIMIT_DATE_DEPRECIATION", "IJ_BACKOFFICE_SYSTEM"
                        };
    
    public static String[] systemPropsAISONote = {"Book Type of accounting system OID: contoh 1= Rp. 2=USD","Symbol dari currency yang dijadikan book type", "Oid of General Contact ID for non specific company/personal",
                           "Oid of General Contact ID for non specific cucompany/personal","Oid of General Contact ID for non specific customer",  
                          "Department ID for Special Journal","Payment System ID for cash payment","Local currency Id","Contact Id for travel contact category","Contact Id for coorporate contact category","Contact Id for .com contact category",
                          "Contact Id for goverment contact category","Id for type Walk In Reservation ( special for Hanoman Integration)", "Default department Id for Interactive Journal","contact id for your company use for supplier","Auto receive for asset purchase",
                          "COMPANY_NAME","COMPANY_ADDRESS","COMPANY_PHONE","COMPANY_CITY","PERIOD_INTERVAL",
                          "Location code for special journal",
                            "Bank Name of Company Account",
                            "Number of  of Company Bank Account",
                            "Account Id for Petty Cash ( Only used for special journal) ; disable =0",
                            "Length in minutes of active duration before session time out",
                            "Account Name of Company Account",
                            "Id of IDR book type : default = 1",
                            "Id of USD book type : default = 2",
                            "For special journal only: Y=check box contact list and disable selection. N=open",
                            "idex of command back",
                            "0= Aiso is enable to provide all modules, 1=Aiso is enable only for asset management",
                            "Y=enable icon for searching contact. N=Disable",
                            "Information shown on header. Blank=\"\" is to hide",
                            "For special journal only: 1= base on details. 0= base on CoA",
                            "duration in days , that entry is still enable, e.g 15 = 15 days",
                            "Length of Period in Month; 1= monthly interval",
                            "Number for multiply value on report; e.g. 1= number is represent fully in report; 1000= number on report is to be multiply by 1000",
                            "Y=enable update of journal ; N=disable update",
                            "Y=using date picker/calendar ; N= Use combo box selection for date",
                            "1=enable journal distribution on detail journal ; 0=disable", "IJ : Company Department ID for Room Division used for IJ posting : detail journal","IJ : Company Department ID for Telephone Revenue used for IJ posting",
                            "Mapping for room class id to department e.g. :   Oid Room Class Manggis Villa => oid Department of Puri Bagus Manggis ; Oid Villa Class X => Depart.  Z. : 121212121=6767756456; 232322=4545454;",
                            "Default ID of department to post include breakfast revenue",
                            "Mapping for include breakfast revenue from room department to department that provide included breakfast. e.g RoomDept => F&B Department; Dept Villa X => Dep.Catering  : 121212121=232323; 232322=4545454;",
                            "User ID/name logbook to enable you to submit online help, request, and bug report. Please call Dimata for the data",
                            "User password logbook to enable you to submit online help, request, and bug report.Please call Dimata for the data",
                            "Month of Closing Annual : 1 = January, 2 = February, ... 12=Desember , if 0 or not defined => 12=Desember",
                            "Setting nominal high for unbalance bill,ex differnt : 0.1 or 0.01 ",
                            "Closing Mode: 0=closing journal step 1(P/L=>Period Earning), step 2(Period Earning=>Annual) on current period, step 3(annual closing: Annual Earning=>Returned Earning) on next period ; Mode 1= step 2 and step 3 on next period",
                            "Limit of assets aquisation date  before that date on a month the assets depriciations will be calculated : 0= default date 15, -1=no limit , all asset in the month depreciated, ##= a spec. date",
                            "list of enable IJ back office system, e.g. :  1&2&3 ( ProChainPOS , Hanoman, Sedana) : 0=ProManufacturer, 1=ProChain POS, 2= Hanoman,3= Dimata Sedana"
                        };
    
    
    /**
     *  static and permanent system property should be hard coded here
     */
    public static final String PROP_APPURL      =  "http://192.168.0.10:8080"; //own
	//public static final String PROP_APPURL      =  "http://192.168.0.16:8080";//server

    /**
     *  loadable properties are loaded here
     */    
  /*  public static String ADMIN_EMAIL        = "Not initialized";*/
 
    public static String PROP_IMGCACHE         = "";//"C:\\tomcat\\webapps\\prochain\\imgchace\\";
    public static String MATERIAL_PERIOD       = "0";//MATERIAL_PERIOD";
    public static String LOC_TRANS_ID          = "0";
    public static String NO_COLOR_ID           = "0";
    public static String FINISH_ID             = "0";
    public static String UNFINISH_ID           = "0";
    public static String TARITA_ID             = "0";
    public static String COST_GROUP_TARITA_ID  = "0";
    

    /** Creates new SessSystemProperty */
    public SessSystemProperty() {
        if(!loaded) {            
            boolean ok = loadFromDB();
            String okStr = "OK";
            if(!ok) okStr = "FAILED";
            System.out.println("Loading system proerties ............................. ["+ okStr +"]");
            loaded = true;
        }
    } 
    
    public static int getSystemPropsAISOIdx(String sysPropName){
       for(int i=0; i < systemPropsAISO.length ;i++){
           if(systemPropsAISO[i].equalsIgnoreCase(sysPropName)){
               return i;
           }
       }
       return -1;
    }

    public static String getSystemPropsAISONote(String sysPropName){
       for(int i=0; i < systemPropsAISO.length ;i++){
           if(systemPropsAISO[i].equalsIgnoreCase(sysPropName)){
               return systemPropsAISONote[i];
           }
       }
       return "";
    }  
    
    public boolean loadFromDB() {
        try {
            PstSystemProperty.loadFromDbToHash(systemPropsAISO);
            /*PROP_IMGCACHE    = PstSystemProperty.getValueByName("PROP_IMGCACHE");
            LOC_TRANS_ID	 = PstSystemProperty.getValueByName("LOC_TRANS_ID");
            NO_COLOR_ID      = PstSystemProperty.getValueByName("NO_COLOR_ID");
            FINISH_ID      = PstSystemProperty.getValueByName("FINISH_PACKED_ID");
            UNFINISH_ID     = PstSystemProperty.getValueByName("UNFINISH_ID");
            //TARITA_ID     = PstSystemProperty.getValueByName("TARITA_ID");
            TARITA_ID     = PstSystemProperty.getValueByName("COMPANY_ID");
            //COST_GROUP_TARITA_ID = PstSystemProperty.getValueByName("COST_GROUP_TARITA_ID");
            COST_GROUP_TARITA_ID = PstSystemProperty.getValueByName("COST_GROUP_COMPANY_ID");
            */
            return true;
        }catch(Exception e) {
            return false;
        }
    }
    
    
    
    public static void main(String[] args) {
        SessSystemProperty prop = new SessSystemProperty();
    }

    

}
