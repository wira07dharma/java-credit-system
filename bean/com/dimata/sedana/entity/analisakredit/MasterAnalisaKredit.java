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
public class MasterAnalisaKredit extends Entity {

	private long groupId = 0;
	private String analisaId = "";
	private String description = "";
	private Date createdAt = null;
	private Date updatedAt = null;

	public long getGroupId() {
		return groupId;
	}

	public void setGroupId(long groupId) {
		this.groupId = groupId;
	}

	public String getAnalisaId() {
		return analisaId;
	}

	public void setAnalisaId(String analisaId) {
		this.analisaId = analisaId;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
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
