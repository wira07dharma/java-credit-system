<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*,
                 com.dimata.util.*,
                 com.dimata.harisma.entity.masterdata.PstDepartment,
                 com.dimata.harisma.entity.masterdata.Department,
                 com.dimata.aiso.entity.report.Neraca,
                 com.dimata.aiso.session.report.SessWorkSheet,
                 com.dimata.aiso.session.report.SessNeraca,
                 com.dimata.aiso.entity.periode.PstPeriode,
                 com.dimata.aiso.entity.periode.Periode,
                 com.dimata.aiso.entity.masterdata.Perkiraan,
                 com.dimata.interfaces.chartofaccount.I_ChartOfAccountGroup,
                 com.dimata.aiso.entity.masterdata.PstPerkiraan" %>

<!--import java-->
<%@ page import="java.util.Date" %>

<!--import qdep-->
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_TRIAL_BALANCE, AppObjInfo.OBJ_REPORT_TRIAL_BALANCE_PRIV); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition
if(!privView && !privSubmit){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
}else{
%>

<%!
int FLAG_PRINT = 0;

public static String strTitle[][] = {
	{"Periode","Keterangan","Realisasi","Anggaran","Pencapaian","Debet",
     "Kredit","Saldo Akhir","Data tidak ditemukan. Silahkan periksa kembali data",
     "Departemen","Silahkan pilih departemen dulu","AKTIVA","TOTAL AKTIVA","PASIVA","TOTAL PASIVA"},

	{"Period","Description","Actual","Budget","Achievement","Debet",
     "Kredit","Last Balance","Data not found. Please check data and try again.",
     "Department","Please change department first","ACTIVA","TOTAL ACTIVA","PASSIVA","TOTAL PASSIVA"}
};

public static String strHeader[][] = {
	{"Perkiraan","Desember","Perubahan","Rp","%","Dalam"},
	{"Account","as of","Changes","IDR","%","in"}	
};

private static final String strTitleReporPDF[][] = {
	{"BALANCE SHEET","Per","Rp.","Dalam"},
	{"BALANCE SHEET","As of","IDR","in"}
};

public static String strTitleContent[][] = {
	{"AKTIVA","Aktiva Lancar", "Aktiva Tetap","Aktiva Lain-lain","HUTANG DAN EKUITAS","Hutang JK Pendek","Hutang JK Panjang","Ekuitas"},
	{"ASSETS","Current Assets","Fixed Assets","Other Assets","Short Term Liabilities","Long Term Liabilities","Equity","LIABILITIES AND EQUITY"}
};
public static final String masterTitle[] = {
	"Laporan","Report"
};

public static final String listTitle[] = {
	"Neraca","Balance Sheet"
};

public static String formatStringNumber(double dbl, FRMHandler frmHandler){
    if(Double.isInfinite(dbl))
        return String.valueOf(frmHandler.userFormatStringDecimal(0.0));
    if(Double.isNaN(dbl))
        return String.valueOf(frmHandler.userFormatStringDecimal(0.0));

    if(dbl<0)
        return "("+String.valueOf(frmHandler.userFormatStringDecimal(dbl * -1))+")";
    else
        return String.valueOf(frmHandler.userFormatStringDecimal(dbl));
}


/** dwi 2007/05/24
 * For value format
 * @param double that will be formatted
 * @return String formatted value
 */
	 
private static String formatNumber(double dblValue){
	String strValue = "";	
	if(dblValue < 0)
		strValue = "<div align=\"right\">("+Formater.formatNumber(dblValue * -1, "##,###.##")+")</div>";
	else
		strValue = "<div align=\"right\">"+Formater.formatNumber(dblValue, "##,###.##")+"</div>";		
	return 	strValue;
}

/** dwi 2007/05/24
 * For value format PDF
 * @param double that will be formatted
 * @return String formatted value
 */
	 
private static String formatNumberPDF(double dblValue){
	String strValue = "";	
	if(dblValue < 0)
		strValue = "("+Formater.formatNumber(dblValue * -1, "##,###.##")+")";
	else
		strValue = Formater.formatNumber(dblValue, "##,###.##");		
	return 	strValue;
}

/** dwi 2007/05/24
 * View Account Name base on language
 * @param object of perkiraan 
 * @return String Account Name
 */
private static String getAccountName(Perkiraan objPerkiraan, int language){
	String accName = "";
		if(objPerkiraan != null){
			try{
				if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
					accName = objPerkiraan.getAccountNameEnglish();
				else
					accName = objPerkiraan.getNama();	
			}catch(Exception e){
				System.out.println("Exception on getAccountName () :::: "+e.toString());
			}
		}
	return accName;
}

/** dwi 2007/05/24
 * View Parent Account Data
 * @param object of perkiraan
 * @param int language
 * @return Vector Parent Account Data
 */
private static Vector getParent(Perkiraan objPerkiraan, int language){
	Vector vResult = new Vector(1,1);
	Vector vTempJSP = new Vector(1,1);
	Vector vTempPDF = new Vector(1,1);
		if(objPerkiraan != null){
			try{
				Vector  rowx = new Vector();
				rowx.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+objPerkiraan.getNoPerkiraan()+"&nbsp;"+getAccountName(objPerkiraan, language));
				rowx.add("");
				rowx.add("");
				rowx.add("");
				rowx.add("");
				vTempJSP.add(rowx);
				
				Vector  rowR = new Vector();
				rowR.add("        "+objPerkiraan.getNoPerkiraan()+" "+getAccountName(objPerkiraan, language));
				rowR.add("");
				rowR.add("");
				rowR.add("");
				rowR.add("");
				vTempPDF.add(rowR);
				
			}catch(Exception e){
				System.out.println("Exception on getParent ::::: "+e.toString());
			}		
		}
	vResult.add(vTempJSP);
	vResult.add(vTempPDF);	
	return vResult;
}

/** dwi 2007/05/24
 * View Child Account Data
 * @param object of neraca
 * @param object of perkiraan
 * @param int language
 * @param double previous amount
 * @param double current amount
 * @return Vector Child Account Data
 */
