/*
 * SessProdCostOnLGR.java
 *
 * Created on January 18, 2005, 7:58 AM
 */

package com.dimata.ij.session.engine;

// core java package
import java.util.Vector;
import java.util.Date;
import java.util.Hashtable;  

// qdep package
import com.dimata.qdep.entity.I_DocStatus;

// ij package
import com.dimata.ij.I_IJGeneral;
import com.dimata.ij.ibosys.*;
import com.dimata.ij.iaiso.*;
import com.dimata.ij.entity.mapping.*;

/**
 *
 * @author  gedhy
 */
public class SessProdCostOnLGR {
    
    // define journal note for transaction Production Cost On LGR
    public static String strJournalNote[] = 
    {
        "Transaksi biaya produksi pada saat LGR",  
        "Production cost on LGR transaction"
    };
    
    
    /**     
     * Generate list of ProdCost on LGR journal based on selected document on selected Bo system
     *
     * @param <CODE>dSelectedDate</CODE>Date of transaction selected by user
     * @param <CODE>iDocTypeReference</CODE>Dococument type of selected document that will linking it to generated journal
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return Number of LGR Journal process
     * @created by Edhy
     *
     * @algoritm :
     *  1. iterate as long as location count to generate LGRJournal
     */    
    public int generateProdCostOnLGRJournal(Date selectedDate, int docTypeReference, IjEngineParam objIjEngineParam)    
    {
        int result = 0;        
        
        Vector vLocationOid = objIjEngineParam.getVLocationOid();
        if(vLocationOid!=null && vLocationOid.size()>0)
        {
            int iLocationCount = vLocationOid.size();
            for(int i=0; i<iLocationCount; i++)
            {
                long lLocationOid = Long.parseLong(String.valueOf(vLocationOid.get(i)));
                result = result + generateProdCostOnLGRJournal(lLocationOid, selectedDate, docTypeReference, objIjEngineParam);                
            }
        }                
        
        return result;         
    }

    
    /**
     *  Generate list of ProdCost on LGR journal based on selected document on selected Bo system
     *
     * @param <CODE>lLocationOid</CODE>ID of Location object of transaction
     * @param <CODE>selectedDate</CODE>Date of transaction selected by user
     * @param <CODE>docTypeReference</CODE>Dococument type of selected document that will linking it to generated journal
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return Number of LGR Journal process
     * @created by Edhy
     *
     * @algoritm :
     *  1. get list of LGR Document from selected BO system
     *  2. iterate as long as document count to generate LGRJournal 
     */    
    public int generateProdCostOnLGRJournal(long lLocationOid, Date selectedDate, int docTypeReference, IjEngineParam objIjEngineParam)    
    {
        int result = 0;                
        
        Vector vectOfProdCostOnLGRDoc = new Vector(1,1); 
        try
        {            
            // --- start get list of LGR Document from selected BO system ---
            String strIjImplBo = objIjEngineParam.getSIjImplBo();
            I_BOSystem i_bosys = (I_BOSystem) Class.forName(strIjImplBo).newInstance();                                    
            vectOfProdCostOnLGRDoc = i_bosys.getListProductionCostOnLGR(lLocationOid,selectedDate);            
            // --- end get list of LGR Document from selected BO system ---   
            
            // --- start iterate as long as document count to generate LGRJournal ---
            if(vectOfProdCostOnLGRDoc!=null && vectOfProdCostOnLGRDoc.size()>0)
            {
                int maxProdCostOnLGRDoc = vectOfProdCostOnLGRDoc.size();
                for(int i=0; i<maxProdCostOnLGRDoc; i++)
                {
                    IjProdCostOnLGRDoc objIjProdCostOnLGRDoc = (IjProdCostOnLGRDoc) vectOfProdCostOnLGRDoc.get(i);                                
                    long lResult = genJournalOfObjProdCostOnLGR(lLocationOid, objIjProdCostOnLGRDoc, docTypeReference, objIjEngineParam);                    
                }
            }        
            else
            {
                System.out.println(".::MSG : Because no document found, journaling DP on Sales Order process skip ... ");
            }            
            // --- end iterate as long as document count to generate LGRJournal ---
        }
        catch(Exception e)
        {
            System.out.println(".:: ERR : Exception when instantiate interface");
        }        
        return result;         
    }
    
    
    /**
     * Generate LGR journal based on IjProdCostOnLGRDoc
     *
     * @param <CODE>lLocationOid</CODE>ID of Location object of transaction
     * @param <CODE>objIjProdCostOnLGRDoc</CODE>object IjProdCostOnLGRDoc
     * @param <CODE>docTypeReference</CODE>Dococument type of selected document that will linking it to generated journal
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return OID of LGR Journal
     * @created by Edhy
     */    
    public long genJournalOfObjProdCostOnLGR(long lLocationOid, IjProdCostOnLGRDoc objIjProdCostOnLGRDoc, int iDocTypeReference, IjEngineParam objIjEngineParam)    
    {
        long lResult = 0;        
        
        Hashtable hashStandartRate = objIjEngineParam.getHStandartRate();
        String strStandartRate = (hashStandartRate.get(""+objIjProdCostOnLGRDoc.getDocTransCurrency())) != null ? ""+hashStandartRate.get(""+objIjProdCostOnLGRDoc.getDocTransCurrency()) : "1";
        double standartRate = Double.parseDouble(strStandartRate);
        
        // 1. pembuatan object ij jurnal main
        IjJournalMain objIjJournalMain = genObjIjJournalMain(objIjProdCostOnLGRDoc, iDocTypeReference, objIjEngineParam);        

        // 2. start pembuatan vector of object ij jurnal detail
        Vector vectOfObjIjJurDetail = new Vector(1,1);
        
            // 2.1 object which handle data journal detail that will insert into db
            Vector vWIP = genObjIjJDOfWIP(objIjProdCostOnLGRDoc, objIjEngineParam);                
            Vector vInventory = genObjIjJournalDetailInventory(objIjProdCostOnLGRDoc, objIjEngineParam);           
            Vector vDPDeduction = genObjJournalDetailDPDeduction(objIjProdCostOnLGRDoc, objIjEngineParam);
            Vector vProdCostDiscount = genObjJournalDetailProCostDiscount(objIjProdCostOnLGRDoc, objIjEngineParam);            

            double totalInventory = getTotalInventory(vectOfObjIjJurDetail);                                
            double totalDPDeduction = getTotalDPDeduction(vectOfObjIjJurDetail);            
            double totalProdCostDiscount = getTotalProdCostDiscount(vectOfObjIjJurDetail);
            Vector vPayableOnGoodsReceive = genObjJournalDetailPayableOnGoodsReceive(objIjProdCostOnLGRDoc, totalInventory, totalProdCostDiscount, totalDPDeduction, objIjEngineParam);

        // 3. masukkan object masing-masing account ke dalam vector of jurnal detail    
        if(vWIP!=null && vWIP.size()>0)
        {
            vectOfObjIjJurDetail.addAll(vWIP);
        }
            
        if(vInventory!=null && vInventory.size()>0)
        {
            vectOfObjIjJurDetail.addAll(vInventory);
        }

        if(vDPDeduction!=null && vDPDeduction.size()>0)
        {
            vectOfObjIjJurDetail.addAll(vDPDeduction);
        }

        if(vProdCostDiscount!=null && vProdCostDiscount.size()>0)
        {
            vectOfObjIjJurDetail.addAll(vProdCostDiscount);
        }
            
        if(vPayableOnGoodsReceive!=null && vPayableOnGoodsReceive.size()>0)
        {
            vectOfObjIjJurDetail.addAll(vPayableOnGoodsReceive);
        }
                    
        // 4. save jurnal ke database IJ
        if(vectOfObjIjJurDetail!=null && vectOfObjIjJurDetail.size()>0)
        {
            boolean bJournalBalance = PstIjJournalDetail.isBalanceDebetAndCredit(vectOfObjIjJurDetail);
            if( (vectOfObjIjJurDetail!=null && vectOfObjIjJurDetail.size()>1) && bJournalBalance)
            {
                lResult = PstIjJournalMain.generateIjJournal(objIjJournalMain, vectOfObjIjJurDetail);                                        
                
                // posting ke AISO dan update BO Status
                if(lResult != 0 && objIjEngineParam.getIConfJournalSystem() == I_IJGeneral.CFG_GRP_SYS_IJ_ENG_FULL_AUTO)
                {
                    SessPosting objSessPosting = new SessPosting();
                    objIjJournalMain.setOID(lResult);
                    objSessPosting.postingAisoJournal(objIjJournalMain, objIjEngineParam);
                }                
            }
        }
            
        return lResult;
    }
    
    
    /**
     * @param <CODE>objIjProdCostOnLGRDoc</CODE>object IjProdCostOnLGRDoc
     * @param <CODE>docTypeReference</CODE>Dococument type of selected document that will linking it to generated journal
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return  
     */    
    private IjJournalMain genObjIjJournalMain(IjProdCostOnLGRDoc objIjProdCostOnLGRDoc, int iDocTypeReference, IjEngineParam objIjEngineParam)    
    {
        IjJournalMain objIjJournalMain = new IjJournalMain();        
        
        objIjJournalMain.setJurTransDate(objIjProdCostOnLGRDoc.getDocTransDate());                
        objIjJournalMain.setJurBookType(objIjEngineParam.getLBookType());
        objIjJournalMain.setJurTransCurrency(objIjProdCostOnLGRDoc.getDocTransCurrency());                
        objIjJournalMain.setJurStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);                                
        objIjJournalMain.setJurDesc(strJournalNote[objIjEngineParam.getILanguage()]);                                                                                 
        objIjJournalMain.setRefBoDocType(iDocTypeReference);                  
        objIjJournalMain.setRefBoDocOid(objIjProdCostOnLGRDoc.getDocId());                
        objIjJournalMain.setRefBoDocNumber(objIjProdCostOnLGRDoc.getDocNumber());                                 
        
