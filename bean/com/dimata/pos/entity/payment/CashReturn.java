/* Generated by Together */

package com.dimata.pos.entity.payment;

import com.dimata.qdep.entity.Entity;

public class CashReturn extends Entity {
    private long billMainId;
    private long currencyId;
    private double rate;
    private double amount;
    private int paymentStatus;
    
    public CashReturn() {}
    
    public long getBillMainId(){
        return billMainId;
    }
    public void setBillMainId(long billMainId){
        this.billMainId=billMainId;
    }
    public long getCurrencyId(){
        return currencyId;}
    public void setCurrencyId(long currencyId){
        this.currencyId=currencyId;}
    
    public double getRate(){
        return rate;}
    public void setRate(double rate){
        this.rate=rate;}
    
    public double getAmount(){
        return amount;}
    public void setAmount(double amount){
        this.amount=amount;}
    
    /**
     * Getter for property paymentStatus.
     * @return Value of property paymentStatus.
     */
    public int getPaymentStatus() {
        return paymentStatus;
    }
    
    /**
     * Setter for property paymentStatus.
     * @param paymentStatus New value of property paymentStatus.
     */
    public void setPaymentStatus(int paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
}