private static Vector getChild(Neraca objNeraca, Perkiraan objPerkiraan, int language, double prevAmount, double currAmount, 
double totPrevAmount, double totCurrAmount, double dValueReport){
	Vector vResult = new Vector(1,1);
	Vector vTempJSP = new Vector(1,1);
	Vector vTempPDF = new Vector(1,1);
		if(objPerkiraan != null){
			try{
				Vector rowx = new Vector();
				rowx.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+getAccountName(objPerkiraan, language));
				rowx.add(formatNumber((objNeraca.getPrevValue()) / dValueReport));
				rowx.add(formatNumber((objNeraca.getValue()) / dValueReport));
				rowx.add(formatNumber((objNeraca.getValue() - objNeraca.getPrevValue()) / dValueReport));
				rowx.add(formatNumber(objNeraca.getPrevValue() == 0? 0 : (objNeraca.getValue() - objNeraca.getPrevValue()) / (objNeraca.getPrevValue() < 0? (objNeraca.getPrevValue() * -1) : objNeraca.getPrevValue()) * 100));
				vTempJSP.add(rowx);
				
				Vector rowR = new Vector();
				rowR.add("                "+getAccountName(objPerkiraan, language));
				rowR.add(formatNumberPDF((objNeraca.getPrevValue()) / dValueReport));
				rowR.add(formatNumberPDF((objNeraca.getValue()) / dValueReport));
				rowR.add(formatNumberPDF((objNeraca.getValue() - objNeraca.getPrevValue()) / dValueReport));
				rowR.add(formatNumberPDF(objNeraca.getPrevValue() == 0? 0 : ((objNeraca.getValue() - objNeraca.getPrevValue()) / objNeraca.getPrevValue()) * 100));
				vTempPDF.add(rowR);
				
				prevAmount += objNeraca.getPrevValue();
				currAmount += objNeraca.getValue();
				
				totPrevAmount += objNeraca.getPrevValue();
				totCurrAmount += objNeraca.getValue();
		
				vResult.add(vTempJSP);
				vResult.add(""+prevAmount);
				vResult.add(""+currAmount);
				vResult.add(vTempPDF);
				vResult.add(""+totPrevAmount);
				vResult.add(""+totCurrAmount);
				
			}catch(Exception e){
				System.out.println("Exception on getChild() :::: "+e.toString());
			}
		}
	return vResult;
}

/** dwi 2007/05/24
 * View Child Account SubTotal
 * @param object of perkiraan
 * @param int language
 * @param double previous amount
 * @param double current amount
 * @return Vector Child Account SubTotal
 */
 
private static Vector getSubTotalChild(Perkiraan objPerkiraan, int language, double prevAmount,double currAmount, double dValueReport){
	Vector vResult = new Vector(1,1);
	Vector vTempJSP = new Vector(1,1);
	Vector vTempPDF = new Vector(1,1);
		if(objPerkiraan != null){
			try{
				Vector rowx = new Vector();
				rowx.add("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Sub Total &nbsp;"+objPerkiraan.getNoPerkiraan()+"&nbsp;"+getAccountName(objPerkiraan, language));
				rowx.add(formatNumber(prevAmount / dValueReport));
				rowx.add(formatNumber(currAmount / dValueReport));
				rowx.add(formatNumber((currAmount - (prevAmount < 0? (prevAmount * -1) : prevAmount)) / dValueReport));
				rowx.add(formatNumber(prevAmount == 0? 0 :((currAmount - (prevAmount < 0? (prevAmount * -1) : prevAmount)) / prevAmount) * 100));
				vTempJSP.add(rowx);
				
				Vector rowR = new Vector();
				rowR.add("        Sub Total "+objPerkiraan.getNoPerkiraan()+" "+getAccountName(objPerkiraan, language));
				rowR.add(formatNumberPDF(prevAmount / dValueReport));
				rowR.add(formatNumberPDF(currAmount / dValueReport));
				rowR.add(formatNumberPDF((currAmount - prevAmount) / dValueReport));
				rowR.add(formatNumberPDF(prevAmount == 0? 0 :((currAmount - prevAmount) / prevAmount) * 100));
				vTempPDF.add(rowR);
				
			}catch(Exception e){
				System.out.println("Exception on getSubTotalChild() ::: "+e.toString());
			}		
		}
		
	vResult.add(vTempJSP);
	vResult.add(vTempPDF);
	return vResult;
}

/** dwi 2007/05/24
 * View Title Content Data
 * @param int index
 * @param int language
 * @return Vector Title Content Data
 */
private static Vector getTitleContent(int index, int language){
	Vector vResult = new Vector(1,1);	
	Vector vTempJSP = new Vector(1,1);
	Vector vTempPDF = new Vector(1,1);
		try{
			Vector rowx = new Vector(1,1);
			rowx.add("<b>"+strTitleContent[language][index]+"</b>");
			rowx.add("");
			rowx.add("");
			rowx.add("");
			rowx.add("");
			vTempJSP.add(rowx);
			
			Vector rowR = new Vector(1,1);
			rowR.add(strTitleContent[language][index]);
			rowR.add("");
			rowR.add("");
			rowR.add("");
			rowR.add("");
			vTempPDF.add(rowR);
			
		}catch(Exception e){
			System.out.println("Exception on getTitleContent() ::: "+e.toString());
		}
	vResult.add(vTempJSP);
	vResult.add(vTempPDF);	
	return vResult;
}

/** dwi 2007/05/24
 * View Title Content Data
 * @param int index
 * @param int language
 * @return Vector Title Content Data
 */
private static Vector getSubTitleContent(int inx, int language){
	Vector vResult = new Vector(1,1);
	Vector vTempJSP = new Vector(1,1);
	Vector vTempPDF = new Vector(1,1);	
		try{
			Vector rowx = new Vector(1,1);
			rowx.add("<b>&nbsp;&nbsp;&nbsp;&nbsp;"+strTitleContent[language][inx]+"</b>");
			rowx.add("");
			rowx.add("");
			rowx.add("");
			rowx.add("");
			vTempJSP.add(rowx);
			
			Vector rowR = new Vector(1,1);
			rowR.add("    "+strTitleContent[language][inx]);
			rowR.add("");
			rowR.add("");
			rowR.add("");
			rowR.add("");
			vTempPDF.add(rowR);
			
		}catch(Exception e){
			System.out.println("Exception on getTitleContent() ::: "+e.toString());
		}
	vResult.add(vTempJSP);	
	vResult.add(vTempPDF);
	return vResult;
}

/** dwi 2007/05/24
 * Create space
 * @return Vector Space
 */
private static Vector getSpace(){
	Vector vResult = new Vector(1,1);	
		try{
			Vector rowx = new Vector(1,1);
			rowx.add("&nbsp;");
			rowx.add("&nbsp;");
			rowx.add("&nbsp;");
			rowx.add("&nbsp;");
			rowx.add("&nbsp;");
			vResult.add(rowx);
		}catch(Exception e){
			System.out.println("Exception on getTitleContent() ::: "+e.toString());
		}
	return vResult;
}

/** dwi 2007/05/24
 * View Total Report per Group Account
 * @param int index
 * @param double previous value
 * @param double current value
 * @param int language
 * @return Vector Total per Group Account
 */
