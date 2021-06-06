package com.dimata.posbo.session.purchasing;
import java.util.*;
import java.util.Date;
import java.sql.*;
import com.dimata.posbo.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.*;
import com.dimata.posbo.entity.search.*;
import com.dimata.posbo.entity.purchasing.*;
import com.dimata.posbo.entity.masterdata.*;
import com.dimata.common.entity.contact.*;
import com.dimata.common.entity.location.*;

public class SessPurchaseOrder {

    public static final String className = I_DocType.DOCTYPE_CLASSNAME;

    public static final String SESS_SRC_ORDERMATERIAL = "SESSION_SRC_ORDERMATERIAL";
    public static final String SESS_SRC_ORDERMARKET = "SESSION_SRC_ORDERMARKET";
    public static final String SESS_SRC_ORDERASSET = "SESSION_SRC_ORDERASSET";

    /**
     * this method used to list purchase order based on following parameter
     * @param : object SrcPurchaseOrder
     * @param : int docType
     * @param : int start
     * @param : int recordToGet
     */
    public static Vector searchPurchaseOrderMaterial(SrcPurchaseOrder srcpurchaseorder, int docType, int start, int recordToGet) {
        Vector vectOrderCode = LogicParser.textSentence(srcpurchaseorder.getPrmnumber());
        for (int i = 0; i < vectOrderCode.size(); i++) {
            String name = (String) vectOrderCode.get(i);
            if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0])))
                vectOrderCode.remove(i);
        }

        Vector vectOrderVendor = LogicParser.textSentence(srcpurchaseorder.getVendorname());
        for (int i = 0; i < vectOrderVendor.size(); i++) {
            String name = (String) vectOrderVendor.get(i);
            if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0])))
                vectOrderVendor.remove(i);
        }
        return getPurchaseOrderMaterialList(className, docType, vectOrderCode, vectOrderVendor, srcpurchaseorder, start, recordToGet, 0);
    }

    /**
     * this method used to list purchase order based on following parameter
     * @param : object SrcPurchaseOrder
     * @param : String ponumber
     * @param : long oidVendor
     * @param : int start
     * @param : int recordToGet
     */
    public static Vector searchPurchaseOrderMaterial(SrcPurchaseOrder srcpurchaseorder, String ponumber, long oidVendor, int start, int recordToGet) {
        Vector vectOrderCode = LogicParser.textSentence(ponumber);
        for (int i = 0; i < vectOrderCode.size(); i++) {
            String name = (String) vectOrderCode.get(i);
            if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0])))
                vectOrderCode.remove(i);
        }
        return getPurchaseOrderMaterialList(className, 0, vectOrderCode, new Vector(), srcpurchaseorder, start, recordToGet, oidVendor);
    }

    /**
     * this method used to list purchase order based on following parameter
     * @param : String className
     * @param : int docType
     * @param : Vector vectNumber
     * @param : Vector vectVendor
     * @param : SrcPurchaseOrder srcpurchaseorder
     * @param : int start
     * @param : int recordToGet
     * @param : long oidVendor
     */
    public static Vector getPurchaseOrderMaterialList(String className, int docType, Vector vectNumber, Vector vectVendor, SrcPurchaseOrder srcpurchaseorder, int start, int recordToGet, long oidVendor) {
        DBResultSet dbrs = null;
        Vector result = new Vector(1, 1);
        try {
            I_PstDocType i_pstDocType = (I_PstDocType) Class.forName(className).newInstance();
            String sql = "SELECT MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID] +
                    ", MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE] +
                    ", MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_STATUS] +
                    ", MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE] +
                    ", CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] +
                    ", CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] +
                    ", CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME] +
                    ", MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_REMARK] +
                    ", MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_CURRENCY_ID] +
                    " FROM " + PstPurchaseOrder.TBL_PURCHASE_ORDER + " AS MAT" +
                    " INNER JOIN " + PstContactList.TBL_CONTACT_LIST + " AS CNT " +
                    " ON MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_SUPPLIER_ID] +
                    " = CNT." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID];

            String strPoNumber = "";
            if (vectNumber != null && vectNumber.size() > 0) {
                for (int a = 0; a < vectNumber.size(); a++) {
                    if (strPoNumber.length() != 0) {
                        strPoNumber = strPoNumber + " OR " + "(MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE] + " LIKE '%" + vectNumber.get(a) + "%')";
                    } else {
                        strPoNumber = "(MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE] + " LIKE '%" + vectNumber.get(a) + "%')";
                    }
                }
                strPoNumber = "(" + strPoNumber + ")";
            }

            String strVendor = "";
            if (vectVendor != null && vectVendor.size() > 0) {
                for (int b = 0; b < vectVendor.size(); b++) {
                    if (strVendor.length() != 0) {
                        strVendor = strVendor + " OR " + "(CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] + " LIKE '%" + vectVendor.get(b) + "%') " +
                                " OR " + "(CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE '%" + vectVendor.get(b) + "%') " +
                                " OR " + "(CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME] + " LIKE '%" + vectVendor.get(b) + "%')";
                    } else {
                        strVendor = "(CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] + " LIKE '%" + vectVendor.get(b) + "%') " +
                                " OR " + "(CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE '%" + vectVendor.get(b) + "%')" +
                                " OR " + "(CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME] + " LIKE '%" + vectVendor.get(b) + "%')";
                    }
                }
                strVendor = "(" + strVendor + ")";
            }

            String strDate = "";
            if (srcpurchaseorder.getStatusdate() != 0) {
                String startDate = Formater.formatDate(srcpurchaseorder.getPrmdatefrom(), "yyyy-MM-dd");
                String endDate = Formater.formatDate(srcpurchaseorder.getPrmdateto(), "yyyy-MM-dd");
                strDate = " MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE] + " BETWEEN '" + startDate + "' AND '" + endDate + "'";
            }

            String strStatus = "";
            if (srcpurchaseorder.getPrmstatus() != null && srcpurchaseorder.getPrmstatus().size() > 0) {
                for (int a = 0; a < srcpurchaseorder.getPrmstatus().size(); a++) {
                    if (strStatus.length() != 0) {
                        strStatus = strStatus + " OR " + "(MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_STATUS] + " =" + srcpurchaseorder.getPrmstatus().get(a) + ")";
                    } else {
                        strStatus = "(MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_STATUS] + " =" + srcpurchaseorder.getPrmstatus().get(a) + ")";
                    }
                }
                strStatus = "(" + strStatus + ")";
            }

            String strVendorId = "";
            if (oidVendor != 0) {
                strVendorId = " MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_SUPPLIER_ID] + "=" + oidVendor;
            }

            String strLocationType = "";
            if (srcpurchaseorder.getLocationType() != -1) {
                strLocationType = " MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_LOCATION_TYPE] + "=" + srcpurchaseorder.getLocationType();
            }

            String whereClause = "";
            if (strPoNumber.length() > 0)
                whereClause = strPoNumber;

            if (strVendor.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND " + strVendor;
                } else {
                    whereClause = whereClause + strVendor;
                }
            }

            if (strDate.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND " + strDate;
                } else {
                    whereClause = whereClause + strDate;
                }
            }

            if (strStatus.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND " + strStatus;
                } else {
                    whereClause = whereClause + strStatus;
                }
            }

            if (strVendorId.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND " + strVendor;
                } else {
                    whereClause = whereClause + strVendor;
                }
            }

            if (strLocationType.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND " + strLocationType;
                } else {
                    whereClause = whereClause + strLocationType;
                }
            }

            if (whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            switch (srcpurchaseorder.getSortby()) {
                case 0:
                    sql = sql + " ORDER BY MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE];
                    break;
                case 1:
                    sql = sql + " ORDER BY MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE];
                    break;
                case 2:
                    sql = sql + " ORDER BY MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_STATUS];
                    break;
                case 3:
                    sql = sql + " ORDER BY CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME];
                    break;
            }
            
            sql += ", MAT."+PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE]; /** defaultnya, list diurut berdasarkan DATE */
            sql +=  " LIMIT " + start + "," + recordToGet;

            System.out.println("sql getPurchaseOrderMaterialList: " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                PurchaseOrder purchaseOrder = new PurchaseOrder();
                ContactList contactList = new ContactList();
                Vector vt = new Vector(1, 1);

                purchaseOrder.setOID(rs.getLong(PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID]));
                purchaseOrder.setPoCode(rs.getString(PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE]));
                purchaseOrder.setPurchDate(rs.getDate(PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE]));
                purchaseOrder.setPoStatus(rs.getInt(PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_STATUS]));
                purchaseOrder.setRemark(rs.getString(PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_REMARK]));
                purchaseOrder.setCurrencyId(rs.getLong(PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_CURRENCY_ID]));
                vt.add(purchaseOrder);

                contactList.setCompName(rs.getString(PstContactList.fieldNames[PstContactList.FLD_COMP_NAME]));
                contactList.setPersonName(rs.getString(PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME]));
                contactList.setPersonLastname(rs.getString(PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME]));
                vt.add(contactList);
                result.add(vt);
            }
            rs.close();

        } catch (Exception e) {
            System.out.println("Err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }

    public static Vector getListVendor(String name, Vector vect, int start, int recordToGet) {
        String whereClause = "";
        Vector vectVendor = new Vector(1, 1);
        if ((name != null) && (name.length() > 0)) {
            vectVendor = LogicParser.textSentence(name);
            for (int i = 0; i < vectVendor.size(); i++) {
                String nameVendor = (String) vectVendor.get(i);
                if ((nameVendor.equals(LogicParser.SIGN)) || (nameVendor.equals(LogicParser.ENGLISH[LogicParser.WORD_OR])))
                    vectVendor.remove(i);
            }
        }
        return PstContactList.getListContact(vectVendor, vect, start, recordToGet);
    }

    public static int getCountListVendor(String name, Vector vect) {
        String whereClause = "";
        Vector vectVendor = new Vector(1, 1);
        if ((name != null) && (name.length() > 0)) {
            vectVendor = LogicParser.textSentence(name);
            for (int i = 0; i < vectVendor.size(); i++) {
                String nameVendor = (String) vectVendor.get(i);
                if ((nameVendor.equals(LogicParser.SIGN)) || (nameVendor.equals(LogicParser.ENGLISH[LogicParser.WORD_OR])))
                    vectVendor.remove(i);
            }
        }
        return PstContactList.getCountListContact(vectVendor, vect);
    }


    public static int getCountPurchaseOrderMaterial(SrcPurchaseOrder srcpurchaseorder, int docType) {
        if (srcpurchaseorder != null)
            System.out.println("Not null!!!");
        else
            System.out.println("Null");
        Vector vectOrderCode = LogicParser.textSentence(srcpurchaseorder.getPrmnumber());
        for (int i = 0; i < vectOrderCode.size(); i++) {
            String name = (String) vectOrderCode.get(i);
            //System.out.println("name : " + name);
            if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0])))
                vectOrderCode.remove(i);
        }

        Vector vectOrderVendor = LogicParser.textSentence(srcpurchaseorder.getVendorname());
        for (int i = 0; i < vectOrderVendor.size(); i++) {
            String name = (String) vectOrderVendor.get(i);
            //System.out.println("name : " + name);
            if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0])))
                vectOrderVendor.remove(i);
        }

        return getCountPOMaterialList(className, docType, vectOrderCode, vectOrderVendor, srcpurchaseorder, 0);
    }

    public static int getCountPurchaseOrderMaterial(String ponumber, int docType, long oidVendor) {
        SrcPurchaseOrder srcpurchaseorder = new SrcPurchaseOrder();

        Vector vectOrderCode = LogicParser.textSentence(ponumber);
        for (int i = 0; i < vectOrderCode.size(); i++) {
            String name = (String) vectOrderCode.get(i);
            if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0])))
                vectOrderCode.remove(i);
        }

        return getCountPOMaterialList(className, docType, vectOrderCode, new Vector(), srcpurchaseorder, oidVendor);
    }

    public static int getCountPurchaseOrderMaterial(SrcPurchaseOrder srcpurchaseorder, String ponumber, long oidVendor) {
        Vector vectOrderCode = LogicParser.textSentence(ponumber);
        for (int i = 0; i < vectOrderCode.size(); i++) {
            String name = (String) vectOrderCode.get(i);
            //System.out.println("name : " + name);
            if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0])))
                vectOrderCode.remove(i);
        }

        return getCountPOMaterialList(className, 0, vectOrderCode, new Vector(), srcpurchaseorder, oidVendor);
    }

    public static int getCountPOMaterialList(String className, int docType, Vector vectNumber, Vector vectVendor, SrcPurchaseOrder srcpurchaseorder, long oidVendor) {
        DBResultSet dbrs = null;
        int count = 0;
        try {

            I_PstDocType i_pstDocType = (I_PstDocType) Class.forName(className).newInstance();

            String sql = "SELECT " +
                    " COUNT(MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID] + ") AS CNT " +
                    " FROM " + PstPurchaseOrder.TBL_PURCHASE_ORDER + " AS MAT" +
                    " INNER JOIN " + PstContactList.TBL_CONTACT_LIST + " AS CNT " +
                    " ON MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_SUPPLIER_ID] +
                    " = CNT." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID];

            String strPoNumber = "";
            if (vectNumber != null && vectNumber.size() > 0) {
                for (int a = 0; a < vectNumber.size(); a++) {
                    if (strPoNumber.length() != 0) {
                        strPoNumber = strPoNumber + " OR " + "(MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE] + " LIKE '%" + vectNumber.get(a) + "%')";
                    } else {
                        strPoNumber = "(MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE] + " LIKE '%" + vectNumber.get(a) + "%')";
                    }
                }
                strPoNumber = "(" + strPoNumber + ")";
            }

            String strVendor = "";
            if (vectVendor != null && vectVendor.size() > 0) {
                for (int b = 0; b < vectVendor.size(); b++) {
                    if (strVendor.length() != 0) {
                        strVendor = strVendor + " OR " + "(CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] + " LIKE '%" + vectVendor.get(b) + "%')";
                    } else {
                        strVendor = "(CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] + " LIKE '%" + vectVendor.get(b) + "%')";
                    }
                }
                strVendor = "(" + strVendor + ")";
            }

            String strDate = "";
            if (srcpurchaseorder.getStatusdate() != 0) {
                String startDate = Formater.formatDate(srcpurchaseorder.getPrmdatefrom(), "yyyy-MM-dd");
                String endDate = Formater.formatDate(srcpurchaseorder.getPrmdateto(), "yyyy-MM-dd");
                strDate = "MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE] + " BETWEEN '" + startDate + "' AND '" + endDate + "'";
            }

            String strStatus = "";
            if (srcpurchaseorder.getPrmstatus() != null && srcpurchaseorder.getPrmstatus().size() > 0) {
                for (int a = 0; a < srcpurchaseorder.getPrmstatus().size(); a++) {
                    if (strStatus.length() != 0) {
                        strStatus = strStatus + " OR " + "(MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_STATUS] + " =" + srcpurchaseorder.getPrmstatus().get(a) + ")";
                    } else {
                        strStatus = "(MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_STATUS] + " =" + srcpurchaseorder.getPrmstatus().get(a) + ")";
                    }
                }
                strStatus = "(" + strStatus + ")";
            }

            String strVendorId = "";
            if (oidVendor != 0) {
                strVendorId = " MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_SUPPLIER_ID] + "=" + oidVendor;
            }

            String strLocationType = "";
            if (srcpurchaseorder.getLocationType() != -1) {
                strLocationType = " MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_LOCATION_TYPE] + "=" + srcpurchaseorder.getLocationType();
            }

            String whereClause = "";
            if (strPoNumber.length() > 0)
                whereClause = strPoNumber;

            if (strVendor.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND " + strVendor;
                } else {
                    whereClause = whereClause + strVendor;
                }
            }

            if (strDate.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND " + strDate;
                } else {
                    whereClause = whereClause + strDate;
                }
            }

            if (strStatus.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND " + strStatus;
                } else {
                    whereClause = whereClause + strStatus;
                }
            }

            if (strVendorId.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND " + strVendor;
                } else {
                    whereClause = whereClause + strVendor;
                }
            }

            if (strLocationType.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND " + strLocationType;
                } else {
                    whereClause = whereClause + strLocationType;
                }
            }

            if (whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                count = rs.getInt("CNT");
            }
            rs.close();

        } catch (Exception e) {
            System.out.println("Err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return count;
    }


    public static String getCodeOrderMaterial(PurchaseOrder purchaseOrder) {
        String strCode = "";
        try {
            I_PstDocType i_pstDocType = (I_PstDocType) Class.forName(className).newInstance();
            String documentCode = "PO";
            
            /** get location code; gwawan@21juni2007 */
            Vector vctLocation = PstLocation.list(0, 0, PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID]+"="+purchaseOrder.getLocationId(), "");
            Location location = (Location)vctLocation.get(0);
            
            strCode = location.getCode() + "-" +
                    getYearMonth(purchaseOrder.getPurchDate(), TYPE_GET_YEAR) +
                    "" + getYearMonth(purchaseOrder.getPurchDate(), TYPE_GET_MONTH) +
                    "-" + documentCode +
                    "-" + getCounter(purchaseOrder.getPoCodeCounter());

        } catch (Exception e) {
            System.out.println("Err : " + e.toString());
        }
        return strCode;
    }

    public static int getIntCode(PurchaseOrder purchaseOrder, Date pDate, long oid, int counter) {
        int max = 0;
        DBResultSet dbrs = null;
        Date date = new Date();
        try {
            String sql = "SELECT MAX(" + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE_COUNTER] + ") AS PMAX" +
                    " FROM " + PstPurchaseOrder.TBL_PURCHASE_ORDER +
                    " WHERE YEAR(" + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE] + ") = " + (purchaseOrder.getPurchDate().getYear() + 1900) + "" +
                    " AND MONTH(" + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE] + ") = " + (purchaseOrder.getPurchDate().getMonth() + 1) +
                    " AND " + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID] + " <> '" + oid + "'";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                max = rs.getInt("PMAX");
            }
            rs.close();

            if (oid == 0) {
                max = max + 1;
            } else {
                if (purchaseOrder.getPurchDate() != pDate)
                    max = max + 1;
                else
                    max = counter;
            }

        } catch (Exception e) {
            System.out.println("Err at counter : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return max;
    }

    /**
     * this method used to getNextIndex of maximum number of PR number
     * return : int new number
     *
     * modified on : June 27, 2003 10:53 PM
     * modified by : gedhy
     */
    public static int getIntCode(PurchaseOrder purchaseOrder, Date pDate, long oid, int counter, boolean isIncrement) {
        int max = 0;
        DBResultSet dbrs = null;
        Date date = new Date();
        try {
            String sql = "SELECT MAX(" + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE_COUNTER] + ") AS PMAX" +
                    " FROM " + PstPurchaseOrder.TBL_PURCHASE_ORDER +
                    " WHERE YEAR(" + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE] + ") " +
                    " = " + (purchaseOrder.getPurchDate().getYear() + 1900) + "" +
                    " AND MONTH(" + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE] + ") " +
                    " = " + (purchaseOrder.getPurchDate().getMonth() + 1) +
                    " AND " + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID] +
                    " <> " + oid +
                    " AND " + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_LOCATION_ID] +
                    " = " + purchaseOrder.getLocationId();
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                max = rs.getInt("PMAX");
            }

            if (oid == 0) {
                max = max + 1;
            } else {
                if (purchaseOrder.getPurchDate() != pDate)
                    max = max + 1;
                else
                    max = counter;
            }
        } catch (Exception e) {
            System.out.println("!!!!!SessOrderMaterial.getIntCode() err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return max;
    }

    public static String getCounter(int counter) {
        String strCounter = "";
        String str = String.valueOf(counter);
        switch (str.length()) {
            case 1:
                strCounter = "00" + counter;
                break;
            case 2:
                strCounter = "0" + counter;
                break;
            case 3:
                strCounter = "" + counter;
                break;
            default:
                strCounter = "" + counter;
        }
        return strCounter;
    }

    public static final int TYPE_GET_YEAR = 0;
    public static final int TYPE_GET_MONTH = 1;

    public static String getYearMonth(Date date, int getType) {
        String str = "";
        try {
            switch (getType) {
                case TYPE_GET_YEAR:
                    str = "" + date.getYear();
                    str = str.substring(str.length() - 2, str.length());
                    break;

                case TYPE_GET_MONTH:
                    str = "" + (date.getMonth() + 1);
                    if (str.length() != 2)
                        str = "0" + str;
                    break;

                default:
            }

        } catch (Exception e) {
            System.out.println("Err : " + e.toString());
        }
        return str;
    }

    public static Vector getListMaterialItem(long oidOrderMaterial, long oidVendor) {
        DBResultSet dbrs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = "";
/*"SELECT "+
                "  ITEM."+PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ITEM_ID]+ //MAT_ORDER_ITEM_ID+
                " ,ITEM."+PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_MATERIAL_ID]+ //MATERIAL_ID
                " ,MAT."+PstMaterial.fieldNames[PstMaterial.FLD_SKU]+ // CODE
                " ,MAT."+PstMaterial.fieldNames[PstMaterial.FLD_NAME]+ //NAME
                " ,."+PstCategory.fieldNames[PstCategory.FLD_CODE]+" AS GRP_"+PstCategory.fieldNames[PstCategory.FLD_CODE]+ //CODE
                " ,GRP."+PstCategory.fieldNames[PstCategory.FLD_NAME]+" AS GRP_"+PstCategory.fieldNames[PstCategory.FLD_NAME]+ //NAME
                " ,UNIT."+PstUnit.fieldNames[PstUnit.FLD_UNIT_NAME]+ //UNIT_NAME
                " ,ITEM."+PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_QUANTITY]+ //QUANTITY
                " ,ITEM."+PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_UNIT_PRICE]+ //UNIT_PRICE
                " ,ITEM."+PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_AMOUNT]+ //AMOUNT
                " ,VDR."+PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_VENDOR_MAT_CODE]+
				" FROM "+PstPurchaseOrderItem.TBL_GRM_MAT_ORDER_ITEM+" AS ITEM "+//MAT_PURCHASE_ORDER_ITEM
				" INNER JOIN "+PstMaterial.TBL_MATERIAL+
                	" AS MAT ON ITEM."+PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_MATERIAL_ID]+
                    " = MAT."+PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID]+
				" INNER JOIN "+PstCategory.TBL_MATERIAL_GROUP+ //GRM_MATERIAL_GROUP+
                	" AS GRP ON MAT."+PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_GROUP_ID]+ //MATERIAL_GROUP_ID+
                    " = GRP."+PstCategory.fieldNames[PstCategory.FLD_MATERIAL_GROUP_ID]+ //TBL_MATERIAL_GROUP+
				" INNER JOIN "+PstUnit.TBL_P2_UNIT+ //GRM_UNIT+
                	" AS UNIT ON MAT."+PstMaterial.fieldNames[PstMaterial.FLD_UNIT]+ //UNIT_ID+
                    " = UNIT."+PstUnit.fieldNames[PstUnit.FLD_UNIT_ID]+ //UNIT_ID
				" LEFT JOIN "+PstMatVendorPrice.TBL_GRM_VDR_MATERIAL_PRICE+ //GRM_VDR_MATERIAL_PRICE+
                	" AS VDR ON MAT."+PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID]+ //MATERIAL_ID+
                    " = VDR."+PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_MATERIAL_ID]+ //MATERIAL_ID
				" WHERE ITEM."+PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ID]+" = "+oidOrderMaterial;
        	if(oidVendor!=0)
                {
                    sql = sql + " AND "+PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_VENDOR_ID]+" = "+oidVendor;
        	}
                 */


            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Vector vt = new Vector();
                PurchaseOrderItem poItem = new PurchaseOrderItem();
                Material material = new Material();
                Category category = new Category();
                Unit unit = new Unit();

                poItem.setOID(rs.getLong(1));
                poItem.setQuantity(rs.getDouble(2));
                poItem.setPrice(rs.getDouble(3));
                poItem.setDiscount(rs.getDouble(4));
                poItem.setTotal(rs.getDouble(5));
                vt.add(poItem);

                material.setOID(rs.getLong(6));
                material.setSku(rs.getString(7));
                material.setName(rs.getString(8));
                vt.add(material);

                category.setCode(rs.getString(9));
                category.setName(rs.getString(10));
                vt.add(category);

                unit.setName(rs.getString(11));
                vt.add(unit);

                result.add(vt);
            }

            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }


    /**
     * this method used to get vector prItem
     * used in pr/po editor
     */
    public static Vector getVectPOItem(long poId, int start, int recordToGet) {
        DBResultSet dbrs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = "SELECT PI." + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ITEM_ID] +
                    ", PI." + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ID] +
                    ", PI." + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_MATERIAL_ID] +
                    ", PI." + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_QUANTITY] +
                    ", PI." + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PRICE] +
                    ", PI." + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_TOTAL] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    ", UN." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    ", UN." + PstUnit.fieldNames[PstUnit.FLD_NAME] +
                    " FROM " + PstPurchaseOrderItem.TBL_PURCHASE_ORDER_ITEM + " AS PI " +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " AS MAT " +
                    " ON PI." + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " INNER JOIN " + PstUnit.TBL_P2_UNIT + " AS UN " +
                    " ON MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = UN." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " WHERE " + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ID] + " = " + poId +
                    " LIMIT " + start + ", " + recordToGet;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector tempResult = new Vector(1, 1);
                PurchaseOrderItem pi = new PurchaseOrderItem();
                Material mat = new Material();
                Unit matUnit = new Unit();

                pi.setOID(rs.getLong(1));
                pi.setPurchaseOrderId(rs.getLong(2));
                pi.setMaterialId(rs.getLong(4));
                pi.setQuantity(rs.getDouble(5));
                pi.setPrice(rs.getDouble(6));
                pi.setTotal(rs.getDouble(7));
                tempResult.add(pi);

                mat.setOID(rs.getLong(8));
                mat.setSku(rs.getString(9));
                mat.setName(rs.getString(10));
                tempResult.add(mat);

                matUnit.setOID(rs.getLong(11));
                matUnit.setName(rs.getString(12));
                tempResult.add(matUnit);

                result.add(tempResult);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("SessOrderMaterial.getVectPOItem() err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }

    /**
     * this method used to get count of vector prItem
     * used in pr/po editor
     */
    public static int getCountVectPOItem(long poId) {
        DBResultSet dbrs = null;
        int result = 0;
        try {
            String sql = "SELECT DISTINCT COUNT(PI." + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ITEM_ID] + ")" +
                    " FROM " + PstPurchaseOrderItem.TBL_PURCHASE_ORDER_ITEM + " AS PI " +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " AS MAT " +
                    " ON PI." + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " INNER JOIN " + PstUnit.TBL_P2_UNIT + " AS UN " +
                    " ON MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " = UN." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " WHERE " + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ID] +
                    " = " + poId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("SessOrderMaterial.getCountVectPOItem() err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }

    public static boolean cekPurchDate(Date newDate, Date oldDate) {

        if (newDate == null)
            return true;

        if (newDate.getMonth() != oldDate.getMonth()) {
            return true;
        }
        if (newDate.getYear() != oldDate.getYear()) {
            return true;
        }
        return false;
    }

    /**
     * this method used to list all po which vendor who supply specify material
     * @materialId --> material that supply by vendor
     * @return --> list purchase order
     */
    public static Vector listPoWhichSupplyMaterial(long materialId, int currency) {
        DBResultSet dbrs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = "SELECT PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID] +
                    ", PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_SUPPLIER_ID] +
                    ", PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE] +
                    ", PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE_COUNTER] +
                    ", PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE] +
                    ", CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] +
                    ", CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] +
                    ", CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME] +
                    ", LOC." + PstLocation.fieldNames[PstLocation.FLD_NAME] +
                    " FROM " + PstPurchaseOrder.TBL_PURCHASE_ORDER + " AS PO " +
                    " INNER JOIN " + PstContactList.TBL_CONTACT_LIST + " AS CNT " +
                    " ON PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_SUPPLIER_ID] +
                    " = CNT." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID] +
                    " INNER JOIN " + PstPurchaseOrderItem.TBL_PURCHASE_ORDER_ITEM + " AS POI " +
                    " ON PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID] +
                    " = POI." + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ID] +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " AS MAT " +
                    " ON POI." + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " INNER JOIN " + PstLocation.TBL_P2_LOCATION + " AS LOC " +
                    " ON PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_LOCATION_ID] +
                    " = LOC." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] +
                    " WHERE MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " = " + materialId +
                    " AND PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_STATUS] +
                    " = " + I_DocStatus.DOCUMENT_STATUS_DRAFT +
                    " ORDER BY PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCH_DATE] +
                    ", CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME];
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector tempResult = new Vector();
                PurchaseOrder pr = new PurchaseOrder();
                ContactList cnt = new ContactList();
                Location loc = new Location();

                pr.setOID(rs.getLong(1));
                pr.setSupplierId(rs.getLong(2));
                pr.setPoCode(rs.getString(3));
                pr.setPoCodeCounter(rs.getInt(4));
                pr.setPurchDate(rs.getDate(5));
                tempResult.add(pr);

                cnt.setCompName(rs.getString(6));
                cnt.setPersonName(rs.getString(7));
                cnt.setPersonLastname(rs.getString(8));
                tempResult.add(cnt);

                loc.setName(rs.getString(9));
                tempResult.add(loc);

                result.add(tempResult);
            }
        } catch (Exception e) {
            System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!SessOrderMaterial.listPoWhichSupplyMaterial() err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }

    /**
     * this method used to generate String for whereClause in method "getIntCode()" above
     * return : String of PO type
     *
     * created on : June 27, 2003 16:37 PM
     * created by : gedhy
     */
    public static String genStringPO() {
        String result = "";

        // fill pr index to vector
        Vector vectPr = new Vector(1, 1);
        try {
            I_PstDocType i_pstdoctype = (I_PstDocType) Class.forName(I_DocType.DOCTYPE_CLASSNAME).newInstance();
            vectPr.add(String.valueOf(i_pstdoctype.composeDocumentType(I_DocType.SYSTEM_MATERIAL, I_DocType.MAT_DOC_TYPE_POR)));
            vectPr.add(String.valueOf(i_pstdoctype.composeDocumentType(I_DocType.SYSTEM_MATERIAL, I_DocType.MAT_DOC_TYPE_POM)));
            vectPr.add(String.valueOf(i_pstdoctype.composeDocumentType(I_DocType.SYSTEM_MATERIAL, I_DocType.MAT_DOC_TYPE_POA)));
        } catch (Exception e) {
            System.out.println("!!!!!!!!!!!!!!!!!!!!!SessRequestMaterial.genStringPO() err : " + e.toString());
        }

        // generate string result
        for (int i = 0; i < vectPr.size(); i++) {
            result = result + String.valueOf(vectPr.get(i)) + ",";
        }
        if (result != "" && result.length() > 0) {
            result = result.substring(0, result.length() - 1);
        }

        return result;
    }

    /*public static String getCodeOrderMaterial(PurchaseOrder po)
    {
	String strCode = "";
	try
        {

            I_PstDocType i_pstDocType = (I_PstDocType) Class.forName(className).newInstance();
            String documentCode = "PO";
            strCode = getYearMonth(orderMaterial.getPurchDate(),TYPE_GET_YEAR)+
            ""+getYearMonth(po.getPurchDate(),TYPE_GET_MONTH)+
            "-"+documentCode+
            "-"+getCounter(po.getPoCodeCounter());
        }
        catch(Exception e)
        {
            System.out.println("Err : "+e.toString());
        }
        return strCode;
    }*/
}
