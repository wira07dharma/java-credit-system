/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.masterdata;

/**
 *
 * @author Regen
 */
import com.dimata.qdep.entity.Entity;

public class JangkaWaktuMarkup extends Entity {


  private int markupPct = 0;
  private int markupType = 0;
  private int cashCalculation = 0;

  public int getMarkupPct() {
    return markupPct;
  }

  public void setMarkupPct(int markupPct) {
    this.markupPct = markupPct;
  }

  public int getMarkupType() {
    return markupType;
  }

  public void setMarkupType(int markupType) {
    this.markupType = markupType;
  }

  public void setJangkaWaktuMarkupId(long aLong) {
    throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
  }
  
  /**
   * @return the cashCalculation
   */
  public int getCashCalculation() {
    return cashCalculation;
  }

  /**
   * @param cashCalculation the cashCalculation to set
   */
  public void setCashCalculation(int cashCalculation) {
    this.cashCalculation = cashCalculation;
  }

}