private static Vector getTotalGroup(int ind, double prevValue, double currValue, double totPrevValue, double totCurrValue, int language, double dValueReport, Vector objVector, int indexLoop){
	Vector vResult = new Vector(1,1);
	Vector vTempJSP = new Vector(1,1);
	Vector vTempPDF = new Vector(1,1);	
		try{
			Vector rowx = new Vector(1,1);
			rowx.add("<b> &nbsp;&nbsp;&nbsp;&nbsp; Total &nbsp;"+strTitleContent[language][ind]+"</b>");
			rowx.add("<b>"+formatNumber(prevValue / dValueReport)+"</b>");
			rowx.add("<b>"+formatNumber(currValue / dValueReport)+"</b>");
			rowx.add("<b>"+formatNumber((currValue - prevValue) / dValueReport)+"</b>");
			rowx.add("<b>"+formatNumber(prevValue == 0? 0 :((currValue - prevValue) / prevValue) * 100)+"</b>");
			vTempJSP.add(rowx);
			
			Vector rowR = new Vector(1,1);
			rowR.add("    Total "+strTitleContent[language][ind]);
			rowR.add(formatNumberPDF(prevValue / dValueReport));
			rowR.add(formatNumberPDF(currValue / dValueReport));
			rowR.add(formatNumberPDF((currValue - prevValue) / dValueReport));
			rowR.add(formatNumberPDF(prevValue == 0? 0 :((currValue - prevValue) / prevValue) * 100));
			vTempPDF.add(rowR);
			
			if((indexLoop != 0) && (indexLoop != (objVector.size() - 1))){
				rowR = new Vector(1,1);
				rowR.add("");
				rowR.add("");
				rowR.add("");
				rowR.add("");
				rowR.add("");
				vTempPDF.add(rowR);
			}
			
			totPrevValue += prevValue;
			totCurrValue += currValue;
			
		}catch(Exception e){
			System.out.println("Exception on getTitleContent() ::: "+e.toString());
		}
	vResult.add(vTempJSP);
	vResult.add(""+totPrevValue);
	vResult.add(""+totCurrValue);
	vResult.add(vTempPDF);	
	return vResult;
}

/** dwi 2007/05/24
 * View Total Report per Title
 * @param int index
 * @param double previous value
 * @param double current value
 * @param int language
 * @return Vector Total Report per Title
 */
private static Vector getTotal(int idx, double prevValue, double currValue, int language, double dValueReport){
	Vector vResult = new Vector(1,1);	
	Vector vTempJSP = new Vector(1,1);
	Vector vTempPDF = new Vector(1,1);	
		try{
			Vector rowx = new Vector(1,1);
			rowx.add("<b> TOTAL &nbsp;"+strTitleContent[language][idx]+"</b>");
			rowx.add("<b>"+formatNumber(prevValue / dValueReport)+"</b>");
			rowx.add("<b>"+formatNumber(currValue / dValueReport)+"</b>");
			rowx.add("<b>"+formatNumber((currValue - prevValue) / dValueReport)+"</b>");
			rowx.add("<b>"+formatNumber(prevValue == 0? 0 :((currValue - prevValue) / prevValue) * 100)+"</b>");
			vTempJSP.add(rowx);
			
			Vector rowR = new Vector(1,1);
			rowR.add("TOTAL "+strTitleContent[language][idx]);
			rowR.add(formatNumberPDF(prevValue / dValueReport));
			rowR.add(formatNumberPDF(currValue / dValueReport));
			rowR.add(formatNumberPDF((currValue - prevValue) / dValueReport));
			rowR.add(formatNumberPDF(prevValue == 0? 0 :((currValue - prevValue) / prevValue) * 100));
			vTempPDF.add(rowR);
			
		}catch(Exception e){
			System.out.println("Exception on getTitleContent() ::: "+e.toString());
		}
	vResult.add(vTempJSP);
	vResult.add(vTempPDF);	
	return vResult;
}

/** dwi 2007/05/24
 * View Detail Balance Sheet
 * @param Vector Detail Data
 * @param int language
 * @param double current value
 * @param double previous value
 * @return Vector Detail Balance Sheet
 */
