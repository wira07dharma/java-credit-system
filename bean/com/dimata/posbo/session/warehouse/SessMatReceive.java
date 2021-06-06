package com.dimata.posbo.session.warehouse;

import com.dimata.posbo.entity.search.SrcMatReceive;
import com.dimata.posbo.entity.search.SrcStockCard;
import com.dimata.posbo.entity.warehouse.PstMatReceive;
import com.dimata.posbo.entity.warehouse.MatReceive;
import com.dimata.posbo.entity.warehouse.PstMatReceiveItem;
import com.dimata.posbo.entity.warehouse.MatReceiveItem;
import com.dimata.qdep.entity.I_PstDocType;
import com.dimata.util.LogicParser;
import com.dimata.util.Formater;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.payment.CurrencyType;
import com.dimata.common.entity.payment.PstCurrencyType;
import com.dimata.qdep.entity.I_DocType;
import com.dimata.posbo.entity.warehouse.PstStockCardReport;
import com.dimata.posbo.entity.warehouse.StockCardReport;
import com.dimata.posbo.entity.masterdata.PstMaterial;
import com.dimata.posbo.entity.masterdata.PstUnit;
import com.dimata.posbo.db.DBResultSet;
import com.dimata.posbo.db.DBHandler;
import com.dimata.posbo.entity.purchasing.PurchaseOrder;
import com.dimata.posbo.entity.purchasing.PstPurchaseOrder;

import java.util.Vector;
import java.util.Date;
import java.sql.ResultSet;

/* java package */
public class SessMatReceive {

    public static final String SESS_SRC_MATRECEIVE = "SESSION_SRC_MATRECEIVE";
    public static final String SESS_SRC_MATRECEIVE_DISTRIBUTE = "SESSION_SRC_MATRECEIVE";
    public static final String SESS_SRC_MARRECEIVE = "SESSION_SRC_MARRECEIVE";
    public static final String SESS_SRC_ASSRECEIVE = "SESSION_SRC_ASSRECEIVE";

