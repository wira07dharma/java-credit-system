/*
 * Session Name  	:  SessMemberReg.java
 * Created on 	:  [date] [time] AM/PM
 *
 * @author  	:  [authorName]
 * @version  	:  [version]
 */

/*******************************************************************
 * Class Description 	: [project description ... ]
 * Imput Parameters 	: [input parameter ...]
 * Output 		: [output ...]
 *******************************************************************/
package com.dimata.posbo.session.masterdata;/* java package */

import java.util.*;

import com.dimata.posbo.entity.search.*;
import com.dimata.harisma.entity.masterdata.Religion;
import com.dimata.harisma.entity.masterdata.PstReligion;
import com.dimata.common.entity.contact.*;
import com.dimata.posbo.entity.masterdata.*;
import com.dimata.posbo.db.DBResultSet;
import com.dimata.posbo.db.DBHandler;
import com.dimata.util.*;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.pos.entity.billing.PstPendingOrder;

import java.sql.*;

public class SessMemberReg {
    public static final String SESS_SRC_MEMBERREG = "SESSION_SRC_MEMBERREG";


    private static Vector logicParser(String text) {

        Vector vector = new Vector(1, 1);
        if (text != null && text.length() > 0) {
            vector = LogicParser.textSentence(text);
            for (int i = 0; i < vector.size(); i++) {
                String code = (String) vector.get(i);
                if (((vector.get(vector.size() - 1)).equals(LogicParser.SIGN))
                        && ((vector.get(vector.size() - 1)).equals(LogicParser.ENGLISH))) {
                    vector.remove(vector.size() - 1);
                }
            }
        }//

        return vector;
    }


    public static Vector searchMemberReg(SrcMemberReg srcmemberreg, int start, int recordToGet) {

        Vector result = new Vector(1, 1);
        DBResultSet dbrs = null;
        try {

            String sql = " SELECT MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_CODE] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_HOME_ADDR] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_HOME_TELP] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_TELP_MOBILE] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_HOME_FAX] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_HOME_TOWN] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_BARCODE] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_BIRTH_DATE] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_COUNTER] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_GROUP_ID] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_ID_CARD_NUMBER] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_LAST_UPDATE] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_RELIGION_ID] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_SEX] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_STATUS] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_COMP_NAME] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_BUSS_ADDRESS] +
                    ", RLG." + PstReligion.fieldNames[PstReligion.FLD_RELIGION] +
                    ", GRP." + PstMemberGroup.fieldNames[PstMemberGroup.FLD_NAME] +
                    ", GRP." + PstMemberGroup.fieldNames[PstMemberGroup.FLD_CODE] +
                    ", GRP." + PstMemberGroup.fieldNames[PstMemberGroup.FLD_GROUP_TYPE] +
                    " FROM " + PstMemberReg.TBL_CONTACT_LIST + " AS MBR " +
                    " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " AS ASG " +
                    " ON MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID] +
                    " = ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] +
                    " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " AS CLS " +
                    " ON ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] +
                    " = CLS." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] +
                    " LEFT JOIN " + PstReligion.TBL_HR_RELIGION + " AS RLG " +
                    " ON MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_RELIGION_ID] +
                    " = RLG." + PstReligion.fieldNames[PstReligion.FLD_RELIGION_ID] +
                    " INNER JOIN " + PstMemberGroup.TBL_MEMBER_GROUP + " AS GRP " +
                    " ON MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_GROUP_ID] +
                    " = GRP." + PstMemberGroup.fieldNames[PstMemberGroup.FLD_MEMBER_GROUP_ID] +
                    " WHERE CLS." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] +
                    " = " + PstContactClass.CONTACT_TYPE_MEMBER + " AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PROCESS_STATUS] +
                    " != " + PstMemberReg.DELETE;

            /*"ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] +
            " = (SELECT " + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] +
            " FROM " + PstContactClass.TBL_CONTACT_CLASS +
            " WHERE " +*/


