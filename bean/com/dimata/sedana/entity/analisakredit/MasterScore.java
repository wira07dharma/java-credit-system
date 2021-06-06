/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.analisakredit;

import com.dimata.qdep.entity.Entity;

/**
 *
 * @author arise
 */
public class MasterScore extends Entity{

	private double scoreMin = 0;
	private double scoreMax = 0;
	private String description = "";
	private long groupId = 0;


	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * @return the groupId
	 */
	public long getGroupId() {
		return groupId;
	}

	/**
	 * @param groupId the groupId to set
	 */
	public void setGroupId(long groupId) {
		this.groupId = groupId;
	}

	/**
	 * @return the scoreMin
	 */
	public double getScoreMin() {
		return scoreMin;
	}

	/**
	 * @param scoreMin the scoreMin to set
	 */
	public void setScoreMin(double scoreMin) {
		this.scoreMin = scoreMin;
	}

	/**
	 * @return the scoreMax
	 */
	public double getScoreMax() {
		return scoreMax;
	}

	/**
	 * @param scoreMax the scoreMax to set
	 */
	public void setScoreMax(double scoreMax) {
		this.scoreMax = scoreMax;
	}
}
