package com.dimata.posbo.session.warehouse;

import com.dimata.qdep.form.Control;
import com.dimata.posbo.db.DBResultSet;
import com.dimata.posbo.db.DBHandler;
import com.dimata.qdep.entity.I_DocType;
import com.dimata.posbo.entity.warehouse.*;
import com.dimata.posbo.entity.search.SrcMatCosting;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.location.Location;
import com.dimata.util.Formater;
import com.dimata.posbo.entity.search.SrcStockCard;
import com.dimata.posbo.entity.masterdata.Material;
import com.dimata.posbo.entity.masterdata.PstMaterial;
import com.dimata.posbo.entity.masterdata.PstUnit;
import com.dimata.qdep.entity.I_DocStatus;

import java.util.Vector;
import java.util.Date;
import java.sql.ResultSet;

public class SessMatCosting extends Control {

    public static final String SESS_SRC_MATDISPATCH = "SESSION_MATERIAL_DISPATCH";
    public static final String SESSION_MATERIAL_DISPATCH_EXC = "SESSION_MATERIAL_DISPATCH_EXC";
    public static final String SESSION_TRANSFER_MR_TO_DF = "SESSION_TRANSFER_MR_TO_DF";
    public static final String SESSION_MATERIAL_DISPATCH_RECEIVED = "SESSION_MATERIAL_DISPATCH_RECEIVED";