            if (srcmemberreg != null) {
                Vector vectData = logicParser(srcmemberreg.getBarcode());
                String strWhere = "";
                if (vectData != null && vectData.size() > 0) {
                    strWhere = strWhere + "(";
                    for (int i = 0; i < vectData.size(); i++) {
                        String str = (String) vectData.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            strWhere = strWhere + " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_BARCODE] +
                                    " LIKE '%" + str.trim() + "%' ";
                        } else {
                            strWhere = strWhere + str.trim();
                        }
                    }
                    strWhere = strWhere + ")";
                }

                if (strWhere != null && strWhere.length() > 0) {
                    sql = sql + " AND " + strWhere;
                }

                vectData = logicParser(srcmemberreg.getName());
                strWhere = "";
                if (vectData != null && vectData.size() > 0) {
                    strWhere = strWhere + "(";
                    for (int i = 0; i < vectData.size(); i++) {
                        String str = (String) vectData.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            strWhere = strWhere + " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME] +
                                    " LIKE '%" + str.trim() + "%' ";
                        } else {
                            strWhere = strWhere + str.trim();
                        }
                    }
                    strWhere = strWhere + ")";
                }

                if (strWhere != null && strWhere.length() > 0) {
                    sql = sql + " AND " + strWhere;
                }

                if (srcmemberreg.getReligion() != 0) {
                    sql = sql + " AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_RELIGION_ID] +
                            " = " + srcmemberreg.getReligion();
                }

                if (srcmemberreg.getGroupmember() != 0) {
                    sql = sql + " AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_GROUP_ID] +
                            " = " + srcmemberreg.getGroupmember();
                }

                if (!srcmemberreg.isAllBirthDate()) {
                    sql = sql + " AND (MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_BIRTH_DATE] +
                            " BETWEEN '" + Formater.formatDate(srcmemberreg.getBirthDateFrom(), "yyyy-MM-dd") + "' " +
                            " AND '" + Formater.formatDate(srcmemberreg.getBirthDateTo(), "yyyy-MM-dd") + "') ";
                }

                if (!srcmemberreg.isAllRegDate()) {
                    sql = sql + " AND (MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_REGDATE] +
                            " BETWEEN '" + Formater.formatDate(srcmemberreg.getRegDateFrom(), "yyyy-MM-dd") + "' " +
                            " AND '" + Formater.formatDate(srcmemberreg.getRegDateTo(), "yyyy-MM-dd") + "') ";
                }

                if (srcmemberreg.getStatus() > -1) {
                    sql = sql + " AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_STATUS] +
                            " = " + srcmemberreg.getStatus();
                }

                if (srcmemberreg.getSortBy() == srcmemberreg.MEMBER_NAME) {
                    sql = sql + " ORDER BY MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME];
                } else if (srcmemberreg.getSortBy() == srcmemberreg.MEMBER_BARCODE) {
                    sql = sql + " ORDER BY MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_BARCODE];
                } else if (srcmemberreg.getSortBy() == srcmemberreg.TIPE_MEMBER) {
                    sql = sql + " ORDER BY GRP." + PstMemberGroup.fieldNames[PstMemberGroup.FLD_GROUP_TYPE] +
                            ", GRP." + PstMemberGroup.fieldNames[PstMemberGroup.FLD_CODE];
                }

            }

            if (recordToGet != 0) {
                switch (com.dimata.pos.db.DBHandler.DBSVR_TYPE) {
                    case com.dimata.pos.db.DBHandler.DBSVR_MYSQL:
                        if (start == 0 && recordToGet == 0)
                            sql = sql + "";
                        else
                            sql = sql + " LIMIT " + start + "," + recordToGet;
                        break;
                    case com.dimata.pos.db.DBHandler.DBSVR_POSTGRESQL:
                        if (start == 0 && recordToGet == 0)
                            sql = sql + "";
                        else
                            sql = sql + " LIMIT " + recordToGet + " OFFSET " + start;
                        break;
                    case com.dimata.pos.db.DBHandler.DBSVR_SYBASE:
                        break;
                    case com.dimata.pos.db.DBHandler.DBSVR_ORACLE:
                        break;
                    case com.dimata.pos.db.DBHandler.DBSVR_MSSQL:
                        break;

                    default:
                        if (start == 0 && recordToGet == 0)
                            sql = sql + "";
                        else
                            sql = sql + " LIMIT " + start + "," + recordToGet;
                }
                // sql = sql + " LIMIT " + start + "," + recordToGet;
            }

            //System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>> sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector temp = new Vector(1, 1);
                MemberReg member = new MemberReg();
                member.setCompName(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_COMP_NAME]));
                member.setContactCode(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_CODE]));
                member.setOID(rs.getLong(PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID]));
                member.setPersonName(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME]));
                member.setHomeAddr(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_HOME_ADDR]));
                member.setHomeTelp(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_HOME_TELP]));
                member.setTelpMobile(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_TELP_MOBILE]));
                member.setHomeFax(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_HOME_FAX]));
                member.setHomeTown(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_HOME_TOWN]));
                member.setMemberBirthDate(rs.getDate(PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_BIRTH_DATE]));
                member.setMemberGroupId(rs.getLong(PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_GROUP_ID]));
                member.setMemberBarcode(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_BARCODE]));
                member.setMemberCounter(rs.getInt(PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_COUNTER]));
                member.setMemberIdCardNumber(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_ID_CARD_NUMBER]));
                member.setMemberLastUpdate(rs.getDate(PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_LAST_UPDATE]));
                member.setMemberReligionId(rs.getLong(PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_RELIGION_ID]));
                member.setMemberSex(rs.getInt(PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_SEX]));
                member.setMemberStatus(rs.getInt(PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_STATUS]));
                member.setBussAddress(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_BUSS_ADDRESS]));

                temp.add(member);

                Religion religion = new Religion();
                religion.setReligion(rs.getString(PstReligion.fieldNames[PstReligion.FLD_RELIGION]));
                temp.add(religion);

                MemberGroup mGroup = new MemberGroup();
                mGroup.setCode(rs.getString(PstMemberGroup.fieldNames[PstMemberGroup.FLD_CODE]));
                mGroup.setName(rs.getString(PstMemberGroup.fieldNames[PstMemberGroup.FLD_NAME]));
                mGroup.setGroupType(rs.getInt(PstMemberGroup.fieldNames[PstMemberGroup.FLD_GROUP_TYPE]));
                temp.add(mGroup);

                result.add(temp);
            }
        } catch (Exception e) {
            System.out.println("err di search member : " + e.toString());
            e.printStackTrace();
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }

    public static Vector searchSupplier(SrcMemberReg srcmemberreg, int start, int recordToGet) {

        Vector result = new Vector(1, 1);
        DBResultSet dbrs = null;
        try {

            String sql = " SELECT MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_CODE] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_LASTNAME] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_TELP_NR] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_FAX] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_BUSS_ADDRESS] +
                    ", MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_COMP_NAME] +
                    " FROM " + PstMemberReg.TBL_CONTACT_LIST + " AS MBR " +
                    " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " AS ASG " +
                    " ON MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID] +
                    " = ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] +
                    " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " AS CLS " +
                    " ON ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] +
                    " = CLS." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] +
                    " WHERE CLS." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] +
                    " = " + PstContactClass.CONTACT_TYPE_SUPPLIER + " AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PROCESS_STATUS] +
                    " != " + PstMemberReg.DELETE;

            /*" WHERE ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] +
            " = (SELECT " + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] +
            " FROM " + PstContactClass.TBL_CONTACT_CLASS +
            " WHERE " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] +
            " = " + PstContactClass.CONTACT_TYPE_SUPPLIER + ") AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PROCESS_STATUS] +
            " != " + PstMemberReg.DELETE;*/


            if (srcmemberreg != null) {
                Vector vectData = logicParser(srcmemberreg.getCodeSupplier());
                String strWhere = "";
                if (vectData != null && vectData.size() > 0) {
                    strWhere = strWhere + "(";
                    for (int i = 0; i < vectData.size(); i++) {
                        String str = (String) vectData.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            strWhere = strWhere + " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_CODE] +
                                    " LIKE '%" + str.trim() + "%' ";
                        } else {
                            strWhere = strWhere + str.trim();
                        }
                    }
                    strWhere = strWhere + ")";
                }

                if (strWhere != null && strWhere.length() > 0) {
                    sql = sql + " AND " + strWhere;
                }

                vectData = logicParser(srcmemberreg.getCompanyName());
                strWhere = "";
                if (vectData != null && vectData.size() > 0) {
                    strWhere = strWhere + "(";
                    for (int i = 0; i < vectData.size(); i++) {
                        String str = (String) vectData.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            strWhere = strWhere + " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_COMP_NAME] +
                                    " LIKE '%" + str.trim() + "%' ";
                        } else {
                            strWhere = strWhere + str.trim();
                        }
                    }
                    strWhere = strWhere + ")";
                }

                if (strWhere != null && strWhere.length() > 0) {
                    sql = sql + " AND " + strWhere;
                }

                vectData = logicParser(srcmemberreg.getContactPerson());
                strWhere = "";
                if (vectData != null && vectData.size() > 0) {
                    strWhere = strWhere + "(";
                    for (int i = 0; i < vectData.size(); i++) {
                        String str = (String) vectData.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            strWhere = strWhere + " (MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME] +
                                    " LIKE '%" + str.trim() + "%' OR " +
                                    " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_LASTNAME] +
                                    " LIKE '%" + str.trim() + "%')  ";
                        } else {
                            strWhere = strWhere + str.trim();
                        }
                    }
                    strWhere = strWhere + ")";
                }

                if (strWhere != null && strWhere.length() > 0) {
                    sql = sql + " AND " + strWhere;
                }


                if (srcmemberreg.getSortBy() == srcmemberreg.MEMBER_NAME) {
                    sql = sql + " ORDER BY MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_COMP_NAME] +
                            " ,MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME] +
                            " ,MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_LASTNAME];
                } else {
                    sql = sql + " ORDER BY MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_CODE];
                }

            }

            if (recordToGet != 0) {
                sql = sql + " LIMIT " + start + "," + recordToGet;
            }

            //System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>> sql : "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector temp = new Vector(1, 1);
                ContactList member = new ContactList();
                member.setCompName(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_COMP_NAME]));
                member.setContactCode(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_CODE]));
                member.setOID(rs.getLong(PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID]));
                member.setPersonName(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME]));
                member.setPersonLastname(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_LASTNAME]));
                member.setTelpNr(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_TELP_NR]));
                member.setFax(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_FAX]));
                member.setBussAddress(rs.getString(PstMemberReg.fieldNames[PstMemberReg.FLD_BUSS_ADDRESS]));


                result.add(member);
            }
        } catch (Exception e) {
            System.out.println("err di search supplier : " + e.toString());
            e.printStackTrace();
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCountSearch(SrcMemberReg srcmemberreg) {

        int count = 0;
        DBResultSet dbrs = null;
        try {

            String sql = " SELECT COUNT(" +
                    " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID] +
                    ") " +
                    " FROM " + PstMemberReg.TBL_CONTACT_LIST + " AS MBR " +
                    " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " AS ASG " +
                    " ON MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID] +
                    " = ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] +
                    " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " AS CLS " +
                    " ON ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] +
                    " = CLS." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] +
                    " INNER JOIN " + PstReligion.TBL_HR_RELIGION + " AS RLG " +
                    " ON MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_RELIGION_ID] +
                    " = RLG." + PstReligion.fieldNames[PstReligion.FLD_RELIGION_ID] +
                    " INNER JOIN " + PstMemberGroup.TBL_MEMBER_GROUP + " AS GRP " +
                    " ON MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_GROUP_ID] +
                    " = GRP." + PstMemberGroup.fieldNames[PstMemberGroup.FLD_MEMBER_GROUP_ID] +
                    " WHERE CLS." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] +
                    " = " + PstContactClass.CONTACT_TYPE_MEMBER + " AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PROCESS_STATUS] +
                    " != " + PstMemberReg.DELETE;

            /*" WHERE ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] +
            " = (SELECT " + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] +
            " FROM " + PstContactClass.TBL_CONTACT_CLASS +
            " WHERE " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] +
            " = " + PstContactClass.CONTACT_TYPE_MEMBER + ") AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PROCESS_STATUS] +
            " != " + PstMemberReg.DELETE;*/


            if (srcmemberreg != null) {
                Vector vectData = logicParser(srcmemberreg.getBarcode());
                String strWhere = "";
                if (vectData != null && vectData.size() > 0) {
                    strWhere = strWhere + "(";
                    for (int i = 0; i < vectData.size(); i++) {
                        String str = (String) vectData.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            strWhere = strWhere + " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_BARCODE] +
                                    " LIKE '%" + str.trim() + "%' ";
                        } else {
                            strWhere = strWhere + str.trim();
                        }
                    }
                    strWhere = strWhere + ")";
                }

                if (strWhere != null && strWhere.length() > 0) {
                    sql = sql + " AND " + strWhere;
                }

                vectData = logicParser(srcmemberreg.getName());
                strWhere = "";
                if (vectData != null && vectData.size() > 0) {
                    strWhere = strWhere + "(";
                    for (int i = 0; i < vectData.size(); i++) {
                        String str = (String) vectData.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            strWhere = strWhere + " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME] +
                                    " LIKE '%" + str.trim() + "%' ";
                        } else {
                            strWhere = strWhere + str.trim();
                        }
                    }
                    strWhere = strWhere + ")";
                }

                if (strWhere != null && strWhere.length() > 0) {
                    sql = sql + " AND " + strWhere;
                }

                if (srcmemberreg.getReligion() != 0) {
                    sql = sql + " AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_RELIGION_ID] +
                            " = " + srcmemberreg.getReligion();
                }

                if (srcmemberreg.getGroupmember() != 0) {
                    sql = sql + " AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_GROUP_ID] +
                            " = " + srcmemberreg.getGroupmember();
                }

                if (!srcmemberreg.isAllBirthDate()) {
                    sql = sql + " AND (MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_BIRTH_DATE] +
                            " BETWEEN '" + Formater.formatDate(srcmemberreg.getBirthDateFrom(), "yyyy-MM-dd") + "' " +
                            " AND '" + Formater.formatDate(srcmemberreg.getBirthDateTo(), "yyyy-MM-dd") + "') ";
                }

                if (!srcmemberreg.isAllRegDate()) {
                    sql = sql + " AND (MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_REGDATE] +
                            " BETWEEN '" + Formater.formatDate(srcmemberreg.getRegDateFrom(), "yyyy-MM-dd") + "' " +
                            " AND '" + Formater.formatDate(srcmemberreg.getRegDateTo(), "yyyy-MM-dd") + "') ";
                }

                if (srcmemberreg.getStatus() > -1) {
                    sql = sql + " AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_MEMBER_STATUS] +
                            " = " + srcmemberreg.getStatus();
                }

            }


            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("err di count member : " + e.toString());
            e.printStackTrace();
        } finally {
            DBResultSet.close(dbrs);
            return count;
        }


    }

    public static int getCountSupplier(SrcMemberReg srcmemberreg) {

        int count = 0;
        DBResultSet dbrs = null;
        try {

            String sql = " SELECT COUNT(" +
                    " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID] +
                    ") " +
                    " FROM " + PstMemberReg.TBL_CONTACT_LIST + " AS MBR " +
                    " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " AS ASG " +
                    " ON MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_ID] +
                    " = ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] +
                    " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " AS CLS " +
                    " ON ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] +
                    " = CLS." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] +
                    " WHERE CLS." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] +
                    " = " + PstContactClass.CONTACT_TYPE_SUPPLIER + " AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PROCESS_STATUS] +
                    " != " + PstMemberReg.DELETE;

            /*" WHERE ASG." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] +
            " = (SELECT " + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] +
            " FROM " + PstContactClass.TBL_CONTACT_CLASS +
            " WHERE " + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] +
            " = " + PstContactClass.CONTACT_TYPE_SUPPLIER + ") AND MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PROCESS_STATUS] +
            " != " + PstMemberReg.DELETE;*/


            if (srcmemberreg != null) {
                Vector vectData = logicParser(srcmemberreg.getCodeSupplier());
                String strWhere = "";
                if (vectData != null && vectData.size() > 0) {
                    strWhere = strWhere + "(";
                    for (int i = 0; i < vectData.size(); i++) {
                        String str = (String) vectData.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            strWhere = strWhere + " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_CONTACT_CODE] +
                                    " LIKE '%" + str.trim() + "%' ";
                        } else {
                            strWhere = strWhere + str.trim();
                        }
                    }
                    strWhere = strWhere + ")";
                }

                if (strWhere != null && strWhere.length() > 0) {
                    sql = sql + " AND " + strWhere;
                }

                vectData = logicParser(srcmemberreg.getCompanyName());
                strWhere = "";
                if (vectData != null && vectData.size() > 0) {
                    strWhere = strWhere + "(";
                    for (int i = 0; i < vectData.size(); i++) {
                        String str = (String) vectData.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            strWhere = strWhere + " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_COMP_NAME] +
                                    " LIKE '%" + str.trim() + "%' ";
                        } else {
                            strWhere = strWhere + str.trim();
                        }
                    }
                    strWhere = strWhere + ")";
                }

                if (strWhere != null && strWhere.length() > 0) {
                    sql = sql + " AND " + strWhere;
                }

                vectData = logicParser(srcmemberreg.getContactPerson());
                strWhere = "";
                if (vectData != null && vectData.size() > 0) {
                    strWhere = strWhere + "(";
                    for (int i = 0; i < vectData.size(); i++) {
                        String str = (String) vectData.get(i);
                        if (!LogicParser.isInSign(str) && !LogicParser.isInLogEnglish(str)) {
                            strWhere = strWhere + " (MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_NAME] +
                                    " LIKE '%" + str.trim() + "%' OR " +
                                    " MBR." + PstMemberReg.fieldNames[PstMemberReg.FLD_PERSON_LASTNAME] +
                                    " LIKE '%" + str.trim() + "%')  ";
                        } else {
                            strWhere = strWhere + str.trim();
                        }
                    }
                    strWhere = strWhere + ")";
                }

                if (strWhere != null && strWhere.length() > 0) {
                    sql = sql + " AND " + strWhere;
                }


            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("err di count supplier : " + e.toString());
            e.printStackTrace();
        } finally {
            DBResultSet.close(dbrs);
            return count;
        }
    }

    /**
     * ini
     * @param oidMemberReg
     * @return
     */
    public static boolean readyDataToDelete(long oidMemberReg) {
        boolean status = true;
        try {
            // ini untuk pengecekan data di penjualan
            String where = PstBillMain.fieldNames[PstBillMain.FLD_CUSTOMER_ID] + "=" + oidMemberReg;
            Vector vList = PstBillMain.list(0, 0, where, "");
            if (vList != null && vList.size() > 0) {
                status = false;
            } else {
                where = PstPendingOrder.fieldNames[PstPendingOrder.FLD_MEMBER_ID] + "=" + oidMemberReg;
                vList = PstPendingOrder.list(0, 0, where, "");
                if (vList != null && vList.size() > 0) {
                    status = false;
                } else {
                    where = PstMemberPoin.fieldNames[PstMemberPoin.FLD_MEMBER_ID] + "=" + oidMemberReg;
                    vList = PstMemberPoin.list(0, 0, where, "");
                    if (vList != null && vList.size() > 0) {
                        status = false;
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("SessLocation - readyDataToDelete : " + e.toString());
        }
        return status;
    }
}
