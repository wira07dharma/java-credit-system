/*
 * Form Name  	:  FrmMemberReg.java
 * Created on 	:  [date] [time] AM/PM
 *
 * @author  	:  [authorName]
 * @version  	:  [version]
 */

/*******************************************************************
 * Class Description 	: [project description ... ]
 * Imput Parameters 	: [input parameter ...]
 * Output 		: [output ...]
 *******************************************************************/

package com.dimata.posbo.form.masterdata;

/* java package */

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
/* qdep package */
import com.dimata.qdep.form.*;
/* project package */
import com.dimata.posbo.entity.masterdata.*;

public class FrmMemberReg extends FRMHandler implements I_FRMInterface, I_FRMType {
    private MemberReg memberReg;
    private HttpServletRequest req;

    public static final String FRM_NAME_MEMBERREG = "FRM_NAME_MEMBERREG";

    public static final int FRM_FIELD_CONTACT_ID = 0;
    public static final int FRM_FIELD_CONTACT_CODE = 1;
    public static final int FRM_FIELD_REGDATE = 2;
    public static final int FRM_FIELD_EMPLOYEE_ID = 3;
    public static final int FRM_FIELD_COMP_NAME = 4;
    public static final int FRM_FIELD_PERSON_NAME = 5;
    public static final int FRM_FIELD_PERSON_LASTNAME = 6;
    public static final int FRM_FIELD_BUSS_ADDRESS = 7;
    public static final int FRM_FIELD_TOWN = 8;
    public static final int FRM_FIELD_PROVINCE = 9;
    public static final int FRM_FIELD_COUNTRY = 10;
    public static final int FRM_FIELD_TELP_NR = 11;
    public static final int FRM_FIELD_TELP_MOBILE = 12;
    public static final int FRM_FIELD_FAX = 13;
    public static final int FRM_FIELD_HOME_ADDR = 14;
    public static final int FRM_FIELD_HOME_TOWN = 15;
    public static final int FRM_FIELD_HOME_PROVINCE = 16;
    public static final int FRM_FIELD_HOME_COUNTRY = 17;
    public static final int FRM_FIELD_HOME_TELP = 18;
    public static final int FRM_FIELD_HOME_FAX = 19;
    public static final int FRM_FIELD_NOTES = 20;
    public static final int FRM_FIELD_DIRECTIONS = 21;
    public static final int FRM_FIELD_BANK_ACC = 22;
    public static final int FRM_FIELD_BANK_ACC2 = 23;
    public static final int FRM_FIELD_CONTACT_TYPE = 24;
    public static final int FRM_FIELD_EMAIL = 25;
    public static final int FRM_FIELD_PARENT_ID = 26;
    public static final int FRM_FIELD_MEMBER_GROUP_ID = 27;
    public static final int FRM_FIELD_MEMBER_BARCODE = 28;
    public static final int FRM_FIELD_MEMBER_ID_CARD_NUMBER = 29;
    public static final int FRM_FIELD_MEMBER_SEX = 30;
    public static final int FRM_FIELD_MEMBER_BIRTH_DATE = 31;
    public static final int FRM_FIELD_MEMBER_COUNTER = 32;
    public static final int FRM_FIELD_MEMBER_RELIGION_ID = 33;
    public static final int FRM_FIELD_MEMBER_STATUS = 34;
    public static final int FRM_FIELD_MEMBER_LAST_UPDATE = 35;

