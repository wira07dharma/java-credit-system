 /* Generated by Together */
package com.dimata.common.session.contact;

import com.dimata.common.db.*;
import java.util.*;
import java.sql.*;
import com.dimata.common.entity.contact.*;

public class SessContactClass {

  public static final int TYPE_EMPLOYEE = -1;

  /**
   * this method used to get contactclass and its contact list
   */
  public static Hashtable getContactClassAndItsList(int utangType) {
    DBResultSet dbrs = null;
    Hashtable result = new Hashtable();
    Vector vectContactClass = PstContactClass.listAll();
    if (vectContactClass != null && vectContactClass.size() > 0) {
      for (int i = 0; i < vectContactClass.size(); i++) {
        ContactClass contactClass = (ContactClass) vectContactClass.get(i);
        Vector vectContList = SessContactList.getContactByClass(contactClass.getClassType(), utangType);
        result.put(String.valueOf(contactClass.getOID()), vectContList);
      }
    }
    return result;
  }

  /**
   * this method used to get contactclass and its contact list
   */
  public static Hashtable getEmployeeAndItsList(int utangType) {
    DBResultSet dbrs = null;
    Hashtable result = new Hashtable();
    Vector vectContList = SessContactList.getContactByEmployeeId(utangType);
    result.put(String.valueOf(TYPE_EMPLOYEE), vectContList);
    return result;
  }

  public static void main(String[] args) {
    //Hashtable hashClass = getContactClassAndItsList(1);
    Hashtable hashClass = getEmployeeAndItsList(4);
    Vector vectContactClass = PstContactClass.listAll();
    if (vectContactClass != null && vectContactClass.size() > 0) {
      for (int i = 0; i < vectContactClass.size(); i++) {
        ContactClass contactClass = (ContactClass) vectContactClass.get(i);
        if (hashClass != null && hashClass.size() > 0) {
          Vector vectContactList = (Vector) hashClass.get("" + contactClass.getOID());
          if (vectContactList != null && vectContactList.size() > 0) {
            for (int j = 0; j < vectContactList.size(); i++) {
              ContactList contact = (ContactList) vectContactList.get(j);
              System.out.println("OID : " + contact.getOID());
              System.out.println("Person : " + contact.getPersonName());
              System.out.println("Comp : " + contact.getCompName());
            }
          }
        }
      }
    }
  }

  public static boolean checkContactClass(int iClassType) {
    DBResultSet dbrs = null;
    boolean checkContact = false;
    long lCntClassId = 0;
    try {
      String sql = " SELECT " + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]
              + " FROM " + PstContactClass.TBL_CONTACT_CLASS
              + " WHERE " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = " + iClassType;

      dbrs = DBHandler.execQueryResult(sql);
      ResultSet rs = dbrs.getResultSet();
      while (rs.next()) {
        lCntClassId = rs.getLong(1);
      }

      if (lCntClassId != 0) {
        checkContact = true;
      }

    } catch (Exception e) {
      System.out.println("Exception on checkContactClass() ::: " + e.toString());
      e.printStackTrace();
    }
    return checkContact;
  }

  public static Vector getIdContactClass() {
    DBResultSet dbrs = null;
    Vector vResult = new Vector(1, 1);
    try {
      String sql = " SELECT " + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]
              + " FROM " + PstContactClass.TBL_CONTACT_CLASS;

      //System.out.println("SQL getIdContactClass() :::: "+sql);
      dbrs = DBHandler.execQueryResult(sql);
      ResultSet rs = dbrs.getResultSet();
      while (rs.next()) {
        long idCntClass = rs.getLong(1);
        vResult.add("" + idCntClass);
      }
      rs.close();
    } catch (Exception e) {
      vResult = new Vector(1, 1);
      System.out.println("Exception on getIdContactClass() ::: " + e.toString());
      e.printStackTrace();
    }
    return vResult;
  }

  public static int updateSeries() {
    int iResult = 0;
    try {
      Vector vIdContactClass = (Vector) getIdContactClass();
      if (vIdContactClass != null && vIdContactClass.size() > 0) {
        for (int i = 0; i < vIdContactClass.size(); i++) {
          long idContClass = Long.parseLong(vIdContactClass.get(i).toString());
          String sql = " UPDATE " + PstContactClass.TBL_CONTACT_CLASS
                  + " SET " + PstContactClass.fieldNames[PstContactClass.FLD_SERIES_NUMBER]
                  + " = " + i
                  + " WHERE " + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]
                  + " = " + idContClass;
          iResult = DBHandler.execUpdate(sql);
          // System.out.println("SQL updateSeries ::: "+sql);
        }
      }
    } catch (Exception e) {
      iResult = 0;
      System.out.println("Exception on updateSeries() ::: " + e.toString());
      e.printStackTrace();
    }
    return iResult;
  }
}
