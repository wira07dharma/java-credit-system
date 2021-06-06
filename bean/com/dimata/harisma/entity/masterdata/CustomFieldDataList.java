/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 * Date : 2015-06-15
 *
 * @author Hendra Putu
 */
import com.dimata.qdep.entity.Entity;

public class CustomFieldDataList extends Entity {

    private String dataListCaption = "";
    private String dataListValue = "";
    private long customFieldId = 0;

    public String getDataListCaption() {
        return dataListCaption;
    }

    public void setDataListCaption(String dataListCaption) {
        this.dataListCaption = dataListCaption;
    }

    public String getDataListValue() {
        return dataListValue;
    }

    public void setDataListValue(String dataListValue) {
        this.dataListValue = dataListValue;
    }

    public long getCustomFieldId() {
        return customFieldId;
    }

    public void setCustomFieldId(long customFieldId) {
        this.customFieldId = customFieldId;
    }

}
