/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.employee;

/**
 *
 * @author Hendra Putu
 */
import com.dimata.harisma.entity.masterdata.PstCustomFieldMaster;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

public class PstEmpCustomField extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_EMP_CUSTOM_FIELD = "hr_emp_custom_field";
    public static final int FLD_EMP_CUSTOM_FIELD_ID = 0;
    public static final int FLD_DATA_NUMBER = 1;
    public static final int FLD_DATA_TEXT = 2;
    public static final int FLD_DATA_DATE = 3;
    public static final int FLD_CUSTOM_FIELD_ID = 4;
    public static final int FLD_EMPLOYEE_ID = 5;

    public static String[] fieldNames = {
        "EMP_CUSTOM_FIELD_ID",
        "DATA_NUMBER",
        "DATA_TEXT",
        "DATA_DATE",
        "CUSTOM_FIELD_ID",
        "EMPLOYEE_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstEmpCustomField() {
    }

    public PstEmpCustomField(int i) throws DBException {
        super(new PstEmpCustomField());
    }

    public PstEmpCustomField(String sOid) throws DBException {
        super(new PstEmpCustomField(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstEmpCustomField(long lOid) throws DBException {
        super(new PstEmpCustomField(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public String getTableName() {
        return TBL_EMP_CUSTOM_FIELD;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstEmpCustomField().getClass().getName();
    }

    public static EmpCustomField fetchExc(long oid) throws DBException {
        try {
            EmpCustomField entEmpCustomField = new EmpCustomField();
            PstEmpCustomField pstEmpCustomField = new PstEmpCustomField(oid);
            entEmpCustomField.setOID(oid);
            entEmpCustomField.setDataNumber(pstEmpCustomField.getdouble(FLD_DATA_NUMBER));
            entEmpCustomField.setDataText(pstEmpCustomField.getString(FLD_DATA_TEXT));
            entEmpCustomField.setDataDate(pstEmpCustomField.getDate(FLD_DATA_DATE));
            entEmpCustomField.setCustomFieldId(pstEmpCustomField.getLong(FLD_CUSTOM_FIELD_ID));
            entEmpCustomField.setEmployeeId(pstEmpCustomField.getLong(FLD_EMPLOYEE_ID));
            return entEmpCustomField;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpCustomField(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        EmpCustomField entEmpCustomField = fetchExc(entity.getOID());
        entity = (Entity) entEmpCustomField;
        return entEmpCustomField.getOID();
    }

    public static synchronized long updateExc(EmpCustomField entEmpCustomField) throws DBException {
        try {
            if (entEmpCustomField.getOID() != 0) {
                PstEmpCustomField pstEmpCustomField = new PstEmpCustomField(entEmpCustomField.getOID());
                pstEmpCustomField.setDouble(FLD_DATA_NUMBER, entEmpCustomField.getDataNumber());
                pstEmpCustomField.setString(FLD_DATA_TEXT, entEmpCustomField.getDataText());
                pstEmpCustomField.setDate(FLD_DATA_DATE, entEmpCustomField.getDataDate());
                pstEmpCustomField.setLong(FLD_CUSTOM_FIELD_ID, entEmpCustomField.getCustomFieldId());
                pstEmpCustomField.setLong(FLD_EMPLOYEE_ID, entEmpCustomField.getEmployeeId());
                pstEmpCustomField.update();
                return entEmpCustomField.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpCustomField(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((EmpCustomField) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstEmpCustomField pstEmpCustomField = new PstEmpCustomField(oid);
            pstEmpCustomField.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpCustomField(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(EmpCustomField entEmpCustomField) throws DBException {
        try {
            PstEmpCustomField pstEmpCustomField = new PstEmpCustomField(0);
            pstEmpCustomField.setDouble(FLD_DATA_NUMBER, entEmpCustomField.getDataNumber());
            pstEmpCustomField.setString(FLD_DATA_TEXT, entEmpCustomField.getDataText());
            pstEmpCustomField.setDate(FLD_DATA_DATE, entEmpCustomField.getDataDate());
            pstEmpCustomField.setLong(FLD_CUSTOM_FIELD_ID, entEmpCustomField.getCustomFieldId());
            pstEmpCustomField.setLong(FLD_EMPLOYEE_ID, entEmpCustomField.getEmployeeId());
            pstEmpCustomField.insert();
            entEmpCustomField.setOID(pstEmpCustomField.getlong(FLD_EMP_CUSTOM_FIELD_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpCustomField(0), DBException.UNKNOWN);
        }
        return entEmpCustomField.getOID();
    }
    
    public static void saveCustomField(HttpServletRequest request, long oid){
        try {
            /* input0 = text field */
            String[] input0 = FRMQueryString.requestStringValues(request, "input0");
            String[] hidden0 = FRMQueryString.requestStringValues(request, "hidden0");
            String[] dataType0 = FRMQueryString.requestStringValues(request, "data_type0");
            /* input1 = textarea */
            String[] input1 = FRMQueryString.requestStringValues(request, "input1");
            String[] hidden1 = FRMQueryString.requestStringValues(request, "hidden1");
            String[] dataType1 = FRMQueryString.requestStringValues(request, "data_type1");
            /* input2 = selection */
            String[] input2 = FRMQueryString.requestStringValues(request, "input2");
            String[] hidden2 = FRMQueryString.requestStringValues(request, "hidden2");
            String[] dataType2 = FRMQueryString.requestStringValues(request, "data_type2");
            /* input3 = multiple selection */
            //String[] input3 = FRMQueryString.requestStringValues(request, "input3");
            String[] hidden3 = FRMQueryString.requestStringValues(request, "hidden3");
            String[] dataType3 = FRMQueryString.requestStringValues(request, "data_type3");
            /* input4 = datepicker */
            String[] input4 = FRMQueryString.requestStringValues(request, "input4");
            String[] hidden4 = FRMQueryString.requestStringValues(request, "hidden4");
            String[] dataType4 = FRMQueryString.requestStringValues(request, "data_type4");
            /* input5 = datepicker and time */
            String[] input5 = FRMQueryString.requestStringValues(request, "input5");
            String[] hidden5 = FRMQueryString.requestStringValues(request, "hidden5");
            String[] dataType5 = FRMQueryString.requestStringValues(request, "data_type5");
            /* input6 = check box */
            //String[] input6 = FRMQueryString.requestStringValues(request, "input6");
            String[] hidden6 = FRMQueryString.requestStringValues(request, "hidden6");
            String[] dataType6 = FRMQueryString.requestStringValues(request, "data_type6");
            /* input7 = radio button */
            //String[] input7 = FRMQueryString.requestStringValues(request, "input7");
            String[] hidden7 = FRMQueryString.requestStringValues(request, "hidden7");
            String[] dataType7 = FRMQueryString.requestStringValues(request, "data_type7");

            /* text field*/
            if (hidden0 != null && hidden0.length > 0){

                for(int h=0; h<hidden0.length; h++){
                    EmpCustomField empCustom = new EmpCustomField();
                    empCustom.setCustomFieldId(Long.valueOf(hidden0[h]));
                    Date tgl = new Date();
                    empCustom.setDataDate(tgl);
                    empCustom.setDataNumber(0);
                    empCustom.setDataText("-");
                    switch(Integer.valueOf(dataType0[h])){
                        case 0: empCustom.setDataText(input0[h]); break;
                        case 1: empCustom.setDataNumber(Double.valueOf(input0[h])); break;
                        case 2: empCustom.setDataNumber(Integer.valueOf(input0[h])); break;
                        case 3: empCustom.setDataText(input0[h]); break;
                        case 4: empCustom.setDataText(input0[h]); break;
                    }
                    empCustom.setEmployeeId(oid);
                    // insert or update
                    String whereEmpCustom = "CUSTOM_FIELD_ID="+hidden0[h]+" AND EMPLOYEE_ID="+oid;
                    Vector listEmpCustom = PstEmpCustomField.list(0, 0, whereEmpCustom, "");
                    if (listEmpCustom != null && listEmpCustom.size()>0){
                        long empCustomID = 0;
                        for(int e=0; e<listEmpCustom.size(); e++){
                            EmpCustomField empCust = (EmpCustomField)listEmpCustom.get(e);
                            empCustomID = empCust.getOID();
                        }
                        try {
                            empCustom.setOID(empCustomID);
                            PstEmpCustomField.updateExc(empCustom);
                        } catch(Exception ex){
                            System.out.println("insert emp custom field=>"+ex.toString());
                        }
                    } else {
                        try {
                            PstEmpCustomField.insertExc(empCustom);
                        } catch(Exception ex){
                            System.out.println("insert emp custom field=>"+ex.toString());
                        }
                    }
                }


            }
            /* textarea */
            if (hidden1 != null && hidden1.length > 0){

                for(int h=0; h<hidden1.length; h++){
                    EmpCustomField empCustom = new EmpCustomField();
                    empCustom.setCustomFieldId(Long.valueOf(hidden1[h]));
                    Date tgl = new Date();
                    empCustom.setDataDate(tgl);
                    empCustom.setDataNumber(0);
                    empCustom.setDataText("-");
                    switch(Integer.valueOf(dataType1[h])){
                        case 0: empCustom.setDataText(input1[h]); break;
                        case 1: empCustom.setDataNumber(Double.valueOf(input1[h])); break;
                        case 2: empCustom.setDataNumber(Integer.valueOf(input1[h])); break;
                        case 3: empCustom.setDataText(input1[h]); break;
                        case 4: empCustom.setDataText(input1[h]); break;
                    }
                    empCustom.setEmployeeId(oid);
                    // insert or update
                    String whereEmpCustom = "CUSTOM_FIELD_ID="+hidden1[h]+" AND EMPLOYEE_ID="+oid;
                    Vector listEmpCustom = PstEmpCustomField.list(0, 0, whereEmpCustom, "");
                    if (listEmpCustom != null && listEmpCustom.size()>0){
                        long empCustomID = 0;
                        for(int e=0; e<listEmpCustom.size(); e++){
                            EmpCustomField empCust = (EmpCustomField)listEmpCustom.get(e);
                            empCustomID = empCust.getOID();
                        }
                        try {
                            empCustom.setOID(empCustomID);
                            PstEmpCustomField.updateExc(empCustom);
                        } catch(Exception ex){
                            System.out.println("insert emp custom field=>"+ex.toString());
                        }
                    } else {
                        try {
                            PstEmpCustomField.insertExc(empCustom);
                        } catch(Exception ex){
                            System.out.println("insert emp custom field=>"+ex.toString());
                        }
                    }
                }


            }
            /* select  */
            if (hidden2 != null && hidden2.length > 0){

                for(int h=0; h<hidden2.length; h++){
                    EmpCustomField empCustom = new EmpCustomField();
                    empCustom.setCustomFieldId(Long.valueOf(hidden2[h]));
                    Date tgl = new Date();
                    empCustom.setDataDate(tgl);
                    empCustom.setDataNumber(0);
                    empCustom.setDataText(input2[h]);
                    
                    empCustom.setEmployeeId(oid);
                    // insert or update
                    String whereEmpCustom = "CUSTOM_FIELD_ID="+hidden2[h]+" AND EMPLOYEE_ID="+oid;
                    Vector listEmpCustom = PstEmpCustomField.list(0, 0, whereEmpCustom, "");
                    if (listEmpCustom != null && listEmpCustom.size()>0){
                        long empCustomID = 0;
                        for(int e=0; e<listEmpCustom.size(); e++){
                            EmpCustomField empCust = (EmpCustomField)listEmpCustom.get(e);
                            empCustomID = empCust.getOID();
                        }
                        try {
                            empCustom.setOID(empCustomID);
                            PstEmpCustomField.updateExc(empCustom);
                        } catch(Exception ex){
                            System.out.println("insert emp custom field=>"+ex.toString());
                        }
                    } else {
                        try {
                            PstEmpCustomField.insertExc(empCustom);
                        } catch(Exception ex){
                            System.out.println("insert emp custom field=>"+ex.toString());
                        }
                    }
                }


            }
            /* select multiple */
            if (hidden3 != null && hidden3.length > 0){
                for(int h=0; h<hidden3.length; h++){
                    
                    String[] input3 = FRMQueryString.requestStringValues(request, "input3_"+h);
                    
                    if (input3 != null && input3.length > 0){
                        for (int n=0; n < input3.length; n++){
                            EmpCustomField empCustom = new EmpCustomField();
                            empCustom.setCustomFieldId(Long.valueOf(hidden3[h]));
                            Date tgl = new Date();
                            empCustom.setDataDate(tgl);
                            empCustom.setDataNumber(0);
                            empCustom.setDataText(input3[n]);

                            empCustom.setEmployeeId(oid);
                            // insert or update
                            String whereEmpCustom = "CUSTOM_FIELD_ID="+hidden3[h]+" AND EMPLOYEE_ID="+oid;
                            Vector listEmpCustom = PstEmpCustomField.list(0, 0, whereEmpCustom, "");
                            if (listEmpCustom != null && listEmpCustom.size()>0){
                                if (n==0){
                                    for(int e=0; e<listEmpCustom.size(); e++){
                                        EmpCustomField empCust = (EmpCustomField)listEmpCustom.get(e);
                                        PstEmpCustomField.deleteExc(empCust.getOID());
                                    }    
                                }
                                try {
                                    PstEmpCustomField.insertExc(empCustom);
                                } catch(Exception ex){
                                    System.out.println("insert emp custom field=>"+ex.toString());
                                }
                            } else {
                                try {
                                    PstEmpCustomField.insertExc(empCustom);
                                } catch(Exception ex){
                                    System.out.println("insert emp custom field=>"+ex.toString());
                                }
                            }
                        }
                    }

                }
            }
            /* datepicker */
            if (hidden4 != null && hidden4.length > 0){

                for(int h=0; h<hidden4.length; h++){
                    EmpCustomField empCustom = new EmpCustomField();
                    empCustom.setCustomFieldId(Long.valueOf(hidden4[h]));
                    if ((!(input4[h].equals("null")))&&(input4[h].length()>0)){
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); 
                        Date tgl = new Date();
                        try {
                            dateFormat.parse(input4[h]); 
                        } catch(Exception exc){}

                        empCustom.setDataDate(tgl);
                        empCustom.setDataNumber(0);
                        empCustom.setDataText("-");
                        empCustom.setEmployeeId(oid);
                        // insert or update
                        String whereEmpCustom = "CUSTOM_FIELD_ID="+hidden4[h]+" AND EMPLOYEE_ID="+oid;
                        Vector listEmpCustom = PstEmpCustomField.list(0, 0, whereEmpCustom, "");
                        if (listEmpCustom != null && listEmpCustom.size()>0){
                            long empCustomID = 0;
                            for(int e=0; e<listEmpCustom.size(); e++){
                                EmpCustomField empCust = (EmpCustomField)listEmpCustom.get(e);
                                empCustomID = empCust.getOID();
                            }
                            try {
                                empCustom.setOID(empCustomID);
                                PstEmpCustomField.updateExc(empCustom);
                            } catch(Exception ex){
                                System.out.println("insert emp custom field=>"+ex.toString());
                            }
                        } else {
                            try {
                                PstEmpCustomField.insertExc(empCustom);
                            } catch(Exception ex){
                                System.out.println("insert emp custom field=>"+ex.toString());
                            }
                        }
                    } else {
                        String whereEmpCustom = "CUSTOM_FIELD_ID="+hidden4[h]+" AND EMPLOYEE_ID="+oid;
                        Vector listEmpCustom = PstEmpCustomField.list(0, 0, whereEmpCustom, "");
                        if (listEmpCustom != null && listEmpCustom.size()>0){
                            long empCustomID = 0;
                            for(int e=0; e<listEmpCustom.size(); e++){
                                EmpCustomField empCust = (EmpCustomField)listEmpCustom.get(e);
                                empCustomID = empCust.getOID();
                            }
                            try {
                                PstEmpCustomField.deleteExc(empCustomID);
                            } catch(Exception ex){
                                System.out.println("insert emp custom field=>"+ex.toString());
                            }
                        }
                    }
                }
            }
            /* checkbox */
            if (hidden6 != null && hidden6.length > 0){
                for(int h=0; h<hidden6.length; h++){
                    
                    String[] input6 = FRMQueryString.requestStringValues(request, "input6_"+h);
                    
                    if (input6 != null && input6.length > 0){
                        for (int n=0; n < input6.length; n++){
                            EmpCustomField empCustom = new EmpCustomField();
                            empCustom.setCustomFieldId(Long.valueOf(hidden6[h]));
                            Date tgl = new Date();
                            empCustom.setDataDate(tgl);
                            empCustom.setDataNumber(0);
                            empCustom.setDataText(input6[n]);

                            empCustom.setEmployeeId(oid);
                            // insert or update
                            String whereEmpCustom = "CUSTOM_FIELD_ID="+hidden6[h]+" AND EMPLOYEE_ID="+oid;
                            Vector listEmpCustom = PstEmpCustomField.list(0, 0, whereEmpCustom, "");
                            if (listEmpCustom != null && listEmpCustom.size()>0){
                                if (n==0){
                                    for(int e=0; e<listEmpCustom.size(); e++){
                                        EmpCustomField empCust = (EmpCustomField)listEmpCustom.get(e);
                                        PstEmpCustomField.deleteExc(empCust.getOID());
                                    }    
                                }
                                try {
                                    PstEmpCustomField.insertExc(empCustom);
                                } catch(Exception ex){
                                    System.out.println("insert emp custom field=>"+ex.toString());
                                }
                            } else {
                                try {
                                    PstEmpCustomField.insertExc(empCustom);
                                } catch(Exception ex){
                                    System.out.println("insert emp custom field=>"+ex.toString());
                                }
                            }
                        }
                    }

                }
            }
            /* Radio */
            if (hidden7 != null && hidden7.length > 0){

                for(int h=0; h<hidden7.length; h++){
                    String input7 = FRMQueryString.requestString(request, "input7_"+h);
                    EmpCustomField empCustom = new EmpCustomField();
                    empCustom.setCustomFieldId(Long.valueOf(hidden7[h]));
                    Date tgl = new Date();
                    empCustom.setDataDate(tgl);
                    empCustom.setDataNumber(0);
                    empCustom.setDataText(input7);
                    empCustom.setEmployeeId(oid);
                    // insert or update
                    String whereEmpCustom = "CUSTOM_FIELD_ID="+hidden7[h]+" AND EMPLOYEE_ID="+oid;
                    Vector listEmpCustom = PstEmpCustomField.list(0, 0, whereEmpCustom, "");
                    if (listEmpCustom != null && listEmpCustom.size()>0){
                        long empCustomID = 0;
                        for(int e=0; e<listEmpCustom.size(); e++){
                            EmpCustomField empCust = (EmpCustomField)listEmpCustom.get(e);
                            empCustomID = empCust.getOID();
                        }
                        try {
                            empCustom.setOID(empCustomID);
                            PstEmpCustomField.updateExc(empCustom);
                        } catch(Exception ex){
                            System.out.println("insert emp custom field=>"+ex.toString());
                        }
                    } else {
                        try {
                            PstEmpCustomField.insertExc(empCustom);
                        } catch(Exception ex){
                            System.out.println("insert emp custom field=>"+ex.toString());
                        }
                    }
                }
            }
        } catch (Exception exc){
            System.out.println("Exception at PstEmpCutomField saveCustomField :"+exc.toString());
        }
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((EmpCustomField) entity);
    }

    public static void resultToObject(ResultSet rs, EmpCustomField entEmpCustomField) {
        try {
            entEmpCustomField.setOID(rs.getLong(PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_EMP_CUSTOM_FIELD_ID]));
            entEmpCustomField.setDataNumber(rs.getDouble(PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_DATA_NUMBER]));
            entEmpCustomField.setDataText(rs.getString(PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_DATA_TEXT]));
            entEmpCustomField.setDataDate(rs.getDate(PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_DATA_DATE]));
            entEmpCustomField.setCustomFieldId(rs.getLong(PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_CUSTOM_FIELD_ID]));
            entEmpCustomField.setEmployeeId(rs.getLong(PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_EMPLOYEE_ID]));
        } catch (Exception e) {
        }
    }
    
    public static void resultToObjectJoin(ResultSet rs, EmpCustomField entEmpCustomField) {
        try {
            entEmpCustomField.setOID(rs.getLong(PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_EMP_CUSTOM_FIELD_ID]));
            entEmpCustomField.setDataText(rs.getString(PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_DATA_TEXT]));
            entEmpCustomField.setDataDate(rs.getDate(PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_DATA_DATE]));
            entEmpCustomField.setFieldName(rs.getString(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_FIELD_NAME]));
        } catch (Exception e) {
        }
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_EMP_CUSTOM_FIELD;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                EmpCustomField entEmpCustomField = new EmpCustomField();
                resultToObject(rs, entEmpCustomField);
                lists.add(entEmpCustomField);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }
    
    public static Vector listJoinCustomFieldMaster(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT a.EMP_CUSTOM_FIELD_ID, a.DATA_TEXT, a.DATA_DATE, b.FIELD_NAME FROM " + TBL_EMP_CUSTOM_FIELD + " AS a "
                    + "INNER JOIN " + PstCustomFieldMaster.TBL_CUSTOM_FIELD_MASTER + " AS b "
                    + "ON a." + fieldNames[FLD_CUSTOM_FIELD_ID] + " = b." + fieldNames[FLD_CUSTOM_FIELD_ID];
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                EmpCustomField entEmpCustomField = new EmpCustomField();
                resultToObjectJoin(rs, entEmpCustomField);
                lists.add(entEmpCustomField);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static boolean checkOID(long entEmpCustomFieldId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_EMP_CUSTOM_FIELD + " WHERE "
                    + PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_EMP_CUSTOM_FIELD_ID] + " = " + entEmpCustomFieldId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_EMP_CUSTOM_FIELD_ID] + ") FROM " + TBL_EMP_CUSTOM_FIELD;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    EmpCustomField entEmpCustomField = (EmpCustomField) list.get(ls);
                    if (oid == entEmpCustomField.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }
        return start;
    }

    
    
      /**
      /**
     * Priska 2015-12-24
     * @param employeeId
     */
      public static int updateDATA_TEXT(long employeeId, String text, long oidCustomField ) {
        int success=0;

        //cek data ada 
        String whereX = " CUSTOM_FIELD_ID = "+oidCustomField+" AND EMPLOYEE_ID = " + employeeId;
        int count = getCount(whereX);
        
        try {
            
            String sql  = " UPDATE hr_emp_custom_field  SET  DATA_TEXT = \"" + text +"\"" ; 
                   sql += " WHERE  CUSTOM_FIELD_ID = "+oidCustomField+" AND EMPLOYEE_ID = " + employeeId;
            
            //System.out.println("sql : " + sql);
                   if (count>0){
                        success = DBHandler.execUpdate(sql);
                      
                   } else {
                       EmpCustomField empCustomField = new EmpCustomField();
                       empCustomField.setEmployeeId(employeeId);
                       empCustomField.setDataNumber(0);
                       empCustomField.setDataDate(new Date());
                       empCustomField.setDataText(text);
                       empCustomField.setCustomFieldId(oidCustomField);
                       insertExc(empCustomField);
                   }
        } catch (Exception e) {
            System.out.println("\tExc updatePresenceStatus : " + e.toString());
        } finally {
            //System.out.println("\tFinal updatePresenceStatus");
            //DBResultSet.close(dbrs);
            return success;
        }
    }
    
        public static String getNoSK(long employeeId, String text, long oidCustomField ) {
        DBResultSet dbrs = null;
        String count = "";
        try {
            String sql  = "SELECT " + PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_DATA_TEXT] + " FROM " + TBL_EMP_CUSTOM_FIELD;
                   sql += " WHERE  CUSTOM_FIELD_ID = "+oidCustomField+" AND EMPLOYEE_ID = " + employeeId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                count = rs.getString(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return count;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
        
         public static Date getTglSk(long employeeId, String text, long oidCustomField ) {
        DBResultSet dbrs = null;
        Date count = null;
        try {
            String sql  = "SELECT " + PstEmpCustomField.fieldNames[PstEmpCustomField.FLD_DATA_DATE] + " FROM " + TBL_EMP_CUSTOM_FIELD;
                   sql += " WHERE  CUSTOM_FIELD_ID = "+oidCustomField+" AND EMPLOYEE_ID = " + employeeId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                count = rs.getDate(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return count;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
      
     /**
      /**
     * Priska 2015-12-24
     * @param employeeId
     */
      public static int updateDATA_DATE(long employeeId, Date text, long oidCustomField ) {
        int success=0;

         //cek data ada 
        String whereX = " CUSTOM_FIELD_ID = "+oidCustomField+" AND EMPLOYEE_ID = " + employeeId;
        int count = getCount(whereX);
       
        
        try {
            String sql  = " UPDATE hr_emp_custom_field  SET  DATA_DATE = \"" + Formater.formatDate(text, "yyyy-MM-dd HH:mm:ss") + "\"";
                   sql += " WHERE  CUSTOM_FIELD_ID = "+oidCustomField+" AND EMPLOYEE_ID = " + employeeId;
            
            //System.out.println("sql : " + sql);
            if (count>0){
                        success = DBHandler.execUpdate(sql);
                      
                   } else {
                       EmpCustomField empCustomField = new EmpCustomField();
                       empCustomField.setEmployeeId(employeeId);
                       
                       empCustomField.setDataNumber(0);
                       empCustomField.setDataText("");
                       if (text != null){
                          empCustomField.setDataDate(text);
                       } else {
                          empCustomField.setDataDate(new Date());
                       }
                       
                       empCustomField.setCustomFieldId(oidCustomField);
                       insertExc(empCustomField);
                   }
        } catch (Exception e) {
            System.out.println("\tExc updatePresenceStatus : " + e.toString());
        } finally {
            //System.out.println("\tFinal updatePresenceStatus");
            //DBResultSet.close(dbrs);
            return success;
        }
    }
    public static int findLimitCommand(int start, int recordToGet, int vectSize) {
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + (recordToGet - mdl);
        if (start == 0) {
            cmd = Command.FIRST;
        } else {
            if (start == (vectSize - recordToGet)) {
                cmd = Command.LAST;
            } else {
                start = start + recordToGet;
                if (start <= (vectSize - recordToGet)) {
                    cmd = Command.NEXT;
                    System.out.println("next.......................");
                } else {
                    start = start - recordToGet;
                    if (start > 0) {
                        cmd = Command.PREV;
                        System.out.println("prev.......................");
                    }
                }
            }
        }
        return cmd;
    }
}