private static Vector getDetailNeraca(Vector vDetail, int language, double dValue, double dPrevValue, double dValueReport){
	Vector vResult = new Vector(1,1);
	Vector temp = new Vector(1,1);
	Vector tempPDF = new Vector(1,1);
	long idPerkiraan = 0;
	long idParent = 0;
	Vector rowx = new Vector();
	String accName = "";
	String parentName = "";
	Perkiraan objPerkiraan = new Perkiraan();
	double prevAmount = 0.0;
	double currAmount = 0.0;
	double totPrevAmount = 0.0;
	double totCurrAmount = 0.0;
	long idOldParent = 0;
	Neraca objOldNeraca = new Neraca();
		try{
			for(int i = 0; i < vDetail.size(); i++){
				Neraca objNeraca = (Neraca) vDetail.get(i);
				idParent = objNeraca.getIdParent();
				if(i > 0){
					objOldNeraca = (Neraca)vDetail.get(i - 1);
					idOldParent = objOldNeraca.getIdParent();
				}
				
				idPerkiraan = objNeraca.getIdPerkiraan();
				if(idPerkiraan != 0){
					try{
						objPerkiraan = PstPerkiraan.fetchExc(idPerkiraan);
					}catch(Exception e){
						System.out.println("Exception on fetch objPerkiraan :::: "+e.toString());
					}
				}
				
				Perkiraan objParent = new Perkiraan();
				
				if(objPerkiraan.getIdParent() != 0){
					try{
						objParent = PstPerkiraan.fetchExc(objPerkiraan.getIdParent());
					}catch(Exception e){
						System.out.println("Exception on fetch objParent ::::: "+e.toString());
					}
				}
				Perkiraan objOldParent = new Perkiraan();
				if(idOldParent != 0){
					try{
						objOldParent = PstPerkiraan.fetchExc(idOldParent);
					}catch(Exception e){
						System.out.println("Exception on fetch objParent ::::: "+e.toString());
					}//Try catch
				}// End if objPerkiraan.getIdParent()
						
				if(i != 0){				
					if(idOldParent == idParent){						
						Vector listChild = (Vector)getChild(objNeraca, objPerkiraan, language, prevAmount, currAmount, totPrevAmount, totCurrAmount, dValueReport);
						if(listChild != null && listChild.size() > 0){
							prevAmount = Double.parseDouble(listChild.get(1).toString());
							currAmount = Double.parseDouble(listChild.get(2).toString());
							Vector tempChild = (Vector)listChild.get(0);
							Vector tempChildPDF = (Vector)listChild.get(3);
							totPrevAmount = Double.parseDouble(listChild.get(4).toString());
							totCurrAmount = Double.parseDouble(listChild.get(5).toString());
							
							for(int a = 0; a < tempChild.size(); a++){
								Vector rowChild = (Vector)tempChild.get(a);
								temp.add(rowChild);
							}// End loop tempChild
							
							for(int x = 0; x < tempChildPDF.size(); x++){
								Vector rowChildPdf = (Vector)tempChildPDF.get(x);
								tempPDF.add(rowChildPdf);
							}// End loop tempChildPDF
						}// End if listChild							
						
	
						if(i == (vDetail.size() - 1)){							
							Vector tempSubTotalDetail = (Vector)getSubTotalChild(objOldParent, language, prevAmount, currAmount, dValueReport);
							if(tempSubTotalDetail != null && tempSubTotalDetail.size() > 0){
								Vector subTotalDetail = (Vector)tempSubTotalDetail.get(0);
								Vector subTotalDetailPDF = (Vector)tempSubTotalDetail.get(1);
								
								for(int b = 0; b < subTotalDetail.size(); b++){
									Vector rowSubTotal = (Vector)subTotalDetail.get(b);
									temp.add(rowSubTotal);
								}//End loop subTotalDetail
								
								for(int y = 0; y < subTotalDetailPDF.size(); y++){
									Vector rowSubTotalPDF = (Vector)subTotalDetailPDF.get(y);
									tempPDF.add(rowSubTotalPDF);
								}//End loop subTotalDetailPDF
								
							}//End if(tempSubTotalDetail != null && tempSubTotalDetail.size() > 0)			
						}// End if(i == (vDetail.size() - 1))					 
					}// End if(idOldParent == idParent)
					else{						
						Vector tempSubTotalDetail = (Vector)getSubTotalChild(objOldParent, language, prevAmount, currAmount, dValueReport);
							if(tempSubTotalDetail != null && tempSubTotalDetail.size() > 0){
								Vector subTotalDetail = (Vector)tempSubTotalDetail.get(0);
								Vector subTotalDetailPDF = (Vector)tempSubTotalDetail.get(1);								
								
								for(int c = 0; c < subTotalDetail.size(); c++){
									Vector rowSubTotal = (Vector)subTotalDetail.get(c);
									temp.add(rowSubTotal);
								}//End loop subTotalDetail
								
								for(int z = 0; z < subTotalDetailPDF.size(); z++){
									Vector rowSubTotalPDF = (Vector)subTotalDetailPDF.get(z);
									tempPDF.add(rowSubTotalPDF);
								}// End loop subTotalDetailPDF
							}// End if(tempSubTotalDetail != null && tempSubTotalDetail.size() > 0)
						
						Vector spaceDet = (Vector)getSpace();
							if(spaceDet != null && spaceDet.size() > 0){
								for(int t = 0; t < spaceDet.size(); t++){
									Vector rowSpc = (Vector)spaceDet.get(t);
									temp.add(rowSpc);
								}//End loop spaceDet
							}//End if(spaceDet != null && spaceDet.size() > 0)					
							
						Perkiraan objNextParent = new Perkiraan();
						if(objPerkiraan.getIdParent() != 0){
							try{
								objNextParent = PstPerkiraan.fetchExc(idParent);
							}catch(Exception e){
								System.out.println("Exception on fetch objParent ::::: "+e.toString());
							}//End try catch
						}// End if(objPerkiraan.getIdParent() != 0)
						
						Vector vTempDataParent = (Vector)getParent(objNextParent, language);
						if(vTempDataParent != null && vTempDataParent.size() > 0){
							Vector vDataParent = (Vector)vTempDataParent.get(0);
							Vector vDataParentPDF = (Vector)vTempDataParent.get(1);
							for(int d = 0; d < vDataParent.size(); d++){
								Vector rowParent = (Vector)vDataParent.get(d);
								temp.add(rowParent);
							}// End loop vDataParent
							
							for(int aa = 0; aa < vDataParentPDF.size(); aa++){
								Vector rowParentPDF = (Vector)vDataParentPDF.get(aa);
								tempPDF.add(rowParentPDF);
							}// End loop vDataParentPDF
						}// End if(vTempDataParent != null && vTempDataParent.size() > 0)
						
						if(objPerkiraan.getIdParent() == idParent){
							prevAmount = 0.0;
							currAmount = 0.0;
							
							Vector listChild = (Vector)getChild(objNeraca, objPerkiraan, language, prevAmount, currAmount, totPrevAmount, totCurrAmount, dValueReport);
							if(listChild != null && listChild.size() > 0){
								prevAmount = Double.parseDouble(listChild.get(1).toString());
								currAmount = Double.parseDouble(listChild.get(2).toString());
								Vector tempChild = (Vector)listChild.get(0);
								Vector tempChildPDF = (Vector)listChild.get(3);
								totPrevAmount = Double.parseDouble(listChild.get(4).toString());
								totCurrAmount = Double.parseDouble(listChild.get(5).toString());
								
								for(int a = 0; a < tempChild.size(); a++){
									Vector rowChild = (Vector)tempChild.get(a);
									temp.add(rowChild);
								}// End loop tempChild
								
								for(int x = 0; x < tempChildPDF.size(); x++){
									Vector rowChildPdf = (Vector)tempChildPDF.get(x);
									tempPDF.add(rowChildPdf);
								}// End loop tempChildPDF
							}// End if listChild
						}// End if(objPerkiraan.getIdParent() == idParent)														
					}// End else if(idOldParent == idParent)
				}// End if(i != 0)
				else{
						
						Vector vTempDataParent = (Vector)getParent(objParent, language);
						if(vTempDataParent != null && vTempDataParent.size() > 0){
							Vector vDataParent = (Vector)vTempDataParent.get(0);
							Vector vDataParentPDF = (Vector)vTempDataParent.get(1);
							for(int e = 0; e < vDataParent.size(); e++){
								Vector rowParent = (Vector)vDataParent.get(e);
								temp.add(rowParent);
							}
							
							for(int ab = 0; ab < vDataParentPDF.size(); ab++){
								Vector rowParentPDF = (Vector)vDataParentPDF.get(ab);
								tempPDF.add(rowParentPDF);
							}
						}
						
						Vector tempListChild = (Vector)getChild(objNeraca, objPerkiraan, language, prevAmount, currAmount, totPrevAmount, totCurrAmount, dValueReport);
						if(tempListChild != null && tempListChild.size() > 0){
							prevAmount = Double.parseDouble(tempListChild.get(1).toString());
							currAmount = Double.parseDouble(tempListChild.get(2).toString());
							Vector tempChild = (Vector)tempListChild.get(0);
							Vector tempChildPDF = (Vector)tempListChild.get(3);
							totPrevAmount = Double.parseDouble(tempListChild.get(4).toString());
							totCurrAmount = Double.parseDouble(tempListChild.get(5).toString());
							
							for(int f = 0; f < tempChild.size(); f++){
								Vector rowChild = (Vector)tempChild.get(f);
								temp.add(rowChild);
							}
							
							for(int ac = 0; ac < tempChildPDF.size(); ac++){
								Vector rowChildPDF = (Vector)tempChildPDF.get(ac);
								tempPDF.add(rowChildPDF);
							}
						}
						
						if(vDetail.size() == 1){
							Vector tempSubTotalDetail = (Vector)getSubTotalChild(objOldParent, language, prevAmount, currAmount, dValueReport);
							if(tempSubTotalDetail != null && tempSubTotalDetail.size() > 0){
								Vector subTotalDetail = (Vector)tempSubTotalDetail.get(0);
								Vector subTotalDetailPDF = (Vector)tempSubTotalDetail.get(1);
								
								for(int g = 0; g < subTotalDetail.size(); g++){
									Vector rowSubTotal = (Vector)subTotalDetail.get(g);
									temp.add(rowSubTotal);
								}
								
								for(int ad = 0; ad < subTotalDetailPDF.size(); ad++){
									Vector rowSubTotalPDF = (Vector)subTotalDetailPDF.get(ad);
									tempPDF.add(rowSubTotalPDF);
								}
							}
						}
				}
			}
			
			dValue += totCurrAmount;
			dPrevValue += totPrevAmount;
			
			vResult.add(temp);
			vResult.add(""+dPrevValue);
			vResult.add(""+dValue);
			vResult.add(tempPDF);
			
		}catch(Exception e){
			System.out.println("Exception on getDetailNeraca() :::: "+e.toString());
		}
	return vResult;
}	 

