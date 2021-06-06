
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

public class MemberReg extends Entity { 

	private String contactCode = "";
	private Date regdate;
	private long employeeId;
	private String compName = "";
	private String personName = "";
	private String personLastname = "";
	private String bussAddress = "";
	private String town = "";
	private String province = "";
	private String country = "";
	private String telpNr = "";
	private String telpMobile = "";
	private String fax = "";
	private String homeAddr = "";
	private String homeTown = "";
	private String homeProvince = "";
	private String homeCountry = "";
	private String homeTelp = "";
	private String homeFax = "";
	private String notes = "";
	private String directions = "";
	private String bankAcc = "";
	private String bankAcc2 = "";
	private int contactType;
	private String email = "";
	private long parentId;
	private long memberGroupId;
	private String memberBarcode = "";
	private String memberIdCardNumber = "";
	private int memberSex;
	private Date memberBirthDate;
	private int memberCounter;
	private long memberReligionId;
	private int memberStatus;
	private Date memberLastUpdate;

        /** Holds value of property processStatus. */
        private int processStatus;
        
	public String getContactCode(){ 
		return contactCode; 
	} 

	public void setContactCode(String contactCode){ 
		if ( contactCode == null ) {
			contactCode = ""; 
		} 
		this.contactCode = contactCode; 
	} 

	public Date getRegdate(){ 
		return regdate; 
	} 

	public void setRegdate(Date regdate){ 
		this.regdate = regdate; 
	} 

	public long getEmployeeId(){ 
		return employeeId; 
	} 

	public void setEmployeeId(long employeeId){ 
		this.employeeId = employeeId; 
	} 

	public String getCompName(){ 
		return compName; 
	} 

	public void setCompName(String compName){ 
		if ( compName == null ) {
			compName = ""; 
		} 
		this.compName = compName; 
	} 

	public String getPersonName(){ 
		return personName; 
	} 

	public void setPersonName(String personName){ 
		if ( personName == null ) {
			personName = ""; 
		} 
		this.personName = personName; 
	} 

	public String getPersonLastname(){ 
		return personLastname; 
	} 

	public void setPersonLastname(String personLastname){ 
		if ( personLastname == null ) {
			personLastname = ""; 
		} 
		this.personLastname = personLastname; 
	} 

	public String getBussAddress(){ 
		return bussAddress; 
	} 

	public void setBussAddress(String bussAddress){ 
		if ( bussAddress == null ) {
			bussAddress = ""; 
		} 
		this.bussAddress = bussAddress; 
	} 

	public String getTown(){ 
		return town; 
	} 

	public void setTown(String town){ 
		if ( town == null ) {
			town = ""; 
		} 
		this.town = town; 
	} 

	public String getProvince(){ 
		return province; 
	} 

	public void setProvince(String province){ 
		if ( province == null ) {
			province = ""; 
		} 
		this.province = province; 
	} 

	public String getCountry(){ 
		return country; 
	} 

	public void setCountry(String country){ 
		if ( country == null ) {
			country = ""; 
		} 
		this.country = country; 
	} 

	public String getTelpNr(){ 
		return telpNr; 
	} 

	public void setTelpNr(String telpNr){ 
		if ( telpNr == null ) {
			telpNr = ""; 
		} 
		this.telpNr = telpNr; 
	} 

	public String getTelpMobile(){ 
		return telpMobile; 
	} 

	public void setTelpMobile(String telpMobile){ 
		if ( telpMobile == null ) {
			telpMobile = ""; 
		} 
		this.telpMobile = telpMobile; 
	} 

	public String getFax(){ 
		return fax; 
	} 

	public void setFax(String fax){ 
		if ( fax == null ) {
			fax = ""; 
		} 
		this.fax = fax; 
	} 

	public String getHomeAddr(){ 
		return homeAddr; 
	} 

	public void setHomeAddr(String homeAddr){ 
		if ( homeAddr == null ) {
			homeAddr = ""; 
		} 
		this.homeAddr = homeAddr; 
	} 

	public String getHomeTown(){ 
		return homeTown; 
	} 

	public void setHomeTown(String homeTown){ 
		if ( homeTown == null ) {
			homeTown = ""; 
		} 
		this.homeTown = homeTown; 
	} 

	public String getHomeProvince(){ 
		return homeProvince; 
	} 

	public void setHomeProvince(String homeProvince){ 
		if ( homeProvince == null ) {
			homeProvince = ""; 
		} 
		this.homeProvince = homeProvince; 
	} 

