/**
 * Created by IntelliJ IDEA.
 * User: gadnyana
 * Date: Jun 6, 2005
 * Time: 10:31:05 AM
 * To change this template use Options | File Templates.
 */
package com.dimata.posbo.session.masterdata;

import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.pos.entity.billing.PstPendingOrder;

import java.util.Vector;

public class SessSales {

    /**
     * pengecekan data sales di bill main
     * dan pending order
     * @param salesId
     * @param salesCode
     * @return
     */
    public static boolean readyDataToDelete(long salesId, String salesCode) {
        boolean status = true;
        try {
            String where = PstPendingOrder.fieldNames[PstPendingOrder.FLD_SALES_ID] + "=" + salesId;
            Vector vlist = PstPendingOrder.list(0, 0, where, "");
            if (vlist != null && vlist.size() > 0) {
                status = false;
            }else{
                where = PstBillMain.fieldNames[PstBillMain.FLD_SALES_CODE] + "='" + salesCode +"'";
                vlist = PstBillMain.list(0, 0, where, "");
                if (vlist != null && vlist.size() > 0) {
                    status = false;
                }
            }
        } catch (Exception e) {
            System.out.println("SessSales - readyDataToDelete : " + e.toString());
        }
        return status;
    }
}