/** dwi 2007/05/24
 * View Balance Sheet
 * @param Vector Data
 * @param int language
 * @param String previus year
 * @param String current year
 * @return Vector Balance Sheet
 */
private Vector drawBalanceSheet(Vector vData, int language, String strPrevYear, String strCurrYear, double dValueReport){
	Vector vResult = new Vector(1,1);
	Vector vTempRowPDFAsset = new Vector(1,1);
	Vector vTempTitlePDFAsset = new Vector(1,1);
	Vector vTempSubTotalPDFAsset = new Vector(1,1);
	Vector vTempDetailPDFAsset = new Vector(1,1);
	Vector vTempDataPDFLE = new Vector(1,1);
	Vector vTempTitlePDFLE = new Vector(1,1);
	Vector vTempSubTotalPDFLE = new Vector(1,1);
	Vector vTempDetailPDFLE = new Vector(1,1);
	Vector vDataPDF = new Vector(1,1);
	
	ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("100%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
    ctrlist.setHeaderStyle("listgentitle");
    ctrlist.addHeader(strHeader[language][0],"40%","2","0");
    ctrlist.addHeader(strHeader[language][1]+"&nbsp;"+strPrevYear,"20%","2","0");
    ctrlist.addHeader(strHeader[language][1]+"&nbsp;"+strCurrYear,"20%","2","0");
    ctrlist.addHeader(strHeader[language][2],"6%","0","2");
	if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN){
		ctrlist.addHeader(strHeader[language][5]+" "+strHeader[language][3]+" "+NumberSpeller.specialSpeller(dValueReport,language),"15%","0","0");
	}else{
		ctrlist.addHeader(strHeader[language][5]+" "+NumberSpeller.specialSpeller(dValueReport,language)+" "+strHeader[language][3],"15%","0","0");
	}
	ctrlist.addHeader(strHeader[language][4],"5%","0","0");

    ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);
	Vector rowR = new Vector(1,1);
	int iExistingData = 0; 
	double totPrevValue = 0.0;
	double totCurrValue = 0.0;
	double grTotPrevValue = 0.0;
	double grTotCurrValue = 0.0;
	double grTotAssetPrev = 0.0;
	double grTotAssetCurr = 0.0;
	double grTotLEPrev = 0.0;
	double grTotLECurr = 0.0;
	
		if(vData != null && vData.size() > 0){
			try{
				//----------------------------------- Proses Assets -----------------------------------------
				Vector vTempTitleAsset = (Vector)getTitleContent(0,language);
				if(vTempTitleAsset != null && vTempTitleAsset.size() > 0){
						Vector vTitleAsset = (Vector)vTempTitleAsset.get(0);
						Vector vTitleAssetPDF = (Vector)vTempTitleAsset.get(1);
						for(int i=0; i < vTitleAsset.size(); i++){
							rowx = (Vector)vTitleAsset.get(i);
							lstData.add(rowx);
						}
						
						for(int ae=0; ae < vTitleAssetPDF.size(); ae++){
							rowR = (Vector)vTitleAssetPDF.get(ae);
							vDataPDF.add(rowR);// Index 0
						}
					}
						
				for(int g = 0; g < 3; g++){
					Vector vecAssets = (Vector) vData.get(g);
					if(vecAssets != null && vecAssets.size() > 0){			
								Vector vTempSubTitleAssets = (Vector)getSubTitleContent(g+1,language);
									if(vTempSubTitleAssets != null && vTempSubTitleAssets.size() > 0){
										Vector vSubTitleAssets = (Vector)vTempSubTitleAssets.get(0);
										Vector vSubTitleAssetsPDF = (Vector)vTempSubTitleAssets.get(1);
										for(int h=0; h < vSubTitleAssets.size(); h++){
											rowx = (Vector)vSubTitleAssets.get(h);
											lstData.add(rowx);
										}
										
										for(int af=0; af < vSubTitleAssetsPDF.size(); af++){
											rowR = (Vector)vSubTitleAssetsPDF.get(af);
											vTempRowPDFAsset.add(rowR);
										}
										
									}
															
						Vector tempAssets = (Vector)getDetailNeraca(vecAssets,language,totCurrValue,totPrevValue,dValueReport);
						if(tempAssets != null && tempAssets.size() > 0){
							totPrevValue = Double.parseDouble(tempAssets.get(1).toString());
							totCurrValue = Double.parseDouble(tempAssets.get(2).toString());
							Vector rowAssets = (Vector)tempAssets.get(0);
							Vector rowAssetsPDF = (Vector)tempAssets.get(3);
							
							if(rowAssets != null && rowAssets.size() > 0){
								try{
									
									for(int j = 0; j < rowAssets.size(); j++){
										rowx = (Vector)rowAssets.get(j);
										lstData.add(rowx);
									}
									
									for(int ag = 0; ag < rowAssetsPDF.size(); ag++){
										rowR = (Vector)rowAssetsPDF.get(ag);
										vTempRowPDFAsset.add(rowR);
									}
									
								double prevTempAssets = totPrevValue - grTotPrevValue;
								double currTempAssets = totCurrValue - grTotCurrValue;
								 Vector vTempSubTotalAsset = (Vector)getTotalGroup(g+1, prevTempAssets, currTempAssets, grTotPrevValue,grTotCurrValue,language,dValueReport,vData,g);
								 if(vTempSubTotalAsset != null && vTempSubTotalAsset.size() > 0){
								 		grTotPrevValue = Double.parseDouble(vTempSubTotalAsset.get(1).toString());
										grTotCurrValue = Double.parseDouble(vTempSubTotalAsset.get(2).toString());
										Vector rowSubTotalAssets = (Vector)vTempSubTotalAsset.get(0);
										Vector rowSubTotalAssetsPDF = (Vector)vTempSubTotalAsset.get(3);
										if(rowSubTotalAssets != null && rowSubTotalAssets.size() > 0){
											for(int q = 0; q < rowSubTotalAssets.size(); q++){
												rowx = (Vector)rowSubTotalAssets.get(q);
												lstData.add(rowx);
											}
										}
										
										if(rowSubTotalAssetsPDF != null && rowSubTotalAssetsPDF.size() > 0){
											for(int ah = 0; ah < rowSubTotalAssetsPDF.size(); ah++){
												rowR = (Vector)rowSubTotalAssetsPDF.get(ah);
												vTempRowPDFAsset.add(rowR);
											}
										}
								 }
								 
								 vTempDetailPDFAsset.add(vTempRowPDFAsset);
								if(g > 0){
										Vector spcDetail = (Vector)getSpace();
										if(spcDetail != null && spcDetail.size() > 0){
											for(int u = 0; u < spcDetail.size(); u++){
												Vector rSpace = (Vector)spcDetail.get(u);
												lstData.add(rSpace);
											}
										}
									}				
								}catch(Exception e){
									System.out.println("Exception on loop rowAssets :::: "+e.toString());
								}
							}
						}
					}
				} // ------------- End Proses Assets ----------------------------------------------
				
				vDataPDF.add(vTempDetailPDFAsset);// index 1
				
				// ---------------------------- Proses Total Assets --------------------------------
				Vector tempTotAssets = (Vector)getTotal(0,grTotPrevValue,grTotCurrValue,language,dValueReport);
				if(tempTotAssets != null && tempTotAssets.size() > 0){
					Vector totAssets = (Vector)tempTotAssets.get(0);
					Vector totAssetsPDF = (Vector)tempTotAssets.get(1);
					for(int k = 0; k < totAssets.size(); k++){
						rowx = (Vector)totAssets.get(k);
						lstData.add(rowx);
					}
					
					for(int ai = 0; ai < totAssetsPDF.size(); ai++){
						rowR = (Vector)totAssetsPDF.get(ai);
						vDataPDF.add(rowR); // index 2
					}
				}
				
				Vector spcDet = (Vector)getSpace();
				if(spcDet != null && spcDet.size() > 0){
					for(int v = 0; v < spcDet.size(); v++){
						Vector rwSpace = (Vector)spcDet.get(v);
						lstData.add(rwSpace);
					}
				}
								
				grTotAssetPrev = grTotPrevValue;
				grTotAssetCurr = grTotCurrValue;
							
				grTotPrevValue = 0;
				grTotCurrValue = 0;
				totPrevValue = 0;
				totCurrValue = 0;
				
				// ------------------------------- Proses Liabilities and Equity -----------------------------
				Vector vTempTitleLE = (Vector)getTitleContent(7,language);
				if(vTempTitleLE != null && vTempTitleLE.size() > 0){
					Vector vTitleLE = (Vector)vTempTitleLE.get(0);
					Vector vTitleLEPDF = (Vector)vTempTitleLE.get(1);
						for(int l=0; l < vTitleLE.size(); l++){
							rowx = (Vector)vTitleLE.get(l);
							lstData.add(rowx);
						}
						
						for(int aj=0; aj < vTitleLEPDF.size(); aj++){
							rowR = (Vector)vTitleLEPDF.get(aj);
							vDataPDF.add(rowR);//Index 3
						}
					}	
				
				for(int m = 3; m < vData.size(); m++){
										
					Vector vecLE = (Vector) vData.get(m);
					if(vecLE != null && vecLE.size() > 0){			
								Vector vTempSubTitleLE = (Vector)getSubTitleContent(m+1,language);
									if(vTempSubTitleLE != null && vTempSubTitleLE.size() > 0){
										Vector vSubTitleLE = (Vector)vTempSubTitleLE.get(0);
										Vector vSubTitleLEPDF = (Vector)vTempSubTitleLE.get(1);
										try{
											for(int n=0; n < vSubTitleLE.size(); n++){
												rowx = (Vector)vSubTitleLE.get(n);
												lstData.add(rowx);
											}
										}catch(Exception e){
											System.out.println("Exception on loop vSubTitleLE ::: "+e.toString());
										}
										
										try{
											for(int ak=0; ak < vSubTitleLEPDF.size(); ak++){
												rowR = (Vector)vSubTitleLEPDF.get(ak);
												vTempDataPDFLE.add(rowR);
											}
											//vTempDetailPDFLE.add(vTempTitlePDFLE);
										}catch(Exception e){
											System.out.println("Exception on loop vSubTitleLEPDF ::: "+e.toString());
										}
										
									}	
						
							
						Vector tempLE = (Vector)getDetailNeraca(vecLE,language,totCurrValue,totPrevValue,dValueReport);
						
						if(tempLE != null && tempLE.size() > 0){
							totPrevValue = Double.parseDouble(tempLE.get(1).toString());
							totCurrValue = Double.parseDouble(tempLE.get(2).toString());
							Vector rowLE = (Vector)tempLE.get(0);
							Vector rowLEPDF = (Vector)tempLE.get(3);
							
							if(rowLE != null && rowLE.size() > 0){
								try{
									try{
										for(int p = 0; p < rowLE.size(); p++){
											rowx = (Vector)rowLE.get(p);
											lstData.add(rowx);
										}
									}catch(Exception e){
										System.out.println("Exception on loop rowLE :::: "+e.toString());
									}
									
									try{
										for(int al = 0; al < rowLEPDF.size(); al++){
											rowR = (Vector)rowLEPDF.get(al);
											vTempDataPDFLE.add(rowR);
										}
										
									}catch(Exception e){
										System.out.println("Exception on loop rowLEPDF ::: "+e.toString());
									}
									
									
									
									double prevTempLE = totPrevValue - grTotPrevValue;
									double currTempLE = totCurrValue - grTotCurrValue;
									 Vector vTempSubTotalLE = (Vector)getTotalGroup(m+1, prevTempLE, currTempLE, grTotPrevValue,grTotCurrValue, language,dValueReport,vData,m);
								 	if(vTempSubTotalLE != null && vTempSubTotalLE.size() > 0){
								 		grTotPrevValue = Double.parseDouble(vTempSubTotalLE.get(1).toString());
										grTotCurrValue = Double.parseDouble(vTempSubTotalLE.get(2).toString());
										Vector rowSubTotalLE = (Vector)vTempSubTotalLE.get(0);
										Vector rowSubTotalLEPDF = (Vector)vTempSubTotalLE.get(3);
										if(rowSubTotalLE != null && rowSubTotalLE.size() > 0){
											try{
												for(int r = 0; r < rowSubTotalLE.size(); r++){
													rowx = (Vector)rowSubTotalLE.get(r);
													lstData.add(rowx);
												}
											}catch(Exception e){
												System.out.println("Exception on loop rowSubTotalLE :::: "+e.toString());
											}
										}
										
										if(rowSubTotalLEPDF != null && rowSubTotalLEPDF.size() > 0){
											try{
												for(int am = 0; am < rowSubTotalLEPDF.size(); am++){
													rowR = (Vector)rowSubTotalLEPDF.get(am);
													vTempDataPDFLE.add(rowR);
												}
												//vTempDetailPDFLE.add(vTempSubTotalPDFLE);	
											}catch(Exception e){
												System.out.println("Exception on loop rowSubTotalLEPDF ::: "+e.toString());
											}
											
										}
								 }
								 vTempDetailPDFLE.add(vTempDataPDFLE);
								 if(m < (vData.size() - 1)){
									 Vector vSpace = (Vector)getSpace();
										if(vSpace != null && vSpace.size() > 0){
											for(int w = 0; w < vSpace.size(); w++){
												Vector rSpace = (Vector)vSpace.get(w);
												lstData.add(rSpace);
											}
										}
									}				
								}catch(Exception e){
									//System.out.println("Exception on loop Liabilities and Equity :::: "+e.toString());
								}
							}
						}
					}
						
				} // ------------- End Proses Liabilities and Equity ----------------------------------------------
				
				vDataPDF.add(vTempDetailPDFLE);//Index 4
				
				// ---------------------------- Proses Liabilities and Equity --------------------------------
				Vector temTotLE = (Vector)getTotal(7,totPrevValue,totCurrValue,language,dValueReport);
					if(temTotLE != null && temTotLE.size() > 0){
						Vector totLE = (Vector)temTotLE.get(0);
						Vector totLEPDF = (Vector)temTotLE.get(1);
						for(int k = 0; k < totLE.size(); k++){
							rowx = (Vector)totLE.get(k);
							lstData.add(rowx);
						}
						
						for(int an = 0; an < totLEPDF.size(); an++){
							rowR = (Vector)totLEPDF.get(an);
							vDataPDF.add(rowR);//Index 5
						}
					}
				
				if(totCurrValue != 0 || totPrevValue != 0)	
					iExistingData = 1; 
			FLAG_PRINT = 1; 
			}catch(Exception e){
				System.out.println("Exception on drawBalanceSheet() ::: "+e.toString());
			}
		}
	vResult.add(ctrlist.drawList());
	vResult.add(vDataPDF);
	vResult.add(""+iExistingData);
	return vResult;
}