    public static String[] fieldNames = {
        "FRM_FIELD_CONTACT_ID", "FRM_FIELD_CONTACT_CODE", //
        "FRM_FIELD_REGDATE", "FRM_FIELD_EMPLOYEE_ID",
        "FRM_FIELD_COMP_NAME", "FRM_FIELD_PERSON_NAME",
        "FRM_FIELD_PERSON_LASTNAME", "FRM_FIELD_BUSS_ADDRESS",
        "FRM_FIELD_TOWN", "FRM_FIELD_PROVINCE",
        "FRM_FIELD_COUNTRY", "FRM_FIELD_TELP_NR",
        "FRM_FIELD_TELP_MOBILE", "FRM_FIELD_FAX", //7
        "FRM_FIELD_HOME_ADDR", "FRM_FIELD_HOME_TOWN",
        "FRM_FIELD_HOME_PROVINCE", "FRM_FIELD_HOME_COUNTRY",
        "FRM_FIELD_HOME_TELP", "FRM_FIELD_HOME_FAX",
        "FRM_FIELD_NOTES", "FRM_FIELD_DIRECTIONS",
        "FRM_FIELD_BANK_ACC", "FRM_FIELD_BANK_ACC2",
        "FRM_FIELD_CONTACT_TYPE", "FRM_FIELD_EMAIL",
        "FRM_FIELD_PARENT_ID", "FRM_FIELD_MEMBER_GROUP_ID",
        "FRM_FIELD_MEMBER_BARCODE", "FRM_FIELD_MEMBER_ID_CARD_NUMBER",
        "FRM_FIELD_MEMBER_SEX", "FRM_FIELD_MEMBER_BIRTH_DATE",
        "FRM_FIELD_MEMBER_COUNTER", "FRM_FIELD_MEMBER_RELIGION_ID",
        "FRM_FIELD_MEMBER_STATUS", "FRM_FIELD_MEMBER_LAST_UPDATE"
    };

    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_STRING,
        TYPE_DATE, TYPE_LONG,
        TYPE_STRING, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING, //7
        TYPE_STRING + ENTRY_REQUIRED, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_INT, TYPE_STRING,
        TYPE_LONG, TYPE_LONG,
        TYPE_STRING, TYPE_STRING,
        TYPE_INT, TYPE_DATE,
        TYPE_INT, TYPE_LONG,
        TYPE_INT, TYPE_DATE
    };

    public FrmMemberReg() {
    }

    public FrmMemberReg(MemberReg memberReg) {
        this.memberReg = memberReg;
    }

    public FrmMemberReg(HttpServletRequest request, MemberReg memberReg) {
        super(new FrmMemberReg(memberReg), request);
        this.memberReg = memberReg;
        this.req = request;
    }

    public String getFormName() {
        return FRM_NAME_MEMBERREG;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public MemberReg getEntityObject() {
        return memberReg;
    }

    /**
     *
     * @param memberReg
     * @return
     */
    public MemberPoin requestEntityObjectForUpdate(long oidMemberReg) {
        MemberPoin memberPoin = new MemberPoin();
        try {
            int point = FRMQueryString.requestInt(req,"txt_point");
            MemberPoin mmbrPoin = PstMemberPoin.getTotalPoint(oidMemberReg);
            int pnt = mmbrPoin.getCredit() - mmbrPoin.getDebet();

            int pointx = point - pnt;
            memberPoin.setCashBillMainId(0);
            memberPoin.setMemberId(oidMemberReg);
            memberPoin.setCredit(pointx);
            memberPoin.setDebet(0);
            memberPoin.setTransactionDate(new Date());

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
        return memberPoin;
    }

    public void requestEntityObject(MemberReg memberReg) {
        try {
            this.requestParam();
            memberReg.setContactCode(getString(FRM_FIELD_CONTACT_CODE));
            memberReg.setRegdate(getDate(FRM_FIELD_REGDATE));
            memberReg.setEmployeeId(getLong(FRM_FIELD_EMPLOYEE_ID));
            memberReg.setCompName(getString(FRM_FIELD_COMP_NAME));
            memberReg.setPersonName(getString(FRM_FIELD_PERSON_NAME));
            memberReg.setPersonLastname(getString(FRM_FIELD_PERSON_LASTNAME));
            memberReg.setBussAddress(getString(FRM_FIELD_BUSS_ADDRESS));
            memberReg.setTown(getString(FRM_FIELD_TOWN));
            memberReg.setProvince(getString(FRM_FIELD_PROVINCE));
            memberReg.setCountry(getString(FRM_FIELD_COUNTRY));
            memberReg.setTelpNr(getString(FRM_FIELD_TELP_NR));
            memberReg.setTelpMobile(getString(FRM_FIELD_TELP_MOBILE));
            memberReg.setFax(getString(FRM_FIELD_FAX));
            memberReg.setHomeAddr(getString(FRM_FIELD_HOME_ADDR));
            memberReg.setHomeTown(getString(FRM_FIELD_HOME_TOWN));
            memberReg.setHomeProvince(getString(FRM_FIELD_HOME_PROVINCE));
            memberReg.setHomeCountry(getString(FRM_FIELD_HOME_COUNTRY));
            memberReg.setHomeTelp(getString(FRM_FIELD_HOME_TELP));
            memberReg.setHomeFax(getString(FRM_FIELD_HOME_FAX));
            memberReg.setNotes(getString(FRM_FIELD_NOTES));
            memberReg.setDirections(getString(FRM_FIELD_DIRECTIONS));
            memberReg.setBankAcc(getString(FRM_FIELD_BANK_ACC));
            memberReg.setBankAcc2(getString(FRM_FIELD_BANK_ACC2));
            memberReg.setContactType(getInt(FRM_FIELD_CONTACT_TYPE));
            memberReg.setEmail(getString(FRM_FIELD_EMAIL));
            memberReg.setParentId(getLong(FRM_FIELD_PARENT_ID));
            memberReg.setMemberGroupId(getLong(FRM_FIELD_MEMBER_GROUP_ID));
            memberReg.setMemberBarcode(getString(FRM_FIELD_MEMBER_BARCODE));
            memberReg.setMemberIdCardNumber(getString(FRM_FIELD_MEMBER_ID_CARD_NUMBER));
            memberReg.setMemberSex(getInt(FRM_FIELD_MEMBER_SEX));
            memberReg.setMemberBirthDate(getDate(FRM_FIELD_MEMBER_BIRTH_DATE));
            memberReg.setMemberCounter(getInt(FRM_FIELD_MEMBER_COUNTER));
            memberReg.setMemberReligionId(getLong(FRM_FIELD_MEMBER_RELIGION_ID));
            memberReg.setMemberStatus(getInt(FRM_FIELD_MEMBER_STATUS));
            memberReg.setMemberLastUpdate(getDate(FRM_FIELD_MEMBER_LAST_UPDATE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
