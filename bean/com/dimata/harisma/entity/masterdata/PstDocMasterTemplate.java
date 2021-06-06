/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

//import com.dimata.harisma.entity.payroll.PstSalaryLevel;
//import com.dimata.harisma.entity.payroll.SalaryLevel;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author GUSWIK
 */
public class PstDocMasterTemplate extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

   public static final String TBL_HR_DOC_MASTER_TEMPLATE = "hr_doc_master_template";
   public static final int FLD_DOC_MASTER_TEMPLATE_ID = 0;
   public static final int FLD_DOC_MASTER_ID = 1;
   public static final int FLD_TEMPLATE_TITLE = 2;
   public static final int FLD_TEMPLATE_FILE_NAME = 3;
   public static final int FLD_TEXT_TEMPLATE = 4;
   public static final int FLD_TEXT_HEADER = 5;
   public static final int FLD_TEXT_FOOTER = 6;
   public static final int FLD_TOP_MARGIN = 7;
   public static final int FLD_RIGHT_MARGIN = 8;
   public static final int FLD_LEFT_MARGIN = 9;
   public static final int FLD_BOTTOM_MARGIN = 10;
 
   public static final String[] fieldNames = {
      "DOC_MASTER_TEMPLATE_ID",
      "DOC_MASTER_ID",
      "TEMPLATE_TITLE",
      "TEMPLATE_FILE_NAME",
      "TEXT_TEMPLATE",
      "TEXT_HEADER",
      "TEXT_FOOTER",
      "TOP_MARGIN",
      "RIGHT_MARGIN",
      "LEFT_MARGIN",
      "BOTTOM_MARGIN"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT
    };

   public PstDocMasterTemplate() {
   }

    public PstDocMasterTemplate(int i) throws DBException {
        super(new PstDocMasterTemplate());
    }

    public PstDocMasterTemplate(String sOid) throws DBException {
        super(new PstDocMasterTemplate(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstDocMasterTemplate(long lOid) throws DBException {
        super(new PstDocMasterTemplate(0));
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
        return TBL_HR_DOC_MASTER_TEMPLATE;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstDocMasterTemplate().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        DocMasterTemplate docMasterTemplate = fetchExc(ent.getOID());
        ent = (Entity) docMasterTemplate;
        return docMasterTemplate.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((DocMasterTemplate) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((DocMasterTemplate) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static DocMasterTemplate fetchExc(long oid) throws DBException {
        try {
            DocMasterTemplate docMasterTemplate = new DocMasterTemplate();
            PstDocMasterTemplate pstDocMasterTemplate = new PstDocMasterTemplate(oid);
            docMasterTemplate.setOID(oid);

         docMasterTemplate.setDoc_master_id(pstDocMasterTemplate.getlong(FLD_DOC_MASTER_ID));
         docMasterTemplate.setTemplate_title(pstDocMasterTemplate.getString(FLD_TEMPLATE_TITLE));
         docMasterTemplate.setTemplate_filename(pstDocMasterTemplate.getString(FLD_TEMPLATE_FILE_NAME));
         docMasterTemplate.setText_template(pstDocMasterTemplate.getString(FLD_TEXT_TEMPLATE));
         docMasterTemplate.setText_header(pstDocMasterTemplate.getString(FLD_TEXT_HEADER));
         docMasterTemplate.setText_footer(pstDocMasterTemplate.getString(FLD_TEXT_FOOTER));
         docMasterTemplate.setTopMargin(pstDocMasterTemplate.getfloat(FLD_TOP_MARGIN));
         docMasterTemplate.setRightMargin(pstDocMasterTemplate.getfloat(FLD_RIGHT_MARGIN));
         docMasterTemplate.setLeftMargin(pstDocMasterTemplate.getfloat(FLD_LEFT_MARGIN));
         docMasterTemplate.setBottomMargin(pstDocMasterTemplate.getfloat(FLD_BOTTOM_MARGIN));
            
            return docMasterTemplate;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterTemplate(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(DocMasterTemplate docMasterTemplate) throws DBException {
        try {
            PstDocMasterTemplate pstDocMasterTemplate = new PstDocMasterTemplate(0);
            
            pstDocMasterTemplate.setLong(FLD_DOC_MASTER_ID, docMasterTemplate.getDoc_master_id());
            pstDocMasterTemplate.setString(FLD_TEMPLATE_TITLE, docMasterTemplate.getTemplate_title());
            pstDocMasterTemplate.setString(FLD_TEMPLATE_FILE_NAME, docMasterTemplate.getTemplate_filename());
            pstDocMasterTemplate.setString(FLD_TEXT_TEMPLATE, docMasterTemplate.getText_template());
            pstDocMasterTemplate.setString(FLD_TEXT_HEADER, docMasterTemplate.getText_header());
            pstDocMasterTemplate.setString(FLD_TEXT_FOOTER, docMasterTemplate.getText_footer());
            pstDocMasterTemplate.setFloat(FLD_TOP_MARGIN, docMasterTemplate.getTopMargin());
            pstDocMasterTemplate.setFloat(FLD_LEFT_MARGIN, docMasterTemplate.getLeftMargin());
            pstDocMasterTemplate.setFloat(FLD_RIGHT_MARGIN, docMasterTemplate.getRightMargin());
            pstDocMasterTemplate.setFloat(FLD_BOTTOM_MARGIN, docMasterTemplate.getBottomMargin());
            pstDocMasterTemplate.insert();
            docMasterTemplate.setOID(pstDocMasterTemplate.getlong(FLD_DOC_MASTER_TEMPLATE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterTemplate(0), DBException.UNKNOWN);
        }
        return docMasterTemplate.getOID();
    }

    public static long updateExc(DocMasterTemplate docMasterTemplate) throws DBException {
        try {
            if (docMasterTemplate.getOID() != 0) {
                PstDocMasterTemplate pstDocMasterTemplate = new PstDocMasterTemplate(docMasterTemplate.getOID());

                pstDocMasterTemplate.setLong(FLD_DOC_MASTER_ID, docMasterTemplate.getDoc_master_id());
                pstDocMasterTemplate.setString(FLD_TEMPLATE_TITLE, docMasterTemplate.getTemplate_title());
                pstDocMasterTemplate.setString(FLD_TEMPLATE_FILE_NAME, docMasterTemplate.getTemplate_filename());
                pstDocMasterTemplate.setString(FLD_TEXT_TEMPLATE, docMasterTemplate.getText_template());
                pstDocMasterTemplate.setString(FLD_TEXT_HEADER, docMasterTemplate.getText_header());
                pstDocMasterTemplate.setString(FLD_TEXT_FOOTER, docMasterTemplate.getText_footer());
                pstDocMasterTemplate.setFloat(FLD_TOP_MARGIN, docMasterTemplate.getTopMargin());
                pstDocMasterTemplate.setFloat(FLD_RIGHT_MARGIN, docMasterTemplate.getRightMargin());
                pstDocMasterTemplate.setFloat(FLD_LEFT_MARGIN, docMasterTemplate.getLeftMargin());
                pstDocMasterTemplate.setFloat(FLD_BOTTOM_MARGIN, docMasterTemplate.getBottomMargin());

                pstDocMasterTemplate.update();
                return docMasterTemplate.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterTemplate(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstDocMasterTemplate pstDocMasterTemplate = new PstDocMasterTemplate(oid);
            pstDocMasterTemplate.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMasterTemplate(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HR_DOC_MASTER_TEMPLATE;
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
                DocMasterTemplate docMasterTemplate = new DocMasterTemplate();
                resultToObject(rs, docMasterTemplate);
                lists.add(docMasterTemplate);
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
    
    public static String getfilename(long DocMasterId) {
        DBResultSet dbrs = null;
        String result = "";
        try {
            String sql = "SELECT " + PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TEMPLATE_FILE_NAME] + " FROM " + TBL_HR_DOC_MASTER_TEMPLATE + " WHERE "
                    + PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID] + " = " + DocMasterId;
sql= sql + " LIMIT 0,1 ";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getString(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TEMPLATE_FILE_NAME]);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }
      public static String getTemplateText(long DocMasterId) {
        DBResultSet dbrs = null;
        String result = "";
        try {
            String sql = "SELECT " + PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TEXT_TEMPLATE] + " FROM " + TBL_HR_DOC_MASTER_TEMPLATE + " WHERE "
                    + PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID] + " = " + DocMasterId;
                   sql= sql + " LIMIT 0,1 ";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getString(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TEXT_TEMPLATE]);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }
      
     public static String getNama(String sOid, String ObjectStatusfield) {
        DBResultSet dbrs = null;
        String result = "";
        long oid = Long.parseLong(sOid);
        try {
            if (ObjectStatusfield.equals("DIVISION")) {
                Division division = PstDivision.fetchExc(oid);
                result = division.getDivision();
            }
            if (ObjectStatusfield.equals("DEPARTMENT")) {
                Department department = PstDepartment.fetchExc(oid);
                result = department.getDepartment();
            }
            if (ObjectStatusfield.equals("EMPCAT")) {
                EmpCategory empCategory = PstEmpCategory.fetchExc(oid);
                result = empCategory.getEmpCategory();
            }
            if (ObjectStatusfield.equals("LEVEL")) {
                Level level = PstLevel.fetchExc(oid);
                result = level.getLevel();
            }
            if (ObjectStatusfield.equals("POSITION")) { 
                Position position = PstPosition.fetchExc(oid);
                result = position.getPosition();
            }
            if (ObjectStatusfield.equals("SECTION")) { 
                Section section = PstSection.fetchExc(oid);
                result = section.getSection();
            }
//            if (ObjectStatusfield.equals("SALARYLEVEL")) { 
//                SalaryLevel sLevel = PstSalaryLevel.fetchExc(oid);
//                result = sLevel.getLevelName();
//            }
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }  
      
      public static String escapeHTML(String s){
    int length = s.length();
    int newLength = length;
    boolean someCharacterEscaped = false;
    // first check for characters that might
    // be dangerous and calculate a length
    // of the string that has escapes.
    for (int i=0; i<length; i++){
      char c = s.charAt(i);
      int cint = 0xffff & c;
      if (cint < 32){
        switch(c){
          case '\r':
          case '\n':
          case '\t':
          case '\f':{
          } break;
          default: {
            newLength -= 1;
            someCharacterEscaped = true;
          }
        }
      } else {
        switch(c){
          case '\"':{
            newLength += 5;
            someCharacterEscaped = true;
          } break;
          case '&':
          case '\'':{
            newLength += 4;
            someCharacterEscaped = true;
          } break;
          case '<':
          case '>':{
            newLength += 3;
            someCharacterEscaped = true;
          } break;
        }
      }
    }
    if (!someCharacterEscaped){
      // nothing to escape in the string
      return s;
    }
    StringBuffer sb = new StringBuffer(newLength);
    for (int i=0; i<length; i++){
      char c = s.charAt(i);
      int cint = 0xffff & c;
      if (cint < 32){
        switch(c){
          case '\r':
          case '\n':
          case '\t':
          case '\f':{
            sb.append(c);
          } break;
          default: {
            // Remove this character
          }
        }
      } else {
        switch(c){
          case '\"':{
            sb.append("&quot;");
          } break;
          case '\'':{
            sb.append("&#39;");
          } break;
          case '&':{
            sb.append("&amp;");
          } break;
          case '<':{
            sb.append("&lt;");
          } break;
          case '>':{
            sb.append("&gt;");
          } break;
          default: {
            sb.append(c);
          }
        }
      }
    }
    return sb.toString();
  }

      
      
      public static void resultToObject(ResultSet rs, DocMasterTemplate docMasterTemplate) {
        try {
            docMasterTemplate.setOID(rs.getLong(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_TEMPLATE_ID]));
            docMasterTemplate.setDoc_master_id(rs.getLong(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_ID]));
            docMasterTemplate.setTemplate_title(rs.getString(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TEMPLATE_TITLE]));
            docMasterTemplate.setTemplate_filename(rs.getString(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TEMPLATE_FILE_NAME]));
            docMasterTemplate.setText_template(rs.getString(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TEXT_TEMPLATE]));
            docMasterTemplate.setText_header(rs.getString(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TEXT_HEADER]));
            docMasterTemplate.setText_footer(rs.getString(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TEXT_FOOTER]));
            docMasterTemplate.setTopMargin(rs.getFloat(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_TOP_MARGIN]));
            docMasterTemplate.setRightMargin(rs.getFloat(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_RIGHT_MARGIN]));
            docMasterTemplate.setLeftMargin(rs.getFloat(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_LEFT_MARGIN]));
            docMasterTemplate.setBottomMargin(rs.getFloat(PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_BOTTOM_MARGIN]));
            
        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long docMasterTemplateId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_DOC_MASTER_TEMPLATE + " WHERE "
                    + PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_TEMPLATE_ID] + " = " + docMasterTemplateId;

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
            String sql = "SELECT COUNT(" + PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_TEMPLATE_ID] + ") FROM " + TBL_HR_DOC_MASTER_TEMPLATE;
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

  public static void updateFileName(String fileName,long idDocTemp) {
        try {
            String sql = "UPDATE " + PstDocMasterTemplate.TBL_HR_DOC_MASTER_TEMPLATE+
            " SET " + PstDocMasterTemplate.fieldNames[FLD_TEMPLATE_FILE_NAME] + " = '" + fileName +"'"+
            " WHERE " + PstDocMasterTemplate.fieldNames[PstDocMasterTemplate.FLD_DOC_MASTER_TEMPLATE_ID] +
            " = " + idDocTemp ;           
            System.out.println("sql PstDocMasterTemplate.updateFileName : " + sql);
            int result = DBHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println("\tExc updateFileName : " + e.toString());
        } finally {
            //System.out.println("\tFinal updatePresenceStatus");
        }
    }
  
    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    DocMasterTemplate docMasterTemplate = (DocMasterTemplate) list.get(ls);
                    if (oid == docMasterTemplate.getOID()) {
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

  
}

