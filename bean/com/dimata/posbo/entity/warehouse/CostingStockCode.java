/**
 * Created by IntelliJ IDEA.
 * User: gadnyana
 * Date: Dec 9, 2004
 * Time: 11:22:01 AM
 * To change this template use Options | File Templates.
 */
package com.dimata.posbo.entity.warehouse;

import com.dimata.qdep.entity.Entity;

public class CostingStockCode extends Entity {
    private long costingMaterialItemId = 0;
    private String stockCode = "";

    public String getStockCode() {
        return stockCode;
    }

    public long getCostingMaterialItemId() {
        return costingMaterialItemId;
    }

    public void setCostingMaterialItemId(long costingMaterialItemId) {
        this.costingMaterialItemId = costingMaterialItemId;
    }

    public void setStockCode(String stockCode) {
        this.stockCode = stockCode;
    }

}
