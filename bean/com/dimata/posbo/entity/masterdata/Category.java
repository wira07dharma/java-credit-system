/* Created on 	:  [date] [time] AM/PM
 *
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ]
 * Imput Parameters 	: [input parameter ...]
 * Output 		: [output ...]
 *******************************************************************/

package com.dimata.posbo.entity.masterdata;

/* package java */

import java.util.Date;

/* package qdep */
import com.dimata.qdep.entity.*;

/* package material */
import com.dimata.posbo.session.masterdata.*;

public class Category extends Entity {
    private String code = "";
    private String name = "";
    private double pointPrice = 1;
    //private double pointPrice = 0;
    private String description = "";

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        if (code == null) {
            code = "";
        }
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null) {
            name = "";
        }
        this.name = name;
    }

    /**
     * Getter for property pointPrice.
     * @return Value of property pointPrice.
     */
    public double getPointPrice() {
       // if (pointPrice == 0) {
           // pointPrice = 1;
      //  }
       if (pointPrice == 0) {
           pointPrice = 0;
      }
        return pointPrice;
    }

    /**
     * Setter for property pointPrice.
     * @param pointPrice New value of property pointPrice.
     */
    public void setPointPrice(double pointPrice) {
        this.pointPrice = pointPrice;
    }

}
