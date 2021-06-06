/* Generated by Together */

package com.dimata.aiso.form.masterdata;

// import javax
import javax.servlet.*;
import javax.servlet.http.*;

// import qdep
import com.dimata.qdep.form.FRMHandler;
import com.dimata.qdep.form.I_FRMInterface;
import com.dimata.qdep.form.I_FRMType;

// import aiso
import com.dimata.aiso.entity.masterdata.*;

public class FrmAccountLink extends FRMHandler implements I_FRMInterface, I_FRMType
{
    public static final String FRM_ACCOUNT_LINK = "ACCOUNT_LINK";
    public static final int FRM_TYPE	       = 0;
    public static final int FRM_FIRST_ID       = 1;
    public static final int FRM_SECOND_ID      = 2;
    public static final int FRM_DEPARTMENT_ID      = 3;

    public static String[] fieldNames = 
    {
        "LINK_TYPE",
        "FIRST_ID",
        "SECOND_ID",
        "DEPARTMENT_ID"
    };
    
    public static int[] fieldTypes = 
    {
        TYPE_INT,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_LONG,
        TYPE_LONG
    };

    private AccountLink accountlink;

    public FrmAccountLink(AccountLink accountlink)
    {
        this.accountlink = accountlink;
    }
    
    public FrmAccountLink(HttpServletRequest request, AccountLink accountlink) 
    {
        super(new FrmAccountLink(accountlink), request);
        this.accountlink = accountlink;
    }

    public String getFormName() 
    {
        return FRM_ACCOUNT_LINK;
    }    
    
    public int[] getFieldTypes() 
    {
        return fieldTypes;
    }    
    
    public String[] getFieldNames() 
    {
        return fieldNames;
    }

    public int getFieldSize() 
    {
        return fieldNames.length;
    }

    public AccountLink getEntityObject()
    {
        return accountlink;
    }

    public void requestEntityObject(AccountLink accountlink)
    {
        try 
        {
            this.requestParam();                    
            accountlink.setLinkType(this.getInt(FRM_TYPE));
            accountlink.setFirstId(this.getLong(FRM_FIRST_ID));
            accountlink.setSecondId(this.getLong(FRM_SECOND_ID));
            accountlink.setDepartmentOid(this.getLong(FRM_DEPARTMENT_ID));
            this.accountlink = accountlink;
        }
        catch(Exception e) 
        {
            accountlink = new AccountLink();
        }       
    }
}
