/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.analisakredit;

import com.dimata.qdep.entity.Entity;
import java.util.Date;

/**
 *
 * @author arise
 */
public class MasterGroupAnalisaKredit extends Entity {

	private String groupId = "";
	private String groupDesc = "";
	private int groupBobot = 0;
	private int groupMin = 0;
	private int groupMax = 0;
	private Date createdAt = null;
	private Date updatedAt = null;

	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public String getGroupDesc() {
		return groupDesc;
	}

	public void setGroupDesc(String groupDesc) {
		this.groupDesc = groupDesc;
	}

	public int getGroupBobot() {
		return groupBobot;
	}

	public void setGroupBobot(int groupBobot) {
		this.groupBobot = groupBobot;
	}

	public int getGroupMin() {
		return groupMin;
	}

	public void setGroupMin(int grouptMin) {
		this.groupMin = grouptMin;
	}

	public int getGroupMax() {
		return groupMax;
	}

	public void setGroupMax(int groupMax) {
		this.groupMax = groupMax;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public Date getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}

}
