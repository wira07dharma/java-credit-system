/*
 * SessAppUser.java
 *
 * Created on April 6, 2002, 7:04 AM
 */

package com.dimata.posbo.session.admin;

import com.dimata.posbo.entity.admin.*;
import com.dimata.posbo.db.*;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.pos.entity.balance.PstCashCashier;

import java.util.*;
import java.sql.*;

/**
 *
 * @author  ktanjana
 * @version
 */
public class SessAppUser {

    /** Creates new SessAppUser */
    public SessAppUser() {
    }

    //-------------------Relation AppUser and AppGroup--------------//

    public static Vector getUserGroup(long userID) {
        //System.out.println("---> in : getUserGroup(long userID)");
        PstUserGroup pstUserGroup = new PstUserGroup();
        PstAppGroup pstAppGroup = new PstAppGroup();
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {

            String sql = "SELECT AUG." + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] +
                    ", AUG." + PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] +
                    ", AG." + PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_NAME] +
                    ", AG." + PstAppGroup.fieldNames[PstAppGroup.FLD_DESCRIPTION] +
                    " FROM " + pstUserGroup.getTableName() + " AS AUG ," +
                    pstAppGroup.getTableName() + " AS AG " +
                    "WHERE AUG." + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] + " = '" +
                    userID + "'" +
                    " AND AUG." + PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] + " = " +
                    "AG." + PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_ID];

            //System.out.println(sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                AppGroup appGroup = new AppGroup();
                resultToObject(rs, appGroup);
                lists.add(appGroup);
            }
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }

        return new Vector();
    }


    private static void resultToObject(ResultSet rs, AppGroup appGroup) {
        try {
            appGroup.setOID(rs.getLong(PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_ID]));
            appGroup.setGroupName(rs.getString(PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_NAME]));
            appGroup.setDescription(rs.getString(PstAppGroup.fieldNames[PstAppGroup.FLD_DESCRIPTION]));

        } catch (Exception e) {
            System.out.println("resultToObject() " + e.toString());
        }
    }


    // PATERN ## INSERT WITH Vector of  UserGroup
    /**
     * return false if error
     **/
    public static boolean setUserGroup(long userOID, Vector vector) {

        // do delete
        if (PstUserGroup.deleteByUser(userOID) == 0)
            return false;

        if (vector == null || vector.size() == 0)
            return true;

        // than insert
        for (int i = 0; i < vector.size(); i++) {
            UserGroup ug = (UserGroup) vector.get(i);
            if (PstUserGroup.insert(ug) == 0)
                return false;
        }
        return true;
    }

    /**
     *
     * @param discountTypeId
     * @return
     */
    public static boolean readyDataToDelete(long userId) {
        boolean status = true;
        try {
            // pengecekan di bill main
            String where = PstBillMain.fieldNames[PstBillMain.FLD_APPUSER_ID] + "=" + userId;
            Vector vlist = PstBillMain.list(0, 0, where, "");
            if (vlist != null && vlist.size() > 0) {
                status = false;
            } else {
                // pengecekan di cash cashier
                where = PstCashCashier.fieldNames[PstCashCashier.FLD_APPUSER_ID] + "=" + userId;
                vlist = PstCashCashier.list(0, 0, where, "");
                if (vlist != null && vlist.size() > 0) {
                    status = false;
                }
            }
        } catch (Exception e) {
            System.out.println("SessAppUser - readyDataToDelete : " + e.toString());
        }
        return status;
    }
}
