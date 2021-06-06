/**
 * Created by IntelliJ IDEA.
 * User: gadnyana
 * Date: Jun 3, 2005
 * Time: 3:42:22 PM
 * To change this template use Options | File Templates.
 */
package com.dimata.posbo.session.masterdata;

import com.dimata.posbo.entity.masterdata.PstMaterial;
import java.util.Vector;

public class SessCategory {
    /**
     *
     * @param categoryId
     * @return
     */
    public static boolean readyDataToDelete(long categoryId) {
        boolean status = true;
        try {
            String where = PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + "=" + categoryId;
            Vector vlist = PstMaterial.list(0, 0, where, "");
            if (vlist != null && vlist.size() > 0) {
                status = false;
            }
        } catch (Exception e) {
            System.out.println("SessCategory - readyDataToDelete : " + e.toString());
        }
        return status;
    }
}