%>

<!-- JSP Block -->
<%

    int iCommand = FRMQueryString.requestCommand(request);
    long periodId = FRMQueryString.requestLong(request,SessWorkSheet.FRM_NAMA_PERIODE);
    long oidDepartment = FRMQueryString.requestLong(request,"DEPARTMENT");
    String strCmbOption[] = {"- Silahkan pilih -", "- Please select -"};
    String strCmbFirstSelection = strCmbOption[SESS_LANGUAGE];
    Date today = new Date();
	String strBack = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Back To Search" : "Kembali ke Pencarian";
	String strPrint = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Print Report" : "Cetak Laporan";
	String strExpToExcel = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Export to Excel" : "Ekspor ke Excel";
	String linkPdf = reportrootfooter+"report.neraca.BalanceSheetDeptPdf printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String linkXls = reportrootfooter+"report.neraca.BalanceSheetDeptXls printed on "+Formater.formatDate(today,"EEEE, dd MMMM yyyy, hh:mm a");
	String strPathImage = reportrootimage+"company121.jpg";
	String nameperiode = "";
	String prevPeriodeName = "";
    String namedepartment = ""; 
	
	FRMHandler frmHandler = new FRMHandler();
	frmHandler.setDecimalSeparator(sUserDecimalSymbol); 
	frmHandler.setDigitSeparator(sUserDigitGroup);
	
    Vector list = new Vector();
	String currYear = "";
	String prevYear = "";
    if(iCommand==Command.LIST)
        list = SessNeraca.getListNeraca(periodId,oidDepartment);
		
	try{
            Periode period = PstPeriode.fetchExc(periodId);
			long preOidPeriod = SessWorkSheet.getOidPeriodeLalu(periodId);	
			Date prevDate = (Date)period.getTglAwal();		
			if(prevDate.getMonth() == 0){
				prevDate.setMonth(11);
				prevDate.setYear(prevDate.getYear() - 1);
				prevPeriodeName = Formater.formatShortMonthyYear(prevDate);
			}else{
				prevDate.setMonth(prevDate.getMonth() - 1);
				prevPeriodeName = Formater.formatShortMonthyYear(prevDate);
			}
			Date currDate = (Date)period.getTglAkhir();
			nameperiode = Formater.formatShortMonthyYear(currDate);	
			namedepartment = "";//PstDepartment.fetchExc(oidDepartment).getDepartment();
			
    }catch(Exception e){
		System.out.println("Exception on fetch periode ::::: "+e.toString());
	}
	
	
	// process data on control drawlist
	//Vector vectResult = drawListNeraca(list, SESS_LANGUAGE, frmHandler);
	String sExistData = "";
	int iExistData = 0;
	String listData = "";
	Vector vectResult = new Vector(1,1);
	Vector vectDataToReport = new Vector(1,1);
	try{
		vectResult = (Vector)drawBalanceSheet(list, SESS_LANGUAGE,prevPeriodeName,nameperiode,dValueReport);
		if(vectResult != null && vectResult.size() > 0){	
			listData = String.valueOf(vectResult.get(0));     
			vectDataToReport = (Vector)vectResult.get(1);
			sExistData = vectResult.get(2).toString();
			iExistData = Integer.parseInt(sExistData);
		}
	}catch(Exception e){
		System.out.println("Exception on get data balance sheet ::::: "+e.toString());
	}
	
	Vector vecHeader = new Vector(1,1);
	for(int i = 0; i < strHeader[SESS_LANGUAGE].length; i++){
		vecHeader.add(strHeader[SESS_LANGUAGE][i]);
	}
	
	Vector vecTitle = new Vector(1,1);
	for(int t = 0; t < strTitleReporPDF[SESS_LANGUAGE].length; t++){
		vecTitle.add(strTitleReporPDF[SESS_LANGUAGE][t]);
	}
	
	Vector vecSess = new Vector();
	vecSess.add(nameperiode);
	vecSess.add(namedepartment);
	vecSess.add(linkPdf);
	vecSess.add(linkXls);
	vecSess.add(vectDataToReport);
	vecSess.add(vecHeader);
	vecSess.add(vecTitle);
	vecSess.add(strPathImage);
	vecSess.add(nameperiode);
	vecSess.add(prevPeriodeName);
	
	if(session.getValue("BALANCE_SHEET")!=null){   
		session.removeValue("BALANCE_SHEET");
	}
	session.putValue("BALANCE_SHEET",vecSess);

