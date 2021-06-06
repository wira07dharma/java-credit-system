/**
 * Created by IntelliJ IDEA.
 * User: gadnyana
 * Date: Feb 28, 2006
 * Time: 11:30:51 AM
 * To change this template use Options | File Templates.
 */
package com.dimata.posbo.session.warehouse;

import com.dimata.posbo.db.DBResultSet;
import com.dimata.posbo.db.DBHandler;
import com.dimata.posbo.entity.search.SrcMinimumStock;
import com.dimata.posbo.entity.masterdata.Material;
import com.dimata.posbo.entity.masterdata.PstMaterial;
import com.dimata.posbo.entity.masterdata.PstMaterialStock;
import com.dimata.common.entity.location.Location;

import java.util.Vector;
import java.sql.ResultSet;

public class SessMinimumStock {

    public static String SESSION_MINIMUM_NAME = "SESSION_MINIMUM_NAME";

    // count minimun stock
    public static int getCountReportMinimumStock(SrcMinimumStock srcMinimumStock) {
        DBResultSet dbrs = null;
        int count = 0;
        try {
            String sqlUnion = "";
            String sql = "SELECT COUNT(" + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] + ") AS CNT " +
                    " FROM (";
            for (int k = 0; k < srcMinimumStock.getvLocation().size(); k++) {
                Location location = (Location) srcMinimumStock.getvLocation().get(k);
                sqlUnion = sqlUnion + "SELECT periode_id, material_unit_id " +
                        " FROM pos_material_stock where qty <= qty_min " +
                        " and periode_id = '" + srcMinimumStock.getPeriodId() + "'" +
                        " and location_id = '" + location.getOID() + "'";
                if (k < (srcMinimumStock.getvLocation().size() - 1)) {
                    sqlUnion = sqlUnion + " union ";
                }
            }
            sql = sql + sqlUnion + " ) as tbl " +
                    " inner join pos_material as m on tbl.material_unit_id = m.material_id " +
                    " group by periode_id ";

            // System.out.println("sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt("CNT");
            }
        } catch (Exception e) {
            System.out.println("err minimum stock : " + e.toString());
        }
        return count;
    }

    // minimun stock
    public static Vector getReportMinimumStock(SrcMinimumStock srcMinimumStock, int start, int recordToGet) {
        DBResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sqlUnion = "";
            String sql = "SELECT m." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    ",m." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    ",m." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    ",m." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    "," + createFieldSum(srcMinimumStock.getvLocation()) + " FROM (";

            for (int k = 0; k < srcMinimumStock.getvLocation().size(); k++) {
                Location location = (Location) srcMinimumStock.getvLocation().get(k);
                sqlUnion = sqlUnion + "SELECT location_id, material_unit_id, " +
                        createField(srcMinimumStock.getvLocation(), location.getOID(), k) +
                        " FROM " + PstMaterialStock.TBL_MATERIAL_STOCK + " AS ms";

                String where = "";
                boolean viewedData = false;
                if ((srcMinimumStock.getCategoryId() != 0) && (srcMinimumStock.getOidMerk() != 0)) {
                    sqlUnion = sqlUnion + " inner join pos_material as pm on " +
                            " ms.material_unit_id = pm.material_id ";
                    where = " pm.category_id=" + srcMinimumStock.getCategoryId() +
                            " and pm.merk_id=" + srcMinimumStock.getOidMerk();
                    
                    viewedData = true;

                } else if (srcMinimumStock.getCategoryId() != 0) {
                    sqlUnion = sqlUnion + " inner join pos_material as pm on " +
                            " ms.material_unit_id = pm.material_id ";
                    where = " pm.category_id=" + srcMinimumStock.getCategoryId();
                    viewedData = true;
                } else if (srcMinimumStock.getOidMerk() != 0) {
                    sqlUnion = sqlUnion + " inner join pos_material as pm on " +
                            " ms.material_unit_id = pm.material_id ";

                    where = " pm.merk_id=" + srcMinimumStock.getOidMerk();
                    viewedData = true;
                }
                
                if(viewedData){
                    if (where.length() > 0) {
                        where = where + " and pm.process_status !=" + PstMaterial.DELETE;
                    } else {
                        where = " pm.process_status !=" + PstMaterial.DELETE;
                    }
                }
                
                if (srcMinimumStock.getOidSupplier() != 0) {
                    sqlUnion = sqlUnion + " inner join pos_vendor_price as pvp on " +
                            " ms.material_unit_id = pvp.material_id ";

                    if (where.length() > 0) {

                        where = where + " and pvp.vendor_id=" + srcMinimumStock.getOidSupplier();

                    } else {
                        where = " pvp.vendor_id=" + srcMinimumStock.getOidSupplier();
                    }
                }

                //if(srcMinimumStock.getLocationId()!=0){
                if (where.length() > 0) {

                    where = where + " and ms.location_id=" + location.getOID();
                } else {
                    where = " ms.location_id=" + location.getOID();
                }
                //}

                if (srcMinimumStock.getPeriodId() != 0) {
                    if (where.length() > 0) {
                        where = where + " and ms.periode_id = " + srcMinimumStock.getPeriodId();
                    } else {
                        where = " ms.periode_id = " + srcMinimumStock.getPeriodId();
                    }
                }

                if (srcMinimumStock.getListOidMaterial().size() > 0) {
                    String wherematerial = "";
                    for (int j = 0; j < srcMinimumStock.getListOidMaterial().size(); j++) {
                        long oidMaterial = Long.parseLong((String) srcMinimumStock.getListOidMaterial().get(j));
                        if (wherematerial.length() == 0) {
                            wherematerial = " ms.material_unit_id=" + oidMaterial;
                        } else {
                            wherematerial = wherematerial + " or " + " ms.material_unit_id=" + oidMaterial;
                        }
                    }
                    wherematerial = "(" + wherematerial + ")";
                    if (where.length() > 0) {
                        where = where + " and " + wherematerial;
                    } else {
                        where = wherematerial;
                    }
                }

                if (where.length() > 0) {
                    sqlUnion = sqlUnion + " where " + where;
                }

                if (k < (srcMinimumStock.getvLocation().size() - 1)) {
                    sqlUnion = sqlUnion + " union ";
                }
            }

            sql = sql + sqlUnion + " ) as tbl ";
            sql = sql + " right join pos_material as m on tbl.material_unit_id = m.material_id ";

            if (srcMinimumStock.getOidSupplier() != 0) {
                sql = sql + " inner join pos_vendor_price as pvp on " +
                        " m.material_id = pvp.material_id ";
            }

            if (srcMinimumStock.getCategoryId() != 0) {
                sql = sql + " where m.category_id=" + srcMinimumStock.getCategoryId();
            }

            if (srcMinimumStock.getListOidMaterial().size() > 0) {
                String wherematerial = "";
                for (int k = 0; k < srcMinimumStock.getListOidMaterial().size(); k++) {
                    long oidMaterial = Long.parseLong((String) srcMinimumStock.getListOidMaterial().get(k));
                    if (wherematerial.length() == 0) {
                        wherematerial = "m.material_id=" + oidMaterial;
                    } else {
                        wherematerial = wherematerial + " or " + "m.material_id=" + oidMaterial;
                    }
                }
                wherematerial = "(" + wherematerial + ")";
                if (srcMinimumStock.getCategoryId() != 0) {
                    sql = sql + " and " + wherematerial;
                } else {
                    sql = sql + " where " + wherematerial;
                }
            }

            if (srcMinimumStock.getOidMerk() != 0) {
                if (srcMinimumStock.getCategoryId() != 0) {
                    sql = sql + " and m.merk_id=" + srcMinimumStock.getOidMerk();
                } else {
                    if (srcMinimumStock.getListOidMaterial().size() > 0) {
                        sql = sql + " and m.merk_id=" + srcMinimumStock.getOidMerk();
                    } else {
                        sql = sql + " where m.merk_id=" + srcMinimumStock.getOidMerk();
                    }
                }
            }

            if (srcMinimumStock.getListOidMaterial().size() > 0 ||
                    srcMinimumStock.getOidMerk() != 0 || srcMinimumStock.getCategoryId() != 0) {
                if (srcMinimumStock.getOidSupplier() != 0) {
                    sql = sql + " and pvp.vendor_id=" + srcMinimumStock.getOidSupplier();
                }
            } else {
                if (srcMinimumStock.getOidSupplier() != 0) {
                    sql = sql + " where pvp.vendor_id=" + srcMinimumStock.getOidSupplier();
                }
            }

            sql = sql + " group by m.sku";

            if (recordToGet != 0) {
                sql = sql + " limit " + start + "," + recordToGet;
            }

            System.out.println("sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector vitem = new Vector();
                Vector vMin = new Vector();
                Vector vStock = new Vector();
                Material material = new Material();
                material.setOID(rs.getLong(PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID]));
                material.setSku(rs.getString(PstMaterial.fieldNames[PstMaterial.FLD_SKU]));
                material.setName(rs.getString(PstMaterial.fieldNames[PstMaterial.FLD_NAME]));
                material.setDefaultStockUnitId(rs.getLong(PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID]));
                vitem.add(material);

                // ini untuk object minimum stock 
                for (int k = 0; k < srcMinimumStock.getvLocation().size(); k++) {
                    vMin.add(String.valueOf(rs.getDouble(getFieldSum(1, k, srcMinimumStock.getvLocation()))));
                }
                vitem.add(vMin);

                // ini untuk object stock on hand
                for (int k = 0; k < srcMinimumStock.getvLocation().size(); k++) {
                    vStock.add(String.valueOf(rs.getDouble(getFieldSum(0, k, srcMinimumStock.getvLocation()))));
                }
                vitem.add(vStock);

                list.add(vitem);
            }

        } catch (Exception e) {
            System.out.println("err minimum stock : " + e.toString());
        }
        return list;
    }

    // untuk menggabungkan field dari minimal stock
    private static String createField(Vector vectLoc, long oidLocation, int idx) {
        String str = "";
        if (vectLoc != null && vectLoc.size() > 0) {
            for (int k = 0; k < vectLoc.size(); k++) {
                Location loc = (Location) vectLoc.get(k);
                if (idx == 0) {
                    if (loc.getOID() == oidLocation) {
                        if (str.length() == 0) {
                            str = "qty as q" + k + ",qty_min as qm" + k;
                        } else {
                            str = str + ",qty as q" + k + ",qty_min as qm" + k;
                        }
                    } else {
                        if (str.length() == 0) {
                            str = "0 as q" + k + ",0 as qm" + k;
                        } else {
                            str = str + ",0 as q" + k + ",0 as qm" + k;
                        }
                    }
                } else {
                    if (loc.getOID() == oidLocation) {
                        if (str.length() == 0) {
                            str = "qty as q" + k + ",qty_min as qm" + k;
                        } else {
                            str = str + ",qty as q" + k + ",qty_min as qm" + k;
                        }
                    } else {
                        if (str.length() == 0) {
                            str = "0 as q" + k + ",0 as qm" + k;
                        } else {
                            str = str + ",0 as q" + k + ",0 as qm" + k;
                        }
                    }
                }
            }
        }
        return str;
    }

    // untuk menggabungkan field dari minimal stock
    private static String createFieldSum(Vector vectLoc) {
        String str = "";
        if (vectLoc != null && vectLoc.size() > 0) {
            for (int k = 0; k < vectLoc.size(); k++) {
                Location loc = (Location) vectLoc.get(k);
                if (str.length() == 0) {
                    str = "sum(q" + k + "),sum(qm" + k + ")";
                } else {
                    str = str + ",sum(q" + k + "),sum(qm" + k + ")";
                }
            }
        }
        return str;
    }

    // untuk menggabungkan field dari minimal stock
    private static String getFieldSum(int type, int idx, Vector vectLoc) {
        String str = "";
        if (vectLoc != null && vectLoc.size() > 0) {
            for (int k = 0; k < vectLoc.size(); k++) {
                // Location loc = (Location) vectLoc.get(k);
                if (idx == k) {
                    if (type == 0) {
                        str = "sum(q" + k + ")";
                    } else {
                        str = "sum(qm" + k + ")";
                    }
                    break;
                }
            }
        }
        return str;
    }

    //
    private Vector getQtyMinimumStock(long oidPeriod, long oidLocation) {
        DBResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "SELECT * FROM POS_MATERIAL_STOCK WHERE PERIODE_ID = 504404252370511713 AND LOCATION_ID = 504404271285127208";

        } catch (Exception e) {
            System.out.println("err minimum stock : " + e.toString());
        }
        return new Vector();
    }
}
