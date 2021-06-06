/*
 * CtrlRack.java
 *
 * Created on April 26, 2006, 10:50 AM
 */

package com.dimata.common.form.location;

/**
 *
 * @author  hendra
 */

/* java package */ 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* dimata package */
import com.dimata.util.*;
import com.dimata.util.lang.*;
/* qdep package */
import com.dimata.qdep.system.*;
import com.dimata.qdep.form.*;
import com.dimata.common.db.*;
/* project package */
//import com.dimata.material.entity.masterdata.*;
//import com.dimata.services.objsynchxnodes.*;

import com.dimata.common.entity.location.*;

//integrasi BO dengan POS
//import com.dimata.ObjLink.BOPos.OutletLink;
//import com.dimata.interfaces.BOPos.I_Outlet;

public class CtrlRack extends Control implements I_Language 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;

	public static String[][] resultText = {
		{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
	};

	private int start;
	private String msgString;
	private Rack rack;
	private PstRack pstRack;
	private FrmRack frmRack;
	int language = LANGUAGE_DEFAULT;

	public CtrlRack(HttpServletRequest request){
		msgString = "";
		rack = new Rack();
		try{
			pstRack = new PstRack(0);
		}catch(Exception e){;}
		frmRack = new FrmRack(request);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_DBExceptionInfo.MULTIPLE_ID :
				//this.frmRack.addError(frmRack.FRM_FIELD_Rack_ID, resultText[language][RSLT_EST_CODE_EXIST] );
				return resultText[language][RSLT_EST_CODE_EXIST];
			default:
				return resultText[language][RSLT_UNKNOWN_ERROR]; 
		}
	}

	private int getControlMsgId(int msgCode){
		switch (msgCode){
			case I_DBExceptionInfo.MULTIPLE_ID :
				return RSLT_EST_CODE_EXIST;
			default:
				return RSLT_UNKNOWN_ERROR;
		}
	}

	public int getLanguage(){ return language; }

	public void setLanguage(int language){ this.language = language; }

	public Rack getRack() { return rack; } 

	public FrmRack getForm() { return frmRack; }

	public String getMessage(){ return msgString; }

	public int getStart() { return start; }

	public int action(int cmd , long oidRack){
		msgString = "";
		int excCode = I_DBExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case Command.ADD :
				break;

			case Command.SAVE :
                            //String strCode = "";
                            //String strName = "";
				if(oidRack != 0){
					try{
						rack = PstRack.fetchExc(oidRack);
                                                //strCode = rack.getRackCode();
                                                //strName = rack.getRackName();
					}catch(Exception exc){
                                                System.out.println("Exception exc : "+exc.toString());
					}
				}

				frmRack.requestEntityObject(rack);
                                //System.out.println("rack.getParentId() : "+rack.getParentRackId());

				if(frmRack.errorSize()>0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

                                //System.out.println("code : '"+strCode+"' = '"+rack.getCode()+"'");
                                //System.out.println("name : '"+strName+"' = '"+rack.getName()+"'");

                       

				if(rack.getOID()==0){
					try{
						long oid = pstRack.insertExc(this.rack);
                                                
                                        }catch(DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
						return getControlMsgId(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
						return getControlMsgId(I_DBExceptionInfo.UNKNOWN);
					}

				}else{
					try {
						long oid = pstRack.updateExc(this.rack);
                                                
					}catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN); 
					}

				}
				break;

			case Command.EDIT :
				if (oidRack != 0) {
					try {
						System.out.println("Before Fetch Rack OID = " + rack.getOID());
                                                rack = PstRack.fetchExc(oidRack);
                                                System.out.println("After Rack OID = " + rack.getOID());
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK :
				if (oidRack != 0) {
					try {
						rack = PstRack.fetchExc(oidRack);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.DELETE :

                            if (oidRack != 0){
                                    
					try{
						//long oid = PstRack.deleteExc(oidRack);
                                                //PstMatMinQty.deleteByRackId(oidRack); 
						long oid = PstRack.deleteExc(oidRack);
						
					}catch(DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch(Exception exc){	
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			default :

		}
		return rsCode;
	}
}