    public static Vector searchMatReceiveSupplier(SrcMatReceive srcmatreceive, int start, int recordToGet) {
	Vector vectRecNumber = LogicParser.textSentence(srcmatreceive.getReceivenumber());
	for (int i = 0; i < vectRecNumber.size(); i++) {
	    String name = (String) vectRecNumber.get(i);
	    if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0]))) {
		vectRecNumber.remove(i);
	    }
	}

	Vector vectVendorName = LogicParser.textSentence(srcmatreceive.getVendorname());
	for (int i = 0; i < vectVendorName.size(); i++) {
	    String name = (String) vectVendorName.get(i);
	    if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0]))) {
		vectVendorName.remove(i);
	    }
	}
	return getListReceiveMaterial(vectRecNumber, vectVendorName, srcmatreceive, start, recordToGet);
    }

    public static Vector searchMatReceiveNonSupplier(SrcMatReceive srcmatreceive, int start, int recordToGet) {
	Vector vectRecNumber = LogicParser.textSentence(srcmatreceive.getReceivenumber());
	for (int i = 0; i < vectRecNumber.size(); i++) {
	    String name = (String) vectRecNumber.get(i);
	    if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0]))) {
		vectRecNumber.remove(i);
	    }
	}

	return getListReceiveMaterialNonSupplier(vectRecNumber, srcmatreceive, start, recordToGet);
    }

    public static Vector getListReceiveMaterial(Vector vectRecNumber, Vector vectVendorName, SrcMatReceive srcmatreceive, int start, int recordToGet) {
	DBResultSet dbrs = null;
	Vector result = new Vector(1, 1);
	try {
	    String sql = "SELECT REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] +
		    " ,CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REMARK] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_SOURCE] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REASON] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_CURRENCY_ID] +
		    " ,CT." + PstCurrencyType.fieldNames[PstCurrencyType.FLD_CODE] +
		    " ,PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID] +
		    " ,PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE] +
		    " FROM " + PstMatReceive.TBL_MAT_RECEIVE + " REC" +
		    " INNER JOIN " + PstContactList.TBL_CONTACT_LIST + " CNT" +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_SUPPLIER_ID] +
		    " = CNT." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID] +
		    " LEFT JOIN " + PstCurrencyType.TBL_POS_CURRENCY_TYPE + " CT" +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_CURRENCY_ID] +
		    " = CT." + PstCurrencyType.fieldNames[PstCurrencyType.FLD_CURRENCY_TYPE_ID] +
		    " LEFT JOIN " + PstPurchaseOrder.TBL_PURCHASE_ORDER + " PO " +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_PURCHASE_ORDER_ID] +
		    " = PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID];

	    String strRecNumber = "";
	    if (vectRecNumber != null && vectRecNumber.size() > 0) {
		for (int i = 0; i < vectRecNumber.size(); i++) {
		    if (strRecNumber.length() > 0) {
			strRecNumber = strRecNumber + " OR (REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] + " LIKE '%" + vectRecNumber.get(i) + "%')";
		    } else {
			strRecNumber = "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] + " LIKE '%" + vectRecNumber.get(i) + "%')";
		    }
		}
		strRecNumber = "(" + strRecNumber + ")";
	    }

	    String strVendorName = "";
	    if (vectVendorName != null && vectVendorName.size() > 0) {
		for (int a = 0; a < vectVendorName.size(); a++) {
		    if (strVendorName.length() > 0) {
			strVendorName = strVendorName + " OR (CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] + " LIKE '%" + vectVendorName.get(a) + "%')" +
				" OR (CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE '%" + vectVendorName.get(a) + "%')" +
				" OR (CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME] + " LIKE '%" + vectVendorName.get(a) + "%')";
		    } else {
			strVendorName = "(CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] + " LIKE '%" + vectVendorName.get(a) + "%')" +
				" OR (CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE '%" + vectVendorName.get(a) + "%')" +
				" OR (CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME] + " LIKE '%" + vectVendorName.get(a) + "%')";
		    }
		}
		strVendorName = "(" + strVendorName + ")";
	    }

	    String strStatus = "";
	    if (srcmatreceive.getReceivestatus() != null && srcmatreceive.getReceivestatus().size() > 0) {
		for (int b = 0; b < srcmatreceive.getReceivestatus().size(); b++) {
		    if (strStatus.length() != 0) {
			strStatus = strStatus + " OR " + "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + " =" + srcmatreceive.getReceivestatus().get(b) + ")";
		    } else {
			strStatus = "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + " =" + srcmatreceive.getReceivestatus().get(b) + ")";
		    }
		}
		strStatus = "(" + strStatus + ")";
	    }

	    String strDate = "";
	    if (srcmatreceive.getReceivedatestatus() != 0) {
		String startDate = Formater.formatDate(srcmatreceive.getReceivefromdate(), "yyyy-MM-dd 00:00:00");
		String endDate = Formater.formatDate(srcmatreceive.getReceivetodate(), "yyyy-MM-dd 23:59:59");
		strDate = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + " BETWEEN '" + startDate + "' AND '" + endDate + "'";
	    }

	    String strLocationType = "";
	    if (srcmatreceive.getLocationType() != -1) {
		strLocationType = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_TYPE] +
			" = " + srcmatreceive.getLocationType();
	    }

	    String strReceiveSource = "";
	    if (srcmatreceive.getReceiveSource() != -1) {
		strReceiveSource = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_SOURCE] +
			" = " + srcmatreceive.getReceiveSource();
	    }

	    String strLocationId = "";
	    if (srcmatreceive.getLocationId() != 0) {
		strLocationId = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
			" = " + srcmatreceive.getLocationId();
	    }

	    String strInvoiceSupplier = "";
	    if (((srcmatreceive.getInvoiceSupplier()).length() > 0) && (srcmatreceive.getInvoiceSupplier() != null)) {
		strInvoiceSupplier = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_INVOICE_SUPPLIER] + " LIKE '%" + srcmatreceive.getInvoiceSupplier() + "%'";
	    }

	    String whereClause = "";
	    if (strRecNumber.length() > 0) {
		whereClause = strRecNumber;
	    }

	    if (strVendorName.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strVendorName;
		} else {
		    whereClause = whereClause + " AND " + strVendorName;
		}
	    }

	    if (strStatus.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strStatus;
		} else {
		    whereClause = whereClause + " AND " + strStatus;
		}
	    }

	    if (strDate.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strDate;
		} else {
		    whereClause = whereClause + " AND " + strDate;
		}
	    }

	    if (strLocationType.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strLocationType;
		} else {
		    whereClause = whereClause + " AND " + strLocationType;
		}
	    }

	    if (strReceiveSource.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strReceiveSource;
		} else {
		    whereClause = whereClause + " AND " + strReceiveSource;
		}
	    }

	    if (strLocationId.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strLocationId;
		} else {
		    whereClause = whereClause + " AND " + strLocationId;
		}
	    }

	    if (strInvoiceSupplier.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strInvoiceSupplier;
		} else {
		    whereClause = whereClause + " AND " + strInvoiceSupplier;
		}
	    }

	    if (whereClause.length() > 0) {
		sql = sql + " WHERE " + whereClause;
	    }

	    switch (srcmatreceive.getReceivesortby()) {
		case 0:
		    sql = sql + " ORDER BY REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE];
		    break;
		case 1:
		    sql = sql + " ORDER BY CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME];
		    break;
		case 2:
		    sql = sql + " ORDER BY REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_INVOICE_SUPPLIER];
		    break;
                //lokasi terima
                case 3:
                    sql = sql + " ORDER BY REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID];
                    break;
                //end of lokasi terima
		case 4:
		    sql = sql + " ORDER BY REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE];
		    break;
		case 5:
		    sql = sql + " ORDER BY REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS];
		    break;
		case 6:
		    sql = sql + " ORDER BY REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID];
		    break;
	    }

	    sql += ", REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE];
	    /** defaultnya, list diurut berdasarkan DATE */
	    switch (DBHandler.DBSVR_TYPE) {
		case DBHandler.DBSVR_MYSQL:
		    if (start == 0 && recordToGet == 0) {
			sql = sql + "";
		    } else {
			sql = sql + " LIMIT " + start + "," + recordToGet;
		    }
		    break;
		case DBHandler.DBSVR_POSTGRESQL:
		    if (start == 0 && recordToGet == 0) {
			sql = sql + "";
		    } else {
			sql = sql + " LIMIT " + recordToGet + " OFFSET " + start;
		    }
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

	    System.out.println("#SessMatReceive.getListReceiveMaterial(#,#,#,#,#): \n" + sql);
	    dbrs = DBHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();
	    while (rs.next()) {
		Vector vect = new Vector(1, 1);
		MatReceive matreceive = new MatReceive();
		ContactList contactList = new ContactList();
		CurrencyType currencyType = new CurrencyType();
		PurchaseOrder purchaseOrder = new PurchaseOrder();

		matreceive.setOID(rs.getLong(1));
		matreceive.setRecCode(rs.getString(2));
		matreceive.setReceiveDate(rs.getDate(3));
		matreceive.setReceiveStatus(rs.getInt(5));
		matreceive.setRemark(rs.getString(6));
		matreceive.setReceiveSource(rs.getInt(7));
		matreceive.setReason(rs.getInt(8));
		matreceive.setCurrencyId(rs.getLong(9));
		vect.add(matreceive);

		contactList.setCompName(rs.getString(4));
		vect.add(contactList);

		currencyType.setCode(rs.getString("CT." + PstCurrencyType.fieldNames[PstCurrencyType.FLD_CODE]));
		vect.add(currencyType);

		purchaseOrder.setOID(rs.getLong("PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID]));
		purchaseOrder.setPoCode(rs.getString("PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE]));
		vect.add(purchaseOrder);

		result.add(vect);
	    }
	} catch (Exception e) {
	    System.out.println("SessMatReceive.getListReceiveMaterialnonSupplier() err : " + e.toString());
	} finally {
	    DBResultSet.close(dbrs);
	}
	return result;

    }

    public static Vector getListReceiveMaterialNonSupplier(Vector vectRecNumber, SrcMatReceive srcmatreceive, int start, int recordToGet) {
	DBResultSet dbrs = null;
	Vector result = new Vector(1, 1);
	try {
	    String sql = "SELECT REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] +
		    " ,LOC." + PstLocation.fieldNames[PstLocation.FLD_NAME] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REMARK] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_SOURCE] +
		    " ,CT." + PstCurrencyType.fieldNames[PstCurrencyType.FLD_CODE] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
		    " ,REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_FROM] +
		    " FROM " + PstMatReceive.TBL_MAT_RECEIVE + " REC" +
		    " INNER JOIN " + PstLocation.TBL_P2_LOCATION + " LOC" +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_FROM] +
		    " = LOC." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] +
		    " LEFT JOIN " + PstCurrencyType.TBL_POS_CURRENCY_TYPE + " CT" +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_CURRENCY_ID] +
		    " = CT." + PstCurrencyType.fieldNames[PstCurrencyType.FLD_CURRENCY_TYPE_ID];

	    String strRecNumber = "";
	    if (vectRecNumber != null && vectRecNumber.size() > 0) {
		for (int i = 0; i < vectRecNumber.size(); i++) {
		    if (strRecNumber.length() > 0) {
			strRecNumber = " OR (REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] + " LIKE '" + vectRecNumber.get(i) + "%')";
		    } else {
			strRecNumber = "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] + " LIKE '" + vectRecNumber.get(i) + "%')";
		    }
		}
		strRecNumber = "(" + strRecNumber + ")";
	    }

	    String strStatus = "";
	    if (srcmatreceive.getReceivestatus() != null && srcmatreceive.getReceivestatus().size() > 0) {
		for (int b = 0; b < srcmatreceive.getReceivestatus().size(); b++) {
		    if (strStatus.length() != 0) {
			strStatus = strStatus + " OR " + "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + " =" + srcmatreceive.getReceivestatus().get(b) + ")";
		    } else {
			strStatus = "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + " =" + srcmatreceive.getReceivestatus().get(b) + ")";
		    }
		}
		strStatus = "(" + strStatus + ")";
	    }

	    String strDate = "";
	    if (srcmatreceive.getReceivedatestatus() != 0) {
		String startDate = Formater.formatDate(srcmatreceive.getReceivefromdate(), "yyyy-MM-dd 00:00:00");
		String endDate = Formater.formatDate(srcmatreceive.getReceivetodate(), "yyyy-MM-dd 23:59:59");
		strDate = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + " BETWEEN '" + startDate + "' AND '" + endDate + "'";
	    }

	    String strLocationType = "";
	    if (srcmatreceive.getLocationType() != -1) {
		strLocationType = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_TYPE] +
			" = " + srcmatreceive.getLocationType();
	    }

	    String strReceiveSource = "";
	    if (srcmatreceive.getReceiveSource() != -1) {
		strReceiveSource = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_SOURCE] +
			" = " + srcmatreceive.getReceiveSource();
	    }

	    String strLocationId = "";
	    if (srcmatreceive.getLocationId() != 0) {
		strLocationId = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
			" = " + srcmatreceive.getLocationId();
	    }

	    String strLocationFrom = "";
	    if (srcmatreceive.getLocationFrom() != 0) {
		strLocationFrom = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_FROM] +
			" = " + srcmatreceive.getLocationFrom();
	    }

	    String whereClause = "";
	    if (strRecNumber.length() > 0) {
		whereClause = strRecNumber;
	    }

	    if (strStatus.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strStatus;
		} else {
		    whereClause = whereClause + " AND " + strStatus;
		}
	    }

	    if (strDate.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strDate;
		} else {
		    whereClause = whereClause + " AND " + strDate;
		}
	    }

	    if (strLocationType.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strLocationType;
		} else {
		    whereClause = whereClause + " AND " + strLocationType;
		}
	    }

	    if (strReceiveSource.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strReceiveSource;
		} else {
		    whereClause = whereClause + " AND " + strReceiveSource;
		}
	    }

	    if (strLocationId.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strLocationId;
		} else {
		    whereClause = whereClause + " AND " + strLocationId;
		}
	    }

	    if (strLocationFrom.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strLocationFrom;
		} else {
		    whereClause = whereClause + " AND " + strLocationFrom;
		}
	    }

	    if (whereClause.length() > 0) {
		sql = sql + " WHERE " + whereClause;
	    }

	    switch (srcmatreceive.getReceivesortby()) {
		case 0:
		    sql = sql + " ORDER BY REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE];
		    break;
		case 1:
		    sql = sql + " ORDER BY LOC." + PstLocation.fieldNames[PstLocation.FLD_NAME];
		    break;
		case 2:
		    sql = sql + " ORDER BY REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE];
		    break;
		case 3:
		    sql = sql + " ORDER BY REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS];
		    break;
	    }

	    switch (DBHandler.DBSVR_TYPE) {
		case DBHandler.DBSVR_MYSQL:
		    if (start == 0 && recordToGet == 0) {
			sql = sql + "";
		    } else {
			sql = sql + " LIMIT " + start + "," + recordToGet;
		    }
		    break;
		case DBHandler.DBSVR_POSTGRESQL:
		    if (start == 0 && recordToGet == 0) {
			sql = sql + "";
		    } else {
			sql = sql + " LIMIT " + recordToGet + " OFFSET " + start;
		    }
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
	    System.out.println("sql in getListReceiveMaterialNonSupplier: " + sql);
	    dbrs = DBHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();
	    while (rs.next()) {
		Vector vect = new Vector(1, 1);
		MatReceive matreceive = new MatReceive();
		Location loc = new Location();
		CurrencyType currencyType = new CurrencyType();

		matreceive.setOID(rs.getLong(1));
		matreceive.setRecCode(rs.getString(2));
		matreceive.setReceiveDate(rs.getDate(3));
		matreceive.setReceiveStatus(rs.getInt(5));
		matreceive.setRemark(rs.getString(6));
		matreceive.setReceiveSource(rs.getInt(7));
		matreceive.setLocationId(rs.getLong("REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID]));
		matreceive.setReceiveFrom(rs.getLong("REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_FROM]));
		vect.add(matreceive);

		loc.setName(rs.getString(4));
		vect.add(loc);

		currencyType.setCode(rs.getString("CT." + PstCurrencyType.fieldNames[PstCurrencyType.FLD_CODE]));
		vect.add(currencyType);

		result.add(vect);
	    }
	} catch (Exception e) {
	    System.out.println("SessMatReceive.getListReceiveMaterialnonSupplier() err : " + e.toString());
	} finally {           
	    DBResultSet.close(dbrs);
	}
	return result;

    }
    
    public static int getCountSearchSupplier(SrcMatReceive srcmatreceive) {
	Vector vectRecNumber = LogicParser.textSentence(srcmatreceive.getReceivenumber());
	for (int i = 0; i < vectRecNumber.size(); i++) {
	    String name = (String) vectRecNumber.get(i);
	    if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0]))) {
		vectRecNumber.remove(i);
	    }
	}

	Vector vectVendorName = LogicParser.textSentence(srcmatreceive.getVendorname());
	for (int i = 0; i < vectVendorName.size(); i++) {
	    String name = (String) vectVendorName.get(i);
	    if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0]))) {
		vectVendorName.remove(i);
	    }
	}
	return getCountListReceiveMaterial(vectRecNumber, vectVendorName, srcmatreceive);
    }

    public static int getCountSearchNonSupplier(SrcMatReceive srcmatreceive) {
	Vector vectRecNumber = LogicParser.textSentence(srcmatreceive.getReceivenumber());
	for (int i = 0; i < vectRecNumber.size(); i++) {
	    String name = (String) vectRecNumber.get(i);
	    if ((name.equals(LogicParser.SIGN)) || (name.equals(LogicParser.ENGLISH[0]))) {
		vectRecNumber.remove(i);
	    }
	}

	return getCountListReceiveMaterialNonSupplier(vectRecNumber, srcmatreceive);
    }

    public static int getCountListReceiveMaterial(Vector vectRecNumber, Vector vectVendorName, SrcMatReceive srcmatreceive) {
	DBResultSet dbrs = null;
	int count = 0;
	try {
	    String sql = "SELECT COUNT(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] + ") AS CNT" +
		    " FROM " + PstMatReceive.TBL_MAT_RECEIVE + " REC" +
		    " INNER JOIN " + PstContactList.TBL_CONTACT_LIST + " CNT" +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_SUPPLIER_ID] +
		    " = CNT." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID];

	    String strRecNumber = "";
	    if (vectRecNumber != null && vectRecNumber.size() > 0) {
		for (int i = 0; i < vectRecNumber.size(); i++) {
		    if (strRecNumber.length() > 0) {
			strRecNumber = " OR (REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] + " LIKE '%" + vectRecNumber.get(i) + "%')";
		    } else {
			strRecNumber = "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] + " LIKE '%" + vectRecNumber.get(i) + "%')";
		    }
		}
		strRecNumber = "(" + strRecNumber + ")";
	    }

	    String strVendorName = "";
	    if (vectVendorName != null && vectVendorName.size() > 0) {
		for (int a = 0; a < vectVendorName.size(); a++) {
		    if (strVendorName.length() > 0) {
			strVendorName = strVendorName + " OR (CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] + " LIKE '%" + vectVendorName.get(a) + "%')" +
				" OR (CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE '%" + vectVendorName.get(a) + "%')" +
				" OR (CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME] + " LIKE '%" + vectVendorName.get(a) + "%')";
		    } else {
			strVendorName = "(CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] + " LIKE '%" + vectVendorName.get(a) + "%')" +
				" OR (CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE '%" + vectVendorName.get(a) + "%')" +
				" OR (CNT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME] + " LIKE '%" + vectVendorName.get(a) + "%')";
		    }
		}
		strVendorName = "(" + strVendorName + ")";
	    }

	    String strStatus = "";
	    if (srcmatreceive.getReceivestatus() != null && srcmatreceive.getReceivestatus().size() > 0) {
		for (int b = 0; b < srcmatreceive.getReceivestatus().size(); b++) {
		    if (strStatus.length() != 0) {
			strStatus = strStatus + " OR " + "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + " =" + srcmatreceive.getReceivestatus().get(b) + ")";
		    } else {
			strStatus = "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + " =" + srcmatreceive.getReceivestatus().get(b) + ")";
		    }
		}
		strStatus = "(" + strStatus + ")";
	    }

	    String strDate = "";
	    if (srcmatreceive.getReceivedatestatus() != 0) {
		String startDate = Formater.formatDate(srcmatreceive.getReceivefromdate(), "yyyy-MM-dd 00:00:00");
		String endDate = Formater.formatDate(srcmatreceive.getReceivetodate(), "yyyy-MM-dd 23:59:59");
		strDate = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + " BETWEEN '" + startDate + "' AND '" + endDate + "'";
	    }

	    String strLocationType = "";
	    if (srcmatreceive.getLocationType() != -1) {
		strLocationType = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_TYPE] +
			" = " + srcmatreceive.getLocationType();
	    }

	    String strReceiveSource = "";
	    if (srcmatreceive.getReceiveSource() != -1) {
		strReceiveSource = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_SOURCE] +
			" = " + srcmatreceive.getReceiveSource();
	    }

	    String strLocationId = "";
	    if (srcmatreceive.getLocationId() != 0) {
		strLocationId = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
			" = " + srcmatreceive.getLocationId();
	    }

	    String strInvoiceSupplier = "";
	    if (((srcmatreceive.getInvoiceSupplier()).length() > 0) && (srcmatreceive.getInvoiceSupplier() != null)) {
		strInvoiceSupplier = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_INVOICE_SUPPLIER] + " LIKE '%" + srcmatreceive.getInvoiceSupplier() + "%'";
	    }

	    String whereClause = "";
	    if (strRecNumber.length() > 0) {
		whereClause = strRecNumber;
	    }

	    if (strVendorName.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strVendorName;
		} else {
		    whereClause = whereClause + " AND " + strVendorName;
		}
	    }

	    if (strStatus.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strStatus;
		} else {
		    whereClause = whereClause + " AND " + strStatus;
		}
	    }

	    if (strDate.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strDate;
		} else {
		    whereClause = whereClause + " AND " + strDate;
		}
	    }

	    if (strLocationType.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strLocationType;
		} else {
		    whereClause = whereClause + " AND " + strLocationType;
		}
	    }

	    if (strReceiveSource.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strReceiveSource;
		} else {
		    whereClause = whereClause + " AND " + strReceiveSource;
		}
	    }

	    if (strLocationId.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strLocationId;
		} else {
		    whereClause = whereClause + " AND " + strLocationId;
		}
	    }

	    if (strInvoiceSupplier.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strInvoiceSupplier;
		} else {
		    whereClause = whereClause + " AND " + strInvoiceSupplier;
		}
	    }

	    if (whereClause.length() > 0) {
		sql = sql + " WHERE " + whereClause;
	    }

	    System.out.println("getCountListReceiveMaterial: " + sql);
	    dbrs = DBHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();
	    while (rs.next()) {
		count = rs.getInt("CNT");
	    }
	} catch (Exception e) {
	    System.out.println("SessMatReceive.getCountListReceiveMaterial() err : " + e.toString());
	} finally {
	    DBResultSet.close(dbrs);
	}
	return count;
    }

    public static int getCountListReceiveMaterialNonSupplier(Vector vectRecNumber, SrcMatReceive srcmatreceive) {
	DBResultSet dbrs = null;
	int count = 0;
	try {
	    String sql = "SELECT COUNT(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] + ") AS CNT" +
		    " FROM " + PstMatReceive.TBL_MAT_RECEIVE + " REC" +
		    " INNER JOIN " + PstLocation.TBL_P2_LOCATION + " LOC" +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_FROM] +
		    " = LOC." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] +
		    " LEFT JOIN " + PstCurrencyType.TBL_POS_CURRENCY_TYPE + " CT" +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_CURRENCY_ID] +
		    " = CT." + PstCurrencyType.fieldNames[PstCurrencyType.FLD_CURRENCY_TYPE_ID];

	    String strRecNumber = "";
	    if (vectRecNumber != null && vectRecNumber.size() > 0) {
		for (int i = 0; i < vectRecNumber.size(); i++) {
		    if (strRecNumber.length() > 0) {
			strRecNumber = " OR (REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] + " LIKE '%" + vectRecNumber.get(i) + "%')";
		    } else {
			strRecNumber = "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] + " LIKE '%" + vectRecNumber.get(i) + "%')";
		    }
		}
		strRecNumber = "(" + strRecNumber + ")";
	    }

	    String strStatus = "";
	    if (srcmatreceive.getReceivestatus() != null && srcmatreceive.getReceivestatus().size() > 0) {
		for (int b = 0; b < srcmatreceive.getReceivestatus().size(); b++) {
		    if (strStatus.length() != 0) {
			strStatus = strStatus + " OR " + "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + " =" + srcmatreceive.getReceivestatus().get(b) + ")";
		    } else {
			strStatus = "(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + " =" + srcmatreceive.getReceivestatus().get(b) + ")";
		    }
		}
		strStatus = "(" + strStatus + ")";
	    }

	    String strDate = "";
	    if (srcmatreceive.getReceivedatestatus() != 0) {
		String startDate = Formater.formatDate(srcmatreceive.getReceivefromdate(), "yyyy-MM-dd 00:00:00");
		String endDate = Formater.formatDate(srcmatreceive.getReceivetodate(), "yyyy-MM-dd 23:59:59");
		strDate = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + " BETWEEN '" + startDate + "' AND '" + endDate + "'";
	    }

	    String strLocationType = "";
	    if (srcmatreceive.getLocationType() != -1) {
		strLocationType = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_TYPE] +
			" = " + srcmatreceive.getLocationType();
	    }

	    String strReceiveSource = "";
	    if (srcmatreceive.getReceiveSource() != -1) {
		strReceiveSource = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_SOURCE] +
			" = " + srcmatreceive.getReceiveSource();
	    }

	    String strLocationId = "";
	    if (srcmatreceive.getLocationId() != 0) {
		strLocationId = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
			" = " + srcmatreceive.getLocationId();
	    }

	    String strLocationFrom = "";
	    if (srcmatreceive.getLocationFrom() != 0) {
		strLocationFrom = " REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_FROM] +
			" = " + srcmatreceive.getLocationFrom();
	    }

	    String whereClause = "";
	    if (strRecNumber.length() > 0) {
		whereClause = strRecNumber;
	    }

	    if (strStatus.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strStatus;
		} else {
		    whereClause = whereClause + " AND " + strStatus;
		}
	    }

	    if (strDate.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strDate;
		} else {
		    whereClause = whereClause + " AND " + strDate;
		}
	    }

	    if (strLocationType.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strLocationType;
		} else {
		    whereClause = whereClause + " AND " + strLocationType;
		}
	    }

	    if (strReceiveSource.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strReceiveSource;
		} else {
		    whereClause = whereClause + " AND " + strReceiveSource;
		}
	    }

	    if (strLocationId.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strLocationId;
		} else {
		    whereClause = whereClause + " AND " + strLocationId;
		}
	    }

	    if (strLocationFrom.length() > 0) {
		if (whereClause.length() == 0) {
		    whereClause = whereClause + strLocationFrom;
		} else {
		    whereClause = whereClause + " AND " + strLocationFrom;
		}
	    }

	    if (whereClause.length() > 0) {
		sql = sql + " WHERE " + whereClause;
	    }

	    dbrs = DBHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();
	    while (rs.next()) {
		count = rs.getInt("CNT");
	    }
	} catch (Exception e) {
	    System.out.println("SessMatReceive.getCountListReceiveMaterialNonSupplier() err : " + e.toString());
	} finally {
	    DBResultSet.close(dbrs);
	}
	return count;
    }

    
    /**
     * this method used to count Material Receive and generate next index
     */
    public static int getIntCode(MatReceive matReceive, Date pDate, long oid, int counter) {
	int max = 0;
	DBResultSet dbrs = null;
	Date date = new Date();
	try {
	    String sql = "SELECT MAX(" + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE_CNT] + ") AS PMAX" +
		    " FROM " + PstMatReceive.TBL_MAT_RECEIVE +
		    " WHERE YEAR(" + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + ") = " + (matReceive.getReceiveDate().getYear() + 1900) + "" +
		    " AND MONTH(" + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + ") = " + (matReceive.getReceiveDate().getMonth() + 1) +
		    " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] + " <> " + oid +
		    " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
		    " = " + matReceive.getLocationId();

	    dbrs = DBHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();

	    while (rs.next()) {
		max = rs.getInt("PMAX");
	    }
	    rs.close();

	    if (oid == 0) {
		max = max + 1;
	    } else {
		if (matReceive.getReceiveDate() != pDate) {
		    max = max + 1;
		} else {
		    max = counter;
		}
	    }

	} catch (Exception e) {
	    System.out.println("Err at counter : " + e.toString());
	} finally {
	    DBResultSet.close(dbrs);
	}
	return max;
    }

    /**
     * this method used to getNextIndex of maximum number of Receive number
     * return : int new number
     *
     * modified on : July 05, 2003 09:07 PM
     * modified by : gedhy
     */
    public static int getIntCode(MatReceive matReceive, Date pDate, long oid, int receiveType, int counter, boolean isIncrement) {
	int max = 0;
	DBResultSet dbrs = null;
	Date date = new Date();
	try {
	    String sql = "SELECT MAX(" + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE_CNT] + ") AS PMAX" +
		    " FROM " + PstMatReceive.TBL_MAT_RECEIVE +
		    " WHERE YEAR(" + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + ") = " + (matReceive.getReceiveDate().getYear() + 1900) + "" +
		    " AND MONTH(" + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + ") = " + (matReceive.getReceiveDate().getMonth() + 1) +
		    " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] + " <> " + oid +
		    " AND " + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] +
		    " = " + matReceive.getLocationId();

	    dbrs = DBHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();
	    while (rs.next()) {
		max = rs.getInt("PMAX");
	    }

	    if (oid == 0) {
		max = max + 1;
	    } else {
		if (matReceive.getReceiveDate() != pDate) {
		    max = max + 1;
		} else {
		    max = counter;
		}
	    }
	} catch (Exception e) {
	    System.out.println("SessMatReceive.getIntCode() err : " + e.toString());
	} finally {
	    DBResultSet.close(dbrs);
	}
	return max;
    }

    public static Vector getListReceiveItem(long oidReceive) {
	DBResultSet dbrs = null;
	Vector result = new Vector(1, 1);
	/*try{
	String sql = "SELECT "+
	" ITEM."+PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_QUANTITY_RECEIVE]+
	" ,ITEM."+PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_NOTES]+
	" ,MAT."+PstMaterial.fieldNames[PstMaterial.FLD_CODE]+
	" ,MAT."+PstMaterial.fieldNames[PstMaterial.FLD_NAME]+
	" ,MAT."+PstMaterial.fieldNames[PstMaterial.FLD_DESCRIPTION]+
	" ,GRP."+PstMaterialGroup.fieldNames[PstMaterialGroup.FLD_CODE]+" AS GRP_"+PstMaterialGroup.fieldNames[PstMaterialGroup.FLD_CODE]+
	" ,GRP."+PstMaterialGroup.fieldNames[PstMaterialGroup.FLD_NAME]+" AS GRP_"+PstMaterialGroup.fieldNames[PstMaterialGroup.FLD_NAME]+
	" ,UNT."+PstMatUnit.fieldNames[PstMatUnit.FLD_UNIT_NAME]+
	" FROM "+PstMatReceiveItem.TBL_MAT_RECEIVE_ITEM+" AS ITEM "+
	" INNER JOIN "+PstMaterial.TBL_MATERIAL+" AS MAT "+
	" ON ITEM."+PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_MATERIAL_ID]+
	" = MAT."+PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID]+
	" INNER JOIN "+PstMaterialGroup.TBL_MATERIAL_GROUP+" AS GRP "+
	" ON MAT."+PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_GROUP_ID]+
	" = GRP."+PstMaterialGroup.fieldNames[PstMaterialGroup.FLD_MATERIAL_GROUP_ID]+
	" INNER JOIN "+PstMatUnit.TBL_P2_UNIT+" AS UNT "+
	" ON MAT."+PstMaterial.fieldNames[PstMaterial.FLD_UNIT]+
	" = UNT."+PstMatUnit.fieldNames[PstMatUnit.FLD_UNIT_ID]+
	" WHERE ITEM."+PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_MAT_RECEIVE_ID]+" = "+oidReceive;
	System.out.println("sql receive : "+sql);
	dbrs = DBHandler.execQueryResult(sql);
	ResultSet rs = dbrs.getResultSet();
	while(rs.next()){
	Vector vt = new Vector(1,1);
	MatReceiveItem matReceiveItem = new MatReceiveItem();
	Material material = new Material();
	MaterialGroup materialGroup = new MaterialGroup();
	MatUnit unit = new MatUnit();
	matReceiveItem.setQuantityReceive(rs.getInt(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_QUANTITY_RECEIVE]));
	matReceiveItem.setNotes(rs.getString(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_NOTES]));
	vt.add(matReceiveItem);
	material.setCode(rs.getString(PstMaterial.fieldNames[PstMaterial.FLD_CODE]));
	material.setName(rs.getString(PstMaterial.fieldNames[PstMaterial.FLD_NAME]));
	material.setDescription(rs.getString(PstMaterial.fieldNames[PstMaterial.FLD_DESCRIPTION]));
	vt.add(material);
	materialGroup.setCode(rs.getString("GRP_"+PstMaterialGroup.fieldNames[PstMaterialGroup.FLD_CODE]));
	materialGroup.setName(rs.getString("GRP_"+PstMaterialGroup.fieldNames[PstMaterialGroup.FLD_NAME]));
	vt.add(materialGroup);
	unit.setUnitName(rs.getString(PstMatUnit.fieldNames[PstMatUnit.FLD_UNIT_NAME]));
	vt.add(unit);
	result.add(vt);
	}
	rs.close();
	}catch(Exception e){
	}finally{
	DBResultSet.close(dbrs);
	}*/
	return result;
    }

    public static String getCodeReceive(MatReceive matReceive) {
	String code = "REC";
	String dateCode = "";
	if (matReceive.getReceiveDate() != null) {
	    /** get location code; gwawan@21juni2007 */
	    Vector vctLocation = PstLocation.list(0, 0, PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + "=" + matReceive.getLocationId(), "");
	    Location location = (Location) vctLocation.get(0);

	    int nextCounter = matReceive.getRecCodeCnt();//getMaxCounter(date);
	    Date date = matReceive.getReceiveDate();

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

    /**
     * fungsi ini di gunakan untuk mencari daftar penerimaan barang
     * di pakai untuk stock card.
     * @return
     */
    public static void getDataMaterial(SrcStockCard srcStockCard) {
	DBResultSet dbrs = null;
	try {
	    String sql = "SELECT" +
		    " R." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] +
		    " ,R." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE] +
		    " ,SUM(RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_QTY] + ") AS SUM_QTY " +
		    " ,RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_UNIT_ID] +
		    " ,M." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID] +
		    " FROM " + PstMatReceive.TBL_MAT_RECEIVE + " AS R " +
		    " INNER JOIN " + PstMatReceiveItem.TBL_MAT_RECEIVE_ITEM + " AS RI " +
		    " ON R." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] +
		    " = RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RECEIVE_MATERIAL_ID] +
		    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " AS M " +
		    " ON RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_MATERIAL_ID] +
		    " = M." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID];

	    String whereClause = "";
	    if (srcStockCard.getMaterialId() != 0) {
		whereClause = "RI." + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_MATERIAL_ID] + "=" + srcStockCard.getMaterialId();
	    }

	    if (srcStockCard.getLocationId() != 0) {
		if (whereClause.length() > 0) {
		    whereClause = whereClause + " AND R." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] + "=" + srcStockCard.getLocationId();
		} else {
		    whereClause = "R." + PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID] + "=" + srcStockCard.getLocationId();
		}
	    }

	    if ((srcStockCard.getStardDate() != null) && (srcStockCard.getEndDate() != null)) {
		if (whereClause.length() > 0) {
		    whereClause = whereClause + " AND R." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + " BETWEEN '" + Formater.formatDate(srcStockCard.getStardDate(), "yyyy-MM-dd 00:00:00") + "' AND '" + Formater.formatDate(srcStockCard.getEndDate(), "yyyy-MM-dd 23:59:59") + "'";
		} else {
		    whereClause = " R." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + " BETWEEN '" + Formater.formatDate(srcStockCard.getStardDate(), "yyyy-MM-dd 00:00:00") + "' AND '" + Formater.formatDate(srcStockCard.getEndDate(), "yyyy-MM-dd 23:59:59") + "'";
		}
	    } else { // jika tanggal end date = null;
		if (whereClause.length() > 0) {
		    whereClause = whereClause + " AND R." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + " <= '" + Formater.formatDate(srcStockCard.getStardDate(), "yyyy-MM-dd 00:00:00") + "'";
		} else {
		    whereClause = " R." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] + " <= '" + Formater.formatDate(srcStockCard.getStardDate(), "yyyy-MM-dd 00:00:00") + "'";
		}
	    }

	    String strStatus = "";
	    if (srcStockCard.getDocStatus() != null && srcStockCard.getDocStatus().size() > 0) {
		for (int n = 0; n < srcStockCard.getDocStatus().size(); n++) {
		    if (strStatus.length() != 0) {
			strStatus = strStatus + " OR " + "(R." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + " = " + srcStockCard.getDocStatus().get(n) + ")";
		    } else {
			strStatus = "(R." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + " = " + srcStockCard.getDocStatus().get(n) + ")";
		    }
		}
		strStatus = "(" + strStatus + ")";
	    }

	    if (strStatus.length() > 0) {
		if (whereClause.length() > 0) {
		    whereClause += " AND " + strStatus;
		} else {
		    whereClause = strStatus;
		}
	    }

	    if (whereClause.length() > 0) {
		sql += " WHERE " + whereClause;
	    }

	    sql = sql + " GROUP BY R." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE] +
		    " ,R." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE];
	    sql = sql + " ORDER BY R." + PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE];

	    dbrs = DBHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();
	    while (rs.next()) {
		StockCardReport stockCardReport = new StockCardReport();

		Date date = DBHandler.convertDate(rs.getDate(PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE]), rs.getTime(PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE]));
		stockCardReport.setDate(date);

		stockCardReport.setDocType(I_DocType.MAT_DOC_TYPE_LMRR);
		stockCardReport.setDocCode(rs.getString(PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE]));

		double qty = PstUnit.getQtyPerBaseUnit(rs.getLong(PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_UNIT_ID]), rs.getLong(PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_STOCK_UNIT_ID]));
		stockCardReport.setQty(rs.getDouble("SUM_QTY") * qty);
		stockCardReport.setKeterangan("Penerimaan barang");
		PstStockCardReport.insertExc(stockCardReport);
	    }

	} catch (Exception e) {
	    System.out.println("err getDataMaterial : " + e.toString());
	}
    }

    /**
     * for process insert receive
     * @param list
     * @return
     */
    public static Vector approveReceiveProcess(Vector list) {
	Vector result = new Vector(1, 1);
	try {
	    if (list.size() > 0) {
		int docType = -1;
		try {
		    I_PstDocType i_pstDocType = (I_PstDocType) Class.forName(I_DocType.DOCTYPE_CLASSNAME).newInstance();
		    docType = i_pstDocType.composeDocumentType(I_DocType.SYSTEM_MATERIAL, I_DocType.MAT_DOC_TYPE_LMRR);		    
		} catch (Exception e) {
		    System.out.println("Exc : " + e.toString());
		}

		for (int k = 0; k < list.size(); k++) {
		    Vector listrec = (Vector) list.get(k);
		    MatReceive matReceive = (MatReceive) listrec.get(0);

		    matReceive.setRecCodeCnt(SessMatReceive.getIntCode(matReceive, matReceive.getReceiveDate(), 0, docType, 0, true));
		    matReceive.setRecCode(SessMatReceive.getCodeReceive(matReceive));
		    matReceive.setLastUpdate(new Date());

		    long oid = PstMatReceive.insertExc(matReceive);
		    try {
			matReceive = PstMatReceive.fetchExc(oid);
			result.add(matReceive);
		    } catch (Exception e) {
		    }

		    Vector listData = (Vector) listrec.get(1);
		    for (int j = 0; j < listData.size(); j++) {
			MatReceiveItem matReceiveItem = (MatReceiveItem) listData.get(j);
			matReceiveItem.setReceiveMaterialId(oid);
			try {
			    PstMatReceiveItem.insertExc(matReceiveItem);
			} catch (Exception e) {
			}
		    }
		}
	    }
	} catch (Exception e) {
	}
	return result;
    }
}
