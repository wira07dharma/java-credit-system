/* 
 * Ctrl Name  		:  CtrlContactList.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  		: karya 
 * @version  		: 01 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.dimata.common.form.contact;

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
//import com.dimata.prochain02.db.*;
import com.dimata.common.entity.contact.*;
//import com.dimata.prochain.entity.catalog.PstProduct;
import com.dimata.services.objsynchxnodes.DSJ_ObjSynch;

public class CtrlContactList extends Control implements I_Language 
{
	public static int RSLT_OK = 0;
	public static int RSLT_UNKNOWN_ERROR = 1;
	public static int RSLT_EST_CODE_EXIST = 2;
	public static int RSLT_FORM_INCOMPLETE = 3;
        public static int RSLT_EXP_CONTACT_CLASS = 4;

	public static String[][] resultText = {
		{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap", "Type kontak belum diisi"},
		{"Succes", "Can not process", "Estimation code exist", "Data incomplete","Contact Class not select"}
	};

	private int start;
	private String msgString;
	private ContactList contactList;
	private PstContactList pstContactList;
	private FrmContactList frmContactList;
	int language = LANGUAGE_DEFAULT;

	public CtrlContactList(HttpServletRequest request){
		msgString = "";
		contactList = new ContactList();
		try{ 
			pstContactList = new PstContactList(0);
		}catch(Exception e){;}
		frmContactList = new FrmContactList(request, contactList);
	}

	private String getSystemMessage(int msgCode){
		switch (msgCode){
			case I_DBExceptionInfo.MULTIPLE_ID :
				this.frmContactList.addError(frmContactList.FRM_FIELD_CONTACT_ID, resultText[language][RSLT_EST_CODE_EXIST] );
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

	public ContactList getContactList() { return contactList; } 

	public FrmContactList getForm() { return frmContactList; }

	public String getMessage(){ return msgString; }
        
        private String getErrorMassage(int iIndex){
            return resultText[language][iIndex];
        }

	public int getStart() { return start; }

	public int action(int cmd , long oidContactList, Vector vectClassAssign, boolean sameCode){
                System.out.println("----------------oidContactList : "+oidContactList);
		msgString = "";
		int excCode = I_DBExceptionInfo.NO_EXCEPTION;
		int rsCode = RSLT_OK;
		switch(cmd){
			case Command.ADD :
				break;

			case Command.SAVE :
				if(oidContactList != 0){
					try{
                                            contactList = PstContactList.fetchExc(oidContactList);
					}catch(Exception exc){
					}
				}

				frmContactList.requestEntityObject(contactList);
                                if(!sameCode){
                                        boolean bool = PstContactList.cekCodeContact(contactList.getContactCode(),oidContactList);
                                        if(bool){
                                            frmContactList.addError(frmContactList.FRM_FIELD_CONTACT_CODE,"Company code is alredy defined.");
                                        }    
                                }
                                
                                if(frmContactList.errorSize() > 0){
                                    msgString = resultText[language][RSLT_FORM_INCOMPLETE];
                                    return RSLT_FORM_INCOMPLETE;
                                }
                                
                                if(String.valueOf(contactList.getContactType()) == null){
                                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                                    return RSLT_FORM_INCOMPLETE ;
                                }
                                
                                System.out.println("vectClassAssign.size() :::: "+vectClassAssign.size());
                                if(vectClassAssign == null || vectClassAssign.size() == 0){
                                    msgString = getErrorMassage(RSLT_EXP_CONTACT_CLASS);
                                    return RSLT_EXP_CONTACT_CLASS ;
                                }
                                
				if(frmContactList.errorSize()>0) {
					msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
					return RSLT_FORM_INCOMPLETE ;
				}

				if(contactList.getOID()==0){
					try{
						long oid = pstContactList.insertExc(this.contactList);
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
						long oid = pstContactList.updateExc(this.contactList);
					}catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					}catch (Exception exc){
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN); 
					}

				}

                                PstContactClassAssign.deleteClassAssign(oidContactList);
                                if((vectClassAssign!=null)&&(vectClassAssign.size()>0)){
                                        for(int i=0;i<vectClassAssign.size();i++){
                                        ContactClassAssign cntClsAssign = (ContactClassAssign)vectClassAssign.get(i);
                                        cntClsAssign.setContactId(contactList.getOID());                                        
                                        PstContactClassAssign.insertExc(cntClsAssign);
                                    }
                                }

				break;

			case Command.EDIT :
				if (oidContactList != 0) {
					try {
						contactList = PstContactList.fetchExc(oidContactList);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.ASK :
				if (oidContactList != 0) {
					try {
						contactList = PstContactList.fetchExc(oidContactList);
					} catch (DBException dbexc){
						excCode = dbexc.getErrorCode();
						msgString = getSystemMessage(excCode);
					} catch (Exception exc){ 
						msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
					}
				}
				break;

			case Command.DELETE :
				if (oidContactList != 0){
					try{
						long oid = PstContactList.deleteExc(oidContactList);
						if(oid!=0){
							msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
							excCode = RSLT_OK;
						}else{
							msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
							excCode = RSLT_FORM_INCOMPLETE;
						}
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
        
        
        /*public int action(int cmd , long oidContactList, Vector vectClassAssign){
        msgString = "";
        int excCode = I_DBExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch(cmd){
            case Command.ADD :
                break;
                
            case Command.SAVE :
                if(oidContactList != 0){
                    try{
                        contactList = PstContactList.fetchExc(oidContactList);
                    }catch(Exception exc){
                    }
                }
                
                frmContactList.requestEntityObject(contactList);
                
                boolean bool = PstContactList.cekCodeContact(contactList.getContactCode(),oidContactList);
                if(bool)
                    frmContactList.addError(frmContactList.FRM_FIELD_CONTACT_CODE,"Code is alredy defined for another company or person.");
                
                if(frmContactList.errorSize()>0) {
                    msgString = FRMMessage.getMsg(FRMMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE ;
                }
                
                if(contactList.getOID()==0){
                    try{
                        long oid = pstContactList.insertExc(this.contactList);
                        if(oid != 0){
                            DSJ_ObjSynch.addObjToSynch(oid, contactList.getClass().getName(), Command.ADD);
                        }
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
                        ContactList oldContactList = PstContactList.fetchExc(oidContactList);
                        String oldCode = oldContactList.getContactCode();                        
                        if((oldCode != null) && (!oldCode.equals(contactList.getContactCode()))){                            
                                PstProduct.updateConsCodeByContact(oldCode, contactList.getContactCode(), contactList.getOID());                            
                        }
                        
                        long oid = pstContactList.updateExc(this.contactList);
                        
                        if(oid != 0){
                            DSJ_ObjSynch.addObjToSynch(oid, contactList.getClass().getName(), Command.UPDATE);
                        }
                    }catch (DBException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    }catch (Exception exc){
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                    
                }
                    
                PstContactClassAssign.deleteClassAssign(contactList.getOID());
                
                if((vectClassAssign!=null)&&(vectClassAssign.size()>0)){
                    for(int i=0;i<vectClassAssign.size();i++){
                        ContactClassAssign cntClsAssign = (ContactClassAssign)vectClassAssign.get(i);
                        cntClsAssign.setContactId(contactList.getOID());
                        PstContactClassAssign.insertExc(cntClsAssign);
                    }
                }
                
                break;
                
            case Command.EDIT :
                if (oidContactList != 0) {
                    try {
                        contactList = PstContactList.fetchExc(oidContactList);
                    } catch (DBException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc){
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.ASK :
                if (oidContactList != 0) {
                    try {
                        contactList = PstContactList.fetchExc(oidContactList);
                    } catch (DBException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc){
                        msgString = getSystemMessage(I_DBExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case Command.DELETE :
                if (oidContactList != 0){
                    try{                        
                        long oid = PstContactList.deleteExc(oidContactList);
                        if(oid!=0){
                            DSJ_ObjSynch.addObjToSynch(oid, contactList.getClass().getName(), Command.DELETE);
                            msgString = FRMMessage.getMessage(FRMMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        }else{
                            msgString = FRMMessage.getMessage(FRMMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
                        }
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
    }*/
        
       
        
}