	public String getHomeCountry(){ 
		return homeCountry; 
	} 

	public void setHomeCountry(String homeCountry){ 
		if ( homeCountry == null ) {
			homeCountry = ""; 
		} 
		this.homeCountry = homeCountry; 
	} 

	public String getHomeTelp(){ 
		return homeTelp; 
	} 

	public void setHomeTelp(String homeTelp){ 
		if ( homeTelp == null ) {
			homeTelp = ""; 
		} 
		this.homeTelp = homeTelp; 
	} 

	public String getHomeFax(){ 
		return homeFax; 
	} 

	public void setHomeFax(String homeFax){ 
		if ( homeFax == null ) {
			homeFax = ""; 
		} 
		this.homeFax = homeFax; 
	} 

	public String getNotes(){ 
		return notes; 
	} 

	public void setNotes(String notes){ 
		if ( notes == null ) {
			notes = ""; 
		} 
		this.notes = notes; 
	} 

	public String getDirections(){ 
		return directions; 
	} 

	public void setDirections(String directions){ 
		if ( directions == null ) {
			directions = ""; 
		} 
		this.directions = directions; 
	} 

	public String getBankAcc(){ 
		return bankAcc; 
	} 

	public void setBankAcc(String bankAcc){ 
		if ( bankAcc == null ) {
			bankAcc = ""; 
		} 
		this.bankAcc = bankAcc; 
	} 

	public String getBankAcc2(){ 
		return bankAcc2; 
	} 

	public void setBankAcc2(String bankAcc2){ 
		if ( bankAcc2 == null ) {
			bankAcc2 = ""; 
		} 
		this.bankAcc2 = bankAcc2; 
	} 

	public int getContactType(){ 
		return contactType; 
	} 

	public void setContactType(int contactType){ 
		this.contactType = contactType; 
	} 

	public String getEmail(){ 
		return email; 
	} 

	public void setEmail(String email){ 
		if ( email == null ) {
			email = ""; 
		} 
		this.email = email; 
	} 

	public long getParentId(){ 
		return parentId; 
	} 

	public void setParentId(long parentId){ 
		this.parentId = parentId; 
	} 

	public long getMemberGroupId(){ 
		return memberGroupId; 
	} 

	public void setMemberGroupId(long memberGroupId){ 
		this.memberGroupId = memberGroupId; 
	} 

	public String getMemberBarcode(){ 
		return memberBarcode; 
	} 

	public void setMemberBarcode(String memberBarcode){ 
		if ( memberBarcode == null ) {
			memberBarcode = ""; 
		} 
		this.memberBarcode = memberBarcode; 
	} 

	public String getMemberIdCardNumber(){ 
		return memberIdCardNumber; 
	} 

	public void setMemberIdCardNumber(String memberIdCardNumber){ 
		if ( memberIdCardNumber == null ) {
			memberIdCardNumber = ""; 
		} 
		this.memberIdCardNumber = memberIdCardNumber; 
	} 

	public int getMemberSex(){ 
		return memberSex; 
	} 

	public void setMemberSex(int memberSex){ 
		this.memberSex = memberSex; 
	} 

	public Date getMemberBirthDate(){ 
		return memberBirthDate; 
	} 

	public void setMemberBirthDate(Date memberBirthDate){ 
		this.memberBirthDate = memberBirthDate; 
	} 

	public int getMemberCounter(){ 
		return memberCounter; 
	} 

	public void setMemberCounter(int memberCounter){ 
		this.memberCounter = memberCounter; 
	} 

	public long getMemberReligionId(){ 
		return memberReligionId; 
	} 

	public void setMemberReligionId(long memberReligionId){ 
		this.memberReligionId = memberReligionId; 
	} 

	public int getMemberStatus(){ 
		return memberStatus; 
	} 

	public void setMemberStatus(int memberStatus){ 
		this.memberStatus = memberStatus; 
	} 

	public Date getMemberLastUpdate(){ 
		return memberLastUpdate; 
	} 

	public void setMemberLastUpdate(Date memberLastUpdate){ 
		this.memberLastUpdate = memberLastUpdate; 
	} 

        /** Getter for property processStatus.
         * @return Value of property processStatus.
         *
         */
        public int getProcessStatus() {
            return this.processStatus;
        }
        
        /** Setter for property processStatus.
         * @param processStatus New value of property processStatus.
         *
         */
        public void setProcessStatus(int processStatus) {
            this.processStatus = processStatus;
        }
        
        
}