/**
* Declare Commands caption
*/
String strReport = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Preview Report" : "Tampilkan Laporan";
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="javascript">
function report(){
    //var val = document.frmTrialBalance.DEPARTMENT.value;
    //if(val!=0){
        document.frmTrialBalance.command.value ="<%=Command.LIST%>";
        document.frmTrialBalance.action = "balance_sheet_dept.jsp";
        document.frmTrialBalance.submit();
    /*}else{
        alert('<%=strTitle[SESS_LANGUAGE][10]%>');*/
        document.frmTrialBalance.DEPARTMENT.focus();
   // }
}

function cmdBack(){
	document.frmTrialBalance.command.value ="<%=Command.BACK%>";
	document.frmTrialBalance.action = "balance_sheet_dept.jsp#up";
    document.frmTrialBalance.submit();
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<SCRIPT language=JavaScript>

function hideObjectForMenuJournal(){
	}

function hideObjectForMenuReport(){
	}

function hideObjectForMenuPeriod(){
	}

function hideObjectForMenuMasterData(){
	}

function hideObjectForMenuSystem(){
	}

//*****************
function showObjectForMenu(){

}

function reportPdf(){	 
		var linkPage = "<%=reportroot%>report.neraca.BalanceSheetPdf";       
		window.open(linkPage);  				
}

function printXLS(){	 
		var linkPage = "<%=reportroot%>report.neraca.BalanceSheetXls";       
		window.open(linkPage);  				
}

</SCRIPT>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
<link rel="StyleSheet" href="../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
            <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmTrialBalance" method="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
                  <td colspan="2">&nbsp;
                  </td>
                </tr>
              </table>
			  <%if(privView && privSubmit){%>
              <table width="100%" border="0" height="94">
                <tr>
                  <td width="11%" height="23" id="up"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td height="23" width="1%">
                    <div align="center">:</div></td>
                  <td height="23" width="88%">
                    <%
					  String sOrderBy = PstPeriode.fieldNames[PstPeriode.FLD_TGLAWAL]+" DESC";
                      Vector vtPeriod = PstPeriode.list(0,0,"",sOrderBy);
                      Vector vPeriodKey = new Vector(1,1);
                      Vector vPeriodVal = new Vector(1,1);
                      for(int k=0;k<vtPeriod.size();k++){
                        Periode periode = (Periode)vtPeriod.get(k);

                        vPeriodKey.add(""+periode.getOID());
                        vPeriodVal.add(periode.getNama());
                      }
                      out.println(ControlCombo.draw(SessWorkSheet.FRM_NAMA_PERIODE,"",null,""+periodId,vPeriodKey,vPeriodVal,""));
				  %>
                  </td>
                </tr>
                <tr>
                  <td width="11%" height="23"><%//=strTitle[SESS_LANGUAGE][9]%></td>
                  <td height="23" width="1%">
                    <!-- <div align="center">:</div></td> -->
                  <td height="23" width="88%"><%
                  /*Vector vectDept = new Vector();
                  Vector vUsrCustomDepartment = PstDataCustom.getDataCustom(userOID, "hrdepartment");
                  if(vUsrCustomDepartment!=null && vUsrCustomDepartment.size()>0){
                  int iDataCustomCount = vUsrCustomDepartment.size();
                    for(int i=0; i<iDataCustomCount; i++){
                        DataCustom objDataCustom = (DataCustom) vUsrCustomDepartment.get(i);
                        Department dept = new Department();
                        try{
                            dept = PstDepartment.fetchExc(Long.parseLong(objDataCustom.getDataValue()));
                        }catch(Exception e){
                            System.out.println("Err >> department : "+e.toString());
                        }
                        vectDept.add(dept);
                    }
                  }

                  Vector vectDeptKey = new Vector();
                  Vector vectDeptName = new Vector();
                  vectDeptKey.add("0");
                  vectDeptName.add(strCmbFirstSelection);
                  int iDeptSize = vectDept.size();
                  for (int deptNum = 0; deptNum < iDeptSize; deptNum++){
                      Department dept = (Department) vectDept.get(deptNum);
                      vectDeptKey.add(String.valueOf(dept.getOID()));
                      vectDeptName.add(dept.getDepartment());
                  }
                  String strSelectedDept = String.valueOf(oidDepartment);*/
                %>
                      <%//=ControlCombo.draw("DEPARTMENT", "", null, strSelectedDept, vectDeptKey, vectDeptName)%> </td>
                </tr>
                <tr>
                  <td height="23">&nbsp;</td>
                  <td height="23">&nbsp;</td>
                  <td height="23">&nbsp;</td>
                </tr>
                <tr>
                  <td width="11%" height="23">&nbsp;</td>
                  <td height="23" width="1%">
                    <div align="center"><b></b></div></td>
                  <td height="23" width="88%"><input name="btnViewReport" type="button" onClick="javascript:report()" value="<%=strReport%>"></td>
                </tr>
				<tr><td colspan="3" height="2">&nbsp;</td></tr>
				<%if(iCommand==Command.LIST && iExistData > 0){%>

                <tr>
                  <td colspan="3" height="2"><b>&nbsp;&nbsp;<%=masterTitle[SESS_LANGUAGE]%> : <%=SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? strTitleReporPDF[SESS_LANGUAGE][3]+" "+strTitleReporPDF[SESS_LANGUAGE][2]+" "+NumberSpeller.specialSpeller(dValueReport,SESS_LANGUAGE) : strTitleReporPDF[SESS_LANGUAGE][3]+" "+NumberSpeller.specialSpeller(dValueReport,SESS_LANGUAGE)+" "+strTitleReporPDF[SESS_LANGUAGE][2]%></b></td>
                </tr>
                <tr>
                  <td colspan="3" height="2"><%=listData%></td>
                </tr>
                <tr>
                  <td colspan="3" height="2"><table width="100%" border="0" cellspacing="1" cellpadding="1">
                    <tr>
                      <td width="13%" nowrap><input name="btnPrint" type="button" onClick="javascript:reportPdf()" value="<%=strPrint%>"></td>
                      <td width="17%" nowrap><input name="btnExport" type="button" onClick="javascript:printXLS()" value="<%=strExpToExcel%>"></td>
                      <td width="70%" nowrap><input name="btnBack" type="button" onClick="javascript:cmdBack()" value="<%=strBack%>"></td>
                    </tr>
                  </table> </td>
                  <td height="2">&nbsp;</td>
                </tr>
                <%if(FLAG_PRINT == 1){%>
                <tr>
                  <td>&nbsp;</td>
                </tr>
                <%}%>                
              </table>
			   <%}else{%>
			   	<%if(iCommand == Command.LIST){%>
			   	<table width="100%">
					<tr><td class="msgerror"><%=strTitle[SESS_LANGUAGE][8]%></td></tr>
				</table>
				<%}%>
			   <%}%>
              <%}else{%>
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr>
                  <td colspan="2"><font color="#FF0000"><i><%=strTitle[SESS_LANGUAGE][2]%></i></font></td>
                </tr>
              </table>
			  <%}%>
            </form>
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td height="100%"> 
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" height="20" class="footer"> 
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>