    public static final String[] orderBy =
            {
                PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_CODE],
                PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID],
                PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_TO],
                PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE],
                PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS]
            };

    /* list for material request */
    public static Vector listMatCosting(SrcMatCosting srcMatCosting, int start, int limit) {
        Vector result = new Vector(1, 1);
        String sql = "SELECT DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_MATERIAL_ID] +
                " , DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_CODE] +
                " , DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                " , LOC." + PstLocation.fieldNames[PstLocation.FLD_NAME] +
                " , DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_TO] +
                " , DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] +
                " , DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_REMARK] +
                " FROM " + PstMatCosting.TBL_COSTING + " DF" +
                " INNER JOIN " + PstLocation.TBL_P2_LOCATION + " LOC" +
                " ON DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] +
                " = LOC." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID];


        if (srcMatCosting != null) {
            String fromLocation = "";
            if (srcMatCosting.getCostingFrom() != 0) {
                fromLocation = "(DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] + "=" + srcMatCosting.getCostingFrom() + ")";
            }

            String toLocation = "";
            if (srcMatCosting.getCostingTo() != 0) {
                toLocation = "(DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_TO] + "=" + srcMatCosting.getCostingTo() + ")";
            }

            String date = "";
            if (!srcMatCosting.getIgnoreDate()) {
                date = "(DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] + " BETWEEN '" + Formater.formatDate(srcMatCosting.getCostingDateFrom(), "yyyy-MM-dd 00:00:01") + "' AND '" +
                        Formater.formatDate(srcMatCosting.getCostingDateTo(), "yyyy-MM-dd 23:59:59") + "')";
            }

            String dfCode = "";
            if (srcMatCosting.getCostingCode().length() > 0) {
                dfCode = "(DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_CODE] + " LIKE '" + srcMatCosting.getCostingCode() + "%')";
            }

            String status = "";
            if (srcMatCosting.getStatus() >= 0) {
                status = "(DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] + " = " + (srcMatCosting.getStatus()) + ")";
            }

            String where = "";
            if (fromLocation.length() > 0) {
                if (where.length() > 0) {
                    where = where + " AND " + fromLocation;
                } else {
                    where = fromLocation;
                }
            }

            if (toLocation.length() > 0) {
                if (where.length() > 0) {
                    where = where + " AND " + toLocation;
                } else {
                    where = toLocation;
                }
            }

            if (date.length() > 0) {
                if (where.length() > 0) {
                    where = where + " AND " + date;
                } else {
                    where = date;
                }
            }

            if (dfCode.length() > 0) {
                if (where.length() > 0) {
                    where = where + " AND " + dfCode;
                } else {
                    where = dfCode;
                }
            }

            if (status.length() > 0) {
                if (where.length() > 0) {
                    where = where + " AND " + status;
                } else {
                    where = status;
                }
            }

            if (where.length() > 0) {
                where = " WHERE	" + where;
            }

            sql += where;
            sql += " ORDER BY DF." + orderBy[srcMatCosting.getSortBy()];
            sql += ", DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE]; /** defaultnya, list diurut berdasarkan DATE */
        }
        System.out.println("sql > "+sql);
        switch (DBHandler.DBSVR_TYPE) {
            case DBHandler.DBSVR_MYSQL:
                if (start == 0 && limit == 0)
                    sql = sql + "";
                else
                    sql = sql + " LIMIT " + start + "," + limit;
                break;
            case DBHandler.DBSVR_POSTGRESQL:
                if (start == 0 && limit == 0)
                    sql = sql + "";
                else
                    sql = sql + " LIMIT " + limit + " OFFSET " + start;
                break;
            case DBHandler.DBSVR_SYBASE:
                break;
            case DBHandler.DBSVR_ORACLE:
                break;
            case DBHandler.DBSVR_MSSQL:
                break;
            default:
                ;
        }


        DBResultSet dbrs = null;
        try {
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector temp = new Vector();
                MatCosting matDf = new MatCosting();
                Location loc1 = new Location();

                matDf.setOID(rs.getLong(1));
                matDf.setCostingCode(rs.getString(2));
                matDf.setCostingDate(rs.getDate(3));
                matDf.setCostingTo(rs.getLong(5));
                matDf.setCostingStatus(rs.getInt(6));
                matDf.setRemark(rs.getString(7));
                temp.add(matDf);

                loc1.setName(rs.getString(4));
                temp.add(loc1);

                result.add(temp);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("exception on search DF : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }


    public static int getCountMatCosting(SrcMatCosting srcMatCosting) {

        int result = 0;
        String sql = "SELECT COUNT(DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_MATERIAL_ID] +
                " ) AS CNT FROM " + PstMatCosting.TBL_COSTING + " DF" +
                " INNER JOIN " + PstLocation.TBL_P2_LOCATION + " LOC" +
                " ON DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] +
                " = LOC." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID];

        if (srcMatCosting != null) {
            String fromLocation = "";

            if (srcMatCosting.getCostingFrom() != 0) {
                fromLocation = "(DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] + "=" + srcMatCosting.getCostingFrom() + ")";
            }

            String toLocation = "";
            if (srcMatCosting.getCostingTo() != 0) {
                toLocation = "(DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_TO] + "=" + srcMatCosting.getCostingTo() + ")";
            }

            String date = "";
            if (!srcMatCosting.getIgnoreDate()) {
                date = "(DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] + " BETWEEN '" + Formater.formatDate(srcMatCosting.getCostingDateFrom(), "yyyy-MM-dd 00:00:01") + "' AND '" +
                        Formater.formatDate(srcMatCosting.getCostingDateTo(), "yyyy-MM-dd 23:59:59") + "')";
            }

            String dfCode = "";
            if (srcMatCosting.getCostingCode().length() > 0) {
                dfCode = "(DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_CODE] + " LIKE '" + srcMatCosting.getCostingCode() + "%')";
            }

            String status = "";
            if (srcMatCosting.getStatus() >= 0) {
                status = "(DF." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] + " = " + (srcMatCosting.getStatus()) + ")";
            }

            String where = "";
            if (fromLocation.length() > 0) {
                if (where.length() > 0) {
                    where = where + " AND " + fromLocation;
                } else {
                    where = fromLocation;
                }
            }

            if (toLocation.length() > 0) {
                if (where.length() > 0) {
                    where = where + " AND " + toLocation;
                } else {
                    where = toLocation;
                }
            }

            if (date.length() > 0) {
                if (where.length() > 0) {
                    where = where + " AND " + date;
                } else {
                    where = date;
                }
            }

            if (dfCode.length() > 0) {
                if (where.length() > 0) {
                    where = where + " AND " + dfCode;
                } else {
                    where = dfCode;
                }
            }

            if (status.length() > 0) {
                if (where.length() > 0) {
                    where = where + " AND " + status;
                } else {
                    where = status;
                }
            }

            if (where.length() > 0) {
                where = " WHERE	" + where;
            }
            sql += where;
        }
        DBResultSet dbrs = null;
        try {
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("exception on count search DF : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }

    public static int findLimitStart(long oid, int recordToGet, SrcMatCosting srcMaterial) {
        /*String order = "";
        int size = getCount(srcMaterial);
        int start = 0;
        boolean found =false;
        for(int i=0; (i < size) && !found ; i=i+recordToGet){
             Vector list =  listMatCosting(srcMaterial,i,recordToGet);
             start = i;
             if(list.size()>0){
              for(int ls=0;ls<list.size();ls++){
                     MatCosting materialdispatch = (MatCosting)list.get(ls);
                   if(oid == materialdispatch.getOID())
                      found=true;
              }
          }
        }
        if((start >= size) && (size > 0))
            start = start - recordToGet;

        return start;*/
        return 0;
    }


    public String generateRequestCode(MatCosting materialDf) {

        String code = "DR";
        /*String dateCode = "";
        if(materialDf.getDfmDate()!=null){

        	int nextCounter = materialDf.getCostingCodeCounter();//getMaxCounter(date);

            Date date = materialDf.getDfmDate();

            int tgl = date.getDate();
            int bln = date.getMonth() + 1;
            int thn = date.getYear() + 1900;

            if(tgl<10){
				dateCode = "0"+tgl;
            }
            else{
                dateCode = ""+tgl;
            }

            if(bln<10){
                dateCode = dateCode+"0"+bln;
            }
            else{
                dateCode = dateCode+""+bln;
            }

            dateCode = dateCode + (String.valueOf(thn)).substring(2,4);

            String counter = "";
            if(nextCounter<10){
                counter = "00"+nextCounter;
            }
            else{
                if(nextCounter<100){
                    counter = "0"+nextCounter;
                }
                else{
                    counter = ""+counter;
                }
            }

            code = code+"-"+dateCode+"-"+counter;
        }
        */
        return code;
    }

    public static int getMaxReqCounter(Date date) {
        int counter = 0;
        /*DBResultSet dbrs = null;

        Date startDate = (Date)date.clone();
        startDate.setDate(1);

        Date endDate = (Date)date.clone();
        endDate.setMonth(endDate.getMonth()+1);
        endDate.setDate(1);
        endDate.setDate(endDate.getDate()-1);

        try{

             I_PstDocType i_PstDocType = (I_PstDocType)Class.forName(I_DocType.DOCTYPE_CLASSNAME).newInstance();

            String sql = "SELECT MAX("+PstMatCosting.fieldNames[PstMatCosting.FLD_DISPATCH_CODE_COUNTER]+") AS MAXIMUM "+
                " FROM "+PstMatCosting.TBL_MAT_DISPATCH+" WHERE ("+
                PstMatCosting.fieldNames[PstMatCosting.FLD_DFM_DATE]+" BETWEEN \""+
                Formater.formatDate(startDate, "yyyy-MM-dd")+"\" AND \""+Formater.formatDate(endDate, "yyyy-MM-dd")+"\""+
                ") AND ("+PstMatCosting.fieldNames[PstMatCosting.FLD_DISPATCH_TYPE]+">99)"+
                " AND ("+PstMatCosting.fieldNames[PstMatCosting.FLD_DOC_TYPE]+"="+i_PstDocType.composeDocumentType(I_DocType.SYSTEM_MATERIAL , I_DocType.MAT_DOC_TYPE_DR)+")";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while(rs.next()){
                counter = rs.getInt("MAXIMUM");
            }

            rs.close();
        }
        catch(Exception e){
            DBResultSet.close(dbrs);
            System.out.println("Exception getMaxCounter : "+e.toString());
            return 0;
        }
        finally{
            DBResultSet.close(dbrs);
        }
        */
        return counter;
    }

    //-------------------------------------------

    /* material dispatch */

    /* list for material dispatch */
    /*public static Vector listMatCosting(SrcMatCosting srcMaterial, int start, int limit)
    {
          Vector result = new Vector(1,1);
          /*if(srcMaterial!=null){
            	String sql = "SELECT * FROM "+PstMatCosting.TBL_MAT_DISPATCH+" AS DF ";

                String innerJoin = "";
                String materialCode = "";
                String materialName = "";
                if((srcMaterial.getMaterialCode().length()>0) || (srcMaterial.getMaterialName().length()>0) ){
                    innerJoin = "INNER JOIN "+PstMatCostingItem.TBL_MAT_DISPATCH_ITEM+" AS MAT "+
                        " ON MAT."+PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MAT_DISPATCH_ID]+"="+
                        " DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_MAT_DISPATCH_ID]+" "+
                        " INNER JOIN "+PstMatStock.TBL_MAT_STOCK+" AS STOCK "+
                        " ON STOCK."+PstMatStock.fieldNames[PstMatStock.FLD_MAT_STOCK_ID]+"="+
                        " MAT."+PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MAT_STOCK_ID]+" "+
                        " INNER JOIN "+PstMaterial.TBL_MATERIAL+" AS CATALOG ON CATALOG."+
                        PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID]+"= STOCK."+PstMatStock.fieldNames[PstMatStock.FLD_MATERIAL_ID];

                    if(srcMaterial.getMaterialCode().length()>0){
                        materialCode = "(CATALOG."+PstMaterial.fieldNames[PstMaterial.FLD_CODE]+" LIKE \"%"+srcMaterial.getMaterialCode()+"%\")";
                    }

                    if(srcMaterial.getMaterialName().length()>0){
                        materialName = "(CATALOG."+PstMaterial.fieldNames[PstMaterial.FLD_NAME]+" LIKE \"%"+srcMaterial.getMaterialName()+"%\")";
                    }
                }

                String fromLocation = "";
                if(srcMaterial.getCostingFrom()!=0){
					fromLocation = "(DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_DISPATCH_FROM]+"="+srcMaterial.getCostingFrom()+")";
                }

                String toLocation = "";
                if(srcMaterial.getCostingTo()!=0){
					toLocation = "(DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_DISPATCH_TO]+"="+srcMaterial.getCostingTo()+")";
                }

                String date = "";
                if(!srcMaterial.getIgnoreDate()){
                    date = "(DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_DFM_DATE]+" BETWEEN \""+Formater.formatDate(srcMaterial.getCostingDateFrom(), "yyyy-MM-dd")+"\" AND \""+
                        Formater.formatDate(srcMaterial.getCostingDateTo(), "yyyy-MM-dd")+"\")";
                }

                String dfCode = "";
                if(srcMaterial.getCostingCode().length()>0){
                    dfCode = "(DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_DISPATCH_CODE]+" LIKE \"%"+srcMaterial.getCostingCode()+"%\")";
                }

                String status = "";
                if(srcMaterial.getStatus()>=0){
                    status =  "(DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_DF_STATUS]+" = "+(srcMaterial.getStatus())+")";
                }
                String referency = "";
                String innerReferency = "";
                if(srcMaterial.getRequestRefCode().length()>0){
                    innerReferency = " INNER JOIN "+PstMatCosting.TBL_MAT_DISPATCH+" AS REF ON REF."+PstMatCosting.fieldNames[PstMaterial.FLD_MATERIAL_ID]+"="+
                        " DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_REFERENCE_ID]+" ";

                    referency = "(REF."+PstMatCosting.fieldNames[PstMatCosting.FLD_REFERENCE_ID]+" LIKE \"%"+srcMaterial.getRequestRefCode()+"%\")";
                }



                String where = "";
                String lastInner = "";
                if(materialCode.length()>0 || materialName.length()>0){
                      lastInner = innerJoin;
                      if(materialCode.length()>0){
                         	where = materialCode;
                      }

                      if( materialName.length()>0){
	                        if( where.length()>0){
	                            where = where + " AND " + materialName;
	                        }
	                        else{
	                            where = materialName;
	                        }
                      }
                }

                if( fromLocation.length()>0){
                    if( where.length()>0){
                        where = where + " AND " + fromLocation;
                    }
                    else{
                        where = fromLocation;
                    }
                 }

                if( toLocation.length()>0){
                    if( where.length()>0){
                        where = where + " AND " + toLocation;
                    }
                    else{
                        where = toLocation;
                    }
                 }

                if( date.length()>0){
                    if( where.length()>0){
                        where = where + " AND " + date;
                    }
                    else{
                        where = date;
                    }
                 }

                if( dfCode.length()>0){
                    if( where.length()>0){
                        where = where + " AND " + dfCode;
                    }
                    else{
                        where = dfCode;
                    }
                 }

                if(status.length()>0){
                    if( where.length()>0){
                        where = where + " AND " + status;
                    }
                    else{
                        where = status;
                    }
                }

                if(referency.length()>0){
                    if( where.length()>0){
                        where = where + " AND " + referency;
                    }
                    else{
                        where = referency;
                    }
                }


                try{
                  	 I_PstDocType i_PstDocType = (I_PstDocType)Class.forName(I_DocType.DOCTYPE_CLASSNAME).newInstance();

	                 if( where.length()>0){
	                     where = where + " AND (DF."+ PstMatCosting.fieldNames[PstMatCosting.FLD_DOC_TYPE]+"="+i_PstDocType.composeDocumentType(I_DocType.SYSTEM_MATERIAL , I_DocType.MAT_DOC_TYPE_DF) +")";
	                 }
	                 else{
	                     where = "(DF."+ PstMatCosting.fieldNames[PstMatCosting.FLD_DOC_TYPE]+"="+i_PstDocType.composeDocumentType(I_DocType.SYSTEM_MATERIAL , I_DocType.MAT_DOC_TYPE_DF) +")";
	                 }

                 }
                catch(Exception e){
                    System.out.println("Exception e - interface : "+e.toString());
                }


                if(where.length()>0){
                    where = " WHERE	("+where+")";
                }

                 sql = sql + lastInner + innerReferency + where +" ORDER BY DF."+orderBy[srcMaterial.getSortBy()];//+" LIMIT "+start+","+limit;

                 switch (DBHandler.DBSVR_TYPE) {
	                case DBHandler.DBSVR_MYSQL :
							if(start == 0 && limit == 0)
								sql = sql + "";
							else
								sql = sql + " LIMIT " + start + ","+ limit ;

	                        break;

	                 case DBHandler.DBSVR_POSTGRESQL :
							if(start == 0 && limit == 0)
								sql = sql + "";
							else
								sql = sql + " LIMIT " +limit + " OFFSET "+ start ;

	                        break;

	                 case DBHandler.DBSVR_SYBASE :
	                    	break;

	                 case DBHandler.DBSVR_ORACLE :
	                    	break;

	                 case DBHandler.DBSVR_MSSQL :
	                    	break;

	                default:
	                    ;
	            }


                 DBResultSet dbrs = null;
                 try{
                    dbrs = DBHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    while(rs.next()){
                        MatCosting matDf = new MatCosting();
                        PstMatCosting.resultToObject(rs, matDf);

                        result.add(matDf);
                    }

                    rs.close();
                 }
                 catch(Exception e){
                    DBResultSet.close(dbrs);
                    System.out.println("exception on search DF REG : "+e.toString());
                 }
                 finally{
                    DBResultSet.close(dbrs);
                 }

                 return result;

          }
           else
           {
          }
          return result;
    }
           */


    /*
   for material dispatch
   */
    public static int getCount(SrcMatCosting srcMaterial) {

        int result = 0;

        /*if(srcMaterial!=null){
              String sql = "SELECT COUNT(DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_MAT_DISPATCH_ID]+") FROM "+PstMatCosting.TBL_MAT_DISPATCH+" AS DF ";

              String innerJoin = "";
              String materialCode = "";
              String materialName = "";
              if((srcMaterial.getMaterialCode().length()>0) || (srcMaterial.getMaterialName().length()>0) ){
                  innerJoin = "INNER JOIN "+PstMatCostingItem.TBL_MAT_DISPATCH_ITEM+" AS MAT "+
                      " ON MAT."+PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MAT_DISPATCH_ID]+"="+
                      " DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_MAT_DISPATCH_ID]+" "+
                      " INNER JOIN "+PstMatStock.TBL_MAT_STOCK+" AS STOCK "+
                      " ON STOCK."+PstMatStock.fieldNames[PstMatStock.FLD_MAT_STOCK_ID]+"="+
                      " MAT."+PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MAT_STOCK_ID]+" "+
                      " INNER JOIN "+PstMaterial.TBL_MATERIAL+" AS CATALOG ON CATALOG."+
                      PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID]+"= STOCK."+PstMatStock.fieldNames[PstMatStock.FLD_MATERIAL_ID];

                  if(srcMaterial.getMaterialCode().length()>0){
                      materialCode = "(CATALOG."+PstMaterial.fieldNames[PstMaterial.FLD_CODE]+" LIKE \"%"+srcMaterial.getMaterialCode()+"%\")";
                  }

                  if(srcMaterial.getMaterialName().length()>0){
                      materialName = "(CATALOG."+PstMaterial.fieldNames[PstMaterial.FLD_NAME]+" LIKE \"%"+srcMaterial.getMaterialName()+"%\")";
                  }
              }

              String fromLocation = "";
              if(srcMaterial.getCostingFrom()!=0){
                  fromLocation = "(DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_DISPATCH_FROM]+"="+srcMaterial.getCostingFrom()+")";
              }

              String toLocation = "";
              if(srcMaterial.getCostingTo()!=0){
                  toLocation = "(DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_DISPATCH_TO]+"="+srcMaterial.getCostingTo()+")";
              }

              String date = "";
              if(!srcMaterial.getIgnoreDate()){
                  date = "(DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_DFM_DATE]+" BETWEEN \""+Formater.formatDate(srcMaterial.getCostingDateFrom(), "yyyy-MM-dd")+"\" AND \""+
                      Formater.formatDate(srcMaterial.getCostingDateTo(), "yyyy-MM-dd")+"\")";
              }

              String dfCode = "";
              if(srcMaterial.getCostingCode().length()>0){
                  dfCode = "(DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_DISPATCH_CODE]+" LIKE \"%"+srcMaterial.getCostingCode()+"%\")";
              }

              String status = "";
              if(srcMaterial.getStatus()>=0){
                  status =  "(DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_DF_STATUS]+" = "+(srcMaterial.getStatus())+")";
              }
              String referency = "";
              String innerReferency = "";
              if(srcMaterial.getRequestRefCode().length()>0){
                  innerReferency = " INNER JOIN "+PstMatCosting.TBL_MAT_DISPATCH+" AS REF ON REF."+PstMatCosting.fieldNames[PstMaterial.FLD_MATERIAL_ID]+"="+
                      " DF."+PstMatCosting.fieldNames[PstMatCosting.FLD_REFERENCE_ID]+" ";

                  referency = "(REF."+PstMatCosting.fieldNames[PstMatCosting.FLD_REFERENCE_ID]+" LIKE \"%"+srcMaterial.getRequestRefCode()+"%\")";
              }



              String where = "";
              String lastInner = "";
              if(materialCode.length()>0 || materialName.length()>0){
                    lastInner = innerJoin;
                    if(materialCode.length()>0){
                           where = materialCode;
                    }

                    if( materialName.length()>0){
                          if( where.length()>0){
                              where = where + " AND " + materialName;
                          }
                          else{
                              where = materialName;
                          }
                    }
              }

              if( fromLocation.length()>0){
                  if( where.length()>0){
                      where = where + " AND " + fromLocation;
                  }
                  else{
                      where = fromLocation;
                  }
               }

              if( toLocation.length()>0){
                  if( where.length()>0){
                      where = where + " AND " + toLocation;
                  }
                  else{
                      where = toLocation;
                  }
               }

              if( date.length()>0){
                  if( where.length()>0){
                      where = where + " AND " + date;
                  }
                  else{
                      where = date;
                  }
               }

              if( dfCode.length()>0){
                  if( where.length()>0){
                      where = where + " AND " + dfCode;
                  }
                  else{
                      where = dfCode;
                  }
               }

              if(status.length()>0){
                  if( where.length()>0){
                      where = where + " AND " + status;
                  }
                  else{
                      where = status;
                  }
              }

              if(referency.length()>0){
                  if( where.length()>0){
                      where = where + " AND " + referency;
                  }
                  else{
                      where = referency;
                  }
              }


              try{
                     I_PstDocType i_PstDocType = (I_PstDocType)Class.forName(I_DocType.DOCTYPE_CLASSNAME).newInstance();

                   if( where.length()>0){
                       where = where + " AND (DF."+ PstMatCosting.fieldNames[PstMatCosting.FLD_DOC_TYPE]+"="+i_PstDocType.composeDocumentType(I_DocType.SYSTEM_MATERIAL , I_DocType.MAT_DOC_TYPE_DF) +")";
                   }
                   else{
                       where = "(DF."+ PstMatCosting.fieldNames[PstMatCosting.FLD_DOC_TYPE]+"="+i_PstDocType.composeDocumentType(I_DocType.SYSTEM_MATERIAL , I_DocType.MAT_DOC_TYPE_DF) +")";
                   }

               }
              catch(Exception e){
                  System.out.println("Exception e - interface : "+e.toString());
              }


              if(where.length()>0){
                  where = " WHERE	("+where+")";
              }

               sql = sql + lastInner + innerReferency + where ;//+" ORDER BY "+orderBy[srcMaterial.getSortBy()]+" LIMIT "+start+","+limit;

               DBResultSet dbrs = null;
               try{
                  dbrs = DBHandler.execQueryResult(sql);
                  ResultSet rs = dbrs.getResultSet();
                  while(rs.next()){
                      result = rs.getInt(1);
                  }

                  rs.close();
               }
               catch(Exception e){
                  DBResultSet.close(dbrs);
                  System.out.println("exception on search DF REG : "+e.toString());
               }
               finally{
                  DBResultSet.close(dbrs);
               }

               return result;

        }else{
        }*/
        return result;
    }


    public String generateCostingCode(MatCosting matCosting) {
        String code = "CST";
        String dateCode = "";
        if (matCosting.getCostingDate() != null) {
            /** get location code; gwawan@21juni2007 */
            Vector vctLocation = PstLocation.list(0, 0, PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID]+"="+matCosting.getLocationId(), "");
            Location location = (Location)vctLocation.get(0);
            
            int nextCounter = matCosting.getCostingCodeCounter();//getMaxCounter(date);
            Date date = matCosting.getCostingDate();

            int tgl = date.getDate();
            int bln = date.getMonth() + 1;
            int thn = date.getYear() + 1900;

            dateCode = (String.valueOf(thn)).substring(2, 4);

            if (bln < 10) {
                dateCode = dateCode + "0" + bln;
            } else {
                dateCode = dateCode + bln;
            }

            if (tgl < 10) {
                dateCode = dateCode + "0" + tgl;
            } else {
                dateCode = dateCode + tgl;
            }

            String counter = "";
            if (nextCounter < 10) {
                counter = "00" + nextCounter;
            } else {
                if (nextCounter < 100) {
                    counter = "0" + nextCounter;
                } else {
                    counter = "" + nextCounter;
                }
            }
            code = location.getCode() + "-" + dateCode + "-" + code + "-" + counter;
        }
        return code;
    }

    public static int getMaxCostingCounter(Date date, MatCosting matCosting) {
        int counter = 0;
        DBResultSet dbrs = null;
        try {

            Date startDate = (Date) date.clone();
            startDate.setDate(1);

            Date endDate = (Date) date.clone();
            endDate.setMonth(endDate.getMonth() + 1);
            endDate.setDate(1);
            endDate.setDate(endDate.getDate() - 1);

            //I_PstDocType i_PstDocType = (I_PstDocType) Class.forName(I_DocType.DOCTYPE_CLASSNAME).newInstance();

            String sql = "SELECT MAX(" + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_CODE_COUNTER] + ") AS MAXIMUM " +
                    " FROM " + PstMatCosting.TBL_COSTING+
                    " WHERE (" + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                    " BETWEEN '" + Formater.formatDate(startDate, "yyyy-MM-dd") +
                    " ' AND '" + Formater.formatDate(endDate, "yyyy-MM-dd") +
                    " ') AND " + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] + " = " + matCosting.getLocationId();

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                counter = rs.getInt("MAXIMUM");
            }

            rs.close();
        } catch (Exception e) {
            DBResultSet.close(dbrs);
            System.out.println("Exception getMaxCounter : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return counter;
    }

    /**
     * untuk mencari data qty stock card
     * @param srcStockCard
     */
    public static void getDataMaterial(SrcStockCard srcStockCard) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT" +
                    " R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                    " ,R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_CODE] +
                    " ,SUM(RI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_QTY] + ") AS SUM_QTY " +
                    " ,RI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_QTY] +
                    " ,M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
                    " ,RI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_UNIT_ID] +
                    " FROM " + PstMatCosting.TBL_COSTING+ " AS R " +
                    " INNER JOIN " + PstMatCostingItem.TBL_MAT_COSTING_ITEM+ " AS RI " +
                    " ON R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_MATERIAL_ID] +
                    " = RI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_COSTING_MATERIAL_ID] +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL+ " AS M " +
                    " ON RI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MATERIAL_ID] +
                    " = M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID];
            String whereClause = "";
            if (srcStockCard.getMaterialId() != 0) {
                whereClause = "RI." + PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_MATERIAL_ID] + "=" + srcStockCard.getMaterialId();
            }

            if (srcStockCard.getLocationId() != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND R." + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] + "=" + srcStockCard.getLocationId();
                } else {
                    whereClause = "R." + PstMatCosting.fieldNames[PstMatCosting.FLD_LOCATION_ID] + "=" + srcStockCard.getLocationId();
                }
            }

            if (srcStockCard.getStardDate() != null && srcStockCard.getEndDate() != null) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] + " BETWEEN '" + Formater.formatDate(srcStockCard.getStardDate(), "yyyy-MM-dd 00:00:01") + "' AND '" + Formater.formatDate(srcStockCard.getEndDate(), "yyyy-MM-dd 23:59:59") + "'";
                } else {
                    whereClause = " R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] + " BETWEEN '" + Formater.formatDate(srcStockCard.getStardDate(), "yyyy-MM-dd 00:00:01") + "' AND '" + Formater.formatDate(srcStockCard.getEndDate(), "yyyy-MM-dd 23:59:59") + "'";
                }
            }else{ // data privous
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " AND R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] + " <= '" + Formater.formatDate(srcStockCard.getStardDate(), "yyyy-MM-dd 00:00:00") + "'";
                } else {
                    whereClause = " R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] + " <= '" + Formater.formatDate(srcStockCard.getStardDate(), "yyyy-MM-dd 00:00:00") + "'";
                }
            }
            
            String strStatus = "";
            if (srcStockCard.getDocStatus() != null && srcStockCard.getDocStatus().size() > 0) {
                for (int n = 0; n < srcStockCard.getDocStatus().size(); n++) {
                    if (strStatus.length() != 0) {
                        strStatus = strStatus + " OR " + "(R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] + " = " + srcStockCard.getDocStatus().get(n) + ")";
                    } else {
                        strStatus = "(R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_STATUS] + " = " + srcStockCard.getDocStatus().get(n) + ")";
                    }
                }
                strStatus = "(" + strStatus + ")";
            }
            
            if (strStatus.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause +=" AND " + strStatus;
                } else {
                    whereClause = strStatus;
                }
            }
            
            if (whereClause.length() > 0) {
                sql += " WHERE " + whereClause;
            }
            
            sql = sql + " GROUP BY R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE] +
                    " ,R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_CODE];
            sql = sql + " ORDER BY R." + PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_CODE];
            //System.out.println("sql dispatch : "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                StockCardReport stockCardReport = new StockCardReport();

                //System.out.println("Date : "+rs.getDate(PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE]));
                Date date = DBHandler.convertDate(rs.getDate(PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE]),rs.getTime(PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_DATE]));
                stockCardReport.setDate(date);
                //System.out.println("Date : "+date);

                stockCardReport.setDocType(I_DocType.MAT_DOC_TYPE_COS);
                stockCardReport.setDocCode(rs.getString(PstMatCosting.fieldNames[PstMatCosting.FLD_COSTING_CODE]));
                double qtyBase = PstUnit.getQtyPerBaseUnit(rs.getLong(PstMatCostingItem.fieldNames[PstMatCostingItem.FLD_UNIT_ID]),rs.getLong(PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID]));
                stockCardReport.setQty(rs.getDouble("SUM_QTY") * qtyBase);
                stockCardReport.setKeterangan("Costing barang");

                PstStockCardReport.insertExc(stockCardReport);
            }

        } catch (Exception e) {
            System.out.println("err getDataMaterial : "+e.toString());
        }
    }
}