        return objIjJournalMain;        
    }    
    
    
    /**
     * @param <CODE>objIjProdCostOnLGRDoc</CODE>object IjProdCostOnLGRDoc
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return  
     */    
    private Vector genObjIjJDOfWIP(IjProdCostOnLGRDoc objIjProdCostOnLGRDoc, IjEngineParam objIjEngineParam)
    {
        Vector vResult = new Vector(1,1);        
        
        try 
        {            
            Vector listOfInventory = objIjProdCostOnLGRDoc.getListInventory();  
            if(listOfInventory!=null && listOfInventory.size()>0)
            {
                PstIjLocationMapping objPstIjLocationMapping = new PstIjLocationMapping(); 
                int inventoryCount = listOfInventory.size();
                for(int iInv=0; iInv<inventoryCount; iInv++)
                {
                    IjInventoryDoc objIjInventoryDoc = (IjInventoryDoc) listOfInventory.get(iInv);

                    // Ambil Transaction Location Mapping Work In Process
                    IjLocationMapping objIjLocationMapping = objPstIjLocationMapping.getObjIjLocationMapping(I_IJGeneral.TRANS_WIP, -1, 0, objIjInventoryDoc.getInvSourceLocation(), objIjInventoryDoc.getInvProdDepartment());
                    long locationAccChart = objIjLocationMapping.getAccount();                                                                                

                    // pembuatan jurnal detail
                    IjJournalDetail objIjJournalDetail = new IjJournalDetail();
                    objIjJournalDetail.setJdetAccChart(locationAccChart);                            
                    objIjJournalDetail.setJdetTransCurrency(objIjEngineParam.getLBookType());                        
                    objIjJournalDetail.setJdetTransRate(1);                        
                    objIjJournalDetail.setJdetDebet(0);                             
                    objIjJournalDetail.setJdetCredit(objIjInventoryDoc.getInvValue());                            
                    vResult.add(objIjJournalDetail);    
                }                        
            }                                                                
        }
        catch(Exception e)
        {
            System.out.println("Exc when fetch Ref Df Document : " + e.toString());            
        }          
        return vResult;
    }
    
    
    /**
     * @param <CODE>objIjProdCostOnLGRDoc</CODE>object IjProdCostOnLGRDoc
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return  
     */    
    private Vector genObjIjJournalDetailInventory(IjProdCostOnLGRDoc objIjProdCostOnLGRDoc, IjEngineParam objIjEngineParam)
    {
        Vector vResult = new Vector(1,1);       
        
        try
        {
            Vector listOfInventory = objIjProdCostOnLGRDoc.getListInventory();  
            Vector listOfProdCost = objIjProdCostOnLGRDoc.getListProdCost();                    
            if(listOfProdCost!=null && listOfProdCost.size()>0)
            {
                int maxProdCost = listOfProdCost.size();
                PstIjLocationMapping objPstIjLocationMapping = new PstIjLocationMapping();
                for(int iProd=0; iProd<maxProdCost; iProd++)
                {
                    IjProductionCostValue objIjProductionCostValue = (IjProductionCostValue) listOfProdCost.get(iProd);                   

                    IjLocationMapping objIjLocationMapping = objPstIjLocationMapping.getObjIjLocationMapping(I_IJGeneral.TRANS_INVENTORY_LOCATION, -1, 0, objIjProdCostOnLGRDoc.getDocLocation(), objIjProductionCostValue.getProdDepartment());
                    long locationAccChart = objIjLocationMapping.getAccount();                                                                                

                    double totalInvValue = 0;
                    if(listOfInventory!=null && listOfInventory.size()>0)
                    {
                        int inventoryCount = listOfInventory.size();
                        for(int iInv=0; iInv<inventoryCount; iInv++)
                        {
                            IjInventoryDoc objIjInventoryDoc = (IjInventoryDoc) listOfInventory.get(iInv);
                            if(objIjInventoryDoc.getInvProdDepartment() == objIjProductionCostValue.getProdDepartment())
                            {
                                totalInvValue = totalInvValue + objIjInventoryDoc.getInvValue();
                            }
                        }
                    }

                    IjJournalDetail objIjJournalDetail = new IjJournalDetail();
                    objIjJournalDetail.setJdetAccChart(locationAccChart);                            
                    objIjJournalDetail.setJdetTransCurrency(objIjEngineParam.getLBookType());                        
                    objIjJournalDetail.setJdetTransRate(1);                        
                    objIjJournalDetail.setJdetDebet((totalInvValue + objIjProductionCostValue.getProdCostValue()));                             
                    objIjJournalDetail.setJdetCredit(0);                            
                    vResult.add(objIjJournalDetail);    
                }
            }                                                
            return vResult;
        }
        catch(Exception e)
        {
            System.out.println("Exc when fetch Ref Df Document : " + e.toString());
            return new Vector(1,1);
        }                                    
    }
    
    /**
     * @param vIjJournalDetail
     * @return
     */    
    private double getTotalInventory(Vector vIjJournalDetail)
    {
        return PstIjJournalDetail.getTotalOnDebetSide(vIjJournalDetail);
    }
    
    
    /**
     * @param <CODE>objIjProdCostOnLGRDoc</CODE>object IjProdCostOnLGRDoc
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return       
     */    
    private Vector genObjJournalDetailDPDeduction(IjProdCostOnLGRDoc objIjProdCostOnLGRDoc, IjEngineParam objIjEngineParam)
    {
        Vector vResult = new Vector(1,1);
        
        Vector listOfDpDeduction = objIjProdCostOnLGRDoc.getListDPDeduction();
        if(listOfDpDeduction!=null && listOfDpDeduction.size()>0)
        {
            PstIjAccountMapping objPstIjAccountMapping = new PstIjAccountMapping();                        
            int DPDeductionCount = listOfDpDeduction.size();
            for(int iDp=0; iDp<DPDeductionCount; iDp++)
            {
                IjDPDeductionDoc objIjDPDeductionDoc = (IjDPDeductionDoc) listOfDpDeduction.get(iDp);

                // Ambil Account Mapping DP On Purchase Order
                IjAccountMapping objIjAccountMapping = objPstIjAccountMapping.getObjIjAccountMapping(I_IJGeneral.TRANS_DP_ON_PRODUCTION_ORDER, objIjProdCostOnLGRDoc.getDocTransCurrency());                                            
                long dpDeductionAccChart = objIjAccountMapping.getAccount();                                                                                

                if(dpDeductionAccChart != 0)
                {
                    Hashtable hashStandartRate = objIjEngineParam.getHStandartRate();
                    String strStandartRateDp = (hashStandartRate.get(""+objIjDPDeductionDoc.getPayCurrency())) != null ? ""+hashStandartRate.get(""+objIjDPDeductionDoc.getPayCurrency()) : "1";
                    double standartRateDp = Double.parseDouble(strStandartRateDp);                            

                    // pembuatan jurnal detail
                    IjJournalDetail objIjJournalDetail = new IjJournalDetail();
                    objIjJournalDetail.setJdetAccChart(dpDeductionAccChart);                            
                    objIjJournalDetail.setJdetTransCurrency(objIjProdCostOnLGRDoc.getDocTransCurrency());                        
                    objIjJournalDetail.setJdetTransRate(standartRateDp);                        
                    objIjJournalDetail.setJdetDebet(0);                             
                    objIjJournalDetail.setJdetCredit((objIjDPDeductionDoc.getPayNominal()*standartRateDp));                                            
                    vResult.add(objIjJournalDetail);                            
                }
            }                        
        }                        
        return vResult;        
    }
    
    /**
     * @param vIjJournalDetail
     * @return
     */    
    private double getTotalDPDeduction(Vector vIjJournalDetail)
    {
        return PstIjJournalDetail.getTotalOnCreditSide(vIjJournalDetail);
    }
    
    
    
    /**
     * @param <CODE>objIjProdCostOnLGRDoc</CODE>object IjProdCostOnLGRDoc
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return  
     */    
    private Vector genObjJournalDetailProCostDiscount(IjProdCostOnLGRDoc objIjProdCostOnLGRDoc, IjEngineParam objIjEngineParam)
    {
        Vector vResult = new Vector(1,1);
        
        PstIjLocationMapping objPstIjLocationMappingCr = new PstIjLocationMapping();
        IjLocationMapping objIjLocationMapping = objPstIjLocationMappingCr.getObjIjLocationMapping(I_IJGeneral.TRANS_PROD_COST_DISCOUNT, -1, objIjProdCostOnLGRDoc.getDocTransCurrency(), objIjProdCostOnLGRDoc.getDocLocation(), 0);                
        long prodCostDiscAccChart = objIjLocationMapping.getAccount();

        if(prodCostDiscAccChart != 0)
        {        
            Hashtable hashStandartRate = objIjEngineParam.getHStandartRate();
            String strStandartRateProdDisc = (hashStandartRate.get(""+objIjProdCostOnLGRDoc.getDocTransCurrency())) != null ? ""+hashStandartRate.get(""+objIjProdCostOnLGRDoc.getDocTransCurrency()) : "1";
            double standartRateProdDisc = Double.parseDouble(strStandartRateProdDisc);
            double totalDiscount = standartRateProdDisc * objIjProdCostOnLGRDoc.getDocDiscount();                    

            IjJournalDetail objIjJournalDetail = new IjJournalDetail();
            objIjJournalDetail.setJdetAccChart(prodCostDiscAccChart);                            
            objIjJournalDetail.setJdetTransCurrency(objIjProdCostOnLGRDoc.getDocTransCurrency());                        
            objIjJournalDetail.setJdetTransRate(standartRateProdDisc);                        
            objIjJournalDetail.setJdetDebet(0);                             
            objIjJournalDetail.setJdetCredit(totalDiscount);                            
            vResult.add(objIjJournalDetail);                            
        }
        
        return vResult;        
    }
    
    /**
     * @param vIjJournalDetail
     * @return 
     */    
    private double getTotalProdCostDiscount(Vector vIjJournalDetail)
    {
        return PstIjJournalDetail.getTotalOnCreditSide(vIjJournalDetail);
    }
    
    
    /**
     * @param <CODE>objIjProdCostOnLGRDoc</CODE>object IjProdCostOnLGRDoc
     * @param <CODE>objIjEngineParam</CODE>IjEngineParameter object
     *
     * @return  
     */        
    private Vector genObjJournalDetailPayableOnGoodsReceive(IjProdCostOnLGRDoc objIjProdCostOnLGRDoc, double totalProdCost, double totalDiscount, double totalDpDeduction, IjEngineParam objIjEngineParam)
    {
        Vector vResult = new Vector(1,1);
        
        PstIjAccountMapping objPstIjAccountMappingCr = new PstIjAccountMapping();
        IjAccountMapping objIjAccountMappingCr = objPstIjAccountMappingCr.getObjIjAccountMapping(I_IJGeneral.TRANS_GOODS_RECEIVE, objIjProdCostOnLGRDoc.getDocTransCurrency());                
        long goodReceiveAccChart = objIjAccountMappingCr.getAccount();

        if(goodReceiveAccChart != 0)
        {
            IjJournalDetail objIjJournalDetailCr = new IjJournalDetail();
            objIjJournalDetailCr.setJdetAccChart(goodReceiveAccChart);                            
            objIjJournalDetailCr.setJdetTransCurrency(objIjEngineParam.getLBookType());                        
            objIjJournalDetailCr.setJdetTransRate(1);                        
            objIjJournalDetailCr.setJdetDebet(0);                             
            objIjJournalDetailCr.setJdetCredit((totalProdCost - totalDiscount - totalDpDeduction));                                    
            vResult.add(objIjJournalDetailCr);                            
        }
        
        return vResult;
    }    
    
}
